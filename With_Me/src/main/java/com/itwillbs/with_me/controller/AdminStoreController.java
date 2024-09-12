package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.service.AdminStoreService;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.StoreVO;
import com.itwillbs.with_me.vo.Store_userVO;

@Controller
public class AdminStoreController {
	
	@Autowired
	private AdminStoreService service;
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload";
	
	// 스토어 뷰폼
	@GetMapping("AdminStore")
	public String adminStore(
	@RequestParam(defaultValue = "") String searchType,
	@RequestParam(defaultValue = "") String searchKeyword,
	@RequestParam(defaultValue = "1") int pageNum,
	Model model) {
		
		// 페이징 처리를 위해 조회 목록 갯수 조절에 사용될 변수 선언
		int listLimit = 10; // 페이지 당 게시물 수
		int startRow = (pageNum - 1) * listLimit; // 조회할 게시물의 행 번호
		
		// 페이징 처리를 위한 계산 작업
		int listCount = service.getProductListCount(searchType, searchKeyword);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 갯수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 검색했을 때 페이지번호가 1보다 작거나 최대 페이지번호보다 크다면 1페이지로 이동하도록 설정
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminStore?pageNum=1");
			return "result/fail";
		}
		
		// StoreService - getProductList() 메서드 호출하여 게시물 목록 조회 요청
		List<StoreVO> productList = service.getProductList(searchType, searchKeyword, startRow, listLimit);
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		
		// 게시물 목록과 페이징 정보를 Model 객체에 저장
		model.addAttribute("productList", productList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_store_list";
	}
	
	// 상품 등록
	@GetMapping("ProductRegist")
	public String productRegist(HttpSession session, Model model) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		return "admin/admin_product_regist";
	}
	
	// 상품 등록 로직
	@PostMapping("ProductRegistPro")
	public String productRegistPro(StoreVO store, HttpServletRequest request, HttpSession session, Model model) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 파일 업로드 처리
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		
		// 경로 관리
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		
		// 1. 현재 시스템의 날짜 정보를 갖는 객체 생성
		LocalDate today = LocalDate.now();
		
		// 2. 날짜 포맷을 디렉토리 형식에 맞게 변경
		String datePattern = "yyyy/MM/dd";
		// DateTimeFormatter.ofPattern() 메서드를 호출하여 파라미터로 패턴 문자열 전달
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		
		// 3. 지정한 포맷을 적용하여 날짜 형식 변경 결과 문자열을 경로 변수 subDir 에 저장
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		
		// 4. 기존 실제 업로드 경로에 서브 디렉토리(날짜 경로) 결합
		realPath += "/" + subDir;
		
		try {
			// 5. 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			//    실제 업로드 경로를 관리하는 java.nio.file.Path 객체 리턴받기
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			
			// 5-2) Files 클래스의 createDirectories() 메서드 호출하여 실제 경로 생성
			//      => 이 때, 경로 상에서 생성되지 않은 모든 디렉토리 생성
			//         만약, 최종 서브디렉토리 1개만 생성 시 createDirectory() 메서드도 사용 가능
			Files.createDirectories(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// ----------------------------------
		// 업로드 되는 실제 파일 처리
		// 실제 파일은 StoreVO 객체의 MultipartFile 타입 객체(멤버변수 fileX)가 관리함
		MultipartFile pImg1 = store.getProduct_img_file1();
		MultipartFile pImg2 = store.getProduct_img_file2();
		
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		// => 주의! 업로드 파일이 존재하지 않으면 파일명에 null 값이 아닌 널스트링값 저장됨
		System.out.println("원본파일명1 : " + pImg1.getOriginalFilename());
		System.out.println("원본파일명2 : " + pImg2.getOriginalFilename());
		
		// 파일명 중복 방지 대책
		// 자신의 업로드하는 파일명끼리도 중복을 방지하려면 UUID 를 매번 생성하여 결합
		String pImgName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + pImg1.getOriginalFilename();
		String pImgName2 = UUID.randomUUID().toString().substring(0, 8) + "_" + pImg2.getOriginalFilename();
		
		// 업로드 할 파일이 존재할 경우(원본 파일명이 널스트링이 아닐 경우)에만 
		// StoreVO 객체에 서브디렉토리명과 함께 파일명 저장
		// => 단, 업로드 파일이 선택되지 않은 파일은 파일명에 null 값이 저장되므로
		//    파일명 저장 전 StoreVO 객체의 파일명에 해당하는 멤버변수값을 널스트링("") 으로 변경
		store.setProduct_img("");
		store.setProduct_img2("");
		
		if(!pImg1.getOriginalFilename().equals("")) {
			store.setProduct_img(subDir + "/" + pImgName1);
		}
		
		if(!pImg2.getOriginalFilename().equals("")) {
			store.setProduct_img2(subDir + "/" + pImgName2);
		}
		
		System.out.println("DB 에 저장될 파일명 : " + store.getProduct_img());
		System.out.println("DB 에 저장될 파일명2 : " + store.getProduct_img2());
		
		
		// 아이템 옵션(여러개 일 시 | 이렇게 처리)
		String[] options = request.getParameterValues("product_item_option");

		// 값이 있는 옵션만 필터링하여 |로 결합
		if (options != null) {
		    // 빈 값(널스트링)을 제외한 값만 모아서 결합
		    String optionString = Arrays.stream(options)
		                                .filter(option -> option != null && !option.trim().isEmpty())  // 빈 문자열이나 null 값 제거
		                                .collect(Collectors.joining("|"));
		    store.setProduct_item_option(optionString);  // 필터링된 옵션을 저장
		}
		
		// 상품등록 작업 요청
		int insertCount = service.registProduct(store);
		
		// 상품 등록 작업 요청 결과 판별
		if(insertCount > 0) { // 성공
			try {
				// 업로드 파일들은 MultipartFile 객체에 의해 임시 저장공간에 저장되어 있으며
				// 글쓰기 작업 성공 시 임시 저장공간 -> 실제 디렉토리로 이동 작업 필요
				// => MultipartFile 객체의 transferTo() 메서드 호출하여 실제 위치로 이동 처리
				//    (파라미터 : java.io.File 타입 객체 전달)
				// => 단, 업로드 파일이 선택되지 않은 항목은 이동 대상에서 제외
				if(!pImg1.getOriginalFilename().equals("")) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					pImg1.transferTo(new File(realPath, pImgName1));
				}
				
				if(!pImg2.getOriginalFilename().equals("")) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					pImg2.transferTo(new File(realPath, pImgName2));
				}
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			model.addAttribute("msg", "상품이 등록되었습니다!");
			model.addAttribute("targetURL", "AdminStore");
			
			// 상품관리(AdminStore) 서블릿 주소 리다이렉트
			return "result/success";
		} else { // 실패
			// "상품등록 실패!" 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "상품등록 실패!");
			return "result/fail";
		}
	}
	
	// 상품 상세 보기
	@GetMapping("ProductDetail")
	public String productDetail(int product_idx, Model model, StoreVO store, HttpSession session) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 상품 상세정보 조회 요청
		StoreVO product = service.getProduct(product_idx);
		// 상품 옵션값 꺼내기(ex : 빨간색 장난감|파란색 장난감 => 빨간색 장난감)
		List<Map<String, Object>> productOptions = service.getProdcutOption(product_idx);
		
		System.out.println("product : " + product);
		System.out.println("productOptions : " + productOptions);
		
		// 조회 결과가 없을 경우 "존재하지 않는 게시물입니다" 출력 및 이전페이지 돌아가기 처리
		if(product == null) {
			model.addAttribute("msg", "존재하지 않는 상품입니다");
			return "result/fail";
		}
		
		model.addAttribute("product", product);
		model.addAttribute("productOptions", productOptions);
		
//		List<StoreVO> productList = service.getProductDetailList(store);
		
		
		// 뷰페이지에서 파일 목록의 효율적 처리를 위해 파일명만 별도로 List 객체에 저장
		List<String> fileList = new ArrayList<String>();
		fileList.add(product.getProduct_img());
		fileList.add(product.getProduct_img2());
		
		System.out.println("fileList : " + fileList);
		
		
		// List 객체를 반복하면서 파일명에서 원본 파일명을 추출
		List<String> originalFileList = new ArrayList<String>();
		for(String file : fileList) {
			if(!file.equals("")) {
				// "_" 기호 다음(해당 인덱스값 + 1)부터 끝까지 추출하여 리스트에 추가
				originalFileList.add(file.substring(file.indexOf("_") + 1));
			}
		}
		
		model.addAttribute("fileList", fileList);
		model.addAttribute("originalFileList", originalFileList);
		
		return "admin/admin_store_detail";
	}
	
	// 상품삭제
	@GetMapping("ProductDelete")
	public String productDelete(
			int product_idx, @RequestParam(defaultValue = "1") int pageNum,
			HttpSession session, Model model) throws Exception {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 지울 상품 조회
		StoreVO store = service.getProduct(product_idx);
		System.out.println("store : " + store);
		
		// 상품 삭제 작업
		int deleteCount = service.removeProduct(product_idx);
		
		if(deleteCount > 0) {
			// --------------------------------------------------------------------
			// DB에서 게시물 정보 삭제 완료 시 실제 업로드 된 파일 삭제 처리 추가
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			
			// 파일 삭제에 사용될 파일명(최대 3개)를 List 또는 배열에 저장하여 처리 코드 중복 제거
			String[] arrFileNames = {
				store.getProduct_img(),
				store.getProduct_img2()
			};
//			System.out.println("삭제할 파일 목록 : " + Arrays.toString(arrFileNames));
			
			// 향상된 for문 활용하여 배열 반복
			for(String fileName : arrFileNames) {
				// 파일명이 널스트링("")이 아닐 경우 판별하여 파일 삭제
				if(!fileName.equals("")) {
					// 업로드 경로와 파일명(서브디렉토리 경로 포함) 결합하여 Path 객체 생성
					Path path = Paths.get(realPath, fileName);
					System.out.println("실제 삭제 대상 : " + path.toString());
					
					// Files 클래스의 deleteIfExists() 메서드 호출하여 파일 존재할 경우 삭제 처리
					Files.deleteIfExists(path);
				}
			}
			// --------------------------------------------------------------------
			
			model.addAttribute("msg", "삭제 성공!");
			model.addAttribute("targetURL", "AdminStore?pageNum=" + pageNum);
			return "result/success";
		} else {
			model.addAttribute("msg", "삭제 실패!");
			return "result/fail";
		}
	}
	
	// 상품수정
	@GetMapping("ProductModify")
	public String productModifyForm(int product_idx, HttpSession session, Model model) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 상품 1개 조회
		StoreVO store = service.getProduct(product_idx);
		System.out.println("store : " + store);
		model.addAttribute("store", store);
		
		// 뷰페이지에서 파일 목록의 효율적 처리를 위해 파일명만 별도로 List 객체에 저장
		List<String> fileList = new ArrayList<String>();
		fileList.add(store.getProduct_img());
		fileList.add(store.getProduct_img2());
		
		// List 객체를 반복하면서 파일명에서 원본 파일명을 추출
		List<String> originalFileList = new ArrayList<String>();
		for(String file : fileList) {
			if(!file.equals("")) {
				// "_" 기호 다음(해당 인덱스값 + 1)부터 끝까지 추출하여 리스트에 추가
				originalFileList.add(file.substring(file.indexOf("_") + 1));
			} else {
				 // 파일이 존재하지 않을 경우 널스트링 값 추가
				originalFileList.add("");
			}
		}
		// Model 객체에 파일 목록 저장
		model.addAttribute("fileList", fileList);
		model.addAttribute("originalFileList", originalFileList);
		
		return "admin/admin_store_modify";
	}
	
	// 상품 수정 - 파일 삭제
	@GetMapping("ProductDeleteFile")
	public String productDeleteFile(@RequestParam Map<String, String> map, HttpSession session) throws Exception {
		
		System.out.println("map : " + map);
		
		int deleteCount = service.removeProductImg(map);
		
		// DB 에서 해당 파일명 삭제 완료 시 실제 파일도 삭제 처리
		if(deleteCount > 0) {
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			
			// 전송된 파일명이 널스트링("") 아닐 경우 파일 삭제 처리
			if(!map.get("product_img").equals("")) {
				// 업로드 경로와 파일명(서브디렉토리 경로 포함) 결합해서 Path 객체 생성
				Path path = Paths.get(realPath, map.get("product_img"));
				// 파일 삭제
				Files.deleteIfExists(path);
			}
		}
		return "redirect:/ProductModify?product_idx=" + map.get("product_idx") + "&pageNum=" + map.get("pageNum");
	}
	
	// 상품 수정
	@PostMapping("ProductModify")
	public String productModifyPro(
			StoreVO store, @RequestParam(defaultValue = "1") String pageNum,
			HttpSession session, Model model, HttpServletRequest request) throws Exception {
		
		
		System.out.println("store 수정 : " + store);
		
		// 실제 업로드 경로 알아내기
		String realPath = session.getServletContext().getRealPath(uploadPath);
		
		// 날짜별 서브디렉토리 생성하여 기본 경로에 결합
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		LocalDate today = LocalDate.now();
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		realPath += "/" + subDir;
		Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
		
		// 디렉토리 생성 처리
		Files.createDirectories(path);
		
		// 파일명 중복 방지
		MultipartFile pImg1 = store.getProduct_img_file1();
		MultipartFile pImg2 = store.getProduct_img_file2();
		
		System.out.println("원본파일명1 : " + pImg1.getOriginalFilename());
		System.out.println("원본파일명2 : " + pImg2.getOriginalFilename());
		
		String imgName = UUID.randomUUID().toString().substring(0, 8) + "_" + pImg1.getOriginalFilename();
		String imgName2 = UUID.randomUUID().toString().substring(0, 8) + "_" + pImg2.getOriginalFilename();
		
//		System.out.println("imgName : " + imgName);
		
		store.setProduct_img("");
		store.setProduct_img2("");
		
		if(!pImg1.getOriginalFilename().equals("")) {
			store.setProduct_img(subDir + "/" + imgName);
		}
		
		if(!pImg2.getOriginalFilename().equals("")) {
			store.setProduct_img2(subDir + "/" + imgName2);
		}
		
		System.out.println("DB 에 저장될 파일명 : " + store.getProduct_img());
		System.out.println("DB 에 저장될 파일명2 : " + store.getProduct_img2());
		
		// 아이템 옵션(여러개 일 시 | 이렇게 처리)
		String[] options = request.getParameterValues("product_item_option");

		// 값이 있는 옵션만 필터링하여 |로 결합
		if (options != null) {
		    // 빈 값(널스트링)을 제외한 값만 모아서 결합
		    String optionString = Arrays.stream(options)
		                                .filter(option -> option != null && !option.trim().isEmpty())  // 빈 문자열이나 null 값 제거
		                                .collect(Collectors.joining("|"));
		    store.setProduct_item_option(optionString);  // 필터링된 옵션을 저장
		}
		
		// 수정 작업 요청
		int updateCount = service.modifyProduct(store);
		
		if(updateCount > 0) {
			if(!pImg1.getOriginalFilename().equals("")) {
				// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
				pImg1.transferTo(new File(realPath, imgName));
			}
			
			if(!pImg2.getOriginalFilename().equals("")) {
				// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
				pImg2.transferTo(new File(realPath, imgName2));
			}
			
			// 글 상세정보 조회 페이지 리다이렉트(파라미터 : 글번호, 페이지번호)
			return "redirect:/ProductDetail?product_idx=" + store.getProduct_idx() + "&pageNum=" + pageNum;
		} else {
			model.addAttribute("msg", "상품 수정 실패!");
			return "result/fail";
		}
	}
	
	// 스토어 상품 주문내역 리스트
	@GetMapping("AdminStoreOrder")
	public String adminStoreOrder(
	@RequestParam(defaultValue = "") String searchType,
	@RequestParam(defaultValue = "") String searchKeyword,
	@RequestParam(defaultValue = "1") int pageNum,
	Model model, HttpServletRequest request) {
		
		// 페이징 처리를 위해 조회 목록 갯수 조절에 사용될 변수 선언
		int listLimit = 10; // 페이지 당 게시물 수
		int startRow = (pageNum - 1) * listLimit; // 조회할 게시물의 행 번호
		
		// 페이징 처리를 위한 계산 작업
		int listCount = service.getProductOrderListCount(searchType, searchKeyword);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 갯수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 검색했을 때 페이지번호가 1보다 작거나 최대 페이지번호보다 크다면 1페이지로 이동하도록 설정
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminStore?pageNum=1");
			return "result/fail";
		}
		
		List<Map<String, Object>> productOrderList = service.getProductOrderList(searchType, searchKeyword, startRow, listLimit);
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		
		// 리스트 객체 안에 있는 order_date 컬럼이 datetime 속성이라서 <fmt:>으로 형변환 할때 오류가 생김!
		// 그래서 order_date를 Map객체를 for문으로 반복해서 String으로 바꿔서 form에서 형태를 바꿔야한다.
		for(Map<String, Object> productOrder : productOrderList) {
			productOrder.put("order_date", productOrder.get("order_date").toString());
			System.out.println(productOrder);
		}
		
		model.addAttribute("productOrderList", productOrderList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_store_order_list";
	}
	
	// 상품 주문내역 상세 보기
	@GetMapping("ProductOrderDetail")
	public String productOrderDetail(int order_idx, Model model, StoreVO store, HttpSession session) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 상품 상세정보 조회 요청
		Map<String, Object> productOrder = service.getProductOrderDetail(order_idx);
		System.out.println("productOrder : " + productOrder);
		
		// 조회 결과가 없을 경우 "존재하지 않는 게시물입니다" 출력 및 이전페이지 돌아가기 처리
		if(productOrder == null) {
			model.addAttribute("msg", "존재하지 않는 주문내역입니다");
			return "result/fail";
		}
		model.addAttribute("productOrder", productOrder);
		
		return "admin/admin_store_order_detail";
	}
	
	// 상품 주문내역 배송상태 변경
	@GetMapping("ProductOrderModify")
	public String productOrderModify(int order_idx, HttpSession session, Model model) {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 상품 1개 조회
		Map<String, Object> productOrder = service.getProductOrderDetail(order_idx);
		System.out.println("productOrder : " + productOrder);
		model.addAttribute("productOrder", productOrder);
		
		
		return "admin/admin_store_order_modify";
	}
	
	// 상품 주문내역 배송상태 변경
	@PostMapping("ProductOrderModify")
	public String productOrderModifyPro(
			Store_userVO store_user, @RequestParam(defaultValue = "1") String pageNum,
			HttpSession session, Model model, HttpServletRequest request) throws Exception {
		
		
		System.out.println("store_user 수정 : " + store_user);
		
		// 수정 작업 요청
		int updateCount = service.modifyProductOrder(store_user);
		
		if(updateCount > 0) {
			// 글 상세정보 조회 페이지 리다이렉트(파라미터 : 글번호, 페이지번호)
			return "redirect:/ProductOrderDetail?order_idx=" + store_user.getOrder_idx() + "&pageNum=" + pageNum;
		} else {
			model.addAttribute("msg", "배송상태 변경 실패!");
			return "result/fail";
		}
	}
	
	
	// 상품 주문내역 삭제
	@GetMapping("ProductOrderDelete")
	public String productOrderDelete(
			int order_idx, @RequestParam(defaultValue = "1") int pageNum,
			HttpSession session, Model model) throws Exception {
		
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		
		// 지울 상품 조회
		Store_userVO storeUser = service.getProductOrder(order_idx);
		System.out.println("storeUser : " + storeUser);
		
		// 상품 삭제 작업
		int deleteCount = service.removeProductOrder(order_idx);
		
		if(deleteCount > 0) {
			model.addAttribute("msg", "삭제 성공!");
			model.addAttribute("targetURL", "AdminStoreOrder?pageNum=" + pageNum);
			return "result/success";
		} else {
			model.addAttribute("msg", "삭제 실패!");
			return "result/fail";
		}
	}

}























