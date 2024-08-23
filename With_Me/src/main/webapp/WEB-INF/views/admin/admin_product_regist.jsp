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
<script type="text/javascript">

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
							<td><input type="text" name="product_code" size="9" id="product_code"></td>
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
								<select name="product_category">
									<option value="">카테고리를 선택하세요</option>
									<option value="푸드">푸드</option>
									<option value="패션/위생">패션/위생</option>
									<option value="식기/급수기">식기/급수기</option>
									<option value="장난감/훈련">장난감/훈련</option>
									<option value="하우스/안전">하우스/안전</option>
								</select>
							</td>
						<tr>
							<td>상품 세부카테고리</td>
						</tr>
						<tr>
							<td>
								<select name="project_category_detail">
									<option value="">세부 카테고리를 선택하세요</option>
									<option value="사료">사료</option>
									<option value="껌류">껌류</option>
									<option value="수제간식">수제간식</option>
									<option value="의류">의류</option>
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
<!-- 						<tr> -->
<!-- 							<td>상품상태</td> -->
<!-- 						</tr> -->
<!-- 						<tr>	 -->
<!-- 							<td> -->
<!-- 								<input type="text" name="product_status" id="product_status"> -->
<!-- 							</td> -->
<!-- 						</tr>	 -->
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








