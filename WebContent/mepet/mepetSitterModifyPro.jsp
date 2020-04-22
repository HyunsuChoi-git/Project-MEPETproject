<%@page import="java.io.File"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
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
	String cId = null;
	Cookie[] ck = null;
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	MepetsitterDTO sitter = null;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitter = sitterDAO.sitterInfo(cId);
		if(sitter.getId() != null) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	if(si_sId == null) { %>
		<script>
			alert("펫시터 전용 페이지입니다.");
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
		
		String img = sitterDAO.sitterImg(si_sId);
		if(sysname == null)	{
			sysname = img;
		}else{
			File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\sitterImg\\"+img);				
			f.delete();
		}	
		
		String name = mr.getParameter("name");
		String pw = mr.getParameter("pw");
		String area = mr.getParameter("area");
		int year = Integer.parseInt(mr.getParameter("year"));
		
		MepetsitterDTO dto = new MepetsitterDTO();
		dto.setId(si_sId);
		dto.setName(name);
		dto.setPw(pw);
		dto.setArea(area);
		dto.setYear(year);
		dto.setImg(sysname);
		
		int result = sitterDAO.sitterModify(dto);
		
		if(result == 1){ %>	
		<script>
			alert("펫시터 정보를 수정하였습니다.");
			window.location.href="mepetSitterpage.jsp";
		</script>
	<% }else{ %>	
		<script>
			alert("시스템오류 다시시도해주세요.");
			window.location.href="mepetSitterModify.jsp";
		</script>
	<% }
		
		
	}catch(Exception e){ %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<% 	}
	
} %>
<body>

</body>
</html>