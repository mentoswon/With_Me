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

import com.itwillbs.with_me.service.AdminService;
import com.itwillbs.with_me.service.MemberService;
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
		List<ProjectVO> projectList = adminService.getProjectList(startRow, listLimit, searchKeyword, projectStatus);
//		System.out.println("projectList : " + projectList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		System.out.println("pageInfo : " + pageInfo);
		
		// 프로젝트 목록, 페이징 정보 Model 객체에 저장 -> admin_regist_waiting_project_list.jsp 로 전달
		model.addAttribute("projectList", projectList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "admin/admin_project_list";
	}
	
	// 프로젝트 등록 승인/거부
	@GetMapping("AdminProjectApproval")
	public String adminProjectApproval(HttpSession session, Model model, ProjectVO project, String isAuthorize) {
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
		// 성공 시 "프로젝트 등록 승인/거부 성공!" 메세지 출력 및 "AdminRegistWaitingProjectList" 서블릿 주소 전달(success.jsp)
		// 실패 시 "프로젝트 등록 승인/거부 실패!" 메세지 출력 및 이전페이지 처리(fail.jsp)
		if(updateCount > 0) {
			if(status.equals("승인")) {
				model.addAttribute("msg", "프로젝트 등록 승인 성공!");
			} else if(status.equals("거부")) {
				model.addAttribute("msg", "프로젝트 등록 거부 성공!");
			}
			model.addAttribute("targetURL", "AdminRegistWaitingProjectList");
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
	@GetMapping("AdminProjectCancel")
	public String adminProjectCancel(HttpSession session, Model model, ProjectVO project, String isAuthorize) {
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
		// 성공 시 "프로젝트 취소 승인/거부 성공!" 메세지 출력 및 "AdminProgressProjectList" 서블릿 주소 전달(success.jsp)
		// 실패 시 "프로젝트 취소 승인/거부 실패!" 메세지 출력 및 이전페이지 처리(fail.jsp)
		if(updateCount > 0) {
			if(status.equals("취소")) {
				model.addAttribute("msg", "프로젝트 취소 승인 성공!");
			} else {
				model.addAttribute("msg", "프로젝트 취소 거부 성공!");
			}
			model.addAttribute("targetURL", "AdminProgressProjectList");
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
}




