<%@page import="web.mepet.model.Board_commentDTO"%>
<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	#section { width:600px; height:200%; }
</style>
</head>
<%
	//쿠키세션검사 완료.
	//비로그인 시 경고창 -> loginFrom.jsp로 보내기
	
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(Cookie c : coo){
			if(c.getName().equals("cId")) cId = c.getValue();
		}		
	}
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	boolean sitter = false;
	if(si_sId == null && cId != null){
		sitter = sitterDAO.sitterLogin(cId);
		if(sitter) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	String pageNum = null;
	String sitterpageNum = null;
	int num = 0; 

	if(si_sId == null){%>
		<script>
			alert("로그인 후 이용 가능한 페이지입니다.");
			window.location.href="meLoginForm.jsp";
		</script>
	<%}else if(request.getParameter("num") == null){%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
		
	<%}else{
	
		num = Integer.parseInt(request.getParameter("num"));
		if(request.getParameter("pageNum") != null)	pageNum = request.getParameter("pageNum");
		if(request.getParameter("sitterpageNum") != null) sitterpageNum = request.getParameter("sitterpageNum");
		
		Board_commentDAO dao = new Board_commentDAO();
		Board_commentDTO comment = dao.getArticle(num);	
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	
	%>	
	<body>
		<header>
			<jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<h1 id="h1sub">수정하기</h1>
			<br/>
			<div id="section">	
				<form action="board_commentRModifyPro.jsp" method="post" encType="multipart/form-data">
				<input type="hidden" name="num" value="<%=num %>"/>
				<%if(pageNum != null) { %>
					<input type="hidden" name="pageNum" value="<%=pageNum %>"/>
				<% } %>
				<%if(sitterpageNum != null) { %>
					<input type="hidden" name="sitterpageNum" value="<%=sitterpageNum %>"/>
				<% } %>
				<br/>
					<table id="writeForm">
						<tr>
							<td colspan="2">펫시터 : <%=comment.getSitter_name() %> &nbsp; 작성일 : <%= sdf.format(comment.getReg())%></td>
						</tr>
						<tr>
							<td><br/>제목<br/>
							<input type="text" name="subject" value="<%=comment.getSubject() %>" size="60"/></td>			
						</tr>
						<tr>
							<td colspan="2">
							<br/>내용<br/>
							<input type="file" name="img" /><br/>
							<%if(comment.getImg() != null){%>
								<img src="boardImg/<%=comment.getImg() %>" width="300" /><br/>
							<% }%>
							<textarea name="content" rows="8" cols="70">
							<%=comment.getContent() %></textarea>
							</td>
						</tr>			
						<tr>
						<td colspan="2">
						<br/>
						<%				
							if(si_sId != null && si_sId.equals(comment.getId())){%>
							<input type="submit" value="수정하기"/>
							<input type="button" value="돌아가기" onclick="history.go(-1)"/>
							<%}	%>
						</td>
					</tr>
				</table>
				</form>
			</div>	
		</section>	
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>

<%} %>
</html>