<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@page import="web.mepet.model.Board_sitterDTO"%>
<%@page import="web.mepet.model.Board_sitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	 td{ margin:5px; border-top: 1px solid #77878F; }
</style>
</head>
<body>
	<header>
		 <jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
<%
	//세션 쿠키 검사 
	//로그인 후 읽을 수 있는 페이지.
	String sId = (String)session.getAttribute("sId");
	String si_sId = (String)session.getAttribute("si_sId");
	
	String cId = null;
	Cookie[] coo = request.getCookies();
	if(coo != null){
		for(int i = 0; i < coo.length; i++){
			if(coo[i].getName().equals("cId")) cId = coo[i].getValue();
		}
	}
	
	MepetsitterDAO sitterDAO = new MepetsitterDAO();
	boolean result = false;
	if(sId == null && cId != null){
		session.setAttribute("sId", cId);
		sId = cId;
		
		result = sitterDAO.sitterLogin(sId);
		if(result) {
			session.setAttribute("si_sId", cId);
			si_sId = cId;
		}
	}
	
	if(sId == null){ %>
		<script>
			alert("로그인 후 이용 가능한 페이지입니다.");
			window.location.href="board_sitterList.jsp";
		</script>		
 <% }else{
	
//////////////////////////////
		String pageNum = null;
		String sitterpageNum = null;
		
		int num = 0;
		if(request.getParameter("num") == null){ %>
			<script>
				alert("접근오류.");
				window.location.href="mepetMain.jsp";
			</script>		
   	 <% }else{
			num = Integer.parseInt(request.getParameter("num"));
			if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
			if(request.getParameter("sitterpageNum") != null) sitterpageNum = request.getParameter("sitterpageNum");
					
			Board_sitterDAO dao = new Board_sitterDAO();
			Board_sitterDTO article = dao.getContent(num);
			System.out.println(num);
			
			MepetsitterDTO sitter = sitterDAO.sitterInfo(article.getId());
		%>
			<section>
				<h1 id="h1sub">펫시터 예약하기</h1>
				<br/>
				<div id="section">
					<table id="writeForm">
						<tr>
							<td colspan="2">
							<br/>
							<img src="sitterImg/<%=sitter.getImg()%>" width="150"/><br/>
							<h3>'<%=article.getName() %>'</h3>
							*지역 : <%=sitter.getArea() %>  &nbsp; *전화번호 : <%=sitter.getPhon() %>
						</tr>
						<tr>
							<td colspan="2">
							<h2><%=article.getSubject() %></h2></td>
							</td>
						</tr>
						<tr>
							<td>
								*펫시터 경력 : <%=sitter.getSittercount() %>회  &nbsp; 
								*반려견 경험 : <%=sitter.getYear() %>년  &nbsp;   	
								*평점 : <%=sitter.getAvgpoint() %>점
								
							</td>
								
						</tr>
						<tr>
							<td colspan="2" width="400">
								소개
								<table>
									<tr>
										<td width="400" height="200">
											<%  if(article.getImg() != null){ %>
											<img src="boardImg/<%=article.getImg()%>" width="400"/> <br/>
											<%  } %>
											<%=article.getContent() %> <br/>
										</td>
									</tr>
								</table>		
								<br/>	
								<a href="board_commentList.jsp?sel=sitter_name&search=<%=sitter.getName()%>">[ 후기보러가기 ]</a>
							</td>
						</tr>
						<% //사용자의 글이면 수정하기 삭제하기 버튼 띄우기
							//세션 아이디와, 글의 아이디가 일치하면 됨			
							if(article.getId().equals(sId)){
						%>
						<tr>
							<td colspan="2">
							<br/>
							<% if(pageNum != null) { %> 
								<button onclick="window.location.href='board_sitterModifyForm.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">수정하기</button> &nbsp; 
								<button onclick="window.location.href='board_sitterDelete.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">삭제하기</button>	
							<% }else if(sitterpageNum != null) { %> 
								<button onclick="window.location.href='board_sitterModifyForm.jsp?num=<%=num%>&sitterpageNum=<%=sitterpageNum%>'">수정하기</button> &nbsp; 	
								<button onclick="window.location.href='board_sitterDelete.jsp?num=<%=num%>&sitterpageNum=<%=sitterpageNum%>'">삭제하기</button>	
							<% } %>
							</td>
						</tr>
						<% 	} %>
					</table>
					<br/>
				</div>
				<div align="center">
				<br/>
				<%  
				if(pageNum != null){  //게시판에서
					//다음글 (검색글이 아닐 경우에만)
					if(request.getParameter("count") != null){
						int count = Integer.parseInt(request.getParameter("count"));
						int realCount = dao.articleCount();
						if(count == realCount){
							int nextNum = dao.nextNum(num);	
							if(nextNum > 0){ %>
								<button onclick="window.location.href='board_sitterContent.jsp?pageNum=<%=pageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
						 <% }
						} 
					}%>
					 &nbsp; <button onclick="window.location.href='board_sitterList.jsp?pageNum=<%=pageNum%>'">리스트 보기</button> &nbsp; 	
					<% //이전 글 (검색글이 아닐 경우에만)
					if(request.getParameter("count") != null){
						int count = Integer.parseInt(request.getParameter("count"));
						int realCount = dao.articleCount();
						if(count == realCount){
							int pastNum = dao.pastNum(count, num);	
							if(pastNum > 0){ %>
								<button onclick="window.location.href='board_sitterContent.jsp?pageNum=<%=pageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
						 <% }
						}
					}
				}else if(sitterpageNum != null) { //내글 목록에서
					//다음글 (검색글이 아닐 경우에만)
					if(request.getParameter("count") != null){
						int count = Integer.parseInt(request.getParameter("count"));
						int realCount = dao.myArticleCount(si_sId);
						if(count == realCount){
							int nextNum = dao.nextNum(num, si_sId);	
							if(nextNum > 0){ %>
								<button onclick="window.location.href='board_sitterContent.jsp?sitterpageNum=<%=sitterpageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
						 <% }
						} 
					}%>
					 &nbsp; <button onclick="window.location.href='mepetSitterArticle.jsp?sitterpageNum=<%=sitterpageNum%>'">리스트 보기</button> &nbsp; 	
					<% //이전 글 (검색글이 아닐 경우에만)
					if(request.getParameter("count") != null){
						int count = Integer.parseInt(request.getParameter("count"));
						int realCount = dao.myArticleCount(si_sId);
						if(count == realCount){
							int pastNum = dao.pastNum(count, num, si_sId);	
							if(pastNum > 0){ %>
								<button onclick="window.location.href='board_sitterContent.jsp?sitterpageNum=<%=sitterpageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
						 <% }
						}
					}
					
				 } %>
				</div>
				<br/><br/><br/><br/>
			</section>
			<footer>
				<jsp:include page="mepetFooter.jsp" flush="false"/>
			</footer>	
<%		}
	
   	 } %>
</body>
</html>