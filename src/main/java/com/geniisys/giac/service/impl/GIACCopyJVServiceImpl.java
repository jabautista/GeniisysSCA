package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.giac.dao.GIACCopyJVDAO;
import com.geniisys.giac.service.GIACCopyJVService;

public class GIACCopyJVServiceImpl implements GIACCopyJVService{
	
	private GIACCopyJVDAO giacCopyJVDAO;
	
	@SuppressWarnings("unused")
	private GIACCopyJVDAO giacCopyJVDAO(){
		return giacCopyJVDAO;
	}
	
	public void setGiacCopyJVDAO (GIACCopyJVDAO giacCopyJVDAO) {
		this.giacCopyJVDAO = giacCopyJVDAO;
	}

	@Override
	public String giacs051CheckCreateTransaction(HttpServletRequest request) throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("tranDate", request.getParameter("tranDate"));
		params.put("branchTo", request.getParameter("branchTo"));
		return giacCopyJVDAO.giacs051CheckCreateTransaction(params);
	}

	@Override
	public String giacs051CopyJV(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object>params = new HashMap<String, Object>();
		params.put("fundCdFrom", request.getParameter("fundCdFrom"));
		params.put("branchTo", request.getParameter("branchTo"));
		params.put("tranDateFrom", request.getParameter("tranDateFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		params.put("docMmFrom", request.getParameter("docMmFrom"));
		params.put("docSeqNoFrom", request.getParameter("docSeqNoFrom"));
		params.put("branchFrom", request.getParameter("branchFrom"));
		params.put("docYearTo", request.getParameter("docYearTo"));
		params.put("docMmTo", request.getParameter("docMmTo"));
		params.put("userId", userId);
		params.put("tranIdFrom", request.getParameter("tranIdFrom"));
		
		Map<String, Object> params2 =  giacCopyJVDAO.giacs051CopyJV(params);
		//String msg = (String) params2.get("newTranNo");
		String msg = (String) params2.get("newTranNo")+"#"+(String) params.get("tranIdAcc"); // bonok :: 10.10.2014
		return msg;
		
	}

	@Override
	public String giacs051ValidateBranchCdFrom(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCdFrom", request.getParameter("branchFrom"));
		params.put("userId", userId);
		return giacCopyJVDAO.giacs051ValidateBranchCdFrom(params);
	}

	@Override
	public String giacs051ValidateDocYear(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCdFrom", request.getParameter("branchFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		return giacCopyJVDAO.giacs051ValidateDocYear(params);
	}

	@Override
	public String giacs051ValidateDocMm(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCdFrom", request.getParameter("branchFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		params.put("docMmFrom", request.getParameter("docMmFrom"));
		return giacCopyJVDAO.giacs051ValidateDocMm(params);
	}

	@Override
	public Map<String, Object> giacs051ValidateDocSeqNo(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCdFrom", request.getParameter("branchFrom"));
		params.put("docYearFrom", request.getParameter("docYearFrom"));
		params.put("docMmFrom", request.getParameter("docMmFrom"));
		params.put("docSeqNoFrom", request.getParameter("docSeqNoFrom"));
		return giacCopyJVDAO.giacs051ValidateDocSeqNo(params);
	}

	@Override
	public String giacs051ValidateBranchCdTo(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCdTo", request.getParameter("branchTo"));
		params.put("userId", userId);
		return giacCopyJVDAO.giacs051ValidateBranchCdTo(params);
	}

}
