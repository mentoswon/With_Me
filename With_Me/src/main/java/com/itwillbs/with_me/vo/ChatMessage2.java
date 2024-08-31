package com.itwillbs.with_me.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
 [ 채팅 메세지를 저장할 chat_message 테이블 정의 ] 
 room_id - 50글자 NN
 sender_id - 16글자 NN
 receiver_id - 16글자 NN
 message - 2000글자 NN
 type - 20글자 NN
 send_time - 날짜 및 시각(DATETIME)
 ---------------------------------------
 CREATE TABLE chat_message (
 	room_id VARCHAR(50) NOT NULL,
 	sender_id VARCHAR(16) NOT NULL,
 	receiver_id VARCHAR(16) NOT NULL,
 	message VARCHAR(2000) NOT NULL,
 	type VARCHAR(20) NOT NULL,
 	send_time DATETIME NOT NULL
 );
 */

// ---------------------------------------------------
// 웹소켓 채팅 메세지를 자동으로 파싱하기 위한 클래스
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessage2 {
	private String type;            // 메세지 타입
	private String sender_id;       // 송신자 아이디
	private String receiver_id;     // 수신자 아이디
	private String room_id;         // 채팅방 아이디
	private String message;         // 채팅 메세지
	private String send_time;       // 메세지 전송 시각
	
	// type 변수값으로 활용될 값을 상수로 생성
	public static final String TYPE_ENTER = "ENTER";
	public static final String TYPE_LEAVE = "LEAVE";
	public static final String TYPE_TALK = "TALK";
	public static final String TYPE_ERROR = "ERROR";
	public static final String TYPE_INIT = "INIT";
	public static final String TYPE_INIT_COMPLETE = "INIT_COMPLETE";
	public static final String TYPE_ADD_LIST = "ADD_LIST";
	public static final String TYPE_START = "START";
	public static final String TYPE_REQUEST_CHAT_LIST = "REQUEST_CHAT_LIST";
}
