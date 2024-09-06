package com.itwillbs.with_me.handler;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;

@Component
public class BankValueGenerator {

	// 거래고유번호(참가기관) 자동생성을 위함
	public String getBankTranId(String client_use_code) {
		
		// 거래고유번호 : 이용기관코드 10자리 + 생성주체구분코드 ("U") + 난수 9자리
		String bank_tran_id = "";
		
		// 1) 만약, 정수형 난수로만 구성될 경우 SecureRandom 클래스 활용 가능
//		SecureRandom sr = new SecureRandom();
//		
//		int rNum = sr.nextInt(1000000000);
//		bank_tran_id = String.format("%09d", rNum); // => 0 채워넣기
		
		// 2) 미리 정의해둔 GenerateRandomCode - getRandomCode()
		// => 파라미터로 난수 길이 9 전달
		// => 주의! bank_tran_id 값의 타입이 AN(10) 으로 표기되어 있으며, 이 경우 알파벳은 반드시 대문자여야함 !!!
		// ==> 변환해줘야함
		
		bank_tran_id = client_use_code + "U" + GenerateRandomCode.getRandomCode(9).toUpperCase(); 
		// 스트링 클래스의 toUpperCase 사용하여 대문자로 변환 !
		
		return bank_tran_id;
	}

	
	// 거래 요청 일시 자동 생성을 위함 
	public String getTranDTime() {
		// => 현재 시스템 날짜 및 시각을 기준으로 14자리 숫자(문자열 타입) 생성(yyyyMMddHHmmss 형식)
		// => LocalDateTime 클래스 활용
		
		// 현재 시스템 날짜 및 시각 정보 가져오기
		LocalDateTime localDateTime = LocalDateTime.now();
		
		// LocalXXX 클래스에 대한 포맷팅
		DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyyMMddHHmmss");
		
		// localDateTime 객체의 format() 메서드를 호출하여 포맷 문자열 적용해서 그대로 리턴
		
		return localDateTime.format(dateTimeFormatter);
	}
	
}
