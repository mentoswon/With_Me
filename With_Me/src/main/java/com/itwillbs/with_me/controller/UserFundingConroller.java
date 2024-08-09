package com.itwillbs.with_me.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.service.UserFundingService;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectVO;

@Controller
public class UserFundingConroller {
	@Autowired
	private UserFundingService service;
	
	@GetMapping("ProjectList")
	public String projectList(ProjectVO project, Model model, 
			@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchKeyword) {
		System.out.println("searchKeyword : " + searchKeyword);
		
		// 메뉴에서 선택한 카테고리대로 목록이 표출되게 해야함
		String category = project.getProject_category_detail(); 
		
		System.out.println("categoryDetail : " + category);
		
		// 한 페이지에서 표시할 글 목록 개수 지정 (jsp 에서 가져옴)
		int listLimit = 6;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		// --------------------------------------------------------------------
		
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getBoardListCount(searchKeyword, category);
		
//		System.out.println("listCount : " + listCount);
		
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
			model.addAttribute("targetURL", "BoardList");
			
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(category, searchKeyword, startRow, listLimit);
		
		System.out.println("projectList : " + projectList);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageInfo", pageInfo);
		
		
		return "project/project_list";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
