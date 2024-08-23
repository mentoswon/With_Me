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
	#writeForm {
		width: 500px;
		height: 550px;
		margin: auto;
	}
	
	#writeForm > table {
		margin: auto;
		width: 550px;
	}
	
	.write_td_left {
		width: 150px;
		background: orange;
		text-align: center;
	}
	
	.write_td_right {
		width: 300px;
		background: skyblue;
	}
</style>
<script>
// 공통코드 셀렉트
var subjectObject = {
  "Front-end": {
    "HTML": ["Links", "Images", "Tables", "Lists"],
    "CSS": ["Borders", "Margins", "Backgrounds", "Float"],
    "JavaScript": ["Variables", "Operators", "Functions", "Conditions"]    
  },
  "Back-end": {
    "PHP": ["Variables", "Strings", "Arrays"],
    "SQL": ["SELECT", "UPDATE", "DELETE"]
  }
}
window.onload = function() {
  var subjectSel = document.getElementById("subject");
  var topicSel = document.getElementById("topic");
  var chapterSel = document.getElementById("chapter");
  for (var x in subjectObject) {
    subjectSel.options[subjectSel.options.length] = new Option(x, x);
  }
  subjectSel.onchange = function() {
    //empty Chapters- and Topics- dropdowns
    chapterSel.length = 1;
    topicSel.length = 1;
    //display correct values
    for (var y in subjectObject[this.value]) {
      topicSel.options[topicSel.options.length] = new Option(y, y);
    }
  }
  topicSel.onchange = function() {
    //empty Chapters dropdown
    chapterSel.length = 1;
    //display correct values
    var z = subjectObject[subjectSel.value][this.value];
    for (var i = 0; i < z.length; i++) {
      chapterSel.options[chapterSel.options.length] = new Option(z[i], z[i]);
    }
  }
}

// ==========================================================================
// 카테고리 셀렉트
var subjectObject = {
	"푸드": ["사료", "껌류", "수제간식"],
	"패션/위생": ["의류"],
	"식기/급수기": ["급수기"],
	"장난감/훈련": ["인형"],
	"하우스/안전": ["계단/스텝", "매트"]
}
window.onload = function() {
  var product_categorySel = document.getElementById("product_category");
  var project_category_detailSel = document.getElementById("project_category_detail");
  
  for (var x in subjectObject) {
	  product_categorySel.options[product_categorySel.options.length] = new Option(x, x);
  }
  product_categorySel.onchange = function() {
	  
    project_category_detailSel.length = 1;
	
	var y = subjectObject[this.value];
	
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
		<article>
			<h1 align="center">상품 등록</h1>
			<form action="ProductRegistPro" name="RegistForm" method="post" enctype="multipart/form-data">
				<section class="joinForm1">
					<table id="tb01">
						<tr>
							<td>상품코드</td>
						</tr>
						<tr>
							<td>
<!-- 								<input type="text" name="product_code" size="9" id="product_code"> -->
								<select name="product_code1" id="product_code1">
									<option value="" selected="selected">상위공통코드</option>
								</select>
								<select name="product_code2" id="product_code2">
									<option value="" selected="selected">공통코드</option>
								</select>
								<select name="product_code3" id="product_code3">
									<option value="" selected="selected">공통코드</option>
								</select>
								<input type="text" name="product_code4" size="2">
							</td>
						</tr>	
						<tr>
							<td>상품이름</td>
						</tr>
						<tr>
							<td><input type="text" name="product_name" id="product_name"></td>
						</tr>	
						<tr>
							<td>상품설명</td>
						</tr>
						<tr>
							<td><input type="text" name="product_description" id="product_description"></td>
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
								<select name="project_category_detail" id="project_category_detail">
								    <option value="" selected="selected">세부 카테고리</option>
							   </select>
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
							<td>상품 이미지</td>
						</tr>
						<tr>
							<td class="write_td_left"><label for="board_file">파일첨부</label></td>
							<td class="write_td_right">
								<%-- 파일 첨부 형식은 input 태그의 type="file" 속성 활용 --%>
								<%-- 주의! 파일 업로드를 위해 form 태그 속성에 enctype 속성 필수!  --%>
								<%-- 1) 한번에 하나의 파일(단일 파일) 선택 가능하게 할 경우 --%>
								<input type="file" name="product_img_file1">
							</td>
						</tr>
						<tr>
							<td align="center"><br><input type="submit" value="가입"></td>
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








