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
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style type="text/css">
article {
    width: 1080px;
    margin: 0 auto;
    position: relative;
}

#topWrap {
	text-align: left;
	width: 100%;
	margin: 20px 0;
	
}
#topWrap h4 {
	font-size: 32px;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
	margin-bottom: 30px;
}

/* ----- 진행상태 필터버튼 ----- */
#statusMenu ul {
	list-style-type: none;
	padding: 0;
	margin: 0;
	display: flex;
	gap: 10px;	/* 항목 사이 간격 */
}

#statusMenu li {
	width: 60px;
	padding: 10px 15px;
	background-color: #fff;
	border: 2px solid #ccc;
	border-radius: 23px;
	cursor: pointer;
	text-align: center;
	caret-color: transparent;	/* 커서 깜빡임 없애기 */
}

#statusMenu li:hover {
	background-color: #FFAB40;
	border-color: #FFAB40;
}

/* 프로젝트 리스트 영역 */
.projectWrap {
	display: flex;
 	justify-content: space-between;
    align-items: center;
    gap: 20px;
	border: 3px solid #ccc;
	padding: 20px;
}
.projectWrap p {
	line-height: 300%;	/* 줄간격 */
}
.projectImage {
	width: 250px;
	height: 200px;
}
.projectImage img {
	width: 100%;
	height: 100%;
	border-radius: 5px;
}

.projectContent {
	width: 550px;
}

.management, .delete {
	width: 150px;
	height: 50px;
	margin: 10px;
	border-radius: 10px;
	font-size: 16px;
}
.management {	/* 관리 */
	border: none;
	background-color: #FFAB40;
}

.delete {	/* 삭제 */
	background-color: #ffffff;
	border: 2px solid #ccc;
}

.management:hover, .delete:hover {
	cursor: pointer;
	box-shadow: 0 2px 5px rgba(0,0,0,0.3);
}


</style>
<script type="text/javascript">
$(function() {
	// 상태 메뉴의 각 버튼 클릭 이벤트
	$("#statusMenu li").on("click", function() {
		let status = $(this).attr("class");  // 클릭된 버튼의 클래스를 통해 상태를 가져옴
		
		// AJAX 요청
		$.ajax({
			url: "ProjectList",
			method: "POST",
			contentType: "json",
			data: { status: status },
			success: function(response) {
				// 서버에서 받은 프로젝트 리스트를 기반으로 DOM 업데이트
				updateProjectList(response);
			},
			error: function() {
				alert("프로젝트 리스트를 가져오는 데 실패했습니다.");
		    }
		});
	});
	
	// 프로젝트 리스트 업데이트 함수
	function updateProjectList(projects) {
		 var projectListContainer = $("#projectListContainer");
		 projectListContainer.empty();  // 기존 리스트 초기화
		
		 // 서버에서 받은 각 프로젝트 데이터로 리스트 생성
		 projects.forEach(function(project) {
		     var projectItem = 
		     	``;
			projectListContainer.append(projectItem);
		 });
	}

	
	
});	// ready 이벤트 끝

</script>

</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<%-- ---------- 프로젝트 등록 메뉴바 ---------- --%>
	<article>
		<div id="topWrap">
			<h4>내가 만든 프로젝트</h4>
			<div id="statusMenu">
				<ul>
					<li class="all">전체</li>
					<li class="writing">작성중</li>
					<li class="underReview">심사중</li>
					<li class="approve">승인됨</li>
					<li class="refuse">반려됨</li>
					<li class="reveal">공개예정</li>
					<li class="ongoing">진행중</li>
					<li class="terminate">종료됨</li>
				</ul>
			</div>
		</div>
		
		<%-- ---------- 프로젝트 리스트 표시할 영역 ---------- --%>
		<div id="projectListContainer">
			<h2>작성중</h2><br>
			<c:forEach var="project" items="${projectList}">
				<c:if test="${project.project_status eq '작성중'}">
					<div class="projectWrap">
						<div class="projectImage">
							<c:choose>
								<c:when test="${empty project.project_image}">
									<img alt="기본이미지" src="${pageContext.request.contextPath}/resources/image/image.png">
								</c:when>
								<c:otherwise>
									<img alt="프로젝트대표이미지" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
								</c:otherwise>
							</c:choose>
						</div>
						<div class="projectContent">
							<h2>${project.project_title}</h2>
							<p>${project.project_summary}</p>
						</div>
						<div class="btnWrap">
							<form action="ProjectCreate" method="post">
								<input type="hidden" name="project_idx" value="${project.project_idx}">
								<input type="button" class="management" value="관리"><br>
								<input type="button" class="delete"  value="삭제">
							</form>
						</div>
					</div>
				</c:if>
				<br><br>
			</c:forEach>
			
			
		</div>
	</article>
	
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
