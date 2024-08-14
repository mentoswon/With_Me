package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.ProjectVO;

public interface UserFundingMapper {

	// 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, @Param("category")String category);
	
	
	// 리스트 가져오기
	List<Map<String, Object>> selectProjectList(@Param("category")String category,
												  @Param("searchKeyword")String searchKeyword, 
												  @Param("startRow")int startRow, 
												  @Param("listLimit")int listLimit);


	// 프로젝트 상세정보 가져오기
	Map<String, Object> selectProject(String project_code);


	// 팔로워 수 계산
	int countFollower(String creator_email);
	






}
