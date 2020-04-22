<%@page import="web.mepet.model.Member_petDAO"%>
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
	if(sId == null || request.getParameter("petnum") ==null){ %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<%	}else{
		int petnum = Integer.parseInt(request.getParameter("petnum"));
		String pw = request.getParameter("pw");
		String petImg = null;
		
		
		Member_petDAO dao = new Member_petDAO();
		petImg = dao.petImg(petnum);
		int result = dao.deletePet(sId, pw, petnum);
		
		if(result == 1){ %>
			<script>
				alert("삭제가 완료되었습니다.");
				self.close();
			</script>	
	<% 	}else if(result == -1){ %>
			<script>
				alert("비밀번호가 일치하지 않습니다.");
				history.go(-1);
			</script>
	<%	}else{ %>
			<script>
				alert("시스템 오류. 다시 시도해주세요.");
				history.go(-1);
			</script>
	<% 	}
	}%>	
<body>

</body>
</html>