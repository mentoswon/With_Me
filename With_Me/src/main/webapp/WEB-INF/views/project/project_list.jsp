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
			.sec02 .itemList .itemWrapper .item .item_image {
				position: relative;
			}
			
			.sec02 .itemList .itemWrapper .item .item_image .like{
				position: absolute;
				top: 88%;
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
				let progress = document.querySelectorAll('.progress');
				let fund_rate = document.querySelectorAll('.fund_rate');

				
			});
		
		</script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="sec02">
				<c:choose>
					<c:when test="${searchKeyword ne '' && empty projectList}">
						<p>
						검색결과가 없습니다. <br><br>
						이용에 불편을 드려 죄송합니다.
						</p>
					</c:when>
					<c:when test="${searchKeyword ne ''}">
						<c:choose>
							<c:when test="${param.project_category_detail eq null}">
								<h2>${param.project_category}</h2>
							</c:when>
							<c:otherwise>
								<h2>${param.project_category} > ${param.project_category_detail}</h2>
							</c:otherwise>
						</c:choose>
						
						<%-- 페이지 번호 기본값 1로 설정 --%>
						<c:set var="pageNum" value="1"/>
						<c:if test="${not empty param.pageNum}">
							<c:set var="pageNum" value="${param.pageNum}"/>
						</c:if>
						
						<div class="itemList">
							<div class="itemWrapper">
							
							<!-- 오늘 날짜 추출 -->
							<c:set var="now" value="<%=new java.util.Date()%>" />
							<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
							<!-- 오늘 날짜 추출 end -->
							
							<c:forEach var="project" items="${projectList}">
							
								<c:if test="${project.funding_end_date > today}">
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
											<h4><a href="MemberInfoTest?mem_email=${project.creator_email}">${project.creator_name}</a></h4>
											<h3><a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">${project.project_title}</a></h3>
										</div>
										
										<div class="fund_info">
											<div class="fund_leftWrap">
												<%-- 펀딩률 --%>
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
												<%-- 펀딩률 end --%>
												
												<div class="fund_amt"><fmt:formatNumber pattern="#,###">${project.funding_amt}</fmt:formatNumber> 원</div> 
											</div>
											<div class="fund_etc">
												<c:choose>
													<c:when test="${leftDay eq 0}">
														오늘 마감
													</c:when>
													<c:otherwise>
													
														<!-- 남은 날짜 계산 -->
														<fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
														<fmt:parseNumber value="${project.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
														<c:set value="${endDate - strDate}" var="leftDay"/>
														<!-- 남은 날짜 계산 end -->
														
														<c:out value="${leftDay}" />일 남음
													</c:otherwise>
												</c:choose>
											</div> <%-- 남은 날짜/오늘 마감/오픈 날짜/펀딩 성공 --%>
										</div>
<!-- 										<div class="fund_rate_var"></div> -->
										<progress class="progress" value="${fund_rate}" min="0" max="100"></progress>
									</div>
								</c:if>
							</c:forEach>
							</div>
						</div>
					</c:when>
				</c:choose>
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
	</script>
</html>




















