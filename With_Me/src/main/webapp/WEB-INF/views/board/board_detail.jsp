<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link
	href="${pageContext.request.contextPath }/resources/css/default.css"
	rel="stylesheet" type="text/css">
<style type="text/css">
/* 업데이트된 CSS 스타일 */
#articleForm {
	width: 60%;
	margin: 20px auto;
	padding: 20px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	border-radius: 10px;
	background-color: #fff;
}
section {
	min-height: auto;
}

h2 {
	text-align: left;
	margin-bottom: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

th, td {
/* 	border: 1px solid #ddd; */
	padding: 10px;
	text-align: left;
}
tr {
    border-bottom: solid 1px #F0F0F0 ;
}
th {
	background-color: #f9f9f9;
}

#basicInfoArea {
	margin-bottom: 20px;
}

#articleContentArea {
	background: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	white-space: pre-line;
	overflow: auto;
}

#commandCell {
	text-align: center;
	margin-top: 20px;
	
}




#list_btn {
	padding: 10px 20px;
	border: none;
	background-color: #FFAB40;
	width: 100px;
	color: white;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
}

#list_btn:hover {
	background-color: #fe9100;
}
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 상세내용 보기 -->
	<main>
		<section id="articleForm">
			<div align="left">
			<h2>공지사항</h2>
			</div>
			<section id="basicInfoArea">
				
				<table>
					<tr>
						<th width="70">제 목</th>
						<td colspan="4">${bo.bo_subject}</td>
					</tr>
					<tr>
						<!-- 작성일시 출력 형식은 ex) 2024-06-04 12:30 -->
						<th width="70">작성일시</th>
						<td><fmt:formatDate value="${bo.bo_sysdate}"
								pattern="yyyy-MM-dd" /></td>
						<td width="100">조회수 ${bo.bo_readcount}</td>
					</tr>
				</table>
			</section>
			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				<img
					src="${pageContext.request.contextPath}/resources/upload/${bo.bo_file}"
					id="img1" class="bo_image" selected> 
					
					${bo.bo_content}
			</section>
			<section id="commandCell">
				<!-- 목록 버튼 클릭시 BoardList.bo 서블릿 요청(파라미터 : 페이지번호) -->
				<input type="button" value="목록"
					onclick="location.href='BoardList?pageNum=${param.pageNum}'" id="list_btn">
			</section>
		</section>
	</main>
	
	
	<footer>
		<!-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 -->
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>