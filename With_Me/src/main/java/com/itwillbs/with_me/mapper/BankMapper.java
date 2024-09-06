package com.itwillbs.with_me.mapper;

import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.BankToken;

@Mapper
public interface BankMapper {

	// 토큰 정보 조회 -> 아이디 리턴
	String selectId(Map<String, Object> map);

	// 엑세스토큰 정보 추가 
	void insertAccessToken(Map<String, Object> map);

	// 엑세스토큰 정보 갱신 
	void updateAccessToken(Map<String, Object> map);

	// 로그인 시 엑세스 정보 조회하여 저장하도록 처리해야하니까 일단 조회부터
	BankToken selectBankUserInfo(String id);

}
