package com.itwillbs.with_me.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.AdminStoreMapper;
import com.itwillbs.with_me.vo.StoreVO;

@Service
public class AdminStoreService {
	@Autowired
	private AdminStoreMapper mapper;
	
	// 상품 등록
	public int registProduct(StoreVO store) {
		return mapper.insertProduct(store);
	}
	
	
}
