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
		<link href="${pageContext.request.contextPath}/resources/css/report_form.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/project_detail.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<script type="text/javascript">
		
			function chat(creatorId) {
				console.log("채팅창 열기: " + creatorId);
				
				var chatUrl = "/with_me/Chating?receiver_id=" + encodeURIComponent(creatorId); 
// 				var chatUrl = "/Chating?receiver_id=" + creatorId; 
				// encodeURIComponent 이거는 JavaScript의 내장 함수로, 
				// 문자열을 안전하게 URL에 포함할 수 있도록 특수 문자를 이스케이프(escape) 처리하여 변환해줌
				
				var popupOptions = "width=1000, height=500, scrollbars=yes, resizable=no";
				
				var chatWindow = window.open(chatUrl, "ChatWindow", popupOptions);
				
			    if (chatWindow) {
			        chatWindow.focus();
			    } else {
			        alert("팝업 창이 차단되었습니다. 팝업 차단을 해제해주세요.");
			    }
				
				
			}
		</script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="con01">
				<div class="itemWrapper">
					<div id="imgArea">
						<img alt="프로젝트 썸네일" src="${pageContext.request.contextPath}/resources/upload/${project_detail.project_image}">
					</div>
					<div id="infoArea">
						<span class="category">${project_detail.project_category} > ${project_detail.project_category_detail}</span>
						<h4>${project_detail.project_title}</h4>
						<div class="fundInfo1">
							<div>
								<span>모인 금액</span>
								<ul>
									<li><h4><fmt:formatNumber pattern="#,###">${project_detail.funding_amt}</fmt:formatNumber></h4></li>
									<li>원</li>
									
									<%-- 펀딩률 --%>
									<fmt:parseNumber var="funding_amt" value="${project_detail.funding_amt*1.0}" ></fmt:parseNumber>
									<fmt:parseNumber var="target_price" value="${project_detail.target_price}" ></fmt:parseNumber>
									
									<c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
									
									<c:choose>
										<c:when test="${fund_rate eq 0.0}">
											<li class="fund_rate">&nbsp;&nbsp; 0%</li>
										</c:when>
										<c:otherwise>
											<li class="fund_rate">&nbsp;&nbsp; <fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>%</li>
										</c:otherwise>
									</c:choose>
									<%-- 펀딩률 end --%>
								</ul>
							</div>
							<div>
								<span>후원자</span>
								<ul>
									<li><h4>${project_detail.funding_people}</h4></li>
									<li>명</li>
								</ul>
							</div>
						</div>
						<div class="fundInfo2">
							<dl>
								<dt>목표금액</dt>
								<dd><fmt:formatNumber pattern="#,###">${project_detail.target_price}</fmt:formatNumber> 원</dd>
							</dl>
							<dl>
								<dt>펀딩기간</dt>
								<dd>${project_detail.funding_start_date} ~ ${project_detail.funding_end_date}</dd>
								
								<!-- 오늘 날짜 추출 -->
								<c:set var="now" value="<%=new java.util.Date()%>" />
								<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
								<!-- 오늘 날짜 추출 end -->
								
								<!-- 남은 날짜 계산 -->
								<fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
								<fmt:parseNumber value="${project_detail.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
								<c:set value="${endDate - strDate + 1}" var="leftDay"/>
								<!-- 남은 날짜 계산 end -->
								
								<dd id="leftDay" style="<c:if test="${leftDay eq 0}">background-color:#ffab40; color:#ffffff;font-weight: bold;</c:if>">
									<c:choose>
										<c:when test="${leftDay eq 0}">
											오늘 마감이에요 !
										</c:when>
										<c:when test="${leftDay < 0}">
											마감
										</c:when>
										<c:when test="${project_detail.funding_start_date > today}">
											공개 예정
										</c:when>
										<c:otherwise>
											<c:out value="${leftDay}"></c:out>일 남았어요 !
										</c:otherwise>
									</c:choose>
								</dd>
							</dl>
							<dl>
								<dt>결제</dt>
								<dd>목표금액 달성 시 <b>${project_detail.pay_date}</b>에 결제 진행</dd> <!-- 마감일 다음날 결제 예정일 -->
							</dl>
						</div>
						
						<div class="fundInfo3">
							<c:choose>
								<c:when test="${project_detail.isLike.like_mem_email eq sId and project_detail.isLike.like_status eq 'Y'}">
									<button class="like Btn" type="button" onclick="cancelLike('${project_detail.project_code}', '${sId}')">
										<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
									</button>
								</c:when>
								<c:otherwise>
									<button class="like Btn" type="button" onclick="registLike('${project_detail.project_code}', '${sId}')">
										<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
									</button>
								</c:otherwise>
							</c:choose>
							<c:choose>
								<c:when test="${project_detail.funding_start_date > today}">
									<button type="button" class="goFund Btn" id="goFund" disabled
										 style="<c:if test="${project_detail.funding_start_date > today}">background-color: #f5f5f5; color: #555;</c:if>"
									>아직 오픈하지 않은 프로젝트예요!</button>
								</c:when>
								<c:when test="${project_detail.funding_end_date < today}">
									<button type="button" class="goFund Btn" id="goFund" disabled
										 style="<c:if test="${project_detail.funding_end_date < today}">background-color: #f5f5f5; color: #555;</c:if>"
									>마감된 프로젝트예요!</button>
								</c:when>
								<c:otherwise>
									<button type="button" class="goFund Btn" id="goFund" onclick="goToScroll()">이 프로젝트 후원하기</button>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</div>
			</section>
			
			<section class="con02">
				<div class="left">
					<img alt="상세 이미지" src="${pageContext.request.contextPath}/resources/upload/${project_detail.project_introduce}" class="detailImg">
				</div>
				
				<div class="right">
					<div id="creatorInfo">
						<h4>창작자 소개</h4>
						<div class="wrap">
							<div>
								<div class="creator">
									<img alt="창작자 프로필사진" src="${pageContext.request.contextPath}/resources/upload/${project_detail.project_image}">
									<span><a href="OtherMemberInfo?creator_email=${project_detail.creator_email}">${project_detail.creator_name}</a></span>
								</div>
								<div>
									<ul>
										<li>누적펀딩액</li>
										<li><fmt:formatNumber pattern="#,###">${project_detail.totalFundAmt}</fmt:formatNumber> 원</li>
									</ul>
									<ul>
										<li>팔로워</li>
										<li>${project_detail.followerCount} 명</li>
									</ul>
								</div>
							</div>
							<c:if test="${project_detail.creator_email ne sId}">
								<div class="btns">
									<%-- 팔로우 여부 판단 --%>
									<c:set var="isFollowing" value="false" />
									<c:forEach var="follower" items="${project_detail.followerList}">
										<c:choose>
										    <c:when test="${follower.follow_mem_email eq sId and follower.follow_status eq 'Y'}">
										        <c:set var="isFollowing" value="true" />
										    </c:when>
									    </c:choose>
									</c:forEach>
									
									<c:choose>
									    <c:when test="${isFollowing}"> <%-- 팔로우 중일 경우 --%>
									        <button type="button" class="unFollow" onclick="unfollow('${sId}','${project_detail.creator_email}')">팔로우 취소</button>
									    </c:when>
									    <c:otherwise>
									        <button type="button" class="follow" onclick="confirmFollow('${project_detail.creator_name}', '${project_detail.creator_email}')">팔로우</button>
									    </c:otherwise>
									</c:choose>
									<button type="button"  class="ask" onclick="chat('${project_detail.creator_email}')">문의</button>
								</div>
							</c:if>
						</div>
					</div>
					
					<div id="report">
						<span>문제가 있나요?</span>
						<img alt="이동" src="${pageContext.request.contextPath}/resources/image/right-arrow.png">
					</div>
					
					<c:if test="${today > project_detail.funding_start_date}">
						<div id="fundingOptions">
							<h4>후원 선택</h4>
							<div class="wrap">
								<%-- 일반후원은 클릭하면 바로 결제페이지로 이동 --%>
	<!-- 							<div class="reward" id="reward_default" onclick="location.href='FundInProgress?reward_amt=1000&reward_title=일반후원하기'"> -->
								<div class="reward" id="reward_default" style="<c:if test='${project_detail.funding_end_date < today or project_detail.creator_email eq sId}'>pointer-events: none; opacity: 0.5; cursor: not-allowed;</c:if>">
									<div class="reward_price"><fmt:formatNumber pattern="#,###">1000</fmt:formatNumber>원
										<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
									</div>
									<div class="reward_title">일반 후원하기</div>
									<form action="FundInProgress" method="get">
										<input type="hidden" value="${project_detail.pay_date}" name="project_payDate">
										<input type="hidden" value="${project_detail.project_idx}" name="funding_project_idx">
										<input type="hidden" value="0" name="funding_reward_idx">
										<input type="hidden" value="일반 후원하기" name="reward_title">
										<input type="hidden" value="1000" name="reward_price">
			<!-- 									<input type="hidden" value="" name="funding_item_option" class="funding_item_option"> -->
										<input type="submit" value="결정했어요!" class="rewardSubmitBtn">
									</form>
								</div>
								
								<c:forEach var="rewardList" items="${rewardList}">
									<div class="reward" style="<c:if test='${project_detail.funding_end_date < today or project_detail.creator_email eq sId}'>pointer-events: none; opacity: 0.5; cursor: not-allowed;</c:if>">
										<div class="reward_price"><fmt:formatNumber pattern="#,###">${rewardList.reward_price}</fmt:formatNumber>원
											<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
										</div> 
										<div class="reward_title">${rewardList.reward_title}</div>
										
										<form action="FundInProgress" method="get">
											<div class="reward_item_wrap">
												<c:forEach var="allRewardItems" items="${allRewardItems}">
													<c:if test="${allRewardItems.reward_idx eq rewardList.reward_idx}">
														<div class="reward_item">
															<div class="reward_item_name">${allRewardItems.item_name}</div>
															
															<!-- 옵션이 있으면 셀렉박스 표출됨 -->
															<div class="reward_item_option">
																<c:choose>
																	<c:when test="${allRewardItems.item_condition eq '객관식'}">
																		<select class="reward_item_option_select">
																			<option disabled hidden selected value="">옵션을 선택해주세요.</option>
																			<c:forEach var="itemOptions" items="${itemOptions}">
																				<option value="${itemOptions.splited_item_option}" >${itemOptions.splited_item_option}</option>
																			</c:forEach>
																		</select>
																	</c:when>
																	<c:otherwise>
																		<input type="text" placeholder="옵션을 입력해주세요." class="reward_item_option_write" >
																	</c:otherwise>
																</c:choose>
															</div>
														</div>
													</c:if>
												</c:forEach>
											</div>
											
			<%-- 										<input type="hidden" value="${project_detail.project_title}" name="project_title"> --%>
			<%-- 										<input type="hidden" value="${project_detail.project_code}" name="project_code"> --%>
											<input type="hidden" value="${project_detail.pay_date}" name="project_payDate">
											<input type="hidden" value="${project_detail.project_idx}" name="funding_project_idx" class="funding_project_idx">
											<input type="hidden" value="${rewardList.reward_idx}" name="funding_reward_idx" id="funding_reward_idx">
											<input type="hidden" value="${rewardList.reward_title}" name="reward_title">
											<input type="hidden" value="${rewardList.reward_price}" name="reward_price">
											<input type="hidden" value="" name="reward_option_title" class="reward_option_title">
											<input type="hidden" value="" name="funding_item_option" class="funding_item_option"> <%-- | 로 구분해서 넣을거임 --%>
											<input type="submit" value="결정했어요!" class="rewardSubmitBtn validate">
										</form>
										<div class="optionResult"></div>
									</div>
								</c:forEach>
							</div>
						</div>
					</c:if>
				</div>
			</section>
		</div>
		
		<div class="modal"> <!-- 신고 -->
		    <div class="modal_popup">
		        <h3>신고하기</h3>
	        	<span>어떤 문제가 있나요?</span><br>
		        <div class="content">
		        	<button value="지식재산권 침해" onclick="reportType(this.value, '${project_detail.project_title}', '${project_detail.project_code}')">
		        		<span class="repTitle">지식재산권 침해</span>
		        		<span class="repContent">
		        			타인의 지식재산권을 허락없이 사용했어요. <br>
							타인의 제품이나 콘텐츠를 동일하게 모방했어요.
		        		</span>
		        	</button>
		        	
		        	<button value="상세설명 내 허위사실" onclick="reportType(this.value, '${project_detail.project_title}', '${project_detail.project_code}')">
		        		<span class="repTitle">상세설명 내 허위사실</span>
		        		<span class="repContent">
		        			상품을 받아보니 상세설명과 다른 부분이 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="동일 제품의 타 채널 유통" onclick="reportType(this.value, '${project_detail.project_title}', '${project_detail.project_code}')">
		        		<span class="repTitle">동일 제품의 타 채널 유통</span>
		        		<span class="repContent">
		        			프로젝트 진행 전에 이미 판매한 적이 있는 제품이에요. <br>
							같은 제품을 다른 곳에서 (예약)판매하고 있어요.
		        		</span>
		        	</button>
		        	
		        	<button value="부적절한 콘텐츠" onclick="reportType(this.value, '${project_detail.project_title}', '${project_detail.project_code}')">
		        		<span class="repTitle">부적절한 콘텐츠</span>
		        		<span class="repContent">
		        			- 타인을 모욕, 명예훼손하는 콘텐츠 <br>
		        			- 개인정보를 침해하는 콘텐츠<br>
		        			- 차별, 음란, 범죄 등 불건전한 콘텐츠 <br>
		        			- 타사 유통 채널 광고. 홍보 목적의 콘텐츠
		        		</span>
		        	</button>
		        	
		        	<button value="기타" onclick="reportType(this.value, '${project_detail.project_title}', '${project_detail.project_code}')">
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
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		<script type="text/javascript">
			let modal = document.querySelectorAll('.modal');
			let report = document.querySelector('#report');
			let closeBtn = document.querySelectorAll('.close_btn');
			// ==========================================================================
			// 이 프로젝트 후원하기 클릭 시 스크롤 이동
			function goToScroll() {
			    let location = document.querySelector("#fundingOptions").offsetTop;
			    window.scrollTo({top: location, behavior: 'smooth'});
			}
			// ==========================================================================
			// 후원 선택 (옵션 띄우기)
			let reward = document.querySelectorAll(".reward");
			let reward_item = document.querySelectorAll(".reward_item");
			let reward_item_option = document.querySelectorAll(".reward_item_option");
			let reward_item_option_select = document.querySelectorAll(".reward_item_option_select");
			let reward_item_option_write = document.querySelectorAll(".reward_item_option_write");
			let rewardSubmitBtn = document.querySelectorAll(".rewardSubmitBtn.validate");
			let optionResult = document.querySelectorAll(".optionResult");
			
			$(reward).on('click', function() { 
				
				// 이미 on 클래스가 있는 리워드라면 (즉, 이미 선택된 상태라면) 아무것도 하지 않음
			    if ($(this).hasClass("on")) {
			        return; // 현재 선택된 리워드는 변경을 막지 않음
			    }
			    
			    // 자식 태그가 있는지 확인
			    if ($(".reward.on").find($(optionResult)).children().length > 0) {
			        alert("리워드를 변경하시면 옵션이 모두 삭제됩니다");
			        
			        $(optionResult).children().remove();
			    }
				
// 				console.log("reward clicked!"); // 확인 완료
				
				// 클릭한 리워드에 있는 아이템에 있는 옵션에 클래스 on 붙이기
				$(reward).removeClass("on");
				$(this).addClass("on");
				
				// 클릭 시 border 변경
				$(reward).css('border','2px solid #eee');
				
				if($(this).hasClass("on")){
					$(this).css('border','2px solid #ffab40');
				}
				
			});
			// ==========================================================================
			// 리워드 옵션 유효성 검사
			
			$(rewardSubmitBtn).on('click', function(e) { 
// 				e.preventDefault(); // submit 막는거
				updateHiddenTagValue();
				
				let this_reward = $(this).parents(".reward.on");
// 				console.log(this_reward.html());
				
				let rewardOptionSelect = $(this_reward).find($(reward_item_option)).find($(reward_item_option_select));
				if (rewardOptionSelect.length && rewardOptionSelect.val() == null) {
				    alert("옵션을 선택해주세요.");
				    rewardOptionSelect.focus();
				    
				    return false;
				}

				let rewardOptionWrite = $(this_reward).find($(reward_item_option)).find($(reward_item_option_write));
				if (rewardOptionWrite.length && rewardOptionWrite.val() == "") {
				    alert("옵션을 입력해주세요.");
				    rewardOptionWrite.focus();
				    
				    return false;
				}
				
			});
				
			// ------------------------------------------------------------------------
			$(reward_item_option).children().on('change', function() {
				let option_title = $(this).parent().siblings($(".reward_item_name")).text();
				
				if($(this).is(reward_item_option_select)){
					if($(".reward_item_option_select_value").length >= 1){
						alert("옵션은 1개만 선택가능합니다.");
						
						return ;
					}
					$(".reward.on").find($(optionResult)).append("<div class='reward_item_option_select_value'>" + option_title + " : " + $(this).val().trim() + "<span class='removeTag'><img src='${pageContext.request.servletContext.contextPath}/resources/image/removeTag.png'></span></div>");
				} 
				
				if ($(this).is(reward_item_option_write)){
					if($(".reward_item_option_write_value").length >= 1){
						alert("옵션은 1개만 입력가능합니다.");
						
						return;
					}
					
					$(".reward.on").find($(optionResult)).append("<div class='reward_item_option_write_value'>" + option_title + " : " + $(this).val().trim() + "<span class='removeTag'><img src='${pageContext.request.servletContext.contextPath}/resources/image/removeTag.png'></span></div>");
					
				}
				
				updateHiddenTagValue()
			});
			
			
			// ------------------------------------------------------------------------
			// ------------------------------------------------------------------------
			// hidden input 업데이트 함수
		    function updateHiddenTagValue() {
				let optionTitles = [];
				let options = [];
// 				console.log($(".optionResult").children().text());
				
				$(".optionResult").children().each(function() {
					optionTitles.push($(this).text().split(" : ")[0]);
				});
				
				$(".reward.on").find(".reward_option_title").val(optionTitles.join("|"));  //옵션명을 태그를 구분자 | 로 연결하여 hidden input에 설정
				
				
				$(".optionResult").children().each(function() {
					options.push($(this).text().split(" : ")[1]);
					console.log(options);
				});
				
				$(".reward.on").find(".funding_item_option").val(options.join("|"));  // 옵션을 구분자 | 로 연결하여 hidden input에 설정
			}
			
			
			// ------------------------------------------------------------------------
			// 옵션 제거
			$(document).on('click', '.removeTag', function () {
				$(this).parent().remove();
			});
		
	     	// 폼 로드 시 함수실행
		    updateHiddenTagValue();
				
			// ==========================================================================
			// 프로젝트 좋아요
			function registLike(project_code, sId) {
// 				console.log("project_code : " + project_code + ", sId : " + sId);
				if(confirm("프로젝트를 좋아요 하시겠습니까?")){
					$.ajax({
						url: "RegistLike",
						type : "POST",
						async:false, // 이 한줄만 추가해주시면 됩니다.
						data:{
							"like_project_code": project_code,
							"like_mem_email": sId
						},
						dataType: "json",
						success: function (response) {
							if(response.result){
								alert("좋아한 프로젝트에 추가되었습니다.");
								location.reload();
							} else if(!response.result) {
								alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
								location.href="MemberLogin";
							}
						}
					});
				}
			}
			
			// 프로젝트 좋아요 취소
			function cancelLike((project_code, sId) {
// 				console.log("project_code : " + project_code + ", sId : " + sId);
				$.ajax({
					url: "CancelLike",
					type : "POST",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"like_project_code": project_code,
						"like_mem_email": sId
					},
					dataType: "json",
					success: function (response) {
						if(response.result){
							alert("좋아요가 취소되었습니다.");
							location.reload();
						} else if(!response.result) {
							alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
							location.href="MemberLogin";
						}
					}
				});
			}
	     	
			// ==========================================================================
			// 팔로우 - AJAX
			function confirmFollow(creatorName, creatorEmail){
				
				if(confirm(creatorName + "님을 팔로우 하시겠습니까?")){
					
					$.ajax({
						url: "CommitFollow",
						type : "POST",
						async: false, // 이 한줄만 추가해주시면 됩니다.
						data: {
							"follow_creator": creatorEmail
						},
						dataType: "json",
						success: function (response) {
							console.log("성공 : " + JSON.stringify(response))
							if(response.result) {
								alert("성공적으로 팔로우했습니다.");
								location.reload();
							} else if(!response.result) {
								alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
								location.href="MemberLogin";
							}
						}, error : function () {
							alert("실패! ");
						}
					});
				}
			}
			
			// ---------------------------------------------------------------
			// 언팔로우 - AJAX
			function unfollow(sId, creatorEmail){
				
				if(confirm("팔로우를 취소하시면 더 이상 프로젝트 공개 알림을 받으실 수 없습니다. \n팔로우를 취소하시겠습니까?")){
					
					$.ajax({
						url: "UnFollow",
						type : "POST",
						async: false, // 이 한줄만 추가해주시면 됩니다.
						data: {
							"follow_mem_email": sId,
							"follow_creator": creatorEmail,
						},
						dataType: "json",
						success: function (response) {
							if(response.result) {
								alert("팔로우가 취소되었습니다.");
								location.reload();
							} 
						}, error : function () {
							alert("실패! ");
						}
					});
				}
			}
	     	
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
			function reportType(type, title, project_code){
// 				console.log(type); // 오케이 .. 뜬다..
				$.ajax({
					url: "ReportForm",
					type : "get",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"type": type,
						"project_title": title,
						"project_code": project_code
					},
					dataType: "json",
					success: function (response) {
						let content = $(".modal.on").find($(".modal_popup")).find($(".content"));
						content.html("<div id='resultArea'></div>");
						
						writeReportForm(response.type, response.project_title, response.project_code);
						
						console.log(response.project_title);
					}, error : function (response) {
						alert("실패! ");
					}
				});
				
			}
			
			function writeReportForm(type, title, project_code){
				$.ajax({
					url: "ReportWriteForm",
					type : "get",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"type": type,
						"project_title": title,
						"project_code": project_code
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
			
		</script>
	</body>
</html>




















