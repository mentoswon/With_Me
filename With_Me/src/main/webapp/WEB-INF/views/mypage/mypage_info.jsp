<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<%-- 외부 CSS 파일(css/default.css) 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/res_confirm.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
</head>
<body>
	<header>
		<%-- 기본 메뉴 표시 영역(inc/top.jsp) 페이지 삽입 --%>
		<%-- 현재 위치는 컨텍스트 루트(/MVC_Board = webapp) 이므로 inc 디렉토리의 top.jsp 지정 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<div class="OuterBox" align="center">
		<main>
			<section>
				<div align="center" class="myPageBox">
					<div class="header">
						<h1>마이페이지</h1>
						
						<!-- join절 써서 예약리스트 가져오기 변수명 reserve로 지정 -->
<%-- 						<c:forEach items="${ReserveList}" var="reserve"> --%>
						
					</div>
					<div align="right">
						<button class="myInfoManagement" id="myInfo" onclick="location.href='myInfo'">내 정보 관리</button>
					</div>			
					<section class="resSection">
						<input type="hidden" value="${ReserveList[0].mem_id}" name="mem_id" id="mem_id"readonly>
						<h2>예약내역</h2>
							<c:if test="${sessionScope.sId eq ReserveList[0].mem_id}">
								<div class="reservationList">
									<div class="carList_top">
										<div class="resCarImage">
											<!-- 로고사진 -->
<!-- 											<img -->
<%-- 												src="${pageContext.request.servletContext.contextPath}/resources/images/1그랜저.png" --%>
<!-- 												width="300px" height="300px" alt="Car Image"> -->
											<br>
<%-- 											<a>${ReserveList[0].car_company}</a> --%>
<%-- 											<h3>${ReserveList[0].car_model}</h3> --%>
										</div>
										<div class="carImage">
											<img
												src="${pageContext.request.contextPath}/resources/upload/${ReserveList[0].car_model_image}" width="200px"><br>
												<img src="${pageContext.request.servletContext.contextPath}/resources/upload/${ReserveList[0].car_logo_image}">
										</div>
									</div>
									<div class="reservationInfo" align="left">
										<h3>${ReserveList[0].car_model}</h3>
										<p>예약 번호: ${ReserveList[0].res_idx}</p>
										<p>지점 : ${ReserveList[0].brc_name}</p>
										<p>
										<fmt:parseDate value="${ReserveList[0].res_rental_date}" pattern="yyyy-MM-dd" var="parseDateTime" type="both"/>
											<fmt:formatDate value="${parseDateTime}"
											pattern="yyyy-MM-dd" /> ~ 
											<fmt:parseDate value="${ReserveList[0].res_return_date}" pattern="yyyy-MM-dd" var="parseDateTime" type="both"/>
											<fmt:formatDate value="${parseDateTime}"
											pattern="yyyy-MM-dd" />
										</p>
									</div>
										<button class="detailsBtn"
											onclick="location.href='ReservationDetail?res_idx=${ReserveList[0].res_idx}'">예약 상세 보기</button><br>
									<button class="payStatus">${ReserveList[0].pay_status}</button>
								</div>
 							</c:if>
					</section>
					<section class="questionSection">
						<div class="questionList">
							<div class="questionContent">
								<h2>1:1 문의내역</h2>
								<p>정확한 답변으로 안내해 드릴게요</p>
							</div>
							<br>
							<div>
								<button class="moreViewBtn"
								onclick="location.href='MyQuestionList'">이동</button>
							</div>
						</div>
					</section>
						
				</div>
			</section>
		</main>
	</div>
		
		

    
    
    <!-- okokokkokok 카카오톡 1:1문의하기 okokokkokok-->		
	<div class="chatCont">
		<div class="chatBtn">
			<a>
				1:1<br>
				문의
			</a>
		</div>
	</div>
    
    
     
    <footer>
        <%-- 회사 소개 영역 --%>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
    </footer>
</body>
</html>