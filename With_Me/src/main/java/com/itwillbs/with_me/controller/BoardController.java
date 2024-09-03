package com.itwillbs.with_me.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.itwillbs.with_me.service.BoardService;
import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PageInfo;

@Controller
public class BoardController {
	@Autowired
	private BoardService service;
	// 가상의 경로명 저장(이클립스 프로젝트 상의 경로)
	private String uploadPath = "/resources/upload";
	
	
	@GetMapping("BoardWrite")
	public String boardmanagerWriteForm(HttpSession session, Model model, HttpServletRequest request) {
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			String prevURL = request.getServletPath();
			if(request.getQueryString() != null) {
				prevURL += "?" + request.getQueryString();
			}
			session.setAttribute("prevURL", prevURL);
			return "result/fail";
		}
		
		return "board/board_write_form";
	}
	
// [ 글쓰기 비즈니스 로직 처리 ] 
	@PostMapping("BoardWrite")
	public String boardmanagerWritePro(BoardVO bo, HttpServletRequest request, HttpSession session, Model model) {
		System.out.println(bo);
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		LocalDate today = LocalDate.now();
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		realPath += "/" + subDir;
		try {
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// --------------------------------------------------------------------------------------
		// [ 업로드 되는 실제 파일 처리 ]
		MultipartFile mFile1 = bo.getFile();
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		System.out.println("원본파일명1 : " + mFile1.getOriginalFilename());
		// [ 파일명 중복 방지 대책 ]
		String fileName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile1.getOriginalFilename();
		bo.setBo_file("");
		if(!mFile1.getOriginalFilename().equals("")) {
			bo.setBo_file(subDir + "/" + fileName1);
		}
		
		// BoardService - registBoard() 메서드 호출하여 게시물 등록 작업 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(insertCount)
		int insertCount = service.applyBoard(bo);
		
		// 게시물 등록 작업 요청 결과 판별
		if(insertCount > 0) { // 성공
			try {
				if(!mFile1.getOriginalFilename().equals("")) {
					mFile1.transferTo(new File(realPath, fileName1));
				}
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			// 글목록(BoardList) 서블릿 주소 리다이렉트
			return "redirect:/BoardListManage";
		} else { 
			// "글쓰기 실패!" 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "글쓰기 실패!");
			return "result/fail";
		}
//			return "";
	}
	
	
	
	// 공지사항 게시글 목록 페이지
	@GetMapping("BoardList")
	public String boardList(
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "1") int pageNum, 
			Model model) {
//		System.out.println("검색타입 : " + searchType);
//		System.out.println("검색어 : " + searchKeyword);
//		System.out.println("페이지번호 : " + pageNum);			
		// --------------------------------------------------------------------
		// 페이징 처리를 위해 조회 목록 갯수 조절에 사용될 변수 선언
		int listLimit = 5;
		int startRow = (pageNum - 1) * listLimit; // 조회할 게시물의 행 번호
		
		// 페이징 처리를 위한 계산 작업
		int listCount = service.getBoardListCount(searchType, searchKeyword);
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
		// --------------------------------------------------------------------
		// 전달받은 페이지번호가 1보다 작거나 최대 페이지번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동하도록 처리
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "BoardList?pageNum=1");
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// BoardService - getBoardList() 메서드 호출하여 게시물 목록 조회 요청
		// => 파라미터 : 검색타입, 검색어, 시작행번호, 게시물 수
		// => 리턴타입 : List<BoardVO>(boardList)
		List<BoardVO> boardList = service.getBoardList(searchType, searchKeyword, startRow, listLimit);
//		System.out.println(boardList);
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		// 게시물 목록과 페이징 정보를 Model 객체에 저장
		model.addAttribute("boardList", boardList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "board/board_list";
		
	}
	
	// 공지사항 게시글 상세 페이지 
	@GetMapping("BoardDetail")
	public String boardDetail(int bo_idx, Model model) {
		BoardVO bo = service.getBoardDetail(bo_idx, true);
//		System.out.println("제발 좀 떠봐라 임마 : " + bo);
		if(bo == null) {
			model.addAttribute("msg", "존재하지 않는 게시물입니다");
			return "result/fail";
		}
		model.addAttribute("bo", bo);
		return "board/board_detail";
	}
	
	// 공지사항 리스트 삭제
	@GetMapping("BoardDelete")
	public String boardDelete(
			int bo_idx, @RequestParam(defaultValue = "1") int pageNum,
			HttpSession session, Model model) throws Exception {
//				System.out.println("board_num : " + board_num);
//				System.out.println("pageNum : " + pageNum);
		
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "관리자 권한 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------------
		// 게시물 삭제 시 실제 업로드 된 파일도 삭제해야하므로 
		// DB 에서 게시물 정보 삭제 전 파일명을 미리 조회하기 위해
		// BoardService - getBoard() 메서드 재사용하여 게시물 상세정보 조회 요청
		// => 주의! 조회수 증가되지 않도록 두번째 파라미터값 false 값 전달
		BoardVO bo = service.getBoardDetail(bo_idx, false);
//				System.out.println(board);
		
		// 게시물이 존재하지 않거나, 조회된 게시물의 작성자가 자신이 아닐 경우
		// "잘못된 접근입니다!" 출력 및 이전 페이지 돌아가기 처리
		// => 조회된 게시물의 작성자 판별 시 세션 아이디와 비교
		if(bo == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// BoardService - removeBoard() 메서드 호출하여 글 삭제 작업 요청
		// => 파라미터 : 글번호   리턴타입 : int(deleteCount)
		int deleteCount = service.deleteBoard(bo_idx);
		
		// 삭제 결과 판별하여 처리
		if(deleteCount > 0) {
			// --------------------------------------------------------------------
			// DB에서 게시물 정보 삭제 완료 시 실제 업로드 된 파일 삭제 처리 추가
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			
//					System.out.println("삭제할 파일명1 : " + board.getBoard_file1());
//					System.out.println("삭제할 파일명2 : " + board.getBoard_file2());
//					System.out.println("삭제할 파일명3 : " + board.getBoard_file3());
			// 파일 삭제에 사용될 파일명(최대 3개)를 List 또는 배열에 저장하여 처리 코드 중복 제거
			
			model.addAttribute("msg", "삭제 성공!");
			model.addAttribute("targetURL", "BoardListManage?pageNum=" + pageNum);
			return "result/success";
		} else {
			model.addAttribute("msg", "삭제 실패!");
			return "result/fail";
		}
		
	}
	
	// [ 글 수정 ]
	@GetMapping("BoardModify")
	public String boardModifyForm(int bo_idx, HttpSession session, Model model) {
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "관리자 권한 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------
		// BoardService - getBoard() 메서드 재사용하여 게시물 1개 정보 조회
		// => 조회수 증가되지 않도록 두번째 파라미터값 false 값 전달
		BoardVO bo = service.getBoardDetail(bo_idx, false);
//				System.out.println(board);
		
		// 게시물이 존재하지 않거나, 
		// 조회된 게시물의 작성자(board_name) 와 세션아이디가 다를 경우
		// "잘못된 접근입니다!" 출력 후 이전페이지로 돌아가기 처리
		if(bo == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			return "result/fail";
		}
		
		// 조회 결과 게시물 정보 저장
		model.addAttribute("bo", bo);
		
		
		return "board/board_manager_modify_form";
	}
	
	// [ 공지사항 수정 ]
	@PostMapping("BoardModify")
	public String boardModifyPro(
			BoardVO bo,
			@RequestParam(defaultValue = "1") String pageNum,
			HttpSession session, Model model) throws Exception {
		System.out.println(bo);
		
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
		System.out.println("path가 나오는지 확인해봅시다 : " + path);
		// ------------------------------------------------------------------
		Files.createDirectories(path);
		//파일명 중복 방지
		MultipartFile mFile1 = bo.getFile();
		 if (mFile1 == null) {
		        model.addAttribute("msg", "업로드된 파일이 없습니다.");
		        return "result/fail";
		    }else if(mFile1.getOriginalFilename().equals("")) {
		    	model.addAttribute("msg", "업로드된 파일이 없습니다2.");
		    	return "result/fail";
		    }
		 
		String fileName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile1.getOriginalFilename();
		bo.setBo_file("");
		System.out.println("과연 이것도 나올가요? : " + mFile1.getOriginalFilename());
		if(!mFile1.getOriginalFilename().equals("")) {
			bo.setBo_file(subDir + "/" + fileName1);
		}
		
		System.out.println("사진 수정이 왜 안될까요? : " + bo);
		
		
		int updateCount = service.modifyBoard(bo);
		
		// DB 작업 요청 처리 결과 판별하여
		// 성공 시 실제 파일 업로드 처리 후 글 상세정보 조회 페이지 리다이렉트
		// 실패 시 "글 수정 실패!" 출력 후 이전페이지 돌아가기 처리
		 if (updateCount > 0) {
		        try {
		            // 수정된 부분: 파일 업로드 과정에서 발생할 수 있는 예외 처리
		            mFile1.transferTo(new File(realPath, fileName1));
		        } catch (IllegalStateException | IOException e) {
		            e.printStackTrace();
		            model.addAttribute("msg", "파일 업로드 중 오류 발생!");
		            return "result/fail";
		        }
		        return "redirect:/BoardDetail?bo_idx=" + bo.getBo_idx() + "&pageNum=" + pageNum;
		    } else {
		        model.addAttribute("msg", "글 수정 실패!");
		        return "result/fail";
		    }
		
	}
	//공지사항 수정 파일 삭제
	@GetMapping("BoardDeleteFile")
	public String boardDeleteFile(@RequestParam Map<String, String> map, HttpSession session) throws Exception {
		System.out.println("진성민의 마지막 어택 : " + map);
		int deleteCount = service.removeBoFile(map);
		if(deleteCount>0) {
			String realPath = session.getServletContext().getRealPath(uploadPath);
			if(!map.get("bo_file").equals("")) {
				Path path = Paths.get(realPath, map.get("bo_file"));
				Files.deleteIfExists(path);
			}
		}
		
		return"redirect:/BoardModify?bo_idx=" + map.get("bo_idx");
	}
	
	//========================================================================

	
	
	
	//========================================================================
	// 1대1 문의게시글
	
	@GetMapping("QnaBoardWrite")
	public String qnaboardWriteForm(HttpSession session, Model model, HttpServletRequest request) {
		if(session.getAttribute("sId") == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			String prevURL = request.getServletPath();
			if(request.getQueryString() != null) {
				prevURL += "?" + request.getQueryString();
			}
			session.setAttribute("prevURL", prevURL);
			return "result/fail";
		}
		
		return "board/qna_write_form";
	}
	
// [ 글쓰기 비즈니스 로직 처리 ] 
	@PostMapping("QnaBoardWrite")
	public String qnaboardWritePro(BoardVO qnabo, HttpServletRequest request, HttpSession session, Model model) {
		System.out.println(qnabo);
		String realPath = session.getServletContext().getRealPath(uploadPath); // 가상의 경로 전달
		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
		LocalDate today = LocalDate.now();
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
		realPath += "/" + subDir;
		try {
			Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
			Files.createDirectories(path);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		// --------------------------------------------------------------------------------------
		// [ 업로드 되는 실제 파일 처리 ]
		MultipartFile mFile1 = qnabo.getFile();
		// MultipartFile 객체의 getOriginalFile() 메서드 호출 시 업로드 한 원본 파일명 리턴
		System.out.println("원본파일명1 : " + mFile1.getOriginalFilename());
		// [ 파일명 중복 방지 대책 ]
		String fileName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile1.getOriginalFilename();
		qnabo.setBo_file("");
		if(!mFile1.getOriginalFilename().equals("")) {
			qnabo.setBo_file(subDir + "/" + fileName1);
		}
		
		// BoardService - registBoard() 메서드 호출하여 게시물 등록 작업 요청
		// => 파라미터 : BoardVO 객체   리턴타입 : int(insertCount)
		int insertCount = service.applyQnaBoard(qnabo);
		
		// 게시물 등록 작업 요청 결과 판별
		if(insertCount > 0) { // 성공
			try {
				if(!mFile1.getOriginalFilename().equals("")) {
					mFile1.transferTo(new File(realPath, fileName1));
				}
				
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			
			// 글목록(BoardList) 서블릿 주소 리다이렉트
			return "redirect:/QnaBoardList";
		} else { 
			// "글쓰기 실패!" 메세지 출력 및 이전 페이지 돌아가기 처리
			model.addAttribute("msg", "글쓰기 실패!");
			return "result/fail";
		}
//			return "";
	}
	
	
	
	// 1:1문의 게시글 목록 페이지
	@GetMapping("QnaBoardList")
	public String qnaBoardList(
			@RequestParam(defaultValue = "") String searchType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "1") int pageNum, 
			Model model) {
//		System.out.println("검색타입 : " + searchType);
//		System.out.println("검색어 : " + searchKeyword);
//		System.out.println("페이지번호 : " + pageNum);			
		// --------------------------------------------------------------------
		// 페이징 처리를 위해 조회 목록 갯수 조절에 사용될 변수 선언
		int listLimit = 5;
		int startRow = (pageNum - 1) * listLimit; // 조회할 게시물의 행 번호
		
		// 페이징 처리를 위한 계산 작업
		int listCount = service.getQnaBoardListCount(searchType, searchKeyword);
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
		// --------------------------------------------------------------------
		// 전달받은 페이지번호가 1보다 작거나 최대 페이지번호보다 클 경우
		// "해당 페이지는 존재하지 않습니다!" 출력 및 1페이지로 이동하도록 처리
		if(pageNum < 1 || pageNum > maxPage) {
			model.addAttribute("msg", "해당 페이지는 존재하지 않습니다!");
			model.addAttribute("targetURL", "QnaBoardList?pageNum=1");
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// BoardService - getBoardList() 메서드 호출하여 게시물 목록 조회 요청
		// => 파라미터 : 검색타입, 검색어, 시작행번호, 게시물 수
		// => 리턴타입 : List<BoardVO>(boardList)
		List<BoardVO> QnaBoardList = service.getQnaBoardList(searchType, searchKeyword, startRow, listLimit);
//		System.out.println(boardList);
		// --------------------------------------------------------------------
		PageInfo pageInfo = new PageInfo(listCount, pageListLimit, maxPage, startPage, endPage);
		// --------------------------------------------------------------------
		// 게시물 목록과 페이징 정보를 Model 객체에 저장
		model.addAttribute("QnaBoardList", QnaBoardList);
		model.addAttribute("pageInfo", pageInfo);
		
		return "board/qna_list";
		
	}
	
	// 1:1 문의 게시글 상세 페이지 
	@GetMapping("QnaBoardDetail")
	public String qnaBoardDetail(int faq_idx, Model model) {
		BoardVO qnabo = service.getQnaBoardDetail(faq_idx, true);
//		System.out.println("제발 좀 떠봐라 임마 : " + bo);
		if(qnabo == null) {
			model.addAttribute("msg", "존재하지 않는 게시물입니다");
			return "result/fail";
		}
		model.addAttribute("qnabo", qnabo);
		return "board/qna_detail";
	}
	
	// 1:1문의 게시글 리스트 삭제
	@GetMapping("QnaBoardDelete")
	public String qnaBoardDelete(
			int bo_idx, @RequestParam(defaultValue = "1") int pageNum,
			HttpSession session, Model model) throws Exception {
//				System.out.println("board_num : " + board_num);
//				System.out.println("pageNum : " + pageNum);
		
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "로그인 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------------
		// 게시물 삭제 시 실제 업로드 된 파일도 삭제해야하므로 
		// DB 에서 게시물 정보 삭제 전 파일명을 미리 조회하기 위해
		// BoardService - getBoard() 메서드 재사용하여 게시물 상세정보 조회 요청
		// => 주의! 조회수 증가되지 않도록 두번째 파라미터값 false 값 전달
		BoardVO qnabo = service.getQnaBoardDetail(bo_idx, false);
//				System.out.println(board);
		
		// 게시물이 존재하지 않거나, 조회된 게시물의 작성자가 자신이 아닐 경우
		// "잘못된 접근입니다!" 출력 및 이전 페이지 돌아가기 처리
		// => 조회된 게시물의 작성자 판별 시 세션 아이디와 비교
		if(qnabo == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			return "result/fail";
		}
		// --------------------------------------------------------------------
		// BoardService - removeBoard() 메서드 호출하여 글 삭제 작업 요청
		// => 파라미터 : 글번호   리턴타입 : int(deleteCount)
		int deleteCount = service.qnaDeleteBoard(bo_idx);
		
		// 삭제 결과 판별하여 처리
		if(deleteCount > 0) {
			// --------------------------------------------------------------------
			// DB에서 게시물 정보 삭제 완료 시 실제 업로드 된 파일 삭제 처리 추가
			// 실제 업로드 경로 알아내기
			String realPath = session.getServletContext().getRealPath(uploadPath);
			
//					System.out.println("삭제할 파일명1 : " + board.getBoard_file1());
//					System.out.println("삭제할 파일명2 : " + board.getBoard_file2());
//					System.out.println("삭제할 파일명3 : " + board.getBoard_file3());
			// 파일 삭제에 사용될 파일명(최대 3개)를 List 또는 배열에 저장하여 처리 코드 중복 제거
			
			model.addAttribute("msg", "삭제 성공!");
			model.addAttribute("targetURL", "QnaBoardList?pageNum=" + pageNum);
			return "result/success";
		} else {
			model.addAttribute("msg", "삭제 실패!");
			return "result/fail";
		}
		
	}
	
	// [ 글 수정 ]
	@GetMapping("QnaBoardModify")
	public String qnaboardModifyForm(int faq_idx, HttpSession session, Model model) {
		// 미 로그인 처리
		String id = (String)session.getAttribute("sId");
		if(id == null) {
			model.addAttribute("msg", "관리자 권한 필수!");
			model.addAttribute("targetURL", "MemberLogin");
			return "result/fail";
		}
		// ----------------------------------------------------------------
		// BoardService - getBoard() 메서드 재사용하여 게시물 1개 정보 조회
		// => 조회수 증가되지 않도록 두번째 파라미터값 false 값 전달
		BoardVO qnabo = service.getQnaBoardDetail(faq_idx, false);
//				System.out.println(board);
		
		// 게시물이 존재하지 않거나, 
		// 조회된 게시물의 작성자(board_name) 와 세션아이디가 다를 경우
		// "잘못된 접근입니다!" 출력 후 이전페이지로 돌아가기 처리
		if(qnabo == null) {
			model.addAttribute("msg", "잘못된 접근입니다!");
			return "result/fail";
		}
		
		// 조회 결과 게시물 정보 저장
		model.addAttribute("qnabo", qnabo);
		
		
		return "board/qna_modify_form";
	}
	
	// [ 1:1문의 게시글 수정 ]
	@PostMapping("QnaBoardModify")
	public String qnaboardModifyPro(
			BoardVO qnabo,
			@RequestParam(defaultValue = "1") String pageNum,
			HttpSession session, Model model) throws Exception {
		System.out.println(qnabo);
		
//		//실제 업로드 경로 알아내기
//		String realPath = session.getServletContext().getRealPath(uploadPath);
//		
//		// 날짜별 서브디렉토리 생성하여 기본 경로에 결합
//		String subDir = ""; // 하위 디렉토리명을 저장할 변수 선언
//		LocalDate today = LocalDate.now();
		String datePattern = "yyyy/MM/dd"; // 형식 변경에 사용할 패턴 문자열 지정
		DateTimeFormatter dtf = DateTimeFormatter.ofPattern(datePattern);
//		subDir = today.format(dtf); // LocalDate - DateTimeFormatter
//		realPath += "/" + subDir;
//		Path path = Paths.get(realPath); // 파라미터로 실제 업로드 경로 전달
//		System.out.println("path가 나오는지 확인해봅시다 : " + path);
//		// ------------------------------------------------------------------
//		Files.createDirectories(path);
//		//파일명 중복 방지
//		MultipartFile mFile1 = qnabo.getFile();
//		 if (mFile1 == null) {
//		        model.addAttribute("msg", "업로드된 파일이 없습니다.");
//		        return "result/fail";
//		    }else if(mFile1.getOriginalFilename().equals("")) {
//		    	model.addAttribute("msg", "업로드된 파일이 없습니다2.");
//		    	return "result/fail";
//		    }
//		 
//		String fileName1 = UUID.randomUUID().toString().substring(0, 8) + "_" + mFile1.getOriginalFilename();
//		qnabo.setBo_file("");
//		System.out.println("과연 이것도 나올가요? : " + mFile1.getOriginalFilename());
//		if(!mFile1.getOriginalFilename().equals("")) {
//			qnabo.setBo_file(subDir + "/" + fileName1);
//		}
//		
		System.out.println("사진 수정이 왜 안될까요? : " + qnabo);
		
		
		int updateCount = service.qnaModifyBoard(qnabo);
		System.out.println("updateCount : " + updateCount);
		// DB 작업 요청 처리 결과 판별하여
		// 성공 시 실제 파일 업로드 처리 후 글 상세정보 조회 페이지 리다이렉트
		// 실패 시 "글 수정 실패!" 출력 후 이전페이지 돌아가기 처리
		 if (updateCount > 0) {
//		        try {
//		            // 수정된 부분: 파일 업로드 과정에서 발생할 수 있는 예외 처리
//		            mFile1.transferTo(new File(realPath, fileName1));
//		        } catch (IllegalStateException | IOException e) {
//		            e.printStackTrace();
//		            model.addAttribute("msg", "파일 업로드 중 오류 발생!");
//		            return "result/fail";
//		        }
		        return "redirect:/QnaBoardDetail?faq_idx=" + qnabo.getFaq_idx() + "&pageNum=" + pageNum;
		 } else {
	        model.addAttribute("msg", "글 수정 실패!");
	        return "result/fail";
		 }
		
	}
	//공지사항 수정 파일 삭제
	@GetMapping("QnaBoardDeleteFile")
	public String qnaboardDeleteFile(@RequestParam Map<String, String> map, HttpSession session) throws Exception {
		System.out.println("진성민의 마지막 어택 : " + map);
		int deleteCount = service.removeQnaBoFile(map);
		if(deleteCount>0) {
			String realPath = session.getServletContext().getRealPath(uploadPath);
			if(!map.get("bo_file").equals("")) {
				Path path = Paths.get(realPath, map.get("bo_file"));
				Files.deleteIfExists(path);
			}
		}
		
		return"redirect:/BoardModify?bo_idx=" + map.get("bo_idx");
	}
	
	
	
	
	
	

	
}
