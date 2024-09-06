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
import com.itwillbs.with_me.vo.LikeVO;
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
	public String storeDetail(StoreVO store, Model model, HttpSession session) {
		System.out.println("StoreDetail : " + store);
		String product_code = store.getProduct_code();

		// 상품 가져오기 
		Map<String,Object> product_detail = service.getProduct(product_code);
		System.out.println("가져온 상품123 : " + product_detail);

		// =================================================================

		//  좋아요 -----------------
		String id = (String)session.getAttribute("sId");
		LikeVO isLike = service.getIsLike(product_code, id);
		product_detail.put("isLike", isLike);
		System.out.println("product_detail : " + product_detail);

		// =================================================================
		model.addAttribute("product_detail", product_detail);

		return "store/store_detail";
	}

	// --------------------------------------------------------------------------------------------------------------

	// 좋아요 등록
	@ResponseBody
	@PostMapping("RegistLikeProduct")
	public String registLike(@RequestParam(defaultValue = "") String like_product_code, @RequestParam(defaultValue = "") String like_mem_email, HttpSession session) {
		System.out.println("좋아요 : " + like_product_code + ", " + like_mem_email);
		String id = (String) session.getAttribute("sId");

		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();

		if(id == null) {
			resultMap.put("result", false);

		} else {
			// 내가 이 프로젝트를 좋아요 한 적 있는지 먼저 확인
			int likeCount = service.getLikeCount(like_product_code, like_mem_email);
			int updateCount = 0;
			int insertCount = 0;

			if(likeCount > 0) { // 좋아요 한 흔적이 있음
				updateCount = service.modifyLike(like_product_code, like_mem_email); // 좋아요 한 흔적은 있는데 N이니까 Y로 변경
			} else { // 좋아요 한 흔적 없음
				insertCount = service.registLike(like_product_code, like_mem_email);
			}

			if(insertCount > 0 || updateCount > 0) {
				resultMap.put("result", true);
			} else {
				resultMap.put("result", false);
			}
		}

		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 데이터 : " + jo.toString());

		return jo.toString();
	}
	// ========================================================================================================
	// 상품 좋아요 취소
	@ResponseBody
	@PostMapping("CancleLikeProduct")
	public String cancleLike(@RequestParam(defaultValue = "") String like_product_code, @RequestParam(defaultValue = "") String like_mem_email) {

		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();

		int updateCount = service.cancleLike(like_product_code, like_mem_email);

		if(updateCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}

		JSONObject jo = new JSONObject(resultMap);
		//		System.out.println("응답 데이터 : " + jo.toString());

		return jo.toString();
	}


	// ------------------------------------------------------------------------------------------------------------------	


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
	@ResponseBody
	@PostMapping("StoreRegistAddress")
	public List<AddressVO> registAddress(AddressVO new_address, HttpSession session, MemberVO member) throws Exception {
		System.out.println("new_address : " + new_address);
		
		String id = (String) session.getAttribute("sId");

		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
		
		// 배송지를 등록하면 해당 배송지를 선택된 배송지로 만들것임
		// 원래 선택된 배송지 있으면 그건 .. N으로 바꾸기
		
		// 선택된 배송지 있는지 판별
		int isSelectedCount = service.getAddressIsSelected(id);
		List<AddressVO> addressList = null;
		
		if(isSelectedCount == 1) { // 선택된 배송지 있는 경우
					
			// 해당 배송지를 N으로 바꿔야함
			int changeCount = service.modifySelectedAddressToN(id);
			
			if(changeCount > 0) { // 이 아이디에 있던 선택된 배송지를 N으로 바꿈
				
				// 일단 기본배송지 등록된거 있는지 확인 먼저 필요
				int isDefaultCount = service.getAddressIsDefault(id);
				
				if(isDefaultCount > 0) { // 기본배송지 있음
					if(new_address.getAddress_is_default().equals("off")) { // 기본 배송지 있는데 안 바꾸면 그냥 등록 !
						int insertCount = service.registNewAddress(new_address);
						
						if(insertCount > 0) {
							addressList = service.getUserAddress(member);
						} 
						
						System.out.println("기본배송지 있는데 변경 안 하는 경우 : " + insertCount);
						
					} else if(new_address.getAddress_is_default().equals("on")) { // 새 주소 등록하면서 기본 배송지 설정 !
						
						// 기본배송지가 있으면 그걸 N으로 바꿔야함 -> update
						int updateCount = service.modifyDefaultAddressToN(id);
						
						// 바꾸고 새로운 기본배송지 insert
						if(updateCount > 0) {
							int insertCount = service.registNewAddress(new_address);
							
							if(insertCount > 0) {
								addressList = service.getUserAddress(member);
							} 
						} 
						System.out.println("기본배송지 있는데 기본배송지 변경하는 경우 : " + updateCount);
						
					}
				} else if (isDefaultCount == 0) { // 기본 배송지 없음 ! 그냥 등록 ! null, on 에 따라 다르게 들어가게 mapper.xml 에 해놨음
					
					int insertCount = service.registNewAddress(new_address);
					
					if(insertCount > 0) {
						addressList = service.getUserAddress(member);
					} 
					
					System.out.println("기본배송지 없는 경우 : " + insertCount);
				}
				
			} 
		} else { //선택배송지 원래 없는 경우
			int insertCount = service.registNewAddress(new_address);
			
			if(insertCount > 0) {
				addressList = service.getUserAddress(member);
			} 
		} 
		
		return addressList;
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

	// 선택된 배송지 삭제하는 경우 - 추가 0905
	@ResponseBody
	@GetMapping("StoreDeleteAddress2")
	public List<AddressVO> deleteAddress2(AddressVO address, HttpSession session, MemberVO member) {
		System.out.println("address : " + address);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int deleteCount = service.removeAddress(address); // 일단 delete 하고
		
		String id = (String) session.getAttribute("sId");
		
		member.setMem_email(id);
		
		// 아이디로 회원 정보 가져오기
		member = memberService.getMember(member);
		
		List<AddressVO> addressList = null;
		
		if(deleteCount > 0) {
			service.modifySelectedAddressToY2(id); // 그 사람의 배송지 주소 중에 제일 큰걸 selected 로 바꾸기
			
			addressList = service.getUserAddress(member);
		}
		
		return addressList;
	}
	
	// 배송지 변경
	@ResponseBody
	@PostMapping("StoreChangeAddress")
	public String changeAddress(@RequestParam(defaultValue = "0")int address_idx, HttpSession session) {
		System.out.println("address_idx: " + address_idx);

		// 선택된 배송지 있는지 판별
		String id = (String) session.getAttribute("sId");
		int isSelectedCount = service.getAddressIsSelected(id);

		// 주소 변경 요청
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		Map<String, Object> resultMap = new HashMap<String, Object>();

		if(isSelectedCount == 1) { // 선택된 배송지 있는 경우

			// 해당 배송지를 N으로 바꿔야함
			int changeCount = service.modifySelectedAddressToN(id);

			if(changeCount > 0) { // 원래 address_selected 가 Y 인걸 N 으로 바꾸는걸 성공하고 update 해야함
				int updateCount = service.modifySelectedAddressToY(address_idx);

				if(updateCount > 0) {
					resultMap.put("result", true); // 변경 성공
				} else { 
					resultMap.put("result", false);// 변경 실패
				}
			} 
		} else { //선택배송지 원래 없는 경우
			int updateCount = service.modifySelectedAddressToY(address_idx);

			if(updateCount > 0) {
				resultMap.put("result", true);// 변경 성공
			} else {
				resultMap.put("result", false);// 변경 실패
			}
		} 

		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());

		return jo.toString();
	}


	// 기본 배송지 변경 - 설정
	@ResponseBody
	@PostMapping("StoreRegistDefaultAddress")
	public String registDefaultAddress(@RequestParam(defaultValue = "0")int address_idx, HttpSession session) {
		System.out.println("address_idx: " + address_idx);

		Map<String, Object> resultMap = new HashMap<String, Object>();

		// 일단 기본배송지 등록된거 있는지 확인 먼저 필요
		String id = (String) session.getAttribute("sId");
		int isDefaultCount = service.getAddressIsDefault(id);

		if(isDefaultCount > 0) { // 기본배송지 있음
			// 원래 기본 배송지를 N으로 바꾸고
			int updateCount = service.modifyDefaultAddressToN(id);

			if(updateCount > 0) {
				int updateCount2 = service.modifyDefaultAddressToY(address_idx);

				if(updateCount2 > 0) {
					resultMap.put("result", true);// 변경 성공
				} else {
					resultMap.put("result", false);// 변경 실패
				}
			}

		} else { // 기본 배송지 없음

			// 변경 요청 처리 결과 판별
			// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
			int updateCount = service.modifyDefaultAddressToY(address_idx);

			if(updateCount > 0) {
				resultMap.put("result", true);// 변경 성공
			} else {
				resultMap.put("result", false);// 변경 실패
			}
		}

		JSONObject jo = new JSONObject(resultMap);
		return jo.toString();
	}

	// 기본 배송지 변경 - 해제
	@ResponseBody
	@PostMapping("StoreCancleDefaultAddress")
	public String cancleDefaultAddress(@RequestParam(defaultValue = "")String address_mem_email, HttpSession session) {

		// 변경 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		Map<String, Object> resultMap = new HashMap<String, Object>();
		int updateCount = service.modifyDefaultAddressToN(address_mem_email);

		if(updateCount > 0) {
			resultMap.put("result", true);// 변경 성공
		} else {
			resultMap.put("result", false);// 변경 실패
		}


		JSONObject jo = new JSONObject(resultMap);
		return jo.toString();
	}
	
	// ------------------------------------------------------------------------------------
	// 신고하기 1
	@ResponseBody
	@GetMapping("StoreReportForm")
	public String storeReportForm(@RequestParam(defaultValue = "") String type, @RequestParam(defaultValue ="") String product_name, @RequestParam(defaultValue = "")String product_code) {
		System.out.println("type : " + type);
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", true);
		resultMap.put("type", type);
		resultMap.put("product_name", product_name);
		resultMap.put("product_code", product_code);
		
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 : " + jo.toString());
		return jo.toString();
	}
	
	// 신고하기 작성 폼
	@GetMapping("StoreReportWriteForm")
	public String storeReportWriteForm(@RequestParam(defaultValue = "") String type, @RequestParam(defaultValue ="") String product_name, @RequestParam(defaultValue = "")String product_code, Model model, HttpSession session, MemberVO member) {
		System.out.println("type2222 : " + type);
		System.out.println(product_name + ", " + product_code);
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
		
		model.addAttribute("type", type);
		model.addAttribute("product_name", product_name);
		model.addAttribute("member", member);
		model.addAttribute("product_code", product_code);
		
		return "store/store_report_form";
	}
	
	// 신고 접수
	@PostMapping("StoreReportSubmit")
	public String storeReportSubmit(@RequestParam Map<String, Object> map, Model model) {
		System.out.println("map : " + map);
		int insertCount = service.registReport(map);
		
		if(insertCount > 0) {
			model.addAttribute("msg", "신고가 접수되었습니다.");
			
			return "result/success";
		} else {
			model.addAttribute("msg", " 신고 접수 중 오류가 발생하였습니다. \n 다시 시도해주세요.");
			
			return "result/fail";
		}
		
	}

	// =============================================================================================
	
	// 주문 등록
	@GetMapping("StoreUserOrderPro")
	public String storeUserOrderProView() {
		
		return "store/store_success";
	}
	
	@PostMapping("StoreUserOrderPro")
	public String storeUserOrderPro(@RequestParam Map<String, Object> map, Model model) {
		System.out.println("주문할 내용 : " + map);
		
		
		
		return "";
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
