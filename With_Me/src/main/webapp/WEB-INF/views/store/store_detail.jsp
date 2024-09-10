<%@page import="java.sql.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>index</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/store_detail.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/report_form.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
	</head>
	
	<body>
		<script type="text/javascript">
// 			document.addEventListener('DOMContentLoaded', function() {
// 	            document.getElementById('shareButton').addEventListener('click', function() {
// 	                const pageUrl = window.location.href;
	
// 	                navigator.clipboard.writeText(pageUrl).then(function() {
// 	                    alert("링크 복사 완료");
// 	                }).catch(function(err) {
// 	                    console.error('링크 복사에 실패했습니다: ', err);
// 	                });
// 	            });
// 	        });


			// 위의 방법은 HTTP에서는 동작하지 않고, HTTPS에서만 동작 하기 때문에
			// 대체 방법으로 document.execCommand('copy')를 사용하여 텍스트를 클립보드에 복사하는 방식을 사용
			document.addEventListener('DOMContentLoaded', function() {
			    document.getElementById('shareButton').addEventListener('click', function() {
			        const pageUrl = window.location.href;
			
			        // 임시 textarea 요소 생성
			        const tempTextarea = document.createElement('textarea');
			        tempTextarea.value = pageUrl;
			
			        // body에 textarea 추가
			        document.body.appendChild(tempTextarea);
			
			        // 텍스트 선택 및 복사
			        tempTextarea.select();
			        document.execCommand('copy');
			
			        // textarea 제거
			        document.body.removeChild(tempTextarea);
			
			        // 사용자에게 알림
			        alert("링크 복사 완료");
			    });
			});
		</script>
		<header>
			<jsp:include page="/WEB-INF/views/inc/store_top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="con01">
				<div class="itemWrapper">
<%-- 				<c:set var="product_detail" value="${product_detail}"/> --%>
					<div id="imgArea">
<%-- 						<img alt="프로젝트 썸네일" src="${pageContext.request.contextPath}/resources/image/imgReady.jpg"> --%>
						<img alt="스토어 상품 썸네일" src="${pageContext.request.contextPath}/resources/upload/${product_detail.product_img}">
					</div>
					<div id="infoArea">
						<span class="category">${product_detail.product_category} > ${product_detail.product_category_detail}</span>
						<button id="shareButton">
							<span id="share"> URL 공유 </span>
<%-- 							<img alt="링크복사" src="${pageContext.request.contextPath}/resources/image/shareIcon.png" class="shareImg"> --%>
						</button>
						<h4>${product_detail.product_name}</h4>
						<div class="productInfo1">
							<div>
								<span>가격</span>
								<ul>
									<li><h4><fmt:formatNumber pattern="#,###">${product_detail.product_price}</fmt:formatNumber></h4></li>
									<li>원</li>
								</ul>
							</div>
						</div>
						<div class="productInfo2">
							<dl> 
								<dt>배송</dt>
								<dd><b>평일 16시 전 주문하면 오늘 출발  </b>(무료배송)</dd> <!-- 마감일 다음날 결제 예정일 -->
							</dl>
						</div>
						<form action="StoreInProgress" method="get" onsubmit="return validateOptionSelection();">
							
							<div class="productInfo3">
								<c:choose>
									<c:when test="${product_detail.product_status eq '1'}"> <!-- 판매중일 때 -->
										<select class="store_product_option_select option" id="product_select">
											<option disabled  selected value="">옵션을 선택해주세요.</option>
											<c:forEach var="productOptions" items="${productOptions}">
												<option value="${productOptions.splited_product_option}" >${productOptions.splited_product_option}</option>
											</c:forEach>
										</select>
									</c:when>
									<c:otherwise>
										<input type="text" placeholder="현재 구매 불가한 상품 입니다." class="reward_item_option_write option" >
									</c:otherwise>
								</c:choose>
							</div>
							<div class="productInfo4">
							<c:choose>
								<c:when test="${product_detail.isLike.like_mem_email eq sId and product_detail.isLike.like_status eq 'Y'}">
									<button class="like Btn" type="button" onclick="CancelLikeProduct('${product_detail.product_code}', '${sId}')">
										<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
									</button>
								</c:when>
								<c:otherwise>
									<button class="like Btn" type="button" onclick="RegistLikeProduct('${product_detail.product_code}', '${sId}')">
										<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
									</button>
								</c:otherwise>
							</c:choose>
								
<!-- 								<button class="goStore Btn">상품문의하기</button> -->
								<input type="hidden" id="productOption" name="productOption" value="">
								<input type="hidden" id="productPrice" name="productPrice" value="${product_detail.product_price}">
								<input type="hidden" id="productName" name="productName" value="${product_detail.product_name}">
								<input type="hidden" id="productIdx" name="productIdx" value="${product_detail.product_idx}">
								<input type="submit" class="goStore Btn" value="구매하기">
							</div>
						</form>
					</div>
				</div>
			</section>
			
			<section class="con02">
				<div class="left">
					<img alt="상품 상세 이미지" src="${pageContext.request.contextPath}/resources/upload/${product_detail.product_img2}" class="detailImg">
<%-- 					<img alt="스토어 상품 썸네일" src="${pageContext.request.contextPath}/resources/image/cuteDog.JPG" class="detailImg"> --%>
				</div>
				
				<div class="right">
					<div id="creatorInfo">
						<h4>문의・정책</h4>
						<div class="wrap">
							<div>
								<div class="creator">
									<img alt="창작자 프로필사진" src="${pageContext.request.contextPath}/resources/image/withme.png">
									<span>위드미</span>
								</div>
							</div>
							<div class="btns">
								<button class="follow" onclick="StoreList('푸드', '')">다른상품 보러가기</button>
								<button class="ask" onclick="location.href='QnaBoardWrite'">문의</button>
							</div>
						</div>
					</div>
					
					<div id="report">
						<span>문제가 있나요?</span>
						<img alt="이동" src="${pageContext.request.contextPath}/resources/image/right-arrow.png">
					</div>
					<div id="policy">
						<span>교환/환불 정책</span>
						<img alt="이동" src="${pageContext.request.contextPath}/resources/image/right-arrow.png">
					</div>

					<div class="productAside">
						<h4>구매 전 반드시 확인하세요!</h4>
						<div class="wrap">
							<div class="reward" id="reward_default" >
								<div class="reward_title">- 아래 스토리 내용은 이전 펀딩 진행 시 작성된 내용입니다.</div>
								<div class="reward_title">- 상품 금액은 스토리 상이 아닌 상품 선택해서 확인해 주세요.</div>
							</div>
						</div>
					</div>
					<div class="productAside">
						<div class="wrap">
							<div class="reward" id="reward_default" >
								<h4>반품 보내실 주소</h4>
								<div class="reward_title">서울특별시 서초구 서초대로 398, 20층</div>
								<div class="reward_title">(서초동, BNK 디지털타워)</div>
							</div>
							

						</div>
					</div>
				</div>
			</section>
		</div>
		
<div class="modal"> <!-- 신고 -->
		    <div class="modal_popup">
		        <h3>신고하기</h3>
	        	<span>어떤 문제가 있나요?</span><br>
		        <div class="content">
		        	<button value="지식재산권 침해" onclick="reportType(this.value, '${product_detail.product_name}', '${product_detail.product_code}')">
		        		<span class="repTitle">지식재산권 침해</span>
		        		<span class="repContent">
		        			타인의 지식재산권을 허락없이 사용했어요. <br>
							타인의 제품이나 콘텐츠를 동일하게 모방했어요.
		        		</span>
		        	</button>
		        	
		        	<button value="상세설명 내 허위사실" onclick="reportType(this.value, '${product_detail.product_name}', '${product_detail.product_code}')">
		        		<span class="repTitle">상세설명 내 허위사실</span>
		        		<span class="repContent">
		        			상품을 받아보니 상세설명과 다른 부분이 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="동일 제품의 타 채널 유통" onclick="reportType(this.value, '${product_detail.product_name}', '${product_detail.product_code}')">
		        		<span class="repTitle">동일 제품의 타 채널 유통</span>
		        		<span class="repContent">
		        			프로젝트 진행 전에 이미 판매한 적이 있는 제품이에요. <br>
							같은 제품을 다른 곳에서 (예약)판매하고 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="부적절한 콘텐츠" onclick="reportType(this.value, '${product_detail.product_name}', '${product_detail.product_code}')">
		        		<span class="repTitle">부적절한 콘텐츠</span>
		        		<span class="repContent">
		        			- 타인을 모욕, 명예훼손하는 콘텐츠 <br>
		        			- 개인정보를 침해하는 콘텐츠<br>
		        			- 차별, 음란, 범죄 등 불건전한 콘텐츠 <br>
		        			- 타사 유통 채널 광고. 홍보 목적의 콘텐츠
		        		</span>
		        	</button>
		        	
		        	<button value="기타" onclick="reportType(this.value, '${product_detail.product_name}', '${product_detail.product_code}')">
		        		<span class="repTitle">기타</span>
		        		<span class="repContent">
		        			- 리워드가 불량이라 교환/수리 신청하고 싶어요. <br>
		        			- 리워드에 큰 하자가 있어 환불 신청하고 싶어요.  <br>
		        			- 배송이 너무 늦어져서 환불 신청하고 싶어요.  <br>
		        			- 창작자와 의사소통이 잘 되지 않아요. 
		        		</span>
		        	</button>
		        	
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
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn">
		    </div>
		</div>
		<!-- ========================= 교환/환불 정책 팝업 ============================ -->
		<div class="policy"> <!-- 교환/환불 정책 -->
		    <div class="policy_popup">
		    <h3>교환/환불 정책</h3>
	        	<span>확인해주세요</span><br>
		        <div class="content">
		        	<div class="refundPolicy">
		        		<span>
		        			– 서포터 단순 변심에 의한 교환/반품은 상품 수령 후 7일 이내에 신청할 수 있습니다.(반품 배송비 서포터 부담) <br>
							– 상품의 내용이 표시∙광고 내용과 다르거나 계약내용과 다르게 이행된 경우에는 해당 상품 등을 수령한 날부터 3개월 이내, <br>
							그 사실을 안 날 또는 알 수 있었던 날부터 30일 이내에 교환/반품을 신청할 수 있습니다.(반품 배송비 메이커 부담)<br>
							<b>– 다음의 경우에는 교환/반품을 신청할 수 없습니다.</b><br>
							&nbsp;&nbsp;– 서포터의 책임 있는 사유로 상품 등이 멸실 또는 훼손된 경우(다만, 상품 등의 내용을 확인하기 위하여 포장 등을 훼손한 경우는 제외함) <br>
							&nbsp;&nbsp;– 서포터의 사용 또는 일부 소비로 인하여 상품 등의 가치가 현저히 감소한 경우 <br>
							&nbsp;&nbsp;– 시간의 경과에 의하여 재판매가 곤란할 정도로 상품 등의 가치가 현저히 감소한 경우 <br>
							&nbsp;&nbsp;– 복제 가능한 상품 등의 포장을 훼손한 경우 <br>
							&nbsp;&nbsp;– 용역 또는 “문화산업진흥 기본법” 제2조 제5호의 디지털콘텐츠의 제공이 개시된 경우<br>
							(다만, 가분적 용역 또는 가분적 디지털콘텐츠로 구성된 계약의 경우에는 제공이 개시되지 아니한 부분에 대하여는 제외함)<br>
							&nbsp;&nbsp;– 주문에 따라 개별적으로 생산되는 상품 등 그에 대하여 청약철회 등을 인정할 경우 메이커에게 회복할 수 없는 중대한 피해가 예상되는 경우로서,<br> 
							사전에 해당 거래에 대하여 별도로 그 사실을 고지하고 서포터의 서면(전자문서를 포함)에 의한 동의를 받은 경우<br>
							&nbsp;&nbsp;– 그 밖에 관련 법령에 따른 반품 제한 사유에 해당되는 경우
		        		</span>
		        	</div>
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn2">
		    
		    
		    
		    </div>
	    </div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		<script type="text/javascript">
			$(".store_product_option_select").on('change', function(){
				$("#productOption").val($(".store_product_option_select").val());
			});
			
			// ==========================================================================
			// 교환/환불 정책 
			let policy = document.querySelectorAll('.policy');
			let policyOpen = document.querySelector('#policy');
			let closeBtn2 = document.querySelector('.close_btn2');
			
			//--------------------------------
			// 교환/환불정책
			// 팝업 오픈
			policyOpen.onclick = function(){
				policy[0].classList.add('on'); 
			}
			
			
			//--------------------------------
			// 닫기 버튼
			closeBtn2.onclick = function(){
				policy[0].classList.remove('on');
			}
			
			// ===========================================
			// 상품 좋아요
			function RegistLikeProduct(product_code, sId) {
				console.log("product_code : " + product_code + ", sId : " + sId);
				if(confirm("해당 상품을 좋아요 하시겠습니까?")){
					$.ajax({
						url : "RegistLikeProduct",
						type : "POST",
// 						async: false,
						data:{
							"like_product_code": product_code,
							"like_mem_email": sId
						},
						dataType: "json",
						success: function (response) {
							if(response.result) {
								alert("해당 상품이 좋아요 리스트에 추가 되었습니다");
								location.reload();
								
							} else if(!response.result) {
								alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
								location.href="MemberLogin";
							}
						}
					});
				}
			}
				
			// 상품 좋아요 취소 
			function CancelLikeProduct(product_code, sId) {
				$.ajax({
					url : "CancelLikeProduct",
					type : "POST",
// 					async:false,
					data :{
						"like_product_code" : product_code,
						"like_mem_email" : sId
					}, 
					dataType: "json",
					success: function(response) {
						if(response.result) {
							alert("좋아요가 취소되었습니다.");
							location.reload();
						} else if(!response.result) {
							alert("로그인 후 이용 가능합니다. \n로그인 페이지로 이동합니다.");
							location.href="MemberLogin";
						}
					} 
				});
			}
			
			let modal = document.querySelectorAll('.modal');
			let report = document.querySelector('#report');
			let closeBtn = document.querySelectorAll('.close_btn');
			// ==========================================================================
			// 신고하기
			// 팝업 오픈
			
			$(report).on('click', function() { 
				$(modal).addClass("on");
			});
			
			// -------------------------------------------------------------------------
			// 닫기 버튼
			$(closeBtn).on('click', function() { 
				$(modal).removeClass("on");
			});
			// -------------------------------------------------------------------------
			// 신고 폼
			function reportType(type, title, product_code){
// 				console.log(type); // 오케이 .. 뜬다..
				$.ajax({
					url: "StoreReportForm",
					type : "get",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"type": type,
						"product_name": title,
						"product_code": product_code
					},
					dataType: "json",
					success: function (response) {
						let content = $(".modal.on").find($(".modal_popup")).find($(".content"));
						content.html("<div id='resultArea'></div>");
						
						writeReportForm(response.type, response.product_name, response.product_code);
						
						console.log(response.product_name);
					}, error : function (response) {
						alert("실패! ");
					}
				});
				
			}
			
			function writeReportForm(type, title, product_code){
				$.ajax({
					url: "StoreReportWriteForm",
					type : "get",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"type": type,
						"product_name": title,
						"product_code": product_code
					},
					success: function (response) {
						$("#resultArea").html(response);
					}, error : function (response) {
						alert("실패! ");
					}
				});
			}
			
			// 신고하기 end
			
			document.addEventListener('keydown', function(event) {
			  if (event.keyCode === 13) {
			    event.preventDefault();
			  };
			}, true);	
			
			// ===============================================================
			function validateOptionSelection() {
		        const selectedOption = document.querySelector(".store_product_option_select").value;
		        
		        if (!selectedOption) {  // 옵션이 선택되지 않은 경우
		            alert("옵션을 선택해 주세요.");
		            document.querySelector(".store_product_option_select").focus();  // 옵션 선택창으로 포커스 이동
		            return false;  // 폼 제출을 막음
		        }
		
		        return true;  // 옵션이 선택된 경우 폼 제출 허용
		    }
		</script>
	</body>
</html>




















