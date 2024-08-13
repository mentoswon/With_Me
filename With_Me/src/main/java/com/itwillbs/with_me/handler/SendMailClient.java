package com.itwillbs.with_me.handler;

import java.util.Date;
import java.util.Properties;

import jakarta.mail.Address;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.Message.RecipientType;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class SendMailClient {
	private static final String HOST = "smtp.naver.com"; // 네이버 메일 사용 시
	private static final String PORT = "587"; // 네이버 메일 사용 시
	private static final String SENDER_ADDRESS = "dviasd67532@naver.com";
	
	public static void sendMail(String receiver, String title, String content) {
		try {
			// ================== 메일 전송에 필요한 정보 설정 =======================
			// 메일 송신 프로토콜 : SMTP(Simple Mail Transfer Protocol) <-> 수신 프로토콜 : POP3, IMAP
			// => 기본 포트(Well-known Port) : 25번(그러나, 각 상용 메일 서비스마다 달라짐)
			//    ex) Gmail 은 587번 포트 사용
			// 1. 시스템(= 톰캣 서버)의 속성 정보(= 서버 정보)를 java.util.Properties 객체로 리턴받기
			Properties props = System.getProperties();
			
			// 2. Properties 객체를 활용하여 메일 전송에 필요한 기본 설정 정보를 서버 정보에 추가
			// => Properties 객체의 put() 메서드 사용
			// 메일 전송에 사용할 메일 서버에 대한 정보 설정(구글, 네이버, 아웃룩 등)
			props.put("mail.smtp.host", HOST); // 구글(Gmail)의 SMTP 서버 주소
			props.put("mail.smtp.auth", "true"); // SMTP 서비스 이용 시 접근 과정에서 인증(로그인) 여부 설정
			props.put("mail.smtp.port", PORT); // Gmail 의 SMTP 서비스 포트번호 설정
			// 메일 서버 인증 관련 추가 정보 설정(설정 내용에 따라 위의 정보 중 포트번호 바뀔 수 있음)
			props.put("mail.smtp.starttls.enable", "true"); // TLS 라는 인증 프로토콜 사용 여부 설정
			props.put("mail.smtp.ssl.trust", HOST); // SSL 인증에 사용할 신뢰 가능한 서버 주소 지정
			
			// 3. 메일 서버 인증 정보 관리하는 사용자 정의 클래스의 인스턴스 생성
			// => MailAuthenticator -> Authenticator 타입으로 업캐스팅
			Authenticator authenticator = new MailAuthenticator();
			
			// 4. 자바 메일 전송 작업을 jakarta.mail.Session 객체 단위로 관리하므로
			//    Session 클래스의 getDefaultInstance() 메서드 호출하여 Session 타입 객체 리턴받기
			// => 주의! 웹에서 사용하는 기본 세션 객체(HttpSession) 와 다름
			// => 파라미터 : Properties 객체(SMTP 서버 정보), Authenticator 객체(인증 정보)
			Session mailSession = Session.getDefaultInstance(props, authenticator);
			
			// 5. 서버 정보와 인증 정보를 포함하여 전송할 메일 정보를 하나의 묶음으로 관리할
			//    jakarta.mail.internet.MimeMessage 객체 생성(파라미터 : Session 객체)
			// => MimeMessage -> Message 타입으로 업캐스팅
			Message message = new MimeMessage(mailSession);
			// ------------------------------------------------------------------------------------
			// 6. 전송할 메일에 대한 상세 정보 설정
			// 1) 발신자 정보 설정
			//    => InternetAddress 객체 활용(Address 타입으로 업캐스팅)
			//    => 생성자 파라미터 : 발신자 메일주소, 발신자 이름
			Address senderAddress = new InternetAddress(SENDER_ADDRESS, "아이티윌");
			// => 주의! 네이버는 발신자 메일주소 수정 자체가 차단되어있으므로
			//    실제 네이버 메일 주소를 정확하게 지정해야한다!
			// => 메일 주소 강제 변경 시 예외 발생(인가되지 않은 발신자 주소)
			//    com.sun.mail.smtp.SMTPSendFailedException: 554 5.7.1 The sender address is unauthorized e8elkxYhRzaLlkY-Ah049w - nsmtp
			
			// 2) 수신자 정보 설정
			//    => 파라미터 : 수신자 메일주소
			//    => AddressException 예외 발생(수신자 주소 불일치 등)
			Address receiverAddress = new InternetAddress(receiver);
			
			// 3) 5번 과정에서 생성한 Message 객체를 활용하여 전송할 메일의 내용 설정
			// => MessagingException 예외 처리 필요
			// 3-1) 메일 헤더 정보 설정(생략 가능)
//			message.setHeader("content-type", "text/html; charset=UTF-8");
			
			// 3-2) 발신자 정보 설정
			message.setFrom(senderAddress);
			
			// 3-3) 수신자 정보 설정
			// => Message 객체의 setRecipient() 메서드는 단일 수신자에게 발송할 때 사용하고
			//    setRecipients() 메서드는 다중 수신자에게 발송할 때 사용(파라미터가 다름)
			// => 첫번째 파라미터로 전달할 수신 타입(RecipientType 객체)은 상수 활용
			//    RecipientType.TO : 수신자에게 직접 전송(메일을 직접 수신할 수신자 = 업무 담당자)
			//    RecipientType.CC : 참조(Carbon Copy 약자). 직접 수신자는 아니나 업무 참조용으로 수신(= 업무 관계자)
			//    RecipientType.BCC : 숨은 참조(Blind CC 약자). 메일 수신자가 CC 여부를 알 수 없게 참조 수신자를 숨김
			message.setRecipient(RecipientType.TO, receiverAddress);
			
			// 3-4) 메일 제목 설정
			message.setSubject(title);
			
			// 3-5) 메일 본문 설정
			// => 파라미터 : 메일 본문, 본문의 컨텐츠 타입
			// => 또는 파라미터 타입을 Multipart 타입으로 전달 시 첨부 파일 기능도 활용 가능
			message.setContent("<h3>" + content + "</h3>", "text/html; charset=UTF-8");
			
			// 3-6) 메일 발송 날짜 및 시각 설정
			message.setSentDate(new Date());// 현재 날짜 및 시각 정보 설정
			// ------------------------------------------------------------------------------
			// 7. 메일 전송
			// => jakarta.mail.Transport 클래스의 static 메서드 send() 호출
			Transport.send(message);
			System.out.println("메일 발송 성공!");
		} catch (Exception e) {
			System.out.println("메일 발송 실패!");
			e.printStackTrace();
		}
	}
}
