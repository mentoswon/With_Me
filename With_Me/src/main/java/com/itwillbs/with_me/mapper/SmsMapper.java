package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.SmsAuthInfo;

@Mapper
public interface SmsMapper {

	// 인증 정보를 DB에 저장
    boolean saveSmsAuthInfo(SmsAuthInfo smsAuthInfo);

    // 인증번호 확인
    SmsAuthInfo getSmsAuthInfoByPhoneNumber(String phone_number);

    // 인증번호 삭제 (선택적)
    void deleteSmsAuthInfo(String phone_number);
	
}