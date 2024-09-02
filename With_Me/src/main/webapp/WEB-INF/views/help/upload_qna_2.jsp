<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헬프센터 프로젝트올리기 질문</title>
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
			<h2>프로젝트 주요 일정이 어떻게 되나요?</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <a>
				 프로젝트의 주요 일정을 미리 알면 펀딩을 더욱 구체적으로 계획할 수 있습니다.

				 텀블벅 프로젝트의 주요 일정은 크게 <b>(공개예정 기간 - 펀딩 기간 - 결제 기간 - 정산일 - 선물 전달)</b>로 진행됩니다. 
				 아래에서 프로젝트의 주요 일정의 설정 가능 기간을 확인해 주세요. 
				 </a>
				 </span>
				 <span>
				 
				 <a>
				 (선택) 공개예정 기간 : 공개예정 기능 이용은 창작자님의 선택 사항입니다. 펀딩 시작 전에 미리 프로젝트를 소개할 수 있는 공개예정 기능은 펀딩 시작 전 1일~15일 내로 설정하실 수 있습니다.

				 ㆍ펀딩 기간 : 펀딩 기간은 7일부터 60일 내로 권장합니다. 

				 ㆍ결제 기간 : 후원 결제는 펀딩 종료일 다음 날부터 7일 동안 24시간 간격으로 시도됩니다.

				 ㆍ정산일 : 모금액 정산일은 결제 종료일 다음 날부터 영업일 기준 7일 후입니다.

				 ㆍ선물 전달 : 선물의 예상 전달일은 결제 종료 다음 날부터 5년 내로 설정하실 수 있습니다.
				 </a>
				 </span>
				 <table>
				 	<tr>
				 		<th>공개예정 기간</th>
				 		<td>(선택사항) 펀딩 시작 전 1일-15일</td>
				 	</tr>
				 	<tr>
				 		<th>펀딩 기간</th>
				 		<td>7일 - 60일</td>
				 	</tr>
				 	<tr>
				 		<th>결제 기간</th>
				 		<td>펀딩 마감일 다음 날 - 7일동안</td>
				 	</tr>
				 	<tr>
				 		<th>정산일</th>
				 		<td>결제 종료일 다음 날로부터 영업일 기준 7일 후</td>
				 	</tr>
				 	<tr>
				 		<th>선물 예상 전달일</th>
				 		<td>결제 종료 다음 날 - 5년</td>
				 	</tr>
				 	
				 </table>
				 <span>
				 <a>
				 현재 작성 중인 프로젝트 별 주요 일정은 <b>프로젝트 관리 > 프로젝트 기획 > 펀딩 계획 > 펀딩 일정</b>에서 확인하실 수 있습니다.
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