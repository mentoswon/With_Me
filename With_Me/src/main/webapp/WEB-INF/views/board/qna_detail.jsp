<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 게시물</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	body {
		font-family: Arial, sans-serif;
		margin: 0;
		padding: 0;
	}

	#articleForm {
		width: 500px;
		height: auto;
		margin: 20px auto;
		padding: 20px;
		border: 1px solid #ddd;
		background-color: #fff;
		border-radius: 8px;
		box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	}

	h2 {
		text-align: center;
	}

	table {
		width: 100%;
		border-collapse: collapse;
		margin: 20px 0;
	}

	th, td {
		border: 1px solid #ddd;
		padding: 10px;
	}

	th {
		background-color: #FFAB40;
		color: white;
	}

	td {
		background-color: #f9f9f9;
	}

	#basicInfoArea {
		margin: 10px 0;
	}

	#articleContentArea {
		background-color: #fff;
		margin-top: 10px;
		padding: 15px;
		border: 1px solid #ddd;
		border-radius: 8px;
		overflow: auto;
		white-space: pre-line;
		color: #333;
	}

	#commandCell {
		text-align: center;
		margin-top: 20px;
	}

	#commandCell input[type="button"] {
		background-color: #FFAB40;
		color: white;
		border: none;
		padding: 10px 20px;
		margin: 5px;
		border-radius: 5px;
		cursor: pointer;
	}

	#commandCell input[type="button"]:hover {
		background-color: #d07601;
	}
</style>
<script type="text/javascript">
	function confirmDelete() {
		// 삭제 버튼 클릭 시 확인창(confirm dialog)을 통해 "삭제하시겠습니까?" 출력 후
		// 다이얼로그의 확인 버튼 클릭 시 "BoardDelete.bo" 서블릿 요청
		// => 파라미터 : 글번호, 페이지번호
		if(confirm("삭제하시겠습니까?")) {
			location.href = "QnaBoardDelete?faq_idx=${qnabo.faq_idx}&pageNum=${param.pageNum}";
		}
	}
</script>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<!-- 게시판 상세내용 보기 -->
		<section id="articleForm">
			<h2>1:1 문의글 상세내용 보기</h2>
			<section id="basicInfoArea">
<%-- 				<input type="hidden" value="${qnabo.mem_email}"> --%>
				<table border="1">
				<tr><th width="70">제 목</th><td colspan="3">${qnabo.faq_subject}</td></tr>
				<tr>
					<th width="70">작성자</th><td>${qnabo.mem_name}</td>
					<%-- 작성일시 출력 형식은 ex) 2024-06-04 12:30 --%>
					<th width="70">작성일시</th>
					<td><fmt:formatDate value="${qnabo.faq_date}" pattern="yyyy-MM-dd"/></td>
				</tr>
				<tr>
					<th colspan="4">문의내용</th>
				</tr>
				<tr>
					<td colspan="4" style="height: 100px;">${qnabo.faq_content}</td>
				</tr>
				</table>
				<!-- 답변 영역 -->
				<%-- 답글, 수정, 삭제 버튼은 로그인 한 사용자에게만 표시 --%>
				<%-- 단, 수정, 삭제 버튼은 세션 아이디와 작성자 아이디가 일치할 경우에만 표시 --%>
				<c:if test="${not empty qnabo.faq_reply}">
					<div id="articleReplyArea">
						<b>답변</b>
						<textarea rows="10" cols="67" name="faq_reply">${qnabo.faq_reply}</textarea>
					</div>
				</c:if>
			</section>
			<section id="commandCell">
				<%-- 답글, 수정, 삭제 버튼은 로그인 한 사용자에게만 표시 --%>
				<%-- 단, 수정, 삭제 버튼은 세션 아이디와 작성자 아이디가 일치할 경우에만 표시 --%>
				<c:if test="${not empty sessionScope.sId}">
					<c:if test="${sessionScope.sId eq 'admin@naver.com'}">
					<%-- 세션아이디가 관리자이메일과 일치할 때만 "답변"버튼 표시  --%>
						<input type="button" value="답변" onclick="location.href='QnaBoardReply?faq_idx=${qnabo.faq_idx}&pageNum=${pageNum}'">
					</c:if>
					<c:if test="${sessionScope.sId eq qnabo.mem_email}">
						<input type="button" value="삭제" onclick="confirmDelete()">
					</c:if>
				</c:if>
				<input type="button" value="돌아가기" onclick="history.back()">
			</section>
		</section>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
















