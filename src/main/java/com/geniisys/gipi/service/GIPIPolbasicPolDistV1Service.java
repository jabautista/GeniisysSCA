package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GIPIPolbasicPolDistV1Service {
	
	HashMap<String, Object> getGIPIPolbasicPolDistV1List(HashMap<String, Object> params) throws SQLException, JSONException;

	/**
	 * Returns query details from GIPI_POLBASIC_POL_DIST_V1 for GIUWS012 (Distribution by Peril).
	 * @param params
	 * @return
	 * @throws SQLException
	 * @throws JSONException
	 */
	HashMap<String, Object> getGIPIPolbasicPolDistV1ListForPerilDist(HashMap<String, Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getGIPIPolbasicPolDistV1ListOneRiskDist(HashMap<String, Object> params) throws SQLException, JSONException;
	void getV1ListDistByTsiPremPeril(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	
	/**
	 * Gets currency code and description for GIUWS012
	 * @param policyId
	 * @param distNo
	 * @param distSeqNo
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getGiuws012Currency(Integer policyId, Integer distNo, Integer distSeqNo) throws SQLException;
	void getV1PopMissingDistRec(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String createMissingDistRec(HttpServletRequest request, GIISUser USER) throws SQLException;
}
