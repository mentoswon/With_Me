<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 마이페이지</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_like.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/mypage_main.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
	.option {
		background-color: #FFFFFF;
		border: none;
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
	.sec02 .itemList .itemWrapper .item .item_info h3 {
		text-align: left;
		font-size: 16px;
	}
	
	.sec02 .itemList .itemWrapper .item .item_info a {
		word-wrap: break-word;
	}
	
	
	.sec02 .itemList .itemWrapper .item .fund_info {
		display: flex;
		justify-content: space-between;
		align-items: center;
		margin-bottom: 15px;
	} 
	
	.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap {
		display: flex;
		align-items: center;
	} 
	
	.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap > .fund_rate {
		margin-right: 10px;
		color: #ffab40;
		font-weight: bold;
	}	
	
	.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap > .fund_amt {
		color: #aaa;
		font-size: 14px;
	}
		
	.progress {
		width: 100%;
		appearance: none;
		height: 7px;
	}
	
	.progress::-webkit-progress-bar {
		background-color: #eee;
		border-radius: 3px;
	}
	
	.progress::-webkit-progress-value {
		background-color: #ffab40;
		border-radius: 3px;
	}
	
	.item_image {
		width: 230px;
		height: 230px;
	}
	
	.item_image img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	
	
	.product {
	width: 115%; /* 4열 그리드 설정 */
	height: 211px; /* 박스의 전체 높이를 300px로 제한 */
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

	.buyProduct {
	width: 88%; /* 4열 그리드 설정 */
	height: 211px; /* 박스의 전체 높이를 300px로 제한 */
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
	margin-right: 20px;
}

/* ------------------------------------------------------- */
/* 제품 박스에 마우스를 올렸을 때 스타일 */
.product:hover {
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15); /* 더 진한 그림자 */
}

.product_image {
	height: 80%;
	overflow: hidden;
}

/* 제품 이미지 스타일 */
.product_image img {
	width: 100%; /* 이미지의 너비를 부모 요소에 맞춤 */
	height: 100%; /* 높이를 자동으로 설정하여 이미지 비율을 유지 */
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
	margin-bottom: 15px;
	
}

/* 제품명 링크에 마우스를 올렸을 때 스타일 */
.product_info a:hover {
	color: #333; /* 글꼴 색상 진하게 변경 */
}

.like Btn {
	width: 30px;
}

/* --------------------------------------------------------- */
.sec01 .productList {
	height: 100%;
}

.sec01 .productList .boxWrapper {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
	gap: 2rem;
}

.sec01 .productList .boxWrapper .product {
	width: 160%;
}

.sec01 .productList .boxWrapper .product .product_image {
	position: relative;

}

.sec01 .productList .boxWrapper .product .product_image .like {
	position: absolute;
	top: 88%;
	right: 2%;
	width: 25px;
	height: 25px;
	background-color: transparent;
	border: none;
	cursor: pointer;
}

.sec01 .productList .boxWrapper .product .product_info h4 {
	font-size: 13px;
	font-weight: bold;
	color: #bbb;
}

.sec01 .productList .boxWrapper .product .product_info h3 {
	text-align: left;
	font-size: 16px;
}

.sec01 .productList .boxWrapper .product .product_info a {
	word-wrap: break-word;
}

.sec01 .mainWrapper {
	width: 80%;
}

#showProjectsBtn {
    width: 100%;
    max-width: 132px;
    padding: 10px;
    margin: 20px 0;
    border: none;
    border-radius: 8px;
    background-color: #FFAB40;
    color: white;
    font-size: 16px;
    cursor: pointer;
    margin-right: 20px;
}

#showProductsBtn {
    width: 100%;
    max-width: 132px;
    padding: 10px;
    margin: 20px 0;
    border: none;
    border-radius: 8px;
    background-color: #FFAB40;
    color: white;
    font-size: 16px;
    cursor: pointer;
}

.item_project {
	width: 24%;
}

#likeBtn {
	width: 15%;
}

#likeProjectTitle {
	font-size: 16px;
}

#likeProjectName {
	color: #BBBBBB;
	font-size: 13px;
	font-weight: normal;
}

#fund_rate {
	    margin-right: 10px;
    color: #ffab40;
    font-weight: bold;
}

.likeProduct {
	width: 21%;
}

#productsList, #projectList {
    gap: 20px;
}

#chat, #qna {
/*       width: 100%; */
      padding: 12px;
      background-color: #FFAB40;
      color: #fff;
      border: none;
      border-radius: 8px;
      font-size: 18px;
      cursor: pointer;
      transition: background-color 0.3s;
      margin-right: 33px;
}


</style>
<script type="text/javascript">
	$(document).ready(function() {
	
	    // 메뉴 항목 클릭 시 활성화 처리
	    $("#MypageMenuList li").click(function() {
	        $(".writeContainer").hide();	// 모든 .writeContainer 숨기기
	        $("#MypageMenuList li").removeClass("active");
	        $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
	        let index = $(this).data("index");	// 클릭된 메뉴 항목의 인덱스
	        $("#writeContainer" + index).show();	// 해당 인덱스에 해당하는 콘텐츠 영역만 보이기
	    });
	    
	//     $("#LikeMenuList li").click(function() {
	//         $(".writeContainer").hide();	// 모든 .writeContainer 숨기기
	//         $("#LikeMenuList li").removeClass("active");
	//         $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
	//         let index = $(this).data("index");	// 클릭된 메뉴 항목의 인덱스
	//         $("#writeContainer" + index).show();	// 해당 인덱스에 해당하는 콘텐츠 영역만 보이기
	//     });
	    document.getElementById('showProjectsBtn').addEventListener('click', function() {
	        document.getElementById('projectsList').style.display = 'flex';
	        document.getElementById('productsList').style.display = 'none';
	    });
	
	    document.getElementById('showProductsBtn').addEventListener('click', function() {
	        document.getElementById('projectsList').style.display = 'none';
	        document.getElementById('productsList').style.display = 'flex';
	    });
	    
		

		
	});	// ready 이벤트 끝

</script>

</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<div class="inner" style="min-height: 404px;">
		<section id="MemberInfo">
			<div id="projectInfoWrap">
				<div id="MypageMenuTop">
					<div style="text-align: center; display: flex;">
							<c:choose>
						        <c:when test="${not empty creator and not empty creatorInfo.creator_name}">
						            <h3>${creatorInfo.creator_name}</h3>
						        </c:when>
						        <c:otherwise>
						            <h3>${memberInfo.mem_name}</h3>
						        </c:otherwise>
						    </c:choose>
						<button class="option" type="button" onclick="location.href='MypageInfo'">
							<img src="${pageContext.request.contextPath}/resources/image/mypage.png" width="25">
						</button>
					</div>
				</div>
			</div>
		</section>
		<section id="MemberMypage">
			<div id="MypageMenuWrap">
				<div id="MypageMenu">
					<ul id="MypageMenuList">
						<li class="writeList active" data-index="1">
							<span>프로필</span>
						</li>
		                <li class="writeList" data-index="2">
		                    <span>좋아요</span>
		                </li>
						<li class="writeList" data-index="3">
							<span>올린 프로젝트</span>
						</li>
						<li class="writeList" data-index="4">
							<span>후원한 프로젝트</span>
						</li>
						<li class="writeList" data-index="5">
							<span>팔로워</span>
						</li>
						<li class="writeList" data-index="6">
							<span>팔로잉</span>
						</li>
						<li class="writeList" data-index="7">
							<span>구매한 상품</span>
						</li>
						<li class="writeList" data-index="8">
							<span>메세지</span>
						</li>
					</ul>
				</div>
			</div>
		</section>
		
		<article>
			<div id="writeContainer1" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
					    <c:choose>
					        <c:when test="${not empty creatorInfo and not empty creatorInfo.creator_introduce}">
					            <p>${creatorInfo.creator_introduce}</p>
					        </c:when>
					        <c:otherwise>
					            <p>창작자 되어서 자신을 소개해보세요!</p>
					        </c:otherwise>
					    </c:choose>
					</div>
				</div>
			</div>
		    <div id="writeContainer2" class="writeContainer">
		        <div class="MypageWriteWrap">
		            <div class="MypageExplanationWrap">
		            <div class="inner">
		            <section class="sec02">
		            
		                <button id="showProjectsBtn">프로젝트 좋아요</button>
		                <button id="showProductsBtn">상품 좋아요</button>
		
		                <div id="itemList">
		                <div class="itemWrapper">
		                	<div id="projectsList" class="likeList" style="display:none;">
	                            <c:if test="${not empty likeProjectList}">
	                            	<c:set var="hasValidProject" value="false" />
	                            	
                            		<c:set var="now" value="<%=new java.util.Date()%>" />
					                <c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
					                
		                        	<c:forEach var="project" items="${likeProjectList}">
					                    <c:choose>
					                        <c:when test="${project.funding_end_date > today}">
					                            <c:set var="hasValidProject" value="true" />
					                            <div class="item_project">
					                                <div class="item_image">
					                                    <a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">
					                                        <img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
					                                    </a>
<%-- 															<c:if test="${not empty likeProjectList.like_status and likeProjectList.like_status eq 'Y'}"> --%>
														<button class="like Btn" id="likeBtn" type="button" onclick="MypageCancelLike('${project.project_code}', '${sId}')">
															<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
														</button>
<%-- 															</c:if> --%>
					                                </div>
					                                <div class="item_info">
					                                    <h4 id="likeProjectName"><a href="MemberInfoTest?mem_email=${project.creator_email}">${project.creator_name}</a></h4>
					                                    <h3 ><a id="likeProjectTitle" href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">${project.project_title}</a></h3>
					                                </div>
					                                <div class="fund_info">
					                                    <div class="fund_leftWrap">
					                                        <fmt:parseNumber var="funding_amt" value="${project.funding_amt*1.0}" ></fmt:parseNumber>
					                                        <fmt:parseNumber var="target_price" value="${project.target_price}" ></fmt:parseNumber>
					                                        <c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
					                                        <c:choose>
					                                            <c:when test="${fund_rate eq 0.0}">
					                                                <div class="fund_rate">0%</div>
					                                            </c:when>
					                                            <c:otherwise>
					                                                <div class="fund_rate"><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>%</div>
					                                            </c:otherwise>
					                                        </c:choose>
					                                        <div class="fund_amt"><fmt:formatNumber pattern="#,###">${project.funding_amt}</fmt:formatNumber> 원</div> 
					                                    </div>
					                                    <div class="fund_etc">
					                                        <c:choose>
					                                            <c:when test="${leftDay eq 0}">
					                                                오늘 마감
					                                            </c:when>
					                                            <c:otherwise>
					                                                <fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
					                                                <fmt:parseNumber value="${project.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
					                                                <c:set value="${endDate - strDate}" var="leftDay"/>
					                                                <c:out value="${leftDay}" />일 남음
					                                            </c:otherwise>
					                                        </c:choose>
					                                    </div>
					                                </div>
					                                <progress class="progress" value="${fund_rate}" min="0" max="100"></progress>
					                            </div>
					                        </c:when>
					                    </c:choose>
					                </c:forEach>
	                            </c:if>
		                    </div>
		
		                    <!-- 내가 좋아요한 상품 -->
		                    <div id="productsList" class="likeList" style="display:none;">
		                    	<c:if test="${not empty likeProjectList}">
		                    	<c:set var="hasValidProject" value="false" />
									<c:forEach var="product" items="${likeProductList}">
										<div class="product likeProduct">
											<div class="product_image">
												<a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}">
													<img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${product.product_img}">
												</a>
												<button class="like Btn" type="button" onclick="CancelLikeProduct('${product.product_code}', '${sId}')">
													<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
												</button>											
											</div>
											<div class="product_info">
												<h4><a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}"><fmt:formatNumber pattern="#,###">${product.product_price}</fmt:formatNumber>원</a></h4>
												<span><a href="StoreDetail?product_name=${product.product_name}&product_code=${product.product_code}">${product.product_name}</a></span>
											</div>
										</div>	
									</c:forEach>
			                    </c:if>
		                    </div>
		                </div>
		                </div>
		            </section>
		            </div>
		            </div>
		        </div>
		    </div>
			<div id="writeContainer3" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<div class="inner">
						<section class="sec02">
						    <!-- 내 프로젝트가 존재하는지 먼저 확인 -->
						    <c:if test="${not empty projectList}">
						        <c:set var="hasValidProject" value="false" />
						
						        <div class="itemList">
						            <div class="itemWrapper">
						            	<!-- 오늘 날짜 추출 -->
						                <c:set var="now" value="<%=new java.util.Date()%>" />
						                <c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
						
						                <c:forEach var="project" items="${projectList}">
						                    <c:choose>
						                        <c:when test="${project.creator_idx eq creatorInfo.creator_idx && project.funding_end_date > today}">
						                            <c:set var="hasValidProject" value="true" />
						                            <div class="item">
						                                <div class="item_image">
						                                    <a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">
						                                        <img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
						                                    </a>
						                                    <img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
						                                    <!-- 나중에 쓸 채워진 하트 -->
								<%-- 								<img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/colored_like.png"> --%>
						                                </div>
						                                <div class="item_info">
						                                    <h4><a href="OtherMemberInfo?creator_email=${project.creator_email}">${project.creator_name}</a></h4>
						                                    <h3><a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">${project.project_title}</a></h3>
						                                </div>
						                                <div class="fund_info">
						                                    <div class="fund_leftWrap">
						                                        <fmt:parseNumber var="funding_amt" value="${project.funding_amt*1.0}" ></fmt:parseNumber>
						                                        <fmt:parseNumber var="target_price" value="${project.target_price}" ></fmt:parseNumber>
						                                        <c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
						                                        <c:choose>
						                                            <c:when test="${fund_rate eq 0.0}">
						                                                <div class="fund_rate">0%</div>
						                                            </c:when>
						                                            <c:otherwise>
						                                                <div class="fund_rate"><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>%</div>
						                                            </c:otherwise>
						                                        </c:choose>
						                                        <div class="fund_amt"><fmt:formatNumber pattern="#,###">${project.funding_amt}</fmt:formatNumber> 원</div> 
						                                    </div>
						                                    <div class="fund_etc">
						                                        <c:choose>
						                                            <c:when test="${leftDay eq 0}">
						                                                오늘 마감
						                                            </c:when>
						                                            <c:otherwise>
						                                                <fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
						                                                <fmt:parseNumber value="${project.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
						                                                <c:set value="${endDate - strDate}" var="leftDay"/>
						                                                <c:out value="${leftDay}" />일 남음
						                                            </c:otherwise>
						                                        </c:choose>
						                                    </div>
						                                </div>
						                                <progress class="progress"  id="fund_rate" value="${fund_rate}" min="0" max="100"></progress>
						                            </div>
						                        </c:when>
						                    </c:choose>
						                </c:forEach>
						            </div>
						        </div>
						
						        <!-- 조건을 만족하는 프로젝트가 하나도 없을 때 메시지 표시 -->
						        <c:if test="${!hasValidProject}">
						            <p>등록된 프로젝트가 없습니다.</p>
						        </c:if>
						    </c:if>
						
						    <!-- projectList 자체가 비어 있을 때 메시지 표시 -->
						    <c:if test="${empty projectList}">
						        <p>등록된 프로젝트가 없습니다.</p>
						    </c:if>
						</section>
							
						</div>
					</div>
				</div>
			</div>
			<div id="writeContainer4" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<div class="inner">
							<section class="sec02">
							    <!-- 후원하는 프로젝트가 존재하는지 먼저 확인 -->
							    <c:if test="${not empty DonationProjectList}">
							        <c:set var="hasValidProject" value="false" />
							
							        <div class="itemList">
							            <div class="itemWrapper">
							            	<!-- 오늘 날짜 추출 -->
							                <c:set var="now" value="<%=new java.util.Date()%>" />
							                <c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
							
							                <c:forEach var="dp" items="${DonationProjectList}">
							                    <c:choose>
							                        <c:when test="${dp.funding_end_date > today}">
							                            <c:set var="hasValidProject" value="true" />
							                            <div class="item">
							                                <div class="item_image">
							                                    <a href="DonationProjectDetail?funding_idx=${dp.funding_idx}">
							                                       <img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${dp.project_image}">
							                                    </a>
<%-- 							                                    <img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/empty_like.png"> --%>
							                                    <!-- 나중에 쓸 채워진 하트 -->
									<%-- 								<img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/colored_like.png"> --%>
							                                </div>
							                                <div class="item_info">
							                                    <h4><a href="OtherMemberInfo?creator_email=${dp.creator_email}">${dp.creator_name}</a></h4>
							                                    <div>
								                                    <b><a href="DonationProjectDetail?funding_idx=${dp.funding_idx}">${dp.project_title}</a></b>
								                                    <p>(<fmt:formatNumber value="${dp.funding_pay_amt}" type="number" groupingUsed="true"/>원)</p>
							                                    </div>
							                                </div>
							                                <div class="fund_info">
							                                    <div class="fund_leftWrap">
							                                        <fmt:parseNumber var="funding_amt" value="${dp.funding_amt*1.0}" ></fmt:parseNumber>
							                                        <fmt:parseNumber var="target_price" value="${dp.target_price}" ></fmt:parseNumber>
							                                        <c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
							                                        <c:choose>
							                                            <c:when test="${fund_rate eq 0.0}">
							                                                <div class="fund_rate">0%</div>
							                                            </c:when>
							                                            <c:otherwise>
							                                                <div class="fund_rate"><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>%</div>
							                                            </c:otherwise>
							                                        </c:choose>
							                                        <div class="fund_amt"><fmt:formatNumber pattern="#,###">${dp.funding_amt}</fmt:formatNumber> 원</div> 
							                                    </div>
							                                    <div class="fund_etc">
							                                        <c:choose>
							                                            <c:when test="${leftDay eq 0}">
							                                                오늘 마감
							                                            </c:when>
							                                            <c:otherwise>
							                                                <fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
							                                                <fmt:parseNumber value="${dp.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
							                                                <c:set value="${endDate - strDate}" var="leftDay"/>
							                                                <c:out value="${leftDay}" />일 남음
							                                            </c:otherwise>
							                                        </c:choose>
							                                    </div>
							                                </div>
							                                <progress class="progress" value="${fund_rate}" min="0" max="100"></progress>
							                            </div>
							                        </c:when>
							                    </c:choose>
							                </c:forEach>
							            </div>
							        </div>
							
							        <!-- 조건을 만족하는 프로젝트가 하나도 없을 때 메시지 표시 -->
							        <c:if test="${!hasValidProject}">
							            <p>등록된 프로젝트가 없습니다.</p>
							        </c:if>
							    </c:if>
							
							    <!-- projectList 자체가 비어 있을 때 메시지 표시 -->
							    <c:if test="${empty DonationProjectList}">
							        <p>등록된 프로젝트가 없습니다.</p>
							    </c:if>
							</section>
						</div>
					</div>
				</div>
			</div>
			<div id="writeContainer5" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<section id="articleForm">
							<div align="center">
								<section id="articleForm">
								    <div class="center-container">
								        <section id="listForm">
								            <!-- followList가 비어있을 때 팔로우한 사용자가 없다는 메시지 표시 -->
								            <c:if test="${empty followList}">
								                <p class="empty-message">팔로우한 사용자가 없습니다.</p>
								            </c:if>
								
								            <!-- followList가 비어있지 않을 때 목록을 표시 -->
								            <c:if test="${not empty followList}">
								                <table class="follow-table">
								                    <thead>
								                        <tr id="tr_top">
								                            <th>창작자 이름</th>
								                            <th>창작자 소개</th>
								                        </tr>
								                    </thead>
								                    <tbody>
								                        <c:set var="pageNum" value="1" />
								                        <c:if test="${not empty param.pageNum}">
								                            <c:set var="pageNum" value="${param.pageNum}" />
								                        </c:if>
								
								                        <c:forEach var="follow" items="${followList}">
								                            <tr>
								                                <td>
								                                    <c:choose>
								                                        <c:when test="${not empty follow.creator_name}">
								                                            <button class="creator-btn" 
								                                                    onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_mem_email}'">
								                                                ${follow.creator_name}
								                                            </button>
								                                        </c:when>
								                                        <c:otherwise>
								                                            <button class="creator-btn" 
								                                                    onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_mem_email}'">
								                                                ${follow.mem_name}
								                                            </button>
								                                        </c:otherwise>
								                                    </c:choose>
								                                </td>
								                                <td>${follow.creator_introduce}</td>
								                            </tr>
								                        </c:forEach>
								                    </tbody>
								                </table>
								            </c:if>
								        </section>
								    </div>
								</section>
							</div>
						</section>
					</div>
				</div>
			</div>
			<div id="writeContainer6" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<section id="articleForm">
						    <div class="center-container">
						        <section id="listForm">
						            <!-- followList가 비어있을 때 팔로우한 사용자가 없다는 메시지 표시 -->
						            <c:if test="${empty followingList}">
						                <p class="empty-message">팔로우한 사용자가 없습니다.</p>
						            </c:if>
						
						            <!-- followList가 비어있지 않을 때 목록을 표시 -->
						            <c:if test="${not empty followingList}">
						                <table class="follow-table">
						                    <thead>
						                        <tr id="tr_top">
						                            <th>창작자 이름</th>
						                            <th>창작자 소개</th>
						                        </tr>
						                    </thead>
						                    <tbody>
						                        <c:set var="pageNum" value="1" />
						                        <c:if test="${not empty param.pageNum}">
						                            <c:set var="pageNum" value="${param.pageNum}" />
						                        </c:if>
						
						                        <c:forEach var="follow" items="${followingList}">
						                            <tr>
						                                <td>
						                                    <c:choose>
						                                        <c:when test="${not empty follow.creator_name}">
						                                            <button class="creator-btn" 
						                                                    onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
						                                                ${follow.creator_name}
						                                            </button>
						                                        </c:when>
						                                        <c:otherwise>
						                                            <button class="creator-btn" 
						                                                    onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
						                                                ${follow.mem_name}
						                                            </button>
						                                        </c:otherwise>
						                                    </c:choose>
						                                </td>
						                                <td>${follow.creator_introduce}</td>
						                            </tr>
						                        </c:forEach>
						                    </tbody>
						                </table>
						            </c:if>
						        </section>
						    </div>
						</section>
					</div>
				</div>
			</div>
			<div id="writeContainer7" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<div class="inner">
							<section class="sec01">
							    <!-- 구매한 상품이 존재하는지 먼저 확인 -->
							    <div class="productList" id="productList">
<!-- 									<div class="orderWrapper">  -->
<!-- 										<span class="orderSelect" id="orderList01" onclick="fetchSortedProducts('newest')">최신순</span> -->
<!-- 										<span class="orderSelect" id="orderList02" onclick="fetchSortedProducts('priceDesc')">가격 높은순</span> -->
<!-- 										<span class="orderSelect" id="orderList03" onclick="fetchSortedProducts('priceAsc')">가격 낮은순</span> -->
<!-- 									</div> -->
									<div class="boxWrapper">
									<c:forEach var="product" items="${BuyProductList}">
										<div class="buyProduct">
											<div class="product_image">
												<a href="BuyProductDetail?order_idx=${product.order_idx}">
<%-- 													<img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG"> --%>
													<img alt="이미지" src="${pageContext.request.contextPath}/resources/upload/${product.product_img}">
												</a>
											</div>
											<div class="product_info">
												<span><a href="BuyProductDetail?order_idx=${product.order_idx}">${product.product_name}</a></span>
												<h4><a href="BuyProductDetail?order_idx=${product.order_idx}"><fmt:formatNumber pattern="#,###">${product.product_price}</fmt:formatNumber>원</a></h4>
											</div>
										</div>	
									</c:forEach>
									</div>
								</div>
							
							    <!-- projectList 자체가 비어 있을 때 메시지 표시 -->
							    <c:if test="${empty BuyProductList}">
							        <p>결제한 상품이 없습니다.</p>
							    </c:if>
							</section>
						</div>
					</div>
				</div>
			</div>
			<div id="writeContainer8" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<div class="inner">
							<section class="sec01">
							    <!-- 후원하는 프로젝트가 존재하는지 먼저 확인 -->
							    <div class="productList" id="productList">
							    	<button type="button" id="chat" class="ask" onclick="chat()">나의 채팅방</button>
							    	<input type="button" id="qna" onclick="location.href='QnaBoardList'" value="나의 1:1문의">
<!-- 							    	<button type="button" class="ask" onclick="loaction.href='QnaBoardList'">나의 1:1문의</button> -->
								</div>
							</section>
						</div>
					</div>
				</div>
			</div>
		</article>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
<script type="text/javascript">

// 프로젝트 좋아요 취소
function MypageCancelLike(project_code, sId) {
	console.log("project_code : " + project_code + ", sId : " + sId);
	$.ajax({
		url: "MypageCancelLike",
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
// 				$(item).remove();
				location.reload();
			} else if(!response.result) {
				alert("좋아요 취소가 실패가 되었습니다!!");
// 					location.href="MemberInfo";
			}
		}
	});
}



</script>
<script type="text/javascript">
//상품 좋아요 취소
function CancelLikeProduct(product_code, sId) {
	console.log("product_code : " + product_code + ", sId : " + sId);
	$.ajax({
		url: "CancleLikeProduct",
		type : "POST",
		async:false, // 이 한줄만 추가해주시면 됩니다.
		data:{
			"like_product_code": product_code,
			"like_mem_email": sId
		},
		dataType: "json",
		success: function (response) {
			if(response.result){
				alert("좋아요가 취소되었습니다.");
// 				$(item).remove();
				location.reload();
			} else if(!response.result) {
				alert("좋아요 취소가 실패가 되었습니다!!");
// 					location.href="MemberInfo";
			}
		}
	});
}

function chat() {
// 	console.log("채팅창 열기: " + creatorId);
	
	var chatUrl = "/with_me/Chating"; 
//		var chatUrl = "/Chating?receiver_id=" + creatorId; 
	// encodeURIComponent 이거는 JavaScript의 내장 함수로, 
	// 문자열을 안전하게 URL에 포함할 수 있도록 특수 문자를 이스케이프(escape) 처리하여 변환해줌
	
	var popupOptions = "width=1000, height=500, scrollbars=yes, resizable=no";
	
	var chatWindow = window.open(chatUrl, "ChatWindow", popupOptions);
	
    if (chatWindow) {
        chatWindow.focus();
    } else {
        alert("팝업 창이 차단되었습니다. 팝업 차단을 해제해주세요.");
    }
}




</script>
</html>
