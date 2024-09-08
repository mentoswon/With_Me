package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Mapper
public interface AdminAccountMapper {
	
	// 프로젝트 개수 조회
	int selectAccountListCount(@Param("searchKeyword") String searchKeyword, @Param("accountStatus") String accountStatus);
	
	// 프로젝트 목록 조회
	List<Map<String, Object>> selectAccountList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
												@Param("searchKeyword") String searchKeyword, @Param("accountStatus") String accountStatus);

	// 해당 프로젝트에 후원하는 후원자 수 조회
	int selectUserAccountListCount(@Param("searchKeyword") String searchKeyword, @Param("project_code") String project_code);

	// 해당 프로젝트에 후원하는 후원자 목록 조회
	List<Map<String, Object>> selectUserAccountList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
													@Param("searchKeyword") String searchKeyword, @Param("project_code") String project_code);

	
}
