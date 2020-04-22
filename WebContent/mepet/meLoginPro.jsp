<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
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
	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	String auto = request.getParameter("auto");
	
	if(id == null || pw == null){
		String sId = (String)session.getAttribute("sId");
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
			Cookie c = new Cookie("cId", id);
			c.setMaxAge(60*60*24);
			response.addCookie(c);
			
			session.setAttribute("sId", cId);
			sId = cId;
			
			sitterDAO = new MepetsitterDAO();
			sitter = sitterDAO.sitterLogin(cId);
			if(sitter) session.setAttribute("si_sId", cId);
			
			response.sendRedirect("mepetMain.jsp");
		}else if(sId != null){
			response.sendRedirect("mepetMain.jsp");
		} %>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>	
	<% }
	
	MepetmemberDAO dao = new MepetmemberDAO();
	int result = dao.login(id, pw);
	
	switch(result){
	case 1: 
		session.setAttribute("sId", id);
		if(auto != null){
			Cookie ck = new Cookie("cId", id);
			ck.setMaxAge(60*60*24);
			response.addCookie(ck);
			System.out.println("쿠키완료");
		}
		//시터가입자용세션
		MepetsitterDAO sitterDAO = new MepetsitterDAO();
		boolean sitter = sitterDAO.sitterLogin(id);
		if(sitter) session.setAttribute("si_sId", id);
		
		//관리자용 세션
		if(id.equals("admin")){
			session.setAttribute("admin", id);
		}
		%>
		<script>
			alert("로그인 되었습니다.");
			window.location.href="mepetMain.jsp";
		</script>
		<%
	case -1: 
		%>
		<script>
			alert("비밀번호가 일치하지 않습니다.");
			history.go(-1);
		</script>
		<%
	case 0: 
		%>
		<script>
			alert("아이디가 존재하지 않습니다.");
			history.go(-1);
		</script>
		<%
	}
%>
<body>

</body>
</html>