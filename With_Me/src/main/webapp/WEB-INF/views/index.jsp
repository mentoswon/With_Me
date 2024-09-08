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
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
	$(function (){
		let slideIndex = 1;
		showSlides(slideIndex);
		
		// Next/previous controls
		function plusSlides(n) {
			showSlides(slideIndex += n);
		}
		
		// Thumbnail image controls
		function currentSlide(n) {
			showSlides(slideIndex = n);
		}
		
		function showSlides(n) {
			let i;
			let slides = document.getElementsByClassName("mySlides");
			
			if (n > slides.length) {
				slideIndex = 1;
			}
			if (n < 1) {
				slideIndex = slides.length;
			}
			
			// 모든 슬라이드를 숨기고 클래스 제거
			for (i = 0; i < slides.length; i++) {
				slides[i].classList.remove('fade');
			}
			
			// 현재 슬라이드를 보여주고 활성화된 점을 표시
			slides[slideIndex - 1].classList.add('fade');
		}
		
		// Auto slide every 5 seconds
		setInterval(function() {
			plusSlides(1); // Move to the next slide
		}, 5000); // 5000 milliseconds = 5 seconds
	});
</script>
</head>
<body>
<header>
	<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
</header>

<div class="inner">
	<section class="sec01">
		<div class="mainWrapper">
			<div id="mainBanner">
				<div class="slideshow-container">
					<div class="mySlides fade">
						<img src="https://puppydog.co.kr/web/upload/appfiles/0zdpAngaKBFnlCcCqpCU4A/ff643a9b4816f7173f45188aba4c8707.jpg" style="width:100%">
					</div>
					
					<div class="mySlides">
						<img src="https://puppydog.co.kr/web/upload/appfiles/0zdpAngaKBFnlCcCqpCU4A/c4f80a5d10178e13cb76c6b9dcf3fdb2.jpg" style="width:100%">
					</div>
					
					<div class="mySlides">
						<img src="https://puppydog09.openhost.cafe24.com/web/upload/appfiles/0zdpAngaKBFnlCcCqpCU4A/db4f9bfbcc7182cdd172831929f8b60d.png" style="width:100%">
					</div>
				</div>
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
					
						<!-- 오늘 날짜 추출 -->
						<c:set var="now" value="<%=new java.util.Date()%>" />
						<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
						<!-- 오늘 날짜 추출 end -->
						
						<c:set var="limit" value="0"/>
						<c:forEach items="${projectList}" varStatus="status">
							<c:if test="${projectList[status.index] != null and limit < 4}">
								<div class="item">
									<div class="item_image">
										<a href="ProjectDetail?project_title=${projectList[status.index].project_title}&project_code=${projectList[status.index].project_code}">
											<img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${projectList[status.index].project_image}">
										</a>
										<c:choose>
											<c:when test="${projectList[status.index].like_mem_email eq sId and projectList[status.index].like_status eq 'Y'}">
												<button class="like Btn" type="button" onclick="cancleLike('${projectList[status.index].project_code}', '${sId}')">
													<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
												</button>
											</c:when>
											<c:otherwise>
												<button class="like Btn" type="button" onclick="registLike('${projectList[status.index].project_code}', '${sId}')">
													<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
												</button>
											</c:otherwise>
										</c:choose>
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
				<c:forEach items="${popularProList}" varStatus="status">
					<c:if test="${popularProList[status.index] != null and limit < 5}">
						<div class="popularItem">
							<b>${status.index + 1}</b>
							<div class="popTitle">
								<span><a href="OtherMemberInfo?creator_email=${popularProList[status.index].creator_email}">${popularProList[status.index].creator_name}</a></span>
								<h3><a href="ProjectDetail?project_title=${popularProList[status.index].project_title}&project_code=${popularProList[status.index].project_code}">${popularProList[status.index].project_title}</a></h3>
								
								<%-- 펀딩률 --%>
								<fmt:parseNumber var="funding_amt" value="${popularProList[status.index].funding_amt*1.0}" ></fmt:parseNumber>
								<fmt:parseNumber var="target_price" value="${popularProList[status.index].target_price}" ></fmt:parseNumber>
								
								<c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
								
								<span><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>% 달성</span>
							</div>
							<div class="popular_image">
								<a href="ProjectDetail?project_title=${popularProList[status.index].project_title}&project_code=${popularProList[status.index].project_code}">
									<img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${popularProList[status.index].project_image}">
								</a>
							</div>
						</div>
					</c:if>
				</c:forEach>
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
								<c:choose>
									<c:when test="${storeList[status.index].like_mem_email eq sId and storeList[status.index].like_status eq 'Y'}">
										<button class="like Btn" type="button" onclick="CancleLikeProduct('${storeList[status.index].product_code}', '${sId}')">
											<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
										</button>
									</c:when>
									<c:otherwise>
										<button class="like Btn" type="button" onclick="RegistLikeProduct('${storeList[status.index].product_code}', '${sId}')">
											<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
										</button>
									</c:otherwise>
								</c:choose>
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
		
		// 프로젝트 좋아요
		function registLike(project_code, sId) {
				console.log("project_code : " + project_code + ", sId : " + sId);
			if(confirm("프로젝트를 좋아요 하시겠습니까?")){
				$.ajax({
					url: "RegistLike",
					type : "POST",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"like_project_code": project_code,
						"like_mem_email": sId
					},
					dataType: "json",
					success: function (response) {
						if(response.result){
							alert("좋아한 프로젝트에 추가되었습니다.");
							location.reload();
						} else if(!response.result) {
							alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
							location.href="MemberLogin";
						}
					}
				});
			}
		}
		
		// 프로젝트 좋아요 취소
		function cancleLike(project_code, sId) {
				console.log("project_code : " + project_code + ", sId : " + sId);
			$.ajax({
				url: "CancleLike",
				type : "POST",
				async:false, // 이 한줄만 추가해주시면 됩니다.
				data:{
					"like_project_code": project_code,
					"like_mem_email": sId
				},
				dataType: "json",
				success: function (response) {
					if(response.result){
						alert("좋아요가 취소되었습니다.");
						location.reload();
					} else if(!response.result) {
						alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
						location.href="MemberLogin";
					}
				}
			});
		}
		
		// ===========================================
		// 상품 좋아요
		function RegistLikeProduct(product_code, sId) {
			console.log("product_code : " + product_code + ", sId : " + sId);
			if(confirm("해당 상품을 좋아요 하시겠습니까?")){
				$.ajax({
					url : "RegistLikeProduct",
					type : "POST",
//						async: false,
					data:{
						"like_product_code": product_code,
						"like_mem_email": sId
					},
					dataType: "json",
					success: function (response) {
						if(response.result) {
							alert("해당 상품이 좋아요 리스트에 추가 되었습니다");
							location.reload();
							
						} else if(!response.result) {
							alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
							location.href="MemberLogin";
						}
					}
				});
			}
		}
			
		// 상품 좋아요 취소 
		function CancleLikeProduct(product_code, sId) {
			$.ajax({
				url : "CancleLikeProduct",
				type : "POST",
//					async:false,
				data :{
					"like_product_code" : product_code,
					"like_mem_email" : sId
				}, 
				dataType: "json",
				success: function(response) {
					if(response.result) {
						alert("좋아요가 취소되었습니다.");
						location.reload();
					} else if(!response.result) {
						alert("로그인 후 이용 가능합니다. \n로그인 페이지로 이동합니다.");
						location.href="MemberLogin";
					}
				} 
			});
		}
	</script>
</html>




















