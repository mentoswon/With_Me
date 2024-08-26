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
</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	function confirmDelete() {
		// 삭제 버튼 클릭 시 확인창(confirm dialog)을 통해 "삭제하시겠습니까?" 출력 후
		// 다이얼로그의 확인 버튼 클릭 시 "BoardDelete.bo" 서블릿 요청
		// => 파라미터 : 글번호, 페이지번호
		if(confirm("삭제하시겠습니까?")) {
			location.href = "BoardDelete?board_num=${board.board_num}&pageNum=${param.pageNum}";
		}
	}
	// ======================================================================================
	// 대댓글 작성 아이콘 클릭 처리를 위한 reReplyWriteForm() 함수 정의
	function reReplyWriteForm(reply_num, reply_re_ref, reply_re_parent_reply_num, reply_re_lev, reply_re_seq, index) {
// 		console.log("reReplyWriteForm : " + reply_num + ", " + reply_re_ref + ", " + reply_re_lev + ", " + reply_re_seq + ", " + index)
		
		// 기존 대댓글 입력폼 있을 경우를 대비해 대댓글 입력폼 요소(#reReplyTr) 제거
		$("#reReplyTr").remove();
		
		// 지정한 댓글 아래쪽에 대댓글 입력폼 표시
		// => 댓글 요소 tr 태그 지정 후 after() 메서드 호출하여 해당 요소 바깥쪽 뒤에 tr 태그 추가
		// => 해당 댓글 요소의 tr 태그 탐색을 위해 status.index 값을 전달받아 tr 태그 eq(인덱스)로 탐색
		$(".replyTr").eq(index).after(
				'<tr id="reReplyTr">'
				+ '	<td colspan="3">'
				+ '		<form action="BoardTinyReReplyWrite" method="post" id="reReplyForm">'
				+ '			<input type="hidden" name="board_num" value="${board.board_num}">'
				+ '			<input type="hidden" name="reply_num" value="' + reply_num + '">'
				+ '			<input type="hidden" name="reply_re_ref" value="' + reply_re_ref + '">'
				+ '			<input type="hidden" name="reply_re_parent_reply_num" value="' + reply_re_parent_reply_num + '">'
				+ '			<input type="hidden" name="reply_re_lev" value="' + reply_re_lev + '">'
				+ '			<input type="hidden" name="reply_re_seq" value="' + reply_re_seq + '">'
				+ '			<textarea id="reReplyTextarea" name="reply_content"></textarea>'
				+ '			<input type="button" value="댓글쓰기" id="reReplySubmit" onclick="reReplyWrite()">'
				+ '		</form>'
				+ '	</td>'
				+ '</tr>'
			);
		
	
	}
	// 댓글쓰기(대댓글) 버튼 클릭 처리 => AJAX 활용하여 대댓글 등록 처리
	function reReplyWrite() {
		// 대댓글 입력항목(textarea) 체크
		if($("#reReplyTextarea").val() == "") {
			alert("댓글 내용 입력 필수!");
			$("#reReplyTextarea").focus();
			return;
		}
		
		// AJAX 활용하여 대댓글 등록 요청 - BoardTinyReReplyWrite
		$.ajax({
			type : "post",
			url : "BoardTinyRePlyWrite",
			data : $("#reReplyForm").serialize(),
			dataType : "json",
			success : function(response) {
				console.log(JSON.stringify(response));
				console.log(response.isInvalidSession);
				if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
					alert("잘못된 접근입니다!");
				} else if(!response.result) { // 댓글 등록 실패일 경우
					alert("댓글 등록 실패!\n잠시 후 다시 시도해 주시기 바랍니다.");
				} else if(response.result) { // 댓글 등록 성공일 경우
					location.reload(); // 현재 페이지 갱신(새로고침)
				}
			},
			error : function() {
				alert("댓글 작성 요청 실패!");
			}
		});
	}
	
	// -----------------------------------------------------------------
	// 댓글 삭제 아이콘 클릭 처리를 위한 confirmReplyDelete() 함수 정의
	function confirmReplyDelete(reply_num, index) {
// 		console.log("confirmReplyDelete : " + reply_num + ", " + index)
		
		if(confirm("댓글을 삭제하시겠습니까?")) {
			// AJAX 활용하여 "BoardTinyReplyDelete" 서블릿 요청(파라미터 : 댓글번호) - POST
			$.ajax({
				type : "POST",
				url : "BoardTinyReplyDelete",
				data : {
					"reply_num" : reply_num
				},
				dataType : "json",
				success : function(response) {
					console.log(JSON.stringify(response));
					console.log(response.isInvalidSession);
					if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
						alert("잘못된 접근입니다!");
					} else if(!response.result) { // 댓글 삭제 실패일 경우
						alert("댓글 삭제 실패!\n잠시 후 다시 시도해 주시기 바랍니다.");
					} else if(response.result) { // 댓글 삭제 성공일 경우
// 						location.reload(); // 현재 페이지 갱신(새로고침)
						// ------------------------------------------------------
						// 페이지 갱신 대신 index 값을 활용한 tr 태그 삭제(제거)
						$(".replyTr").eq(index).remove();
						// 여기서 index는 밑에 tr에 순서를 주는 느낌이여서 해당 tr를 제거하는 듯한 느낌 						
					}
				},
				error : function() {
					alert("댓글 삭제 요청 실패!");
				}
			});
		}
	}

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
	<!-- 게시판 상세내용 보기 -->
	<article id="articleForm">
		<h2 align="center">상품 상세내용</h2>
			<form action="MemberJoinPro" name="joinForm" method="post">
				<section class="joinForm1">
					<input type="hidden" name="product_idx">
					<table id="tb01">
						<tr>
						</tr>
						<tr>
							<td>상품코드</td>
						</tr>
						<tr>
							<td><input type="text" name="product_code" value="${product.product_code}" id="product_code"></td>
						</tr>	
						<tr>
							<td>상품명</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_name" id="product_name" value="${product.product_name}">
							</td>
						</tr>	
						<tr>
							<td>상품설명</td>
						</tr>
						<tr>
							<td>
								<input type="text" name="product_description" id="product_description" value="${product.product_description}">
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
							<td>상품가격</td>
						</tr>
						<tr>
							<td><input type="text" name="product_price" id="product_price" value="${product.product_price}">
							</td>
						</tr>
						<tr>
							<td>재고수량</td>
						</tr>
						<tr>
							<td><input type="text" name="product_stock" id="product_stock" value="${product.product_stock}">
							</td>
						</tr>	
						<tr>
							<td>상품상태</td>
						</tr>
						<tr>
							<c:choose>
								<c:when test="${product.product_status eq 1}">
									<td>판매중</td>
								</c:when>
								<c:when test="${product.product_status eq 2}">
									<td>판매중지</td>
								</c:when>
								<c:when test="${product.product_status eq 2}">
									<td>품절</td>
								</c:when>
							</c:choose>
						</tr>	
						<tr>
							<td align="center"><br>
								<input type="submit" value="가입">
								<input type="button" value="수정" onclick="location.href='ProductModify?product_idx=${product.product_idx}&pageNum=${param.pageNum}'">
								<input type="button" value="삭제" onclick="confirmDelete()">
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















