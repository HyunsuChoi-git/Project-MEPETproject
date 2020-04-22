<%@page import="web.mepet.model.MepetmemberDAO"%>
<%@page import="web.mepet.model.Board_commentDTO"%>
<%@page import="java.util.List"%>
<%@page import="web.mepet.model.Board_commentDAO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMypetHome.css" rel="stylesheet" type="text/css" />
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
<%	}else{ 

	String mypageNum = "1";	
	if(request.getParameter("mypageNum") != null) {
		mypageNum = request.getParameter("mypageNum");
	}

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	int pageSize = 10;
	int currentPage = Integer.parseInt(mypageNum);
	int startRow = (currentPage-1)*pageSize + 1;
	int endRow = currentPage*pageSize;
	int number = 0; // 게시판에 뿌려줄 글번호
	
	//전체 글 갯수 반환
	int count = 0;
	
	MepetmemberDAO member = new MepetmemberDAO();
	String nick = member.memberNick(sId);
	Board_commentDAO dao = new Board_commentDAO();
	List getConmmentList = null;
	
	/////////검색기능을 사용했으면 검색관련 글 뽑아주기
	
	String sel = request.getParameter("sel");
	String search = request.getParameter("search");
	if(sel != null && search != null){
		count = dao.getMyCommentCount(sel, search, nick);
		if(count > 0){
			getConmmentList = dao.getMyCommentList(sel, search, startRow, endRow, nick);
		}
	}else{
		count = count = dao.getMyCommentCount(nick);
		if(count > 0){
			getConmmentList = dao.getMyConmmentList(startRow, endRow, nick);
		}
	}
	
	//현재페이지에서부터 모든 글의 수 
	number = count - (currentPage -1) * pageSize;

%> 
	<body>
		<header>
			 <jsp:include page="mepetHeader.jsp" flush="false"/>
		</header>
		<section>
			<br/>
			<a href="mepetMyHome.jsp"><h3 align="center" style="margin-bottom: 0; color: #655f86;">'<%=nick %>'님의</h3>
			<h1 align="center" style="margin-top: 0; color: #655f86;">마이 미펫 홈</h1></a>
			<div id="mypage">
				<button class="box" onclick="window.location.href='mepetMypage.jsp'">내 정보</button>
				<button div class="box" onclick="window.location.href='mepetMyArticle.jsp'">나의활동</button>
				<button div class="box" onclick="window.location.href='mepetMysitter.jsp'">펫시터</button>
			</div>
			<br/>
			<h1 align="center"><button class="mepetButt" onclick="window.location.href='board_sitterList.jsp'" >펫시터 예약하기</button></h1>
			<br/>
			<div class="table">
			<table id="list">
				<tr>
					<td colspan="5" align="right">
						<form action="board_commentList.jsp" method="post">
							<select id="sel" name="sel">
								<option value="area">지역</option>
								<option value="sitter_name">펫시터</option>
								<option value="point">만족도</option>
							</select>
							<input class="text" type="text" name="search" />
							<input  class="mepetButt" type="submit" value="검색" />
						</form>
					</td>
				</tr>
				<tr>
					<td>No.</td>
					<td width="400px">제목</td>
					<td>글쓴이</td>
					<td>날짜</td>
					<td>조회수</td>
				</tr>
			<% // 글이 없을 때
				if(count == 0){ %>
					<tr>
						<td colspan="5">작성된 글이 없습니다.</td>
					</tr>	
			<% 	}else{ //글이 있을 때 
				Board_commentDTO comment = null;
				for(int i = 0; i < getConmmentList.size(); i++){
					comment = (Board_commentDTO)getConmmentList.get(i);
					if(comment.getRe_step() > 0){	//답글일 때 %>
						<tr>
							<td><%= number-- %></td>
							<td width="450">
							<a href="board_commentContent.jsp?num=<%=comment.getNum()%>&mypageNum=<%=mypageNum%>&count=<%=count%>&re_step=<%=comment.getRe_step()%>">
							 &nbsp; &nbsp;
							 <img src = "adminImg/rewriteIcon.png" width="15" /> [답글]
							 <%= comment.getSubject() %></a>
							</td>
							<td><%= comment.getNick() %></td>
							<td><%= sdf.format(comment.getReg()) %></td>
							<td><%= comment.getReadcount() %></td>
					
						</tr>
						
				<% 	}else{ //새글 일 때
						String[] petdate = comment.getPetdate().split(" ");%>
							
						<tr>
							<td><%= number-- %></td>
							<td width="450">
							<h3><a href="board_commentContent.jsp?num=<%=comment.getNum()%>&mypageNum=<%=mypageNum%>&count=<%=count%>"><%= comment.getSubject() %></a></h3>
							이용날짜 : <%=petdate[0] %> &nbsp; <%=comment.getPetday() %> <br/>
							지역 : <%=comment.getArea() %> &nbsp; 펫시터 : <%= comment.getSitter_name() %>님 &nbsp; 만족도 : <%= comment.getPoint() %> 점
							</td>
							<td><%= comment.getNick() %></td>
							<td><%= sdf.format(comment.getReg()) %></td>
							<td><%= comment.getReadcount() %></td>
				
						</tr>
				<%	}
			 	}
			} %>	
			</table>
		</div>	
		<br/>
		<br/>
		<br/>
			<div class="view" align="center">
			<%//페이지뷰어 만들기
				if(count > 0){
					//1. 총 몇페이지 나오는지 계산
					int pageCount = count/pageSize + (count%pageSize == 0 ? 0 : 1);
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
					<a class="view" href="mepetMysitter.jsp?mypageNum=<%=startPage-1%>"> &lt; </a>
					<%}
					//5. 페이지 반복해서 뿌려주기
					for(int i = startPage; i <= endPage; i++){%>
					<a class="view" href="mepetMysitter.jsp?mypageNum=<%=i%>"> &nbsp; <%=i%> &nbsp; </a>
					<%}
					//7. endPage가 pageCount보다 작으면 '>'
					if(endPage < pageCount){%>
					<a class="view" href="mepetMysitter.jsp?mypageNum=<%=endPage+1%>"> &gt; </a>
					<%}
				}%>
				<br/>
				<button class="mepetButt" onclick="window.location.href='mepetMyHome.jsp'">마이 홈</button>
			</div>
	
		</section>
		<footer>
			<jsp:include page="mepetFooter.jsp" flush="false"/>
		</footer>
				
			
	</body>
<% } %>
</html>