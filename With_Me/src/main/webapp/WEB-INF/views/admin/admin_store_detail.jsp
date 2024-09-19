<%@page import="com.itwillbs.with_me.vo.StoreVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	.product_img {
		width: 300px;
		height: 215px;
	}
	.product_img img{
		width: 25%;
		object-fit: cover;
	}
	
	body {
	    font-family: Arial, sans-serif;
	    margin: 0;
	    padding: 0;
	    background-color: #f4f4f4;
	}
	
	#articleForm {
	    margin: 20px auto;
	    max-width: 600px;
	    padding: 20px;
	    background-color: #fff;
	    border-radius: 8px;
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	
	h2 {
	    text-align: center;
	    color: #333;
	    margin-bottom: 20px;
	}
	
	table {
	    width: 100%;
	    border-collapse: separate;
	    border-spacing: 0 10px; /* 셀 간격 조정 */
	}
	
	tr:nth-child(even) td {
	    padding-bottom: 20px;
	}
	
	td:first-child {
	    width: 25%;
	    font-weight: bold;
	}
	
	#status {
		font-weight: normal;
	}
	
	#price {
		font-weight: normal;
	}
	
	td:last-child {
	    width: 30%;
	}
	
	input[type="text"], select {
	    width: 100%;
	    padding: 8px;
	    box-sizing: border-box;
	    margin-top: 5px; /* 필드와 레이블 간격 */
	    background-color: #eee;
	    border:none;
	}
	
	.item-option {
	    width: calc(20% - 10px); /* 아이템 옵션의 너비 조정 */
	    margin-right: 10px; /* 아이템 옵션 간격 조정 */
	    display: inline-block;
	}
	
	.product-img {
	    max-width: 100%;
	    height: auto;
	    border-radius: 5px;
	}
	
	.button {
	    background-color: #FFAB40;
	    color: #fff;
	    border: none;
	    padding: 10px 20px;
	    margin: 5px;
	    cursor: pointer;
	    border-radius: 5px;
	    font-size: 16px;
	    transition: background-color 0.3s ease;
	}
	
	.button:hover {
	    background-color: #e6952d;
	}

</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">

function confirmDelete() {
	// 삭제 버튼 클릭 시 확인창(confirm dialog)을 통해 "삭제하시겠습니까?" 출력 후
	// 다이얼로그의 확인 버튼 클릭 시 "BoardDelete.bo" 서블릿 요청
	// => 파라미터 : 글번호, 페이지번호
	if(confirm("삭제하시겠습니까?")) {
		location.href = "ProductDelete?product_idx=${product.product_idx}&pageNum=${param.pageNum}";
	}
}

	
</script>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	
	<!-- 게시판 상세내용 보기 -->
	<article id="articleForm">
		<h2 align="center">상품 상세내용</h2>
			<section class="joinForm1">
				<input type="hidden" name="product_idx">
				<table id="tb01">
					<tr>
						<td>상품코드</td>
					</tr>
					<tr>
						<td><input type="text" name="product_code" value="${product.product_code}" id="product_code" readonly="readonly"></td>
					</tr>	
					<tr>
						<td>상품명</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="product_name" id="product_name" readonly="readonly" value="${product.product_name}">
						</td>
					</tr>	
					<tr>
						<td>상품설명</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="product_description" id="product_description" readonly="readonly" value="${product.product_description}">
						</td> 
					</tr>	
					<tr>
						<td>상품 카테고리</td>
					</tr>
					<tr>
		                <td>
							<input type="text" name="product_category" id="product_category" readonly="readonly" value="${product.product_category}">
		                </td>
					</tr>	
					<tr>
						<td>상품 세부카테고리</td>
					</tr>
					<tr>
		                <td>
							<input type="text" name="product_category" id="product_category" readonly="readonly" value="${product.product_category_detail}">
		                </td>
					</tr>	
					<tr>
						<td>상품 옵션</td>
					</tr>
					<tr>
				        <td>
							<c:forEach var="options" items="${productOptions}">
								<input type="text" name="product_item_option" class="itemText" value="${options.splited_option}" readonly="readonly" >
							</c:forEach>
				        </td>
					</tr>	
					<tr>
						<td>상품가격</td>
					</tr>
					<tr>
						<td id="price">
							<fmt:formatNumber value="${product.product_price}" type="number" groupingUsed="true"/>원
						</td>
					</tr>
					<tr>
						<td>재고수량</td>
					</tr>
					<tr>
						<td id="price">
							<fmt:formatNumber value="${product.product_stock}" type="number" groupingUsed="true"/>개
						</td>
					</tr>	
					<tr>
						<td>상품상태</td>
					</tr>
					<tr>
						<c:choose>
							<c:when test="${product.product_status eq 1}">
								<td id="status">판매중</td>
							</c:when>
							<c:when test="${product.product_status eq 2}">
								<td id="status">판매중지</td>
							</c:when>
							<c:when test="${product.product_status eq 3}">
								<td id="status">품절</td>
							</c:when>
						</c:choose>
					</tr>
					<tr>
						<td>상품사진</td>
					</tr>
					<tr>
						<td class="product_img" colspan="2">
							<div>
								<img
									src="${pageContext.request.contextPath}/resources/upload/${product.product_img}"
									id="img1" class="car_image" selected>
							</div>
							<div>
								<img
									src="${pageContext.request.contextPath}/resources/upload/${product.product_img2}"
									id="img1" class="car_image" selected>
							</div>
						</td>
					</tr>
					<tr><td width="70">파일</td>
					</tr>
					<tr>	
						<td colspan="3" id="product_img">
							<%-- List 객체("fileList") 크기만큼 반복문을 통해 파일명 출력 --%>
							<c:forEach var="file" items="${fileList}">
								<%-- 단, 파일명(file 객체)가 비어있지 않을 경우메나 출력 --%>
								<c:if test="${not empty file}">
									<%-- [ JSTL - functions 라이브러리 함수 활용하여 원본 파일명 추출하기 ] --%> 
									<%-- 1) split() 함수 활용하여 "_" 구분자로 분리 후 두번째 인덱스 값 사용 --%>
		<%-- 							split() : ${fn:split(file, "_")[1]}<br> --%>
		
									<%-- 2) substring() 함수 활용하여 시작인덱스부터 지정 인덱스까지 문자열 추출 --%>
									<%--    (단, 전체 파일명의 길이를  --%>
		<%-- 							<c:set var="fileLength" value="${fn:length(file)}" /> --%>
		<%-- 							<c:set var="delimIndex" value="${fn:indexOf(file, '_')}" /> --%>
		<%-- <%-- 							substring() : ${fn:substring(file, 시작인덱스, 끝인덱스)} --%>
		<%-- 							substring() : ${fn:substring(file, delimIndex + 1, fileLength)}<br> --%>
		
									<%-- 3) substringAfter() 함수 활용하여 시작인덱스부터 끝까지 추출 --%>
		<%-- 							substringAfter() : ${fn:substringAfter(file, '_')}<br> --%>
									<c:set var="orginalFileName" value="${fn:substringAfter(file, '_')}"/>
<%-- 										<input type="hidden" name="originalFileName" value="${originalFileName}" /> --%>
									${file}
								</c:if>
							</c:forEach> 
						</td>
					</tr>
					<tr>
						<td align="center"><br>
							<input type="button" class="button" value="목록" onclick="location.href='AdminStore?pageNum=${param.pageNum}'">
							<input type="button" class="button" value="수정" onclick="location.href='ProductModify?product_idx=${product.product_idx}&pageNum=${param.pageNum}'">
							<input type="button" class="button" value="삭제" onclick="confirmDelete()">
						</td>
					</tr>
				</table>
			</section>
	</article>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
















