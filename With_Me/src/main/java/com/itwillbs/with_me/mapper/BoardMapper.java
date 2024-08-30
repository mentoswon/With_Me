package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.BoardVO;

@Mapper
public interface BoardMapper {
	
	// 게시물 등록
	int insertBoard(BoardVO bo);
	
	// 게시물 목록 조회 
	List<BoardVO> selectBoardList(
			@Param("searchType") String searchType, // searchType 변수의 파라미터명을 "searchType" 로 지정 
			@Param("searchKeyword") String searchKeyword, // searchKeyword 변수의 파라미터명을 "searchKeyword" 로 지정 
			@Param("startRow") int startRow, // startRow 변수의 파라미터명을 "startRow" 로 지정
			@Param("listLimit") int listLimit); // listLimit 변수의 파라미터명을 "listLimit" 로 지정

	// 전체 게시물 갯수 조회
	int selectBoardListCount(
			@Param("searchType") String searchType, 
			@Param("searchKeyword") String searchKeyword);

	
	// 공지사항 상세 조회
	BoardVO selectBoardDetail(int bo_idx);
	void updateReadcount(BoardVO bo);
	
	//공지사항 삭제
	int deleteBoard(int bo_idx);
	
	//공지사항 수정
	int updateBoard(BoardVO bo);
	
	//공지사항 파일 삭제
	int deleteBoFile(Map<String, String> map);

}
