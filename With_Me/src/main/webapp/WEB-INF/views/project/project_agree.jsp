<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>With_Me</title>
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

#projecWrap {
    max-width: 520px;
}
#projecWrap p {
	line-height: 300%;	/* 줄간격 */
}

/* ----- 체크박스 ----------*/
.agreeChechbox {
	display: flex;
	align-items: flex-start;
	margin-bottom: 10px;
	position: relative;
	padding-left: 30px; /* 체크박스의 왼쪽 여백 */
	line-height: 1.5; /* 줄 높이 */
}

input[type="checkbox"] {
	opacity: 0; /* 기본 체크박스 숨기기 */
	position: absolute;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

input[type="checkbox"] + label::before {
	content: '';
	display: inline-block;
	width: 20px;
	height: 20px;
	border: 2px solid #ccc;
	background-color: #fff;
	margin-right: 5px;
	vertical-align: middle;
	border-radius: 4px;
	position: absolute; /* 체크박스 위치 조정 */
	left: 0; /* 체크박스의 왼쪽 위치 조정 */
	top: 3px;
	transform: translateY(0); /* 수직 중앙 정렬 */
}

input[type="checkbox"]:checked + label::before {
	background-color: #FFAB40;
	border-color: #FFAB40;
}

input[type="checkbox"]:checked + label::after {
	content: '✓';
	position: absolute;
	top: 12px;
	left: 2%;
	transform: translate(-50%, -50%);
	color: #fff;
	font-size: 18px;
	font-weight: bold;
}

label {
	margin: 3px;
	cursor: pointer;
}
label b {
	color: red;
}

#commission {
	color: #ccc;
}

/* ----- 버튼 ----------*/
#button {
	display: flex;
	justify-content: space-between;
}
#back, #start {
	width: 100px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
}

#back {	/* 돌아가기 */
	background-color: #ffffff;
	border: 2px solid #ccc;
}
#start {	/* 시작하기 */
	border: none;
	background-color: #FFAB40;
}
#back:hover,#start:enabled:hover {
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

#start:disabled {
	background-color: #F0F0F0;
}
</style>
<script type="text/javascript">
	$(function() {
		// 전체선택 체크박스
		$("#agreeAll").click(function() {
			if($("#agreeAll").prop("checked")) {	// 전체선택 처리
				$(":checkbox").prop("checked", true);
			} else {	// 전체선택 해제
				$(":checkbox").prop("checked", false);
			}
			toggleSubmitButton();
		});
		
		// 개별 체크박스 클릭 시 모두 동의 해제
		$(".agree").click(function() {
			if (!this.checked) {
				$("#agreeAll").prop("checked", false);
			} else {
				let allChecked = true;
				$(".agree").each(function() {
					if (!this.checked) allChecked = false;
				});
				$('#agreeAll').prop('checked', allChecked);
			}
			toggleSubmitButton();
		});

		// 초기 상태에서 '시작하기' 버튼 비활성화
		toggleSubmitButton();

		function toggleSubmitButton() {
			const allChecked = $(".agree").length == $(".agree:checked").length;
			$("#start").prop("disabled", !allChecked);
		}
		
	});	// ready 이벤트 끝
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<article>
		<div id="projecWrap">
			<br><br> 
			<div>
				<h2>창작자님! 이런 준비가 필요합니다.</h2>
				<p>프로젝트를 진행하시려면 아래 내용을 동의해주세요.</p>
			</div>
			<div>
				<div class="agreeChechbox">
					<input type="checkbox" name="agreeAll" id="agreeAll">
					<label for="agreeAll">모두 동의합니다.</label><br>
				</div>
				<hr>
				
				<div class="agreeChechbox">
					<input type="checkbox" name="agree" id="agree1" class="agree">
					<label for="agree1">대표 창작자는 <b>만 19세 이상의 성인</b> 이어야합니다.</label><br>
				</div>
				<div class="agreeChechbox">
					<input type="checkbox" name="agree" id="agree2" class="agree">
					<label for="agree2">위드미에서필요 시 연락 드릴 수 있도록 <b>본인 명의의 휴대폰 번호와 이메일 주소</b>가 필요합니다.</label><br>
				</div>
				<div class="agreeChechbox">
					<input type="checkbox" name="agree" id="agree3" class="agree">
					<label for="agree3">펀딩 성공 후의 정산을 위해 <b>신분증 또는 사업자 등록증, 국내은행 계좌</b>를 준비해주세요.</label><br>
				</div>
				<div class="agreeChechbox">
					<input type="checkbox" name="agree" id="agree4" class="agree">
					<label for="agree4">위드미 요금제에는플랫폼 수수료 <b>5%</b> 가 포함되어 있습니다.<br><a id="commission">(+결제수수료 3%)</a></label><br><br>
				</div>
			</div>
			<hr>
			<div id="button">
				<input type="button" value="돌아가기" id="back" onclick="history.back()">
				<form action="ProjectCreate" method="post">
					<input type="hidden" name="project_category" value="${project_category}">
					<input type="hidden" name="project_title" value="${project_title}">
					<input type="submit" value="시작하기" id="start">
				</form>
			</div>
		</div>
		<br><br>
		
	</article>
<!-- 	<footer> -->
<%-- 		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> --%>
<!-- 	</footer> -->
</body>
</html>
