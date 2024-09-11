<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
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
	"패션/위생": ["의류"],
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
	<main>
		<article id="articleForm">
			<h1 align="center">상품 등록</h1>
			<form action="ProductRegistPro" name="RegistForm" method="post" enctype="multipart/form-data">
				<section class="joinForm1">
					<table id="tb01">
						<tr>
							<td>상품코드</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_code" size="9" id="product_code" placeholder="예) SHOPFOFEE001">
							</td>
						</tr>	
						<tr>
							<td>상품명</td>
						</tr>
						<tr>
							<td><input type="text" name="product_name" id="product_name" placeholder="예) 맛있는 간식"></td>
						</tr>	
						<tr>
							<td>상품설명</td>
						</tr>
						<tr>
							<td><input type="text" name="product_description" id="product_description" size="20" placeholder="예) 어떤 아이든 가리지 않고 다 좋아하는 맛"></td>
						</tr>	
						<tr>
							<td>상품 카테고리</td>
						</tr>
						<tr>
							<td>
								<select name="product_category" id="product_category">
									<option value="" selected="selected">카테고리</option>
								</select>
							</td>
						<tr>
							<td>상품 세부카테고리</td>
						</tr>
						<tr>
							<td>
								<select name="product_category_detail" id="project_category_detail">
								    <option value="" selected="selected">세부 카테고리</option>
							   </select>
							</td>
						</tr>
						<tr>
							<td>상품 옵션</td>
						</tr>
						<tr>
			                <td>
								<input type="text" name="product_item_option" class="itemText" placeholder="예) 230mm">
								<input type="text" name="product_item_option" class="itemText" placeholder="예) 240mm">
								<input type="text" name="product_item_option" class="itemText" placeholder="예) 250mm">
								<input type="text" name="product_item_option" class="itemText" placeholder="예) 260mm">
								<input type="text" name="product_item_option" class="itemText" placeholder="예) 270mm">
			                </td>
						</tr>	
						<tr>
							<td>상품가격</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_price" id="product_price">
							</td> 
						</tr>	
						<tr>
							<td>재고수량</td>
						</tr>
						<tr>	
							<td>
								<input type="text" name="product_stock" id="product_stock">
							</td>
						</tr>	
						<%-- 파일 첨부 영역 --%>
						<tr>
							<td class="write_td_left"><label for="board_file">파일첨부</label></td>
						</tr>
						<tr>
							<td class="write_td_right">
								<%-- 파일 첨부 형식은 input 태그의 type="file" 속성 활용 --%>
								<%-- 주의! 파일 업로드를 위해 form 태그 속성에 enctype 속성 필수!  --%>
								<%-- 1) 한번에 하나의 파일(단일 파일) 선택 가능하게 할 경우 --%>
								<input type="file" name="product_img_file1">
								<input type="file" name="product_img_file2">
							</td>
						</tr>
						<tr>
							<td align="center"><br>
								<input type="submit" value="등록">
								<input type="button" value="목록" onclick="location.href='AdminStore?pageNum=${param.pageNum}'">
							</td>
						</tr>
					</table>
				</section>
			</form>
		</article>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>








