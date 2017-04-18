package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
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
import com.geniisys.giex.dao.GIEXExpiriesVDAO;
import com.geniisys.giex.entity.GIEXExpiriesV;
import com.geniisys.giex.service.GIEXExpiriesVService;
import com.seer.framework.util.StringFormatter;

public class GIEXExpiriesVServiceImpl implements GIEXExpiriesVService{
	
	private GIEXExpiriesVDAO giexExpiriesVDAO;

	/**
	 * @param giexExpiriesVDAO the giexExpiriesVDAO to set
	 */
	public void setGiexExpiriesVDAO(GIEXExpiriesVDAO giexExpiriesVDAO) {
		this.giexExpiriesVDAO = giexExpiriesVDAO;
	}

	/**
	 * @return the giexExpiriesVDAO
	 */
	public GIEXExpiriesVDAO getGiexExpiriesVDAO() {
		return giexExpiriesVDAO;
	}
	
	@Override
	public HashMap<String, Object> getExpiredPolicies(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIEXExpiriesV> list = this.getGiexExpiriesVDAO().getExpiredPolicies(params);
		//params.put("rows", new JSONArray((List<GIEXExpiriesV>) StringFormatter.escapeHTMLInList(list)));
		params.put("rows", new JSONArray(list));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getQueriedExpiredPolicies(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIEXExpiriesV> list = this.getGiexExpiriesVDAO().getQueriedExpiredPolicies(params);
		params.put("rows", new JSONArray((List<GIEXExpiriesV>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public Map<String, Object> preFormGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().preFormGIEXS004(params);
	}

	@Override
	public Map<String, Object> postQueryGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().postQueryGIEXS004(params);
	}

	@Override
	public Map<String, Object> checkPolicyGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().checkPolicyGIEXS004(params);
	}

	@Override
	public Map<String, Object> checkRenewFlagGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().checkRenewFlagGIEXS004(params);
	}

	@Override
	public Map<String, Object> verifyOverrideRbGIEXS004(
			Map<String, Object> params) throws SQLException {
		return this.getGiexExpiriesVDAO().verifyOverrideRbGIEXS004(params);
	}

	@Override
	public Map<String, Object> processPostButtonGIEXS004(
			Map<String, Object> params) throws SQLException {
		return this.getGiexExpiriesVDAO().processPostButtonGIEXS004(params);
	}

	@Override
	public Map<String, Object> processPostOnOverrideGIEXS004(
			Map<String, Object> params) throws SQLException {
		return this.getGiexExpiriesVDAO().processPostOnOverrideGIEXS004(params);
	}

	@Override
	public Map<String, Object> saveProcessTagGIEXS004(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().saveProcessTagGIEXS004(params);
	}

	@Override
	public Map<String, Object> purgeBasedNotParam(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedNotParam(params);
	}

	@Override
	public Map<String, Object> purgeBasedNotTime(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedNotTime(params);
	}

	@Override
	public Map<String, Object> purgeBasedOnBeforeMonth(
			Map<String, Object> params) throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedOnBeforeMonth(params);
	}

	@Override
	public Map<String, Object> purgeBasedOnBeforeDate(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedOnBeforeDate(params);
	}
	
	@Override
	public Map<String, Object> purgeBasedExactMonth(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedExactMonth(params);
	}
	
	@Override
	public Map<String, Object> purgeBasedExactDate(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().purgeBasedExactDate(params);
	}
	
	@Override
	public Map<String, Object> checkNoOfRecordsToPurge(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().checkNoOfRecordsToPurge(params);
	}

	@Override
	public List<String> getPolicyIdGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getGiexExpiriesVDAO().getPolicyIdGiexs006(params);
	}

	@Override
	public Map<String, Object> getGiex004InitialVariables() throws SQLException {
		return getGiexExpiriesVDAO().getGiex004InitialVariables();
	}

	@Override
	public void giexs004ProcessPostButton(Map<String, Object> params)
			throws SQLException {
		getGiexExpiriesVDAO().giexs004ProcessPostButton(params);
	}

	@Override
	public void giexs004ProcessRenewal(Map<String, Object> params)
			throws SQLException {
		getGiexExpiriesVDAO().giexs004ProcessRenewal(params);
	}

	@Override
	public void giexs004ProcessPolicies(Map<String, Object> params)
			throws SQLException {
		System.out.println(params);
		getGiexExpiriesVDAO().giexs004ProcessPolicies(params);
	}
	
	@Override
	public JSONObject getExpiryRecord(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showAssignExtractedExpiryRecord");
		params.put("userId", USER.getUserId());
		params.put("fromDate", request.getParameter("fromDate"));	//start - Gzelle 07092015 SR4744 UW-SPECS-2015-065
		params.put("toDate", request.getParameter("toDate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("intmNo",(request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.put("byDate", request.getParameter("byDate"));		
		//System.out.println(USER.getAllUserSw().toString()); end - Gzelle 07302015 SR4744 UW-SPECS-2015-065
		Map<String, Object> assignExtractedExpiry = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonAssignExtractedExpiry = new JSONObject(assignExtractedExpiry);
		request.setAttribute("jsonAssignExtractedExpiry", jsonAssignExtractedExpiry);
		return jsonAssignExtractedExpiry;
	}

	@Override
	public String updateExpiryRecord(HttpServletRequest request, String USER) throws SQLException, ParseException, JSONException {
		String message = "";
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER, GIEXExpiriesV.class));
		message = this.getGiexExpiriesVDAO().updateExpiryRecord(params);
		System.out.println(params);
		return message;
	}

	@Override
	public String updateExpiriesByBatch(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("extractUser", request.getParameter("extractUser"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", USER.getUserId());
		params.put("byDate", request.getParameter("byDate"));
		//params.put("misSw", request.getParameter("misSw"));			  Gzelle 07212015 SR4744
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("credBranch", request.getParameter("credBranch"));	//Gzelle 07212015 SR4744
		//params.put("update", request.getParameter("update"));			  Gzelle 07212015 SR4744
		String policyId = null;
		policyId = request.getParameter("policy");
		if (policyId.length() <= 4000) {
			params.put("policyId1", policyId.substring(0, policyId.length()));
		}else if(policyId.length() <= 8000){
			params.put("policyId1", policyId.substring(0, 4000));
			params.put("policyId2", policyId.substring(4001,policyId.length()));
		}else if(policyId.length() <= 12000){
			params.put("policyId1", policyId.substring(0, 4000));
			params.put("policyId2", policyId.substring(4001,8000));
			params.put("policyId3", policyId.substring(8001,policyId.length()));
		}															
		params.put("statusTag", request.getParameter("statusTag"));	
		params.put("to", request.getParameter("to"));	//end Gzelle 07162015 SR4744
		message = this.getGiexExpiriesVDAO().updateExpiriesByBatch(params);
		return message;
	}

	@Override
	public Integer checkExtractUserAccess(HttpServletRequest request) throws SQLException {
		Integer check = 1;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("extractUser", request.getParameter("extractUser"));
		params.put("moduleId", "GIEXS008");
		check = this.getGiexExpiriesVDAO().checkExtractUserAccess(params);
		return check;
	}
	
	@Override
	public String checkRecords(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("extractUser", request.getParameter("extractUser"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", USER.getUserId());
		params.put("byDate", request.getParameter("byDate"));
		params.put("misSw", request.getParameter("misSw"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmNo", request.getParameter("intmNo").equals("") ? "" : Integer.parseInt(request.getParameter("intmNo")));
		System.out.println(params);
		return this.getGiexExpiriesVDAO().checkRecords(params);
	}

	@Override
	public String checkSubline(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		return this.getGiexExpiriesVDAO().checkSubline(params);
	}

	@Override
	public JSONObject showViewRenewal(HttpServletRequest request, String USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getViewRenewalList");
		params.put("user", USER);
	
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}

	@Override
	public JSONObject showRenewalHistory(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRenewalHistoryList");
		params.put("policyId", request.getParameter("policyId"));
	
		Map<String, Object> json = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonList = new JSONObject(json);
		return jsonList;
	}

}
