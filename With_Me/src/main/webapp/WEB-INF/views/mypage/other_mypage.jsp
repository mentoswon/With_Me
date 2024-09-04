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
</style>
<script type="text/javascript">
$(function() {

    // 메뉴 항목 클릭 시 활성화 처리
    $("#MypageMenuList li").click(function() {
        $(".writeContainer").hide();	// 모든 .writeContainer 숨기기
        $("#MypageMenuList li").removeClass("active");
        $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
        let index = $(this).data("index");	// 클릭된 메뉴 항목의 인덱스
        $("#writeContainer" + index).show();	// 해당 인덱스에 해당하는 콘텐츠 영역만 보이기
    });
	
	// 임시) 초기 상태로 두 번째 메뉴와 콘텐츠가 보이도록 설정
    $("#MypageMenuList li:eq(0)").click();
    
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
					        <c:when test="${not empty creatorName}">
								<c:forEach var="creator" items="${creatorInfo}">
						            <h3>${creator.creator_name}</h3>
								</c:forEach>
					        </c:when>
					        <c:otherwise>
					            <h3>${notCreatorMember.mem_name}</h3>
					        </c:otherwise>
					    </c:choose>
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
						<c:forEach var="creator" items="${creatorInfo}">
						    <c:choose>
						        <c:when test="${not empty creatorName}">
						            <p>${creator.creator_introduce}</p>
						        </c:when>
						        <c:otherwise>
						            <p>등록된 소개가 없습니다.</p>
						        </c:otherwise>
						    </c:choose>
						</c:forEach>
					</div>
				</div>
			</div>
			<div id="writeContainer2" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<p>
							좋아요가 없습니다.
						</p>
					</div>
				</div>
			</div>
			<div id="writeContainer3" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<div class="inner">
						<section class="sec02">
						    <!-- 프로젝트가 존재하는지 먼저 확인 -->
						    <c:if test="${not empty projectList}">
						        <c:set var="hasValidProject" value="false" />
						
						        <div class="itemList">
						            <div class="itemWrapper">
						            	<!-- 오늘 날짜 추출 -->
						                <c:set var="now" value="<%=new java.util.Date()%>" />
						                <c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
						
						                <c:forEach var="creator" items="${creatorInfo}">
							                <c:forEach var="project" items="${projectList}">
							                    <c:choose>
							                        <c:when test="${project.creator_idx eq creator.creator_idx && project.funding_end_date > today}">
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
							                                                <div class="fund_rate">${fund_rate}%</div>
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
					</div>
				</div>
			</div>
			<div id="writeContainer4" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<p>
							후원한 프로젝트가 없습니다.
						</p>
					</div>
				</div>
			</div>
			<div id="writeContainer5" class="writeContainer">
				<div class="MypageWriteWrap">
					<div class="MypageExplanationWrap">
						<section id="articleForm">
							<div align="center">
								<section id="listForm">
									<c:if test="${not empty followList}">
										<c:set var="hasValidProject" value="false" />
											<table border="1">
												<tr id="tr_top">
													<td>프로필</td>
													<td>창작자 이름</td>
													<td>해당창작자 정보</td>
												</tr>
						
												<c:set var="pageNum" value="1" />
												<c:if test="${not empty param.pageNum}">
													<c:set var="pageNum" value="${param.pageNum}" />
												</c:if>
												<%-- JSTL 과 EL 활용하여 글목록 표시 작업 반복(followList 객체 활용) --%>
												<c:forEach var="follow" items="${followList}">
													<tr>
														<td>
															<img
															src="${pageContext.request.contextPath}/resources/upload/${follow.creator_image}"
															id="img1" selected>
														</td>
														<td>
															<input type="button" value="${follow.creator_name}" onclick="location.href='MemberInfo?creator_name='${follow.creator_name}">
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
										onclick="location.href='qna_ask?pageNum=${pageNum - 1}'"
										<c:if test="${pageNum <= 1}">disabled</c:if>>
				
									<c:forEach var="i" begin="${pageInfo.startPage}"
										end="${pageInfo.endPage}">
										<c:choose>
											<c:when test="${i eq pageNum}">
												<b>${i}</b>
												<%-- 현재 페이지 번호 --%>
											</c:when>
											<c:otherwise>
												<a href="qna_ask?pageNum=${i}">${i}</a>
												<%-- 다른 페이지 번호 --%>
											</c:otherwise>
										</c:choose>
									</c:forEach>
				
									<input type="button" value="다음"
										onclick="location.href='qna_ask?pageNum=${pageNum + 1}'"
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
						<p>
							팔로우한 사용자가 없습니다.
						</p>
					</div>
				</div>
			</div>
		</article>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
