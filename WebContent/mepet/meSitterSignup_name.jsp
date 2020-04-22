<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
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
	String name = request.getParameter("name");

	//세션 쿠키검사
	//비로그인 상태 및, name값 없으면 접근오류
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	
	if(sId == null || name == null) { %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
	<% }else{
	
		MepetsitterDAO dao = new MepetsitterDAO();
		boolean result = dao.nameCheck(name);
		
		if(result){
			%>
			<form action="meSitterSignup_name.jsp" method="post">
				<tr>
					<td>'<%=name %>' 은/는 이미 존재하는 이름입니다.</td>
				</tr>
				<tr>
					<td>
						<input type="text" name="name" />
						<input type="submit" value="다시검색" />
					</td>
				</tr>
			</form>
			<%			
		}else{
			%>
			<form action="meSitterSignup_name.jsp" method="post">
			<tr>
				<td>'<%=name %>'은/는 사용할 수 있는 닉네임입니다.</td>
			</tr>
			<tr>
				<td>
					<input type="text" name="name" />
					<input type="submit" value="다시검색" />
				</td>
			</tr>
			<tr>
				<td>
					<input type="button" value="사용하기" onclick="setId()"/>
					<script>
						function setId(){
							opener.document.signup.name.value="<%=name%>";
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