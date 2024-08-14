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
    padding: 5px; /* 텍스트 주위에 여백을 추가 */
    margin: 0 5px;  /* 마진 제거 */
    box-sizing: border-box; /* 패딩이 포함되도록 설정 */
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
	// jQuery UI Datepicker의 한글 설정
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
    $.datepicker.setDefaults($.datepicker.regional['ko']); // 한글 설정 적용

	
    // 오늘 날짜와 내일 날짜 설정
    let today = new Date();
    let tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    let tomorrowFormatted = $.datepicker.formatDate('yy-mm-dd', tomorrow);

    // 출발일 선택 시
    $("#start_date").datepicker({
        dateFormat: 'yy-mm-dd',
        minDate: tomorrow, // 내일 날짜부터 선택 가능
        beforeShow: function(input, inst) {
            setTimeout(setDatepickerZIndex, 0); // 캘린더 열릴 때 z-index 설정
        },
        onSelect: function(selectedDate) {
            let startDate = $(this).datepicker('getDate');
            // 종료일의 최소, 최대 날짜를 설정합니다.
            let endDateMin = new Date(startDate);
            endDateMin.setDate(startDate.getDate() + 1); // 시작일 다음 날부터
            let endDateMax = new Date(startDate);
            endDateMax.setDate(startDate.getDate() + 60); // 시작일로부터 최대 60일 이내

            $('#end_date').datepicker('option', 'minDate', endDateMin);
            $('#end_date').datepicker('option', 'maxDate', endDateMax);

            // 종료일 필드 활성화
            $('#end_date').prop('disabled', false);

            // 숨겨진 필드에 시작일 업데이트
            updateStartDate();
        }
    });

    // 종료일 선택 시
    $("#end_date").datepicker({
        dateFormat: 'yy-mm-dd',
        beforeShow: function(input, inst) {
            setTimeout(setDatepickerZIndex, 0); // 캘린더 열릴 때 z-index 설정
        },
        onSelect: function(selectedDate) {
            // 숨겨진 필드에 종료일 업데이트
            updateEndDate();
        }
    });

    // 페이지가 처음 로드될 때 종료일 필드 비활성화
    $('#end_date').prop('disabled', true);

    // 공통 설정(캘린더를 맨앞으로 이동)
    function setDatepickerZIndex() {
        $('.ui-datepicker').css('z-index', 9999);
    }

    // 시작일 숨겨진 필드 업데이트
    function updateStartDate() {
        let date = $("#start_date").val();
        if (date) {
            $("#funding_start_date").val(date);
        }
    }

    // 종료일 숨겨진 필드 업데이트
    function updateEndDate() {
        let date = $("#end_date").val();
        if (date) {
            $("#funding_end_date").val(date);
        }
    }
});
</script>


	<b>시작일</b><br>
	<div class="date-input">
		<input type="text" id="start_date" readonly="readonly" placeholder="시작 날짜를 선택해주세요.">
		<span class="calendar-icon">
			<img alt="캘린더아이콘" src="${pageContext.request.contextPath}/resources/image/calendar.png">
		</span>
	</div>
	<br>

	<b>종료일</b><br>
	<div class="date-input">
		<input type="text" id="end_date" readonly="readonly" placeholder="종료 날짜를 선택해주세요.">
		<span class="calendar-icon">
			<img alt="캘린더아이콘" src="${pageContext.request.contextPath}/resources/image/calendar.png">
		</span>
	</div>
	<br>

	<b>펀딩기간</b><br>
	<span><span id="fundingPeriod">0</span>일</span><br>

	<b>후원자 결제종료</b><br>
	
	<span id="userPaymentDate">종료일 다음날부터 7일</span><br>

	<b>정산일</b><br>
	<span id="settlementDate">결제종료 다음날부터 7일</span><br>


<%-- 시작일, 종료일 전달 --%>
<input type="hidden" id="funding_start_date" name="funding_start_date" readonly>
<input type="hidden" id="funding_end_date" name="funding_end_date" readonly>