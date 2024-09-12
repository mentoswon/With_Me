<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#writeForm {
		border: 1px solid #ccc;
		border-radius: 12px;
		padding: 10px 30px;
		width: 400px;
		display: flex;
		justify-content: center;
		margin: 20px auto; /* 가운데 정렬을 위해 추가 */
		background-color: #fff; /* 배경색상 추가 */
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 추가 */
	}
	
	#writeForm h1 {
		text-align: center; /* 제목 가운데 정렬 */
		margin-bottom: 20px; /* 제목과 내용 사이 간격 */
	}
	
	#writeForm form {
		margin-top: 20px; /* 폼 상단 여백 */
	}
	
	#writeForm table {
		width: 100%; /* 테이블 너비 100%로 설정 */
	}
	
	#writeForm label {
		display: block;
		margin-bottom: 8px;
		color: #333; /* 라벨 텍스트 색상 */
	}
	
	#writeForm input[type="text"],
	#writeForm textarea{
		width: calc(100% - 20px); /* 입력 요소 너비 */
		padding: 10px;
		margin-bottom: 15px;
		border: 1px solid #ccc;
		border-radius: 5px;
	}
	
	#commandCell {
		text-align: center;
		height: auto;
	}
	
	#writeForm input[type="submit"],
	#writeForm input[type="button"] {
		background-color: #ffab40; /* 버튼 배경색 */
		color: #fff; /* 버튼 텍스트 색상 */
		border: none;
		padding: 10px 20px;
		cursor: pointer;
		border-radius: 5px;
		transition: background-color 0.3s;
	}
	
	#writeForm input[type="submit"]:hover,
	#writeForm input[type="button"]:hover{
		background-color: #ccaa20; /* 버튼 호버 배경색 */
	}
	section {
		min-height: 80px;
	}
	
	.replyArea {
		border: 1px solid gray;
	    background-color: #f9f9f9;
	    font-size: 12px;
	}
	textarea {
	    resize: none;
	    outline: none; /* 클릭 시 외부 테두리 제거 */
	}
	
	textarea:focus {
	    border: 1px solid gray; /* 클릭 시에도 동일한 테두리 유지 */
	}
</style>
</head>
<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section>
			<!-- 게시판 등록 -->
			<article id="writeForm">
				<div>
					<h1>1:1 문의 답변</h1>
					<form action="AdminFAQReply" name="writeForm" method="post">
						<input type="hidden" name="faq_idx" value="${faq.faq_idx}">
						<table>
							<tr>
								<td>작성자</td>
							</tr>
							<tr>
								<td>
									<input type="text" name="mem_name" value="${member.mem_name}(${member.mem_email})" size="15" readonly>
								</td>
							</tr>
							<tr>
								<td class="write_td_left"><label for="faq_subject">제목</label></td>
							</tr>
							<tr>
								<td class="write_td_right"><input type="text" id="faq_inquery" value="${faq.faq_subject}" size="35" readonly></td>
							</tr>
							<tr>
								<td class="write_td_left"><label for="faq_content">내용</label></td>
							</tr>
							<tr>
								<td class="write_td_right">
									<textarea id="qna_content" name="faq_content" rows="10" cols="40" readonly>${faq.faq_content}</textarea>
								</td>
							</tr>
							<tr>
								<td class="write_td_left"><label for="faq_content">답변</label></td>
							</tr>
							<tr>
								<td class="write_td_right">
									<c:choose>
										<c:when test="${faq.faq_reply != null && faq.faq_reply != ''}">
											<textarea name="faq_reply" rows="10" cols="40" class="replyArea">${faq.faq_reply}</textarea>
										</c:when>
										<c:otherwise>
											<textarea name="faq_reply" rows="10" cols="40" class="replyArea"></textarea>
										</c:otherwise>
									</c:choose>
								</td>
							</tr>
						</table>
						<section id="commandCell">
							<c:choose>
								<c:when test="${faq.faq_reply != null && faq.faq_reply != ''}">
									<input type="hidden" name="replyType" value="수정">
									<input type="submit" value="답변수정">
								</c:when>
								<c:otherwise>
									<input type="hidden" name="replyType" value="작성">
									<input type="submit" value="답변작성">
								</c:otherwise>
							</c:choose>
							<input type="button" value="목록" onclick="location.href='AdminFAQ'">
						</section>
					</form>
				</div>
			</article>
		</section>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>




