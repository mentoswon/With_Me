<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<style>
	.main {
		padding: 1.5rem;
	}
	
	.main h3 {
		text-align: left;
		margin-bottom: 30px;
	}
	.main .wrapper_top {
		display: flex;
		justify-content: space-between;
		position: relative;
		margin-bottom: 20px;
	}
	
	.main .wrapper_top .search {
		position: absolute;
		left: 40%;
	}
	.main .content {
		width: 100%;
		margin-bottom: 50px;
	}
	
	.main .content table {
		width: 100%;
	}
	
	.isCancel {
		background-color: orange;
	}
	
	/* 페이징 처리 */
	.main #pageList {
		text-align: center;
	}
</style>
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script>
	// 페이지당 목록 개수 변경
	function showListLimit(limit) {
		location.href="AdminProjectList?status=${param.status}&listLimit=" + limit;
	}
	// 프로젝트 상세
	function projectDetail(project_idx) {
		location.href = "AdminProjectDetail?status=${param.status}&project_idx=" + project_idx;
	}
</script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>	
	<div class="inner">
		<section class="wrapper">
			<jsp:include page="/WEB-INF/views/inc/admin_side_nav.jsp"></jsp:include>
			<article class="main">
				<c:choose>
					<c:when test="${param.status eq '등록대기'}">
						<h3>등록신청관리</h3>
					</c:when>
					<c:when test="${param.status eq '진행중'}">
						<h3>진행중인 프로젝트</h3>
					</c:when>
					<c:when test="${param.status eq '종료'}">
						<h3>종료된 프로젝트</h3>
					</c:when>
					<c:when test="${param.status eq '취소'}">
						<h3>취소된 프로젝트</h3>
					</c:when>
				</c:choose>
				<div class="wrapper_top">
					<div>
						<span>Show</span>
						<select onchange="showListLimit(this.value)">
							<option value="5" <c:if test="${param.listLimit eq 5}">selected</c:if>>5</option>
							<option value="10" <c:if test="${param.listLimit eq 10}">selected</c:if>>10</option>
							<option value="20" <c:if test="${param.listLimit eq 20}">selected</c:if>>20</option>
							<option value="30" <c:if test="${param.listLimit eq 30}">selected</c:if>>30</option>
						</select>
						<span>entries</span>
					</div>
					<form action="AdminProjectList">
						<div class="search">
							<span>Search</span>
							<input type="hidden" name="status" value="${param.status}">
							<input type="search" name="searchKeyword" value="${param.searchKeyword}" >
							<input type="submit" value="검색">
						</div>
					</form>
				</div>
				<div class="content">
					<table border="1">
						<tr>
							<th>프로젝트 코드</th>
							<th>프로젝트 제목</th>
							<th>카테고리</th>
							<th>세부 카테고리</th>
							<c:choose>
								<c:when test="${param.status eq '등록대기'}">
									<th>목표 후원 금액</th>
									<th>프로젝트 기간</th>
									<th>프로젝트 심사</th>
								</c:when>
								<c:when test="${param.status eq '진행중'}">
									<th>누적 후원 금액</th>
									<th>남은 기간</th>
									<th>프로젝트 상세</th>
								</c:when>
								<c:when test="${param.status eq '종료'}">
									<th>최종 달성한 후원 금액</th>
									<th>비고</th>
									<th>프로젝트 상세</th>
								</c:when>
								<c:when test="${param.status eq '취소'}">
									<th>취소신청사유</th>
									<th>프로젝트 상세</th>
								</c:when>
							</c:choose>
						</tr>
						<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
						<c:set var="pageNum" value="1" />
						<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
						<c:if test="${not empty param.pageNum}">
							<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
							<c:set var="pageNum" value="${param.pageNum}" />
						</c:if>
						<%-- 오늘 날짜 추출 --%>
						<c:set var="now" value="<%=new java.util.Date()%>" />
						<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
						<%-- 오늘 날짜 추출 end --%>
						<c:forEach var="PL" items="${projectList}">
							<tr align="center">
								<td>${PL.project_code}</td>
								<td>${PL.project_title}</td>
								<td>${PL.project_category}</td>
								<td>${PL.project_category_detail}</td>
								<c:choose>
									<c:when test="${param.status eq '등록대기'}">
										<td><fmt:formatNumber value="${PL.target_price}" pattern="#,###"/>원</td>
										<td>${PL.funding_start_date} ~ ${PL.funding_end_date}</td>
										<td><input type="button" <c:if test="${PL.pcs != ''}">class="isCancel"</c:if> value="프로젝트 심사" onclick="projectDetail(${PL.project_idx})"></td>
									</c:when>
									<c:when test="${param.status eq '진행중'}">
										<td><fmt:formatNumber value="${PL.funding_amt}" pattern="#,###"/>원</td>
										<%-- 남은 날짜 계산 --%>
										<fmt:parseNumber var="strDate" value="${now.time/(1000*60*60*24)}" integerOnly="true"></fmt:parseNumber>
										<fmt:parseNumber var="endDate" value="${PL.funding_end_date.time/(1000*60*60*24)}" integerOnly="true"></fmt:parseNumber>
										<c:set var="leftDay" value="${endDate - strDate}"/>
										<%-- 남은 날짜 계산 end --%>
										<td>${leftDay}일 후에 종료</td>
										<td><input type="button" <c:if test="${PL.pcs != ''}">class="isCancel"</c:if> value="프로젝트 상세" onclick="projectDetail(${PL.project_idx})"></td>
									</c:when>
									<c:when test="${param.status eq '종료'}">
										<td><fmt:formatNumber value="${PL.funding_amt}" pattern="#,###"/>원</td>
										<td>
											<c:choose>
												<c:when test="${PL.funding_amt < PL.target_price}">목표 금액 달성 실패</c:when>
												<c:otherwise>특이사항 없음</c:otherwise>
											</c:choose>
										</td>
										<td><input type="button" value="프로젝트 상세" onclick="projectDetail(${PL.project_idx})"></td>
									</c:when>
									<c:when test="${param.status eq '취소'}">
										<td>${PL.project_cancel_reason}</td>
										<td><input type="button" value="프로젝트 상세" onclick="projectDetail(${PL.project_idx})"></td>
									</c:when>
								</c:choose>
							</tr>
						</c:forEach>
						<c:if test="${empty projectList}">
							<tr>
								<td align="center" colspan="7">조회 결과가 없습니다.</td>
							</tr>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<c:if test="${not empty projectList}">
					<div id="pageList">
						<%-- [이전] 버튼 클릭 시 AdminProjectList 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
						<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
						<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
						<input type="button" onclick="location.href='AdminProjectList?pageNum=${pageNum - 1}&status=${param.status}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
						<%-- 계산된 페이지 번호가 저장된 PageInfo 객체(pageInfo)를 통해 페이지 번호 출력 --%>
						<%-- 시작페이지(startPage = begin) 부터 끝페이지(endPage = end)까지 1씩 증가하면서 표시 --%>
						<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
							<%-- 각 페이지마다 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
							<%-- 단, 현재 페이지(i 값과 pageNum 파라미터값이 동일)는 하이퍼링크 없이 굵게 표시 --%>
							<c:choose>
								<c:when test="${i eq pageNum}">
									<b>${i}</b> <%-- 현재 페이지 번호 --%>
								</c:when>
								<c:otherwise>
									<a href="AdminProjectList?pageNum=${i}&status=${param.status}">${i}</a> <%-- 다른 페이지 번호 --%>
								</c:otherwise>
							</c:choose>
						</c:forEach>
						<%-- [다음] 버튼 클릭 시 AdminProjectList 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
						<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
						<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
						<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
						<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
						<input type="button" onclick="location.href='AdminProjectList?pageNum=${pageNum + 1}&status=${param.status}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
					</div>
				</c:if>
			</article>
		</section>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>