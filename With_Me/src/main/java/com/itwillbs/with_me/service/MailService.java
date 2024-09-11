package com.itwillbs.with_me.service;

import org.springframework.stereotype.Service;

import com.itwillbs.with_me.handler.GenerateRandomCode;
import com.itwillbs.with_me.handler.SendMailClient;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;

@Service
public class MailService {

	// 인증 메일 발송 요청
	public MailAuthInfo sendAuthMail(MemberVO member) {
		// 인증 메일에 포함시킬 난수 생성
		// GenerateRandomCode 클래스의 static getRandomCode() 메서드 호출하여 난수 리턴
		// => 파라미터 : 생성할 난수 길이(정수)
		String auth_code = GenerateRandomCode.getRandomCode(50);
		System.out.println("생성된 인증코드 : " + auth_code);
		// --------------------------------------------------------
		// 인증 메일에 포함할 제목과 본문 생성
		String subject = "[위드미] 가입 인증 메일입니다.";
		// 인증 코드만 메일로 발송할 경우
//		String content = "인증코드 : " + auth_code;
		// 인증 링크를 메일로 발송할 경우
//		String content = "<a href=\"http://localhost:8081/mvc_board/MemberEmailAuth?email=" + member.getEmail() + "&auth_code=" + auth_code + "\">이메일 인증을 수행하려면 이 링크를 클릭하세요!</a>";
		String content = "<a href=\"http://c5d2403t2.itwillbs.com/with_me/MemberEmailAuth?email=" + member.getMem_email() + "&auth_code=" + auth_code + "\">이메일 인증을 수행하려면 이 링크를 클릭하세요!</a>";
		// ----------------------------------------------------------
		// SendMailClient - sendMail() 메서드 호출하여 메일 발송 요청
		// => 파라미터 : 이메일주소, 제목, 본문
//		SendMailClient.sendMail(member.getEmail(), subject, content);
		// 단, 메일 발송 과정에서 메일 전송 상황에 따라 시간 지연이 발생할 수 있는데
		// 이 과정에서 다음 작업을 실행하지 못하고 발송 완료까지 대기하게 된다.
		// (ex. 다음 화면을 표시하지 못하거나, 데이터베이스 작업을 수행하지 못함)
		// 따라서, 메일 발송 작업과 나머지 작업을 별도로 동작시키기 위해
		// 메일 발송 메서드 호출 작업을 하나의 쓰레드(Thread)로 동작시키면 별도로 처리 가능하다!
		// 즉, 메일 발송이 완료되지 않았더라도 다음 작업 진행이 가능해진다!
		new Thread(new Runnable() {
			@Override
			public void run() {
				// 쓰레드로 수행할 작업
				SendMailClient.sendMail(member.getMem_email(), subject, content);
//				System.out.println("쓰레드 작업 완료");
			}
		}).start();
		
		// ========================================================================
		// MailAuthInfo 객체 생성 후 이메일 주소와 인증 코드 저장 후 리턴
		MailAuthInfo mailAuthInfo = new MailAuthInfo(member.getMem_email(), auth_code);
		
		
		return mailAuthInfo;
	}

}















