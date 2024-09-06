<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<script type="text/javascript">
		// JSP 내장객체 request 의 "msg" 속성값을 자바스크립트 alert() 함수로 출력
		alert("${msg}"); // requestScope 영역 객체 지정 생략 가능
		// 1) JSTL 과 EL 을 조합하여 request 객체의 "targetURL" 속성이 비어있을 경우
		// 이전페이지로 돌아가기 수행하고, 아니면 "targetURL" 속성에 지정된 페이지로 이동
		// => 주의! 자바스크립트 내에 JSTL 코드 사용 시 JSTL 색상 표기가 되지 않지만
		//    실제로는 서버에서 해당 코드가 정상적으로 처리된다!
		// => 또한, 주석 처리 과정에서 자동 주석 처리 시 자바스크립트 주석으로 처리되지만
		//    서버에서 실행되지 않도록 하기 위해서는 강제로 JSP 주석으로 처리해야한다!
		
		// "isClose" 속성값이 "ture" 일 경우 (또는 비어있지 않을 경우) 현재 창 닫기
		// "${isCLose}" == true 대신 "${isCLose}"만 지정해도 됨 
		if("${isClose}") { // 자바스크립트는 문자열이 비어있으면 false임
			// 부모창 새로고침 후 자식창 닫기
			window.opener.location.reload(); // 부모창 제어하려면 window.opener를 앞에 붙여줘야함
			window.close();
		}
		// 2) 자바스크립트의 조건문으로 판별
		// => EL 을 통해 targetURL 속성값을 가져와서 자바스크립트 if 문으로 판별
		//    (전달받은 속성값이 없을 경우 널스트링 값이 출력되므로 자바스크립트 "" 값과 비교)
		// => 자바 문자열 데이터를 자바스크립트로 판별 시 EL 문장을 "" 따옴표로 둘러싸야한다!
		if("${targetURL}" == "") {
			history.back();
		} else {
			location.href = "${targetURL}";
		}
	</script>
</body>
</html>










