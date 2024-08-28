<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>

<style>
b {
	line-height: 250%;
}

/* 캘린더 */
.ui-datepicker {
    background-color: #f6f6f6;
    color: #333;
    border: 1px solid #ddd;
    width: 350px;
}

/* 선택된 날짜 */
.ui-datepicker .ui-state-active {
    background-color: #FFAB40;
    color: #fff;
}

/* 캘린더 제목(월/연도) */
.ui-datepicker-title {
    font-weight: bold;
    color: #595959;
}

/* 요일 이름 */
.ui-datepicker th {
    color: #595959;
    font-weight: bold;
}

/* 주말 날짜 텍스트 */
.ui-datepicker-week-end .ui-state-default {
    color: #dc3545;
}

/* 마우스 오버 시 날짜 스타일 */
.ui-datepicker .ui-state-active,
.ui-datepicker .ui-state-hover {
    background-color: #FFAB40; /* 배경색 설정 */
    color: #fff;
}

/* 선택된 날짜 및 마우스 오버 시 배경색 */
.ui-datepicker .ui-state-active, .ui-datepicker .ui-state-hover {
    background-color: #FFAB40;
    color: #fff;
}

/* 날짜 셀 */
.ui-datepicker td {
    width: 40px;
    height: 40px;
    text-align: center;
    vertical-align: middle;
    padding: 0;
}

/* 날짜 텍스트 */
.ui-datepicker .ui-state-default {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    border: none;
    border-radius: 50%; /* 동그랗게 만들기 */
    padding: 5px;
    margin: 0 5px;
    box-sizing: border-box;
}


/* ----- 캘린더 아이콘 삽입 ----- */
.date-input {
    position: relative;
    display: inline-block;
}
.date-input input {
    padding-right: 30px; /* 아이콘 크기에 맞게 조정 */
    box-sizing: border-box;
}
.calendar-icon {
    position: absolute;
    right: 10px; /* 아이콘 위치 조정 */
    top: 50%;
    transform: translateY(-50%);
    width: 20px; /* 아이콘 크기 조정 */
    height: 20px; /* 아이콘 크기 조정 */
    background-size: contain;
    background-repeat: no-repeat;
    pointer-events: none; /* 아이콘 클릭 방지 */
}
</style>

<script>
$(document).ready(function() {
    $.datepicker.regional['ko'] = {
        closeText: '닫기',
        prevText: '이전달',
        nextText: '다음달',
        currentText: '오늘',
        monthNames: ['1월','2월','3월','4월','5월','6월',
        '7월','8월','9월','10월','11월','12월'],
        monthNamesShort: ['1월','2월','3월','4월','5월','6월',
        '7월','8월','9월','10월','11월','12월'],
        dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'],
        dayNamesShort: ['일','월','화','수','목','금','토'],
        dayNamesMin: ['일','월','화','수','목','금','토'],
        weekHeader: '주',
        dateFormat: 'yy-mm-dd',
        firstDay: 0,
        isRTL: false,
        showMonthAfterYear: true,
        yearSuffix: '년'
    };
    $.datepicker.setDefaults($.datepicker.regional['ko']);

    let today = new Date();
    let tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    let tomorrowFormatted = $.datepicker.formatDate('yy-mm-dd', tomorrow);

    $("#start_date").datepicker({
        dateFormat: 'yy-mm-dd',
        minDate: tomorrow,
        beforeShow: function(input, inst) {
            setTimeout(setDatepickerZIndex, 0);
        },
        onSelect: function(selectedDate) {
            let startDate = $(this).datepicker('getDate');
            let endDateMin = new Date(startDate);
            endDateMin.setDate(startDate.getDate() + 1);
            let endDateMax = new Date(startDate);
            endDateMax.setDate(startDate.getDate() + 60);

            $('#end_date').datepicker('option', 'minDate', endDateMin);
            $('#end_date').datepicker('option', 'maxDate', endDateMax);
            $('#end_date').prop('disabled', false);

            updateStartDate();
            updateCalculations();
        }
    });

    $("#end_date").datepicker({
        dateFormat: 'yy-mm-dd',
        beforeShow: function(input, inst) {
            setTimeout(setDatepickerZIndex, 0);
        },
        onSelect: function(selectedDate) {
            updateEndDate();
            updateCalculations();
            
			// 요금제 선택 영역을 보이도록 설정
            $("#selectChargeWrap").show();
        }
    });

    $('#end_date').prop('disabled', true);

    function setDatepickerZIndex() {
        $('.ui-datepicker').css('z-index', 9999);
    }

    function updateStartDate() {
        let date = $("#start_date").val();
        if (date) {
            $("#funding_start_date").val(date);
        }
    }

    function updateEndDate() {
        let date = $("#end_date").val();
        if (date) {
            $("#funding_end_date").val(date);
        }
    }

    function updateCalculations() {
        let startDateStr = $("#start_date").val();
        let endDateStr = $("#end_date").val();

        if (startDateStr && endDateStr) {
            let startDate = new Date(startDateStr);
            let endDate = new Date(endDateStr);

            // 펀딩 기간 계산
            let fundingPeriod = Math.ceil((endDate - startDate) / (1000 * 60 * 60 * 24));
            $("#fundingPeriod").text(fundingPeriod);

            // 후원자 결제 종료일 계산 (종료일 다음날부터 7일)
            let userPaymentDate = new Date(endDate);
            userPaymentDate.setDate(endDate.getDate() + 1);
            userPaymentDate.setDate(userPaymentDate.getDate() + 7);
            $("#userPaymentDate").text($.datepicker.formatDate('yy-mm-dd', userPaymentDate));

			// 정산일 계산 (후원자 결제 종료일 기준으로 다음날부터 7일)
            let settlementDate = new Date(userPaymentDate);
            settlementDate.setDate(userPaymentDate.getDate() + 1);
            settlementDate.setDate(settlementDate.getDate() + 7);
            $("#settlementDate").text($.datepicker.formatDate('yy-mm-dd', settlementDate));
        }
    }
});
</script>


	<b>시작일</b><br>
	<div class="date-input">
		<input type="text" id="start_date" readonly="readonly" placeholder="시작 날짜를 선택해주세요." value="${project.funding_start_date}">
		<span class="calendar-icon">
			<img alt="캘린더아이콘" src="${pageContext.request.contextPath}/resources/image/calendar.png">
		</span>
	</div>
	<br><br>

	<b>종료일</b><br>
	<div class="date-input">
		<input type="text" id="end_date" readonly="readonly" placeholder="종료 날짜를 선택해주세요." value="${project.funding_end_date}">
		<span class="calendar-icon">
			<img alt="캘린더아이콘" src="${pageContext.request.contextPath}/resources/image/calendar.png">
		</span>
	</div>
	<br><br>

	<b>펀딩기간</b><br>
	<span><span id="fundingPeriod">0</span>일</span><br><br>

	<b>후원자 결제종료</b><br>
	
	<span id="userPaymentDate">종료일 다음날부터 7일</span><br><br>

	<b>정산일</b><br>
	<span id="settlementDate">결제종료 다음날부터 7일</span><br><br>


<%-- 시작일, 종료일 전달 --%>
<input type="hidden" id="funding_start_date" name="funding_start_date" value="${project.funding_start_date}" readonly>
<input type="hidden" id="funding_end_date" name="funding_end_date" value="${project.funding_end_date}" readonly>