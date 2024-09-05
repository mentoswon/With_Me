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
			<h2>프로젝트 시작에는 어떤 자격요건이 필요한가요?</h2>
			</div>

			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
				 <a>위드미는 사업자와 개인 여부에 관계없이 자유롭게 프로젝트를 시작하실 수 있습니다.</a>

				 <a>다만 신뢰와 안전을 위해 다음과 같은 최소 자격 요건을 심사 단계에서 확인하고 있습니다.</a>
				 </span>
				 <span>
				 ㆍ한국에서 개설된 본인 개인 또는 사업자의 <b>국내 은행계좌</b>가 있어야 하며, 통장 사본을 제출하셔야 합니다.
					- 등록 가능 계좌 : KDB산업은행, BOA, IBK기업은행, KB국민은행, NH농협, NH투자증권, SC은행, 경남은행, 광주은행, 대구은행, 대신증권, 미래에셋, 부산은행, 삼성증권, 새마을은행, 수협은행, 신한은행, 신협은행, 씨티은행, 외환은행, 우리은행, 우체국, 유안타증권, 전북은행, 제주은행, 하나은행, 한화투자증권<br>
				 ㆍ창작자가 개인일 경우 <b>신분증,</b> 사업자인 경우 <b>사업자등록증</b>을 제출하셔야 합니다.<br>
				 ㆍ정산 계좌는 <b>창작자 본인의 계좌</b>만 등록할 수 있습니다. (단, 사업자의 경우 대표자의 계좌를 등록할 수 있습니다.)<br>
				 ㆍ창작자는 본인인증을 위해 <b>국내 통신사의 휴대폰 회선</b>을 보유하고 있어야 합니다.<br>
				 ㆍ<b>만 19세 미만 미성년자는 프로젝트 개설이 불가</b>합니다.<Br>
				 
				 </span>
				<span>
				<a>더 자세한 사항은 프로젝트 심사 기준(제6조 창작자 신뢰도)를 참고해 주세요.</a>
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