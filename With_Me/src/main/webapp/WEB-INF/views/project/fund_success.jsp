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
				<h2><span>${param.FundMemCount}번째</span> 후원자가 돼셨습니다 !</h2>
				
				<p>후원내역은 <a href="MemberInfo">마이페이지</a> 에서 확인 가능합니다.
			</section>
		</div>
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		
		<script type="text/javascript">
			
			
		</script>
	</body>
</html>




















