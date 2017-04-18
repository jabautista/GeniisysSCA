package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;

public interface GIACBankAccountsService {

	/**
	 * Gets the records of BANK_CD and BANK_ACCT_CD LOV for Close DCB module (Giacs035)
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getBankAcctNoLOV(Integer pageNo, String keyword) throws SQLException;
	JSONObject showGiacs312(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void saveGiacs312(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
}
