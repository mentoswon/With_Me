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
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="sec01">
				<div class="mainWrapper">
					<div id="mainBanner">
						<!-- 메인배너 자리 (슬라이드로 할지 .. 그냥 이미지 박을지 .. -->
						<img class="bannerImg" alt="배너" src="${pageContext.request.contextPath}/resources/image/cuteDog3.jpg">
					</div>
					<div class="itemList">
						<div id="category01">
							<div class="cateTitle">
								<h4>주목할 만한 프로젝트</h4>
								<a href="ProjectList?project_category=푸드">
									<img class="more" alt="더보기" src="${pageContext.request.contextPath}/resources/image/plus.png">
								</a>
							</div>
							<div class="itemWrapper">
								<c:set var="limit" value="0"/>
								<c:forEach items="${projectList}" varStatus="status">
									<c:if test="${projectList[status.index] != null and limit < 4}">
										<div class="item">
											<div class="item_image">
												<a href="ProjectDetail?project_title=${projectList[status.index].project_title}&project_code=${projectList[status.index].project_code}">
													<img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${projectList[status.index].project_image}">
												</a>
											</div>
											<div class="item_info">
											
												<%-- 펀딩률 --%>
												<fmt:parseNumber var="funding_amt" value="${projectList[status.index].funding_amt*1.0}" ></fmt:parseNumber>
												<fmt:parseNumber var="target_price" value="${projectList[status.index].target_price}" ></fmt:parseNumber>
												
												<c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
												
												
												<c:choose>
													<c:when test="${fund_rate eq 0.0}">
														<h4>0% 달성</h4>
													</c:when>
													<c:otherwise>
														<h4><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>% 달성</h4>
													</c:otherwise>
												</c:choose>
												<a href="ProjectDetail?project_title=${projectList[status.index].project_title}&project_code=${projectList[status.index].project_code}">${projectList[status.index].project_title}</a>
											</div>
											<span class="tag">펀딩</span>
										</div>
									<c:set var="limit" value="${limit + 1}"/>
									</c:if>
								</c:forEach>
							</div>
						</div>
					</div>
				</div>
				
				<div class="popularList">
					<h3 style="margin: 15px 0 ; text-align: left;">실시간 랭킹</h3>
					<div id="tabMenu">
						<ul>
							<li class="tabFunding tabMenu on">펀딩</li>
							<li class="tabStore tabMenu">스토어</li>
						</ul>
					</div>
					
					<!-- 펀딩 실시간 랭킹 -->
					<div class="popularWrapper on">
						<%-- 해원 ) 반복문 사용 예정. 임시로 여러개 넣어둠 --%>
						<div class="popularItem">
							<b>1</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
								<span>55% 달성</span>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>2</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
								<span>55% 달성</span>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>3</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
								<span>55% 달성</span>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>4</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
								<span>55% 달성</span>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>5</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
								<span>55% 달성</span>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
								</a>
							</div>
						</div>
					</div>
					
					<!-- 스토어 실시간 랭킹 -->
					<div class="popularWrapper">
						<%-- 해원 ) 반복문 사용 예정. 임시로 여러개 넣어둠 --%>
						<div class="popularItem">
							<b>1</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample2.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>2</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample2.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>3</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample2.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>4</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample2.jpg">
								</a>
							</div>
						</div>
						<div class="popularItem">
							<b>5</b>
							<div class="popTitle">
								<span><a href="#">창작자명</a></span>
								<h3><a href="#">제목</a></h3>
							</div>
							<div class="popular_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample2.jpg">
								</a>
							</div>
						</div>
					</div>
				</div>
			</section>
			
			<section class="sec03">
				<h4>위드미의 PICK !</h4>
				<div class="itemList">
					<div class="itemWrapper">
						<c:set var="limit" value="0"/>
						<c:forEach items="${storeList}" varStatus="status">
							<c:if test="${storeList[status.index] != null and limit < 3}">
								<div class="item">
									<div class="item_image">
										<a href="StoreDetail?product_name=${storeList[status.index].product_name}&product_code=${storeList[status.index].product_code}">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/${storeList[status.index].product_img}">
										</a>
									</div>
									<div class="item_info">
										<h4><a href="StoreDetail?product_name=${storeList[status.index].product_name}&product_code=${storeList[status.index].product_code}">${storeList[status.index].product_name}</a></h4>
										<span><fmt:formatNumber value="${storeList[status.index].product_price}" pattern="#,###"/>원</span>
									</div>
								</div>
								<c:set var="limit" value="${limit + 1}"/>
							</c:if>
						</c:forEach>
					</div>
				</div>
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




















