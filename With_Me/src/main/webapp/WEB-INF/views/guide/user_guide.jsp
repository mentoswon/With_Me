<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
    <title>with_me</title>
<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
<link
	href="${pageContext.request.contextPath }/resources/css/default.css"
	rel="stylesheet" type="text/css">
	<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style>


	.guideWrapper {
		overflow: hidden; /* 섹션의 요소들이 넘치지 않도록 */
   		width:50%;
		margin: 0 auto;
		padding:2em;
	}
	
	.headerWrapper {
		margin-bottom: 2em;
		color: #FFAB40;
	}
	.divWrapper {
        border: 2px solid orange;
		border-radius: 5px;
		padding-top: 2em;
		padding-bottom: 3em;
		padding-left: 3em;
		padding-right: 3em;
		background-color: #f7f7f7;
	}
	
    /* div 요소를 기준으로 주황색 얇은 선을 그리는 스타일 */
    .guideInner {
        border-bottom: 3px solid #e0e0e0;
        padding: 10px 0 7px 0;
        
    }

    .final-section {
/*         border-bottom: 1px solid orange; */
        padding: 10px 0;
        text-align: center;
        margin-top: 2em;
    }

    h2 {
        color: #333;
        font-size: 24px;
    }

    p {
        color: #666;
        font-size: 20px;
    }
    
    .btnWrapper {  
    	width: 100%;
    	text-align: center;
    	margin: 2em 0; /* 위, 아래 여백을 충분히 줌 */
    }
    .btnWrapper :hover {
    	cursor: pointer;
    }
    .backBtn { /* 메인 페이지로 이동 */
    	width: 40%;
    	color: #fff;
    	background-color: #FFAB40;
    	border: none;
    	border-radius: 10px;
    	padding: 1.2em;
    	font-size: 20px;
    } 
    .backBtn:hover {
    	color: #a7a7a7;
    }
    
</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<section class="guideWrapper">
	
		<div class="headerWrapper">
	    <h1>위드미에서 프로젝트 시작하기</h1>
	    </div>
		<div class="divWrapper">
		    <div class="guideInner">
		        <h2>1. 프로젝트 준비</h2>
		        <p>
		            프로젝트를 시작하려면 먼저 아이디어를 구체화하고, 후원자들에게 제공할 내용을 준비해야 합니다. 
		            위드미는 다양한 형태의 프로젝트를 지원하며, 창작자의 독창적인 아이디어가 중요합니다.
		        </p>
		    </div>
		
		    <div class="guideInner">
		        <h2>2. 프로젝트 제출</h2>
		        <p>
		            준비된 프로젝트는 위드미에 제출하여 검토 과정을 거칩니다. 검토가 완료되면 프로젝트가 공개되고 후원자를 모집할 수 있습니다.
		        </p>
		    </div>
		
		    <div class="guideInner">
		        <h2>3. 펀딩 진행</h2>
		        <p>
		            프로젝트가 공개되면 펀딩이 시작됩니다. 후원자들은 목표 금액을 달성하기 위해 다양한 금액으로 후원을 할 수 있으며, 프로젝트가 성공하면 목표 금액이 창작자에게 전달됩니다.
		        </p>
		    </div>
		
		    <div class="guideInner">
		        <h2>4. 보상 발송</h2>
		        <p>
		            프로젝트가 성공하면 창작자는 후원자에게 약속한 보상을 발송해야 합니다. 보상은 물리적 상품이나 디지털 콘텐츠 등 다양한 형태일 수 있습니다.
		        </p>
		    </div>
		
		    <div class="guideInner">
		        <p>
		            위드미는 창작자와 후원자 간의 신뢰를 중요하게 생각하며, 원활한 소통을 위해 다양한 도구를 제공합니다.
		        </p>
		    </div>
		    <div class="final-section">
		        <p>
		           	<b><a>관심있는 프로젝트 또는 상품은 '좋아요'!</a></b><br>
		            <span>마감되기 전에 잊지 않게</span>
		        </p>
		        <br><br>
		        <p>
		           	<b><a>좋아하는 창작자는 '팔로우'!</a></b><br>
		            <span>다음 프로젝트도 놓치지 마세요~</span>
		        </p>
		    </div>
		    <div class="btnWrapper">
<!-- 		  		<button value="위드미로 출발하기"class="backBtn" onclick="./">위드미로 출발하기</button> -->
		  		<input type="button" value="위드미로 출발하기" class="backBtn" onclick="location.href='./'">
		    </div>
	    </div>
    </section>
	<footer>
		<!-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 -->
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
</html>