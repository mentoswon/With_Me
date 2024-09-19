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
	
	td {
	    vertical-align: top;
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
    "패션/위생": ["의류", "화장실"],
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
		<h2 align="center">상품 수정</h2>
			<form action="ProductModify" name="ProductForm" method="post" enctype="multipart/form-data">
				<section class="ProductForm1">
					<input type="hidden" name="product_idx" id="product_idx" value="${store.product_idx}">
					<table id="tb01">
						<tr>
							<td>상품코드</td>
						</tr>
						<tr>
							<td><input type="text" name="product_code" value="${store.product_code}" id="product_code"></td>
						</tr>	
						<tr>
							<td>상품명</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_name" id="product_name" value="${store.product_name}">
							</td>
						</tr>	
						<tr>
							<td>상품설명</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_description" id="product_description" value="${store.product_description}">
							</td> 
						</tr>	
						<tr>
							<td>상품 카테고리</td>
						</tr>
						<tr>
			                <td>
			                    <select name="product_category" id="product_category">
			                        <option value="">카테고리를 선택하세요</option>
			                    </select>
			                </td>
						</tr>	
						<tr>
							<td>상품 세부카테고리</td>
						</tr>
						<tr>
			                <td>
			                    <select name="product_category_detail" id="product_category_detail">
			                        <option value="">세부 카테고리를 선택하세요</option>
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
							<td><input type="text" name="product_price" id="product_price" value="${store.product_price}">
							</td>
						</tr>
						<tr>
							<td>재고수량</td>
						</tr>
						<tr>
							<td><input type="text" name="product_stock" id="product_stock" value="${store.product_stock}">
							</td>
						</tr>	
						<tr>
							<td>상품상태</td>
						</tr>
						<tr>
							<td>
								<select name="product_status">
									<option value="1" <c:if test="${store.product_status eq '1'}">selected</c:if>>판매중</option>
									<option value="2" <c:if test="${store.product_status eq '2'}">selected</c:if>>판매중지</option>
									<option value="3" <c:if test="${store.product_status eq '3'}">selected</c:if>>품절</option>
								</select>
							</td>
<%-- 							<c:choose> --%>
<%-- 								<c:when test="${store.product_status eq 1}"> --%>
<!-- 									<td>판매중</td> -->
<%-- 								</c:when> --%>
<%-- 								<c:when test="${store.product_status eq 2}"> --%>
<!-- 									<td>판매중지</td> -->
<%-- 								</c:when> --%>
<%-- 								<c:when test="${store.product_status eq 2}"> --%>
<!-- 									<td>품절</td> -->
<%-- 								</c:when> --%>
<%-- 							</c:choose> --%>
						</tr>
						<tr>
							<td>상품사진</td>
						</tr>
						<tr>
							<td class="product_img" colspan="2">
								<div>
									<img
										src="${pageContext.request.contextPath}/resources/upload/${store.product_img}"
										id="img1" class="feed" name="product_img">
								</div>
								<div>
									<img
										src="${pageContext.request.contextPath}/resources/upload/${store.product_img2}"
										id="img1" class="feed" name="product_img2">
								</div>
							</td>
						</tr>
<!-- 						<tr><td width="70">파일</td> -->
<!-- 						</tr>	 -->
						<tr>
<!-- 							<td class="td_left"><label for="product_img">파일첨부</label></td> -->
							<td class="td_right">
								<%-- 파일명 존재 여부 판별 --%>
								<%-- 
								<c:forEach> 태그를 활용하여 fileList 객체의 요소 갯수만큼 반복
								=> varStatus 속성을 지정하여 요소 인덱스값 또는 요소 순서번호 확인 가능
								   (요소 인덱스 : 속성명.index   요소 순서번호 : 속성명.count)
								--%>
								<c:forEach var="fileName" items="${fileList}" varStatus="status">
									<%-- div 태그로 파일 1개의 영역 지정(파일 항목 구분을 위해 class 선택자 뒤에 번호 결합 --%>
									<div class="file file_item_${status.count}">
										<c:choose>
											<c:when test="${not empty fileName}">
												<%-- 파일명 존재할 경우 원본 파일명 출력 --%>
												${originalFileList[status.index]}
												<%-- 파일 삭제 링크(이미지) 생성(개별 삭제 위함) --%>
												<%-- 삭제 아이콘 클릭 시 deleteFile() 함수 호출(파라미터 : 글번호, 파일명, 카운팅번호) --%>
												<a href="javascript:deleteFile(${store.product_idx}, '${fileName}', ${status.count})">
													<img src="${pageContext.request.contextPath}/resources/image/delete-icon.png" class="img_btn_delete" title="파일삭제">
												</a>
												<%-- 파일명만 표시하는 경우에도 파일업로드 요소 생성하여 파라미터는 전달되도록 하기 --%>
												<%-- 단, 사용자에게 보이지 않도록 숨김 처리를 위해 hidden 속성 적용 --%>
												<input type="file" name="product_img_file${status.count}" hidden>
											</c:when>
											<c:otherwise>
												<%-- 
												파일명이 존재하지 않을 경우 파일 업로드 항목 표시
												=> name 속성값을 다르게 부여하기 위해 
												   file 문자열과 카운팅을 위한 값 ${status.count} 결합하여 name 지정
												   (ex. "file" + 1 = "file1") 
												--%>
												<%--  --%>
												<input type="file" name="product_img_file${status.count}">
											</c:otherwise>
										</c:choose>
									</div>
								</c:forEach>
							</td>
						</tr>	
						<tr>
							<td align="center"><br>
								<input type="submit" class="button" value="수정" onclick="return confirm('상품 수정이 완료되었습니다.');">
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
















