<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>index</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<style>
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
	
	/* 페이징 처리 */
	.main #pageList {
		text-align: center;
	}
</style>
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
function productDetail(productIdx) {
	location.href="ProductDetail?product_idx=" + productIdx;
}	
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>	
	<div class="inner">
		<section class="wrapper">
			<jsp:include page="/WEB-INF/views/inc/admin_side_nav.jsp"></jsp:include>
			<article class="main">
				<h3>등록신청관리</h3>
				<div class="wrapper_top">
					<form action="AdminStore">
						<div class="search">
							<span>Search</span>
							<select name="searchType">
								<option value="code" <c:if test="${param.searchType eq 'code'}">selected</c:if>>상품코드</option>
								<option value="name" <c:if test="${param.searchType eq 'name'}">selected</c:if>>상품명</option>
							</select>
							<input type="search" name="searchKeyword" value="${param.searchKeyword}" >
							<input type="submit" value="검색">
						</div>
							<input type="button" value="상품 등록" onclick="location.href='ProductRegist'" />
					</form>
				</div>
				<br>
				<div class="content">
					<table border="1">
						<tr>
							<th>상품번호</th>
							<th>상품코드</th>
							<th>카테고리</th>
							<th>상품명</th>
							<th>재고</th>
							<th>등록일</th>
							<th>상품상태</th>
							<th>상세보기</th>
						</tr>
						<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
						<c:set var="pageNum" value="1" />
						<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
						<c:if test="${not empty param.pageNum}">
							<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
							<c:set var="pageNum" value="${param.pageNum}" />
						</c:if>
						<c:forEach var="pl" items="${productList}">
							<tr align="center">
								<td>${pl.product_idx}</td>
								<td>${pl.product_code}</td>
								<td>${pl.product_category}(${pl.product_category_detail})</td>
								<td>${pl.product_name}</td>
								<td>${pl.product_stock}</td>
								<td>
									<fmt:formatDate value="${pl.product_created}" pattern="yy-MM-dd HH:mm" />
								</td>
								<c:choose>
									<c:when test="${pl.product_status eq 1}">
										<td>판매중</td>
									</c:when>
									<c:when test="${pl.product_status eq 2}">
										<td>판매중지</td>
									</c:when>
									<c:when test="${pl.product_status eq 3}">
										<td>품절</td>
									</c:when>
								</c:choose>
								<td>
									<input type="button" value="상세보기" onclick="productDetail(${pl.product_idx})">
								</td>
							</tr>
						</c:forEach>
						<c:if test="${empty productList}">
							<tr>
								<td align="center" colspan="8">조회 결과가 없습니다.</td>
							</tr>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<c:if test="${not empty productList}">
					<div id="pageList">
						<%-- [이전] 버튼 클릭 시 AdminStore 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
						<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
						<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
						<input type="button" onclick="location.href='AdminStore?pageNum=${pageNum - 1}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
						<%-- 계산된 페이지 번호가 저장된 PageInfo 객체(pageInfo)를 통해 페이지 번호 출력 --%>
						<%-- 시작페이지(startPage = begin) 부터 끝페이지(endPage = end)까지 1씩 증가하면서 표시 --%>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<%-- 각 페이지마다 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
							<%-- 단, 현재 페이지(i 값과 pageNum 파라미터값이 동일)는 하이퍼링크 없이 굵게 표시 --%>
							<c:choose>
								<c:when test="${i eq pageNum}">
									<b>${i}</b> <%-- 현재 페이지 번호 --%>
								</c:when>
								<c:otherwise>
									<a href="AdminStore?pageNum=${i}">${i}</a> <%-- 다른 페이지 번호 --%>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<%-- [다음] 버튼 클릭 시 AdminStore 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
						<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
						<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
						<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
						<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
						<input type="button" onclick="location.href='AdminStore?pageNum=${pageNum + 1}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
					</div>
				</c:if>
			</article>
		</section>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>