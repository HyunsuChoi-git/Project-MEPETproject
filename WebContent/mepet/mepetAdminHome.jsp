<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<style>
	.box_p { height:65px; margin-top:4px; padding:10px; }
	.mepetButt { border : 1px solid #b8bce9; }
	#h1 {margin-top:45px; margin-bottom: 15px; }
	#sitterpage { margin-top:10px;}
</style>
</head>
<%
	String admin = (String)session.getAttribute("admin");
	if(admin == null){ %>
		<script>
			alert("관리자 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{ %>
	
	
		
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
			<br/>
			<a href="mepetAdminHome.jsp"><h1 align="center" style="margin-top: 0; color: #655f86;">미펫 관리자 홈</h1></a>
			<h1 id="h1" align="center"><button class="mepetButt" onclick="window.location.href='board_sitterList.jsp'">펫시터 예약하기 바로가기</button>
			<button class="mepetButt" onclick="window.location.href='board_commentList.jsp'">펫시터 이용후기 바로가기</button>
			<button class="mepetButt" onclick="window.location.href='board_commList.jsp'">미펫 커뮤니티 바로가기</button></h1>
			<div id="sitterpage">
				<button class="box_p" onclick="window.location.href='mepetAdminMember.jsp'">회원<br/>관리</button>
				<button class="box_p" onclick="window.location.href='mepetAdminSitter.jsp'">펫시터<br/>관리</button>
				<button class="box_p" onclick="window.location.href='mepetAdminPet.jsp'">Pet<br/>관리</button>
			</div>
	</body>
 <% } %>
</html>