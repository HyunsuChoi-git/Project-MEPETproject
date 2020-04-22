<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="xMepetStyle.css" rel="stylesheet" type="text/css" />
<style>	
	input {	height:30px; }
	td { width:300px; color: #37486d; font-weight: bold; padding-top: 5px;}
	table { border-radius: 20px; }
</style>
<script>
	//유효성검사
	function check(){
		var signup = document.signup;
		var regExp = /\s/g;
		var idReg = /^[a-z0-9]{5,15}$/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ]{1,10}$/g;
		var phonReg = /^[0-9]*$/;
		if(!signup.id.value){
			alert("아이디를 입력하세요.");
			return false;
		}
		if(!idReg.test(signup.id.value) || regExp.test(signup.id.value)){
			alert("아이디는 6~16자 사이의 영문 소문자+숫자만 가능합니다.");
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
		if(!signup.nick.value || regExp.test(signup.nick.value)){
			alert("닉네임을 입력하세요.");
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
	
	//아이디 중복검사
	function idCheck(signup){
		if(signup.id.value == ""){
			alert("id를 입력하세요.");
			return;
		}
		var url = "meSignup_id.jsp?id="+signup.id.value;
		open(url, "ID 중복검사", "toolbar=no, status=no, menubar=no, scrollbars=no, resizalbe=no, width=430px, height==230px");
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
	//세션쿠키 검사 완료
	//비회원만 가능 
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId != null || cId != null){ %>
		<script>
			alert("이미 미펫 회원입니다.");
			window.location.href="meLoginPro.jsp";
		</script>
 <% }else{ %>
	<body>
		<h1>미펫 회원가입</h1>
	
		<form name="signup" action="meSignupPro.jsp" onsubmit="return check()" method="post">
			<table>
				<tr>
					<td>*아이디<br/>
						<input type="text" name="id" autofocus/>
						<input type="button" value="중복검사" onclick="idCheck(this.form)"/>
					</td>
				</tr>
				<tr>
					<td>*비밀번호<br/>
						<input type="password" name="pw" size="31"/></td>
				</tr>
				<tr>
					<td>*비밀번호 확인<br/>
						<input type="password" name="pw2" size="31"/></td>
				</tr>
				<tr>
					<td>*닉네임<br/>
						<input type="text" name="nick" />
						<input type="button" value="중복검사" onclick="nickCheck(this.form)"/>
					</td>
				</tr>
				<tr>
					<td>전화번호<br/>
						<input type="text" name="phon" size="31" placeholder="'-'를 제외한 숫자입력"/></td>
				</tr>
				<tr>
					<td>E-mail<br/>
						<input type="text" name="email" size="31"/></td>
				</tr>
				<tr>
					<td colspan="2">
						<br/>
						<input type="submit" value="가입하기" /> &nbsp; 
						<input type="button" value="뒤로가기" onclick="history.go(-1)"/>
					</td>
				</tr>
			</table>
		</form>
	
	</body>
 <% } %>
</html>