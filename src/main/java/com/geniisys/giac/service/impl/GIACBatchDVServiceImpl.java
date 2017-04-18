/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.giac.service.impl
	File Name: GIACBatchDVServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 8, 2011
	Description: 
*/


package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACBatchDVDAO;
import com.geniisys.giac.service.GIACBatchDVService;
import com.seer.framework.util.StringFormatter;

public class GIACBatchDVServiceImpl implements GIACBatchDVService{
	private GIACBatchDVDAO giacBatchDVDAO;
	
	@Override
	public Map<String, Object> getSpecialCSRListing(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getSpecialCSRListing");
		params.put("userId", USER.getUserId());
		params.put("pageSize", ApplicationWideParameters.PAGE_SIZE);
		params.put("branchCd", request.getParameter("branchCd"));// added for GIACS055
		params.put("claimId", request.getParameter("claimId"));
		System.out.println(params);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("paramBranchCd",request.getParameter("branchCd"));
		request.setAttribute("specialCSRListingTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	/**
	 * @param giacBatchDVDAO the giacBatchDVDAO to set
	 */
	public void setGiacBatchDVDAO(GIACBatchDVDAO giacBatchDVDAO) {
		this.giacBatchDVDAO = giacBatchDVDAO;
	}

	/**
	 * @return the giacBatchDVDAO
	 */
	public GIACBatchDVDAO getGiacBatchDVDAO() {
		return giacBatchDVDAO;
	}

	@Override
	public void cancelGIACBatch(Map<String, Object> params) throws SQLException {
		this.getGiacBatchDVDAO().cancelGIACBatch(params);
		
	}

	@Override
	public Map<String, Object> getGIACS086AcctTransTableGrid(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS086AcctTransTableGrid");
		params.put("userId", USER.getUserId());
		params.put("batchDvId", request.getParameter("batchDvId"));
		params.put("pageSize", 5);
		System.out.println("batchDvId: "+request.getParameter("batchDvId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("acctTransTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public Map<String, Object> getGIACS086AcctEntPostQuery(
			Map<String, Object> params) throws SQLException {
		return this.getGiacBatchDVDAO().getGIACS086AcctEntPostQuery(params);
	}
	
	public JSONObject getGIACS087Listing(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS087Listing");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	public JSONObject getGIACS087BatchDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS087BatchDetails");		
		params.put("batchDvId", request.getParameter("batchDvId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	public JSONObject getGIACS087AcctEntries(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS087AcctEntries");		
		params.put("batchDvId", request.getParameter("batchDvId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	public JSONObject getGIACS087AcctEntriesDtl(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS087AcctEntriesDtl");		
		params.put("tranId", request.getParameter("tranId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	public JSONObject getGIACS087AcctEntTotals(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", request.getParameter("tranId"));
		params.put("branchCd", request.getParameter("branchCd"));
		
		return new JSONObject(this.getGiacBatchDVDAO().getGIACS087AcctEntTotals(params));
	}

}
