package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLCatDtl;

public interface GICLCatDtlDAO {
	List<GICLCatDtl> getCatDtls(Map<String, Object> params) throws SQLException;
}
