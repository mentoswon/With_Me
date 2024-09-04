<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>With_Me</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
article {
    width: 1080px;
    margin: 0 auto;
    position: relative;
}

#topWrap {
	text-align: left;
	width: 100%;
	margin: 20px 0;
	
}
#topWrap h4 {
	font-size: 32px;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
	margin-bottom: 30px;
}

/* ----- 진행상태 필터버튼 ----- */
#statusMenu ul {
	list-style-type: none;
	padding: 0;
	margin: 0;
	display: flex;
	gap: 10px;	/* 항목 사이 간격 */
}

#statusMenu li {
	width: 60px;
	padding: 10px 15px;
	background-color: #fff;
	border: 2px solid #ccc;
	border-radius: 23px;
	cursor: pointer;
	text-align: center;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#statusMenu li:hover {
	background-color: #FFAB40;
	border-color: #FFAB40;
	color: #fff;
}
#statusMenu li.selected  {
	background-color: #FFAB40;
	border-color: #FFAB40;
	color: #fff;
}

/* 프로젝트 리스트 영역 */
.projectWrap {
	display: flex;
 	justify-content: space-between;
    align-items: center;
    gap: 20px;
	border: 3px solid #ccc;
	padding: 20px;
	margin-bottom: 20px;
}
.projectWrap p {
	line-height: 300%;	/* 줄간격 */
}
.projectImage {
	width: 250px;
	height: 200px;
}
.projectImage img {
	width: 100%;
	height: 100%;
	border-radius: 5px;
}

.projectContent {
	width: 550px;
}

.management, .delete, .requestDelete {
	width: 150px;
	height: 50px;
	margin: 10px;
	border-radius: 10px;
	font-size: 16px;
}
.management {	/* 관리 */
	border: none;
	background-color: #FFAB40;
	color: #ffffff;
}

.delete, .requestDelete {	/* 삭제, 삭제요청 */
	background-color: #ffffff;
	border: 2px solid #ccc;
}

/* 프로젝트가 없을 경우 */
.emptyProjectListWrap {
	text-align: center;
}
.emptyProjectListWrap h2 {
	line-height: 200%;	/* 줄간격 */
}

#projectStart {
	width: 290px;
	height: 45px;
	margin: 10px;
	border-radius: 10px;
	border: none;
	background-color: #FFAB40;
	color: #ffffff;
}
input[type="button"]:hover:not(:disabled) {
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}

/* 비활성화된 삭제 버튼 스타일 */
.requestDelete:disabled,
.requestDelete.disabled {
    background-color: #e0e0e0;
    color: #a0a0a0;
    cursor: default;
    opacity: 0.6;
}

/* 프로젝트 삭제요청 팝업 */
#popupWrap {
 	display: none;
	position: fixed;
    top: 50%; 
    left: 50%;
    transform: translate(-50%, -50%);
    width: 670px; 
    box-sizing: border-box;;
    background-color: #f1f3f5;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
    z-index: 9999;
    padding: 30px;
    overflow: auto;
	overflow-x: none;
}

#popupTop {
	margin: 0 10px;
}
#popupTop h2 {
	line-height: 200%;	/* 줄간격 */
}

#popupContent {
	padding: 10px;
}
#popupContent label {
	line-height: 200%;
}

textarea {
	padding: 8px 10px;
	width: 550px;
	border: 1px solid #ccc;
	border-color: #ccc;
	box-sizing: border-box;
	outline-style: none;	/* 포커스시 발생하는 효과 제거 */
	resize: none;
	margin-left: 30px;
}

#request, #cancel {
	width: 100%;
	height: 40px;
	margin: 6px 0;
	border-radius: 10px;
	font-size: 16px;
}
#request {	/* 관리 */
	border: none;
	background-color: #FFAB40;
	color: #ffffff;
}

#cancel {	/* 삭제, 삭제요청 */
	background-color: #ffffff;
	border: 2px solid #ccc;
}

/* 기본 라디오 버튼 숨기기 */
input[type="radio"] {
    display: none;
}

/* 커스텀 라디오 버튼 만들기 */
input[type="radio"] + label {
    position: relative;
    padding-left: 30px; /* 라디오 버튼 공간 확보 */
    cursor: pointer;
    line-height: 20px; /* 라벨 높이 조정 */
}

/* 커스텀 라디오 버튼 디자인 */
input[type="radio"] + label::before {
    content: "";
    position: absolute;
    left: 0;
    top: 0;
    width: 20px; /* 라디오 버튼 크기 */
    height: 20px; /* 라디오 버튼 크기 */
    border: 1px solid #ccc;
    border-radius: 50%; /* 원형 */
    background-color: #fff;
}

/* 체크된 상태의 커스텀 라디오 버튼 스타일 */
input[type="radio"]:checked + label::before {
    border-color: #FFAB40;
    background-color: #FFAB40;
}

/* 커스텀 라디오 버튼 내부 점 디자인 */
input[type="radio"]:checked + label::after {
    content: "";
    position: absolute;
    left: 7px; /* 내부 점 위치 조정 */
    top: 7px; /* 내부 점 위치 조정 */
    width: 8px; /* 내부 점 크기 */
    height: 8px; /* 내부 점 크기 */
    border-radius: 50%; /* 원형 */
    background-color: white; /* 내부 점 색상 */
}


</style>
<script type="text/javascript">
$(document).ready(function() {
    // "전체" 항목을 기본 선택된 상태로 설정
    $("#statusMenu li.all").addClass("selected");
    
    // 상태 메뉴의 각 버튼 클릭 이벤트
    $("#statusMenu li").on("click", function() {
        // 모든 항목에서 'selected' 클래스 제거
        $("#statusMenu li").removeClass("selected");
        // 클릭된 항목에 'selected' 클래스 추가
        $(this).addClass("selected");
        
		// 선택된 상태 가져옴
		var selectedStatus = $(this).attr("class").split(" ")[0]; // 클래스 첫 번째 항목이 상태
// 		$("#projectListContainer").show();	// 모든 프로젝트 보여줌
		$(".projectWrap").show();	// 모든 프로젝트 보여줌
		
		if (selectedStatus !== "all") {
			$("#projectListContainer > h2").remove();
			// 선택된 상태에 따라 필터링
			$(".projectWrap").each(function() {
				var projectStatus = $(this).attr("class").split(" ")[1]; // 상태 클래스 추출
				
				console.log("Selected Status:", selectedStatus);
				console.log("Project Status:", projectStatus);
				
				if (projectStatus !== selectedStatus) {
					$(this).hide();
				}
			});
		} else {
			location.reload();
		}
		
    });
    
    // 프로젝트 삭제 버튼 클릭 이벤트
    $(".delete").on('click', function() {
        let projectIdx = $(this).siblings("input[name='project_idx']").val();  // 프로젝트 인덱스 추출
        let projectElement = $(this).closest(".projectWrap");  // 삭제할 프로젝트 영역

        if (confirm("프로젝트를 삭제하시겠습니까?")) {
            // AJAX 활용하여 "DeleteProject" 서블릿 요청(파라미터 : project_idx) - POST
            $.ajax({
                type: "POST",
                url: "DeleteProject",
                data: {
                    "project_idx": projectIdx
                },
                dataType: "json",
                success: function(response) {
                    if (response.result) {
                        // 삭제 성공 시 해당 프로젝트 요소 제거
                        projectElement.remove();
                    } else {
                        alert("프로젝트 삭제에 실패하였습니다.");
                    }
                },
                error: function(xhr, status, error) {
                    console.log("Error:", status, error);
                    alert("프로젝트 삭제 요청에 실패하였습니다.");
                }
            });    // ajax 끝
        }
    });
    
    
    // 취소 요청 버튼 클릭 이벤트
    $(".requestDelete").on('click', function() {
    	var projectIdx = $(this).siblings("input[name='project_idx']").val();  // 프로젝트 인덱스 추출
		$("#popupWrap").show();
		$("#overlay").show();
		$("#project_idx").val(projectIdx); // hidden input에 project_idx 값 설정
    });
    
	// 라디오 버튼 클릭 이벤트 처리
	$("input[name='project_cancel_reason']").on("change", function () {
	    if ($("#reason4").is(":checked")) {
			// '기타' 라디오 버튼이 선택되었을 때 textarea 보이기
			$("#textareaWrap").show();
			$("#besides").focus();
	    } else {
	        // 그 외의 경우 textarea 숨기기
			$("#textareaWrap").hide();
			$("#besides").val(''); // 기타 이유 텍스트 초기화
	    }
	});
	
	// 프로젝트 취소 요청 - 취소 요청하기 버튼 클릭 이벤트
    $("#request").click(function() {
        let projectIdx = $("#project_idx").val();
        let selectedReason = $("input[name='project_cancel_reason']:checked").next("label").text();

        if (!$("input[name='project_cancel_reason']:checked").length) {	// 중단 사유 미선택 시
            alert("삭제 사유를 선택해 주세요.");
        } else if ($("#reason4").is(":checked") && !$("#besides").val()) {	// 기타 선택 후 사유 미입력 시 
            alert("삭제 사유를 입력해 주세요.");
        } else {	// 그 외
	        let cancelReason = selectedReason;	// 펀딩 중단 사유
	        if ($("#reason4").is(":checked")) {	// 기타 선택했을 경우
	            cancelReason = $("#besides").val();	// 입력값을 사유로
	        }

	        $.ajax({
	            type: "POST",
	            url: "RequestDeleteProject",
	            data: {
	                "project_idx": projectIdx,
	                "project_cancel_reason": cancelReason
	            },
	            dataType: "json",
	            success: function(response) {
	                if (response.result) {
	                    alert("취소 요청이 되었습니다.\n요청 결과는 이틀 내로 메일로 알려드립니다.");
	                    // 취소 요청 버튼 비활성화
						$(".requestDelete").each(function() {
							if ($(this).siblings("input[name='project_idx']").val() === projectIdx) {
								$(this).prop('disabled', true).addClass('disabled'); // 또는 $(this).addClass('disabled');
							}
						});
	                    
	                    closePopup();
	                } else {
	                    alert("취소 요청에 실패했습니다.22");
	                }
	            },
	            error: function(xhr, status, error) {
	                console.log("Error:", status, error);
	                alert("취소 요청에 실패했습니다.");
	            }
	        });
		}

    });

    // 프로젝트 취소 요청 - 취소 버튼 클릭 이벤트
    $("#cancel").click(function() {
    	closePopup();
    });
	
	// 팝업창 닫기 및 초기화 함수
    function closePopup() {
        $("#textareaWrap").hide();
        $("#popupWrap").hide();
        $("#overlay").hide();
        $("input[name='project_cancel_reason']").prop('checked', false); // 라디오 버튼 선택 해제
        $("#besides").val(''); // 기타 이유 텍스트 초기화
    }
	
	// 프로젝트 취소 요청 - 취소버튼
    $("#cancel").click(function() {
		$("#textareaWrap").hide();
	});
    
    
    
    
});


</script>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<article>
		<div id="topWrap">
			<h4>내가 만든 프로젝트</h4>
			<div id="statusMenu">
				<ul>
					<li class="all">전체</li>
					<li class="writing">작성중</li>
					<li class="review">심사중</li>
					<li class="approve">승인됨</li>
					<li class="refuse">반려됨</li>
<!-- 					<li class="reveal">공개예정</li> -->
<!-- 					<li class="ongoing">진행중</li> -->
<!-- 					<li class="terminate">종료됨</li> -->
				</ul>
			</div>
		</div>
		
		<%-- ---------- 프로젝트 리스트 표시할 영역 ---------- --%>
		<div id="projectListContainer">
        <c:choose>
            <c:when test="${not empty projectList}">
                <%-- '작성중' 상태의 프로젝트 목록 --%>
                <c:forEach var="project" items="${projectList}">
                    <c:if test="${project.project_status eq '작성중'}">
                        <c:if test="${not isWritingDisplayed}">
                            <h2>작성중</h2><br>
                            <c:set var="isWritingDisplayed" value="true" />
                        </c:if>
                        <div class="projectWrap writing">
                            <div class="projectImage">
                                <c:choose>
                                    <c:when test="${empty project.project_image}">
                                        <img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
                                    </c:when>
                                    <c:otherwise>
                                        <img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="projectContent">
                                <h2>${project.project_title}</h2>
                                <p>${project.project_summary}</p>
                            </div>
                            <div class="btnWrap">
	                            <input type="hidden" name="project_idx" value="${project.project_idx}">
								<input type="button" class="management" value="관리" onclick="location.href='ProjectCreate?project_idx=${project.project_idx}'"><br>
	                            <input type="button" class="delete" value="삭제">
                            </div>
                        </div>
                        
                    </c:if>
                </c:forEach>

                <%-- '심사중' 상태의 프로젝트 목록 --%>
                <c:forEach var="project" items="${projectList}">
                    <c:if test="${project.project_status eq '심사중'}">
                        <c:if test="${not isSubmittedDisplayed}">
                            <h2>심사중</h2><br>
                            <c:set var="isSubmittedDisplayed" value="true" />
                        </c:if>
                        <div class="projectWrap review">
                            <div class="projectImage">
                                <c:choose>
                                    <c:when test="${empty project.project_image}">
                                        <img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
                                    </c:when>
                                    <c:otherwise>
                                        <img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="projectContent">
                                <h2>${project.project_title}</h2>
                                <p>${project.project_summary}</p>
                            </div>
                            <div class="btnWrap">
								<input type="hidden" name="project_idx" value="${project.project_idx}">
								<input type="button" class="management" value="관리" onclick="location.href='ProjectCreate?project_idx=${project.project_idx}'"><br>
								<input type="button" class="requestDelete" data-project-idx="${project.project_idx}" value="취소 요청" <c:if test="${fn:contains(cancelList, project.project_idx)}">disabled</c:if>>
                            </div>
                        </div>
                        
                    </c:if>
                </c:forEach>

                <%-- '승인됨' 상태의 프로젝트 목록 --%>
                <c:forEach var="project" items="${projectList}">
                    <c:if test="${project.project_status eq '승인'}">
                        <c:if test="${not isApprovedDisplayed}">
                            <h2>승인됨</h2><br>
                            <c:set var="isApprovedDisplayed" value="true" />
                        </c:if>
						                        
                        <div class="projectWrap approve">
                            <div class="projectImage">
                                <c:choose>
                                    <c:when test="${empty project.project_image}">
                                        <img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
                                    </c:when>
                                    <c:otherwise>
                                        <img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
	                        <%-- 현재 날짜를 설정 --%>
							<%
							    // 서버 측에서 현재 날짜와 시간을 가져옵니다.
							    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
							    String currentDate = sdf.format(new java.util.Date());
							    // 현재 날짜를 request 속성에 설정하여 EL에서 사용할 수 있도록 합니다.
							    request.setAttribute("currentDate", currentDate);
							%>
                            <div class="projectContent">
                            	<span style="padding: 3px 7px; background-color: #FFAB40; color: #fff; border-radius: 3px; line-height: 250%;">	<!-- 프로젝트 시작일, 종료일에 따라 공개예정, 진행중, 종료됨 구분 -->
                            		<c:choose>
								        <c:when test="${project.funding_start_date > currentDate}">공개예정</c:when>
								        <c:when test="${project.funding_start_date <= currentDate && project.funding_end_date >= currentDate}">진행중</c:when>
								        <c:when test="${project.funding_end_date < currentDate}">종료됨</c:when>
								    </c:choose>
                            	</span>
                                <h2>${project.project_title}</h2>
                                <p>${project.project_summary}</p>
                            </div>
                            <div class="btnWrap">
                                <input type="hidden" name="project_idx" value="${project.project_idx}">
                                <input type="button" class="management" value="관리" onclick="location.href='ProjectCreate?project_idx=${project.project_idx}'"><br>
                                <!-- 아직 진행중이지 않은 프로젝트만 삭제요청 가능 -->
                                <c:if test="${project.funding_start_date > currentDate}">
                                	<input type="button" class="requestDelete" data-project-idx="${project.project_idx}" value="취소 요청" <c:if test="${fn:contains(cancelList, project.project_idx)}">disabled</c:if>>
                                </c:if>
                            </div>
                        </div>
                        
                    </c:if>
                </c:forEach>

                <%-- '반려됨' 상태의 프로젝트 목록 --%>
                <c:forEach var="project" items="${projectList}">
                    <c:if test="${project.project_status eq '반려'}">
                        <c:if test="${not isRefusedDisplayed}">
                            <h2>반려됨</h2><br>
                            <c:set var="isRefusedDisplayed" value="true" />
                        </c:if>
                        <div class="projectWrap refuse">
                            <div class="projectImage">
                                <c:choose>
                                    <c:when test="${empty project.project_image}">
                                        <img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
                                    </c:when>
                                    <c:otherwise>
                                        <img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="projectContent">
                                <h2>${project.project_title}</h2>
                                <p>${project.project_summary}</p>
                            </div>
                            <div class="btnWrap">
	                            <input type="hidden" name="project_idx" value="${project.project_idx}">
	                            <input type="button" class="management" value="관리" onclick="location.href='ProjectCreate?project_idx=${project.project_idx}'"><br>
                            </div>
                        </div>
                        
                    </c:if>
                </c:forEach>

                
            </c:when>
            <c:otherwise>
				<div class="emptyProjectListWrap">
	                <br><br><br><br><br><br>
					<div id="projectStartImg">
						<img alt="프로젝트 만들기" src="${pageContext.request.contextPath}/resources/image/write_icon.png">
					</div>
					<div>
						<h2>작성한 프로젝트가 없습니다.</h2>
						<input type="button" id="projectStart" class="projectStartButton" value="프로젝트 만들기" onclick="location.href='ProjectStart'">
					</div>
					<br><br><br><br><br><br>
				</div>
            </c:otherwise>
        </c:choose>
    </div>
</article>

	<%-- ---------- 프로젝트 취소 요청 팝업창 ---------- --%>
	<div id="popupWrap">
		<div id="popupTop">
			<h2>프로젝트 취소 요청</h2>
			<p style="margin-left: 8px;">
				프로젝트를 정말 취소하시나요?<br>
				펀딩 중단 사유를 선택해주세요.<br>
				제출 시 위드미 담당자에게 프로젝트 삭제를 요청합니다.
			</p>
		</div>
		<br>
		<div id="popupContent">
			<%-- ----- 취소 사유 선택란 ----- --%>
			<input type="radio" name="project_cancel_reason" id="reason1">
			<label for="reason1">계획한 일정대로 진행이 어려움 (원재료 수급 문제 등)</label><br>
			<input type="radio" name="project_cancel_reason" id="reason2">
			<label for="reason2">펀딩 성과가 예상보다 저조함</label><br>
			<input type="radio" name="project_cancel_reason" id="reason3">
			<label for="reason3">프로젝트 또는 후원과 관련한 중요한 설정을 잘못 등록함</label><br>
			<input type="radio" name="project_cancel_reason" id="reason4">
			<label for="reason4">기타</label><br>
			<div id="textareaWrap" style="display: none;">
				<textarea rows="3" cols="20" name="reason4" id="besides" placeholder="펀딩 중단 사유를 입력해주세요."></textarea>
			</div>
			
			<input type="hidden" id="project_idx" name="project_idx">
			<input type="button" id="request" value="취소 요청하기">
			<input type="button" id="cancel" value="취소">
		</div>

	</div>

	<%-- 팝업 배경 (click 시 팝업 닫기) --%>
	<div id="overlay" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 9998;"></div>
	
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
