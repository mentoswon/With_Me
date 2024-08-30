package com.itwillbs.with_me.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.ItemVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.RewardVO;

@Mapper
public interface CreatorFundingMapper {

	// 프로젝트 목록 조회
	List<ProjectVO> selectProjectList(@Param("id") String id, @Param("status") String status);

	// 상위공통코드 FUND 인 컬럼(카테고리) 조회
	List<CommonCodeVO> selectCategory();

	// 세부 카테고리 조회
	List<CommonCodeVO> selectCategoryDetail(String project_category);

	// 창작자 정보 조회
	CreatorVO selectCreator(String id);

	// 창작자 정보 등록
	void insertCreator(String id);

	// 프로젝트 등록
	int insertProject(@Param("creator_idx") int creator_idx, 
					  @Param("project") ProjectVO project);
	
	// 프로젝트 번호 조회
	Integer selectProjectIdx(String id);

	// 프로젝트 정보 조회
	ProjectVO selectProject(String project_idx);

	// 아이템 등록
	int insertItem(Map<String, String> map);

	// 아이템 리스트 조회
	List<ItemVO> selectItemList(String project_idx);

	// 아이템 삭제
	int deleteItem(String item_idx);

	// 후원 구성 등록
	int insertReward(Map<String, String> map);

	// 후원 구성 리스트 조회
	List<HashMap<String, String>> selectRewardList(String project_idx);

	// 후원 구성 삭제
	int deleteReward(String reward_idx);

	// 프로젝트 임시저장
	int updateProject(ProjectVO project);

	// 창작자정보 임시저장
	int updateCreator(CreatorVO creator);



}