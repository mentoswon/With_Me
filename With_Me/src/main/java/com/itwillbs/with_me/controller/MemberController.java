package com.itwillbs.with_me.controller;

import java.security.PrivateKey;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.itwillbs.with_me.handler.RsaKeyGenerator;
import com.itwillbs.with_me.service.KakaoService;
import com.itwillbs.with_me.service.MailService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FundingVO;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.Store_userVO;

@Controller
public class MemberController {
	@Autowired
	private MemberService service;
	@Autowired
	private MailService MailService;
	@Autowired
	private KakaoService kakaoService;
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload"; 
	
	// 회원가입폼 페이지
	@GetMapping("MemberJoin")
	public String memberJoin(HttpSession session, Model model) {
		
		// 로그인 폼 요청 시 아이디와 패스워드 암호화 과정에서 사용할 공개키/개인키 생성(RSA 알고리즘)
		// 사용자 정의 클래스 RsaKeyGenerator 클래스의 static 메서드 generateKey() 호출
		Map<String, Object> rsaKey = RsaKeyGenerator.generateKey();
//		System.out.println("개인키 : " + rsaKey.get("RSAPrivateKey"));
//		System.out.println("공개키(Modulus) : " + rsaKey.get("RSAModulus"));
//		System.out.println("공개키(Exponent) : " + rsaKey.get("RSAExponent"));
		
		// 개인키는 세션에 저장하고, 공개키는 Model 객체를 통해 클라이언트측으로 전송
		session.setAttribute("RSAPrivateKey", rsaKey.get("RSAPrivateKey"));
		model.addAttribute("RSAModulus", rsaKey.get("RSAModulus"));
		model.addAttribute("RSAExponent", rsaKey.get("RSAExponent"));
		
		
		return "member/member_join_form";
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
		System.out.println("tel : " + member.getMem_tel());
		
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
	
	
	// 회원가입
	@PostMapping("MemberJoinPro")
	public String memberJoinPro(MemberVO member, Model model, BCryptPasswordEncoder passwordEncoder, HttpSession session) {
		System.out.println(member);
		
		// ============================= 아이디/패스워드 복호화 ====================================
//		System.out.println("암호화 된 아이디 : " + member.getMem_email());
		System.out.println("암호화 된 패스워드 : " + member.getMem_passwd());
		
		// RSAKeyGenerator 클래스의 decrypt() 메서드 호출하여 전달받은 암호문 복호화
		PrivateKey privateKey = (PrivateKey)session.getAttribute("RSAPrivateKey");
		
		// RsaKeyGenerator 클래스의 decrypt() 메서드 호출하여 전달받은 암호문 복호화
		// => 파라미터 : 세션에 저장된 개인키, 암호문   리턴타입 : String
//		String id = RsaKeyGenerator.decrypt(privateKey, member.getMem_email());
		String passwd = RsaKeyGenerator.decrypt(privateKey, member.getMem_passwd());
//		System.out.println("복호화 된 아이디 : " + id);
		System.out.println("복호화 된 패스워드 : " + passwd);
		
		// MemberVO 객체에 복호화 된 아이디, 패스워드 저장
//		member.setMem_email(id);
		member.setMem_passwd(passwd);
		
		
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
	public String login(HttpSession session, Model model) {
		// 로그인 폼 요청 시 아이디와 패스워드 암호화 과정에서 사용할 공개키/개인키 생성(RSA 알고리즘)
		// 사용자 정의 클래스 RsaKeyGenerator 클래스의 static 메서드 generateKey() 호출
		Map<String, Object> rsaKey = RsaKeyGenerator.generateKey();
//		System.out.println("개인키 : " + rsaKey.get("RSAPrivateKey"));
//		System.out.println("공개키(Modulus) : " + rsaKey.get("RSAModulus"));
//		System.out.println("공개키(Exponent) : " + rsaKey.get("RSAExponent"));
		
		// 개인키는 세션에 저장하고, 공개키는 Model 객체를 통해 클라이언트측으로 전송
		session.setAttribute("RSAPrivateKey", rsaKey.get("RSAPrivateKey"));
		model.addAttribute("RSAModulus", rsaKey.get("RSAModulus"));
		model.addAttribute("RSAExponent", rsaKey.get("RSAExponent"));
		
		return "member/member_login_form";
	}
	
	
	// 로그인 성공창(메인)
	// http://localhost:8080/camcar/MemberLoginPro
	@PostMapping("MemberLoginPro")
	public String memberLoginPro(MemberVO member, Model model, HttpSession session, String rememberId,
								BCryptPasswordEncoder passwordEncoder, HttpServletResponse response) {
		
		// ============================= 아이디/패스워드 복호화 ====================================
		System.out.println("암호화 된 아이디 : " + member.getMem_email());
		System.out.println("암호화 된 패스워드 : " + member.getMem_passwd());
		
		// RSAKeyGenerator 클래스의 decrypt() 메서드 호출하여 전달받은 암호문 복호화
		PrivateKey privateKey = (PrivateKey)session.getAttribute("RSAPrivateKey");
		
		// RsaKeyGenerator 클래스의 decrypt() 메서드 호출하여 전달받은 암호문 복호화
		// => 파라미터 : 세션에 저장된 개인키, 암호문   리턴타입 : String
		String id = RsaKeyGenerator.decrypt(privateKey, member.getMem_email());
		String passwd = RsaKeyGenerator.decrypt(privateKey, member.getMem_passwd());
		System.out.println("복호화 된 아이디 : " + id);
		System.out.println("복호화 된 패스워드 : " + passwd);
		
		// MemberVO 객체에 복호화 된 아이디, 패스워드 저장
		member.setMem_email(id);
		member.setMem_passwd(passwd);
		// ===============================================================================================
		
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
	
	// [ 카카오 로그인 ]
	@GetMapping("KakaoLoginCallback")
	public String kakaoLogin(String code, Model model, HttpSession session) {
//		System.out.println(code);
		
		Map<String, String> token = kakaoService.requestKakaoAccessToken(code);
		System.out.println(token);
		
		Map<String, Object> userInfo = kakaoService.requestKakaoUserInfo(token);
		System.out.println(userInfo);
		
		// 이메일 저장된 kakaoAccount 객체 꺼내기
		Map<String, Object> kakaoAccount = (Map<String, Object>) userInfo.get("kakao_account");
		
		MemberVO member = service.getMemberFromEmail((String)kakaoAccount.get("email"));
		System.out.println(member);
		
		if(member == null) {
			model.addAttribute("msg", "가입되지 않은 회원입니다!\\n회원가입 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberJoin?email=" + kakaoAccount.get("email"));
			return "result/success";
		} else {
			// 가입된 회원은 즉시 로그인 처리
			session.setAttribute("sId", member.getMem_email());
			session.setMaxInactiveInterval(60 * 60); // 60초 * 60분
			return "redirect:/";
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
	
	
	// 아이디 찾기
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
	@PostMapping("PwFindPro")
	public String pwFindPro(MemberVO member, Model model) {
			
		MemberVO dbMember = service.getFindPasswdFromEmail(member);
		
		if(dbMember == null) { // !member.getMem_tel().equals(mem_tel)
			model.addAttribute("msg", "없는 아이디입니다");
			return "result/fail";

		} else {
//				model.addAttribute("mem_id", mem_id); // model에 아이디값 저장
			model.addAttribute("dbMember", dbMember); // model에 아이디값 저장
			return "member/member_pw_find_pro";
		}
	}
	
	// 전화번호로 비밀번호 찾기
	@PostMapping("PwResetPro")
	public String pwResetPro(MemberVO member, Model model) {
		MemberVO dbMember = service.getFindPasswdFromTel(member);
		if(dbMember == null) { // !member.getMem_tel().equals(mem_tel)
			model.addAttribute("msg", "없거나 해당 아이디와 맞지 않는 전화번호입니다");
			return "result/fail";
			
		} else {
			model.addAttribute("dbMember", dbMember); // model에 전화번호값 저장
			return "member/member_pw_reset";
		}
		
//		return "member/member_pw_find";
	}
	
	// 비밀번호 재설정 폼
	@GetMapping("PwResetFinal")
	public String pwResetFinal() {
		return "member/member_pw_reset";
	}
	
	
	// 비밀번호 재설정
	@PostMapping("PwResetFinal")
	public String pwResetFinalPro(@RequestParam Map<String, String> map, MemberVO member
								, BCryptPasswordEncoder passwordEncoder, Model model, @RequestParam(defaultValue = "")String mem_tel) {
		member = service.getMember(member); // // map이 있으니까 member에 덮어씌워도 상관없다
		System.out.println("mem_tel : " + mem_tel);
		// 새 비밀번호 입력 여부를 확인하여 새 비밀번호 입력됐을 경우 암호화 수행 필요
		if(!map.get("mem_passwd").equals("")) { // 널스트링이 아니면 새 비밀번호 암호화 수행
			map.put("mem_passwd", passwordEncoder.encode(map.get("mem_passwd")));
			System.out.println("map : " + map); // passwd 항목 암호화 결과 확인
		}
		
		int updateCount = service.modifyPasswd(map);
		
		if(updateCount > 0) {
//			return "redirect:/MemberInfo";
			model.addAttribute("msg", "패스워드 수정 성공!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/success";
		} else {
			model.addAttribute("msg", "패스워드 수정 실패!");
			return "result/fail";
		}
		
	}
	
	
	// 마이페이지(창작자 정보)
	@GetMapping("MemberInfo")
	public String memberInfo(MemberVO member, Model model, HttpSession session, ProjectVO project,
							@RequestParam(defaultValue = "1") int pageNum) {
		
		String id = (String)session.getAttribute("sId");
		member.setMem_email(id);
		member = service.getMember(member);
		
		System.out.println("member : !!!!!!!!!! " + member);
		
		// 한 페이지에서 표시할 글 목록 개수 지정 (jsp 에서 가져옴)
		int listLimit = 8;
		
		// 조회 시작 행 번호 계산
		int startRow = (pageNum - 1) * listLimit;
		
		// --------------------------------------------------------------------
		
		// 페이징 처리를 위한 계산 작업 (jsp 에서 가져옴)
		// 검색 파라미터 추가해주기 (원래 파라미터 없음)
		int listCount = service.getProjectListCount();
		
		System.out.println("listCount : " + listCount);
		
		int pageListLimit = 3;
		
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
		
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
		
		// 전달받은 페이지 번호가 1보다 작거나 최대 번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "MemberInfo");
			
			return "result/fail";
		}
		
		// --------------------------------------------------------------------
		// 프로젝트 목록 표출하기
		List<Map<String, Object>> projectList = service.getProjectList(startRow, listLimit,member.getMem_email());
		// 후원한 프로젝트 목록 나타내기
		List<Map<String, Object>> DonationProjectList = service.getDonationProjectList(startRow, listLimit, member.getMem_email());
		// 팔로우 목록 나타내기
		List<Map<String, Object>> followList = service.getFollowtList(startRow, listLimit, member.getMem_email());
		// 팔로잉 목록 나타내기
		List<Map<String, Object>> followingList = service.getFollowingtList(startRow, listLimit, member.getMem_email());
		// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//		List<FollowVO> followerCount = service.getFollowerCount(followerCount);
		// 내가 좋아요한 프로젝트 목록 나타내기
		List<Map<String, Object>> likeProjectList = service.getLikeProjectList(startRow, listLimit, member.getMem_email());
		// 내가 좋아요한 상품 목록 나타내기
		List<Map<String, Object>> likeProductList = service.getLikeProductList(startRow, listLimit, member.getMem_email());
		// 내가 구매한 상품 목록 나타내기
		List<Map<String, Object>> BuyProductList = service.getBuyProductList(startRow, listLimit, member.getMem_email());
		
		
		System.out.println("projectList : " + projectList);
		System.out.println("DonationProjectList : " + DonationProjectList);
		System.out.println("followList : " + followList);
		System.out.println("followingList : " + followingList);
		System.out.println("likeProjectList : " + likeProjectList);
		System.out.println("likeProductList : " + likeProductList);
		System.out.println("BuyProductList : " + BuyProductList);
//		System.out.println("followerCount : " + followerCount);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("projectList", projectList);
		model.addAttribute("DonationProjectList", DonationProjectList);
		model.addAttribute("followList", followList);
		model.addAttribute("followingList", followingList);
		model.addAttribute("likeProjectList", likeProjectList);
		model.addAttribute("likeProductList", likeProductList);
		model.addAttribute("BuyProductList", BuyProductList);
//		model.addAttribute("followerCount", followerCount);
		
		// 나의 마이페이지 들어갈 때 필요한 크리에이터 정보 세션 아이디로 들어감
		// 창작자에 등록되어있는지 알아내기 위해 email 이용해서 창작자정보 가져오기
		CreatorVO creatorInfo = service.getCreatorInfo(member);
		
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
//		int followListCount = service.getFollowListCount();
		int likeListCount = service.getLikeListCount();
		
		System.out.println("listCount : " + listCount);
//		System.out.println("followListCount : " + followListCount);
		System.out.println("likeListCount : " + likeListCount);
		
		int pageListLimit = 3;
		int maxPage = listCount / listLimit + (listCount % listLimit > 0 ? 1 : 0);
//		int followListMaxPage = followListCount / listLimit + (followListCount % listLimit > 0 ? 1 : 0);
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
//		if(followListMaxPage == 0) {
//			followListMaxPage = 1;
//		}
//		if(endPage > followListMaxPage) {
//			endPage = followListMaxPage;
//		}
		
		// 전달받은 페이지 번호가 1보다 작거나 최대 번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "ProjectList");
			
			return "result/fail";
		}
		// ---------------------------------------------------------
//		if(pageNum < 1 || pageNum > followListMaxPage) {
//			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
//			model.addAttribute("targetURL", "ProjectList");
//			
//			return "result/fail";
//		}
		
		// --------------------------------------------------------------------
		String creatorEmail = creator.getCreator_email();
		
		// 프로젝트 목록 표출하기
		List<Map<String, Object>> OtherprojectList = service.getOtherProjectList(startRow, listLimit, creatorEmail);
		System.out.println("OtherprojectList : " + OtherprojectList);
		
//		System.out.println("creatorEmail : !!!!!!!!!!!! " + creatorEmail);
		
		// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//		List<FollowVO> followerCount = service.getFollowerCount(followerCount);
		
		CreatorVO creatorInfo = service.getOtherCreatorInfo(creatorEmail);
//		if(creatorInfo.size() > 0 ) {
//			creatorEmail = creatorInfo.get(0).getCreator_email();
//		} 
		
		System.out.println("creatorInfo : " + creatorInfo);
		model.addAttribute("creatorInfo", creatorInfo);
		

//		System.out.println("followerCount : " + followerCount);
		
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
//		PageInfo followPageInfo = new PageInfo(listCount, pageListLimit, followListMaxPage, startPage, endPage);
		// --------------------------------------------------------------------
		model.addAttribute("pageInfo", pageInfo);
		model.addAttribute("OtherprojectList", OtherprojectList);
//		model.addAttribute("followPageInfo", followPageInfo);
		

//		model.addAttribute("followerCount", followerCount);
		
		
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
			// 창작자가 아닌경우 팔로잉 목록 나타내기
			List<Map<String, Object>> OtherNoCreatorfollowingList = service.getOtherNoCreatorFollowingtList(startRow, listLimit, notCreatorMember.getMem_email());
			// 창작자가 아닌경우 후원한 프로젝트 목록 나타내기
			List<Map<String, Object>> OtherNoCreatorDonationProjectList = service.getOtherNoCreatorDonationProjectList(startRow, listLimit, notCreatorMember.getMem_email());
			System.out.println("OtherNoCreatorfollowList : " + OtherNoCreatorfollowList);
			System.out.println("OtherNoCreatorfollowingList : " + OtherNoCreatorfollowingList);
			System.out.println("OtherNoCreatorDonationProjectList : " + OtherNoCreatorDonationProjectList);
			
			model.addAttribute("OtherNoCreatorfollowList", OtherNoCreatorfollowList);
			model.addAttribute("OtherNoCreatorfollowingList", OtherNoCreatorfollowingList);
			model.addAttribute("OtherNoCreatorDonationProjectList", OtherNoCreatorDonationProjectList);
	        
	    // 창작자 이름이 있다면 크리에이터 정보를 마이페이지에 뿌림
	    } else {
	    	// 위에서 만든 creatorInfo를 들고와서 창작자가 맞다면 크리에이터 정보를 뿌림
	    	System.out.println("창작자 맞는 사람 정보 : " + creatorInfo);
	    	model.addAttribute("creatorInfo", creatorInfo);
	    	
	    	// 창작자인 경우 팔로우 목록 나타내기
	    	List<Map<String, Object>> otherCreatorfollowList = service.getOtherCreatorFollowtList(startRow, listLimit, creatorEmail);
	    	// 창작자인 경우 팔로잉 목록 나타내기
	    	List<Map<String, Object>> otherCreatorfollowingList = service.getOtherCreatorFollowingList(startRow, listLimit, creatorEmail);
			// 창작자가 아닌경우 후원한 프로젝트 목록 나타내기
			List<Map<String, Object>> OtherCreatorDonationProjectList = service.getOtherCreatorDonationProjectList(startRow, listLimit, creatorEmail);
	    	System.out.println("otherCreatorfollowList : " + otherCreatorfollowList);
	    	System.out.println("otherCreatorfollowingList : " + otherCreatorfollowingList);
	    	System.out.println("OtherCreatorDonationProjectList : " + OtherCreatorDonationProjectList);
	    	
	    	model.addAttribute("otherCreatorfollowList", otherCreatorfollowList);
	    	model.addAttribute("otherCreatorfollowingList", otherCreatorfollowingList);
	    	model.addAttribute("OtherCreatorDonationProjectList", OtherCreatorDonationProjectList);
	    }
	    
		return "mypage/other_mypage";
	}
	
	// 내가 후원한 프로젝트 디테일정보
	@GetMapping("DonationProjectDetail")
	public String donationProjectDetail(FundingVO funding, Model model, HttpSession session, HttpServletRequest request) {
		
		System.out.println("funding.getFunding_idx() : " + funding.getFunding_idx());
		
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 후원한 프로젝트 목록 나타내기
		Map<String, Object> DonationProjectDetail = service.getDonationProjectDetail(funding.getFunding_idx());
		System.out.println("DonationProjectDetail!!!!!!!! : " + DonationProjectDetail);
		model.addAttribute("DonationProjectDetail", DonationProjectDetail);
		
		// funding_pay_date는 datetime 속성이라서 <fmt:>로 형변환이 안되기에 이렇게 변환시켜야함
		LocalDateTime fundingPayDate = (LocalDateTime) DonationProjectDetail.get("funding_pay_date");
		Date date = Date.from(fundingPayDate.atZone(ZoneId.systemDefault()).toInstant());
		request.setAttribute("fundingPayDate", date);
		
		
		return "mypage/donation_project_detail";
	}
	
	// 후원 변경(취소)
	@PostMapping("DonationProjectCancel")
	public String donationProjectCancel(@RequestParam Map<String, String> map, HttpSession session, Model model, FundingVO funding) {
		
		System.out.println("map : " + map);
		System.out.println("funding : " + funding);
		
		int updateCount = service.modifyDonationProject(funding);
		
		System.out.println("updateCount : " + updateCount);
		
		if(updateCount > 0) {
			model.addAttribute("msg", "후원 취소 성공!");
			return "redirect:/DonationProjectDetail?funding_idx=" + funding.getFunding_idx();
		} else {
			model.addAttribute("msg", "후원 취소 실패!");
			return "result/fail";
		}
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
	@PostMapping("MyPageInfoModify")
	public String myPageInfoModify(@RequestParam Map<String, String> map, MemberVO member, BCryptPasswordEncoder passwordEncoder, Model model, HttpSession session) {
		
		// => 조회된 상세정보의 암호화 된 패스워드와 입력받은 기존 패스워드 비교
		// => 만약, 두 패스워드가 다를 경우 "수정 권한이 없습니다!" 출력 후 이전페이지 처리
		member = service.getMember(member);
		
		if(!passwordEncoder.matches(map.get("old_mem_passwd"), member.getMem_passwd())) { // 패스워드 불일치시
			model.addAttribute("msg", "수정 권한이 없습니다.");
			return "result/fail";
		}
		
		// 기존 비밀번호 일치 시 회원 정보 수정 요청 전에
		// 새 비밀번호 입력 여부를 확인하여 새 비밀번호 입력됐을 경우 암호화 수행 필요
		if(!map.get("mem_passwd").equals("")) { // 널스트링이 아니면 새 비밀번호 암호화 수행
			map.put("mem_passwd", passwordEncoder.encode(map.get("mem_passwd")));
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
	
	// 마이페이지에서 프로젝트 좋아요 취소
	@ResponseBody
	@PostMapping("MypageCancelLike")
	public String mypageCancelLike(@RequestParam(defaultValue = "") String like_project_code, @RequestParam(defaultValue = "") String like_mem_email) {
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int updateCount = service.cancleLike(like_project_code, like_mem_email);
		
		if(updateCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		JSONObject jo = new JSONObject(resultMap);
			System.out.println("응답 데이터 : " + jo.toString());
		
		return jo.toString();
	}
	
	// 마이페이지에서 상품 좋아요 취소
	@ResponseBody
	@PostMapping("CancleLikeProduct")
	public String cancleLikeProduct(@RequestParam(defaultValue = "") String like_product_code, @RequestParam(defaultValue = "") String like_mem_email) {
		
		// 결과 담을 Map
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		int updateCount = service.cancelProductLike(like_product_code, like_mem_email);
		
		if(updateCount > 0) {
			resultMap.put("result", true);
		} else {
			resultMap.put("result", false);
		}
		
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 데이터 : " + jo.toString());
		
		return jo.toString();
	}
	
	// 내가 구입한 상품정보 상세정보
	@GetMapping("BuyProductDetail")
	public String buyProductDetail(HttpSession session, Model model, Store_userVO store_user, HttpServletRequest request) {
		
		System.out.println("store_user.getOrder_idx() : " + store_user.getOrder_idx());
		
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 내가 구입한 상품 목록 나타내기
		Map<String, Object> BuyProductDetail = service.getBuyProductDetail(store_user.getOrder_idx());
		System.out.println("BuyProductDetail!!!!!!!! : " + BuyProductDetail);
		model.addAttribute("BuyProductDetail", BuyProductDetail);
		
		// order_date는 datetime 속성이라서 <fmt:>로 형변환이 안되기에 이렇게 변환시켜야함
		LocalDateTime orderDate = (LocalDateTime) BuyProductDetail.get("order_date");
		Date date = Date.from(orderDate.atZone(ZoneId.systemDefault()).toInstant());
		request.setAttribute("orderDate", date);
		
		
		return "mypage/buy_product_detail";
	}
	
	// 결제 변경(취소)
	@PostMapping("BuyProductCancel")
	public String buyProductCancel(@RequestParam Map<String, String> map, HttpSession session, Model model, Store_userVO store_user) {
		
		System.out.println("map : " + map);
		System.out.println("store_user : " + store_user);
		
		int updateCount = service.modifyBuyProduct(store_user);
		
		System.out.println("updateCount : " + updateCount);
		
		if(updateCount > 0) {
			model.addAttribute("msg", "결제 취소 성공!");
			return "redirect:/BuyProductDetail?order_idx=" + store_user.getOrder_idx();
		} else {
			model.addAttribute("msg", "결제 취소 실패!");
			return "result/fail";
		}
	}
	
	// 회원 탈퇴
	@GetMapping("MemberWithdraw")
	public String withdrawForm(HttpSession session, Model model) {
		
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
	
			return "result/fail";
		}
		return "mypage/member_withdraw_form";
	}
	
	// 회원탈퇴 로직
	@PostMapping("MemberWithdraw")
	public String withdrawPro(MemberVO member, HttpSession session, Model model, BCryptPasswordEncoder passwordEncoder) {
		
		String id = (String)session.getAttribute("sId");
		if(id == null) { // 세션 아이디가 아닌 경우 튕기게 하는건 시크릿모드에서 주소를 그대로 입력하는것으로 확인 가능
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin"); // targetURL = ""이면 history.back() / targetURL = href이면 해당 href로 이동(fail.jsp에서 확인가능)
	
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// MemberVO 객체에 세션 아이디 저장 
		member.setMem_email(id);
		// --------------------------------------------------------------------
		MemberVO dbMember = service.getMember(member); 
		
		// 비크립트 패스워드를 두번째 칸에 넣어야 한다.
		if(!passwordEncoder.matches(member.getMem_passwd(), dbMember.getMem_passwd())) { // 패스워드 불일치시
			model.addAttribute("msg", "수정 권한이 없습니다!");
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// MemberService - withdrawMember() 메서드 호출하여 회원 탈퇴 작업 요청
		int updateCount = service.withdrawMember(member);
		
		session.invalidate();
		model.addAttribute("msg", "회원 탈퇴 완료!");
		model.addAttribute("targetURL", "./");
		return "result/success";
	}
	
	
}
























