package com.itwillbs.with_me.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.json.JSONException;
import org.json.JSONObject;

@Service
public class PaymentService {

    @Value("${iamport.api.key}")
    private String apiKey;

    @Value("${iamport.api.secret}")
    private String apiSecret;

    // 1. 토큰 발급 메서드
    public String getToken() throws Exception {
        System.out.println("토큰발급");
        RestTemplate restTemplate = new RestTemplate();
        String url = "https://api.iamport.kr/users/getToken";

        JSONObject requestBody = new JSONObject();
        requestBody.put("imp_key", apiKey);
        requestBody.put("imp_secret", apiSecret);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        ResponseEntity<String> response;
        try {
            response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
            System.out.println("응답 상태 코드: " + response.getStatusCode());
            System.out.println("응답 본문: " + response.getBody());
        } catch (Exception e) {
            throw new Exception("API 요청 중 오류 발생: " + e.getMessage());
        }

        if (response.getStatusCode().is2xxSuccessful()) {
            JSONObject responseJson;
            try {
                responseJson = new JSONObject(response.getBody());
            } catch (JSONException e) {
                throw new Exception("JSON 파싱 오류: " + e.getMessage());
            }

            System.out.println("응답 JSON: " + responseJson.toString()); // 전체 JSON 응답 출력
            System.out.println("코드 : " + responseJson.getInt("code"));

            if (responseJson.getInt("code") == 0) {
                System.out.println("토큰발급 성공");
                return responseJson.getJSONObject("response").getString("access_token");
            } else {
                throw new Exception("토큰 발급 실패: " + responseJson.getString("message"));
            }
        } else {
            throw new Exception("응답 실패: " + response.getStatusCode());
        }
    }

    // 2. 결제 취소 메서드
    public void cancelPayment(String impUid, String merchantUid, String token) throws Exception {
        System.out.println("결제취소");
        RestTemplate restTemplate = new RestTemplate();
        String url = "https://api.iamport.kr/payments/cancel";

        JSONObject requestBody = new JSONObject();
        requestBody.put("imp_uid", impUid);
        requestBody.put("merchant_uid", merchantUid);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        JSONObject responseJson = new JSONObject(response.getBody());

        if (!responseJson.getString("code").equals("0")) {
            throw new Exception("결제 취소 실패: " + responseJson.getString("message"));
        }
    }
}
