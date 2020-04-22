<%@page import="java.text.SimpleDateFormat"%>
<%@page import="web.mepet.model.Board_commDTO"%>
<%@page import="web.mepet.model.Board_commDAO"%>
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
<%
	//세션 쿠키 검사
	int num = 0;
	String pageNum = null;
	String mypageNum = null;
	
	String sId = (String)session.getAttribute("sId");
	String cId = null;
	Cookie[] ck = request.getCookies();
	if(ck != null){
		for(Cookie c : ck){
			if(c.getName().equals("cId")) cId = c.getValue();
		}
	}
	if(sId == null && cId != null) {
		session.setAttribute("sId", cId);
		sId = cId;
	}
	
	if(request.getParameter("num") == null){ %>
		<script>
			alert("접근오류.");
			window.location.href="mepetMain.jsp";
		</script>	
 <% }else{
		num = Integer.parseInt(request.getParameter("num"));	
		
		if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
		if(request.getParameter("mypageNum") != null) mypageNum = request.getParameter("mypageNum");
		
	 	Board_commDAO dao = new Board_commDAO();
		Board_commDTO article = dao.getContent(num);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	
%>
	<body>
		<header>
			<jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<h1 id="h1sub">미펫 커뮤니티</h1>
			<br/>
			<div id="section">
				<%=article.getType() %>글
				<table id="writeForm">
					<tr>
						<td colspan="2">
						<h2>
						<%if(request.getParameter("re_step") != null){ %>[답글]<% } %>
					    <%=article.getSubject() %></h2>
						글쓴이 : <%=article.getNick() %>
						</td>			
					</tr>
					<tr>
						<td >작성일 : <%= sdf.format(article.getReg())%>
						 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
						조회수 : <%=article.getReadcount() %></td>
					</tr>
					<tr>
						<td><br/>내용
						<table>
							<tr>
								<td width="400" height="200">
									<%if(article.getImg() != null){%>
										<img src="boardImg/<%=article.getImg() %>" width="400" /><br/>
									<% }%>
									<%=article.getContent() %>
								</td>
							</tr>
						</table>
						</td>
					</tr>			
					<tr>
						<td>
						<br/>
					<% if(sId != null && mypageNum == null) { %> 
							<button onclick="window.location.href='board_commWriteForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>&ref=<%=article.getRef() %>&re_step=<%=article.getRe_step()%>&re_level=<%=article.getRe_level()%>'">답글쓰기</button>
					<% } %>	
					<% if(sId != null && sId.equals(article.getId())){
							if(pageNum != null){ %> 
								<button onclick="window.location.href='board_commModifyForm.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">수정하기</button> &nbsp; 
								<button onclick="window.location.href='board_commDelete.jsp?num=<%=article.getNum()%>&pageNum=<%=pageNum%>'">삭제하기</button>
						 <% }else if(mypageNum != null){ %>
								<button onclick="window.location.href='board_commModifyForm.jsp?num=<%=article.getNum()%>&mypageNum=<%=mypageNum%>'">수정하기</button> &nbsp; 
								<button onclick="window.location.href='board_commDelete.jsp?num=<%=article.getNum()%>&mypageNum=<%=mypageNum%>'">삭제하기</button>
						 <% }%>
					<% } %>
						</td>
					</tr>
				</table>
			</div>
			<div align="center">
				<br/>
				<% //다음글 (검색글이 아닐 경우에만)
					if(pageNum != null){
						if(request.getParameter("count") != null){
							int count = Integer.parseInt(request.getParameter("count"));
							int realCount = dao.getCommCount();
							if(count == realCount){
								int nextNum = dao.nextNum(num);	
								if(nextNum > 0){ %>
									<button onclick="window.location.href='board_commContent.jsp?pageNum=<%=pageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
							 <% }
							} 
						}%>
						<button onclick="window.location.href='board_commList.jsp?pageNum=<%=pageNum%>'">리스트 보기</button>	
						<% //이전 글 (검색글이 아닐 경우에만)
						if(request.getParameter("count") != null){
							int count = Integer.parseInt(request.getParameter("count"));
							int realCount = dao.getCommCount();
							if(count == realCount){
								int pastNum = dao.pastNum(count, num);	
								if(pastNum > 0){ %>
									<button onclick="window.location.href='board_commContent.jsp?pageNum=<%=pageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
							 <% }
							}
						}
					}else if(mypageNum != null){ 
						if(request.getParameter("count") != null){
							int count = Integer.parseInt(request.getParameter("count"));
							int realCount = dao.getMyCommCount(sId);
							if(count == realCount){
								int nextNum = dao.nextNum(num, sId);	
								if(nextNum > 0){ %>
									<button onclick="window.location.href='board_commContent.jsp?mypageNum=<%=mypageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
							 <% }
							} 
						}%>
						<button onclick="window.location.href='mepetMyArticle.jsp?mypageNum=<%=mypageNum%>'">리스트 보기</button>	
						<% //이전 글 (검색글이 아닐 경우에만)
						if(request.getParameter("count") != null){
							int count = Integer.parseInt(request.getParameter("count"));
							int realCount = dao.getMyCommCount(sId);
							if(count == realCount){
								int pastNum = dao.pastNum(count, num, sId);	
								if(pastNum > 0){ %>
									<button onclick="window.location.href='board_commContent.jsp?mypageNum=<%=mypageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
							 <% }
							}
						}
			       } %>
			</div>
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
	</body>
 <% } %>
</html>