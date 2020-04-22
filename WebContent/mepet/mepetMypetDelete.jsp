<%@page import="web.mepet.model.Member_petDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<style>
	body { background-color: #f5f0f1; text-align: center;}
	.sel { height:22px; font-size: 13px; margin-top:10px;}
	#infoForm { width: 200px; }
</style>
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
	if(sId == null || request.getParameter("petnum") ==null){ %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<%	}else{
		
		int petnum = Integer.parseInt(request.getParameter("petnum"));
	
		
%>	
	<body>
		<table  id="infoForm">
			<form action="mepetMypetDeletePro.jsp" method="post" />
			<input type="hidden" name="petnum" value="<%=petnum %>" />
			<tr>
				<td>
				비밀번호를 입력하세요.<br/>
				<input class="sel" type="password" name="pw" />
				</td>
			</tr>
			<tr>
				<td>
				<input class="mepetButt" type="submit" value="삭제하기" /> &nbsp; 
				<input class="mepetButt" type="button" value="취소" onclick="history.go(-1)"/>
				</td>
			</tr>
			</form>
		</table>
	</body>
<% } %>
</html>