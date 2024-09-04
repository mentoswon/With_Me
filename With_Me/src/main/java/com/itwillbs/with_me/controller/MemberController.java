package com.itwillbs.with_me.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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
import com.itwillbs.with_me.service.UserFundingService;
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
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload"; 
	
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
		
		// --------------------------------------------------------------
		// 회원가입 시 작성한 주소지를 기본 배송지로 집어넣기
		String address_mem_email = member.getMem_email(); 
		String address_receiver_name = member.getMem_name(); 
		String address_post_code = member.getMem_post_code(); 
		String address_main = member.getMem_add1(); 
		String address_sub = member.getMem_add2(); 
		String address_receiver_tel = member.getMem_tel();  
		
		service.registTransAddress(address_mem_email, address_receiver_name, address_post_code,address_main, address_sub,address_receiver_tel);
		
		
		
		// --------------------------------------------------------------
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
	
	// 마이페이지(창작자 정보)
	@GetMapping("MemberInfo")
	public String memberInfo(MemberVO member, Model model, HttpSession session, ProjectVO project,
							@RequestParam(defaultValue = "1") int pageNum) {
		
		
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
		
		String id = (String)session.getAttribute("sId");
		member.setMem_email(id);
		member = service.getMember(member);
		
		System.out.println("member : !!!!!!!!!! " + member);
		
		// --------------------------------------------------------------------
		// 프로젝트 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(startRow, listLimit);
		// 팔로우 목록 나타내기
		List<Map<String, Object>> followList = service.getFollowtList(startRow, listLimit, member.getMem_email());
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
		
		// 나의 마이페이지 들어갈 때 필요한 크리에이터 정보 세션 아이디로 들어감
		// 창작자에 등록되어있는지 알아내기 위해 email 이용해서 창작자정보 가져오기
		List<CreatorVO> creatorInfo = service.getCreatorInfo(member);
		
		// ====================================================
		// 마이페이지로 들어가는게 아닌 팔로우나 프로젝트 리스트에서 들어가서
		// 상대방의 마이페이지로 들어가는 상황일 경우
		
		String mem_email = member.getMem_email();
		
		System.out.println("mem_email : !!!!!!!!!!!! " + mem_email);
		
		// 창작자가 아닌 사람의 경우 멤버 테이블을 사용하기 위해서 member테이블값 가져오기
		MemberVO memberInfo = service.getMember(member);
//		// 팔로워 값 들고오기
//		List<FollowVO> followInfo = service.getFollower(member);
		
		
		System.out.println("creatorInfo!!!!!!!!! : " + creatorInfo);
	    System.out.println("memberInfo : " + memberInfo);
	    
	    model.addAttribute("creatorInfo", creatorInfo);
	    model.addAttribute("memberInfo", memberInfo);
	    
		return "mypage/mypage";
	}
	
	// 다른사람 마이페이지(창작자 정보)
	@GetMapping("OtherMemberInfo")
	public String otherMemberInfo(MemberVO member, Model model, HttpSession session, ProjectVO project, String creator_email, CreatorVO creator,
							@RequestParam(defaultValue = "1") int pageNum) {
		
		// 한 페이지에서 표시할 글 목록 개수 지정 (jsp 에서 가져옴)
		int listLimit = 8;
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		// --------------------------------------------------------------------
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getProjectListCount();
		int followListCount = service.getFollowListCount();
		int likeListCount = service.getLikeListCount();
		
		System.out.println("listCount : " + listCount);
		System.out.println("followListCount : " + followListCount);
		System.out.println("likeListCount : " + likeListCount);
		
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
		
		// --------------------------------------------------------------------
		// 프로젝트 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(startRow, listLimit);
		
//		String memEmail = member.getMem_email();
		String creatorEmail = creator.getCreator_email();
//		System.out.println("creatorEmail : !!!!!!!!!!!! " + creatorEmail);
		
		// 크리에이터 이메일이랑 조인해서 mem_email 들고오면은 창작자 아닌 사람의 경우에는 값을 가져오지 못함
		// 그래서 mem_email로 팔로우나 크리에이터 정보를 가져와야한다.
//		String memEmail = service.getMemEmail(creatorEmail);
//		System.out.println("memEmail !!!!!!!!!! : " + memEmail);
		

		
		
		// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//		List<FollowVO> followerCount = service.getFollowerCount(followerCount);
		
		// 좋아요 리스트 나타내기
//		List<Map<String, Object>> likeList = service.getOtherLikeList(startRow, listLimit, memEmail);
		
		// 팔로우, 좋아요는 창작자이거나 아니거나 다 볼 수 있어야 하기 때문에
		// mem_email을 들고와서 비교를 해야 값을 들고올 수 있다. !!!!!!!!!!!!!!!!!!!!!!!!!!!!
		List<CreatorVO> creatorInfo = service.getOtherCreatorInfo(creatorEmail);
		if(creatorInfo != null) {
			String getCreator_email = creatorInfo.get(0).getCreator_email();
			System.out.println("getCreator_email : " + getCreator_email);
			
		}
		
		System.out.println("creatorInfo : " + creatorInfo);
		model.addAttribute("creatorInfo", creatorInfo);
		
		
		System.out.println("projectList : " + projectList);

//		System.out.println("followerCount : " + followerCount);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		PageInfo followPageInfo = new PageInfo(listCount, pageListLimit, followListMaxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("projectList", projectList);
		model.addAttribute("followPageInfo", followPageInfo);
		

//		model.addAttribute("followerCount", followerCount);
		
		// ====================================================
		// 마이페이지로 들어가는게 아닌 팔로우나 프로젝트 리스트에서 들어가서
		// 상대방의 마이페이지로 들어가는 상황일 경우
		
		
		// 이메일로 창작자 이름 들고오기
		String creatorName = service.getCreatorName(creatorEmail);
		System.out.println("creatorName !!!!!!!: " + creatorName);
		model.addAttribute("creatorName", creatorName);
		
		
		// 창작자 이름이 없다면 member정보를 마이페이지에 뿌림
	    if(creatorName == null) {
	        MemberVO notCreatorMember= service.getMemberInfo(creatorEmail);
	            
	        System.out.println("창작자 아닌 사람 정보  !!!!!!!!!! : " + notCreatorMember);
	        model.addAttribute("notCreatorMember", notCreatorMember);
	        
			// 창작자가 아닌경우 팔로우 목록 나타내기
			List<Map<String, Object>> OtherNoCreatorfollowList = service.getOtherNoCreatorFollowtList(startRow, listLimit, notCreatorMember.getMem_email());
			System.out.println("OtherNoCreatorfollowList : " + OtherNoCreatorfollowList);
			model.addAttribute("OtherNoCreatorfollowList", OtherNoCreatorfollowList);
	        
	    // 창작자 이름이 있다면 크리에이터 정보를 마이페이지에 뿌림
	    } else {
	    	// 위에서 만든 creatorInfo를 들고와서 창작자가 맞다면 크리에이터 정보를 뿌림
	    	System.out.println("창작자 맞는 사람 정보 : " + creatorInfo);
	    	model.addAttribute("creatorInfo", creatorInfo);
	    	
	    	// 창작자가 아닌경우 팔로우 목록 나타내기
//	    	List<Map<String, Object>> otherCreatorfollowList = service.getOtherCreatorFollowtList(startRow, listLimit, getCreator_email);
//	    	System.out.println("otherCreatorfollowList : " + otherCreatorfollowList);
//	    	model.addAttribute("otherCreatorfollowList", otherCreatorfollowList);
	    	
	    }
	    
		return "mypage/other_mypage";
	}
	
	// 마이페이지(개인정보)
	@GetMapping("MypageInfo")
	public String mypageInfo(HttpSession session, Model model, MemberVO member) {
		
		String id = (String)session.getAttribute("sId");
		
		if(id == null) { // 세션 아이디가 아닌 경우 튕기게 하는건 시크릿모드에서 주소를 그대로 입력하는것으로 확인 가능
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin"); // targetURL = ""이면 history.back() / targetURL = href이면 해당 href로 이동(fail.jsp에서 확인가능)
	
			return "result/fail";
		}
		
		member.setMem_email(id);
		member = service.getMember(member);
		
		model.addAttribute("member", member);
		
		return "mypage/mypage_info";
	}
	
	// 마이페이지(개인정보) 수정
	@GetMapping("MyPageInfoModify")
	public String myPageInfoModify(@RequestParam Map<String, String> map, MemberVO member, BCryptPasswordEncoder passwordEncoder, Model model) {
		
//		String id = (String)session.getAttribute("sId");
//		
//		member.setMem_email(id);
		member = service.getMember(member);
		System.out.println("member !!!!!!!!!!!! : " + member);
//		model.addAttribute("member", member);
		
		if(!passwordEncoder.matches(map.get("oldPasswd"), member.getMem_passwd())) { // 패스워드 불일치시
			model.addAttribute("msg", "비밀번호가 올바르지 않습니다.");
			return "result/fail";
		}
		
		// 기존 비밀번호 일치 시 회원 정보 수정 요청 전에
		// 새 비밀번호 입력 여부를 확인하여 새 비밀번호 입력됐을 경우 암호화 수행 필요
		if(!map.get("passwd").equals("")) { // 널스트링이 아니면 새 비밀번호 암호화 수행
			map.put("passwd", passwordEncoder.encode(map.get("passwd")));
		}
		
		// 개인정보 수정
		int updateCount = service.modifyMember(map);
		
		if(updateCount > 0) {
			model.addAttribute("msg", "회원정보 수정 성공!");
			model.addAttribute("targetURL", "MypageInfo");
			return "result/success";
		} else {
			model.addAttribute("msg", "회원정보 수정 실패!");
			return "result/fail";
		}
	}
	
}
























