package com.itwillbs.with_me.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.ChatMessage2;
import com.itwillbs.with_me.vo.ChatRoom;

@Mapper
public interface ChatMapper {

	// 기존 자신의 채팅방 목록 조회
	List<ChatRoom> selectChatRoomList(String sender_id);
	
	// 해당 사용자와의 기존 채팅방 조회(파라미터 2개 주의!)
	ChatRoom selectChatRoom(@Param("sender_id") String sender_id, @Param("receiver_id") String receiver_id);
	
	// 새 채팅방 생성(추가)
	void insertChatRoom(List<ChatRoom> chatRoomList);

	// 채팅 메세지 저장
	void insertChatMessage(ChatMessage2 chatMessage);

	// 기존 채팅 내역 조회
	List<ChatMessage2> selectChatMessageList(String room_id);

	// 채팅방 종료
	void updateChatRoomStatusForQuitRoom(@Param("room_id") String room_id, @Param("sender_id") String sender_id);



}
