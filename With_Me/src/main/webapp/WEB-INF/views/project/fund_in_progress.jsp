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
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/fund_in_progress.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<%-- 다음 우편번호 API --%>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script type="text/javascript">
			// 주소 검색 API 활용 기능 추가
			// "t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
// 			$("#address_search_btn").click(function() {
// 				console.log("동작");
// 				new daum.Postcode({
// 			        oncomplete: function(data) { 
// 			            $("#address_post_code").val(data.zonecode);
			            
// 						let address = data.address;
						
// 			            if(data.buildingName !== ''){
// 			               address += "(" + data.buildingName + ")";
// 			            }
			            
// 			            $("#address_main").val(address);
			            
// 			            $("#address_sub").focus();
// 			        }
// 			    }).open();
// 			});
			
		</script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<h2>${member.mem_name} 후원자님! 다시 한 번 확인해주세요.</h2>
			<%-- 후원 처리할 때 가져갈 form --%>
			<form action="UserFundingPro" name="goFundForm" method="post">
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
				
				<%-- 위치 고민 중 --%>
				<section class="con04"> 
					<div class="rewardInfo">
						<h4>결제 정보</h4>
						<div id='moreAmtInfo'> * 추가 후원금은 결제 시 포함하여 결제됩니다. </div>
						<div class="infoWrapper">
							<div class="title">${selectedReward.reward_title}</div>
							<div>
								<c:if test="${optionMap ne null}">
									<c:forEach var="optionMap" items="${optionMap}">
										<div class="option_name">${optionMap.key}</div>
										<div class="multiple_option">&nbsp;&nbsp;- 옵션 : ${optionMap.value}</div>
									</c:forEach>
								</c:if>
							</div>
							
							<div id="amtWrapper">
								<div><fmt:formatNumber pattern="#,###"> ${selectedReward.reward_price}</fmt:formatNumber>&nbsp;원</div>
								<input type="hidden" name="user_funding_reward_idx" id="user_funding_reward_idx" value="${selectedReward.funding_reward_idx}">
								<div class="moreAmt">
									<span id="moreAmt"></span>
								</div>
							</div>
							<span id="totalAmt"> 총액 : <fmt:formatNumber pattern="#,###"> ${selectedReward.reward_price}</fmt:formatNumber>&nbsp;원</span>
						</div>
					</div>
				</section>
				
				<%-- 위치 고민 중 --%>
				<section class="con03">
					<div class="moreFundAmt">
						<h4>추가 후원(선택)</h4>
						<div class="infoWrapper">
							<div>
								<div>후원금</div>
								<input type="number" value="" id="inputMoreAmt">&nbsp; 원
							</div>
						</div>
					</div>
				</section>
				
				<section class="con02">
					<div class="addressInfo">
						<h4>배송지
							<c:if test="${selectedReward.reward_title eq '일반 후원하기'}">
								<span id="addWarn">일반 후원의 경우 배송되는 물품이 없습니다.</span>
							</c:if>
						</h4>
						<div class="AddAddressBtn">
							<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
							&nbsp;&nbsp;&nbsp; 배송지 추가
						</div>
	
						<%-- address 테이블에서 가져와서 반복 --%>
						<div class="infoWrapper" id="addressList" >
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
							<div class="warnInfo">
								<p>
									프로젝트 성공 시, 결제는 <b>${selectedReward.project_payDate}</b> 에 진행됩니다. <br><br>
									프로젝트가 무산되거나 중단된 경우, 예약된 결제는 자동으로 취소됩니다.
								</p>
							</div>
							<div class="agreementInfo">
								<input type="checkbox" name="agreement" id="fund_agreement1" required> 
								<label for="fund_agreement1">개인정보 제3자 제공 동의 <span>(필수)</span></label>
							</div>	
							<div class="agreementInfo">
								<input type="checkbox" name="agreement" id="fund_agreement2" required>
								<label for="fund_agreement2">후원 유의사항 확인 <span>(필수)</span></label>
								<div>
									<h5>후원은 구매가 아닌 창의적인 계획에 자금을 지원하는 일입니다.</h5>
									<p>
										텀블벅에서의 후원은 아직 실현되지 않은 프로젝트가 실현될 수 있도록 제작비를 후원하는 과정으로, <br><br>
										기존의 상품 또는 용역을 거래의 대상으로 하는 매매와는 차이가 있습니다. <br><br>
										따라서 전자상거래법상 청약철회 등의 규정이 적용되지 않습니다.
									</p>
								</div>
								
								<div>
									<h5>프로젝트는 계획과 달리 진행될 수 있습니다.</h5>
									<p>
										예상을 뛰어넘는 멋진 결과가 나올 수 있지만 진행 과정에서 계획이 지연, 변경되거나 <br><br> 무산될 수도 있습니다.
										본 프로젝트를 완수할 책임과 권리는 창작자에게 있습니다.
									</p>
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
								<input type="radio" id="kakaoPay" name="payMethod" required checked>
								<label for="kakaoPay"> 카카오페이</label>
							</div>
							<div>
								<input type="radio" id="creditCard" name="payMethod" required>
								<label for="creditCard"> 카드결제</label>
							</div>
							<div>
								<input type="radio" id="accountTransfer" name="payMethod" required>
								<label for="accountTransfer"> 계좌이체</label>
							</div>
						</div>
						<div>
							
						</div>
					</div>
				
					<input type="hidden" name="user_funding_email" id="user_funding_email" value="">					<!-- 완) 후원자 email -->
					<input type="hidden" name="user_funding_project_idx" id="user_funding_project_idx" value="">			<!-- 프로젝트 번호 -->
					<input type="hidden" name="user_funding_itemOption" id="user_funding_itemOption" value="">			<!-- 아이템 옵션 | 로 구분-->
					<input type="hidden" name="user_funding_count" id="user_funding_count" value="">					<!-- 후원 개수 => 우리는 1개 고정 -->
		<!-- 			<input type="hidden" name="user_funding_reward_idx" id="user_funding_reward_idx" value=""> -->    <!-- 리워드 번호 => 위에서 넣음 -->
					<input type="hidden" name="user_funding_address_idx" id="user_funding_address_idx" value="">			<!-- 배송지 번호 -->
					<input type="hidden" name="user_funding_plus_amt" id="user_funding_plus_amt" value="">				<!-- 추가 후원금 -->
					<input type="hidden" name="user_funding_pay_amt" id="user_funding_pay_amt" value="">                  <!-- 총액 -->
					<input type="submit" id="user_funding_payment" value="결제하기"> 
				</section>
			</form>
			
		</div>
		
		<!-- 배송지 추가 -->
		<div class="modal"> 
		    <div class="modal_popup">
		        <h3>배송지 추가</h3>
		        <div class="content add">
		        	<form action="RegistAddress" class="addressForm" method="POST">
			        	<div>
			        		<span>받는 사람</span>
			        		<input type="text" placeholder="&nbsp;&nbsp;받는 분 성함을 입력해주세요." id="address_receiver_name" name="address_receiver_name" required>
			        	</div>
			        	
			        	<div>
			        		<span>주소</span>
							<br>
			        		<input type="text" name="address_post_code" id="address_post_code" placeholder="&nbsp;&nbsp;우편번호" required>
<!-- 			        		<button id="address_search_btn">주소 검색</button> -->
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
		        	<form action="ChangeAddress" method="POST">
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
											<div class="cancleDefault" data-address-mem-email="${sId}">기본 배송지<br> 해제</div>
										</c:when>
										<c:otherwise>
											<div class="registDefault" data-address-idx="${userAddress.address_idx}" style="background-color: #ffab40; color: #fff;">기본 배송지<br>설정</div>
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
			// =========================================================================
			// 페이지 로딩 시 결제 할 때 넘어갈 hidden 태그에 value 넣기
			// mem_email, project_code, reward_idx, item_option, funding_count
			$(function (){
				// 받아오면 바로 넣을 수 있는 것
				
				// 후원자 email
				$("#user_funding_email").val('${member.mem_email}'); 
				
				// project_idx
				$("#user_funding_project_idx").val('${selectedReward.funding_project_idx}');
				
				// itemOption
				let item_option = "${selectedReward.funding_item_option}";
				
				// funding_count
				$("#user_funding_count").val(1);
				
				// reward_idx
// 				$("#user_funding_reward_idx").val($("#reward_idx").val()); // 위에서 넣음

				// address_idx
				let addressIdx = $(".addressWrapper").data("address-idx");
				$("#user_funding_address_idx").val(addressIdx);
				
				if($("#inputMoreAmt").val() == "") { // 페이지 로딩 됐을 때는 추가 후원금이 0이니까 0도 넣어주기
					$("#user_funding_plus_amt").val(0);
				}
				
				$("#user_funding_pay_amt").val('${selectedReward.reward_price}');
				
				// ------------------------------------------------------------------------------------
			});
		
			// =========================================================================
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
				let infoWrapper = $(this).parent();
				let parentInfoWrapper = $(this).parents(".modal.on").siblings(".inner").children(".con02").find(".addressWrapper");
				
				// `parentInfoWrapper` 중에서 `address_idx` 값을 가진 요소를 필터링하여 기존 목록에서도 삭제하도록 함
			    let targetElement = parentInfoWrapper.filter(function() {
			        return $(this).data("address-idx") === address_idx;
			    });
				
// 				console.log(targetElement.html());
				
				if(confirm("배송지를 삭제하시겠습니까?")){
					$.ajax({
						url: "DeleteAddress",
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
			});
			
			// 배송지 등록
			$(document).on('click', '#addRegBtn', function() {
				let isDefault = $("#address_is_default").is(":checked") ? "on" : "off";
				
				console.log($("#address_is_default").val());
				$.ajax({
					url: "RegistAddress",
					type : "post",
// 					async:false, // 이 한줄만 추가해주시면 됩니다.
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
					
					}, error : function () {
						alert("실패! ");
						
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
			                +  '<div>'
			                +    address.address_receiver_name
			                +    (address.address_is_default === "Y" 
			                        ? '<span class="default_symbol">기본 배송지</span>' 
			                        : '')
			                +  '</div>'
			                +  '<div>'
			                +    '[' + address.address_post_code + '] ' + address.address_main
			                +  '</div>'
			                +  '<div>'
			                +    address.address_sub
			                +  '</div>'
			                + '</div>'
			                + '<div class="changeAddressBtn">변경</div>'
			            + '</div>';
			            
					$("#addressList").append(listItem);
		        }
			}
			
			// 배송지 변경
			$(document).on('click', '#changeBtn', function(){
				let address_idx = $("input:radio[name='address_idx']:checked").val();
				
				$.ajax({
					url: "ChangeAddress",
					type : "post",
					async: false, // 이 한줄만 추가해주시면 됩니다.
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
					
					}, error : function (response) {
						alert("실패! ");
					}
				});
				
			});
			
			// 기본 배송지 변경 - 등록 !
			$(document).on('click', '.registDefault', function() {
				let address_idx = $(this).data("address-idx");
				
				console.log("기본배송지 설정 눌렀을 때 address_idx :" + address_idx);
				if(confirm("기본배송지로 설정하시겠습니까? \n기본배송지는 1개만 설정 가능합니다.")){
					$.ajax({
						url: "RegistDefaultAddress",
						type : "post",
	// 					async:false, // 이 한줄만 추가해주시면 됩니다.
						data:{
							"address_idx": address_idx,
						},
						dataType: "json",
						success: function (response) {
							alert("정상 처리 되었습니다.");
							location.reload();
						}, error : function () {
							alert("실패! ");
							
							return false;
						}
					});
				}
			});
			
			// 기본 배송지 변경 - 해제 !
			$(document).on('click', '.cancleDefault', function() {
				let address_mem_email = $(this).data("address-mem-email");
				
// 				console.log("기본배송지 해제 눌렀을 때 address_mem_email :" + address_mem_email);
				if(confirm("기본배송지를 해제하시겠습니까? \n기본배송지는 1개만 설정 가능합니다.")){
					$.ajax({
						url: "CancleDefaultAddress",
						type : "post",
	// 					async:false, // 이 한줄만 추가해주시면 됩니다.
						data:{
							"address_mem_email": address_mem_email,
						},
						dataType: "json",
						success: function (response) {
							alert("정상 처리 되었습니다.");
							location.reload();
						}, error : function () {
							alert("실패! ");
							
							return false;
						}
					});
				}
			});
			
			// -------------------------------------------------------------------------
			// 추가 후원금이 있을 경우
			$("#inputMoreAmt").keyup(function (){
				let moreMoneyAmt = $("#inputMoreAmt").val();
				let rewardPrice = ${selectedReward.reward_price};
				let totalAmt = rewardPrice + Number(moreMoneyAmt);
				
				if(moreMoneyAmt == ""){
					$("#moreAmt").text("");
				}
				
				// 결제 할 때 넘어갈 hidden 태그에 value 넣기
				$("#user_funding_plus_amt").val(moreMoneyAmt);
				$("#user_funding_pay_amt").val(totalAmt);
				
				// 1000단위 마다 , 찍기
				totalAmt = totalAmt.toString();
				moreMoneyAmt = moreMoneyAmt.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				$("#moreAmt").text("추가 후원금 : " + moreMoneyAmt + " 원");
				
				totalAmt = totalAmt.replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				$("#totalAmt").text("총액 : " + totalAmt + " 원");
			});
			
			// -------------------------------------------------------------------------
			// 닫기 버튼
			$(closeBtn).on('click', function() { 
				$(modal).removeClass("on");
			});
			
			
			// ==================================================================================
			//결제 수단 목록
			let payMethod = document.querySelectorAll(".payMethod");
			
			// 결제 수단 변경
			
			$("#kakaoPay").click(function() {
				payMethod[0].classList.remove("on");
				payMethod[1].classList.remove("on");
				
				payMethod[0].classList.add("on");
			});
			
			$("#creditCard").click(function() {
				payMethod[0].classList.remove("on");
				payMethod[1].classList.remove("on");
				
				payMethod[1].classList.add("on");
			});
			
		</script>
	</body>
</html>




















