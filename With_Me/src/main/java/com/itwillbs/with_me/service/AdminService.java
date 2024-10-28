package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminMapper;
import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.PremiumPaymentVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.ReportVO;
import com.itwillbs.with_me.vo.StoreVO;

@Service
public class AdminService {
	@Autowired
	private AdminMapper mapper;
	
	// 회원 목록 개수 조회
	public int getMemberListCount(String searchKeyword) {
		return mapper.selectMemberListCount(searchKeyword);
	}
	
	// 회원 목록 조회
	public List<MemberVO> getMemberList(int startRow, int listLimit, String searchKeyword) {
		return mapper.selectMemberList(startRow, listLimit, searchKeyword);
	}
	
	// 관리자 권한 부여/해제
	public int changeAdminAuth(MemberVO member) {
		return mapper.updateAdminAuth(member);
	}
	
	// 후원내역 개수 조회
	public int getSponsorshipHistoryListCount(String searchKeyword, MemberVO member) {
		return mapper.selectSponsorshipHistoryListCount(searchKeyword, member);
	}
	
	// 후원내역 조회
	public List<Map<String, Object>> getSponsorshipHistory(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectSponsorshipHistory(startRow, listLimit, searchKeyword, member);
	}
	
	// 구매내역 개수 조회
	public int getPurchaseHistoryListCount(String searchKeyword, MemberVO member) {
		return mapper.selectPurchaseHistoryListCount(searchKeyword, member);
	}
	
	// 구매내역 조회
	public List<Map<String, Object>> getPurchaseHistory(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectPurchaseHistory(startRow, listLimit, searchKeyword, member);
	}
	
	// 프로젝트 개수 조회
	public int getProjectListCount(String searchKeyword, String projectStatus) {
		return mapper.selectProjectListCount(searchKeyword, projectStatus);
	}
	
	// 프로젝트 목록 조회
	public List<Map<String, Object>> getProjectList(int startRow, int listLimit, String searchKeyword, String projectStatus) {
		return mapper.selectProjectList(startRow, listLimit, searchKeyword, projectStatus);
	}
	
	// 프로젝트 상세정보 조회
	public Map<String, Object> getProjectDetail(ProjectVO project) {
		return mapper.selectProjectDetail(project);
	}
	
	// 창작자 정보 조회
	public CreatorVO getCreator(Map<String, Object> projectInfo) {
		return mapper.selectCreator(projectInfo);
	}
	
	// ----------------------------------------------------------------
	// 24.10.25 최지민 작업 결제 취소 작업
	// 프리미엄 요금 결제정보 조회 요청
	public PremiumPaymentVO getPremiumPayment(ProjectVO project) {
		return mapper.selectPremiumPayment(project);
	}
	
	// 프리미엄 요금 환불 처리 요청
	public int premiumRefund(ProjectVO project) {
		return mapper.updatePremiumRefund(project);
	}
	
	// ----------------------------------------------------------------
	
	// 프로젝트 상태 변경
	public int changeProjectStatus(ProjectVO project, String status) {
		return mapper.updateProjectStatus(project, status);
	}
	
	// 프로젝트 취소 신청여부 조회
	public ProjectCancelVO getProjectCancel(ProjectVO project) {
		return mapper.selectProjectCancel(project);
	}
	
	// 프로젝트 취소 승인여부 변경
	public int changeProjectCancelStatus(ProjectVO project) {
		return mapper.updateProjectCancelStatus(project);
	}
	
	// 공지사항 개수 조회
	public int getNoticeListCount(String searchKeyword) {
		return mapper.selectNoticeListCount(searchKeyword);
	}
	
	// 공지사항 목록 조회
	public List<BoardVO> getNoticeList(int startRow, int listLimit, String searchKeyword) {
		return mapper.selectNoticeList(startRow, listLimit, searchKeyword);
	}
	
	// 공지사항 등록
	public int registNotice(BoardVO notice) {
		return mapper.insertNotice(notice);
	}
	
	// 공지사항 수정 - 파일 삭제
	public int removeFile(BoardVO notice) {
		return mapper.deleteFile(notice);
	}
	
	// 공지사항 수정
	public int modifyNotice(BoardVO notice) {
		return mapper.updateNotice(notice);
	}
	
	// 공지사항 삭제
	public int removeNotice(int bo_idx) {
		return mapper.deleteNotice(bo_idx);
	}
	
	// 1:1문의 개수 조회
	public int getFAQListCount(String searchKeyword) {
		return mapper.selectFAQListCount(searchKeyword);
	}
	
	// 1:1문의 목록 조회
	public List<BoardVO> getFAQList(int startRow, int listLimit, String searchKeyword) {
		return mapper.selectFAQList(startRow, listLimit, searchKeyword);
	}
	
	// 1:1문의 상세정보 조회
	public BoardVO getFAQDetail(BoardVO faq) {
		return mapper.selectFAQDetail(faq);
	}
	
	// 1:1문의 답변 작성/수정
	public int changeFAQReply(BoardVO faq) {
		return mapper.updateFAQReply(faq);
	}
	
	// 신고 개수 조회
	public int getReportListCount(String searchKeyword) {
		return mapper.selectReportListCount(searchKeyword);
	}
	
	// 신고 목록 조회
	public List<ReportVO> getReportList(int startRow, int listLimit, String searchKeyword) {
		return mapper.selectReportList(startRow, listLimit, searchKeyword);
	}
	
	// 신고 상세정보 조회
	public ReportVO getReportDetail(ReportVO report) {
		return mapper.selectReportDetail(report);
	}
	
	// 상품 상세정보 조회
	public StoreVO getProductDetail(StoreVO product) {
		return mapper.selectProductDetail(product);
	}
	
	// 신고 상태 변경
	public int changeReportState(ReportVO report) {
		return mapper.updateReportState(report);
	}


	
	
}
