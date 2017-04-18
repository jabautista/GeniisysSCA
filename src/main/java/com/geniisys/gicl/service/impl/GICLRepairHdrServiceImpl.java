/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service.impl
	File Name: GICLRepairHdrServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
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
import com.geniisys.gicl.dao.GICLRepairHdrDAO;
import com.geniisys.gicl.entity.GICLRepairHdr;
import com.geniisys.gicl.entity.GICLRepairLpsDtl;
import com.geniisys.gicl.entity.GICLRepairOtherDtl;
import com.geniisys.gicl.service.GICLRepairHdrService;
import com.seer.framework.util.StringFormatter;

public class GICLRepairHdrServiceImpl implements GICLRepairHdrService{
	private GICLRepairHdrDAO giclRepairHdrDAO;

	public GICLRepairHdrDAO getGiclRepairHdrDAO() {
		return giclRepairHdrDAO;
	}

	public void setGiclRepairHdrDAO(GICLRepairHdrDAO giclRepairHdrDAO) {
		this.giclRepairHdrDAO = giclRepairHdrDAO;
	}

	@Override
	public GICLRepairHdr getRepairDtl(Integer evalId) throws SQLException {
		return getGiclRepairHdrDAO().getRepairDtl(evalId);
	}

	@Override
	public Map<String, Object> getGicls070LpsRepairDetailsList(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls070LpsRepairDetailsList");
		params.put("userId", USER.getUserId());
		params.put("pageSize", 7);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();

		request.setAttribute("repairLpsDetailsTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public String getTinsmithAmount(Map<String, Object> params)
			throws SQLException {
		return giclRepairHdrDAO.getTinsmithAmount(params);
	}

	@Override
	public String getPaintingsAmount(String lossExpCd) throws SQLException {
		return giclRepairHdrDAO.getPaintingsAmount(lossExpCd);
	}

	@Override
	public String validateBeforeSave(Map<String, Object> params)
			throws SQLException {
		return giclRepairHdrDAO.validateBeforeSave(params);
	}

	@Override
	public void saveRepairDet(String strParameters, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("giclRepairHdr", JSONUtil.prepareObjectFromJSON(objParameter.getJSONObject("giclRepairHdrObj"), USER.getUserId(), GICLRepairHdr.class));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("setRows"))  , USER.getUserId(), GICLRepairLpsDtl.class));
		//params.put("modifiedRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("modifiedRows")), USER.getUserId(), GICLRepairLpsDtl.class));
		params.put("deletedRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("deletedRows")), USER.getUserId(), GICLRepairLpsDtl.class));
		params.put("evalId", objParameter.getInt("evalId"));
		params.put("evalMasterId", objParameter.isNull("evalMasterId") ? null : objParameter.getInt("evalMasterId"));
		
		getGiclRepairHdrDAO().saveRepairDet(params);
	}

	@Override
	public Map<String, Object> getGiclRepairOtherDtlList(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getGiclRepairOtherDtlList");
		params.put("userId", USER.getUserId());
		params.put("pageSize", 7);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();

		request.setAttribute("repairOtherDtlTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public Map<String, Object> validateBeforeSaveOther(
			Map<String, Object> params) throws SQLException {
		return getGiclRepairHdrDAO().validateBeforeSaveOther(params);
	}

	@Override
	public void saveOtherLabor(String strParameters, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("giclRepairObj", JSONUtil.prepareObjectFromJSON(objParameter.getJSONObject("giclRepairObj"), USER.getUserId(), GICLRepairHdr.class));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("setRows"))  , USER.getUserId(), GICLRepairOtherDtl.class));
		params.put("deletedRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameter.getString("deletedRows")), USER.getUserId(), GICLRepairOtherDtl.class));
		params.put("otherLaborAmt", objParameter.isNull("otherLaborAmt") ? null : new BigDecimal(objParameter.getString("otherLaborAmt")));
		params.put("dspTotalLabor", objParameter.isNull("dspTotalLabor") ? null : new BigDecimal(objParameter.getString("dspTotalLabor")));
		params.put("dedExist", objParameter.getString("dedExist"));
		params.put("vatExist", objParameter.getString("vatExist"));
		params.put("masterReportType", objParameter.getString("masterReportType"));
		params.put("evalMasterId",objParameter.isNull("evalMasterId") ? null : Integer.parseInt(objParameter.getString("evalMasterId")));
		//System.out.println(objParameter);
		getGiclRepairHdrDAO().saveOtherLabor(params);
	}
	
	
}
