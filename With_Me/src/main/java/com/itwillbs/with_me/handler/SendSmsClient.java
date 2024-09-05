package com.itwillbs.with_me.handler;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

public class SendSmsClient {
    private static final String SMS_API_URL = "https://api.coolsms.co.kr/sms/send";
    private static final String API_KEY = "NCSQMHZF0P97BK4W";
    private static final String API_SECRET = "L5IOFHZAB61DFSN9LOSZ0F2GU3KAMQDH";
    private static final String PHONE_NUM = "01047801548";

    public static boolean sendSms(String phoneNumber, String content) {
//    	HttpURLConnection connection = null;
//        try {
//        	// 1. URL 객체 생성
//        	System.out.println("1. URL 객체 생성 시도");
//            URL url = new URL(SMS_API_URL);
//            connection = (HttpURLConnection) url.openConnection();
//            
//            // 2. HTTP 요청 설정
//            System.out.println("2. HTTP 연결 설정 중");
//            connection.setRequestMethod("POST");
////            connection.setRequestProperty("Content-Type", "application/json");
//            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
////            connection.setRequestProperty("Authorization", API_KEY + ":" + API_SECRET);
//            connection.setDoOutput(true);
//
//            // 3. 요청 파라미터 설정
//            System.out.println("3. 요청 파라미터 설정 중");
////            Map<String, String> params = new HashMap<>();
////            params.put("to", phoneNumber); // 수신자 전화번호
////            params.put("from", PHONE_NUM); // 발신자 전화번호 (CoolSMS 서비스에 등록된 번호여야 함)
////            params.put("type", "SMS");
////            params.put("text", content); // 메시지 내용
////            params.put("app_version", "WithMe v1.0"); // 앱 버전
//            String postData = String.format("api_key=%s&api_secret=%s&to=%s&from=%s&type=%s&text=%s",
//                    API_KEY, API_SECRET, phoneNumber, PHONE_NUM, "SMS", content);
//
//            // 4. 요청 본문 생성
//            System.out.println("4. 요청 본문 전송 중");
////            JSONObject jsonParams = new JSONObject(params);
//            OutputStream os = connection.getOutputStream();
////            os.write(jsonParams.toString().getBytes(StandardCharsets.UTF_8));
//            os.write(postData.getBytes(StandardCharsets.UTF_8));
//            os.flush();
//            os.close();
//
//            // 5. 응답 확인
//            System.out.println("5. 응답 대기 중");
//            int responseCode = connection.getResponseCode();
//            if (responseCode == HttpURLConnection.HTTP_OK) {	// 200
//                String responseMessage = new String(connection.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
//                JSONObject jsonResponse = new JSONObject(responseMessage);
//                System.out.println("문자 발송 성공: " + jsonResponse.toString());
//                return true;
//            } else {
//                System.out.println("문자 발송 실패: HTTP 오류 코드 " + responseCode);
//                return false;
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//            System.out.println("문자 발송 실패: " + e.getMessage());
//            return false;
//        } finally {
//            if (connection != null) {
//                connection.disconnect();
//            }
//        }
    	DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize(API_KEY, API_SECRET, "https://api.coolsms.co.kr");
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