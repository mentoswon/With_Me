package com.itwillbs.with_me.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.itwillbs.with_me.vo.StoreVO;

@Mapper
public interface HomeMapper {

	List<Map<String, Object>> selectProjectList(String sId);

	List<Map<String, Object>> selectStoreList(String sId);
	
}
