<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<style type="text/css">
		#pageList {
			margin: 30px auto;
			width: 1024px;
			text-align: center;
		}
		.sec02 .itemList {
			height: 100%;
		}
		
		.sec02 .itemList .itemWrapper {
			display: grid;
			grid-template-columns: repeat(4, 1fr);
			gap: 2rem;
		}
		
		.sec02 .itemList .itemWrapper .item {
			width: 100%;
		}
		
		.sec02 .itemList .itemWrapper .item .item_image .like{
			top: 90%;
			bottom: 0;
			left: 90%;
			right: 0;
			width: 20px;
			height: 20px;
		}
		
		.sec02 .itemList .itemWrapper .item .item_info h4 {
			font-size: 13px;	
			font-weight: normal;
			color: #bbb;
		}
		
		.sec02 .itemList .itemWrapper .item .fund_rate_var {
			width: 100%;
			height: 5px;
			background-color: #ffab40;
		}
		</style>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="sec02">
				<h2>${category}</h2>

				<%-- 페이지 번호 기본값 1로 설정 --%>
				<c:set var="pageNum" value="1"/>
				<c:if test="${not empty param.pageNum}">
					<c:set var="pageNum" value="${param.pageNum}"/>
				</c:if>
				
				<div class="itemList">
					<c:if test="${empty projectList}">
						<p>
						${category}에 등록된 펀딩이 없습니다. <br><br>
						이용에 불편을 드려 죄송합니다.
						</p>
					</c:if>
					<div class="itemWrapper">
					<c:forEach var="project" items= "${projectList}">
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
								</a>
								<img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
								
								<!-- 나중에 쓸 채워진 하트 -->
<%-- 								<img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/colored_like.png"> --%>
							</div>
							<div class="item_info">
								<h4><a href="#">${project.creator_name}</a></h4>
								<a href="#">${project.project_title}</a>
							</div>
							
							<div class="fund_info">
							
							</div>
							<div class="fund_rate_var"></div>
						</div>
					</c:forEach>
					</div>
				</div>
			</section>
			
			<section id="pageList">
				<%-- 현재 페이지 번호가 1 보다 클 경우에만 가능하게 해야함 --%>
				<input type="button" value="이전" onclick="location.href='ProjectList?pageNum=${pageNum - 1}'"
						<c:if test="${pageNum <= 1}">disabled</c:if> >
				
				<%-- 계산된 페이지 번호가 저장된 PageInfo 객체를 통해 페이지 번호 출력 --%>
				<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
					
					<c:choose>
						<c:when test="${pageNum eq i}">
							<b>${i}</b>
						</c:when>
						<c:otherwise>
							<a href="ProjectList?pageNum=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				
		<%-- 			<a href="BoardList.bo?pageNum=${i}">${i}</a> --%>
				</c:forEach>
				
				<input type="button" value="다음" onclick="location.href='ProjectList?pageNum=${pageNum + 1}'"
						<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
			</section>
		</div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
	</body>
	
	<script type="text/javascript">
		let tabMenu = document.querySelectorAll('.tabMenu');
		let popularWrapper = document.querySelectorAll('.popularWrapper');
				
		for(let i = 0; i < tabMenu.length; i++){
			tabMenu[i].onclick = function () {
				tabMenu[0].classList.remove('on');
				tabMenu[1].classList.remove('on');
			                  
				tabMenu[i].classList.add('on');
			
				popularWrapper[0].classList.remove('on')
				popularWrapper[1].classList.remove('on')
			
				popularWrapper[i].classList.add('on');
			}
		}
	</script>
</html>




















