<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/join_success_default.css" rel="stylesheet" type="text/css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
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
            text-align: center;
        }

        main h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }

        main div {
            margin-bottom: 20px;
        }

        main input[type="button"] {
            width: 100%;
            max-width: 200px;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            color: white;
        }

        main input[type="button"].btn-home {
            background-color: #ccc;
        }

        main input[type="button"].btn {
            background-color: #FFAB40;
        }

        main input[type="button"]:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section id="joinFinish">
			<div>
				<h1 align="center">회원 가입 완료</h1>
				<h1 align="center">이메일 인증 후 로그인을 하세요!</h1>
				<div align="center">
					<input type="button" value="홈으로" onclick="location.href='./'" class="btn" style="background-color: #ccc;">
					<input type="button" value="로그인"
						onclick="location.href='MemberLogin'" class="btn">
				</div>
			</div>
		</section>
	</main>
	
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












