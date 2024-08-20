<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>위드미 | 프로젝트 등록</title>
<%-- 외부 CSS 파일 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
$(function() {

    // 메뉴 항목 클릭 시 활성화 처리
    $("#MypageMenuList li").click(function() {
        $(".writeContainer").hide();	// 모든 .writeContainer 숨기기
        $("#MypageMenuList li").removeClass("active");
        $(this).addClass("active");	// 클릭된 항목에 active 클래스 추가
        let index = $(this).data("index");	// 클릭된 메뉴 항목의 인덱스
        $("#writeContainer" + index).show();	// 해당 인덱스에 해당하는 콘텐츠 영역만 보이기
    });
	
	// 임시) 초기 상태로 두 번째 메뉴와 콘텐츠가 보이도록 설정
    $("#MypageMenuList li:eq(0)").click();
    
});	// ready 이벤트 끝

</script>

</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<section id="MemberInfo">
		<div id="projectInfoWrap">
			<div id="MypageMenuTop">
				<div>
					<h2>gg${project.project_title}</h2>
					<input type="button" value="내정보" onclick="location.href='MypageInfo'">
					<p style="line-height: 200%;">${project.project_category}</p>
				</div>
			</div>
		</div>
	</section>
	<section id="MemberMypage">
		<div id="MypageMenuWrap">
			<div id="MypageMenu">
				<ul id="MypageMenuList">
					<li class="writeList active" data-index="1">
						<span>프로필</span>
					</li>
					<li class="writeList" data-index="2">
						<span>좋아요</span>
					</li>
					<li class="writeList" data-index="3">
						<span>올린 프로젝트</span>
					</li>
					<li class="writeList" data-index="4">
						<span>후원한 프로젝트</span>
					</li>
					<li class="writeList" data-index="5">
						<span>팔로워</span>
					</li>
					<li class="writeList" data-index="6">
						<span>팔로잉</span>
					</li>
				</ul>
			</div>
		</div>
	</section>
	
	<article>
		<div id="writeContainer1" class="writeContainer">
			<div class="MypageWriteWrap">
				<div class="MypageExplanationWrap">
					<p>
						등록된 소개가 없습니다.
					</p>
				</div>
			</div>
		</div>
	</article>
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
