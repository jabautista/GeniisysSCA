package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuoteBondBasic;

public interface GIPIQuoteBondBasicDAO {

	GIPIQuoteBondBasic getGIPIQuoteBondBasic(Integer quoteId) throws SQLException;
	String saveBondPolicyData(Map<String, Object> params) throws SQLException;
}
