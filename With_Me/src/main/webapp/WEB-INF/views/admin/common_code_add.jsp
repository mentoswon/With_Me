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
    width: 116%;
    border-collapse: separate;
    border-spacing: 0 10px; /* 셀 간격 조정 */
}

td {
    padding: 10px;
    vertical-align: top;
}

td:first-child {
    width: 60%;
    font-weight: bold;
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
<script>
// ==========================================================================
// 카테고리 셀렉트
var categoryObject = {
	"푸드": ["사료", "껌류", "수제간식"],
	"패션/위생": ["의류", "화장실"],
	"식기/급수기": ["급수기", "급식기"],
	"장난감/훈련": ["장난감", "훈련용품"],
	"하우스/안전": ["하우스", "울타리", "기타안전용품"]
}
window.onload = function() {
  var product_categorySel = document.getElementById("product_category");
  var project_category_detailSel = document.getElementById("project_category_detail");
  
  for (var x in categoryObject) {
	  product_categorySel.options[product_categorySel.options.length] = new Option(x, x);
  }
  product_categorySel.onchange = function() {
	  
    project_category_detailSel.length = 1;
	
	var y = categoryObject[this.value];
	
    for (var i = 0; i < y.length; i++) {
    	project_category_detailSel.options[project_category_detailSel.options.length] = new Option(y[i], y[i]);
    }
  }
}


</script>
</head>
<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<div id="commonCode">
		<select name="">
			<option value="FUND">FUND</option>
			<option value="SHOP">SHOP</option>
		</select>
		<input type="button" value="+">
	</div>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>








