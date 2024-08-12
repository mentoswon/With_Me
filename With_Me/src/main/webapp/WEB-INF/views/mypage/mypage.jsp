<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<link href="${pageContext.request.servletContext.contextPath}/resources/css/login_form.css" rel="stylesheet" type="text/css">
<style type="text/css">
#loginForm {
	border: 1px solid #ccc;
	border-radius: 12px;
	margin: 0 100px;
	padding: 20px;
}
#loginBtn {
	 height: 90px;
	 width: 170px; 
	 margin: 20px 0 10px 0;
	 border: none;
	 border-radius: 12px;
	 background-color: #ccc;
	 font-size: 18px;
}
#loginBtn:hover {
	 background-color: #59b9a9;
}

.on {
	display: block;
}

.option {
	background-color: #FFFFFF;
	border: none;
}

</style>
<script type="text/javascript">
	let tabMenu = document.querySelectorAll('.tabMenu');
	let loginCon = document.querySelectorAll('#button');
			
	for(let i = 0; i < tabMenu.length; i++){
		tabMenu[i].onclick = function () {
			tabMenu[0].classList.remove('on');
			tabMenu[1].classList.remove('on');
		                  
			tabMenu[i].classList.add('on');
		
			loginCon[0].classList.remove('on')
			loginCon[1].classList.remove('on')
		
			loginCon[i].classList.add('on');
		}
	}
</script>
</head>
<body>
	<header>
		<%-- top.jsp 페이지를 현재 페이지에 삽입 --%>
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
		<section>
			<div style="text-align: center; display: flex;">
				<h3>${sessionScope.sName}</h3>
				<button class="option" type="button" onclick="location.href='MypageInfo'">
					<img src="${pageContext.request.contextPath}/resources/image/mypage.png" width="25">
				</button>
			</div>
			<div>
				<input type="button" id="buttonA" class="tabMenu on" value="프로필">
				<div>
					<p>
					등록된 정보가 없습니다.
					</p>
				</div>
				<input type="button" id="buttonB" class="tabMenu" value="좋아요">
				<input type="button" id="buttonC" class="tabMenu" value="올린 프로젝트">
				<input type="button" id="buttonD" class="tabMenu" value="후원한 프로젝트">
				<input type="button" id="buttonE" class="tabMenu" value="팔로워">
				<input type="button" id="buttonF" class="tabMenu" value="팔로잉">
			</div>
			<div>
			
			</div>
		</section>
	</main>
	
	
	<footer>
		<%-- 회사 소개 영역(inc/botto.jsp) 페이지 삽입 --%>
		<jsp:include page="/WEB-INF/views//inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>












