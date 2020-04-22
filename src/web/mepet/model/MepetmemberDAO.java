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


public class MepetmemberDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	//회원가입
	public void signup(MepetmemberDTO member) {
		try {
			conn = getConnection();
			
			String sql = "insert into mepetmember values(?,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getId());
			pstmt.setString(2, member.getPw());
			pstmt.setString(3, member.getNick());
			pstmt.setInt(4, member.getPhon());
			pstmt.setString(5, member.getEmail());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
	}
	//로그인
	public int login(String id, String pw) {
		int result = 0;
		String dbpw = null;
		//아이디 불일치 = 0, 비밀번호 불일치 = -1, 성공 = 1
		
		try {
			conn = getConnection();
			String sql = "select pw from mepetmember where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				dbpw = rs.getString(1);
				
				if(dbpw.equals(pw)) result = 1;
				else result = -1;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	//회원가입 아이디체크
	public boolean idCheck(String id) {
		boolean result = false;
		try {
			conn = getConnection();
			String sql = "select id from mepetmember where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) result = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return result;
	}
	//회원가입 닉네임 체크
	public boolean nickCheck(String nick) {
		boolean result = false;
		try {
			conn = getConnection();
			
			String sql = "select nick from mepetmember where nick=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			rs = pstmt.executeQuery();
			
			if(rs.next()) result = true;
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return result;
	}
	//닉네임 리턴
	public String getNick(String id) {
		String nick = null;
		
		try {
			conn = getConnection();
			
			String sql = "select nick from mepetmember where id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) nick = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return nick;
	}
	
	//회원 정보 리턴
	public MepetmemberDTO memberInfo(String id) {
		MepetmemberDTO member = null;
		try {
			conn = getConnection();
			String sql = "select * from mepetmember where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				member = new MepetmemberDTO();
				member.setId(rs.getString("id"));
				member.setNick(rs.getString("nick"));
				member.setPw(rs.getString("pw"));
				member.setPhon(rs.getInt("phon"));
				member.setEmail(rs.getString("email"));
				member.setReg(rs.getTimestamp("reg"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return member;
	}
	
	public int memberModify(MepetmemberDTO member) {
		int result = 0;
		
		try {
			conn = getConnection();
			
			String sql = "update mepetmember set nick=?, pw=?, phon=?, email=? where id =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getNick());
			pstmt.setString(2, member.getPw());
			pstmt.setInt(3, member.getPhon());
			pstmt.setString(4, member.getEmail());
			pstmt.setString(5, member.getId());
			result = pstmt.executeUpdate();
			
			sql = "select id from mepetsitter where id =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, member.getId());
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "update mepetsitter set phon=?, email=? where id =?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, member.getPhon());
				pstmt.setString(2, member.getEmail());
				pstmt.setString(3, member.getId());
				pstmt.executeUpdate();
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return result;
	}
	
	//회원탈퇴 
	public int deleteMember(String pw, String id) {
		int result = 0;
		try {
			conn = getConnection();
			String sql = "delete from mepetmember where id=? and pw=?";
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
	
	//닉네임 리턴
	public String memberNick(String id) {
		String nick = null;
		try {
			conn = getConnection();
			String sql = "select nick from mepetmember where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) nick = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return nick;
	}
	
	//회원 전체 수 리턴
	public int memberCount() {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from mepetmember";
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
	public List memberList(int startRow, int endRow) {
		List members = null;
		MepetmemberDTO member = null;
		
		try {
			conn= getConnection();
			String sql = "select id,nick,phon,email,reg, r "
					+ "from (select id,nick,phon,email,reg, rownum r "
					+ "from (select id,nick,phon,email,reg "
					+ "from mepetmember order by reg desc) order by reg desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			members = new ArrayList();
			while(rs.next()) {
				member = new MepetmemberDTO();
				member.setId(rs.getString("id"));
				member.setNick(rs.getString("nick"));
				member.setPhon(rs.getInt("phon"));
				member.setEmail(rs.getString("email"));
				member.setReg(rs.getTimestamp("reg"));
				
				members.add(member);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return members;
	}
	
	//회원 전체 수 리턴(검색)
	public int selectMemberCount(String sel, String select) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from mepetmember where "+sel+" like '%"+select+"%'";
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
	public List selectMemberList(int startRow, int endRow, String sel, String select) {
		List members = null;
		MepetmemberDTO member = null;
		
		try {
			conn= getConnection();
			String sql = "select id,nick,phon,email,reg, r "
					+ "from (select id,nick,phon,email,reg, rownum r "
					+ "from (select id,nick,phon,email,reg "
					+ "from mepetmember where "+sel+" like '%"+select+"%' order by reg desc) order by reg desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			members = new ArrayList();
			while(rs.next()) {
				member = new MepetmemberDTO();
				member.setId(rs.getString("id"));
				member.setNick(rs.getString("nick"));
				member.setPhon(rs.getInt("phon"));
				member.setEmail(rs.getString("email"));
				member.setReg(rs.getTimestamp("reg"));
				
				members.add(member);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return members;
	}	
	
	//관리자용 탈퇴 메소드
	public int adminMember(String pw, String id) {
		int result = 0;
		try {
			conn = getConnection();
			
			String sql = "select pw from mepetmember where pw=? and id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, pw);
			pstmt.setString(2, "admin");
			rs = pstmt.executeQuery();
			if(rs.next()) {
				sql = "delete from mepetmember where id=?";
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
