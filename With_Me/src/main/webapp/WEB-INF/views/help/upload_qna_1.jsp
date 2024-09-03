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
			<h2>심사관련 자주묻는 질문</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <a>위드미에서 진행되는 모든 프로젝트는 모금상의 신뢰와 안전을 위해 심사팀의 심사를 거칩니다(프로젝트 심사 기준). 심사 기준과 일정에 대해 가장 많이 궁금해 하시는 내용을 모았습니다.</a>
				 </span>
				 <span>
				 <b>Q. 아직 계획 뿐인데 펀딩해도 되나요?</b>
				 <a>
				 그럼요! 하지만 <b>'예상 결과물'</b>이 있어야 합니다. 후원자는 프로젝트 계획만을 보고 후원을 할지 말지 결정해야 해요. 따라서 아직 완성된 제품은 없더라도 예상되는 결과물을 가늠할 수 있도록 최대한의 정보를 제공해주셔야 합니다. 결과물의 소재, 사양, 기능 등을 이미지나 영상을 활용하여 충분히 설명해 주세요.

				 프로젝트 작성이 어려우신 분들을 위해 <b>창작자 가이드</b>를 제공하고 있습니다.
				 </a>
				 </span>
				 <span>
				 <b>Q. 그럴싸하게 설명하면 되나요?</b>
				 <a>
				 이미지나 영상이 실제 결과물과 최대한 유사해야 해요. 아직 완성되지 않은 제품인데 이미 완성된 것처럼 작성하거나 실제와 너무 다른 이미지를 사용하시면 안 돼요. 
				 실제로는 50쪽짜리 도서인데 이미지로는 500쪽처럼 보인다면 후원자는 실물을 받고 당황할 수밖에 없어요. 
				 제작하면서 변경된 부분이 있다면 후원자들에게 업데이트로 꼭 안내해주세요.
				 </a>
				 </span>
				 <span>
				 <b>Q. 제 프로젝트가 왜 반려되었죠?</b><br>
				 <b>1. 혹시 판매나 유통하신 적이 있나요?</b>
				 <a>
				 이전에 판매, 유통, 펀딩을 성공하셨던 '제품∙콘텐츠'는 프로젝트를 진행하실 수 없어요. 판매 플랫폼에 노출되어 있다면 실제 판매 여부와 무관하게 '유통된' 것으로 간주됩니다. 
				 하지만 펀딩을 시도했다가 무산된 경우, 유통된 것은 아니기 때문에 다시 도전하실 수 있어요!
				 </a>
				 <b>2. 기부하기 위한 펀딩인가요?</b>
				 <a>
				 펀딩을 통해 선한 영향력을 전하고 싶은 따뜻한 마음에는 공감합니다. 하지만 텀블벅은 신규 창작이나 제작이 목적인 펀딩만 진행하실 수 있어요. 
				 따라서 텀블벅으로 모은 금액의 일부나 전체를 제 3자에게 전달하거나, 물품을 구입하여 전달하기 위한 프로젝트는 진행하실 수 없습니다.
				 </a>
				 <b>3. 홍보 만을 위한 펀딩인가요?</b>
				 <a>
				 텀블벅의 프로젝트는 구체적인 목표, 분명한 완료 기준, 예상 결과물이 있어야 합니다. 그래서 브랜드 홍보나 인식 개선, 혹은 캠페인 만을 위한 프로젝트는 진행할 수 없어요. 목표가 추상적이기 때문에 목표를 달성했는지도 분명하게 알기 어렵기 때문이에요. 
				 구체적인 목표, 분명한 완료의 기준이 있는지 다시 한 번 검토해 보세요.
				 </a>
				 <b>해외 결제수단(페이팔 등)은 지원하지 않습니다</b>
				 </span>
				 <span>
				 <b>Q. 심사를 요청했어요.</b><br>
				 <b>1. 심사 결과는 언제 나오나요?</b>
				 <a>
				 평균 3 영업일(공휴일/주말 제외) 동안 심사가 진행됩니다. 접수 순으로 진행되기 때문에 정확한 시간 안내는 어렵습니다.
				 </a>
				 <b>2. 원하는 일자에 꼭 시작하고 싶어요. 최종 승인까지 며칠 정도 걸릴까요?</b>
				 <a>
				 원하시는 시작일이 있다면 적어도 7일 정도 전에 여유있게 심사를 요청해 주세요.
				 </a>
				 <b>3. 심사 요청 이후 수정할 수 있나요?</b>
				 <a>
				 네, 가능합니다. 심사 담당자가 수정된 내용으로 심사할 수 있도록 최대한 빠르게 수정해 주세요.
				 </a>
				 <b>4. 프로젝트 시작일이 내일이에요. 그 전에 승인되지 않으면 어떻게 되나요?</b>
				 <a>
				 프로젝트는 심사 승인 이후 시작할 수 있습니다. 승인 이후에도 일정을 변경할 수 있으니 걱정마세요. 심사 진행 중 시작일이 지났다고 해서 반려되는 일은 없습니다.
				 </a>
				 <b>5. 심사 피드백이나 규정에 대한 질문이 있어요.</b>
				 <a>
				 관련한 문의는 받아보신 메일에서 회신으로 보내주세요. 심사 매니저가 확인하여 답변 드리겠습니다.
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