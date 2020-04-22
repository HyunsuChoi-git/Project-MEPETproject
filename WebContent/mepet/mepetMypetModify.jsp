<%@page import="web.mepet.model.Member_petDTO"%>
<%@page import="web.mepet.model.Member_petDAO"%>
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
		var modifypet = document.modifypet;
		var regExp = /\s/g;
		var pwReg = /^[A-za-z0-9]{3,19}$/g;
		var nickReg = /^[가-힣ㄱ-ㅎㅏ-ㅣ]{1,10}$/g;
		var phonReg = /^[0-9]*$/;

		if(!modifypet.type.value){
			alert("반려동물 종류를 입력하세요.");
			return false;
		}
		if(!modifypet.pettype.value){
			alert("품종을 입력하세요.");
			return false;
		}
		if(!modifypet.petname.value){
			alert("반려동물의 이름을 입력하세요.");
			return false;
		}
		if(!modifypet.test(modifypet.petage.value)){
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
	if(sId == null || request.getParameter("petnum") ==null){ %>
		<script>
			alert("접근 오류.");
			window.location.href="mepetMain.jsp";
		</script>	
<%	}else{
		
		int petnum = Integer.parseInt(request.getParameter("petnum"));
		Member_petDAO dao = new Member_petDAO();
		Member_petDTO pet = dao.petInfo(petnum);
		
%>		
	<body>
		<h3 style="color: #655f86;">나의 반려동물 정보 수정하기</h3>
		<form name="modifypet" action="mepetMypetModifyPro.jsp" onsubmit="return check()" method="post" encType="multipart/form-data" >
			<input type="hidden" name="petnum" value="<%=petnum %>" />
			<table id="infoForm" border="1">
				<tr>
					<td>
				<%  if(pet.getImg() != null) { %>
					<img src="petImg/<%=pet.getImg() %>" width="180" />
				<%  }else { %>
				  	<img src="petImg/empty.png" width="180" />
				<%  }%>
					</td>	
					<td width="280">
						<br/>
						이름 &nbsp; : &nbsp; <input class="text" type="text" name="petname" value="<%=pet.getPetname() %>" size="12"/><br/>
						나이 &nbsp; : &nbsp; <input class="text" type="text" name="petage" size="4" value="<%=pet.getPetage() %>"/> 세<br/>  
						성별 &nbsp; : &nbsp; 
						<input type="radio" name="petsex" value="수컷" 
						<% if(pet.getPetsex().equals("수컷")){ %> checked <% } %>
						/>수컷
						<input type="radio" name="petsex" value="암컷"
						<% if(pet.getPetsex().equals("암컷")){ %> checked <% } %>
						/>암컷 <br/>  
						<br/><br/>
						
						반려동물 종류 &nbsp; : &nbsp; 
						<select class="sel" name="type">
							<option value="<%=pet.getType() %>" selected><%=pet.getType() %></option>
							<option value="강아지">강아지</option>
							<option value="고양이">고양이</option>
							<option value="햄스터">햄스터</option>
							<option value="고슴도치">고슴도치</option>
							<option value="포유류">포유류</option>
							<option value="조류">조류</option>
							<option value="어류">어류</option>
							<option value="파충류">파충류</option>
						</select>
						<br/>  
						품종 &nbsp; : &nbsp; <input class="text" type="text" name="pettype" size="10" value="<%=pet.getPettype() %>"/> <br/>  
						크기 &nbsp; : &nbsp; 
						<select class="sel" name="petsize">
							<option  value="<%=pet.getPetsize() %>"><%=pet.getPetsize() %></option>
							<option value="소형">소형</option>
							<option value="중형">중형</option>
							<option value="대형">대형</option>
						</select>
						<br/>  
						몸무게 &nbsp; : &nbsp; <input class="text" type="text" name="petweight" size="3" value="<%=pet.getPetweight() %>"/> kg<br/>  
						중성화 유/무 &nbsp; : &nbsp; 
						<input type="radio" name="petneutral" value="유" 
						<% if(pet.getPetneutral().equals("유")){ %> checked <% } %>
						/>유
						<input type="radio" name="petneutral" value="무"
						<% if(pet.getPetneutral().equals("무")){ %> checked <% } %>
						/>무
						<br/><br/>
						이미지  &nbsp; : &nbsp; <input type="file" name="img" /><br/>
						<br/>
					</td>
				</tr>
			</table>
			<br/>
			<input class="mepetButt" type="submit" value="수정하기"/> &nbsp; 
			<input class="mepetButt" type="button" value="삭제하기" onclick="window.location.href='mepetMypetDelete.jsp?petnum=<%=petnum%>'"/><br/><br/>
			<input class="mepetButt" type="button" value="뒤로가기" onclick="history.go(-1)"/>
			<br/>
		</form>	
	</body>
<%	} %>
</html>