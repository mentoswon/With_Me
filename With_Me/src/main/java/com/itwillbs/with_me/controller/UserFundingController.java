package com.itwillbs.with_me.controller;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.service.UserFundingService;
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
        
//        System.out.println("rewardList : " + rewardList);
        
        // --------------------------------------------------------------
        
        // 리워드별 아이템 가져오기
        List<Map<String, Object>> rewardItemList = new ArrayList<Map<String,Object>>();
        
        for(int i = 0 ; i < rewardList.size() ; i++) {
        	int reward_idx = rewardList.get(i).getReward_idx();
        	
        	rewardItemList = service.getRewardItemList(reward_idx);
        }
        
        // 확인
//        System.out.println("rewardItemList : " + rewardItemList);
        
        // 객관식일 경우 아이템별 옵션도 가져와야함 
        List<Map<String, Object>> itemOptions = new ArrayList<Map<String,Object>>();
        
        for(int i = 0; i < rewardItemList.size() ; i++) {
        	String item_idx = (String) rewardItemList.get(i).get("splited_item_idx");
        	
        	if(rewardItemList.get(i).get("item_condition").equals("객관식")) {
        		itemOptions = service.getItemOpionList(item_idx);
        	}
        }
        // 확인
        System.out.println("itemOptions : " + itemOptions);
        
        // 후원 정보 가져오기 end --------
        
        // =========================================================
		model.addAttribute("project_detail", project_detail);
		model.addAttribute("rewardList", rewardList);
		model.addAttribute("rewardItemList", rewardItemList);
		model.addAttribute("itemOptions", itemOptions);
		
		return "project/project_detail";
	}
	
	
	// 후원 진행
	@GetMapping("FundInProgress")
	public String fundInProgress(int reward_amt, String reward_title, HttpSession session, MemberVO member,
								Model model) {
//		System.out.println("reward_amt, reward_title : " + reward_amt + ", " + reward_title);		
		String id = (String) session.getAttribute("sId");
//		System.out.println(id);
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
//		System.out.println("member : " + member);
		
		// =========================================================================
		model.addAttribute("member", member);
		
		return "project/fund_in_progress";
	}
	
	
	
	
	
	
	
}


















