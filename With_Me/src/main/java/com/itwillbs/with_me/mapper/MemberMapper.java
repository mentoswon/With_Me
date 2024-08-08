package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.MemberVO;

@Mapper
public interface MemberMapper {
	
	// 회원가입 등록
	int insertMember(MemberVO member);
	
	// 회원 상세정보 조회
	MemberVO selectMember(MemberVO member);
	
	// 아이디 조회
	MemberVO selectId(MemberVO member);

}
