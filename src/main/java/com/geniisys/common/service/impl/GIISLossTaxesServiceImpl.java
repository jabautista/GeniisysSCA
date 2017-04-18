package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISLossTaxesDAO;
import com.geniisys.common.entity.GIISLossTaxLine;
import com.geniisys.common.entity.GIISLossTaxes;
import com.geniisys.common.service.GIISLossTaxesService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISLossTaxesServiceImpl implements GIISLossTaxesService {
	
	private GIISLossTaxesDAO giisLossTaxesDAO;
	
	public JSONObject showGicls106(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls106RecList");		
		params.put("taxType", request.getParameter("taxType"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("airTypeCd") != null){
			String airTypeCd = request.getParameter("airTypeCd");
			return this.giisLossTaxesDAO.valDeleteRec(airTypeCd);
		} else {
			return null;
		}
		
	}

	public void saveGicls106(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLossTaxes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLossTaxes.class));
		params.put("appUser", userId);
		this.giisLossTaxesDAO.saveGicls106(StringFormatter.escapeHTMLInMap(params));
	}

	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("airTypeCd") != null){
			String recId = request.getParameter("airTypeCd");
			this.giisLossTaxesDAO.valAddRec(recId);
		}
	}
	
	@Override
	public Map<String, Object> validateGicls106Tax(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		return this.giisLossTaxesDAO.validateGicls106Tax(StringFormatter.escapeHTMLInMap(params));
	}
	
	@Override
	public Map<String, Object> validateGicls106Branch(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		return this.giisLossTaxesDAO.validateGicls106Branch(StringFormatter.escapeHTMLInMap(params));
	}
	
	public JSONObject showTaxRateHistory(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls106TaxRateHistory");		
		params.put("lossTaxId", request.getParameter("lossTaxId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public JSONObject showCopyTax(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls106CopyTax");		
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	} 
	
	public void copyTaxToIssuingSource(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxType", request.getParameter("taxType"));
		params.put("taxCd", Integer.parseInt(request.getParameter("taxCd")));
		params.put("taxName", request.getParameter("taxName"));
		params.put("taxRate", Integer.parseInt(request.getParameter("taxRate")));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("glAcctId", Integer.parseInt(request.getParameter("glAcctId")));
		params.put("slTypeCd", request.getParameter("slTypeCd"));
		params.put("remarks", request.getParameter("remarks"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("appUser", userId);
		this.giisLossTaxesDAO.copyTaxToIssuingSource(params);
	}
	
	public Map<String, Object> validateGicls106LossTaxes(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxType", request.getParameter("taxType"));
		params.put("issCd", request.getParameter("issCd"));
		//return this.giisLossTaxesDAO.validateGicls106LossTaxes(StringFormatter.escapeHTMLInMap(params));
		return this.giisLossTaxesDAO.validateGicls106LossTaxes(params);
	}
	
	public JSONObject showLineLossExp(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls106LineLossExp");		
		params.put("lossTaxId", request.getParameter("lossTaxId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public void saveLineLossExp(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLossTaxLine.class));
		params.put("appUser", userId);
		this.giisLossTaxesDAO.saveLineLossExp(StringFormatter.escapeHTMLInMap(params));
	}
	
	public String valLineLossExp(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lossTaxId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("lossTaxId", request.getParameter("lossTaxId"));
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("lossExpCd", request.getParameter("lossExpCd"));
			return this.giisLossTaxesDAO.valLineLossExp(StringFormatter.escapeHTMLInMap(params));
		} else {
			return null;
		}
	}
	
	@Override
	public Map<String, Object> validateGicls106Line(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		return this.giisLossTaxesDAO.validateGicls106Line(StringFormatter.escapeHTMLInMap(params));
	}
	
	@Override
	public Map<String, Object> validateGicls106LossExp(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		return this.giisLossTaxesDAO.validateGicls106LossExp(StringFormatter.escapeHTMLInMap(params));
	}
	
	public JSONObject showLineLossExpHistory(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "gicls106LineLossExpHistory");		
		params.put("lossTaxId", request.getParameter("lossTaxId"));
		params.put("lineCd", StringFormatter.unescapeHTML2(request.getParameter("lineCd")));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	public void copyTaxToIssuingSourceAndTaxLine(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxType", request.getParameter("taxType"));
		params.put("taxCd", Integer.parseInt(request.getParameter("taxCd")));
		params.put("taxName", request.getParameter("taxName"));
		params.put("taxRate", Integer.parseInt(request.getParameter("taxRate")));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("glAcctId", Integer.parseInt(request.getParameter("glAcctId")));
		params.put("slTypeCd", request.getParameter("slTypeCd"));
		params.put("remarks", request.getParameter("remarks"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("origIssCd", request.getParameter("origIssCd"));
		params.put("appUser", userId);
		this.giisLossTaxesDAO.copyTaxToIssuingSourceAndTaxLine(params);
	}
	
	public GIISLossTaxesDAO getGiisLossTaxesDAO() {
		return giisLossTaxesDAO;
	}

	public void setGiisLossTaxesDAO(GIISLossTaxesDAO giisLossTaxesDAO) {
		this.giisLossTaxesDAO = giisLossTaxesDAO;
	}
	
	@Override
	public Map<String, Object> checkCopyTaxLineBtn(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lossTaxId", request.getParameter("lossTaxId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", userId);
		return this.giisLossTaxesDAO.checkCopyTaxLineBtn(params);
	}
}
