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
	
</script>

<div class="inner">
	<div id="member_area">
		<a href="./" class="main_logo"><img src=""></a>
		<%-- session 아이디 존재 여부를 판별하여 각각 다른 링크 표시  --%>
		<%-- EL의 sessionScope 내장 객체 접근하여 sId 속성값 존재 여부 판별 --%>
		<c:choose>
			<c:when test="${empty sessionScope.sId}"> <%-- 로그인 상태가 아닐 경우 --%>
				<button class="btn">스토어</button>
				<button class="btn">로그인/회원가입</button>
				<button class="btn">프로젝트 만들기</button>
			</c:when>
			<c:otherwise>
				<%-- 아이디 클릭 시 회원 상세정보 조회를 위한 "MemberInfo.me" 서블릿 요청 --%>
				| <a href=""></a>님
				<%-- 하이퍼링크 상에서 자바스크립트 함수 호출 시
				"javascript:함수명()" 형태로 호출 --%>
				| <a href="javascript:confirmLogout()">로그아웃 </a>
			</c:otherwise>			
		</c:choose>
		<c:if test="">
			| <a href="">관리자페이지</a>
		</c:if>
	</div>
	
	<nav>
		
		<ul>
			<li class="depth01">
				<a href=""> 푸드 </a>
				<ul class="depth02">
					<li><a href="">사료</a></li>
					<li><a href="">껌류</a></li>
					<li><a href="">수제간식</a></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href=""> 패션 / 위생 </a>
				<ul class="depth02">
					<li><a href="">메뉴1</a></li>
					<li><a href="">메뉴2</a></li>
					<li><a href="">메뉴3</a></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href=""> 식기 / 급수기 </a>
				<ul class="depth02">
					<li><a href="">메뉴1</a></li>
					<li><a href="">메뉴2</a></li>
					<li><a href="">메뉴3</a></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href=""> 장난감 / 훈련 </a>
				<ul class="depth02">
					<li><a href="">메뉴1</a></li>
					<li><a href="">메뉴2</a></li>
					<li><a href="">메뉴3</a></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href=""> 하우스 / 안전 </a>
				<ul class="depth02">
					<li><a href="">메뉴1</a></li>
					<li><a href="">메뉴2</a></li>
					<li><a href="">메뉴3</a></li>
				</ul>
			</li>
		</ul>
		
		<input type="search" id="search">
	</nav>
</div>


