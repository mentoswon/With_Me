<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_default.css" rel="stylesheet" type="text/css">
<%-- <link href="${pageContext.request.servletContext.contextPath}/resources/css/main.css" rel="stylesheet" type="text/css"> --%>
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
        }

        h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }

        #findPw_wrap {
            width: 100%;
            max-width: 400px;
            margin: 0 auto;
        }

        #sec01 {
            text-align: center;
            margin-bottom: 20px;
        }

        #td02 {
            font-size: 16px;
            color: #555;
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }

        td {
            padding: 12px;
            font-size: 16px;
            color: #333;
        }

        #td03 {
            text-align: right;
            padding-right: 10px;
        }

        input[type="text"] {
            padding: 10px;
            width: 57%;
            max-width: 250px;
            border: 1px solid #ddd;
            border-radius: 8px;
        }

        input[type="submit"] {
            width: 100%;
            max-width: 200px;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background-color: #FFAB40;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            opacity: 0.9;
        }

        #td04 {
            text-align: center;
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
				<div id="findPw_wrap">
					<form action="PwFindPro" method="post" id="form01">
						<section id="sec01">
							<table>
								<tr>
									<td id="td01"><h2>비밀번호 재설정</h2></td>
								</tr>
								<tr>
									<td id="td02">찾고자 하는 아이디를 입력해주세요</td>
								</tr>
							</table>
						</section>	
						<section id="sec02">
							<div style="display: flex; justify-content: center;">
								<table>
									<tr>
										<td id="td03">아이디</td>
										<td><input type="text" name="mem_email" id="mem_email" size="10" required="required"></td>
									</tr>
									
									<tr>
									<td id="td04" colspan="2">
										<br><input type="submit" value="다음" id="next">
									</td>
								</tr>
								</table>
							</div>
						</section>
					</form>
				</div>
			</section>
		</main>
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












