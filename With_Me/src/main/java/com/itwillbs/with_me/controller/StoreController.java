package com.itwillbs.with_me.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.service.StoreService;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.StoreVO;

@Controller
public class StoreController {
	@Autowired
	private StoreService service;
	
	
	
	// 스토어 메인 페이지 이동
	@GetMapping("StoreList")
	public String store(StoreVO store, Model model,
			@RequestParam(defaultValue = "1") int pageNum,
			@RequestParam(defaultValue = "") String searchKeyword) {
		System.out.println("searchKeyword : " + searchKeyword);
		String productCategory = store.getProduct_category();
		String productCategory_detail = store.getProduct_category_detail();
		
		System.out.println("productCategory : " + productCategory);
		System.out.println("productCategory_detail : " + productCategory_detail);
		
		// 한 페이지에서 표시할 글 목록 개수 지정
		int listLimit = 8;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		//----------------------------------------
		
		int listCount = service.getBoardListCount(searchKeyword, productCategory, productCategory_detail);
		System.out.println("listCount : " + listCount);
		
		int pageListLimit = 3;
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		
		int endPage = startPage + pageListLimit - 1;
		
		// 검색 결과가 없을 때 해당 페이지는 존재하지 않습니다. 가 뜨는 경우를 위해 
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0이면 1이다.
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
			model.addAttribute("targetURL", "StoreList");
			
			return "result/fail";
		}
		
		// --------------------------------------------------------------------------------------
		
		// 목록 표출
		List<Map<String, Object>> StoreList = service.getStoreList(searchKeyword, productCategory, productCategory_detail, startRow, listLimit);
		System.out.println("StoreList : " + StoreList);
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("projectList", StoreList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "store/store_main";
	}
	
	// 스토어 상품 상세 페이지 이동 
	@GetMapping("StoreDetail")
	public String storeDetail() {
		return "store/store_detail";
	}
}
