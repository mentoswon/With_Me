<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헬프센터 후원자 질문</title>
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
			<h2>후원했는데 후원현황에 보이지 않아요.</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <b>후원을 했는데 후원현황에 후원한 내역이 보이지 않나요?</b>
				 <a>
				 후원한 계정과 지금 로그인하고 있는 계정이 다를 수도 있습니다. 동일한 계정인지 확인해 주세요.
				 후원한 계정으로 다시 로그인하면 후원현황에서 내역을 확인할 수 있습니다.
				 계정의 비밀번호가 기억나지 않는다면 로그인 페이지 하단에서 비밀번호 재설정 링크를 받아보실 수 있습니다. 
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