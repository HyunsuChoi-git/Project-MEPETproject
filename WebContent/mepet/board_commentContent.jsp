<%@page import="web.mepet.model.MepetsitterDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="web.mepet.model.Board_commentDTO"%>
<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="web.mepet.model.MepetsitterDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<link href="xContent.css" rel="stylesheet" type="text/css" />
<style>
	 td{ margin:5px; border-top: 1px solid #77878F; }
	.writeForm { margin: auto; text-align: center;  }
</style>
</head>
<%
	
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
	
	String pageNum = null;
	String mypageNum = null;
	String sitterpageNum = null;
	int num = 0;
	if(request.getParameter("num") == null) {%>
		<script>
		alert("접근오류.");
		window.location.href="mepetMain.jsp";
		</script>
	<%}else{
		if(request.getParameter("pageNum") != null) pageNum = request.getParameter("pageNum");
		if(request.getParameter("mypageNum") != null) mypageNum = request.getParameter("mypageNum");
		if(request.getParameter("sitterpageNum") != null) sitterpageNum = request.getParameter("sitterpageNum");
	
	%>
	
<body>
	<header>
		<jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<br/>
		<h1 id="h1sub">펫시터 이용후기</h1>		
		<br/>	
		<div id="section">
<% 		num = Integer.parseInt(request.getParameter("num"));		
		 //답글인 경우와 아닌경우로 나눌 때,
		
		Board_commentDAO dao = new Board_commentDAO();
		Board_commentDTO comment = dao.commentContent(num);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");	
		
		if(comment.getRe_step() != 0) { //답글%>

		<%-- 답글로직 --%>
			<table class="writeForm" >
			'<%=comment.getNick() %>'님의 후기글에 대한 답글입니다.
				<tr>
					<td colspan="2"><h2>[답글]<%=comment.getSubject() %></h2></td>			
				</tr>
				<tr>
					<td >펫시터 : <%=comment.getSitter_name() %> &nbsp; 작성일 : <%= sdf.format(comment.getReg())%></td>
				</tr>
				<tr>
					<td><br/>내용
					<table>
						<tr>
							<td width="400" height="200">
								<%if(comment.getImg() != null){%>
									<img src="boardImg/<%=comment.getImg() %>" width="400" /><br/>
								<% }%>
								<%=comment.getContent() %>
							</td>
						</tr>
					</table>
					</td>
				</tr>			
				<%				
					if(si_sId != null && si_sId.equals(comment.getId())){%>
				<tr>
					<td>
					<br/>
					<% if(pageNum != null){ %> 
						<button onclick="window.location.href='board_commentRDelete.jsp?num=<%=comment.getNum()%>&pageNum=<%=pageNum%>'">삭제하기</button> &nbsp; 
						<button onclick="window.location.href='board_commentRModifyForm.jsp?num=<%=comment.getNum()%>&pageNum=<%=pageNum%>'">수정하기</button>
					<% }else if(sitterpageNum != null){ %> 
						<button onclick="window.location.href='board_commentRDelete.jsp?num=<%=comment.getNum()%>&sitterpageNum=<%=sitterpageNum%>'">삭제하기</button> &nbsp; 
						<button onclick="window.location.href='board_commentRModifyForm.jsp?num=<%=comment.getNum()%>&sitterpageNum=<%=sitterpageNum%>'">수정하기</button>
					<% } %>
					</td>
				</tr>
					<%}	%>
		</table>	
			
		<%}else{ //일반글
			
			String[] date = comment.getPetdate().split(" ");%>
		<%-- 후기글 로직--%>
		<table class="writeForm">
			<tr>
				<td>작성자 : <%= comment.getNick() %> &nbsp; 작성일 : <%= sdf.format(comment.getReg())%></td>
			</tr>
			<tr>
				<td><h2><%=comment.getSubject() %></h2></td>
			</tr>
			<tr height="70px">
				<td>이용 날짜 : <%=date[0] %> &nbsp; <%=comment.getPetday() %><br/>
				지역 : <%=comment.getArea() %> &nbsp; 펫시터 : <%=comment.getSitter_name() %> &nbsp; 만족도 : <%=comment.getPoint() %></td>
			</tr>
			<tr>
				<td><br/>후기
					<table>
						<tr>
							<td width="400" height="200">
								<%if(comment.getImg() != null){ %>
									<img src="boardImg/<%=comment.getImg() %>" width="400" /><br/>
								<%} %>
								<%=comment.getContent() %>
							</td>
						</tr>
					</table>		
				</td>
			</tr>
				<%
				if(si_sId != null){
					MepetsitterDTO sitter = sitterDAO.sitterInfo(si_sId);
					if(sitter.getName().equals(comment.getSitter_name())) { //펫시터 본인일 경우 %>
				<tr>
					<td>
						<br/>
						<% if(pageNum != null) { %> 
							<button onclick="window.location.href='board_commentRWriteForm.jsp?num=<%=comment.getNum()%>&pageNum=<%=pageNum%>&ref=<%=comment.getRef()%>&sitter_name=<%=sitter.getName() %>&re_step=<%=comment.getRe_step() %>&nick=<%=comment.getNick() %>'">답글쓰기</button>
						<% }else if(sitterpageNum != null) { %> 
							<button onclick="window.location.href='board_commentRWriteForm.jsp?num=<%=comment.getNum()%>&sitterpageNum=<%=sitterpageNum%>&ref=<%=comment.getRef()%>&name=<%=sitter.getName() %>&re_step=<%=comment.getRe_step() %>'">답글쓰기</button>
						<% } %>
					</td>
				</tr>	
					<%} 
				}%>	
				<%	if(sId != null && sId.equals(comment.getId())){ //작성자 본인일 경우%>
			<tr>
				<td>
					<br/>
					<% if(pageNum != null){ %> 
						<button onclick="window.location.href='board_commentModifyForm.jsp?num=<%=num%>&pageNum=<%=pageNum%>'">수정하기</button> &nbsp; 
						<button onclick="window.location.href='board_commentDelete.jsp?num=<%=comment.getNum()%>&pageNum=<%=pageNum%>'">삭제하기</button>
					<% }else if(mypageNum != null){ %>
						<button onclick="window.location.href='board_commentModifyForm.jsp?num=<%=num%>&mypageNum=<%=mypageNum%>'">수정하기</button> &nbsp; 
						<button onclick="window.location.href='board_commentDelete.jsp?num=<%=comment.getNum()%>&mypageNum=<%=mypageNum%>&mypageNum=<%=mypageNum%>'">삭제하기</button>
					 <% } %>
				</td>
			</tr>
					<%}	%>
		</table>
		<%}	%>	
		</div>
		<div align="center">
		<br/>
		<br/>
		<% 
		if(pageNum != null){ //후기게시판!!!
		
			//다음글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getCommentCount();
				if(count == realCount){
					int nextNum = dao.nextNum(num);	
					if(nextNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?pageNum=<%=pageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button> &nbsp; 	
				 <% }
				} 
			}%>
			<button onclick="window.location.href='board_commentList.jsp?pageNum=<%=pageNum%>'">리스트 보기</button> &nbsp; 	
			<% //이전 글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getCommentCount();
				if(count == realCount){
					int pastNum = dao.pastNum(count, num);	
					if(pastNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?pageNum=<%=pageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
				 <% }
				}
			}
		}else if(mypageNum != null){  //내가쓴 후기 페이지!!!
			
			//다음글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getMyCommentCount(comment.getNick());
				if(count == realCount){
					int nextNum = dao.nextNum(num, comment.getNick());	
					if(nextNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?mypageNum=<%=mypageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
				 <% }
				} 
			}%>
			<button onclick="window.location.href='mepetMysitter.jsp?mypageNum=<%=mypageNum%>'">리스트 보기</button>	
			<% //이전 글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getMyCommentCount(comment.getNick());
				if(count == realCount){
					int pastNum = dao.pastNum(count, num, comment.getNick());	
					if(pastNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?mypageNum=<%=mypageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
				 <% }
				}
			}
	  	}else if(sitterpageNum != null) {  
	  		String name = sitterDAO.sitterName(si_sId);
	  		
	  		//내게쓴 후기 페이지!!!
	  		//다음글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getSitterCommentCount(name);
				if(count == realCount){
					int nextNum = dao.nextNum_s(num, name);	
					if(nextNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?sitterpageNum=<%=sitterpageNum%>&num=<%= nextNum%>&count=<%=count%>'">다음글</button>	
				 <% }
				} 
			}%>
			<button onclick="window.location.href='mepetSitterComment.jsp?sitterpageNum=<%=sitterpageNum%>'">리스트 보기</button>	
			<% //이전 글 (검색글이 아닐 경우에만)
			if(request.getParameter("count") != null){
				int count = Integer.parseInt(request.getParameter("count"));
				int realCount = dao.getSitterCommentCount(name);
				if(count == realCount){
					int pastNum = dao.pastNum_s(count, num, name);	
					if(pastNum > 0){ %>
						<button onclick="window.location.href='board_commentContent.jsp?sitterpageNum=<%=sitterpageNum%>&num=<%= pastNum%>&count=<%=count%>'">이전글</button>	
				 <% }
				}
			}

		 } %>
		</div>
<%	} %>
	<br/>
	<br/>
	<br/>
	<br/>
	<br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>
</html>