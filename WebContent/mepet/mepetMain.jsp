<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="xMepetStyle.css" rel="stylesheet" type="text/css" />
<link href="https://fonts.googleapis.com/css?family=Nanum+Pen+Script&display=swap&subset=korean" rel="stylesheet">
<style>
	#main{ font-family: 'Nanum Pen Script', cursive; text-align: center; width:100%; 
		 margin:0 auto;	background-color: #e8e8fa; height:200px; 
	}
	#mainSub {  font-size: 50px; display: inline-block; background-color: #f7dfdf; height:35px; padding:0; margin-top:0; margin-bottom: 0;
		border-radius: 40px; color:#e04a2a;
	} 
	#mainSub_b {  font-size: 35px; display: inline-block; padding:0; margin-top:1; margin-bottom: 0; color: #485a74;}
	#mainText { font-size: 25px; color: #485a74;}

	#board {magin:0 auto;}
	.board{ display: inline-block; width:20%; margin-left: 30px; }
	.boardList { font-family: 'Nanum Pen Script', cursive; font-size: 23px; color:#655f86; 
		margin:0; margin-bottom: 10px; display: inline-block; height: 15px; background-color: #e8e8fa; border-radius: 6px;
	}
	.arrow { margin:0; padding : 0;}
	img { border-radius: 3px; }
	
	
	#sitter { font-family: 'Nanum Pen Script', cursive; text-align: center; border : 2px solid #cfcfe1; width:70%;
		border-radius: 10px; margin:0 auto;	background-color: #f0f0fc;
	}
	#sitterSub { font-size: 30px; font-weight: bolder; color: #312838;}
	#sitterText { font-size: 25px; color:#655f86; }
	#a:link { text-decoration:none; color:#fb4c4c; }
	#a:visited { text-decoration:none; color:#fb4c4c;}
</style>

</head>
<body>
	<header>
		 <jsp:include page="mepetHeader.jsp" flush="false"/>
	</header>
	<section>
		<br/><br/><br/>
		<div id="main">
			<p id="mainSub_b">나와 함께하는 반려동물을 위한</p>
			<h2 id="mainSub">&nbsp; '미펫 Me&Pet'</h2>
			<p id="mainText">펫시터를 연결해줌은 물론, 나도 펫시터가 될 수 있는 좋은 기회!<br/>
			그리고 반려동물을 사랑하는 전국의 모든 분들과 소통해보아요~</p>
		</div>
		<br/><br/><br/><br/><br/><br/>
		<div align="center" id="board">
			<div class="board" align="center">
				<p class="boardList">미펫 펫시터 예약하기</p>
				<img class="arrow" src="adminImg/arrow2.png" width="30px" />
				<a href="board_sitterList.jsp"><img src="adminImg/main1.jpg" width="100%"/></a>
			</div>
			<div class="board" align="center">
				<p class="boardList">미펫 펫시터 이용후기</p>
				<img class="arrow" src="adminImg/arrow2.png" width="30px" />
				<a href="board_commentList.jsp"><img src="adminImg/main2.jpg"width="100%"/></a>
			</div>
			<div class="board" align="center">
				<p class="boardList">미펫 커뮤니티</p>
				<img class="arrow" src="adminImg/arrow2.png" width="30px" />
				<a href="board_commList.jsp"><img src="adminImg/main3.jpg"width="100%"/></a>
			</div>
		</div>
		<br/><br/><br/><br/><br/><br/>
		<div id="sitter">
			<p id="sitterText">
			펫시터는 반려동물을 사랑하는 여러분에게 최고의 시간제 일자리입니다. <br/>
			여유로운 날, 사랑이 필요한 반려동물과 함께 시간을 보내보는 건 어떨까요?
			</p>
			<p id="sitterSub">펫시터 신청하기&nbsp;<a id="a" href="meSitterSignupForm.jsp">click!</a></p>
		</div>
		<br/><br/><br/><br/><br/><br/>
	</section>
	<footer>
		<jsp:include page="mepetFooter.jsp" flush="false"/>
	</footer>
</body>

</html>