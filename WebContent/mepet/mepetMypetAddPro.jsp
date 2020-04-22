<%@page import="web.mepet.model.Member_petDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="web.mepet.model.Member_petDTO"%>
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
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<%	}else{ 
		
		//2.
		String path = request.getRealPath("mepet/petImg");
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
			
			String type = mr.getParameter("type");
			String pettype = mr.getParameter("pettype"); 
			String petname = mr.getParameter("petname");
			int petage = 0;
			if(mr.getParameter("petage") != null ){
				petage = Integer.parseInt(mr.getParameter("petage"));
			}
			String petsex = mr.getParameter("petsex");
			String petsize = mr.getParameter("petsize");
			double petweight = 0;
			if(mr.getParameter("petweight") != null ){
				petweight = Double.parseDouble(mr.getParameter("petweight"));
			}
			String petneutral = mr.getParameter("petneutral");
			
			Member_petDTO pet = new Member_petDTO();
			pet.setId(sId);
			pet.setType(type);
			pet.setPettype(pettype);
			pet.setPetname(petname);
			pet.setPetage(petage);
			pet.setPetsex(petsex);
			pet.setPetsize(petsize);
			pet.setPetweight(petweight);
			pet.setPetneutral(petneutral);
			pet.setImg(sysname);
			pet.setReg(new Timestamp(System.currentTimeMillis()));
			
			
			Member_petDAO dao = new Member_petDAO();
			int result = dao.insertPet(pet);
			
			if(result == 1){ %>
				<script>
					alert("등록 완료!");
					self.close();
				</script>	
		<% 	}else{ %>
				<script>
					alert("시스템 오류. 다시 시도해주세요.");
					window.location.href="mepetMypetAdd.jsp";
				</script>	
			
		<% } 
			
			
			
		}catch(Exception e){ %>
			<script>
				alert("접근 오류.");
				window.location.href="mepetMain.jsp";
			</script>	
	 <% }
  } %>
<body>

</body>
</html>