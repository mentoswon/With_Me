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
			<h1 align="center">내 정보</h1>
			<form action="MemberModify" name="joinForm" method="post">
				<section class="joinForm1">
					<table id="tb01">
						<tr>
							<td>프로필 사진</td>
						</tr>
						<tr>
							<td>
								<img
									src="${pageContext.request.contextPath}/resources/upload/${creator.creator_image}"
									id="img1" class="car_image" selected>
							</td>
						</tr>
						<tr>
							<td class="td_right">
								<%-- 파일명 존재 여부 판별 --%>
								<%-- 
								<c:forEach> 태그를 활용하여 fileList 객체의 요소 갯수만큼 반복
								=> varStatus 속성을 지정하여 요소 인덱스값 또는 요소 순서번호 확인 가능
								   (요소 인덱스 : 속성명.index   요소 순서번호 : 속성명.count)
								--%>
								<c:forEach var="fileName" items="${fileList}" varStatus="status">
									<%-- div 태그로 파일 1개의 영역 지정(파일 항목 구분을 위해 class 선택자 뒤에 번호 결합 --%>
									<div class="file file_item_${status.count}">
										<c:choose>
											<c:when test="${not empty fileName}">
												<%-- 파일 삭제 링크(이미지) 생성(개별 삭제 위함) --%>
												<%-- 삭제 아이콘 클릭 시 deleteFile() 함수 호출(파라미터 : 글번호, 파일명, 카운팅번호) --%>
												<a href="javascript:deleteFile(${memberInfo.mem_idx}, '${fileName}', ${status.count})">
													<img src="${pageContext.request.contextPath}/resources/image/delete-icon.png" class="img_btn_delete" title="파일삭제">
												</a>
												<%-- 파일명만 표시하는 경우에도 파일업로드 요소 생성하여 파라미터는 전달되도록 하기 --%>
												<%-- 단, 사용자에게 보이지 않도록 숨김 처리를 위해 hidden 속성 적용 --%>
												<input type="file" name="file${status.count}" hidden>
											</c:when>
											<c:otherwise>
												<%-- 
												파일명이 존재하지 않을 경우 파일 업로드 항목 표시
												=> name 속성값을 다르게 부여하기 위해 
												   file 문자열과 카운팅을 위한 값 ${status.count} 결합하여 name 지정
												   (ex. "file" + 1 = "file1") 
												--%>
												<%--  --%>
												<input type="file" name="file${status.count}">
											</c:otherwise>
										</c:choose>
									</div>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td>이름</td>
						</tr>
						<tr>
							<td><input type="text" name="mem_name" id="mem_name" value="${member.mem_name}" pattern="^[가-힣]{2,5}$" title="한글 2-5글자"></td>
						</tr>	
						<tr>
							<td>이메일</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="mem_email" id="mem_email" value="${member.mem_email}" placeholder="이메일입력" onblur="checkEmail()">
								<div id="checkEmailResult"></div>
							</td>
						</tr>	
						<tr>
							<td>비밀번호</td>
						</tr>
						<tr>
							<td>
								<input type="password" name="mem_passwd" id="mem_passwd" size="25" onblur="checkPasswd()">
								<span id="checkPasswdComplexResult"></span>
								<div id="checkPasswdResult"></div>
							</td> 
						</tr>	
						<tr>
							<td>비밀번호확인</td>
						</tr>
						<tr>	
							<td>
								<input type="password" name="mem_passwd2" id="mem_passwd2" size="25" onblur="checkSamePasswd()">
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
								<input type="button" id="update" value="정보수정" onclick="location.href=''">
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















