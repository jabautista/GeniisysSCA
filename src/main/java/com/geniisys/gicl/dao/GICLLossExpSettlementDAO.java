package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLLossExpSettlementDAO {

	void saveGicls060(Map<String, Object> params) throws SQLException;
	String valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
