<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMepetStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<table>
<%
	request.setCharacterEncoding("UTF-8");
	String nick = request.getParameter("nick");

	//세션 쿠키검사
	//로그인 상태 및, nick값 없으면 접근오류
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(nick == null){ %>
		<script>
			alert("접근오류.");
			window.location.href="meLoginPro.jsp";
		</script>
 <% }else{ 	
	
		MepetmemberDAO dao = new MepetmemberDAO();
		boolean result = dao.nickCheck(nick);
		
		if(result){
			%>
			<form action="meSignup_nick.jsp" method="post">
				<tr>
					<td>'<%=nick %>' 은/는 이미 존재하는 닉네임입니다.</td>
				</tr>
				<tr>
					<td>
						<input type="text" name="nick" />
						<input type="submit" value="다시검색" />
					</td>
				</tr>
			</form>
			<%			
		}else{
			%>
			<form action="meSignup_nick.jsp" method="post">
			<tr>
				<td>'<%=nick %>'은/는 사용할 수 있는 닉네임입니다.</td>
			</tr>
			<tr>
				<td>
					<input type="text" name="nick" />
					<input type="submit" value="다시검색" />
				</td>
			</tr>
			<tr>
				<td>
					<input type="button" value="사용하기" onclick="setId()"/>
					<script>
						function setId(){
							opener.document.signup.nick.value="<%=nick%>";
							self.close();
						}
					</script>
				</td>
			</tr>
		</form>
			<%
		}
 	}
%>

	</table>
	<br/>
</body>
</html>