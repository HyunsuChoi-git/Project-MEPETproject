<%@page import="web.mepet.model.Member_petDTO"%>
<%@page import="web.mepet.model.Member_petDAO"%>
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
			
			Member_petDAO dao = new Member_petDAO();
			
			String type = mr.getParameter("type");
			String pettype = mr.getParameter("pettype");
			String petname = mr.getParameter("petname");
			int petage = 0;
			if(mr.getParameter("petage") != null){
				petage = Integer.parseInt(mr.getParameter("petage"));
			}
			String petsex = mr.getParameter("petsex");
			String petsize = mr.getParameter("petsize");
			double petweight = 0;
			if(mr.getParameter("petweight") != null){
				petweight = Double.parseDouble(mr.getParameter("petweight"));
			}
			String petneutral =mr.getParameter("petneutral");
			int petnum = Integer.parseInt(mr.getParameter("petnum"));
			
			
			String img = dao.petImg(petnum);
			if(sysname == null)	{
				sysname = img;
			}else{
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\petImg\\"+img);				
				f.delete();
			}	
			
			Member_petDTO pet = new Member_petDTO();
			
			pet.setType(type);
			pet.setPettype(pettype);
			pet.setPetname(petname);
			pet.setPetage(petage);
			pet.setPetsex(petsex);
			pet.setPetsize(petsize);
			pet.setPetweight(petweight);
			pet.setPetneutral(petneutral);
			pet.setImg(sysname);
			pet.setPetnum(petnum);
			
			int result = dao.modifyPet(pet);
			if(result == 1){ %>	
			<script>
				alert("반려동물의 정보를 수정하였습니다.");
				window.location.href="mepetMypetInfo.jsp?petnum=<%=petnum%>";
			</script>
		<% }else{ %>	
			<script>
				alert("시스템오류 다시시도해주세요.");
				window.location.href="mepetMypetModify.jsp";
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