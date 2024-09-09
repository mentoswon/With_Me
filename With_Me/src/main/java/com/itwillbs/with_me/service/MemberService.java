package com.itwillbs.with_me.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.MemberMapper;
import com.itwillbs.with_me.vo.CreatorVO;
import com.itwillbs.with_me.vo.FollowVO;
import com.itwillbs.with_me.vo.FundingVO;
import com.itwillbs.with_me.vo.LikeVO;
import com.itwillbs.with_me.vo.MailAuthInfo;
import com.itwillbs.with_me.vo.MemberVO;
import com.itwillbs.with_me.vo.ProjectVO;
import com.itwillbs.with_me.vo.Store_userVO;

@Service
public class MemberService {
	@Autowired
	private MemberMapper mapper;
	
	// 회원가입 요청
	public int registMember(MemberVO member) {
		return mapper.insertMember(member);
	}
	
	// 회원 상세정보 요청
	public MemberVO getMember(MemberVO member) {
		return mapper.selectMember(member);
	}
	
	// 아이디 조회
	public MemberVO getId(MemberVO member) {
		return mapper.selectId(member);
	}

	// 이메일 인증 정보 등록 요청
	public void registMailAuthInfo(MailAuthInfo mailAuthInfo) {
		// 기존 인증정보 존재 여부 확인
		// MemberMapper - selectMailAuthInfo() 메서드 호출
		MailAuthInfo dbMailAuthInfo = mapper.selectMailAuthInfo(mailAuthInfo);
		System.out.println("조회된 인증 정보 : " + dbMailAuthInfo);
		
		// 인증정보 조회 결과 판별
		if(dbMailAuthInfo == null) { // 기존 인증정보 없음
			// 새 인증정보 등록 위해 insertMailAuthInfo() 메서드 호출하여 등록 작업 요청(INSERT)
			mapper.insertMailAuthInfo(mailAuthInfo);
			
		} else { // 기존 인증정보 있음(인증메일 발송 이력 있음)
			// 기존 인증정보 갱신 위해 updateMailAuthInfo() 메서드 호출하여 수정 작업 요청(UPDATE)
			mapper.updateMailAuthInfo(mailAuthInfo);
		}
	}
	
	// 이메일 인증 처리 요청
	public boolean requestEmailAuth(MailAuthInfo authInfo) {
		boolean isAuthSuccess = false;
		
		// MemberMapper - selectMailAuthInfo() 메서드 호출하여 인증정보 조회 수행
		// => 파라미터 : MailAuthInfo 객체   리턴타입 : MailAuthInfo
		MailAuthInfo dbMailAuthInfo = mapper.selectMailAuthInfo(authInfo);
		
		// 인증정보 조회 결과 판별
		if(dbMailAuthInfo != null) { // 인증코드가 존재할 경우
			// 하이퍼링크를 통해 전달받은 인증코드와 조회된 인증코드 문자열 비교
			if(authInfo.getAuth_code().equals(dbMailAuthInfo.getAuth_code())) { // 인증코드 일치
				// 1) MemberMapper - updateMailAuthStatus() 메서드 호출하여
				//    member 테이블의 이메일 인증 상태(mail_auth_status)값을 "Y"로 변경
				//    => 파라미터 : MailAuthInfo 객체
				mapper.updateMailAuthStatus(authInfo);
				
				// 2) MemberMapper - deleteMailAuthInfo() 메서드 호출하여
				//    mail_auth_info  테이블의 인증정보 삭제
//			    => 파라미터 : MailAuthInfo 객체
				mapper.deleteMailAuthInfo(authInfo);
				// 인증 수행 결과 저장 변수값을 true로 변경
				isAuthSuccess = true;
			}
		}
		
		// MemberMapper - updateEmailAuth() 메서드 호출하여 이메일 인증 처리
		return isAuthSuccess;
	}

	// 회원 아이디로 비밀번호 찾기
	public MemberVO getFindPasswdFromEmail(MemberVO member) {
		return mapper.selectFindPasswdFromEmail(member);
	}
	
	// 아이디 + 전화번호로 비밀번호 리셋폼으로 넘어가기
	public MemberVO getFindPasswdFromTel(MemberVO member) {
		return mapper.selectFindPasswdFromTel(member);
	}
	
	//회원 비밀번호 변경
	public int modifyPasswd(Map<String, String> map) {
		return mapper.updatePasswd(map);
	}
	
	// 회원정보 조회
	public List<MemberVO> getMember() {
		return mapper.selectMember();
	}

	// 이메일로 창작자정보 조회
	public CreatorVO getCreatorInfo(MemberVO member) {
		return mapper.selectCreator(member);
	}

	// 프로젝트 리스트 목록 개수 가져오기
	public int getProjectListCount() {
		return mapper.selectProjectListCount();
	}

	// 내 마이페이지에서 프로젝트 리스트 가져오기
	public List<Map<String, Object>> getProjectList(int startRow, int listLimit, String mem_email) {
		return mapper.selectProjectList(startRow, listLimit, mem_email);
	}
	
	// 상대방 마이페이지에서 프로젝트 리스트 가져오기
	public List<Map<String, Object>> getOtherProjectList(int startRow, int listLimit, String creatorEmail) {
		return mapper.selectOtherProjectList(startRow, listLimit, creatorEmail);
	}
	
	// 내 마이페이지에서 후원한 프로젝트 가져오기
	public List<Map<String, Object>> getDonationProjectList(int startRow, int listLimit, String mem_email) {
		return mapper.selectDonationProjectList(startRow, listLimit, mem_email);
	}
	
	// 후원한 프로젝트 세부정보
	public Map<String, Object> getDonationProjectDetail(int funding_idx) {
		return mapper.selectDonationProjectDetail(funding_idx);
	}
	
	// 후원 수정(취소)
	public int modifyDonationProject(FundingVO funding) {
		return mapper.updateDonationProject(funding);
	}

	// 팔로우 리스트 개수 가져오기
	public int getFollowListCount(String mem_email) {
		return mapper.selectFollowListCount(mem_email);
	}
	
	// 좋아요 리스트 개수 가져오기
	public int getLikeListCount() {
		return mapper.selectLikeListCount();
	}

	// 내 마이페이지에서 팔로우 리스트 가져오기
	public List<Map<String, Object>> getFollowtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectFollowList(startRow, listLimit, mem_email);
	}
	
	// 내 마이페이지에서 팔로잉 리스트 가져오기
	public List<Map<String, Object>> getFollowingtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectFollowingList(startRow, listLimit, mem_email);
	}
	
	// 좋아요 프로젝트 리스트 나타내기
	public List<Map<String, Object>> getLikeProjectList(int startRow, int listLimit, String mem_email) {
		return mapper.selectLikeProjectList(startRow, listLimit, mem_email);
	}
	
	// 좋아요 상품 리스트 나타내기
	public List<Map<String, Object>> getLikeProductList(int startRow, int listLimit, String mem_email) {
		return mapper.selectLikeProductList(startRow, listLimit, mem_email);
	}
	
	// 프로젝트 상세정보 가져오기(프로젝트 하나만)
	public Map<String, Object> getProject(String mem_email) {
		return mapper.selectProject(mem_email);
	}
	
	// 좋아요 취소
	public int cancleLike(String like_project_code, String like_mem_email) {
		return mapper.cancleLike(like_project_code, like_mem_email);
	}
	
	// 좋아요 상품 취소
	public int cancelProductLike(String like_product_code, String like_mem_email) {
		return mapper.cancelProductLike(like_product_code, like_mem_email);
	}
	
	// 내가 구매한 상품목록
	public List<Map<String, Object>> getBuyProductList(int startRow, int listLimit, String mem_email) {
		return mapper.selectBuyProductList(startRow, listLimit, mem_email);
	}
	
	// 내가 구매한 상품 세부정보
	public Map<String, Object> getBuyProductDetail(int order_idx) {
		return mapper.selectBuyProductDetail(order_idx);
	}
	
	// 내가 구매한 상품 결제 취소
	public int modifyBuyProduct(Store_userVO store_user) {
		return mapper.updateBuyProduct(store_user);
	}
	
	// 크리에이터 이메일 들고와서 mem_email 들고오기
	public String getMemEmail(String creatorEmail) {
		return mapper.selectMemEmail(creatorEmail);
	}
	
	// 창작자가 아닌 상대방 마이페이지에서 팔로워 리스트 가져오기
	public List<Map<String, Object>> getOtherNoCreatorFollowtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectOtherNoCreatorFollowList(startRow, listLimit, mem_email);
	}
	
	// 창작자가 아닌 상대방 마이페이지에서 팔로잉 리스트 가져오기
	public List<Map<String, Object>> getOtherNoCreatorFollowingtList(int startRow, int listLimit, String mem_email) {
		return mapper.selectOtherNoCreatorFollowingList(startRow, listLimit, mem_email);
	}
	
	// 창작자인 상대방 마이페이지에서 팔로워 리스트 가져오기 
	public List<Map<String, Object>> getOtherCreatorFollowtList(int startRow, int listLimit, String creatorEmail) {
		return mapper.selectOtherCreatorFollowList(startRow, listLimit, creatorEmail);
	}
	
	// 창작자인 상대방 마이페이지에서 팔로잉 리스트 가져오기 
	public List<Map<String, Object>> getOtherCreatorFollowingList(int startRow, int listLimit, String creatorEmail) {
		return mapper.selectOtherCreatorFollowingList(startRow, listLimit, creatorEmail);
	}
	
	// 창작자가 아닌 상대방 마이페이지에서 후원한 프로젝트 목록 나타내기
	public List<Map<String, Object>> getOtherNoCreatorDonationProjectList(int startRow, int listLimit, String mem_email) {
		return mapper.selectOtherNoCreatorDonationProjectList(startRow, listLimit, mem_email);
	}
	
	// 창작자인 상대방 마이페이지에서 후원한 프로젝트 목록 나타내기
	public List<Map<String, Object>> getOtherCreatorDonationProjectList(int startRow, int listLimit, String creatorEmail) {
		return mapper.selectOtherCreatorDonationProjectList(startRow, listLimit, creatorEmail);
	}


	// 팔로우 리스트에서 내가 팔로우한 사람이 팔로우한 수
//	public List<FollowVO> getFollowerCount(List<FollowVO> followerCount) {
//		return mapper.selectFollowerCount(followerCount);
//	}

	// 프로필 사진 삭제
	public int removeProfileDelete(Map<String, String> map) {
		return mapper.deleteProfileDelete(map);
	}

	// 마이페이지(기본정보 수정)
	public int modifyMember(Map<String, String> map) {
		return mapper.updateMember(map);
	}
	
	// 팔로우나 프로젝트 리스트에서 들어가는 마이페이지 들어가기 위해 창작자 이름 가져오기
	public String getCreatorName(String creatorEmail) {
		return mapper.selectCreatorName(creatorEmail);
	}

	// 상대방 마이페이지(창작자가 아닌 경우)
	public MemberVO getMemberInfo(String creatorEmail) {
		return mapper.selectMemberInfo(creatorEmail);
	}
	
	// 상대방 마이페이지(창작자인 경우)
	public CreatorVO getOtherCreatorInfo(String creatorEmail) {
		return mapper.selectOtherCreatorInfo(creatorEmail);
	}
	
	
	
	// ========================================
	// 회원 아이디 조회(채팅용)
	public String getMemberId(String receiver_id) {
		return mapper.selectMemberId(receiver_id);
	}
	// ================================================
	// 회원 가입 시 배송지 등록
	public void registTransAddress(String address_mem_email, String address_receiver_name, String address_post_code,
			String address_main, String address_sub, String address_receiver_tel) {
		mapper.insertTransAddress(address_mem_email, address_receiver_name, address_post_code,address_main, address_sub,address_receiver_tel);
	}




































}

















