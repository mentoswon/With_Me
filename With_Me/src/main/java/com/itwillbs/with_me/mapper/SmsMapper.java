package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.SmsAuthInfo;

@Mapper
public interface SmsMapper {

	// 기존 인증정보 존재 여부 확인
	SmsAuthInfo selectSmsAuthInfo(SmsAuthInfo smsAuthInfo);

	// 새 인증정보 등록(INSERT)
	void insertSmsAuthInfo(SmsAuthInfo smsAuthInfo);

	// 기존 인증정보 갱신(UPDATE)
	void updateSmsAuthInfo(SmsAuthInfo smsAuthInfo);
	
	
	
	
}