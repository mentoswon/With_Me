<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>With_Me</title>
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<style type="text/css">
			section {
				margin: 60px auto;
				width: 60%;
			}
			
			.inner .con01 h2 {
				text-align: center;
				margin-bottom: 20px;
			}	
			
			.inner .con01 h2 span {
				color: #ffab40;
				
			}
			
			.inner .con01 p {
				text-align: center;
			}
			
			.inner .con01 p a{
				text-decoration: underline;
				color: #ffab40;
			}
			
			
		</style>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="con01">
				<h2>축하합니다 ! </h2>
				<h2>주문이 완료 되었습니다 !</h2>
				
				<p>주문내역은 <b><a href="MemberInfo">마이페이지</a></b> 에서 확인 가능합니다.</p><br>
				<p><b><a href="./">계속 주문 하시겠습니까?</a></b></p>
			</section>
		</div>
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		
		<script type="text/javascript">
			
			
		</script>
	</body>
</html>




















