<%@page import="web.mepet.model.MepetsitterDTO"%>
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
	#section { width:600px; height:880px;}
</style>
</head>
<%
	
	//세션 쿠키 검사 완료.
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
 <% }else{
	 
	 MepetsitterDTO sit = sitterDAO.sitterInfo(si_sId);
%> 

<body>
	<header>
		 <jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<h1 id="h1sub">홍보하기</h1>
		<br/>
		<div id="section">
		<form action="board_sitterWritePro.jsp" method="post" encType="multipart/form-data">
		<input type="hidden" name="name" value="<%=sit.getName() %>" />
		<input type="hidden" name="area" value="<%=sit.getArea() %>" />
		<input type="hidden" name="avgpoint" value="<%=sit.getAvgpoint() %>" />
			<table>
				<tr>
					<td width="60%">
				<% 	if(sit.getImg() != null){ %> <img src="sitterImg/<%=sit.getImg() %>" width="200" /> <% }
					else{ %> <img src="sitterImg/empty.png" width="200" /> <% } %>
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
			<table id="writeForm" >
				<tr height="40px">
					<td align="left">제목 : </td>
					<td align="center" colspan="2"><input type="text" name="subject" size="60"/></td>
				</tr>
				<tr>
					<tr height="80px" >
						<td align="left" >내용 :</td>
				</tr>
				<tr>	
					<td colspan="2">
					<input type="file" name="img" /><br/>
					<textarea name="content" rows="30" cols="70"></textarea>
					</td>
				</tr>
			</table>
			<input type="submit" value="등록하기"/>
			<input type="button" value="돌아가기"/>
		</form>
		</div>
	</section>	
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
  <% } %>
</html>