/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service
	File Name: GICLEvalVatService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLEvalVatService {
	Map<String, Object> getMcEvalVatListing(HttpServletRequest request, String userId)throws SQLException, JSONException;
	Map<String, Object>validateEvalCom(Map<String, Object>params) throws SQLException;
	Map<String, Object>validateEvalPartLabor(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateLessDepreciation(Map<String, Object>params)throws SQLException;
	Map<String, Object> validateLessDeductibles(Map<String, Object>params)throws SQLException;
	public String checkEnableCreateVat(Integer evalId) throws SQLException;
	void saveVatDetail(String strParameters, String userId)throws SQLException, JSONException;
	BigDecimal createVatDetails(String strParameters, String userId)throws SQLException, JSONException;
	String checkGiclEvalVatExist(HttpServletRequest request, GIISUser USER) throws SQLException, Exception;
}
