package com.geniisys.gicl.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONTokener;

public interface GICLLossRatioDAO {

	String validateAssdNoGicls204(BigDecimal assdNo) throws SQLException;
	String validatePerilCdGicls204(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractGicls204(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDetailReportDate(Map<String, Object> params) throws SQLException;

}
