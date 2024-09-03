package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
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
	int selectSponsorshipHistoryListCount(@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 후원내역 조회
	List<Map<String, Object>> selectSponsorshipHistory(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
													@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 구매내역 개수 조회
	int selectPurchaseHistoryListCount(@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 구매내역 조회
	List<Map<String, Object>> selectPurchaseHistory(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
													@Param("searchKeyword") String searchKeyword, @Param("member") MemberVO member);
	
	// 프로젝트 개수 조회
	int selectProjectListCount(@Param("searchKeyword") String searchKeyword, @Param("projectStatus") String projectStatus);
	
	// 프로젝트 목록 조회
	List<ProjectVO> selectProjectList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
									@Param("searchKeyword") String searchKeyword, @Param("projectStatus") String projectStatus);
	
	// 프로젝트 상태 변경
	int updateProjectStatus(@Param("project") ProjectVO project, @Param("status") String status);
	
	// 프로젝트 취소 신청여부 조회
	ProjectCancelVO selectProjectCancel(int project_idx);
	
	// 프로젝트 취소 승인여부 변경
	int updateProjectCancelStatus(@Param("project") ProjectVO project);
	
	// 공지사항 개수 조회
	int selectNoticeListCount(String searchKeyword);
	
	// 공지사항 목록 조회
	List<BoardVO> selectNoticeList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
								@Param("searchKeyword") String searchKeyword);
	// 공지사항 등록
	int insertNotice(BoardVO notice);
	
	// 공지사항 수정 - 파일 삭제
	int deleteFile(BoardVO notice);
	
	// 공지사항 수정
	int updateNotice(BoardVO notice);
	
	// 공지사항 삭제
	int deleteNotice(int bo_idx);
	
}
