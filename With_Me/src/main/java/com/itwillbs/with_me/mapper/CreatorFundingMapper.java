package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.ProjectVO;

@Mapper
public interface CreatorFundingMapper {

	// 작성중인 프로젝트 목록 조회
	ProjectVO selectProjectList(String id);

}
