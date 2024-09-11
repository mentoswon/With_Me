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

section { /* 페이지 하단 공백 생기는 현상 해결 */
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
			<h2>가능한 결제수단은 무엇인가요?</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <b>국내 신용/체크 카드</b>
				 <a>
				 비씨, KB국민(카카오뱅크체크), KEB하나(외환), 삼성, 신한, 현대, 롯데, NH채움, 하나, 씨티, 수협, 신협, 우리, 광주, 전북, 제주, 산은캐피탈, 우체국*, 저축은행, 새마을금고, KDB산업은행, 카카오뱅크*, 토스뱅크*

				 *카드 등록 시 우체국은 'BC카드' 카카오뱅크는 'KB국민카드', 토스뱅크는 '외환카드'로 표시됩니다.
				 </a>
				 </span>
				 <span>
				 <b>국내 은행/증권사 계좌</b>
				 <a>
				 경남은행, 광주은행, 국민은행, 기업은행, 농협, 대구은행, 부산은행, 삼성증권, 신한은행, 신협, 씨티은행, 우리은행, 우체국, 유안타증권, 제주은행, KDB산업은행, KEB하나은행, MG새마을금고, SC제일은행
				 </a>
				 </span>
				 <span>
				 <b>카카오페이</b>
				 <a>
				 카카오페이에서 지원하는 결제수단에 관해서는 카카오페이 고객센터를 참고해주세요.
				 </a>
				 <b>해외 결제수단(페이팔 등)은 지원하지 않습니다</b>
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