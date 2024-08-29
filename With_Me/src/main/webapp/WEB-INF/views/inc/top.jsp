<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
	/*모달 팝업 영역 스타일링*/
	.modal {
	/*팝업 배경*/
		display: none; /*평소에는 보이지 않도록*/
	    position: absolute;
	    top:0;
	    left: 0;
	    width: 100%;
	    height: 140vh;
	    overflow: hidden;
	}
	.modal .modal_popup {
	/*팝업*/
		border: 1px solid #ccc;
	    position: absolute;
	    width: 150px;
	    top: 11.5%;
	    left: 76.5%;
	    transform: translate(-50%, -50%);
	    padding: 20px;
	    background: #ffffff;
	}
	.modal .modal_popup ul>li {
		margin-bottom: 15px;
	}
	.modal .modal_popup ul>li>a:hover {
		color: skyblue;
	}
	.modal .modal_popup .close_btn {
	    padding: 2.5px 5px;
	    background-color: skyblue;
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	.modal.on {display: block;}
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
					<%-- 아이디 클릭 시 회원 상세정보 조회를 위한 "MemberInfo.me" 서블릿 요청 --%>
					<c:choose>
						<c:when test="${sessionScope.sIsAdmin eq 'Y'}">
							<a href="AdminMain" class="loged">${sessionScope.sName}님</a>
						</c:when>
						<c:otherwise>
							<%-- 하이퍼링크 상에서 자바스크립트 함수 호출 시 "javascript:함수명()" 형태로 호출 --%>
							<a href="javascript:ModalPopup()" class="loged">${sessionScope.sName}님</a>
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
	<div class="modal">
		<div class="modal_popup">
			<ul>
				<li class="depth01"><a href="MemberInfo">프로필</a></li>
				<li class="depth01"><a href="MyProject">내가 만든 프로젝트</a></li>
				<li class="depth01"><a href="MyChat">메시지</a></li>
			</ul>
			<div class="btnArea" style="text-align : center">
	        	<input type="button" class="close_btn" value="닫기">
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
	let modal = document.querySelectorAll('.modal');
	let closeBtn = document.querySelectorAll('.close_btn');
	// 팝업 띄우기
	function ModalPopup() {
		modal[0].classList.add('on');
	}
	// 팝업 닫기
	for(let i = 0; i < closeBtn.length ; i++) {
		closeBtn[i].onclick = function(){
			modal[i].classList.remove('on');
		}
	}
</script>


