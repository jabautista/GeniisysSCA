/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACPdcPremCollnDAO;
import com.geniisys.giac.entity.GIACPdcPremColln;
import com.geniisys.giac.service.GIACPdcPremCollnService;
import com.seer.framework.util.StringFormatter;

public class GIACPdcPremCollnServiceImpl implements GIACPdcPremCollnService{

	private GIACPdcPremCollnDAO giacPdcPremCollnDAO;
	
	@Override
	public List<GIACPdcPremColln> getDatedChkDtls(Integer gaccTranId) throws SQLException {
		return giacPdcPremCollnDAO.getDatedChkDtls(gaccTranId);
	}

	/**
	 * @return the giacPdcPremCollnDAO
	 */
	public GIACPdcPremCollnDAO getGiacPdcPremCollnDAO() {
		return giacPdcPremCollnDAO;
	}

	/**
	 * @param giacPdcPremCollnDAO the giacPdcPremCollnDAO to set
	 */
	public void setGiacPdcPremCollnDAO(GIACPdcPremCollnDAO giacPdcPremCollnDAO) {
		this.giacPdcPremCollnDAO = giacPdcPremCollnDAO;
	}

	/**
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPostDatedCheckDtls(HashMap<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		@SuppressWarnings("unused")
		Integer pdcId = Integer.parseInt(params.get("pdcId").toString());
		params.put("filter", this.preparePdcPremCollnFilter(params.get("filter") == null ? null : params.get("filter").toString()));
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACPdcPremColln> list = this.giacPdcPremCollnDAO.getPostDatedCheckDtls(params);
		params.put("rows", new JSONArray((List<GIACPdcPremColln>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcPremCollnService#validatePremSeqNo(java.util.Map)
	 */
	public HashMap<String, Object> validatePremSeqNo(Map<String, Object> params)
		throws SQLException {
		return this.giacPdcPremCollnDAO.validatePremSeqNo(params);
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> preparePdcPremCollnFilter(String filter) throws JSONException {
		Map<String, Object> pdcPremCollnMap = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		if (null == filter){
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		pdcPremCollnMap.put("collnAmt", jsonFilter.isNull("collnAmt") ? "%%" : '%'+jsonFilter.getString("collnAmt")+'%');
		pdcPremCollnMap.put("issCd", jsonFilter.isNull("issCd") ? "%%" : '%'+jsonFilter.getString("issCd").toUpperCase()+'%');
		pdcPremCollnMap.put("tranType", jsonFilter.isNull("tranType") ? "%%" : '%'+jsonFilter.getString("tranType")+'%');
		
		return pdcPremCollnMap;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcPremCollnService#getPdcPremCollnDtls(java.util.Map)
	 */
	public HashMap<String, Object> getPdcPremCollnDtls(Map<String, Object> params)
		throws SQLException {
		return this.giacPdcPremCollnDAO.getPdcPremCollnDtls(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcPremCollnService#fetchPremCollnUpdateValues(java.util.Map)
	 */
	public HashMap<String, Object> fetchPremCollnUpdateValues(Map<String, Object> params)
		throws SQLException {
		return this.giacPdcPremCollnDAO.fetchPremCollnUpdateValues(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcPremCollnService#getParticulars(java.util.Map)
	 */
	public String getParticulars(Map<String, Object> params)
		throws SQLException {
		return this.giacPdcPremCollnDAO.getParticulars(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACPdcPremCollnService#getParticulars2(java.util.Map)
	 */
	public String getParticulars2(Map<String, Object> params)
		throws SQLException {
		return this.giacPdcPremCollnDAO.getParticulars2(params);
	}

	@Override
	public JSONObject getPremCollnUpdateValues(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("apdcId",request.getParameter("apdcId"));
		params.put("pdcId",request.getParameter("pdcId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("updateFlag", request.getParameter("updateFlag")); //benjo 11.08.2016 SR-5802
		this.giacPdcPremCollnDAO.getPremCollnUpdateValues(params);
		
		JSONObject json = new JSONObject(params);
		return json;
	}
	
	@Override
	public String getRefPolNo(HttpServletRequest request) throws SQLException { //benjo 11.08.2016 SR-5802
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		return this.giacPdcPremCollnDAO.getRefPolNo(params);
	}
	
	@Override
	public String validatePolicy(HttpServletRequest request) throws SQLException { //benjo 11.08.2016 SR-5802
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("checkDue", request.getParameter("checkDue"));
		return this.giacPdcPremCollnDAO.validatePolicy(params);
	}

	@Override
	public List<Map<String, Object>> getPolicyInvoices(HttpServletRequest request) throws SQLException { //benjo 11.08.2016 SR-5802
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("checkDue", request.getParameter("checkDue"));
		return this.giacPdcPremCollnDAO.getPolicyInvoices(params);
	}
	
	@Override
	public Map<String, Object> getPackInvoices(HttpServletRequest request) throws SQLException, JSONException { //benjo 11.08.2016 SR-5802
		request.setAttribute("packLineCd", request.getParameter("lineCd"));
		request.setAttribute("packSublineCd", request.getParameter("sublineCd"));
		request.setAttribute("packIssCd", request.getParameter("issCd"));
		request.setAttribute("packIssueYy", request.getParameter("issueYy"));
		request.setAttribute("packPolSeqNo", request.getParameter("polSeqNo"));
		request.setAttribute("packRenewNo", request.getParameter("renewNo"));
		request.setAttribute("packCheckDue", request.getParameter("checkDue"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("packLineCd", request.getParameter("lineCd"));
		params.put("packSublineCd", request.getParameter("sublineCd"));
		params.put("packIssCd", request.getParameter("issCd"));
		params.put("packIssueYy", request.getParameter("issueYy"));
		params.put("packPolSeqNo", request.getParameter("polSeqNo"));
		params.put("packRenewNo", request.getParameter("renewNo"));
		params.put("packCheckDue", request.getParameter("checkDue"));
		params.put("ACTION", "getPackInvoicesGiacs090");
		return TableGridUtil.getTableGrid(request, params);
	}
}
