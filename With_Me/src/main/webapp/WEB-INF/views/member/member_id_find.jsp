<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/mypage_default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/id_find.css" rel="stylesheet" type="text/css">
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

        #findId_wrap h2 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }

        #findId_wrap p {
            font-size: 14px;
            color: #666;
            line-height: 1.5;
            margin-bottom: 20px;
        }

        #findId_wrap input[type="text"] {
            width: 100%;
            max-width: 300px;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 8px;
            font-size: 16px;
        }

        #findId_wrap input[type="submit"] {
            width: 100%;
            max-width: 120px;
            padding: 10px;
            margin: 20px 0;
            border: none;
            border-radius: 8px;
            background-color: #FFAB40;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }

        #findId_wrap input[type="submit"]:hover {
            opacity: 0.9;
        }

        #findId_wrap td {
            padding: 10px;
        }

        table {
            width: 100%;
            text-align: center;
        }

        #td02 {
            font-size: 14px;
            color: #666;
            text-align: center;
            line-height: 1.5;
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
			<div id="findId_wrap" align="center">
				<form action=IdFindPro method="post">
					<section id="sec01">
						<table>
							<tr>
								<td id="td01"><h2>아이디 찾기</h2></td>
							</tr>
							<tr>
								<td id="td02">위드미는 이메일을 아이디로 사용합니다.<br>
											소유하고 계신 계정을 입력해보세요.<br>
											가입여부를 확인해드립니다.
								</td>
							</tr>
						</table>
					</section>	
					<section id="sec02">
						<div style="display: flex; justify-content: center;">
							<table>
								<tr>
									<td><input type="text" name="mem_email" id="mem_email" size="10" required="required" placeholder="이메일 계정"></td>
								</tr>	
								<tr>
								<td id="td05" align="center" colspan="3">
									<br><input type="submit" value="다음" id="next">
		<!-- 						<input type="button" value="다음" onclick="location.href='MemberJoin_two'"> -->
		<!-- 						<input type="button" value="돌아가기" onclick="history.back()"> -->
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












