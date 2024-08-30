package com.itwillbs.with_me.controller;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.service.UserFundingService;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.RewardVO;

@Controller
public class UserFundingController {
	@Autowired
	private UserFundingService service;
	
	@Autowired
	private MemberService memberService;
	
	@GetMapping("ProjectList")
	public String projectList(ProjectVO project, Model model, 
			@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchKeyword) {
		System.out.println("searchKeyword : " + searchKeyword);
		
		// 메뉴에서 선택한 카테고리대로 목록이 표출되게 해야함
		String category = project.getProject_category(); 
		String category_detail = project.getProject_category_detail(); 
		
//		System.out.println("category : " + category);
//		System.out.println("category_detail : " + category_detail);
		
		// 한 페이지에서 표시할 글 목록 개수 지정 (jsp 에서 가져옴)
		int listLimit = 8;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		// --------------------------------------------------------------------
		
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getBoardListCount(searchKeyword, category,category_detail);
		
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
		// --------------------------------------------------------------------
		// 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(category, category_detail, searchKeyword, startRow, listLimit);
		
		System.out.println("projectList : " + projectList);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "project/project_list";
	}
	
	
	@GetMapping("ProjectDetail")
	public String projectDetail(ProjectVO project, Model model) {
		System.out.println("ProjectDetail : " + project);
		String project_code = project.getProject_code();
		
		// 프로젝트 가져오기
		Map<String, Object> project_detail = service.getProject(project_code);
		
		System.out.println("가져온 프로젝트 ~ : " + project_detail);
		
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
        
        // 팔로워 계산 -------------------
        // 창작자 email 가져오기
        String creator_email = (String) project_detail.get("creator_email");
        
        int followerCount = service.countFollower(creator_email);
        
//        System.out.println(creator_email + "의 팔로워 수 : " + followerCount);
        
        // Map 객체 (project_detail) 에 집어넣기
        project_detail.put("followerCount", followerCount);
         
        // 팔로워 계산 end ---------------
        
        // ===================================================================
        
        // 프로젝트별 후원 정보 가져오기 ------------
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
	
	
	// 후원 진행
//	@GetMapping("FundInProgress")
//	public String fundInProgress(@RequestParam(defaultValue = "0") int reward_amt, 
//								 @RequestParam(defaultValue = "") String reward_title,
//								 HttpSession session, MemberVO member, Model model) {
////		System.out.println("reward_amt, reward_title : " + reward_amt + ", " + reward_title);		
//		String id = (String) session.getAttribute("sId");
//		
//		if(id == null) {
//			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
//			model.addAttribute("targetURL", "MemberLogin");
//			session.setAttribute("prevURL", "FundInProgress");
//			return "result/fail";
//		}
//		
//		member.setMem_email(id);
//		
//		// 아이디로 회원 정보 가져오기
//		member = memberService.getMember(member);
////		System.out.println("member : " + member);
//		
//		// 아이디로 주소 정보 가져오기
//		List<AddressVO> userAddress = service.getUserAddress(member);
////		System.out.println("userAddress : " + userAddress);
//		
//		// =========================================================================
//		model.addAttribute("member", member);
//		model.addAttribute("userAddress", userAddress);
//		
//		return "project/fund_in_progress";
//	}
	
	
	@PostMapping("FundInProgress")
	public String fundInProgress(@RequestParam Map<String, Object> map, HttpSession session, MemberVO member, Model model) {
		System.out.println("map : " + map);	
		
		String id = (String) session.getAttribute("sId");
		
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
//			session.setAttribute("prevURL", "");
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
		String selected_option = map.get("funding_item_option").toString();
		String selected_option_title = map.get("reward_option_title").toString();
		
//		System.out.println(selected_option);
		
		String[] optionArr = selected_option.split("\\|");
		String[] optionTitleArr = selected_option_title.split("\\|");
//		System.out.println("optionArr : " + Arrays.toString(optionArr));		
//		System.out.println("optionTitleArr : " + Arrays.toString(optionTitleArr));
//		
//		map.put("selectedOption", optionArr);
//		map.put("selectedOption", optionTitleArr);
//		
//		System.out.println("map: " + map);
		Map<String, Object> optionMap = new HashMap<String, Object>();
		for(int i = 0 ; i < optionArr.length ; i++) {
			optionMap.put(optionTitleArr[i], optionArr[i]);
		}
		
		System.out.println("optionMap : " +optionMap);
		
		// =========================================================================
		model.addAttribute("member", member);
		model.addAttribute("userAddress", userAddress);
		model.addAttribute("selectedReward", map);
		model.addAttribute("optionMap", optionMap);
		
		
		return "project/fund_in_progress";
	}
	
	
	// 배송지 등록
	@PostMapping("RegistAddress")
	public String registAddress(AddressVO new_address, HttpSession session) {
		System.out.println("new_address : " + new_address);
		
		String id = (String) session.getAttribute("sId");
		
		// insert를 할건데 
		// 1. 기본 배송지 설정이 이미 돼있으면 (on / null)
		// address_is_default = Y 인걸 찾아서 N으로 바꾸고 새로 등록하는걸 Y로 바꿔야함.
		// 2. 기본 배송지 설정된거 없으면 그냥 등록
		// 3. 기본 배송지 설정된거 있는데 안바꿔도 그냥 등록
		
		// 일단 기본배송지 등록된거 있는지 확인 먼저 필요
		int isDefaultCount = service.getAddressIsDefault(id);
		
		if(isDefaultCount == 1) {
			if(new_address.getAddress_is_default() == null) { // 기본 배송지 있는데 안 바꾸면 그냥 등록 !
				service.registNewAddress(new_address);
			} else if(new_address.getAddress_is_default().equals("on")) { // 새 주소 등록하면서 기본 배송지 설정 !
					
			// 기본배송지가 있으면 그걸 N으로 바꿔야함 -> update
				int updateCount = service.modifyDefaultAddress(id);
				
				// 바꾸고 새로운 기본배송지 insert
				if(updateCount > 0) {
					service.registNewDefaultAddress(new_address);
				}
			}
		} else {
			// 기본 배송지도 없고, 기본 배송지 설정 안 하고 그냥 등록 ! (기본이든 기본 아니든)
			service.registNewAddress(new_address);
			
		}
		
		return "redirect:/FundInProgress";
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
	
	// 기본 배송지 변경
	@PostMapping("ChangeDefaultAddress")
	public String changeDefaultAddress(AddressVO address) {
		System.out.println("address : " + address);
		
		return "";
	}
	
	
	
}


















