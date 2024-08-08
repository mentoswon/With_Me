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
#projectStartWrap {
	text-align: center;
}

#projectStartWrap p {
	line-height: 300%;	/* 줄간격 */
}

/* ----- 버튼 ----- */
.projectStartButton {
	width: 150px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
}

#startNow {	/* 지금 시작하기 */
	border: none;
	background-color: #f0f8ff;
/* 	color: #ffffff; */
}
#creatorGuide {	/* 창작자 가이드 */
	background-color: #ffffff;
	border: 1px solid #ccc;
}
</style>

<script type="text/javascript">
// function creatorGuide() {
// 	// 창작자 가이드 새 창 열기
// 	let authWindow = window.open("about:blank", "authWindow", "width=500,height=700");
// }	
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<article>
		<br><br><br><br><br><br>
		<div id="projectStartWrap">
			<div>
				<h2>누구나 쉽고 빠르게<br>프로젝트를 시작할 수 있습니다.</h2>
				<p>내 반려와 함께하는 위드미..</p>
			</div>
			<div>
				<input type="button" id="startNow" class="projectStartButton" value="지금 시작하기" onclick="location.href='ProjectCategory'">
				<input type="button" id="creatorGuide" class="projectStartButton" value="창작자 가이드" onclick="creatorGuide()">
			</div>
		</div>
		<br><br><br><br><br><br>
	</article>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>