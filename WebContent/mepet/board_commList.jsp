<%@page import="web.mepet.model.Board_commDTO"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Board_commDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xBoardList.css" rel="stylesheet" type="text/css" />
<style>
	section { min-height: 100vh;}
	body {
  min-height: 100%;
  display: grid;
  grid-template-rows: 1fr auto;
}
</style>
<style>
	.mepetButt { border : 1px solid #b8bce9; }
</style>
</head>
<%
	//전체공개, 게시글도 전체공개    쿠키세션검사완료
	//글쓰기만 회원전용으로
	request.setCharacterEncoding("UTF-8");
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String admin = (String)session.getAttribute("admin");
	String cId = null;
	Cookie[] ck = null;
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	
	String pageNum = "1";	
	if(request.getParameter("pageNum") != null) {
		pageNum = request.getParameter("pageNum");
	}

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	int pageSize = 10;
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage-1)*pageSize + 1;
	int endRow = currentPage*pageSize;
	int number = 0; // 게시판에 뿌려줄 글번호
	
	//전체 글 갯수 반환
	int count = 0;
	
	Board_commDAO dao = new Board_commDAO();
	List getConmmList = null;
	
	/////////검색기능을 사용했으면 검색관련 글 뽑아주기
	
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	if(sel != null && search != null){
		count = dao.getSearchCommCount(sel, search);
		if(count > 0){
			getConmmList = dao.getConmmentList(sel, search, startRow, endRow);
		}
	}else{
		count = dao.getCommCount();
		if(count > 0){
			getConmmList = dao.getConmmentList(startRow, endRow);
		}
	}
	
	//현재페이지에서부터 모든 글의 수 
	number = count - (currentPage -1) * pageSize;

%>
<body>
	<header>
		<jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<br/>
		<a href="board_commList.jsp"><h1 align="center" style="margin-bottom: 0; color: #3e6383;">미펫 커뮤니티</h1></a>
		<br/>
		<br/>
		<% if(sId != null){ %> 
			<div align="center">
			<button class="button" onclick="window.location.href='board_sitterList.jsp'">펫시터 구하기</button> &nbsp; &nbsp; 
			<button class="button" onclick="window.location.href='board_commentList.jsp'">펫시터 이용후기</button>
			<br/><br/><br/>
			<button class="listButt" onclick="window.location.href='board_commWriteForm.jsp?pageNum=<%=pageNum%>'">글쓰기</button>
			</div>
		<% } %>
		<br/>
		<div class="table">
			<table id="list">
				<tr>
					<td colspan="6" align="right">
						<form action="board_commList.jsp" method="post">
							<select id="sel" name="sel">
								<option value="type">글종류</option>
								<option value="subject">제목</option>
								<option value="content">내용</option>
								<option value="nick">닉네임</option>
							</select>
							<input class="text" type="text" name="search" />
							<input type="submit" value="검색" />
						</form>
					</td>
				</tr>
				<tr>
					<td>No.</td>
					<td>글종류</td>
					<td width="350px">제목</td>
					<td>글쓴이</td>
					<td>날짜</td>
					<td>조회수</td>
				</tr>
			<% // 글이 없을 때
				if(count == 0){ %>
					<tr>
						<td colspan="6" width="400">작성된 글이 없습니다.</td>
					</tr>	
			<% 	}else{ //글이 있을 때 
				Board_commDTO article = null;
				for(int i = 0; i < getConmmList.size(); i++){
					article = (Board_commDTO)getConmmList.get(i);
					if(article.getRe_step() > 0){	//답글일 때 %>
						<tr>
							<td><%= number-- %></td>
							<td><%=article.getType() %></td>
							<td align="left">
							<a href="board_commContent.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>&count=<%=count%>&re_step=<%=article.getRe_step() %>">
							<% for(int j = 0; j < article.getRe_level(); j++){ %>
								  &nbsp; &nbsp;
							<% } %>
							  &nbsp; <img src = "adminImg/rewriteIcon.png" width="15" /> [답글]
							<%= article.getSubject() %></a>
							</td>
							<td><%= article.getNick() %></td>
							<td><%= sdf.format(article.getReg()) %></td>
							<td><%= article.getReadcount() %></td>
						 	<%if(admin != null){ %> 
							<td><button onclick="window.location.href='board_commDelete.jsp?num=<%=article.getNum()%>'">삭제</button></td>
							<% } %>
						
						</tr>
						
				<% 	}else{ //새글 일 때 %>
						<tr>
							<td><%= number-- %></td>
							<td><%=article.getType() %></td>
							<td align="left">
							<a href="board_commContent.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>&count=<%=count%>">
							 &nbsp; <%= article.getSubject() %></a>
							</td>
							<td><%= article.getNick() %></td>
							<td><%= sdf.format(article.getReg()) %></td>
							<td><%= article.getReadcount() %></td>
						<%if(admin != null){ %> 
							<td><button onclick="window.location.href='board_commDelete.jsp?num=<%=article.getNum()%>'">삭제</button></td>
							<% } %>
						
						</tr>
				<%	}
			 	}
			} %>	
			</table>
		</div>
		
		<br/>
		<br/>
		<div class="view" align="center">
		<%//페이지뷰어 만들기
			if(count > 0){
				//1. 총 몇페이지 나오는지 계산
				int pageCount = count/pageSize + (count%pageSize == 0 ? 0 : 1);
				//2. 보여줄 페이지번호의 갯수
				int pageBlock = 5;
				//3. 현재 위치한 페이지에서 페이지 뷰어 첫번째 숫자가 무엇인지 찾기.
				int startPage = 0;
					if(currentPage % pageBlock == 0){
						startPage = (int)((currentPage-1)/pageBlock)*pageBlock+1;
					}else{
						startPage = (int)(currentPage/pageBlock)*pageBlock+1;
					}
				//4. 마지막에 보여지는 페이지뷰어에 페이지 갯수가 10 미만일 때. 마지막 페이지 번호가 endPage가 되도록.
				int endPage = startPage + pageBlock - 1;
				if(endPage > pageCount) endPage = pageCount;
				//6. startPage가 pageBlock보다 크면 '<'
				if(startPage > pageBlock){%>
				<a class="view" href="board_commList.jsp?pageNum=<%=startPage-1%>"> &lt; </a>
				<%}
				//5. 페이지 반복해서 뿌려주기
				for(int i = startPage; i <= endPage; i++){%>
				<a class="view" href="board_commList.jsp?pageNum=<%=i%>"> &nbsp; <%=i%> &nbsp; </a>
				<%}
				//7. endPage가 pageCount보다 작으면 '>'
				if(endPage < pageCount){%>
				<a class="view" href="board_commList.jsp?pageNum=<%=endPage+1%>"> &gt; </a>
				<%}
			}%>
			<br/><br/>
			<button class="button" onclick="window.location.href='mepetMain.jsp'">메인으로</button>
		</div>
		<br/><br/><br/><br/><br/><br/><br/><br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
</html>