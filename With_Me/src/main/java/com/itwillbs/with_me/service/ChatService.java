package com.itwillbs.with_me.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.ChatMapper;
import com.itwillbs.with_me.vo.ChatMessage2;
import com.itwillbs.with_me.vo.ChatRoom;

@Service
public class ChatService {
	@Autowired
	private ChatMapper mapper;
	
	// 기존 자신의 채팅방 목록 조회
	public List<ChatRoom> getChatRoomList(String sender_id) {
		return mapper.selectChatRoomList(sender_id);
	}
	
	// 기존 채팅방 여부 확인을 위한 1개 채팅방 정보 조회
	public ChatRoom getChatRoom(String sender_id, String receiver_id) {
		return mapper.selectChatRoom(sender_id, receiver_id);
	}
	
	// 새 채팅방 생성(추가)
	public void addChatRoom(List<ChatRoom> chatRoomList) {
		mapper.insertChatRoom(chatRoomList);
	}

	// 채팅 메세지 저장
	public void addChatMessage(ChatMessage2 chatMessage) {
		mapper.insertChatMessage(chatMessage);
	}

	// 기존 채팅 내역 조회
	public List<ChatMessage2> getChatMessageList(String room_id) {
		return mapper.selectChatMessageList(room_id);
	}

	// 채팅방 종료
	public void quitChatRoom(String room_id, String sender_id) {
		mapper.updateChatRoomStatusForQuitRoom(room_id, sender_id);
	}

	// 채팅 읽음 설정
	public int updateReadState(ChatMessage2 chatMessage2) {
		return mapper.updateReadState(chatMessage2);
	}



}
