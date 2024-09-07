package com.itwillbs.with_me.handler;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Component // 이 어노테이션을 추가하여 Spring Bean으로 등록
public class SendSmsClient {
	@Value("${sms.api.url}")
    private String smsApiUrl;

    @Value("${sms.api.key}")
    private String apiKey;

    @Value("${sms.api.secret}")
    private String apiSecret;

    @Value("${sms.phone.num}")
    private String phoneNum;

    public boolean sendSms(String phoneNumber, String content) {
        DefaultMessageService messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecret, smsApiUrl);
        Message message = new Message();
        message.setFrom(phoneNum);
        message.setTo(phoneNumber);
        message.setText(content);

    	try {
    	  // send 메소드로 ArrayList<Message> 객체를 넣어도 동작함
    	  messageService.send(message);
    	  return true; 
    	} catch (NurigoMessageNotReceivedException exception) {
    	  // 발송에 실패한 메시지 목록 확인
    	  System.out.println(exception.getFailedMessageList());
    	  System.out.println(exception.getMessage());
    	  return false; 
    	} catch (Exception exception) {
    	  System.out.println(exception.getMessage());
    	  return false; 
        }
    }
}