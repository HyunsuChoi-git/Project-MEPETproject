<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="java.io.File"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<script>
	function check(){
		if(!document.meDelete.pw.value){
			alert("비밀번호를 입력하세요.");
			return false;
		}
	}
</script>
<style>
	.mepetButt { border : 1px solid #b8bce9; }
	.sel { height:22px; font-size: 13px; margin-top:10px;}
</style>
</head>
<%
	
	//세션쿠키 로직
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	String cId = null;
	Cookie[] ck = null;
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	MepetsitterDTO sitter = null;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		sitter = sitterDAO.sitterInfo(cId);
		if(sitter.getId() != null) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	if(si_sId == null) { %>
		<script>
			alert("펫시터 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>		
<% 	}else{ %>
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
			<section>
				<br/>
				<a href="mepetSitterHome.jsp"><h3 align="center" style="margin-bottom: 0; color: #655f86;">'헤라'님의</h3>
				<h1 align="center" style="margin-top: 0; color: #655f86;">펫시터 홈</h1></a>
				<div id="sitterpage">
					<button class="box_p" onclick="window.location.href='mepetSitterpage.jsp'">펫시터<br/>정보</button>
					<button class="box_p" onclick="window.location.href='mepetSitterArticle.jsp'">나의<br/>홍보글</button>
					<button class="box_p" onclick="window.location.href='mepetSitterComment.jsp'">나의<br/>후기</button>
				</div>
				<br/><br/>
				
		 <% String pw = null; 
			if(request.getParameter("pw") == null){ 

			%>
				<form name="meDelete" action="mepetSitterDelete.jsp" onsubmit="return check()" method="post">
					<table id="si_infoForm" border="1">
						<tr>
							<td>
								펫시터 비밀번호를 입력하세요. <br/><br/>
								<input class="sel" type="password" name="pw" autofocus/>
								<br/><br/><br/>
								<input class="mepetButt" type="submit" value="펫시터 해지하기" /> &nbsp; 
								<input class="mepetButt" type="button" value="뒤로가기" onclick="window.location.href='mepetSitterpage.jsp'"/>
							</td>
						</tr>
					</table>
				</form>
		 <% }else if(request.getParameter("pw") != null){
			 //해지로직

			 pw = request.getParameter("pw");
			 String sitterImg = sitterDAO.sitterImg(si_sId);
			 int result = sitterDAO.deleteSitter(pw, si_sId);
			 
			 if(result == 1){
				 if(sitterImg != null){
					 File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\sitterImg\\"+sitterImg);
					 f.delete();
				 }
				//시터 글 삭제(사진삭제)
				Board_sitterDAO sitterA = new Board_sitterDAO();
				List imgs = sitterA.getBoardImg(si_sId);  // 삭제할 사진 불러오기

				int r = sitterA.adminDelete(si_sId); //글 전체삭제
				if(r == 1) {
					if(imgs != null){
						for(int i = 0; i < imgs.size(); i++){
							String img = (String)imgs.get(i);
							File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
							f.delete();
						}
					}
					response.sendRedirect("mepetMain.jsp");
				}else{ %>
					<script>
						alert("펫시터 글 삭제 실패.");
						history.go(-1);
					</script>		
			 <% }
				 %>	 
			 	<script>
					alert("펫시터 해지가 완료되었습니다.");
					window.location.href="mepetMain.jsp";
				</script>
		 <% }else{ %>
				<script>
					alert("비밀번호가 일치하지 않습니다.");
					window.location.href="mepetSitterDelete.jsp";
				</script> 
		 <% }
			 
			 
		   } %>
		 </section>
		 <footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>		
	</body>
<% } %>
</html>