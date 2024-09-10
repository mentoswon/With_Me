<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>With_Me</title>
		<!-- 외부 CSS 파일(css/default.css) 연결하기 -->
		<link href="${pageContext.request.contextPath }/resources/css/side_default.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<style>

main {
	overflow: hidden;
}
.guideWrapper {
	width: 60%; 
	margin:0 auto;
	
}
.section01 {
	margin: 2em 0 2em 0;
}
.imgWrapper {
	width: 100%;
	height:60%;
}
#guide_img {
	width:100%;
	height:300px;
	
}

#process_img {
	width:100%;
	height: 200px;

}

p {
	margin: 1.5em;
}

h2 {
	margin-left: 1.2em;
	margin-top: 1.5em;
}


.section02 {
	
	margin-bottom: 5%;
	border-bottom: 1px solid #c7c7c7;
	height:60px;
}
.toggle-button {
	display:inline-block;
	margin-bottom: 10px;
	font-size: 16px;
	font-weight: bold;
	background-color: #FFAB40;
	color: #fff;
	border:none;
	border-radius: 5px;
	padding: 10px;
	cursor: pointer;
}
.goMain {
	display:inline-block;
	margin-bottom: 10px;
	font-size: 16px;
	font-weight: bold;
	background-color: #FFAB40;
	color: #000000;
	border:none;
	border-radius: 5px;
	padding: 10px;
	cursor: pointer;
}

.toggle-section {
	display: none;
	background-color: #f7f7f7;
	padding: 10px;
	border-radius: 5px;
	margin-bottom: 10px;
}

.toggle-section.active {
	display: block;
}



</style>
</head>
<body>
	<header>
		<!-- Login, Join 링크 표시 영역 -->
		<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
	</header>
	<main>
    <section class="guideWrapper">
		<section class="section01" id="intro">
			<div class="imgWrapper">
				<img alt="가이드이미지" id="guide_img" src="${pageContext.request.contextPath}/resources/image/guide_book.png">
			</div>
			<p>
			위드미는 창조적인 프로젝트를 위한 크라우드 펀딩 서비스를 제공합니다. 반려동물 관련 다양한 식품, 용품 등에 관해 창조적이고 혁신적인 시도가 위드미를 통해 실현되었습니다.
			위드미는 후원을 통해 제작 예산을 해결하기에 독립적으로 프로젝트를 진행 할 수 있고, 후원자를 통하여 커뮤니티를 키워 나갈 수 있어 지속가능한 창작의 발판이 됩니다.
			모든게 처음이라도 괜찮습니다. 가이드 순서대로 프로젝트 계획과 선물을 고려한 후 펀딩 목표와 계획을 세워보세요.
			위드미가 익숙하지 않고 제작 경험이 적어도 이 과정을 통해 구체적으로 펀딩을 준비할 수 있습니다.
			</p>
		</section>
		<!-- 토글 버튼 -->
		<section class="section02">
			<button class="toggle-button" data-target="#creator_guide_1">1. 시작하기</button>
			<button class="toggle-button" data-target="#creator_guide_2">2. 프로젝트 계획</button>
			<button class="toggle-button" data-target="#creator_guide_3">3. 선물</button>
			<button class="toggle-button" data-target="#creator_guide_4">4. 펀딩 목표</button>
			<button class="toggle-button" data-target="#creator_guide_5">5. 프로모션</button>
			<button class="toggle-button" data-target="#creator_guide_6">6. 후원자와 소통하기</button>
			<button class="toggle-button" data-target="#creator_guide_7">7. 전달하기</button>
			<button class="goMain" onclick="location.href='./'">돌아가기</button>
		</section>
		
		<!-- 토글할 섹션 -->
		<!-- 토글 버튼 클릭 시 표출되는 가이드 내용 -->
		<!-- =========== 1. 시작하기 - 내용 =========== -->
		<section class="toggle-section" id="creator_guide_1">
	        <div class="step">
	            <h2>위드미 프로젝트의 필수 요소</h2>
	            <p class="hidden-content">
	            창작자는 새로운 제작, 생산을 사람들의 후원을 받아 실현하고 그 결실을 선물로 전달합니다. 
	            이과정을 위드미에서는 프로젝트라 부릅니다. 프로젝트를 진행하기 위해서는 다음의 요소가 필요합니다.
	            • 프로젝트에 대한 소개와 계획을 담은 <b>프로젝트 계획</b>
	            • 프로젝트가 완료되면 후원자가 받게 되는 <b>선물</b>
	            </p>
	        </div>
	        <div class="step">
	            <h2>프로젝트 진행 과정</h2>
	            <p class="hidden-content">
	            위드미 프로젝트는 크게 심사 -> 공개예정 -> 펀딩 -> 결제 -> 정산 -> 선물 전달 순서로 진행됩니다.<br>
	            <img alt="진행과정" id="process_img" src="${pageContext.request.contextPath}/resources/image/project_process.png">
		            프로젝트 올리기를 통해 프로젝트를 완성하셨다면 텀블벅 심사팀에게 심사를 요청할 수 있습니다. 심사과정을 거쳐
		            승인을 받은 프로젝트는 공개 예정 또는 펀딩을 시작하실 수 있습니다.<br>
		            <br>
		            심사 요청을 하면 2영업일 이내로 심사결과를 안내드리고 있습니다. 규정에 따라 잘 작성해주신 경우에는 바로 승인되고,
		            필요시 수정 및 보완 사항을 안내드릴 수 있습니다. 따라서 시작 일정이 중요한 프로젝트라면 최소 10일 전에 심사 요청을
		            하실 것을 권합니다.<br>
		            <br>
		            
		            텀블벅은 프로젝트가 성사되어야 후원금이 인출되기 때문에 만약의 상황에 대비하여 7일의 후원자 결제 기간을 갖습니다. 
		            결제 종료일로부터 7일 이후에 후원금이 창작자 계좌에 입금됩니다.<br>
					<br>		            
		           선물 예상 전달일은 제작일정을 고려하여 최대 5년까지 자유롭게 결정할 수 있습니다. 선물을 빠리 전달하고, 받고 싶은 것이 
		           모두의 마음이겠지만 혹시모를 제작상의 변수를 고려하여 일정은 여유 있게 정하는 것이 좋습니다.
		           한번에 배송할 수 있는 수량이 정해져 있다면 선물마다 수량 제한과 함께 함께 전달 일정에 시차를 두면 효율적으로 일정을 관리
		           할 수 있습니다.<br>
	            </p>
	        </div>
		</section>
		<!-- =========== 2. 프로젝트 계획 - 내용 =========== -->
		<section class="toggle-section" id="creator_guide_2">
			<div class="step">
	            <h2>프로젝트 소개</h2>
	            <p class="hidden-content">
	            어떤것을 만드고 실현하기 위한 프로젝트인지 소개해주세요. 어디서부터 소개해야 할 지 막막하다면, 아래 구성방법을 참고하여 작성해보세요.
	            <br><br>
	            <span>
	            <b>1. 프로젝트의 개요를 먼저 설명해보세요</b><br>
	            • 프로젝트 전반을 요약하는 개요로 시작하고, 구체적인 세부사항을 설명해보세요.
	            복잡하고 규모있는 프로젝트일수록 실현하려는 목표를 하나씩 소개해야 쉽게 이해할 수 있어요.<br>
	            </span><br>
	            <span>
	            <b>2. 프로젝트가 시작된 계기부터 설명해보세요.</b><br>
	            • 프로젝트 아이디어는 어디서 왔나요? 그리고 왜 하게 되었나요? 아이디러를 떠올리게 된 에피소드나 과정을 설명하다보면
	            자연스럽게 사람들이 프로젝트의 취지에 공감 할 수 있습니다. 이러한 공감은 후원을 결정하게 만드는 것은 물론 프로젝트를 주변에 공유하게 만듭니다.
	            </span>
	            </p>
	        </div>
			<div class="step">
	            <h2>프로젝트 예산</h2>
	            <p class="hidden-content">
	            사람들은 제작 예산이 현실적이고 그 사용 계획이 구체적일 때 창작자가 프로젝트를 문제없이 완수할 수 있다고 판단합니다. 후원자들이 왜 목표금액이 필요한지
	            알 수 있도록 이번 프로젝트에 필요한 예산을 구체적인 항목으로 공유해주세요.
	            
	            또한 예산은 이번 창작 활동에 관한 내용으로만 구성해 주세요. 다음 프로젝트에 사용하거나 공익단체에 기부하기 등 이번 프로젝트와 무관한 내용은
	            기재할 수 없습니다. 
	            </p>
	        </div>
			<div class="step">
	            <h2>프로젝트 일정</h2>
	            <p class="hidden-content">
	            프로젝트가 마감된 후 제작이 시작되는 만큼 후원자들이 후원 선물을 ㅂ다기까지 기다리는 시간이 매우 길 수 있습니다. 그 동안 후원자가 믿고 기다릴 수 있도록 구체적인 계획을
	            공유하는 것이 중요합니다.<br>
	            <span>
	            <b>1. 현재까지의 준비 상태를 알려주세요</b><br>
	            • 현재 구상 단계인지, 시제품이나 파일럿 등 가안 제작 단계인지 정확히 알려주세요.<br>
	            </span><br>
	            <span>
	            <b>2. 진행 과정을 구체적으로 알려주세요</b><br>
	            • 펀딩에 성공한다면 어떤 일정으로 완수할 계획인지, 펀딩 종료 이후의 예상 제작일을 구체적으로 알려주세요. 향후 계획이 변경된다면 커뮤니티를 통해 후원자에게 알릴 수 있습니다.<br>
	            </span>
	            </p>
	        </div>
			<div class="step">
	            <h2>선물설명</h2>
	            <p class="hidden-content">
				후원자들에게 후원금에 따라 제공할 선물을 소개해주세요. 후원자 선물은 프로젝트의 결과로 만들어질 창작물과 더불어 후원자명 기재, 친필 사인 등 위드미에서만 받을 수 있는 서비스도 
				선물이 될 수 있습니다.<br>
					<span>
		            <b>1. 현재까지의 준비 상태를 알려주세요</b><br>
		            • 펀딩은 아직 제작되지 않은 창작물에 대해 후원을 하는 만큼 후원자에게 프로젝트 완수에 대한 신뢰를 주어야합니다. 
		            프로젝트 결과물을 예상할 수 있는 샘플 이미지, 영상, 미리보기 콘텐츠를 포함하여 주세요.<br>
		            </span><br>
		            <span>
		            <b>2. 상세한 제작 스펙을 알려주세요</b><br>
		            • 창작물의 크기 및 재질 등을 확인할 수 있도록 도표를 첨부하거나 이미지를 사용해보세요.<br>
		            </span><br>
		            <span>
		            <b>3. 주의 및 참고사항을 미리 적어주세요</b><br>
		            • 선물 전달 방법 및 주의사항, 질문 등 프로젝트에 대해 못한 이야기가 있다면 안내해주세요.
		            개별적인 문의는 [창작자에게 문의]를 이용하시도록 표기할 수 있습니다.
		            </span>
	            </p>
	        </div>
			<div class="step">
	            <h2>TIP : 이미지 및 동영상 활용 방법</h2>
	            <p class="hidden-content">
				제작 이전의 프로젝트를 사람들에게 이해시키기 위해선 사진, 샘플 또는 목업이미지, 영상이 단연 효과적입니다.<br>
				<span>
	            <b>1. 이미지</b><br>
	            • 디테일이 중요한 제품이라면 후원자가 궁금해 할 부분을 꼼꼼하게 보여주세요. 페이지에 처음 들어왔을 때 눈길을 사로잡을 수 있는 이미지를 
	            준비하세요.<br>
	            </span><br>
	            <span>
	            <b>2. 영상, GIF, 표, 그래프</b><br>
	            • 복잡한 기능이나 사용 예시를 설명하는데는 영상과 GIF가 유용합니다. 하드웨어 프로젝트라면 프로토 타입 작동 영상을 포함하는 것이 신뢰 형성에 중요합니다.
	            성능이나 효과를 설명 할 때는 표나 그래프를 활용하세요. 다양한 선물을 설명할 때도 시각화된 도표가 도움이 될 수 있습니다.<br>
	            </span>
	            </p>
	        </div>
		</section>
		
		<!-- ============== 3. 선물 - 내용 ============== -->
		<section class="toggle-section" id="creator_guide_3">
			<div class="step">
	            <h2>다양한 구성과 금액대의 선물</h2>
	            <p class="hidden-content">
				창작자의 결실을 선물로 나누세요. <br>
				창작물이 곧 선물이 되는 경우도 있고 프로젝트에 따라 재미있는 아이디어를 생각할 수도 있습니다.
				후원자가 창작에 참여하는 형태나 후원자에게 찾아가서 개인에 맞춰진 선물을 제공할 수도 있습니다.
				선물 아이디어에서 자신의 프로젝트에 적용할 만한 아이디어를 얻어보세요.
				<br>
				사람마다 후원할 수 있는 금액은 다양합니다. 제작 예산을 크게 초과하지 않고, 프로젝트와 관련된 범위 안에서 다양한 금액대의 선물을 고려해보세요.
				여러 니즈의 후원자들을 모두 끌어들일 수 있습니다.
	            <br>
	            </p>
	        </div>
		</section>
		<!-- ============== 4. 펀딩 목표 - 내용 ============== -->
		<section class="toggle-section" id="creator_guide_4">
			<div class="step">
	            <h2>목표 금액 설정</h2>
	            <p class="hidden-content">
				목표 금액은 펀딩에서 약속한 것을 실행하고 후원자에게 선물을 전달하는데 드는 최소비용입니다. <br>
				<br>
				목표 금액을 설정할 때에는 예산, 예상 후원자 수를 고려하여 설정해주세요. 제작과정에서 발생할 비용들을 미리 조사하고 확인하는 것이 중요합니다.
				어림짐작으로 얼마가 들것인지 보다는 실제로 들어가는 금액이나 제작 견적을 알아보세요.
				비용이 들어가는 항목들을 리스트로 만들어서 관리하는 것도 큰 도움이 됩니다.<br>
	            </p>
	        </div>	
			<div class="step">
	            <h2>성사 혹은 무산</h2>
	            <p class="hidden-content">
				위드미는 펀딩이 성사되어야만 후원금을 전달합니다. 펀딩기간 내에 목표금액을 넘지 않으면 프로젝트는 무산되고 모인 금액 역시 전달 되지 않습니다.
				 이는 창작자가 최소 비용이 확보되지 않은 상태에서 제작하는 위험을 방지합니다. 후원자는 창작자가 충분한 비용을 갖고 제작할 것을 알기에 안심하고 기다릴 수 있습니다.<br>
	            </p>
	        </div>	
			<div class="step">
	            <h2>펀딩 일정 설정</h2>
	            <p class="hidden-content">
				펀딩 기간은 최대 60일까지 설정 할 수 있습니다. 제작 상황에 따라 자유롭게 결정할 수 있지만, 위드미가 권장하는 기간은 30일 전후 입니다. 이보다 기간이 길다면
				창작자 업데이트를 통해 꾸준히 펀딩에 대한 관심을 끌고 후원을 독려하는 것이 중요합니다. 프로젝트에 따라 짧은 기간을 진행하되 집약적으로 홍보하는 것도 한 방법이 될 수 있습니다.<br>
	            </p>
	        </div>	
		</section>
		<!-- ============== 5. 프로모션 - 내용 ============== -->
		<section class="toggle-section" id="creator_guide_5">
			<div class="step">
	            <h2>가까운 곳부터 시작하세요</h2>
	            <p class="hidden-content">
				후원할 사람을 파악하는 방법은 내 주변의 네트워크에서부터 시작하는 것입니다.친구와 가족은 물론 나의 팬, 내가 속한 창작 분야 동료부터 내 이야기에 마음을 열어줄 사람들까지 
				잠재적인 후원자를 파악하고 이중 얼마가 내 프로젝트에 후원할지 생각해보세요.<br>
	            </p>
	        </div>		
			<div class="step">
	            <h2>타깃을 좁히세요</h2>
	            <p class="hidden-content">
				어떤사람들이 내 프로젝트에 관심을 보일지 생각해보세요. 나이나 성별은 큰 틀의 접근일뿐이며, 내 창작의 특징이나 차별점에서 타깃하는 사람을 좀더 좁혀보세요.
				프로젝트와 관계있는 인터넷 커뮤니티, SNS 그룹을 고려하는것도 도움이 될 수 있습니다.<br>
	            </p>
	        </div>		
			<div class="step">
	            <h2>전달 방법을 고민하세요</h2>
	            <p class="hidden-content">
				작동 및 조립이 복잡한 제품이라면 사람들은 자연스레 영상을 궁금해 할 겁니다. 누구에게 알릴것인지 만큼 어떻게 보여줄 것인지를 고민하세요.
				단순히 광고 전단처럼 장점만 반복하는 것보다 프로젝트와 관련된 다양한 자료들을 준비하여 상황에 따라 적절하게 활용하는 것이 중요합니다.<br>
	            </p>
	        </div>		
			<div class="step">
	            <h2>직접하는 홍보가 어렵다면?</h2>
	            <p class="hidden-content">
				프로젝트를 혼자 준비하고 있거나 홍보에 대한 아이디어가 없다면 프로젝트의 타깃을 정하고 전달 방법을 고민하는 일이 무척 어렵고 버거울 수 있습니다.<br>
				<br>
				위드미에서 제공하는 광고 상품을 이용하여 프로젝트를 홍보해 보시면 어떨까요?
				페이스북, 인스타그램 등 외부 유저에게 프로젝트를 소개하는 SNS 광고 대행과 텀블벅 주요 탐색 영역에 프로젝트를 소개하는 디스플레이 광고, 프로젝트 특성에 맞는 유저에게 
				홍보 메세지를 발송할 수 있는 CRM 광고가 준비되어 있습니다.<br>
	            </p>
	        </div>		
		</section>
		<!-- ============== 6. 후원자와 소통하기 - 내용 ============== -->	
		<section class="toggle-section" id="creator_guide_6">
			<div class="step">
	            <h2>관리 도구</h2>
	            <p class="hidden-content">
				펀딩 시작부터 선물 전달까지 보다 편리하게 후원자 정보를 관리할 수 있습니다. <br>
				대시보드를 활용하면 프로젝트의 홍보를 효율적으로 관리 할 수 있습니다. <br>
				<span>
				<b>1. 대시보드</b><br>
				• 모든 위드미 펀딩은 구글 애널리틱스 분석을 통하여 누적 후원액, 후원자 성별 및 연령 정보, 프로젝트 방문 요약에 대한 데이터를 실시간으로 확인 할 수 있습니다.<br>
				<br>
				</span><br>
				<span>
				<b>2. 후원자 관리하기</b><br>
				• 후원자에 대한 모든 정보가 알기 쉽게 정리됩니다. 배송 정보와 어떤 선물을 어떤 옵션으로 선택하였는지 확인 할 수 있고 엑셀 문서로 다운받을 수 있어 배송 정보를 정리하는 일이 한결 쉬워집니다.<br>
	            </span>
	            </p>
	        </div>		
		</section>
		
		<!-- ============== 7. 전달하기 - 내용 ============== -->	
		<section class="toggle-section" id="creator_guide_7">
			<div class="step">
	            <h2>배송준비</h2>
	            <p class="hidden-content">
				예상되는 후원자 수에 맞춰 배송량을 미리 측정해 보세요. 적은 수량이라면 직접 포장하여 지역 택배사를 이용할 수 있습니다.
				직접 감당하기 어려운 양이라면 배송 전문 업체의 도움을 받는것이 효율적입니다.
				포장도 중요합니다. 박스와 완충재는 물론, 식품과 같은 선물은 특수한 포장을 필요로 할 수 있습니다. 배송에 대한 비용을 제작 예산에 포함하는 것을 잊지마세요. <br>
				<br>
	            </p>
	        </div>		
			<div class="step">
	            <h2>전달에 변동 사항이 생길 시</h2>
	            <p class="hidden-content">
				너무 많은 후원자가 생겼거나 제작 사고가 발생하여 선물 전달 일정에 변동이 생길 수도 있습니다. 먼저 후원자에게 업데이트로 신속하고 정직하게 관련 사항을 공유해주세요.
				어떤 문제가 발생했고 어떻게 해결할 것이닞, 그리고 새롭게 약속하는 일정에 대한 정보가 포함되면 좋습니다. 후원자들이 안심할 수 있도록 정기적으로
				꾸준히 업데이트로 소통하는 것 역시 중요합니다.<br>
				<br>
	            </p>
	        </div>		
		</section>
	</section>
	</main>
    	<footer>
		<!-- 회사 소개 영역(inc/bottom.jsp) 페이지 삽입 -->
		<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
	</footer>
</body>
<script type="text/javascript">
	$(document).ready(function() {
		$('.toggle-button').click(function() {
			var target = $(this).data('target');
			$(target).toggleClass('active');
			$(this).toggleClass('active');
			$('.toggle-button').not(this).removeClass('active');
			$('.toggle-section').not(target).removeClass('active');
		});
	});

</script>
</html>