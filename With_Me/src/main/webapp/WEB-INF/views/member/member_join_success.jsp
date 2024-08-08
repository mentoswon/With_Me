<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
.btn {
	border: none;
	border-radius: 12px;
	padding: 15px 30px;
	margin: 10px;
}
#joinFinish {
	border: 1px solid #ccc;
	border-radius: 12px;
	padding: 30px 0 50px 0;
	margin: 60px 120px;
}

</style>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section id="joinFinish">
			<div>
				<h1 align="center">회원 가입 완료</h1>
				<div align="center">
					<input type="button" value="홈으로" onclick="location.href='./'" class="btn" style="background-color: #ccc;">
					<input type="button" value="로그인"
						onclick="location.href='MemberLogin'" class="btn" style="background-color: #59b9a9;">
				</div>
			</div>
		</section>
	</main>
	
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












