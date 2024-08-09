<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 프로젝트 등록</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/project_create.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	$(function() {
		// 프로젝트 심사 기준 팝업창 버튼 클릭 시 닫힘
		$("#agree").click(function() {
			$("#popupWrap").hide();
		});
		
		// 메뉴 항목 클릭 시 활성화 처리
	    $("#projectMenuList li").click(function() {
	        $("#projectMenuList li").removeClass("active");
	        $(this).addClass("active");
	    });
		
		
	});	// ready 이벤트 끝
</script>
</head>
<body>
	<%-- ---------- 프로젝트 등록 페이지 헤더 ---------- --%>
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
	
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<section id="projectCreateMenu">
		<div id="projectMenuWrap">
			<div id="projectMenuTop">
				<img alt="로고" src="${pageContext.request.contextPath}/resources/image/image.png">
				<div>
					<h2>${project.project_title}</h2>
					<p style="line-height: 200%;">${project.project_category}</p>
				</div>
			</div>
			<div id="projectMenu">
				<ul id="projectMenuList">
					<li class="writeList active">
						<span>기본 정보</span>
					</li>
					<li class="writeList">
						<span>펀딩 계획</span>
					</li>
					<li class="writeList">
						<span>후원 구성</span>
					</li>
					<li class="writeList">
						<span>프로젝트 계획</span>
					</li>
					<li class="writeList">
						<span>창작자 정보</span>
					</li>
				</ul>
			</div>
		</div>
	</section>
	
	<article>
		<div>
			<br>
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 카테고리<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트 성격과 가장 일치하는 카테고리를 선택해주세요.<br>
						적합하지 않을 경우 운영자에 의해 조정될 수 있습니다.
					</p>
				</div>
				<div class="projectContentWrap">
					<select id="projectCategorySelect" class="select">
						<option>푸드</option>
						<option>패션/위생</option>
						<option>식기/급수기</option>
						<option>장난감/훈련</option>
						<option>하우스/안전</option>
					</select>
					<br><br>
					<select id="projectCategoryDetailSelect" class="select">
						<option>사료</option>
						<option>껌류</option>
						<option>수제간식</option>
					</select>
				</div>
			</div>
			
			
			<br><br><br><br><br><br><br><br><br><br><br>
			<h2 align="center">프로젝트 등록 시자악!</h2>
			<br><br><br><br><br><br><br><br><br><br><br>
		</div>
		
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
