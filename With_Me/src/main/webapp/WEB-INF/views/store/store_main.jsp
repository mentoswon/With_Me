<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>store</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">

</style>
</head>
<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		<div class="inner">
			<section class="sec01">
				<div class="mainWrapper">
					<div class="productMain">
						<div class="mainBanner">
							<img src="">
						</div>
						<div class="categoryList">
							
						</div>
						<div class="product_Category">
							<div class="orderWrapper">
								<ul class="orderList">
									<li class="orderSelect" id="orderList01">인기순</li>
									<li class="orderSelect" id="orderList02">추천순</li>
									<li class="orderSelect" id="orderList03">최신순</li>
								</ul>
							</div>
							<div class="productBox01">
								<div class="product_image">
									<a href="#">
										<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
									</a>
								</div>
								<div class="product_info">
									<h4>00,000원</h4>
									<a href="#">제품명제품명</a>
								</div>
							</div>	
							<div class="productBox01">
								<div class="product_image">
									<a href="#">
										<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
									</a>
								</div>
								<div class="product_info">
									<h4>00,000원</h4>
									<a href="#">제품명제품명</a>
								</div>
							</div>	
							<div class="productBox01">
								<div class="product_image">
									<a href="#">
										<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
									</a>
								</div>
								<div class="product_info">
									<h4>00,000원</h4>
									<a href="#">제품명제품명</a>
								</div>
							</div>	
							<div class="productBox01">
								<div class="product_image">
									<a href="#">
										<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
									</a>
								</div>
								<div class="product_info">
									<h4>00,000원</h4>
									<a href="#">제품명제품명</a>
								</div>
							</div>	
						</div>
					</div>
					<div class="rankList">
					
					</div>
				</div>
			
			</section>
		</div>
		
		
		
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
</body>
</html>