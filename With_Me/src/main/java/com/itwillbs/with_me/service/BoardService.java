package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.itwillbs.with_me.mapper.BoardMapper;
import com.itwillbs.with_me.vo.BoardVO;

@Service
public class BoardService {
	@Autowired
	private BoardMapper mapper;
	
	
	// 공지사항 등록 요청
	public int applyBoard(BoardVO bo) {
		return mapper.insertBoard(bo);
	}
	
	
	// 공지사항 총 갯수 조회 요청
	public int getBoardListCount(String searchType, String searchKeyword) {
		return mapper.selectBoardListCount(searchType, searchKeyword);
	}
	
	// 공지사항 목록 조회 요청
	public List<BoardVO> getBoardList(String searchType, String searchKeyword, int startRow, int listLimit) {
		return mapper.selectBoardList(searchType, searchKeyword, startRow, listLimit);
	}

	// 공지사항 상세 조회
	public BoardVO getBoardDetail(int bo_idx, boolean theIncreaseReadcount) {
		BoardVO bo = mapper.selectBoardDetail(bo_idx);
		// BoardMapper - updateReadcount() 메서드 호출하여 해당 게시물의 조회수 증가
		if(bo != null && theIncreaseReadcount) {
			// 단, 조회수 증가된 게시물 번호를 전달받기 위해 글번호가 저장된 BoardVO 객체 전달
			mapper.updateReadcount(bo);
			// => Mapper 에서 조회수 증가 작업 후 BoardVO 객체에 증가된 조회수 값 저장했을 경우
			//    별도의 리턴 과정이 없어도 동일한 주소값을 갖는 BoardVO 객체를 공유하므로
			//    변경된 조회수 값의 영향을 동일하게 받는다!
			// => 즉, 동일한 객체를 공유하기 때문에 사용하는 값도 동일함(= 변경된 값도 동일)
		}
		return bo;
	}
	
	
	//공지사항 삭제
		public int deleteBoard(int bo_idx) {
			return mapper.deleteBoard(bo_idx);
		}


	
	//공지사항 수정
	public int modifyBoard(BoardVO bo) {
		return mapper.updateBoard(bo);
	}
		
	//공지사항 파일 삭제
	public int removeBoFile(Map<String, String> map) {
		return mapper.deleteBoFile(map);
	}

	
	
// ===========================================================================================
	// 1:1문의 게시
	
	// 1:1문의 등록 요청
	public int applyQnaBoard(BoardVO qnabo) {
		
		return mapper.insertQnaBoard(qnabo);
	}

	// 1:1문의 게시글 갯수 조회 요청
	public int getQnaBoardListCount(String searchType, String searchKeyword) {
		
		return mapper.selectQnaBoardListCount(searchType, searchKeyword);
	}

	// 1:1문의 게시글 목록 조회 요청
	public List<BoardVO> getQnaBoardList(String searchType, String searchKeyword, int startRow, int listLimit) {
		
		return mapper.selectQnaBoardList(searchType, searchKeyword, startRow, listLimit);
	}

	// 1:1문의 게시글 상세 조회 요청
	public BoardVO getQnaBoardDetail(int faq_idx, boolean theIncreaseReadcount) {
		BoardVO qnabo = mapper.selectQnaBoardDetail(faq_idx);
		// BoardMapper - updateReadcount() 메서드 호출하여 해당 게시물의 조회수 증가
//		if(qnabo != null && theIncreaseReadcount) {
//			// 단, 조회수 증가된 게시물 번호를 전달받기 위해 글번호가 저장된 BoardVO 객체 전달
//			mapper.updateQnaReadcount(qnabo);
//			// => Mapper 에서 조회수 증가 작업 후 BoardVO 객체에 증가된 조회수 값 저장했을 경우
//			//    별도의 리턴 과정이 없어도 동일한 주소값을 갖는 BoardVO 객체를 공유하므로
//			//    변경된 조회수 값의 영향을 동일하게 받는다!
//			// => 즉, 동일한 객체를 공유하기 때문에 사용하는 값도 동일함(= 변경된 값도 동일)
//		}
		return qnabo;
		
		
		
		
		
	}

	// 1:1문의 게시글 삭제 요청
	public int qnaDeleteBoard(int bo_idx) {
		
		return mapper.qnaDeleteBoard(bo_idx);
	}

	// 1:1문의 게시글 수정 요청
	public int qnaModifyBoard(BoardVO qnabo) {
		
		return mapper.qnaUpdateBoard(qnabo);
	}


	public int removeQnaBoFile(Map<String, String> map) {
		
		return mapper.deleteQnaBoFile(map);
	}
	
	
	// 답글 등록 요청
	// => 순서번호 조정 작업과 답글 등록 작업 두 가지의 DB 데이터 조작 작업을 차례대로 수행하는데
	//    이 때, 두 작업에 대한 트랜잭션을 적용하기 위해 @Transactional 어노테이션 적용 필수!
	//    (주의! root-context.xml 과 servlet-context.xml 파일에 트랜잭션 설정 필수!)
	//    별도로 개발자가 commit 또는 rollback 명령을 내릴 필요 없이 자동으로 처리됨!
	@Transactional
	public int registReplyBoard(BoardVO board) {
		// 기존 답글들의 순서번호 조정을 위해 updateBoardReSeq() 메서드 호출
		// => 파라미터 : BoardVO 객체   리턴타입 : void
		mapper.updateBoardReSeq(board);
		
		// 답글 등록 작업 위해 insertReplyBoard() 메서드 호출
		// => 파라미터 : BoardVO 객체   리턴타입 : int
		return mapper.insertReplyBoard(board);
	}
	
	
	
	
	
	
	
	
	
	
}
