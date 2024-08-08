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
					</div>
					<div class="itemList">
						<div id="category01">
							<div class="cateTitle">
								<h4>해피 멍뭉 시리즈</h4>
								<img class="more" alt="더보기" src="${pageContext.request.contextPath}/resources/image/plus.png">
							</div>
							<div class="itemWrapper">
								<div class="item">
									<div class="item_image">
										<a href="#">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
										</a>
									</div>
									<div class="item_info">
										<h4>55% 달성</h4>
										<a href="#">제목</a>
									</div>
									<span class="tag">펀딩</span>
								</div>
								
								<div class="item">
									<div class="item_image">
										<a href="#">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/Sample3.jpg">
										</a>
									</div>
									<div class="item_info">
										<h4>55% 달성</h4>
										<a href="#">제목</a>
									</div>
									<span class="tag">펀딩</span>
								</div>
							</div>
						</div>
						<div id="category02">
							<div class="cateTitle">
								<h4>해피 냥냥 시리즈</h4>
								<img class="more" alt="더보기" src="${pageContext.request.contextPath}/resources/image/plus.png">
							</div>
							<div class="itemWrapper">
								<div class="item">
									<div class="item_image">
										<a href="#">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample.jpg">
										</a>
									</div>
									<div class="item_info">
										<h4>55% 달성</h4>
										<a href="#">제목</a>
									</div>
									<span class="tag">펀딩</span>
								</div>
								
								<div class="item">
									<div class="item_image">
										<a href="#">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample.jpg">
										</a>
									</div>
									<div class="item_info">
										<h4>55% 달성</h4>
										<a href="#">제목</a>
									</div>
									<span class="tag">펀딩</span>
								</div>
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
			
			<section class="sec02">
				<h4>컨텐츠 제목 입력</h4>
				
				<div class="itemList">
					<div class="itemWrapper">
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4>55% 달성</h4>
								<a href="#">제목</a>
							</div>
							<span class="tag">펀딩</span>
						</div>
						
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4>55% 달성</h4>
								<a href="#">제목</a>
							</div>
							<span class="tag">펀딩</span>
						</div>
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4>55% 달성</h4>
								<a href="#">제목</a>
							</div>
							<span class="tag">펀딩</span>
						</div>
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4>55% 달성</h4>
								<a href="#">제목</a>
							</div>
							<span class="tag">펀딩</span>
						</div>
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4>55% 달성</h4>
								<a href="#">제목</a>
							</div>
							<span class="tag">펀딩</span>
						</div>
					</div>
				</div>
			</section>
			
			<section class="sec03">
				<h4>컨텐츠 제목 입력</h4>
				<div class="itemList">
					<div class="itemWrapper">
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4><a href="#">제품명</a></h4>
								<span><fmt:formatNumber value="10000" pattern="#,###"/>원</span>
							</div>
						</div>
						
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4><a href="#">제품명</a></h4>
								<span><fmt:formatNumber value="10000" pattern="#,###"/>원</span>
							</div>
						</div>
						<div class="item">
							<div class="item_image">
								<a href="#">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/catSample3.jpg">
								</a>
							</div>
							<div class="item_info">
								<h4><a href="#">제품명</a></h4>
								<span><fmt:formatNumber value="10000" pattern="#,###"/>원</span>
							</div>
						</div>
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




















