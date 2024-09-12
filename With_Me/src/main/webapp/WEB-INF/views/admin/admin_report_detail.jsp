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
	.inner>.con01>h2 {
		text-align: center;
	}
	#infoArea {margin: auto;}
	#reportForm {margin: auto;}
	#reportForm>input {margin: auto;}
	/* 신고 접수/처리 버튼 시작 */
	.receptionBtn, .transactionBtn, .transactionCompleteBtn {
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
	.receptionBtn:disabled, .transactionBtn:disabled, .transactionCompleteBtn:disabled {
		background-color: gray;
	}
	/* 신고 접수/처리 버튼 끝 */
	
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
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>	
	<div class="inner">
		<section class="con01">
			<h2>신고 상세정보</h2>
			<br>
			<div class="itemWrapper">
				<div id="infoArea">
					<div class="fundInfo1">
						<div>
							<span><b>신고자 이름</b></span>
							<ul>
								<li>${member.mem_name}(${member.mem_email})</li>
							</ul>
						</div>
					</div>
					<div class="fundInfo2">
						<dl>
							<dt>신고 번호</dt>
							<dd> | ${report.report_idx}</dd>
						</dl>
						<dl>
							<c:choose>
								<c:when test="${report.report_project_code != null}">
									<dt>신고 프로젝트</dt>
									<dd> | ${project.project_title}(${project.project_code})</dd>
								</c:when>
								<c:when test="${report.report_product_code != null}">
									<dt>신고 상품</dt>
									<dd> | ${product.product_name}(${product.product_code})</dd>
								</c:when>
							</c:choose>
						</dl>
						<dl>
							<dt>신고 카테고리</dt>
							<dd> | ${report.report_category}</dd>
						</dl>
						<dl>
							<dt>신고 사유</dt>
							<dd> | ${report.report_reason}</dd>
						</dl>
						<dl>
							<dt>증빙 자료</dt>
							<c:choose>
								<c:when test="${report.report_file == null or report.report_file eq ''}">
									<dd> | 파일이 없습니다</dd>
								</c:when>
								<c:otherwise>
									<dd>
										<%-- 파일명 존재할 경우 원본 파일명 출력 --%>
										 | ${originalFileName[3]}
										<%-- 파일 다운로드 링크(버튼) 생성 --%>
										<a href="${pageContext.request.contextPath}/resources/upload/${fileName}" download="${originalFileName[3]}">
											<input type="button" value="다운로드">
										</a>
									</dd>
								</c:otherwise>
							</c:choose>
						</dl>
						<dl>
							<dt>참고 URL1</dt>
							<c:choose>
								<c:when test="${report.report_ref_url1 == null or report.report_ref_url1 eq ''}">
									<dd> | URL이 없습니다</dd>
								</c:when>
								<c:otherwise>
									<dd> | ${report.report_ref_url1}</dd>
								</c:otherwise>
							</c:choose>
						</dl>
						<dl>
							<dt>참고 URL2</dt>
							<c:choose>
								<c:when test="${report.report_ref_url2 == null or report.report_ref_url2 eq ''}">
									<dd> | URL이 없습니다</dd>
								</c:when>
								<c:otherwise>
									<dd> | ${report.report_ref_url2}</dd>
								</c:otherwise>
							</c:choose>
						</dl>
						<dl>
							<dt>참고 URL3</dt>
							<c:choose>
								<c:when test="${report.report_ref_url3 == null or report.report_ref_url3 eq ''}">
									<dd> | URL이 없습니다</dd>
								</c:when>
								<c:otherwise>
									<dd> | ${report.report_ref_url3}</dd>
								</c:otherwise>
							</c:choose>
						</dl>
						<dl>
							<dt>신고 날짜</dt>
							<dd> | 
								<%-- 년년년년-월월-일일 시시:분분 형태로 포맷팅 --%>
								<fmt:formatDate value="${report.report_date}" pattern="yyyy-MM-dd HH:mm"/>
							</dd>
						</dl>
						<dl>
							<dt>신고 상태</dt>
							<c:choose>
								<c:when test="${report.report_state == null or report.report_state eq ''}"> | 접수대기</c:when>
								<c:otherwise><dd> | ${report.report_state}</dd></c:otherwise>
							</c:choose>
						</dl>
					</div>
					<div class="fundInfo3">
						<form action="ChangeReportState" id="reportForm" method="post">
							<input type="hidden" name="report_idx" value="${report.report_idx}">
							<input type="hidden" name="report_state" value="${report.report_state}">
							<c:choose>
								<c:when test="${report.report_state == null or report.report_state eq ''}">
									<input type="submit" class="receptionBtn" value="신고접수">
								</c:when>
								<c:when test="${report.report_state eq '접수완료'}">
									<input type="submit" class="transactionBtn" value="신고처리">
								</c:when>
								<c:when test="${report.report_state eq '처리완료'}">
									<input type="submit" class="transactionCompleteBtn" value="처리완료" disabled>
								</c:when>
							</c:choose>
						</form>
					</div>
				</div>
			</div>
		</section>
		<div class="listBtn">
			<input type="button" id="listBtn" value="목록" onclick="location.href='AdminReport'">
		</div>
	</div>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>