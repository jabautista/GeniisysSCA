/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLMcEvaluationServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jan 16, 2012
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLMcEvaluationDAO;
import com.geniisys.gicl.entity.GICLMcEvaluation;
import com.geniisys.gicl.entity.GICLMcTpDtl;
import com.geniisys.gicl.service.GICLMcEvaluationService;
import com.seer.framework.util.StringFormatter;

public class GICLMcEvaluationServiceImpl implements GICLMcEvaluationService{
	private GICLMcEvaluationDAO giclMcEvaluationDAO;
	
	public Map<String, Object> getClaimPolicyInfo(Map<String, Object> params)
			throws SQLException {
		return this.getGiclMcEvaluationDAO().getClaimPolicyInfo(params);
	}

	/**
	 * @param giclMcEvaluationDAO the giclMcEvaluationDAO to set
	 */
	public void setGiclMcEvaluationDAO(GICLMcEvaluationDAO giclMcEvaluationDAO) {
		this.giclMcEvaluationDAO = giclMcEvaluationDAO;
	}

	/**
	 * @return the giclMcEvaluationDAO
	 */
	public GICLMcEvaluationDAO getGiclMcEvaluationDAO() {
		return giclMcEvaluationDAO;
	}

	@Override
	public Map<String, Object> getMcEvaluationTGList(
			HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = null;
		try {
			params = FormInputUtil.getFormInputs(request);
		} catch (Exception e) {
			e.printStackTrace();
		}
		params.put("ACTION", "getMcEvaluationTGList");
		params.put("userId", USER.getUserId());
		params.put("pageSize", 5);
		System.out.println(params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("mcEvalTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public Map<String, Object> getVariables(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().getVariables(params);
	}

	@Override
	public void saveMCEvaluationReport(JSONObject jsonObj, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("user", USER);
		params.put("mcMainObj", JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("mcMainObj"))));
		params.put("newEval",JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("newEval"))));
		params.put("extraParam", JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("extraParam"))));
		params.put("varMcMainObj", JSONUtil.prepareMapFromJSON(new JSONObject(jsonObj.getString("varMcMainObj"))));
		this.getGiclMcEvaluationDAO().saveMCEvaluationReport(params);
	}

	@Override
	public void updateMcEvaluationReport(Map<String, Object> params)
			throws SQLException {
		System.out.println("beeeeeeeeeeeeerrrrrrrrrrrrtttttttttttttttt::: " + params.toString());
		this.getGiclMcEvaluationDAO().updateMcEvaluationReport(params);
	}

	@Override
	public void cancelMcEvalreport(GICLMcEvaluation giclMcEval, String userId)
			throws SQLException {
		getGiclMcEvaluationDAO().cancelMcEvalreport(giclMcEval, userId);
	}

	@Override
	public GICLMcTpDtl getGiclMcTpDtlVehicleInfo(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().getGiclMcTpDtlVehicleInfo(params);
	}

	@Override
	public Map<String, Object> getGiclMotorCarDtlVehicleInfo(
			Map<String, Object> params) throws SQLException {
		return getGiclMcEvaluationDAO().getGiclMotorCarDtlVehicleInfo(params);
	}
	
	@Override
	public String validateBeforePostMap(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().validateBeforePostMap(params);
	}

	@Override
	public void postEvalReport(Map<String, Object> params) throws SQLException {
		getGiclMcEvaluationDAO().postEvalReport(params);
	}

	@Override
	public void createSettlementForReport(Map<String, Object> params)
			throws SQLException {
		getGiclMcEvaluationDAO().createSettlementForReport(params);
		
	}

	@Override
	public String validateOverrideUserMcEval(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().validateOverrideUserMcEval(params);
	}

	@Override
	public void updateEvalDepVatAmt(Map<String, Object> params)
			throws SQLException {
		getGiclMcEvaluationDAO().updateEvalDepVatAmt(params);
	}

	@Override
	public void createSettlementForLossExpEvalReport(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("evalId", request.getParameter("evalId"));
		params.put("paramPerilCd", request.getParameter("paramPerilCd"));
		params.put("userId", USER.getUserId());
		this.getGiclMcEvaluationDAO().createSettlementForLossExpEvalReport(params);
		
	}

	@Override
	public Map<String, Object> popGiclMcEval(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().popGiclMcEval(params);
	}

	@Override
	public Map<String, Object> checkEvalCSLOverrideRequestExist(
			Map<String, Object> params) throws SQLException {
		return getGiclMcEvaluationDAO().checkEvalCSLOverrideRequestExist(params);
	}

	@Override
	public Map<String, Object> getMcItemPeril(Map<String, Object> params)
			throws SQLException {
		return getGiclMcEvaluationDAO().getMcItemPeril(params);
	}

	
}
