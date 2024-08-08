<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 프로젝트 등록</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
article {	/* 가운데 정렬 */
	display: flex;
    justify-content: center;
    align-items: center;
}

#topWrap {
	display: flex;
	justify-content: space-between;
    align-items: center;
    max-width: 1280px;
    min-width: 900px;
    width: calc(100% - 40px);
    margin: 0 auto;
    padding: 8px 0;
}


/* ----- 버튼 ---------- */
#save, #request {	/* 저장하기 */
	width: 100px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
	border: none;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}
#save {
	background-color: #FFAB40;
}

#save:hover, #request:enabled:hover {
	background-color: #FFAB40;
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

#request:disabled {
	background-color: #F0F0F0;
}

/* ----- 프로젝트 심사기준 팝업창 ---------- */
#popupWrap {
	position: fixed;
    left: 50%;
    top: 400px;
    transform: translate(-50%, -50%);
    width: 800px; height: auto;
    box-sizing: border-box;;
    background-color: #F0F0F0;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    z-index: 1000;
    border-radius: 10px;
    padding: 20px 30px;
}

#popupTop {
	margin: 0 10px;
}
#popupTop p {
	line-height: 300%;	/* 줄간격 */
}

#popupContent {
	display: flex;
	justify-content: space-between;
}
#popupContent p {
	line-height: 200%;
}
.icon {
	border-radius: 100%;
	width: 25px; height: 25px;
	color: #fff;
	margin: auto;
	text-align: center;
}

#grantProject, #returnProject {
	background-color: #fff;
	border-radius: 10px;
	padding: 20px;
	width: 320px;
}

.grant {
	background-color: #2db400;
}
.return {
	background-color: red;
}

#agree {	/* 확인했어요 버튼 */
	width: 80%;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
	background-color: #FFAB40;
	color: #fff;
	border: none;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#agree:hover {
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

/* --------------------------------------- */
</style>
<script type="text/javascript">
	$(function() {
		// 프로젝트 심사 기준 팝업창 버튼 클릭 시 닫힘
		$("#agree").click(function() {
			$("#popupWrap").hide();
		});
	});	// ready 이벤트 끝
</script>
</head>
<body>
	<header>
		<div id="topWrap">
			<a href="#">← 내가 만든 프로젝트</a>
			<a href="./" class="main_logo">
				<img alt="로고" src="${pageContext.request.contextPath}/resources/image/withme.png">
			</a>
			<div>
				<input type="button" id="save" value="저장하기">
				<input type="submit" id="request" value="심사요청" disabled>
			</div>
		</div>
	</header>
	<article>
		<br><br><br><br><br><br><br><br><br><br><br>
		<h2 align="center">프로젝트 등록 시자악!</h2>
		<br><br><br><br><br><br><br><br><br><br><br>
		
	</article>
	
	<%-- ---------- 프로젝트 심사 기준 확인 팝업창 ---------- --%>
	<div id="popupWrap">
		<div id="popupTop">
			<h2>위드미의 프로젝트 심사 기준을 확인해주세요.</h2>
			<p>심사 기준을 준수하면 보다 빠른 프로젝트 승인이 가능합니다.</p>
		</div>
		<div id="popupContent">
			<%-- ----- 승인 가능 프로젝트 ----- --%>
			<div id="grantProject">
				<div class="icon grant">✓</div>
				<h4 align="center"><br>승인 가능 프로젝트</h4>
				<br>
				<p>- 기존에 없던 새로운 시도</p>
				<p>- 기존에 없던 작품, 제품</p>
				<p>- 창작자의 이전 제품 및 콘텐츠는 후원에서 부수적으로 제공 가능</p>
			</div>
			<%-- ----- 반려 대상 프로젝트 ----- --%>
			<div id="returnProject">
				<div class="icon return">X</div>
				<h4 align="center"><br>반려 대상 프로젝트</h4>
				<br>
				<p>- 기존 상품의 판매 및 홍보</p>
				<p>- 제3자에 후원금 또는 물품 기부</p>
				<p>- 시중에 판매 및 유통되었던 제품 제공</p>
				<p>- 현금, 주식, 지분, 복권, 사이버머니, 상품권 등 수익성 상품 제공</p>
				<p>- 추첨을 통해서만 제공되는 선물</p>
				<p>- 무기, 군용장비, 라이터 등 위험 품목</p>
			</div>
		</div>
		<div align="center">
			<input type="button" id="agree" value="확인했어요.">
		</div>
	</div>
	
<!-- 	<footer> -->
<%-- 		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> --%>
<!-- 	</footer> -->
</body>
</html>
