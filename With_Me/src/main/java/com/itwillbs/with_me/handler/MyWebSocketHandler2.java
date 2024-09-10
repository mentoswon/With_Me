package com.itwillbs.with_me.handler;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.google.gson.Gson;
import com.itwillbs.with_me.service.ChatService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.ChatMessage2;
import com.itwillbs.with_me.vo.ChatRoom;

public class MyWebSocketHandler2 extends TextWebSocketHandler {
	// 접속한 클라이언트(사용자)들에 대한 정보를 저장하기 위한 Map 객체 생성
	// => Key : 웹소켓 세션 아이디(문자열)   Value : 웹소켓 세션 객체(WebSocketSession 타입 객체)
	// => Map 의 구현체 클래스 HashMap 타입 대신 ConcurrentHashMap 타입 사용 시
	//    다수의 사용자가 하나의 객체에 접근하는 멀티쓰레딩 환경에서
	//    객체 동시 접근 시에도 락(Lock)을 통해 안전하게 데이터 접근 가능
	private Map<String, WebSocketSession> userSessions = new ConcurrentHashMap<String, WebSocketSession>();
	
	// 접속한 사용자의 HttpSession 아이디와 WebSocketSession 객체의 아이디를 관리할 Map 객체 생성
	// => 사용자마다 갱신되는 WebSocketSession 객체를 HttpSession 객체의 sId 속성값과 연결하여
	//    WebSocketSession 객체가 갱신되더라도 갱신된 정보를 HttpSession 세션 아이디를 통해 구별(유지)
	// => users 객체의 key 에 해당하는 value - userSessions 의 key 가 연결됨
	//    (= 사용자 아이디를 통해 상대방의 WebSocketSession 객체에 접근 가능)
	private Map<String, String> users = new ConcurrentHashMap<String, String>();
	// ------------------------------------------------------------------------------
	// JSON 데이터 파싱 작업을 처리할 Gson 객체 생성
	private Gson gson = new Gson();
	// ------------------------------------------------------------------------------
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private ChatService chatService;
	// ------------------------------------------------------------------------------
	// 웹소켓을 통해 통신을 수행하는 과정에서 자동으로 호출될 메서드들 오버라이딩
	// 1) 최초 웹소켓 연결 시 스프링에서도 WebSocket 관련 객체가 생성되며, 이 때 자동으로 호출되는 메서드
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		System.out.println("웹소켓 연결됨(afterConnectionEstablished)");
		
		// userSessions Map 객체에 웹소켓 클라이언트 정보(WebSocketSession 아이디, WebSocketSession 객체) 저장
		userSessions.put(getWebSocketSessionId(session), session);
		
		// users Map 객체에 사용자 정보(HttpSession 아이디, WebSocketSession 아이디) 저장
		users.put(getHttpSessionId(session), session.getId());
		
		System.out.println("클라이언트 목록(" + userSessions.keySet().size() + "명) : " + userSessions);
		System.out.println("사용자 목록(" + users.keySet().size() + "명) : " + users);
	}

	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
//		System.out.println("메세지 수신됨(handleTextMessage)");
//		System.out.println("수신된 메세지 : " + message.getPayload());
		
		// 수신된 메세지(JSON 형식 문자열)를 ChatMessage2 타입 객체로 변환 => gson.fromJson() 활용
		ChatMessage2 chatMessage = gson.fromJson(message.getPayload(), ChatMessage2.class);
		System.out.println("chatMessage : " + chatMessage);
		System.out.println("메세지 수신 시각 : " + getDateTimeForNow());
		// -----------------------------------------------------------------------------------
		// 송신자 아이디와 수신자 아이디를 가져와서 변수에 저장
		String sender_id = getHttpSessionId(session); // 송신자 아이디는 HttpSession 객체의 세션 아이디
		String receiver_id = chatMessage.getReceiver_id();
		System.out.println("송신자 : " + sender_id + ", 수신자 : " + receiver_id);
		
		// ChatMessage2 객체에 송신자 아이디 설정
		chatMessage.setSender_id(sender_id);
		// -----------------------------------------------------------------------------------
		// 수신된 메세지 타입 판별
		if(chatMessage.getType().equals(ChatMessage2.TYPE_INIT)) { // 채팅페이지 초기 진입 메세지
			// DB 에 저장된 기존 채팅방 목록(= 자신의 아이디가 포함된 채팅) 조회 후 목록 전송
			// ChatService - getChatRoomList() 메서드 호출
			// => 파라미터 : 송신자(자신)의 아이디   리턴타입 : List<ChatRoom>(chatRoomList)
			List<ChatRoom> chatRoomList = chatService.getChatRoomList(sender_id);
			System.out.println("기존 채팅방 목록 : " + chatRoomList);
			
			// 조회 결과를 JSON 형식으로 변환하여 메세지로 설정
			chatMessage.setMessage(gson.toJson(chatRoomList));
			
			// sendMessage() 메서드 호출하여 클라이언트측으로 메세지 전송
			sendMessage(session, chatMessage);
			
		} else if(chatMessage.getType().equals(ChatMessage2.TYPE_INIT_COMPLETE)) { // 채팅페이지 초기화 완료 메세지
			// 초기화 완료 메세지의 수신자 포함 여부 판별
			if(!receiver_id.equals("")) {
				System.out.println("수신자 아이디 있음!");
				// -----------------------------------------------------------------------
				// [ 메세지를 수신할 상대방 존재 여부 확인 ]
				// 1) users 객체에 상대방 아이디(= 키) 존재 여부 확인
				//    => Map 객체(users) 의 get() 메서드를 통해 
				//       HttpSession 객체의 세션 아이디("sId" 키)에 해당하는
				//       WebSocketSession 객체의 아이디(값) 확인
				//       => null : 접속 기록 없음, null이 아니면 접속 기록 있음
//				System.out.println("users.get(receiver_id) : " + users.get(receiver_id));
//				boolean isConnectUser = users.get(receiver_id) == null ? false : true;
//				if(!isConnectUser) { // 접속중인 사용자가 아닐 경우
//					
//				}
				
				if(users.get(receiver_id) == null) { // 접속중인 사용자가 아닐 경우
					// 2) MemberService - getMemberId() 메서드 호출하여 DB 에서 상대방 아이디 검색
					//    => 파라미터 : 수신자 아이디   리턴타입 : String(dbReceiverId)
					String dbReceiverId = memberService.getMemberId(receiver_id);
//					System.out.println("dbReceiverId : " + dbReceiverId);
					
					if(dbReceiverId == null) { // DB 에도 상대방 아이디가 존재하지 않을 경우
						// 메세지 송신자에게 오류 메세지 전송 후 메서드 종료(송신자를 수신자 아이디 자리에 설정)
						ChatMessage2 errorMessage = new ChatMessage2(
								ChatMessage2.TYPE_ERROR, "", sender_id, "", "사용자가 존재하지 않습니다!", "");
						sendMessage(session, errorMessage);
						return;
					}
				}
				// -----------------------------------------------------------------
				// 상대방 존재할 경우 채팅창 표시(신규 채팅방 or 기존 채팅방)
				// ChatService - getChatRoom() 메서드 호출하여 상대방과의 기존 채팅방 존재 여부 확인
				// => 파라미터 : 송신자 아이디, 수신자 아이디   리턴타입 : ChatRoom(chatRoom)
				ChatRoom chatRoom = chatService.getChatRoom(sender_id, receiver_id);
				
				if(chatRoom == null) {
					System.out.println("채팅방 없음 - 새로운 채팅방 생성!");
					
					// 1. 새 채팅방의 방번호(room_id) 생성 => getRoomId() 메서드 활용
					chatMessage.setRoom_id(getRoomId());
					System.out.println(chatMessage);
					
					// 2. ChatService - addChatRoom() 메서드 호출하여 새 채팅방 정보 DB 에 저장(임시)
					// => 파라미터 : List<ChatRoom> 객체(chatRoomList)   리턴타입 : void
					// => 1개의 채팅방 정보(룸아이디, 제목, 사용자아이디, 상태)를 갖는
					//    ChatRoom 객체를 송신자와 수신자 각각에 대해 생성하여 List 객체에 추가
					List<ChatRoom> chatRoomList = new ArrayList<ChatRoom>();
					// ChatRoom 객체 각각에 데이터 저장 시 sender_id 만 활용하지만 두 정보 모두 설정(송수신자 반대로하여 다른 하나도 설정)
					// status 값은 정상적인 채팅방 표시로 1 전달
					chatRoomList.add(new ChatRoom(chatMessage.getRoom_id(), receiver_id + " 님과의 대화", sender_id, receiver_id, 1, 0));
					chatRoomList.add(new ChatRoom(chatMessage.getRoom_id(), sender_id + " 님과의 대화", receiver_id, sender_id, 1, 0));
					chatService.addChatRoom(chatRoomList);
					// -------------------------------
					// 3. 채팅 메세지 객체 정보 설정 
					// => 리스트의 0번 인덱스에 저장된 ChatRoom 객체 활용(자신의 채팅방 정보)
					// 3-1. 채팅방 정보 설정(ChatRoom 객체 1개를 JSON 형식으로 변환하여 메세지에 저장)
//					System.out.println(chatRoomList);
//					chatMessage.setMessage(gson.toJson(chatRoomList.get(0)));
					
					// 3-2. 송신자 화면에 새 채팅방 목록 추가를 위한 타입 지정
					chatMessage.setType(ChatMessage2.TYPE_START);

					// 3-3. 채팅 메세지에 채팅방 상태값(status)과 채팅방 제목 설정
//					chatMessage.setMessage(chatRoomList.get(0).getStatus() + "/" + chatRoomList.get(0).getTitle());
					// => 위에서 생성한 채팅방 목록에서 첫번째 인덱스에 저장된 객체(채팅방 1개) 꺼내서 ChatRoom 객체 저장
					chatRoom = chatRoomList.get(0);
					chatMessage.setMessage(gson.toJson(chatRoom));
					
					// 4. 송신자에게 메세지 전송
					sendMessage(session, chatMessage);
				} else {
					System.out.println("채팅방 있음 - 새로운 채팅방 생성 불필요!");
					
					// 기존 채팅방이 존재하므로 DB 작업은 불필요
					// 채팅 메세지 객체 정보 설정 
					// 조회된 룸 아이디 저장
					chatMessage.setRoom_id(chatRoom.getRoom_id());
					
					// 채팅 시작을 위한 START 타입 설정
					chatMessage.setType(ChatMessage2.TYPE_START);
					
					// 채팅 메세지에 채팅방 상태값(status) 설정
//					chatMessage.setMessage(chatRoom.getStatus() + "/" + chatRoom.getTitle());
					// => 문자열 결합 대신 조회된 채팅방 정보(ChatRoom 객체)를 JSON 으로 변환하여 저장
					chatMessage.setMessage(gson.toJson(chatRoom));
					
					
					// 송신자에게 메세지 전송
					sendMessage(session, chatMessage);
				}
				
			} else {
				// 수신자 아이디가 없을 경우 채팅방 목록만 표시하면 되므로
				// 실제로는 else 문 자체가 불필요
				System.out.println("수신자 아이디 없음!");
			}
		} else if(chatMessage.getType().equals(ChatMessage2.TYPE_REQUEST_CHAT_LIST)) {
			// ChatService - getChatMessageList() 메서드 호출하여 기존 채팅 내역 조회 요청
			// => 파라미터 : room_id   리턴타입 : List<ChatMessage2>(chatMessageList)
			List<ChatMessage2> chatMessageList = chatService.getChatMessageList(chatMessage.getRoom_id());
			
			
			// 기존 채팅 내역 존재할 경우에만 클라이언트측으로 전송
			if(chatMessageList.size() > 0) {
				// 채팅 내역을 JSON 형식으로 변환하여 메세지로 전송
				chatMessage.setMessage(gson.toJson(chatMessageList));
				sendMessage(session, chatMessage);
			}
			
		} else if(chatMessage.getType().equals(ChatMessage2.TYPE_TALK)) {
			System.out.println("채팅 메세지 수신됨 - " + chatMessage);
			
			// getDateTimeForNow() 메서드 호출하여 현재 시스템 날짜 및 시각 정보 저장하기
			chatMessage.setSend_time(getDateTimeForNow());
			
			System.out.println("메세지 수신자 : " + users.get(receiver_id));
			
			// ChatService - addChatMessage() 메서드 호출하여 채팅 메세지 DB 저장 요청
			// => 파라미터 : ChatMessage2 객체
			chatService.addChatMessage(chatMessage);
			
			// 채팅 메세지 전송할 사용자 확인(user 객체에 receiver_id를 통해 판별)
			if(users.get(receiver_id) != null) { // 현재 수신자가 접속해 있을 경우
				// 탐색된 receiver_id에 해당하는 웹소켓 세션 객체의 세션 아이디를 활용하여
				// userSessions 객체의 웹소켓 세션 객체를 가져와서 메세지 전송 요청
				WebSocketSession receiver_ws = userSessions.get(users.get(receiver_id));
				// sendMessage() 메서드 호출하여 메세지 전송 요청
				// => 파라미터 : 수신자 WebSocketSession 객체, ChatMessage2 객체
				sendMessage(receiver_ws, chatMessage);
 			} 
			
		} else if(chatMessage.getType().equals(ChatMessage2.TYPE_LEAVE)) {
			// ChatService - quitChatRoom() 메서드 호출하여 채팅방 종료 정보 설정
			// => 파라미터 : 룸아이디, 송신자 아이디 또는 ChatMessage2 객체
			chatService.quitChatRoom(chatMessage.getRoom_id(), chatMessage.getSender_id());
			
			// getDateTimeForNow() 메서드 호출하여 현재 시스템 날짜 및 시각 정보 저장하기
			chatMessage.setSend_time(getDateTimeForNow());
			
			// ChatMessage2 객체의 메세지에 "xxx 님이 나갔습니다." 메세지 저장
			chatMessage.setMessage(chatMessage.getSender_id() + " 님이 나갔습니다.");
			
			// ChatService - addChatMessage() 메서드 호출하여 채팅 메세지 DB 저장 요청
			// => 파라미터 : ChatMessage2 객체
			chatService.addChatMessage(chatMessage);
			
			// 채팅 종료 신호를 상대방(수신자)에게도 전달
			// 채팅 메세지 전송할 사용자 확인(user 객체에 receiver_id를 통해 판별)
			if(users.get(receiver_id) != null) { // 현재 수신자가 접속해 있을 경우
				// 탐색된 receiver_id에 해당하는 웹소켓 세션 객체의 세션 아이디를 활용하여
				// userSessions 객체의 웹소켓 세션 객체를 가져와서 메세지 전송 요청
				WebSocketSession receiver_ws = userSessions.get(users.get(receiver_id));
				// sendMessage() 메서드 호출하여 메세지 전송 요청
				// => 파라미터 : 수신자 WebSocketSession 객체, ChatMessage2 객체
				sendMessage(receiver_ws, chatMessage);
			} 
		}
		
	}
	
	// 각 웹소켓 세션(채팅방 사용자)들에게 메세지를 전송하는 sendMessage() 메서드
	public void sendMessage(WebSocketSession session, ChatMessage2 chatMessage) throws Exception {
		// ChatMessage 객체를 JSON 문자열로 변환하여 클라이언트측으로 전송
		// => 자바스크립트 웹소켓 이벤트 중 onmessage 이벤트에 의한 onMessage() 함수 호출됨
		session.sendMessage(new TextMessage(gson.toJson(chatMessage)));
	}

	// =================================================================================
	// WebSocketSession 객체에서 HttpSession 객체의 세션 아이디 꺼내서 리턴하는 메서드
	private String getHttpSessionId(WebSocketSession session) {
		return session.getAttributes().get("sId").toString();
	}
	
	// WebSocketSession 객체에서 WebSocketSession 객체의 아이디 꺼내서 리턴하는 메서드
	private String getWebSocketSessionId(WebSocketSession session) {
		return session.getId();
	}
	
	// 현재 시스템의 날짜 및 시각 정보를 yyyy-MM-dd HH:mm:ss 형태로 변환하여 리턴하는 메서드
	private String getDateTimeForNow() {
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"); // 형식 지정
		// 현재 시스템의 날짜 및 시각을 형식에 맞게 변환하여 리턴
		return LocalDateTime.now().format(dtf); 
	}
	// =================================================================================
	// 웹소켓 연결 해제 시 자동으로 호출되는 메서드
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		System.out.println("웹소켓 연결 해제됨(afterConnectionClosed)");
		
		// 클라이언트 정보가 저장된 Map 객체(userSessions) 내에서
		// 종료 요청이 발생한 웹소켓 세션 객체 제거
		// => Map 객체의 remove() 메서드 호출하여 전달받은 WebSocketSession 객체의 아이디를 키로 지정
		userSessions.remove(getWebSocketSessionId(session));
		
		// 사용자 정보가 저장된 Map 객체(users) 내에서
		// 종료 요청이 발생한 웹소켓의 세션 아이디 제거(널스트링으로 변경)
		// => Map 객체의 remove() 메서드 호출하여 HttpSession 객체의 세션 아이디를 키로 지정
		// => 단, HttpSession 객체의 세션 아이디(users 의 키)는 유지
		users.put(getHttpSessionId(session), "");
		// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		// => 임시 작업이며 차후 users 내의 키, 값 도 삭제
		// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		
		System.out.println("클라이언트 목록(" + userSessions.keySet().size() + "명) : " + userSessions);
		System.out.println("사용자 목록(" + users.keySet().size() + "명) : " + users);
		
	}
	
	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		System.out.println("웹소켓 오류 발생(handleTransportError)");
	}
	
	// ============================================================
	// 룸 아이디 생성을 위한 getRoomId() 메서드 정의
	private String getRoomId() {
		return UUID.randomUUID().toString();
	}

	
}














