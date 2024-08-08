package com.itwillbs.with_me.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.itwillbs.with_me.service.AdminService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;

@Controller
public class AdminController {
	@Autowired 
	private AdminService adminService;
	@Autowired
	private MemberService memberService;
	
	// 관리자 메인
	@GetMapping("Admin")
	public String memberJoin(HttpSession session, Model model) {
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
	public String memberList(@RequestParam(defaultValue = "1") int pageNum,
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
//		int listLimit = 5; // 페이지 당 게시물 수
		int startRow = (pageNum - 1) * listLimit; // 조회할 게시물의 행 번호
		
		int listCount = adminService.getMemberListCount(searchKeyword); // 총 게시물 개수
//		System.out.println(listCount);
		int pageListLimit = 3; // 임시) 페이지 당 페이지 번호 갯수를 3개로 지정(1 2 3 or 4 5 6)
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
		
//		System.out.println(memberList);
		
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		
		// 회원 목록, 페이징 정보 Model 객체에 저장 -> admin_member_list.jsp 로 전달
		model.addAttribute("memberList", memberList);
		model.addAttribute("pageInfo", pageInfo);
		
//		System.out.println(pageInfo);
		
		return "admin/admin_member_list";
	}
	
	// 관리자 권한 부여 여부
	// 같은 서블릿 주소에서 하면 버튼을 눌러서 넘어왔는지 그냥 넘어왔는지 판별이 안되므로 
	// 주소를 구분해서 하는게 좋다 !!!!!
	@GetMapping("ChangeAdminAuthorize")
	public String changeAuthorize(MemberVO member, HttpSession session, Model model) {
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
	
	// 관리자 - 회원관리 - 회원목록 - 후원내역(보류)
	@GetMapping("AdminMemberSponsorshipDetail")
	public String adminMemberSponsorshipDetail(MemberVO member, Model model) {
		member = memberService.getMember(member);
		return "";
	}
}




