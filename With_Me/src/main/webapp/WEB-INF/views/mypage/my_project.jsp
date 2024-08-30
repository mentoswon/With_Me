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
	color: #fff;
}
#statusMenu li.selected  {
	background-color: #FFAB40;
	border-color: #FFAB40;
	color: #fff;
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
	// "전체" 항목을 기본 선택된 상태로 설정
	$("#statusMenu li.all").addClass("selected");
	
	// 상태 메뉴의 각 버튼 클릭 이벤트
	$("#statusMenu li").on("click", function() {
		// 모든 항목에서 'selected' 클래스 제거
		$("#statusMenu li").removeClass("selected");
		// 클릭된 항목에 'selected' 클래스 추가
		$(this).addClass("selected");
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
					<li class="review">심사중</li>
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
		    <c:choose>
		        <c:when test="${not empty projectList}">
					<%-- 각 project_status에 대한 플래그 변수 초기화 --%>
					<c:set var="isWritingDisplayed" value="false" />
					<c:set var="isSubmittedDisplayed" value="false" />
					<c:set var="isApprovedDisplayed" value="false" />
					
					<c:forEach var="project" items="${projectList}">
						<%-- '작성중' 상태의 프로젝트 목록 --%>
						<c:if test="${project.project_status eq '작성중'}">
							<c:if test="${not isWritingDisplayed}">
							<h2>작성중</h2><br>
							<c:set var="isWritingDisplayed" value="true" />
						</c:if>
					
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
							            <input type="button" class="delete" value="삭제">
							        </form>
							    </div>
							</div>
							<br><br>
						</c:if>
					
					<%-- '제출됨' 상태의 프로젝트 목록 --%>
					<c:if test="${project.project_status eq '제출됨'}">
					<c:if test="${not isSubmittedDisplayed}">
					<h2>제출됨</h2><br>
					<c:set var="isSubmittedDisplayed" value="true" />
					</c:if>
					
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
					            <input type="button" class="delete" value="삭제">
					        </form>
					    </div>
					</div>
					<br><br>
					</c:if>
					
					<%-- '승인됨' 상태의 프로젝트 목록 --%>
					<c:if test="${project.project_status eq '승인됨'}">
					<c:if test="${not isApprovedDisplayed}">
					<h2>승인됨</h2><br>
					<c:set var="isApprovedDisplayed" value="true" />
					</c:if>
					
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
					            <input type="button" class="delete" value="삭제">
					        </form>
					    </div>
					</div>
					<br><br>
					</c:if>
					</c:forEach>
					</c:when>
					<c:otherwise>
					<p>프로젝트가 없습니다.</p>
					</c:otherwise>
		    </c:choose>
		</div>

	</article>
	
	
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
