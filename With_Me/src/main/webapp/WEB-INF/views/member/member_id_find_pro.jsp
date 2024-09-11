<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/join_success_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/id_find.css" rel="stylesheet" type="text/css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        main {
            width: 100%;
            max-width: 500px;
            margin: 60px auto;
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 22px;
            color: #333;
            margin-bottom: 20px;
        }

        #findId_wrap_ {
            width: 100%;
            max-width: 400px;
        }

        #table01 {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        #table01 td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            font-size: 16px;
        }

        #table01 td:first-child {
            font-weight: bold;
            color: #555;
        }

        #table01 td:last-child {
            color: #333;
        }

        #moveLogin {
            width: 100%;
            max-width: 200px;
            padding: 12px;
            margin-top: 20px;
            border: none;
            border-radius: 8px;
            background-color: #FFAB40;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        #moveLogin:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section>
			<h1 align="center">회원으로 등록된 아이디입니다.</h1>
			<div id="findId_wrap_" style="display: flex; justify-content: center;">
				<table id="table01">
					<tr>
						<td>아이디 : </td><td>${dbMember.mem_email}</td>
<%-- 							<td><input type="text" name="id_name" value="${sessionScope.sId}" required="required" size="15"></td> --%>
					</tr>
					<tr>
						<td>가입일 : </td><td>${dbMember.mem_sign_date}</td>
					</tr>	
					<tr>
						<td colspan="2" align="center">
							<br>
							<input type="button" value="로그인하러 가기" onclick="location.href='MemberLogin'" id="moveLogin">
						</td>
					</tr>
				</table>
			</div>
		</section>
	</main>
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












