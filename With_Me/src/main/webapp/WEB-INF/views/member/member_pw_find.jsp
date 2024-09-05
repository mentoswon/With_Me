<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- <link href="${pageContext.request.servletContext.contextPath}/resources/css/main.css" rel="stylesheet" type="text/css"> --%>
<style type="text/css">
#findPw_wrap {
	border: 1px solid #ccc;
	border-radius: 12px;
	padding: 10px 30px;
}
#next {
	padding: 10px 30px;
	border: none;
	border-radius: 12px;
	background-color: #ccc;
}
#next:hover {
	background-color: #59b9a9;
}
#sec02 {
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
				<div id="findPw_wrap">
					<form action="PwFindPro" method="post" id="form01">
						<section id="sec01">
							<table>
								<tr>
									<td id="td01"><h2>비밀번호 재설정</h2></td>
								</tr>
								<tr>
									<td id="td02">찾고자 하는 아이디를 입력해주세요</td>
								</tr>
							</table>
						</section>	
						<section id="sec02">
							<div style="display: flex; justify-content: center;">
								<table>
									<tr>
										<td id="td03">아이디</td>
										<td><input type="text" name="mem_email" id="mem_email" size="10" required="required"></td>
									</tr>
									
									<tr>
									<td id="td04" colspan="2">
										<br><input type="submit" value="다음" id="next">
									</td>
								</tr>
								</table>
							</div>
						</section>
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












