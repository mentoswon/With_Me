<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 헬프센터</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">

.qnaWrapper {
    width: 80%;
    margin: 0 auto;
    font-family: Arial, sans-serif;
    padding: 2em;
}

.qnaHeader h2 {
    margin: 0;
    font-size: 24px;
    color: #333;
    text-align: left;
}

.qnaHeader h3 {
    margin: 0;
    font-size: 18px;
    color: #555;
    text-align: left;
    margin-top: 5px;
}

.groupTitle h4 {
    font-size: 16px;
    color: #333;
    margin-bottom: 15px;
    text-align: left;
}

.qnaGroup {
    display: flex;
    justify-content: space-between;
    border: 1px solid #ccc;
    border-radius: 10px;
    padding: 2em;
    margin-bottom: 4em; 
}

.qnaList {
    width: 30%;
}

.qnaList h5 {
    font-size: 16px;
    color: #333;
    margin-bottom: 10px;
    border-bottom: 1px solid #ddd;
    padding-bottom: 5px;
}

.qnaList span {
    display: block;
    margin-bottom: 10px;
    font-size: 14px;
}

.qnaList span a {
    color: #007BFF;
    text-decoration: none;
}

.qnaList span a:hover {
    text-decoration: underline;
}

</style>

</head>
<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<section>
		<div class="qnaWrapper">
			<div class="qnaHeader">
				<h2>헬프센터</h2>
				<h3>무엇을 도와드릴까요?</h3>
			</div>
			<br>
			<div align="left" class="groupcreator_qna_1.jspTitle">
				<h4>도움말</h4>
			</div>
			<div class="qnaGroup">
				<div class="qnaList">
					<h5>위드미 기본</h5>
					<span class="basicList"><a href="Basic1">위드미(withme)는 무엇인가요?</a></span>
					<span class="basicList"><a href="Basic2">크라우드펀딩과 후원이란 무엇인가요?</a></span>
					<span class="basicList"><a href="Basic3">프로젝트 후원은 무엇인가요?</a></span>
					<span class="basicList"><a href="Basic4">선물은 무엇인가요?</a></span>
				</div>	
				
				<div class="qnaList">
					<h5>후원자 질문</h5>
					<span class="creatorQna"><a href="CreatorQna1">결제는 언제 되나요?</a></span>
					<span class="creatorQna"><a href="CreatorQna2">후원을 변경하거나 취소할 수 있나요?</a></span>
					<span class="creatorQna"><a href="CreatorQna3">가능한 결제수단은 무엇인가요?</a></span>
				</div>	
				
				<div class="qnaList">
					<h5>프로젝트 올리기</h5>
					<span class="upload"><a href="UploadQna1">심사관련 자주 묻는 질문</a></span>
					<span class="upload"><a href="UploadQna2">프로젝트 주요일정이 어떻게 되나요?</a></span>
					<span class="upload"><a href="UploadQna3">프로젝트 시작에는 어떤 자격요건이 필요한가요?</a></span>
				</div>	
			</div>
		
		
		</div>
	</section>








	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>