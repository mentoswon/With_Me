package com.itwillbs.with_me.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.itwillbs.with_me.vo.ProjectVO;

@Controller
public class UserFundingConroller {
	
	@GetMapping("ProjectList")
	public String projectList(ProjectVO project, Model model) {
		
//		System.out.println("categoryDetail : " + project.getProject_category_detail());
		
		model.addAttribute("categoryDetail", project.getProject_category_detail());
		
		return "project/project_list";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
