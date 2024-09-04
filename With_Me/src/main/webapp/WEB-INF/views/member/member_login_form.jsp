<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/login_form.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<%-- RSA 양방향 암호화 자바스크립트 라이브러리 추가 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rsa.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/jsbn.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/prng4.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rng.js"></script>
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
<script type="text/javascript">
	$(function() {
		// form 태그 submit 이벤트 핸들링
		$("form").submit(function() {
			// ==================== RSA 알고리즘을 활용한 비대칭키 방식 암호화 ===================
			// 자바스크립트 외부 라이브러리를 통해 양방향 암호화를 수행할 RsaKey 객체 생성
			let rsa = new RSAKey();
			// RSAKey 객체의 setPublic() 메서드를 호출하여 전달받은 공개키(Modulus, Exponent)값 전달
			rsa.setPublic("${RSAModulus}", "${RSAExponent}");
			// 입력받은 평문 아이디와 평문 패스워드 암호화 => RSAKey 객체의 encrypt() 메서드 활용
			// => 16진수 문자열로 변환된 암호문을 hidden 속성 value 값으로 저장
			$("#hiddenId").val(rsa.encrypt($("#mem_email").val())); // 아이디에 대한 암호화는 생략 가능
			$("#hiddenPassswd").val(rsa.encrypt($("#mem_passwd").val()));
			
			console.log($("#mem_email").val());
			console.log($("#mem_passwd").val());
			
			// hidden 속성에 암호문 저장 완료 후 자동으로 submit 동작 수행 => Login 비즈니스로직 요청
			// => 전송 과정에서 암호문이 노출되더라도 개인키를 모르면 복호화가 불가능하다.
		});
	});
</script>
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
							<input type="text" id="mem_email" required size="18" value="${cookie.rememberId.value}"><br>
							<input type="checkbox" name="rememberId" style="margin-bottom: 10px;">아이디 저장<br>
							<b>비밀번호</b><br>
							<input type="password" id="mem_passwd" size="18" required>
							<input type="hidden" name="mem_email" id="hiddenId">
							<input type="hidden" name="mem_passwd" id="hiddenPassswd">
						</div>
						<div>
							<input type="submit" value="로그인" id="loginBtn"><br>
							<a onclick="location.href='MemberJoin'" style="font-size: 12px;">회원가입&nbsp;&nbsp;&nbsp;&nbsp;</a>
							<a onclick="location.href='IdFind'" style="font-size: 12px;">아이디 찾기/</a>
							<a onclick="location.href='PasswdFind'" style="font-size: 12px;">비밀번호 찾기</a>
							<input type="button" value="인증메일재발송" onclick="location.href='ReSendAuthMail'">
							<input type="button" value="카카오로그인" onclick="location.href='KakaoLogin'">
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












