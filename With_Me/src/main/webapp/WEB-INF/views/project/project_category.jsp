<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
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

#updateProjectWrap, #projectCategoryWrap, #projectTitleWrap {
    max-width: 550px;
    box-sizing: border-box;
}
#projectTitleWrap {
	display: none;
}

#projectCategoryWrap p, #projectTitleWrap p {
	line-height: 300%;	/* 줄간격 */
}

/* ----- 작성중인 프로젝트 ---------- */
#updateProjectWrap img {
	width: 120px;
	height: 100px;
	margin-right: 20px;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#projectContent {
	display: flex;
    justify-content: center;
    align-items: center;
}
#projectContent h3 {
	text-align: left;
}

.importanceImg img {
	width: 22px;
	height: 22px;
	vertical-align: text-bottom;	/* 글자와 정렬 맞추기 */
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
	color: #fff;
	background-color: #FFAB40;
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
#create {	/* 이어서 작성 */
	width: 120px;
	height: 40px;
	margin: 0 10px 0 20px;
	border-radius: 10px;
	border: none;
	background-color: #F0F0F0;
}
#next {	/* 다음 */
	width: 100px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
	border: none;
	background-color: #FFAB40;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
	color: #fff;
}

#next:enabled:hover, #create:hover {
	background-color: #FFAB40;
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
	color: #fff;
}

#next:disabled {
	background-color: #F0F0F0;
}
/* ======================================================== */
/* Mobile Responsive CSS */
@media screen and (max-width: 768px) {
	article>div {
		width: 100%;
	}
	/* 이어서 작성하기 영역 */
	.importanceImg {margin-left: 15px;}
	#updateProjectWrap {
		width: 95%;
		margin: 8px auto;
		display: block;
	}
	#projectContent {
		display: block;
		text-align: center;
	}
	#updateProjectWrap img {
        width: 100%;
        height: 230px;
	    margin: 5px auto;
	}
	#create {
		width: 90%;
		text-align: center;
		background-color: #FFAB40;
		color: #fff;
		margin-top: 10px;
	}
	
	/* 카테고리 선택 영역 */
	#projectCategoryWrap, #projectTitleWrap {
		width: 95%;
	    margin: 0 auto;
	}
	
	#title {
		width: 93%;
	}
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
			<%-- 작성중인 프로젝트 있는지 확인(있다면 이어서 작성 표시) --%>
			<c:if test="${not empty project}">
				<a style="color: red;">
					<span class="importanceImg">
						<img alt="주의사항 아이콘" src="${pageContext.request.contextPath}/resources/image/importance_icon.png">
					</span>
					작성중인 프로젝트가 있습니다!
				</a>
				<div id="updateProjectWrap">
					<div id="projectContent">
						<c:choose>
							<c:when test="${empty project[0].project_image}">
								<img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
							</c:when>
							<c:otherwise>
								<img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project[0].project_image}">
							</c:otherwise>
						</c:choose>
						<h3>${project[0].project_title}</h3>
					</div>
					<div>
						<form action="ProjectCreate" method="post">
							<input type="hidden" name="project_idx" value="${project[0].project_idx}">
							<input type="submit" id="create" value="이어서 작성">
						</form>
					</div>
				</div>
				<br><br>
			</c:if>
			<%-- ------------------------------------------------------ --%>
			
			
			<%-- ---------- 프로젝트 카테고리 선택 -------------------- --%>
			<form action="ProjectAgree" method="post">
				<div id="projectCategoryWrap">
					<div>
						<h2>멋진 아이디어가 있으시군요!<br>어떤 프로젝트를 계획 중이신가요?</h2>
						<p>카테고리는 나중에 변경 가능합니다.</p>
					</div>
					<div>
						<c:forEach var="category" items="${category}">
							<input type="radio" name="project_category" id="${category.common_code}" value="${category.common_code}">
							<label for="${category.common_code}">${category.common_code_name}</label>
						</c:forEach>
						
<!-- 						<input type="radio" name="project_category" id="food" value="푸드"> -->
<!-- 						<label for="food">푸드</label> -->
<!-- 						<input type="radio" name="project_category" id="fashion/hygiene" value="패션/위생"> -->
<!-- 						<label for="fashion/hygiene">패션/위생</label> -->
<!-- 						<input type="radio" name="project_category" id="tableware/waterSupply" value="식기/급수기"> -->
<!-- 						<label for="tableware/waterSupply">식기/급수기</label> -->
<!-- 						<input type="radio" name="project_category" id="toy/training" value="장난감/훈련"> -->
<!-- 						<label for="toy/training">장난감/훈련</label> -->
<!-- 						<input type="radio" name="project_category" id="house/safety" value="하우스/안전"> -->
<!-- 						<label for="house/safety">하우스/안전</label> -->
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
