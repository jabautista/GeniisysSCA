package com.geniisys.giac.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACParameter;

public interface GIACParameterFacadeService {

	public GIACParameter getParamValueV(String paramName) throws SQLException;
	
	public String getParamValueV2(String paramName) throws SQLException;
		 
	public Integer getParamValueN(String paramName1) throws SQLException;
	 
	public List<GIACParameter> getParamValues(String paramName) throws SQLException;
	
	String getGlobalBranchCdByUserId(String paramName) throws SQLException;
	
	JSONObject showGiacs301(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiacs301(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	
	//added john 10.23.2014
	public BigDecimal getParamValueN2(String paramName1) throws SQLException;
	
}
