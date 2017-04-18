package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACDCBBankDepDAO {

	/**
	 * Gets GDBD block records listing in table grid
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getGdbdListTableGrid(Map<String, Object> params) throws SQLException;
	
	/**
	 * Executes POPULATE_GDBD procedure and fetches the records for GDBD block
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> populateGDBD(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> saveDCBForClosing(Map<String, Object> params) throws SQLException;
	void refreshDCB(Map<String, Object> params) throws SQLException;
}
