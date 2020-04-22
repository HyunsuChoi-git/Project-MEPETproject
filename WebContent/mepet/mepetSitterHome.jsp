<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
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
%>
<body>
	<header>
		 <jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<br/>
		<a href="mepetSitterHome.jsp"><h3 align="center" style="margin-bottom: 0; color: #655f86;">'<%=sitter.getName() %>'님의</h3>
			<h1 align="center" style="margin-top: 0; color: #655f86;">펫시터 홈</h1></a>
		<br/>
		<div id="mysitter">
			<h3 style="color: #655f86;">나의 펫시터 활동</h3>
			<div class="sitterPoint">
				<br/>
				총 포인트
				<h1 class="point"><%=sitter.getPoint() %>점</h1>
			</div>
			<div class="sitterPoint">
				<br/>
				평점
				<h1 class="point"><%=sitter.getAvgpoint() %>점</h1>
			</div>
			<div class="sitterPoint">
				<br/>
				후기
				<h1 class="point"><%=sitter.getSittercount() %>개</h1>
			</div>
			<br/><br/>
			<%=sitter.getName() %>님의 고객 만족도는 <b>'
			<%if(sitter.getAvgpoint() >= 4 ){ %> 상 <% } 
			else if(sitter.getAvgpoint() >= 3 ){ %> 중 <% } 
			else if(sitter.getAvgpoint() >= 0 ){ %> 하 <% } %>
			'</b> 입니다.<br/><br/>
			<br/>
		</div>
		<div id="sitterpage">
			<button class="box_p" onclick="window.location.href='mepetSitterpage.jsp'">펫시터<br/>정보</button>
			<button class="box_p" onclick="window.location.href='mepetSitterArticle.jsp'">나의<br/>홍보글</button>
			<button class="box_p" onclick="window.location.href='mepetSitterComment.jsp'">나의<br/>후기</button>
		</div>
		<br/><br/><br/><br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
<% } %>
</html>