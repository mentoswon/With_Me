<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/res_confirm.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage.css" rel="stylesheet" type="text/css">
<!-- jquery 라이브러리 포함시키기 -->
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style>
    /* 추가 스타일 정의 */
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
    }
    .OuterBox {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }
    .myPageBox {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .myPageBox .header {
        width: 100%;
        text-align: center;
    }
    .myInfoManagement {
        margin-top: 10px;
        align-self: flex-end;
    }
    .resSection, .questionSection {
        width: 100%;
        margin-top: 20px;
        border: 1px solid #ccc;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
        border-radius: 8px;
    }
    .reservationList {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 20px;
    }
    .resCarImage, .carImage {
        flex: 1;
    }
    .carImage img {
        display: block;
        max-width: 100%;
        height: auto;
    }
    .reservationInfo {
        flex: 2;
        margin-left: 20px;
    }
    .questionList {
        text-align: center;
    }
    .chatCont {
        position: fixed;
        bottom: 20px;
        right: 20px;
    }
    .chatBtn a {
        display: block;
        background-color: #ffcc00;
        padding: 10px 20px;
        border-radius: 5px;
        text-align: center;
        color: #000;
        font-weight: bold;
        text-decoration: none;
    }
    footer {
        margin-top: 40px;
        text-align: center;
        padding: 20px;
        background-color: #f8f8f8;
        border-top: 1px solid #ddd;
    }
</style>
</head>
<body>
    <header>
        <!-- 기본 메뉴 표시 영역(inc/top.jsp) 페이지 삽입 -->
        <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    </header>
    
    <div class="OuterBox">
        <main>
            <section>
                <div class="myPageBox">
                    <div class="header">
                        <h1>내 정보</h1>
                    </div>
                    <section class="resSection">
                        <h2>기본정보</h2>
                            <div class="reservationList">
                                <div class="resCarImage">
                                    <div>
		                                <input type="text" name="name" id="name" value="${member.mem_name}" required 
										pattern="^[가-힣]{2,5}$" title="한글 2-5글자">
                                    </div>
                                </div>
                                <div class="reservationInfo" align="left">
                                    <h3>${ReserveList[0].car_model}</h3>
                                    <p>예약 번호: ${ReserveList[0].res_idx}</p>
                                    <p>지점 : ${ReserveList[0].brc_name}</p>
                                    <p>
                                        <fmt:parseDate value="${ReserveList[0].res_rental_date}" pattern="yyyy-MM-dd" var="parseDateTime" type="both"/>
                                        <fmt:formatDate value="${parseDateTime}" pattern="yyyy-MM-dd" /> ~ 
                                        <fmt:parseDate value="${ReserveList[0].res_return_date}" pattern="yyyy-MM-dd" var="parseDateTime" type="both"/>
                                        <fmt:formatDate value="${parseDateTime}" pattern="yyyy-MM-dd" />
                                    </p>
                                </div>
                                <button class="detailsBtn" onclick="location.href='ReservationDetail?res_idx=${ReserveList[0].res_idx}'">예약 상세 보기</button><br>
                                <button class="payStatus">${ReserveList[0].pay_status}</button>
                            </div>
                    </section>
                    <section class="questionSection">
                        <div class="questionList">
                            <div class="questionContent">
                                <h2>1:1 문의내역</h2>
                                <p>정확한 답변으로 안내해 드릴게요</p>
                            </div>
                            <br>
                            <div>
                                <button class="moreViewBtn" onclick="location.href='MyQuestionList'">이동</button>
                            </div>
                        </div>
                    </section>
                </div>
            </section>
        </main>
    </div>

    <!-- 카카오톡 1:1문의하기 -->
    <div class="chatCont">
        <div class="chatBtn">
            <a>1:1<br>문의</a>
        </div>
    </div>
    
    <footer>
        <!-- 회사 소개 영역 -->
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
    </footer>
</body>
</html>
