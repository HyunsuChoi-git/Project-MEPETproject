<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
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
	//세션쿠키 로직
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	
	if(sId == null && si_sId != null) { %>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>		
<% 	}else{
		
		
	//2.
	String path = request.getRealPath("mepet/sitterImg");
	//3.
	int max = 1024*1024*5;
	//4.
	String enc = "UTF-8";
	//5.
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = null;
	
	try{
		mr = new MultipartRequest(request,path,max,enc,dp);
		
		String sysname = mr.getFilesystemName("img");
		String contentT = mr.getContentType("img");
		if(sysname != null){
			String[] ct = contentT.split("/");
			File f = new File(sysname);
			if(!(ct[0].equals("image"))){
				f.delete();
			%>
				<script type="text/javascript">
					alert("이미지 파일이 아닙니다. 이미지 파일을 업로드해주세요.");
					history.go(-1);
				</script>		
			<%	
			}
			
		}

		String pw = mr.getParameter("pw");
		String name = mr.getParameter("name");
		int phon = 0;
		if(mr.getParameter("phon") != null) phon = Integer.parseInt(mr.getParameter("phon"));
		String email = mr.getParameter("email");
		String area = mr.getParameter("area");
		int year = 0; 
		if(mr.getParameter("year") != null) year = Integer.parseInt(mr.getParameter("year"));
		
		MepetsitterDTO dto = new MepetsitterDTO();
		dto.setId(sId);
		dto.setPw(pw);
		dto.setName(name);
		dto.setPhon(phon);
		dto.setEmail(email);
		dto.setArea(area);
		dto.setYear(year);
		dto.setImg(sysname);
		dto.setReg(new Timestamp(System.currentTimeMillis()));
		
		MepetsitterDAO dao = new MepetsitterDAO();
		int result = dao.sitterSignup(dto);
		
		if(result == 1){ %>	
		<script>
			alert("펫시터 가입이 완료되었습니다.");
			window.location.href="mepetSitterHome.jsp";
		</script>
	<% }else{ %>	
		<script>
			alert("시스템오류 다시시도해주세요.");
			window.location.href="meSitterSignupForm.jsp";
		</script>
	<% }
		
		
	}catch(Exception e){ %>
 		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<% 	} 
} %>
</body>
</html>