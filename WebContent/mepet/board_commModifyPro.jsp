<%@page import="web.mepet.model.Board_commDTO"%>
<%@page import="web.mepet.model.Board_commDAO"%>
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
	String pageNum = null;
	String mypageNum = null;
	int num = 0; 

	if(sId == null){%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
	<% }

	
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
		
		num = Integer.parseInt(mr.getParameter("num"));
		if(mr.getParameter("pageNum") != null) pageNum = mr.getParameter("pageNum");
		if(mr.getParameter("mypageNum") != null) mypageNum = mr.getParameter("mypageNum");
	
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		String type = mr.getParameter("type");

		Board_commDAO dao = new Board_commDAO();
		
		String img = dao.commImg(num);
		if(sysname == null)	{
			sysname = img;
		}else{
			File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);				
			f.delete();
		}	
		
		Board_commDTO article = new Board_commDTO();
		article.setNum(num);
		article.setSubject(subject);
		article.setContent(content);
		article.setType(type);
		article.setImg(sysname);
		
		int result = dao.modifyComm(article);
		
		if(result == 0){ %>
			<script type="text/javascript">
				alert("수정을 실패하였습니다. 다시 시도해 주세요.");
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
					<td>글이 수정되었습니다.<br/>
					<% if(pageNum != null){ %>
					<button onclick="window.location.href='board_commList.jsp'">리스트보기</button>
					<button onclick="window.location.href='board_commContent.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">수정글확인</button>
					<% } %>
					<% if(mypageNum != null){ %>
					<button onclick="window.location.href='mepetMyArticle.jsp'">리스트보기</button>
					<button onclick="window.location.href='board_commContent.jsp?num=<%=num%>&mypageNum=<%=mypageNum%>'">수정글확인</button>
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
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
 <% } %> 

</html>