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
    padding: 10px;
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
    width: 40%;
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
    var selectedCategory = "${product.product_category}";
    var selectedDetailCategory = "${product.product_category_detail}";

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
	
	<%
    // product_item_option을 가져와서 |로 분리하고 첫 번째 옵션만 선택
//     String productItemOption = product.getProduct_item_option(); // 상품 옵션 문자열
    StoreVO product = (StoreVO) request.getAttribute("product_item_option");
    String selectedOption = ""; // 기본값 설정

    if (product != null) {
        // StoreVO 객체의 product_item_option 필드를 가져옴
        String productItemOption = product.getProduct_item_option();

        if (productItemOption != null && !productItemOption.isEmpty()) {
            String[] options = productItemOption.split("\\|"); // "|"로 문자열 분리
            selectedOption = options.length > 0 ? options[0] : ""; // 첫 번째 옵션 가져오기
        }
    }
	%>
	
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
		                    <select name="product_category" id="product_category" disabled="disabled">
		                        <option value="">카테고리를 선택하세요</option>
		                    </select>
		                </td>
					</tr>	
					<tr>
						<td>상품 세부카테고리</td>
					</tr>
					<tr>
		                <td>
		                    <select name="product_category_detail" id="product_category_detail" disabled="disabled">
		                        <option value="">세부 카테고리를 선택하세요</option>
		                    </select>
		                </td>
					</tr>	
					<tr>
						<td>상품 옵션</td>
					</tr>
					<tr>
				        <td>
							<c:forEach var="options" items="${productOptions}">
								<input type="text" name="product_item_option" class="itemText" value="${options.splited_option}" disabled="disabled">
							</c:forEach>
				        </td>
					</tr>	
					<tr>
						<td>상품가격</td>
					</tr>
					<tr>
						<td><input type="text" name="product_price" id="product_price" readonly="readonly" value="${product.product_price}">
						</td>
					</tr>
					<tr>
						<td>재고수량</td>
					</tr>
					<tr>
						<td><input type="text" name="product_stock" id="product_stock" readonly="readonly" value="${product.product_stock}">
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
								<td>판매중지</td>
							</c:when>
							<c:when test="${product.product_status eq 3}">
								<td>품절</td>
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
							<input type="button" value="목록" onclick="location.href='AdminStore?pageNum=${param.pageNum}'">
							<input type="button" value="수정" onclick="location.href='ProductModify?product_idx=${product.product_idx}&pageNum=${param.pageNum}'">
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
















