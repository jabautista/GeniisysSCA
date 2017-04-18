package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface GIACBudgetDAO {
	void valAddBudgetYear(String year) throws SQLException;
	void copyBudget(Map<String, Object> params) throws SQLException;
	void saveGiacs510(Map<String, Object> params) throws SQLException;
	void saveGIACS510Dtl(Map<String, Object> params) throws SQLException;
	void valDeleteBudgetPerYear(String glAcctId, String year) throws SQLException;
	Map<String, Object> validateGLAcctNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkExistBeforeExtractGiacs510(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> extractGiacs510(HashMap<String, Object> params) throws SQLException;
}
