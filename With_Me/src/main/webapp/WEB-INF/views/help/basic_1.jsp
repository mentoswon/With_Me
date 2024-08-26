<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>헬프센터 기본질문</title>
</head>
<body>
	<main>
		<section id="articleForm">
			<div align="left">
			<h2>공지사항</h2>
			</div>
			<section id="basicInfoArea">
				
				<table>
					<tr>
						<th width="70">제 목${bo.bo_subject}</th>
						<td colspan="3"></td>
					</tr>
					<tr>
						<!-- 작성일시 출력 형식은 ex) 2024-06-04 12:30 -->
						<th width="70">작성일시</th>
						<td><fmt:formatDate value="${bo.bo_sysdate}"
								pattern="yyyy-MM-dd" /></td>
					</tr>
				</table>
			</section>
			<!-- 게시글 본문 출력 영역 -->
			<section id="articleContentArea">
				<img
					src="${pageContext.request.contextPath}/resources/upload/${bo.bo_file}"
					id="img1" class="bo_image" selected> 
					<br>
					${bo.bo_content}
			</section>
			<section id="commandCell">
				<!-- 목록 버튼 클릭시 BoardList.bo 서블릿 요청(파라미터 : 페이지번호) -->
				<input type="button" value="헬프센터"
					onclick="location.href='BoardList?pageNum=${param.pageNum}'" id="list_btn">
			</section>
		</section>
	</main>
</body>
</html>