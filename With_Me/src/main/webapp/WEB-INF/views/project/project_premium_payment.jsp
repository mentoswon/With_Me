<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>with_me</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<%-- 포트원 결제 --%>
<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
<%-- iamport.payment.js --%>
<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

<style type="text/css">
article {
    width: 1080px;
    margin: 0 auto;
}
section {
	margin: 40px auto;
	width: 60%;
	min-height: auto;
}

.inner h2 {
	margin-top: 40px;
	text-align: center;
	font-size: 32px;
}

h4 {
	font-size: 24px;
	margin-bottom: 20px;
}
	
.payInfoWrap {
	border: 1px solid #ccc;
	border-radius: 10px;
	padding: 20px;
}
.agreementContainer .payInfo h3 {
	margin-bottom: 15px;
	color: #ffab40;
	font-size: 20px;
}

.agreementContainer .payInfoWrap{
	padding-top: 50px;
}

.agreementContainer .payInfo .warnInfo {
	margin-bottom: 11px;
}

/* 동의체크박스 */
.agreementContainer .payInfo .agreementInfo{
	margin-bottom: 15px;
	padding-left: 40px; /* 체크박스의 왼쪽 여백 */
	position: relative;
	padding-top: 11px;
}

.agreementContainer .payInfo .agreementInfo input[type="checkbox"] {
	opacity: 0; /* 기본 체크박스 숨기기 */
	position: absolute;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

.agreementContainer .payInfo .agreementInfo label span {
	font-size: 13px;
}

.agreementContainer .payInfo .agreementInfo input[type="checkbox"] + label::before {
	content: '';
	width: 20px;
	height: 20px;
	border: 2px solid #ccc;
	background-color: #fff;
	margin-left: 10px;
	vertical-align: middle;
	border-radius: 4px;
	position: absolute; /* 체크박스 위치 조정 */
	left: 0; /* 체크박스의 왼쪽 위치 조정 */
	top: 8px;
	transform: translateY(0); /* 수직 중앙 정렬 */	
}

.agreementContainer .payInfo .agreementInfo input[type="checkbox"]:checked + label::before {
	background-color: #FFAB40;
	border-color: #FFAB40;	
}

.agreementContainer .payInfo .agreementInfo input[type="checkbox"]:checked + label::after {
	content: '✓';
	position: absolute;
	top: 17px;
	left: 3.5%;
	transform: translate(-50%, -50%);
	color: #fff;
	font-size: 18px;
	font-weight: bold;
}

.agreementContainer .payInfo .agreementInfo > div {
	padding: 15px 0;
}

.agreementContainer .payInfo .agreementInfo > div h5 {
	margin-bottom: 10px;
}

.agreementContainer .payInfo .agreementInfo > div p {
	font-size: 13px;
	color: #555;
}

/* paymentContainer */
.paymentContainer .pay {
	margin-bottom: 20px;	
}

.paymentContainer .payInfoWrap {
	display: flex;
	justify-content: space-around;
}

.payMethod {
	display: none;
}

.payMethod #addAccountBtn {
	padding: 0 20px;
    margin-left: 10px;
    height: 100%;
    border: 0.5px solid #797979;
    border-radius: 5px;
    background-color: #f5f5f5;
    font-size: 16px;
}

.payMethod #addAccountBtn:hover {
    background-color: #ffab40;
    color: #fff;
}

.payMethod.on {
	display: block;
}

.payWrap {
	display: flex;
	align-items: center;
	margin-bottom : 20px; 
}

.payWrap h4{
	margin: 0;
	margin-right: 15px;
}

#funding_complete{
	width: 100%;
	padding: 15px 0;
	margin-top: 20px;
	border: none;
	border-radius: 10px;
	background-color: #ffab40;
	color: #fff;
	font-weight: bold;
	font-size: 20px;
	text-align: center;
	cursor: pointer;
}
</style>
<script type="text/javascript">
$(function () {
    // 결제 수단 목록
    let payMethod = document.querySelectorAll(".payMethod");

    // 페이지 로드 시 기본 값 설정 (카카오페이 기본 선택)
    $("#pre_pay_method_idx").val("1");

    // 결제 수단 변경
    $("#kakaoPay").click(function() {
        togglePaymentMethod(0, $(this).val());
    });

    $("#creditCard").click(function() {
        togglePaymentMethod(1, $(this).val());
    });

    // 결제 진행
    $("#funding_complete").click(function() {
        // 동의사항 체크 여부 확인
        if ($("input:checkbox[name=agreement]:checked").length === 2) {  // 필수 체크박스 2개 확인
        	// 포트원 결제 요청 함수 호출
        	requestPay();
        } else {
            alert("필수 동의사항에 체크해주세요.");
        }
    });

    var IMP = window.IMP;
	IMP.init("imp61351081");
	
	let today = new Date();
	let hours = today.getHours(); // 시
	let minutes = today.getMinutes();  // 분
	let seconds = today.getSeconds();  // 초
	let milliseconds = today.getMilliseconds();
	let makeMerchantUid = "" + hours + minutes + seconds + milliseconds;
    
    function togglePaymentMethod(index, value) {
        // 모든 결제 수단 숨기기
        payMethod.forEach(function (method) {
            method.classList.remove("on");
        });

        // 선택한 결제 수단 보이기
        payMethod[index].classList.add("on");

        // 숨겨진 결제 수단 값을 설정
        $("#pre_pay_method_idx").val(value);
    }
    
    function requestPay() {
		if($("input:radio[name=payMethod]:checked").val() == "1") {
			IMP.request_pay({
				// 파라미터 값 설정
				pg : "kakaopay.TC0ONETIME", // PG사 코드표에서 선택
				pay_method : "card", // 결제 방식
				merchant_uid : "IMP" + makeMerchantUid, // 상점 거래 고유 번호
				name : "${project.project_title}", // 프로젝트명 -> 필수
				amount : 500000, // 결제 금액 -> 필수
				//구매자 정보 ↓
				buyer_email : "${sId}",
				buyer_name : "${member.mem_name}",
				buyer_tel : "${member.mem_tel}",
			
			}, function(rsp){ // callback
				if(rsp.success){
					// 성공적으로 결제된 경우, hidden 필드에 결제 정보를 추가
                    $("#merchant_uid").val("IMP" + makeMerchantUid); // 상점 거래 고유 번호
                    $("#imp_uid").val(rsp.imp_uid); // 결제 고유 번호
                    $("#apply_num").val(rsp.apply_num); // 카드 승인 번호 (if applicable)
                    console.log("apply_num: ", rsp.apply_num); // apply_num의 값을 확인
                    alert("결제되었습니다.");
					$("#ProjectSubmit").submit();
				}else {
					var msg = '결제에 실패하였습니다.';
			        msg += '\n에러내용 : ' + rsp.error_msg;
			        alert(msg);
				}
			
			});//IMP.request_pay 끝
		} else if($("input:radio[name=payMethod]:checked").val() == "2"){
			IMP.request_pay({
				// 파라미터 값 설정
				pg : "html5_inicis.INIpayTest", // PG사 코드표에서 선택
				pay_method : "card", // 결제 방식
				merchant_uid : "IMP" + makeMerchantUid, // 상점 거래 고유 번호
				name : "${project.project_title}", // 프로젝트명 -> 필수
				amount : 500, // 결제 금액 -> 필수(원래 50만원인데 실제 돈 출금되므로 500원으로 적음....)
				//구매자 정보 ↓
				buyer_email : "${sId}",
				buyer_name : "${member.mem_name}",
				buyer_tel : "${member.mem_tel}",
			
			}, function(rsp){ // callback
				if(rsp.success){
					// 성공적으로 결제된 경우, hidden 필드에 결제 정보를 추가
                    $("#merchant_uid").val("IMP" + makeMerchantUid); // 상점 거래 고유 번호
                    $("#imp_uid").val(rsp.imp_uid); // 결제 고유 번호
                    $("#apply_num").val(rsp.apply_num); // 카드 승인 번호 (if applicable)
                    console.log("apply_num: ", rsp.apply_num); // apply_num의 값을 확인
                    alert("결제되었습니다.");
					$("#ProjectSubmit").submit();
				}else {
					var msg = '결제에 실패하였습니다.';
			        msg += '\n에러내용 : ' + rsp.error_msg;
			        alert(msg);
				}
			
			});	//IMP.request_pay 끝
		}
	};//requestPay() 함수 끝
});
</script>
</head>
<body>
<header>
    <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
</header>

<article>
	<br><br><br>
    <div id="projectSubmitWrap">
        <div align="center">
            <h2>프로젝트 제출 전 Premium 광고료 선결제가 진행됩니다.</h2>
        </div>
        <div style="width: 1080px; margin: 0 auto;">
        	<form action="ProjectSubmit" id="ProjectSubmit" method="get">
	       		<section class=accountContainer> 
					<div class="rewardInfo">
						<h4>결제 정보</h4>
						<div class="payInfoWrap">
							<table style="width: 100%; border: none;">
								<tr>
									<td width="110">프로젝트명</td>
									<td> : ${project.project_title}</td>
								</tr>
								<tr>
									<td>프로젝트코드</td>
									<td> : ${project.project_code}</td>
								</tr>
								<tr>
									<td>결제금액</td>
									<td> : <fmt:formatNumber value="500000" pattern="#,###" />&nbsp;원</td>
								</tr>
							</table>
						</div>
					</div>
				</section>
	       		
	            <section class="agreementContainer">
	                <div class="payInfo">
	                    <h3>결제하기 전에 확인해주세요 !</h3>
	                    <div class="payInfoWrap">
	                        <div class="agreementInfo">
	                            <input type="checkbox" name="agreement" id="fund_agreement1" required>
	                            <label for="fund_agreement1">개인정보 제3자 제공 동의 <span>(필수)</span></label>
	                        </div>
	                        <div class="agreementInfo">
	                            <input type="checkbox" name="agreement" id="fund_agreement2" required>
	                            <label for="fund_agreement2">결제 진행 및 서비스 동의 <span>(필수)</span></label>
	                            <div>
	                                <h5>프로젝트는 계획과 달리 진행될 수 있습니다.</h5>
	                                <p>
	                                    예상보다 멋진 결과가 나올 수 있지만, 진행 과정에서 지연, 변경되거나 무산될 수 있습니다. 본 프로젝트를 완수할 책임과 권리는 창작자에게 있습니다.
	                                </p><br>
                                    <h5>프로젝트 시작 후 무산되거나 중단된 경우, 광고료 결제건에 대해서는 취소되지 않습니다.</h5>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </section>
	
	            <section class="paymentContainer">
	                <div class="pay">
	                    <div class="payWrap">
	                        <h4>결제 수단</h4>
	                        <div class="payMethod on">
	                            카카오페이를 선택하셨습니다. 즉시할인 신용카드 적용이 불가합니다.
	                        </div>
	                        <div class="payMethod">
	                            신용/체크카드를 선택하셨습니다. 즉시할인 신용카드 적용이 가능합니다.
	                        </div>
	                    </div>
	                    <div class="payInfoWrap">
	                        <div>
	                            <input type="radio" id="kakaoPay" name="payMethod" value="1" required checked>
	                            <label for="kakaoPay"> 카카오페이</label>
	                        </div>
	                        <div>
	                            <input type="radio" id="creditCard" name="payMethod" value="2" required>
	                            <label for="creditCard"> 카드결제</label>
	                        </div>
	                    </div>
	                </div>
	
	                <input type="hidden" name="pre_pay_method_idx" id="pre_pay_method_idx" value="1">
	                <input type="hidden" name="pre_creator_email" value="${sId}">
	                <input type="hidden" name="project_idx" id="project_idx" value="${project.project_idx}">
	                <input type="hidden" name="pre_project_code" id="pre_project_code" value="${project.project_code}">
	                <input type="hidden" name="pre_pay_amt" value="500000">
	
	                <input type="button" id="funding_complete" value="결제하기">
	            </section>
	            
                <input type="hidden" name="merchant_uid" id="merchant_uid" value="">
                <input type="hidden" name="imp_uid" id="imp_uid" value="">
                <input type="hidden" name="apply_num" id="apply_num" value="">
        	</form>
        </div>
    </div>
    <br><br><br>
</article>

<footer>
    <jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
</footer>
</body>
</html>