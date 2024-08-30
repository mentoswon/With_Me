package com.itwillbs.with_me.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.service.MailService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectVO;

@Controller
public class MemberController {
	@Autowired
	private MemberService service;
	@Autowired
	private MailService MailService;
	
	// 회원가입폼 페이지
	@GetMapping("MemberJoin")
	public String memberJoin() {
		return "member/member_join_form3";
	}
	
	
	// "MemberCheckDupEmail" 서블릿 주소 매핑 - GET
	// 이 때, 응답 데이터를 직접 생성하여 응답하려면 @ResponseBody 어노테이션 지정 후
	// return 문 뒤에 응답 데이터를 지정하면 해당 데이터가 그대로 응답데이터(body)로 전송된다!
	@ResponseBody
	@GetMapping("MemberCheckDupEmail")
	public String checkDupEmail(MemberVO member) {
//		System.out.println("email : " + member.getMem_email());
		
		// MemberService - getMember() 메서드 재사용하여 회원 상세정보 조회
		// => 파라미터 : MemberVO 객체   리턴타입 : MemberVO 객체
		member = service.getMember(member);
		
		// 조회 결과 리턴된 MemberVO 객체가 있을 경우 아이디 중복, null 이면 사용 가능이므로
		// MemberVO 객체가 null 이 아닐 경우 "true" 리턴, 아니면 "false" 리턴
		if(member != null) {
			return "true";
		} else {
			return "false";
		}
	}
	
	
	// 휴대전화번호 사용중인지 아닌지 판별
	@ResponseBody
	@GetMapping("MemberCheckDupTel")
	public String checkDupTel(MemberVO member) {
//		System.out.println("tel : " + member.getMem_tel());
		
		// MemberService - getMember() 메서드 재사용하여 회원 상세정보 조회
		// => 파라미터 : MemberVO 객체   리턴타입 : MemberVO 객체
		member = service.getMember(member);
		
		// 조회 결과 리턴된 MemberVO 객체가 있을 경우 아이디 중복, null 이면 사용 가능이므로
		// MemberVO 객체가 null 이 아닐 경우 "true" 리턴, 아니면 "false" 리턴
		if(member != null) {
			return "true";
		} else {
			return "false";
		}
		
	}
	
	
	// 회원가입 폼
	@PostMapping("MemberJoinPro")
	public String memberJoinPro(MemberVO member, Model model, BCryptPasswordEncoder passwordEncoder) {
		System.out.println(member);
		
		// 평문(원문) 패스워드에 대한 해싱(Hashing = 단방향 암호화) 수행 후 결과값 문자열로 저장
		String securePasswd = passwordEncoder.encode(member.getMem_passwd());
//		System.out.println("평문 : " + member.getMem_passwd());
//		System.out.println("암호문 : " + securePasswd);
		
		// 암호화 된 패스워드를 다시 MemberVO 객체의 passwd 값에 저장(덮어쓰기)
		member.setMem_passwd(securePasswd);
		
		
		int insertCount = service.registMember(member);
		
		// 회원가입 성공/실패에 따른 페이징 처리
		// 성공 시 : "MemberJoinSuccess" 서블릿 주소 리다이렉트
		// 실패 시 : "result_process/fail.jsp" 페이지 포워딩("msg" 속성값 : "회원가입 실패!")
		if(insertCount > 0) {
			// ------------ 인증 메일 발송 작업 추가 --------------
			// MailService - sendAuthMail() 메서드 호출하여 인증메일 발송 요청
			// => 파라미터 : MemberVO 객체    리턴타입 : MailAuthInfo(mailAuthInfo)
			MailAuthInfo mailAuthInfo = MailService.sendAuthMail(member);
			// MemberService - registMailAuthInfo() 메서드 호출하여 인증 정보 등록 요청
			// => 파라미터 : MailAuthInfo 객체    리턴타입 : void
			service.registMailAuthInfo(mailAuthInfo);
			
			return "redirect:/MemberJoinSuccess";
		} else {
			model.addAttribute("msg", "회원가입 실패!");
			return "result/fail";
		}
	}
	
	// 이메일 인증
	@GetMapping("MemberEmailAuth")
	public String memberEmailAtuth(MailAuthInfo authInfo, Model model) {
		
		System.out.println("authInfo : " + authInfo);
		
		// MemberService - requestEmailAuth() 메서드 호출하여 이메일 인증 처리 요청
		boolean isAuthSuccess = service.requestEmailAuth(authInfo);
		
		if(!isAuthSuccess) {
			model.addAttribute("msg", "인증 실패!");
			return "result/fail";
		} else { // 인증 성공
			model.addAttribute("msg", "인증 성공!\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			
			return "result/success";
		}
	}
	
//	// 이메일 인증 버튼 눌렀을 때
//	@ResponseBody
//	@GetMapping("RequestEmailAuth")
//	public String requestEmailAuth(MemberVO member) {
//		
//		int insertCount = service.registMember(member);
//		
//		if(insertCount > 0) {
//			// ------------ 인증 메일 발송 작업 추가 --------------
//			// MailService - sendAuthMail() 메서드 호출하여 인증메일 발송 요청
//			MailAuthInfo mailAuthInfo = MailService.sendAuthMail(member);
//			
//			// MemberService - registMailAuthInfo() 메서드 호출하여 인증 정보 등록 요청
//			service.registMailAuthInfo(mailAuthInfo);
//			
//			// ----------------------------------------------------
//			return "redirect:/MemberJoinSuccess";
//		}
//		
//		return "";
//	}
	
	
	// 회원가입 완료
	@GetMapping("MemberJoinSuccess")
	public String memberJoinSuccess() {
		return "member/member_join_success";
	}
	
	
	// 로그인 페이지
	@GetMapping("MemberLogin")
	public String login() {
		return "member/member_login_form";
	}
	
	
	// 로그인 성공창(메인)
	// http://localhost:8080/camcar/MemberLoginPro
	@PostMapping("MemberLoginPro")
	public String memberLoginPro(MemberVO member, Model model, HttpSession session, String rememberId,
								BCryptPasswordEncoder passwordEncoder, HttpServletResponse response) {
		
		MemberVO dbMember = service.getMember(member);
		System.out.println(dbMember);
//		System.out.println(member);
		
		if(dbMember == null || !passwordEncoder.matches(member.getMem_passwd(), dbMember.getMem_passwd())) {
			model.addAttribute("msg", "로그인 실패!");
			return "result/fail";
			
		} else if(dbMember.getMem_status() == 3) { // 로그인 성공(이지만 탈퇴 회원인 경우)
			model.addAttribute("msg", "탈퇴한 회원입니다!");
			return "result/fail";
			
		} else if(dbMember.getMem_mail_auth_status().equals("N")) { // 이메일 미인증 회원인 경우
			model.addAttribute("msg", "이메일 인증 후 로그인 가능합니다.");
			return "result/fail";
			
		} else { // 로그인 성공
		
			// 로그인 성공한 아이디를 세션에 저장
			session.setAttribute("sId", member.getMem_email());
			session.setAttribute("sName", dbMember.getMem_name());
			if(dbMember.getMem_isAdmin() == 1) {
				session.setAttribute("sIsAdmin", "Y");
			} else {
				session.setAttribute("sIsAdmin", "N");
			}
			
			// 세션 타이머 1시간으로 변경
			session.setMaxInactiveInterval(60 * 60); // 60초 * 60분 = 3600
			
			// ---------- 코드 중복 제거 ----------
			// 1. javax.servlet.http.Cookie 객체 생성
			Cookie cookie = new Cookie("rememberId", member.getMem_email());
			System.out.println("rememberId : " + rememberId);
			// 2. 파라미터로 전달받은 rememberId 변수값 체크
			if(rememberId != null) {
				// 2-1. 아이디 기억하기 체크 시 : 쿠키 유효기간 30일로 설정
				cookie.setMaxAge(60 * 60 * 24 * 30); // 30일(60초 * 60분 * 24시간 * 30일)
			} else { 
				// 2-2. 아이디 기억하기 미체크 시 : 쿠키 삭제 위해 유효기간을 0 으로 설정
				cookie.setMaxAge(0);
			}
			
			// 3. 클라이언트측으로 쿠키 정보를 전송하기 위해
			//    응답 객체를 관리하는 HttpServletResponse 객체의 addCookie() 메서드로 쿠키 추가
			response.addCookie(cookie);

			// 관리자(admin) 일 경우 관리자 메인으로 리다이렉트
			if(dbMember.getMem_isAdmin() == 1) {
				return "redirect:/AdminMain";
			}
			
			if(session.getAttribute("prevURL") == null) {
				return "redirect:/";
			} else {
				// 요청 서블릿 주소 앞에 "/" 기호가 이미 붙어있으므로 "redirect:" 문자열과 결합
				return "redirect:" + session.getAttribute("prevURL");
			}
		}
	}
	
	// 이메일 인증 메일 재발송 폼
	@GetMapping("ReSendAuthMail")
	public String reSendAuthMailForm() {
		return "member/re_send_auth_mail_form";
	}
	
	@PostMapping("ReSendAuthMail")
	public String reSendAuthMailPro(MemberVO member, Model model) {
		System.out.println("member : " + member);
		// 아이디, 이메일 일치 여부 확인
		// MemberService - getMember() 메서드 호출하여 회원 상세정보 조회
		MemberVO dbMember = service.getMember(member);
		System.out.println(dbMember);
		
//		if(dbMember == null) { // 아이디 없음
//			model.addAttribute("msg", "존재하지 않는 아이디");
//			return "result/fail";
//		} else if(!dbMember.getMem_email().equals(member.getMem_email())) { // 이메일 불일치
//			model.addAttribute("msg", "존재하지 않는 이메일");
//			return "result/fail";
//		}
		if(!dbMember.getMem_email().equals(member.getMem_email())) { // 아이디 없음
			model.addAttribute("msg", "존재하지 않는 이메일");
			return "result/fail";
		}
		// ------------ 인증 메일 발송 작업 추가 --------------
		// MailService - sendAuthMail() 메서드 호출하여 인증메일 발송 요청
		// => 파라미터 : MemberVO 객체    리턴타입 : MailAuthInfo(mailAuthInfo)
		MailAuthInfo mailAuthInfo = MailService.sendAuthMail(member);
		
		// MemberService - registMailAuthInfo() 메서드 호출하여 인증 정보 등록 요청
		// => 파라미터 : MailAuthInfo 객체    리턴타입 : void
		service.registMailAuthInfo(mailAuthInfo);
		
		model.addAttribute("msg", "인증 메일 발송 성공!\\n인증메일을 확인해 주세요.\\n로그인 페이지로 이동합니다.");
		model.addAttribute("targetURL", "MemberLogin");
		System.out.println(model.getAttribute("msg"));
		
		return "result/success";
	}
	
	
	// 로그아웃
	@GetMapping("MemberLogout")
	public String memberLogout(HttpSession session) {
		session.invalidate();
		return "redirect:/";
	}
	
	// 아이디 찾기 폼
	@GetMapping("IdFind") 
	public String idFind() {
		return "member/member_id_find";
	}
	
	
	// 전화번호로 아이디 찾기
	@PostMapping("IdFindPro")
	public String idFindPro(MemberVO member, Model model) {
		
		MemberVO dbMember = service.getId(member);
		System.out.println("dbMember : " + dbMember);
		
		if(dbMember == null) { // !member.getMem_tel().equals(mem_tel)
			model.addAttribute("msg", "없는 아이디입니다");
			return "result/fail";
			
		} else {
			model.addAttribute("dbMember", dbMember); // model에 전화번호 값 저장
			return "member/member_id_find_pro";
		}
		
	}
	
	// 비밀번호 찾기
	@GetMapping("PasswdFind")
	public String passwd_Find() {
		return "member/member_pw_find";
	}
	
//	// 비밀번호 찾기
//	@PostMapping("PwFindPro")
//	public String pwFindPro(MemberVO member, Model model) {
//			
//		MemberVO dbMember = service.isExistId(member);
//		
//		if(dbMember == null) { // !member.getMem_tel().equals(mem_tel)
//			model.addAttribute("msg", "없는 아이디입니다");
//			return "result/fail";
//
//		} else {
////				model.addAttribute("mem_id", mem_id); // model에 아이디값 저장
//			model.addAttribute("dbMember", dbMember); // model에 아이디값 저장
//			return "member/member_pw_find_pro";
//		}
//		
//		return "member/member_pw_find_pro";
//	}
	
//	// 비밀번호 재설정
//	@PostMapping("PwReset")
//	public String pwReset() {
//		return "member/member_pw_reset";
//	}
	
	// 마이페이지
	@GetMapping("MemberInfo")
	public String memberInfo(MemberVO member, Model model, HttpSession session, ProjectVO project,
							@RequestParam(defaultValue = "1") int pageNum) {
		String id = (String)session.getAttribute("sId");
//		System.out.println("id : !!!!!!!!" + id);
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 한 페이지에서 표시할 글 목록 개수 지정 (jsp 에서 가져옴)
		int listLimit = 8;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		// --------------------------------------------------------------------
		
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getProjectListCount();
		int followListCount = service.getFollowListCount();
		
		System.out.println("listCount : " + listCount);
		System.out.println("followListCount : " + followListCount);
		
		int pageListLimit = 3;
		
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		int followListMaxPage = followListCount / listLimit + (followListCount % listLimit > 0 ? 1 : 0);
		
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
		
		// ------------------------------------
		if(followListMaxPage == 0) {
			followListMaxPage = 1;
		}
		
		if(endPage > followListMaxPage) {
			endPage = followListMaxPage;
		}
		
		
		// 전달받은 페이지 번호가 1보다 작거나 최대 번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "ProjectList");
			
			return "result/fail";
		}
		// ---------------------------------------------------------
		if(pageNum < 1 || pageNum > followListMaxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "ProjectList");
			
			return "result/fail";
		}
		
		member.setMem_email(id);
		member = service.getMember(member);
//		System.out.println("member : !!!!!!!!!!" + member);
		
//		FollowVO follow = service.getFollow();
//		System.out.println("follow : !!!!!!!!!!" + follow);
		
		
		// --------------------------------------------------------------------
		// 프로젝트 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(startRow, listLimit);
		// 팔로우 목록 나타내기
		List<Map<String, Object>> followList = service.getFollowtList(startRow, listLimit);
		// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//		List<FollowVO> followerCount = service.getFollowerCount(followerCount);
		
//		System.out.println("projectList : " + projectList);
		System.out.println("followList : " + followList);
//		System.out.println("followerCount : " + followerCount);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		PageInfo followPageInfo = new PageInfo(listCount, pageListLimit, followListMaxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("projectList", projectList);
		
		model.addAttribute("followList", followList);
		model.addAttribute("followPageInfo", followPageInfo);
//		model.addAttribute("followerCount", followerCount);
		
		
		
		// 창작자에 등록되어있는지 알아내기 위해 email 이용해서 창작자 이름 가져오기
		CreatorVO creatorInfo = service.getCreatorName(member);
		// 창작자가 아닌 사람의 경우 멤버 테이블을 사용하기 위해서 member테이블값 가져오기
		MemberVO memberInfo = service.getMember(member);
//		// 팔로워 값 들고오기
//		List<FollowVO> followInfo = service.getFollower(member);
		
		
//		System.out.println("creatorInfo : " + creatorInfo);
//	    System.out.println("memberInfo : " + memberInfo);
	    
	    model.addAttribute("creatorInfo", creatorInfo);
	    model.addAttribute("memberInfo", memberInfo);
	    
		return "mypage/mypage";
	}
	
	// 마이페이지(개인정보)
	@GetMapping("MypageInfo")
	public String mypageInfo(MemberVO member, Model model, HttpSession session) {
		
		String id = (String)session.getAttribute("sId");
		
		member.setMem_email(id);
		member = service.getMember(member);
//		System.out.println("member !!!!!!!!!!!! : " + member);
		model.addAttribute("member", member);
		
		CreatorVO creatorInfo = service.getCreatorName(member);
		model.addAttribute("creatorInfo", creatorInfo);
		
		MemberVO memberInfo = service.getMember(member);
//		System.out.println("memberInfo !!!!!!!!!!!! : " + memberInfo);
		model.addAttribute("memberInfo", memberInfo);
		
		List<String> fileList = new ArrayList<String>();
		fileList.add(creatorInfo.getCreator_image());
		
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
		
		return "mypage/mypage_info2";
	}
	
	@GetMapping("CreatorProfileDelete")
	public String creatorProfileDelete(@RequestParam Map<String, String> map, HttpSession session) throws Exception {
		
		int deleteCount = service.removeProfileDelete(map);
		
		return "";
	}
	
}
























