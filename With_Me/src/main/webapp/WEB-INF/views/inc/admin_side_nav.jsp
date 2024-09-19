<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<nav class="side_nav">
	<ul>
		<li><a href="AdminMemberList" id="GoHome">관리자페이지 홈</a></li>
		<li class="depth01">
			<a href="javascript:showDepth02(0)">회원관리</a>
			<ul class="adminDepth02">
				<li><a href="AdminMemberList">회원목록</a></li>
			</ul>
		</li>
		<li class="depth01">
			<a href="javascript:showDepth02(1)">프로젝트관리</a>
			<ul class="adminDepth02">
				<li><a href="AdminProjectList?status=등록대기">등록신청관리</a></li>
				<li><a href="AdminProjectList?status=진행중">진행중인 프로젝트</a></li>
				<li><a href="AdminProjectList?status=종료">종료된 프로젝트</a></li>
				<li><a href="AdminProjectList?status=취소">취소된 프로젝트</a></li>
			</ul>
		</li>
		<li class="depth01">
			<a href="javascript:showDepth02(2)">스토어관리</a>
			<ul class="adminDepth02">
				<li><a href="AdminStore">스토어 상품 등록</a></li>
				<li><a href="AdminStoreOrder">스토어 상품 주문내역</a></li>
			</ul>
		</li>
		<li class="depth01">
			<a href="javascript:showDepth02(3)">정산관리</a>
			<ul class="adminDepth02">
				<li><a href="AdminAccountList?status=출금대기">출금이체 대기중인 프로젝트</a></li>
				<li><a href="AdminAccountList?status=입금대기">입금이체 대기중인 프로젝트</a></li>
				<li><a href="AdminAccountList?status=입금완료">정산완료된 프로젝트</a></li>
			</ul>
		</li>
		<li class="depth01">
			<a href="javascript:showDepth02(4)">게시판관리</a>
			<ul class="adminDepth02">
				<li><a href="AdminNotice">공지사항</a></li>
<!-- 				<li><a href="AdminCs">자주 묻는 질문</a></li> -->
				<li><a href="AdminFAQ">1:1 문의</a></li>
				<li><a href="AdminReport">신고관리</a></li>
			</ul>
		</li>
		<li class="depth01">
			<a href="javascript:showDepth02(5)">카테고리 관리</a>
			<ul class="adminDepth02">
				<li><a href="CommonCode">카테고리 추가</a></li>
			</ul>
		</li>
	</ul>
</nav>
<script>
	let adminDepth02 = document.querySelectorAll(".adminDepth02");
	
	function showDepth02(num) {
		if(adminDepth02[num].classList.item(1) == null) {
			for(let i = 0; i < adminDepth02.length; i++) {
				adminDepth02[i].classList.remove("show");
			}
			adminDepth02[num].classList.add("show");
		} else {
			for(let i = 0; i < adminDepth02.length; i++) {
				adminDepth02[i].classList.remove("show");
			}
		}
	}
</script>