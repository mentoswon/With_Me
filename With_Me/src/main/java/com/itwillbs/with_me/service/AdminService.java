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
	
	// 회원 총 개수
	public int getMemberListCount(String searchKeyword) {
		return mapper.selectMemberListCount(searchKeyword);
	}
	
	// 회원 목록
	public List<MemberVO> getMemberList(int startRow, int listLimit, String searchKeyword) {
		return mapper.selectMemberList(startRow, listLimit, searchKeyword);
	}
	
	// 관리자 권한 부여/해제
	public int changeAdminAuth(MemberVO member) {
		return mapper.updateAdminAuth(member);
	}
	
}
