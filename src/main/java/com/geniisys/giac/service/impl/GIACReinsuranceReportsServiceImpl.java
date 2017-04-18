package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISDistShare;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACReinsuranceReportsDAO;
import com.geniisys.giac.service.GIACReinsuranceReportsService;

public class GIACReinsuranceReportsServiceImpl implements GIACReinsuranceReportsService {
	
	private GIACReinsuranceReportsDAO giacReinsuranceReportsDAO;
	
	private PrintServiceLookup printServiceLookup;

	/**
	 * @return the giacReinsuranceReportsDAO
	 */
	public GIACReinsuranceReportsDAO getGiacReinsuranceReportsDAO() {
		return giacReinsuranceReportsDAO;
	}

	/**
	 * @param giacReinsuranceReportsDAO the giacReinsuranceReportsDAO to set
	 */
	public void setGiacReinsuranceReportsDAO(GIACReinsuranceReportsDAO giacReinsuranceReportsDAO) {
		this.giacReinsuranceReportsDAO = giacReinsuranceReportsDAO;
	}

	// -gzelle 06.19.2013
	@Override
	public JSONObject getDates(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> dates = this.giacReinsuranceReportsDAO.getDates(USER.getUserId());
		JSONObject jsonDates = new JSONObject(dates); 
		System.out.println(jsonDates);
		return jsonDates;
	}
	
	// -gzelle 06.18.2013
	@Override
	public String extractToTable(HttpServletRequest request, GIISUser USER) throws SQLException {
		String msg = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("riCd", request.getParameter("riCd") == "" ? null : Integer.parseInt(request.getParameter("riCd")));
		msg = this.giacReinsuranceReportsDAO.extractToTable(params);
		return msg;
	}	
	
	@Override
	public String giacs181ValidateBeforeExtract(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		return getGiacReinsuranceReportsDAO().giacs181ValidateBeforeExtract(params);
	}

	@Override
	public Map<String, Object> giacs181ExtractToTable(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", USER.getUserId());
		params.put("exist", null);
		return getGiacReinsuranceReportsDAO().giacs181ExtractToTable(params);
	}

	@Override
	public String giacs182ValidateDateParams(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("userId", USER.getUserId());
		return getGiacReinsuranceReportsDAO().giacs182ValidateDateParams(params);
	}

	@Override
	public Map<String, Object> extractGIACS182(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", USER.getUserId());
		params.put("exist", null);
		return getGiacReinsuranceReportsDAO().extractGIACS182(params);
	}

	@Override
	public String giacs183ValidateBeforeExtract(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("cutOffDate", request.getParameter("cutOfDate"));
		return getGiacReinsuranceReportsDAO().giacs183ValidateBeforeExtract(params);
	}

	@Override
	@SuppressWarnings("static-access")
	public void showPremDueFromFaculRiAsOf(HttpServletRequest request,GIISUser USER) throws SQLException {
		PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
		request.setAttribute("printers", printers);
		Map<String, Object> dateMap = getGiacReinsuranceReportsDAO().giacs183GetDate(USER.getUserId());
		request.setAttribute("jsonDate", new JSONObject(dateMap));
	}

	@Override
	public  Map<String, Object> giacs183ExtractToTable(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("cutOffDate", request.getParameter("cutOfDate"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("exist", null);
		params.put("fundCd", null);
		params.put("branchCd", null);
		params.put("tranDate", null);
		params.put("collnAmt", null);
		return getGiacReinsuranceReportsDAO().giacs183ExtractToTable(params);
	}

	@Override
	public String validateIfExisting(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateIfExisting");
		params.put("quarter", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
		params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
		return giacReinsuranceReportsDAO.validateIfExisting(params);
	}

	@Override
	public String validateBeforeInsert(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateBeforeExtract");
		params.put("quarter", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
		params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
		params.put("userId", USER.getUserId());
		return giacReinsuranceReportsDAO.validateBeforeExtract(params);
	}

	@Override
	public void deletePrevExtractedRecords(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("quarter", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
		params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
		params.put("userId", USER.getUserId());
		this.giacReinsuranceReportsDAO.deletePrevExtractedRecords(params);
	}

	@Override
	public String extractRecordsToTable(HttpServletRequest request, GIISUser USER) throws SQLException {
		String msg = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("quarter", request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
		params.put("year", request.getParameter("year").equals("") ? null : Integer.parseInt(request.getParameter("year")));
		params.put("userId", USER.getUserId());
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", request.getParameter("shareCd").equals("") ? null : Integer.parseInt(request.getParameter("shareCd")));
		msg = this.giacReinsuranceReportsDAO.extractRecordsToTable(params);
		System.out.println(request.getParameter("quarter").equals("") ? null : Integer.parseInt(request.getParameter("quarter")));
		return msg;
	}
	
	@Override
	public JSONObject getPrevParams(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> param = this.giacReinsuranceReportsDAO.getPrevParams(USER.getUserId());
		JSONObject jsonParam = new JSONObject(param); 
		System.out.println(jsonParam);
		return jsonParam;
	}

	@Override
	public JSONObject extractGIACS296(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		
		params = this.giacReinsuranceReportsDAO.extractGIACS296(params);
		return new JSONObject(params);
	}
	
	public Map<String, Object> getExtractDateGIACS296(String userId) throws SQLException{
		return this.giacReinsuranceReportsDAO.getExtractDateGIACS296(userId);
	}
	
	public Integer getExtractCountGIACS296(String userId) throws SQLException{
		return this.giacReinsuranceReportsDAO.getExtractCountGIACS296(userId);
	}

	@Override
	public Map<String, Object> getGIACS279InitialValues(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return this.giacReinsuranceReportsDAO.getGIACS279InitialValues(params);
	}

	@Override
	public Map<String, Object> giacs279ExtractTable(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("chkClaims", request.getParameter("chkClaims"));
		params.put("chkAging", request.getParameter("chkAging"));
		params.put("fcParam", request.getParameter("fcParam")); //benjo 12.04.2015 UCPBGEN-SR-20083
		params.put("tpParam", request.getParameter("tpParam")); //benjo 12.04.2015 UCPBGEN-SR-20083
		params.put("userId", userId);
		
		return this.giacReinsuranceReportsDAO.giacs279ExtractTable(params);
	}

	@Override
	public Map<String, Object> checkGIACS279Dates(String btn, String userId) throws SQLException {
		Map<String, Object> params = this.giacReinsuranceReportsDAO.checkGIACS279Dates(btn, userId);
		return params;
	}
	
	public Map<String, Object> checkGiacs274PrevExt(String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return this.giacReinsuranceReportsDAO.checkGiacs274PrevExt(params);
	}
	
	public String validateGiacs274BranchCd(String branchCd) throws SQLException{
		return this.giacReinsuranceReportsDAO.validateGiacs274BranchCd(branchCd);
	}
	
	public JSONObject extractGiacs274(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("dateParam", request.getParameter("dateParam"));
		params.put("issueDate", request.getParameter("issueDate"));
		params.put("effDate", request.getParameter("effDate"));
		params.put("userId", userId);
		
		params = this.giacReinsuranceReportsDAO.extractGiacs274(params);
		
		JSONObject json = new JSONObject(params);
		return json;
	}

	@Override
	public String extractSOAFaculRi(HttpServletRequest request, GIISUser USER) throws SQLException {
		String msg = "";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("appUser", USER.getUserId());
		param.put("dateTag", request.getParameter("dateTag"));
		param.put("currTag", request.getParameter("currTag"));
		param.put("fromDate", request.getParameter("fromDate"));
		param.put("toDate", request.getParameter("toDate"));
		param.put("cutOffDate", request.getParameter("cutOffDate"));
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("riCd", request.getParameter("riCd").equals("")?null: Integer.parseInt(request.getParameter("riCd")));
		param.put("userId", USER.getUserId());
		msg = this.giacReinsuranceReportsDAO.extractSOAFaculRi(param);
		return msg;
	}

	@Override
	public Map<String, Object> getLastExtractSOAFaculRi(String userId) throws SQLException {
		return this.giacReinsuranceReportsDAO.getLastExtractSOAFaculRi(userId);
	}
	
	public JSONObject extractGiacs276(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("commParam", Integer.parseInt(request.getParameter("commParam")));
		params.put("issParam", Integer.parseInt(request.getParameter("issParam")));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		
		params = this.giacReinsuranceReportsDAO.extractGiacs276(params);
		
		JSONObject json = new JSONObject(params);
		return json;
} 
	
	/*--start Gzelle 09222015 SR18792--*/ 
	public Map<String, Object> getGiacs276InitialValues(HttpServletRequest request, String userId) throws SQLException { 
		Map<String, Object> params = new HashMap<String, Object>(); 
		params.put("userId", userId); 
		params.put("commParam", request.getParameter("commParam")); 
		return this.giacReinsuranceReportsDAO.getGiacs276InitialValues(params); 
	} 
	
	@Override	/*09232015*/ 
	public Map<String, Object> valExtractPrint(HttpServletRequest request, String userId) throws SQLException { 
		Map<String, Object> params = new HashMap<String, Object>(); 
		params.put("trigger", request.getParameter("trigger")); 
		params.put("commParam", request.getParameter("commParam")); 
		params.put("userId", userId);
		params.put("fromDate", request.getParameter("fromDate")); 
		params.put("toDate", request.getParameter("toDate")); 
		params.put("lineCd", request.getParameter("lineCd")); 
		return this.giacReinsuranceReportsDAO.valExtractPrint(params);  
	} 
	/*--end Gzelle 09222015 SR18792--*/ 
	@Override
	public JSONObject getDistShareList(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs220DistShareList");
		params.put("userId", userId);
		Map<String, Object> distList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(distList);
		return json;
	}

	@Override
	public JSONObject getTreatyPanelList(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGiacs220TreatyPanel");
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		Map<String, Object> treatyPanelList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(treatyPanelList);
		return json;
	}

	@Override
	public Map<String, Object> checkForPrevExtract(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		params.put("month1", (request.getParameter("month1") != null && !request.getParameter("month1").equals("")) ? Integer.parseInt(request.getParameter("month1")) : null );
		params.put("month2", (request.getParameter("month2") != null && !request.getParameter("month2").equals("")) ? Integer.parseInt(request.getParameter("month2")) : null );
		params.put("month3", (request.getParameter("month3") != null && !request.getParameter("month3").equals("")) ? Integer.parseInt(request.getParameter("month3")) : null );
		this.getGiacReinsuranceReportsDAO().checkForPrevExtract(params);
		
		return params;
	}

	@Override
	public Map<String, Object> deleteAndExtract(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		params.put("month1", (request.getParameter("month1") != null && !request.getParameter("month1").equals("")) ? Integer.parseInt(request.getParameter("month1")) : null );
		params.put("month2", (request.getParameter("month2") != null && !request.getParameter("month2").equals("")) ? Integer.parseInt(request.getParameter("month2")) : null );
		params.put("month3", (request.getParameter("month3") != null && !request.getParameter("month3").equals("")) ? Integer.parseInt(request.getParameter("month3")) : null );
		this.getGiacReinsuranceReportsDAO().deleteAndExtract(params);
		
		return params;
	}

	@Override
	public String computeTaggedRecords(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("objParams"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISDistShare.class));
		allParams.put("userId", userId);
		return this.getGiacReinsuranceReportsDAO().computeTaggedRecords(allParams);
	}

	@Override
	public String postTaggedRecords(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("objParams"));
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISDistShare.class));
		allParams.put("userId", userId);
		return this.getGiacReinsuranceReportsDAO().postTaggedRecords(allParams);
	}

	@Override
	public JSONObject checkBeforeView(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("riCd", (request.getParameter("riCd") != null && !request.getParameter("riCd").equals("")) ? Integer.parseInt(request.getParameter("riCd")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		
		JSONObject json = new JSONObject(this.getGiacReinsuranceReportsDAO().checkBeforeView(params));
		return json;
	}

	@Override
	public JSONObject getTreatyQuarterSummary(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("riCd", (request.getParameter("riCd") != null && !request.getParameter("riCd").equals("")) ? Integer.parseInt(request.getParameter("riCd")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		Map<String, Object> summary = this.getGiacReinsuranceReportsDAO().getTreatyQuarterSummary(params);
		System.out.println("summary: "+summary);
		JSONObject json = new JSONObject(summary);
		return json;
	}

	@Override
	public JSONObject getTreatyCashAcct(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		params.put("summaryId", ((request.getParameter("summaryId") != null && !request.getParameter("summaryId").equals("")) ? Integer.parseInt(request.getParameter("summaryId")) : null ));
		JSONObject json = new JSONObject(this.getGiacReinsuranceReportsDAO().getTreatyCashAcct(params));
		return json;
	}

	@Override
	public JSONObject getSummaryBreakdownList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shareCd", (request.getParameter("shareCd") != null && !request.getParameter("shareCd").equals("")) ? Integer.parseInt(request.getParameter("shareCd")) : null );
		params.put("treatyYy", (request.getParameter("treatyYy") != null && !request.getParameter("treatyYy").equals("")) ? Integer.parseInt(request.getParameter("treatyYy")) : null );
		params.put("riCd", (request.getParameter("riCd") != null && !request.getParameter("riCd").equals("")) ? Integer.parseInt(request.getParameter("riCd")) : null );
		params.put("year", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null );
		params.put("qtr", (request.getParameter("qtr") != null && !request.getParameter("qtr").equals("")) ? Integer.parseInt(request.getParameter("qtr")) : null );
		
		Map<String, Object> summaryBreakdownList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(summaryBreakdownList);
		return json;
	}

	@Override
	public JSONObject getReportListByPage(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getReportListByPage");
		params.put("fromPage", request.getParameter("fromPage"));
		
		Map<String, Object> reportList = TableGridUtil.getTableGrid(request, params);
		reportList.remove("from");
		reportList.remove("to");
		JSONObject json = new JSONObject(reportList);
		return json;
	}

	@Override
	public String saveTreatyStatement(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("summaryId", (request.getParameter("summaryId") != null && !request.getParameter("summaryId").equals("")) ? Integer.parseInt(request.getParameter("summaryId")) : null );
		params.put("outstandingLossAmt", (request.getParameter("outstandingLossAmt") != null && !request.getParameter("outstandingLossAmt").equals("")) ? new BigDecimal(request.getParameter("outstandingLossAmt")) : null );
		params.put("releasedIntAmt", (request.getParameter("releasedIntAmt") != null && !request.getParameter("releasedIntAmt").equals("")) ? new BigDecimal(request.getParameter("releasedIntAmt")) : null );
		params.put("premResvRelsdAmt", (request.getParameter("premResvRelsdAmt") != null && !request.getParameter("premResvRelsdAmt").equals("")) ? new BigDecimal(request.getParameter("premResvRelsdAmt")) : null );
		params.put("whtTaxAmt", (request.getParameter("whtTaxAmt") != null && !request.getParameter("whtTaxAmt").equals("")) ? new BigDecimal(request.getParameter("whtTaxAmt")) : null );
		params.put("endingBalAmt", (request.getParameter("endingBalAmt") != null && !request.getParameter("endingBalAmt").equals("")) ? new BigDecimal(request.getParameter("endingBalAmt")) : null );
		System.out.println("params to save in treaty summary: "+params);
		return this.getGiacReinsuranceReportsDAO().saveTreatyStatement(params);
	}

	@Override
	public String saveTreatyCashAcct(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("summaryId", (request.getParameter("summaryId") != null && !request.getParameter("summaryId").equals("")) ? Integer.parseInt(request.getParameter("summaryId")) : null );
		params.put("prevBalance", (request.getParameter("prevBalance") != null && !request.getParameter("prevBalance").equals("")) ? new BigDecimal(request.getParameter("prevBalance")) : null );
		params.put("prevBalanceDt", request.getParameter("prevBalanceDt"));
		params.put("ourRemittance", (request.getParameter("ourRemittance") != null && !request.getParameter("ourRemittance").equals("")) ? new BigDecimal(request.getParameter("ourRemittance")) : null );
		params.put("yourRemittance", (request.getParameter("yourRemittance") != null && !request.getParameter("yourRemittance").equals("")) ? new BigDecimal(request.getParameter("yourRemittance")) : null );
		params.put("cashCallPaid", (request.getParameter("cashCallPaid") != null && !request.getParameter("cashCallPaid").equals("")) ? new BigDecimal(request.getParameter("cashCallPaid")) : null );
		params.put("cashBalInFavor", (request.getParameter("cashBalInFavor") != null && !request.getParameter("cashBalInFavor").equals("")) ? new BigDecimal(request.getParameter("cashBalInFavor")) : null );
		params.put("prevResvBalance", (request.getParameter("prevResvBalance") != null && !request.getParameter("prevResvBalance").equals("")) ? new BigDecimal(request.getParameter("prevResvBalance")) : null );
		params.put("prevResvBalDt", request.getParameter("prevResvBalDt"));
		params.put("resvBalance", (request.getParameter("resvBalance") != null && !request.getParameter("resvBalance").equals("")) ? new BigDecimal(request.getParameter("resvBalance")) : null );
		params.put("resvBalanceDt", request.getParameter("resvBalanceDt"));
		System.out.println("params to save in cash account: "+params);
		return this.getGiacReinsuranceReportsDAO().saveTreatyCashAcct(params);
	}

	@Override
	public Map<String, Object> getGIACS182Variables(String userId)
			throws SQLException {
		return this.getGiacReinsuranceReportsDAO().getGIACS182Variables(userId);
	}

}

