<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<style>
	#img { border: 1px solid #b8bce9; border-radius: 40px; margin: 0 auto; text-align: center; 
		width: 150px; padding:20px;}
	.mepetButt { border : 1px solid #b8bce9; }	
</style>
<script>
	//유효성검사
	function checkSi(){
		var sitter = document.sitter;
		var regExp = /\s/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ]{1,10}$/g;
		var phonReg = /^[0-9]+$/;

		if(!sitter.name.value || regExp.test(sitter.name.value)){
			alert("이름을 입력하세요.");
			return false;
		}
		if(!sitter.pw.value){
			alert("비밀번호를 입력하세요.");
			return false;
		}
		if(!pwReg.test(sitter.pw.value) || regExp.test(sitter.id.value)){
			alert("비밀번호는 4~20자 사이의 영문 대소문자+숫자만 가능합니다.");
			return false;
		}
		if(sitter.pw.value != sitter.pw2.value){
			alert("비밀번호와 비밀번호확인이 일치하지 않습니다.");
			return false;
		}
		if(!nickReg.test(sitter.name.value)){
			alert("이름은 2~10자 사이의 한글만 가능합니다.");
			return false;
		}
		if(!sitter.area.value){
			alert("지역을 입력하세요.");
			return false;
		}
		if(!sitter.year.value){
			alert("반려동물 키워본 기간을 입력하세요.");
			return false;
		}
		if(!phonReg.test(sitter.year.value)){
			alert("반려동물 키워본 기간은 숫자만 가능합니다.");
			return false;
		}
	}
	
	//유효성검사
	function checkMe(){
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
	String admin = (String)session.getAttribute("admin");
	if(admin == null){ %>
		<script>
			alert("관리자 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{ 
 
 		String mepet = request.getParameter("mepet");
 		String id = request.getParameter("id");
 		
 		if(mepet == null || id == null){ %>
 			<script>
 				alert("접근오류");
 				window.location.href="mepetMain";
 			</script>	
 	<% 	}
		
 		MepetmemberDAO me = null;
 		MepetsitterDAO si = null;
 		
%>
		<body>
			<header>
				<jsp:include page="mepetAdminHome.jsp" flush="false"/>
			</header>
			<section>
			<br/><br/>
			
 	<%	if(mepet.equals("member")){
 			me = new MepetmemberDAO();
 			MepetmemberDTO member = me.memberInfo(id);
 	%>
 		<br/>
 		<h3 align="center" style="margin-top: 0; color: #655f86;">회원 정보 수정</h3>
 	 	<table id="infoForm" border="1">
 	 		<form name="signup" action="mepetAdminModifyPro.jsp" onsubmit="return checkMe()" method="post" encType="multipart/form-data">
				<input type="hidden" name="mepet" value="member"/>
				<input type="hidden" name="id" value="<%=member.getId()%>"/>
					<tr>
						<td>
						<br/>
						아이디 &nbsp; : &nbsp; <%=member.getId()%><br/><br/>
						*닉네임 &nbsp; : &nbsp; <input type="text" name="nick" size="8" value="<%=member.getNick() %>"/> &nbsp; 
						<button onclick="nickCheck(this.form)">중복체크</button>
						<br/><br/>
						*비밀번호 &nbsp; : &nbsp; <input type="password" name="pw" size="12" value="<%=member.getPw()%>"/><br/><br/>
						*비밀번호 확인&nbsp; : &nbsp; <input type="password" name="pw2" size="12" value="<%=member.getPw()%>"/><br/><br/>
						핸드폰번호 &nbsp; : &nbsp; <input type="text" name="phon" size="12" value="<%=member.getPhon()%>"/><br/><br/>
						이메일 &nbsp; : &nbsp; <input type="text" name="email" size="23" value="<%=member.getEmail()%>"/><br/><br/>
						<br/><br/>
						</td>
					</tr>
					<tr>
						<td>
						<input class="mepetButt" type="submit" value="수정"> &nbsp; <input class="mepetButt" type="button" value="취소" onclick="history.go(-1)">
						</td>
					</tr>
			</form>
 	 	</table>
 	 	
 	 		
 	<% 	}else if(mepet.equals("sitter")){
 			si = new MepetsitterDAO();
 			MepetsitterDTO sitter = si.sitterInfo(id);
 	%>
			<br/>
 			<h3 align="center" style="margin-top: 0; color: #655f86;">펫시터 정보 수정</h3>
 			<div id="img">
			<% if(sitter.getImg() != null){ %> 
				<img src="sitterImg/<%=sitter.getImg() %>" width="150px" style="border-radius: 60px;"/>
			<% }else{ %>
				<img src="sitterImg/empty.png" width="150px" style="border-radius: 60px;"/>
			<% } %>
			</div>
			<br/>
			<table id="si_infoForm" border="1">
				<form name="sitter" action="mepetAdminModifyPro.jsp" onsubmit="return checkSi()" method="post" encType="multipart/form-data">
					<input type="hidden" name="mepet" value="sitter"/>
					<input type="hidden" name="id" value="<%=sitter.getId() %>"/>
					
					<tr>
						<td>
						<br/>
						프로필 사진 &nbsp; : &nbsp; <input class="mepetButt" type="file" name="img" /><br/><br/>
						아이디 &nbsp; : &nbsp; <%=sitter.getId() %><br/><br/>
						*이름 &nbsp; : &nbsp; <input type="text" name="name" size="8" value="<%=sitter.getName()%>"/> &nbsp; 
						<br/><br/>
						*비밀번호 &nbsp; : &nbsp; <input type="password" name="pw" size="12" value="<%=sitter.getPw() %>"/><br/><br/>
						*비밀번호 확인 &nbsp; : &nbsp; <input type="password" name="pw2" size="12" value="<%=sitter.getPw() %>"/><br/><br/>
						지역 &nbsp; : &nbsp; 
							<select name="area" >
								<<option value = "<%=sitter.getArea() %>" selected><%=sitter.getArea() %></option>
								<option value = "경기도">경기도</option>
			                    <option value = "강원도">강원도</option>
			                    <option value = "경상북도">경상북도</option>
			                    <option value = "경상남도">경상남도</option>
			                    <option value = "충청북도">충청북도</option>
			                    <option value = "충청남도">충청남도</option>
			                    <option value = "전라북도">전라북도</option>
			                    <option value = "전라남도">전라남도</option>
			                    <option value = "제주도">제주도</option>
			                    <option value = "서울특별시">서울</option>
			                    <option value = "인천광역시">인천</option>
			                    <option value = "대전광역시">대전</option>
			                    <option value = "세종특별시">세종</option>
			                    <option value = "광주광역시">광주</option>
			                    <option value = "대구광역시">대구</option>
			                    <option value = "부산광역시">부산</option>
			                    <option value = "울산광역시">울산</option>						
							</select> 
						<br/><br/>
						반려동물 경험 &nbsp; : &nbsp; <input type="text" name="year" size="4" value="<%=sitter.getYear()%>"/>년<br/><br/> 
						<br/>
						</td>
					</tr>
					<tr>
						<td>
						<br/>
						<input class="mepetButt" type="submit" value="수정"> &nbsp; <input class="mepetButt" type="button" value="취소" onclick="history.go(-1)">
						<br/><br/>
						</td>
					</tr>
				</form>
			</table>	
 	<%  } %>
			<br/><br/><br/><br/><br/><br/>
			</section>
			<footer>
				<jsp:include page="mepetFooter.jsp" flush="false"/>
			</footer>
		</body>
<% } %>
</html>