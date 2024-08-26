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
		<link href="${pageContext.request.contextPath}/resources/css/fund_in_progress.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<h2>${member.mem_name} 후원자님! 다시 한 번 확인해주세요.</h2>
			<section class="con01">
				<div class="userInfo">
					<h4>후원자 정보</h4>
					<div class="infoWrapper">
						<div>
							<div>연락처</div>
							<div>${member.mem_tel}</div>
						</div>
						<div>
							<div>이메일</div>
							<div>${member.mem_email}</div>
						</div>
						
						<span> * 위 연락처와 이메일로 후원 관련 소식이 전달됩니다. </span>
						<span> * 연락처 및 이메일 변경은 설정 > 계정 설정에서 가능합니다. </span>
					</div>
				</div>
			</section>
			
			<section class="con02">
				<div class="addressInfo">
					<h4>배송지</h4>
					<div class="infoWrapper">
						<button>
							<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
							&nbsp;&nbsp;&nbsp; 배송지 추가
						</button>
						<div class="address">
							<%-- address 테이블에서 가져와서 반복 --%>
							<c:choose>
								<c:when test=""></c:when>
								<c:otherwise></c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</section>
			
			<section class="con03">
				<div class="moreFundAmt">
					<h4>추가 후원(선택)</h4>
					<div class="infoWrapper">
						<div>
							<div>후원금</div>
							<input type="text"> 원
						</div>
					</div>
				</div>
			</section>
		</div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		<script type="text/javascript">
		</script>
	</body>
</html>




















