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
	// [ 기본 정보 ]
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
        $(".writeContainer").hide();	// 모든 .writeContainer 숨기기
        $("#projectMenuList li").removeClass("active");
        $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
        let index = $(this).data("index");	// 클릭된 메뉴 항목의 인덱스
        $("#writeContainer" + index).show();	// 해당 인덱스에 해당하는 콘텐츠 영역만 보이기
    });
	
	// 초기 상태로 첫 번째 메뉴와 콘텐츠가 보이도록 설정
//     $("#projectMenuList li:eq(0)").click();
	// -------------------------------------------------------------------------------
	// 임시) 초기 상태로 세 번째 메뉴와 콘텐츠가 보이도록 설정
    $("#projectMenuList li:eq(2)").click();
	// -------------------------------------------------------------------------------
    
    // 카테고리 변경 시 AJAX 요청 전송(세부카테고리 불러오기)
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
    
    // 프로젝트 대표 이미지 미리보기
	$("#project_image").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_image_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
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
    
    // ========================================================================================
    // [ 펀딩 계획 ]
	// 수수료 비율 정의
    const PAYMENT_FEE_RATE = 0.03; // 결제대행 수수료 3%
    const PLATFORM_FEE_RATE = 0.05; // 위드미 수수료 5%
    const VAT_RATE = 0.1; // 부가세 10%

    // 목표금액 입력 시 이벤트 처리
    $("#target_price").on("input", function(event) {
        let value = $(this).val();

        // 숫자만 남기기
        value = value.replace(/[^0-9]/g, "");

        // 숫자 포맷팅
        if (value) {
            value = parseInt(value, 10).toLocaleString("ko-KR");	// 세자리 마다 콤마(,) 붙여줌
        }
        $(this).val(value);

        // 50만원 이상인지 체크
        let numericValue = parseInt(value.replace(/,/g, ""), 10) || 0;
        if (numericValue < 500000) {
            $("#checkTargetPrice").text("50만원 이상의 금액을 입력해주세요.");
            $("#checkTargetPrice").css("color", "red");
        } else if (numericValue > 9999999999) {
            $("#checkTargetPrice").text("9,999,999,999원 이하의 금액을 입력해주세요.");
            $("#checkTargetPrice").css("color", "red");
		} else {
            $("#checkTargetPrice").text("");
        }
		calculateEstimateAmounts(numericValue);
    });

    // 수수료 및 예상 수령액 계산
    function calculateEstimateAmounts(targetPrice) {
        // 결제대행 수수료 계산
        let paymentFee = Math.floor(targetPrice * PAYMENT_FEE_RATE);
        let paymentVAT = Math.floor(paymentFee * VAT_RATE);
        let totalPaymentFee = paymentFee + paymentVAT;

        // 위드미 수수료 계산
        let platformFee = Math.floor(targetPrice * PLATFORM_FEE_RATE);
        let platformVAT = Math.floor(platformFee * VAT_RATE);
        let totalPlatformFee = platformFee + platformVAT;

        // 총 수수료
        let totalCommission = totalPaymentFee + totalPlatformFee;

        // 예상 수령액
        let estimateAmount = targetPrice - totalCommission;

        // 계산된 금액 표시
        $("#createCommission").text(totalPaymentFee.toLocaleString('ko-KR'));
        $("#withmeCommission").text(totalPlatformFee.toLocaleString('ko-KR'));
        $("#totalCommission").text(totalCommission.toLocaleString('ko-KR'));
        $("#estimateAmount").text(estimateAmount.toLocaleString('ko-KR'));
    }

    // 예상 수령액 초기화
    function resetEstimateAmounts() {
        $("#createCommission").text("0");
        $("#withmeCommission").text("0");
        $("#totalCommission").text("0");
        $("#estimateAmount").text("0");
    }

    // 숫자 입력만 허용하는 keypress 이벤트
    $("#target_price").on("keypress", function(event) {
    	let keyCode = event.keyCode;
        if (keyCode < 48 || keyCode > 57) {
            event.preventDefault();
        }
    });
    
    // ========================================================================================
    // [ 후원 구성 ]
    // 아이템 이름 글자 수
    $("#item_name").keyup(function() {
    	let itemNameLength = $("#item_name").val().length;
        $("#itemNameLength").text(itemNameLength);
    });
    
	// 옵션조건 선택 이벤트
	// 처음에는 두 영역 모두 숨김
    $('#subjectiveWrap').hide();
    $('#objectiveWrap').hide();
	$("input[name='item_condition']").on("change", function() {
        // 옵션조건 관련 레이블 제거
        $("label").removeClass("selected");
        $("label[for='none'], label[for='subjective'], label[for='objective']").removeClass("selected");
        // 체크된 라디오 버튼의 for 속성과 일치하는 라벨에 selected 클래스 추가
        $("label[for='" + $(this).attr("id") + "']").addClass("selected");
        // 선택된 라디오 버튼의 값을 가져옴
        let selectedValue = $(this).val();
		// input 초기화
        $('#subjectiveWrap input').val('');
        $('#objectiveWrap input[type="text"]').val('');
        $('#objectiveWrap input[type="text"]').slice(2).remove(); // 처음 2개 외의 input 제거

        if (selectedValue == "주관식") {	// 주관식 선택 시
            $("#subjectiveWrap").show();
            $("#objectiveWrap").hide();
        } else if (selectedValue == "객관식") {	// 객관식 선택 시
            $("#subjectiveWrap").hide();
            $("#objectiveWrap").show();
        } else {	// 없음 선택 시
            $("#subjectiveWrap").hide();
            $("#objectiveWrap").hide();
        }
    });
	
	// '+' 버튼 클릭 시 새로운 input 필드 추가 (최대 15개까지)
    $("#addOption").on("click", function() {
    	let inputCount = $("#objectiveWrap input[type='text']").length;
    	if (inputCount < 15) { // 현재 input 개수가 15개 미만일 때만 추가
	        let newInput = $("<input type='text' name='item_option_name' class='itemText'>");
	        $("#objectiveWrap").append(newInput);	// objectiveWrap의 마지막 input 요소 뒤에 새 input 요소 추가
	        newInput.focus();	// 새로운 input 필드에 포커스 이동
    	} else {
            alert("옵션 항목은 최대 15개까지 추가할 수 있습니다.");
        }
    });
    
	// 등록 버튼 클릭 시 AJAX 요청 전송(아이템 등록 및 리스트 조회)
    $("#itemRegist").on("click", function(event) {
        if ($("#item_name").val().trim() === "") {
	    	event.preventDefault(); // 기본 폼 제출 동작 방지(if 문 바깥에 있으니까 success시 폼 리셋이 안되더라..)
        	alert("아이템 이름을 입력해주세요!");
        } else if (!$("input[name='item_condition']:checked").val()) {
	    	event.preventDefault(); // 기본 폼 제출 동작 방지
        	alert("옵션 조건을 선택해주세요!");
		} else {
	        $.ajax({
	            type: "POST",
	            url: "RegistItem",
	            data : {
	            	project_idx : $("input[name='project_idx']").val(), 
	            	item_name : $("#item_name").val(), 
	            	item_condition : $("input[name='item_condition']:checked").val(), 
	            	// 모든 .itemText의 값을 배열로 수집하고 |로 연결
	                multiple_option: $(".itemText").map(function() {
			            if ($(this).val().trim() !== "") {  // 빈 값이 아닌 경우만 포함
			                return $(this).val();
			            }
	                }).get().join('|') // 값들을 |로 연결하여 문자열로 변환
				},
				dataType : "json",
	            success: function(response) {
	                // 받은 응답 데이터로 리스트를 업데이트
	                updateItemList(response);
	                // 폼 리셋
	                $("#registItemForm")[0].reset();
	            },
	            error: function() {
	                alert("아이템 등록에 실패하였습니다.");
	            }
	        });	// ajax 끝
		}
	});
	
	// 아이템 리스트 출력
    function updateItemList(itemList) {
		// 기존 리스트 초기화
        $("#itemListContainer").empty();
        $("#chooseItemContainer").empty();

        // 서버로부터 받은 아이템 리스트를 사용하여 새로운 리스트 생성
        itemList.forEach(function(item) {
			let listItem =  
            	`<div class="itemListWrap">
	            	<div class="itemList">
						<h4>${item.item_name}</h4>
						<p>
							<b>옵션조건(${item.item_condition})</b><br>
							${item.multiple_option}
						</p>
						<br>
					</div>
					<div class="trashImg" data-item-idx="${item.item_idx}">
						<img alt="휴지통아이콘" src="${pageContext.request.contextPath}/resources/image/trash_icon.png">
					</div>
				</div>`;
			
			$("#itemListContainer").append(listItem);
			$("#chooseItemContainer").append('<input type="checkbox" name="reward_item_idx" value="${item.item_name}">');
        });
    }
    
	// 아이템 삭제 이벤트
	$(document).on("click", ".trashImg", function() {
	    let item_idx = $(this).data("item-idx");  // 클릭된 아이콘의 item_idx 추출
	
	    if (confirm("정말로 삭제하시겠습니까?")) {
	    	// AJAX 활용하여 "DeleteItem" 서블릿 요청(파라미터 : item_idx) - POST
	    	$.ajax({
	            type: "POST",
	            url: "DeleteItem",  // 서버의 삭제 처리 URL
	            data: {
	            	"item_idx" : item_idx
	            },
	            dataType: "json",
	            success: function(response) {
	            	console.log(JSON.stringify(response));
					if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
						alert("잘못된 접근입니다!");
					} else if(!response.result) { // 댓글 삭제 실패일 경우
	                    alert("아이템 삭제에 실패하였습니다.");
					} else if(response.result) { // 댓글 삭제 성공일 경우
// 						location.reload(); // 현재 페이지 갱신
// 						$(`div[data-item-idx="${item_idx}"]`).closest(".itemListWrap").remove();
	                	// 콘솔 로그 추가: 삭제 시도
	                    console.log("item_index : ", item_idx);	// ------ 이건 뜨는데
	
	                    // 삭제 성공 시 해당 아이템 UI에서 제거
            	        let itemToRemove = $(`div[data-item-idx="${item_idx}"]`).closest(".itemListWrap");
	                    console.log("Item to remove : ", itemToRemove);	// 삭제할 요소 로그
	                    // ------ Item to remove: ce.fn.init {length: 0, prevObject: ce.fn.init}
						// ------ length 가 안뜸 ㅎㅎㅎㅎㅎ
	                    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	                    // 아이템 삭제는 되는데 UI에서 remove() 안되는 문제
						// location.reload(); 하면 되긴 하는데 갱신 안하고 지우고싶다.. 
	                    // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	                    itemToRemove.remove(); // 요소 제거
	                }
	            },
	            error: function() {
	                alert("아이템 삭제 요청에 실패하였습니다.");
	            }
	        });	// ajax 끝
	    }
	});
	
	// 구성 설명 글자 수(후원 제목)
    $("#reward_title").keyup(function() {
    	let rewardTitleLength = $("#reward_title").val().length;
        $("#rewardTitleLength").text(rewardTitleLength);
    });
    
	// 수량제한 선택 이벤트
	$("input[name='amount_limit']").on("change", function() {
		$("label[for='amountLimit_Y'], label[for='amountLimit_N']").removeClass("selected");
	    $("label[for='" + $(this).attr("id") + "']").addClass("selected");
	    let selectedValue = $(this).val();
	 });	
	
	// 배송여부 선택 이벤트
	$("input[name='delivery_status']").on("change", function() {
	    $("label[for='deliveryStatus_Y'], label[for='deliveryStatus_N']").removeClass("selected");
        $("label[for='" + $(this).attr("id") + "']").addClass("selected");
        let selectedValue = $(this).val();
	 });	
	
	// 후원 금액 입력 이벤트
    $("#reward_price").on("input", function(event) {
        let value = $(this).val();
        // 숫자만 남기기
        value = value.replace(/[^0-9]/g, "");
        // 숫자 포맷팅
        if (value) {
            value = parseInt(value, 10).toLocaleString("ko-KR");	// 세자리 마다 콤마(,) 붙여줌
        }
        $(this).val(value);

        // 1000원 이상인지 체크
        let numericValue = parseInt(value.replace(/,/g, ""), 10) || 0;
        if (numericValue < 1000) {
            $("#checkRewardPrice").text("1000원 이상의 금액을 입력해주세요.");
            $("#checkRewardPrice").css("color", "red");
        } else if (numericValue > 10000000) {
            $("#checkRewardPrice").text("10,000,000원 이하의 금액을 입력해주세요.");
            $("#checkRewardPrice").css("color", "red");
		} else {
            $("#checkRewardPrice").text("");
        }
    });

    // 숫자 입력만 허용하는 keypress 이벤트
    $("#reward_price").on("keypress", function(event) {
    	let keyCode = event.keyCode;
        if (keyCode < 48 || keyCode > 57) {
            event.preventDefault();
        }
    });
	
    // ========================================================================================
    // [ 프로젝트 계획 ]
	// 프로젝트 소개 미리보기
	$("#project_introduce").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_introduce_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});

	// 프로젝트 예산 미리보기
	$("#project_budget").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_budget_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});

	// 프로젝트 일정 미리보기
	$("#project_schedule").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_schedule_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});

	// 프로젝트 팀 소개 미리보기
	$("#project_team_introduce").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_team_introduce_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});

	// 후원 설명 미리보기
	$("#project_sponsor").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#project_sponsor_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});

    // 프로젝트 정책 글자 수
    $("#project_policy").keyup(function() {
    	let projectPolicyLength = $("#project_policy").val().length;
        $("#projectPolicyLength").text(projectPolicyLength);
    });
    
    
    // ========================================================================================
    // [ 창작자 정보 ]
	// 창작자 이름 길이 체크
    function checkCreatorName() {
        let nameLength = $("#creator_name").val().length;
        $("#nameLength").text(nameLength);
        if (nameLength > 20) {
            alert("창작자 이름은 20자 까지만 입력 가능합니다!");
            $("#checkCreatorName").css("color", "red");
        } else {
            $("#checkCreatorName").text(""); // 메시지 제거
        }
    }
    
    // 창작자 이름 글자 수 체크
    $("#creator_name").keyup(function() {
    	checkCreatorName();
    });
    
	// 프로필 이미지 미리보기
	$("#creator_image").on("change", function(event) {
	    let file = event.target.files[0];
	    let reader = new FileReader(); 
	    reader.onload = function(e) {
	        $("#creator_image_preview").attr("src", e.target.result);
	    }
	    reader.readAsDataURL(file);
	});
    
	// 창작자 소개 길이 체크
    function checkCreatorIntroduce() {
        let introduceLength = $("#creator_introduce").val().length;
        $("#introduceLength").text(introduceLength);
        if (introduceLength > 300) {
            alert("창작자 소개는 300자 까지만 입력 가능합니다!");
            $("#checkCreatorIntroduce").css("color", "red");
        } else {
            $("#checkCreatorIntroduce").text(""); // 메시지 제거
        }
    }
    
    // 창작자 소개 글자 수 체크
    $("#creator_introduce").keyup(function() {
    	checkCreatorIntroduce();
    });
    
    // -----------------------------------------------
    // 본인인증(cool sms)
    
    
});	// ready 이벤트 끝

// 입금 계좌 등록
function linkAccount() {
	// 새 창을 열어서 사용자 인증 서비스 요청
	// => 금융결제원 오픈API - 2.1.1. 사용자인증 API (3-legged) 서비스
	// ----------------------------------------------------------------
	// 빈 창으로 새 창 띄운 후 해당 창에 사용자 인증 페이지 표시
	let authWindow = window.open("about:blank", "authWindow", "width=500,height=700");
	authWindow.location = "https://testapi.openbanking.or.kr/oauth/2.0/authorize?"
							+ "response_type=code"
							+ "&client_id=4066d795-aa6e-4720-9383-931d1f60d1a9"
							+ "&redirect_uri=http://localhost:8081/mvc_board/callback"
							+ "&scope=login inquiry transfer"
							+ "&state=12345678901234567890123456789012"
								+ "&auth_type=0";
}

</script>
</head>
<body>
	<%-- ---------- 프로젝트 등록 페이지 헤더 ---------- --%>
	<header>
		<div id="topWrap">
			<a href="#">← 내가 만든 프로젝트</a>
			<a href="./" class="main_logo">
				<c:choose>
					<c:when test="${empty project.project_image}">
						<img alt="기본 이미지" src="${pageContext.request.contextPath}/resources/image/withme.png">
					</c:when>
					<c:otherwise>
						<img alt="프로젝트 대표 이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
					</c:otherwise>
				</c:choose>
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
					<li class="writeList active" data-index="1">
						<span>기본 정보</span>
					</li>
					<li class="writeList" data-index="2">
						<span>펀딩 계획</span>
					</li>
					<li class="writeList" data-index="3">
						<span>후원 구성</span>
					</li>
					<li class="writeList" data-index="4">
						<span>프로젝트 계획</span>
					</li>
					<li class="writeList" data-index="5">
						<span>창작자 정보</span>
					</li>
				</ul>
			</div>
		</div>
	</section>
	
	<article>
		<%-- ---------- 기본 정보 ---------- --%>
		<div id="writeContainer1" class="writeContainer">
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
					<input type="text" name="project_title" id="project_title" placeholder="제목을 입력해주세요." value="${project.project_title}" maxlength="30">
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
					<div class="imagePreview">
						<img id="project_image_preview">
					</div>
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
		
		<%-- ---------- 펀딩 계획 ---------- --%>
		<div id="writeContainer2" class="writeContainer">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>목표 금액<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트를 완수하기 위해 필요한 금액을 설정해주세요.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">목표금액 설정 시 꼭 알아두세요!</p>
						<p>
							1. 종료일까지 목표금액을 달성하지 못하면 후원자 결제가 진행되지 않습니다.<br>
							2. 후원 취소 및 결제 누락을 대비해 10% 이상 초과 달성을 목표로 해주세요.<br>
							3. 제작비, 선물 배송비, 인건비, 예비 비용 등을 함께 고려해주세요 .<br>
							4. 목표금액은 50만원 이상 1억 미만으로 설정해 주세요.<br>
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<div class="projectWriteBorder">
						<h4>목표금액</h4>
						<table style="border: 1px solid #ccc; width: 100%;">
							<tr>
								<td>
									<input type="text" name="target_price" id="target_price" placeholder="50만원 이상의 금액을 입력하세요." maxlength="14" style="border: none; text-align: right; width: 565px;">
								</td>
								<td style="text-align: center; padding-bottom: 2px;" width="40px">원</td>
							</tr>
						</table>
						<span id="checkTargetPrice"></span>
						
						
						<div id="estimateAmountWrap">
							<div class="amountArea">
								<h4>목표금액 달성 시 예상 수령액</h4>
								<h3 class="fontModify"><span id="estimateAmount">0</span>원</h3>
							</div>
							<hr class="dividingLine2">
							<div class="amountArea">
								<p>총 수수료</p>
								<span><span id="totalCommission">0</span>원</span>
								<input type="hidden" name="funding_commission" id="funding_commission">	<%-- 수수료 --%>
							</div>
							<div class="amountArea">
								<p>결제대행 수수료 (총 결제 성공금액의 3% + VAT)</p>
								<span><span id="createCommission">0</span>원</span>
							</div>
							<div class="amountArea">
								<p>위드미 수수료 (총 결제 성공금액의 5% + VAT)</p>
								<span><span id="withmeCommission">0</span>원</span>
							</div>
						</div>
					</div>
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>펀딩 일정<span class="essential">&nbsp;*</span></h3>
					<p>
						설정한 날짜가 되면 펀딩이 자동 시작됩니다.<br>
						펀딩 시작 전까지 날짜를 변경할 수 있습니다.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">펀딩기간 설정 시 꼭 알아두세요!</p>
						<p>
							선택하신 시작일 9시에 펀딩이 시작됩니다.<br>
							선택하신 종료일 다음 날 0시에 펀딩이 종료됩니다.<br>
							프로젝트가 성공하면 펀딩 종료 다음 날 후원금이 결제됩니다.<br>
							결제가 이루어지지 않은 경우 24시간 간격으로 7일 동안 결제를 시도합니다.<br>
							모금액은 후원자 결제 종료 다음 날부터 7일째 되는 날 입금됩니다.
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<jsp:include page="/WEB-INF/views/project/calendar.jsp"></jsp:include>
					<br><br>
				</div>
			</div>
			
<!-- 			<div id="selectChargeWrap" style="display: none;"> -->
			<div id="selectChargeWrap">
				<hr class="dividingLine">
				<div class="projectWriteWrap">
					<div class="projectExplanationWrap">
						<h3>요금제 선택<span class="essential">&nbsp;*</span></h3>
						<p>
							프로젝트 진행 목적에 적합한 요금제를 선택해 주세요.<br>
							프로젝트가 승인된 이후에는 요금제를 변경할 수 없으니 신중히 선택해주세요.
						</p>
					</div>
					<div class="projectContentWrap">
						<div class="projectWriteBorder">
						</div>
						<br><br>
					</div>
				</div>
			</div>
			
		</div>
		
		<%-- ---------- 후원 구성 ---------- --%>
		<div id="writeContainer3" class="writeContainer">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>내가 만든 아이템</h3>
					<div id="itemListContainer">
						<c:forEach var="item" items="${itemList}">
							<div class="itemListWrap">
	           					<div class="itemList">
	           						<h4>${item.item_name}</h4>
	           						<p>
		           						<b>옵션조건(${item.item_condition})</b><br>
		           						${item.multiple_option}
	           						</p>
	           						<br>
								</div>
	           					<div class="trashImg" data-item-idx="${item.item_idx}">
	           						<img alt="휴지통아이콘" src="${pageContext.request.contextPath}/resources/image/trash_icon.png">
								</div>
							</div>
						</c:forEach>
					</div>
				</div>
				<div class="projectContentWrap">
					<div class="projectWriteBorder">
						<h3>아이템 만들기</h3>
						<p>
							아이템은 후원에 포함되는 구성 품목을 말합니다.<br>
							특별한 물건부터 의미있는 경험까지 후원을 구성할 아이템을 만들어 보세요.
						</p>
						<form id="registItemForm">
							<input type="hidden" name="project_idx" value="${project.project_idx}">
							<b>아이템 이름</b>
							<input type="text" name="item_name" id="item_name" maxlength="50" style="width: 100%;">
							<div class="LengthCount">
								<p><span id="itemNameLength">0</span>/50</p>
							</div>
							<br>
							
							<b>옵션 조건</b>
							<div id="optionCondition" style="display: flex; justify-content: space-between;">
								<input type="radio" name="item_condition" id="none" value="없음">
								<label for="none">없음</label>
								<input type="radio" name="item_condition" id="subjective" value="주관식">
								<label for="subjective">주관식</label>
								<input type="radio" name="item_condition" id="objective" value="객관식">
								<label for="objective">객관식</label>
							</div>
							<br>
							
							<div id="subjectiveWrap">
								<b>옵션 항목</b>
								<input type="text" name="item_option_name" class="itemText" placeholder="예) 각인문구를 작성해주세요.">
							</div>
							<div id="objectiveWrap">
								<b>옵션 항목</b>
								<div style="display: flex; justify-content: space-between; align-items: flex-end;">
									<p>
										2개 이상의 옵션 항목을 만들어주세요.<br>
										한 칸에 하나의 옵션을 작성해주세요.
									</p>
									<span id="addOption" class="addImg" style="margin-bottom: 10px;">
		           						<img alt="+아이콘" src="${pageContext.request.contextPath}/resources/image/add_icon.png">
									</span>
								</div>
								<input type="text" name="item_option_name" class="itemText" placeholder="예) 240mm">
								<input type="text" name="item_option_name" class="itemText" placeholder="예) 250mm">
							</div>
							
							<hr class="dividingLine2">
							<div style="display: flex; justify-content: space-between;">
								<input type="reset" id="reset" value="초기화">
								<input type="submit" id="itemRegist" value="등록">
							</div>
						</form>
					</div>
					<br><br>
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>내가 만든 후원</h3>
					<div id="rewardListContainer">
						<div class="rewardListWrap">
							<div class="rewardList">
								<h2>1,000원+</h2>
								<h4>선물 없이 후원하기</h4>
							</div>
						</div>
<%-- 						<c:forEach var="reward" items="${rewardList}"> --%>
<!-- 							<div class="rewardListWrap"> -->
<!-- 	           					<div class="rewardList"> -->
<%-- 	           						<h2>${reward.reward_price}원+</h2> --%>
<%-- 	           						<h4>${reward.reward_title}</h4> --%>
<!-- 	           						<p> -->
<!-- 	           							아이템 | 아이템 -->
<!-- 	           							수량 : 00개 -->
<!-- 	           						</p> -->
<!-- 	           						<br> -->
<!-- 								</div> -->
<%-- 	           					<div class="trashImg" data-reward-idx="${reward.reward_idx}"> --%>
<%-- 	           						<img alt="휴지통아이콘" src="${pageContext.request.contextPath}/resources/image/trash_icon.png"> --%>
<!-- 								</div> -->
<!-- 							</div> -->
<%-- 						</c:forEach> --%>
					</div>
				</div>
				<div class="projectContentWrap">
					<div class="projectWriteBorder">
						<h3>후원 구성하기</h3>
						<p>
							다양한 금액대로 여러 개의 리워드를 만들어주세요.<br>
							펀딩 성공률이 높아지고, 더 많은 후원 금액을 모금할 수 있어요.
						</p>
						<form id="registRewardForm">
							<input type="hidden" name="project_idx" value="${project.project_idx}">
							<b>아이템 선택</b>
							<div id="chooseItemContainer">
								<c:forEach var="item" items="${itemList}">
									<div class="chooseItem">
										<input type="checkbox" name="reward_item_idx" id="item${item.item_idx}" value="${item.item_idx}">
										<label for="item${item.item_idx}">${item.item_name}</label><br>
									</div>
								</c:forEach>
							</div>
							<br>
							
							<b>구성 설명</b>
							<p>어떤 아이템으로 구성되었는지 쉽게 알 수 있는 설명을 입력해주세요.</p>
							<input type="text" name="reward_title" id="reward_title" placeholder="예) 강아지 간식, 배송비 포함" maxlength="50" style="width: 100%;">
							<div class="LengthCount">
								<p><span id="rewardTitleLength">0</span>/50</p>
							</div>
							
							<hr class="dividingLine2">
							<div id="amountLimitContainer">
								<b>수량 제한</b>
								<div id="amountLimitWarp" style="display: flex; justify-content: space-between;">
									<input type="radio" name="amount_limit" id="amountLimit_Y" value="Y">
									<label for="amountLimit_Y">있음</label>
									<input type="radio" name="amount_limit" id="amountLimit_N" value="N">
									<label for="amountLimit_N">없음</label>
								</div>
							</div>
							
							<hr class="dividingLine2">
							<div id="deliveryStatusContainer">
								<b>배송 여부</b>
								<div id="deliveryStatusWarp" style="display: flex; justify-content: space-between;">
									<input type="radio" name="delivery_status" id="deliveryStatus_Y" value="Y">
									<label for="deliveryStatus_Y">네</label>
									<input type="radio" name="delivery_status" id="deliveryStatus_N" value="N">
									<label for="deliveryStatus_N">아니오</label>
								</div>
							</div>
							
							<hr class="dividingLine2">
							<b>후원 금액</b>
							<table style="border: 1px solid #ccc; width: 100%;">
								<tr>
									<td>
										<input type="text" name="reward_price" id="reward_price" placeholder="1000원 이상의 금액을 입력하세요." maxlength="10" style="border: none; text-align: right; width: 565px;">
									</td>
									<td style="text-align: center; padding-bottom: 2px;" width="40px">원</td>
								</tr>
							</table>
							<span id="checkRewardPrice"></span>
							
							<br>
							<hr class="dividingLine2">
							<div style="display: flex; justify-content: space-between;">
								<input type="reset" id="reset" value="초기화">
								<input type="submit" id="rewardRegist" value="등록">
							</div>
						</form>
					</div>
					<br><br>
				</div>
			</div>
			
		</div>
		<%-- ---------- 프로젝트 계획 ---------- --%>
		<div id="writeContainer4" class="writeContainer">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 소개<span class="essential">&nbsp;*</span></h3>
					<p>
						프로젝트에 대해 자세히 설명해 주세요.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">다음 내용이 포함되도록 작성해 주세요!</p>
						<p>
							Q. 무엇을 만들기 위한 프로젝트인가요?<br>
							Q. 프로젝트를 간단히 소개한다면?<br>
							Q. 이 프로젝트가 왜 의미있나요?<br>
							Q. 이 프로젝트를 시작하게 된 배경이 무엇인가요?
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_introduce" id="project_introduce">
					<label for="project_introduce">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								소개 이미지 업로드
							</span>
						</div>
					</label>
					<div class="imagePreview">
						<img id="project_introduce_preview">
					</div>
					<br><br>
				</div>
			</div>

			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 예산<span class="essential">&nbsp;*</span></h3>
					<p>
						설정하신 목표 금액을 어디에 사용 예정이 신지 구체적인 지출 항목으로 적어주세요.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">다음 항목을 확인해주세요!</p>
						<p>
							예산은 ‘제작비’가 아닌 구체적인 ‘항목’으로 적어주세요.<br>
							이번 프로젝트의 실행에 필요한 비용으로만 작성해 주세요.<br>
							예시) 목표금액은 아래의 지출 항목으로 사용할 예정입니다.
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_budget" id="project_budget">
					<label for="project_budget">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								예산 이미지 업로드
							</span>
						</div>
					</label>
					<div class="imagePreview">
						<img id="project_budget_preview">
					</div>
					<br><br>
				</div>
			</div>

			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 일정</h3>
					<p>
						작업 일정을 구체적인 날짜와 함께 작성하세요.<br>
						후원자가 일정을 보면서 어떤 작업이 진행될지 알 수 있어야 합니다.<br>
						펀딩 종료 이후의 제작 일정을 반드시 포함하세요.
					</p>
					<br>
					<div class="creatorGuide">
						<p class="emphasis">아래의 양식을 참고하여 작성해보세요!</p>
						<p>
							(예시)<br>
							0월 0일: 현재 제품 시안 및 1차 샘플 제작<br>
							0월 0일: 펀딩 시작일<br>
							0월 0일: 펀딩 종료일<br>
							0월 0일: 제품 디테일 보완<br>
							0월 0일: 제품 발주 시작<br>
							0월 0일: 후가공 처리 및 포장 작업<br>
							0월 0일: 선물 예상 전달일
						</p>
					</div>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_schedule" id="project_schedule">
					<label for="project_schedule">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								일정 이미지 업로드
							</span>
						</div>
					</label>
					<div class="imagePreview">
						<img id="project_schedule_preview">
					</div>
					<br><br>
				</div>
			</div>

			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 팀 소개</h3>
					<p>
						프로젝트를 진행하는 팀(혹은 개인)을 알려주세요.<br>
						이 프로젝트를 완수할 수 있다는 점을 후원자가 알 수 있어야 합니다.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_team_introduce" id="project_team_introduce">
					<label for="project_team_introduce">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								팀소개 이미지 업로드
							</span>
						</div>
					</label>
					<div class="imagePreview">
						<img id="project_team_introduce_preview">
					</div>
					<br><br>
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>후원 설명</h3>
					<p>
						후원자가 후원 금액별로 받을 수 있는 선물을 상세하게 알려주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<input type="file" name="project_sponsor" id="project_sponsor">
					<label for="project_sponsor">
						<div class="fileUpload">
							<span class="uploadImg">
								<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
								후원 설명 이미지 업로드
							</span>
						</div>
					</label>
					<div class="imagePreview">
						<img id="project_sponsor_preview">
					</div>
					<br><br>
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로젝트 정책</h3>
					<p>
						펀딩 종료 후 후원자의 불만 또는 분쟁 발생 시 중요한 기준이 될 수 있습니다. 
						신중히 작성해 주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<div class="projectWriteBorder">
						<h4>프로젝트 정책</h4>
						<p>이 프로젝트의 정책을 기입해주세요.</p>
						<textarea name="project_policy" id="project_policy" rows="8" cols="10" maxlength="10000" style="width: 100%;"></textarea>
						<div class="LengthCount">
							<p><span id="projectPolicyLength">0</span>/1000</p>
						</div>
					</div>
					<br><br>
				</div>
			</div>
		</div>
		<%-- ---------- 창작자 정보 ---------- --%>
		<div id="writeContainer5" class="writeContainer">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>창작자 이름<span class="essential">&nbsp;*</span></h3>
					<p>
						창작자 개인이나 팀을 대표할 수 있는 이름을 써주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<input type="text" name="creator_name" id="creator_name" maxlength="20">
					<div class="LengthCheck">
						<span id="checkCreatorName"></span>
						<p><span id="nameLength">0</span>/20</p>
					</div>
					<br><br>
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>프로필 이미지<span class="essential">&nbsp;*</span></h3>
					<p>
						창작자 개인이나 팀을 대표할 수 있는 사진을 올려주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap" style="display: flex; align-items: center;">
					<input type="file" name="creator_image" id="creator_image">
					<div class="imagePreview creatorName">
						<img id="creator_image_preview">
					</div>
					<div>
						<label for="creator_image">
							<div class="fileUpload" style="width: 410px;">
								<span class="uploadImg">
									<img alt="업로드아이콘" src="${pageContext.request.contextPath}/resources/image/upload_icon.png">
									이미지 업로드
								</span>
							</div>
						</label>
						<p>
							파일 형식은 jpg 또는 gif로, 사이즈는 가로 200px, <br>
							세로 200px 이상으로 올려주세요.
						</p>
					</div>
					<br><br> 
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>창작자 소개<span class="essential">&nbsp;*</span></h3>
					<p>
						2~3문장으로 창작자님의 이력과 간단한 소개를 써주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<textarea name="creator_introduce" id="creator_introduce" rows="5" cols="10" placeholder="간단한 이력과 소개를 써주세요." maxlength="300"></textarea>
					<div class="LengthCheck">
						<span id="checkCreatorIntroduce"></span>
						<p><span id="introduceLength">0</span>/300</p>
					</div>
					<br><br> 
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>본인 인증<span class="essential">&nbsp;*</span></h3>
					<p>
						창작자 본인 명의의 휴대번호로 인증해주세요.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<input type="button" value="본인인증하기" class="button" onclick="selfIdentification()">
					<br><br> 
				</div>
			</div>
			
			<hr class="dividingLine">
			<div class="projectWriteWrap">
				<div class="projectExplanationWrap">
					<h3>입금 계좌<span class="essential">&nbsp;*</span></h3>
					<p>
						후원금을 전달받을 계좌를 등록해주세요.
						법인사업자는 법인 계좌로만 정산받을 수 있습니다.
					</p>
					<br>
				</div>
				<div class="projectContentWrap">
					<input type="button" value="계좌등록하기" class="button" onclick="linkAccount()">
					<p>
						<span class="importanceImg">
							<img alt="주의사항 아이콘" src="${pageContext.request.contextPath}/resources/image/importance_icon.png">
						</span>
						본인인증 후 계좌등록이 가능합니다.
					</p>
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
				<h4 align="center">승인 가능 프로젝트</h4>
				<p>- 기존에 없던 새로운 시도</p>
				<p>- 기존에 없던 작품, 제품</p>
				<p>- 창작자의 이전 제품 및 콘텐츠는 후원에서 부수적으로 제공 가능</p>
			</div>
			<%-- ----- 반려 대상 프로젝트 ----- --%>
			<div id="returnProject">
				<div class="icon return">X</div>
				<h4 align="center">반려 대상 프로젝트</h4>
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
	
</body>
</html>
