<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
	.inner {
		position: relative;
	}

	section {
		width: 100%;
	    position: absolute;
	    top: 50%;
	    left: 50%;
	    transform: translate(-50%, 30%);
	}
	
	h4 {
		text-align: center;
		font-size: 120px;
		margin: 40px 0;
		color: #ffab40;
	}
	
	p {
		margin: 50px auto;
		text-align: center;
		font-size: 20px;
	}
	
	.main_logo {
		width: 80px;
	    height: 80px;
	    display: block;
	    margin: 0 auto;
	}
	
	.main_logo img{
		width: 100%;
		height: 100%;
	}
	
	div {
		text-align: center;
	}
</style>
</head>
<body>
<div class="inner">
	<section>
		<h4>
			Internet Server Error
		</h4>
		<p>
			서비스 이용에 불편을 드려 죄송합니다. <br>
			시스템 에러가 발생하여 페이지를 표시할 수 없습니다.<br>
			관리자에게 문의하거나 잠시 후 다시 시도해주세요.
		</p>
		<a href="./" class="main_logo">
			<img alt="로고" src="${pageContext.request.contextPath}/resources/image/withme.png">
		</a>
		<div>로고를 클릭하면 홈으로 이동합니다.</div>
	</section>
</div>
</body>
</html>




















