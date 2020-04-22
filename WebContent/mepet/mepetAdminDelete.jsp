<%@page import="web.mepet.model.Member_petDAO"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@page import="java.io.File"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
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
		if(!document.deleteMS.pw.value){
			alert("비밀번호를 입력하세요.");
			return false;
		}
	}
</script>
</head>
<%
	String admin = (String)session.getAttribute("admin");
	if(admin == null){ %>
		<script>
			alert("관리자 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{ 
 
 		String mepet = request.getParameter("mepet");
 		String id = request.getParameter("id");
 		String pw = null;
 		
 		if(request.getParameter("pw") != null){
	 		if(mepet.equals("member")){
	 			//멤버삭제(펫사진 삭제), 시터가입자면 시터삭제(펫사진삭제) 및 시터글 삭제
	 			pw = request.getParameter("pw");
				MepetmemberDAO dao = new MepetmemberDAO();
				int result = dao.adminMember(pw, id);
				 
				if(result == 1){
					//펫사진 삭제하기
					Member_petDAO petDAO = new Member_petDAO();
					List memberPets = petDAO.memberPets(id); //펫사진들 꺼내옴
					int res = petDAO.adminPets(id);
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
					boolean b = sitterDAO.sitterCheck(id);
					
					if(b){ //삭제
						String sitterImg = sitterDAO.sitterImg(id); //프로필사진 
						int re = sitterDAO.adminSitter(pw, id); //관리자용 삭제메소드
						
						if(re == 1){
							if(sitterImg != null){ //프로필 사진 삭제
								File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\sitterImg\\"+sitterImg);
								f.delete();
							} 
							//시터 글 삭제(사진삭제)
							Board_sitterDAO sitterA = new Board_sitterDAO();
							List imgs = sitterA.getBoardImg(id);  // 삭제할 사진 불러오기
	
							int r = sitterA.adminDelete(id); //글 전체삭제
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
	 			
	 		}else if(mepet.equals("sitter")){
	 			//시터삭제, 시터글 삭제
	 			MepetsitterDAO sitterDAO = new MepetsitterDAO();
				String sitterImg = sitterDAO.sitterImg(id); //프로필사진 
				int result = sitterDAO.adminSitter(pw, id); //관리자용 삭제메소드
				 
				if(result == 1){
					if(sitterImg != null){ //프로필 사진 삭제
						File f = new File("D:\\hyunsu\\heraProject\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\web\\mepet\\sitterImg\\"+sitterImg);
						f.delete();
					} 
					//시터 글 삭제(사진삭제)
					Board_sitterDAO sitterA = new Board_sitterDAO();
					List imgs = sitterA.getBoardImg(id);  // 삭제할 사진 불러오기

					int r = sitterA.adminDelete(id); //글 전체삭제
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
				}
					%>	 
				 	<script>
						alert("펫시터 해지가 완료되었습니다.");
						window.location.href="mepetAdminSitter.jsp";
					</script>
			 <% }else{ %>
					<script>
						alert("비밀번호가 일치하지 않습니다.");
						window.location.href="mepetSitterDelete.jsp";
					</script> 
			 <% }
	 		
 		}else{ %>
			<body>
				<form name="deleteMS" action="mepetAdminDelete.jsp" onsubmit="return check()" method="post">
					<% if(mepet.equals("member")) {%> 
					<input type="hidden" name="mepet" value="member"/>
					<% }else if(mepet.equals("sitter")){ %> 
					<input type="hidden" name="mepet" value="sitter"/>
					<% } %>
					<input type="hidden" name="id" value="<%=id%>"/>
					
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
			</body>
 	<% 	}
 } %>
</html>