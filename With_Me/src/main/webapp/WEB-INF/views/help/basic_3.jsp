<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헬프센터 기본질문</title>
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
			<h2>프로젝트 후원은 무엇인가요?</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <a>
				 후원은 창작자들이 구상하는 프로젝트가 실현될 수 있도록 금액을 지불하여 돕는 것입니다. 창작자를 향한 지지와 도움을 제공하시고 프로젝트를 통해 만들어지는 선물을 받아보시게 됩니다. 

				 후원은 간단합니다. 응원을 보내고 싶은 프로젝트 페이지에서 받아보고 싶은 선물을 고르신 다음, 후원 결제를 예약하시면 후원이 완료됩니다.
				 </a>
				 </span>
				 <span>
				 <b>후원 결제를 예약한다는 것은 어떤 의미인가요?</b>
				 <a>
				 후원자 보호를 위해 후원을 하신 즉시 결제가 진행되지 않습니다.
				 
				 후원하신 프로젝트가 목표 모금액을 달성했을 경우에만 <b>펀딩 종료일 다음날</b>부터 7일간 결제가 진행됩니다. 프로젝트가 무산될 경우엔 결제 자체가 진행되지 않습니다.
				 </a>
				 </span>
				 <span>
				 <b>좋아하는 프로젝트들을 한꺼번에 후원해도 당장은 비용을 지불하지 않아도 된다는 거군요!</b>
				 <a>
				 네, 맞습니다.

				 결제를 예약하신 금액은 각 프로젝트의 목표 모금액 달성 여부에 따라 자동으로 결제되거나 취소될 뿐입니다. 즉, 후원하는 시점과는 별도로 각 프로젝트의 펀딩 종료일에 맞춰 결제가 진행됩니다.
				 </a>
				 </span>
				 <table border="2">
					 <tr>
					 	<td>프로젝트</td>
					 	<td>후원 일시</td>
					 	<td> 펀딩 일정</td>
					 	<td>실제 결제일</td>
					 </tr>
					 <tr>
					 	<td>A 프로젝트</td>
					 	<td>1월 1일</td>
					 	<td>1월 1일 ~ 1월 10일</td>
					 	<td>1월 11일</td>
					 </tr>
					 <tr>
					 	<td>B 프로젝트</td>
					 	<td>1월 1일</td>
					 	<td>1월 1일 ~ 2월 10일</td>
					 	<td>2월 11일</td>
					 </tr>
				 </table>
				 <span>
				 <b>프로젝트를 후원할 때 발생하는 수수료가 있나요?</b>
				 <a>
				 없습니다. 프로젝트의 목표 모금액이 모이지 않아 펀딩이 무산되어도 지불하실 수수료는 없고, 후원 결제 예약은 취소됩니다.
				 </a>
				 </span>
				 <span>
				 <b>저의 후원 금액이 공개적으로 표시되나요?</b>
				 <a>
				 후원자님의 후원 금액은 오직 해당 프로젝트의 창작자와 후원자 본인만 확인할 수 있습니다.
				 </a>
				 </span>
				 <ul>
					 <li>ㆍ텀블벅에서의 후원은 아직 실현되지 않은 프로젝트가 실현될 수 있도록 제작비를 후원하는 과정으로, 익숙한 인터넷 쇼핑과는 다릅니다. 기존의 상품 또는 용역을 거래의 대상으로 하는 매매와는 차이가 있어 전자상거래법상 청약철회 등의 규정이 적용되지 않습니다.</li>
					 <li>ㆍ텀블벅에서 진행되는 프로젝트를 완수할 책임과 권리는 해당 프로젝트를 진행한 창작자에게 있습니다.</li>
				 </ul>
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