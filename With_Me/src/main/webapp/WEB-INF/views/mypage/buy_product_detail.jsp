<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
.profile-form {
    max-width: 600px;
    margin: 0 auto;
    padding: 20px;
    background-color: #f9f9f9;
    border-radius: 8px;
    border: 1px solid #ddd;
}

.form-group {
    margin-bottom: 15px;
}

.form-group label {
    display: block;
    font-weight: bold;
    margin-bottom: 5px;
    font-size: 16px;
}

.form-group input[type="text"], 
.form-group input[type="password"], 
.form-group input[type="email"], 
.form-group input[type="tel"] {
    width: calc(100% - 10px);
    padding: 10px;
    font-size: 14px;
    border: 1px solid #ccc;
    border-radius: 4px;
}

.form-group p {
    font-size: 16px;
    color: #333;
    padding: 5px 0;
}

#profile-img {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    margin-bottom: 10px;
}

#btnSearchAddress {
    display: block;
    margin-top: 5px;
    background-color: #ddd;
    border: none;
    padding: 10px;
    cursor: pointer;
}

.form-actions {
    display: flex;
    justify-content: space-between;
    margin-top: 20px;
}

.form-actions input[type="submit"], 
.form-actions input[type="reset"], 
.form-actions button {
    background-color: #4CAF50;
    color: white;
    border: none;
    padding: 10px 20px;
    border-radius: 5px;
    cursor: pointer;
}

.form-actions input[type="submit"]:hover, 
.form-actions input[type="reset"]:hover, 
.form-actions button:hover {
/*     background-color: #45a049; */
}

.top {
	display: flex;
	gap: 30px;
}

.fundInfo {
	display: flex;
	gap: 30px;
}

 .image {
 	width: 175px;
 	height: 185px;
 }
 
 .image img {
 	width: 100%;
 	height: 100%;
 	object-fit: cover;
 }
 
 .topInfo {
 	margin-top: 20px;
 }

</style>
</head>
<body>	
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<article>
		<form action="BuyProductCancel" name="joinForm" method="post">
		    <section class="profile-form">
		    	<input type="hidden" name="order_idx" id="order_idx" value="${BuyProductDetail.order_idx}">
		        <div class="form-group top" style="border: 1px solid #ccc;">
		            <div>
		                <div class="image">
<%-- 		                    <img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG"> --%>
							<img
								src="${pageContext.request.contextPath}/resources/upload/${BuyProductDetail.product_img}"
								id="img1" class="product_image" selected>
		                </div>
		                <div>
							<img
								src="${pageContext.request.contextPath}/resources/upload/${BuyProductDetail.product_img2}"
								id="img2" class="product_image2" selected>
		                </div>
		            </div>
		            <div class="topInfo">
		                <h2>${BuyProductDetail.product_name}</h2>
		                <p><b>카테고리</b> : ${BuyProductDetail.product_category}(${BuyProductDetail.product_category_detail})</p>
			                <p><b>결제상태</b> : ${BuyProductDetail.store_usuer_status}</p>
<%-- 		                <p><fmt:formatNumber value="${BuyProductDetail.funding_amt}" type="number" groupingUsed="true"/>원</p> --%>
<%-- 		                <p><fmt:formatNumber value="${BuyProductDetail.target_price}" type="number" groupingUsed="true"/>원</p> --%>
		            </div>
		        </div>
				
				<div class="form-group" style="border: 1px solid #ccc;">
		            <div>
		                <h4>상품 정보</h4>
		            </div>
		            <div>
		            	<p><b>상품명</b> : ${BuyProductDetail.product_name}</p>
		            	<p><b>상품설명</b> : ${BuyProductDetail.product_description}</p>
		            	<p><b>상품옵션</b> : ${BuyProductDetail.product_item_option}</p>
		            	<p><b>상품금액</b> : <fmt:formatNumber value="${BuyProductDetail.product_price}" type="number" groupingUsed="true"/>원</p>
		            	<p><b>주문개수</b> : ${BuyProductDetail.order_count}개</p>
		            </div>
		        </div>
				
		        <div class="form-group" style="border: 1px solid #ccc;">
		            <div>
		                <h4>배송 정보</h4>
		            </div>
		            <div>
						<p><b>주문날짜</b> : <fmt:formatDate value="${orderDate}" pattern="yyyy.MM.dd" /></p>
						<p><b>결제금액</b> : <fmt:formatNumber value="${BuyProductDetail.product_pay_amt}" type="number" groupingUsed="true"/>원</p>
						<p><b>도로명</b> : ${BuyProductDetail.address_post_code}</p>
						<p><b>주소</b> : ${BuyProductDetail.address_main}</p>
						<p><b>상세주소</b> : ${BuyProductDetail.address_sub}</p>
						<p><b>수신자 전화번호</b> : ${BuyProductDetail.address_receiver_tel}</p>
						<c:choose>
							<c:when test="${BuyProductDetail.product_shipping_info eq 1}">
								<td id="status"><b>배송상태</b> : 배송전</td>
							</c:when>
							<c:when test="${BuyProductDetail.product_shipping_info eq 2}">
								<td><b>배송상태</b> : 배송중</td>
							</c:when>
							<c:when test="${BuyProductDetail.product_shipping_info eq 3}">
								<td><b>배송상태</b> : 배송완료</td>
							</c:when>
						</c:choose>
		            </div>
		        </div>
		
				<div class="form-actions">
				    <c:if test="${BuyProductDetail.store_usuer_status != '결제 취소' && BuyProductDetail.product_shipping_info eq 1}">
				        <input type="submit" value="결제 취소" onclick="return confirm('결제한 상품을 취소하시겠습니까?');">
				    </c:if>
<!-- 				    <button type="button" onclick="history.back()">돌아가기</button> -->
				    <input type="button" value="목록" onclick="location.href='MemberInfo?pageNum=${param.pageNum}'">
				</div>
		    </section>
		</form>
		</article>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>















