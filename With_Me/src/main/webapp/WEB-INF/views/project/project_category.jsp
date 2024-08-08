<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 프로젝트 시작하기</title>
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

#updateProjectWrap {
	display: flex;
    justify-content: space-between;
    align-items: center;
	border: 2px solid #ccc;
	border-radius: 10px;
	padding: 10px;
	margin: 10px 0;
}

#projectCategoryWrap {
    max-width: 520px;
}
#projectTitleWrap {
	display: none;
}

#projectCategoryWrap p, #projectTitleWrap p {
	line-height: 300%;	/* 줄간격 */
}

/* ----- 작성중인 프로젝트 ---------- */
#updateProjectWrap img {
	width: 100px;
	height: 100px;
	margin-right: 20px;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#projectContent {
	display: flex;
    justify-content: center;
    align-items: center;
}

/* ----- 프로젝트 카테고리 ----------*/
input[type="radio"] {
	display: none;
}
label {
	display: inline-block;
	border: 1px solid #ccc;
	border-radius: 30px;
	padding: 8px 20px;
	margin: 3px 8px;
	cursor: pointer;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
	width: 100px;
	text-align: center;
}

label.selected {
	background-color: #f0f8ff;
	border: none;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}


/* ----- 프로젝트 제목 ----------*/
#title {
	padding: 10px;
	border-radius: 8px;
/* 	border-color: #ccc; */
}
#titleLengthCheck {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

#titleLengthCheck p {
	font-size: 12px;
	color: #ccc;
}

/* ----- 버튼 ----------*/
#create {
	width: 120px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
	border: none;
	background-color: #flf3f5;
}
#next {	/* 다음 */
	width: 100px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
	border: none;
	background-color: #f0f8ff;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#next:enabled:hover, #create:hover {
	background-color: #f0f8ff;
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

#next:disabled {
	background-color: #f1f3f5;
}
</style>
<script type="text/javascript">
	$(function() {
		// 카테고리 선택 시
		$("input[type='radio']").on("change", function() {
	        // 모든 라벨에서 selected 클래스를 제거
	        $("label").removeClass("selected");
	        
	        // 체크된 라디오 버튼의 for 속성과 일치하는 라벨에 selected 클래스 추가
	        $("label[for='" + $(this).attr("id") + "']").addClass("selected");
	        
	        // 제목 작성 영역 표시
	        $("#projectTitleWrap").show();
	    });
		
		// 프로젝트 제목 글자수 체크
	    $("#title").keyup(function() {
	        let titleLength = $("#title").val().length;
	        $("#titleLength").text(titleLength);
	        if(titleLength < 10) {	// 글자수가 10자 미만인 경우
	        	$("#checkLength").text("10자 이상 입력해주세요.");
	        	$("#checkLength").css("color", "red");
				$("#next").prop("disabled", true); // 다음 버튼 비활성화
			} else if (titleLength > 30) {	// 글자수가 30자 초과한 경우
	        	alert("프로젝트 제목은 30자 까지만 입력 가능합니다!");
			} else {
	        	$("#checkLength").text("");
				$("#next").prop("disabled", false); // 다음 버튼 활성화
			}
	    });
		
		// 초기 상태에서 '다음' 버튼 비활성화
		$("#next").prop("disabled", true);
		
	});	// ready 이벤트 끝
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<article>
		<div>
			<br><br>
			<%-- ------------------------------------------------------ --%>
			<%-- 작성중인 프로젝트 있는지 확인 --%>
			<%-- 있다면 이어서 작성 표시 --%>
			<a style="color: red;">작성중인 프로젝트가 있습니다!</a>
			<div id="updateProjectWrap">
				<div id="projectContent">
					<img alt="로고" src="${pageContext.request.contextPath}/resources/image/image.png">
					<h3>프로젝트 제목</h3>
				</div>
				<input type="button" id="create" value="이어서 작성">
			</div>
			<br><br>
			<%-- ------------------------------------------------------ --%>
			
			
			<%-- ---------- 프로젝트 카테고리 선택 -------------------- --%>
			<form action="ProjectAgree" method="post">
				<div id="projectCategoryWrap">
					<div>
						<h2>멋진 아이디어가 있으시군요!<br>어떤 프로젝트를 계획 중이신가요?</h2>
						<p>카테고리는 나중에 변경 가능합니다.</p>
					</div>
					<div>
						<input type="radio" name="project_category" id="food" value="푸드">
						<label for="food">푸드</label>
						<input type="radio" name="project_category" id="fashion/hygiene" value="패션/위생">
						<label for="fashion/hygiene">패션/위생</label>
						<input type="radio" name="project_category" id="tableware/water supply" value="식기/급수기">
						<label for="tableware/water supply">식기/급수기</label>
						<input type="radio" name="project_category" id="toy/training" value="장난감/훈련">
						<label for="toy/training">장난감/훈련</label>
						<input type="radio" name="project_category" id="house/safety" value="하우스/안전">
						<label for="house/safety">하우스/안전</label>
					</div>
				</div>
				<br><br>
				
				<%-- ---------- 프로젝트 제목 작성 -------------------- --%>
				<div id="projectTitleWrap">
					<h2>프로젝트 제목을 간단하게 입력해주세요.</h2>
					<p>나중에 수정 가능하니 편하게 적어주세요.</p>
					<input type="text" name="project_title" id="title" placeholder="프로젝트 제목을 입력해주세요." maxlength="30" size="70">
					<div id="titleLengthCheck">
						<span id="checkLength"></span>
						<p><span id="titleLength">0</span>/30</p>
					</div>
					<br><hr>
					
					<div align="right">
						<input type="submit" id="next" value="다음">
					</div>
					<br><br>
				</div>
			</form>
		</div>
	</article>
<!-- 	<footer> -->
<%-- 		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> --%>
<!-- 	</footer> -->
</body>
</html>
