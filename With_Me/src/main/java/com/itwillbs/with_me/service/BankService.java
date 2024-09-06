package com.itwillbs.with_me.service;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.BankApiClient;
import com.itwillbs.with_me.mapper.BankMapper;
import com.itwillbs.with_me.vo.BankToken;

@Service
public class BankService {
	@Autowired
	private BankApiClient bankApiClient;
	
	@Autowired
	private BankMapper mapper;
	
	// 엑세스토큰 발급 요청
	public BankToken getAccessToken(Map<String, String> authResponse) {
		// BankApiClient - requestAccessToken() 메서드 호출하여 엑세스토큰 발급 요청 수행
		
		return bankApiClient.requestAccessToken(authResponse);
	}

	// 엑세스토큰 정보 저장 요청
	public void registAccessToken(Map<String, Object> map) {
		// BankMapper - selectTokenInfo() 메서드 호출하여 아이디에 해당하는 토큰 정보 조회
		// 파라미터: Map 객체     리턴 : String(id)
		String id = mapper.selectId(map);
		
		System.out.println("토큰 아이디 정보 : " + id);
		
		// 조회된 아이디가 없을 경우 (= 엑세스토큰 정보 없음) 토큰 정보 추가 (INSERT)
		// 조회된 아이디가 있을 경우 (= 엑세스토큰 정보 있음) 토큰 정보 갱신 (UPDATE)
		if(id == null) {
			mapper.insertAccessToken(map);
		} else {
			mapper.updateAccessToken(map);
		}
	}

	// 로그인 시 엑세스 정보 조회하여 저장하도록 처리해야하니까 일단 조회부터 (DB)
	public BankToken getBankUserInfo(String id) {
		return mapper.selectBankUserInfo(id);
	}

	// 핀테크 계좌 목록 조회
	public Map<String, Object> getBankAccountList(BankToken token) {
		return bankApiClient.requestBankAccountList(token);
	}

}
