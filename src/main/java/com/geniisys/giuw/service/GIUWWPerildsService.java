package com.geniisys.giuw.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

public interface GIUWWPerildsService {
	
	Map<String, Object> getGiuwWperildsForDistFinal(Map<String, Object> params) throws SQLException, JSONException;

	/**
	 * Checks if dist exists in giuw_wperilds and giuw_wperilds_dtl. used in POST-QUERY of GIUW_POL_DIST block
	 * @param distNo
	 * @return
	 * @throws SQLException
	 */
	String isExistGiuwWPerildsGIUWS012(Integer distNo) throws SQLException;
}
