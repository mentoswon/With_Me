package com.itwillbs.with_me.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.itwillbs.with_me.mapper.CreatorFundingMapper;

@Service
public class CreatorFundingService {
	@Autowired
	private CreatorFundingMapper mapper;

}
