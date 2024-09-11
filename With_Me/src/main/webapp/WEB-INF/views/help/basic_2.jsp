<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link
	href="${pageContext.request.contextPath }/resources/css/default.css"
	rel="stylesheet" type="text/css">
<style type="text/css">
/* 업데이트된 CSS 스타일 */
#articleForm {
	width: 60%;
	margin: 20px auto;
	padding: 20px;
 	box-shadow: 0 0 5px rgba(0, 0, 0, 0.1); 
	border-radius: 10px;
	background-color: #fff;
}

h2 {
	text-align: left;
	margin-bottom: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

th, td {
/* 	border: 1px solid #ddd; */
	padding: 10px;
	text-align: left;
}
tr {
    border-bottom: solid 1px #F0F0F0 ;
}
th {
	background-color: #f9f9f9;
}

#basicInfoArea {
	margin-bottom: 20px;
}

#articleContentArea {
	background: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	white-space: pre-line;
	overflow: auto;
}

#commandCell {
	text-align: center;
	margin-top: 20px;
	
}




#list_btn {
	padding: 10px 20px;
	border: none;
	background-color: #FFAB40;
	width: 180px;
	color: white;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
}

#list_btn:hover {
	background-color: #fe9100;
}
section {
	min-height: 80px;
}
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section id="articleForm">
			<div align="left">
			<h2>크라우드펀딩과 후원이란 무엇인가요?</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <b>크라우드 펀딩이란 무엇이죠?</b>
				 <a>
				 크라우드 펀딩은 아이디어는 있지만 실행을 위한 자금이 부족한 개인 또는 팀이 다수의 사람들(Crowd)로부터 돈을 모금(Funding)하는 것을 말합니다. 
				 </a>
				 </span>
				 <span>
				 <b>후원이란 무엇인가요?</b>
				 <a>
				 후원은 물건이나 콘텐츠를 구매하는 것이 아닙니다. 아직 구현되지 않은 아이디어를 함께 완성해 나가는 일입니다.

				 창작자들이 구상하는 프로젝트가 실현될 수 있도록 후원을 통해 일정한 금액을 지불하여 창작자를 향한 지지와 도움을 더합니다. 그에 대한 보답으로 프로젝트가 완료되면 창작자가 약속한 선물을 받아보실 수 있습니다.

 				 후원은 이미 완성된 창작물을 구매하는 것이 아닙니다. 따라서 제작 과정 상의 변수로 창작자가 고지한 일정보다 늦어지거나 받아보실 선물이 변경될 수도 있는 점을 양지해 주셔야 합니다.

				 프로젝트에 대한 궁금한 점은 언제든 창작자에게 문의하여 답변을 받아볼 수 있습니다. 
				 </a>
				 </span>
				 <span>
				 <b>위드미는 이 과정에서 무엇을 하나요?</b>
				 <a>
				 위드미는 창작자의 신뢰와 후원자의 안전을 위해 원활하게 커뮤니티가 운영될 수 있도록 노력하고 있습니다.
				
				 신뢰할 수 있는 프로젝트를 소개하기 위해 프로젝트 심사 기준에 따라 모든 프로젝트를 심사하고 있습니다.
				
				 커뮤니티 내에서 창작자와 후원자 간 소통이 원활히 소통할 수 있도록 돕고, 공지와 알림 등을 통하여 정보격차가 발생하지 않도록 노력하고 있습니다.
				
				 이용약관에 명시된 프로젝트에 대한 책임이나 성실한 소통의 의무를 다하지 않는 창작자나 커뮤니티 가이드라인에 맞지 않는 행동으로 커뮤니티에 피해를 주는 이용자에게는 주의·경고를 거쳐 이용 정지 등의 제재를 가하고 있습니다. 
				
				 위드미는 운영정책에 맞지 않는 프로젝트나 이용자를 발견하실 경우, 문의하기를 통해 제보해 주시기 바랍니다.
				 </a>
				 </span>
			</section>
			<section id="commandCell">
				<!-- 목록 버튼 클릭시 BoardList.bo 서블릿 요청(파라미터 : 페이지번호) -->
				<input type="button" value="다른질문 보러가기"
					onclick="location.href='HelpCenter'" id="list_btn">
			</section>
		</section>
	</main>
	<footer>
		<!-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 -->
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>