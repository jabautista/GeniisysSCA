package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACAgingSoaDetailDAO;
import com.geniisys.giac.entity.GIACAgingSoaDetail;
import com.geniisys.giac.service.GIACAgingSoaDetailService;

/**
 * The Class GIACAgingSoaDetailServiceImpl.
 */
public class GIACAgingSoaDetailServiceImpl implements GIACAgingSoaDetailService{
	
	/** The giac agingSoa dao. */
	private GIACAgingSoaDetailDAO giacAgingSoaDetailDAO;

	/**
	 * @return the giacAgingSoaDetailDAO
	 */
	public GIACAgingSoaDetailDAO getGiacAgingSoaDetailDAO() {
		return giacAgingSoaDetailDAO;
	}

	/**
	 * @param giacAgingSoaDetailDAO the giacAgingSoaDetailDAO to set
	 */
	public void setGiacAgingSoaDetailDAO(GIACAgingSoaDetailDAO giacAgingSoaDetailDAO) {
		this.giacAgingSoaDetailDAO = giacAgingSoaDetailDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAgingSoaDetailService#getInstnoDetails(java.lang.String, java.lang.Integer)
	 */
	@Override
	public List<GIACAgingSoaDetail> getInstnoDetails(String issCd, Integer premSeqNo) throws SQLException {
		return (List<GIACAgingSoaDetail>) giacAgingSoaDetailDAO.getInstnoDetails(issCd, premSeqNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAgingSoaDetailService#getPolicyDetails(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getPolicyDetails(Map<String, Object> params)	throws SQLException {
		
		return giacAgingSoaDetailDAO.getPolicyDetails(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAgingSoaDetailService#getAgingSoaDetails(java.lang.String)
	 */
	@Override
	public PaginatedList getAgingSoaDetails(String keyword, String issCd)
			throws SQLException {
		List<GIACAgingSoaDetail> agingSOAList = this.getGiacAgingSoaDetailDAO().getAgingSoaDetails(keyword, issCd);
		PaginatedList paginatedList = new PaginatedList(agingSOAList, ApplicationWideParameters.PAGE_SIZE);
		return paginatedList;
	}

	/**
	 * Retrieves bill info based on issCd and premSeqNo extracted from request parameters
	 * @author andrew robes
	 * @date 11.15.2011
	 * @param request - HttpServletRequest containing issCd and premSeqNo parameters
	 * @return JSONObject
	 */
	@Override
	public JSONObject getBillInfo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("tranType", request.getParameter("tranType"));
		
		JSONObject billInfo = new JSONObject(this.giacAgingSoaDetailDAO.getBillInfo(params));		
		return billInfo;
	}
	
	/**
	 * Retrieves inst info based on issCd, premSeqNo and instNo extracted from request parameters
	 * @author andrew robes
	 * @date 11.15.2011
	 * @param request - HttpServletRequest containing issCd, premSeqNo and instNo parameters
	 * @return JSONObject
	 */
	@Override
	public JSONObject getInstInfo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("instNo", request.getParameter("instNo"));
		
		GIACAgingSoaDetail agingSoaDetail = this.giacAgingSoaDetailDAO.getInstInfo(params);
		
		JSONObject instInfo = new JSONObject();
		if(agingSoaDetail != null) {
			instInfo = new JSONObject(agingSoaDetail);
		}
		return instInfo;
	}

	@Override
	public Map<String, Object> getPolicyDtlsGIACS007(Map<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiacAgingSoaDetailDAO().getPolicyDtlsGIACS007(params);
	}

	@Override
	public JSONObject getInvoiceSoaDetails(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		
		GIACAgingSoaDetail invoiceSoaDtl = this.getGiacAgingSoaDetailDAO().getInvoiceSoaDetails(params);
		JSONObject json = invoiceSoaDtl != null ? new JSONObject(invoiceSoaDtl) : new JSONObject();
		return json;
	}
	
}
