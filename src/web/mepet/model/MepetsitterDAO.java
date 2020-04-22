package web.mepet.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MepetsitterDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//펫시터 가입 이름 체크
	public boolean nameCheck(String name) {
		boolean result = false;
		try {
			conn = getConnection();
			
			String sql = "select name from mepetsitter where name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			
			if(rs.next()) result = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return result;
	}
	
	//펫시터 가입 메소드
	public int sitterSignup(MepetsitterDTO dto) {
		int result = 0;
		
		try {
			conn = getConnection();
			String sql = "insert into mepetsitter(id,pw,name,phon,email,area,year,img,reg) values(?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPw());
			pstmt.setString(3, dto.getName());
			pstmt.setInt(4, dto.getPhon());
			pstmt.setString(5, dto.getEmail());
			pstmt.setString(6, dto.getArea());
			pstmt.setInt(7, dto.getYear());
			pstmt.setString(8, dto.getImg());
			pstmt.setTimestamp(9, dto.getReg());
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return result;
	}
	
	//펫시터 로그인
	public boolean sitterLogin(String id) {
		boolean sitter = false;
		try {
			conn = getConnection();
			
			String sql = "select id from mepetsitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1,id);
			rs = pstmt.executeQuery();
			if(rs.next()) sitter = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return sitter;
	}
	
	//시터 정보 리턴 메소드
	public MepetsitterDTO sitterInfo(String id) {
		MepetsitterDTO sitter = null;
		try {
			conn = getConnection();

			String sql = "select * from mepetsitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sitter = new MepetsitterDTO();
				
				sitter.setId(id);
				sitter.setName(rs.getString("name"));
				sitter.setPhon(rs.getInt("phon"));
				sitter.setEmail(rs.getString("email"));
				sitter.setImg(rs.getString("img"));
				sitter.setArea(rs.getString("area"));
				sitter.setSittercount(rs.getInt("sittercount"));
				sitter.setYear(rs.getInt("year"));
				sitter.setPoint(rs.getInt("point"));;
				sitter.setAvgpoint(rs.getInt("avgpoint"));
				sitter.setReg(rs.getTimestamp("reg"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return sitter;
	}
	
	// 글 작성시 펫시터 이름 갯수 리턴하는 메소드
	public int searchPersitterCount(String name) {
		int count = 0;
		try {
			conn = getConnection();
			String sql = "select count(*) from mepetsitter where name like '%"+name+"%'";
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
	
	// 글 작성시 펫시터 이름 검색하는 메소드 
	public List searchPersitter(String name) {
		List petsitters = null;
		try {
			conn = getConnection();
			
			String sql = "select * from mepetsitter where name like '%"+name+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			petsitters = new ArrayList();
			MepetsitterDTO petsitter = null;
			while(rs.next()) {
				petsitter = new MepetsitterDTO();
				petsitter.setId(rs.getString("id"));
				petsitter.setName(rs.getString("name"));
				petsitter.setPhon(rs.getInt("phon"));
				petsitter.setArea(rs.getString("area"));
				petsitter.setImg(rs.getString("img"));
				petsitter.setAvgpoint(rs.getDouble("avgpoint"));
				
				petsitters.add(petsitter);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return petsitters;
	}
	
	//전체 펫시터 count 리턴하는 메소드
	public int allPersitterCount() {
		int count = 0;
		try {
			conn = getConnection();
			String sql = "select count(*) from mepetsitter";
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
	
	//전체 펫시터 List 리턴하는 메소드
	public List allPersitter() {
		List petsitters = null;
		try {
			conn = getConnection();
			
			String sql = "select * from mepetsitter";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			petsitters = new ArrayList();
			MepetsitterDTO petsitter = null;
			while(rs.next()) {
				petsitter = new MepetsitterDTO();
				petsitter.setId(rs.getString("id"));
				petsitter.setName(rs.getString("name"));
				petsitter.setPhon(rs.getInt("phon"));
				petsitter.setArea(rs.getString("area"));
				petsitter.setImg(rs.getString("img"));
				petsitter.setAvgpoint(rs.getDouble("avgpoint"));
				
				petsitters.add(petsitter);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return petsitters;
	}
	
	public String sitterImg(String id) {
		String img = null;
		
		try {
			conn = getConnection();
			
			String sql = "select img from mepetsitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) img = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return img;
	}
	
	//시터정보 수정 메소드
	
	public int sitterModify(MepetsitterDTO dto) {
		int result = 0;
		
		try {
			conn = getConnection();
			
			String sql = "update mepetsitter set pw=?, name=?, area=?, year=?, img=? where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getPw());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getArea());
			pstmt.setInt(4, dto.getYear());
			pstmt.setString(5, dto.getImg());
			pstmt.setString(6, dto.getId());
			
			result = pstmt.executeUpdate();
			
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
				
		return result;
	}
	
	//시터 탈퇴 메소드
	public int deleteSitter(String pw, String id) {
		int result = 0;
		try {
			conn = getConnection();
			String sql = "delete from mepetsitter where id=? and pw=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setString(2, pw);
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	//시터 이름 리턴 메소드
	public String sitterName(String id) {
		String name = null;
		
		try {
			conn = getConnection();
			
			String sql = "select name from mepetsitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) name = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return name;
	}
	
	//회원 전체 리스트 리턴(가입순)
	public List sitterList(int startRow, int endRow) {
		List sitters = null;
		MepetsitterDTO sitter = null;
		
		try {
			conn= getConnection();
			String sql = "select id,name,area,sittercount,point,avgpoint,reg, r "
					+ "from (select id,name,area,sittercount,point,avgpoint,reg, rownum r "
					+ "from (select id,name,area,sittercount,point,avgpoint,reg "
					+ "from mepetsitter order by reg desc) order by reg desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			sitters = new ArrayList();
			while(rs.next()) {
				sitter = new MepetsitterDTO();
				sitter.setId(rs.getString("id"));
				sitter.setName(rs.getString("name"));
				sitter.setArea(rs.getString("area"));
				sitter.setSittercount(rs.getInt("sittercount"));
				sitter.setPoint(rs.getInt("point"));
				sitter.setAvgpoint(rs.getDouble("avgpoint"));
				sitter.setReg(rs.getTimestamp("reg"));
				
				sitters.add(sitter);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return sitters;
	}
	
	//회원 전체 수 리턴(검색)
	public int selectSitterCount(String sel, String select) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from mepetsitter where "+sel+" like '%"+select+"%'";
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
	
	//회원 전체 리스트 리턴(검색)
	public List selectSitterList(int startRow, int endRow, String sel, String select) {
		List sitters = null;
		MepetsitterDTO sitter = null;
		
		try {
			conn= getConnection();
			String sql = "select id,name,area,sittercount,point,avgpoint,reg, r "
					+ "from (select id,name,area,sittercount,point,avgpoint,reg, rownum r "
					+ "from (select id,name,area,sittercount,point,avgpoint,reg "
					+ "from mepetsitter where "+sel+" like '%"+select+"%' order by reg desc) order by reg desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			sitters = new ArrayList();
			while(rs.next()) {
				sitter = new MepetsitterDTO();
				sitter.setId(rs.getString("id"));
				sitter.setName(rs.getString("name"));
				sitter.setArea(rs.getString("area"));
				sitter.setSittercount(rs.getInt("sittercount"));
				sitter.setPoint(rs.getInt("point"));
				sitter.setAvgpoint(rs.getDouble("avgpoint"));
				sitter.setReg(rs.getTimestamp("reg"));
				
				sitters.add(sitter);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return sitters;
	}	
	
	//시터 존재유무 확인 메소드
	public boolean sitterCheck(String id) {
		boolean b = false;
		
		try {
			conn = getConnection();
			
			String sql = "select * from mepetsitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) b = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return b;
	}
	
	
	
	//관리자용 시터해지 메소드
	public int adminSitter(String pw, String id) {
		int result = 0;
		try {
			conn = getConnection();
			
			String sql = "select pw from mepetmember where pw=? and id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pw);
			pstmt.setString(2, "admin");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "delete from mepetsitter where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				result = pstmt.executeUpdate();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
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
