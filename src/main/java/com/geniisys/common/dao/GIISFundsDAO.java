package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIISFundsDAO {

	/**
	 * Gets the records of FUND_CD LOV for Close DCB module (Giacs035)
	 * @param keyword
	 * @return
	 */
	List<Map<String, Object>> getFundCdLOVList(String keyword) throws SQLException;
	void saveGiacs302(Map<String, Object> params) throws SQLException;
	void valDeleteRec(String recId) throws SQLException;
	void valAddRec(String recId) throws SQLException;
}
