package com.itwillbs.with_me.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.CommonCodeVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Mapper
public interface CreatorFundingMapper {

	// 작성중인 프로젝트 목록 조회
	ProjectVO selectProjectList(String id);

	// 상위공통코드 FUND 인 컬럼(카테고리) 조회
	List<CommonCodeVO> selectCategory();

	// 세부 카테고리 조회
	List<CommonCodeVO> selectCategoryDetail(String project_category);

	// 창작자 정보 조회
	String selectCreator(String id);

	// 창작자 정보 등록
	void insertCreator(String id);

	// 프로젝트 등록
	int insertProject(@Param("creator_idx") String creator_idx, 
					  @Param("project") ProjectVO project);
	
	// 프로젝트 번호 조회
	Integer selectProjectIdx(String id);

	// 프로젝트 정보 조회
	ProjectVO selectProject(Integer project_idx);



}