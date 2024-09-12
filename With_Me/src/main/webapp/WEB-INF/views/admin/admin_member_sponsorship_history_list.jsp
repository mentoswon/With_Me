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
	function showListLimit(limit){
		location.href="SponsorshipHistoryList?mem_email=${member.mem_email}&listLimit=" + limit;
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
				<h3>${member.mem_name}님의 후원내역</h3>
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
					<form action="SponsorshipHistoryList">
						<div class="search">
							<span>Search</span>
							<input type="hidden" name="mem_email" value="${member.mem_email}">
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
							<th>결제상태</th>
							<th>결제일</th>
							<th>결제금액</th>
							<th>결제방법</th>
						</tr>
						<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
						<c:set var="pageNum" value="1" />
						<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
						<c:if test="${not empty param.pageNum}">
							<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
							<c:set var="pageNum" value="${param.pageNum}" />
						</c:if>
						<c:forEach var="SHL" items="${sponsorshipHistoryList}">
							<tr align="center">
								<td>${SHL.project_code}</td>
								<td>${SHL.project_title}</td>
								<td>${SHL.pro_pay_status}</td>
								<td>
									<c:choose>
										<c:when test="${SHL.pro_pay_status eq '미결제'}">
											아직 결제가 진행되지 않았습니다
										</c:when>
										<c:otherwise>
											<%-- 
											테이블 조회를 Map 타입으로 관리 시 날짜 및 시각 데이터가
											LocalXXX 타입으로 관리됨(ex. LocalDate, LocalTime, LocalDateTime)
											=> 날짜 및 시각 정보 조회 시 2024-08-21T16:47:59 형식으로 저장되어 있음
											=> 일반 Date 타입에서 사용하는 형태로 파싱 후 다시 포맷팅 작업 필요
											=> JSTL fmt 라이브러리 - <fmt:parseDate> 태그 활용하여 파싱 후
											   <fmt:formatDate> 태그 활용하여 포맷팅 수행
											   var 속성 : 파싱 후 해당 날짜 및 시각 정보를 다룰 객체명(변수명)
											   value 속성 : 파싱할 대상 날짜 데이터
											   pattern 속성 : 파싱할 대상 날짜 데이터의 기존 형식(2024-08-21T16:47:59)에 대한 패턴 지정
											                  => 날짜와 시각 사이의 구분자 T 도 정확하게 명시
											                     (단, 구분자 T 는 단순 텍스트로 취급하기 위해 '' 로 둘러쌈)
											   type 속성 : 대상 날짜 파싱 타입(time : 시각, date : 날짜, both : 둘 다)
											--%>
											<fmt:parseDate var="pro_pay_date" value="${SHL.pro_pay_date}" 
															pattern="yyyy-MM-dd'T'HH:mm" type="both" />
											<%-- 파싱 후 날짜 및 시각 형식 : Wed Aug 21 16:47 KST 2024 --%>
											<%-- 파싱된 날짜 및 시각이 저장된 Date 객체의 포맷팅 수행 --%>								
											<%-- 년년년년-월월-일일 시시:분분 형태로 포맷팅 --%>
											<fmt:formatDate value="${pro_pay_date}" pattern="yyyy-MM-dd HH:mm"/>
										</c:otherwise>
									</c:choose>
								</td>
								<td><fmt:formatNumber value="${SHL.pro_pay_amt}" pattern="#,###"/>원</td>
								<td>${SHL.pay_method_name}</td>
							</tr>
						</c:forEach>
						<c:if test="${empty sponsorshipHistoryList}">
							<tr>
								<td align="center" colspan="6">후원내역이 없습니다.</td>
							</tr>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<div id="pageList">
					<%-- [이전] 버튼 클릭 시 SponsorshipHistoryList 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
					<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<input type="button" value="이전" onclick="location.href='SponsorshipHistoryList?mem_email=${member.mem_email}&pageNum=${pageNum - 1}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
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
								<a href="SponsorshipHistoryList?mem_email=${member.mem_email}&pageNum=${i}">${i}</a> <%-- 다른 페이지 번호 --%>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<%-- [다음] 버튼 클릭 시 SponsorshipHistoryList 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
					<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
					<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
					<input type="button" value="다음" onclick="location.href='SponsorshipHistoryList?mem_email=${member.mem_email}&pageNum=${pageNum + 1}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
				</div>
			</article>
		</section>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>