package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.service.BankService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.service.UserFundingService;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.ReportVO;
import com.itwillbs.with_me.vo.RewardVO;

@Controller
public class UserFundingController {
	@Autowired
	private UserFundingService service;
	
	@Autowired
	private MemberService memberService;
	
	private String uploadPath = "/resources/upload"; 
	
	@GetMapping("ProjectList")
	public String projectList(ProjectVO project, Model model, 
			@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String project_state,
			HttpSession session) {
		System.out.println("searchKeyword : " + searchKeyword);
		
		// 메뉴에서 선택한 카테고리대로 목록이 표출되게 해야함
		String category = project.getProject_category(); 
		String category_detail = project.getProject_category_detail(); 
		
//		System.out.println("category : " + category);
//		System.out.println("category_detail : " + category_detail);
		
		// 한 페이지에서 표시할 글 목록 개수 지정
		int listLimit = 8;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		// --------------------------------------------------------------------
		
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getBoardListCount(searchKeyword, category, category_detail, project_state);
		
		System.out.println("listCount : " + listCount);
		
		int pageListLimit = 3;
		
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		
		int startPage = (pageNum -1) / pageListLimit * pageListLimit + 1;
		
		int endPage = startPage + pageListLimit - 1;
		
		// 수정 !! 검색 결과가 없을 때 해당페이지는 존재하지 않습니다가 뜨는 경우를 위해 
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0이면 1로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 전달받은 페이지 번호가 1보다 작거나 최대 번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "ProjectList");
			
			return "result/fail";
		}
		
		// ===================================================================
		// --------------------------------------------------------------------
		// 목록 표출하기
		
		String id = (String)session.getAttribute("sId");
		
		List<Map<String, Object>> projectList = service.getProjectList(category, category_detail, searchKeyword, startRow, listLimit, id, project_state);
		
		System.out.println("projectList : " + projectList);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageInfo", pageInfo);
//		model.addAttribute("isLike", isLike);
		
		return "project/project_list";
	}
	
	
	@GetMapping("ProjectDetail")
	public String projectDetail(ProjectVO project, Model model, HttpSession session) {
		System.out.println("ProjectDetail : " + project);
		String project_code = project.getProject_code();
		
		// 프로젝트 가져오기
		Map<String, Object> project_detail = service.getProject(project_code);
		
		System.out.println("가져온 프로젝트 ~ : " + project_detail);
		
		// 창작자의 누적 펀딩액 가져오기
		int totalFundAmt = service.getTotalFundAmtOfCreator((String)project_detail.get("creator_email"));
		
		project_detail.put("totalFundAmt", totalFundAmt);
		
		// 결제일 계산 ------------------
		Date project_end_date = (Date) project_detail.get("funding_end_date");
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");

        Calendar cal = Calendar.getInstance(); // 날짜 계산을 위해 Calendar 추상클래스 선언 및 getInstance() 메서드 사용
        
        cal.setTime(project_end_date);

        cal.add(Calendar.DATE, 1); // 날짜에 1일 더한다.
        
        String pay_date = format.format(cal.getTime());
//        System.out.println(pay_date);
        
        // 결제일 계산 end --------------
        
        // Map 객체 (project_detail) 에 집어넣기
        project_detail.put("pay_date", pay_date);
		
        // --------------------------------------------------------------
        
        // 팔로워 수 계산 -------------------
        // 창작자 email 가져오기
        String creator_email = (String) project_detail.get("creator_email");
        
        int followerCount = service.countFollower(creator_email);
        
//        System.out.println(creator_email + "의 팔로워 수 : " + followerCount);
        
        // Map 객체 (project_detail) 에 집어넣기
        project_detail.put("followerCount", followerCount);
         
        // 팔로워 수 계산 end ---------------
        
        // 팔로워 리스트 --------------------
        List<FollowVO> followerList = service.getFollowerList(creator_email);
        
        project_detail.put("followerList", followerList);
        System.out.println("팔로우 ~ : " + followerList);
        // 팔로워 리스트  end ---------------
        
        // ===================================================================
        
        // 내가 좋아요 한건지 판단 후 가져가기 -----------------------------
        String id = (String) session.getAttribute("sId");
        
        LikeVO isLike = service.getIsLike(project_code, id);
        project_detail.put("isLike", isLike);
        
        // ===================================================================
        
        // 프로젝트별 리워드 정보 가져오기 ------------
        int project_idx = (int) project_detail.get("project_idx");
//        System.out.println("project_idx : " + project_idx);
        List<RewardVO> rewardList = service.getReward(project_idx);
        
        System.out.println("rewardList : " + rewardList);
        
        // --------------------------------------------------------------
        
        // 리워드별 아이템 가져오기
        List<Map<String, Object>> rewardItemList = new ArrayList<Map<String,Object>>();
        List<Map<String, Object>> allRewardItems = new ArrayList<Map<String,Object>>();  // 모든 아이템을 저장할 리스트

        List<Map<String, Object>> itemOptions = new ArrayList<Map<String,Object>>();
        Map<String, Object> allItemOptionsMap = new HashMap<String, Object>(); // 아이템별 옵션을 저장할 맵

        int reward_idx = 0;

        for(int i = 0 ; i < rewardList.size() ; i++) {
            reward_idx = rewardList.get(i).getReward_idx();
            
            System.out.println("reward_idx : " + reward_idx);
            rewardItemList = service.getRewardItemList(reward_idx);
            
            // 가져온 아이템 리스트를 전체 리스트에 추가
            allRewardItems.addAll(rewardItemList);
        }

        // 객관식일 경우 아이템별 옵션도 가져와야함
        for(int j = 0; j < allRewardItems.size() ; j++) {
            String item_idx = (String) allRewardItems.get(j).get("splited_item_idx");
            System.out.println("item_idx : " + item_idx);
            
            if(allRewardItems.get(j).get("item_condition").equals("객관식")) {
                itemOptions = service.getItemOpionList(item_idx);
                
                // 옵션 리스트를 맵에 추가, 키는 item_idx로 설정
                allItemOptionsMap.put(item_idx, itemOptions);
            }
        }

        // 이제 allRewardItems 리스트에 모든 아이템들이 저장되어 있고,
        // allItemOptionsMap 맵에는 객관식 옵션이 있는 아이템들의 옵션 리스트가 저장되어 있음.
        // => 변수에 덮어써져서 마지막거만 표출되고 나머지는 표출되지 않았음 .. 해결 0830
        
        
        // 확인
        System.out.println("allItemOptionsMap : " + allItemOptionsMap);
        System.out.println("allRewardItems : " + allRewardItems);
        System.out.println("rewardItemList : " + rewardItemList);
        
        System.out.println("itemOptions : " + itemOptions);
        // 확인
        
        // 후원 정보 가져오기 end --------
        
        // =========================================================
		model.addAttribute("project_detail", project_detail);
		model.addAttribute("rewardList", rewardList);
		model.addAttribute("allRewardItems", allRewardItems);
		model.addAttribute("itemOptions", itemOptions);
		
		return "project/project_detail";
	}
	
//	@GetMapping("FundInProgress")
//	public String fundInProgress() {
//		return "project/fund_in_progress";
//	}
	
	// 사용자 후원 진행
	@GetMapping("FundInProgress")
	public String fundInProgress(@RequestParam Map<String, Object> map, HttpSession session, MemberVO member, Model model) {
		System.out.println("map 후원 진행 : " + map);	
		
		String id = (String) session.getAttribute("sId");
		
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
//			session.setAttribute("prevURL", "ProjectDetail?project_title=" + (String)map.get("project_title") + "&project_code=" + (String)map.get("project_code"));
			return "result/fail";
		}
		
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
//		System.out.println("member : " + member);
		
		// 아이디로 주소 정보 가져오기
		List<AddressVO> userAddress = service.getUserAddress(member);
//		System.out.println("userAddress : " + userAddress);
		
		
		// =========================================================================
		// 선택한 후원 정보 정리
		
		Map<String, Object> optionMap = new HashMap<String, Object>(); // option 만 따로 담을 map
		
		if(map.get("funding_item_option") != null) {
			
			String selected_option = map.get("funding_item_option").toString();
			String selected_option_title = map.get("reward_option_title").toString();
			
//		System.out.println(selected_option);
			
			String[] optionArr = selected_option.split("\\|");
			String[] optionTitleArr = selected_option_title.split("\\|");
			System.out.println("optionArr : " + Arrays.toString(optionArr));		
			System.out.println("optionTitleArr : " + Arrays.toString(optionTitleArr));
			
			map.put("selectedOption", optionArr);
			map.put("selectedOption", optionTitleArr);
			
			System.out.println("map: " + map);
			for(int i = 0 ; i < optionArr.length ; i++) {
				optionMap.put(optionTitleArr[i], optionArr[i]);
			}
			
			System.out.println("optionMap : " +optionMap);
		}
		
		// =========================================================================
		model.addAttribute("member", member);
		model.addAttribute("userAddress", userAddress);
		model.addAttribute("selectedReward", map);
		model.addAttribute("optionMap", optionMap);
		
		
		return "project/fund_in_progress";
//		return "redirect:/FundInProgress";
	}
	
	
	// =========================================================================
	
	// 펀딩 등록
	@GetMapping ("UserFundingPro")
	public String userFundingProView(){
		
		return "project/fund_success";
	}
	
	@PostMapping ("UserFundingPro")
	public String userFundingPro(@RequestParam Map<String, Object> map, Model model, HttpSession session, MemberVO member) {
		System.out.println("후원할 내용 : " + map);
		
		String id = (String) session.getAttribute("sId");
		member.setMem_email(id);
		
		Integer payMethod = Integer.parseInt(String.valueOf( map.get("payMethod"))); //결제 방법
		
		// 몇 번째 후원자인지
		int FundMemCount = 0;
		int user_funding_project_idx = 0;
		
		// 0908 funding_idx 빼내서 가져가기
		int funding_idx = 0;
		
		
		// 일반후원과 리워드 후원 메서드 구분 필요.. !
		// 일반후원
		if(Integer.parseInt(String.valueOf(map.get("user_funding_reward_idx"))) == 0) {
			int insertCount = service.registDefaultFunding(map);
			
			user_funding_project_idx = Integer.parseInt(String.valueOf(map.get("user_funding_project_idx")));
			
			if(insertCount > 0) {
				FundMemCount = service.getFundCount(user_funding_project_idx);
//				System.out.println("FundMemCount : " + FundMemCount);
				
				funding_idx = service.getNowFundingIdx(id);
				
				// 구매 내역 project_payment 테이블에 저장
				service.registPaymentInfo(map);
				
				if(payMethod == 3) { // 금융결제원일 때만
					// 계좌 정보 DB에 저장 (map 에 fintech_use_num, tranDtime 담아왔음)
					// 추가로 필요) mem_name 가져오기
					
					member.setMem_email(id);
					member = memberService.getMember(member);
					String mem_name = member.getMem_name();
					
					map.put("mem_name", mem_name);
					
					// tranDtime 변형
					String tran_dtime = (String) map.get("tranDtime"); 
					
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
					LocalDate tranDtime = LocalDate.parse(tran_dtime, formatter);
					
					map.put("tranDtime", tranDtime);
					
					// user_account 테이블에 저장하러 갑시다
					service.registAccountInfo(map);
				}
			}
			
		} else {
			// 구매후원
			int insertCount = service.registUserFunding(map); // 후원 정보 등록
			
			user_funding_project_idx = Integer.parseInt(String.valueOf(map.get("user_funding_project_idx")));
			
			if(insertCount > 0) {
				FundMemCount = service.getFundCount(user_funding_project_idx);
//				System.out.println("FundMemCount : " + FundMemCount);
				
				funding_idx = service.getNowFundingIdx(id);
				
				// 구매 내역 project_payment 테이블에 저장
				service.registPaymentInfo(map);
				
				if(payMethod == 3) { // 금융결제원일 때만
					// 계좌 정보 DB에 저장 (map 에 fintech_use_num, tranDtime 담아왔음)
					// 추가로 필요) mem_name 가져오기
					
					member = memberService.getMember(member);
					String mem_name = member.getMem_name();
					
					map.put("mem_name", mem_name);
					
					// tranDtime 변형
					String tran_dtime = (String) map.get("tranDtime"); 
					
					DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
					LocalDate tranDtime = LocalDate.parse(tran_dtime, formatter);
					
					map.put("tranDtime", tranDtime);
					
					// user_account 테이블에 저장하러 갑시다
					service.registAccountInfo(map);
				}
			}
		}
		
		model.addAttribute("FundMemCount", FundMemCount); // 몇 번째 후원자인지 전달
		
		model.addAttribute("funding_idx", funding_idx); // 몇 번째 후원자인지 전달
		
		return "redirect:/UserFundingPro";
	}
	
	// ================================================================================================================

	// =================================================================================================================
	
	// 배송지 등록
	@ResponseBody
	@PostMapping("RegistAddress")
	public List<AddressVO> registAddress(AddressVO new_address, HttpSession session, MemberVO member) throws Exception {
		System.out.println("new_address : " + new_address);
		
		String id = (String) session.getAttribute("sId");

		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
		
		// 배송지를 등록하면 해당 배송지를 선택된 배송지로 만들것임
		// 원래 선택된 배송지 있으면 그건 .. N으로 바꾸기
		
		// 선택된 배송지 있는지 판별
		int isSelectedCount = service.getAddressIsSelected(id);
		List<AddressVO> addressList = null;
		
		if(isSelectedCount == 1) { // 선택된 배송지 있는 경우
					
			// 해당 배송지를 N으로 바꿔야함
			int changeCount = service.modifySelectedAddressToN(id);
			
			if(changeCount > 0) { // 이 아이디에 있던 선택된 배송지를 N으로 바꿈
				
				// 일단 기본배송지 등록된거 있는지 확인 먼저 필요
				int isDefaultCount = service.getAddressIsDefault(id);
				
				if(isDefaultCount > 0) { // 기본배송지 있음
					if(new_address.getAddress_is_default().equals("off")) { // 기본 배송지 있는데 안 바꾸면 그냥 등록 !
						int insertCount = service.registNewAddress(new_address);
						
						if(insertCount > 0) {
							addressList = service.getUserAddress(member);
						} 
						
						System.out.println("기본배송지 있는데 변경 안 하는 경우 : " + insertCount);
						
					} else if(new_address.getAddress_is_default().equals("on")) { // 새 주소 등록하면서 기본 배송지 설정 !
						
						// 기본배송지가 있으면 그걸 N으로 바꿔야함 -> update
						int updateCount = service.modifyDefaultAddressToN(id);
						
						// 바꾸고 새로운 기본배송지 insert
						if(updateCount > 0) {
							int insertCount = service.registNewAddress(new_address);
							
							if(insertCount > 0) {
								addressList = service.getUserAddress(member);
							} 
						} 
						System.out.println("기본배송지 있는데 기본배송지 변경하는 경우 : " + updateCount);
						
					}
				} else if (isDefaultCount == 0) { // 기본 배송지 없음 ! 그냥 등록 ! null, on 에 따라 다르게 들어가게 mapper.xml 에 해놨음
					
					int insertCount = service.registNewAddress(new_address);
					
					if(insertCount > 0) {
						addressList = service.getUserAddress(member);
					} 
					
					System.out.println("기본배송지 없는 경우 : " + insertCount);
				}
				
			} 
		} else { //선택배송지 원래 없는 경우
			int insertCount = service.registNewAddress(new_address);
			
			if(insertCount > 0) {
				addressList = service.getUserAddress(member);
			} 
		} 
		
		return addressList;
	}
	
	
	// 배송지 삭제
	@ResponseBody
	@GetMapping("DeleteAddress")
	public String deleteAddress(AddressVO address, HttpSession session, MemberVO member) {
		System.out.println("address : " + address);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int deleteCount = service.removeAddress(address);
		
		// 주소 삭제 요청
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(deleteCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
		
	}
	
	// 선택된 배송지 삭제하는 경우 - 추가 0905
	@ResponseBody
	@GetMapping("DeleteAddress2")
	public List<AddressVO> deleteAddress2(AddressVO address, HttpSession session, MemberVO member) {
		System.out.println("address : " + address);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int deleteCount = service.removeAddress(address); // 일단 delete 하고
		
		String id = (String) session.getAttribute("sId");
		
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
		
		List<AddressVO> addressList = null;
		
		if(deleteCount > 0) {
			service.modifySelectedAddressToY2(id); // 그 사람의 배송지 주소 중에 제일 큰걸 selected 로 바꾸기
			
			addressList = service.getUserAddress(member);
		}
		
		return addressList;
	}
	
	// 배송지 변경
	@ResponseBody
	@PostMapping("ChangeAddress")
	public String changeAddress(@RequestParam(defaultValue = "0")int address_idx, HttpSession session) {
		System.out.println("address_idx: " + address_idx);
		
		// 선택된 배송지 있는지 판별
		String id = (String) session.getAttribute("sId");
		int isSelectedCount = service.getAddressIsSelected(id);
		
		// 주소 변경 요청
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(isSelectedCount == 1) { // 선택된 배송지 있는 경우
			
			// 해당 배송지를 N으로 바꿔야함
			int changeCount = service.modifySelectedAddressToN(id);
			
			if(changeCount > 0) { // 원래 address_selected 가 Y 인걸 N 으로 바꾸는걸 성공하고 update 해야함
				int updateCount = service.modifySelectedAddressToY(address_idx);
				
				if(updateCount > 0) {
					resultMap.put("result", true); // 변경 성공
				} else { 
					resultMap.put("result", false);// 변경 실패
				}
			} 
		} else { //선택배송지 원래 없는 경우
			int updateCount = service.modifySelectedAddressToY(address_idx);
			
			if(updateCount > 0) {
				resultMap.put("result", true);// 변경 성공
			} else {
				resultMap.put("result", false);// 변경 실패
			}
		} 
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
	// 기본 배송지 변경 - 설정
	@ResponseBody
	@PostMapping("RegistDefaultAddress")
	public String registDefaultAddress(@RequestParam(defaultValue = "0")int address_idx, HttpSession session) {
		System.out.println("address_idx: " + address_idx);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 일단 기본배송지 등록된거 있는지 확인 먼저 필요
		String id = (String) session.getAttribute("sId");
		int isDefaultCount = service.getAddressIsDefault(id);
		
		if(isDefaultCount > 0) { // 기본배송지 있음
			// 원래 기본 배송지를 N으로 바꾸고
			int updateCount = service.modifyDefaultAddressToN(id);
			
			if(updateCount > 0) {
				int updateCount2 = service.modifyDefaultAddressToY(address_idx);
				
				if(updateCount2 > 0) {
					resultMap.put("result", true);// 변경 성공
				} else {
					resultMap.put("result", false);// 변경 실패
				}
			}
			
		} else { // 기본 배송지 없음
			
			// 변경 요청 처리 결과 판별
			// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
			int updateCount = service.modifyDefaultAddressToY(address_idx);
			
			if(updateCount > 0) {
				resultMap.put("result", true);// 변경 성공
			} else {
				resultMap.put("result", false);// 변경 실패
			}
		}
		
		JSONObject jo = new JSONObject(resultMap);
		return jo.toString();
	}
	
	// 기본 배송지 변경 - 해제
	@ResponseBody
	@PostMapping("CancleDefaultAddress")
	public String cancleDefaultAddress(@RequestParam(defaultValue = "")String address_mem_email, HttpSession session) {
		
		// 변경 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int updateCount = service.modifyDefaultAddressToN(address_mem_email);
		
		if(updateCount > 0) {
			resultMap.put("result", true);// 변경 성공
		} else {
			resultMap.put("result", false);// 변경 실패
		}
		
		
		JSONObject jo = new JSONObject(resultMap);
		return jo.toString();
	}
	
	// ------------------------------------------------------------------------------------
	// 신고하기 1
	@ResponseBody
	@GetMapping("ReportForm")
	public String reportForm(@RequestParam(defaultValue = "") String type, @RequestParam(defaultValue = "")String project_title, @RequestParam(defaultValue = "")String project_code) {
//			System.out.println("type : " + type);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", true);
		resultMap.put("type", type);
		resultMap.put("project_title", project_title);
		resultMap.put("project_code", project_code);
		
		JSONObject jo = new JSONObject(resultMap);
//			System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
	// 신고하기 작성 폼
	@GetMapping("ReportWriteForm")
	public String reportWriteForm(@RequestParam(defaultValue = "") String type, @RequestParam(defaultValue = "")String project_title,@RequestParam(defaultValue = "")String project_code ,Model model, HttpSession session, MemberVO member) {
		System.out.println("type2222 : " + type);
		System.out.println(project_title + ", " + project_code);
		String id = (String) session.getAttribute("sId");
		
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
//				session.setAttribute("prevURL", "");
			return "result/fail";
		}
		
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
		
		model.addAttribute("type", type);
		model.addAttribute("project_title", project_title);
		model.addAttribute("member", member);
		model.addAttribute("project_code", project_code);
		
		return "project/report_form";
	}
	
	// 신고 접수
	@PostMapping("ReportSubmit")
	public String reportSubmit(ReportVO report, Model model, HttpSession session) {
		
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달

		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		
		LocalDate today = LocalDate.now();
		String datePattern = "yyyyMMdd"; // 형식 변경에 사용할 패턴 문자열 지정
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		
		String id = (String) session.getAttribute("sId");
		
		subDir = "REPORT" + "/" + today.format(dtf) + "/" + id;
		
		// 기존 실제 업로드 경로에 서브 디렉토리 결합 REPORT/20240907/id/파일명
		realPath += "/" + subDir;
		
		try {
			// 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path);	// 실제 경로 생성
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// [ 업로드 되는 실제 파일 처리 ]
		// 실제 파일은 BoardVO 객체의 MultipartFile 타입 객체(멤버변수 fileX)가 관리함
		MultipartFile mFile = report.getFile();
//		System.out.println("원본파일명1 : " + mFile.getOriginalFilename());
		
		// 업로드 할 파일이 존재할 경우(원본 파일명이 널스트링이 아닐 경우)에만 
		// BoardVO 객체에 서브디렉토리명과 함께 파일명 저장
		// => 단, 업로드 파일이 선택되지 않은 파일은 파일명에 null 값이 저장되므로
		//    파일명 저장 전 BoardVO 객체의 파일명에 해당하는 멤버변수값을 널스트링("") 으로 변경
		report.setReport_file("");
		
		if(!mFile.getOriginalFilename().equals("")) {
			report.setReport_file(subDir + "/" + mFile.getOriginalFilename());
		}
		
		int insertCount = service.registReport(report);
		
		if(insertCount > 0) {
			model.addAttribute("msg", "신고가 접수되었습니다.");
			
			try {
				if(!mFile.getOriginalFilename().equals("")) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					mFile.transferTo(new File(realPath, mFile.getOriginalFilename()));
				}
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			return "result/success";
		} else {
			model.addAttribute("msg", "신고 접수 중 오류가 발생하였습니다. \n 다시 시도해주세요.");
			
			return "result/fail";
		}
	}
	
	// ------------------------------------------------------------------------------------
	
	// 팔로우
	// ProjectDetail 할 때 해당 창작자를 팔로우 하는 사람들 리스트 가져간 상태
	@ResponseBody
	@PostMapping("CommitFollow")
	public String commitFollow(@RequestParam(defaultValue = "") String follow_creator, HttpSession session, Model model) {
//			System.out.println("follow_creator : " + follow_creator);
		String id = (String) session.getAttribute("sId");
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(id == null) {
			resultMap.put("result", false);
			
		} else {
			
			int followCount = service.getFollowCount(id, follow_creator); // 내가 이 창작자를 팔로우한 적이 있는지 (언팔도 status 남으니까 그냥 있으면 무조건 넘어옴)
			
			int insertCount = 0;
			int updateCount = 0;
			
			if(followCount > 0) { // 팔로우 한 적 있음
				updateCount = service.modifyFollow(id, follow_creator);
			} else { // 팔로우 한 적 없음
				insertCount = service.registFollow(id, follow_creator);
			}
			
			if(insertCount > 0 || updateCount > 0) {
				resultMap.put("result", true);
			} else {
				resultMap.put("result", false);
			}
		}
		JSONObject jo = new JSONObject(resultMap);
//			System.out.println("응답 데이터 : " + jo.toString());
			
		return jo.toString();
	}
	
	// 언팔로우
	@ResponseBody
	@PostMapping("UnFollow")
	public String unFollow(@RequestParam(defaultValue = "") String follow_mem_email, @RequestParam(defaultValue = "") String follow_creator) {
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int updateCount = service.unFollow(follow_mem_email, follow_creator);
		
		if(updateCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		JSONObject jo = new JSONObject(resultMap);
//			System.out.println("응답 데이터 : " + jo.toString());
		
		return jo.toString();
	}
	
	
	// 좋아요 등록
	@ResponseBody
	@PostMapping("RegistLike")
	public String registLike(@RequestParam(defaultValue = "") String like_project_code, @RequestParam(defaultValue = "") String like_mem_email, HttpSession session) {
		System.out.println("좋아요 : " + like_project_code + ", " + like_mem_email);
		String id = (String) session.getAttribute("sId");
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		if(id == null) {
			resultMap.put("result", false);
			
		} else {
			// 내가 이 프로젝트를 좋아요 한 적 있는지 먼저 확인
			int likeCount = service.getLikeCount(like_project_code, like_mem_email);
			int updateCount = 0;
			int insertCount = 0;
			
			if(likeCount > 0) { // 좋아요 한 흔적이 있음
				updateCount = service.modifyLike(like_project_code, like_mem_email); // 좋아요 한 흔적은 있는데 N이니까 Y로 변경
			} else { // 좋아요 한 흔적 없음
				insertCount = service.registLike(like_project_code, like_mem_email);
			}
			
			if(insertCount > 0 || updateCount > 0) {
				resultMap.put("result", true);
			} else {
				resultMap.put("result", false);
			}
		}
		
		JSONObject jo = new JSONObject(resultMap);
//			System.out.println("응답 데이터 : " + jo.toString());
		
		return jo.toString();
	}
	
	@ResponseBody
	@PostMapping("CancelLike")
	public String cancelLike(@RequestParam(defaultValue = "") String like_project_code, @RequestParam(defaultValue = "") String like_mem_email) {
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int updateCount = service.cancelLike(like_project_code, like_mem_email);
		
		if(updateCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		JSONObject jo = new JSONObject(resultMap);
//			System.out.println("응답 데이터 : " + jo.toString());
		
		return jo.toString();
	}
		
	
	// ========================================================================================
	// 로그 출력을 위한 기본 라이브러리(org.slf4j.Logger 타입) 변수 선언
	private static final Logger logger = LoggerFactory.getLogger(BankController.class);
	
	// --------------------------------------------------------------------------------
	// 계좌 목록 조회
	//https://testapi.openbanking.or.kr/v2.0/account/list
	@ResponseBody
	@GetMapping("UserBankAccountList")
	public Map<String, Object> userbankAccountList(HttpSession session, Model model) {
		
		// 엑세스토큰 관련 정보가 저장된 BankToken(token) 객체를 세션에서 꺼내기
		BankToken token = (BankToken) session.getAttribute("token"); // -> 다운캐스팅임
		
		// -----------------------------------------------------------------------------
		// BankService - getBankUserInfoFromApi() 메서드 호출하여 핀테크 사용자 정보 조회
		// => 파라미터 : 토큰 관련 정보(BankToken 객체)   리턴타입 : Map<String, Object>(bankUserInfo)
		// => 주의! 응답데이터 중 res_list 값이 리스트 형태이므로 String, String 대신 String, Object 타입 지정
		Map<String, Object> bankUserInfo = service.getBankUserInfoFromApi(token);
		logger.info(">>>>>> bankUserInfo : " + bankUserInfo);
		
		// fintech_user_info 테이블에 fintech_use_num, user_ci 저장 -> bankToken 에 저장하기 ..?
		List<Map<String, Object>> res_list = (List<Map<String, Object>>) bankUserInfo.get("res_list");

		String fin_use_num = (String) res_list.get(0).get("fintech_use_num");
		String user_ci = (String) bankUserInfo.get("user_ci");
		String id = (String) session.getAttribute("sId");
		
		service.registFintechInfo(fin_use_num, user_ci, id); // regist 인데 update 할거임
		
		return bankUserInfo;
	}
	
	// -----------------------------------------------------------------------------------------------------
	
	
	
}


















