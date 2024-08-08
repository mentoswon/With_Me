<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Result</title>
    <script type="text/javascript">
        function closeWindowAndRefreshParent() {
            alert("${msg}");
            window.opener.location.reload(); // 부모 창 새로고침
            window.close(); // 현재 창 닫기
        }
        
        // ㅎㅎ
    </script>
</head>
<body onload="closeWindowAndRefreshParent()">
</body>
</html>








