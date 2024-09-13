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
<title>MVC 게시판</title>
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
    max-width: 800px;
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

td {
    padding: 5px;
    vertical-align: top;
}

td:first-child {
    width: 25%;
    font-weight: bold;
    padding-right: 120px; /* 오른쪽 여백 추가 */
}

#status {
	font-weight: normal;
}

td:last-child {
    width: 30%;
}

input[type="text"], select {
    width: 47%;
    padding: 8px;
    box-sizing: border-box;
    margin-top: 5px; /* 필드와 레이블 간격 */
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

.button-container {
    text-align: center;
    padding: 20px 0;
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

#status {
	font-weight: normal;
}

#price {
	font-weight: normal;
}

</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">

function confirmDelete() {
	// 삭제 버튼 클릭 시 확인창(confirm dialog)을 통해 "삭제하시겠습니까?" 출력 후
	// 다이얼로그의 확인 버튼 클릭 시 "BoardDelete.bo" 서블릿 요청
	// => 파라미터 : 글번호, 페이지번호
	if(confirm("삭제하시겠습니까?")) {
		location.href = "ProductOrderDelete?order_idx=${productOrder.order_idx}&pageNum=${param.pageNum}";
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
		<h2 align="center">상품 주문내역</h2>
			<section class="joinForm1">
				<input type="hidden" name="order_idx" value="${productOrder.order_idx}">
				<table id="tb01">
					<tr>
						<td>상품 코드</td>
					</tr>
					<tr>
						<td><input type="text" name="product_code" value="${productOrder.product_code}" id="product_code" readonly="readonly"></td>
					</tr>	
					<tr>
						<td>상품명</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="product_name" id="product_name" readonly="readonly" value="${productOrder.product_name}">
						</td>
					</tr>	
					<tr>
						<td>상품 설명</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="product_description" id="product_description" readonly="readonly" value="${productOrder.product_description}">
						</td> 
					</tr>	
					<tr>
						<td>상품 카테고리</td>
					</tr>
					<tr>
		                <td>
							<input type="text" name="product_category" id="product_category" readonly="readonly" value="${productOrder.product_category}(${productOrder.product_category_detail})">
							<input type="hidden" name="product_category_detail" id="product_category_detail" readonly="readonly" value="${productOrder.product_category}(${productOrder.product_category_detail})">
		                </td>
					</tr>	
					<tr>
						<td>상품 옵션</td>
					</tr>
					<tr>
				        <td>
							<input type="text" name="product_item_option" class="itemText" value="${productOrder.product_item_option}" readonly="readonly">
				        </td>
					</tr>	
					<tr>
						<td>상품 가격</td>
					</tr>
					<tr>
						<td id="price">
							<fmt:formatNumber  value="${productOrder.product_price}" type="number" groupingUsed="true"/>원
						</td>
					</tr>
					<tr>
						<td>결제 금액</td>
					</tr>
					<tr>
						<td id="price">
							<fmt:formatNumber value="${productOrder.product_pay_amt}" type="number" groupingUsed="true"/>원
						</td>
					</tr>	
					<tr>
						<td>결제일</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="order_date" id="order_date" readonly="readonly" value="${productOrder.order_date}">
<%-- 							<fmt:formatDate value="${productOrder.order_date}" pattern="yyyy.MM.dd HH:mm" />	 --%>
						</td>
					</tr>	
					<tr>
						<td>배송 상태</td>
					</tr>
					<tr>
						<c:choose>
							<c:when test="${productOrder.product_shipping_info eq 1}">
								<td id="status">배송전</td>
							</c:when>
							<c:when test="${productOrder.product_shipping_info eq 2}">
								<td id="status">배송중</td>
							</c:when>
							<c:when test="${productOrder.product_shipping_info eq 3}">
								<td id="status">배송완료</td>
							</c:when>
						</c:choose>
					</tr>
					<tr>
						<td>결제 상태</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="store_usuer_status" id="store_usuer_status" readonly="readonly" value="${productOrder.store_usuer_status}">
						</td>
					</tr>	
					<tr>
						<td>주소</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="address_post_code" id="address_post_code" readonly="readonly" value="${productOrder.address_post_code} / ${productOrder.address_main}">
							<input type="text" name="address_sub" id="address_sub" readonly="readonly" value="${productOrder.address_sub}">
						</td>
					</tr>	
					<tr>
						<td>고객 전화번호</td>
					</tr>
					<tr>
						<td>
							<input type="text" name="address_receiver_tel" id="address_receiver_tel" readonly="readonly" value="${productOrder.address_receiver_tel}">
						</td>
					</tr>	
					<tr>
						<td>상품사진</td>
					</tr>
					<tr>
						<td class="product_img" colspan="2">
							<div>
								<img
									src="${pageContext.request.contextPath}/resources/upload/${productOrder.product_img}"
									id="img1" class="car_image" selected>
							</div>
							<div>
								<img
									src="${pageContext.request.contextPath}/resources/upload/${productOrder.product_img2}"
									id="img1" class="car_image" selected>
							</div>
						</td>
					</tr>
					<tr>
						<td align="center"><br>
							<input type="button" value="목록" onclick="location.href='AdminStoreOrder?pageNum=${param.pageNum}'">
							<input type="button" value="수정" onclick="location.href='ProductOrderModify?order_idx=${productOrder.order_idx}&pageNum=${param.pageNum}'">
							<input type="button" value="삭제" onclick="confirmDelete()">
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
















