<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
	
	if(sId == null){ %>
		<script>
			alert("로그인 후 사용 가능한 페이지입니다.");
			window.location.href="meLoginForm.jsp";
		</script>	
<%	}else{ %> 
		<jsp:useBean id="member" class="web.mepet.model.MepetmemberDTO"/>
		<jsp:setProperty property="*" name="member"/>
	<%
		MepetmemberDAO dao = new MepetmemberDAO();
		int result = dao.memberModify(member);
			
		if(result == 1){ %>	
		<script>
			alert("회원정보를 수정하였습니다.");
			window.location.href="mepetMypage.jsp";
		</script>
	<% }else{ %>	
		<script>
			alert("시스템오류 다시시도해주세요.");
			window.location.href="mepetMypage.jsp";
		</script>
	<% }
}


%>
<body>

</body>
</html>