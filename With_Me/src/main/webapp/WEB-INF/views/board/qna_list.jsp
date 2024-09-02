<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 1:1 문의내역</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link
	href="${pageContext.request.contextPath}/resources/css/default.css"
	rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/qna_list.css" rel="stylesheet" type="text/css">
<style type="text/css">
/* #listForm { */
/* 	width: 1024px; */
/* 	max-height: 610px; */
/* 	margin: auto; */
/* } */

/* h2 { */
/* 	text-align: center; */
/* } */

/* table { */
/* 	margin: auto; */
/* 	width: 1024px; */
/* } */

/* #tr_top { */
/* 	background: orange; */
/* 	text-align: center; */
/* } */

/* table td { */
/* 	text-align: center; */
/* } */

/* #pageList { */
/* 	margin: auto; */
/* 	width: 1024px; */
/* 	text-align: center; */
/* } */

/* #emptyArea { */
/* 	margin: auto; */
/* 	width: 1024px; */
/* 	text-align: center; */
/* } */

/* #myListForm { */
/* 	margin: auto; */
/* 	width: 1024px; */
/* 	text-align: right; */
/* } */

/* /* 하이퍼링크 밑줄 제거 */ 
/* a { */
/* 	text-decoration: none; */
/* } */

/* /* 제목 열 좌측 정렬 및 여백 설정 */ 
/* #subject { */
/* 	text-align: left; */
/* 	padding-left: 20px; */
/* } */
</style>
</head>
<body>
	<header>
		<%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
		<div class="mainWrapper">
		<div class="main" align="center">
			<section class="boardTitle" id="board_title">
				<div align="left">
				<!-- 게시판 리스트 -->
				<h2>1:1문의</h2>
				</div>
			
				<div align="right">
					<%-- ============================================================================ --%>
					<%-- ======================= [ 게시물 검색 기능 추가 ] ========================== --%>
					<%-- 검색 기능을 위한 폼 생성 --%>
					<form action="QnaBoardList">
						<%-- 검색타입 목록(셀렉트박스), 검색어(텍스트박스) 추가(파라미터 있으면 해당 내용 표시) --%>
						<select name="searchType">
							<option value="subject"
								<c:if test="${param.searchType eq 'subject'}">selected</c:if>>제목</option>
							<option value="content"
								<c:if test="${param.searchType eq 'content'}">selected</c:if>>내용</option>
							<option value="subject_content"
								<c:if test="${param.searchType eq 'subject_content'}">selected</c:if>>제목+내용</option>
						</select> <input type="text" name="searchKeyword"
							value="${param.searchKeyword}"> <input type="submit"
							value="검색">
					</form>
					<%-- ============================================================================ --%>
					<input type="button" value="글쓰기" onclick="location.href='QnaBoardWrite'">
				</div>
			</section>
			<section id="listForm">
				<br>
				<div class="listWrapper">
					<ul class="list">
									<%-- ================================================ --%>
						<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
						<c:set var="pageNum" value="1" />
						<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
						<c:if test="${not empty param.pageNum}">
							<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
							<c:set var="pageNum" value="${param.pageNum}" />
						</c:if>
						<%-- ================================================ --%>
						<c:forEach var="qnabo" items="${QnaBoardList}">
							<%-- boardList 에서 꺼낸 BoardBean 객체(board)에 저장된 멤버변수값(데이터) 출력 --%>
							
							<li class="subject">
								<a href="QnaBoardDetail?faq_idx=${qnabo.faq_idx}&pageNum=${pageNum}"> 
									<span class="titleBox"> 
										<span class="group">문의</span> 
										<span class="subject">${qnabo.mem_name}</span> 
										<span class="subject">${qnabo.faq_subject}</span> 
										<span><fmt:formatDate value="${qnabo.faq_date}" pattern="yyyy-MM-dd" /></span>
<%-- 										<span class="view">조회수 ${qnabo.faq_readcount}</span> --%>
									</span>
								</a>
							</li>
							
						</c:forEach>
					</ul>
					<c:if test="${empty QnaBoardList}">
						<ul>
							<li class="subject">
								<span class="titleBox" id="noList">
									<span class="group">게시물이 존재하지 않습니다.</span>
								</span>
							</li>
						</ul>
					</c:if>
				</div>

				<table>
					<%-- ================================================ --%>
					<%-- JSTL 과 EL 활용하여 글목록 표시 작업 반복(boardList 객체 활용) --%>
<%-- 					<c:forEach var="bo" items="${boardList}"> --%>
<%-- 						boardList 에서 꺼낸 BoardBean 객체(board)에 저장된 멤버변수값(데이터) 출력 --%>
<!-- 						<tr> -->
<%-- 							<td>${bo.bo_idx}</td> --%>
<!-- 							<td id="subject"> -->
<%-- 								제목 클릭 시 하이퍼링크 설정(BoardDetail) 파라미터 : 글번호(board_num), 페이지번호(pageNum) --%>
<%-- 								<a href="BoardDetail?bo_idx=${bo.bo_idx}&pageNum=${pageNum}">${bo.bo_subject}</a> --%>
<!-- 							</td> -->
<%-- 							<td><fmt:formatDate value="${bo.bo_sysdate}" --%>
<%-- 									pattern="yyyy-MM-dd" /></td> --%>
<%-- 							<td>${bo.bo_readcount}</td> --%>
<!-- 						</tr> -->
<%-- 					</c:forEach> --%>
<%-- 					<c:if test="${empty boardList}"> --%>
<!-- 						<tr> -->
<!-- 							<td colspan="5">게시물이 존재하지 않습니다.</td> -->
<!-- 						</tr> -->
<%-- 					</c:if> --%>
				</table>
			</section>
			
			<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
			<c:set var="pageNum" value="1" />
			<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
			<c:if test="${not empty param.pageNum}">
				<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
				<c:set var="pageNum" value="${param.pageNum}" />
			</c:if>
			<%-- ================================================ --%>
			<%-- ========================== 페이징 처리 영역 ========================== --%>
			<section id="pageList">
				<%-- [이전] 버튼 클릭 시 BoardList 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
				<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
				<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
				<input type="button" value="이전"
					onclick="location.href='BoardList?pageNum=${pageNum - 1}'"
					<c:if test="${pageNum <= 1}">disabled</c:if>>

				<%-- 계산된 페이지 번호가 저장된 PageInfo 객체(pageInfo)를 통해 페이지 번호 출력 --%>
				<%-- 시작페이지(startPage = begin) 부터 끝페이지(endPage = end)까지 1씩 증가하면서 표시 --%>
				<c:forEach var="i" begin="${pageInfo.startPage}"
					end="${pageInfo.endPage}">
					<%-- 각 페이지마다 BoardList.bo 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
					<%-- 단, 현재 페이지(i 값과 pageNum 파라미터값이 동일)는 하이퍼링크 없이 굵게 표시 --%>
					<c:choose>
						<c:when test="${i eq pageNum}">
							<b>${i}</b>
							<%-- 현재 페이지 번호 --%>
						</c:when>
						<c:otherwise>
							<a href="board_list?pageNum=${i}">${i}</a>
							<%-- 다른 페이지 번호 --%>
						</c:otherwise>
					</c:choose>
				</c:forEach>

				<%-- [다음] 버튼 클릭 시 BoardList 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
				<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
				<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
				<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
				<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
				<input type="button" value="다음"
					onclick="location.href='BoardList?pageNum=${pageNum + 1}'"
					<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
			</section>
			</div>
			</div>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>













