<%@page import="web.mepet.model.MepetmemberDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
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
	.sitterTable2 { border: 2px solid #97a7b7; margin:0 auto; text-align: center; width:650px;
			border-radius: 5px; background-color: #eff1f4; }
</style>
</head>
<%
	request.setCharacterEncoding("UTF-8");
	String admin = (String)session.getAttribute("admin");
	if(admin == null){ %>
		<script>
			alert("관리자 전용 페이지입니다.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{ 
 		
	 	String pageNum = "1";
	 	if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
	 	
	 	int amount = 20;
	 	int currentPage = Integer.parseInt(pageNum);
	 	int startRow = (currentPage-1)*amount+1;
	 	int endRow = currentPage*amount;
		int count = 0;
		int number = 0;
		
		String sel = null;
		String select = null;
		if(request.getParameter("sel") != null) sel = request.getParameter("sel");
		if(request.getParameter("select") != null) select = request.getParameter("select");
		
		SimpleDateFormat sdf = new SimpleDateFormat("yy-MM-dd");
		MepetmemberDAO dao = new MepetmemberDAO();
 		
 		
 		List members = null; 
		if( sel !=null && select !=null){
			count = dao.selectMemberCount(sel, select);
		 	if(count > 0) {
 				members = dao.selectMemberList(startRow, endRow, sel, select);
		 	}
		}else{
	 		count = dao.memberCount();
	 		if(count > 0) {
				members = dao.memberList(startRow, endRow);
 			}
 		}
 		number = count;
 
 %>
<body>
	<header>
		<jsp:include page="mepetAdminHome.jsp" flush="false"/>
	</header>
	<section>
		<br/><br/>
		<div id="button" align="center">
			<form action="mepetAdminMember.jsp" method="post">
				<select id="sel" name="sel">
					<option value="id">아이디</option>
					<option value="nick">닉네임</option>
				</select>
				<input type="text" class="text" name="select"/>
				<input type="submit" value="검색" id ="search"/>
			</form>
		</div>
		<br/>
		<div class="sitterTable2">
				<table id="list">
					<tr>
						<td>No.</td>
						<td>아이디</td>
						<td>닉네임</td>
						<td>연락처</td>
						<td>이메일</td>
						<td>가입날짜</td>
						<td>수정/탈퇴</td>
					</tr>
					<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				<% if(members == null){ %> 
						<tr>
							<td colspan="7">회원이 존재하지 않습니다.</td>
						</tr>
				<% }else{
					  MepetmemberDTO member = null;	
					  for(int i = 0; i < members.size(); i++){
						  member = new MepetmemberDTO();
						  member = (MepetmemberDTO)members.get(i); %>

							<tr>	
								<td><%=number-- %></td>
								<td><%=member.getId() %></td>
								<td><%=member.getNick() %></td>
								<td><%=member.getPhon() %></td>
								<td><%=member.getEmail() %></td>
								<td><%=sdf.format(member.getReg()) %></td>
								<td>
									<button onclick="window.location.href='mepetAdminModify.jsp?mepet=member&id=<%=member.getId() %>'">수정</button>
									<button onclick="window.location.href='mepetAdminDelete.jsp?mepet=member&id=<%=member.getId() %>'">탈퇴</button>
								</td>
							</tr>
					
				<%    } 
			   	   } %>
				</table>	
			</div>	
			
					<br/>
		<br/>
		<div class="view" align="center">
		<%//페이지뷰어 만들기
			if(count > 0){
				//1. 총 몇페이지 나오는지 계산
				int pageCount = count/amount + (count%amount == 0 ? 0 : 1);
				//2. 보여줄 페이지번호의 갯수
				int pageBlock = 5;
				//3. 현재 위치한 페이지에서 페이지 뷰어 첫번째 숫자가 무엇인지 찾기.
				int startPage = 0;
					if(currentPage % pageBlock == 0){
						startPage = (int)((currentPage-1)/pageBlock)*pageBlock+1;
					}else{
						startPage = (int)(currentPage/pageBlock)*pageBlock+1;
					}
				//4. 마지막에 보여지는 페이지뷰어에 페이지 갯수가 10 미만일 때. 마지막 페이지 번호가 endPage가 되도록.
				int endPage = startPage + pageBlock - 1;
				if(endPage > pageCount) endPage = pageCount;
				//6. startPage가 pageBlock보다 크면 '<'
				if(startPage > pageBlock){%>
				<a class="view" href="mepetAdminMember.jsp?pageNum=<%=startPage-1%>"> &lt; </a>
				<%}
				//5. 페이지 반복해서 뿌려주기
				for(int i = startPage; i <= endPage; i++){%>
				<a class="view" href="mepetAdminMember.jsp?pageNum=<%=i%>"> &nbsp; <%=i%> &nbsp; </a>
				<%}
				//7. endPage가 pageCount보다 작으면 '>'
				if(endPage < pageCount){%>
				<a class="view" href="mepetAdminMember.jsp?pageNum=<%=endPage+1%>"> &gt; </a>
				<%}
			}%>
		</div>
		<br/><br/><br/><br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
 <% } %>
</html>