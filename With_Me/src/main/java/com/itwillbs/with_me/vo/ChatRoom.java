package com.itwillbs.with_me.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/*
[ 채팅방 1개 정보를 관리할 chat_room 테이블 정의 ]
----------------------------------------------------
채팅방ID(room_id) - 문자 36자, NN
채팅방 제목(title) - 문자 50wk, NN
채팅방 사용자 아이디(user_id) - 문자 16자(송수신자 구분 없음), NN
채팅방 상태(status) - 정수, NN

ex) room_id                                title      user_id      status
    -----------------------------------------------------------------------
    ec3157ea-31b1-4291-ad5b-2c65d9c4dcef   채팅방1    asdf123        1
    ec3157ea-31b1-4291-ad5b-2c65d9c4dcef   채팅방1    admin          1
    => 두 개의 행(레코드)가 하나의 채팅방 정보를 가리킴(2명 이상일 수도 있음)
-------------------------------------------------
CREATE TABLE chat_room (
	room_id VARCHAR(36) NOT NULL,
	title VARCHAR(50) NOT NULL,
	user_id VARCHAR(16) NOT NULL,
	status INT NOT NULL
);
----------------------------------------------------------
단, VO 클래스 정의 시에는 송신자 아이디와 수신자 아이디 구별 필요
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChatRoom {
	private String room_id;
	private String title;
	private String sender_id;
	private String receiver_id;
	private int status;
	private int unread_count;       // 안 읽은 메세지 개수
}
