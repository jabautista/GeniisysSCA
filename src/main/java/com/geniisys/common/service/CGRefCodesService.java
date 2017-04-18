package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

public interface CGRefCodesService {

	/**
	 * Executes the CGDV$CHK_CHAR_REF_CODES procedure for CG_REF_CODES
	 * @param params
	 * @throws SQLException
	 */
	void checkCharRefCodes(Map<String, Object> params) throws SQLException;
	String validateMemoType(HttpServletRequest request) throws SQLException;
	String validateGIACS127TranClass(HttpServletRequest request) throws SQLException;
	String validateGIACS127JVTran(HttpServletRequest request) throws SQLException;
	List<Map<String, Object>> getFileSourceList() throws SQLException;
}
