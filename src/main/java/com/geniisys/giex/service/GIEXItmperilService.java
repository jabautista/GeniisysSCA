package com.geniisys.giex.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIEXItmperilService {
	
	public void deleteItmperilByPolId(Integer policyId) throws SQLException;
	Map<String, Object> deletePerilGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> createPerilGIEXS007(Map<String, Object> params) throws SQLException, Exception;
	void saveGIEXItmperil(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> computeTsiGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> computePremiumGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateWitemGIEXS007(Map<String, Object> params) throws SQLException;
	public void deleteOldPEril(Map<String, Object> params) throws SQLException;
	String computeDeductibleAmt(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException;
	Map<String, Object> validateItemperil(Map<String, Object> params) throws SQLException; //joanne 12-02-13
	Map<String, Object> deleteItemperil(Map<String, Object> params) throws SQLException; //joanne 12-05-13	
}
