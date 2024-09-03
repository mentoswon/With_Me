<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	function confirmLogout() {
		let isLogout = confirm("로그아웃 하시겠습니까?");

		// isLogout 변수값이 true 일 경우 로그아웃 작업을 수행할
		// "MemberLogout" 서블릿 요청
		if (isLogout) {
			location.href = "MemberLogout";
		}
	}
	
	function StoreList(productCategory, productCategory_detail) {
		if(productCategory_detail != "") {
			location.href="StoreList?product_category=" + productCategory + "&product_category_detail=" + productCategory_detail;
		} else {
			location.href="StoreList?product_category=" + productCategory;
		}
	}
	
	$(function (){
		$(".storeBtn").on('click', function StoreList() {
	   		StoreList('푸드', '');
		});
	});	
	
</script>

<div class="inner">
	<div id="member_area">
		<a href="./" class="main_logo">
			<img alt="로고" src="${pageContext.request.contextPath}/resources/image/withme.png">
		</a>
		<%-- session 아이디 존재 여부를 판별하여 각각 다른 링크 표시  --%>
		<%-- EL의 sessionScope 내장 객체 접근하여 sId 속성값 존재 여부 판별 --%>
		<div>
			<c:choose>
				<c:when test="${empty sessionScope.sId}"> <%-- 로그인 상태가 아닐 경우 --%>
<!-- 					<button class="btn" onclick="location.href='StoreList'">스토어</button> -->
					<button onclick="StoreList('푸드', '')" class="btn storeBtn" id="storeButton"> 스토어 </button>
					<button class="btn" onclick="location.href='MemberLogin'">로그인</button>
<!-- 					<button class="btn" onclick="location.href='MemberJoin'">회원가입</button> -->
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:when>
				<c:otherwise>
					<%-- 아이디 클릭 시 회원 상세정보 조회를 위한 "MemberInfo.me" 서블릿 요청 --%>
					<a href="MemberInfo" class="loged">${sessionScope.sName}님</a>
					<a href="javascript:confirmLogout()" class="loged">로그아웃 </a>
<!-- 					<button class="btn" onclick="location.href='StoreList'">스토어</button> -->
					<button onclick="StoreList('푸드', '')" class="btn storeBtn" id="storeButton"> 스토어 </button>
					<%-- 하이퍼링크 상에서 자바스크립트 함수 호출 시
					"javascript:함수명()" 형태로 호출 --%>
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:otherwise>
			</c:choose>
	 		<c:if test="${sessionScope.sIsAdmin eq 'Y'}">
				<button class="btn" onclick="location.href='AdminMain'">관리자페이지</button>
			</c:if>
		</div>
	</div>
	
	<nav>
		
		<ul>
			<li class="depth01">
				<a href="javascript:StoreList('푸드', '')"> 푸드 </a>
				<ul class="depth02">
					<li><button value="사료" onclick="StoreList('푸드', this.value)" >사료</button></li>
					<li><button value="껌류" onclick="StoreList('푸드', this.value)" >껌류</button></li>
					<li><button value="수제간식" onclick="StoreList('푸드', this.value)" >수제간식</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:StoreList('패션/위생', '')"> 패션 / 위생 </a>
				<ul class="depth02">
					<li><button value="의류" onclick="StoreList('패션/위생',this.value)" >의류</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:StoreList('식기/급수기', '')"> 식기 / 급수기 </a>
				<ul class="depth02">
					<li><button value="급식기" onclick="StoreList('식기/급수기',this.value)" >급식기</button></li>
					<li><button value="급수기" onclick="StoreList('식기/급수기',this.value)" >급수기</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:StoreList('장난감/훈련', '')"> 장난감 / 훈련 </a>
				<ul class="depth02">
					<li><button value="장난감" onclick="StoreList('장난감/훈련',this.value)" >장난감</button></li>
					<li><button value="훈련용품" onclick="StoreList('장난감/훈련',this.value)" >훈련용품</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:StoreList('하우스/안전', '')"> 하우스 / 안전 </a>
				<ul class="depth02">
					<li><button value="하우스" onclick="StoreList('하우스/안전',this.value)" >하우스</button></li>
					<li><button value="울타리" onclick="StoreList('하우스/안전',this.value)" >울타리</button></li>
					<li><button value="기타안전용품" onclick="StoreList('하우스/안전',this.value)" >기타안전용품</button></li>
				</ul>
			</li>
		</ul>
		
		<%-- 검색 form 태그 추가 예정 --%>
		<form action="StoreList">
			<input type="text" id="search" name="searchKeyword" value="${param.searchKeyword}">
			<input type="submit" id="searchBtn" value="">		
		</form>
	</nav>
</div>


