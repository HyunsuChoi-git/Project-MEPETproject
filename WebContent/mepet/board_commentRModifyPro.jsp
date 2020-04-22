<%@page import="web.mepet.model.Board_commentDTO"%>
<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	#section { width:250px; padding :10px;}
	tr { line-height:30px; }
</style>
</head>
<%

	request.setCharacterEncoding("UTF-8");	

	//세션,버그잡기 완료
	String si_sId = (String)session.getAttribute("si_sId");
	String pageNum = null;
	String sitterpageNum = null;
	int num = 0; 

	if(si_sId == null){%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
	<%}
	
	//2.
	String path= request.getRealPath("mepet/boardImg");
	//3.
	int max = 1024*1024*5;
	//4.
	String enc = "UTF-8";
	//5.
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = null;
	
	try{
		mr = new MultipartRequest(request, path, max, enc, dp);
		
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
		
		if(mr.getParameter("pageNum") != null)	pageNum = mr.getParameter("pageNum");
		if(mr.getParameter("sitterpageNum") != null) sitterpageNum = mr.getParameter("sitterpageNum");
		num = Integer.parseInt(mr.getParameter("num"));
		
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		
		Board_commentDAO dao = new Board_commentDAO();
		
		String img = dao.commentImg(num);
		if(sysname == null)	{
			sysname = img;
		}else{
			File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);				
			f.delete();
		}	
		
		Board_commentDTO comment = new Board_commentDTO();
		comment.setNum(num);
		comment.setSubject(subject);
		comment.setContent(content);
		comment.setImg(sysname);
		
		dao.modifyRecomment(comment);
		
	%>
	<body>
		<header>
			<jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<br/>
			<br/>
			<div id="section">
				<table id="writeForm">
					<tr>
						<td>수정이 완료되었습니다.<br/>
						<%if(pageNum != null){ %> 
							<button onclick="window.location.href='board_commentList.jsp?pageNum=<%=pageNum%>'">리스트보기</button>
							<button onclick="window.location.href='board_commentContent.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">수정글확인</button>
						<% }else if(sitterpageNum != null){ %> 
							<button onclick="window.location.href='mepetSitterComment.jsp?sitterpageNum=<%=sitterpageNum%>'">리스트보기</button>
							<button onclick="window.location.href='board_commentContent.jsp?num=<%=num%>&sitterpageNum=<%=sitterpageNum%>'">수정글확인</button>
						<% } %>
						</td>
					</tr>
					
				</table>
			</div>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
		
 	<%}catch(Exception e){%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
	<%}%> 
</html>