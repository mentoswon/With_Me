package com.itwillbs.with_me.handler;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

public class SendSmsClient {
    private static final String SMS_API_URL = "https://api.coolsms.co.kr";
    private static final String API_KEY = "NCSQMHZF0P97BK4W";
    private static final String API_SECRET = "L5IOFHZAB61DFSN9LOSZ0F2GU3KAMQDH";
    private static final String PHONE_NUM = "01047801548";

    public static boolean sendSms(String phoneNumber, String content) {
    	DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize(API_KEY, API_SECRET, SMS_API_URL);
    	// Message 패키지가 중복될 경우 net.nurigo.sdk.message.model.Message로 치환하여 주세요
    	Message message = new Message();
    	message.setFrom(PHONE_NUM);
    	message.setTo(phoneNumber);
    	message.setText(content);

    	try {
    	  // send 메소드로 ArrayList<Message> 객체를 넣어도 동작합니다!
    	  messageService.send(message);
    	  return true; 
    	} catch (NurigoMessageNotReceivedException exception) {
    	  // 발송에 실패한 메시지 목록을 확인할 수 있습니다!
    	  System.out.println(exception.getFailedMessageList());
    	  System.out.println(exception.getMessage());
    	  return false; 
    	} catch (Exception exception) {
    	  System.out.println(exception.getMessage());
    	  return false; 
        }
    }
}