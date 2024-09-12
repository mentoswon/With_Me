<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
	/*모달 팝업 영역 스타일링*/
	.profile {
	/*팝업 배경*/
		display: none; /*평소에는 보이지 않도록*/
	    position: absolute;
	    top:0;
	    left: 0;
	    width: 100%;
	    height: 140vh;
	    overflow: hidden;
	}
	.profile .profile_popup {
	/*팝업*/
		border: 1px solid #ccc;
	    position: absolute;
	    width: 150px;
	    top: 70px;
  		right: 205px;
/* 	    transform: translate(-50%, -50%); */
	    padding: 20px;
	    background: #ffffff;
	    z-index: 999;
	}
	.profile .profile_popup ul>li {
		margin-bottom: 15px;
	}
	.profile .profile_popup ul>li>a:hover {
		color: skyblue;
	}
	.profile .profile_popup .close_btn {
	    padding: 3px 10px;
	    background-color: #FFAB40;
	    border: none;
	    border-radius: 5px;
	    color: #fff;
	    cursor: pointer;
	    transition: box-shadow 0.2s;
	}
	.profile .profile_popup .close_btn:hover {
		box-shadow: 0 2px 5px rgba(0,0,0,0.3);
	}
	.profile.on {display: block;}
	
	
	/* 채팅 알림 */
	.name {
		position: relative;
	}
	
	.message {
		position: relative;
	}
	
	.alarm {
		position: absolute;
	    top: -6px;
	    right: -9px;
	    font-size: 12px;
	    background-color: #ffab40;
	    width: 14px;
	    height: 14px;
	    border-radius: 50%;
	    color: #fff;
	    text-align: center;
	    display: none;
	}
	
	.chatRoomList {
		position: relative;
	}
	
</style>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
	function confirmLogout() {
		let isLogout = confirm("로그아웃 하시겠습니까?");

		// isLogout 변수값이 true 일 경우 로그아웃 작업을 수행할
		// "MemberLogout" 서블릿 요청
		if (isLogout) {
			location.href = "MemberLogout";
		}
	}
	
	function projectList(category, category_detail, state) {
		if(category_detail != "") {
			location.href="ProjectList?project_category=" + category + "&project_category_detail=" + category_detail + "&project_state=" + state;
		} else {
			location.href="ProjectList?project_category=" + category + "&project_state=" + state;
		}
	}
	
	function StoreList(productCategory, productCategory_detail) {
		if(productCategory_detail != "") {
			location.href="StoreList?product_category=" + productCategory + "&product_category_detail=" + productCategory_detail;
		} else {
			location.href="StoreList?product_category=" + productCategory;
		}
	}
	
	$(function (){
		$(".storeBtn").on('click', function StoreList() {
	   		StoreList('푸드', '');
		});
	});
	
</script>

<div class="inner">
	<div id="member_area">
		<a href="./" class="main_logo">
			<img alt="로고" src="${pageContext.request.contextPath}/resources/image/withme.png">
		</a>
		<%-- session 아이디 존재 여부를 판별하여 각각 다른 링크 표시  --%>
		<%-- EL의 sessionScope 내장 객체 접근하여 sId 속성값 존재 여부 판별 --%>
		<div>
			<c:choose>
				<c:when test="${empty sessionScope.sId}"> <%-- 로그인 상태가 아닐 경우 --%>
					<button class="btn" onclick="location.href='MemberLogin'">로그인</button>
<!-- 					<button class="btn" onclick="location.href='MemberJoin'">회원가입</button> -->
					<button class="btn storeBtn" onclick="StoreList('푸드', '')">스토어</button>
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:when>
				<c:otherwise>
					<%-- 관리자 여부에 따라 이름 클릭 시 동작 구분 --%>
					<c:choose>
						<%-- 관리자일 경우 관리자메인페이지로 포워딩 --%>
						<c:when test="${sessionScope.sIsAdmin eq 'Y'}">
							<a href="AdminMemberList" class="loged">${sessionScope.sName}님</a>
						</c:when>
						<%-- 관리자가 아닐 경우(=일반 회원일 경우) 프로필 팝업 출력 --%>
						<c:otherwise>
							<%-- 하이퍼링크 상에서 자바스크립트 함수 호출 시 "javascript:함수명()" 형태로 호출 --%>
							<a href="javascript:ProfilePopupOpen()" class="loged name">${sessionScope.sName}님<div class="alarm"></div></a>
						</c:otherwise>
					</c:choose>
					<a href="javascript:confirmLogout()" class="loged">로그아웃 </a>
					<button class="btn storeBtn" onclick="StoreList('푸드', '')">스토어</button>
					<button class="btn" onclick="location.href='ProjectStart'">프로젝트 만들기</button>
				</c:otherwise>
			</c:choose>
		
		</div>
		<%-- 모바일 화면 시 클릭 하면 메뉴 뜸 --%>
		<img src="${pageContext.request.contextPath}/resources/image/menu.png" class="menuBtn">
		<img src="${pageContext.request.contextPath}/resources/image/close.png" class="menuCloseBtn">
	</div>
	
	<%-- 회원명 클릭시 출력되는 팝업 --%>
	<div class="profile">
		<div class="profile_popup">
			<ul>
				<%-- 각 메뉴에 맞는 서블릿 주소 매핑 --%>
				<li class="depth01"><a href="MemberInfo">프로필</a></li>
				<li class="depth01"><a href="MyProject">내가 만든 프로젝트</a></li>
			</ul>
			<div class="btnArea" style="text-align : center">
	        	<input type="button" class="close_btn" value="닫기" onclick="ProfilePopupClose()">
	        </div>
		</div>
	</div>
	
	<nav>
		<ul>
			<li class="depth01">
				<a href="javascript:projectList('푸드', '', '전체')"> 푸드 </a>
				<ul class="depth02">
					<li><button value="사료" onclick="projectList('푸드', this.value, '전체')" >사료</button></li>
					<li><button value="껌류" onclick="projectList('푸드', this.value, '전체')" >껌류</button></li>
					<li><button value="수제간식" onclick="projectList('푸드', this.value, '전체')" >수제간식</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('패션/위생', '', '전체')"> 패션 / 위생 </a>
				<ul class="depth02">
					<li><button value="의류" onclick="projectList('패션/위생',this.value, '전체')" >의류</button></li>
					<li><button value="화장실" onclick="projectList('패션/위생',this.value, '전체')" >화장실</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('식기/급수기', '', '전체')"> 식기 / 급수기 </a>
				<ul class="depth02">
					<li><button value="급식기" onclick="projectList('식기/급수기',this.value, '전체')" >급식기</button></li>
					<li><button value="급수기" onclick="projectList('식기/급수기',this.value, '전체')" >급수기</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('장난감/훈련', '', '전체')"> 장난감 / 훈련 </a>
				<ul class="depth02">
					<li><button value="장난감" onclick="projectList('장난감/훈련',this.value, '전체')" >장난감</button></li>
					<li><button value="훈련용품" onclick="projectList('장난감/훈련',this.value, '전체')" >훈련용품</button></li>
				</ul>
			</li>
			
			<li class="depth01">
				<a href="javascript:projectList('하우스/안전', '', '전체')"> 하우스 / 안전 </a>
				<ul class="depth02">
					<li><button value="하우스" onclick="projectList('하우스/안전',this.value, '전체')" >하우스</button></li>
					<li><button value="울타리" onclick="projectList('하우스/안전',this.value, '전체')" >울타리</button></li>
					<li><button value="기타안전용품" onclick="projectList('하우스/안전',this.value, '전체')" >기타안전용품</button></li>
				</ul>
			</li>
		</ul>
		
		<%-- 검색 form 태그 추가 예정 --%>
		<form action="ProjectList">
			<input type="text" id="search" name="searchKeyword" value="${param.searchKeyword}">
			<input type="submit" id="searchBtn" value="">		
		</form>
	</nav>
</div>

<script>
	let profile = document.querySelectorAll('.profile');
	// 프로필 팝업 띄우기
	function ProfilePopupOpen() {
		profile[0].classList.add('on');
	}
	// 프로필 팝업 닫기 - 팝업창 바깥을 클릭했을 경우
	let isClicked = true;
	$(".profile").click(function() {
		$(".profile_popup").click(function() { // 페이지 새로고침 후 처음 한번은 함수가 작동하지 않는 현상이 있음
			isClicked = false;                 // (두번째부터는 정상적으로 작동함)
		});
// 		console.log("isClicked : " + isClicked);
		if(isClicked) {
			profile[0].classList.remove('on');
		} else {
			isClicked = true;
		}
	});
	// 프로필 팝업 닫기 - 닫기 버튼을 클릭했을 경우
	function ProfilePopupClose() {
		profile[0].classList.remove('on');
	}
</script>
<c:if test="${not empty sId}">
	<script>
		let ws; // WebSocket 객체가 저장될 변수 선언 
		let messageCount = 0; // 초기 메시지 카운트
		// -----------------------------------------------------------------------------------
		$(function() {
			// 페이지 로딩 완료 시 채팅방 입장을 위해 웹소켓 연결을 수행할 connect() 함수 호출
			connect();
		});
		// ==================================================================================
		// 최초 1회 웹소켓 연결을 수행하는 connect() 함수 정의
		function connect() {
			// 요청 주소 생성(웹소켓 기본 프로토콜은 ws, 보안 프로토콜은 wss)
			// EL 활용하여 request 객체 정보 추출을 통해 현재 서버 주소 지정 가능
			let ws_base_url = "ws://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}";
			console.log(ws_base_url);
			
			// WebSocket 객체 생성하여 서버측에 웹소켓 통신 연결 요청(최초 연결을 위한 handshaking 수행)
			// => 파라미터 : 웹소켓 요청을 위한 프로토콜 및 URL(ws://주소:포트/매핑주소)
			ws = new WebSocket(ws_base_url + "/echo2");
			// => 개발자 도구의 Network 탭에서 에서 확인 가능(일반 HTTP 요청과 다른 형태로 구분됨)
			// => 반드시 /echo 요청에 대한 웹소켓 매핑 작업을 서버측에서 수행해야한다!
			//    (최초의 웹소켓 주소 매핑은 설정 파일(xml)에서 수행)
			// => 서버(스프링)에서 WebSocketHandler 구현체의 afterConnectionEstablished() 메서드 자동 호출됨
			
			// WebSocket 객체의 onxxx 이벤트에 각 함수 연결하여 특정 웹소켓 이벤트 발생 시 작업 수행
			// => 웹소켓을 통해 각종 정보를 주고 받으므로 이벤트 정보도 웹소켓을 통해 수신
			//    따라서, HTTP 통신이 아니므로 개발자 도구를 통해 확인 어려움
			ws.onopen = onOpen; // 웹소켓 연결(open) 시 onOpen 함수 호출하도록 연결
			ws.onclose = onClose; // 웹소켓 연결 해제(close) 시 onClose 함수 호출하도록 연결
			ws.onmessage = onMessage; // 웹소켓 메세지 수신(message) 시 onMessage 함수 호출하도록 연결
			ws.onerror = onError; // 웹소켓 에러(error) 시 onError 함수 호출하도록 연결
			// => 각각의 요청에 대한 응답에 맞는 콜백 메서드가 해당 시점에 자동으로 호출됨
		}	
		// ------------------------------------------------------------------------------------
		function onOpen() {
			console.log("onOpen()");
		}
		// ======================================================================
		function onClose() {
			console.log("onClose()");
		}
		// ======================================================================
		function onMessage(event) {
			let data = JSON.parse(event.data);
			console.log("onMessage() 수신된 데이터 : " + JSON.stringify(data)); 
			
			// 메세지 타입 판별
			if(data.type == "INIT") { // 채팅페이지 초기 진입
				// 채팅방 목록 표시 영역 초기화
				$("#chatRoomListArea").empty();
			
				// 전달받은 message 속성값에 채팅방 목록이 저장되어 전송되므로
				// 해당 목록을 다시 JSON 객체 형태로 파싱
				// => 복수개의 채팅방 목록이 배열 형태로 전달되므로 반복을 통해 객체 접근
				for(let room of JSON.parse(data.message)) {
					// appendChatRoomToRoomList() 함수 호출하여 채팅방 목록 표시
					
					appendChatRoomToRoomList(room);
				}
				
				// 초기화 완료 메세지 전송
				// => 메세지 타입 : INIT_COMPLETE, 수신자 아이디도 함께 전송
				sendMessage("INIT_COMPLETE", "", data.receiver_id, "", "");
			} else if(data.type == "ERROR") { // 채팅 관련 오류
				// 사용자에게 오류메세지 표시 및 이전 페이지로 돌아가기
				alert(data.message + "\n이전 페이지로 돌아갑니다.");
				history.back();
			} else if(data.type == "START") { // 채팅방 추가
				// 채팅방 생성(표시) 및 채팅방 목록 표시
				// 1. 채팅방 목록에 새 채팅방 추가를 위해 appendChatRoomToRoomList() 함수 호출
				//    (기존 대화내역이 없는 사용자와 채팅 시작 시 채팅방 목록에 새 채팅방 추가 위함)
				// => 파라미터 : data 객체 내의 message 속성값을 파싱하여 룸 1개 정보 전달
				appendChatRoomToRoomList(JSON.parse(data.message));
				
				// 2. 채팅방 표시 위해 createChatRoom() 함수 호출
				// => 파라미터 : data 객체(파싱 X)
				createChatRoom(data);
			} else if(data.type == "REQUEST_CHAT_LIST") { // 기존 채팅 메세지 내역 수신 
				// 기존 채팅 내역이 저장된 message 내의 리스트 반복하여 
				// appendMessageToTargetRoom() 메서드 호출하여 메세지 표시
				for(let message of JSON.parse(data.message)) {
					// 파싱된 1개 메세지의 정보들을 파라미터로 전달
					appendMessageToTargetRoom(message.type, message.sender_id, message.receiver_id, message.room_id, message.message, message.send_time);
				}
			} else if(data.type == "TALK") { // 채팅 메세지 수신
				// 메세지 알람
				messageCount++;
				createAlarm(messageCount);
				
				// 채팅방 생성(표시) 및 채팅방 목록 표시
				appendChatRoomToRoomList(data);
				createChatRoom(data);
				
				// appendMessageToTargetRoom() 함수 호출하여 수신된 메세지를 채팅방에 표시
				appendMessageToTargetRoom(data.type, data.sender_id, data.receiver_id, data.room_id, data.message, data.send_time);
				
				
			} else if(data.type == "LEAVE") { // 채팅 종료 메세지 수신
				appendMessageToTargetRoom(data.type, data.sender_id, data.receiver_id, data.room_id, data.message, data.send_time);
				disableRoom(data);
			}
		}
		// ======================================================================
		// 메세지 알람
		function createAlarm(messageCount){
			console.log("숫자 : " + messageCount);
			let alarm = 				
					"<span class='alarmCont'>"
					+ messageCount
					+ "</span>";
					
			$(".alarm").css("display", "block");
			$(".alarm").html(alarm);
		}
			
			
		// ======================================================================
		// 상대방이 종료한 채팅방을 비활성화하는 함수
		function disableRoom(room) {
			// 룸아이디가 일치하는 채팅방 영역 탐색
			let chatRoom = $("#chatRoomArea").find("." + room.room_id);
// 			console.log($(chatRoom).html());
			
			// 메세지 표시영역 색상 어둡게
			$(chatRoom).find(".chatMessageArea").css("background", "#CCCCCCAA");
			// 채팅방 제목에 종료 표시
			$(chatRoom).find(".chatTitleArea").text($(chatRoom).find(".chatTitleArea").text() + "(종료됨)");
			// 채팅 메세지 입력창과 전송 버튼 비활성화
			$(chatRoom).find(".chatMessage").prop("disabled", true);
			$(chatRoom).find(".btnSend").prop("disabled", true);
		}
		// ======================================================================
		// 채팅방 영역에 1개의 채팅방 생성(표시)하는 함수
		function createChatRoom(room) {
			console.log(JSON.stringify(room));
			
			// 수신자가 세션 아이디와 동일할 경우
			// 방 생성에 필요한 receiver_id 값을 송신자 아이디로 변경, 아니면 그대로 사용
			let receiver_id = room.receiver_id == "${sId}" ? room.sender_id : room.receiver_id;
// 			console.log("receiver_id : " + receiver_id);
			
			// 클래스 선택자 중 "chatRoom" 클래스를 갖는 요소를 찾아
			// 해당 요소의 클래스에 룸아이디가 포함되어 있지 않을 경우
			// 채팅방 영역에 새 채팅방 1개 추가
			if(!$(".chatRoom").hasClass(room.room_id)) {
				console.log("채팅방 표시 시작!");
				// 생성할 채팅방 div 태그 문자열을 변수에 저장
				// => 생성할 채팅방 hidden 태그에 채팅방의 룸아이디와 수신자아이디를 저장
				let divRoom = '<div class="chatRoom ' + room.room_id + '">'
							+ '	<div class="chatTitleArea">&lt;' + receiver_id + '&gt;</div>'
							+ '	<div class="chatMessageArea"></div>'
							+ '	<div class="commandArea">'
							+ '		<input type="hidden" class="room_id" value="' + room.room_id + '">'
							+ '		<input type="hidden" class="receiver_id" value="' + receiver_id + '">'
							+ '		<input type="text" class="chatMessage" onkeypress="checkEnter(event)">'
							+ '		<input type="button" class="btnSend" value="전송" onclick="send(this)"><br>'
							+ '		<input type="button" class="btnCloseRoom" value="닫기" onclick="closeRoom(this)">'
							+ '		<input type="button" class="btnQuitRoom" value="종료" onclick="quitRoom(this)">'
							+ '	</div>'
							+ '</div>';
							
				// ID 선택자 "chatRoomArea" 영역에 채팅방 1개 추가
				$("#chatRoomArea").append(divRoom);
				// ----------------------------------------------------------
				// 기존 채팅 내역을 불러오기 위한 요청 전송
				// => 메세지 타입을 "REQUEST_CHAT_LIST" 타입으로 지정
				sendMessage("REQUEST_CHAT_LIST", "", "", room.room_id, "");
				
				// 채팅방 상태(status)가 2 일 경우(상대방이 채팅을 종료)
				// 채팅방 표시하되 비활성화 상태로 표시하기 위해 
				// disableRoom() 함수 호출
				if(room.status == 2) {
					disableRoom(room);
				}
			}
		}
		
		// ======================================================================
		// 채팅 메세지 입력창 엔터키 입력을 판별하는 함수
		function checkEnter(event) {
// 			console.log(event); // 이벤트 객체
// 			console.log(event.target); // 이벤트가 발생한 요소 객체(파라미터로 this 전달 대신 활용)
			
			// 누른 키의 코드값(event.keyCode) 가져와서 엔터키(코드값 13)인지 판별
			if(event.keyCode == 13) {
				// 메세지를 전송하는 send() 함수 호출하여 이벤트 발생 요소 객체 전달
				send(event.target);
			}

		}
		// ======================================================================
		// 채팅방 1개 닫기(종료가 아닌 화면 상에서 채팅방 제거)
		function closeRoom(elem) {
			let parent = $(elem).parent(); // 닫기 버튼의 부모(commandArea) 탐색
			let chatRoom = $(parent).parent(); // commandArea 의 부모(chatRoom) 탐색
// 			console.log($(parent).html());
			$(chatRoom).remove(); // chatRoom(해당 채팅방) 제거
			// 단, 부모의 부모 탐색 대신 부모 요소의 자식들 중 room_id 를 탐색하여
			// chat_room 클래스 선택자에 룸 아이디가 동일한 요소를 제거해도 동일함
		}
		// ======================================================================
		// 채팅방 1개 대화 종료
		function quitRoom(elem) {
			if(confirm("채팅방을 나가시겠어요?")) {
				let parent = $(elem).parent(); // 닫기 버튼의 부모(commandArea) 탐색
	// 			let chatRoom = $(parent).parent(); // commandArea 의 부모(chatRoom) 탐색
	// 			$(chatRoom).remove(); // chatRoom(해당 채팅방) 제거
				// 단, 부모의 부모 탐색 대신 부모 요소의 자식들 중 room_id 를 탐색하여
				// chat_room 클래스 선택자에 룸 아이디가 동일한 요소를 제거해도 동일함
				let room_id = $(parent).find(".room_id").val(); // 룸 아이디 가져오기
				console.log("room_id : " + room_id);
				
				let receiver_id = $(parent).find(".receiver_id").val(); // 수신자 아이디 가져오기
				console.log("receiver_id : " + receiver_id);
				
				// 클래스 선택자가 chatRoom 이면서 room_id 인 채팅방 1개 요소 제거
				$(".chatRoom." + room_id).remove();
				
				// 클래스 선택자가 chatRoomList 이면서 room_id 인 채팅방 목록 1개 요소 제거
				$(".chatRoomList." + room_id).remove();
				
				// 채팅방 종료를 위해 서버로 종료 신호 전송
				// => 메세지 타입 : "LEAVE", 송신자 아이디, 수신자 아이디, 룸 아이디 전송
				sendMessage("LEAVE", "${sId}", receiver_id, room_id, "");
			}
			
		}
		// ======================================================================
		// 전송 버튼 클릭 시 채팅 메세지를 전송하는 함수(파라미터로 태그 요소 객체 전달받음)
		function send(elem) {
// 			console.log(elem);
			
			// 메세지가 입력된 채팅방 구분
			// 1) 전달받은 요소 객체의 부모 요소(class="commandArea") 탐색 => parent() 메서드 활용
			let parent = $(elem).parent(); // commandArea 클래스 선택자 내의 요소가 객체로 리턴됨
// 			console.log("parent : " + $(parent).html()); // 해당 요소 태그 확인
			
			// 2) 해당 부모 요소의 자식 요소의 value 값에 접근 => find() 메서드 활용
			let inputElement = $(parent).find(".chatMessage"); // 텍스트박스 요소 가져오기
			let message = $(inputElement).val();
			let room_id = $(parent).find(".room_id").val();
			let receiver_id = $(parent).find(".receiver_id").val();
// 			console.log("message : " + message + ", room_id : " + room_id + ", receiver_id : " + receiver_id);

			// 입력메세지 비어있을 경우 입력창 포커스 요청 후 작업 종료
			if(message == "") {
				$(inputElement).focus();
				return;
			}
			
			// 채팅 메세지를 서버로 전송할 sendMessage() 함수 호출
			// => 메세지 타입 : "TALK"
			// => 송신자 아이디 : 세션 아이디
			// => 수신자 아이디, 룸 아이디, 메세지는 전달받은 값 사용
			sendMessage("TALK", "${sId}", receiver_id, room_id, message);
			
			// 자신의 채팅창에 입력한 메세지 출력을 위해 appendMessageToTargetRoom() 함수 호출
			// => sendMessage() 함수 호출 파라미터와 동일하게 전달
			appendMessageToTargetRoom("TALK", "${sId}", receiver_id, room_id, message);
			
			// 채팅 메세지 입력창 초기화 후 포커스 요청
			$(inputElement).val("");
			$(inputElement).focus();
			
		}
		// ======================================================================
		// 문자열로 된 날짜(yyyy-MM-dd hh:mm:ss)를 Date 객체로 변환하여 리턴하는 함수
		function convertDateStringToDate(send_time) {
			// Date 객체의 문자열 형식("yyyy-MM-ddThh:mm:ss")에 맞게 변환하여 리턴
			return new Date(send_time.split(" ")[0] + "T" + send_time.split(" ")[1]);
		}
		// ======================================================================
		// 채팅창에 메세지를 출력하는 함수
		function appendMessageToTargetRoom(type, sender_id, receiver_id, room_id, message, send_time, read_status) {
			// --------------------- 채팅 메세지 날짜 변환하기 ----------------------
			// send_time 값이 비어있을 경우(undefined) 현재 시스템 날짜 설정하고
			// 아니면, 전송받은 날짜를 Date 객체로 변환
			let date;
			if(send_time == undefined) {
				date = new Date();
			} else {
				date = convertDateStringToDate(send_time);
			}
// 			console.log(date);
			
			// 기본적으로 시각(시:분)은 표시되므로 먼저 전송 시각 저장
			send_time = date.getHours() + ":" + String(date.getMinutes()).padStart(2, '0');
			
			let now = new Date(); // 시스템 날짜를 기준으로 Date 객체 생성
			// date 변수에 저장된 메세지 전송 날짜가 오늘이 아닐 경우 전송 날짜를 추가
// 			console.log(date.getMonth() + ", " + now.getMonth() + ", " + date.getDate() + ", " + now.getDate());
			if(date.getMonth() != now.getMonth() || date.getDate() != now.getDate()) {
				send_time = (date.getMonth() + 1) + "-" + date.getDate() + " " + send_time;
			}
			
			// date 변수에 저장된 메세지 전송 날짜가 올해가 아닐 경우 전송 연도도 추가
			if(date.getFullYear() != now.getFullYear()) {
				send_time = date.getFullYear() + "-" + send_time;
			}
			// ------------------------------------------------------------------------
			// 메세지 타입에 따라 정렬 위치 다르게 표시하기 위한 div 태그 생성
			let div_message = "";
			
			// 메세지 타입 판별
			if(type != "TALK") { // 시스템 메세지
				// 가운데 정렬을 통해 메세지만 표시
				div_message = "<div class='message message_align_center'><span class='chat_text'>" + message + "</span></div>";
			} else if(sender_id == "${sId}") { // 자신의 메세지(송신자가 자신인 경우)
				// 우측 정렬을 통해 메세지만 표시
				div_message = "<div class='message message_align_right'><span class='send_time'>" + send_time + "</span><span class='chat_text'>" + message + "</span></div>";
			} else if(receiver_id == "${sId}") { // 상대방 메세지(수신자가 자신인 경우)
				// 좌측 정렬을 통해 상대방 아이디와 메세지 표시
				div_message = "<div class='message message_align_left'><div class='sender_id'>" + sender_id + "</div><span class='chat_text'>" + message + "</span><span class='send_time'>" + send_time + "</span></div>";
			}
			
			// 룸 아이디가 일치하는 채팅방 영역 탐색
			let chatRoom = $("#chatRoomArea").find("." + room_id);
			// 해당 채팅방 영역의 채팅 메세지 영역(".chatMessageArea") 탐색하여 메세지 추가
			$(chatRoom).find(".chatMessageArea").append(div_message);
			
			let chatMessageArea = $(chatRoom).find(".chatMessageArea");
			// 채팅 메세지 출력창의 스크롤바를 항상 맨 밑으로 유지
			// div 영역의 크기 대신 스크롤바의 크기를 구한 뒤(요소(배열 0번 인덱스)의 scrollHeight)
			// 해당 크기를 채팅 메세지 표시 영역의 스크롤바 위치로 지정
			$(chatMessageArea).scrollTop($(chatMessageArea)[0].scrollHeight);
		}
		// ======================================================================
		// 채팅방 목록 영역에 1개 채팅방 정보를 추가하는 함수
		function appendChatRoomToRoomList(room) {
			
			// 클래스 선택자 중 "chatRoomList" 클래스를 갖는 요소를 찾아
			// 해당 요소의 클래스에 룸아이디가 포함되어 있지 않을 경우
			// 채팅방 목록에 새 채팅방 목록으로 추가
			if(!$(".chatRoomList").hasClass(room.room_id)) {
				// 채팅방 제목과 채팅방 상태가 전달되지 않았을 경우 기본값 설정
				// => 제목은 상대방 아이디 + " 님과의 대화" 로 설정하고
				//    채팅방 상태는 1로 설정
				console.log("room.title : " + room.title + ", room.status: " + room.status);
				
				let title = room.title == undefined ? room.sender_id + " 님과의 대화" : room.title;
				let status = room.status == undefined ? 1 : room.status;
				
				// 안 읽은 메세지 개수
// 				let unreadMessage = room.unread_count;
					
				// 채팅방 상태(status) 가 2일 경우 채팅방 목록의 제목에 (종료) 추가
				if(status == 2) {
					title += " (종료)"; 
				}
				
				// 새로 생성할 채팅방 목록 1개의 div 태그 작성
				let divRoom = "<div class='chatRoomList " + room.room_id + " status_" + status + "'>"
							+ title
							+ "</div>";
				$("#chatRoomListArea").append(divRoom);
				
				// 해당 채팅방 목록 div 태그에 더블클릭 이벤트 핸들링
				// => 복수개의 class 선택자 검색이므로 마침표로 연결
				// => ex) <div class="chatRoomList xxxxxxxx"> => $(".chatRoomList.xxxxxxxx")
				$(".chatRoomList." + room.room_id).on("dblclick", function() {
					// 채팅방 1개 생성하도록 createChatRoom() 함수 호출
					// => 파라미터 : 채팅방 1개 정보가 저장된 room 객체
					createChatRoom(room);
				});
			}
		}
		
		// ======================================================================
		function onError() {
			console.log("onError()");
		}
		// ======================================================================
		// 전달받은 메세지를 웹소켓 서버측으로 전송하는 함수
		// => 함수 호출 형태 : sendMessage(메세지타입, 송신자아이디, 수신자아이디, 채팅방아이디, 메세지)
		// => 함수 호출 예시 : sendMessage("TALK", sender_id, receiver_id, room_id, "안녕하세요")
		function sendMessage(type, sender_id, receiver_id, room_id, message) {
			// WebSocket 객체의 send() 메서드 호출하여 서버측으로 메세지 전송
			// => 전송할 메세지를 toJsonString() 함수를 통해 JSON 형식으로 변환하여 전송
			ws.send(toJsonString(type, sender_id, receiver_id, room_id, message));
		}
		
		// ======================================================================
		// 전달받은 메세지타입과 메세지를 JSON 형식 문자열로 변환하는 toJsonString() 함수
		function toJsonString(type, sender_id, receiver_id, room_id, message) {
			// 전달받은 파라미터들을 하나의 객체로 묶어 JSON 타입 문자열로 변환 후 리턴
			let data = {
				type : type,
				sender_id : sender_id,
				receiver_id : receiver_id,
				room_id : room_id,
				message : message
			};
			
			// JSON.stringify() 메서드 호출하여 객체 -> JSON 문자열로 변환
			return JSON.stringify(data);
		}
		
		
	</script>
</c:if>

<script>
	//=========================================================================
	// 반응형
	$(function (){
		let menuBtn = document.querySelector('.menuBtn');
		let menuCloseBtn = document.querySelector('.menuCloseBtn');
		let menu = document.querySelector('nav>ul');
		
		menuBtn.onclick = function () {
			menuBtn.classList.add('on');
			menuCloseBtn.classList.add('on');
			menu.classList.add('on');
		}
		
		menuCloseBtn.onclick = function () {
			menuBtn.classList.remove('on');
			menuCloseBtn.classList.remove('on');
			menu.classList.remove('on');
		}
		
	});
</script>
