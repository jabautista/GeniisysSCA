package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface CGRefCodesDAO {

	/**
	 * Executes the CGDV$CHK_CHAR_REF_CODES procedure for CG_REF_CODES
	 * @param params
	 * @throws SQLException
	 */
	void checkCharRefCodes(Map<String, Object> params) throws SQLException;
	String validateMemoType(String memoType) throws SQLException;
	String validateGIACS127TranClass(Map <String, Object> params) throws SQLException;
	String validateGIACS127JVTran(String jvTranCd) throws SQLException;
	List<Map<String, Object>> getFileSourceList() throws SQLException;
}
