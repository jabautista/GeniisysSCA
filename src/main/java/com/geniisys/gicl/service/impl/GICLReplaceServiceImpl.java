/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLReplaceServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReplaceDAO;
import com.geniisys.gicl.service.GICLReplaceService;
import com.seer.framework.util.StringFormatter;

public class GICLReplaceServiceImpl implements GICLReplaceService{

	private GICLReplaceDAO giclReplaceDAO;
	
	@Override
	public Map<String, Object> getMcEvalReplaceListing(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getMcEvalReplaceListing");
		params.put("userId", USER.getUserId());
		params.put("pageSize", 10);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("mcEvalReplaceTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	/**
	 * @param giclReplaceDAO the giclReplaceDAO to set
	 */
	public void setGiclReplaceDAO(GICLReplaceDAO giclReplaceDAO) {
		this.giclReplaceDAO = giclReplaceDAO;
	}

	/**
	 * @return the giclReplaceDAO
	 */
	public GICLReplaceDAO getGiclReplaceDAO() {
		return giclReplaceDAO;
	}

	@Override
	public Map<String, Object> validatePartType(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validatePartType(params);
	}

	@Override
	public Integer countPrevPartListLOV(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().countPrevPartListLOV(params);
	}

	@Override
	public Map<String, Object> checkPartIfExistMaster(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().checkPartIfExistMaster(params);
	}

	@Override
	public Map<String, Object> copyMasterPart(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().copyMasterPart(params);
	}

	@Override
	public Map<String, Object> validatePartDesc(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validatePartDesc(params);
	}

	@Override
	public Map<String, Object> getPayeeDetailsMap(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().getPayeeDetailsMap(params);
	}

	@Override
	public Map<String, Object> validateCompanyType(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validateCompanyType(params);
	}

	@Override
	public Map<String, Object> validateCompanyDesc(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validateCompanyDesc(params);
	}

	@Override
	public Map<String, Object> checkVatAndDeductibles(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().checkVatAndDeductibles(params);
	}

	@Override
	public Map<String, Object> validateBaseAmt(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validateBaseAmt(params);
	}

	@Override
	public Map<String, Object> validateNoOfUnits(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().validateNoOfUnits(params);
	}

	@Override
	public List<String> getWithVatList(Integer evalMasterId)
			throws SQLException {
		return getGiclReplaceDAO().getWithVatList(evalMasterId);
	}

	@Override
	public Map<String, Object> checkUpdateRepDtl(Map<String, Object> params)
			throws SQLException {
		return getGiclReplaceDAO().checkUpdateRepDtl(params);
	}

	@Override
	public String finalCheckVat(Map<String, Object> params) throws SQLException {
		return getGiclReplaceDAO().finalCheckVat(params);
	}

	@Override
	public String finalCheckDed(Map<String, Object> params) throws SQLException {
		return getGiclReplaceDAO().finalCheckDed(params);
	}

	@Override
	public void saveReplaceDetail(Map<String, Object> params)
			throws SQLException {
		getGiclReplaceDAO().saveReplaceDetail(params);
	}

	@Override
	public void updateItemNo(String userId, Integer evalId) throws SQLException {
		getGiclReplaceDAO().updateItemNo(userId, evalId);
	}

	@Override
	public void deleteReplaceDetail(Map<String, Object> params)
			throws SQLException {
		getGiclReplaceDAO().deleteReplaceDetail(params);
	}

	@Override
	public Map<String, Object> getReplacePayeeListing(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("ACTION", "getReplacePayeeListing");
		params.put("userId", USER.getUserId());
		params.put("pageSize", 7);
		params.put("evalId", request.getParameter("evalId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("mcReplacePayeeTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public void applyChangePayee(String strParameters, String userId)
			throws SQLException, JSONException {
		JSONObject objParameter  = new JSONObject(strParameters);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParameter.getString("setRows"))));
		params.put("evalId",objParameter.isNull("evalId") ? null : Integer.parseInt(objParameter.getString("evalId")));
		params.put("paytPayeeCdMan",objParameter.isNull("paytPayeeCdMan") ? null : Integer.parseInt(objParameter.getString("paytPayeeCdMan")));
		params.put("paytPayeeTypeCdMan", objParameter.getString("paytPayeeTypeCdMan"));
		params.put("userId", userId);
		getGiclReplaceDAO().applyChangePayee(params);
	}

	


}
