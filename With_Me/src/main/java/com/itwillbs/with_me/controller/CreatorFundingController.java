package com.itwillbs.with_me.controller;

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

import com.itwillbs.with_me.service.CreatorFundingService;
import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.RewardVO;

@Controller
public class CreatorFundingController {
	@Autowired
	private CreatorFundingService service;
	
	// 프로젝트 만들기 페이지
	@GetMapping("ProjectStart")
	public String projectStart(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동(로그인 후 ProjectStart 페이지로 돌아오기)
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			session.setAttribute("prevURL", "ProjectStart");
			return "result/fail";
		}
		
		
		return "project/project_start";
	}
	
	// 프로젝트 카테고리 선택 및 제목 작성 페이지
	@GetMapping("ProjectCategory")
	public String projectCategory(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 작성중인 프로젝트 목록 조회
		ProjectVO project = service.getProjectList(id);
		System.out.println("project : " + project);
		model.addAttribute("project", project);
		
		// 공통코드 테이블에서 상위공통코드 FUND 인 컬럼(카테고리) 조회
		List<CommonCodeVO> category = service.getCategory();
		model.addAttribute("category", category);
		
		return "project/project_category";
	}
	
	// 프로젝트 동의 약관 페이지
	@PostMapping("ProjectAgree")
	public String projectAgree(ProjectVO project, HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
//		System.out.println("project : " + project);
		model.addAttribute("project_category", project.getProject_category());
		model.addAttribute("project_title", project.getProject_title());
		return "project/project_agree";
	}
	
	// 프로젝트 시작하기 페이지
	@PostMapping("ProjectCreate")
	public String projectCreate(ProjectVO project, HttpSession session, Model model, @RequestParam Map<String, String> map, Integer project_idx) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------------------
		if (project_idx == null) {	// 새로 작성하는 프로젝트 일 경우
			// 프로젝트 등록 전 창작자 정보 먼저 임시 등록
			// (project_info 테이블의 creator_idx 컬럼이 참조되어 있으므로..)
			service.registCreator(id);
			
			// 프로젝트 제목, 카테고리 저장(insert) 후 이동
			// => NN 값의 경우 임시값 넣어서 insert 할 것
			int insertCount = service.registProject(id, project);
			
			if (insertCount == 0) {
				model.addAttribute("msg", "프로젝트 등록 실패!");
				return "result/fail";
			}
			
			// insert 한 프로젝트 번호 조회
			project_idx = service.getProjectIdx(id);
		}
		
		return "redirect:/ProjectCreate?project_idx=" + project_idx;
	}
	
	// 프로젝트 정보 조회 및 페이지 렌더링
	@GetMapping("ProjectCreate")
	public String projectCreateGet(HttpSession session, Model model, @RequestParam("project_idx") String project_idx) {
	    String id = (String) session.getAttribute("sId");

	    // 미로그인 시 로그인 페이지로 이동
	    if (id == null) {
	        model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
	        model.addAttribute("targetURL", "MemberLogin");
	        return "result/fail";
	    }

	    // 프로젝트 정보 조회
	    ProjectVO project = service.getProject(project_idx);

	    // 공통코드 테이블에서 상위공통코드 FUND 인 컬럼(카테고리) 조회
	    List<CommonCodeVO> category = service.getCategory();
	    model.addAttribute("category", category);

	    // 세부 카테고리 조회
	    String project_category = project.getProject_category();
	    List<CommonCodeVO> category_detail = service.getCategoryDetail(project_category);
	    
	    // 아이템 리스트 조회
	    List<ItemVO> itemList = service.getItemList(project_idx);
	    // 후원 구성 리스트 조회
		List<HashMap<String, String>> rewardList = service.getRewardList(project_idx);

	    model.addAttribute("category_detail", category_detail);
	    model.addAttribute("itemList", itemList);
	    model.addAttribute("rewardList", rewardList);
	    model.addAttribute("project", project);

	    return "project/project_create";
	}
	
	
	// 세부 카테고리 불러오기
	@ResponseBody
	@PostMapping("GetCategoryDetail")
	public List<CommonCodeVO> getCategoryDetail(@RequestParam("project_category") String project_category) {
		List<CommonCodeVO> categoryDetailList = service.getCategoryDetail(project_category);
		// 데이터 반환 (Spring이 자동으로 JSON으로 변환)
		return categoryDetailList;
	}
	
	// 아이템 등록 및 리스트 조회 하기
	@ResponseBody
	@PostMapping("RegistItem")
	public List<ItemVO> registItem(@RequestParam Map<String, String> map) {
		System.out.println("map : " + map);
		
		String project_idx = map.get("project_idx");
		System.out.println("project_idx : " + project_idx);
		
		// 아이템 등록
		int insertCount = service.registItem(map);
		List<ItemVO> itemList = null;
		
		if (insertCount > 0) {	// 아이템 등록 성공
			// 아이템 리스트 조회
			itemList = service.getItemList(project_idx);
		}
		return itemList;
	}
	
	// 아이템 삭제
	@ResponseBody
	@PostMapping("DeleteItem")
	public String deleteItem(@RequestParam("item_idx") String item_idx) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 아이템 삭제 요청
		int deleteCount = service.deleteItem(item_idx);
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
	
	// 후원 구성 등록 및 리스트 조회 하기
	@ResponseBody
	@PostMapping("RegistReward")
	public List<HashMap<String, String>> registReward(@RequestParam Map<String, String> map) {
		System.out.println("map : " + map);
		
		String project_idx = map.get("project_idx");
		System.out.println("project_idx : " + project_idx);
		
		// 후원 구성 등록
		int insertCount = service.registReward(map);
		List<HashMap<String, String>> rewardList = null;
		
		if (insertCount > 0) {	// 아이템 등록 성공
			// 후원 구성 리스트 조회
			rewardList = service.getRewardList(project_idx);
		}
		return rewardList;
	}
	
	// 후원 구성 삭제
	@ResponseBody
	@PostMapping("DeleteReward")
	public String deleteReward(@RequestParam("reward_idx") String reward_idx) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 후원 구성 삭제 요청
		int deleteCount = service.deleteReward(reward_idx);
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
}

