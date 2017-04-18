package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.giuts.dao.GIUTS008CopyPolicyDAO;
import com.geniisys.giuts.service.GIUTS008CopyPolicyService;

public class GIUTS008CopyPolicyServiceImpl implements GIUTS008CopyPolicyService{
	
	private GIUTS008CopyPolicyDAO giuts008CopyPolicyDAO;

	public GIUTS008CopyPolicyDAO getGiuts008CopyPolicyDAO() {
		return giuts008CopyPolicyDAO;
	}

	public void setGiuts008CopyPolicyDAO(GIUTS008CopyPolicyDAO giuts008CopyPolicyDAO) {
		this.giuts008CopyPolicyDAO = giuts008CopyPolicyDAO;
	}

	public String validateLineCd(String lineCd) throws SQLException,
			ParseException {
		return this.giuts008CopyPolicyDAO.validateLineCd(lineCd);
	}
	
	public String validateGIUTS008LineCd(HttpServletRequest request, GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", USER.getUserId());
		params.put("moduleId",request.getParameter("moduleId"));
		return this.getGiuts008CopyPolicyDAO().validateGIUTS008LineCd(params);
	}

	@Override
	public String validateOpFlag(HashMap<String, Object> params)
			throws SQLException, ParseException {
		// TODO Auto-generated method stub
		return this.giuts008CopyPolicyDAO.validateOpFlag(params);
	}

	@Override
	public Integer validateUserPassIssCd(HashMap<String, Object> params)
			throws SQLException, ParseException {
		// TODO Auto-generated method stub
		return this.giuts008CopyPolicyDAO.validateUserPackIssCd(params);
	}

	@Override
	public Integer getPolicyId(HashMap<String, Object> params)
			throws SQLException, ParseException {
		// TODO Auto-generated method stub
		return this.giuts008CopyPolicyDAO.getPolicyId(params);
	}

	@Override
	public String copyMainQuery(HashMap<String, Object> params)
			throws SQLException, ParseException {
		// TODO Auto-generated method stub
		return this.giuts008CopyPolicyDAO.copyMainQuery(params);
	}

	@Override
	public HashMap<String, Object> copyPARPolicyMainQuery(HashMap<String, Object> params)
			throws JSONException, Exception {
			return this.giuts008CopyPolicyDAO.copyPARPolicyMainQuery(params);
		
		
	}

	@Override
	public Map<String, Object> copyPolicyEndtToPAR(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("nbtLineCd", request.getParameter("nbtLineCd"));
		params.put("nbtSublineCd", request.getParameter("nbtSublineCd"));
		params.put("nbtIssCd", request.getParameter("nbtIssCd"));
		params.put("nbtIssueYy", request.getParameter("nbtIssueYy") == null || request.getParameter("nbtIssueYy").equals("") ? 0 : Integer.parseInt(request.getParameter("nbtIssueYy")));
		params.put("nbtPolSeqNo", request.getParameter("nbtPolSeqNo") == null || request.getParameter("nbtPolSeqNo").equals("") ? 0 : Integer.parseInt(request.getParameter("nbtPolSeqNo")));
		params.put("nbtRenewNo", request.getParameter("nbtRenewNo") == null || request.getParameter("nbtRenewNo").equals("") ? 0 : Integer.parseInt(request.getParameter("nbtRenewNo")));
		params.put("nbtEndtIssCd", request.getParameter("nbtEndtIssCd"));
		params.put("nbtEndtYy", request.getParameter("nbtEndtYy") == null || request.getParameter("nbtEndtYy").equals("") ? 0 : Integer.parseInt(request.getParameter("nbtEndtYy")));
		params.put("nbtEndtSeqNo", request.getParameter("nbtEndtSeqNo") == null || request.getParameter("nbtEndtSeqNo").equals("") ? 0 : Integer.parseInt(request.getParameter("nbtEndtSeqNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", USER.getUserId());
		return this.getGiuts008CopyPolicyDAO().copyPolicyEndtToPAR(params);
	}
	
	
}
