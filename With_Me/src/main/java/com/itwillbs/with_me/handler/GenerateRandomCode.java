package com.itwillbs.with_me.handler;

import java.util.Random;

import org.apache.commons.lang3.RandomStringUtils;

// 특정 길이의 난수 생성에 사용할 GenerateRandomCode 클래스 정의
public class GenerateRandomCode {
	// 난수 생성하여 문자열로 리턴할 getRandomCode() 메서드 정의
	// => 파라미터 : 난수의 길이(정수)   리턴타입 : String
	// => 인스턴스 생성 없이 즉시 호출 가능하도록 static 메서드 정의
	public static String getRandomCode(int length) {
		// [ 난수 생성 방법 ]
		// 1. java.util.Random 클래스 활용
		// 5자리 정수(0 ~ 99999)로 된 난수 생성
//		Random r = new Random();
//		int rNum = r.nextInt(100000); // 0 ~ 99999 까지의 난수 생성
//		int rNum = r.nextInt((int)Math.pow(10, length)); // 10 ^ length 까지의 난수 생성(ex. length = 5 일 때 10^5 = 100000)
		// => 주의! 10 ^ length 자체를 수식으로 지정 시 비트단위 논리연산자 XOR 로 취급되어
		//    2진수 10 과 2진수 length 의 XOR 연산 결과값이 적용되므로 다른 값이 된다!
		//    따라서, double Math.pow(double, double) 메서드 활용하는 것이 정확하다!
//		System.out.println("rNum : " + rNum);
		
		// 생성된 정수형 난수의 경우 x자리에 해당하는 숫자가 있을 경우 앞자리가 0이면 표시 생략함
		// 그러나, 정확히 5자리의 난수를 만들어내려면 문자열 변환 과정에서 앞자리에 0 표시해야한다!
//		String strNum = String.format("%05d", rNum);
//		System.out.println("strNum : " + strNum);
		// ======================================================================================
		// 2. 난수 생성에 관한 다양한 기능을 제공하는 클래스 활용
		// RandomStringUtils 클래스 활용(commons-lang3 라이브러리 추가 필요)
		// => randomXXX() 메서드 활용하여 원하는 형태의 난수 생성
//		return RandomStringUtils.randomNumeric(length); // 원하는 자릿수의 정수를 문자열로 생성(앞자리 0 포함)
		return RandomStringUtils.randomAlphanumeric(length); // 원하는 자릿수의 알파벳&정수 조합을 문자열로 생성
	}
}









