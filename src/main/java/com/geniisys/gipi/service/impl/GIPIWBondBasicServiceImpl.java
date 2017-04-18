package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWBondBasicDAO;
import com.geniisys.gipi.entity.GIPIWBondBasic;
import com.geniisys.gipi.service.GIPIWBondBasicService;
import com.seer.framework.util.StringFormatter;

public class GIPIWBondBasicServiceImpl implements GIPIWBondBasicService{
	
	private GIPIWBondBasicDAO gipiWBondBasicDAO;

	@Override
	public GIPIWBondBasic getGIPIWBondBasic(Integer parId) throws SQLException {
		return this.getGipiWBondBasicDAO().getGIPIWBondBasic(parId);
	}

	public void setGipiWBondBasicDAO(GIPIWBondBasicDAO gipiWBondBasicDAO) {
		this.gipiWBondBasicDAO = gipiWBondBasicDAO;
	}

	public GIPIWBondBasicDAO getGipiWBondBasicDAO() {
		return gipiWBondBasicDAO;
	}

	@Override
	public void saveBondPolicyData(Map<String, Object> params)
			throws SQLException {
		this.getGipiWBondBasicDAO().saveBondPolicyData(params);
	}

	@Override
	public void saveEndtBondPolicyData(Map<String, Object> params)
			throws SQLException {
		this.gipiWBondBasicDAO.saveEndtBondPolicyData(params);
	}

	@Override
	public GIPIWBondBasic getBondBasicNewRecord(Integer parId)
			throws SQLException {
		return this.getGipiWBondBasicDAO().getBondBasicNewRecord(parId);
	}

	@Override
	public JSONObject showLandCarrierDtl(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLandCarrierDtlList");	
		params.put("parId", request.getParameter("globalParId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void saveLandCarrierDtl(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", this.prepareGIPIWC20DtlForInsert(new JSONArray(request.getParameter("setRows"))));
		params.put("delRows", this.prepareGIPIWC20DtlForDelete(new JSONArray(request.getParameter("delRows"))));
		params.put("appUser", userId);
		this.gipiWBondBasicDAO.saveLandCarrierDtl(params);
	}

	@Override
	public void valAddLandCarrierDtl(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", request.getParameter("parId"));
		params.put("itemNo", request.getParameter("itemNo"));
		this.gipiWBondBasicDAO.valAddLandCarrierDtl(params);
	}
	
	private List<Map<String, Object>> prepareGIPIWC20DtlForInsert(JSONArray setRows) throws JSONException{
		List<Map<String, Object>> itemList = new ArrayList<Map<String, Object>>();
		
		for(int i=0; i < setRows.length(); i++){
			Map<String, Object> item = new HashMap<String, Object>();
			JSONObject objItem = setRows.getJSONObject(i);

			item.put("parId", (objItem.isNull("parId") ? null : objItem.getInt("parId")));
			item.put("itemNo", (objItem.isNull("itemNo") ? null : objItem.getInt("itemNo")));
			item.put("plateNo", (objItem.isNull("plateNo") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("plateNo"))));
			item.put("motorNo", (objItem.isNull("motorNo") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("motorNo"))));
			item.put("make", (objItem.isNull("make") ? null : StringFormatter.unescapeHtmlJava(objItem.getString("make"))));
			item.put("pscCaseNo", (objItem.isNull("pscCaseNo") ? null : StringEscapeUtils.unescapeHtml(objItem.getString("pscCaseNo"))));
			itemList.add(item);
		}		
		
		return itemList;
	}
	
	private List<Map<String, Object>> prepareGIPIWC20DtlForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> deleteItemList = new ArrayList<Map<String, Object>>();
		Map<String, Object> deleteMap = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			deleteMap = new HashMap<String, Object>();
			deleteMap.put("parId", delRows.getJSONObject(i).isNull("parId") ? null : delRows.getJSONObject(i).getInt("parId"));
			deleteMap.put("itemNo", delRows.getJSONObject(i).isNull("itemNo") ? null : delRows.getJSONObject(i).getInt("itemNo"));
			
			deleteItemList.add(deleteMap);
			deleteMap = null;
		}		
		
		return deleteItemList;
	}
	
	public Integer getMaxItemNoLandCarrierDtl(Integer parId) throws SQLException{
		return this.gipiWBondBasicDAO.getMaxItemNoLandCarrierDtl(parId);
	}
}
