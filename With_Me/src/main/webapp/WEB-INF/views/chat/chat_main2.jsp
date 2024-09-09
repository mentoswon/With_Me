<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%-- 외부 CSS 파일(css/default.css) 연결하기 --%>
<link href="${pageContext.request.servletContext.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
<style type="text/css">
	body {
		font-family: Arial, sans-serif;
		background-color: #f4f4f4;
		margin: 0;
		padding: 0;
	}

	article {
		padding: 20px;
	}

	/* 채팅방 목록 영역 */
	#chatRoomListArea {
		width: 20%;
		min-width: 150px;
		height: auto;
		background-color: #ffffff;
		border-radius: 5px;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		padding: 10px;
		overflow: auto;
		display: inline-block;
		vertical-align: top;
	}

	.chatRoomList {
		font-size: 14px;
		padding: 8px;
		margin-bottom: 5px;
		border-radius: 5px;
		cursor: pointer;
		background-color: #e9e9e9;
		transition: background-color 0.3s ease;
		position: relative;
	}

	.chatRoomList:hover {
		background-color: #FFAB40;
		color: #fff;
	}

	/* 채팅방 표시 영역 */
	#chatRoomArea {
		width: 45%;
		min-width: 350px;
		height: auto;
		background-color: #ffffff;
		border-radius: 5px;
		box-shadow: 0 2px 4px rgba(0,0,0,0.1);
		padding: 20px;
		display: inline-block;
		overflow: auto;
	}

	/* 채팅방 1개 영역 */
	.chatRoom {
		margin-bottom: 20px;
		padding: 10px;
		border-bottom: 1px solid #e0e0e0;
	}

	.chatTitleArea {
		text-align: center;
		font-size: 18px;
		font-weight: bold;
		margin-bottom: 10px;
	}

	.chatMessageArea {
		width: 95%;
		height: 250px;
		background-color: #f9f9f9;
		border-radius: 5px;
		border: 1px solid #ddd;
		padding: 10px;
		overflow-y: auto;
		margin-bottom: 10px;
	}

	/* 채팅방 메세지 입력 및 버튼 영역 */
	.commandArea {
		display: flex;
		align-items: center;
		margin-top: 10px;
	}

	.commandArea input[type="text"] {
		flex-grow: 1;
		padding: 10px;
		border-radius: 5px;
		border: 1px solid #ddd;
		margin-right: 10px;
	}

	.commandArea input[type="button"] {
		background-color: #FFAB40;
		color: #ffffff;
		border: none;
		border-radius: 5px;
		padding: 10px 20px;
		margin-left: 5px;
		cursor: pointer;
		transition: background-color 0.3s ease;
	}

	.commandArea input[type="button"]:hover {
		background-color: #ff9800;
	}

	.message {
		font-size: 14px;
		margin-bottom: 10px;
	}

	.message_align_right {
		text-align: right;
	}

	.message_align_left {
		text-align: left;
	}

	.message_align_center {
		text-align: center;
	}

	.message_align_right .chat_text {
		background-color: #f1f3f5;
		border-radius: 4px;
		padding: 5px;
		display: inline-block;
	}

	.message_align_left .chat_text {
		background-color: lightpink;
		border-radius: 4px;
		padding: 5px;
		display: inline-block;
	}

	.message_align_center .chat_text {
		background-color: skyblue;
		border-radius: 4px;
		padding: 5px;
		display: inline-block;
	}

	.sender_id, .send_time {
		font-size: 10px;
		color: #666;
	}
	
	
	
</style>
<script src="${pageContext.request.servletContext.contextPath}/resources/js/jquery-3.7.1.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
	<header>
		<%-- 기본 메뉴 표시 영역(inc/top.jsp) 페이지 삽입 --%>
		<%-- 현재 위치는 컨텍스트 루트(/MVC_Board = webapp) 이므로 inc 디렉토리의 top.jsp 지정 --%>
		<jsp:include page="/WEB-INF/views/inc/chat_top.jsp"></jsp:include>
	</header>
	<article>
		<%-- 본문 표시 영역 --%>
		<div id="chatRoomArea"> <%-- 채팅방들을 표시하는 영역 --%>
			<%-- 각각의 채팅방이 추가될 위치 --%>
<!-- 			<div class="chatRoom room_id"> -->
<!-- 				<div class="chatTitleArea">&lt;채팅방 제목&gt;</div> -->
<!-- 				<div class="chatMessageArea"></div> -->
<!-- 				<div class="commandArea"> -->
<!-- 					<input type="hidden" class="room_id" value="xxx"> -->
<!-- 					<input type="hidden" class="receiver_id" value="yyy"> -->
<!-- 					<input type="text" class="chatMessage"> -->
<!-- 					<input type="button" class="btnSend" value="전송"> -->
<!-- 					<input type="button" class="btnQuitRoom" value="대화종료"> -->
<!-- 				</div> -->
<!-- 			</div> -->
		</div>
		<div id="chatRoomListArea"> 
			<%-- 채팅방 목록을 표시하는 영역 --%>
		</div>
	</article>
	<script>
		$(function() {
			startChat();			
		});
		
		function startChat() {
			// 채팅 요청 상대방 아이디 파라미터 가져오기
			let receiver_id = "${param.receiver_id}";
			console.log("receiver_id : " + receiver_id);
			
			// 페이지 로딩 완료 시점에는 top.jsp 페이지도 포함되어 있으므로
			// 해당 페이지에서 생성한 자바스크립트의 WebSocket 객체가 ws 변수에 저장되어 있음
			// 따라서, 현재 chat_main2.jsp 페이지에서 ws 변수에 접근도 가능
			console.log("웹소켓 객체 : " + ws); // [object WebSocket]
			
			// 웹소켓 연결 상태 체크(ws.readyState 상수값이 1이면 연결된 상태)
			console.log("웹소켓 연결 상태 : " + ws.readyState);
			// => ws.readyState 값이 ws.OPEN 상수(1)과 같으면 현재 웹소켓 세션 연결된 상태
			
			// setInterval() 함수를 호출하여 0.5초(500 밀리초)마다 웹소켓 연결 상태를 감지하여
			// 연결이 됐을 경우 서버측으로 채팅방 초기화 메세지 전송
// 			setInterval(function() {
				
// 			}, milliseconds);
			// 위의 코드를 화살표 함수 형태로 변환한 코드(기능은 완벽하게 동일함)
			let wsCheckInterval = setInterval(() => { // 현재 인터벌 동작에 대한 아이디값을 변수에 저장
// 				console.log("웹소켓 객체 : " + ws); // [object WebSocket]
// 				console.log("웹소켓 연결 상태 : " + ws.readyState); // 1 이 되면 연결된 상태
				
				if(ws != null && ws != undefined && ws.readyState === ws.OPEN) { // 연결 성공 시
					console.log("1:1 채팅방 입장 및 웹소켓 연결 완료!");
				
					// 서버측으로 초기화 메세지 전송
					// top.jsp 페이지의 스크립트에 정의된 sendMessage() 함수 호출
					// => 파라미터 : 메세지타입("INIT"), 송신자아이디(""), 수신자아이디(receiver_id)
					//               채팅방아이디(""), 채팅메세지("")
					sendMessage("INIT", "", receiver_id, "", "");
					
					// 현재 인터벌 작업 종료하기 위해 clearInterval() 함수 활용
					// => 함수 파라미터로 반복 인터벌 작업 수행하는 함수의 아이디를 전달
					clearInterval(wsCheckInterval);
				}
			}, 500);
		}
	</script>
</body>
</html>












