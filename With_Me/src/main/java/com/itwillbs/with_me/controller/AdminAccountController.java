package com.itwillbs.with_me.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.service.AdminAccountService;
import com.itwillbs.with_me.service.CreatorFundingService;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.PageInfo;

@Controller
public class AdminAccountController {
	@Autowired 
	private AdminAccountService service;
	
	@Autowired
	private CreatorFundingService creatorService;
	
	// 관리자 - 정산관리
	@GetMapping("AdminAccountList")
	public String adminMemberList(@RequestParam(defaultValue = "1") int pageNum,
								@RequestParam(defaultValue ="") String searchKeyword,
								@RequestParam(defaultValue = "5") int listLimit,
								HttpSession session, Model model, String status) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 파라미터로 받아온 status 값에 따라 accountStatus 값 설정
		String accountStatus = "";
		if(status.equals("출금대기")) {
			accountStatus = "출금대기";	// funding_end_date + 8(후원자 결제종료일)이 오늘보다 미래인 것
			// 후원자 계좌 목록 출력 시 project_payment 테이블의 pro_pay_status 컬럼 '미결제' 인것 출력
		} else if(status.equals("입금대기")) {
			accountStatus = "입금대기";	// creator_account 테이블의 status 컬럼 '입금대기'
		} else if(status.equals("입금완료")) {
			accountStatus = "입금완료";	// creator_account 테이블의 status 컬럼 '입금완료'
		}
		// 페이징 처리
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = service.getAccountListCount(searchKeyword, accountStatus); // 총 목록 개수
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {maxPage = 1;}
		if(endPage > maxPage) {endPage = maxPage;}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminAccountList?pageNum=1&status=" + status);
			return "result/fail";
		}
		
		// 프로젝트 목록 조회
		// 검색어는 기본적으로 "" 널스트링
		List<Map<String, Object>> accountList = service.getAccountList(startRow, listLimit, searchKeyword, accountStatus);
		System.out.println("accountList : " + accountList);
		
		// fintech_use_num을 이용해 계좌 정보 조회
        for (Map<String, Object> account : accountList) {
            String fintechUseNum = (String) account.get("fintech_use_num");
            String id = (String) account.get("creator_email");
            if (fintechUseNum != null) {
            	System.out.println("fintechUseNum : " + fintechUseNum);
            	// 핀테크 사용자 관련 정보 조회(엑세스토큰 조회 위함)
            	BankToken token = creatorService.getBankUserInfo(id);
            	System.out.println("token : " + token);
                
            	// 핀테크 사용자 정보 조회 API 호출
            	Map<String, Object> bankUserInfo = creatorService.getBankUserInfoFromApi(token);
            	
            	// 조회된 핀테크 사용자 정보를 모델에 추가
            	System.out.println("bankUserInfo : " + bankUserInfo);
            	model.addAttribute("bankUserInfo", bankUserInfo);
            }
        }
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		
		// 프로젝트 목록, 페이징 정보 Model 객체에 저장
		model.addAttribute("accountList", accountList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_account_list";
	}
	
	// 해당 프로젝트의 후원자 계좌정보 리스트 조회
	@GetMapping("AdminAccountDetail")
	public String adminAccountDetail(@RequestParam(defaultValue = "1") int pageNum,
									@RequestParam(defaultValue ="") String searchKeyword,
									@RequestParam(defaultValue = "5") int listLimit,
									HttpSession session, Model model, 
									@RequestParam("project_code") String project_code) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}

		// 페이징 처리
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = service.getUserAccountListCount(searchKeyword, project_code); // 총 목록 개수
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {maxPage = 1;}
		if(endPage > maxPage) {endPage = maxPage;}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminAccountDetail?pageNum=1");
			return "result/fail";
		}
		
		// 프로젝트 목록 조회
		// 검색어는 기본적으로 "" 널스트링
		List<Map<String, Object>> accountList = service.getUserAccountList(startRow, listLimit, searchKeyword, project_code);
		System.out.println("accountList : " + accountList);
		
		// fintech_use_num을 이용해 계좌 정보 조회
		// => 조회 잘 안되서 생략 (fintech_use_num 만 띄울거임)
        for (Map<String, Object> account : accountList) {
            String fintechUseNum = (String) account.get("fintech_use_num");
            String id = (String) account.get("mem_email");
            
            // 날짜 변환 작업 (LocalDateTime -> String 변환)
            LocalDateTime proPayDate = (LocalDateTime) account.get("pro_pay_date");
            if (proPayDate != null) {
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                String formattedDate = proPayDate.format(formatter);
                account.put("formattedProPayDate", formattedDate); // 변환한 날짜를 새로운 필드에 저장
            }
            
            if (fintechUseNum != null) {
            	System.out.println("fintechUseNum : " + fintechUseNum);
            	// 핀테크 사용자 관련 정보 조회(엑세스토큰 조회 위함)
            	BankToken token = creatorService.getBankUserInfo(id);
            	System.out.println("token : " + token);
                
            	// 핀테크 사용자 정보 조회 API 호출
            	Map<String, Object> bankUserInfo = creatorService.getBankUserInfoFromApi(token);
            	
            	// 조회된 핀테크 사용자 정보를 모델에 추가
            	System.out.println("bankUserInfo : " + bankUserInfo);
            	model.addAttribute("bankUserInfo", bankUserInfo);
            }
        }
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		
		// 프로젝트 목록, 페이징 정보 Model 객체에 저장
		model.addAttribute("accountList", accountList);
		model.addAttribute("pageInfo", pageInfo);
//		model.addAttribute("project_title", project_title);
		
		return "admin/admin_account_detail";
	}
	
}
