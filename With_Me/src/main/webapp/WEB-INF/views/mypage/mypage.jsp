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
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
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
	        document.getElementById('projectsList').style.display = 'block';
	        document.getElementById('productsList').style.display = 'none';
	    });
	
	    document.getElementById('showProductsBtn').addEventListener('click', function() {
	        document.getElementById('projectsList').style.display = 'none';
	        document.getElementById('productsList').style.display = 'block';
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
	<div class="inner">
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
		            
		                <button id="showProjectsBtn">프로젝트 좋아요</button>
		                <button id="showProductsBtn">상품 좋아요</button>
		
		                <!-- Container to hold the lists -->
		                <div id="likeContent">
		                	<div id="projectsList" class="likeList" style="display:none;">
	                            <c:if test="${not empty likeProjectList}">
	                            	<c:set var="hasValidProject" value="false" />
	                            	
                            		<c:set var="now" value="<%=new java.util.Date()%>" />
					                <c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set>
					                
		                        	<c:forEach var="project" items="${likeProjectList}">
					                    <c:choose>
					                        <c:when test="${project.funding_end_date > today}">
					                            <c:set var="hasValidProject" value="true" />
					                            <div class="item">
					                                <div class="item_image">
					                                    <a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">
					                                        <img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
					                                    </a>
<%-- 															<c:if test="${not empty likeProjectList.like_status and likeProjectList.like_status eq 'Y'}"> --%>
														<button class="like Btn" type="button" onclick="MypageCancelLike('${project.project_code}', '${sId}')">
															<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
														</button>
<%-- 															</c:if> --%>
					                                </div>
					                                <div class="item_info">
					                                    <h4><a href="MemberInfoTest?mem_email=${project.creator_email}">${project.creator_name}</a></h4>
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
					                                <progress class="progress" value="${fund_rate}" min="0" max="100"></progress>
					                            </div>
					                        </c:when>
					                    </c:choose>
					                </c:forEach>
	                            </c:if>
		                    </div>
		
		                    <!-- 내가 좋아요한 상품 -->
		                    <div id="productsList" class="likeList" style="display:none;">
		                        <c:forEach items="${likeProductList}" var="product">
		                            <p>${product.name}</p>
		                        </c:forEach>
		                    </div>
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
						                                        <img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
						                                    </a>
						                                    <img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
						                                    <!-- 나중에 쓸 채워진 하트 -->
								<%-- 								<img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/colored_like.png"> --%>
						                                </div>
						                                <div class="item_info">
						                                    <h4><a href="MemberInfoTest?mem_email=${project.creator_email}">${project.creator_name}</a></h4>
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
						    <c:if test="${empty projectList}">
						        <p>등록된 프로젝트가 없습니다.</p>
						    </c:if>
						</section>
							
							<section id="pageList">
								<%-- 현재 페이지 번호가 1 보다 클 경우에만 가능하게 해야함 --%>
								<input type="button" value="이전" onclick="location.href='MemberInfo?pageNum=${pageNum - 1}'"
										<c:if test="${pageNum <= 1}">disabled</c:if> >
								
								<%-- 계산된 페이지 번호가 저장된 PageInfo 객체를 통해 페이지 번호 출력 --%>
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									
									<c:choose>
										<c:when test="${pageNum eq i}">
											<b>${i}</b>
										</c:when>
										<c:otherwise>
											<a href="MemberInfo?pageNum=${i}">${i}</a>
										</c:otherwise>
									</c:choose>
								
						<%-- 			<a href="BoardList.bo?pageNum=${i}">${i}</a> --%>
								</c:forEach>
								
								<input type="button" value="다음" onclick="location.href='MemberInfo?pageNum=${pageNum + 1}'"
										<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
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
							                                        <img alt="이미지" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG">
							                                    </a>
							                                    <img alt="좋아요" class="like" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
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
							<section id="pageList">
								<%-- 현재 페이지 번호가 1 보다 클 경우에만 가능하게 해야함 --%>
								<input type="button" value="이전" onclick="location.href='MemberInfo?pageNum=${pageNum - 1}'"
										<c:if test="${pageNum <= 1}">disabled</c:if> >
								
								<%-- 계산된 페이지 번호가 저장된 PageInfo 객체를 통해 페이지 번호 출력 --%>
								<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
									
									<c:choose>
										<c:when test="${pageNum eq i}">
											<b>${i}</b>
										</c:when>
										<c:otherwise>
											<a href="MemberInfo?pageNum=${i}">${i}</a>
										</c:otherwise>
									</c:choose>
								
						<%-- 			<a href="BoardList.bo?pageNum=${i}">${i}</a> --%>
								</c:forEach>
								
								<input type="button" value="다음" onclick="location.href='MemberInfo?pageNum=${pageNum + 1}'"
										<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
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
								<section id="listForm">
								    <!-- followList가 비어있을 때 팔로우한 사용자가 없다는 메시지 표시 -->
								    <c:if test="${empty followList}">
								        <p>팔로우한 사용자가 없습니다.</p>
								    </c:if>
								
								    <!-- followList가 비어있지 않을 때 목록을 표시 -->
								    <c:if test="${not empty followList}">
								        <table border="1">
								            <tr id="tr_top">
								                <td>창작자 이름</td>
								                <td>해당창작자 정보</td>
								            </tr>
								
								            <c:set var="pageNum" value="1" />
								            <c:if test="${not empty param.pageNum}">
								                <c:set var="pageNum" value="${param.pageNum}" />
								            </c:if>
								
								            <c:forEach var="follow" items="${followList}">
								                <tr>
								                    <td>
								                        <c:choose>
								                            <c:when test="${not empty follow.creator_name}">
								                                <input type="button" value="${follow.creator_name}" 
								                                       onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
								                            </c:when>
								                            <c:otherwise>
								                                <input type="button" value="${follow.mem_name}" 
								                                       onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
								                            </c:otherwise>
								                        </c:choose>
								                    </td>
								                    <td>
								                        <input type="button" value="답변" 
								                               onclick="location.href='QnaDetail?qna_number=${qna.qna_number}'">
								                    </td>
								                </tr>
								            </c:forEach>
								        </table>
								    </c:if>
								</section>
								<br>
								<%-- ========================== 페이징 처리 영역 ========================== --%>
								<section id="pageList">
									<input type="button" value="이전"
										onclick="location.href='MemberInfo?pageNum=${pageNum - 1}'"
										<c:if test="${pageNum <= 1}">disabled</c:if>>
				
									<c:forEach var="i" begin="${pageInfo.startPage}"
										end="${pageInfo.endPage}">
										<c:choose>
											<c:when test="${i eq pageNum}">
												<b>${i}</b>
												<%-- 현재 페이지 번호 --%>
											</c:when>
											<c:otherwise>
												<a href="MemberInfo?pageNum=${i}">${i}</a>
												<%-- 다른 페이지 번호 --%>
											</c:otherwise>
										</c:choose>
									</c:forEach>
				
									<input type="button" value="다음"
										onclick="location.href='MemberInfo?pageNum=${pageNum + 1}'"
										<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
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
							<div align="center">
								<section id="listForm">
								    <!-- followList가 비어있을 때 팔로우한 사용자가 없다는 메시지 표시 -->
								    <c:if test="${empty followingList}">
								        <p>팔로우한 사용자가 없습니다.</p>
								    </c:if>
								
								    <!-- followList가 비어있지 않을 때 목록을 표시 -->
								    <c:if test="${not empty followingList}">
								        <table border="1">
								            <tr id="tr_top">
								                <td>창작자 이름</td>
								                <td>해당창작자 정보</td>
								            </tr>
								
								            <c:set var="pageNum" value="1" />
								            <c:if test="${not empty param.pageNum}">
								                <c:set var="pageNum" value="${param.pageNum}" />
								            </c:if>
								
								            <c:forEach var="follow" items="${followingList}">
								                <tr>
								                    <td>
								                        <c:choose>
								                            <c:when test="${not empty follow.creator_name}">
								                                <input type="button" value="${follow.creator_name}" 
								                                       onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
								                            </c:when>
								                            <c:otherwise>
								                                <input type="button" value="${follow.mem_name}" 
								                                       onclick="location.href='OtherMemberInfo?creator_email=${follow.follow_creator}'">
								                            </c:otherwise>
								                        </c:choose>
								                    </td>
								                </tr>
								            </c:forEach>
								        </table>
								    </c:if>
								</section>
								<br>
								<%-- ========================== 페이징 처리 영역 ========================== --%>
								<section id="pageList">
									<input type="button" value="이전"
										onclick="location.href='MemberInfo?pageNum=${pageNum - 1}'"
										<c:if test="${pageNum <= 1}">disabled</c:if>>
				
									<c:forEach var="i" begin="${pageInfo.startPage}"
										end="${pageInfo.endPage}">
										<c:choose>
											<c:when test="${i eq pageNum}">
												<b>${i}</b>
												<%-- 현재 페이지 번호 --%>
											</c:when>
											<c:otherwise>
												<a href="MemberInfo?pageNum=${i}">${i}</a>
												<%-- 다른 페이지 번호 --%>
											</c:otherwise>
										</c:choose>
									</c:forEach>
				
									<input type="button" value="다음"
										onclick="location.href='MemberInfo?pageNum=${pageNum + 1}'"
										<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
								</section>
							</div>
						</section>
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
</html>
