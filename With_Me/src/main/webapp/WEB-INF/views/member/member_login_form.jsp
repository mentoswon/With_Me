<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/login_form.css" rel="stylesheet" type="text/css">
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rsa.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/jsbn.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/prng4.js"></script>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/rsa/rng.js"></script>
<style type="text/css">
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    #loginForm {
        max-width: 500px;
        margin: 50px auto;
        padding: 30px;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 12px;
        box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
    }
    h1 {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        color: #333;
    }
    label {
        font-size: 14px;
        margin-bottom: 5px;
        display: block;
    }
    input[type="text"], input[type="password"] {
        width: 95%;
        padding: 10px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
    }
    #loginBtn {
        width: 100%;
        padding: 12px;
        background-color: #FFAB40;
        color: #fff;
        border: none;
        border-radius: 8px;
        font-size: 18px;
        cursor: pointer;
        transition: background-color 0.3s;
    }
    #loginBtn:hover {
        background-color: #ffa726;
    }
    .form-actions {
        text-align: center;
        margin-top: 15px;
    }
    .form-actions a {
        font-size: 12px;
        color: #333;
        margin-right: 10px;
        text-decoration: none;
    }
    .form-actions a:hover {
        text-decoration: underline;
    }
    .extra-buttons {
        display: flex;
        justify-content: space-between;
        margin-top: 20px;
    }
    .extra-buttons input {
        width: 48%;
        padding: 10px;
        background-color: #FFAB40;
        color: white;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-size: 14px;
        transition: background-color 0.3s;
    }
    .extra-buttons input:hover {
        background-color: #ffa726;
    }
    .kakao-login {
        margin-top: 20px;
        text-align: center;
    }
    .kakao-login img {
        width: 200px;
    }
</style>
<script type="text/javascript">
    $(function() {
        $("form").submit(function() {
            let rsa = new RSAKey();
            rsa.setPublic("${RSAModulus}", "${RSAExponent}");
            $("#hiddenId").val(rsa.encrypt($("#mem_email").val()));
            $("#hiddenPassswd").val(rsa.encrypt($("#mem_passwd").val()));
        });
    });
</script>
</head>
<body>
    <header>
        <jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
    </header>
    <main>
        <section>
            <div id="loginForm">
                <h1>로그인</h1>
                <form action="MemberLoginPro" method="post">
                    <label for="mem_email">아이디</label>
                    <input type="text" id="mem_email" required value="${cookie.rememberId.value}">
                    <input type="checkbox" name="rememberId" style="margin-bottom: 10px;"> 아이디 저장
                    
                    <label for="mem_passwd">비밀번호</label>
                    <input type="password" id="mem_passwd" required>
                    <input type="hidden" name="mem_email" id="hiddenId">
                    <input type="hidden" name="mem_passwd" id="hiddenPassswd">
                    
                    <input type="submit" value="로그인" id="loginBtn">
                    
                    <div class="form-actions">
                        <a onclick="location.href='MemberJoin'">회원가입</a>
                        <a onclick="location.href='IdFind'">아이디 찾기</a>
                        <a onclick="location.href='PasswdFind'">비밀번호 찾기</a>
                    </div>
                    
                    <div class="extra-buttons">
                        <input type="button" value="인증메일 재발송" onclick="location.href='ReSendAuthMail'">
                        <c:set var="client_id" value="5d33f40785e5f7a04c305e9e2ea27009" />
                        <c:set var="redirect_uri" value="http://localhost:8081/with_me/KakaoLoginCallback" />
                        <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=${client_id}&redirect_uri=${redirect_uri}">
                            <img src="${pageContext.request.servletContext.contextPath}/resources/image/kakao_login_medium_narrow.png">
                        </a>
                    </div>
                    
                    <div class="kakao-login">
                    </div>
                </form>    
            </div>
        </section>
    </main>
    
    <footer>
        <jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
    </footer>
</body>
</html>












