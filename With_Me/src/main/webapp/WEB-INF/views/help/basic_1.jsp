<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link
	href="${pageContext.request.contextPath }/resources/css/default.css"
	rel="stylesheet" type="text/css">
<style type="text/css">
/* 업데이트된 CSS 스타일 */
#articleForm {
	width: 60%;
	margin: 20px auto;
	padding: 20px;
 	box-shadow: 0 0 1px rgba(0, 0, 0, 0.1); 
	border-radius: 10px;
	background-color: #fff;
}

h2 {
	text-align: left;
	margin-bottom: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

th, td {
/* 	border: 1px solid #ddd; */
	padding: 10px;
	text-align: left;
}
tr {
    border-bottom: solid 1px #F0F0F0 ;
}
th {
	background-color: #f9f9f9;
}

#basicInfoArea {
	margin-bottom: 20px;
}

#articleContentArea {
	background: #f9f9f9;
	padding: 20px;
	border-radius: 5px;
	white-space: pre-line;
	overflow: auto;
}

#commandCell {
	text-align: center;
	margin-top: 20px;
	
}




#list_btn {
	padding: 10px 20px;
	border: none;
	background-color: #FFAB40;
	width: 180px;
	color: white;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s;
}

#list_btn:hover {
	background-color: #fe9100;
}
section {
	min-height: 80px;
}
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section id="articleForm">
			<div align="left">
			<h2>위드미(withme)는 무엇인가요?</h2>
			</div>
<!-- 			<section id="basicInfoArea"> -->
				
<!-- 				<table> -->
<!-- 					<tr> -->
<%-- 						<th width="70">제 목${bo.bo_subject}</th> --%>
<!-- 						<td colspan="3"></td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						작성일시 출력 형식은 ex) 2024-06-04 12:30 -->
<!-- 						<th width="70">작성일시</th> -->
<%-- 						<td><fmt:formatDate value="${bo.bo_sysdate}" --%>
<!-- 								pattern="yyyy-MM-dd" /></td> -->
<!-- 					</tr> -->
<!-- 				</table> -->
<!-- 			</section> -->
			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				 <span>
					안녕하세요, 창조적인 시도를 응원하는 크라우드 펀딩 플랫폼 위드미입니다.<br>
					
					반려견, 반려묘들의 푸드, 패션/위생, 식기/급수기, 장난감, 하우스 등 모든 분야의 창조적인 새로운 시도를 돕고 있으며 창작자들의 비전이 보다 편리한 방법으로 실현될 수 있도록 모든 역량을 기울이고 있습니다.<br>
					
					위드미를 통해 창작 활동에 필요한 자금을 모으고, 창작자들과 함께 아이디어를 실현하고자 하는 후원자를 만나보세요.
				 </span>
			</section>
			<section id="commandCell">
				<!-- 목록 버튼 클릭시 BoardList.bo 서블릿 요청(파라미터 : 페이지번호) -->
				<input type="button" value="다른질문 보러가기"
					onclick="location.href='HelpCenter'" id="list_btn">
			</section>
		</section>
	</main>
	<footer>
		<!-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 -->
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>