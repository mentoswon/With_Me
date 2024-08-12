package com.itwillbs.with_me.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

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
	public String projectCreate(ProjectVO project, HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 공통코드 테이블에서 상위공통코드 FUND 인 컬럼(카테고리) 조회
		List<CommonCodeVO> category = service.getCategory();
		model.addAttribute("category", category);

		// ----------------------------------------------------------------------------
		// 프로젝트 이어서 작성하기라면 project_idx로 project_info select 하여 이동
		
		// 새로 작성하는 프로젝트라면 제목, 카테고리 저장(insert) 후 이동
		// => NN 값의 경우 임시값 넣어서 insert 할 것
		
		
//		model.addAttribute("project_category", project.getProject_category());
//		model.addAttribute("project_title", project.getProject_title());
		System.out.println("project : " + project);
		model.addAttribute("project", project);
		
		return "project/project_create";
	}

	
}