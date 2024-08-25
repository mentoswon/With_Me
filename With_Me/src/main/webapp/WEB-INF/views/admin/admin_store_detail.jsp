<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	#articleForm {
		width: 500px;
/* 		height: 600px; */
		height: 100%;
		margin: auto;
	}
	
	h2 {
		text-align: center;
	}
	
	table {
		border: 1px solid black;
		border-collapse: collapse; 
	 	width: 500px;
	}
	
	th {
		text-align: center;
	}
	
	td {
		width: 150px;
		text-align: center;
	}
	
	#basicInfoArea {
		height: auto;
		text-align: center;
	}
	
	#board_file {
		height: auto;
		font-size: 12px;
	}
	
	#articleContentArea {
		background: orange;
		margin-top: 10px;
		height: 350px;
		text-align: center;
		overflow: auto;
		white-space: pre-line;
	}
	
	#commandList {
		margin: auto;
		width: 500px;
		text-align: center;
	}
	
	/*
	-------------- 댓글 영역 -----------------
	*/
	#replyArea {
		width: 500px;
		height: 100%; 
		margin: auto;
		margin-top: 20px;
		margin-bottom: 50px;
	}
	
	#replyTextarea { /* 댓글 입력 공간 */
		width: 400px;
		height: 50px;
		resize: none;
		vertical-align: middle;
	}
	
	#replySubmit { /* 댓글 작성 버튼 */
		width: 85px;
		height: 55px;
		vertical-align: middle;
	}
	
	#replyListArea {
		font-size : 12px;
		margin-top: 20px;
	}
	
	#replyListArea table, tr, td {
		border: none;
	}
	
	#replyListArea tr {
		height: 35px;
	}
	
	.replyContent {
		width: 300px;
		text-align: left;
	}
	
	.replyContent img {
		width: 10px;
		height: 10px;
	}
	
	.replyWriter {
		width: 80px;
	}
	
	.replyDate {
		width: 100px;
	}
	
	/* ---- 대댓글 ---- */
	#reReplyTextarea {
		width: 300px;
		height: 20px;
		resize: none;
		vertical-align: middle;
	}
	
	#reReplySubmit {
		width: 65px;
		height: 25px;
		vertical-align: middle;
		font-size: 12px;
	}
	
	
</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	function confirmDelete() {
		// 삭제 버튼 클릭 시 확인창(confirm dialog)을 통해 "삭제하시겠습니까?" 출력 후
		// 다이얼로그의 확인 버튼 클릭 시 "BoardDelete.bo" 서블릿 요청
		// => 파라미터 : 글번호, 페이지번호
		if(confirm("삭제하시겠습니까?")) {
			location.href = "BoardDelete?board_num=${board.board_num}&pageNum=${param.pageNum}";
		}
	}
	// ======================================================================================
	// 대댓글 작성 아이콘 클릭 처리를 위한 reReplyWriteForm() 함수 정의
	function reReplyWriteForm(reply_num, reply_re_ref, reply_re_parent_reply_num, reply_re_lev, reply_re_seq, index) {
// 		console.log("reReplyWriteForm : " + reply_num + ", " + reply_re_ref + ", " + reply_re_lev + ", " + reply_re_seq + ", " + index)
		
		// 기존 대댓글 입력폼 있을 경우를 대비해 대댓글 입력폼 요소(#reReplyTr) 제거
		$("#reReplyTr").remove();
		
		// 지정한 댓글 아래쪽에 대댓글 입력폼 표시
		// => 댓글 요소 tr 태그 지정 후 after() 메서드 호출하여 해당 요소 바깥쪽 뒤에 tr 태그 추가
		// => 해당 댓글 요소의 tr 태그 탐색을 위해 status.index 값을 전달받아 tr 태그 eq(인덱스)로 탐색
		$(".replyTr").eq(index).after(
				'<tr id="reReplyTr">'
				+ '	<td colspan="3">'
				+ '		<form action="BoardTinyReReplyWrite" method="post" id="reReplyForm">'
				+ '			<input type="hidden" name="board_num" value="${board.board_num}">'
				+ '			<input type="hidden" name="reply_num" value="' + reply_num + '">'
				+ '			<input type="hidden" name="reply_re_ref" value="' + reply_re_ref + '">'
				+ '			<input type="hidden" name="reply_re_parent_reply_num" value="' + reply_re_parent_reply_num + '">'
				+ '			<input type="hidden" name="reply_re_lev" value="' + reply_re_lev + '">'
				+ '			<input type="hidden" name="reply_re_seq" value="' + reply_re_seq + '">'
				+ '			<textarea id="reReplyTextarea" name="reply_content"></textarea>'
				+ '			<input type="button" value="댓글쓰기" id="reReplySubmit" onclick="reReplyWrite()">'
				+ '		</form>'
				+ '	</td>'
				+ '</tr>'
			);
		
	
	}
	// 댓글쓰기(대댓글) 버튼 클릭 처리 => AJAX 활용하여 대댓글 등록 처리
	function reReplyWrite() {
		// 대댓글 입력항목(textarea) 체크
		if($("#reReplyTextarea").val() == "") {
			alert("댓글 내용 입력 필수!");
			$("#reReplyTextarea").focus();
			return;
		}
		
		// AJAX 활용하여 대댓글 등록 요청 - BoardTinyReReplyWrite
		$.ajax({
			type : "post",
			url : "BoardTinyRePlyWrite",
			data : $("#reReplyForm").serialize(),
			dataType : "json",
			success : function(response) {
				console.log(JSON.stringify(response));
				console.log(response.isInvalidSession);
				if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
					alert("잘못된 접근입니다!");
				} else if(!response.result) { // 댓글 등록 실패일 경우
					alert("댓글 등록 실패!\n잠시 후 다시 시도해 주시기 바랍니다.");
				} else if(response.result) { // 댓글 등록 성공일 경우
					location.reload(); // 현재 페이지 갱신(새로고침)
				}
			},
			error : function() {
				alert("댓글 작성 요청 실패!");
			}
		});
	}
	
	// -----------------------------------------------------------------
	// 댓글 삭제 아이콘 클릭 처리를 위한 confirmReplyDelete() 함수 정의
	function confirmReplyDelete(reply_num, index) {
// 		console.log("confirmReplyDelete : " + reply_num + ", " + index)
		
		if(confirm("댓글을 삭제하시겠습니까?")) {
			// AJAX 활용하여 "BoardTinyReplyDelete" 서블릿 요청(파라미터 : 댓글번호) - POST
			$.ajax({
				type : "POST",
				url : "BoardTinyReplyDelete",
				data : {
					"reply_num" : reply_num
				},
				dataType : "json",
				success : function(response) {
					console.log(JSON.stringify(response));
					console.log(response.isInvalidSession);
					if(response.isInvalidSession) { // 잘못된 세션 정보일 경우
						alert("잘못된 접근입니다!");
					} else if(!response.result) { // 댓글 삭제 실패일 경우
						alert("댓글 삭제 실패!\n잠시 후 다시 시도해 주시기 바랍니다.");
					} else if(response.result) { // 댓글 삭제 성공일 경우
// 						location.reload(); // 현재 페이지 갱신(새로고침)
						// ------------------------------------------------------
						// 페이지 갱신 대신 index 값을 활용한 tr 태그 삭제(제거)
						$(".replyTr").eq(index).remove();
						// 여기서 index는 밑에 tr에 순서를 주는 느낌이여서 해당 tr를 제거하는 듯한 느낌 						
					}
				},
				error : function() {
					alert("댓글 삭제 요청 실패!");
				}
			});
		}
	}

</script>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<!-- 게시판 상세내용 보기 -->
	<article id="articleForm">
		<h2>글 상세내용 보기</h2>
		<section id="basicInfoArea">
			<table border="1">
			<tr><th width="70">상품코드</th><td colspan="3">${store.product_idx}</td></tr>
			<tr>
				<th width="70">작성자</th><td>${board.board_name}</td>
				<%-- 작성일시 출력 형식은 ex) 2024-06-04 12:30 --%>
				<th width="70">작성일시</th>
				<td><fmt:formatDate value="${board.board_date}" pattern="yyyy-MM-dd HH:mm"/></td>
			</tr>
			<tr>
				<th width="70">작성자IP</th><td>${board.board_writer_ip}</td>
				<th width="70">조회수</th><td>${board.board_readcount}</td>
			</tr>
			<tr><th width="70">파일</th>
				<td colspan="3" id="board_file">
					<%-- List 객체("fileList") 크기만큼 반복문을 통해 파일명 출력 --%>
					<c:forEach var="file" items="${fileList}">
						<%-- 단, 파일명(file 객체)가 비어있지 않을 경우메나 출력 --%>
						<c:if test="${not empty file}">
							<%-- [ JSTL - functions 라이브러리 함수 활용하여 원본 파일명 추출하기 ] --%> 
							<%-- 1) split() 함수 활용하여 "_" 구분자로 분리 후 두번째 인덱스 값 사용 --%>
<%-- 							split() : ${fn:split(file, "_")[1]}<br> --%>

							<%-- 2) substring() 함수 활용하여 시작인덱스부터 지정 인덱스까지 문자열 추출 --%>
							<%--    (단, 전체 파일명의 길이를  --%>
<%-- 							<c:set var="fileLength" value="${fn:length(file)}" /> --%>
<%-- 							<c:set var="delimIndex" value="${fn:indexOf(file, '_')}" /> --%>
<%-- <%-- 							substring() : ${fn:substring(file, 시작인덱스, 끝인덱스)} --%>
<%-- 							substring() : ${fn:substring(file, delimIndex + 1, fileLength)}<br> --%>

							<%-- 3) substringAfter() 함수 활용하여 시작인덱스부터 끝까지 추출 --%>
<%-- 							substringAfter() : ${fn:substringAfter(file, '_')}<br> --%>
							<c:set var="orginalFileName" value="${fn:substringAfter(file, '_')}"/>
							<%-- 
							다운로드 버튼을 활용하여 해당 파일 다운로드(버튼에 하이퍼링크 필요)
							=> 하이퍼링크에 download 속성 설정 시 해당 파일 다운로드 가능
							=> download 속성값으로 파일명 지정 시 지정된 파일명으로 다운로드 가능
							   (이 때, 다운로드 할 파일명을 원본 파일명 추출을 통해 지정)
							=> 다운로드 경로는 이클립스가 관리하는 upload 경로 지정
							--%>
						${file}
						<a href="${pageContext.request.contextPath}/resources/upload/${file}" download="${orginalFileName}">
							<input type="button" value="다운로드">
						</a><br>
						</c:if>
					</c:forEach> 
				</td>
			</tr>
			</table>
		</section>
		<%-- 게시물 본문 출력 영역 --%>
		<section id="articleContentArea">
			${board.board_content}
		</section>
		<section id="commandCell">
			<%-- 답글, 수정, 삭제 버튼은 로그인 한 사용자에게만 표시 --%>
			<%-- 단, 수정, 삭제 버튼은 세션 아이디와 작성자 아이디가 일치할 경우에만 표시 --%>
			<c:if test="${not empty sessionScope.sId}">
				<input type="button" value="답변" onclick="location.href='BoardReply?board_num=${board.board_num}&pageNum=${param.pageNum}'">
				<c:if test="${sessionScope.sId eq board.board_name}">
					<input type="button" value="수정" onclick="location.href='BoardModify?board_num=${board.board_num}&pageNum=${param.pageNum}'">
					<%-- 임시) 삭제 버튼 클릭 시 BoardDeleteForm.bo 서블릿 요청(삭제 폼 페이지 포워딩) --%>
					<%-- 파라미터 : 글번호(board_num) --%>
<%-- 					<input type="button" value="삭제" onclick="location.href='BoardDeleteForm.bo?board_num=${board.board_num}'"> --%>
					<%-- 삭제 버튼 클릭 시 패스워드 확인페이지 이동 없이 삭제 확인만 받기 위해 --%>
					<%-- 자바스크립트 confirmDelete() 메서드 호출하여 확인 후 비즈니스 로직 요청 --%>
					<input type="button" value="삭제" onclick="confirmDelete()">
				</c:if>
			</c:if>
			
			<%-- 목록 버튼은 항상 표시하고, 클릭 시 "BoardList.bo" 서블릿 요청(파라미터 : 페이지번호) --%>
			<input type="button" value="목록" onclick="location.href='BoardList?pageNum=${param.pageNum}'">
		</section>
		<%-- ============================ [댓글 영역 ] ===================================== --%>
		<section id="replyArea">
			<%-- 댓글 작성 폼 영역 --%>
			<form action="BoardTinyReplyWrite" method="post">
				<%-- 입력받지 않은 글번호, 페이지번호 함께 전달 = hidden 활용 --%>
				<input type="hidden" name="board_num" value="${board.board_num}">
				<input type="hidden" name="pageNum" value="${param.pageNum}">
				
				<%-- 세션 아이디가 없을 경우(= 미로그인) 댓글 작성 차단 --%>
				<%-- textarea와 submit 버튼 disabled, textarea에 메세지 표시 --%>
				<c:choose>
					<c:when test="${empty sessionScope.sId}"> <%-- 미 로그인 체크 --%>
						<textarea id="replyTextarea" name="reply_content" disabled="disabled" placeholder="로그인 한 사용자만 작성 가능합니다."></textarea>
						<input type="submit" value="댓글쓰기" id="replySubmit">
					</c:when>
					<c:otherwise>
						<textarea id="replyTextarea" name="reply_content"></textarea>
						<input type="submit" value="댓글쓰기" id="replySubmit">
					</c:otherwise>
				</c:choose>
			</form>
			<%-- 댓글 목록 표시 영역 --%>
			<div id="replyListArea">
				<table>
					<%-- 댓글 내용(reply_content), 작성자(reply_name), 작성일시(reply_date) 표시 --%>
					<%-- 반복문을 통해 List 객체(tinyReplyBoardList)로부터 Map 객체 꺼내서 출력 --%>
					<c:forEach var="tinyReplyBoard" items="${tinyReplyBoardList}" varStatus="status">
						<tr class="replyTr">
							<td class="replyContent">
								<%-- 대댓글 들여쓰기 --%>
								<c:forEach var="i" begin="1" end="${tinyReplyBoard.reply_re_lev}">
									&nbsp;&nbsp;
								</c:forEach>
								${tinyReplyBoard.reply_content}
								<%-- 세션 아이디가 존재할 경우 대댓글 작성 이미지(reply-icon.png) 추가 --%>
								<c:if test="${not empty sessionScope.sId}">
									<%-- 대댓글작성 아이콘 클릭 시 자바스크립트 함수 reReplyWriteForm() 호출 --%>
									<%-- 파라미터 : 대상 댓글번호(reply_num), 댓글 참조글번호, 들여쓰기레벨, 순서번호, 반복 인덱스값(status.index) --%>
									<a href="javascript:reReplyWriteForm(${tinyReplyBoard.reply_num}, ${tinyReplyBoard.reply_re_ref}, ${tinyReplyBoard.reply_re_parent_reply_num}, ${tinyReplyBoard.reply_re_lev}, ${tinyReplyBoard.reply_re_seq}, ${status.index})">
										<img src="${pageContext.request.contextPath}/resources/images/reply-icon.png" title="대댓글작성">
									</a>
									<c:if test="${sessionScope.sId eq 'admin' or sessionScope.sId eq tinyReplyBoard.reply_name}">
										<%-- 댓글 삭제 아이콘 클릭 시 자바스크립트 함수 confirmReplyDelete() 호출 --%>
										<%-- 파라미터 : --%>
										<a href="javascript:confirmReplyDelete(${tinyReplyBoard.reply_num}, ${status.index})">
											<img src="${pageContext.request.contextPath}/resources/images/delete-icon.png" title="댓글삭제">
										</a>
									</c:if>
								</c:if>
								<%-- 또한, 세션 아이디가 댓글 작성자와 동일하거나 관리자("admin")일 경우 --%>
								<%-- 댓글 삭제 이미지(delete-icon.png) 추가 --%>
								
							</td>
							<td class="replyWriter">
								${tinyReplyBoard.reply_name}
							</td>
							<td class="replyDate">
<%-- 								${tinyReplyBoard.reply_date} --%>
								<%--
								테이블 조회를 Map 타입으로 관리 시 날짜 및 시각 데이터가
								LocalXXX 타입으로 관리됨(ex.LocalDate, LocalTime, LocalTime)
								=> 날짜 및 시각 정보 조회 시 2024-08-05T10:26:56 형식으로 저장되어 있음
								=> 일반 Date 타입에서 사용하는 형태로 파싱 후 다시 포맷팅 작업 필요
								=> JSTL fmt 라이브러리 <fmt:parseDate/> 태그 활용하여 파싱 후
									<fmt:formatDate value=""/> 태그 활용하여 포맷팅 수행
									var
								 --%>
								 <fmt:parseDate var="parsedReplyDate" 
												 value="${tinyReplyBoard.reply_date}" 
												 pattern="yyyy-MM-dd'T'HH:mm" 
												 type="both" />
 								<%-- 파싱 후 날짜 및 시각 형식 : Mon Aug 05 10:26:00 KST 2024 --%>
<%-- 								${parsedReplyDate} --%>
								<%-- 파싱된 날짜 및 시각이 저장된 Date 객체의 포맷팅 수행 --%>								
								<%-- 월월-일일 시시:분분 형태로 포맷팅 --%>
								 <fmt:formatDate value="${parsedReplyDate}" pattern="MM-dd HH:mm" />
							</td>
						</tr>
					</c:forEach>
				</table>
			</div>
		</section>
	</article>
	<footer>
		<%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>
















