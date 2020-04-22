<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="java.sql.Timestamp"%>
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
	//세션 쿠키 검사 완료
	
	request.setCharacterEncoding("UTF-8");
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(int i = 0; i < coo.length; i++){
			if(coo[i].getName().equals("cId")) cId = coo[i].getValue();
		}
	}
	MepetsitterDAO sitterDAO = null;
	boolean sitter = false;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitterDAO = new MepetsitterDAO();
		sitter = sitterDAO.sitterLogin(cId);
		if(sitter) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	if(sId == null || si_sId == null){ %>
	<script>
		alert("접근 오류.");
		window.location.href="meLoginPro.jsp";
	</script>
<% }
	
	
	//2.
	String path = request.getRealPath("mepet/boardImg");
	//D:\hyunsu\heraProject\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\web\mepet\boardImg
	//3.
	int max = 1024*1024*5;
	//4.
	String enc = "UTF-8";
	//5.
	DefaultFileRenamePolicy dp = new DefaultFileRenamePolicy();
	
	MultipartRequest mr = null;
	
	try {
		mr = new MultipartRequest(request, path, max, enc, dp);
	
		//사진이미지 맞는지 아닌지 검사
		String sysName = mr.getFilesystemName("img");
		String contentType = mr.getContentType("img");
		if(sysName != null){
			String[] ct = contentType.split("/");
			if(!ct[0].equals("image")){
				File f = new File("sysName");
				f.delete(); %>
				<script>
					alert("이미지 파일이 아닙니다. 다시 업로드해주세요.");
					history.go(-1);
				</script>	
		 <%	}
		}
		
		String id = sId;
		String subject = mr.getParameter("subject");
		String content = mr.getParameter("content");
		String ip = request.getRemoteAddr();
		String name = mr.getParameter("name");
		String area = mr.getParameter("area");
		double avgpoint = 0;
		if(mr.getParameter("avgpoint") != null){
			avgpoint = Double.parseDouble(mr.getParameter("avgpoint"));
		}
		
		Board_sitterDTO article = new Board_sitterDTO();
		article.setId(id);
		article.setName(name);
		article.setSubject(subject);
		article.setContent(content);
		article.setImg(sysName);
		article.setIp(ip);
		article.setArea(area);
		article.setAvgpoint(avgpoint);
		article.setReg(new Timestamp(System.currentTimeMillis()));
		
		Board_sitterDAO dao = new Board_sitterDAO();
		int num = dao.insetArticle(article);
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
							<td>
							글 등록이 완료되었습니다. <br/>
							<button onclick="window.location.href='board_sitterContent.jsp?num=<%=num%>&pageNum=1'">작성글 확인</button>
							<button onclick="window.location.href='board_sitterList.jsp'">리스트</button>
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
			window.location.href="meLoginPro.jsp";
		</script>
 <% } %>

</html>