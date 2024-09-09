<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>With_Me</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/project_detail.css" rel="stylesheet" type="text/css">
<style>
	/* 승인/거부 버튼 시작 */
	.approvalBtn {
		border: 1px solid #eee;
		border-radius: 10px;
		width: 400px;
		height: 50px;
		font-weight: bold;
		font-size: 20px;
		color: #fff;
		background-color: #ffab40;
		margin-right: 10px;
		cursor: pointer;
	}
	.approvalBtn:disabled {
		background-color: gray;
	}
	/* 승인/거부 버튼 끝 */
	
	/* 목록 버튼 시작 */
	.listBtn {
		text-align: center;
	}
	.listBtn>#listBtn {
		border: 1px solid #eee;
		border-radius: 10px;
		width: 100px;
		height: 30px;
		font-weight: bold;
		font-size: 15px;
		color: #fff;
		background-color: #ffab40;
		margin-bottom: 10px;
		cursor: pointer;
	}
	/* 목록 버튼 끝 */
</style>
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
	// 프로젝트 등록 승인/거부
	function projectRegistApproval(isAuthorize, project_idx) {
		let msg = "";
		
		if(isAuthorize == 'YES') {
			msg = "승인";
		} else if(isAuthorize == 'NO') {
			msg = "거부";
		}
		
		if(confirm("프로젝트 등록을 " + msg + "하시겠습니까?")) {
			location.href = "AdminProjectRegistApproval?isAuthorize=" + isAuthorize + "&project_idx=" + project_idx;
		}
	}
	// 프로젝트 취소 승인
	function projectCancelApproval(project_idx){
		if(confirm("프로젝트 취소를 승인하시겠습니까?")) {
			location.href = "AdminProjectCancelApproval?status=${param.status}&project_idx=" + project_idx;
		}
	}
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>	
	<div class="inner">
		<section class="con01">
			<c:choose>
				<c:when test="${param.status eq '등록대기'}">
					<h2>프로젝트 심사</h2>
				</c:when>
				<c:when test="${param.status eq '진행중'}">
					<h2>프로젝트 상세정보</h2>
				</c:when>
				<c:when test="${param.status eq '종료'}">
					<h2>프로젝트 상세정보</h2>
				</c:when>
			</c:choose>
			<br>
			<div class="itemWrapper">
				<div id="imgArea">
					<img alt="프로젝트 썸네일" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}" title="프로젝트 썸네일">
				</div>
				<div id="infoArea">
					<span class="category">${project.project_category} > ${project.project_category_detail}</span>
					<h4>${project.project_title}</h4>
					<div class="fundInfo1">
						<div>
							<span><b>창작자 이름</b></span>
							<ul>
								<li>${creator.creator_name}(${creator.creator_email})</li>
							</ul>
						</div>
						<div>
							<span><b>창작자 소개</b></span>
							<ul>
								<li>${creator.creator_introduce}</li>
							</ul>
						</div>
					</div>
					<div class="fundInfo2">
						<dl>
							<dt>프로젝트 요약</dt>
							<dd> | ${project.project_summary}</dd>
						</dl>
						<dl>
							<dt>목표 후원 금액</dt>
							<dd> | <fmt:formatNumber value="${project.target_price}" pattern="#,###"/> 원</dd>
						</dl>
						<c:choose>
							<c:when test="${param.status eq '진행중'}">
								<dl>
									<dt>누적 후원 금액</dt>
									<dd> | <fmt:formatNumber value="${project.funding_amt}" pattern="#,###"/> 원</dd>
								</dl>
							</c:when>
							<c:when test="${param.status eq '종료'}">
								<dl>
									<dt>최종 달성 금액</dt>
									<dd> | <fmt:formatNumber value="${project.funding_amt}" pattern="#,###"/> 원</dd>
								</dl>
							</c:when>
						</c:choose>
						<dl>
							<dt>수수료</dt>
							<dd> | <fmt:formatNumber value="${project.funding_commission}" pattern="#,###"/> 원</dd>
						</dl>
						<dl>
							<dt>프리미엄 요금</dt>
							<dd> | 
								<c:choose>
									<c:when test="${project.funding_premium eq 0}">미선택</c:when>
									<c:when test="${project.funding_premium eq 1}">선택</c:when>
								</c:choose>
							</dd>
						</dl>
						<dl>
							<dt>펀딩기간</dt>
							<dd> | ${project.funding_start_date} ~ ${project.funding_end_date}</dd>
						</dl>
						<%-- 오늘 날짜 추출 --%>
						<c:set var="now" value="<%=new java.util.Date()%>" />
						<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
						<%-- 오늘 날짜 추출 end --%>
						<%-- 남은 날짜 계산 --%>
						<fmt:parseNumber var="strDate" value="${now.time/(1000*60*60*24)}" integerOnly="true"></fmt:parseNumber>
						<fmt:parseNumber var="endDate" value="${project.funding_end_date.time/(1000*60*60*24)}" integerOnly="true"></fmt:parseNumber>
						<c:set var="leftDay" value="${endDate - strDate}"/>
						<%-- 남은 날짜 계산 end --%>
						<c:if test="${param.status eq '진행중'}">
							<dl>
								<dt>남은 기간</dt>
								<dd> | ${leftDay}일</dd>
							</dl>
						</c:if>
						<dl>
							<dt>프로젝트 정책</dt>
							<dd> | ${project.project_policy}</dd>
						</dl>
						<c:if test="${param.status eq ('등록대기' or '진행중')}">
							<dl>
								<dt>취소신청여부</dt>
								<dd> | 
									<c:choose>
										<c:when test="${projectCancel == null}">신청하지 않음</c:when>
										<c:otherwise>신청함</c:otherwise>
									</c:choose>
								</dd>
							</dl>
							<c:choose>
								<c:when test="${projectCancel == null}"></c:when>
								<c:otherwise>
									<dl>
										<dt>취소신청사유</dt>
										<dd> | ${projectCancel.project_cancel_reason}</dd>
									</dl>
								</c:otherwise>
							</c:choose>
						</c:if>
					</div>
					<div class="fundInfo3">
						<c:choose>
							<c:when test="${param.status eq '등록대기'}">
								<input type="button" class="approvalBtn" value="등록승인" onclick="projectRegistApproval('YES', ${project.project_idx})">
								<input type="button" class="approvalBtn" value="등록거부" onclick="projectRegistApproval('NO', ${project.project_idx})">
								<%-- 창작자가 취소 신청을 하지 않았을 경우 버튼 비활성화 처리 --%>
								<input type="button" class="approvalBtn" value="취소승인" onclick="projectCancelApproval(${project.project_idx})" <c:if test="${projectCancel == null}">disabled</c:if>>
							</c:when>
							<c:when test="${param.status eq '진행중'}">
								<%-- 창작자가 취소 신청을 하지 않았을 경우 버튼 비활성화 처리 --%>
								<input type="button" class="approvalBtn" value="취소승인" onclick="projectCancelApproval(${project.project_idx})" <c:if test="${projectCancel == null}">disabled</c:if>>
							</c:when>
							<c:when test="${param.status eq '종료'}">
								<input type="button" class="approvalBtn" value="종료됨" disabled>
							</c:when>
						</c:choose>
					</div>
				</div>
			</div>
		</section>
		<div class="listBtn">
			<input type="button" id="listBtn" value="목록" onclick="location.href='AdminProjectList?status=${param.status}'">
		</div>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>