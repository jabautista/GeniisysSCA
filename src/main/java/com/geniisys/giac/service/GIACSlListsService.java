package com.geniisys.giac.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;

public interface GIACSlListsService {

	/**
	 * Gets a paginated list of SL Listing with specified whtax id
	 * @param pageNo
	 * @param keyword
	 * @param whtaxId
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getSlListingByWhtaxId(Integer pageNo, String keyword, Integer whtaxId) throws SQLException;
	
	// shan 12.18.2013
	String getSapIntegrationSw() throws SQLException;
	JSONObject showGiacs309(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs309(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
