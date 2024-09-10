package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.ReportVO;
import com.itwillbs.with_me.vo.StoreVO;

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
	List<Map<String, Object>> selectProjectList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
												@Param("searchKeyword") String searchKeyword, @Param("projectStatus") String projectStatus);
	
	// 프로젝트 상세정보 조회
	Map<String, Object> selectProjectDetail(ProjectVO project);
	
	// 창작자 정보 조회
	CreatorVO selectCreator(Map<String, Object> projectInfo);
	
	// 프로젝트 상태 변경
	int updateProjectStatus(@Param("project") ProjectVO project, @Param("status") String status);
	
	// 프로젝트 취소 신청여부 조회
	ProjectCancelVO selectProjectCancel(ProjectVO project);
	
	// 프로젝트 취소 승인여부 변경
	int updateProjectCancelStatus(ProjectVO project);
	
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
	
	// 1:1문의 개수 조회
	int selectFAQListCount(String searchKeyword);
	
	// 1:1문의 목록 조회
	List<BoardVO> selectFAQList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
								@Param("searchKeyword") String searchKeyword);
	
	// 1:1문의 상세정보 조회
	BoardVO selectFAQDetail(BoardVO faq);
	
	// 1:1문의 답변 작성/수정
	int updateFAQReply(BoardVO faq);
	
	// 신고 개수 조회
	int selectReportListCount(String searchKeyword);
	
	// 신고 목록 조회
	List<ReportVO> selectReportList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
									@Param("searchKeyword") String searchKeyword);
	
	// 신고 상세정보 조회
	ReportVO selectReportDetail(ReportVO report);
	
	// 상품 상세정보 조회
	StoreVO selectProductDetail(StoreVO product);
	
	// 신고 상태 변경
	int updateReportState(ReportVO report);
	
}
