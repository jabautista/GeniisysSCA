package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.giuts.dao.CopyUtilitiesDAO;
import com.geniisys.giuts.service.CopyUtilitiesService;

public class CopyUtilitiesServiceImpl implements CopyUtilitiesService{
	
	private CopyUtilitiesDAO copyUtilitiesDAO;
	
	public CopyUtilitiesDAO getCopyUtilitiesDAO() {
		return copyUtilitiesDAO;
	}

	public void setCopyUtilitiesDAO(CopyUtilitiesDAO copyUtilitiesDAO) {
		this.copyUtilitiesDAO = copyUtilitiesDAO;
	}

	@Override
	public String summarizePolToPar(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("parIssCd", request.getParameter("parIssCd"));
		params.put("spldPolSw", request.getParameter("spldPolSw"));
		params.put("spldEndtSw", request.getParameter("spldEndtSw"));
		params.put("cancelSw", request.getParameter("cancelSw"));
		params.put("expiredSw", request.getParameter("expiredSw"));
		params.put("userId", userId);
		params.put("moduleId", "GIUTS009");
		System.out.println("Begin summary of pol to par - "+params);
		JSONObject result = new JSONObject(this.getCopyUtilitiesDAO().summarizePolToPar(params));
		System.out.println("Test Result - "+result);
		return result.toString();
	}

	@Override
	public void checkIfPolicyExists(Map<String, Object> params)
			throws SQLException {
		this.getCopyUtilitiesDAO().checkIfPolicyExists(params);
	}

	@Override
	public void checkPolicy(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("spldPolSw", request.getParameter("spldPolSw"));
		params.put("spldEndtSw", request.getParameter("spldEndtSw"));
		params.put("cancelSw", request.getParameter("cancelSw"));
		params.put("expiredSw", request.getParameter("expiredSw"));
		params.put("userId", userId);
		System.out.println("Checking policy - "+params);
		this.getCopyUtilitiesDAO().checkPolicy(params);
	}

	@Override
	public void validateLine(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("spldPolSw", request.getParameter("spldPolSw"));
		params.put("spldEndtSw", request.getParameter("spldEndtSw"));
		params.put("cancelSw", request.getParameter("cancelSw"));
		params.put("expiredSw", request.getParameter("expiredSw"));
		params.put("userId", userId);
		System.out.println("Validating Line - "+params);
		this.getCopyUtilitiesDAO().validateLine(params);
	}

	@Override
	public void validateIssCd(HttpServletRequest request,
			String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("userId", userId);
		System.out.println("Validating Iss Cd - "+params);
		this.getCopyUtilitiesDAO().validateIssCd(params);
	}

	//GIUTS008A
	@Override
	public String validateLineCdGiuts008a(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", request.getParameter("userId"));//added by reymon 05042013
		String message = this.getCopyUtilitiesDAO().validateLineCdGiuts008a(params);
		return message;
	}

	@Override
	public String validateIssCdGiuts008a(HttpServletRequest request) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("userId", request.getParameter("userId"));//added by reymon 05072013
		String allow = this.getCopyUtilitiesDAO().validateIssCdGiuts008a(params);
		return allow;
	}

	@Override
	public String copyPackPolicyGiuts008a(HttpServletRequest request, String userId) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("parIssCd", request.getParameter("parIssCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("endtIssCd", request.getParameter("endtIssCd"));
		params.put("endtYy", request.getParameter("endtYy") == "" ? null : Integer.parseInt(request.getParameter("endtYy")));
		params.put("endtSeqNo", request.getParameter("endtSeqNo") == "" ? null : Integer.parseInt(request.getParameter("endtSeqNo")));
		params.put("userId", userId);
		JSONObject result = new JSONObject(this.getCopyUtilitiesDAO().copyPackPolicyGiuts008a(params));
		return result.toString();
	}

	@Override
	public void validateParIssCd(HttpServletRequest request, String userId)
			throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("parIssCd", request.getParameter("parIssCd"));
		params.put("userId", userId);
		System.out.println("Validating Par Iss Cd - "+params.toString());
		this.getCopyUtilitiesDAO().validateParIssCd(params);
	}	
}
