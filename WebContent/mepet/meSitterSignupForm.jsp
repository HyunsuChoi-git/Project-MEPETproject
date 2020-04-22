<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link href="xMepetStyle.css" rel="stylesheet" type="text/css" />
<style>	
	input {	height:30px; font-size: 16px; text-align: center;}
	td { width:300px; color: #37486d; font-weight: bold; padding-top: 5px;}
	table { border-radius: 20px; }
	p { font-size: 12px; margin-top:0; margin-bottom:0; margin:0 ; padding:0; padding-top:0; padding-bottom: 0;}
	.form { display: inline-block; margin: 10px; height:560px; }
	#forms { margin: 0 auto; width: 800px; text-align: center;}
	.but { background-color: #e5e5ff; color: #37486d; }
	select { font-size: 16px; height:25px; color: #77878F; border-radius: 3px; }
</style>
<script>
	//유효성검사
	function check(){
		var signup = document.signup;
		var regExp = /\s/g;
		var idReg = /^[a-z0-9]{5,15}$/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ0-9]{1,5}$/g;
		var phonReg = /^[0-9]*$/;
		
		if(!signup.name.value){
			alert("이름을 입력하세요.");
			return false;
		}
		if(!nickReg.test(signup.name.value) || regExp.test(signup.name.value)){
			alert("이름은 2~6자 사이의 한글, 중복이 있을 경우엔 실명+숫자 만 가능합니다.");
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
		if(!signup.area.value){
			alert("지역을 선택하세요.");
			return false;
		}
		if(!phonReg.test(signup.year.value)|| regExp.test(signup.year.value)){
			alert("'반려동물 키워본 경험'란은 숫자만 가능합니다.");
			return false;
		}
		
	}
	
	//이름 중복검사
	function nameCheck(signup){
		if(signup.name.value == ""){
			alert("실명을 입력하세요.");
			return;
		}
		var url = "meSitterSignup_name.jsp?name="+signup.name.value;
		open(url, "실명 중복검사", "toolbar=no, status=no, menubar=no, scrollbars=no, resizalbe=no, width=430px, height==230px");

	}
</script>
</head>
<% 
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
	if(sId == null) { %>
		<script>
			alert("먼저 로그인이 필요한 서비스입니다.");
			window.location.href="meLoginForm.jsp";
		</script>	
	<% }
	if(si_sId != null) { %>
		<script>
			alert("회원님은 이미 미펫의 펫시터입니다.");
			window.location.href="mepetMain.jsp";
		</script>		
<% 	}else{ 
	MepetmemberDAO dao = new MepetmemberDAO();
	MepetmemberDTO member = dao.memberInfo(sId);

%>
	<body>
		<h1>미펫 펫시터 가입</h1>
		<br/><br/><br/>
		<form name="signup" action="meSitterSignupPro.jsp" onsubmit="return check()" method="post" encType="multipart/form-data">
			<div id="forms">
				<table class="form" align="center">
					<tr>
						<td>
						<br/>
						<p>아래는 회원님의 기본 정보입니다.<br/>
						펫시터 가입을 위해 오른쪽 공란을 채워주세요.</p>
						</td>
					</tr>
					<tr>
						<td>아이디<br/>
							<input type="text" name="id" value="<%=member.getId() %>" readonly/>
						</td>
					</tr>
					<tr>
						<td>닉네임<br/>
							<input type="text" name="nick" value="<%=member.getNick() %>" readonly/>
						</td>
					</tr>
					<tr>
						<td>전화번호<br/>
							<input type="text" name="phon" size="31" value="<%=member.getPhon() %>" readonly/></td>
					</tr>
					<tr>
						<td>E-mail<br/>
							<input type="text" name="email" size="31" value="<%=member.getEmail() %>" readonly/>
							<br/><br/><br/>
						</td>
					</tr>
				</table>
				
				<table class="form" align="center">
					<tr>
						<td>*실명
						<p>(중복이 존재할 경우 실명+숫자로 조합하여 주십시오.)</p>
							<input type="text" name="name" />
							<input type="button" value="중복검사" onclick="nameCheck(this.form)"/>
						</td>
					</tr>
					<tr>
						<td>*비밀번호 <br/>
							<p>(펫시터 활동 시 사용할 비밀번호를 입력하세요.)</p>
							<input type="password" name="pw" size="31"/></td>
					</tr>
					<tr>
						<td>*비밀번호 확인<br/>
							<input type="password" name="pw2" size="31"/></td>
					</tr>
					<tr>
						<td>*지역<br/>
						<select name="area" >
							<option value = "경기도" selected>경기도</option>
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
						</td>
					</tr>
					<tr>
						<td>반려동물 키워본 경험<br/>
						<input type="text" name="year" size="31"/> 년</td>
					</tr>
					<tr>
						<td>프로필 사진<br/>
						<input type="file" name="img" size="31"/><br/></td>
					</tr>
				</table>
				<br/><br/>
				<input class="but" type="submit" value="가입하기" /> &nbsp; 
				<input class="but" type="button" value="뒤로가기" onclick="history.go(-1)"/>
			</div>	
		</form>
		<br/><br/><br/><br/><br/><br/>
	</body>
 <% } %>
</html>