<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style> 
	#section { width:600px; height:300px; }
	td {padding-bottom: 4px;}
</style>
<script>
	function check(){
		var comment = document.recommentWrite;
		if(!comment.subject.value){
			alert("제목을 입력하세요.");
			return false;
		}
		if(!comment.content.value){
			alert("내용을 입력하세요.");
			return false;
		}
	}
</script>
</head>
<% 
	//쿠키세션검사
	//비로그인 시 경고창 -> loginFrom.jsp로 보내기
	
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(Cookie c : coo){
			if(c.getName().equals("cId")) cId = c.getValue();
		}		
	}
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	boolean sitter = false;
	if(si_sId == null && cId != null){
		sitter = sitterDAO.sitterLogin(cId);
		if(sitter) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	//commentList에서 넘어온 데이터들 저장해놓기 (없으면 접근오류)
	int num = 0, ref = 0, re_step = 0;
	String sitter_name = null, nick = null;
	if(request.getParameter("num") != null || request.getParameter("ref") != null || request.getParameter("re_step") != null){
		num = Integer.parseInt(request.getParameter("num"));
		sitter_name = request.getParameter("sitter_name"); 
		nick = request.getParameter("nick"); 
		ref = Integer.parseInt(request.getParameter("ref")); 
		re_step = Integer.parseInt(request.getParameter("re_step")); 
	}else{%>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>
	<%}
	
	//세션쿠키검사 완료
	if(si_sId == null){%>
		<script>
			alert("로그인 후 이용 가능한 페이지입니다.");
			window.location.href="meLoginForm.jsp";
		</script>
	<%}else{ %>
		<body>
			<header>
				 <jsp:include page="mepetHeader.jsp" flush="false"/>
			</header>
			<section>
				<br/>
				<h1 id="h1sub">후기 답글 쓰기</h1>
				<br/>
				<div id="section">
					<form name="recommentWrite" onsubmit="return check()" action="board_commentRWritePro.jsp" method="post" encType="multipart/form-data">	
						<input type="hidden" name="ref" value="<%=ref%>"/>
						<input type="hidden" name="re_step" value="<%=re_step%>"/>
						<input type="hidden" name="sitter_name" value="<%=sitter_name%>"/>
						<input type="hidden" name="nick" value="<%=nick%>"/>
						
						<table id="writeForm">
							<tr height="30px">
								<td>제목</td>
								<td align="left"><input type="text" name="subject" size="60"/></td>
							</tr>
							<tr height="30px">
								<td>내용</td>
								<td align="left">
								<br/>
								<input type="file" name="img" /><br/>
								<textarea name="content" rows="8" cols="70"></textarea>
								</td>
							</tr>
						</table>
						<h1>
							<input type="submit" value="등록하기" /> &nbsp; 
							<input type="button" value="뒤로가기" onclick="history.go(-1)"/>
						</h1>
					</form>
				</div>
			</section>		
			<footer>
				<jsp:include page="mepetFooter.jsp" flush="false"/>
			</footer>
		</body>
	<%}%>
</html>