<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/login_form.css" rel="stylesheet" type="text/css">
<style type="text/css">
#loginForm {
	border: 1px solid #ccc;
	border-radius: 12px;
	margin: 0 100px;
	padding: 20px;
}
#loginBtn {
	 height: 90px;
	 width: 170px; 
	 margin: 20px 0 10px 0;
	 border: none;
	 border-radius: 12px;
	 background-color: #ccc;
	 font-size: 18px;
}
#loginBtn:hover {
	 background-color: #59b9a9;
}
</style>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section>
			<div style="text-align: center;">
				<h1>로그인</h1>
			</div>
			<div id="loginForm">
				<form action="MemberLoginPro" method="post">
					<div style="display: flex; justify-content: center;">
						<div style="margin-right: 20px;">
							<b>아이디</b><br>
							<input type="text" name="mem_email" required size="18" value="${cookie.rememberId.value}"><br>
							<input type="checkbox" name="rememberId" style="margin-bottom: 10px;">아이디 저장<br>
							<b>비밀번호</b><br>
							<input type="password" name="mem_passwd" size="18" required>
						</div>
						<div>
							<input type="submit" value="로그인" id="loginBtn"><br>
							<a onclick="location.href='MemberJoin'" style="font-size: 12px;">회원가입&nbsp;&nbsp;&nbsp;&nbsp;</a>
							<a onclick="location.href='IdFind'" style="font-size: 12px;">아이디 찾기/</a>
							<a onclick="location.href='PasswdFind'" style="font-size: 12px;">비밀번호 찾기</a>
						</div>
					</div>
				</form>	
			</div>
		</section>
	</main>
	
	
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












