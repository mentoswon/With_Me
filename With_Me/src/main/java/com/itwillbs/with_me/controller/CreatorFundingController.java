package com.itwillbs.with_me.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.itwillbs.with_me.service.CreatorFundingService;
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
		
		// 작성중인 프로젝트 목록 조회
		ProjectVO project = service.getProjectList(id);
		System.out.println("project : " + project);
		model.addAttribute("project", project);
		
		return "project/project_category";
	}
	
	// 프로젝트 동의 약관 페이지
	@PostMapping("ProjectAgree")
	public String projectAgree(ProjectVO project, HttpSession session, Model model) {
		// 미로그인 시 로그인 페이지로 이동
		
//		System.out.println("project : " + project);
		model.addAttribute("project_category", project.getProject_category());
		model.addAttribute("project_title", project.getProject_title());
		return "project/project_agree";
	}
	
	
	// 프로젝트 시작하기 페이지
	@PostMapping("ProjectCreate")
	public String projectCreate(ProjectVO project, HttpSession session, Model model) {
		// 미로그인 시 로그인 페이지로 이동
		
		model.addAttribute("project_category", project.getProject_category());
		model.addAttribute("project_title", project.getProject_title());
		
		return "project/project_create";
	}

	
}
