<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 외부 CSS 파일(css/default.css) 연결하기 --%>
<%-- <link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css"> --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/join_form.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<%-- 다음 우편번호 API --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript">
	// 입력값 검증 결과를 저장할 변수 선언(true : 적합, false : 부적합)
	// => submit 이벤트에서 검사 후 submit 여부 결정
	let checkEmailResult = false;
	let checkPasswdResult = false;
	let checkPasswd2Result = false;
	let checkJuminResult = false;
	let checkTelResult = false;
	// =============================================================
	
	function checkEmail() {
		// 입력받은 이메일 값 가져오기
		let mem_email = $("#mem_email").val();
		
		let regex =  /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
		
		let msg = "";
		let color = "";
		let bgColor = "";

		// 정규표현식 문자열을 관리하는 객체(regex)의 exec() 메서드 호출하여
		// 검사할 문자열을 전달하면 정규표현식 일치 여부 확인 가능
		if(!regex.exec(mem_email)) { // 불일치
			checkEmailResult = false; // 아이디 검사 적합 여부 false(부적합) 값 저장
		} else { // 일치
			checkEmailResult = true; // 아이디 검사 적합 여부 true(적합) 값 저장
		}
		
		
		// 정규표현식 규칙 검사 결과 판별
		// => 불일치 시 불일치 메세지 출력 처리
		// => 일치 시 AJAX 활용하여 아이디 중복 검사 요청 후 결과 처리
		if(!checkEmailResult) {
			msg = "올바른 양식의 이메일을 입력하세요";
			color = "red";
			bgColor = "lightpink";
		} else {
			$.ajax({
				type : "GET",
				url : "MemberCheckDupEmail",
				data : {
					mem_email : $("#mem_email").val()
				},
				success : function(result) {
					console.log("result = " + result);
					if(result.trim() == "true") {
						msg = "이미 사용중인 이메일";
						color = "red";
						bgColor = "lightpink";
					} else if(result.trim() == "false") {
						msg = "사용 가능한 이메일";
						color = "green";
						bgColor = "";
					}
					
					$("#checkEmailResult").text(msg);
					$("#checkEmailResult").css("color", color);
					$("#mem_email").css("background", bgColor);
				}
			});
		}
		
		// AJAX 요청에 대한 코드 실행 시점 문제 발생으로 AJAX 응답 성공 시
		// 기본값 널스트링 값이 저장된 채로 실행되므로 정확한 결과값이 표시되지 않는다!
		// => 따라서, 현재 코드가 AJAX 요청 성공 시 처리하는 success 블럭에도 추가되어야한다!
		
		$("#checkEmailResult").text(msg);
		$("#checkEmailResult").css("color", color);
		$("#mem_email").css("background", bgColor);
		
	}
	
	
	function checkTel() {
		// 입력받은 전화번호 값 가져오기
		let mem_tel = $("#mem_tel").val();
		
		let regex = /^0\d{1,2}(-|\))\d{3,4}-\d{4}$/;

		// 정규표현식 문자열을 관리하는 객체(regex)의 exec() 메서드 호출하여
		// 검사할 문자열을 전달하면 정규표현식 일치 여부 확인 가능
		if(!regex.exec(mem_tel)) { // 불일치
			checkTelResult = false; // 아이디 검사 적합 여부 false(부적합) 값 저장
		} else { // 일치
			checkTelResult = true; // 아이디 검사 적합 여부 true(적합) 값 저장
		}
		
		let msg = "";
		let color = "";
		let bgColor = "";
		
		// 정규표현식 규칙 검사 결과 판별
		// => 불일치 시 불일치 메세지 출력 처리
		// => 일치 시 AJAX 활용하여 아이디 중복 검사 요청 후 결과 처리
		if(!checkTelResult) {
			msg = "양식에 맞게 입력해주세요";
			color = "red";
			bgColor = "lightpink";
		} else {
			$.ajax({
				type : "GET",
				url : "MemberCheckDupTel",
				data : {
					mem_tel : $("#mem_tel").val()
				},
				success : function(result) {
					console.log("result = " + result);
					if(result.trim() == "true") {
						msg = "이미 사용중인 전화번호";
						color = "red";
						bgColor = "lightpink";
					} else if(result.trim() == "false") {
						msg = "사용 가능한 전화번호";
						color = "green";
						bgColor = "";
					}
					
					$("#checkTelResult").text(msg);
					$("#checkTelResult").css("color", color);
					$("#mem_tel").css("background", bgColor);
				}
			});
		}
		
		// AJAX 요청에 대한 코드 실행 시점 문제 발생으로 AJAX 응답 성공 시
		// 기본값 널스트링 값이 저장된 채로 실행되므로 정확한 결과값이 표시되지 않는다!
		// => 따라서, 현재 코드가 AJAX 요청 성공 시 처리하는 success 블럭에도 추가되어야한다!
		
		$("#checkTelResult").text(msg);
		$("#checkTelResult").css("color", color);
		$("#mem_tel").css("background", bgColor);
		
	}
	
	
	// 3. 비밀번호 입력란에 입력 후 빠져나갈 때(blur) 비밀번호 입력값 체크하기
	function checkPasswd() {
		// 패스워드 입력값 가져오기
		let mem_passwd = $("#mem_passwd").val();
		
		// 패스워드 검증 결과 메세지 출력에 사용될 변수 선언
		let msg = "";
		let color = "";
		let bgColor = "";
		
		// 1) 패스워드 길이 및 종류 검증 : 영문자(대소문자), 숫자, 특수문자(!@#$%) 조합 8 ~ 16자리
		let lengthRegex = /^[A-Za-z0-9!@#$%]{8,16}$/;
		
		if(lengthRegex.exec(mem_passwd)) { // 패스워드 길이 검사 적합
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
			
			if(engUpperRegex.exec(mem_passwd)) { count++; } // 대문자 포함
			if(engLowerRegex.exec(mem_passwd)) { count++; } // 소문자 포함
			if(numRegex.exec(mem_passwd)) { count++; } // 숫자 포함
			if(specRegex.exec(mem_passwd)) { count++; } // 특수문자(!@#$%) 포함
			
			// 복잡도 검사 결과 판별하여 id 선택자 checkPasswdComplexResult 영역에 출력
			// 4점 : 안전(초록색 - green)
			// 3점 : 보통(주황색 - orange)
			// 2점 : 위험(빨간색 - red)
			// 1점 이하 : id 선택자 "checkPasswdResult" 에 사용불가 메세지 출력(빨간색)
			let complexityMsg = "";
			let complexityColor = "";
			
			if(count == 4) {
				complexityMsg = "안전";
				complexityColor = "green";
			} else if(count == 3) {
				complexityMsg = "보통";
				complexityColor = "orange";
			} else if(count == 2) {
				complexityMsg = "위험";
				complexityColor = "red";
			} else if(count <= 1) {
				msg = "영문자, 숫자, 특수문자(!@#$%) 조합 8 ~ 16글자";
				color = "red";
				bgColor = "lightpink";
				checkPasswdResult = false; // 패스워드 검사 적합 여부 false(부적합) 값 저장
			}

			if(count >= 2) {
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
		
		if(mem_passwd == mem_passwd2) { // 입력된 두 패스워드가 같은지 판별
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
	//==================================================================================================================
	$(function() {
		// 10. 가입(submit) 클릭 시 이벤트 처리(생략)
// 		$("form").submit(function() {
// 			// 아이디 정규표현식 검사, 패스워드와 패스워드 확인 정규표현식 검사,
// 			// 취미 항목 체크 여부 확인을 통해 해당 항목이 부적합 할 경우 
// 			// 오류메세지 출력 및 submit 동작 취소
// 			if(!checkIdResult) {
// 				alert("아이디 규칙이 적합하지 않습니다!");
// 				$("#mem_id").focus();
// 				return false; // submit 동작 취소
// // 			} else if(!checkPasswdResult) { // 패스워드 검사 결과 확인 생략
// // 				alert("패스워드 규칙이 적합하지 않습니다!");
// // 				$("#passwd").focus();
// // 				return false; // submit 동작 취소
// 			} else if(!checkPasswd2Result) {
// 				alert("패스워드 확인 항목이 일치하지 않습니다!");
// 				$("#mem_passwd2").focus();
// 				return false; // submit 동작 취소
				
// 			} else if(!checkPasswdResult) {
// 				alert("패스워드를 부적합하게 입력했습니다.");
// 				$("#mem_passwd").focus();
// 				return false;
				
// 			} else if(!checkJuminResult) {
// 				alert("주민번호를 부적합하게 입력했습니다.");
// 				$("#mem_jumin").focus();
// 				return false;
			
// 			} else if(!checkTelResult) {
// 				alert("전화번호를 부적합하게 입력했습니다.");
// 				$("#mem_tel").focus();
// 				return false;
			
// 			}
			
			
// 		});
		
		
		// 주소 검색 API 활용 기능 추가
		// "t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
		$("#btnSearchAddress").click(function() {
			new daum.Postcode({
				// 주소검색 창에서 주소 검색 후 검색된 주소를 클릭 시
				// oncomplete 속성 뒤의 익명함수가 실행(호출)됨
				// => 어떤 함수를 실행한 후 해당 함수가 나의 함수를 호출하는 경우
				//    호출되는 나의 함수를 콜백 함수(callback function)라고 함
		        oncomplete: function(data) { 
		            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
		            // => 검색 결과는 모두 익명함수 파라미터 data 에 저장되어 있으므로
		            //    data.xxx 형식으로 검색 결과에 접근 가능함
					// 1) 우편번호(zonecode) 가져와서 우편번호 항목(postCode)에 출력              
		            $("#mem_post_code").val(data.zonecode);
			
					// 2) 기본주소(address) 또는 도로명주소(roadAddress) 가져와서 
					//    기본주소 항목(address1)에 출력
//						$("#address1").val(data.address);
					let address = data.address;
		            
		            // 3) 만약, 건물명(buildingName)이 존재할 경우(= 널스트링이 아님)
		            //    기본 주소 뒤에 건물명 결합
		            if(data.buildingName !== ''){
		               address += "(" + data.buildingName + ")";
		            }
		            
		            // 4) 기본주소(+ 건물명)를 기본주소 항목(address1)에 출력
		            $("#mem_add1").val(address);
		            
		            // 5) 상세주소 항목(address2)에 포커스 요청
		            $("#mem_add2").focus();
		        }
		    }).open();
		});
		
		
	});
	
	//----------------------------------------------------------------------------------------------------
		
		

		
</script>
<style type="text/css">
/* #need { */
/* 	margin-bottom: 20px; */
/* } */

</style>

</head>
<body>	
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/top.jsp"></jsp:include>
	</header>
	<main>
		<div align="center">
			<h4>회원 가입</h4>
			<br>
			<form action="MemberJoinPro" name="joinForm" method="post">
				<div>
					<label for="name">이름</label> 
					<input placeholder="2~5글자의 한글" maxlength="5" type="text" name="mem_name" id="mem_name" required>
					<div id="checkNameResult"></div>
				</div>
				<div>
					<label for="email">이메일</label> 
					<input placeholder="이메일을 입력해주세요" type="text"  name="mem_email" id="mem_email" required onblur="checkEmail()">
					<input type="button" value="이메일 인증" id="emailAuthCodeButton" onclick="sendAuthMail()">
					<div id="checkEmailResult"></div>
				</div>
				<div>
					<label for="passwd">비밀번호</label> 
					<input maxlength="16" placeholder="8~16자의 영문 대/소문자, 숫자, 특수문자(!@#%^&*)" type="password"  name="mem_passwd" id="mem_passwd" required onblur="checkPasswd()">
					<span id="checkPasswdComplexResult"></span>
					<div id="checkPasswdResult"></div>
				</div>
				<div>
					<label for="passwd2">비밀번호 확인</label> 
					<input maxlength="16" placeholder="비밀번호를 다시 입력해주세요" type="password" name="mem_passwd2" id="mem_passwd2" required onblur="checkSamePasswd()">
					<div id="checkPasswd2Result"></div>
				</div>
				<div>
					<label for="address">주소</label>
						<input type="text" name="mem_post_code" id="mem_post_code" size="6" required readonly>
						<input type="button" value="주소검색" id="btnSearchAddress">
						<br>
						<input type="text" name="mem_add1" id="mem_add1" size="30" placeholder="기본주소" required>
						<br>
						<input type="text" name="mem_add2" id="mem_add2" size="30" placeholder="상세주소">
				</div>
				<div>
					<label for="birthday" id="mgForFour">생년월일</label> 
					<input type="text" name="mem_birthday" id="mem_birthday" required>
					<div id="checkBirthdateResult"></div>
				</div>
				<div>
					<label for="tel" id="mgForFive">휴대폰번호</label> 
					<input maxlength="13" placeholder="숫자만 입력해주세요" type="tel" name="mem_tel" id="mem_tel" required onblur="checkTel()">
					<div id="checkTelResult"></div>
				</div>
				<div>
					<button class="btn" type="button" onclick="history.back()">돌아가기</button>
					<button class="btn" type="submit">가입완료</button>
				</div>
				<p class="outer-link">
					이미 계정이 있나요? <a href="MemberLogin">로그인 하기</a>
				</p>
			</form>
		</div>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>















