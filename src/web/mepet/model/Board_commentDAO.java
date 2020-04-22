package web.mepet.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class Board_commentDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//전체 글 갯수 리턴 메소드
	public int getCommentCount() {
		int count = 0;
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comment";
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
	
	//페이지사이즈만큼 글 리턴하는 메소드
	public List getConmmentList(int startRow, int endRow) {
		List getConmmentList = null;
		
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			getConmmentList = new ArrayList();
			Board_commentDTO dto = null;
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getConmmentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmentList;
	}
	
	//검색 글 갯수 리턴 메소드
	public int getSearchCommentCount(String sel, String search) {
		int count = 0;
			try {
				conn = getConnection();
				String sql = "select count(*) from board_comment where "+sel+" like '%"+search+"%'";
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
	
	//페이지사이즈만큼 검색글 리턴하는 메소드
	public List getSearchCommentList(String sel, String search, int startRow, int endRow) {
		List getSearchCommentList = null;
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment where "+sel+" like '%"+search+"%' order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			getSearchCommentList = new ArrayList();
			Board_commentDTO dto = null;
			
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getSearchCommentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return getSearchCommentList;
	}
	
	//내가 쓴 후기 글 갯수 리턴 메소드
	public int getMyCommentCount(String nick) {
		int count = 0;
			try {
				conn = getConnection();
				String sql = "select count(*) from board_comment where nick=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nick);
				rs = pstmt.executeQuery();
				if(rs.next()) count = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close(conn,pstmt,rs);
			}
		
		return count;
	}
	//내가 쓴 후기 글 리턴
	public List getMyConmmentList(int startRow, int endRow, String nick) {
		List getConmmentList = null;
		
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment where nick=? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getConmmentList = new ArrayList();
			Board_commentDTO dto = null;
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getConmmentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmentList;
	}
	
	//내가쓴 후기글 검색 글 갯수 리턴
	public int getMyCommentCount(String sel, String search, String nick) {
		int count = 0;
			try {
				conn = getConnection();
				String sql = "select count(*) from board_comment where "+sel+" like '%"+search+"%' and nick=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nick);
				rs = pstmt.executeQuery();
				if(rs.next()) count = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close(conn,pstmt,rs);
			}
		
		return count;
	}	
		
	//내가쓴 후기글 검색 글 리턴
	public List getMyCommentList(String sel, String search, int startRow, int endRow, String nick) {
		List getSearchCommentList = null;
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment where "+sel+" like '%"+search+"%' and nick=? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getSearchCommentList = new ArrayList();
			Board_commentDTO dto = null;
			
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getSearchCommentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return getSearchCommentList;
	}	
	
	
	
	//내게쓴 글 갯수 리턴 메소드
	public int getSitterCommentCount(String name) {
		int count = 0;
		try {
			conn = getConnection();
			String sql = "select count(*) from board_comment where sitter_name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return count;
	}
	
	//페이지사이즈만큼 글 리턴하는 메소드
	public List getSitterCommentList(int startRow, int endRow, String name) {
		List getConmmentList = null;
		
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment where sitter_name=? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getConmmentList = new ArrayList();
			Board_commentDTO dto = null;
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getConmmentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return getConmmentList;
	}
	
	
	//내게 쓴 후기  검색글 갯수 리턴 메소드
	public int getSitterCommentCount(String sel, String search, String name) {
		int count = 0;
			try {
				conn = getConnection();
				String sql = "select count(*) from board_comment where "+sel+" like '%"+search+"%' and sitter_name=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, name);
				rs = pstmt.executeQuery();
				if(rs.next()) count = rs.getInt(1);
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				close(conn,pstmt,rs);
			}
		
		return count;
	}
	//내게쓴 후기글 검색 글 리턴
	public List getSitterCommentList(String sel, String search, int startRow, int endRow, String name) {
		List getSearchCommentList = null;
		try {
			conn = getConnection();
			String sql = "select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg, rownum r "
					+ "from (select num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, re_step, readcount, ip, reg "
					+ "from board_comment where "+sel+" like '%"+search+"%' and sitter_name=? order by ref desc, re_step asc) order by ref desc, re_step asc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, name);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			getSearchCommentList = new ArrayList();
			Board_commentDTO dto = null;
			
			while(rs.next()) {
				dto = new Board_commentDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setNick(rs.getString("nick"));
				dto.setSubject(rs.getString("subject"));
				dto.setContent(rs.getString("content"));
				dto.setPetdate(rs.getString("petdate"));
				dto.setPetday(rs.getString("petday"));
				dto.setArea(rs.getString("area"));
				dto.setSitter_name(rs.getString("sitter_name"));
				dto.setPoint(rs.getInt("point"));
				dto.setImg(rs.getString("img"));
				dto.setRef(rs.getInt("ref"));
				dto.setRe_step(rs.getInt("re_step"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				
				getSearchCommentList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return getSearchCommentList;
	}	
	
	
	//글 저장 메소드
	public int insertCommenet(Board_commentDTO comment) {
		int n = 0;
		int num = 0;
		int ref = 0;

		int point = 0;
		double avgpoint = 0;
		int sittercount = 0;
				
		String sql = null;
		try {
			conn = getConnection();
			
			//고유넘버 구해서 ref에 담기
			sql = "select max(num) from board_comment";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()) ref = rs.getInt(1)+1;
			else ref = 1;
				
			//시터db에 point, avgpoint, countpoint올려주기
			sql = "select point, sittercount from mepetsitter where name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getSitter_name());
			rs = pstmt.executeQuery();
			if(rs.next()) point = rs.getInt("point"); sittercount= rs.getInt("sittercount");
				
			point += comment.getPoint();
			sittercount += 1;
			avgpoint = (double)point/sittercount;
				
			sql = "update mepetsitter set point=?, avgpoint=?, sittercount=? where name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, point);
			pstmt.setDouble(2, avgpoint);
			pstmt.setDouble(3, sittercount);
			pstmt.setString(4, comment.getSitter_name());
			pstmt.executeUpdate();
			
			//시터의 펫시터게시판 글컬럼에도 avg업데이트해주기
			sql = "update board_sitter set avgpoint=? where name=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setDouble(1, avgpoint);
			pstmt.setString(2, comment.getSitter_name());
			pstmt.executeUpdate();
					
			//글 저장하는 메소드
			sql = "insert into board_comment(num, id, nick, subject, content, petdate, petday, area, sitter_name, point, img, ref, ip, reg ) "
					+ "values(board_comment_seq.nextval,?,?,?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getId());
			pstmt.setString(2, comment.getNick());
			pstmt.setString(3, comment.getSubject());
			pstmt.setString(4, comment.getContent());
			pstmt.setString(5, comment.getPetdate());
			pstmt.setString(6, comment.getPetday());
			pstmt.setString(7, comment.getArea());
			pstmt.setString(8, comment.getSitter_name());
			pstmt.setInt(9, comment.getPoint());
			pstmt.setString(10, comment.getImg());
			pstmt.setInt(11, ref);
			pstmt.setString(12, comment.getIp());
			pstmt.setTimestamp(13, comment.getReg());
			
			pstmt.executeUpdate();
			
			
			sql = "select num from board_comment where ref=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			rs = pstmt.executeQuery();
			
			if(rs.next()) n = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return n;
	}	
	//답글 저장 매소드
	public int insertRecommenet(Board_commentDTO comment) {
		int n = 0;
		int ref = comment.getRef();
		int re_step = comment.getRe_step();
		
		String sql = null;
		try {
			conn = getConnection();

			sql = "update board_comment set re_step = re_step+1 where ref=? and re_step > ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			pstmt.setInt(2, re_step);
			pstmt.executeUpdate();
				
			re_step += 1;
			
			//글 저장하는 메소드
			sql = "insert into board_comment(num, id, nick, subject, content, sitter_name, ref, re_step, img, ip, reg) "
					+ "values(board_comment_seq.nextval,?,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getId());
			pstmt.setString(2, comment.getNick());
			pstmt.setString(3, comment.getSubject());
			pstmt.setString(4, comment.getContent());
			pstmt.setString(5, comment.getSitter_name());
			pstmt.setInt(6, ref);
			pstmt.setInt(7, re_step);
			pstmt.setString(8, comment.getImg());
			pstmt.setString(9, comment.getIp());
			pstmt.setTimestamp(10, comment.getReg());
			
			pstmt.executeUpdate();
			
			
			sql = "select num from board_comment where ref=? and re_step=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, ref);
			pstmt.setInt(2, re_step);
			rs = pstmt.executeQuery();
			
			if(rs.next()) n = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		return n;
	}
	
	
	//content 리턴 메소드
	public Board_commentDTO commentContent(int num) {
		Board_commentDTO comment = null;
		
		try {
			//조회수 올려주기
			conn = getConnection();
			String sql = "update board_comment set readcount = readcount+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "select * from board_comment where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				comment = new Board_commentDTO();
				comment.setNum(rs.getInt("num"));
				comment.setId(rs.getString("id"));
				comment.setNick(rs.getString("nick"));
				comment.setSubject(rs.getString("subject"));
				comment.setContent(rs.getString("content"));
				comment.setPetdate(rs.getString("petdate"));				
				comment.setPetday(rs.getString("petday"));
				comment.setArea(rs.getString("area"));
				comment.setSitter_name(rs.getString("sitter_name"));
				comment.setPoint(rs.getInt("point"));
				comment.setImg(rs.getString("img"));
				comment.setRef(rs.getInt("ref"));
				comment.setRe_step(rs.getInt("re_step"));
				comment.setReadcount(rs.getInt("readcount"));
				comment.setIp(rs.getString("ip"));
				comment.setReg(rs.getTimestamp("reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return comment;
	}
	
	public Board_commentDTO getArticle(int num) {
		Board_commentDTO comment = null;
		
		try {

			conn = getConnection();
			String sql = "select * from board_comment where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				comment = new Board_commentDTO();
				comment.setNum(rs.getInt("num"));
				comment.setId(rs.getString("id"));
				comment.setNick(rs.getString("nick"));
				comment.setSubject(rs.getString("subject"));
				comment.setContent(rs.getString("content"));
				comment.setPetdate(rs.getString("petdate"));				
				comment.setPetday(rs.getString("petday"));
				comment.setArea(rs.getString("area"));
				comment.setSitter_name(rs.getString("sitter_name"));
				comment.setPoint(rs.getInt("point"));
				comment.setImg(rs.getString("img"));
				comment.setRef(rs.getInt("ref"));
				comment.setRe_step(rs.getInt("re_step"));
				comment.setReadcount(rs.getInt("readcount"));
				comment.setIp(rs.getString("ip"));
				comment.setReg(rs.getTimestamp("reg"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return comment;
	}
	
	
	//이전글 메소드
	public int pastNum(int count , int num) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment order by ref desc, re_step asc) "
					+ "order by ref desc, re_step asc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment order by ref desc, re_step asc) "
				+ "order by ref desc, re_step asc) where r=?";
				
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
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment order by ref desc, re_step asc) "
					+ "order by ref desc, re_step asc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment order by ref desc, re_step asc) "
				+ "order by ref desc, re_step asc) where r=?";
				
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
	
	//내가 쓴 글 이전글 메소드
	public int pastNum(int count , int num, String nick) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment where nick=? order by ref desc, re_step asc) "
					+ "order by ref desc, re_step asc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment where nick=? order by ref desc, re_step asc) "
				+ "order by ref desc, re_step asc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nick);
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
	
	//내가 쓴 글 다음글 메소드
	public int nextNum(int num, String nick) {
		int nextNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment where nick=? order by ref desc, re_step asc) "
					+ "order by ref desc, re_step asc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, nick);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment where nick=? order by ref desc, re_step asc) "
				+ "order by ref desc, re_step asc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, nick);
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
	
	//내게 쓴 글 이전글 메소드
	public int pastNum_s(int count , int num, String sitter_name) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment where sitter_name=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, sitter_name);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment where sitter_name=? order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, sitter_name);
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
	
	//내게 쓴 글 다음글 메소드
	public int nextNum_s(int num, String sitter_name) {
		int nextNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num,ref,re_step, rownum r from "
					+ "(select num,ref,re_step from board_comment where sitter_name=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, sitter_name);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num,ref,re_step, rownum r from "
				+ "(select num,ref,re_step from board_comment where sitter_name=? order by num desc) "
				+ "order by num desc) where r=?";
				
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, sitter_name);
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
	
	//사진 정보 리턴 메소드
	public String commentImg(int num) {
		String img = null;
		
		try {
			conn = getConnection();
			String sql = "select img from board_comment where num=?";
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
	
	//글 수정하는 메소드
	public void modifyComment(Board_commentDTO comment) {
		int dbPoint = 0;
		int sitterPoint = 0;
		int sittercount = 0;
		double avgpoint = 0;
		String sql = null;
		
		try {
			conn = getConnection();
			
			//만약에 입력받은 point와 기존후기에 point가 다를 경우
			sql = "select point from board_comment where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment.getNum());
			rs = pstmt.executeQuery();
			if(rs.next()) dbPoint = rs.getInt(1);
			
			
			if(dbPoint != comment.getPoint()) {
				sql = "select * from mepetsitter where name=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, comment.getSitter_name());
				rs = pstmt.executeQuery();
				if(rs.next()) sitterPoint = rs.getInt("point"); sittercount = rs.getInt("sittercount");
				sitterPoint = sitterPoint - dbPoint + comment.getPoint();
				avgpoint = (double)sitterPoint / sittercount;
				
				sql = "update mepetsitter set point=?, avgpoint=? where name=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, sitterPoint);
				pstmt.setDouble(2, avgpoint);
				pstmt.setString(3, comment.getSitter_name());
				pstmt.executeUpdate();
				
				//시터의 펫시터게시판 글컬럼에도 avg업데이트해주기
				sql = "update board_sitter set avgpoint=? where name=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setDouble(1, avgpoint);
				pstmt.setString(2, comment.getSitter_name());
				int x = pstmt.executeUpdate();

			}
			
			sql = "update board_comment set subject=?,content=?,petdate=?,petday=?,area=?,sitter_name=?,point=?,img=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getSubject());
			pstmt.setString(2, comment.getContent());
			pstmt.setString(3, comment.getPetdate());
			pstmt.setString(4, comment.getPetday());
			pstmt.setString(5, comment.getArea());
			pstmt.setString(6, comment.getSitter_name());
			pstmt.setInt(7, comment.getPoint());
			pstmt.setString(8, comment.getImg());
			pstmt.setInt(9, comment.getNum());
			
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
	}
	
	//답글 수정 메소드
	public void modifyRecomment(Board_commentDTO comment) {
		
		try {
			conn = getConnection();
			
			String sql = "update board_comment set subject=?,content=?,img=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getSubject());
			pstmt.setString(2, comment.getContent());
			pstmt.setString(3, comment.getImg());
			pstmt.setInt(4, comment.getNum());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
	}	
	
	
	//글 삭제 메소드
	public int deleteArticle(int num) {
		int result = 0;
		try {
			conn = getConnection();
			String sql = "delete from board_comment where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			result = pstmt.executeUpdate();
			
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
