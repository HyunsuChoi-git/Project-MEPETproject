<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.Board_sitterDTO"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	#section { width:600px;  height:200%; }
</style>
</head>
<%
	//쿠키세션 검사
	//본인 글 아니면 아웃
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(int i = 0; i < coo.length; i++){
			if(coo[i].getName().equals("cId")) cId = coo[i].getValue();
		}
	}
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	boolean sitter = false;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitter = sitterDAO.sitterLogin(cId);
		if(sitter) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	if(sId == null){ %>
		<script>
			alert("로그인이 필요합니다.");
			window.location.href="meLoginForm.jsp";
		</script>
 <% }else if(si_sId == null){ %>
		<script>
			alert("펫시터 등록 후 이용 가능한 페이지입니다.");
			window.location.href="board_sitterList.jsp";
		</script>
 <% }
	
	int num = 0;
	if(request.getParameter("num") == null) { %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>
	<% }else{
			num = Integer.parseInt(request.getParameter("num"));
			String pageNum = null;
			String sitterpageNum = null;
			
			if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
			if(request.getParameter("sitterpageNum") != null ) sitterpageNum = request.getParameter("sitterpageNum");
			
			Board_sitterDAO dao = new Board_sitterDAO();
			Board_sitterDTO article = dao.getArticle(num);
			
			if(!article.getId().equals(si_sId)){ %>
				<script>
					alert("접근 오류.");
					window.location.href="mepetMain.jsp";
				</script>
	     <% }
			
			 MepetsitterDTO sit = sitterDAO.sitterInfo(si_sId);

%>
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<h1 id="h1sub">수정하기</h1>
			<br/>
			<div id="section">
				<form action="board_sitterModifyPro.jsp" method="post" encType="multipart/form-data">
				<input type="hidden" name="num" value="<%=num %>" />
				<% if(pageNum != null){ %> 
					<input type="hidden" name="pageNum" value="<%=pageNum %>" />
				<% }else if(sitterpageNum != null){ %> 
					<input type="hidden" name="sitterpageNum" value="<%=sitterpageNum %>" />
				<% } %>
					<table align="center">
						<tr>
							<td width="200">
						<% 	if(sit.getImg() != null){ %> <img src="sitterImg/<%=sit.getImg() %>" width="200" /> <% }
							else{ %> <img src="sitterImg/empty.png" width="150" /> <% } %>
							</td>
							<td align="left">
							이름 : <%=sit.getName() %><br/>
							지역 : <%=sit.getArea() %><br/>
							평점 : <%=sit.getAvgpoint() %>점<br/>
							펫시터 경력 : <%=sit.getSittercount() %>회  &nbsp; <br/> 
							반려동물 키워본 기간 : <%=sit.getYear() %>년
							</td>
						</tr>
					</table>
					<table id="writeForm">
						<tr>
							<td align="left">제목</td>
							<td><input type="text" name="subject" value="<%=article.getSubject()%>" size="60"/></td>
						</tr>
						<tr>
							<td colspan="2">	
							<%if(article.getImg() != null) { %>
								<img src ="boardImg/<%=article.getImg() %>" width="300"/><br/>
							<% } %>
							<input type="file" name="img" /><br/>
							</td>
						<tr>
							<td align="left" colspan="2">내용</td>
						</tr>
						<tr>
							<td colspan="2">	
							<textarea name="content" vlaue="<%=article.getContent() %>" rows="30" cols="70"><%=article.getContent() %></textarea>
							</td>
						</tr>
					</table>
					<br/>
					<input type="submit" value="수정하기"/> &nbsp; 
					<input type="button" value="돌아가기" onclick="history.go(-1)"/>
				</form>
				<br/>
			</div>
		</section>	
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
	<% } %>
</html>