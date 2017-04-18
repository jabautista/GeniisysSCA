/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service.impl
	File Name: GICLEvalVatServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLEvalVatDAO;
import com.geniisys.gicl.entity.GICLEvalVat;
import com.geniisys.gicl.service.GICLEvalVatService;
import com.seer.framework.util.StringFormatter;

public class GICLEvalVatServiceImpl implements GICLEvalVatService{

	private GICLEvalVatDAO giclEvalVatDAO;	
	
	
	@Override
	public Map<String, Object> getMcEvalVatListing(HttpServletRequest request,
			String userId) throws SQLException, JSONException{
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getMcEvalVatListing");
		params.put("userId", userId);
		params.put("pageSize", 7);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();

		request.setAttribute("evalVatTg", grid);
		request.setAttribute("object", grid);
		return params;
	}



	/**
	 * @param giclEvalVatDAO the giclEvalVatDAO to set
	 */
	public void setGiclEvalVatDAO(GICLEvalVatDAO giclEvalVatDAO) {
		this.giclEvalVatDAO = giclEvalVatDAO;
	}



	/**
	 * @return the giclEvalVatDAO
	 */
	public GICLEvalVatDAO getGiclEvalVatDAO() {
		return giclEvalVatDAO;
	}



	@Override
	public Map<String, Object> validateEvalCom(Map<String, Object> params)
			throws SQLException {
		return getGiclEvalVatDAO().validateEvalCom(params);
	}



	@Override
	public Map<String, Object> validateEvalPartLabor(Map<String, Object> params)
			throws SQLException {
		return getGiclEvalVatDAO().validateEvalPartLabor(params);
	}



	@Override
	public Map<String, Object> validateLessDepreciation(
			Map<String, Object> params) throws SQLException {
		return getGiclEvalVatDAO().validateLessDepreciation(params);
	}



	@Override
	public Map<String, Object> validateLessDeductibles(
			Map<String, Object> params) throws SQLException {
		return getGiclEvalVatDAO().validateLessDeductibles(params);
	}



	@Override
	public String checkEnableCreateVat(Integer evalId) throws SQLException {
		return giclEvalVatDAO.checkEnableCreateVat(evalId);
	}



	@Override
	public void saveVatDetail(String strParameters, String userId)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("setRows"))  , userId, GICLEvalVat.class));
		params.put("deletedRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("deletedRows")), userId, GICLEvalVat.class));
		params.put("totalVat", objParameter.isNull("totalVat") ? null : new BigDecimal(objParameter.getString("totalVat")));
		params.put("evalId", objParameter.getString("evalId"));
		params.put("userId",userId);
		
		getGiclEvalVatDAO().saveVatDetail(params);
		
	}



	@Override
	public BigDecimal createVatDetails(String strParameters, String userId)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("setRows"))  , userId, GICLEvalVat.class));
		params.put("evalId", objParameter.getString("evalId"));
		params.put("userId",userId);
		
		return giclEvalVatDAO.createVatDetails(params);
	}



	@Override
	public String checkGiclEvalVatExist(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("evalId", request.getParameter("evalId"));
		params.put("userId", USER.getUserId());
		return this.getGiclEvalVatDAO().checkGiclEvalVatExist(params);
	}

}
