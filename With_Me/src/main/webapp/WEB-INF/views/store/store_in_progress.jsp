<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>With_Me</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/fund_in_progress.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<%-- 다음 우편번호 API --%>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		
		<%-- 포트원 결제 --%>
		<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
		<%-- iamport.payment.js --%>
		<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
		<style>
		
		.btnGroup {
			display: flex;
			align-content: center;
		}
		
		#cancel_btn {
			width: 30%;
		    padding: 15px 0;
		    margin-top: 20px;
		    border: none;
		    border-radius: 10px;
		    background-color: #ddd;
		    color: #fff;
		    font-weight: bold;
		    font-size: 20px;
		    text-align: center;
		    cursor: pointer;		
		}
		
		#user_store_complete {
			width: 70%;
		    padding: 15px 0;
		    margin-top: 20px;
		    margin-right: 10px;
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
// 			주소 검색 API 활용 기능 추가
// 			"t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
			$(function(){
				$("#address_search_btn").click(function() {
					console.log("동작");
					new daum.Postcode({
				        oncomplete: function(data) { 
				            $("#address_post_code").val(data.zonecode);
				            
							let address = data.address;
							
				            if(data.buildingName !== ''){
				               address += "(" + data.buildingName + ")";
				            }
				            
				            $("#address_main").val(address);
				            
				            $("#address_sub").focus();
				        }
				    }).open();
				});
			});
			
		</script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		<div id="postcode-layer" style="display:none; position:fixed; overflow:hidden; z-index:9999; -webkit-overflow-scrolling:touch;">
		    <!-- 여기에 Daum Postcode API 팝업이 렌더링됩니다. -->
		</div>
		<div class="inner">
			<h2>${member.mem_name} 후원자님! 다시 한 번 확인해주세요.</h2>
			<form action="StoreUserOrderPro" id="UserStorePayForm" method="post">
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
							<span> * 연락처 및 이메일 변경은 마이페이지에서 가능합니다. </span>
						</div>
					</div>
				</section>
				
				<section class="con04">
					<div class="rewardInfo">
						<h4>결제 정보</h4>
						<div class="infoWrapper">
							<div>${selectedProduct.productName}</div>
							<div>
<%-- 								<c:if test="${member ne null}"> --%>
<%-- 									<c:forEach var="selectedProduct" items="${selectedProduct}"> --%>
										<%-- foreach --%>
										<div>제품 구성</div>
										<div>&nbsp;&nbsp;&nbsp; - 옵션 : ${selectedProduct.productOption}</div>
<%-- 									</c:forEach> --%>
<%-- 								</c:if> --%>
							</div>
							<div id="amtWrapper">
								<div><fmt:formatNumber pattern="#,###">${selectedProduct.productPrice}</fmt:formatNumber>&nbsp;원</div>
								<input type="hidden" name="user_store_product_idx" id="user_store_product_idx" value="${selectedProduct.productIdx}">
							</div>
							<span id="totalAmt">총액 : <fmt:formatNumber pattern="#,###">${selectedProduct.productPrice}</fmt:formatNumber>원</span>
						</div>
					</div>
				</section>
				
				<section class="con02">
					<div class="addressInfo">
						<h4>배송지</h4>
						<div class="AddAddressBtn">
							<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
							&nbsp;&nbsp;&nbsp; 배송지 추가
						</div>
	
						<%-- address 테이블에서 가져와서 반복 --%>
						<div class="infoWrapper" id="addressList">
							<c:forEach var="userAddress" items="${userAddress}">
								<c:if test="${userAddress.address_selected eq 'Y'}">
									<div class="addressWrapper" data-address-idx="${userAddress.address_idx}">
										<div class="left">
											<div>${userAddress.address_receiver_name}
												<c:if test="${userAddress.address_is_default eq 'Y'}">
													<span class="default_simbol">기본 배송지</span>
												</c:if>	
											</div>											
											<div>[${userAddress.address_post_code}] ${userAddress.address_main}</div>											
											<div>${userAddress.address_sub}</div>
										</div>
										<div class="changeAddressBtn">변경</div>
									</div>
								</c:if>	
							</c:forEach>
						</div>
					</div>
				</section>
				
				<section class="con05">
					<div class="payInfo">
						<h3>결제하기 전에 확인해주세요 !</h3>
						<div class="infoWrapper">
							<div class="agreementInfo">
								<input type="checkbox" name="agreement" id="fund_agreement1" required> 
								<label for="fund_agreement1">개인정보 제3자 제공 동의 <span>(필수)</span></label>
							</div>	
							<div class="agreementInfo">
								<input type="checkbox" name="agreement" id="fund_agreement2" required>
								<label for="fund_agreement2">구매조건, 결제 진행 및 결제 대행 서비스 동의 <span>(필수)</span></label>
								<div>
									<p>· 전자금융거래 이용약관</p>
									<p>· 개인정보 수집 및 이용 및 제3자 제공의 대한 동의</p>
				
								</div>
							</div>
						</div>
					</div>
				</section>
				
				<section class="con06">
					<div class="pay">
						<div class="payWrap">
							<h4>결제 수단 </h4>
							<div class="payMethod on">
								카카오페이를 선택하셨습니다. 
								즉시할인 신용카드 적용이 불가합니다.
							</div>
							<div class="payMethod">
								신용/체크카드를 선택하셨습니다. 
								즉시할인 신용카드 적용이 가능합니다.
							</div>
						</div>
						<div class="infoWrapper">
							<div>
								<input type="radio" id="kakaoPay" name="payMethod" value="1" required checked>
								<label for="kakaoPay"> 카카오페이</label>
							</div>
							<div>
								<input type="radio" id="creditCard" name="payMethod" value="2" required>
								<label for="creditCard"> 카드결제</label>
							</div>
						</div>
						<div>
							
						</div>
					</div>
				
					
					
					<input type="hidden" name="user_store_product_idx" id="user_store_product_idx" value="${selectedProduct.productIdx}">					<!-- 상품 번호 -->
					<input type="hidden" name="user_store_email" id="user_store_email" value="${member.mem_email}">					<!-- 구매자 email -->
<!-- 					<input type="hidden" name="user_store_product_idx" id="user_store_product_idx" value="">			상품 번호 -->
					<input type="hidden" name="user_store_product_option" id="user_store_product_option" value="${selectedProduct.productOption}">			<!-- 스토어 아이템 옵션 | 로 구분-->
					<input type="hidden" name="user_order_count" id="user_order_count" value="1">					<!-- 상품 개수 => 우리는 1개 고정 -->
					<input type="hidden" name="user_store_address_idx" id="user_store_address_idx" value="">			<!-- 배송지 번호 -->
					<input type="hidden" name="user_store_pay_amt" id="user_store_pay_amt" value="${selectedProduct.productPrice}">     <!-- 총액 -->
					
					
					<input type="hidden" name="user_store_pay_method" id="user_store_pay_method" value="">                  <!-- 결제 방식 -->
					<div class="btnGroup">
						<input type="button" id="user_store_complete" value="결제하기">
						<input type="button" id="cancel_btn" onclick="./" value="취소하기"> 
					</div>
				</section>
			</form>
		</div>
		
		<!-- 배송지 추가 -->
		<div class="modal"> 
		    <div class="modal_popup">
		        <h3>배송지 추가</h3>
		        <div class="content add">
		        	<form action="StoreRegistAddress" method="POST" class="addressForm">
			        	<div>
			        		<span>받는 사람</span>
			        		<input type="text" placeholder="&nbsp;&nbsp;받는 분 성함을 입력해주세요." id="address_receiver_name" name="address_receiver_name" required>
			        	</div>
			        	
			        	<div>
			        		<span>주소</span>
							<br>
			        		<input type="text" name="address_post_code" id="address_post_code" placeholder="&nbsp;&nbsp;우편번호" required>
			        		<button type="button" id="address_search_btn">주소 검색</button>
							<br>
							<input type="text" name="address_main" id="address_main" placeholder="&nbsp;&nbsp;기본주소" required>
							<br>
							<input type="text" name="address_sub" id="address_sub" placeholder="&nbsp;&nbsp;상세주소">
			        	</div>
			        	
			        	<div>
			        		<span>받는 사람 휴대폰 번호</span>
			        		<br>
			        		<input type="text" name="address_receiver_tel" id="address_receiver_tel" placeholder="&nbsp;&nbsp;받는 분 휴대폰 번호를 입력해주세요." required>
			        	</div>
			        	
		        		<label>
		        			<input type="checkbox" name="address_is_default" id="address_is_default">
		        			<span>기본 배송지로 등록</span>
		        		</label>
		        		
			        	<input type="hidden" name="address_mem_email" id="address_mem_email" value="${member.mem_email}">
			        	
			        	<input type="button" value="배송지 등록" id="addRegBtn">
		        	</form>
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn">
		    </div>
		</div>
		
		<!-- 배송지 변경 -->
		<div class="modal"> 
		    <div class="modal_popup">
		        <h3>배송지 변경</h3>
		        <div class="content change">
		        	<form action="StoreChangeAddress" method="POST">
			        	<c:forEach var="userAddress" items="${userAddress}">
			        		<div class="infoWrapper">
				        		<label>
					        		<c:choose>
					        			<c:when test="${userAddress.address_selected eq 'Y'}">
					        				<input type="radio" name="address_idx" value="${userAddress.address_idx}" checked> 
					        			</c:when>
					        			<c:otherwise>
					        				<input type="radio" name="address_idx" value="${userAddress.address_idx}"> 
					        			</c:otherwise>
					        		</c:choose>
									<div class="addressWrapper">
										<div>${userAddress.address_receiver_name}
											<c:if test="${userAddress.address_is_default eq 'Y'}">
												<span class="default_simbol">기본 배송지</span>
											</c:if>
										</div>											
										<div>[${userAddress.address_post_code}] ${userAddress.address_main}</div>											
										<div>${userAddress.address_sub}</div>											
									</div>
								</label>
								<div>
									<div class="deleteAddress" data-address-idx="${userAddress.address_idx}">삭제</div>
									<c:choose>
										<c:when test="${userAddress.address_is_default eq 'Y'}">
											<div class="cancelDefault" data-address-mem-email="${sId}">기본 배송지<br> 해제</div>
										</c:when>
										<c:otherwise>
											<div class="registDefault" data-address-idx="${userAddress.address_idx}" style="background-color:#ffab40; color: #fff;">기본 배송지<br>설정</div>
										</c:otherwise>
									</c:choose>
								</div>
							</div>
						</c:forEach>
						
						<input type="button" value="배송지 선택 완료" id="changeBtn">
					</form>
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn">
		    </div>
		</div>
		
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		
		<script type="text/javascript">
			// =================================================================================
			// 페이지 로딩 시 결제 할 때 넘어갈 hidden 태그에 value 넣기
			// mem_email, product_code, order_idx, product_item_option, order_count
			$(function (){
				// 받아오면 바로 넣을 수 있는 것 
				
				
				// address_idx
				let addressIdx = $(".addressWrapper").data("address-idx");
				$("#user_store_address_idx").val(addressIdx);
				
				
				$("#user_store_pay_method").val($("input:radio[name=payMethod]:checked").val());
				
				// --------------------------------------------------------------------------------
			});
				
				
				
				
				
		
		
		
		
			// =================================================================================
			let modal = document.querySelectorAll('.modal');
			let AddAddressBtn = document.querySelectorAll('.AddAddressBtn');
			let changeAddressBtn = document.querySelectorAll('.changeAddressBtn');
			let closeBtn = document.querySelectorAll('.close_btn');
			// -------------------------------------------------------------------------
			// 팝업 오픈
			$(AddAddressBtn).on('click', function() { 
				$($(modal)[0]).addClass("on");
				return;
			});
			
			$(changeAddressBtn).on('click', function() { 
				$($(modal)[1]).addClass("on");
				return;
			});
			// -------------------------------------------------------------------------
			// 배송지 삭제
			$(document).on('click', '.deleteAddress', function() {
				let address_idx = $(this).data("address-idx");
				let infoWrapper = $(this).parent().parent();
				let parentInfoWrapper = $(this).parents(".modal.on").siblings(".inner").children(".con02").find(".addressWrapper");
				
				// `parentInfoWrapper` 중에서 `address_idx` 값을 가진 요소를 필터링하여 기존 목록에서도 삭제하도록 함
				let targetElement = parentInfoWrapper.filter(function(){
					return $(this).data("address_idx") === address_idx;
				});
// 				console.log(targetElement.html);
				
				// 선택된 배송지를 삭제하는 경우는 따로 분리해야함 0905
				let selectedAddress = infoWrapper.children().find($("input:radio[name=address_idx]:checked"));
				
				if(address_idx != selectedAddress.val()) { // 선택된 배송지 말고 다른거 지울 때 	
					if(confirm("배송지를 삭제하시겠습니까?")){
						$.ajax({
							url: "StoreDeleteAddress",
							type : "get",
							async:false, // 이 한줄만 추가해주시면 됩니다.
							data:{
								"address_idx": address_idx
							},
							dataType: "json",
							success: function (response) {
								
								console.log(JSON.stringify(response));
								
								if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
									alert("잘못된 접근입니다!");
								} else if(!response.result) { // 삭제 실패일 경우
				                    alert("배송지 삭제에 실패하였습니다.");
								} else if(response.result) { // 삭제 성공일 경우
				                    // 삭제된 아이템 요소 제거
				                    $(infoWrapper).remove(); 
									
									// 기존 목록에서도 삭제하도록 함
									$(targetElement).remove();
				                }
							
							}, error : function (response) {
								alert("실패! ");
							}
						});
					}
				} else { // 선택된 배송지를 지우면 그 배송지 말고 다른 배송지를 selected로 바꿔줘야함.
					if(confirm("배송지를 삭제하시겠습니까?")){
						$.ajax({
							url: "StoreDeleteAddress2",
							type : "get",
							async:false,
							data:{
								"address_idx": address_idx
							},
							dataType: "json",
							success: function (response) {
								
								// 받은 응답 데이터로 주소 리스트 업데이트
								updateAddressList(response);
								
								location.reload();
							
							}, error : function (response) {
								alert("실패! ");
							}
						});
					}					
				}
			});
			
			// 배송지 등록
			$(document).on('click', '#addRegBtn', function(){
				let isDefault = $("#address_is_default").is(":checked") ? "on" : "off";
			    
				console.log($("#address_is_default").val());
				$.ajax({
					url: "StoreRegistAddress",
					type: "post",
					data:{
						"address_receiver_name": $("#address_receiver_name").val(),
						"address_post_code": $("#address_post_code").val(),
						"address_main": $("#address_main").val(),
						"address_sub": $("#address_sub").val(),
						"address_receiver_tel": $("#address_receiver_tel").val(),
						"address_is_default": isDefault,
						"address_mem_email": $("#address_mem_email").val()
					},
					dataType: "json",
					success: function (response) {
						// 받은 응답 데이터로 주소 리스트 업데이트
						updateAddressList(response);
						
						location.reload();
					}, error: function() {
						alert("실패!");
						
						return false;
					}
				});
			});
			
			// 주소 리스트 출력 및 주소 영역 초기화
			function updateAddressList(addressList) {
				console.log(addressList);
				// 기존 리스트 초기화
				$("#addressList").empty();
			
				// 서버로부터 받은 아이템 리스트를 사용하여 새로운 리스트 생성 
				for(let address of addressList) {
					console.log("address : " + address);
					let listItem = 
						'<div class="addressWrapper">'
							+ '<div class="left">'
							+ '<div>'
							+ 	address.address_receiver_name
							+	(address.address_is_default === "Y"
									? '<span clas="default_symbol">기본 배송지</span>'
									: '')
							+	'</div>'
							+	'<div>'
							+		'[' + address.address_post_code + ']' + address.address_main
							+	'</div>'
							+	'<div>'
							+	 address.address_sub
							+	'</div>'
							+	'<div>'
							+	'<div class="changeAddressBtn">변경</div>'
						+ '</div>';
					$("#addressList").append(listItem);
				}
			}
			
			// 배송지 변경
			$(document).on('click', '#changeBtn', function(){
				let address_idx = $("input:radio[name='address_idx']:checked").val();
				
				$.ajax({
					url: "StoreChangeAddress",
					type: "post",
					async: false, 
					data:{
						"address_idx": address_idx
					},
					dataType: "json",
					success: function (response) {
						console.log(JSON.stringify(response));
						if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
							alert("잘못된 접근입니다!");
						} else if(!response.result) { // 변경 실패일 경우
							alert("배송지 변경에 실패하였습니다.");
						} else if(response.result) { // 변경 성공일 경우 
							// 페이지 리로드 
							location.reload();
							
						}
					}, error : function (response){
						alert("실패! ");
					}
				});
			});
			
			// 기본 배송지 변경 - 등록!
			$(document).on('click', '.registDefault', function() {
				let address_idx = $(this).data("address-idx");
				
				console.log("기본배송지 설정 눌렀을 떄 address_idx : " + +address_idx);
				if(confirm("기본배송지로 설정하시겠습니까? \n기본배송지는 1개만 설정 가능합니다.")) {
					$.ajax({
						url: "StoreRegistDefaultAddress",
						type: "post",
						data:{
							"address_idx" : address_idx,
						},
						dataType: "json",
						success: function(response){
							alert("정상 처리 되었습니다.");
							location.reload();
						}, error : function() {
							alert("실패");
							
							return false;
						}
					});
				}
			});
			
			
			// 기본 배송지 변경 -  해제!
			$(document).on('click', '.cancelDefault', function() {
				let address_mem_email = $(this).data("address_mem_email");
				
				console.log("기본배송지 해제 눌렀을 떄 address_mem_email : " +address_mem_email);
				if(confirm("기본배송지를 해제하시겠습니까? \n기본배송지는 1개만 설정 가능합니다.")) {
					$.ajax({
						url: "StoreCancelDefaultAddress",
						type: "post",
						data:{
							"addresss_mem_email" : address_mem_email,
						},
						dataType: "json",
						success: function(){
							alert("정상 처리 되었습니다.");
							location.reload();
						}, error : function(){
							alert("실패");
							
							return false;
						}
					});
				}
			});
			
			// -------------------------------------------------------------------------
			// 닫기 버튼
			$(closeBtn).on('click', function() { 
				$(modal).removeClass("on");
			});
			
			// =========================================================================
			// 결제 수단 목록
			let payMethod = document.querySelectorAll(".payMethod");
			
			// 결제 수단 변경 - 카카오페이
			$("#kakaoPay").click(function(){
				payMethod[0].classList.remove("on");
				payMethod[1].classList.remove("on");
// 				payMethod[2].classList.remove("on");
				
				
				payMethod[0].classList.add("on");
				$("#user_store_pay_method").val($(this).val());
			});
			
			// 결제수단 변경 - 신용카드
			$("#creditCard").click(function(){
				payMethod[0].classList.remove("on");
				payMethod[1].classList.remove("on");
// 				payMethod[2].classList.remove("on");
				
				payMethod[1].classList.add("on");
				$("#user_store_pay_method").val($(this).val());
			});
			
			
			
			// 결제 진행
			$("#user_store_complete").click(function(){
				// 동의사항 체크 여부 확인
				if($("input:checkbox[name=agreement]:checked").length > 1) {
					requestPay();
				} else {
					alert("필수 동의사항에 체크해주세요.");
				}
			});
			
			
			
			var IMP = window.IMP;
			IMP.init("imp61351081");
			
			let today =new Date();
			let hours = today.getHours(); // 시
			let minutes = today.getMinutes(); // 분
			let seconds = today.getSeconds(); // 초
			let milliseconds = today.getMilliseconds();
			let makeMerchantUid = "" + hours + minutes + seconds + milliseconds;

			// 포트원 예약 결제 https://developers.portone.io/opi/ko/integration/start/v2/billing/schedule?v=v2
			// https://velog.io/@code_june/Code-CampTIL-29%EC%9D%BC%EC%B0%A8-%EA%B2%B0%EC%A0%9C-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4			
			function requestPay() {
				if($("input:radio[name=payMethod]:checked").val() == "1") {
					IMP.request_pay ({
						// 파라미터 값 설정
						pg : "kakaopay.TC0ONETIME", // PG사 코드표에서 선택
						pay_method : "card", // 결제 방식
						merchant_uid : "IMP" + makeMerchantUid, // 결제 고유 번호  
						name : "${selectedProduct.productName}", // 상품명 -> 필수
						amount : "${selectedProduct.productPrice}", // 결제 금액 -> 필수
						// 구매자 정보 
						buyer_email : "${sId}",
						buyer_name : "${member.mem_name}",
						buyer_tel :  "${member.mem_tel}",
										
					}, function(rsp){// callback
						 if(rsp.success) {
							 alert("결제되었습니다.");
							 $("#UserStorePayForm").submit();
						 } else {
							 var msg = '결제에 실패하였습니다.';
							 msg += '\n에러내용 : ' + rsp.error_msg;
							 alert(msg);
						 }
					 });// IMP.request_pay End
					
				} else if($("input:radio[name=payMethod]:checked").val() == "2") {
					IMP.request_pay ({
						// 파라미터 값 설정
						pg : "html5_inicis.INIpayTest", // PG사 코드표에서 선택
						pay_method : "card", // 결제방식
						merchant_uid : "IMP" + makeMerchantUid, // 결제 고유 번호 
						name : "${selectedProduct.productName}", // 상품명 -> 필수
						amount : "${selectedProduct.productPrice}", // 결제 금액 -> 필수
						// 구매자 정보 
						buyer_email : "${sId}",
						buyer_name : "${member.mem_name}",
						buyer_tel : "${member.mem_tel}",
						
					}, function(rsp) {
						if(rsp.success) {
							alert("결제되었습니다.");
							$("#UserStorePayForm").submit();
						} else {
							var msg = '결제에 실패하였습니다.';
							msg += '\n에러내용 : ' + rsp.error_msg;
							alert(msg);
						}
						
					}); // IMP.request_pay End
				}
			}; // requestPay function End
			
			
		</script>
	</body>
</html>




















