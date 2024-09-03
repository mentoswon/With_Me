<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 날짜 등의 출력 형식 변경을 위한 JSTL - format(fmt) 라이브러리 등록 --%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- hidden (where 절에 써야해서 파라미터 전달해야함 --%>
<input type="hidden" name="bo_idx" value="${notice.bo_idx}" >
<div>
	<span>제목</span> <br>
	<input type="text" name="bo_subject" value="${notice.bo_subject}">
</div>
<div>
	<span>공지내용</span> <br>
	<textarea rows="10" cols="40" name="bo_content">${notice.bo_content}</textarea>
</div>
<div>
	<span>첨부파일</span> <br>
	<c:choose>
		<c:when test="${not empty fileName}">
			<%-- 파일명 존재할 경우 원본 파일명 출력 --%>
			${originalFileName}
			<%-- 파일 다운로드 링크(버튼) 생성 --%>
			<a href="${pageContext.request.contextPath}/resources/upload/${fileName}" download="${originalFileName}">
				<input type="button" value="다운로드">
			</a>
			<%-- 파일 삭제 링크(버튼) 생성(개별 삭제 위함) --%>
			<%-- 삭제 버튼 클릭 시 removeFile() 함수 호출(파라미터 : 글번호, 파일명) --%>
			<input type="button" value="파일삭제" onclick="removeFile(${notice.bo_idx}, '${fileName}')">
			<%-- 파일명만 표시하는 경우에도 파일업로드 요소 생성하여 파라미터는 전달되도록 하기 --%>
			<%-- 단, 사용자에게 보이지 않도록 숨김 처리를 위해 hidden 속성 적용 --%>
			<input type="file" name="file" hidden>
		</c:when>
		<c:otherwise>
			<%-- 파일명이 존재하지 않을 경우 파일 업로드 항목 표시 --%>
			<input type="file" name="file">
		</c:otherwise>
	</c:choose>
</div>