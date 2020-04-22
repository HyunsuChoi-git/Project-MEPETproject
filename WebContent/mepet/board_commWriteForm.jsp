<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	#section { width:600px; height:400px; }
</style>
<script>
	function check(){
		var comm = document.commWrite;
		if(!comm.subject.value){
			alert("제목을 입력하세요.");
			return false;
		}
		if(!comm.content.value){
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
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(Cookie c : coo){
			if(c.getName().equals("cId")) cId = c.getValue();
		}		
	}
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
	}
	
	if(sId == null){ %>
		<script>
			alert("로그인 후 이용 가능합니다.");
			window.location.href="meLoginForm.jsp";
		</script>
 <% }else{
 	
	 //글쓴이 정보 가져오기
	 MepetmemberDAO dao = new MepetmemberDAO();
	 String nick = dao.getNick(sId);
	 
	 int num = 0, ref = 0, re_step = 0, re_level = 0;
 	//답글인 경우와 아닌경우로 나누기
	 if(request.getParameter("num") != null){
		num = Integer.parseInt(request.getParameter("num"));
		ref = Integer.parseInt(request.getParameter("ref"));
		re_step = Integer.parseInt(request.getParameter("re_step"));
		re_level = Integer.parseInt(request.getParameter("re_level"));
			
	}
 %>
	
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<h1 id="h1sub">
		 <% if(num != 0){ %>
			답글 작성하기
		 <% }else{ %>
		 	글 작성하기
		 <% } %>
			</h1>
			<br/>
				<div id="section">
				<form name="commWrite" onsubmit="return check()" action="board_commWritePro.jsp" method="post" encType="multipart/form-data">
					<input type="hidden" name="num" value="<%=num %>" />	
					<input type="hidden" name="ref" value="<%=ref %>" />	
					<input type="hidden" name="re_step" value="<%=re_step %>" />	
					<input type="hidden" name="re_level" value="<%=re_level %>" />	
					<input type="hidden" name="nick" value="<%=nick %>" />
					
					<table id="writeForm"> 
						<tr>
							<td align="left">종류 : </td>
							<td align="left">
							<select name="type">
								<option value="일반" selected>일반</option>
								<option value="추천">추천</option>
								<option value="거래">거래</option>
							</select>
							</td>
						</tr>
						<tr height="40px">
							<td align="left">제목 : </td>
							<td align="center">
							<input type="text" name="subject" size="60"/>
							</td>
						</tr>
						<tr height="80px">
							<td align="left" colspan="2" >내용 :</td>
						</tr>
						<tr>
							<td align="left" colspan="2">
							<input type="file" name="img" /><br/>
							<textarea name="content" rows="8" cols="70"></textarea>
							</td>
						</tr>
					</table>
					<h1>
						<input type="submit" value="등록하기" />
						<%String pageNum = "1";
						if(request.getParameter("pageNum") != null)	pageNum = request.getParameter("pageNum"); %>
						<input type="button" value="뒤로가기" onclick="window.location.href='board_commList.jsp?pageNum=<%=pageNum%>'"/>
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