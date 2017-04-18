package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLNoClaimMultiYyDAO;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.entity.GICLNoClaimMultiYy;
import com.geniisys.gicl.service.GICLNoClaimMultiYyService;
import com.seer.framework.util.StringFormatter;

public class GICLNoClaimMultiYyServiceImpl implements GICLNoClaimMultiYyService{
	
	private GICLNoClaimMultiYyDAO giclNoClaimMultiYyDAO;
	private static Logger log = Logger.getLogger(GICLNoClaimMultiYyServiceImpl.class);
	
	
	public void setGiclNoClaimMultiYyDAO(GICLNoClaimMultiYyDAO giclNoClaimMultiYyDAO) {
		this.giclNoClaimMultiYyDAO = giclNoClaimMultiYyDAO;
	}

	
	public GICLNoClaimMultiYyDAO giclNoClaimMultiYyDAO() {
		return giclNoClaimMultiYyDAO;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNoClaimMultiYyList(
			HashMap<String, Object> params) throws SQLException {
		log.info("getNoClaimMultiYyList");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> catList = (List<Map<String, Object>>) this.giclNoClaimMultiYyDAO().getNoClaimMultiYyList(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}


	@Override
	public GICLNoClaimMultiYy getNoClaimMultiYyDetails(Integer noClaimId) throws SQLException {		
		return this.giclNoClaimMultiYyDAO().getNoClaimMultiYyDetails(noClaimId);
	}


	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList(
			HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> catList = (List<Map<String, Object>>) this.giclNoClaimMultiYyDAO().getNoClaimMultiYyPolicyList(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}


	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList2(
			HashMap<String, Object> params) throws SQLException {


		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> catList = (List<Map<String, Object>>) this.giclNoClaimMultiYyDAO().getNoClaimMultiYyPolicyList2(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}


	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList3(
			HashMap<String, Object> params) throws SQLException {

		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		@SuppressWarnings("unchecked")
		List<Map<String, Object>> catList = (List<Map<String, Object>>) this.giclNoClaimMultiYyDAO().getNoClaimMultiYyPolicyList3(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		
		return params;
	}


	@Override
	public Integer getNoClaimMultiYyNumber() throws SQLException {
		// TODO Auto-generated method stub
		System.out.println("GET CLAIM NUMBER:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
		return this.giclNoClaimMultiYyDAO().getNoClaimMultiYyNo();
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLNoClaimMultiYyService#saveNewDetail(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@SuppressWarnings("unused")
	@Override
	public String saveNewDetail(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("plateNo",Integer.parseInt(request.getParameter("plateNo")));
		params.put("noClaimId",Integer.parseInt(request.getParameter("noclaimId")));
		params.put("serialNo",Integer.parseInt(request.getParameter("serialNo")));
		params.put("motorNo",request.getParameter("motorNo"));
		return null;
	}


	@Override
	public GICLNoClaimMultiYy populateDetails(HashMap<String, Object> params)
			throws SQLException {
		return this.giclNoClaimMultiYyDAO().populateDetails(params);
	}


	@Override
	public String validateExisting(Map<String, Object> params)
			throws SQLException {
		return this.giclNoClaimMultiYyDAO().validateExisting(params);
	}


	@Override
	public GICLNoClaimMultiYy additionalDtls() throws SQLException {
		return this.giclNoClaimMultiYyDAO().additionalDtl();
	}
	
	public GICLNoClaimMultiYy updateDtls(Integer noClaimId) throws SQLException {
		return this.giclNoClaimMultiYyDAO().updateDtls(noClaimId);
	}


	@Override
	public String saveNoClmMultiYy(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("noClaimId",(request.getParameter("noClaimId").equals("") 			? null : Integer.parseInt(request.getParameter("noClaimId"))));
		params.put("ncIssCd",(request.getParameter("ncIssCd").equals("") 				? "" : request.getParameter("ncIssCd")));
		params.put("ncIssueYy",(request.getParameter("ncIssueYy").equals("") 			? null : Integer.parseInt(request.getParameter("ncIssueYy"))));
		params.put("ncSeqNo",(request.getParameter("ncSeqNo").equals("") 				? null : Integer.parseInt(request.getParameter("ncSeqNo"))));
		params.put("assdNo",(request.getParameter("assdNo").equals("") 					? null : Integer.parseInt(request.getParameter("assdNo"))));
		//params.put("noIssueDate",(request.getParameter("noIssueDate").equals("") 		? "" : request.getParameter("noIssueDate")));
		params.put("noIssueDate",request.getParameter("noIssueDate"));
		params.put("motorNo",(request.getParameter("motorNo").equals("") 				? "" : request.getParameter("motorNo")));
		params.put("serialNo",(request.getParameter("serialNo").equals("") 				? "" : request.getParameter("serialNo")));
		params.put("plateNo",(request.getParameter("plateNo").equals("") 				? "" : request.getParameter("plateNo")));
		params.put("modelYear",(request.getParameter("modelYear").equals("") 			? "" : request.getParameter("modelYear")));
		params.put("makeCd",(request.getParameter("makeCd").equals("") 					? null : Integer.parseInt(request.getParameter("makeCd"))));
		params.put("motcarCompCd",(request.getParameter("motcarCompCd").equals("") 		? null : Integer.parseInt(request.getParameter("motcarCompCd"))));
		params.put("basicColorCd",(request.getParameter("basicColorCd").equals("") 		? "" : request.getParameter("basicColorCd")));
		params.put("colorCd",(request.getParameter("colorCd").equals("") 				? null : Integer.parseInt(request.getParameter("colorCd"))));
		params.put("cancelTag",(request.getParameter("cancelTag").equals("") 			? "" : request.getParameter("cancelTag")));
		params.put("remarks",(request.getParameter("remarks").equals("") 				? "" : request.getParameter("remarks")));
		params.put("cpiRecNo",(request.getParameter("cpiRecNo").equals("") 				? null : Integer.parseInt(request.getParameter("cpiRecNo"))));
		params.put("cpiBranchCd",(request.getParameter("cpiBranchCd").equals("") 		? "" : request.getParameter("cpiBranchCd")));
		params.put("userId",(request.getParameter("userId").equals("") 					? "" : request.getParameter("userId")));
		//params.put("lastUpdate",(request.getParameter("lastUpdate").equals("") 			? "" : df.parse(request.getParameter("lastUpdate"))));
		//params.put("ncIssueDate",request.getParameter("ncIssueDate").equals("") ? "" : df.parse(request.getParameter("ncIssueDate")) ); // removed parse - orwom
		System.out.println("::::::::::::::::::::::::::  PARAMS SA SERVICE "+params+":::::::::::::::::::::::::::::::::::");
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclNoClaimMultiYyDAO.saveNewDetails(params))).toString();
	}


	@Override
	public GICLNoClaim getNoClaimCertDtls(Integer noClaimId)
			throws SQLException {
		return this.giclNoClaimMultiYyDAO().getNoClaimCertDtls(noClaimId);
	}


}
