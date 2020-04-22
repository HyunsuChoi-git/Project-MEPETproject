<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
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
	String admin = (String)session.getAttribute("admin");
	if(admin == null){ %>
		<script>
			alert("관리자 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{ 
 		
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
			
			String mepet = mr.getParameter("mepet");
			String id = mr.getParameter("id");

			if(mepet.equals("sitter")){
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
				
				MepetsitterDAO sitterDAO = new MepetsitterDAO();
				String img = sitterDAO.sitterImg(id);
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
				dto.setId(id);
				dto.setName(name);
				dto.setPw(pw);
				dto.setArea(area);
				dto.setYear(year);
				dto.setImg(sysname);
				
				int result = sitterDAO.sitterModify(dto);
				
				if(result == 1){ %>	
				<script>
					alert("펫시터 정보를 수정하였습니다.");
					window.location.href="mepetAdminSitter.jsp";
				</script>
			<%	}
			}else if(mepet.equals("member")){
				
				String nick = mr.getParameter("nick");
				String pw = mr.getParameter("pw");
				int phon = 0;
				if(mr.getParameter("phon") != null) phon = Integer.parseInt(mr.getParameter("phon"));
				String email = mr.getParameter("email");
				
				MepetmemberDTO member = new MepetmemberDTO();
				member.setId(id);
				member.setPw(pw);
				member.setNick(nick);
				member.setPhon(phon);
				member.setEmail(email);
				
				MepetmemberDAO memberDAO = new MepetmemberDAO();
				int result = memberDAO.memberModify(member);
					
				if(result == 1){ %>	
				<script>
					alert("회원정보를 수정하였습니다.");
					window.location.href="mepetAdminMember.jsp";
				</script>
		<%		}
			}
		
		}catch(Exception e){ %>
			<script type="text/javascript">
				alert("접근 오류!");
				window.location.href="mepetMain.jsp";
			</script>	
	<% 	}
    } %>
<body>

</body>
</html>