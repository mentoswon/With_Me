package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.SponsorVO;

public interface UserFundingMapper {

	// 리스트 목록 개수 가져오기
	int selectBoardListCount(@Param("searchKeyword") String searchKeyword, 
							 @Param("category")String category, 
							 @Param("category_detail")String category_detail);
	
	
	// 리스트 가져오기
	List<Map<String, Object>> selectProjectList(@Param("category")String category,
												@Param("category_detail")String category_detail,
												@Param("searchKeyword")String searchKeyword, 
												@Param("startRow")int startRow, 
												@Param("listLimit")int listLimit);


	// 프로젝트 상세정보 가져오기
	Map<String, Object> selectProject(String project_code);


	// 팔로워 수 계산
	int countFollower(String creator_email);

	// 후원 리워드 리스트
	List<SponsorVO> selectSponsorList(int project_idx);

	// 창작자에 등록되어있는지
	String selectCreatorName(String mem_email);

	// 창작자가 아닌 사람 정보 가져오기
	MemberVO selectMemberInfo(String mem_email);
	






}
