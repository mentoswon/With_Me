package com.itwillbs.with_me.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.itwillbs.with_me.vo.MemberVO;

@Mapper
public interface AdminMapper {
	
	// 관리자 - 회원 목록 개수 세기
	int selectMemberListCount(String searchKeyword);
	
	// 관리자 - 회원 목록 가져오기
	List<MemberVO> selectMemberList(@Param("startRow") int startRow, @Param("listLimit") int listLimit,
									@Param("searchKeyword") String searchKeyword);
	
	// 관리자 권한 부여/해제
	int updateAdminAuth(MemberVO member);
	
}
