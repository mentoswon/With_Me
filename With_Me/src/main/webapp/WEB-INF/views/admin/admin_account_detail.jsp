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
		// HTML 특수 문자와 공백을 URL에 안전하게 인코딩
		
		var encodedProjectTitle = encodeURIComponent('${param.project_title}');
		location.href="AdminAccountDetail?project_code=${param.project_code}&project_title=" + encodedProjectTitle + "&listLimit=" + limit;
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
				<h3>${param.project_title} (${param.project_code})</h3>
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
					<form action="AdminAccountDetail">
						<div class="search">
							<span>Search</span>
							<input type="hidden" name="project_code" value="${param.project_code}">
							<input type="search" name="searchKeyword" value="${param.searchKeyword}" >
							<input type="submit" value="검색">
						</div>
					</form>
				</div>
				<div class="content">
					<table border="1">
						<tr>
							<th>USER ID</th>
							<th>후원자명</th>
							<th>결제예정일</th>
							<th>결제금액</th>
							<th>결제상태</th>
							<th>계좌정보</th>
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
								<td>${account.mem_email}</td>
								<td>${account.mem_name}</td>
								<td>${account.user_payment_date}</td>
								<td>${account.funding_pay_amt}원</td>
								<td>${account.pro_pay_status}</td>
								<td>
									<c:forEach var="info" items="${bankUserInfo.res_list}">
										${info.account_holder_name}&nbsp;${info.account_num_masked}(${info.bank_name})
									</c:forEach>
								</td>
							</tr>
						</c:forEach>
						<c:if test="${empty accountList}">
							<tr>
								<td align="center" colspan="6">조회 결과가 없습니다.</td>
							</tr>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<div id="pageList">
					<%-- [이전] 버튼 클릭 시 AdminAccountList 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
					<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<input type="button" value="이전" onclick="location.href='AdminAccountDetail?pageNum=${pageNum - 1}&project_code=${param.project_code}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
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
								<a href="AdminAccountDetail?pageNum=${i}&project_code=${param.project_code}">${i}</a> <%-- 다른 페이지 번호 --%>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<%-- [다음] 버튼 클릭 시 AdminAccountList 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
					<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
					<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
					<input type="button" value="다음" onclick="location.href='AdminAccountDetail?pageNum=${pageNum + 1}&project_code=${param.project_code}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
				</div>
			</article>
		</section>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>