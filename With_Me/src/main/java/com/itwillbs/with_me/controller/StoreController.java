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

import com.google.gson.JsonObject;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.service.StoreService;
import com.itwillbs.with_me.vo.AddressVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.StoreVO;

@Controller
public class StoreController {
	@Autowired
	private StoreService service;
	
	@Autowired
	private MemberService memberService;
	
	
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
		
		// 목록 표출222
		List<Map<String, Object>> StoreListAll = service.getStoreListAll(searchKeyword, productCategory, productCategory_detail, startRow, listLimit);
		System.out.println("StoreListAll : " + StoreListAll);
		// 2222--------------------------------------------------------------------
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("StoreList", StoreList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "store/store_main";
	}
	
	// 스토어 상품 상세 페이지 이동 
	@GetMapping("StoreDetail")
	public String storeDetail(StoreVO store, Model model) {
		System.out.println("StoreDetail : " + store);
		String product_code = store.getProduct_code();
		
		// 상품 가져오기 
		Map<String,Object> product_detail = service.getProduct(product_code);
		System.out.println("가져온 상품123 : " + product_detail);
		model.addAttribute("product_detail", product_detail);
		return "store/store_detail";
	}
	
	@PostMapping("StoreInProgress")
	public String storeInProgress(@RequestParam Map<String,Object> map, HttpSession session, MemberVO member, Model model) {
		System.out.println("map : " + map);
		
		String id = (String)session.getAttribute("sId");
//		System.out.println("id : " + id);
		if(id == null) {
			model.addAttribute("msg", "로그인 후 사용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			session.setAttribute("prevURL", "StoreInProgress");
			return "result/fail";
			
		}
		
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기 
		member = memberService.getMember(member);
		System.out.println("memeber : " + member);
		
		// 아이디로 주소 정보 가져오기 
		List<AddressVO> userAddress = service.getUserAddress(member);
		System.out.println("userAddress : " + userAddress);
		
		// =========================================================================
		
		model.addAttribute("member", member);
		model.addAttribute("userAddress", userAddress);
		
		
		
		return "store/store_in_progress";
	}
	
	// 배송지 등록 
	@PostMapping("StoreRegistAddress")
	public String storeRegistAddress(AddressVO new_address, HttpSession session) {
		System.out.println("new_address : " + new_address);
		
		String id = (String) session.getAttribute("sId");
		
		// insert를 할건데 
		// 1. 기본 배송지 설정이 이미 돼있으면 (on / null)
		// address_is_default = Y 인걸 찾아서 N으로 바꾸고 새로 등록하는걸 Y로 바꿔야함.
		// 2. 기본 배송지 설정된거 없으면 그냥 등록
		// 3. 기본 배송지 설정된거 있는데 안바꿔도 그냥 등록		
		
		// 일단 기본 배송지 등록 된거 있는지 확인 필요
		int isDefaultCount = service.getAddressIsDefault(id);
		
		if(isDefaultCount == 1) {
			if(new_address.getAddress_is_default() == null) { // 기본 배송지 있는데 안 바꾸면 그냥 등록!
				service.registNewAddress(new_address);
			} else if(new_address.getAddress_is_default().equals("on")) { // 새 주소 등록하면서 기본 배송지 설정!
				
				// 기본 배송지가 있으면 N으로 변경  -> update
				int updateCount = service.modifyDefaultAddress(id);
				
				// 바꾸고 새로운 기본배송지 insert
				if(updateCount > 0) {
					service.registNewDefaultAddress(new_address);
				}
			}
		} else {
			// 기본 배송지도 없고, 기본 배송지 설정 안하고 그냥 등록만!
			service.registNewAddress(new_address);
			
		}
		
		return "redirect:/StoreInProgress";
	}
	
	// 배송지 삭제
	@ResponseBody
	@GetMapping("StoreDeleteAddress")
	public String storeDeleteAddress(AddressVO address, HttpSession session, MemberVO member) {
		System.out.println("address : " + address);
		
		Map <String, Object> resultMap = new HashMap<String, Object>();
		
		int deleteCount = service.removeAddress(address);
		
		// 주소 삭제 요청 
		// 삭제 요청 처리 결과 판별
		// 성공 시 resultMap  객체의 "result" 속성값을 true, 실패 시 false로 저장 
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
		@PostMapping("StoreChangeDefaultAddress")
		public String storechangeDefaultAddress(AddressVO address) {
			System.out.println("address : " + address);
			
			return "";
		}
	
	
	
}
