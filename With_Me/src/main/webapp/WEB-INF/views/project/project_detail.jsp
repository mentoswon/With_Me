<%@page import="java.sql.Date"%>
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
			section {
				margin: 40px 0;
			}
			
			.itemWrapper {
				display: flex;
				justify-content: space-between;
				align-items: center;
				height: 500px;
			}
			
			.itemWrapper #imgArea {
				width: 53%;
				height: 100%;
			}
			
			.itemWrapper #imgArea img {
				width: 100%;
				height: 100%;
				object-fit: cover;
			}
			
			.itemWrapper #infoArea {
				width: 40%;
				height: 100%;
			}
			
			.itemWrapper #infoArea h4{
				margin: 40px 0 20px;
				font-size: 32px;
			}
			
			.itemWrapper #infoArea .fundInfo1{
				padding: 20px 0 20px; 
				border-top: 1px solid #bbb;
				border-bottom: 1px solid #bbb;
			}
			
			
			.itemWrapper #infoArea .fundInfo1 div {
				margin-bottom: 20px;
			}
			
			.itemWrapper #infoArea .fundInfo1 div:last-child {
				margin: 0;
			}
			
			.itemWrapper #infoArea .fundInfo1 div span {
				color: #595959;
				display: block;
				margin-bottom: 15px;
			}
			
			.itemWrapper #infoArea .fundInfo1 div ul{
				display: flex;
				align-items: baseline;
			}
			
			.itemWrapper #infoArea .fundInfo1 div ul li h4 {
 				color: #ffab40;
 				font-size: 30px;
 				margin-top: 0;
 				margin-bottom: 0;
 				margin-right: 10px;
 			}
 			
 			/* fundInfo2 */
 			
 			.itemWrapper #infoArea .fundInfo2 {
 				padding: 20px 0 20px; 
 				border-bottom: 1px solid #bbb;
 			}
 			
 			.itemWrapper #infoArea .fundInfo2 dl {
 				display: flex;
 				margin-bottom: 15px;
 				align-items: center;
 			}
 			
 			.itemWrapper #infoArea .fundInfo2 dl dt {
 				width: 100px;
 				font-weight: bold;
 				color: #595959;
 			}
 			
 			.itemWrapper #infoArea .fundInfo2 #leftDay {
 				font-size: 13px;
 				padding: 3px 10px;
 				height: 20px;
 				text-align: center;
 				align-content: center;
 				border-radius: 5px;
 				background-color: #eee;
 				margin-left: 10px;
 			}
 			
 			/* fundInfo3 */
 			
 			.itemWrapper #infoArea .fundInfo3 {
 				padding-top: 15px;
 				display: flex;
 			}
 			
 			.itemWrapper #infoArea .fundInfo3 .Btn{
 				border-radius: 10px;
 				border: 1px solid #eee;
 				margin-right: 10px;
 				background-color: transparent;
 			}
 			
 			.itemWrapper #infoArea .fundInfo3 .Btn img {
 				object-fit: cover;
 				width: 80%;
 			}
 			
 			.itemWrapper #infoArea .fundInfo3 .like {
 				width: 50px;
 				height: 50px;
 			}
 			
 			.itemWrapper #infoArea .fundInfo3 .goFund {
 				width: 400px;
 				height: 50px;
 				background-color: #ffab40;
 				color: #fff;
 				font-weight: bold;
 				font-size: 20px;
 			}
 			
 			/* ---------------------------------------------------------------------- */
 			.con02 {
 				display: flex;
 				justify-content: space-between;
 				align-items: center;
 				padding: 40px 0;
    			border-top: 1px solid #eee;
 			}
 			
 			.con02 .left {
 				width: 70%;
 				height: 300px;
 				background-color: yellow;
 			}
 			
 			.con02 .right {
 				width: 25%;
 				height: 300px;
 				background-color: olive;
 			}
 			
 			
		</style>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="con01">
				<div class="itemWrapper">
					<div id="imgArea">
						<img alt="프로젝트 썸네일" src="${pageContext.request.contextPath}/resources/image/imgReady.jpg">
					</div>
					<div id="infoArea">
						<span class="category">${project_detail.project_category} > ${project_detail.project_category_detail}</span>
						<h4>${project_detail.project_title}</h4>
						<div class="fundInfo1">
							<div>
								<span>모인 금액</span>
								<ul>
									<li><h4><fmt:formatNumber pattern="#,###">123456</fmt:formatNumber></h4></li>
									<li>원</li>
								</ul>
							</div>
							<div>
								<span>후원자</span>
								<ul>
									<li><h4>ddd</h4></li>
									<li>명</li>
								</ul>
							</div>
						</div>
						<div class="fundInfo2">
							<dl>
								<dt>목표금액</dt>
								<dd><fmt:formatNumber pattern="#,###">${project_detail.target_price}</fmt:formatNumber> 원</dd>
							</dl>
							<dl>
								<dt>펀딩기간</dt>
								<dd>${project_detail.funding_start_date} ~ ${project_detail.funding_end_date}</dd>
								<fmt:parseNumber value="${project_detail.funding_start_date.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
								<fmt:parseNumber value="${project_detail.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
								<c:set value="${endDate - strDate}" var="leftDay"/>
								
								<dd id="leftDay" style="<c:if test="${leftDay eq 0}">background-color:#ffab40; color:#ffffff;font-weight: bold;</c:if>">
									<c:choose>
										<c:when test="${leftDay eq 0}">
											오늘 마감이에요 !
										</c:when>
										<c:otherwise>
											<c:out value="${leftDay}"></c:out>일 남았어요 !
										</c:otherwise>
									</c:choose>
								</dd>
							</dl>
							<dl>
								<dt>결제</dt>
								<dd>목표금액 달성 시 <b>${pay_date}</b>에 결제 진행</dd> <!-- 마감일 다음날 결제 예정일 -->
							</dl>
						</div>
						
						<div class="fundInfo3">
							<button class="like Btn">
								<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
							</button>
							<button class="goFund Btn">이 프로젝트 후원하기</button>
						</div>
					</div>
				</div>
			</section>
			
			<section class="con02">
				<div class="left">
				
				</div>
				<div class="right">
					<div id="creatorInfo">
						<h4>창작자 소개</h4>
						<div>
							<div>
							
							</div>
							<div class="btns">
								<button class="follow">팔로우</button>
								<button class="ask">문의</button>
							</div>
						</div>
					</div>
					<div id="choosenFunding">
						<h4>후원 선택</h4>
					
					</div>
					<div id="report">
						<span>신고하기</span>
						<img alt="이동" src="${pageContext.request.contextPath}/resources/image/right-arrow.png">
					</div>
					<div id="fundingOptions">
						<h4>후원 선택</h4>
						<div>
							
						</div>
					</div>
					
				</div>
			</section>
		</div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
	</body>
</html>




















