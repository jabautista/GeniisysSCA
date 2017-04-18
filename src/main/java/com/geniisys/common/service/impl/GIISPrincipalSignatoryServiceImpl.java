/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.service.impl
	File Name: GIISPrincipalSignatoryServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 24, 2011
	Description: 
*/


package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.jfree.util.Log;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPrincipalSignatoryDAO;
import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISPrincipalRes;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISPrincipalSignatoryService;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISPrincipalSignatoryServiceImpl implements GIISPrincipalSignatoryService{
	
	private GIISPrincipalSignatoryDAO giisPrincipalSignatoryDAO;

	@Override
	public JSONObject getPrincipalSignatories(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Integer assdNo = ("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? null : Integer.parseInt((request.getParameter("assdNo")));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPrincipalSignatories");
		if (!"GIIMM011".equalsIgnoreCase(request.getParameter("callingForm")) && !"GIPIS017".equalsIgnoreCase(request.getParameter("callingForm"))) {
			params.put("assdNo", assdNo);
		}
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	/**
	 * @param giisPrincipalSignatoryDAO the giisPrincipalSignatoryDAO to set
	 */
	public void setGiisPrincipalSignatoryDAO(GIISPrincipalSignatoryDAO giisPrincipalSignatoryDAO) {
		this.giisPrincipalSignatoryDAO = giisPrincipalSignatoryDAO;
	}
	/**
	 * @return the giisPrincipalSignatoryDAO
	 */
	public GIISPrincipalSignatoryDAO getGiisPrincipalSignatoryDAO() {
		return giisPrincipalSignatoryDAO;
	}
	@Override
	public GIISPrincipalRes getAssuredPrincipalResInfo(int assdNo)
			throws SQLException {
		return this.giisPrincipalSignatoryDAO.getAssuredPrincipalResInfo(assdNo);
	}
	@Override
	public String validatePrincipalORCoSignorId(Map<String, Object> params)
			throws SQLException {
		return this.getGiisPrincipalSignatoryDAO().validatePrincipalORCoSignorId(params);
	}
	@Override
	public String validateCTCNo(String ctcNo) throws SQLException {
		return this.getGiisPrincipalSignatoryDAO().validateCTCNo(ctcNo);
	}
	@Override
	public void savePrincipalSignatory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object>params = new HashMap<String, Object>();
		Integer assdNo = ("".equals(request.getParameter("assdNo")) || request.getParameter("assdNo") == null)? null : Integer.parseInt((request.getParameter("assdNo")));
		System.out.println("Assured No: " + assdNo);
		params.put("assdNo", assdNo);
		params.put("principalResNo", request.getParameter("principalResNo"));
		params.put("principalResDate",  request.getParameter("principalResDate"));
		params.put("principalResPlace",  request.getParameter("principalResPlace"));
		params.put("controlTypeCd", request.getParameter("controlTypeCd")); //added by steven 11/27/2012
		params.put("strParameters", request.getParameter("strParameters"));
		params.put("userId", USER.getUserId());
		this.getGiisPrincipalSignatoryDAO().savePrincipalSignatory(params);
	}
	@Override
	public GIISAssured getInitialAssdNo() throws SQLException {
		return this.getGiisPrincipalSignatoryDAO().getInitialAssdNo();
	}
	@Override
	public List<Integer> getPrinSignatoryIDList(Integer assdNo)throws SQLException {
		Log.info("Retrieving list of Prin Ids for assured: " + assdNo);
		return this.giisPrincipalSignatoryDAO.getPrinSignatoryIDList(assdNo);
	}
	@Override
	public String validateCTCNo2(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ID1", request.getParameter("id1") == null ? 0 : request.getParameter("id1"));
		params.put("ID2", request.getParameter("id2") == null ? 0 : request.getParameter("id2"));
		params.put("CTCNo1", request.getParameter("ctcNo1") == null ?"" : request.getParameter("ctcNo1"));
		params.put("CTCNo2", request.getParameter("ctcNo2") == null ?"" : request.getParameter("ctcNo2"));
		System.out.println("CTC NO:"+params.get("CTCNo"));
		return this.getGiisPrincipalSignatoryDAO().validateCTCNo2(params);
	}
	//added by steven 05.23.2014
	@Override
	public JSONObject getGiiss022Principal(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss022Principal");
		params.put("assdNo", request.getParameter("assdNo"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(map);
	}
	@Override
	public JSONObject showAllGiiss022(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		if (request.getParameter("mode").equals("prinSign")) {
			params.put("ACTION", "getGiiss022PrinSign");
		} else if (request.getParameter("mode").equals("coSign")) {
			params.put("ACTION", "getGiiss022CoSign");
		}
		params.put("assdNo", request.getParameter("assdNo"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
}
