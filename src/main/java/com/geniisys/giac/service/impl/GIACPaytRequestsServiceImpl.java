package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giac.dao.GIACPaytRequestsDAO;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;
import com.geniisys.giac.entity.GIACPaytRequestsDtl;
import com.geniisys.giac.service.GIACPaytRequestsService;
import com.seer.framework.util.StringFormatter;

public class GIACPaytRequestsServiceImpl implements GIACPaytRequestsService{

	private GIACPaytRequestsDAO giacPaytRequestsDAO;

	public GIACPaytRequestsDAO getGiacPaytRequestsDAO() {
		return giacPaytRequestsDAO;
	}

	public void setGiacPaytRequestsDAO(GIACPaytRequestsDAO giacPaytRequestsDAO) {
		this.giacPaytRequestsDAO = giacPaytRequestsDAO;
	}

	@Override
	/*
	 * modified from void to JSONObject; shan 08.29.2013 for GIACS070
	 * 
	 */
	public JSONObject getGiacPaytRequests(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("refId", request.getParameter("refId"));
		Object row = this.giacPaytRequestsDAO.getGiacPaytRequests(params);
		//request.setAttribute("giacPaytRequests", row == null ? new JSONObject(new GIACPaytRequests()) :new JSONObject(StringFormatter.escapeHTMLInObject(row)));
		JSONObject info = row == null ? new JSONObject(new GIACPaytRequests()) :new JSONObject(StringFormatter.escapeHTMLInObject(row));
		request.setAttribute("giacPaytRequests", info);
		return info;
	}

	@Override
	public void saveDisbursmentRequest(HttpServletRequest request, String userID)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		System.out.println(request.getParameter("parameters"));
		System.out.println(objParams);
		GIACPaytRequests giacPaytRequests = (GIACPaytRequests) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giacPaytRequests")), userID, GIACPaytRequests.class);
		GIACPaytRequestsDtl giacPaytRequestsDtl  = (GIACPaytRequestsDtl) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giactPayRequestsDtl")), userID, GIACPaytRequestsDtl.class);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("giacPaytRequests", giacPaytRequests);
		params.put("giacPaytRequestsDtl", giacPaytRequestsDtl);
		params.put("userId",userID);
		params.put("newRec", request.getParameter("newRec"));
		getGiacPaytRequestsDAO().saveDisbursmentRequest(params);
		
	}

	@Override
	public String getClosedTag(Map<String, Object> params) throws SQLException {
		return getGiacPaytRequestsDAO().getClosedTag(params);
	}
		
	@Override
	public Map<String, Object> getFundBranchDesc(Map<String, Object> params)
			throws SQLException {
		return getGiacPaytRequestsDAO().getFundBranchDesc(params);
	}

	@Override
	public void valAmtBeforeClosing(Map<String, Object> params)
			throws SQLException {
		getGiacPaytRequestsDAO().valAmtBeforeClosing(params);
	}

	@Override
	public Map<String, Object> populateChkTags(Map<String, Object> params)
			throws SQLException {
		return getGiacPaytRequestsDAO().populateChkTags(params);
	}

	@Override
	public void closeRequest(HttpServletRequest request, String userID)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		GIACPaytRequests giacPaytRequests = (GIACPaytRequests) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giacPaytRequests")), userID, GIACPaytRequests.class);
		GIACPaytRequestsDtl giacPaytRequestsDtl  = (GIACPaytRequestsDtl) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("giactPayRequestsDtl")), userID, GIACPaytRequestsDtl.class);
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("refId", giacPaytRequests.getRefId());
		params.put("reqDtlNo", giacPaytRequestsDtl.getReqDtlNo());
		params.put("tranId", giacPaytRequestsDtl.getTranId());
		params.put("userId", userID);
		params.put("documentCd", giacPaytRequests.getDocumentCd());
		params.put("branchCd", giacPaytRequests.getBranchCd());
		params.put("lineCd", giacPaytRequests.getLineCd());
		params.put("docYear", giacPaytRequests.getDocYear());
		params.put("docMm", giacPaytRequests.getDocMm());
		params.put("docSeqNo", giacPaytRequests.getDocSeqNo());
		
		getGiacPaytRequestsDAO().closeRequest(params);
	}

	@Override
	public void cancelPaymentRequest(Map<String, Object> params)
			throws SQLException {
		getGiacPaytRequestsDAO().cancelPaymentRequest(params);
	}

	@Override
	public List<GIISLine> getPaymentLinesList(Map<String, Object> params) throws SQLException {
		return this.getGiacPaytRequestsDAO().getPaymentLinesList(params);
	}

	@Override
	public List<GIACPaytRequests> getPaymentDocYear(Map<String, Object> params) throws SQLException {
		return this.getGiacPaytRequestsDAO().getPaymentDocYear(params);
	}

	@Override
	public List<GIACPaytRequests> getPaymentDocMm(Map<String, Object> params) throws SQLException {
		return this.getGiacPaytRequestsDAO().getPaymentDocMm(params);
	}

	@Override
	public GIACPaytRequests validateDocSeqNo(Map<String, Object> params) throws SQLException {
		return this.getGiacPaytRequestsDAO().validateDocSeqNo(params);
	}

	@Override
	public void validatePaytLineCd(Map<String, Object> params) throws SQLException {
		this.getGiacPaytRequestsDAO().validatePaytLineCd(params);
	}

	@Override
	public void validatePaytDocYear(Map<String, Object> params) throws SQLException {
		this.getGiacPaytRequestsDAO().validatePaytDocYear(params);		
	}

	@Override
	public void validatePaytDocMm(Map<String, Object> params) throws SQLException {
		this.getGiacPaytRequestsDAO().validatePaytDocMm(params);		
	}

	@Override
	public JSONObject getGIACS016PaytReqOtherDetails(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", Integer.parseInt((request.getParameter("tranId").equals("") || request.getParameter("tranId").equals("null")) ? "0" : request.getParameter("tranId")));
		params.put("documentCd", request.getParameter("documentCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("docYear", Integer.parseInt(request.getParameter("docYear")));
		params.put("docMm", Integer.parseInt(request.getParameter("docMm")));
		params.put("docSeqNo", Integer.parseInt(request.getParameter("docSeqNo")));
		params.put("paytReqFlag", request.getParameter("paytReqFlag"));
		
		this.giacPaytRequestsDAO.getGIACS016PaytReqOtherDetails(params);
		
		return new JSONObject(params);
	}

	@Override
	public List<GIACPaytReqDocs> getGIACPaytReqDocsList(
			Map<String, Object> params) throws SQLException {
		return giacPaytRequestsDAO.getGIACPaytReqDocsList(params);
	}

	@Override
	public void extractCommFund(Map<String, Object> params) throws SQLException {
		this.getGiacPaytRequestsDAO().extractCommFund(params);
	}

	@Override
	public Map<String, Object> checkCommFundSlip(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("userId", userId);
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("parameters"))));
		return this.getGiacPaytRequestsDAO().checkCommFundSlip(params);
	}

	/*
	 * Added by reymon 06182013
	 * process after printing comm fund slip
	 */
	@Override
	public void processAfterPrinting(Map<String, Object> params)
			throws SQLException {
		this.getGiacPaytRequestsDAO().processAfterPrinting(params);
		
	}
	
}
