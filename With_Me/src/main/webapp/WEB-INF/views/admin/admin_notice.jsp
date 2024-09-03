<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>With_Me</title>
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.contextPath}/resources/css/admin_default.css" rel="stylesheet" type="text/css">
<style>
	.main {
		padding: 1.5rem;
	}
	
	.main h3 {
		text-align: left;
		margin-bottom: 30px;
	}
	.main .wrapper_top {
		display: flex;
		justify-content: space-between;
		position: relative;
		margin-bottom: 20px;
	}
	
	.main .wrapper_top .search {
		width: 280px;
		position: absolute;
		left: 40%;
	}
	.main .content {
		width: 100%;
		margin-bottom: 50px;
	}
	
	.main .content table {
		width: 100%;
	}
	
	.main .content table th {
		background-color: #eee;
	}
	
	/* 페이징 처리 */
	.main #pageList {
		text-align: center;
	}
	
	/* 모달 팝업 */
	/*모달 팝업 영역 스타일링*/
	.notice {
		/*팝업 배경*/
		display: none; /*평소에는 보이지 않도록*/
	    position: absolute;
	    top:0;
	    left: 0;
	    width: 100%;
	    height: 100%;
	    overflow: hidden;
	    background: rgba(0,0,0,0.5);
	    z-index: 9;
	}
	.notice .notice_popup {
		/*팝업*/
	    position: absolute;
	    width: 500px;
	    top: 42.5%;
	    left: 50%;
	    transform: translate(-50%, -50%);
	    padding: 20px;
	    background: #ffffff;
	    border: 1px solid black;
	    border-radius: 20px;
	}
	
	.notice .notice_popup .content {
		width: 100%;
	}
	
	.notice .notice_popup .close_btn, .notice .notice_popup .regist_btn, .notice .notice_popup .reset_btn {
	    padding: 10px 20px;
	    background-color: rgb(116, 0, 0);
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	
	.notice.on {display: block;}
	.btnArea {margin-top: 30px;}
	
</style>
<%-- jquery 라이브러리 포함시키기 --%>
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
</head>
<body>
	<header>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>	
	<div class="inner">
		<section class="wrapper">
			<jsp:include page="/WEB-INF/views/inc/admin_side_nav.jsp"></jsp:include>
			<article class="main">
				<h3>공지사항</h3>
				<div class="wrapper_top">
					<div>
						<span>Show</span>
						<select onchange="showListLimit(this.value)">
							<option value="5" <c:if test="${param.listLimit eq 5}">selected</c:if>>5</option>
							<option value="10" <c:if test="${param.listLimit eq 10}">selected</c:if>>10</option>
							<option value="20" <c:if test="${param.listLimit eq 20}">selected</c:if>>20</option>
							<option value="30" <c:if test="${param.listLimit eq 30}">selected</c:if>>30</option>
						</select>
						<span>entries</span>
					</div>
					<form action="AdminNotice">
						<div class="search">
							<span>Search</span>
							<input type="search" name="searchKeyword" value="${param.searchKeyword}" >
							<input type="submit" value="검색">
						</div>
					</form>
					<!-- 우측 상단 버튼 들어가는 자리 -->			
					<div>
						<input type="button" id="registBtn" value="등록">
					</div>
				</div>
				<div class="content">
					<table border="1">
						<tr>
							<th>공지사항 번호</th>
							<th>공지사항 제목</th>
							<th>작성일</th>
							<th>조회수</th>
							<th>첨부파일</th>
							<th>수정 및 삭제</th>
						</tr>
						<%-- 페이지번호(pageNum 파라미터) 가져와서 저장(없을 경우 기본값 1로 설정) --%>
						<c:set var="pageNum" value="1" />
						<%-- pageNum 파라미터 존재할 경우(= 비어있지 않음) 판별 --%>
						<c:if test="${not empty param.pageNum}">
							<%-- pageNum 변수에 pageNum 파라미터값 저장 --%>
							<c:set var="pageNum" value="${param.pageNum}" />
						</c:if>
						<c:forEach var="notice" items="${noticeList}">
							<tr align="center">
								<td>${notice.bo_idx}</td>
								<td>${notice.bo_subject}</td>
								<td>${notice.bo_sysdate}</td>
								<td>${notice.bo_readcount}</td>
								<td>
									<c:choose>
										<c:when test="${empty notice.bo_file}">첨부파일이 없습니다</c:when>
										<c:otherwise>${notice.bo_file}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<input type="button" class="modifyBtn" value="수정" onclick="modifyNotice('${notice.bo_idx}')">
									<input type="button" class="deleteBtn" value="삭제" onclick="removeNotice('${notice.bo_idx}')">
								</td>
							</tr>
						</c:forEach>
						<c:if test="${empty noticeList}">
							<tr>
								<td align="center" colspan="7">검색결과가 없습니다.</td>
							</tr>
						</c:if>
					</table>
				</div>
				<%-- ========================== 페이징 처리 영역 ========================== --%>
				<div id="pageList">
					<%-- [이전] 버튼 클릭 시 AdminNotice 서블릿 요청(파라미터 : 현재 페이지번호 - 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${pageNum} 활용(미리 저장된 변수값) --%>
					<%-- 단, 현재 페이지 번호가 1 보다 클 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<input type="button" value="이전" onclick="location.href='AdminNotice?pageNum=${pageNum - 1}'" <c:if test="${pageNum <= 1}">disabled</c:if>>
					<%-- 계산된 페이지 번호가 저장된 PageInfo 객체(pageInfo)를 통해 페이지 번호 출력 --%>
					<%-- 시작페이지(startPage = begin) 부터 끝페이지(endPage = end)까지 1씩 증가하면서 표시 --%>
					<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
						<%-- 각 페이지마다 하이퍼링크 설정(페이지번호를 pageNum 파라미터로 전달) --%>
						<%-- 단, 현재 페이지(i 값과 pageNum 파라미터값이 동일)는 하이퍼링크 없이 굵게 표시 --%>
						<c:choose>
							<c:when test="${i eq pageNum}">
								<b>${i}</b> <%-- 현재 페이지 번호 --%>
							</c:when>
							<c:otherwise>
								<a href="AdminNotice?pageNum=${i}">${i}</a> <%-- 다른 페이지 번호 --%>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<%-- [다음] 버튼 클릭 시 AdminNotice 서블릿 요청(파라미터 : 현재 페이지번호 + 1) --%>
					<%-- 현재 페이지 번호(pageNum)가 URL 파라미터로 전달되므로 ${param.pageNum} 활용 --%>
					<%-- 단, 현재 페이지 번호가 최대 페이지번호(maxPage)보다 작을 경우에만 동작(아니면, 버튼 비활성화 처리) --%>
					<%-- 두 가지 경우의 수에 따라 버튼을 달리 생성하지 않고, disabled 만 추가 여부 설정 --%>
					<%-- pageNum 파라미터값이 최대 페이지번호 이상일 때 disabled 속성 추가 --%>
					<input type="button" value="다음" onclick="location.href='AdminNotice?pageNum=${pageNum + 1}'" <c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
				</div>
			</article>
		</section>
	</div>
	<%-- 공지사항 등록 팝업 --%>
	<div class="notice">
		<div class="notice_popup">
			<h3>공지사항 등록</h3>
			<div class="content">
				<form action="AdminNoticeRegist" method="post" name="registForm" enctype="multipart/form-data">
					<div>
						<span>제목</span> <br>
						<input type="text" name="bo_subject">
					</div>
					<div>
						<span>공지내용</span> <br>
						<textarea rows="10" cols="40" name="bo_content"></textarea>
					</div>
					<div>
						<span>첨부파일</span> <br>
						<input type="file" name="file">
					</div>
					<div class="btnArea" style="text-align : center">
						<input type="submit" class="regist_btn" value="등록">
						<input type="reset" class="reset_btn" value="초기화">
						<input type="button" class="close_btn" value="취소">
					</div>
				</form>
			</div>
		</div>
	</div>
	<%-- 공지사항 수정 팝업 --%>
	<div class="notice">
		<div class="notice_popup">
			<h3>공지사항 수정</h3>
			<div class="content">
				<form action="AdminNoticeModify" method="post" name="modifyForm" enctype="multipart/form-data">
					<div id="resultArea"></div> <%-- 수정 팝업 내용 들어갈 자리 --%>
					<div class="btnArea" style="text-align : center">
						<input type="submit" class="regist_btn" value="등록">
						<input type="button" class="close_btn" value="취소">
					</div>
				</form>
			</div>
		</div>
	</div>
	<script>
		// 페이지당 목록 개수 변경
		function showListLimit(limit){
			location.href="AdminNotice?listLimit=" + limit;
		}
		// ----------------------------------------------------------
		let notice = document.querySelectorAll('.notice');
		
		// 공지사항 등록 팝업 띄우기
		$("#registBtn").click(function() {
			notice[0].classList.add('on');
		});
		// 공지사항 수정 팝업 띄우기
		function modifyNotice(bo_idx) {
			notice[1].classList.add('on');
			// 상세 내용 가져오는 AJAX
			$.ajax({
				type : "GET",
				url : "AdminNoticeModify",
				data : {
					"bo_idx" : bo_idx
				},
				success : function(response) {
					$("#resultArea").html(response);
				},
				error : function() {
					alert("공지사항 정보 로딩 과정에서 오류 발생!");
				}
			});
		}
		// 공지사항 수정 - 파일 삭제
		function removeFile(bo_idx, fileName) {
			if(confirm("파일을 삭제하시겠습니까?")) {
				$.ajax({
					type : "POST",
					url : "AdminRemoveFile",
					data : {
						"bo_idx" : bo_idx,
						"bo_file" : fileName
					},
					success : function(response) {
						if(response) {
							alert("파일 삭제에 성공했습니다.");
							modifyNotice(bo_idx);
						} else if(!response) {
							alert("파일 삭제에 실패했습니다.");
							modifyNotice(bo_idx);
						}
					},
					error : function() {
						alert("파일 삭제 처리 과정에서 오류 발생!");
					}
				});
			}
		}
		// 공지사항 등록/수정 취소
		for(let i = 0; i < notice.length; i++) {
			$(".close_btn").click(function() {
				notice[i].classList.remove('on');
			});
		}
		// 공지사항 삭제
		function removeNotice(bo_idx){
			if(confirm("공지사항을 삭제하시겠습니까?")) {
				location.href="AdminNoticeRemove?bo_idx=" + bo_idx;
			}
		}
	</script>
	<footer>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>