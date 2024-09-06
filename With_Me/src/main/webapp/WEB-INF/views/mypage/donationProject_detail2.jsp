<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 외부 CSS 파일(css/default.css) 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<%-- RSA 양방향 암호화 자바스크립트 라이브러리 추가 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rsa.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/jsbn.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/prng4.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rng.js"></script>
<%-- 다음 우편번호 API --%>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>

	body {
	    font-family: Arial, sans-serif;
	    background-color: #f9f9f9;
	    margin: 0;
	    padding: 0;
	    text-align: center; /* body 내 모든 내용 중앙 정렬 */
	}
	
	article {
	    display: inline-block; /* 중앙 정렬을 위해 inline-block 사용 */
	    background-color: #fff;
	    padding: 20px;
	    border-radius: 10px;
	    box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
	    max-width: 600px;
	    width: 100%;
	    margin-top: 20px;
	    text-align: left; /* article 내 텍스트 왼쪽 정렬 */
	}
    
    h1 {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
    }
    td {
        padding: 5px;
    }
    input[type="text"],
    input[type="password"],
    input[type="button"],
    input[type="reset"] {
/*         width: calc(100% - 20px); */
        padding: 10px;
        margin: 5px 0;
        border-radius: 5px;
        border: 1px solid #ccc;
        font-size: 14px;
    }
	input[type="submit"] {
/*  	        width: calc(100% - 20px); */
 	        padding: 10px; 
 	        margin: 5px 0; 
 	        border-radius: 5px; 
 	        border: 1px solid #ccc; 
 	        font-size: 14px; 
 	}
 	
 	.img_btn_delete {
		width: 10px;
		height: 10px;
	}
</style>
</head>
<body>	
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<article>
			<form action="MyPageInfoModify" name="joinForm" method="post">
				<section class="joinForm1">
						<table id="tb01">
							<tr>
								<td>사진</td>
								<td>${DonationProjectDetail.project_title}</td>
							</tr>
							<tr>
							</tr>	
							<tr>
								<td>목표금액</td>
							</tr>
							<tr>
								<td>${DonationProjectDetail.target_price}</td>
							</tr>	
							<tr>
								<td>기존 비밀번호</td>
							</tr>
							<tr>
								<td>
									<input type="password" name="old_mem_passwd" id="old_mem_passwd" size="10" onblur="checkPasswd()">
								</td> 
							</tr>	
							<tr>
								<td>새 비밀번호</td>
							</tr>
							<tr>
								<td>
									<input type="password" name="mem_passwd" id="mem_passwd" size="10" onblur="checkPasswd()">
									<span id="checkPasswdComplexResult"></span>
									<div id="checkPasswdResult"></div>
								</td> 
							</tr>	
							<tr>
								<td>새 비밀번호확인</td>
							</tr>
							<tr>	
								<td>
									<input type="password" name="mem_passwd2" id="mem_passwd2" size="10" onblur="checkSamePasswd()">
									<div id="checkPasswd2Result"></div>
								</td>
							</tr>	
							<tr>
								<td>주소</td>
							</tr>
							<tr>
								<td>
									<input type="text" name="mem_post_code" id="mem_post_code" value="${member.mem_post_code}" size="6" readonly>
									<input type="button" value="주소검색" id="btnSearchAddress">
									<br>
									<input type="text" name="mem_add1" id="mem_add1" value="${member.mem_add1}" size="30" placeholder="기본주소">
									<br>
									<input type="text" name="mem_add2" id="mem_add2" value="${member.mem_add2}" size="30" placeholder="상세주소">
								</td>
							</tr>	
							<tr>
								<td>생년월일</td>
							</tr>
							<tr>
								<td id="tdjumin">(생년월일 6자리를 입력해주세요)</td>
							</tr>
							<tr>
								<td><input type="text" name="mem_birthday" maxlength=6 id="mem_birthday" value="${member.mem_birthday}" maxlength="14" required="required" onblur="checkBirth()">
									<div id="checkBirthResult"></div>
								</td>
							</tr>
							<tr>
								<td>휴대폰 번호</td>
							</tr>
							<tr>
								<td id="tdtel">(휴대폰 번호를 입력 시 "-"를 입력해주세요)</td>
							</tr>
							<tr>
								<td><input type="text" name="mem_tel" id="mem_tel" value="${member.mem_tel}" maxlength="13" required="required" onblur="checkTel()">
									<div id="checkTelResult"></div>
								</td>
							</tr>	
							<tr>
								<td colspan="2" align="center">
									<input type="submit" value="정보수정">
									<input type="reset" value="초기화">
									<input type="button" value="돌아가기" onclick="history.back()">
								</td>
							</tr>
							<tr>
								<td colspan="2" align="center">
									<input type="button" value="회원탈퇴" onclick="location.href='MemberWithdraw'">
								</td>
							</tr>
						</table>
				</section>
			</form>
		</article>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>















