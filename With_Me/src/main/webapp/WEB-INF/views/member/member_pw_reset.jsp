<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/pw_find.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>

<script type="text/javascript">
		let checkPasswdResult = false;
		let checkPasswd2Result = false;
		
		function checkPasswd() {
		// 패스워드 입력값 가져오기
		let mem_passwd = $("#mem_passwd").val();

		// 패스워드 검증 결과 메세지 출력에 사용될 변수 선언
		let msg = "";
		let color = "";
		let bgColor = "";

		// 1) 패스워드 길이 및 종류 검증 : 영문자(대소문자), 숫자, 특수문자(!@#$%) 조합 8 ~ 16자리
		let lengthRegex = /^[A-Za-z0-9!@#$%]{8,16}$/;

		if (lengthRegex.exec(mem_passwd)) { // 패스워드 길이 검사 적합
			// 2) 패스워드 복잡도(안전도) 검사
			//    => 영문 대문자 or 소문자 or 숫자 or 특수문자(!@#$%) 중 최소 2가지 이상 조합
			//    => 단, 부분 검사를 수행하므로 시작(^)과 끝($) 기호는 제외하고 표현식 작성
			// 2-1) 영문자 대문자 검사 규칙
			let engUpperRegex = /[A-Z]/;
			// 2-2) 영문자 소문자 검사 규칙
			let engLowerRegex = /[a-z]/;
			// 2-3) 숫자 검사 규칙
			let numRegex = /\d/; // /[0-9]/ 동일
			// 2-4) 특수문자(!@#$%) 검사 규칙
			let specRegex = /[!@#$%]/;

			// 각 규칙에 대한 부분 검사를 통해 일치하는 항목 카운팅 변수 선언
			// => 일치하는 규칙마다 +1 처리
			let count = 0;

			if (engUpperRegex.exec(mem_passwd)) {
				count++;
			} // 대문자 포함
			if (engLowerRegex.exec(mem_passwd)) {
				count++;
			} // 소문자 포함
			if (numRegex.exec(mem_passwd)) {
				count++;
			} // 숫자 포함
			if (specRegex.exec(mem_passwd)) {
				count++;
			} // 특수문자(!@#$%) 포함

			// 복잡도 검사 결과 판별하여 id 선택자 checkPasswdComplexResult 영역에 출력
			// 4점 : 안전(초록색 - green)
			// 3점 : 보통(주황색 - orange)
			// 2점 : 위험(빨간색 - red)
			// 1점 이하 : id 선택자 "checkPasswdResult" 에 사용불가 메세지 출력(빨간색)
			let complexityMsg = "";
			let complexityColor = "";

			if (count == 4) {
				complexityMsg = "안전";
				complexityColor = "green";
			} else if (count == 3) {
				complexityMsg = "보통";
				complexityColor = "orange";
			} else if (count == 2) {
				complexityMsg = "위험";
				complexityColor = "red";
			} else if (count <= 1) {
				msg = "영문자, 숫자, 특수문자(!@#$%) 조합 8 ~ 16글자";
				color = "red";
				bgColor = "lightpink";
				checkPasswdResult = false; // 패스워드 검사 적합 여부 false(부적합) 값 저장
			}

			if (count >= 2) {
				$("#checkPasswdComplexResult").text(complexityMsg);
				$("#checkPasswdComplexResult").css("color", complexityColor);
				checkPasswdResult = true; // 패스워드 검사 적합 여부 true(적합) 값 저장
			}

		} else { // 패스워드 길이 검사 부적합
			msg = "영문자, 숫자, 특수문자(!@#$%) 조합 8 ~ 16글자";
			color = "red";
			bgColor = "lightpink";

			checkPasswdResult = false; // 패스워드 검사 적합 여부 false(부적합) 값 저장
		}

		$("#checkPasswdResult").text(msg);
		$("#checkPasswdResult").css("color", color);
		$("#mem_passwd").css("background", bgColor);
	}

	// 4. 비밀번호확인 입력란에 키를 누를때마다 비밀번호와 같은지 체크하기
	function checkSamePasswd() {
		let mem_passwd = document.joinForm.mem_passwd.value; // 패스워드
		let mem_passwd2 = document.joinForm.mem_passwd2.value; // 패스워드 확인

		if (mem_passwd == mem_passwd2) { // 입력된 두 패스워드가 같은지 판별
			// 옆쪽 빈 공간(span 태그 영역)에 "비밀번호 일치" 초록색으로 표시
			// 아니면, "비밀번호 불일치" 빨간색으로 표시
			document.querySelector("#checkPasswd2Result").innerText = "비밀번호 일치";
			document.querySelector("#checkPasswd2Result").style.color = "BLUE";
			checkPasswd2Result = true; // 패스워드 확인 검사 적합 여부 true(적합) 값 저장
		} else {
			document.querySelector("#checkPasswd2Result").innerText = "비밀번호 불일치";
			document.querySelector("#checkPasswd2Result").style.color = "RED";
			checkPasswd2Result = false; // 패스워드 확인 검사 적합 여부 false(부적합) 값 저장
		}
	}
	
	$(function() {
		// 가입(submit) 클릭 시 이벤트 처리(생략)
		$("form").submit(function() {
			// 아이디 정규표현식 검사, 패스워드와 패스워드 확인 정규표현식 검사,
			// 취미 항목 체크 여부 확인을 통해 해당 항목이 부적합 할 경우 
			// 오류메세지 출력 및 submit 동작 취소
			if(!checkPasswdResult) {
				alert("패스워드를 부적합하게 입력했습니다.");
				$("#mem_passwd").focus();
				return false; // submit 동작 취소
				
			} else if(!checkPasswd2Result) {
				alert("패스워드 확인 항목이 일치하지 않습니다!");
				$("#mem_passwd2").focus();
				return false;
			}
		});
	});
	
	
	//========================================================================================================
</script>
<style type="text/css">
#findPw_wrap3 {
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
			<div id="findPw_wrap3">
				<form action="PwResetFinal" name="joinForm" method="post">
					<input type="hidden" name="mem_tel" value="${dbMember.mem_tel}" id="mem_tel" size="10">	
					<input type="hidden" name="mem_id" value="${dbMember.mem_id}" id="mem_tel" size="10">	
					<section id="sec01">
						<table>
							<tr>
								<td id="td01"><h2>비밀번호 재설정</h2></td>
							</tr>
						</table>
					</section>	
					<section id="sec02">
						<div style="display: flex; justify-content: center;">
							<table>
								<tr>
									<td id="td03">새 비밀번호</td>
									<td>
										<input type="password" name="mem_passwd" id="mem_passwd" size="15" maxlength="10" onblur="checkPasswd()" required>
										<span id="checkPasswdComplexResult"></span>
										<div id="checkPasswdResult"></div>
									</td>
								</tr>
								<tr>
									<td id="td04">새 비밀번호 확인</td>
									<td>
										<input type="password" name="mem_passwd2" id="mem_passwd2" size="15" maxlength="10" onblur="checkSamePasswd()" required>
										<div id="checkPasswd2Result"></div>
									</td>
								</tr>
								<tr>
									<td id="td04" colspan="2" align="center">
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












