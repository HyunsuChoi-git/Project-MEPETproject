<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="java.io.File"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Member_petDAO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<style>
	.sel { height:22px; font-size: 13px; margin-top:10px; }
</style>
<script>
	function check(){
		if(!document.meDelete.pw.value){
			alert("비밀번호를 입력하세요.");
			return false;
		}
	}
</script>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//쿠키 세션 검사
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId == null && cId != null){
		Cookie c = new Cookie("cId", cId);
		c.setMaxAge(60*60*24);
		response.addCookie(c);
		
		session.setAttribute("sId", cId);
		sId = cId;
	} 
	
	if(sId == null){ %>
		<script>
			alert("로그인 후 사용 가능한 페이지입니다.");
			window.location.href="meLoginForm.jsp";
		</script>	
<%	}else{ %> 
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<h3 align="center" style="margin-bottom: 0; color: #655f86;">'헤라'님의</h3>
			<h1 align="center" style="margin-top: 0; color: #655f86;">마이 미펫 홈</h1>
			<div id="mypage">
				<button class="box" onclick="window.location.href='mepetMypage.jsp'">내 정보</button>
				<button div class="box" onclick="window.location.href='mepetMyArticle.jsp'">내가쓴글</button>
				<button div class="box" onclick="window.location.href='mepetMysitter.jsp'">펫시터</button>
			</div>
			<br/><br/>
		 <% String pw = null; 
			if(request.getParameter("pw") == null){ %>
				<form name="meDelete" action="mepetDelete.jsp" onsubmit="return check()" method="post">
					<table id="infoForm" border="1">
						<tr>
							<td>
								비밀번호를 입력하세요. <br/><br/>
								<input class="sel" type="password" name="pw" autofocus/>
								<br/><br/><br/>
								<input type="submit" value="탈퇴하기" /> &nbsp; 
								<input type="button" value="뒤로가기" onclick="window.location.href='mepetMypage.jsp'"/>
							</td>
						</tr>
					</table>
				</form>
		 <% }else if(request.getParameter("pw") != null){
			 //탈퇴로직
			 pw = request.getParameter("pw");
			 MepetmemberDAO dao = new MepetmemberDAO();
			 int result = dao.deleteMember(pw, sId);
			 
			 if(result == 1){
				//펫사진 삭제하기
					Member_petDAO petDAO = new Member_petDAO();
					List memberPets = petDAO.memberPets(sId); //펫사진들 꺼내옴
					int res = petDAO.adminPets(sId);
					if(res > 0){
						if(memberPets != null){
							for(int i = 0; i < memberPets.size(); i++){
								String img = (String)memberPets.get(i);
								File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\petImg\\"+img);
								f.delete();
							}
						}
					}
					
					//시터가입자 확인하기
					MepetsitterDAO sitterDAO = new MepetsitterDAO();
					boolean b = sitterDAO.sitterCheck(sId);
					
					if(b){ //삭제
						String sitterImg = sitterDAO.sitterImg(sId); //프로필사진 
						int re = sitterDAO.adminSitter(pw, sId); //관리자용 삭제메소드
						
						if(re == 1){
							if(sitterImg != null){ //프로필 사진 삭제
								File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\sitterImg\\"+sitterImg);
								f.delete();
							} 
							//시터 글 삭제(사진삭제)
							Board_sitterDAO sitterA = new Board_sitterDAO();
							List imgs = sitterA.getBoardImg(sId);  // 삭제할 사진 불러오기
	
							int r = sitterA.adminDelete(sId); //글 전체삭제
							if(r == 1) {
								if(imgs != null){
									for(int i = 0; i < imgs.size(); i++){
										String img = (String)imgs.get(i);
										File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\boardImg\\"+img);
										f.delete();
									}
								}
								response.sendRedirect("mepetAdminSitter.jsp");
							}else{ %>
								<script>
									alert("펫시터 글 삭제 실패.");
									window.location.href="mepetAdminSitter.jsp";
								</script>		
						 <% }
						} %>	 
						 	<script>
								alert("펫시터 해지가 완료되었습니다.");
								window.location.href="mepetAdminSitter.jsp";
							</script>
					 <% } %>	 
				  %>	 
			 	<script>
					alert("회원 탈퇴가 완료되었습니다.");
					window.location.href="mepetMain.jsp";
				</script>
		 <% }else{ %>
				<script>
					alert("비밀번호가 일치하지 않습니다.");
					window.location.href="mepetDelete.jsp";
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