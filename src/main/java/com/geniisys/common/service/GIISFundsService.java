package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;

public interface GIISFundsService {

	/**
	 * Gets the records of FUND_CD LOV for Close DCB module (Giacs035)
	 * @param pageNo
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getFundCdLOVList(Integer pageNo, String keyword) throws SQLException;
	JSONObject showGiacs302(HttpServletRequest request, String userId)throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs302(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
