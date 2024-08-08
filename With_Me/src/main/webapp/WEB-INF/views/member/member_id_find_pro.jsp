<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/id_find.css" rel="stylesheet" type="text/css">
<style type="text/css">
#findId_wrap {
	border: 1px solid #ccc;
	border-radius: 12px;
	padding: 10px 30px;
}
#moveLogin {
	padding: 10px 30px;
	border: none;
	border-radius: 12px;
	background-color: #ccc;
}
#moveLogin:hover {
	background-color: #59b9a9;
}
#findId_wrap_ {
	background-color: #f1f3f5;
	border-radius: 12px;
	margin: 10px 60px;
	padding: 10px;
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
			<h1 align="center">회원으로 등록된 아이디입니다.</h1>
			<div id="findId_wrap_" style="display: flex; justify-content: center;">
				<table id="table01">
					<tr>
						<td>아이디 : </td><td>${dbMember.mem_email}</td>
<%-- 							<td><input type="text" name="id_name" value="${sessionScope.sId}" required="required" size="15"></td> --%>
					</tr>
					<tr>
						<td>가입일 : </td><td>${dbMember.mem_sign_date}</td>
					</tr>	
					<tr>
						<td colspan="2" align="center">
							<br>
							<input type="button" value="로그인하러 가기" onclick="location.href='MemberLogin'" id="moveLogin">
<!-- 						<input type="button" value="다음" onclick="location.href='MemberJoin_two'"> -->
<!-- 						<input type="button" value="돌아가기" onclick="history.back()"> -->
						</td>
					</tr>
				</table>
			</div>
		</section>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












