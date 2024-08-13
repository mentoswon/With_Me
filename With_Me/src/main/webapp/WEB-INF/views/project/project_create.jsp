<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 프로젝트 등록</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/project_create.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
$(function() {
	let tagContainer = $("#tagContainer");
    let tagCount = $("#tagCount");
    let maxTags = 5; // 최대 태그 수

	// 정규 표현식(한글 또는 숫자만 허용)
	let regexTag = /^[가-힣0-9]*$/;
	let checkTagResult = false;	// 입력값 검증 결과를 저장할 변수(true : 적합, false : 부적합)
    
    // 프로젝트 심사 기준 팝업창 버튼 클릭 시 닫힘
    $("#agree").click(function() {
        $("#popupWrap").hide();
    });

    // 메뉴 항목 클릭 시 활성화 처리
    $("#projectMenuList li").click(function() {
        $("#projectMenuList li").removeClass("active");
        $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
    });
	
    // 세부 카테고리 조회
	$("#project_category").change(function() {
		let project_category = $("#project_category").val();
		if (project_category) {
		    $.ajax({
		        type: "POST",
		        url: "GetCategoryDetail",
		        data: {
		        	"project_category" : project_category
		        },
		        dataType : "json",
		        success: function(response) {
		            // 기존 세부 카테고리 옵션 지움
		            $("#project_category_detail").empty();
					$("#project_category_detail").append("<option disabled selected hidden>세부 카테고리를 선택하세요.</option>");
		            
		            $.each(response, function(index, item) {
		            	$("#project_category_detail").append("<option value='" + item.common_code_name + "'>" + item.common_code_name + "</option>");
		            });
		        },
		        error: function() {
		            alert("세부 카테고리를 불러오는 데 실패했습니다.");
		        }
		    });
		} else {
			$("#project_category_detail").empty().append("<option disabled selected hidden>세부 카테고리를 선택하세요.</option>");
		}
	});
    
    
    // 제목 길이 체크
    function checkTitleLength() {
        let titleLength = $("#project_title").val().length;
        $("#titleLength").text(titleLength);
        if (titleLength < 10) { // 글자수가 10자 미만인 경우
            $("#checkLengthTitle").text("10자 이상 입력해주세요.");
            $("#checkLengthTitle").css("color", "red");
        } else if (titleLength > 30) { // 글자수가 30자 초과한 경우
            alert("프로젝트 제목은 30자 까지만 입력 가능합니다!");
        } else {
            $("#checkLengthTitle").text(""); // 메시지 제거
        }
    }

    // 요약 길이 체크
    function checkSummaryLength() {
        let summaryLength = $("#project_summary").val().length;
        $("#summaryLength").text(summaryLength);
        if (summaryLength < 10) { // 글자수가 10자 미만인 경우
            $("#checkLengthSummary").text("10자 이상 입력해주세요.");
            $("#checkLengthSummary").css("color", "red");
        } else if (summaryLength > 50) {
            alert("프로젝트 요약은 50자 까지만 입력 가능합니다!");
        } else {
            $("#checkLengthSummary").text(""); // 메시지 제거
        }
    }

    // 페이지 로드 시 제목과 요약 길이 표시(메세지는 숨기기)
    checkTitleLength();
    checkSummaryLength();
    $("#checkLengthTitle").text("");
    $("#checkLengthSummary").text("");

    // 프로젝트 제목 글자 수 체크
    $("#project_title").keyup(function() {
        checkTitleLength();
    });

    // 프로젝트 요약 글자 수 체크
    $("#project_summary").keyup(function() {
        checkSummaryLength();
    });
    
    // 검색 태그 입력값 유효성 검사
    $("#search_tag").keyup(function() {
    	 let tagValue = $("#search_tag").val();  // 입력된 태그 값을 가져옴
        if (!regexTag.exec(tagValue)) {  // 불일치
        	$("#checkTagResult").html("한글, 숫자로만 입력 가능합니다!<br>공백, 특수문자 불가");
        	$("#checkTagResult").css("color", "red");
        	checkTagResult = false;
        } else {	// 일치
        	$("#checkTagResult").html("문자로만 최소 1자 이상 입력해주세요.");
        	$("#checkTagResult").css("color", "#ccc");
        	checkTagResult = true;
        }
    });
    
    // 검색 태그 Enter(SpaceBar) 누름 이벤트
    $("#search_tag").on("keypress", function(event) {
    	let keyCode = event.keyCode;
		if(keyCode == 13 || keyCode == 32) {	// Enter(13) 또는 SpaceBar(32) 누를 시
            event.preventDefault(); // 폼 제출 방지
            let tagValue = $(this).val().trim();	// 입력된 태그 값을 가져와서 공백 제거
            if (checkTagResult) {	// 검색태그 검사 적합여부 true
            	if (tagValue && tagContainer.children().length < maxTags) {    // 유효한 태그와 태그 개수가 최대 개수보다 적은 경우
                    // 새로운 태그 추가
                    tagContainer.append("<span class='tag'>" + tagValue + "<span class='removeTag'><img src='${pageContext.request.servletContext.contextPath}/resources/image/removeTag.png'></span></span>");
                    // 태그 카운트 업데이트
                    updateTagCount();
                    // 입력 필드 비우기
                    $(this).val("");
                    
                } else if (tagContainer.children().length >= maxTags) {
                    alert("태그는 최대 " + maxTags + "개까지만 추가할 수 있습니다.");
                }
			}
    	}
	});
    
	// 태그 삭제 이벤트
    tagContainer.on("click", ".removeTag", function() {
        $(this).parent().remove(); // 현재 태그 요소를 삭제
        updateTagCount(); // 태그 개수 업데이트
    });

    // 태그 개수 업데이트 함수
    function updateTagCount() {
        let currentTagCount = tagContainer.children().length;
        tagCount.text(currentTagCount);
    }
    
    
});	// ready 이벤트 끝

</script>
</head>
<body>
	<%-- ---------- 프로젝트 등록 페이지 헤더 ---------- --%>
	<header>
		<div id="topWrap">
			<a href="#">← 내가 만든 프로젝트</a>
			<a href="./" class="main_logo">
				<img alt="로고" src="${pageContext.request.contextPath}/resources/image/withme.png">
			</a>
			<div>
				<input type="button" id="save" value="저장하기">
				<input type="submit" id="request" value="심사요청" disabled>
			</div>
		</div>
	</header>
	
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<section id="projectInfo">
		<div id="projectInfoWrap">
			<div id="projectMenuTop">
				<img alt="로고" src="${pageContext.request.contextPath}/resources/image/image.png">
				<div>
					<h2>${project.project_title}</h2>
					<p style="line-height: 200%;">${project.project_category}</p>
				</div>
			</div>
		</div>
	</section>
	<section id="projectCreateMenu">
		<div id="projectMenuWrap">
			<div id="projectMenu">
				<ul id="projectMenuList">
					<li class="writeList active">
						<span>기본 정보</span>
					</li>
					<li class="writeList">
						<span>펀딩 계획</span>
					</li>
					<li class="writeList">
						<span>후원 구성</span>
					</li>
					<li class="writeList">
						<span>프로젝트 계획</span>
					</li>
					<li class="writeList">
						<span>창작자 정보</span>
					</li>
				</ul>
			</div>
		</div>
	</section>
	
	<article>
		<div>
			<br>
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 카테고리<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트 성격과 가장 일치하는 카테고리를 선택해주세요.<br>
						적합하지 않을 경우 운영자에 의해 조정될 수 있습니다.
					</p>
				</div>
				<div class="projectContentWrap">
					<select id="project_category" class="select" name="project_category">
						<c:forEach var="category" items="${category}">
							<option value="${category.common_code_name}" <c:if test="${project.project_category eq category.common_code_name}">selected</c:if>>${category.common_code_name}</option>
						</c:forEach>
					</select>
					<br><br>
					<select id="project_category_detail" class="select" name="project_category_detail">
						<option disabled selected hidden>세부 카테고리를 선택하세요.</option>
						<c:forEach var="categoryDetail" items="${category_detail}">
							<option value="${categoryDetail.common_code_name}">${categoryDetail.common_code_name}</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<hr class="dividingLine">

			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 제목<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트의 주제, 창작물의 품목이 명확하게 드러나는 멋진 제목을 붙여주세요.
					</p>
				</div>
				<div class="projectContentWrap">
					<input type="text" name="project_title" id="project_title" placeholder="제목을 입력해주세요." value="${project.project_title}">
					<div class="LengthCheck">
						<span id="checkLengthTitle"></span>
						<p><span id="titleLength">0</span>/30</p>
					</div>
					<br><br>
				</div>
			</div>
			<hr class="dividingLine">
			
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 요약<span class="essential">&nbsp;*</span></h3>
					<p>
						후원자 분들이 프로젝트를 빠르게 이해할 수 있도록 명확하고 간략하게 소개해주세요.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">프로젝트 요약은 어디에 표시되나요?</p>
						<p>프로젝트 카드형 목록에서 프로젝트 제목 하단에 표시됩니다.</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<textarea name="project_summary" id="project_summary" rows="5" cols="10" placeholder="프로젝트 요약을 입력해주세요." maxlength="50"></textarea>
					<div class="LengthCheck">
						<span id="checkLengthSummary"></span>
						<p><span id="summaryLength">0</span>/50</p>
					</div>
					<br><br>
				</div>
			</div>
			<hr class="dividingLine">
			
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 대표 이미지<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트를 나타낼 이미지를 등록해 주세요.
					</p>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_image" id="project_image">
					<label for="project_image">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								이미지 업로드
							</span>
						</div>
					</label>
					<br><br>
				</div>
			</div>
			<hr class="dividingLine">
			
			
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>검색 태그</h3>
					<p>
						잠재 후원자의 관심사를 고려한 검색 태그를 입력해주세요.<br>
						위드미에서 해당 태그로 검색한 후원자가 프로젝트를 발견할 수 있습니다.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">무관한 태그는 후원자의 불편을 초래합니다!</p>
						<p>
							반드시 프로젝트에 관련된 태그만 사용해 주세요. 
							프로젝트와 무관한 태그 설적으로 후원자 신고가 누적될 시 프로젝트에 재재가 가해질 수 있습니다.
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<input type="text" name="search_tag" id="search_tag" placeholder="Enter를 눌러 핵심 키워드를 등록해주세요.">
					<div class="LengthCheck">
						<span id="checkTagResult" style="color: #ccc; font-size: 13px;">문자로만 최소 1자 이상 입력해주세요.</span>
						<p><span id="tagCount">0</span>/5개</p>
					</div>
					<div class="tag-container" id="tagContainer">
		                <!-- 태그가 여기에 추가됨 -->
		            </div>
					<br><br>
				</div>
			</div>
			
		</div>
		
	</article>
	
	<%-- ---------- 프로젝트 심사 기준 확인 팝업창 ---------- --%>
	<div id="popupWrap">
		<div id="popupTop">
			<h2>위드미의 프로젝트 심사 기준을 확인해주세요.</h2>
			<p>심사 기준을 준수하면 보다 빠른 프로젝트 승인이 가능합니다.</p>
		</div>
		<div id="popupContent">
			<%-- ----- 승인 가능 프로젝트 ----- --%>
			<div id="grantProject">
				<div class="icon grant">✓</div>
				<h4 align="center"><br>승인 가능 프로젝트</h4>
				<br>
				<p>- 기존에 없던 새로운 시도</p>
				<p>- 기존에 없던 작품, 제품</p>
				<p>- 창작자의 이전 제품 및 콘텐츠는 후원에서 부수적으로 제공 가능</p>
			</div>
			<%-- ----- 반려 대상 프로젝트 ----- --%>
			<div id="returnProject">
				<div class="icon return">X</div>
				<h4 align="center"><br>반려 대상 프로젝트</h4>
				<br>
				<p>- 기존 상품의 판매 및 홍보</p>
				<p>- 제3자에 후원금 또는 물품 기부</p>
				<p>- 시중에 판매 및 유통되었던 제품 제공</p>
				<p>- 현금, 주식, 지분, 복권, 사이버머니, 상품권 등 수익성 상품 제공</p>
				<p>- 추첨을 통해서만 제공되는 선물</p>
				<p>- 무기, 군용장비, 라이터 등 위험 품목</p>
			</div>
		</div>
		<div align="center">
			<input type="button" id="agree" value="확인했어요.">
		</div>
	</div>
	
<!-- 	<footer> -->
<%-- 		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include> --%>
<!-- 	</footer> -->
</body>
</html>
