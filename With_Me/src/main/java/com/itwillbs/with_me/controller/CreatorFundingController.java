package com.itwillbs.with_me.controller;

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
import com.itwillbs.with_me.vo.ProjectVO;

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
	public String projectCreateGet(HttpSession session, Model model, @RequestParam("project_idx") Integer project_idx) {
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
	    model.addAttribute("category_detail", category_detail);

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
	
}