package com.itwillbs.with_me.handler;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

public class SendSmsClient {
    private static final String SMS_API_URL = "https://api.coolsms.co.kr/sms/send";
    private static final String API_KEY = "NCSQMHZF0P97BK4W";
    private static final String API_SECRET = "L5IOFHZAB61DFSN9LOSZ0F2GU3KAMQDH";
    private static final String PHONE_NUM = "01047801548";

    public static boolean sendSms(String phoneNumber, String content) {
    	HttpURLConnection connection = null;
        try {
            // 1. URL 객체 생성
            URL url = new URL(SMS_API_URL);
            connection = (HttpURLConnection) url.openConnection();
            
            // 2. HTTP 요청 설정
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
//            connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); // JSON 대신 URL 인코딩된 형식 사용
            connection.setRequestProperty("Authorization", "Bearer " + API_KEY + ":" + API_SECRET);
            connection.setDoOutput(true);

            // 3. 요청 파라미터 설정
            Map<String, String> params = new HashMap<>();
            params.put("to", phoneNumber); // 수신자 전화번호
            params.put("from", PHONE_NUM); // 발신자 전화번호 (CoolSMS 서비스에 등록된 번호여야 함)
            params.put("type", "SMS");
            params.put("text", content); // 메시지 내용
            params.put("app_version", "WithMe v1.0"); // 앱 버전
            
//            String postData = String.format("api_key=%s&api_secret=%s&to=%s&from=%s&type=%s&text=%s",
//                    API_KEY, API_SECRET, phoneNumber, PHONE_NUM, "SMS", content);

            
            // 4. 요청 본문 생성
            JSONObject jsonParams = new JSONObject(params);
            OutputStream os = connection.getOutputStream();
            os.write(jsonParams.toString().getBytes(StandardCharsets.UTF_8));
//            os.write(postData.getBytes(StandardCharsets.UTF_8));
            os.flush();
            os.close();

            // 5. 응답 확인
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                String responseMessage = new String(connection.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
                JSONObject jsonResponse = new JSONObject(responseMessage);
                System.out.println("문자 발송 성공: " + jsonResponse.toString());
                return true;
            } else {
                System.out.println("문자 발송 실패: HTTP 오류 코드 " + responseCode);
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("문자 발송 실패: " + e.getMessage());
            return false;
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
}