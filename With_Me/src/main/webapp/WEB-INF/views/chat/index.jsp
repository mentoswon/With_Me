<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 외부 CSS 파일(css/default.css) 연결하기 --%>
<%-- JSP MVC 패턴과 디렉토리 구조가 다름. 외부 자원이 위치하는 resources 까지 명시 필수! --%>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
</head>
<body>
	<header>
		<%-- 기본 메뉴 표시 영역(inc/top.jsp) 페이지 삽입 --%>
		<%-- 현재 위치는 컨텍스트 루트(/test2 = webapp) 이며, inc 디렉토리의 top.jsp 지정 --%>
		<%-- 단, JSP 때와 달리 디렉토리 구조가 다르므로 주의! --%>
		<%-- JSP 파일의 루트는 webapp 이 맞지만, 하위 디렉토리로 WEB-INF/views 가 포함되어야함 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<article>
		<%-- 본문 표시 영역 --%>
		<h1>메시지</h1>
		<hr>
		<h3><a href="Chating">1:1 채팅방 입장</a></h3>
		
	</article>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












