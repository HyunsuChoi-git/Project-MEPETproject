<%@page import="web.mepet.model.Board_commDTO"%>
<%@page import="web.mepet.model.Board_commDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	#section { width:560px; height:200%; }
</style>
</head>
<%
	//세션 쿠키 검사
	int num = 0;
	String pageNum = request.getParameter("pageNum");
	String mypageNum = null;
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId == null && cId != null) {
		session.setAttribute("sId", cId);
		sId = cId;
	}
	
	if(request.getParameter("num") == null || sId == null){ %>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{
		num = Integer.parseInt(request.getParameter("num"));	
		if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
		if(request.getParameter("mypageNum") != null) mypageNum = request.getParameter("mypageNum");
		
	 	Board_commDAO dao = new Board_commDAO();
		Board_commDTO article = dao.getArticle(num);
%>
	<body>
		<header>
		</header>
		<section>
			<br/>
			<h1 id="h1sub">수정하기</h1>
			<br/>
			<div id="section">
				<form action="board_commModifyPro.jsp" method="post" encType="multipart/form-data">		
					<input type="hidden" name="num" value="<%=num %>" />
					<% if(mypageNum != null) { %>
					<input type="hidden" name="mypageNum" value="<%=mypageNum %>" />		
					<% } %>
					<% if(pageNum != null) { %>
					<input type="hidden" name="pageNum" value="<%=pageNum %>" />		
					<% } %>
					<table id="writeForm"> 
						<tr>
							<td align="left">종류 : </td>
							<td align="left">
							<select name="type">
								<option value="<%=article.getType() %>" selected><%=article.getType() %></option>
								<option value="일반" >일반</option>
								<option value="추천">추천</option>
								<option value="거래">거래</option>
							</select>
							</td>
						</tr>
						<tr height="40px">
							<td align="left">제목 : </td>
							<td align="left"><input type="text" name="subject" size="60" value="<%= article.getSubject()%>"/></td>
						</tr>
						<tr>
							<td align="left" colspan="2" >이미지 :</td>
						</tr>
						<tr>
							<td align="left" colspan="2">
							<% if(article.getImg() != null){ %> 
								<img src="boardImg/<%=article.getImg() %>" width="300"/><br/>
							<% } %>
							<input type="file" name="img" /><br/>
						</tr>
						<tr  height="40px">
							<td align="left" colspan="2" >내용 :</td>
						</tr>
						<tr>
							<td colspan="2" >	
							<textarea name="content" rows="8" cols="70" ><%=article.getContent()%></textarea>
							</td>
						</tr>
					</table>
					<h1>
						<input type="submit" value="수정하기" />
						<input type="button" value="뒤로가기" onclick="history.go(-1)'"/>
					</h1>
				</form>
			</div>
			<br/>
			<br/>
			<br/>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>

 <% } %>
</html>