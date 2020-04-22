<%@page import="java.io.File"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
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
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(int i = 0; i < coo.length; i++){
			if(coo[i].getName().equals("cId")) cId = coo[i].getValue();
		}
	}
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	boolean result = false;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		result = sitterDAO.sitterLogin(sId);
		if(result) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	//관리자 글 삭제
	String admin = (String)session.getAttribute("admin");
	if(admin != null) {
		num = Integer.parseInt(request.getParameter("num"));
		Board_sitterDAO dao = new Board_sitterDAO();
		String img = dao.getBoardImg(num);
		int r = dao.deleteArticle(num);
		if(r == 1) {
			if(img != null){
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
				f.delete();
			}
			response.sendRedirect("board_sitterList.jsp");
		}else{ %>
			<script>
				alert("삭제 실패.");
				window.location.href="board_sitterList.jsp";
			</script>		
	 <% }
	}
	
	if(si_sId == null && request.getParameter("num") == null) { %>
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
		
		Board_sitterDAO dao = new Board_sitterDAO();
		String img = dao.getBoardImg(num);
		int r = dao.deleteArticle(num);
		
		switch(r){
		case 1:
			//사진삭제, 메세지 띄우기
			if(img != null){
				File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
				f.delete();
			}
			if(pageNum != null) { %> 
				<script>
					alert("삭제가 완료되었습니다.");
					window.location.href="board_sitterList.jsp";
				</script>
			<% }else if(sitterpageNum != null) { %> 
				<script>
					alert("삭제가 완료되었습니다.");
					window.location.href="mepetSitterArticle.jsp";
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

	</body>

</html>