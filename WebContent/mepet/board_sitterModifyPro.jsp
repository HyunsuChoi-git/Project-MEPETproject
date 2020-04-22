<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="web.mepet.model.Board_sitterDTO"%>
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
	//세션검사 완료 (쿠키 검사할 필요 x)
	request.setCharacterEncoding("UTF-8");
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");

	if(sId == null || si_sId == null){	%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }
	
	//2.
	String path = request.getRealPath("mepet/boardImg");
	//3.
	int max = 1024*1024*5;
	//4.
	String ecn = "UTF-8";
	//5.
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = null;
	try{
		mr = new MultipartRequest(request, path, max, ecn, dp);
		
		//img파일 검사
		String sysname = mr.getFilesystemName("img");
		String contentType = mr.getContentType("img");
		if(contentType != null){
			String[] ct = contentType.split("/");
	
			if(!(sysname != null && ct[0].equals("image"))){
				File f = new File("sysname");
				f.delete();
			%>
				<script type="text/javascript">
					alert("이미지 파일이 아닙니다. 이미지 파일을 업로드해주세요.");
					history.go(-1);
				</script>
			<% 		
			}
		}
		
		
		int num = Integer.parseInt(mr.getParameter("num"));
		String pageNum = null;
		String sitterpageNum = null;
		if(mr.getParameter("pageNum") != null) pageNum = mr.getParameter("pageNum");
		if(mr.getParameter("sitterpageNum") != null) sitterpageNum = mr.getParameter("sitterpageNum");
		
		Board_sitterDTO article = new Board_sitterDTO();
		article.setNum(num);
		article.setSubject(mr.getParameter("subject"));
		article.setContent(mr.getParameter("content"));
		article.setImg(sysname);
		
		Board_sitterDAO dao = new Board_sitterDAO();
		//수정할 사진 존재할 경우 수정사진dto에 저장하고 이전 사진 삭제
		String img = dao.getBoardImg(num);
		if(sysname != null){
			if(img != null){
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
				f.delete();
			}
		}else{ //sysname이 존재하지 않을 경우 기존의 사진 다시 넣어주기
			article.setImg(img);
		}
		
		dao.modifyArticle(article);
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
						<td>글 수정이 완료되었습니다.<br/>
						<% if(pageNum != null) { %> 
							<button onclick="window.location.href='board_sitterContent.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">수정글확인</button> &nbsp; 
							<button onclick="window.location.href='board_sitterList.jsp'">리스트보기</button>
						<% }else if(sitterpageNum != null) { %> 
							<button onclick="window.location.href='board_sitterContent.jsp?num=<%=num%>&sitterpageNum=<%=sitterpageNum%>'">수정글확인</button> &nbsp; 
							<button onclick="window.location.href='mepetSitterArticle.jsp'">리스트보기</button>
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
	<% }catch(Exception e){ %>
		<script>
			alert("접근 오류.");
			window.location.href='mepetMain.jsp';
		</script>
 	<% } %>	

</html>