<%@page import="web.mepet.model.Board_commDAO"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="web.mepet.model.Board_commDTO"%>
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
	String sId = (String)session.getAttribute("sId");
	if(sId == null){%>
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
		String nick = mr.getParameter("nick");
		String type = mr.getParameter("type");
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		String ip = request.getRemoteAddr();
		
		int num = Integer.parseInt(mr.getParameter("num"));
		int ref = Integer.parseInt(mr.getParameter("ref"));
		int re_step = Integer.parseInt(mr.getParameter("re_step"));
		int re_level = Integer.parseInt(mr.getParameter("re_level"));
		
		Board_commDTO article = new Board_commDTO();
		article.setNum(num);
		article.setId(sId);
		article.setNick(nick);
		article.setType(type);
		article.setSubject(subject);
		article.setContent(content);
		article.setImg(sysname);
		article.setRef(ref);
		article.setRe_step(re_step);
		article.setRe_level(re_level);
		article.setIp(ip);
		article.setReg(new Timestamp(System.currentTimeMillis()));
		
		Board_commDAO dao = new Board_commDAO();
		int number = dao.insertComm(article);
		
		if(number == 0){ %>
		<script type="text/javascript">
			alert("글이 정상적으로 등록되지 않았습니다. 다시 시도해주세요.");
			history.go(-1);
		</script>	
<%	}	

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
						<td>글이 등록되었습니다.<br/>
						<button onclick="window.location.href='board_commList.jsp'">리스트보기</button>
						<button onclick="window.location.href='board_commContent.jsp?num=<%=number%>&pageNum=1'">작성글확인</button>
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
