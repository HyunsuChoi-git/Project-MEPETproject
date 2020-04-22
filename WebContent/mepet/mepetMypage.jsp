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
<style>
	td { border:1px solid #deced1; }
</style>
<script>
	//유효성검사
	function check(){
		var signup = document.signup;
		var regExp = /\s/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ]{1,10}$/g;
		var phonReg = /^[0-9]*$/;

		if(!signup.nick.value || regExp.test(signup.nick.value)){
			alert("닉네임을 입력하세요.");
			return false;
		}
		if(!signup.pw.value){
			alert("비밀번호를 입력하세요.");
			return false;
		}
		if(!pwReg.test(signup.pw.value) || regExp.test(signup.pw.value)){
			alert("비밀번호는 4~20자 사이의 영문 대소문자+숫자만 가능합니다.");
			return false;
		}
		if(signup.pw.value != signup.pw2.value){
			alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
			return false;
		}
		if(!nickReg.test(signup.nick.value)){
			alert("닉네임은 2~10자 사이의 한글만 가능합니다.");
			return false;
		}
		if(!phonReg.test(signup.phon.value)){
			alert("핸드폰 번호는 숫자만 가능합니다.");
			return false;
		}
		
	}
	
	//닉네임 중복검사
	function nickCheck(signup){
		if(signup.nick.value == ""){
			alert("닉네임을 입력하세요.");
			return;
		}
		var url = "meSignup_nick.jsp?nick="+signup.nick.value;
		open(url, "닉네임 중복검사", "toolbar=no, status=no, menubar=no, scrollbars=no, resizalbe=no, width=430px, height==230px");

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
			<div id="mypage">
				<button class="box" onclick="window.location.href='mepetMypage.jsp'">내 정보</button>
				<button class="box" onclick="window.location.href='mepetMyArticle.jsp'">나의활동</button>
				<button class="box" onclick="window.location.href='mepetMysitter.jsp'">펫시터</button>
			</div>
			<br/><br/>
			<table id="infoForm" border="1">
			<% 
			String mypage = request.getParameter("mypage");
			dao = new MepetmemberDAO();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			if(mypage == null){ 
				MepetmemberDTO member = dao.memberInfo(sId);
			%>	
					<tr>
						<td>
						아이디 &nbsp; : &nbsp; <%=member.getId() %><br/><br/>
						닉네임 &nbsp; : &nbsp; <%=member.getNick() %><br/><br/>
						핸드폰번호 &nbsp; : &nbsp; <%=member.getPhon() %><br/><br/>
						이메일 &nbsp; : &nbsp; <%=member.getEmail() %><br/><br/>
						가입일 &nbsp; : &nbsp; <%=sdf.format(member.getReg()) %>
						</td>
					</tr>	
					<tr>
						<td>
						<button class="mepetButt" onclick="window.location.href='mepetMypage.jsp?mypage=modify'">정보수정</button> &nbsp; 
						<button class="mepetButt" onclick="window.location.href='mepetDelete.jsp'">회원탈퇴</button>
						</td>
					</tr>
			<% }else if(mypage.equals("modify")){ 

					MepetmemberDTO member = dao.memberInfo(sId);
			%>		
					<form name="signup" action="mepetModifyPro.jsp" onsubmit="return check()" method="post">
						<input type="hidden" name="id" value="<%=sId%>"/>
						<tr>
							<td>
							<br/>
							아이디 &nbsp; : &nbsp; <%=sId %><br/><br/>
							*닉네임 &nbsp; : &nbsp; <input type="text" name="nick" size="8" value="<%=member.getNick() %>"/> &nbsp; 
							<button onclick="nickCheck(this.form)">중복체크</button>
							<br/><br/>
							*비밀번호 &nbsp; : &nbsp; <input type="password" name="pw" size="12" value="<%=member.getPw()%>"/><br/><br/>
							*비밀번호 확인&nbsp; : &nbsp; <input type="password" name="pw2" size="12" /><br/><br/>
							핸드폰번호 &nbsp; : &nbsp; <input type="text" name="phon" size="12" value="<%=member.getPhon()%>"/><br/><br/>
							이메일 &nbsp; : &nbsp; <input type="text" name="email" size="23" value="<%=member.getEmail()%>"/><br/><br/>
							가입일 &nbsp; : &nbsp; <%=sdf.format(member.getReg()) %>
							<br/><br/>
							</td>
						</tr>
						<tr>
							<td>
							<input class="mepetButt" type="submit" value="수정"> &nbsp; <input class="mepetButt" type="button" value="취소" onclick="window.location.href='mepetMypage.jsp'">
							</td>
						</tr>
					</form>
			<% } %>	
				</table>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
<% } %>
</html>