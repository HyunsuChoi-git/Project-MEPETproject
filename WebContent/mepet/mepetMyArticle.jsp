<%@page import="web.mepet.model.MepetmemberDAO"%>
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
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//쿠키 세션 검사
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId == null && cId != null){
		Cookie c = new Cookie("cId", cId);
		c.setMaxAge(60*60*24);
		response.addCookie(c);
		
		session.setAttribute("sId", cId);
		sId = cId;
	} 
	
	if(sId == null){ %>
		<script>
			alert("로그인 후 사용 가능한 페이지입니다.");
			window.location.href="meLoginForm.jsp";
		</script>	
<%	}else{ 
		String mypageNum = "1";	
		if(request.getParameter("mypageNum") != null) {
			mypageNum = request.getParameter("mypageNum");
		}
	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		int pageSize = 10;
		int currentPage = Integer.parseInt(mypageNum);
		int startRow = (currentPage-1)*pageSize + 1;
		int endRow = currentPage*pageSize;
		int number = 0; // 게시판에 뿌려줄 글번호
		
		//전체 글 갯수 반환
		int count = 0;
		
		Board_commDAO dao = new Board_commDAO();
		List getConmmList = null;
		
		//////
		
		String sel = "id";
		String search = sId;
		
		if(request.getParameter("sel") != null && request.getParameter("search") != null) {
			sel = request.getParameter("sel");
			search = request.getParameter("search");
			
			count = dao.getMyCommCount(sel, search, sId);
			if(count > 0){
				getConmmList = dao.getMyConmmentList(sel, search, startRow, endRow, sId);
			}
		}else{
			count = dao.getMyCommCount(sId);
			if(count > 0){
				getConmmList = dao.getMyConmmentList(startRow, endRow, sId);
			}
		}
		//현재페이지에서부터 모든 글의 수 
		number = count - (currentPage -1) * pageSize;
		MepetmemberDAO dao2 = new MepetmemberDAO();
		String nick = dao2.getNick(sId);

%> 
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<a href="mepetMyHome.jsp"><h3 align="center" style="margin-bottom: 0; color: #655f86;">'<%= nick%>'님의</h3>
			<h1 align="center" style="margin-top: 0; color: #655f86;">마이 미펫 홈</h1></a>
			<div id="mypage">
				<button class="box" onclick="window.location.href='mepetMypage.jsp'">내 정보</button>
				<button class="box" onclick="window.location.href='mepetMyArticle.jsp'">나의활동</button>
				<button class="box" onclick="window.location.href='mepetMysitter.jsp'">펫시터</button>
			</div>
			<br/>
			<h1 align="center"><button class="mepetButt" onclick="window.location.href='board_commList.jsp'">미펫 커뮤니티 바로가기</button></h1>
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
								</select>
								<input class="text" type="text" name="search" />
								<input class="mepetButt" type="submit" value="검색" />
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
								<a href="board_commContent.jsp?num=<%=article.getNum()%>&mypageNum=<%=mypageNum%>&count=<%=count%>&re_step=<%=article.getRe_step() %>">
								<% for(int j = 0; j < article.getRe_level(); j++){ %>
									  &nbsp; &nbsp;
								<% } %>
								  &nbsp; [답글]
								<%= article.getSubject() %></a>
								</td>
								<td><%= article.getNick() %></td>
								<td><%= sdf.format(article.getReg()) %></td>
								<td><%= article.getReadcount() %></td>
							<%-- 	<%if(admin != null){ %> 
								<td><button onclick="window.location.href='board_commentDeletePro.jsp?num=<%=comment.getNum()%>'">삭제</button></td>
								<% } %>
							--%>
							</tr>
							
					<% 	}else{ //새글 일 때 %>
							<tr>
								<td><%= number-- %></td>
								<td><%=article.getType() %></td>
								<td align="left">
								<a href="board_commContent.jsp?num=<%=article.getNum()%>&mypageNum=<%=mypageNum%>&count=<%=count%>">
								 &nbsp; <%= article.getSubject() %></a>
								</td>
								<td><%= article.getNick() %></td>
								<td><%= sdf.format(article.getReg()) %></td>
								<td><%= article.getReadcount() %></td>
							<%--<%if(admin != null){ %> 
								<td><button onclick="window.location.href='commentDeletePro.jsp?num=<%=comment.getNum()%>'">삭제</button></td>
								<% } %>
							--%>
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
					<a class="view" href="mepetMyArticle.jsp?mypageNum=<%=startPage-1%>"> &lt; </a>
					<%}
					//5. 페이지 반복해서 뿌려주기
					for(int i = startPage; i <= endPage; i++){%>
					<a class="view" href="mepetMyArticle.jsp?mypageNum=<%=i%>"> &nbsp; <%=i%> &nbsp; </a>
					<%}
					//7. endPage가 pageCount보다 작으면 '>'
					if(endPage < pageCount){%>
					<a class="view" href="mepetMyArticle.jsp?mypageNum=<%=endPage+1%>"> &gt; </a>
					<%}
				}%>
				<br/><br/>
				<button class="mepetButt" onclick="window.location.href='mepetMyHome.jsp'">마이 홈</button>
			</div>
		</section>
		<br/><br/><br/><br/><br/>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
<% } %>
</html>