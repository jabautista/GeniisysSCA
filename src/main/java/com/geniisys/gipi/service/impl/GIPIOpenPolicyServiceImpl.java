package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOpenPolicyDAO;
import com.geniisys.gipi.entity.GIPIOpenPolicy;
import com.geniisys.gipi.service.GIPIOpenPolicyService;
import com.seer.framework.util.StringFormatter;

public class GIPIOpenPolicyServiceImpl implements GIPIOpenPolicyService{
	
	private GIPIOpenPolicyDAO gipiOpenPolicyDAO;

	public GIPIOpenPolicyDAO getGipiOpenPolicyDAO() {
		return gipiOpenPolicyDAO;
	}

	public void setGipiOpenPolicyDAO(GIPIOpenPolicyDAO gipiOpenPolicyDAO) {
		this.gipiOpenPolicyDAO = gipiOpenPolicyDAO;
	}

	@Override
	public GIPIOpenPolicy getEndtseq0OpenPolicy(Integer policyEndSeq0)throws SQLException {
		return this.getGipiOpenPolicyDAO().getEndtseq0OpenPolicy(policyEndSeq0);
	}

	@Override
	public JSONObject getOpenPolicyList(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOpPolicyList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("opSublineCd", request.getParameter("opSublineCd"));
		params.put("opIssCd", request.getParameter("opIssCd"));
		params.put("opIssueYy", (request.getParameter("opIssueYy") != null && !request.getParameter("opIssueYy").equals("")) ? Integer.parseInt(request.getParameter("opIssueYy")) : null);
		params.put("opPolSeqNo", (request.getParameter("opPolSeqNo") != null && !request.getParameter("opPolSeqNo").equals("")) ? Integer.parseInt(request.getParameter("opPolSeqNo")) : null);
		params.put("opRenewNo", (request.getParameter("opRenewNo") != null && !request.getParameter("opRenewNo").equals("")) ? Integer.parseInt(request.getParameter("opRenewNo")) : null);
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("inceptDate", (request.getParameter("inceptDate") != null && !request.getParameter("inceptDate").equals("")) ? request.getParameter("inceptDate") : null);
		params.put("expiryDate", (request.getParameter("expiryDate") != null && !request.getParameter("expiryDate").equals("")) ? request.getParameter("expiryDate") : null);
		params.put("userId", userId);
		params.put("moduleId", "GIPIS199");
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public JSONObject getOpenLiabFiMn(HttpServletRequest request)
			throws SQLException, JSONException {
		String policyId = request.getParameter("policyId").toString();		
		return new JSONObject(StringFormatter.escapeHTMLInMap(gipiOpenPolicyDAO.getOpenLiabFiMn(policyId)));
	}

	@Override
	public JSONObject getOpenCargos(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOpenCargos");
		params.put("policyId", request.getParameter("policyId"));
		params.put("geogCd", request.getParameter("geogCd"));		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(map);
	}
	
	@Override
	public JSONObject getOpenPerils(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOpenPerils");
		params.put("policyId", request.getParameter("policyId"));
		params.put("geogCd", request.getParameter("geogCd"));		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(map);
	}
}
