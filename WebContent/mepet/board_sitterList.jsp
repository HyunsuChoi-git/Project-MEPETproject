<%@page import="web.mepet.model.Board_sitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xBoardList.css" rel="stylesheet" type="text/css" />
<style>
	TD { border-right: 1; padding: 7px; }
	img { margin: 0 auto; text-align: center;}
	.list { margin: 0 auto; }
	.mepetButt { border : 1px solid #b8bce9; }
</style>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//쿠키세션 검사 완료
	//List는 누구나 볼 수 있게, 
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
	
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	MepetsitterDTO sitter = null;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitter = sitterDAO.sitterInfo(cId);
		if(sitter.getId() != null) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	/////////////////////
	
	
	//한페이지 보여줄 글 갯수 셋팅
	String pageNum = "1";
	if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
	
	int pageOfArticles = 5;
	
	//List에 필요한 변수 세팅
	int currentPage = Integer.parseInt(pageNum);
	int startRow = (currentPage-1)*pageOfArticles +1;
	int endRow = pageOfArticles*currentPage;
	int count = 0;
	List articleList = null;
	
	Board_sitterDAO boardDAO = new Board_sitterDAO();
	
	//전체글과 검색글 나누기
	String sel = request.getParameter("sel");
	String select = request.getParameter("select");
	if(sel != null && select != null){
		count = boardDAO.selArticleCount(sel, select);
		if(count > 0) articleList = boardDAO.selArticleList(sel, select, startRow, endRow);
	}else{
		count = boardDAO.articleCount();
		if(count > 0) articleList = boardDAO.articleList(startRow, endRow);
	}
	
%>
<body>
	<header>
		 <jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<br/>
		<h1 align="center" style="margin-bottom: 0; color: #3e6383;">펫시터 예약하기</h1>
		<br/>
		<div id="button" align="center">
			<button class="button" onclick="window.location.href='board_commentList.jsp'">펫시터 이용후기</button> &nbsp; &nbsp; 
			<button class="button" onclick="window.location.href='board_commList.jsp'">미펫 커뮤니티</button>
			<br/><br/><br/>
			<% if(si_sId != null){ %>
				<button class="listButt" onclick="window.location.href='board_sitterWriteForm.jsp'">홍보하기</button>
				<br/><br/>
			<% } %>
			<form >
				<select id="sel" name="sel">
					<option value="area">지역</option>
					<option value="name">펫시터</option>
					<option value="avgpoint">평점</option>
				</select>
				<input class="text" type="text" name="select" id ="sel"/>
				<input type="submit" value="검색" id ="search"/>
			</form>
		</div>
		<br/>
		<%
		Board_sitterDTO article = null;
		
		if(count > 0){ 
			for(int i = 0; i < articleList.size(); i++){
				article = (Board_sitterDTO)articleList.get(i);
				sitter = sitterDAO.sitterInfo(article.getId());
				%>
				<div class="sitterTable">
					<table class="list">
						<tr>
							<td>
							 	<% if(sitter.getImg() != null){ %>
									<img src="sitterImg/<%=sitter.getImg() %>" width="130"/>
								<% }else{ %>
									<img src="sitterImg/empty.png" width="130"/>
								<% } %>
							</td>
							<td width="400" height="100px">
								<a class="subject" href="board_sitterContent.jsp?num=<%=article.getNum()%>
									&pageNum=<%=pageNum%>&count=<%= count%>"><h2><%=article.getSubject() %></h2></a>
								<h4 style="color:#22252e;"><%=article.getName() %> 님</h4>
								<p>
								지역 : <%=sitter.getArea() %> &nbsp; 
								펫시터 경력 : <%=sitter.getSittercount() %>회 &nbsp; 
								반려동물 경험 : <%=sitter.getYear() %>년 &nbsp; 
								펫시터 평점 : <%=sitter.getAvgpoint() %>점
								</p>
							</td>
							<td>조회<br/><%=article.getReadcount() %></td>
							<% if(admin != null) { %> 
							<td><button onclick="window.location.href='board_sitterDelete.jsp?num=<%=article.getNum()%>'">삭제</button></td>
							<% } %>
						</tr>
					</table>	
				</div>	
				<br/>
			<% } %>
		<% }else { %> 
			<div class="sitterTable">
				<table class="list">
					<tr height="100px">
						<td width="500" >등록된 글이 없습니다.</td>
					</tr>	
				</table>
			</div>
		<% } %>
		<br/>
		<div class="view" align="center">
		<% //페이지뷰어
		
		//필요한 변수 4개 생성
		int pageBlock = 5;
		int pageCount = count/pageOfArticles + (count%pageOfArticles == 0 ? 0 : 1);
		int startPage = (currentPage/pageBlock) + 1;
			if(currentPage%pageBlock == 0) startPage = ((currentPage - 1)/pageBlock) + 1;
		int endPage = startPage + pageBlock - 1;
			if(endPage > pageCount) endPage = pageCount;
			
		if(startPage > pageBlock){ %>
		  <a class="view" href="board_sitterList.jsp?pageNum=<%=startPage-1%>"> &lt; </a> 
	 <% }	
		//뿌려주기
		for(int i = startPage; i <= endPage; i++){ %>
			&nbsp; <a class="view" href="board_sitterList.jsp?pageNum=<%=i%>"><%=i %></a> &nbsp; 
	 <% } 
		if(endPage < pageCount){ %> 
		<a class="view" href="board_sitterList.jsp?pageNum=<%=endPage+1%>"> &gt; </a>
	 <% } %>
		<br/><br/>
		<button  class="button" onclick="window.location.href='mepetMain.jsp'">메인으로</button>
		</div>
		<br/><br/><br/><br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
</html>