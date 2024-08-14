<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<article>
		<div align="center">
			<h1>인증메일 재발송</h1>
			<form action="ReSendAuthMail" method="post">
<!-- 				<input type="text" name="id" placeholder="아이디" required><br> -->
				<%-- 쿠키에 저장된 "rememberId" 속성의 쿠키값을 아이디 입력창에 표시 --%>
				<%-- EL 문법에서 내장객체 cookie의 rememberID 속성의 쿠키값을 표시 --%>
				<%-- 기본문법 : ${cookie.쿠키명.value} --%>
				<input type="text" name="mem_email" placeholder="아이디" required><br>
				<input type="text" name="mem_email" placeholder="E-Mail" required><br>
				<input type="submit" value="재발송">
			</form>	
		</div>
	</article>
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












