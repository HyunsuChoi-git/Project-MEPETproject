package web.mepet.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Member_petDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//반려동물 등록하기
	public int insertPet(Member_petDTO pet) {
		int result = 0;
		
		try {
			conn = getConnection();
			String sql = "insert into member_pet values(?,?,?,?,?,?,?,?,?,?,?,member_pet_seq.nextval)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pet.getId());
			pstmt.setString(2, pet.getType());
			pstmt.setString(3, pet.getPettype());
			pstmt.setString(4, pet.getPetname());
			pstmt.setInt(5, pet.getPetage());
			pstmt.setString(6, pet.getPetsex());
			pstmt.setString(7, pet.getPetsize());
			pstmt.setDouble(8, pet.getPetweight());
			pstmt.setString(9, pet.getPetneutral());
			pstmt.setString(10, pet.getImg());
			pstmt.setTimestamp(11, pet.getReg());
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	//반려동물 정보 불러오기 
	public List getPets(String id) {
		List mypets = null;
		Member_petDTO pet = null;
		
		try {
			conn = getConnection();
			String sql = "select * from member_pet where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			mypets = new ArrayList();
			while(rs.next()) {
				pet = new Member_petDTO();
				
				pet.setImg(rs.getString("img"));
				pet.setPetname(rs.getString("petname"));
				pet.setPetnum(rs.getInt("petnum"));
				
				mypets.add(pet);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return mypets;
	}
	
	public Member_petDTO petInfo(int petnum) {
		Member_petDTO pet = null;	
		
		try {
			conn = getConnection();
			String sql = "select * from member_pet where petnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, petnum);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				pet = new Member_petDTO();
				
				pet.setId(rs.getString("id"));
				pet.setType(rs.getString("type"));
				pet.setPettype(rs.getString("pettype"));
				pet.setPetname(rs.getString("petname"));
				pet.setPetage(rs.getInt("petage"));
				pet.setPetsex(rs.getString("petsex"));
				pet.setPetsize(rs.getString("petsize"));
				pet.setPetweight(rs.getDouble("petweight"));
				pet.setPetneutral(rs.getString("petneutral"));
				pet.setImg(rs.getString("img"));
				pet.setReg(rs.getTimestamp("reg"));
				pet.setPetnum(petnum);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return pet;
	}
	
	//사진정보 리턴 
	public String petImg(int petnum) {
		String img = null;
		
		try {
			conn = getConnection();
			String sql = "select img from member_pet where petnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, petnum);
			rs = pstmt.executeQuery();
			if(rs.next()) img = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return img;
	}
	//반려동물 정보 수정
	public int modifyPet(Member_petDTO pet) {
		int result = 0;
		
		try {
			conn = getConnection();
			
			String sql = "update member_pet set "
					+ "type=?,pettype=?,petname=?,petage=?,petsex=?,petsize=?,petweight=?,petneutral=?,img=? "
					+ "where petnum=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pet.getType());
			pstmt.setString(2, pet.getPettype());
			pstmt.setString(3, pet.getPetname());
			pstmt.setInt(4, pet.getPetage());
			pstmt.setString(5, pet.getPetsex());
			pstmt.setString(6, pet.getPetsize());
			pstmt.setDouble(7, pet.getPetweight());
			pstmt.setString(8, pet.getPetneutral());
			pstmt.setString(9, pet.getImg());
			pstmt.setInt(10, pet.getPetnum());
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	public int deletePet(String id, String pw, int petnum) {
		int result = 0;
		String dbpw = null;
		try {
			conn = getConnection();
			
			String sql = "select pw from mepetmember where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) dbpw = rs.getString(1);
			
			if(pw.equals(dbpw)) {
				
				sql = "delete from member_pet where id=? and petnum=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setInt(2, petnum);
				
				result = pstmt.executeUpdate();
				
			}else {
				result = -1;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	//한 계정 반려동물 사진리스트 리턴
	public List memberPets(String id) {
		List memberPets = null;
		
		try {
			conn = getConnection();
			String sql = "select img from member_pet where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			memberPets = new ArrayList();
			while(rs.next()) {
				memberPets.add(rs.getString("img"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return memberPets;
	}
	
	//한 계정 반려동물 정보 삭제
	public int adminPets(String id) {
		int res = 0;
		
		try {
			conn = getConnection();
			String sql = "delete from member_pet where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			res = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return res;
	}
	
	//펫 전체 수 리턴
	public int petCount() {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from member_pet";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return count;
	}
	
	//회원 전체 리스트 리턴(가입순)
	public List petList(int startRow, int endRow) {
		List pets = null;
		Member_petDTO pet = null;
		
		try {
			conn= getConnection();
			String sql = "select id,type,pettype,petname,petsex,petsize,img, r "
					+ "from (select id,type,pettype,petname,petsex,petsize,img, rownum r "
					+ "from (select id,type,pettype,petname,petsex,petsize,img "
					+ "from member_pet order by id asc, petname asc) order by id asc, petname asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			pets = new ArrayList();
			while(rs.next()) {
				pet = new Member_petDTO();
				pet.setId(rs.getString("id"));
				pet.setType(rs.getString("type"));
				pet.setPettype(rs.getString("pettype"));
				pet.setPetname(rs.getString("petname"));
				pet.setPetsex(rs.getString("petsex"));
				pet.setPetsize(rs.getString("petsize"));
				pet.setImg(rs.getString("img"));
				
				pets.add(pet);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return pets;
	}
	
	//회원 전체 수 리턴(검색)
	public int selectPetCount(String sel, String select) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from member_pet where "+sel+" like '%"+select+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return count;
	}
	
	//펫 전체 리스트 리턴(검색)
	public List selectPetList(int startRow, int endRow, String sel, String select) {
		List pets = null;
		Member_petDTO pet = null;
		
		try {
			conn= getConnection();
			String sql = "select id,type,pettype,petname,petsex,petsize,img, r "
					+ "from (select id,type,pettype,petname,petsex,petsize,img, rownum r "
					+ "from (select id,type,pettype,petname,petsex,petsize,img "
					+ "from member_pet where "+sel+" like '%"+select+"%' order by id asc, petname asc) order by id asc, petname asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			pets = new ArrayList();
			while(rs.next()) {
				pet = new Member_petDTO();
				pet.setId(rs.getString("id"));
				pet.setType(rs.getString("type"));
				pet.setPettype(rs.getString("pettype"));
				pet.setPetname(rs.getString("petname"));
				pet.setPetsex(rs.getString("petsex"));
				pet.setPetsize(rs.getString("petsize"));
				pet.setImg(rs.getString("img"));
				
				pets.add(pet);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return pets;
	}
	
	
	
	
	
   public void close(Connection conn,PreparedStatement pstmt,ResultSet rs) {
        
        if(rs!=null) {
           try {
              rs.close();
           }catch(Exception e) {
              e.printStackTrace();
           }
        }
        if(pstmt!=null) {
           try {
              pstmt.close();
           }catch(Exception e) {
              e.printStackTrace();
           }
        }
        if(conn!=null) {
           try {
              conn.close();
           }catch(Exception e) {
              e.printStackTrace();
           }
        }
        
     }
	
}
