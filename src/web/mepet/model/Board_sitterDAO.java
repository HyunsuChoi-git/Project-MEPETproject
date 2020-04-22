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

public class Board_sitterDAO {
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	
	private Connection getConnection() throws Exception{
		Context ctx = new InitialContext();
		Context env = (Context)ctx.lookup("java:comp/env");
		DataSource ds = (DataSource)env.lookup("jdbc/orcl");
		
		return ds.getConnection();
	}
	
	//글 전체 갯수 리턴 메소드
	public int articleCount() {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_sitter";
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
	
	//한 페이지에 뿌려줄 글 List 리턴 메소드
	public List articleList(int startRow, int endRow) {
		List articleList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,name,subject,readcount,ip,reg,area,avgpoint, r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint, rownum r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint "
					+ "from board_sitter order by num desc) order by num desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			articleList = new ArrayList();
			while(rs.next()) {

				Board_sitterDTO dto = new Board_sitterDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setSubject(rs.getString("subject"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setArea(rs.getString("area"));
				dto.setAvgpoint(rs.getDouble("avgpoint"));
				
				articleList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return articleList;
	}
	
	//검색글 갯수 리턴 메소드
	public int selArticleCount(String sel, String select) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_sitter where "+sel+" like '%"+select+"%'";
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
	
	//한 페이지에 뿌려줄 검색글 List 리턴 메소드
	public List selArticleList(String sel, String select, int startRow, int endRow) {
		List articleList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,name,subject,readcount,ip,reg,area,avgpoint, r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint, rownum r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint "
					+ "from board_sitter where "+sel+" like '%"+select+"%' order by num desc) order by num desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			rs = pstmt.executeQuery();
			
			articleList = new ArrayList();
			while(rs.next()) {
				Board_sitterDTO dto = new Board_sitterDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setSubject(rs.getString("subject"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setArea(rs.getString("area"));
				dto.setAvgpoint(rs.getDouble("avgpoint"));
				
				articleList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)try {rs.close();}catch(SQLException e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(SQLException e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(SQLException e) {e.printStackTrace();}
		}
		
		return articleList;
	}
	
	//내글 갯수 뽑아오기 
	public int myArticleCount(String id) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_sitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if(rs.next()) count = rs.getInt(1);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)try {rs.close();}catch(SQLException e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(SQLException e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(SQLException e) {e.printStackTrace();}
		}
		return count;
	}
	
	//한 페이지에 뿌려줄 '내글' List 리턴 메소드
	public List myArticleList(int startRow, int endRow, String id) {
		List articleList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,name,subject,readcount,ip,reg,area,avgpoint, r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint, rownum r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint "
					+ "from board_sitter where id = ? order by num desc) order by num desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			articleList = new ArrayList();
			while(rs.next()) {

				Board_sitterDTO dto = new Board_sitterDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setSubject(rs.getString("subject"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setArea(rs.getString("area"));
				dto.setAvgpoint(rs.getDouble("avgpoint"));
				
				articleList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return articleList;
	}
	
	//내글 검색글 갯수 리턴
	public int selArticleCount(String sel, String select, String id) {
		int count = 0;
		
		try {
			conn = getConnection();
			String sql = "select count(*) from board_sitter where "+sel+" like '%"+select+"%' and id = ?";
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
	
	//내글 검색글 리턴
	
	public List selArticleList(String sel, String select, int startRow, int endRow, String id) {
		List articleList = null;
		
		try {
			conn = getConnection();
			String sql = "select num,id,name,subject,readcount,ip,reg,area,avgpoint, r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint, rownum r "
					+ "from (select num,id,name,subject,readcount,ip,reg,area,avgpoint "
					+ "from board_sitter where "+sel+" like '%"+select+"%' where id = ? order by num desc) order by num desc) "
					+ "where r >= ? and r <= ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, endRow);
			rs = pstmt.executeQuery();
			
			articleList = new ArrayList();
			while(rs.next()) {
				Board_sitterDTO dto = new Board_sitterDTO();
				
				dto.setNum(rs.getInt("num"));
				dto.setId(rs.getString("id"));
				dto.setName(rs.getString("name"));
				dto.setSubject(rs.getString("subject"));
				dto.setReadcount(rs.getInt("readcount"));
				dto.setIp(rs.getString("ip"));
				dto.setReg(rs.getTimestamp("reg"));
				dto.setArea(rs.getString("area"));
				dto.setAvgpoint(rs.getDouble("avgpoint"));
				
				articleList.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(rs != null)try {rs.close();}catch(SQLException e) {e.printStackTrace();}
			if(pstmt != null)try {pstmt.close();}catch(SQLException e) {e.printStackTrace();}
			if(conn != null)try {conn.close();}catch(SQLException e) {e.printStackTrace();}
		}
		
		return articleList;
	}
	
	//글 저장 메소드
	public int insetArticle(Board_sitterDTO article) {
		int num = 0;
		try {
			conn = getConnection();
			
			String sql = "insert into board_sitter(num,id,name,subject,content,img,ip,reg,avgpoint,area) "
					+ "values(board_sitter_seq.nextVal,?,?,?,?,?,?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getId());
			pstmt.setString(2, article.getName());
			pstmt.setString(3, article.getSubject());
			pstmt.setString(4, article.getContent());
			pstmt.setString(5, article.getImg());
			pstmt.setString(6, article.getIp());
			pstmt.setTimestamp(7, article.getReg());
			pstmt.setDouble(8, article.getAvgpoint());
			pstmt.setString(9, article.getArea());
			
			pstmt.executeUpdate();
			
			sql = "select max(num) from board_sitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getId());
			rs = pstmt.executeQuery();
			if(rs.next()) num = rs.getInt(1);
			else num = 1;
			
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return num;
	}
	
	
	//content 메소드
	public Board_sitterDTO getContent(int num) {
		Board_sitterDTO article = null;
		
		try {
			conn = getConnection();
			//조회수 올려주기
			String sql = "update board_sitter set readcount = readcount+1 where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.executeUpdate();
			
			sql = "select * from board_sitter where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new Board_sitterDTO();
				
				article.setNum(num);
				article.setId(rs.getString("id"));
				article.setName(rs.getString("name"));
				article.setImg(rs.getString("img"));
				article.setContent(rs.getString("content"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				article.setAvgpoint(rs.getDouble("avgpoint"));
				article.setArea(rs.getString("area"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return article;
	}
	
	public Board_sitterDTO getArticle(int num) {
		Board_sitterDTO article = null;
		
		try {
			conn = getConnection();

			String sql = "select * from board_sitter where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				article = new Board_sitterDTO();
				
				article.setNum(num);
				article.setId(rs.getString("id"));
				article.setName(rs.getString("name"));
				article.setImg(rs.getString("img"));
				article.setContent(rs.getString("content"));
				article.setSubject(rs.getString("subject"));
				article.setReadcount(rs.getInt("readcount"));
				article.setIp(rs.getString("ip"));
				article.setReg(rs.getTimestamp("reg"));
				article.setAvgpoint(rs.getDouble("avgpoint"));
				article.setArea(rs.getString("area"));
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
					+ "(select num from board_sitter order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_sitter order by num desc) "
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
					+ "(select num from board_sitter order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_sitter order by num desc) "
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
	
	//내 글 이전글 메소드
	public int pastNum(int count , int num, String id) {
		int pastNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_sitter where id=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR < count) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_sitter where id=? order by num desc) "
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
	
	//내 글 다음글 메소드
	public int nextNum(int num, String id) {
		int nextNum = 0;
		int nowNumR = 0;
		try {
			conn = getConnection();
			
			//현재 num의 r 값 받기
			String sql = "select r from (select num, rownum r from "
					+ "(select num from board_sitter where id=? order by num desc) "
					+ "order by num desc) where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.setInt(2, num);
			rs = pstmt.executeQuery();
			if(rs.next()) nowNumR = rs.getInt(1);
			
			if(nowNumR > 1) {
				sql = "select num from (select num, rownum r from "
				+ "(select num from board_sitter where id=? order by num desc) "
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
	
	
	//사진 정보 리턴 메소드
	public String getBoardImg(int num) {
		String img = null;
		try {
			conn = getConnection();
			String sql = "select img from board_sitter where num=?";
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
	public void modifyArticle(Board_sitterDTO article) {
		try {
			conn = getConnection();
			String sql = "update board_sitter set subject=?,content=?,img=? where num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, article.getSubject());
			pstmt.setString(2, article.getContent());
			pstmt.setString(3, article.getImg());
			pstmt.setInt(4, article.getNum());
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
			String sql = "delete from board_sitter where num=?";
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
	
	//한 아이디 이미지 전체 불러오는 메소드
	public List getBoardImg(String id) {
		List imgs = null;
		try {
			conn = getConnection();
			String sql = "select img from board_sitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			imgs = new ArrayList();
			while(rs.next()) {
				
				System.out.println(rs.getString("img"));
				imgs.add(rs.getString("img"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			close(conn,pstmt,rs);
		}
		
		return imgs;
	}
	
	//한 아이디 글 전체 삭제 메소드
	public int adminDelete(String id) {
		int r = 0;
		
		try {
			conn = getConnection();
			
			String sql = "delete from board_sitter where id=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			pstmt.executeUpdate();
			r = 1;
			
		} catch (Exception e) {
			e.printStackTrace();
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

