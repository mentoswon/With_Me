package com.itwillbs.with_me.handler;

import java.math.BigDecimal;
import java.net.URI;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.itwillbs.with_me.vo.BankToken;

@Component
// => 특별한 용도 없이 사용할때는 해당 어노테이션 사용 (통합적으로 사용하는 어노테이션임)
public class CreatorBankApiClient {
	// 오픈뱅킹 API 요청 시 사용할 데이터를 직접 변수에 저장하지 않고
	// 별도의 외부 파일로 분리하여 관리 -> 필요 시 가져다 사용
	// src/main/resources/config 에 만듦. -> servlet_context.xml 파일 내에 설정 필수
	
	// @Value("${속성값 저장된 파일 내의 속성명}")
	// => 이게 되려면 외부 속성파일, servlet_context.xml 에 파일 등록이 되어있어야함. 
	// => 값을 가져와서 사용하려면 이렇게 해야함 !
	@Value("${client_id}")
	private String client_id;
	
	@Value("${client_secret}")
	private String client_secret;
	
	@Value("${redirect_uri}")
	private String redirect_uri;
	
	@Value("${client_use_code}")
	private String client_use_code;
	
	@Value("${cntr_account_num}")
	private String cntr_account_num;
	
	@Value("${cntr_account_holder_name}")
	private String cntr_account_holder_name;
	
	@Value("${base_url}")
	private String base_url;
	
	@Autowired
	private BankValueGenerator bankValueGenerator;
	
	// ----------------------------------------------------------
	// 로깅을 위한 Logger 타입 객체 생성 ! (현재 클래스를 파라미터로 전달해야함 -_-^)
	private static final Logger logger = LoggerFactory.getLogger(CreatorBankApiClient.class);
	// ----------------------------------------------------------
	// 2.1.2. 토큰발급 API - 사용자 토큰발급 요청 수행
	// => 요청 url 은 base_url 변수에 저장되어있는 기본주소 + 상세주소를 결합하여 사용
	//	  https://testapi.openbanking.or.kr  +  /oauth/2.0/token
	// 요청 파라미터 : code, client_id, client_secret, redirect_uri, grant_type
	
	// 핀테크 사용자 정보 조회(API)
	public Map<String, Object> requestUserInfo(BankToken token) {
		
		// 1. HTTP 방식 요청에 필요한 URI 정보를 관리할 URI 객체 생성
		URI uri = UriComponentsBuilder
					.fromUriString(base_url) // 기본 요청 주소 설정
					.path("/v2.0/user/me") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
					.queryParam("user_seq_no", token.getUser_seq_no()) // get 방식에서 파라미터 줄 때 사용 (Post 는 안 씀)
					.encode() // 주소 인코딩
					.build() // UriComponents 타입 객체 생성
					.toUri(); // URI 타입 객체로 변환
		
		// 2. 사용자 정보 조회 API 요청에 사용될 헤더 정보를 관리할 HttpHeaders 객체 생성
		// -> add() 메서드 호출하여 헤더 정보 추가 (엑세스 토큰값 추가)
		// -> 만약, 추가해야할 헤더 정보가 복수개일 경우 LinkedMultiValueMap 객체 활용도 가능
		
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
		// 헤더 정보를 문자열 형태로 간단히 전달할 경우 add() 메서드 활용 가능
		// => 지금 필요한 헤더 이름은 Authorization
		//    헤더값 : "Bearer" 문자열과 엑세스 트콘 문자열 결합(공백으로 두 문자열 구분)
		headers.add("Authorization", "Bearer " + token.getAccess_token());
		
		// 3. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => get 방식이므로 body는 없어도 되고(body 정보 없이 전달함), 문자열로 관리 가능하므로 String 지정
		HttpEntity httpEntity = new HttpEntity<String>(headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		// => 리턴타입 : ResponseEntity<Map> - Map의 제너릭은 없음
//		ResponseEntity<Map> responseEntity = 
//				restTemplate.exchange(uri, HttpMethod.GET, httpEntity, Map.class);
		
		// Map 타입 지정 시 제네릭 타입을 사용하기 위해 ResponseEntity<Map<K,V>> 지정하더라도 
		// exchange() 메서드에 Map.class 를 Map<K,V>.class로 지정이 불가능함 !!
		// => ParameterizedTypeReference 타입을 이용하여 사용할 클래스의 제네릭 타입을 지정.........
		// ==> 추상 클래스이므로 생성자 호출코드 뒤에 중괄호 블럭 표기 필수 !!!!!!!! 
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String,Object>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.GET, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}

	
	// 계좌 목록 조회
	public Map<String, Object> requestBankAccountList(BankToken token) {
		
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/account/list") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.queryParam("user_seq_no", token.getUser_seq_no()) // get 방식에서 파라미터 줄 때 사용 (Post 는 안 씀)
				.queryParam("include_cancel_yn", "Y") 
				.queryParam("sort_order", "D") 
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//		headers.add("Authorization", "Bearer " + token.getAccess_token());
		headers.setBearerAuth(token.getAccess_token());
		
		// 3. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => get 방식이므로 body는 없어도 되고(body 정보 없이 전달함), 문자열로 관리 가능하므로 String 지정
		HttpEntity httpEntity = new HttpEntity<String>(headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String,Object>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.GET, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
		
	}

	
	// 계좌 상세 조회
	// => 잔액조회 테스트 데이터가 등록되어있을 경우에만 요청이 성공함 !!
	public Map<String, String> requestAccountDetail(Map<String, Object> map) {
		BankToken token = (BankToken) map.get("token"); // 맵에 들어있던 토큰 꺼내기
		// ------------------------------------------------------------------------
		// 요청에 사용될 값 생성 (bank_tran_id, tran_dtime) p228 참고
		// BankValueGenerator - getBankTranId() 메서드 호출하여 거래 고유번호 (참가기관) 리턴받기
		// => 파라미터 : 이용기관코드  리턴 : String
		String bank_tran_id = bankValueGenerator.getBankTranId(client_use_code);
		
		String tran_dtime = bankValueGenerator.getTranDTime();
		// ------------------------------------------------------------------------
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/account/balance/fin_num") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.queryParam("bank_tran_id", bank_tran_id) // get 방식에서 파라미터 줄 때 사용 (Post 는 안 씀)
				.queryParam("fintech_use_num", map.get("fintech_use_num")) 
				.queryParam("tran_dtime", tran_dtime) 
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//				headers.add("Authorization", "Bearer " + token.getAccess_token());
		headers.setBearerAuth(token.getAccess_token());
		
		// 3. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => get 방식이므로 body는 없어도 되고(body 정보 없이 전달함), 문자열로 관리 가능하므로 String 지정
		HttpEntity httpEntity = new HttpEntity<String>(headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, String>> responseType = 
				new ParameterizedTypeReference<Map<String,String>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		ResponseEntity<Map<String, String>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.GET, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}

	
	// ==================================================================================
	// 2.5 계좌이체 서비스 - 출금
	public Map<String, String> requestWithdraw(Map<String, Object> map) {
		BankToken token = (BankToken) map.get("token"); // 맵에 들어있던 토큰 꺼내기
		String id = (String)map.get("id");
		// ------------------------------------------------------------------------
		// 요청에 사용될 값 생성 (bank_tran_id, tran_dtime) p228 참고
		// BankValueGenerator - getBankTranId() 메서드 호출하여 거래 고유번호 (참가기관) 리턴받기
		// => 파라미터 : 이용기관코드  리턴 : String
		String bank_tran_id = bankValueGenerator.getBankTranId(client_use_code);
		
		String tran_dtime = bankValueGenerator.getTranDTime();
		// ------------------------------------------------------------------------
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/transfer/withdraw/fin_num") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//				headers.add("Authorization", "Bearer " + token.getAccess_token());
		headers.setBearerAuth(token.getAccess_token());
		
		// ----------------------- 여기부터 다름 (중요) ---------------------------
		// 전송할 요청 파라미터 타입이 json 타입을 요구함 !
		// 헤더 정보를 관리하는 HttpHeaders의 setContentType() --> json 타입 지정을 위해 MediaType.Application_JSON 상수 활용
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		// 3. 요청 파라미터를 JSON 형식 데이터로 생성
		// => JSON 라이브러리 추가
		// 지금 넘길 파라미터는 JSONObject 클래스 사용 예정 (배열이 없음. 배열있으면 JSONArray 사용)
		// 3-1)  JSONObject(JSON) 클래스 활용 => put() 메서드 쓰면 자동으로 JSON 형식으로 변환됨
//		JSONObject jsonObject = new JSONObject(); // 기본 생성자로 객체 생성
//		jsonObject.put("bank_tran_id", bank_tran_id);
//		jsonObject.put("cntr_account_type", "N"); // 약정 계좌
//		jsonObject.put("cntr_account_num", cntr_account_num); // 약정 계좌 번호 (서비스 이용기관의 계좌)
//		jsonObject.put("bank_tran_id", "");
//		jsonObject.put("bank_tran_id", "");
//		jsonObject.put("bank_tran_id", "");
//		jsonObject.put("bank_tran_id", "");
//		
//		System.out.println("jsonObject : " + jsonObject.toString());
		// ------------------------------------------------------------------------
		// 3-2) Gson 클래스와 JsonObject 클래스(Gson) 활용 (대소문자가 다름 ! 이건 Gson꺼)
//		Gson gson = new Gson(); // 현재는 생략
		JsonObject jsonObject = new JsonObject(); // 기본생성자만 제공됨 !
		
		// addProperty() 메서드 호출하여 JSON 데이터 추가
		// ----------핀테크 이용기관 정보----------
		jsonObject.addProperty("bank_tran_id", bank_tran_id);
		jsonObject.addProperty("cntr_account_type", "N");
		jsonObject.addProperty("cntr_account_num", cntr_account_num);
		jsonObject.addProperty("dps_print_content", id); // 입금 계좌 인자 내역 - 입금되는 계좌에 출력할 메세지
		
		// ----------요청고객(출금계좌) 정보----------
		jsonObject.addProperty("fintech_use_num", (String)map.get("withdraw_fintech_use_num")); //출금계좌핀테크이용번호
		jsonObject.addProperty("wd_print_content", "아이티윌 입금"); // 출금계좌인자내역 
		jsonObject.addProperty("tran_amt", (String)map.get("tran_amt")); // 거래금액
		jsonObject.addProperty("tran_dtime", tran_dtime); // 요청일시
		jsonObject.addProperty("req_client_name", (String)map.get("withdraw_client_name")); // 고객 이름
		jsonObject.addProperty("req_client_fintech_use_num", (String)map.get("withdraw_fintech_use_num")); // 요청고객핀테크이용번호 
		// -> 요청고객 계좌번호 미사용 시 핀테크 이용번호 사용하면 되고, 동시 설정 시 오류 발생함 ~!!!!!!!!
		
		jsonObject.addProperty("req_client_num", id.toUpperCase()); 
		// 요청고객회원번호인데 고객번호가 따로 없으므로 id 사용. 근데 ! 다 대문자니까 toUpperCase()
		
		jsonObject.addProperty("transfer_purpose", "ST"); //이체용도 (결제: ST)
		
		// ----------수취고객(최종 입금 대상) 정보 -- (필수항목이 아니지만 안 넣으면 오류나는 것들)----------
		jsonObject.addProperty("recv_client_name", cntr_account_holder_name); // 최종 수취인 성명(입금대상)   
		jsonObject.addProperty("recv_client_bank_code", "002"); //
		jsonObject.addProperty("recv_client_account_num", cntr_account_num); //  
		
		System.out.println("jsonObject : " + jsonObject.toString());
//		System.out.println("jsonObject : " + gson.toJson(jsonObject));
		
		
		// ------------------------------------------------------------------------
		// 4. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => 이번에는 ~ 바디도 필요함. 둘 다 생성자를 활용하여 전달
		HttpEntity httpEntity = new HttpEntity<String>(jsonObject.toString(), headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, String>> responseType = 
				new ParameterizedTypeReference<Map<String,String>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		// POST 방식이니까 !!! POST 로 해줌 !!!!!!
		ResponseEntity<Map<String, String>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}

	
	// 입금 요청 2.5.2 입금이체 API
	public Map<String, Object> requestDeposit(Map<String, Object> map) {
		System.out.println(map);
		BankToken token = (BankToken) map.get("token"); // 맵에 들어있던 관리자 엑세스 토큰 꺼내기
		String id = (String)map.get("id");
		// ------------------------------------------------------------------------
		// 요청에 사용될 값 생성 (bank_tran_id, tran_dtime) p228 참고
		// BankValueGenerator - getBankTranId() 메서드 호출하여 거래 고유번호 (참가기관) 리턴받기
		// => 파라미터 : 이용기관코드  리턴 : String
		String bank_tran_id = bankValueGenerator.getBankTranId(client_use_code);
		String tran_dtime = bankValueGenerator.getTranDTime();
		// ------------------------------------------------------------------------
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/transfer/deposit/fin_num") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//				headers.add("Authorization", "Bearer " + token.getAccess_token());
		headers.setBearerAuth(token.getAccess_token());
		
		// ----------------------- 여기부터 다름 (중요) ---------------------------
		// 전송할 요청 파라미터 타입이 json 타입을 요구함 !
		// 헤더 정보를 관리하는 HttpHeaders의 setContentType() --> json 타입 지정을 위해 MediaType.Application_JSON 상수 활용
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		// 3. 요청 파라미터를 JSON 형식 데이터로 생성
		// => JSON 라이브러리 추가
		// 지금 넘길 파라미터는 JSONObject 클래스 사용 예정 (배열이 없음. 배열있으면 JSONArray 사용)
		// 3-1) JsonObject 클래스(Gson) 활용 (대소문자가 다름 ! 이건 Gson꺼)
//		Gson gson = new Gson(); // 현재는 생략
		JsonObject joReq = new JsonObject(); // 기본생성자만 제공됨 !
		
		// 두 개 값은 고정
		joReq.addProperty("tran_no", 1); // 거래 순번 (단건이체이므로 무조건 1 적어줌 (다건 이체는 중단됨))
		joReq.addProperty("bank_tran_id", bank_tran_id); // 출금계좌인자내역 
		
		// ----------요청고객(입금계좌) 정보----------
		joReq.addProperty("fintech_use_num", (String)map.get("fintech_use_num")); //입금계좌핀테크이용번호
		joReq.addProperty("print_content", "위드미_입금"); // 입금계좌인자내역 
		// ------------
//		joReq.addProperty("tran_amt", (String)map.get("tran_amt")); // 거래금액
		// tran_amt를 BigDecimal에서 String으로 변환
	    joReq.addProperty("tran_amt", ((BigDecimal)map.get("tran_amt")).toString()); // 거래금액
		// ------------
		
		joReq.addProperty("req_client_name", (String)map.get("deposit_client_name")); // 고객 이름
		joReq.addProperty("req_client_fintech_use_num", (String)map.get("deposit_fintech_use_num")); // 요청고객핀테크이용번호 
		// -> 요청고객 계좌번호 미사용 시 핀테크 이용번호 사용하면 되고, 동시 설정 시 오류 발생함 ~!!!!!!!!
		
		joReq.addProperty("req_client_num", id.split("@")[0].toUpperCase());
		// 요청고객회원번호인데 고객번호가 따로 없으므로 id 사용. 근데 ! 다 대문자니까 toUpperCase()
		// ++ 우리는 이메일이라서 일단 @ 앞부분 ..
		
		joReq.addProperty("transfer_purpose", "TR"); //이체용도 (송금: TR, 결제: ST)
		
		// 3-2) 입금 이체 1건의 정보를 배열로 관리 (Gson 꺼) 
		// -> 위의 입금계좌 정보를 JsonObject 객체에 저장해뒀으니까 JsonObject 객체를 배열에 주면 됨
		JsonArray jaReq_list = new JsonArray();
		
		jaReq_list.add(joReq);
		
		// 3-3) 기본 입금 이체 정보를 저장할 JsonObject 객체 생성
		JsonObject jsonObject = new JsonObject();
		
		// addProperty() 메서드 호출하여 JSON 데이터 추가
		// ----------핀테크 이용기관 정보----------
		jsonObject.addProperty("cntr_account_type", "N"); // 약정계좌/계정 구분 (N - 계좌)
		jsonObject.addProperty("cntr_account_num", cntr_account_num); // 약정계좌/계정 번호
		
		jsonObject.addProperty("wd_pass_phrase", "NONE"); // 입금이체용 암호문구 (test 시 NONE 값) 
		jsonObject.addProperty("wd_print_content", (String)map.get("deposit_client_name") + "_송금"); // 출금 계좌 인자 내역 - 서비스 이용기관 계좌에 출력 (사용자 정보가 들어가겠죠)
		jsonObject.addProperty("name_check_option", "on"); // 수취인성명 검증 여부 - “on”:검증함, “off”:미검증
		jsonObject.addProperty("tran_dtime", tran_dtime); // 요청일시
		jsonObject.addProperty("req_cnt", 1); // 입금요청건수 (다건 이체 중단으로 단건)
		
		// 3-4) 기본 입금 이체 정보 JsonObject 객체에 1건 이체 정보 JsonArray 객체를 추가
		jsonObject.add("req_list", jaReq_list);
		logger.info(">>>>>>>>>>>>>>>> 입금이체 요청 데이터 : " + jsonObject);
		
		System.out.println("jsonObject : " + jsonObject.toString());
//		System.out.println("jsonObject : " + gson.toJson(jsonObject));
		
		// ===================================================================
		// 테스트 데이터 등록
		/*
		 * 사용자 정보 선택해주고
		 * 송금인은 이연태임 (기관이 보내주는거니까)
		 * 거래금액 : tran_amt 값
		 * 입금계좌 인자내역 : print_content 값
		 * 수취인 성명 : req_client_name 값 (대상 고객 - 최종 수취인 - 테스트에서는 나)
		 * 
		 */
		// ------------------------------------------------------------------------
		// 4. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => 이번에는 ~ 바디도 필요함. 둘 다 생성자를 활용하여 전달
		HttpEntity httpEntity = new HttpEntity<String>(jsonObject.toString(), headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String,Object>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		// POST 방식이니까 !!! POST 로 해줌 !!!!!!
//		ResponseEntity<Map> responseEntity = 
//				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, Map.class);
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}
	
	
	
	// 관리자 엑세스 토큰 발급 요청 (p.25) => 사용자 엑세스 토큰 가져와서 썼고 2-2) 파라미터만 수정함. 나머지는 손 안 댐! 
	public BankToken requestAdminAccessToken() {
		
		// 1) POST 방식 요청을 수행할 URL 정보를 URI 타입 객체로 생성
		URI uri = UriComponentsBuilder
					.fromUriString(base_url + "/oauth/2.0/token") // 요청 주소 설정
					.encode() // 주소 인코딩
					.build() // UriComponents 타입 객체 생성
					.toUri(); // URI 타입 객체로 변환
		
		// 2) POST 방식 요청 수행 시 파라미터를 URL에 결합하지 않고 body에 별도로 포함시켜야함
		// 	  따라서, 해당 파라미터 데이터를 별도의 객체를 통해 전달 필요
		// 	  => LinkedMultiValueMap 타입 객체 활용 -> 그냥 Map써도 되는데 이거 쓰면 데이터가 안전하게 감
		// 2-1) 객체 생성 !
		LinkedMultiValueMap<String, String> parameters = new LinkedMultiValueMap<String, String>();
		
		// 2-2) 이 객체의 add() 메서드 호출하여 Map 처럼 "키, 값" 형식으로 파라미터 저장
		parameters.add("client_id", client_id);
		parameters.add("client_secret", client_secret);
		parameters.add("scope", "oob"); // 출금일 때 여기가 다름 (p25 참고)
		parameters.add("grant_type", "client_credentials"); // 출금일 때 여기가 다름 (p25 참고)
		
		// 3. 요청 정보로 사용할 헤더와 바디 정보를 관리하는 HttpEntity 타입 객체 생성
		HttpEntity<LinkedMultiValueMap<String, String>> httpEntity = new HttpEntity<LinkedMultiValueMap<String,String>>(parameters);
		// => 요청할 수 있는 데이터의 모양이 만들어짐 !
		
		// 4. REST API(RESTful API) 요청을 위해 RestTemplate 객체 활용
		// 4-1) 객체 생성
		RestTemplate restTemplate = new RestTemplate();
		
		// 중요 !!!! 
		// 4-2) RestTemplate의 exchange() 메서드 호출하여 요청 수행
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.POST 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스
		
		// 응답데이터를 VO 클래스 타입으로 파싱할 경우
		// => 응답데이터를 저장할 클래스를 지정해야함 ! 
		ResponseEntity<BankToken> responseEntity =  restTemplate.exchange(
				uri, // 요청 URL 관리하는 URI 타입 객체 (문자열로 된 URL도 전달 가능)
				HttpMethod.POST,  // 요청 메서드(HttpMethod.xxx)
				httpEntity,  // 요청 정보를 관리하는 httpEntity 객체
				BankToken.class); //응답 데이터를 파싱하여 관리할 클래스 자체를 지정해야함.
		
		// 주의 ! 응답 데이터인 JSON 타입 데이터를 BankToken 타입으로 자동 파싱하려면
		// Gson 또는 Jackson 라이브러리가 필요한데 이 라이브러리가 없을 경우 예외 발생함 !
		// org.springframework.web.client.UnknownContentTypeException: Could not extract response: no suitable HttpMessageConverter found for response type
		
		// => 따라서 라이브러리가 필요함 우리는 Gson 사용할거임
		
		// 임시) 응답 정보 확인을 위해 ResponseEntity 객체의 메서드 활용
		logger.info("응답 코드 : " + responseEntity.getStatusCode());
		logger.info("응답 헤더 : " + responseEntity.getHeaders());
		logger.info("응답 본문 : " + responseEntity.getBody());
		
		// 5. 응답 정보 리턴
		// => ResponseEntity 객체를 직접 리턴하지 않고 getBody() 메서드 호출 결과인 파싱 정보를 관리하는 객체를 리턴
		
		return responseEntity.getBody();
				
	}

	
	// 송금 처리 - 1. 출금
	public Map<String, Object> requestWithdrawForTransfer(Map<String, Object> map) {
		
		// 출금이체 수행
		
		// 두 사용자의 계좌(토큰) 정보 꺼내기
		BankToken senderToken = (BankToken) map.get("senderToken"); // 맵에 들어있던 토큰 꺼내기
		BankToken receiverToken = (BankToken) map.get("receiverToken"); // 맵에 들어있던 토큰 꺼내기
		
		System.out.println("토큰 꺼낸거 확인 - senderToken : " + senderToken + ", receiverToken : " + receiverToken);
		// ------------------------------------------------------------------------
		// 요청에 사용될 값 생성 (bank_tran_id, tran_dtime) p228 참고
		// BankValueGenerator - getBankTranId() 메서드 호출하여 거래 고유번호 (참가기관) 리턴받기
		// => 파라미터 : 이용기관코드  리턴 : String
		String bank_tran_id = bankValueGenerator.getBankTranId(client_use_code);
		
		String tran_dtime = bankValueGenerator.getTranDTime();
		// ------------------------------------------------------------------------
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/transfer/withdraw/fin_num") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//				headers.add("Authorization", "Bearer " + token.getAccess_token());
		headers.setBearerAuth(senderToken.getAccess_token());
		
		// ----------------------- 여기부터 다름 (중요) ---------------------------
		// 전송할 요청 파라미터 타입이 json 타입을 요구함 !
		// 헤더 정보를 관리하는 HttpHeaders의 setContentType() --> json 타입 지정을 위해 MediaType.Application_JSON 상수 활용
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		// ------------------------------------------------------------------------
		// 3-2) Gson 클래스와 JsonObject 클래스(Gson) 활용 (대소문자가 다름 ! 이건 Gson꺼)
//		Gson gson = new Gson(); // 현재는 생략
		JsonObject jsonObject = new JsonObject(); // 기본생성자만 제공됨 !
		
		// addProperty() 메서드 호출하여 JSON 데이터 추가
		// ----------핀테크 이용기관 정보----------
		jsonObject.addProperty("bank_tran_id", bank_tran_id);
		jsonObject.addProperty("cntr_account_type", "N");
		jsonObject.addProperty("cntr_account_num", cntr_account_num);
		jsonObject.addProperty("dps_print_content", senderToken.getName()); // 입금 계좌 인자 내역 - 입금되는 계좌에 출력할 메세지(이름)
		
		// ----------요청고객(출금계좌) 정보----------
		jsonObject.addProperty("fintech_use_num", senderToken.getFintech_use_num()); //출금계좌핀테크이용번호
		jsonObject.addProperty("wd_print_content", receiverToken.getName()); // 출금 계좌 인자내역 (받는 사람) - 출금되는 계좌에 출력할 메세지니까 받는 사람떠야겠지요
//		jsonObject.addProperty("wd_print_content", receiverToken.getId().subString(0, 7)); 
		// 현재는 아이디로 쓰고있어서 출금계좌인자내역이 14바이트를 넘으면 안 됨( -> 원래는 이름 들어감 ! 이름 들어가면 이럴 일 없음)
		jsonObject.addProperty("tran_amt", (String)map.get("tran_amt")); // 거래금액
		jsonObject.addProperty("tran_dtime", tran_dtime); // 요청일시
		jsonObject.addProperty("req_client_name", senderToken.getName()); // 고객 이름
		jsonObject.addProperty("req_client_fintech_use_num", senderToken.getFintech_use_num()); // 요청고객핀테크이용번호 
		// -> 요청고객 계좌번호 미사용 시 핀테크 이용번호 사용하면 되고, 동시 설정 시 오류 발생함 ~!!!!!!!!
		
		jsonObject.addProperty("req_client_num", senderToken.getId().toUpperCase()); 
		// 요청고객회원번호인데 고객번호가 따로 없으므로 id 사용. 근데 ! 다 대문자니까 toUpperCase()
		
		jsonObject.addProperty("transfer_purpose", "TR"); //이체용도 (결제: ST, 송금: TR)
		
		// ----------수취고객(최종 입금 대상) 정보 -- (필수항목이 아니지만 안 넣으면 오류나는 것들 --> 검증은 안 함)----------
		jsonObject.addProperty("recv_client_name", receiverToken.getName()); // 최종 수취인 성명(입금대상) 
		// 아래 2가지는 현재 임의의 값이나, 실제로는 사용자 계좌정보에 저장된 계좌번호와 은행기관코드를 전달하면 된다.
		jsonObject.addProperty("recv_client_bank_code", "002"); // 임의의 값
		jsonObject.addProperty("recv_client_account_num", "111111"); // 임의의 값
		
		System.out.println("jsonObject : " + jsonObject.toString());
//		System.out.println("jsonObject : " + gson.toJson(jsonObject));
		
		
		// ------------------------------------------------------------------------
		// 4. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => 이번에는 ~ 바디도 필요함. 둘 다 생성자를 활용하여 전달
		HttpEntity httpEntity = new HttpEntity<String>(jsonObject.toString(), headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String,Object>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		// POST 방식이니까 !!! POST 로 해줌 !!!!!!
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}

	
	// 송금 처리 - 2. 입금
	public Map<String, Object> requestDepositForTransfer(Map<String, Object> map) {
		
		// 두 사용자의 계좌(토큰) 정보 꺼내기
		BankToken senderToken = (BankToken) map.get("senderToken"); // 맵에 들어있던 토큰 꺼내기
		BankToken receiverToken = (BankToken) map.get("receiverToken"); // 맵에 들어있던 토큰 꺼내기
		BankToken adminToken = (BankToken) map.get("adminToken"); // 맵에 들어있던 토큰 꺼내기
		
		// ------------------------------------------------------------------------
		// 요청에 사용될 값 생성 (bank_tran_id, tran_dtime) p228 참고
		// BankValueGenerator - getBankTranId() 메서드 호출하여 거래 고유번호 (참가기관) 리턴받기
		// => 파라미터 : 이용기관코드  리턴 : String
		String bank_tran_id = bankValueGenerator.getBankTranId(client_use_code);
		String tran_dtime = bankValueGenerator.getTranDTime();
		// ------------------------------------------------------------------------
		// 1. Uri
		URI uri = UriComponentsBuilder
				.fromUriString(base_url) // 기본 요청 주소 설정
				.path("/v2.0/transfer/deposit/fin_num") // 작업 요청 상세 주소 설정 (path 는 여러개도 가능)
				.encode() // 주소 인코딩
				.build() // UriComponents 타입 객체 생성
				.toUri(); // URI 타입 객체로 변환
		
		// 2. 헤더 정보를 관리할 HttpHeaders 객체 생성
		HttpHeaders headers = new HttpHeaders(); // 추가할 헤더 정보가 1개이므로 기본 생성자 활용
//				headers.add("Authorization", "Bearer " + token.getAccess_token());
		// 입금할 때는 핀테크 이용기관 토큰 !! 출금하는 곳이 핀테크 이용기관이므로
		headers.setBearerAuth(adminToken.getAccess_token());
		
		// ----------------------- 여기부터 다름 (중요) ---------------------------
		// 전송할 요청 파라미터 타입이 json 타입을 요구함 !
		// 헤더 정보를 관리하는 HttpHeaders의 setContentType() --> json 타입 지정을 위해 MediaType.Application_JSON 상수 활용
		headers.setContentType(MediaType.APPLICATION_JSON);
		
		// 3. 요청 파라미터를 JSON 형식 데이터로 생성
		// => JSON 라이브러리 추가
		// 지금 넘길 파라미터는 JSONObject 클래스 사용 예정 (배열이 없음. 배열있으면 JSONArray 사용)
		// 3-1) JsonObject 클래스(Gson) 활용 (대소문자가 다름 ! 이건 Gson꺼)
//		Gson gson = new Gson(); // 현재는 생략
		JsonObject joReq = new JsonObject(); // 기본생성자만 제공됨 !
		
		// 두 개 값은 고정
		joReq.addProperty("tran_no", 1); // 거래 순번 (단건이체이므로 무조건 1 적어줌 (다건 이체는 중단됨))
		joReq.addProperty("bank_tran_id", bank_tran_id); // 출금계좌인자내역 
		
		// ---------- 받는 사람 정보 ----------
		joReq.addProperty("fintech_use_num", receiverToken.getFintech_use_num()); //입금계좌핀테크이용번호
		joReq.addProperty("print_content", senderToken.getName()); // 입금계좌인자내역 (보내는 사람)
		joReq.addProperty("tran_amt", (String)map.get("tran_amt")); // 거래금액
		
		// ---------- 보내는 사람 정보 ----------
		joReq.addProperty("req_client_name", senderToken.getName()); // 고객 이름 (보내는 사람)
		joReq.addProperty("req_client_fintech_use_num", senderToken.getFintech_use_num()); // 요청고객핀테크이용번호 (출금계좌) 
		// -> 요청고객 계좌번호 미사용 시 핀테크 이용번호 사용하면 되고, 동시 설정 시 오류 발생함 ~!!!!!!!!
		
		joReq.addProperty("req_client_num", senderToken.getId().toUpperCase()); 
		// 요청고객회원번호인데 고객번호가 따로 없으므로 id 사용. 근데 ! 다 대문자니까 toUpperCase()
		
		joReq.addProperty("transfer_purpose", "TR"); //이체용도 (송금: TR, 결제: ST)
		
		// 3-2) 입금 이체 1건의 정보를 배열로 관리 (Gson 꺼) 
		// -> 위의 입금계좌 정보를 JsonObject 객체에 저장해뒀으니까 JsonObject 객체를 배열에 주면 됨
		JsonArray jaReq_list = new JsonArray();
		
		jaReq_list.add(joReq);
		
		// 3-3) 기본 입금 이체 정보를 저장할 JsonObject 객체 생성
		JsonObject jsonObject = new JsonObject();
		
		// addProperty() 메서드 호출하여 JSON 데이터 추가
		// ----------핀테크 이용기관 정보----------
		jsonObject.addProperty("cntr_account_type", "N"); // 약정계좌/계정 구분 (N - 계좌)
		jsonObject.addProperty("cntr_account_num", cntr_account_num); // 약정계좌/계정 번호
		
		jsonObject.addProperty("wd_pass_phrase", "NONE"); // 입금이체용 암호문구 (test 시 NONE 값) 
		jsonObject.addProperty("wd_print_content", receiverToken.getName()); // 출금 계좌 인자 내역 - 서비스 이용기관 계좌에 출력 (사용자 정보가 들어가겠죠)
		jsonObject.addProperty("name_check_option", "on"); // 수취인성명 검증 여부 - “on”:검증함, “off”:미검증
		jsonObject.addProperty("tran_dtime", tran_dtime); // 요청일시
		jsonObject.addProperty("req_cnt", 1); // 입금요청건수 (다건 이체 중단으로 단건)
		
		// 3-4) 기본 입금 이체 정보 JsonObject 객체에 1건 이체 정보 JsonArray 객체를 추가
		jsonObject.add("req_list", jaReq_list);
		logger.info(">>>>>>>>>>>>>>>> 입금이체 요청 데이터 : " + jsonObject);
		
		System.out.println("jsonObject : " + jsonObject.toString());
//		System.out.println("jsonObject : " + gson.toJson(jsonObject));
		
		// ===================================================================
		// 테스트 데이터 등록
		/*
		 * 사용자 정보 선택해주고 (받는 사람)
		 * 송금인 이연태 (기관이 보내주는거니까)
		 * 거래금액 : tran_amt 값
		 * 입금계좌 인자내역 : print_content 값
		 * 수취인 성명 : req_client_name 값 (대상 고객 - 최종 수취인)
		 */
		
		// ------------------------------------------------------------------------
		// 4. 헤더와 바디를 묶어서 관리하는 HttpEntity 객체 생성
		// => 이번에는 ~ 바디도 필요함. 둘 다 생성자를 활용하여 전달
		HttpEntity httpEntity = new HttpEntity<String>(jsonObject.toString(), headers);
		
		
		// 4-1. RESTful API 요청을 위한 RestTemplate 객체 생성 후 
		RestTemplate restTemplate = new RestTemplate();
		
		// 4-2. exchange() 메서드 호출해서 REST API 요청 수행 - GET
		// => 파라미터 : 요청 URL 관리하는 객체 (URI), 
		// 				 요청 메서드(POST 방식이므로 HttpMethod.GET 상수 활용), 
		//				 정보를 관리하는 HttpEntity 객체,
		//				 요청에 대한 응답 전달되면 응답 데이터를 파싱하여 관리할 클래스 (여기서는 Map)
		
		// => 응답데이터에 리스트객체가 있어서 String, String은 사용 불가합니다요.
		ParameterizedTypeReference<Map<String, Object>> responseType = 
				new ParameterizedTypeReference<Map<String,Object>>() {};
				
		// 이제 마지막 클래스 들어가는 자리에 responseType 적어주면 됨
		// POST 방식이니까 !!! POST 로 해줌 !!!!!!
//		ResponseEntity<Map> responseEntity = 
//				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, Map.class);
		ResponseEntity<Map<String, Object>> responseEntity = 
				restTemplate.exchange(uri, HttpMethod.POST, httpEntity, responseType);
		
		
		// 5. 응답데이터를 관리하는 ResponseEntity 객체의 getBody() 메서드 호출
		return responseEntity.getBody();
	}
	
}













