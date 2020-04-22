package web.mepet.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Board_commDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//전체 글 갯수 리턴
	public int getCommCount() {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comm";
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
	
	//검색 글 갯수 리턴
	public int getSearchCommCount(String sel, String search) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comm where "+sel+" like '%"+search+"%'";
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
	
	//내글 갯수 리턴
	public int getMyCommCount(String id) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comm where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return count;
	}
	
	//내글 검색 글 갯수 리턴
	public int getMyCommCount(String sel, String search, String id) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comm where "+sel+" like '%"+search+"%' and id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return count;
	}
	
	
	public List getConmmentList(int startRow, int endRow) {
		List getConmmList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, rownum r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg "
					+ "from board_comm order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			getConmmList = new ArrayList();
			Board_commDTO article = null;
			while(rs.next()) {
				article = new Board_commDTO();
				
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				
				getConmmList.add(article);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmList;
	}
	
	public List getConmmentList(String sel, String search, int startRow, int endRow) {
		List getConmmList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, rownum r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg "
					+ "from board_comm where "+sel+" like '%"+search+"%' order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			getConmmList = new ArrayList();
			Board_commDTO article = null;
			while(rs.next()) {
				article = new Board_commDTO();
				
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				
				getConmmList.add(article);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmList;
	}
	
	//내글 리턴
	public List getMyConmmentList(int startRow, int endRow, String id) {
		List getConmmList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, rownum r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg "
					+ "from board_comm where id=? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getConmmList = new ArrayList();
			Board_commDTO article = null;
			while(rs.next()) {
				article = new Board_commDTO();
				
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				
				getConmmList.add(article);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmList;
	}
	
	//내 글 검색글 리턴
	public List getMyConmmentList(String sel, String search, int startRow, int endRow, String id) {
		List getConmmList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg, rownum r "
					+ "from (select num,id,nick,type,subject,readcount,ref,re_step,re_level,ip,reg "
					+ "from board_comm where "+sel+" like '%"+search+"%' and id = ? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getConmmList = new ArrayList();
			Board_commDTO article = null;
			while(rs.next()) {
				article = new Board_commDTO();
				
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				
				getConmmList.add(article);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmList;
	}
	
	//글 저장 메소드
	public int insertComm(Board_commDTO article) {
		int result = 0;
		String sql = null;
		
		int num = article.getNum();
		int ref = article.getRef();
		int re_step = article.getRe_step();
		int re_level = article.getRe_level();
				
		try {
			conn = getConnection();
			
			if(num > 0) { //답글일 때
				sql = "update board_comm set re_step = re_step+1 where ref=? and re_step > ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, ref);
				pstmt.setInt(2, re_step);
				pstmt.executeUpdate();
				
				re_step += 1;
				re_level += 1;
				
			}else { //새글일 때
				//ref 채우기
				pstmt = conn.prepareStatement("select max(num) from board_comm");
				rs = pstmt.executeQuery();
				if(rs.next()) ref = rs.getInt(1)+1;
				else ref = 1;
				System.out.println(ref);
				re_step = 0;
				re_level = 0;
			}
			
			sql = "insert into board_comm(num,id,nick,type,subject,content,img,ref,re_step,re_level,ip,reg) "
					+ "values(board_comm_seq.nextval,?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getId());
			pstmt.setString(2, article.getNick());
			pstmt.setString(3, article.getType());
			pstmt.setString(4, article.getSubject());
			pstmt.setString(5, article.getContent());
			pstmt.setString(6, article.getImg());
			pstmt.setInt(7, ref);
			pstmt.setInt(8, re_step);
			pstmt.setInt(9, re_level);
			pstmt.setString(10, article.getIp());
			pstmt.setTimestamp(11, article.getReg());
			
			pstmt.executeUpdate();
			
			
			sql = "select num from board_comm where ref=? and re_step=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			pstmt.setInt(2, re_step);
			rs = pstmt.executeQuery();
			if(rs.next()) result = rs.getInt(1);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	//content 메소드
	public Board_commDTO getContent(int num) {
		Board_commDTO article = null;
		
		try {
			conn = getConnection();
			
			String sql = "update board_comm set readcount = readcount+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			
			sql = "select * from board_comm where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				article = new Board_commDTO();
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setImg(rs.getString("img"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return article;
	}
	
	//글 꺼내기 메소드
	public Board_commDTO getArticle(int num) {
		Board_commDTO article = null;
		
		try {
			conn = getConnection();
			String sql = "select * from board_comm where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				article = new Board_commDTO();
				article.setNum(rs.getInt("num"));
				article.setId(rs.getString("id"));
				article.setNick(rs.getString("nick"));
				article.setType(rs.getString("type"));
				article.setSubject(rs.getString("subject"));
				article.setContent(rs.getString("content"));
				article.setImg(rs.getString("img"));
				article.setReadcount(rs.getInt("readcount"));
				article.setRef(rs.getInt("ref"));
				article.setRe_step(rs.getInt("re_step"));
				article.setRe_level(rs.getInt("re_level"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return article;
	}
	
	//이전글 메소드
	public int pastNum(int count , int num) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_comm order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_comm order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, nowNumR+1);
				rs = pstmt.executeQuery();
				if(rs.next()) pastNum = rs.getInt(1);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return pastNum;
	}
	
	//다음글 메소드
	public int nextNum(int num) {
		int nextNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_comm order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_comm order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, nowNumR-1);
				rs = pstmt.executeQuery();
				if(rs.next()) nextNum = rs.getInt(1);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return nextNum;
	}
	
	//마이아티클 이전글 메소드
	public int pastNum(int count , int num, String id) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_comm where id=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_comm where id=? order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setInt(2, nowNumR+1);
				rs = pstmt.executeQuery();
				if(rs.next()) pastNum = rs.getInt(1);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return pastNum;
	}
	
	//마이아티클 다음글 메소드
	public int nextNum(int num, String id) {
		int nextNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_comm where id=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_comm where id=? order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setInt(2, nowNumR-1);
				rs = pstmt.executeQuery();
				if(rs.next()) nextNum = rs.getInt(1);
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return nextNum;
	}
	
	
	
	//사진정보 리턴 메소드
	public String commImg(int num) {
		String img = null;
		
		try {
			conn = getConnection();
			String sql = "select img from board_comm where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()) img = rs.getString(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return img;
	}
	
	//글 수정 메소드
	public int modifyComm(Board_commDTO article) {
		int result = 0;
		
		try {
			conn = getConnection();
			
			String sql = "update board_comm set subject=?,content=?,type=?,img=? where num=? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getSubject());		
			pstmt.setString(2, article.getContent());		
			pstmt.setString(3, article.getType());		
			pstmt.setString(4, article.getImg());		
			pstmt.setInt(5, article.getNum());		
			
			result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return result;
	}
	
	//글 삭제 메소드
	public int deleteArticle(int num) {
		int r = 0;
		
		try {
			conn = getConnection();
			String sql = "delete from board_comm where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);	
			r = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return r;
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
