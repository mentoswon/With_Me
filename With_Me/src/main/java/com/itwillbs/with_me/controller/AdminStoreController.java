package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.service.AdminStoreService;
import com.itwillbs.with_me.vo.StoreVO;

@Controller
public class AdminStoreController {
	
	@Autowired
	private AdminStoreService service;
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload";
	
	// 스토어 뷰폼
	@GetMapping("AdminStore")
	public String adminStore() {
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
		// 실제 파일은 BoardVO 객체의 MultipartFile 타입 객체(멤버변수 fileX)가 관리함
		MultipartFile pImg1 = store.getProduct_img_file1();
		
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		// => 주의! 업로드 파일이 존재하지 않으면 파일명에 null 값이 아닌 널스트링값 저장됨
		System.out.println("원본파일명1 : " + pImg1.getOriginalFilename());
		
		// 파일명 중복 방지 대책
		// 자신의 업로드하는 파일명끼리도 중복을 방지하려면 UUID 를 매번 생성하여 결합
		String pImgName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + pImg1.getOriginalFilename();
		
		// 업로드 할 파일이 존재할 경우(원본 파일명이 널스트링이 아닐 경우)에만 
		// BoardVO 객체에 서브디렉토리명과 함께 파일명 저장
		// => 단, 업로드 파일이 선택되지 않은 파일은 파일명에 null 값이 저장되므로
		//    파일명 저장 전 BoardVO 객체의 파일명에 해당하는 멤버변수값을 널스트링("") 으로 변경
		store.setProduct_img("");
		
		if(!pImg1.getOriginalFilename().equals("")) {
			store.setProduct_img(subDir + "/" + pImgName1);
		}
		
		System.out.println("DB 에 저장될 파일명 : " + store.getProduct_img());
		
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
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			// 상품관리(AdminStore) 서블릿 주소 리다이렉트
			return "redirect:/AdminStore";
		} else { // 실패
			// "글쓰기 실패!" 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "상품등록 실패!");
			return "result/fail";
		}
	}
	
}























