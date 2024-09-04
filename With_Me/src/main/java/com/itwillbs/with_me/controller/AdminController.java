package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.service.AdminService;
import com.itwillbs.with_me.service.BoardService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Controller
public class AdminController {
	@Autowired 
	private AdminService adminService;
	@Autowired
	private MemberService memberService;
	@Autowired
	private BoardService boardService;
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload";
	
	// 관리자 메인
	@GetMapping("AdminMain")
	public String adminMain(HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		return "admin/admin_main";
	}
	
	// 관리자 - 회원관리 - 회원목록
	@GetMapping("AdminMemberList")
	public String adminMemberList(@RequestParam(defaultValue = "1") int pageNum,
								@RequestParam(defaultValue ="") String searchKeyword,
								@RequestParam(defaultValue = "5") int listLimit,
								HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 페이징 처리
//		int listLimit = 5; // 페이지 당 목록 개수
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = adminService.getMemberListCount(searchKeyword); // 총 목록 개수
//		System.out.println("listCount : " + listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminMemberList?pageNum=1");
			return "result/fail";
		}
		
		// 회원 목록 조회
		// 검색어는 기본적으로 "" 널스트링
		List<MemberVO> memberList = adminService.getMemberList(startRow, listLimit, searchKeyword);
//		System.out.println("memberList : " + memberList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 회원 목록, 페이징 정보 Model 객체에 저장 -> admin_member_list.jsp 로 전달
		model.addAttribute("memberList", memberList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_member_list";
	}
	
	// 관리자 권한 부여/해제
	// 같은 서블릿 주소에서 하면 버튼을 눌러서 넘어왔는지 그냥 넘어왔는지 판별이 안되므로 
	// 주소를 구분해서 하는게 좋다 !!!!!
	@GetMapping("ChangeAdminAuthorize")
	public String changeAdminAuthorize(MemberVO member, HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 파라미터로 전달받은 mem_email, mem_isAdmin 값들이 저장된 MemberVO 객체를 활용하여
		// 해당 회원이 관리자가 아닐 경우 권한 부여, 관리자일 경우 권한 해제
		int adminRegCount = adminService.changeAdminAuth(member);
		
		if(adminRegCount > 0) {
			model.addAttribute("msg", "성공적으로 처리되었습니다.");
			model.addAttribute("targetURL", "AdminMemberList");
			return "result/success";
		}  else {
			model.addAttribute("msg", "권한 변경에 실패했습니다.");
			return "result/fail";
		}
	}
	
	// 관리자 - 회원관리 - 회원목록 - 후원내역
	@GetMapping("SponsorshipHistoryList")
	public String sponsorshipHistoryList(@RequestParam(defaultValue = "1") int pageNum,
										@RequestParam(defaultValue ="") String searchKeyword,
										@RequestParam(defaultValue = "5") int listLimit,
										MemberVO member, HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 후원내역을 조회할 회원의 회원정보 조회
		member = memberService.getMember(member);
		// 페이징 처리
//		int listLimit = 5; // 페이지 당 목록 개수
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = adminService.getSponsorshipHistoryListCount(searchKeyword, member); // 총 목록 개수
//		System.out.println("listCount : " + listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "SponsorshipHistoryList?pageNum=1");
			return "result/fail";
		}
		
		// 후원내역 조회
		// 검색어는 기본적으로 "" 널스트링
		List<Map<String, Object>> sponsorshipHistoryList = adminService.getSponsorshipHistory(startRow, listLimit, searchKeyword, member);
//		System.out.println("sponsorshipHistoryList : " + sponsorshipHistoryList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 후원내역 목록, 페이징 정보 Model 객체에 저장 -> admin_member_sponsorship_detail_list.jsp 로 전달
		model.addAttribute("member", member);
		model.addAttribute("sponsorshipHistoryList", sponsorshipHistoryList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_member_sponsorship_history_list";
	}
	
	// 관리자 - 회원관리 - 회원목록 - 구매내역
	@GetMapping("PurchaseHistoryList")
	public String purchaseHistoryList(@RequestParam(defaultValue = "1") int pageNum,
									@RequestParam(defaultValue ="") String searchKeyword,
									@RequestParam(defaultValue = "5") int listLimit,
									MemberVO member, HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 구매내역을 조회할 회원의 회원정보 조회
		member = memberService.getMember(member);
		// 페이징 처리
//		int listLimit = 5; // 페이지 당 목록 개수
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = adminService.getPurchaseHistoryListCount(searchKeyword, member); // 총 목록 개수
//		System.out.println("listCount : " + listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "PurchaseHistoryList?pageNum=1");
			return "result/fail";
		}
		
		// 구매내역 조회
		// 검색어는 기본적으로 "" 널스트링
		List<Map<String, Object>> purchaseHistorylist = adminService.getPurchaseHistory(startRow, listLimit, searchKeyword, member);
//		System.out.println("purchaseHistorylist : " + purchaseHistorylist);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 구매내역 목록, 페이징 정보 Model 객체에 저장 -> admin_member_purchase_history_list.jsp 로 전달
		model.addAttribute("member", member);
		model.addAttribute("purchaseHistorylist", purchaseHistorylist);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_member_purchase_history_list";
	}
	
	// 관리자 - 프로젝트관리 - 등록신청관리, 진행중인 프로젝트, 종료된 프로젝트
	@GetMapping("AdminProjectList")
	public String adminProjectList(@RequestParam(defaultValue = "1") int pageNum,
								@RequestParam(defaultValue ="") String searchKeyword,
								@RequestParam(defaultValue = "5") int listLimit,
								HttpSession session, Model model, String status) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 파라미터로 받아온 status 값에 따라 projectStatus 값 설정
		String projectStatus = "";
		if(status.equals("등록대기")) {
			projectStatus = "심사중";
		} else if(status.equals("진행중")) {
			projectStatus = "승인";
		} else if(status.equals("종료")) {
			projectStatus = "종료";
		}
		// 페이징 처리
//		int listLimit = 5; // 페이지 당 목록 개수
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = adminService.getProjectListCount(searchKeyword, projectStatus); // 총 목록 개수
//		System.out.println("listCount : " + listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminProjectList?pageNum=1&status=" + status);
			return "result/fail";
		}
		
		// 프로젝트 목록 조회
		// 검색어는 기본적으로 "" 널스트링
		List<Map<String, Object>> projectList = adminService.getProjectList(startRow, listLimit, searchKeyword, projectStatus);
//		System.out.println("projectList : " + projectList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 프로젝트 목록, 페이징 정보 Model 객체에 저장 -> admin_project_list.jsp 로 전달
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_project_list";
	}
	
	// 프로젝트 등록 승인/거부
	@GetMapping("AdminProjectRegistApproval")
	public String adminProjectRegistApproval(HttpSession session, Model model, ProjectVO project, String isAuthorize) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 프로젝트 등록 승인/거부
		String status = "";
		if(isAuthorize.equals("YES")) {
			status = "승인";
		} else if(isAuthorize.equals("NO")) {
			status = "거부";
		}
		int updateCount = adminService.changeProjectStatus(project, status);
		// 등록 승인/거부 결과 판별
		// 성공 시 "프로젝트 등록 승인/거부 성공!" 메세지 출력 및 "AdminProjectList" 서블릿 주소 전달(success.jsp)
		// 실패 시 "프로젝트 등록 승인/거부 실패!" 메세지 출력 및 이전페이지 처리(fail.jsp)
		if(updateCount > 0) {
			if(status.equals("승인")) {
				model.addAttribute("msg", "프로젝트 등록 승인 성공!");
			} else if(status.equals("거부")) {
				model.addAttribute("msg", "프로젝트 등록 거부 성공!");
			}
			model.addAttribute("targetURL", "AdminProjectList?status=등록대기");
			return "result/success";
		} else {
			if(status.equals("승인")) {
				model.addAttribute("msg", "프로젝트 등록 승인 실패!");
			} else if(status.equals("거부")) {
				model.addAttribute("msg", "프로젝트 등록 거부 실패!");
			}
			return "result/fail";
		}
	}
	
	// 프로잭트 취소 신청여부 확인
	@ResponseBody
	@PostMapping("IsCancelExists")
	public String isCancelExists(@RequestParam int project_idx) {
//		System.out.println("project_idx : " + project_idx);
		
		// 프로젝트 취소 신청여부 조회
		ProjectCancelVO projectCancel = adminService.getProjectCancel(project_idx);
//		System.out.println("projectCancel : " + projectCancel);
		
		// 프로젝트 취소 신청여부 판별
		boolean isCancelExists = false; // 취소신청 여부를 저장할 변수 선언(true : 신청함, false : 신청하지 않음)
		if(projectCancel != null) { // 취소신청을 했을 경우 isCancelExists 값을 true로 변경
			isCancelExists = true;
		}
		// 리턴 데이터를 Map 객체에 저장
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("isCancelExists", isCancelExists);
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(map);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		// JSON 객체를 문자열로 변환하여 리턴(@ResponseBody 어노테이션 필수!)
		return jo.toString();
	}
	
	// 프로젝트 취소 승인/거부
	@GetMapping("AdminProjectCancelApproval")
	public String adminProjectCancelApproval(HttpSession session, Model model, ProjectVO project, String isAuthorize) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 프로젝트 취소 승인/거부
		int updateCount = 0;
		String status = "";
		if(isAuthorize.equals("YES")) {
			status = "취소";
			// 프로젝트 상태 변경
			updateCount += adminService.changeProjectStatus(project, status);
			// 프로젝트 취소 승인여부 변경
			updateCount += adminService.changeProjectCancelStatus(project);
		} else if(isAuthorize.equals("NO")) {
			updateCount = 1; // update 작업을 하지 않기에 updateCount를 수동으로 조절
		}
		// 취소 승인/거부 결과 판별
		// 성공 시 "프로젝트 취소 승인/거부 성공!" 메세지 출력 및 "AdminProjectList" 서블릿 주소 전달(success.jsp)
		// 실패 시 "프로젝트 취소 승인/거부 실패!" 메세지 출력 및 이전페이지 처리(fail.jsp)
		if(updateCount > 0) {
			if(status.equals("취소")) {
				model.addAttribute("msg", "프로젝트 취소 승인 성공!");
			} else {
				model.addAttribute("msg", "프로젝트 취소 거부 성공!");
			}
			model.addAttribute("targetURL", "AdminProjectList?status=진행중");
			return "result/success";
		} else {
			if(status.equals("취소")) {
				model.addAttribute("msg", "프로젝트 취소 승인 실패!");
			} else {
				model.addAttribute("msg", "프로젝트 취소 거부 실패!");
			}
			return "result/fail";
		}
	}
	
	// 관리자 - 게시판관리 - 공지사항
	@GetMapping("AdminNotice")
	public String adminNotice(@RequestParam(defaultValue = "1") int pageNum,
							@RequestParam(defaultValue ="") String searchKeyword,
							@RequestParam(defaultValue = "5") int listLimit,
							HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
		// 페이징 처리
//		int listLimit = 5; // 페이지 당 목록 개수
		int startRow = (pageNum - 1) * listLimit; // 조회할 목록의 행 번호
		
		int listCount = adminService.getNoticeListCount(searchKeyword); // 총 목록 개수
//		System.out.println("listCount : " + listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 개수를 3개로 지정(1 2 3 or 4 5 6)
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int startPage = (pageNum - 1) / pageListLimit * pageListLimit + 1;
		int endPage = startPage + pageListLimit - 1;
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 최대 페이지번호(maxPage) 값의 기본값을 1로 설정하기 위해 계산 결과가 0 이면 1 로 변경
		if(maxPage == 0) {
			maxPage = 1;
		}
		
		if(endPage > maxPage) {
			endPage = maxPage;
		}
		
		// 페이지 번호가 1보다 작거나 최대 페이지 번호보다 클 경우
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "AdminNotice?pageNum=1");
			return "result/fail";
		}
		
		// 공지사항 목록 조회
		// 검색어는 기본적으로 "" 널스트링
		List<BoardVO> noticeList = adminService.getNoticeList(startRow, listLimit, searchKeyword);
//		System.out.println("noticeList : " + noticeList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 프로젝트 목록, 페이징 정보 Model 객체에 저장 -> admin_notice.jsp 로 전달
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_notice";
	}
	
	// 공지사항 등록
	@PostMapping("AdminNoticeRegist")
	public String adminNoticeRegist(HttpSession session, Model model, BoardVO notice) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
//		System.out.println("notice : " + notice);
		// [ 파일 업로드 처리 ]
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		// --------------------------------------------------------------------------------------
		// [ 경로 관리 ]
		// 업로드 파일에 대한 관리의 용이성 증대시키기 위해 서브(하위) 디렉토리 활용하여 분산 관리
		// => 날짜별로 하위 디렉토리를 분류하면 관리 용이
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		// 파일 업로드 시점에 맞는 날짜별 서브디렉토리 생성
		// 1. 현재 시스템의 날짜 정보를 갖는 객체 생성
		LocalDate today = LocalDate.now();
		// 2. 날짜 포맷을 디렉토리 형식에 맞게 변경
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		// 2-1) LocalDate 타입 객체의 날짜 포맷 변경을 위해 java.time.format.DateTimeFormat 클래스 활용
		// DateTimeFormatter.ofPattern() 메서드를 호출하여 파라미터로 패턴 문자열 전달
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		// 3. 지정한 포맷을 적용하여 날짜 형식 변경 결과 문자열을 경로 변수 subDir 에 저장
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		// 4. 기존 실제 업로드 경로에 서브 디렉토리(날짜 경로) 결합
		realPath += "/" + subDir;
//		System.out.println("realPath : " + realPath);
		try {
			// 5. 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			// 5-1) java.nio.file.Paths 클래스의 get() 메서드 호출하여
			//      실제 업로드 경로를 관리하는 java.nio.file.Path 객체 리턴받기
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			// 5-2) Files 클래스의 createDirectories() 메서드 호출하여 실제 경로 생성
			//      => 이 때, 경로 상에서 생성되지 않은 모든 디렉토리 생성
			//         만약, 최종 서브디렉토리 1개만 생성 시 createDirectory() 메서드도 사용 가능
			Files.createDirectories(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// --------------------------------------------------------------------------------------
		// [ 업로드 되는 실제 파일 처리 ]
		// 실제 파일은 BoardVO 객체의 MultipartFile 타입 객체(멤버변수 file)가 관리함
		MultipartFile mFile = notice.getFile();
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		// => 주의! 업로드 파일이 존재하지 않으면 파일명에 null 값이 아닌 널스트링값 저장됨
		System.out.println("원본파일명 : " + mFile.getOriginalFilename());
		// [ 파일명 중복 방지 대책 ]
		// - 파일명 앞에 난수를 결합하여 다른 파일과 중복되지 않도록 구분
		// - 숫자만으로 이루어진 난수보다 문자와 함께 결합된 난수가 더 효율적
		String fileName = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile.getOriginalFilename();
		
		// 업로드 할 파일이 존재할 경우(원본 파일명이 널스트링이 아닐 경우)에만 
		// BoardVO 객체에 서브디렉토리명과 함께 파일명 저장
		// => 단, 업로드 파일이 선택되지 않은 파일은 파일명에 null 값이 저장되므로
		//    파일명 저장 전 BoardVO 객체의 파일명에 해당하는 멤버변수값을 널스트링("") 으로 변경
		notice.setBo_file("");
		if(!mFile.getOriginalFilename().equals("")) {
			notice.setBo_file(subDir + "/" + fileName);
		}
		// --------------------------------------------------------------------------------------
		// adminService - registNotice() 메서드 호출하여 공지사항 등록 작업 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(insertCount)
		int insertCount = adminService.registNotice(notice);
		
		// 공지사항 등록 작업 요청 결과 판별
		if(insertCount > 0) { // 성공
			try {
				// 업로드 파일들은 MultipartFile 객체에 의해 임시 저장공간에 저장되어 있으며
				// 글쓰기 작업 성공 시 임시 저장공간 -> 실제 디렉토리로 이동 작업 필요
				// => MultipartFile 객체의 transferTo() 메서드 호출하여 실제 위치로 이동 처리
				//    (파라미터 : java.io.File 타입 객체 전달)
				// => 단, 업로드 파일이 선택되지 않은 항목은 이동 대상에서 제외
				if(!mFile.getOriginalFilename().equals("")) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					mFile.transferTo(new File(realPath, fileName));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			// "공지사항 등록에 성공했습니다." 메세지 출력 및 "AdminNotice" 서블릿 주소 전달
			model.addAttribute("msg", "공지사항 등록에 성공했습니다.");
			model.addAttribute("targetURL", "AdminNotice?pageNum=1");
			
			return "result/success";
		} else { // 실패
			// "공지사항 등록에 실패했습니다." 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "공지사항 등록에 실패했습니다.");
			
			return "result/fail";
		}
	}
	
	// 공지사항 상세정보 가져오기
	@GetMapping("AdminNoticeDetail")
	public String adminNoticeDetail(@RequestParam(defaultValue = "0") int bo_idx, HttpSession session, Model model) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
//		System.out.println("bo_idx : " + bo_idx);
		
		// 공지사항 상세정보 가져와서 BoardVO 객체에 저장
		BoardVO notice = boardService.getBoardDetail(bo_idx, false);
//		System.out.println("notice : " + notice);
		
		// BoardVO 객체를 Model 객체에 저장
		model.addAttribute("notice", notice);
		// -------------------------------------------------------------------------------
		// 뷰페이지에서 파일의 효율적 처리를 위해 파일명만 별도로 String 타입 변수에 저장
		String fileName = notice.getBo_file();
//		System.out.println("fileName : " + fileName);
		// -------------------------------------------------------------------------------
		// 만약, 컨트롤러 측에서 원본 파일명을 추출하여 별도의 객체로 저장 후 전송할 경우
		String originalFileName;
		if(!fileName.equals("")) {
			// "_" 기호 다음(해당 인덱스값 + 1)부터 끝까지 추출하여 리스트에 추가
			originalFileName = (fileName.substring(fileName.indexOf("_") + 1));
		} else {
			 // 파일이 존재하지 않을 경우 널스트링 값 추가
			originalFileName = "";
		}
//		System.out.println("originalFileName : " + originalFileName);
		// -------------------------------------------------------------------------------
		// Model 객체에 파일 목록 저장
		model.addAttribute("fileName", fileName);
		model.addAttribute("originalFileName", originalFileName);
		// -------------------------------------------------------------------------------
		
		return "admin/admin_notice_modify_popup";
	}
	
	// 공지사항 수정 - 파일 삭제
	@ResponseBody
	@PostMapping("AdminRemoveFile")
	public boolean adminRemoveFile(BoardVO notice, HttpSession session) throws Exception {
//		System.out.println("notice : " + notice);
		
		// AdminService - removeFile() 메서드 호출하여 지정된 파일명 삭제 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(deleteCount)
		int deleteCount = adminService.removeFile(notice);
		boolean isSuccess; // 파일 삭제 결과를 저장할 변수 선언
		
		// DB 에서 해당 파일명 삭제 완료 시 실제 파일도 삭제 처리
		if(deleteCount > 0) {
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			
			// 전송된 파일명이 널스트링("") 아닐 경우 파일 삭제 처리
			if(!notice.getBo_file().equals("")) {
				// 업로드 경로와 파일명(서브디렉토리 경로 포함) 결합해서 Path 객체 생성
				Path path = Paths.get(realPath, notice.getBo_file());
				// 파일 삭제
				Files.deleteIfExists(path);
			}
			
			isSuccess = true;
		} else {
			isSuccess = false;
		}
		return isSuccess;
	}
	
	// 공지사항 수정
	@PostMapping("AdminNoticeModify")
	public String adminNoticeModify(@RequestParam(defaultValue = "1") String pageNum,
									HttpSession session, Model model, BoardVO notice) {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
//		System.out.println("notice : " + notice);
		// [ 파일 업로드 처리 ]
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		// --------------------------------------------------------------------------------------
		// [ 경로 관리 ]
		// 업로드 파일에 대한 관리의 용이성 증대시키기 위해 서브(하위) 디렉토리 활용하여 분산 관리
		// => 날짜별로 하위 디렉토리를 분류하면 관리 용이
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		// 파일 업로드 시점에 맞는 날짜별 서브디렉토리 생성
		// 1. 현재 시스템의 날짜 정보를 갖는 객체 생성
		LocalDate today = LocalDate.now();
		// 2. 날짜 포맷을 디렉토리 형식에 맞게 변경
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		// 2-1) LocalDate 타입 객체의 날짜 포맷 변경을 위해 java.time.format.DateTimeFormat 클래스 활용
		// DateTimeFormatter.ofPattern() 메서드를 호출하여 파라미터로 패턴 문자열 전달
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		// 3. 지정한 포맷을 적용하여 날짜 형식 변경 결과 문자열을 경로 변수 subDir 에 저장
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		// 4. 기존 실제 업로드 경로에 서브 디렉토리(날짜 경로) 결합
		realPath += "/" + subDir;
//		System.out.println("realPath : " + realPath);
		try {
			// 5. 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			// 5-1) java.nio.file.Paths 클래스의 get() 메서드 호출하여
			//      실제 업로드 경로를 관리하는 java.nio.file.Path 객체 리턴받기
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			// 5-2) Files 클래스의 createDirectories() 메서드 호출하여 실제 경로 생성
			//      => 이 때, 경로 상에서 생성되지 않은 모든 디렉토리 생성
			//         만약, 최종 서브디렉토리 1개만 생성 시 createDirectory() 메서드도 사용 가능
			Files.createDirectories(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
		// --------------------------------------------------------------------------------------
		// [ 업로드 되는 실제 파일 처리 ]
		// 실제 파일은 BoardVO 객체의 MultipartFile 타입 객체(멤버변수 file)가 관리함
		MultipartFile mFile = notice.getFile();
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		// => 주의! 업로드 파일이 존재하지 않으면 파일명에 null 값이 아닌 널스트링값 저장됨
		System.out.println("원본파일명 : " + mFile.getOriginalFilename());
		// [ 파일명 중복 방지 대책 ]
		// - 파일명 앞에 난수를 결합하여 다른 파일과 중복되지 않도록 구분
		// - 숫자만으로 이루어진 난수보다 문자와 함께 결합된 난수가 더 효율적
		String fileName = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile.getOriginalFilename();
		
		// 업로드 할 파일이 존재할 경우(원본 파일명이 널스트링이 아닐 경우)에만 
		// BoardVO 객체에 서브디렉토리명과 함께 파일명 저장
		// => 단, 업로드 파일이 선택되지 않은 파일은 파일명에 null 값이 저장되므로
		//    파일명 저장 전 BoardVO 객체의 파일명에 해당하는 멤버변수값을 널스트링("") 으로 변경
		notice.setBo_file("");
		if(!mFile.getOriginalFilename().equals("")) {
			notice.setBo_file(subDir + "/" + fileName);
		}
		// --------------------------------------------------------------------------------------
		// adminService - modifyNotice() 메서드 호출하여 공지사항 수정 작업 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(insertCount)
		int updateCount = adminService.modifyNotice(notice);
		
		// 공지사항 수정 작업 요청 결과 판별
		if(updateCount > 0) { // 성공
			try {
				// 업로드 파일들은 MultipartFile 객체에 의해 임시 저장공간에 저장되어 있으며
				// 글쓰기 작업 성공 시 임시 저장공간 -> 실제 디렉토리로 이동 작업 필요
				// => MultipartFile 객체의 transferTo() 메서드 호출하여 실제 위치로 이동 처리
				//    (파라미터 : java.io.File 타입 객체 전달)
				// => 단, 업로드 파일이 선택되지 않은 항목은 이동 대상에서 제외
				if(!mFile.getOriginalFilename().equals("")) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					mFile.transferTo(new File(realPath, fileName));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			// "공지사항 수정에 성공했습니다." 메세지 출력 및 "AdminNotice" 서블릿 주소 전달
			model.addAttribute("msg", "공지사항 수정에 성공했습니다.");
			model.addAttribute("targetURL", "AdminNotice?pageNum=" + pageNum);
			
			return "result/success";
		} else { // 실패
			// "공지사항 수정에 실패했습니다." 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "공지사항 수정에 실패했습니다.");
			
			return "result/fail";
		}
	}
	
	// 공지사항 삭제
	@GetMapping("AdminNoticeRemove")
	public String adminNoticeRemove(int bo_idx, @RequestParam(defaultValue = "1") int pageNum,
									HttpSession session, Model model) throws Exception {
		// 관리자 권한이 없는 경우 접근 차단
		if(session.getAttribute("sIsAdmin").equals("N")) {
			model.addAttribute("msg", "관리자 권한이 없습니다.");
			model.addAttribute("targetURL", "./");
			return "result/fail";
		}
//		System.out.println("bo_idx : " + bo_idx);
//		System.out.println("pageNum : " + pageNum);
		// ----------------------------------------------------------------------
		// 공지사항 삭제 시 실제 업로드 된 파일도 삭제해야하므로 
		// DB 에서 공지사항 정보 삭제 전 파일명을 미리 조회하기 위해
		// BoardService - getBoardDetail() 메서드 재사용하여 공지사항 상세정보 조회 요청
		// => 주의! 조회수 증가되지 않도록 두번째 파라미터값 false 값 전달
		BoardVO notice = boardService.getBoardDetail(bo_idx, false);
//		System.out.println("notice : " + notice);
		
		// 게시물이 존재하지 않을 경우 "잘못된 접근입니다!" 출력 및 이전 페이지 돌아가기 처리
		if(notice == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			return "result/fail";
		}
		// ----------------------------------------------------------------------
		// AdminService - removeNotice() 메서드 호출하여 공지사항 삭제 작업 요청
		// => 파라미터 : 글번호   리턴타입 : int(deleteCount)
		int deleteCount = adminService.removeNotice(bo_idx);
		
		// 삭제 결과 판별하여 처리
		if(deleteCount > 0) {
			// --------------------------------------------------------------------
			// DB에서 게시물 정보 삭제 완료 시 실제 업로드 된 파일 삭제 처리 추가
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			// 파일 삭제에 사용될 파일명을 변수에 저장
			String fileName = notice.getBo_file();
//			System.out.println("삭제할 파일 : " + fileName);
			
			// 파일명이 널스트링("")이 아닐 경우 판별하여 파일 삭제
			if(!fileName.equals("")) {
				// 업로드 경로와 파일명(서브디렉토리 경로 포함) 결합하여 Path 객체 생성
				Path path = Paths.get(realPath, fileName);
//				System.out.println("실제 삭제 대상 : " + path.toString());
				
				// Files 클래스의 deleteIfExists() 메서드 호출하여 파일 존재할 경우 삭제 처리
				Files.deleteIfExists(path);
			}
			// --------------------------------------------------------------------
			model.addAttribute("msg", "삭제 성공!");
			model.addAttribute("targetURL", "AdminNotice?pageNum=" + pageNum);
			return "result/success";
		} else {
			model.addAttribute("msg", "삭제 실패!");
			return "result/fail";
		}
	}
}




