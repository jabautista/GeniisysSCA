/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service.impl
	File Name: GICLEvalDepDtlServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
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

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLEvalDepDtlDAO;
import com.geniisys.gicl.service.GICLEvalDepDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLEvalDepDtlServiceImpl implements GICLEvalDepDtlService{

	private GICLEvalDepDtlDAO giclEvalDepDtlDAO;
	@Override
	public Map<String, Object> getDepPayeeDtls(Integer evalId)
			throws SQLException {
		return getGiclEvalDepDtlDAO().getDepPayeeDtls(evalId);
	}
	/**
	 * @param giclEvalDepDtlDAO the giclEvalDepDtlDAO to set
	 */
	public void setGiclEvalDepDtlDAO(GICLEvalDepDtlDAO giclEvalDepDtlDAO) {
		this.giclEvalDepDtlDAO = giclEvalDepDtlDAO;
	}
	/**
	 * @return the giclEvalDepDtlDAO
	 */
	public GICLEvalDepDtlDAO getGiclEvalDepDtlDAO() {
		return giclEvalDepDtlDAO;
	}
	@Override
	public Map<String, Object> getEvalDepList(HttpServletRequest request, String userId)
			throws SQLException , JSONException{
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getEvalDepList");
		params.put("userId", userId);
		params.put("pageSize", 7);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();

		request.setAttribute("evalDepTG", grid);
		request.setAttribute("object", grid);
		return params;
	}
	@Override
	public Map<String, Object> checkDepVat(Map<String, Object> params)
			throws SQLException {
		return getGiclEvalDepDtlDAO().checkDepVat(params);
	}
	@Override
	public void saveDepreciationDtls(String strParameters, String userId)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("evalId", objParameter.getInt("evalId"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParameter.getString("setRows"))));
		params.put("total", objParameter.getString("total").equals("") ? null : new BigDecimal( objParameter.getString("total")));
		getGiclEvalDepDtlDAO().saveRepairDet(params);
	}
	@Override
	public String applyDepreciation(Map<String, Object> params)
			throws SQLException {
		return getGiclEvalDepDtlDAO().applyDepreciation(params);
	}

}
