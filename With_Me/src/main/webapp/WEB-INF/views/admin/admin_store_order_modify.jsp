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
	
	td:last-child {
	    width: 30%;
	}
	
	input[type="text"], select {
	    width: 100%;
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
	
	#price {
		font-weight: normal;
	}
	
	#status {
		font-weight: normal;
	}
</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
// ======================================================
// 카테고리 셀렉트
var categoryObject = {
    "푸드": ["사료", "껌류", "수제간식"],
    "패션/위생": ["의류"],
    "식기/급수기": ["급수기", "급수기"],
    "장난감/훈련": ["장난감", "훈련용품"],
    "하우스/안전": ["하우스", "울타리", "기타안전용품"]
};

window.onload = function() {
    var product_categorySel = document.getElementById("product_category");
    var product_category_detailSel = document.getElementById("product_category_detail");

    // 카테고리 목록을 셀렉트 박스에 추가
    for (var category in categoryObject) {
        var option = new Option(category, category);
        product_categorySel.options[product_categorySel.options.length] = option;
    }

    // 페이지 로드 시 기존에 선택된 카테고리와 세부 카테고리 설정
    var selectedCategory = "${store.product_category}";
    var selectedDetailCategory = "${store.product_category_detail}";

    if (selectedCategory) {
        product_categorySel.value = selectedCategory;
        var details = categoryObject[selectedCategory];
        if (details) {
            for (var i = 0; i < details.length; i++) {
                var option = new Option(details[i], details[i]);
                product_category_detailSel.options[product_category_detailSel.options.length] = option;
            }
            product_category_detailSel.value = selectedDetailCategory;
        }
    }

    // 카테고리 선택 시 세부 카테고리 옵션 업데이트
    product_categorySel.onchange = function() {
        product_category_detailSel.length = 1; // 기존 옵션 초기화 (기본값 제외)
        var details = categoryObject[this.value];
        if (details) {
            for (var i = 0; i < details.length; i++) {
                var option = new Option(details[i], details[i]);
                product_category_detailSel.options[product_category_detailSel.options.length] = option;
            }
        }
    };
}

function deleteFile(product_idx, fileName, index) {
	
	if(confirm(index + "번 파일을 삭제하시겠습니까?")) {
		// BoardDeleteFile 서블릿 주소 요청(글번호(board_num), 파일명(board_file) 파라미터 전달)
		location.href = "ProductDeleteFile?product_idx=" + product_idx + "&product_img=" + fileName + "&pageNum=" + ${param.pageNum} + "&index=" + index;
	}
}

	
</script>
<style type="text/css">
	.img_btn_delete {
		width: 10px;
		height: 10px;
	}
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 상세내용 보기 -->
	<article id="articleForm">
		<h2 align="center">상품 배송상태 수정</h2>
			<form action="ProductOrderModify" name="ProductForm" method="post">
				<section class="ProductForm1">
					<input type="hidden" name="order_idx" id="order_idx" value="${productOrder.order_idx}">
					<table id="tb01">
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
							<td><input type="text"  id="order_date" readonly="readonly" value="${productOrder.order_date}">
							</td>
						</tr>	
						<tr>
							<td>배송 상태</td>
						</tr>
						<tr>
							<td>
								<select name="product_shipping_info">
									<option value="1" <c:if test="${productOrder.product_shipping_info eq '1'}">selected</c:if>>배송전</option>
									<option value="2" <c:if test="${productOrder.product_shipping_info eq '2'}">selected</c:if>>배송중</option>
									<option value="3" <c:if test="${productOrder.product_shipping_info eq '3'}">selected</c:if>>배송완료</option>
								</select>
							</td>
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
							<td align="center"><br>
								<input type="submit" class="button" value="수정" onclick="return confirm('배송 상태 변경이 완료되었습니다.');">
								<input type="button" class="button" value="취소" onclick="history.back()">
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
















