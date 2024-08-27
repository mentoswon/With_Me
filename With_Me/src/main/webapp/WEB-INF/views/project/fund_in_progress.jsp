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
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/fund_in_progress.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<%-- 다음 우편번호 API --%>
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<script type="text/javascript">
			// 주소 검색 API 활용 기능 추가
			// "t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js" 스크립트 파일 로딩 필수!
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
		</script>
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<h2>${member.mem_name} 후원자님! 다시 한 번 확인해주세요.</h2>
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
			
			<section class="con02">
				<div class="addressInfo">
					<h4>배송지</h4>
<%-- 					<c:choose> --%>
<%-- 						<c:when test="${empty userAddress}"> --%>
							<div class="AddAddressBtn">
								<img class="more" alt="추가" src="${pageContext.request.contextPath}/resources/image/plus.png">
								&nbsp;&nbsp;&nbsp; 배송지 추가
							</div>
<%-- 						</c:when> --%>
	
<%-- 						<c:otherwise> --%>
							<%-- address 테이블에서 가져와서 반복 --%>
							<div class="infoWrapper">
								<c:forEach var="userAddress" items="${userAddress}">
									<div class="addressWrapper">
										<div class="left">
											<div>${userAddress.address_receiver_name}</div>											
											<div>[${userAddress.address_post_code}] ${userAddress.address_main}</div>											
											<div>${userAddress.address_sub}</div>											
										</div>
										<div class="changeAddressBtn">변경</div>
									</div>
								</c:forEach>
							</div>
<%-- 						</c:otherwise> --%>
<%-- 					</c:choose> --%>
				</div>
			</section>
			
			<section class="con03">
				<div class="moreFundAmt">
					<h4>추가 후원(선택)</h4>
					<div class="infoWrapper">
						<div>
							<div>후원금</div>
							<input type="text" name="" class="moreFundAmt"> 원
							
						</div>
					</div>
				</div>
			</section>
		</div>
		
		<!-- 배송지 추가 -->
		<div class="modal"> 
		    <div class="modal_popup">
		        <h3>배송지 추가</h3>
		        <div class="content add">
		        	<form action="RegistAddress" method="post">
			        	<div>
			        		<span>받는 사람</span>
			        		<input type="text" placeholder="받는 분 성함을 입력해주세요." name="address_receiver_name">
			        	</div>
			        	
			        	<div>
			        		<span>주소</span>
							<br>
			        		<input type="text" name="address_post_code" id="address_post_code" placeholder="우편번호">
			        		<button id="address_search_btn">주소 검색</button>
							<br>
							<input type="text" name="address_main" id="address_main" placeholder="기본주소">
							<br>
							<input type="text" name="address_sub" id="address_sub" placeholder="상세주소">
			        	</div>
			        	
			        	<div>
			        		<span>받는 사람 휴대폰 번호</span>
			        		<br>
			        		<input type="text" name="address_receiver_tel" placeholder="받는 분 휴대폰 번호를 입력해주세요.">
			        	</div>
			        	
			        	<div>
			        		<label><input type="checkbox" name="address_is_default" id="isDefault">기본배송지로 등록</label>
			        	</div>
			        	<input type="hidden" name="address_mem_email" value="${member.mem_email}">
			        	
			        	<input type="submit" value="배송지 등록" id="addRegBtn">
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
		        	<c:forEach var="userAddress" items="${userAddress}">
		        		<div class="infoWrapper">
			        		<label>
			        			<input type="radio" name="address">
								<div class="addressWrapper">
									<div>${userAddress.address_receiver_name}</div>											
									<div>[${userAddress.address_post_code}] ${userAddress.address_main}</div>											
									<div>${userAddress.address_sub}</div>											
								</div>
							</label>
						</div>
					</c:forEach>
				</div>
   				<img alt="닫기" src="${pageContext.request.contextPath}/resources/image/close.png" class="close_btn">
		    </div>
		</div>
		
		
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
		
		<script type="text/javascript">
			let modal = document.querySelectorAll('.modal');
			let AddAddressBtn = document.querySelectorAll('.AddAddressBtn');
			let changeAddressBtn = document.querySelectorAll('.changeAddressBtn');
			let closeBtn = document.querySelectorAll('.close_btn');
			// -------------------------------------------------------------------------
			// 팝업 오픈
			$(AddAddressBtn).on('click', function() { 
				$($(modal)[0]).addClass("on");
			});
			
			$(changeAddressBtn).on('click', function() { 
				$($(modal)[1]).addClass("on");
			});
			// -------------------------------------------------------------------------
			// 닫기 버튼
			$(closeBtn).on('click', function() { 
				$(modal).removeClass("on");
			});
			
			
		</script>
	</body>
</html>




















