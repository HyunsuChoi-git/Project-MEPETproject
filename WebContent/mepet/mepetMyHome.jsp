<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.Member_petDTO"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Member_petDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<script>
	function addpet(){
	
		var url = "mepetMypetAdd.jsp"
		open(url, "반려동물 등록하기", "toolbar=no, status=no, menubar=no, scrollbars=no, resizalbe=no, width=430px, height=530px");
	}
	
	function petInfo(){
		var url = "mepetMypetInfo.jsp";
		open(url, "나의 반려동물 정보", "toolbar=no, status=no, menubar=no, scrollbars=no, resizalbe=no, width=430px, height=530px,top=150px,left=300px");
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
<%	}else{ 
		MepetmemberDAO dao = new MepetmemberDAO();
		String nick = dao.getNick(sId);
%> 
	<body>
	
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<a href="mepetMyHome.jsp"><h3 align="center" style="margin-bottom: 0; color: #655f86;">'<%=nick %>'님의</h3>
			<h1 align="center" style="margin-top: 0; color: #655f86;">마이 미펫 홈</h1></a>
			<br/>
			<div id="mypet">
				<h3 style="color: #655f86;">나의 반려동물</h3>
			<%  
				Member_petDAO petDao = new Member_petDAO();
				List mypets = petDao.getPets(sId);
				Member_petDTO pet = null;
				
				if(mypets != null){
					for(int i = 0; i < mypets.size(); i++){
						pet = (Member_petDTO)mypets.get(i);
					%>
						<div class="pets">
							<a href="#" onclick="
								open('mepetMypetInfo.jsp?petnum=<%= pet.getPetnum()%>', '나의 반려동물 정보', 'toolbar=no, status=no, 
								menubar=no, scrollbars=no, resizalbe=no, width=600px, height=460px,top=150px,left=300px')"
							>
							<% if( pet.getImg() != null){ %> 
							<img class="petImg" src = "petImg/<%= pet.getImg()%>" width="150px" />
							<% }else{ %> 
							<img class="petImg" src = "petImg/ssss.jpg" width="150px" />
							<% } %>
						</a>	
						<br/><%=pet.getPetname() %>
						</div>
				 <% }
				} %>
				
				<br/><br/>
				총 <%= mypets.size()%> 마리와 함께하고 있습니다.<br/><br/>
				<button class="mepetButt" onclick="addpet()">새 가족 추가하기</button>
				<br/><br/>
			</div>
			
			<div id="mypage">
				<button class="box" onclick="window.location.href='mepetMypage.jsp'">내 정보</button>
				<button class="box" onclick="window.location.href='mepetMyArticle.jsp'">나의활동</button>
				<button class="box" onclick="window.location.href='mepetMysitter.jsp'">펫시터</button>
			</div>
			<br/><br/><br/><br/>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
<% } %>
</html>