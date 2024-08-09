package com.itwillbs.with_me.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminMapper;
import com.itwillbs.with_me.vo.MemberVO;

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
	public int getSponsorshipDetailListCount(String searchKeyword) {
		return mapper.selectSponsorshipDetailListCount(searchKeyword);
	}
	
	// 후원내역 조회
	public List<String> getSponsorshipDetail(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectSponsorshipDetail(startRow, listLimit, searchKeyword, member);
	}
	
	// 구매내역 개수 조회
	public int getPurchaseHistoryListCount(String searchKeyword) {
		return mapper.selectPurchaseHistoryListCount(searchKeyword);
	}
	
	// 구매내역 조회
	public List<String> getPurchaseHistory(int startRow, int listLimit, String searchKeyword, MemberVO member) {
		return mapper.selectPurchaseHistory(startRow, listLimit, searchKeyword, member);
	}
	
}
