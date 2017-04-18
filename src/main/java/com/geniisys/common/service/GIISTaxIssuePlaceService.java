package com.geniisys.common.service;

import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIISTaxIssuePlaceService {
	//void valDeleteRec(HttpServletRequest request) throws SQLException;
	JSONObject showTaxPlace(HttpServletRequest request, String userId) throws SQLException, JSONException; 
	void saveGiiss028TaxPlace(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteTaxPlaceRec(HttpServletRequest request) throws SQLException;
}
