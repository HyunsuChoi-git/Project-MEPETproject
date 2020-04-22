<%@page import="java.text.SimpleDateFormat"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.MepetmemberDTO"%>
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
<style>
	#img { border: 1px solid #b8bce9; border-radius: 40px; margin: 0 auto; text-align: center; 
		width: 150px; padding:20px;}
	.mepetButt { border : 1px solid #b8bce9; }
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
<% 	}else{
	sitter = sitterDAO.sitterInfo(si_sId);
	MepetmemberDAO dao = new MepetmemberDAO();
	MepetmemberDTO member = dao.memberInfo(si_sId);
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
%>
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
			<div id="img">
			<%if(sitter.getImg() != null) { %> 
				<img src="sitterImg/<%=sitter.getImg() %>" width="150px" style="border-radius: 60px;"/>
			<% }else{ %> 
				<img src="sitterImg/empty.png" width="150px" style="border-radius: 60px;"/>
			<% } %>
			</div>
			<br/><br/>
			<table id="si_infoForm" border="1">
				<tr>
					<td>
					<br/>
					아이디 &nbsp; : &nbsp; <%=member.getId() %><br/><br/>
					이름 &nbsp; : &nbsp; <%=sitter.getName() %><br/><br/>
					지역 &nbsp; : &nbsp; <%=sitter.getArea() %><br/><br/>
					반려동물 경험 &nbsp; : &nbsp; <%=sitter.getYear() %><br/><br/>
					핸드폰번호 &nbsp; : &nbsp; <%=member.getPhon() %><br/><br/>
					이메일 &nbsp; : &nbsp; <%=member.getEmail() %><br/><br/>
					가입일 &nbsp; : &nbsp; <%=sdf.format(sitter.getReg()) %>
					<br/><br/>
					</td>
				</tr>
				<tr>
					<td>
					<br/>
					<button class="mepetButt" onclick="window.location.href='mepetSitterModify.jsp'">펫시터 정보수정</button> &nbsp; 
					<button class="mepetButt" onclick="window.location.href='mepetSitterDelete.jsp'">펫시터 해지</button>
					<br/><br/>
					</td>
				</tr>
			</table>
			<br/><br/><br/><br/><br/><br/>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>		
	</body>
<% } %>
</html>