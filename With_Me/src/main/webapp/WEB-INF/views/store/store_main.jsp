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
/* section { */
/* 	margin: 40px 0; */
/* } */

/* .sec01 { */
/* 	display: flex; */
/* 	justify-content: space-between; */
/* } */

/* /*  🤞🤞 배너&아이템 목록  */ */
/* .sec01 .mainWrapper  { */
/* /* 	background-color: blue; */ */
/* 	width: 70%; */
/* } */


/* .sec01 .mainWrapper{ */
/* 	display: block; */
/* /* 	background-color: yellow; */ */
/* 	width: 100%; */
/* 	height: 100%; */
/* 	position: relative; */
/* 	overflow: hidden; */
/* } */
/* .prouctMain { */
/* 	width: 100%; */
/* 	overflow: hidden; */
/* } */


/* .bannerImg { */
/* 	width:100%; */
/* 	height:300px; */
/* } */


/* .orderWrapper  { */
/* 	width:30%; */
/* 	align-content: left; */
/* 	margin-top: 2em; */
/* } */
/* .orderWrapper .orderSelect { */
	
/* } */

/* .product_Category { */
/* 	display:block; */
/* 	margin-top: 2em; */
	
/* } */

/* .productBox01 { */
/* 	align-items: center; */
/* } */

/* .productBox01 .product_image a>img .product_info{ */
/* 	display: flex; */
/* 	justify-content: space-between; */
/* 	width: 25%; */
/* } */

.boxWrapper { 
 	display: flex; 
    justify-content: space-between; 
    width: 100%; 
    margin-top: 2em; 
 } 
 
/* 정렬 옵션 박스 스타일 */
.orderWrapper {
    display: flex; /* 플렉스박스를 사용하여 항목을 배치 */
    justify-content: left; /* 항목들을 가운데 정렬 */
    align-items: center; /* 수직으로 가운데 정렬 */
    margin-top: 20px; /* 위쪽 여백을 늘려서 간격 조정 */
    margin-bottom: 20px; /* 아래쪽 여백을 늘려서 간격 조정 */
    gap: 30px; /* 인기순, 추천순, 최신순 간의 간격을 늘림 */
}
.orderSelect:hover {
    color: #FFAB40; /* 마우스 오버 시 배경색을 살짝 변경 */
    cursor: pointer;
}
/* ====================================================================*/
/* 배너 이미지 스타일 */
.mainBanner {
    width: 100%; /* 배너가 전체 너비를 차지하도록 설정 */
    height: 300px; /* 배너 높이를 300px로 설정 */
    overflow: hidden; /* 이미지가 넘치지 않도록 설정 */
    margin-bottom: 20px; /* 아래쪽 여백 설정 */
}

.mainBanner img {
    width: 100%; /* 이미지가 배너의 너비에 맞도록 설정 */
    height: 100%; /* 이미지가 배너의 높이에 맞도록 설정 */
    object-fit: cover; /* 이미지가 배너에 맞춰 잘리도록 설정 */
}
/* 전체 콘텐츠를 감싸는 메인 래퍼 */
.mainWrapper {
    max-width: 1200px; /* 최대 너비 설정 */
    margin: 0 auto; /* 중앙 정렬 */
    padding: 20px; /* 내부 여백 */
}

/* 제품 박스들이 담긴 메인 영역 */
.productMain {
    display: flex; /* 플렉스박스를 사용하여 레이아웃 설정 */
    flex-wrap: wrap; /* 여러 줄로 박스들이 배치되도록 설정 */
    justify-content: space-between; /* 박스들 사이 간격 조절 */
    gap: 20px; /* 박스들 사이에 일정한 간격 추가 */
}

/* 개별 제품 박스 스타일 */
.productBox01 {
    width: 20%; /* 4열 그리드 설정 */
    height: 250px; /* 박스의 전체 높이를 300px로 제한 */
    margin-bottom: 20px; /* 아래쪽 여백 */
    border: 1px solid #eee; /* 경계선 설정 */
    border-radius: 8px; /* 모서리를 둥글게 설정 */
    overflow: hidden; /* 내용이 박스를 넘치지 않도록 설정 */
    background-color: #fff; /* 배경색 설정 */
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1); /* 박스 그림자 설정 */
    transition: box-shadow 0.3s ease-in-out; /* 마우스 오버 시 그림자 변화 애니메이션 */
    position: relative; /* 위치 조정을 위해 상대 위치 설정 */
    display: flex; /* 박스 내의 내용 정렬을 위해 플렉스 사용 */
    flex-direction: column; /* 내용을 위아래로 배치 */
    justify-content: space-between; /* 내용이 박스 내에서 균등하게 배치되도록 설정 */
    padding: 10px; /* 내부 여백을 줄여 깔끔하게 */
}

/* 제품 박스에 마우스를 올렸을 때 스타일 */
.productBox01:hover {
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); /* 더 진한 그림자 */
}

.product_image {
	height:80%;
	overflow:hidden;
}

/* 제품 이미지 스타일 */
.product_image img {
    width: 100%; /* 이미지의 너비를 부모 요소에 맞춤 */
    height: auto; /* 높이를 자동으로 설정하여 이미지 비율을 유지 */
    object-fit: cover; /* 이미지가 박스에 맞게 크롭되도록 설정 */
    margin-bottom: 10px; /* 이미지와 제품명 사이에 적당한 간격 추가 */
}

/* 제품 정보 스타일 */
.product_info {
    text-align: left; /* 텍스트 가운데 정렬 */
    padding: 10px 0 0 0; /* 아래쪽 패딩을 제거하여 텍스트와 이미지 간격 줄이기 */
}

/* 제품 가격 스타일 */
.product_info h4 {
    font-size: 16px; /* 글꼴 크기 설정 */
    font-weight: bold; /* 글꼴 굵게 설정 */
    margin-bottom: 5px; /* 제품명과 가격 사이의 간격을 줄이기 */
    color: #333; /* 글꼴 색상 설정 */
}

/* 제품명 링크 스타일 */
.product_info a {
    display: block; /* 블록 요소로 설정 */
    font-size: 14px; /* 글꼴 크기 설정 */
    color: #666; /* 글꼴 색상 설정 */
    text-decoration: none; /* 밑줄 제거 */
}

/* 제품명 링크에 마우스를 올렸을 때 스타일 */
.product_info a:hover {
    color: #333; /* 글꼴 색상 진하게 변경 */
}

/* boxWrapper 안의 요소들을 한 줄에 4개씩 정렬 */
.boxWrapper {
    display: flex; /* Flexbox 레이아웃 사용 */
    flex-wrap: wrap; /* 여러 줄로 아이템이 배치될 수 있도록 설정 */
    justify-content: space-between; /* 아이템들 사이에 균등한 간격 설정 */
    gap: 20px; /* 박스들 사이에 일정한 간격 추가 */
}



/* 반응형 디자인: 화면 크기에 따라 줄 수 조절 */
@media (max-width: 768px) {
    .productBox01 {
        width: 48%; /* 작은 화면에서는 2열 그리드 설정 */
    }
}

@media (max-width: 480px) {
    .productBox01 {
        width: 100%; /* 모바일 화면에서는 1열 그리드 설정 */
    }
}
</style>
</head>
<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/store_top.jsp"></jsp:include>
		</header>
		<div class="inner">
			<section class="sec01">
				<div class="mainWrapper">
					<div class="productMain">
						<div class="mainBanner">
							<img class="bannerImg" alt="배너" src="${pageContext.request.contextPath}/resources/image/cuteDog3.jpg">
						</div>
						<c:choose>
							<c:when test="${searchKeyword ne '' && empty StoreList}">
							<p>
							검색결과가 없습니다. <br><br>
							이용에 불편을 드려 죄송합니다.
							</p>
							</c:when>
							<c:when test="${searchKeyword ne ''}">
								<c:choose>
									<c:when test="${param.product_category_detail eq null}">
										<h2>${param.product_category}</h2>
									</c:when>
									<c:otherwise>
										<h2>${param.product_category} > ${product_category_detail}</h2> 
									</c:otherwise>
								</c:choose>
								
								<%-- 페이지 번호 기본값 1로 설정 --%>
								<c:set var="pageNum" value="1"/>
								<c:if test="${not empty param.pageNum}">
									<c:set var="pageNum" value="${param.pageNum}"/>
								</c:if>
									
								<div class="product_Category">
									<div class="orderWrapper"> 
										<span class="orderSelect" id="orderList01" onclick="location.href=''">인기순</span>
										<span class="orderSelect" id="orderList02" onclick="location.href=''">추천순</span>
										<span class="orderSelect" id="orderList03" onclick="location.href=''">최신순</span>
									</div>
									<div class="boxWrapper">
									<c:forEach var="product" items="${StoreList}">
										<div class="productBox01">
											<div class="product_image">
												<a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}">
													<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
												</a>
											</div>
											<div class="product_info">
												<h4><a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}"><fmt:formatNumber pattern="#,###">${product.product_price}</fmt:formatNumber>원</a></h4>
												<span><a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}">${product.product_name}</a></span>
											</div>
										</div>	
										<div class="productBox01">
											<div class="product_image">
												<a href="StoreDetail">
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
												<a href="StoreDetail">
													<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
												</a>
											</div>
											<div class="product_info">
												<h4>00,000원</h4>
												<a href="StoreDetail">제품명제품명</a>
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
									</c:forEach>
									</div>
								</div>
							</c:when>
						</c:choose>
						
						
					</div>
					<div class="rankList">
					
					</div>
				</div>
			
			</section>
			
			<section id="pageList">
				<%-- 현재 페이지 번호가 1 보다 클 경우에만 가능하게 해야함 --%>
				<input type="button" value="이전" onclick="location.href='StoreList?pageNum=${pageNum - 1}'"
						<c:if test="${pageNum <= 1}">disabled</c:if> >
				
				<%-- 계산된 페이지 번호가 저장된 PageInfo 객체를 통해 페이지 번호 출력 --%>
				<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
					
					<c:choose>
						<c:when test="${pageNum eq i}">
							<b>${i}</b>
						</c:when>
						<c:otherwise>
							<a href="StoreList?pageNum=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				
		<%-- 			<a href="BoardList.bo?pageNum=${i}">${i}</a> --%>
				</c:forEach>
				
				<input type="button" value="다음" onclick="location.href='StoreList?pageNum=${pageNum + 1}'"
						<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
			</section>
		</div>
		
		
		
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
</body>
</html>