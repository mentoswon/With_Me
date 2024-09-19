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

#select-container {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 10px;
}

button {
    padding: 5px 10px;
    background-color: #FFAB40;
    border: none;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background-color: #ff8c00;
}
</style>
</head>
<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
<!-- 	<form action="RegistCode" method="post"> -->
		<div id="commonCode">
			<select name="SelectCode">
				<option value="FUND">FUND(펀드)</option>
				<option value="SHOP">SHOP(스토어)</option>
			</select>
			<button id="addButton">상위 공통코드 추가</button>
			<button id="addSubButton">하위 공통코드 추가</button>
		</div>
		<div>
			<input type="submit" value="등록">
		</div>
<!-- 	</form> -->
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
<script>

document.getElementById('addButton').addEventListener('click', function() {
	
	// 새로운 셀렉트박스 생성
	const newSelect = document.createElement('select');
	newSelect.name = 'SelectCode';
	
	// 새 셀렉트 박스에 옵션 추가
	const newSelectOption1 = document.createElement('option');
	newSelectOption1.value = 'FO';
	newSelectOption1.textContent = 'FO(푸드)';
	
	const newSelectOption2 = document.createElement('option');
	newSelectOption2.value = 'FA';
	newSelectOption2.textContent = 'FA(패션/위생)';
	
	const newSelectOption3 = document.createElement('option');
	newSelectOption3.value = 'CL';
	newSelectOption3.textContent = 'CL(식기/급수기)';
	
	const newSelectOption4 = document.createElement('option');
	newSelectOption4.value = 'TO';
	newSelectOption4.textContent = 'TO(장난감/훈련)';
	
	const newSelectOption5 = document.createElement('option');
	newSelectOption5.value = 'SA';
	newSelectOption5.textContent = 'SA(하우스/안전)';
	
	newSelect.appendChild(newSelectOption1);
	newSelect.appendChild(newSelectOption2);
	newSelect.appendChild(newSelectOption3);
	newSelect.appendChild(newSelectOption4);
	newSelect.appendChild(newSelectOption5);
	
// 	// 새로운 하위 셀렉트박스 생성
// 	const newSelect2 = document.createElement('select');
// 	newSelect2.name = 'SelectCode';
	
// 	// 새 하위 셀렉트 박스에 옵션 추가
// 	const newSubSelectOption1 = document.createElement('option');
// 	newSubSelectOption1.value = 'FEE';
// 	newSubSelectOption1.textContent = 'FEE(사료)';
	
// 	newSelect2.appendChild(newSubSelectOption1);
	
	document.getElementById('commonCode').appendChild(newSelect);
// 	document.getElementById('commonCode').appendChild(newSelect2);
});

// ------------------------------------------------------------------------
document.getElementById('addSubButton').addEventListener('click', function() {
	
	// 새로운 셀렉트박스 생성
	const newSelect = document.createElement('select');
	newSelect.name = 'SelectCode';
	
	// 새 셀렉트 박스에 옵션 추가
	const newSelectOption1 = document.createElement('option');
	newSelectOption1.value = 'FEE';
	newSelectOption1.textContent = 'FEE(사료)';
	
	const newSelectOption2 = document.createElement('option');
	newSelectOption2.value = 'GUM';
	newSelectOption2.textContent = 'FUM(껌류)';
	
	const newSelectOption3 = document.createElement('option');
	newSelectOption3.value = 'HAN';
	newSelectOption3.textContent = 'HAN(수제간식)';
	
	const newSelectOption4 = document.createElement('option');
	newSelectOption4.value = 'CLO';
	newSelectOption4.textContent = 'CLO(의류)';
	
	const newSelectOption5 = document.createElement('option');
	newSelectOption5.value = 'TOI';
	newSelectOption5.textContent = 'TOI(화장실)';
	
	const newSelectOption6 = document.createElement('option');
	newSelectOption6.value = 'FDR';
	newSelectOption6.textContent = 'FDR(급식기)';
	
	const newSelectOption7 = document.createElement('option');
	newSelectOption7.value = 'WAT';
	newSelectOption7.textContent = 'WAT(급수기)';
	
	const newSelectOption8 = document.createElement('option');
	newSelectOption8.value = 'TOY';
	newSelectOption8.textContent = 'TOY(장난감)';
	
	const newSelectOption9 = document.createElement('option');
	newSelectOption9.value = 'TRA';
	newSelectOption9.textContent = 'TRA(훈련용품)';
	
	const newSelectOption10 = document.createElement('option');
	newSelectOption10.value = 'HOU';
	newSelectOption10.textContent = 'HOU(하우스)';
	
	const newSelectOption11 = document.createElement('option');
	newSelectOption11.value = 'FEN';
	newSelectOption11.textContent = 'FEN(울타리)';
	
	const newSelectOption12 = document.createElement('option');
	newSelectOption12.value = 'ETC';
	newSelectOption12.textContent = 'ETC(기타안전용품)';
	
	newSelect.appendChild(newSelectOption1);
	newSelect.appendChild(newSelectOption2);
	newSelect.appendChild(newSelectOption3);
	newSelect.appendChild(newSelectOption4);
	newSelect.appendChild(newSelectOption5);
	newSelect.appendChild(newSelectOption6);
	newSelect.appendChild(newSelectOption7);
	newSelect.appendChild(newSelectOption8);
	newSelect.appendChild(newSelectOption9);
	newSelect.appendChild(newSelectOption10);
	newSelect.appendChild(newSelectOption11);
	newSelect.appendChild(newSelectOption12);
	
	document.getElementById('commonCode').appendChild(newSelect);
});

</script>
</html>








