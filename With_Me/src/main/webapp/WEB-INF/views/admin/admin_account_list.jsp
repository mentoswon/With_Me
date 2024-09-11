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
		width: 280px;
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
	
	.main .content table th {
		background-color: #eee;
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
		location.href="AdminAccountList?status=${param.status}&listLimit=" + limit;
	}
	// 프로젝트 상세
    function accountDetail(project_code, project_title) {
    	// HTML 특수 문자와 공백을 URL에 안전하게 인코딩
		var encodedProjectTitle = encodeURIComponent(project_title);
		location.href = "AdminAccountDetail?project_code=" + project_code + "&project_title=" + encodedProjectTitle;
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
					<c:when test="${param.status eq '출금대기'}">
						<h3>출금이체 대기중인 프로젝트</h3>
					</c:when>
					<c:when test="${param.status eq '입금대기'}">
						<h3>입금이체 대기중인 프로젝트</h3>
					</c:when>
					<c:when test="${param.status eq '입금완료'}">
						<h3>정산완료된 프로젝트</h3>
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
					<form action="AdminAccountList">
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
							<th>프로젝트 진행상태</th>
							<th>펀딩 종료일</th>
							<c:choose>
								<c:when test="${param.status eq '출금대기'}">
									<th>결제 종료일</th>
									<th>후원자 목록</th>
								</c:when>
								<c:otherwise>	<!-- 입금대기, 입금완료 -->
									<th>정산일</th>
									<th>총 모금액</th>
									<th>정산액</th>
									<th>계좌정보</th>
								</c:otherwise>
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
						<c:forEach var="account" items="${accountList}">
							<tr align="center">
								<td>${account.project_code}</td>
								<td>${account.project_title}</td>
								<td>${account.project_status}</td>
								<td>${account.funding_end_date}</td>
								<c:choose>
									<c:when test="${param.status eq '출금대기'}">
										<td>${account.user_payment_date}일 전</td>
										<td><input type="button" value="후원자목록" onclick="accountDetail('${account.project_code}', '${account.project_title}')"></td>
									</c:when>
									<c:when test="${param.status eq '입금대기'}">
										<td>${account.settlement_date}일 전</td>
										<td><fmt:formatNumber value="${account.funding_account}" type="number" groupingUsed="true"/>원</td>
						                <c:set var="commission" value="${account.funding_account * 0.08}" />	<%-- 수수료(8%) 계산 --%>
						                <c:set var="vat" value="${commission * 0.10}" />	<%-- 부가가치세(VAT 10%) 계산 --%>
						                <c:set var="totalFee" value="${commission + vat}" />	<%-- 총 수수료 --%>
						                <c:set var="finalAmount" value="${account.funding_account - totalFee}" />	<%-- 수수료를 뺀 최종 금액 --%>
           							    <td><fmt:formatNumber value="${finalAmount}" type="number" maxFractionDigits="0"/>원</td>	<%-- 최종 금액을 반올림하여 출력 --%>
										<td>
											<c:forEach var="info" items="${bankUserInfo.res_list}">
												${info.account_holder_name}&nbsp;${info.account_num_masked}(${info.bank_name})
											</c:forEach>
										</td>
									</c:when>
									<c:when test="${param.status eq '입금완료'}">
										<td>${account.settlement_date}일 전</td>
										<td><fmt:formatNumber value="${account.funding_account}" type="number" groupingUsed="true"/>원</td>
						                <c:set var="commission" value="${account.funding_account * 0.08}" />	<%-- 수수료(8%) 계산 --%>
						                <c:set var="vat" value="${commission * 0.10}" />	<%-- 부가가치세(VAT 10%) 계산 --%>
						                <c:set var="totalFee" value="${commission + vat}" />	<%-- 총 수수료 --%>
						                <c:set var="finalAmount" value="${account.funding_account - totalFee}" />	<%-- 수수료를 뺀 최종 금액 --%>
           							    <td><fmt:formatNumber value="${finalAmount}" type="number" maxFractionDigits="0"/>원</td>	<%-- 최종 금액을 반올림하여 출력 --%>
										<td>
											<c:forEach var="info" items="${bankUserInfo.res_list}">
												${info.account_holder_name}&nbsp;${info.account_num_masked}(${info.bank_name})
											</c:forEach>
										</td>
									</c:when>
								</c:choose>
							</tr>
						</c:forEach>
						<c:if test="${empty accountList}">
							<c:choose>
								<c:when test="${param.status eq '출금대기'}">
									<tr>
										<td align="center" colspan="6">조회 결과가 없습니다.</td>
									</tr>
								</c:when>
								<c:otherwise>
									<tr>
										<td align="center" colspan="8">조회 결과가 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<div id="pageList">
					<%-- [이전] 버튼 클릭 시 AdminAccountList 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
					<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<input type="button" value="이전" onclick="location.href='AdminAccountList?pageNum=${pageNum - 1}&status=${param.status}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
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
								<a href="AdminAccountList?pageNum=${i}&status=${param.status}">${i}</a> <%-- 다른 페이지 번호 --%>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<%-- [다음] 버튼 클릭 시 AdminAccountList 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
					<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
					<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
					<input type="button" value="다음" onclick="location.href='AdminAccountList?pageNum=${pageNum + 1}&status=${param.status}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
				</div>
			</article>
		</section>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>