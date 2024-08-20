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
		<link href="${pageContext.request.contextPath}/resources/css/project_detail.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
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
								
								<!-- 남은 날짜 계산 -->
								<fmt:parseNumber value="${project_detail.funding_start_date.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
								<fmt:parseNumber value="${project_detail.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
								<c:set value="${endDate - strDate}" var="leftDay"/>
								<!-- 남은 날짜 계산 end -->
								
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
								<dd>목표금액 달성 시 <b>${project_detail.pay_date}</b>에 결제 진행</dd> <!-- 마감일 다음날 결제 예정일 -->
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
						<div class="wrap">
							<div>
								<div class="creator">
									<img alt="창작자 프로필사진" src="${pageContext.request.contextPath}/resources/image/imgReady.jpg">
									<span><a href="MemberInfoTest?mem_email=${project_detail.creator_email}">${project_detail.creator_name}</a></span>
								</div>
								<div>
									<ul>
										<li>누적펀딩액</li>
										<li> 원</li>
									</ul>
									<ul>
										<li>팔로워</li>
										<li>${project_detail.followerCount} 명</li>
									</ul>
								</div>
							</div>
							<div class="btns">
								<button class="follow" onclick="confirmFollow()">팔로우</button>
								<button class="ask" onclick="chat()">문의</button>
							</div>
						</div>
					</div>
					
					<div id="report">
						<span>문제가 있나요?</span>
						<img alt="이동" src="${pageContext.request.contextPath}/resources/image/right-arrow.png">
					</div>
					
					<!-- 후원자가 고른 후원 아이템 -->
					<div id="choosenFunding">
						<h4>후원 선택</h4>
						<div class="wrap">
						
						</div>
					</div>
					
					
					<div id="fundingOptions">
						<h4>후원 선택</h4>
						<div class="wrap">
						
						</div>
					</div>
				</div>
			</section>
		</div>
		
		<div class="modal"> <!-- 신고 -->
		    <div class="modal_popup">
		        <h3>신고하기</h3>
	        	<span>어떤 문제가 있나요?</span><br>
		        <div class="content">
		        	<button value="지식재산권 침해">
		        		<span class="repTitle">지식재산권 침해</span>
		        		<span class="repContent">
		        			타인의 지식재산권을 허락없이 사용했어요. <br>
							타인의 제품이나 콘텐츠를 동일하게 모방했어요.
		        		</span>
		        	</button>
		        	
		        	<button value="상세설명 내 허위사실">
		        		<span class="repTitle">상세설명 내 허위사실</span>
		        		<span class="repContent">
		        			상품을 받아보니 상세설명과 다른 부분이 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="동일 제품의 타 채널 유통">
		        		<span class="repTitle">동일 제품의 타 채널 유통</span>
		        		<span class="repContent">
		        			프로젝트 진행 전에 이미 판매한 적이 있는 제품이에요. <br>
							같은 제품을 다른 곳에서 (예약)판매하고 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="부적절한 콘텐츠">
		        		<span class="repTitle">부적절한 콘텐츠</span>
		        		<span class="repContent">
		        			- 타인을 모욕, 명예훼손하는 콘텐츠 <br>
		        			- 개인정보를 침해하는 콘텐츠<br>
		        			- 차별, 음란, 범죄 등 불건전한 콘텐츠 <br>
		        			- 타사 유통 채널 광고. 홍보 목적의 콘텐츠
		        		</span>
		        	</button>
		        	
		        	<button value="기타">
		        		<span class="repTitle">기타</span>
		        		<span class="repContent">
		        			- 리워드가 불량이라 교환/수리 신청하고 싶어요. <br>
		        			- 리워드에 큰 하자가 있어 환불 신청하고 싶어요.  <br>
		        			- 배송이 너무 늦어져서 환불 신청하고 싶어요.  <br>
		        			- 창작자와 의사소통이 잘 되지 않아요. 
		        		</span>
		        	</button>
		        	
		        	<div class="warn">
		        		<span>
		        			– 신고 내용이 사실과 다르거나 허위인 경우, 이용 제재를 받을 수 있습니다. <br>
							– 신고인의 정보를 허위로기재할 경우, 법적 책임을 물을 수 있습니다. <br>
							– 타인 비방 및 부당 이익 목적의 신고는 신고를 철회하더라도 면책되지 않습니다. <br>
							– 신고자의 정보 및 신고 내용은 안전하게 보호되며 외부에 제공되지 않습니다. <br>
							– 신고자는 개인정보의 수집 및 이용 동의 및 제 3자 제공을 거부할 권리가 있으나,  <br>
							  &nbsp;&nbsp; 거부할 경우 신고하기 서비스 이용에 제한을 받을 수 있습니다.
		        		</span>
		        	</div>
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn">
		    </div>
		</div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		<script type="text/javascript">
			let modal = document.querySelectorAll('.modal');
			let reportBtn = document.querySelector('#report');
			let closeBtn = document.querySelectorAll('.close_btn');
			
			// -------------------------------------------------------------------------
			
			// 팝업 오픈
			reportBtn.onclick = function(){
				modal[0].classList.add('on');
			}
			
			// -------------------------------------------------------------------------
			// 닫기 버튼
			for(let i = 0; i < closeBtn.length ; i++) {
				closeBtn[i].onclick = function(){
					modal[i].classList.remove('on');
				}
			}
			
			// ==========================================================================
		</script>
	</body>
</html>




















