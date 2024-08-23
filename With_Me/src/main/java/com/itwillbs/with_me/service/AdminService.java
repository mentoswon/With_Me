package com.itwillbs.with_me.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminMapper;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;

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
	public int getSponsorshipHistoryListCount(String searchKeyword) {
		return mapper.selectSponsorshipHistoryListCount(searchKeyword);
	}
	
	// 후원내역 조회
	public List<String> getSponsorshipHistory(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectSponsorshipHistory(startRow, listLimit, searchKeyword, member);
	}
	
	// 구매내역 개수 조회
	public int getPurchaseHistoryListCount(String searchKeyword) {
		return mapper.selectPurchaseHistoryListCount(searchKeyword);
	}
	
	// 구매내역 조회
	public List<String> getPurchaseHistory(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectPurchaseHistory(startRow, listLimit, searchKeyword, member);
	}
	
	// 프로젝트 개수 조회
	public int getProjectListCount(String searchKeyword, String projectStatus) {
		return mapper.selectProjectListCount(searchKeyword, projectStatus);
	}
	
	// 프로젝트 목록 조회
	public List<ProjectVO> getProjectList(int startRow, int listLimit, String searchKeyword, String projectStatus) {
		return mapper.selectProjectList(startRow, listLimit, searchKeyword, projectStatus);
	}
	
	// 프로젝트 상태 변경
	public int changeProjectStatus(ProjectVO project, String status) {
		return mapper.updateProjectStatus(project, status);
	}
	
	// 프로젝트 취소 신청여부 조회
	public ProjectCancelVO getProjectCancel(int project_idx) {
		return mapper.selectProjectCancel(project_idx);
	}
	
	// 프로젝트 취소 승인여부 변경
	public int changeProjectCancelStatus(ProjectVO project) {
		return mapper.updateProjectCancelStatus(project);
	}
	
}
