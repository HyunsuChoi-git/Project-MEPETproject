<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="web.mepet.model.Board_commentDTO"%>
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
			if(!(ct[0].equals("image"))){
				File f = new File(sysname);
				f.delete();
			%>
				<script type="text/javascript">
					alert("이미지 파일이 아닙니다. 이미지 파일을 업로드해주세요.");
					history.go(-1);
				</script>		
			<%	
			}
		}
		
		
		int num = 0, ref = 0, re_step = 0;
		String sitter_name = mr.getParameter("sitter_name");
		String nick = mr.getParameter("nick");
		
		if(mr.getParameter("num") != null) num = Integer.parseInt(mr.getParameter("num"));
		if(mr.getParameter("ref") != null) ref = Integer.parseInt(mr.getParameter("ref"));
		if(mr.getParameter("re_step") != null) re_step = Integer.parseInt(mr.getParameter("re_step"));
		
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		String ip = request.getRemoteAddr();

		Board_commentDTO comment = new Board_commentDTO();
		comment.setId(si_sId);
		comment.setNick(nick);
		comment.setSubject(subject);
		comment.setContent(content);
		comment.setSitter_name(sitter_name);
		comment.setRef(ref);
		comment.setRe_step(re_step);
		comment.setImg(sysname);
		comment.setIp(ip);
		comment.setReg(new Timestamp(System.currentTimeMillis()));
		
		Board_commentDAO dao = new Board_commentDAO();
		int number = dao.insertRecommenet(comment);
		
	%>
	</body>
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
						<td>답글이 등록되었습니다.<br/>
						<button onclick="window.location.href='board_commentList.jsp'">리스트보기</button>
						<button onclick="window.location.href='board_commentContent.jsp?num=<%=number%>&pageNum=1'">작성글확인</button>
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