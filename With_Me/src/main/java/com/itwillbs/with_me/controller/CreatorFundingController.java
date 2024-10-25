package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.handler.CreatorBankApiClient;
import com.itwillbs.with_me.service.CreatorFundingService;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.CreatorAccountVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Controller
public class CreatorFundingController {
	@Autowired
	private CreatorFundingService service;
	
	@Autowired
	private CreatorBankApiClient bankApiClient;
	
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload"; 
	
	// 로그 출력을 위한 기본 라이브러리(org.slf4j.Logger 타입) 변수 선언
	private static final Logger logger = LoggerFactory.getLogger(BankController.class);
	
	// 프로젝트 만들기 페이지
	@GetMapping("ProjectStart")
	public String projectStart(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동(로그인 후 ProjectStart 페이지로 돌아오기)
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			session.setAttribute("prevURL", "ProjectStart");
			return "result/fail";
		}
		return "project/project_start";
	}
	
	// 프로젝트 카테고리 선택 및 제목 작성 페이지
	@GetMapping("ProjectCategory")
	public String projectCategory(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
		// 작성중인 프로젝트 목록 조회
		String status = "작성중";
		List<ProjectVO> project = service.getProjectList(id, status);
		System.out.println("project : " + project);
		model.addAttribute("project", project);
		
		// 공통코드 테이블에서 상위공통코드 FUND 인 컬럼(카테고리) 조회
		List<CommonCodeVO> category = service.getCategory();
		model.addAttribute("category", category);
		
		return "project/project_category";
	}
	
	// 프로젝트 동의 약관 페이지
	@PostMapping("ProjectAgree")
	public String projectAgree(ProjectVO project, HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "로그인 후 이용가능합니다.\\n로그인 페이지로 이동합니다.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		
//		System.out.println("project : " + project);
		model.addAttribute("project_category", project.getProject_category());
		model.addAttribute("project_title", project.getProject_title());
		return "project/project_agree";
	}
	
	// 프로젝트 시작하기 페이지
	@PostMapping("ProjectCreate")
	public String projectCreate(ProjectVO project, HttpSession session, Model model, @RequestParam Map<String, String> map, Integer project_idx) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "접근 권한이 없습니다.\\n로그인 후 이용해주세요.");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------------------
		if (project_idx == null) {	// 새로 작성하는 프로젝트 일 경우
			// 프로젝트 등록 전 창작자 정보 먼저 임시 등록
			// (project_info 테이블의 creator_idx 컬럼이 참조되어 있으므로..)
			service.registCreator(id);
			
			// 프로젝트 제목, 카테고리 저장(insert) 후 이동
			// => NN 값의 경우 임시값 넣어서 insert 할 것
			int insertCount = service.registProject(id, project);
			
			if (insertCount == 0) {
				model.addAttribute("msg", "프로젝트 등록 실패!");
				return "result/fail";
			}
			
			// insert 한 프로젝트 번호 조회
			project_idx = service.getProjectIdx(id);
		}
		
		return "redirect:/ProjectCreate?project_idx=" + project_idx;
	}
	
	// 프로젝트 정보 조회 및 페이지 렌더링
	@GetMapping("ProjectCreate")
	public String projectCreateGet(HttpSession session, Model model, @RequestParam("project_idx") String project_idx) {
	    String id = (String) session.getAttribute("sId");

	    // 프로젝트 정보 조회
	    ProjectVO project = service.getProject(project_idx);
	    // 창작자 정보 조회
	    CreatorVO creator = service.getCreator(project.getCreator_idx());

	    if (id == null) {	// 미로그인 시 로그인 페이지로 이동
	    	model.addAttribute("msg", "접근 권한이 없습니다.\\n로그인 후 이용해주세요.");
	        model.addAttribute("targetURL", "MemberLogin");
	        return "result/fail";
	    } else if (!creator.getCreator_email().equals(id)) {	// 프로젝트의 창작자와 로그인한 id 일치하지 않을 경우
	    	model.addAttribute("msg", "접근 권한이 없습니다.");
	    	return "result/fail";
		}


	    // 공통코드 테이블에서 상위공통코드 FUND 인 컬럼(카테고리) 조회
	    List<CommonCodeVO> category = service.getCategory();
	    model.addAttribute("category", category);

	    // 세부 카테고리 조회
	    String project_category = project.getProject_category();
	    List<CommonCodeVO> category_detail = service.getCategoryDetail(project_category);
	    
	    // 아이템 리스트 조회
	    List<ItemVO> itemList = service.getItemList(project_idx);
	    // 후원 구성 리스트 조회
		List<HashMap<String, String>> rewardList = service.getRewardList(project_idx);

		// 프로젝트에 해당하는 창작자 계좌 정보가 있는지 조회
	    CreatorAccountVO creatorAccount = service.getCreatorAccount(project_idx);
	    // 창작자 계좌 정보 있을 경우 핀테크 사용자 정보 조회
	    if (creatorAccount != null) {
	        // 핀테크 사용자 관련 정보 조회(엑세스토큰 조회 위함)
	        BankToken token = service.getBankUserInfo(id);
            // 핀테크 사용자 정보 조회 API 호출
            Map<String, Object> bankUserInfo = service.getBankUserInfoFromApi(token);

            // 조회된 핀테크 사용자 정보를 모델에 추가
            System.out.println("bankUserInfo : " + bankUserInfo);
            model.addAttribute("bankUserInfo", bankUserInfo);
	    }

		
	    model.addAttribute("category_detail", category_detail);
	    model.addAttribute("itemList", itemList);
	    model.addAttribute("rewardList", rewardList);
	    model.addAttribute("project", project);
	    model.addAttribute("creator", creator);

	    return "project/project_create";
	}
	
	
	// 세부 카테고리 불러오기
	@ResponseBody
	@PostMapping("GetCategoryDetail")
	public List<CommonCodeVO> getCategoryDetail(@RequestParam("project_category") String project_category) {
		List<CommonCodeVO> categoryDetailList = service.getCategoryDetail(project_category);
		// 데이터 반환 (Spring이 자동으로 JSON으로 변환)
		return categoryDetailList;
	}
	
	// 아이템 등록 및 리스트 조회 하기
	@ResponseBody
	@PostMapping("RegistItem")
	public List<ItemVO> registItem(@RequestParam Map<String, String> map) {
		System.out.println("map : " + map);
		
		String project_idx = map.get("project_idx");
		System.out.println("project_idx : " + project_idx);
		
		// 아이템 등록
		int insertCount = service.registItem(map);
		List<ItemVO> itemList = null;
		
		if (insertCount > 0) {	// 아이템 등록 성공
			// 아이템 리스트 조회
			itemList = service.getItemList(project_idx);
		}
		return itemList;
	}
	
	// 아이템 삭제
	@ResponseBody
	@PostMapping("DeleteItem")
	public String deleteItem(@RequestParam("item_idx") String item_idx, @RequestParam("deleteConfirm") boolean deleteConfirm) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		
		if (!deleteConfirm) {
			// 아이템 삭제 전 포함되어 있는 후원 구성 몇 개인지 도출
//			int rewardCount = service.getRewardCount(item_idx);
//			if (rewardCount > 0) {	// 후원 구성에 포함되어 있을 경우 사용자에게 확인 후 삭제
			List<Integer> rewardIdxList  = service.getRewardIdxList(item_idx);
			if (!rewardIdxList.isEmpty()) {	// 후원 구성에 포함되어 있을 경우 사용자에게 확인 후 삭제
				// 사용자에게 이 값을 확인하여 사용자에게 confirm 창을 띄울 수 있도록 보냄
				resultMap.put("confirm", true);
//				resultMap.put("rewardCount", rewardCount);  // 몇 개의 후원 구성에 포함되어 있는지 정보도 함께 보냄
				resultMap.put("rewardIdxList", rewardIdxList );  // 몇번의 후원 구성에 아이템이 포함되어 있는지 정보도 함께 보냄
			} else {	// 후원 구성에 포함되어 있지 않으면 바로 삭제
				// 아이템 삭제 요청
				int deleteCount = service.deleteItem(item_idx);
				// 삭제 요청 처리 결과 판별
				// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
				if(deleteCount > 0) {
					resultMap.put("result", true);	// 삭제 성공
				} else {
					resultMap.put("result", false);	// 삭제 실패
				}
			}
		} else {	// 삭제 허용 시
			// 아이템 포함되어 있는 후원구성부터 삭제 요청
			int deleteCount = service.deleteIncludeReward(item_idx);
			// 아이템 삭제 요청
			int deleteCount2 = service.deleteItem(item_idx);
			
			// 삭제 요청 처리 결과 판별
			// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
			if(deleteCount > 0 && deleteCount2 > 0) {
				resultMap.put("result", true);	// 삭제 성공
			} else {
				resultMap.put("result", false);	// 삭제 실패
			}
		}
		
		
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
	// 후원 구성 등록 및 리스트 조회 하기
	@ResponseBody
	@PostMapping("RegistReward")
	public List<HashMap<String, String>> registReward(@RequestParam Map<String, String> map) {
		System.out.println("map : " + map);
		
		String project_idx = map.get("project_idx");
		System.out.println("project_idx : " + project_idx);
		
		// 후원 구성 등록
		int insertCount = service.registReward(map);
		List<HashMap<String, String>> rewardList = null;
		
		if (insertCount > 0) {	// 아이템 등록 성공
			// 후원 구성 리스트 조회
			rewardList = service.getRewardList(project_idx);
		}
		return rewardList;
	}
	
	// 후원 구성 삭제
	@ResponseBody
	@PostMapping("DeleteReward")
	public String deleteReward(@RequestParam("reward_idx") String reward_idx) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 후원 구성 삭제 요청
		int deleteCount = service.deleteReward(reward_idx);
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
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

	// 계좌정보 가져오기
	@ResponseBody
	@GetMapping("SelectAccountInfo")
	public String selectAccountInfo(@RequestParam Map<String, String> map, Model model, HttpSession session, @RequestParam("project_idx") String project_idx) {
		// 엑세스토큰 관련 정보가 저장된 BankToken 객체(token)를 세션에서 꺼내기
		BankToken token = (BankToken)session.getAttribute("token");
		String id = (String) session.getAttribute("sId");
		System.out.println("token : " + token + ", project_idx" + project_idx);
		
		// 로그인 및 토큰 유효성 확인
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		} else if(token == null || token.getAccess_token() == null) {
			model.addAttribute("msg", "계좌 인증 필수!");
			return "result/fail";
		}
		
		// 핀테크 사용자 정보 조회(창작자) - API 사용
		// => 주의! 응답데이터 중 res_list 값이 리스트 형태이므로 String, String 대신 String, Object 타입 지정
		Map<String, Object> bankCreatorInfo = service.getBankUserInfoFromApi(token);
		logger.info(">>>>>> bankCreatorInfo : " + bankCreatorInfo);
		
		// res_list 값이 리스트 형태로 넘어옴
	    List<Map<String, Object>> accountList = (List<Map<String, Object>>) bankCreatorInfo.get("res_list");
	    
	    // 각 계좌 정보 테이블에 저장
	    int insertCount = 0;
	    int updateCount = 0;
	    for (Map<String, Object> accountInfo : accountList) {
	    	// 계좌 정보에 추가적으로 전달할 정보를 넣음
	    	accountInfo.put("project_idx", project_idx);	// 프로젝트번호
	        accountInfo.put("creator_email", id);	// 창작자 아이디

	        // Map을 서비스로 넘겨서 한꺼번에 처리
	        insertCount += service.registCreatorAccount(accountInfo);
	        updateCount += service.registFintechInfo(accountInfo);
	    }

	    // 결과 출력
	    logger.info(">>>>>>>>> insertCount " + insertCount);
	    logger.info(">>>>>>>>> updateCount " + updateCount);
		
	    // JSON 객체로 응답 데이터 생성
		JSONObject jo = new JSONObject(bankCreatorInfo);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
	
	// 프로젝트 저장하기(임시저장)
	@ResponseBody
	@PostMapping("SaveProject")
	public String saveProject(HttpSession session, ProjectVO project, CreatorVO creator) throws Exception {
		// 로그인된 아이디를 creator_email에 삽입
		String id = (String)session.getAttribute("sId");
		creator.setCreator_email(id);

		System.out.println("project : " + project);
		System.out.println("creator : " + creator);

		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String realPath2 = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		String subDir2 = ""; // 하위 디렉토리명을 저장할 변수 선언
		
		// 이미지 등록 - 프로젝트 번호 별 서브디렉토리 생성
		subDir = "FUND" + "/" + project.getProject_idx();
		// creator_image 등록 - 크리에이터 메일명 별 서브디렉토리 생성
		subDir2 = "CREATOR" + "/" + creator.getCreator_email();
		// 기존 실제 업로드 경로에 서브 디렉토리(모델명 경로) 결합
		realPath += "/" + subDir;
		realPath2 += "/" + subDir2;
		
		try {
			// 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path);	// 실제 경로 생성
			Path path2 = Paths.get(realPath2); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path2);	// 실제 경로 생성
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// ----------------------------------
		// 실제 업로드 되는 파일 처리
		MultipartFile mProjectImg = project.getProjectImg();
		MultipartFile mIntroduceImg = project.getIntroduceImg();
		MultipartFile mBudgetImg = project.getBudgetImg();
		MultipartFile mScheduleImg = project.getScheduleImg();
		MultipartFile mInteteamInterducerduceImg = project.getInteteamInterducerduceImg();
		MultipartFile mSponsorImg = project.getSponsorImg();
		
		MultipartFile mCreatorImg = creator.getCreatorImg();
		
	    if (mProjectImg != null && !mProjectImg.getOriginalFilename().isEmpty()) {
	        project.setProject_image(subDir + "/" + mProjectImg.getOriginalFilename());
	    } else if (project.getProject_image() != null && !project.getProject_image().isEmpty()) {
	        // 파일이 업로드되지 않은 경우: 기존 경로 유지
	        project.setProject_image(project.getProject_image());
	    } else {	// 파일 경로가 전혀 없는 경우
	        project.setProject_image("");
	    }
	    if (mIntroduceImg != null && !mIntroduceImg.getOriginalFilename().isEmpty()) {
	        project.setProject_introduce(subDir + "/" + mIntroduceImg.getOriginalFilename());
	    } else if (project.getProject_introduce() != null && !project.getProject_introduce().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_introduce(project.getProject_introduce());
	    } else {
	        project.setProject_introduce("");
	    }
	    if (mBudgetImg != null && !mBudgetImg.getOriginalFilename().isEmpty()) {
	        project.setProject_budget(subDir + "/" + mBudgetImg.getOriginalFilename());
	    } else if (project.getProject_budget() != null && !project.getProject_budget().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_budget(project.getProject_budget());
	    } else {
	        project.setProject_budget("");
	    }
	    if (mScheduleImg != null && !mScheduleImg.getOriginalFilename().isEmpty()) {
	        project.setProject_schedule(subDir + "/" + mScheduleImg.getOriginalFilename());
	    } else if (project.getProject_schedule() != null && !project.getProject_schedule().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_schedule(project.getProject_schedule());
	    } else {
	        project.setProject_schedule("");
	    }
	    if (mInteteamInterducerduceImg != null && !mInteteamInterducerduceImg.getOriginalFilename().isEmpty()) {
	        project.setProject_team_introduce(subDir + "/" + mInteteamInterducerduceImg.getOriginalFilename());
	    } else if (project.getProject_team_introduce() != null && !project.getProject_team_introduce().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_team_introduce(project.getProject_team_introduce());
	    } else {
	        project.setProject_team_introduce("");
	    }
	    if (mSponsorImg != null && !mSponsorImg.getOriginalFilename().isEmpty()) {
	        project.setProject_sponsor(subDir + "/" + mSponsorImg.getOriginalFilename());
	    } else if (project.getProject_sponsor() != null && !project.getProject_sponsor().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_sponsor(project.getProject_sponsor());
	    } else {
	        project.setProject_sponsor("");
	    }
		
	    if (mCreatorImg != null && !mCreatorImg.getOriginalFilename().isEmpty()) {
	    	creator.setCreator_image(subDir2 + "/" + mCreatorImg.getOriginalFilename());
	    } else if (creator.getCreator_image() != null && !creator.getCreator_image().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	creator.setCreator_image(creator.getCreator_image());
	    } else {
	    	creator.setCreator_image("");
	    }
	    
		// 프로젝트 임시저장(update)
	    project.setProject_status("");
		int updateCount = service.modifyProject(project);
		
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(updateCount > 0) {
			try {
				// 업로드 파일들은 MultipartFile 객체에 의해 임시 저장공간에 저장되어 있으며
				// 글쓰기 작업 성공 시 임시 저장공간 -> 실제 디렉토리로 이동 작업 필요
				// => MultipartFile 객체의 transferTo() 메서드 호출하여 실제 위치로 이동 처리
				//    (파라미터 : java.io.File 타입 객체 전달)
				// => 단, 업로드 파일이 선택되지 않은 항목은 이동 대상에서 제외
				if(mProjectImg != null && !mProjectImg.getOriginalFilename().isEmpty()) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					mProjectImg.transferTo(new File(realPath, mProjectImg.getOriginalFilename()));
				}
				if(mIntroduceImg != null && !mIntroduceImg.getOriginalFilename().isEmpty()) {
					mIntroduceImg.transferTo(new File(realPath, mIntroduceImg.getOriginalFilename()));
				}
				if(mBudgetImg != null && !mBudgetImg.getOriginalFilename().isEmpty()) {
					mBudgetImg.transferTo(new File(realPath, mBudgetImg.getOriginalFilename()));
				}
				if(mScheduleImg != null && !mScheduleImg.getOriginalFilename().isEmpty()) {
					mScheduleImg.transferTo(new File(realPath, mScheduleImg.getOriginalFilename()));
				}
				if(mInteteamInterducerduceImg != null && !mInteteamInterducerduceImg.getOriginalFilename().isEmpty()) {
					mInteteamInterducerduceImg.transferTo(new File(realPath, mInteteamInterducerduceImg.getOriginalFilename()));
				}
				if(mSponsorImg != null && !mSponsorImg.getOriginalFilename().isEmpty()) {
					mSponsorImg.transferTo(new File(realPath, mSponsorImg.getOriginalFilename()));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		// 창작자 정보 임시저장(update)
		int updateCount2 = service.modifyCreator(creator);
		
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(updateCount2 > 0) {
			try {
				if(mCreatorImg != null && !mCreatorImg.getOriginalFilename().isEmpty()) {
					mCreatorImg.transferTo(new File(realPath2, mCreatorImg.getOriginalFilename()));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		System.out.println("updateCount : " + updateCount + ", updateCount2 : " + updateCount2);
		
		resultMap.put("result", true);
		// 리턴 데이터가 저장된 Map 객체를 JSON 객체 형식으로 변환
		// => org.json.JSONObject 클래스 활용
		JSONObject jo = new JSONObject(resultMap);
		System.out.println("응답 JSON 데이터 " + jo.toString());
		
		return jo.toString();
	}
	
	@PostMapping("SubmitProject")
	public String submitProject(HttpSession session, ProjectVO project, CreatorVO creator, Model model) throws Exception {
		// 로그인된 아이디를 creator_email에 삽입
		String id = (String)session.getAttribute("sId");
		creator.setCreator_email(id);

		System.out.println("project : " + project);
		System.out.println("creator : " + creator);

		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String realPath2 = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		String subDir2 = ""; // 하위 디렉토리명을 저장할 변수 선언
		
		// 이미지 등록 - 프로젝트 번호 별 서브디렉토리 생성
		subDir = "FUND" + "/" + project.getProject_idx();
		// creator_image 등록 - 크리에이터 메일명 별 서브디렉토리 생성
		subDir2 = "CREATOR" + "/" + creator.getCreator_email();
		// 기존 실제 업로드 경로에 서브 디렉토리(모델명 경로) 결합
		realPath += "/" + subDir;
		realPath2 += "/" + subDir2;
		
		try {
			// 해당 디렉토리를 실제 경로에 생성(단, 존재하지 않을 경우에만 자동 생성)
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path);	// 실제 경로 생성
			Path path2 = Paths.get(realPath2); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path2);	// 실제 경로 생성
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// ----------------------------------
		// 실제 업로드 되는 파일 처리
		MultipartFile mProjectImg = project.getProjectImg();
		MultipartFile mIntroduceImg = project.getIntroduceImg();
		MultipartFile mBudgetImg = project.getBudgetImg();
		MultipartFile mScheduleImg = project.getScheduleImg();
		MultipartFile mInteteamInterducerduceImg = project.getInteteamInterducerduceImg();
		MultipartFile mSponsorImg = project.getSponsorImg();
		
		MultipartFile mCreatorImg = creator.getCreatorImg();
		
	    if (mProjectImg != null && !mProjectImg.getOriginalFilename().isEmpty()) {
	        project.setProject_image(subDir + "/" + mProjectImg.getOriginalFilename());
	    } else if (project.getProject_image() != null && !project.getProject_image().isEmpty()) {
	        // 파일이 업로드되지 않은 경우: 기존 경로 유지
	        project.setProject_image(project.getProject_image());
	    } else {	// 파일 경로가 전혀 없는 경우
	        project.setProject_image("");
	    }
	    if (mIntroduceImg != null && !mIntroduceImg.getOriginalFilename().isEmpty()) {
	        project.setProject_introduce(subDir + "/" + mIntroduceImg.getOriginalFilename());
	    } else if (project.getProject_introduce() != null && !project.getProject_introduce().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_introduce(project.getProject_introduce());
	    } else {
	        project.setProject_introduce("");
	    }
	    if (mBudgetImg != null && !mBudgetImg.getOriginalFilename().isEmpty()) {
	        project.setProject_budget(subDir + "/" + mBudgetImg.getOriginalFilename());
	    } else if (project.getProject_budget() != null && !project.getProject_budget().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_budget(project.getProject_budget());
	    } else {
	        project.setProject_budget("");
	    }
	    if (mScheduleImg != null && !mScheduleImg.getOriginalFilename().isEmpty()) {
	        project.setProject_schedule(subDir + "/" + mScheduleImg.getOriginalFilename());
	    } else if (project.getProject_schedule() != null && !project.getProject_schedule().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_schedule(project.getProject_schedule());
	    } else {
	        project.setProject_schedule("");
	    }
	    if (mInteteamInterducerduceImg != null && !mInteteamInterducerduceImg.getOriginalFilename().isEmpty()) {
	        project.setProject_team_introduce(subDir + "/" + mInteteamInterducerduceImg.getOriginalFilename());
	    } else if (project.getProject_team_introduce() != null && !project.getProject_team_introduce().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_team_introduce(project.getProject_team_introduce());
	    } else {
	        project.setProject_team_introduce("");
	    }
	    if (mSponsorImg != null && !mSponsorImg.getOriginalFilename().isEmpty()) {
	        project.setProject_sponsor(subDir + "/" + mSponsorImg.getOriginalFilename());
	    } else if (project.getProject_sponsor() != null && !project.getProject_sponsor().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	project.setProject_sponsor(project.getProject_sponsor());
	    } else {
	        project.setProject_sponsor("");
	    }
		
	    if (mCreatorImg != null && !mCreatorImg.getOriginalFilename().isEmpty()) {
	    	creator.setCreator_image(subDir2 + "/" + mCreatorImg.getOriginalFilename());
	    } else if (creator.getCreator_image() != null && !creator.getCreator_image().isEmpty()) {
	    	// 파일이 업로드되지 않은 경우: 기존 경로 유지
	    	creator.setCreator_image(creator.getCreator_image());
	    } else {
	    	creator.setCreator_image("");
	    }
	    
	    if (project.getFunding_premium() == 0) {	// Basic 요금제일 경우
	    	project.setProject_status("심사중");
		} else {	// Premium 일 경우 광고비 선결제 후 상태변경
			project.setProject_status("");
		}
		// 프로젝트 심사요청(update) - modifyProject 재활용
		int updateCount = service.modifyProject(project);
		
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(updateCount > 0) {
			try {
				// 업로드 파일들은 MultipartFile 객체에 의해 임시 저장공간에 저장되어 있으며
				// 글쓰기 작업 성공 시 임시 저장공간 -> 실제 디렉토리로 이동 작업 필요
				// => MultipartFile 객체의 transferTo() 메서드 호출하여 실제 위치로 이동 처리
				//    (파라미터 : java.io.File 타입 객체 전달)
				// => 단, 업로드 파일이 선택되지 않은 항목은 이동 대상에서 제외
				if(mProjectImg != null && !mProjectImg.getOriginalFilename().isEmpty()) {
					// File 객체 생성 시 생성자에 업로드 경로명과 파일명 전달
					mProjectImg.transferTo(new File(realPath, mProjectImg.getOriginalFilename()));
				}
				if(mIntroduceImg != null && !mIntroduceImg.getOriginalFilename().isEmpty()) {
					mIntroduceImg.transferTo(new File(realPath, mIntroduceImg.getOriginalFilename()));
				}
				if(mBudgetImg != null && !mBudgetImg.getOriginalFilename().isEmpty()) {
					mBudgetImg.transferTo(new File(realPath, mBudgetImg.getOriginalFilename()));
				}
				if(mScheduleImg != null && !mScheduleImg.getOriginalFilename().isEmpty()) {
					mScheduleImg.transferTo(new File(realPath, mScheduleImg.getOriginalFilename()));
				}
				if(mInteteamInterducerduceImg != null && !mInteteamInterducerduceImg.getOriginalFilename().isEmpty()) {
					mInteteamInterducerduceImg.transferTo(new File(realPath, mInteteamInterducerduceImg.getOriginalFilename()));
				}
				if(mSponsorImg != null && !mSponsorImg.getOriginalFilename().isEmpty()) {
					mSponsorImg.transferTo(new File(realPath, mSponsorImg.getOriginalFilename()));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		// 창작자 정보 저장(update) - modifyCreator 재활용
		int updateCount2 = service.modifyCreator(creator);
		
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(updateCount2 > 0) {
			try {
				if(mCreatorImg != null && !mCreatorImg.getOriginalFilename().isEmpty()) {
					mCreatorImg.transferTo(new File(realPath2, mCreatorImg.getOriginalFilename()));
				}
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
		System.out.println("updateCount : " + updateCount + ", updateCount2 : " + updateCount2);
		
		// 변경된 내용 저장 및 페이지 이동
		if (project.getFunding_premium() == 0) {	// Basic 요금제일 경우
			// 제출 완료 페이지로 이동
			return "redirect:/ProjectSubmit";
		} else {	// Premium 요금제일 경우
			// 결제 페이지로 이동
			return "redirect:/ProjectPayment?project_idx=" + project.getProject_idx();
		}
	}
	
	// 프로젝트 제출 시 광고비 선결제
	@GetMapping("ProjectPayment")
	public String projectPayment(HttpSession session, Model model, @RequestParam("project_idx") String project_idx) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "접근 권한이 없습니다.");
			return "result/fail";
		}
		
		System.out.println("project_idx : " + project_idx);
		// 프로젝트 정보 불러오기 - getProject 재활용
		ProjectVO project = service.getProject(project_idx);
		// 이름, 전화번호 불러오기
		MemberVO member  = service.getMemberInfo(id);
		
		model.addAttribute("project", project);
		model.addAttribute("member", member);
		return "project/project_premium_payment";
	}
	
	// 프로젝트 제출 완료 페이지
	@GetMapping("ProjectSubmit")
	public String projectSubmit(HttpSession session, Model model, @RequestParam Map<String, String> map) {
		String id = (String)session.getAttribute("sId");
		// 미로그인 시 로그인 페이지로 이동
		if(id == null) {
			model.addAttribute("msg", "접근 권한이 없습니다.");
			return "result/fail";
		}
		
		System.out.println("map : " + map);
		
		// 프리미엄 결제하고 온 경우 프로젝트 상태 심사중으로 변경
		if (map.get("payMethod") != null) {
			String project_idx = map.get("project_idx");
			int updateCount = service.modifyProjectStatus(project_idx);
			
			// 결제 내역 저장
			int insertCount = service.registPremiumPayment(map);
			if(updateCount > 0 && insertCount > 0) {
				System.out.println("결제 완료 및 프로젝트 제출됨.");
			}
		}
		
		return "project/project_submit";
	}
	
	
	// ===============================================================================
	// 내가만든 프로젝트
	@GetMapping("MyProject")
	public String myProject(HttpSession session, Model model) {
		String id = (String)session.getAttribute("sId");
		
		// 프로젝트 목록 조회
		String status = "";
		List<ProjectVO> projectList = service.getProjectList(id, status);
		model.addAttribute("projectList", projectList);
		
		// 프로젝트 취소 요청한 프로젝트 조회
		List<Map<String, String>> cancelList = service.getDeleteRequestList(id);
		model.addAttribute("cancelList", cancelList);
		
		
		
		return "mypage/my_project";
	}
	
	// 프로젝트 삭제
	@ResponseBody
	@PostMapping("DeleteProject")
	public String deleteProject(@RequestParam("project_idx") String project_idx) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		// 프로젝트 삭제 요청
		int deleteCount = service.deleteProject(project_idx);
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
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
	
	// 프로젝트 취소 요청
	@ResponseBody
	@PostMapping("RequestDeleteProject")
	public String requestDeleteProject(@RequestParam("project_idx") String project_idx, @RequestParam("project_cancel_reason") String project_cancel_reason) throws Exception {
		// JSON 타입으로 리턴 데이터를 생성을 편리하게 수행하기 위해 Map<String, Object> 객체 생성
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		System.out.println("project_idx : " + project_idx + ", project_cancel_reason : " + project_cancel_reason);
		
		// 프로젝트 삭제 요청 폼 제출
		int insertCount = service.requestDeleteProject(project_idx, project_cancel_reason);
		// 삭제 요청 처리 결과 판별
		// => 성공 시 resultMap 객체의 "result" 속성값을 true, 실패 시 false 로 저장
		if(insertCount > 0) {
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
	
}

