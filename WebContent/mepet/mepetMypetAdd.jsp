<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
<style>
	body { background-color: #f5f0f1; text-align: center;}
	tr { height:40px;}
	.text { height:20px;}
	.sel { height:30px; font-size: 15px;}
</style>
<script>
	//유효성검사
	function check(){
		var addpet = document.addpet;
		var regExp = /\s/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ]{1,10}$/g;
		var phonReg = /^[0-9]*$/;

		if(!addpet.type.value){
			alert("반려동물 종류를 입력하세요.");
			return false;
		}
		if(!addpet.pettype.value){
			alert("품종을 입력하세요.");
			return false;
		}
		if(!addpet.petname.value){
			alert("반려동물의 이름을 입력하세요.");
			return false;
		}
		if(!phonReg.test(addpet.petage.value)){
			alert("반려동물의 나이는 숫자만 가능합니다.");
			return false;
		}
		if(!phonReg.test(modifypet.petweight.value)){
			alert("반려동물의 몸무게는 숫자만 가능합니다.");
			return false;
		}
		
		
	}
</script>
</head>
<%
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
		<h3 style="color: #655f86;">새로운 반려동물</h3>
		<form name="addpet" action="mepetMypetAddPro.jsp" onsubmit="return check()" method="post" encType="multipart/form-data" >
			<input type="hidden" name="id" value="<%=sId %>" />
			<table id="infoForm" border="1">
				<tr height="50px">
					<td>*반려동물 종류</td>
					<td>
					<select class="sel" name="type">
						<option value="강아지" selected>강아지</option>
						<option value="고양이">고양이</option>
						<option value="햄스터">햄스터</option>
						<option value="고슴도치">고슴도치</option>
						<option value="포유류">포유류</option>
						<option value="조류">조류</option>
						<option value="어류">어류</option>
						<option value="파충류">파충류</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>*품종</td>
					<td><input class="text" type="text" name="pettype" size="10"/></td>
				</tr>
				<tr>
					<td>*이름</td>
					<td><input class="text" type="text" name="petname" size="12"/></td>
				</tr>
				<tr>
					<td>나이</td>
					<td><input class="text" type="text" name="petage" size="4"/>&nbsp;세</td>
				</tr>
				<tr>
					<td>성별</td>
					<td>
					<input type="radio" name="petsex" value="수컷" checked/>수컷
					<input type="radio" name="petsex" value="암컷"/>암컷
					</td>
				</tr>
				<tr>
					<td>크기</td>
					<td>
					<select class="sel" name="petsize">
						<option value="소형">소형</option>
						<option value="중형">중형</option>
						<option value="대형">대형</option>
					</select>
					</td>
				</tr>
				<tr>
					<td>몸무게</td>
					<td><input class="text" type="text" name="petweight" />&nbsp;kg</td>
				</tr>
				<tr>
					<td>중성화 유/무</td>
					<td>
					<input type="radio" name="petneutral" value="유" checked/>유
					<input type="radio" name="petneutral" value="무"/>무
					</td>
				</tr>
				<tr>
					<td>이미지</td>
					<td><input type="file" name="img" /></td>
				</tr>
			</table>
			<br/>
			<input class="mepetButt" type="submit" value="등록" /> &nbsp; 
			<input class="mepetButt" type="button" value="취소" />
		</form>
		<br/>
	

	</body>
<%  } %>
</html>









