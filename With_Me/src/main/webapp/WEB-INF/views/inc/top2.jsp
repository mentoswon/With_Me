<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
	/*모달 팝업 영역 스타일링*/
	.profile {
	/*팝업 배경*/
		display: none; /*평소에는 보이지 않도록*/
	    position: absolute;
	    top:0;
	    left: 0;
	    width: 100%;
	    height: 140vh;
	    overflow: hidden;
	}
	.profile .profile_popup {
	/*팝업*/
		border: 1px solid #ccc;
	    position: absolute;
	    width: 150px;
	    top: 11%;
	    left: 76.5%;
	    transform: translate(-50%, -50%);
	    padding: 20px;
	    background: #ffffff;
	}
	.profile .profile_popup ul>li {
		margin-bottom: 15px;
	}
	.profile .profile_popup ul>li>a:hover {
		color: skyblue;
	}
	.profile .profile_popup .close_btn {
	    padding: 2.5px 5px;
	    background-color: skyblue;
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	.profile.on {display: block;}
</style>
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
	
	function projectList(category, category_detail) {
		if(category_detail != "") {
			location.href="ProjectList?project_category=" + category + "&project_category_detail=" + category_detail;
		} else {
			location.href="ProjectList?project_category=" + category;
		}
	}
	
// 	function projectListDetail(cateDetail) {
// 		location.href="ProjectListDetail?project_category_detail=" + cateDetail;
// 	}
	
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
					<button class="btn" onclick="location.href='MemberLogin'">로그인</button>
<!-- 					<button class="btn" onclick="location.href='MemberJoin'">회원가입</button> -->
					<button class="btn" onclick="location.href='StoreList'">스토어</button>
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:when>
				<c:otherwise>
					<%-- 관리자 여부에 따라 이름 클릭 시 동작 구분 --%>
					<c:choose>
						<%-- 관리자일 경우 관리자메인페이지로 포워딩 --%>
						<c:when test="${sessionScope.sIsAdmin eq 'Y'}">
							<a href="AdminMain" class="loged">${sessionScope.sName}님</a>
						</c:when>
						<%-- 관리자가 아닐 경우(=일반 회원일 경우) 프로필 팝업 출력 --%>
						<c:otherwise>
							<%-- 하이퍼링크 상에서 자바스크립트 함수 호출 시 "javascript:함수명()" 형태로 호출 --%>
							<a href="javascript:ProfilePopupOpen()" class="loged">${sessionScope.sName}님</a>
						</c:otherwise>
					</c:choose>
					<a href="javascript:confirmLogout()" class="loged">로그아웃 </a>
					<button class="btn" onclick="location.href='StoreList'">스토어</button>
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
	
	<%-- 회원명 클릭시 출력되는 팝업 --%>
	<div class="profile">
		<div class="profile_popup">
			<ul>
				<%-- 각 메뉴에 맞는 서블릿 주소 매핑 --%>
				<li class="depth01"><a href="MemberInfo">프로필</a></li>
				<li class="depth01"><a href="MyProject">내가 만든 프로젝트</a></li>
				<li class="depth01"><a href="MyChat">메시지</a></li>
			</ul>
			<div class="btnArea" style="text-align : center">
	        	<input type="button" class="close_btn" value="닫기" onclick="ProfilePopupClose()">
	        </div>
		</div>
	</div>
	
	<nav>
		<ul>
			<li class="depth01">
				<a href="javascript:projectList('푸드', '')"> 푸드 </a>
				<ul class="depth02">
					<li><button value="사료" onclick="projectList('푸드', this.value)" >사료</button></li>
					<li><button value="껌류" onclick="projectList('푸드', this.value)" >껌류</button></li>
					<li><button value="수제간식" onclick="projectList('푸드', this.value)" >수제간식</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('패션/위생', '')"> 패션 / 위생 </a>
				<ul class="depth02">
					<li><button value="의류" onclick="projectList('패션/위생',this.value)" >의류</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('식기/급수기', '')"> 식기 / 급수기 </a>
				<ul class="depth02">
					<li><button value="급식기" onclick="projectList('식기/급수기',this.value)" >급식기</button></li>
					<li><button value="급수기" onclick="projectList('식기/급수기',this.value)" >급수기</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('장난감/훈련', '')"> 장난감 / 훈련 </a>
				<ul class="depth02">
					<li><button value="장난감" onclick="projectList('장난감/훈련',this.value)" >장난감</button></li>
					<li><button value="훈련용품" onclick="projectList('장난감/훈련',this.value)" >훈련용품</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('하우스/안전', '')"> 하우스 / 안전 </a>
				<ul class="depth02">
					<li><button value="하우스" onclick="projectList('하우스/안전',this.value)" >하우스</button></li>
					<li><button value="울타리" onclick="projectList('하우스/안전',this.value)" >울타리</button></li>
					<li><button value="기타안전용품" onclick="projectList('하우스/안전',this.value)" >기타안전용품</button></li>
				</ul>
			</li>
		</ul>
		
		<%-- 검색 form 태그 추가 예정 --%>
		<form action="ProjectList">
			<input type="text" id="search" name="searchKeyword" value="${param.searchKeyword}">
			<input type="submit" id="searchBtn" value="">		
		</form>
	</nav>
</div>

<script>
	let profile = document.querySelectorAll('.profile');
	// 프로필 팝업 띄우기
	function ProfilePopupOpen() {
		profile[0].classList.add('on');
	}
	// 프로필 팝업 닫기 - 팝업창 바깥을 클릭했을 경우
	let isClicked = true;
	$(".profile").click(function() {
		$(".profile_popup").click(function() { // 페이지 새로고침 후 처음 한번은 함수가 작동하지 않는 현상이 있음
			isClicked = false;                 // (두번째부터는 정상적으로 작동함)
		});
// 		console.log("isClicked : " + isClicked);
		if(isClicked) {
			profile[0].classList.remove('on');
		} else {
			isClicked = true;
		}
	});
	// 프로필 팝업 닫기 - 닫기 버튼을 클릭했을 경우
	function ProfilePopupClose() {
		profile[0].classList.remove('on');
	}
</script>


