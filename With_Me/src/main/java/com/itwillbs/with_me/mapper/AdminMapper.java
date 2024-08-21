package com.itwillbs.with_me.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Mapper
public interface AdminMapper {
	
	// 회원 목록 개수 조회
	int selectMemberListCount(String searchKeyword);
	
	// 회원 목록 조회
	List<MemberVO> selectMemberList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
									@Param("searchKeyword") String searchKeyword);
	
	// 관리자 권한 부여/해제
	int updateAdminAuth(MemberVO member);
	
	// 후원내역 개수 조회
	int selectSponsorshipDetailListCount(String searchKeyword);
	
	// 후원내역 조회
	List<String> selectSponsorshipDetail(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
										@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 구매내역 개수 조회
	int selectPurchaseHistoryListCount(String searchKeyword);
	
	// 구매내역 조회
	List<String> selectPurchaseHistory(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
										@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 프로젝트 개수 조회
	int selectProjectListCount(@Param("searchKeyword") String searchKeyword, @Param("projectStatus") String projectStatus);
	
	// 프로젝트 목록 조회
	List<ProjectVO> selectProjectList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
										@Param("searchKeyword") String searchKeyword, @Param("projectStatus") String projectStatus);
	
	// 프로젝트 등록 승인/거부
	int updateProjectStatus(@Param("project") ProjectVO project, @Param("isAuthorize") String isAuthorize);
	
}
