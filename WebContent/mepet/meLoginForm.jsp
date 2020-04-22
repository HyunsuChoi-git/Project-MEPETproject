<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMepetStyle.css" rel="stylesheet" type="text/css" />
<style>	
	input {	height:30px; }
	td { width:220px; color: #37486d; font-weight: bold; }
	table { border-radius: 3px; }
	h1 { width : 200px; }
</style>
</head>
<%
	//쿠키세션검사
	//로그인 -> 프로로 넘기기
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	
	if(sId != null || cId != null){ %>
		<script>
			alert("이미 로그인 상태입니다.");
			window.location.href="meLoginPro.jsp";
		</script>
 <% }else{ %>
	<body>
		<h1>로그인</h1>
		<form action="meLoginPro.jsp" method="post">
			<table>
				<tr>
					<td>*아이디<br/>
						<input type="text" name="id" autofocus/>
					</td>
				</tr>
				<tr>
					<td>*비밀번호<br/>
						<input type="password" name="pw" /></td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" name="auto"/>자동로그인 <br/>
						<input type="submit" value="로그인" /> &nbsp; 
						<input type="button" value="회원가입" onclick="window.location.href='meSignupForm.jsp'"/>
					</td>
				</tr>
			</table>
		</form>
	</body>
  <% } %>
</html>