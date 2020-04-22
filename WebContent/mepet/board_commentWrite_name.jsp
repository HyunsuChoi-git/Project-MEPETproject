<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMepetHome.css" rel="stylesheet" type="text/css" />
<style>
	#list { width:400px; margin:0 auto; text-align: center; border: 1px; solid; #97a7b7;}
	.table2 { border: 2px solid #97a7b7; margin:0 auto; text-align: center; width : 430px; 
		border-radius: 5px; background-color: #eff1f4; }
	table { text-align: center; margin:0 auto; border: 1px; solid; #97a7b7; }
</style>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	//세션 버그 잡기 완료 (세션이 있는 경우에만, 쿠키검사필요X)
	String sId = (String)session.getAttribute("sId");
	
	if(sId == null){%>
		<script>
			alert("로그인 후 이용 가능한 페이지입니다.");
			window.location.href="loginForm.jsp";
		</script>
	<%}else{
		
		MepetsitterDAO dao = new MepetsitterDAO();
		
		//펫시터를 검색해서 넘어온 경우
		int count = 0;
		List petsitters = null;		
		String name = request.getParameter("name");
		if(name != null){ 
			count = dao.searchPersitterCount(name);
			petsitters = dao.searchPersitter(name);
		}
		//펫시터 전체검색해서 넘어온 경우
		String all = request.getParameter("all");
		if(all != null){
			count = dao.allPersitterCount();
			petsitters = dao.allPersitter();
		}
		
%>
<body>
		<form name="select" action="board_commentWrite_name.jsp" method="post">
			<h1 align="center" style="margin-bottom: 0; color: #3e6383;"><input type="submit" value="펫시터 전체보기" onclick="window.location.href='board_commentWrite_name.jsp?all=all'"/></h1>
			<div class="table2">
				<table class="list">
					<tr>
						<td>
							펫시터의 이름을 입력하세요. <br/><br/>
							<input class="text" type="text" name="name" />	
							<input class="listButt" type="submit" value="검색" />
							<br/>
								<table id="list" border="1">
									<tr>
										<td>사진</td>
										<td>이름</td>
										<td>지역</td>
										<td>폰번호</td>
										<td>선택</td>
									</tr>
									
							<% //펫시터를 검색했을 경우
							if(count > 0){
								for(int i = 0; i < petsitters.size(); i++){
									MepetsitterDTO petsitter = (MepetsitterDTO)petsitters.get(i);
								%>
									<tr>
										<td>
										<%--나중에 사진파일 합칠 때 수정하기 --%>
										<%if(petsitter.getImg() != null){%>
										<img src="sitterImg/<%= petsitter.getImg()%>" width="30"/>
										<%}else{%>
										<img src="sitterImg/empty.png" width="30"/>
										<%}%>
									</td>	
										<td><a><%=petsitter.getName() %></a></td>
										<td><%=petsitter.getArea() %></td>
										<td><%=petsitter.getPhon() %></td>
										<td><button class="listButt" onclick="opener.document.commentWrite.sitter_name.value='<%=petsitter.getName() %>';
										self.close()">선택</button></td>
										
									</tr>
								<% }%>
									</table>
							<% }else{%>
								<tr>
									<td colspan="5">펫시터가 존재하지 않습니다.</td>
								</tr>
							<%}%>
							</table>
							<br/>
						</td>
					</tr>
				</table>
			</div>
			<h1 align="center"><input class="listButt" type="button" value="닫기" onclick="closePop()" /></h1>
			<script>
			 	function closePop(){
			 		self.close();
		 		}
			</script>

		</form>
	</body>
	<%}%>
</html>