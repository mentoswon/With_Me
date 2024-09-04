package com.itwillbs.with_me.handler;

import java.io.UnsupportedEncodingException;
import java.security.InvalidKeyException;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.RSAPublicKeySpec;
import java.util.HashMap;
import java.util.Map;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

// RSA 알고리즘을 사용하여 암호화 키(공개키/개인키)를 관리하는 클래스 정의
// => java.security 패키지 활용(기본으로 포함된 패키지)
public class RsaKeyGenerator {
	private static final String CIPHER_INSTANCE = "RSA"; // 암호화 알고리즘
	
	// 공개키/개인키 생성하는 메서드
	public static Map<String, Object> generateKey() {
		// 공개키/개인키 한 쌍을 저장할 Map 객체 생성
		Map<String, Object> rsaKey = new HashMap<String, Object>();
		
		try {
			// 공개키/개인키 한 쌍을 생성하는 객체 생성
			// => KeyPairGenerator 클래스의 static 메서드 getInstance() 메서드 호출
			//    파라미터로 암호화 알고리즘명 전달(NoSuchAlgorithmException 처리 필요)
			KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(CIPHER_INSTANCE);
			keyPairGenerator.initialize(1024); // 암호화 알고리즘에서 사용할 키의 길이 설정
			
			// 공개키와 개인키를 각각 생성하기
			// 1) KeyPairGenerator 객체의 genKeyPair() 메서드 호출하여 KeyPair 객체 리턴
			KeyPair keyPair = keyPairGenerator.genKeyPair();
			// 2) KeyPair 객체의 getPublic() 메서드 호출하여 공개키(PublicKey 타입) 리턴받기
			PublicKey publicKey = keyPair.getPublic();
			// 3) KeyPair 객체의 getPrivate() 메서드 호출하여 개인키(Privatekey 타입) 리턴받기
			PrivateKey privateKey = keyPair.getPrivate();
			
//			System.out.println("개인키 : " + privateKey);
//			System.out.println("공개키 : " + publicKey);
			
			// 개인키는 Map 객체에 PrivateKey 객체 형태로 그대로 저장
			rsaKey.put("RSAPrivateKey", privateKey);
			
			// 공개키는 자바스크립트에서 암호화를 수행하기 위해서는 객체 그대로 사용할 수 없으므로
			// 암호화에 사용되는 두 개의 값(Modulus, Exponent)을 추출하여 Map 객체에 저장
			// => 이 때, 16진수 문자열 형태로 변환 후 저장
			// 1) KeyFactory 클래스의 static 메서드 getInstance() 호출하여 KeyFactory 객체 리턴받기
			//    => 파라미터 : 암호화 알고리즘명(NoSuchAlgorithmException 처리 필요)
			KeyFactory keyFactory = KeyFactory.getInstance(CIPHER_INSTANCE);
			// 2) KeyFactory 객체의 getKeySpec() 메서드 호출하여 공개키 리턴받기
			//    => 파라미터 : 공개키, 공개키를 관리할 클래스 지정
			//    => 리턴타입 : 공개키를 관리할 클래스 타입(형변환 필요)
			//    => InvalidKeySpecException 예외 처리 필요
			RSAPublicKeySpec publicKeySpec = 
					(RSAPublicKeySpec)keyFactory.getKeySpec(publicKey, RSAPublicKeySpec.class);
			// 3) RSAPublicKeySpec 객체의 getXXX() 메서드를 호출하여 Modulus, Exponent 값 추출
			//    => 추출된 결과값을 다시 16진수 문자열로 변환하기 위해 toString() 메서드 활용
			//    => getXXX() 메서드 리턴타입이 BigInteger 타입이며
			//       BigInteger 객체의 toString() 메서드에 원하는 진법을 정수로 전달 시
			//       해당 진법 문자열로 변환해줌
			String publicKeyModulus = publicKeySpec.getModulus().toString(16);
			String publicKeyExponent = publicKeySpec.getPublicExponent().toString(16);
			
			// 공개키에 사용될 2개의 값을 Map 객체에 각각 저장
			rsaKey.put("RSAModulus", publicKeyModulus);
			rsaKey.put("RSAExponent", publicKeyExponent);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (InvalidKeySpecException e) {
			e.printStackTrace();
		}
		
		return rsaKey;
	}
	
	// 암호문을 복호화하는 메서드
	public static String decrypt(PrivateKey privateKey, String encryptedValue) {
		String decryptedValue = "";
		
		try {
			// Cipher 클래스의 getInstance() 메서드 호출하여 복호화를 수행할 Cipher 객체 리턴받기
			// => 파라미터 : 복호화 알고리즘 지정
			Cipher cipher = Cipher.getInstance(CIPHER_INSTANCE); // NoSuchPaddingException 예외 처리 필요
			// Cipher 객체의 init() 메서드 호출하여 모드를 복호화 모드로 지정, 개인키도 전달
			cipher.init(Cipher.DECRYPT_MODE, privateKey); // InvalidKeyException 예외 처리 필요
			
			// 암호문 -> 평문 복호화
			// 1) 16진수 암호문 -> byte 배열로 변환 => 사용자 정의 메서드 hexToByteArray() 활용
			byte[] encryptedBytes = hexToByteArray(encryptedValue);
			// 2) Cipher 객체의 doFinal() 메서드 호출하여 
			//    byte 배열로 저장된 암호문을 복호화하여 다시 byte 배열로 리턴
			byte[] decryptedBytes = cipher.doFinal(encryptedBytes); // BadPaddingException 예외 처리 필요
			// 3) 복호화 된 평문을 UTF-8 방식 문자열로 변환하여 리턴
			//    => 문자 인코딩 방식 UTF-8 지정(UnsupportedEncodingException 예외 처리 필요)
//			return new String(decryptedBytes, "UTF-8");
			decryptedValue = new String(decryptedBytes, "UTF-8");
		} catch (Exception e) {
			e.printStackTrace();
		} 
	
		return decryptedValue;
	}
	
	// 16진수 문자열을 byte 배열로 변환하여 리턴하는 메서드
	public static byte[] hexToByteArray(String hexString) {
		// 암호문은 2의 승수만큼의 크기로만 생성되므로 무조건 짝수 크기이다.
		// 따라서, 전달받은 암호문의 길이가 짝수가 아닐 경우 올바르지 못한 암호문이다.
		if(hexString == null || hexString.length() % 2 != 0) {
			return new byte[] {}; // 빈 배열(또는 null) 리턴
		}
		// --------------------------------------------------------
		// byte 타입 1byte(= 8bit)이며, 0 ~ 255 사이의 범위 값을 표현할 수 있는데
		// 이는 16진수 2자리 00 ~ FF 사이의 값으로 표현 가능한 범위와 같다.
		// 따라서, 16진수 문자열을 byte 배열로 변환할 경우
		// 배열의 크기를 문자열 길이 / 2 만큼의 사이즈로 지정하면 된다.
		byte[] bytes = new byte[hexString.length() / 2];
		
		// 16진수 문자를 각각 2개씩 묶어 정수로 변환한 값을 배열에 저장 
		// => 반복문 활용(16진수 문자열 길이만큼 반복하되 i값 2씩 증가)
		for(int i = 0; i < hexString.length(); i += 2) {
			// 16진수 문자열을 2자리 추출하기 위해 substring() 메서드 활용
			// => 추출된 문자열을 정수로 변환 후 다시 byte 타입으로 변환
			// => 이 때, 파라미터로 변환할 문자열과 해당 문자열의 원래 진법(16)을 지정
			byte value = (byte)Integer.parseInt(hexString.substring(i, i + 2), 16); // i ~ i+1 까지 추출됨
			// 변환된 값을 배열에 저장
			// => 이 때, i값은 2의 배수이므로 i값을 2로 나누면 인덱스로 활용 가능
			//    ex) 2일 때 1번, 4일 때 2번, 6일 때 3번 인덱스에 저장
			bytes[i / 2] = value;
			// => 만약, i값이 짝수가 아닌 수도 포함되어 있을 경우 소수점 부분을 버려야 인덱스로 활용 가능
			//    ex) bytes[(int)(Math.floor(i / 2))] = value;
		}
		
		return bytes;
	}
	
}














