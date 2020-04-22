<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

</head>
<%
	int num = 0;
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(int i = 0; i < coo.length; i++){
			if(coo[i].getName().equals("cId")) cId = coo[i].getValue();
		}
	}
	if(si_sId == null && cId != null){
		session.setAttribute("si_sId", cId);
		si_sId = cId;
	}
	String admin = (String)session.getAttribute("admin");
	//관리자 글삭제
	if(admin != null) {
		num = Integer.parseInt(request.getParameter("num"));
		Board_commentDAO dao = new Board_commentDAO();
		String img = dao.commentImg(num);
		int r = dao.deleteArticle(num);
		if(r == 1) {
			if(img != null){
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
				f.delete();
			}
			response.sendRedirect("board_commentList.jsp");
		}else{ %>
			<script>
				alert("삭제 실패.");
				window.location.href="board_commentList.jsp";
			</script>		
	 <% }
	}
	
	if(si_sId == null || request.getParameter("num") == null) { %>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>		
 <% }else{
		num = Integer.parseInt(request.getParameter("num"));
		String pageNum = null;
		String sitterpageNum = null;
		if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
		if(request.getParameter("sitterpageNum") != null) sitterpageNum = request.getParameter("sitterpageNum");
		
		Board_commentDAO dao = new Board_commentDAO();
		String img = dao.commentImg(num);
		int r = dao.deleteArticle(num);
		
		switch(r){
		case 1:
			//사진삭제, 메세지 띄우기
			if(img != null){
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
				f.delete();
			}
			if(pageNum != null){ %>
				<script>
					alert("삭제가 완료되었습니다.");
					window.location.href="board_commentList.jsp";
				</script>
			<% }else if(sitterpageNum != null){ %>
				<script>
					alert("삭제가 완료되었습니다.");
					window.location.href="mepetSitterComment.jsp";
				</script>
			<% }
			break;
		case 0: %>
			<script>
				alert("시스템 오류. 다시시도하세요.");
				history.go(-1);
			</script>	
	<% 	}
	 }
%>
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>

		</section>	
	</body>

</html>