<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link href="${pageContext.request.contextPath }/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
#writeForm {
    border: 1px solid #ccc;
    border-radius: 12px;
    padding: 10px 30px;
    width: 400px;
    display: flex;
    justify-content: center;
    margin: 20px auto; /* 가운데 정렬을 위해 추가 */
    background-color: #fff; /* 배경색상 추가 */
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 추가 */
}

#writeForm h1 {
    text-align: center; /* 제목 가운데 정렬 */
    margin-bottom: 20px; /* 제목과 내용 사이 간격 */
}

#writeForm form {
    margin-top: 20px; /* 폼 상단 여백 */
}

#writeForm table {
    width: 100%; /* 테이블 너비 100%로 설정 */
}

#writeForm label {
    display: block;
    margin-bottom: 8px;
    color: #333; /* 라벨 텍스트 색상 */
}

#writeForm input[type="text"],
#writeForm input[type="password"],
#writeForm textarea,
#writeForm select {
    width: calc(100% - 20px); /* 입력 요소 너비 */
    padding: 10px;
    margin-bottom: 15px;
    border: 1px solid #ccc;
    border-radius: 5px;
}

#writeForm input[type="submit"],
#writeForm input[type="button"] {
    background-color: #59b9a9; /* 버튼 배경색 */
    color: #fff; /* 버튼 텍스트 색상 */
    border: none;
    padding: 10px 20px;
    cursor: pointer;
    border-radius: 5px;
    transition: background-color 0.3s;
}

#writeForm input[type="submit"]:hover,
#writeForm input[type="button"]:hover {
    background-color: #498f7f; /* 버튼 호버 배경색 */
}
</style>
</head>
<body>
    <%-- 로그인하지 않은 사용자 접근 시 "회원만 글쓰기가 가능합니다" 출력 후 로그인 페이지로 이동 --%>
    <%-- 미로그인 = 세션에 저장된 "sId" 속성값이 비어있음 --%>
    <%-- <c:if test="${empty sessionScope.sId}"> --%>
        <%-- <script type="text/javascript"> 
            alert("회원만 글쓰기가 가능합니다");
            location.href = "MemberLoginForm.me";
        </script>
        --%>
    <%-- </c:if> --%>
    <header>
        <%-- inc/top.jsp 페이지 삽입(jsp:include 액션태그 사용 시 / 경로는 webapp 가리킴) --%>
        <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    </header>
    <main>
        <section>
            <!-- 게시판 등록 -->
            <article id="writeForm">
                <div>
                    <h1>1:1 문의하기</h1>
                    <form action="QnaBoardWrite" name="writeForm" method="post">
                        <table>
                            <tr>
                            	<td>작성자</td>
                            </tr>
                            <tr>
                            	<td>
                                	<input type="hidden" name="mem_id" value="${sessionScope.sId}" required="required" size="15" readonly="readonly">
                                	<input type="text" name="mem_name" value="${sessionScope.sName}" required="required" size="15" readonly="readonly">
                                </td>
                            </tr>
<!--                             <tr> -->
<!--                                 <td >유형</td> -->
<!--                             </tr> -->
<!--                             <tr> -->
<!--                                 <td> -->
<!--                                     <select name="qna_type_idx"> -->
<!--                                     <option value="1">예약/계약상담</option> -->
<!--                                     <option value="2">차량인도</option> -->
<!--                                     <option value="3">정비/사고</option> -->
<!--                                     <option value="4">결제</option> -->
<!--                                     <option value="5">계약변경/종료</option> -->
<!--                                     <option value="6">기타</option> -->
<!--                                     </select> -->
<!--                                 </td> -->
<!--                             </tr> -->
                            <!-- 세션 아이디를 사용하여 작성자를 구별하므로 비밀번호는 불필요 -->
                            <!-- <tr>
                                <td class="write_td_left"><label for="board_pass">비밀번호</label></td>
                                <td class="write_td_right">
                                    <input type="password" name="board_pass" required="required" />
                                </td>
                            </tr> -->
                            <tr>
                                <td class="write_td_left"><label for="faq_subject">제목</label></td>
                            </tr>
                            <tr>
                                <td class="write_td_right"><input type="text" id="faq_inquery" size="35" placeholder="한글 기준 2자 ~ 50자 사이로 입력해주세요" name="faq_subject" required="required" /></td>
                            </tr>
                            <tr>
                                <td class="write_td_left"><label for="faq_content">내용</label></td>
                            </tr>
                            <tr>
                                <td class="write_td_right">
                                    <textarea id="qna_content" name="faq_content" rows="15" cols="40" placeholder="한글 기준 10자 이상 입력해주세요" required="required"></textarea>
                                </td>
                            </tr>
                        </table>
                        <section id="commandCell">
                            <input type="submit" value="등록">&nbsp;&nbsp;
                            <input type="reset" value="다시쓰기">&nbsp;&nbsp;
                            <input type="button" value="취소" onclick="history.back()">
                        </section>
                    </form>
                </div>
            </article>
        </section>
    </main>
    <footer>
        <%-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 --%>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
    </footer>
</body>
</html>








