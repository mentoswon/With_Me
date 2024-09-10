<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/id_find.css" rel="stylesheet" type="text/css">
<style type="text/css">
#findId_wrap {
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
			<div id="findId_wrap" align="center">
				<form action=IdFindPro method="post">
					<section id="sec01">
						<table>
							<tr>
								<td id="td01"><h2>아이디 찾기</h2></td>
							</tr>
							<tr>
								<td id="td02">위드미는 이메일을 아이디로 사용합니다.<br>
											소유하고 계신 계정을 입력해보세요.<br>
											가입여부를 확인해드립니다.
								</td>
							</tr>
						</table>
					</section>	
					<section id="sec02">
						<div style="display: flex; justify-content: center;">
							<table>
								<tr>
									<td><input type="text" name="mem_email" id="mem_email" size="10" required="required" placeholder="이메일 계정"></td>
								</tr>	
								<tr>
								<td id="td05" align="center" colspan="3">
									<br><input type="submit" value="다음" id="next">
		<!-- 						<input type="button" value="다음" onclick="location.href='MemberJoin_two'"> -->
		<!-- 						<input type="button" value="돌아가기" onclick="history.back()"> -->
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












