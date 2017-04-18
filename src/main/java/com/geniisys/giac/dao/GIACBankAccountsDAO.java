package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACBankAccountsDAO {

	/**
	 * Gets the records of BANK_CD and BANK_ACCT_CD LOV for Close DCB module (Giacs035)
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getBankAcctNoLOV(String keyword) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
	void valAddRec(Map<String, Object> params) throws SQLException;
	void saveGiacs312(Map<String, Object> params) throws SQLException;
	
}
