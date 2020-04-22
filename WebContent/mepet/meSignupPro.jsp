<%@page import="web.mepet.model.MepetmemberDAO"%>
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
	td { width:330px; color: #37486d; font-weight: bold; }
	table { border-radius: 10px; }
</style>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//세션쿠키검사
	
	String sId = (String)session.getAttribute("sId");
	System.out.println(sId);
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId != null || cId != null || request.getParameter("id") == null){ %>
		<script>
			window.location.href="meLoginPro.jsp";
		</script>
 <% }else{ %>
		<jsp:useBean id="member" class="web.mepet.model.MepetmemberDTO"/>
		<jsp:setProperty property="*" name="member"/>
		<%
			MepetmemberDAO dao = new MepetmemberDAO();
			dao.signup(member);
		%>
		<body>
			<h1>미펫 회원가입</h1>
			<table>
				<tr>
					<td>
						회원가입이 완료되었습니다.<br/>
						<button onclick="window.location.href='meLoginForm.jsp'">로그인</button> &nbsp; 
						<button onclick="window.location.href='mepetMain.jsp'">메인으로</button>
					</td>
				</tr>
			</table>
		</body>

 <% } %>
</html>