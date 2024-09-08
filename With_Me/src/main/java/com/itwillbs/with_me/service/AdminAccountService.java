package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminAccountMapper;
import com.itwillbs.with_me.vo.BankToken;
import com.itwillbs.with_me.vo.BoardVO;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectCancelVO;
import com.itwillbs.with_me.vo.ProjectVO;

@Service
public class AdminAccountService {
	@Autowired
	private AdminAccountMapper mapper;
	
	// 프로젝트 개수 조회 요청
	public int getAccountListCount(String searchKeyword, String accountStatus) {
		return mapper.selectAccountListCount(searchKeyword, accountStatus);
	}
	
	// 프로젝트 목록 조회 요청
	public List<Map<String, Object>> getAccountList(int startRow, int listLimit, String searchKeyword, String accountStatus) {
		return mapper.selectAccountList(startRow, listLimit, searchKeyword, accountStatus);
	}

	// 해당 프로젝트에 후원하는 후원자 수 조회 요청
	public int getUserAccountListCount(String searchKeyword, String project_code) {
		return mapper.selectUserAccountListCount(searchKeyword, project_code);
	}

	
	// 해당 프로젝트에 후원하는 후원자 목록 조회 요청
	public List<Map<String, Object>> getUserAccountList(int startRow, int listLimit, String searchKeyword, String project_code) {
		return mapper.selectUserAccountList(startRow, listLimit, searchKeyword, project_code);
	}

}
