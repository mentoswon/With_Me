package com.itwillbs.with_me.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.StoreVO;

@Mapper
public interface AdminStoreMapper {
	
	// 상품등록
	int insertProduct(StoreVO store);
	
	
}
