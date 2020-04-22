<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#header{ background-color: #aebdea;}
	#sub{ text-align: left; margin: 0 ; width:120px; height:40px; display: inline-block; padding-bottom: 15px;
	color : azure; font-size: 35px; padding-bottom: 15px;
	}
	.headerb{ 
	background-color: azure; border : 1px solid azure; border-radius: 3px;
	padding : 3px; padding-left : 5px; padding-right : 5px; font-size : 15px; color: #77878F; FONT-FAMILY: 맑은 고딕,verdana;
	margin-top: 0px; font-size : 13px; }
	
	#mepet:link{ color : azure; text-decoration: none; }
	#mepet:visited{ color : azure; text-decoration: none; }
</style>
</head>
<%
	//쿠키세션 검사
	//로그인/비로그인
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String admin = (String)session.getAttribute("admin");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	MepetsitterDAO sitterDAO = null;
	boolean sitter = false;
	if(sId == null && cId != null){
		System.out.println("test");
		Cookie c = new Cookie("cId", cId);
		c.setMaxAge(60*60*24);
		response.addCookie(c);
		
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitterDAO = new MepetsitterDAO();
		sitter = sitterDAO.sitterLogin(cId);
		
		if(sitter) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	} 
%>
<body>
	<div id="header">
		<h1 id="sub">&nbsp;&nbsp;<a id="mepet" href="mepetMain.jsp">미펫</a></h1>
		<div style="text-align:right; float:right; width:200px; margin:5px; " >
		<% if(admin != null){ %> 
			<button class="headerb" onclick="window.location.href='mepetAdminHome.jsp'">관리자 홈</button>
			<button class="headerb" onclick="window.location.href='meLogout.jsp'">로그아웃</button>
		<% }else if(sId == null) { %>
			<button class="headerb" onclick="window.location.href='meLoginForm.jsp'">로그인</button>
			<button class="headerb" onclick="window.location.href='meSignupForm.jsp'">회원가입</button>
		<% }else if(sId != null){ 
				if(si_sId != null){ %>
					<button class="headerb" onclick="window.location.href='mepetSitterHome.jsp'">펫시터 홈</button>
			 <% } %>
			<button class="headerb" onclick="window.location.href='mepetMyHome.jsp'">마이 홈</button>
			<button class="headerb" onclick="window.location.href='meLogout.jsp'">로그아웃</button>
		<% }%> 
		</div>
	</div>
</body>
</html>