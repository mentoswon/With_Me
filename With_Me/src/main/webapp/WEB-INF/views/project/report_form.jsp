<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div id="reportTypeWrapper">
	<div>${type}</div>
</div>

<form action="ReportSubmit" id="reportForm" method="POST">
	<input type="hidden" name="report_category" value="${type}">
	<input type="hidden" name="report_project_code" value="${project_code}">
	<div id="repCon01">
		<h4>신고 사유 *</h4>
		<p>상세히 작성해주세요. (최대 1000자)</p>
		<textarea rows="5" cols="85" name="report_reason" placeholder="&nbsp; 최소 20자 이상 입력해야 하며 내용이 충분하지 않을 경우 사실 확인이 어려울 수 있습니다." required></textarea>
	</div>
	
	<div id="repCon02">
		<h4>증빙 자료 (선택)</h4>
		<p>증빙 자료 첨부 시 침해 사실 확인 및 조치가 보다 신속하게 진행됩니다. <br>
			최대 3개, 10 MB 이하의 jpg, jpeg, png, pdf  파일만 등록 가능
		</p>
		<input type="file" value="파일 업로드">
	</div>
	
	<div id="repCon03">
		<h4>참고 URL (선택)</h4>
		<p>신고 내용을 확인할 수 있는 URL을 입력하세요 (최대 3개)</p>
		<div class="moreUrl">
			<input type="text" placeholder="https://" size="70" name="report_ref_url1">
			<button type="button" value="추가" class="moreUrlBtn">추가</button>
		</div>
	</div>
	
	<div id="repCon04">
		<p>아래의 정보를 꼭 확인해주세요</p>
		<div>
			<h4>신고자 이메일</h4>
			<input type="text" value="${member.mem_email}" readonly name="report_mem_email">
		</div>
		
		<div>
			<h4>신고 프로젝트 / 상품</h4>
			<input type="text" value="${project_title}" readonly>
		</div>
	</div>

	<div class="warn">
		<span>
			– 신고 내용이 사실과 다르거나 허위인 경우, 이용 제재를 받을 수 있습니다. <br>
			– 신고인의 정보를 허위로기재할 경우, 법적 책임을 물을 수 있습니다. <br>
			– 타인 비방 및 부당 이익 목적의 신고는 신고를 철회하더라도 면책되지 않습니다. <br>
			– 신고자의 정보 및 신고 내용은 안전하게 보호되며 외부에 제공되지 않습니다. <br>
			– 신고자는 개인정보의 수집 및 이용 동의 및 제 3자 제공을 거부할 권리가 있으나,  <br>
			  &nbsp;&nbsp; 거부할 경우 신고하기 서비스 이용에 제한을 받을 수 있습니다.
	    </span>
    </div>
    
	<input type="button" id="cancleBtn" onclick="cancleConfirm()" value="취소하기">
    <input type="submit" value="접수하기" id="submitReport">
</form> 

<script>
	
	// 취소 버튼
	function cancleConfirm(){
		if(confirm("작성을 취소하시겠습니까?")) {
			$(modal).removeClass("on");
		}
	}
	
// 	function submitConfirm(){
// 		if(confirm("신고를 접수하시겠습니까?")){
// 			location.href="ReportSubmit";
// 		}
// 	}
	
	$(document).on('click','.moreUrlBtn', function (){
		// 현재 .moreUrl 요소의 개수 확인
	    let urlCount = $(".moreUrl").length;
	    
	    if (urlCount >= 3) {
	        alert("URL은 최대 3개까지 작성 가능합니다.");
	        return false; // 최대 개수를 초과하면 추가하지 않음
	    }

	    // 추가할 URL의 번호를 URL 개수에 1을 더해 설정
	    let newUrlNumber = urlCount + 1;
	    
	    let addUrl = 
	        '<div class="moreUrl">'
	            + '<input type="text" placeholder="https://" size="70" name="report_ref_url' + newUrlNumber + '">'
	            + '<button type="button" value="추가" class="moreUrlBtn">추가</button>'
	        + '</div>';
		
		$("#repCon03").append(addUrl);
	});
</script>















