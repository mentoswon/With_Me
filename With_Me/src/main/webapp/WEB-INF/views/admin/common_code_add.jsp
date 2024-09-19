<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.main {
		padding: 1.5rem;
	}
	
	.main h3 {
		text-align: left;
		margin-bottom: 30px;
	}
	.main .wrapper_top {
		display: flex;
		justify-content: space-between;
		position: relative;
		margin-bottom: 20px;
	}
	
	.main .wrapper_top .search {
		position: absolute;
		left: 40%;
	}
	.main .content {
		width: 100%;
		margin-bottom: 50px;
	}
	
	.main .content table {
		width: 100%;
	}
</style>
</head>
	<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<div class="inner">
		<section class="wrapper">
			<jsp:include page="/WEB-INF/views/inc/admin_side_nav.jsp"></jsp:include>
			<article class="main">
				<h3>카테고리 추가</h3>
				<div class="wrapper_top">
					<div>
						<span>Show</span>
						<select onchange="showListLimit(this.value)">
							<option value="5" <c:if test="${param.listLimit eq 5}">selected</c:if>>5</option>
							<option value="10" <c:if test="${param.listLimit eq 10}">selected</c:if>>10</option>
							<option value="20" <c:if test="${param.listLimit eq 20}">selected</c:if>>20</option>
							<option value="30" <c:if test="${param.listLimit eq 30}">selected</c:if>>30</option>
						</select>
						<span>entries</span>
					</div>
					<form action="AdminNotice">
						<div class="search">
							<span>Search</span>
							<input type="search" name="searchKeyword" value="${param.searchKeyword}" >
							<input type="submit" value="검색">
						</div>
					</form>
					<!-- 우측 상단 버튼 들어가는 자리 -->			
					<div>
						<input type="button" id="addButton" value="상위 공통코드 추가">
						<input type="button" id="addSubButton" value="하위 공통코드 추가">
					</div>
				</div>
				<div class="content">
					<table border="1">
						<tr>
							<th>공지사항 번호</th>
							<th>공지사항 제목</th>
							<th>작성일</th>
							<th>조회수</th>
							<th>첨부파일</th>
							<th>수정 및 삭제</th>
						</tr>
					</table>
				</div>
			</article>
		</section>
	</div>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
	</body>
</html>








