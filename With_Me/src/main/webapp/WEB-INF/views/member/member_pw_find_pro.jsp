<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/pw_find_pro.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
#findPw_wrap2 {
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
<script type="text/javascript">
$(function() {
	// 본인인증 요청(cool sms)
	$("#smsBtn").on("click", function(event) {
		
		console.log($("#phone_number").val());
		console.log($("#mem_email").val());
		
		$.ajax({
	        type: 'POST',
	        url: 'PwSendSms',
	        data: { 
	        	"phone_number": $("#phone_number").val().trim().replace(/\D/g, ''), // 하이픈 제거(숫자만 남기기)
				"mem_email" : $("#mem_email").val()
	        },
	        dataType : "json",
	        success: function(response) {
	        	if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
					alert("잘못된 접근입니다!");
				} else if(!response.result) {
	                alert("인증번호 전송에 실패하였습니다.");
				} else if(response.result) {
		            alert("인증코드가 전송되었습니다.\n6자리 인증번호를 입력해주세요.");
		            $("#smsBtn").val("재발송");
		            $("#auth_code").focus();
				}
	        },
	        error: function() {
	            alert("인증코드 전송이 실패했습니다.");
	        }
	    });	// ajax 끝
	});

	// 인증번호 확인
	$("#verifyCode").on("click", function(event) {
	    $.ajax({
	        type: 'POST',
	        url: 'PwVerifyCode',
	        data: { 
	            "phone_number": $("#phone_number").val().trim().replace(/\D/g, ''),
	            "auth_code": $("#auth_code").val(),
	            "mem_email" : $("#mem_email").val()
	        },
	        dataType : "json",
	        success: function(response) {
	        	if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
					alert("잘못된 접근입니다!");
				} else if(!response.result) {
	                alert("인증실패!");
	                $("#auth_code").focus();
	                $("#auth_code").val("");
				} else if(response.result) {
		            alert("인증되었습니다.");
		            location.href = "PwResetFinal?mem_tel=" + $("#phone_number").val();
				}
	        },
	        error: function() {
	            alert("인증에 실패했습니다.");
	        }
	    });
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
			<div id="findPw_wrap2">
				<form action=PwResetPro method="post">
					<input type="hidden" name="mem_email" value="${param.mem_email}" id="mem_email" size="10">
					<input type="hidden" name="mem_tel" value="${param.mem_tel}" id="mem_tel" size="10">
					<section id="sec01">
						<table>
							<tr>
								<td id="td01"><h2>비밀번호 재설정</h2></td>
							</tr>
							<tr>
								<td id="td02">회원정보에 등록한 휴대전화 번호 입력한 전화번호가 같아야 인증번호를 받을 수 있습니다.</td>
							</tr>
						</table>
					</section>	
					<section id="sec02">
						<div style="display: flex; justify-content: center;">
							<table>
								<tr>
									<td id="td04" colspan="3" ><b>이름</b></td>
								</tr>
								<tr>
									<td colspan="3"><input type="text" size="10" maxlength="5"></td>
								</tr>
								<tr>
									<td id="td03" colspan="3"><b>휴대전화번호</b></td>
								</tr>
								<tr>
									<td>
										<select name="CountryCode">
											<option value="+82">+82</option>
										</select>
									</td>
									<td><input type="text" name="phone_number" id="phone_number" size="10"></td>
									<th id="th01" align="left"><input type="button" value="본인인증하기" id="smsBtn"></th>
								</tr>	
								<tr>
									<td colspan="3">
										<input type="text" id="auth_code" placeholder="인증번호를 입력해주세요" maxlength="6">
										<input type="button" value="인증번호확인" id="verifyCode">
									</td>
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












