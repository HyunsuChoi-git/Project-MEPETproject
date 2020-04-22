<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<%
	//세션 쿠키검사
	//비로그인상태 접근오류
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId == null && cId == null ){ %>
		<script>
			alert("접근오류");
			window.location.href="mepetMain.jsp";
		</script>
 <% }else{
		session.invalidate();
		if(cId != null){
			Cookie c = new Cookie("cId", cId);
			c.setMaxAge(0);
			response.addCookie(c);
		} %>
		<script>
			alert("로그아웃이 완료되었습니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <%	}


%>
<body>

</body>
</html>