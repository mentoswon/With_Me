<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
#projectSubmitWrap {
	text-align: center;
}

#projectSubmitWrap p {
	line-height: 300%;	/* 줄간격 */
}

/* ----- 버튼 ----- */
.button {
	width: 150px;
	height: 40px;
	margin: 10px;
	border-radius: 10px;
}

#main_page {	/* 메인 페이지로 */
	background-color: #ffffff;
	border: 2px solid #ccc;
}
#my_project {	/* 내가 만든 프로젝트 */
	border: none;
	background-color: #FFAB40;
 	color: #ffffff;
}

input[type="button"]:hover {
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

</style>

</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<article>
		<br><br><br><br><br><br>
		<div id="projectSubmitWrap">
			<div>
				<h2>프로젝트 제출이 완료되었습니다!</h2>
				<p>심사결과는 이틀내로 알려드립니다.</p>
			</div>
			<div>
				<input type="button" id="main_page" class="button" value="메인 페이지로" onclick="location.href='./'">
				<input type="button" id="my_project" class="button" value="내가 만든 프로젝트" onclick="location.href='MyProject'">
			</div>
		</div>
		<br><br><br><br><br><br>
	</article>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>