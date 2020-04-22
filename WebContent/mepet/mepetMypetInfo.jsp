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
	#infoForm { width: 500px; }
</style>
<%
	//D:\hyunsu\heraProject\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\web\mepet\petImg
	
	
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
		<h3 style="color: #655f86;">나의 반려동물</h3>
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
					<h2 style="color: #655f86;">'<%=pet.getPetname() %>'</h2> 
					나이 &nbsp; : &nbsp; <%=pet.getPetage() %> 세<br/>  
					성별 &nbsp; : &nbsp; <%=pet.getPetsex() %> <br/>  
					<br/><br/>
					
					반려동물 종류 &nbsp; : &nbsp; <%=pet.getType() %> <br/>  
					품종 &nbsp; : &nbsp; <%=pet.getPettype() %> <br/>  
					크기 &nbsp; : &nbsp; <%=pet.getPetsize() %> <br/>  
					몸무게 &nbsp; : &nbsp; <%=pet.getPetweight() %> kg<br/>  
					중성화 유/무 &nbsp; : &nbsp; <%=pet.getPetneutral() %> <br/>  
					<br/><br/>
				</td>
			</tr>
		</table>
		<br/>
		<button  class="mepetButt" onclick="window.location.href='mepetMypetModify.jsp?petnum=<%=petnum%>'">수정</button> &nbsp; 
		<button  class="mepetButt" onclick="self.close()">닫기</button>
		<br/>
		<br/>	
	</body>
<% } %>
</html>