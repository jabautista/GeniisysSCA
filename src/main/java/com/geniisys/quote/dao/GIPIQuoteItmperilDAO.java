package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteItmperil;

public interface GIPIQuoteItmperilDAO {
	String savePerilInfo(Map<String, Object> rowParams, Map<String, Object> params) throws SQLException;
	List<GIPIQuoteItmperil> getItmperils(Map<String, Object> params) throws SQLException;
}
