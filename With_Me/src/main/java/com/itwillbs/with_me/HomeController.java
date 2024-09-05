package com.itwillbs.with_me;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.itwillbs.with_me.service.HomeService;
import com.itwillbs.with_me.service.MemberService;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.StoreVO;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private HomeService homeService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, HttpSession session, Model model) {
//		logger.info("Welcome home! The client locale is {}.", locale);
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		// 로그인 여부 및 관리자 여부에 따라 관리자 권한 설정
		String sId = (String)session.getAttribute("sId");
		MemberVO member = new MemberVO();
		if(sId == null) { // 세션 아이디가 없을 경우(=로그인 하지 않았을 경우)
			session.setAttribute("sIsAdmin", "N"); // 관리자 권한 없음
		} else { // 세션 아이디가 있을 경우(=로그인 했을 경우)
			member.setMem_email(sId);
			member = memberService.getMember(member);
			if(member.getMem_isAdmin() == 0) { // 관리자가 아닐 경우
				session.setAttribute("sIsAdmin", "N"); // 관리자 권한 없음
			} else if(member.getMem_isAdmin() == 1) { // 관리자일 경우
				session.setAttribute("sIsAdmin", "Y"); // 관리자 권한 있음
			}
		} 
		// 세션 타이머 1시간으로 변경
		session.setMaxInactiveInterval(60 * 60); // 60초 * 60분 = 3600
		
		// ========================================================================
		
		// 메인 페이지에 프로젝트 리스트 띄우기
		List<Map<String, Object>> projectList = homeService.getProjectList(sId);
		model.addAttribute("projectList", projectList);
//		System.out.println(projectList);
		
		// 메인 페이지에 스토어 리스트 띄우기
		List<Map<String, Object>> storeList = homeService.getStoreList(sId);
		model.addAttribute("storeList", storeList);
//		System.out.println(storeList);
		
		return "index";
	}
	
}
