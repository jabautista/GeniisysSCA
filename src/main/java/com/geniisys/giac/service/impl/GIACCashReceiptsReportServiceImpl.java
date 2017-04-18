package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCashReceiptsReportDAO;
import com.geniisys.giac.service.GIACCashReceiptsReportService;

public class GIACCashReceiptsReportServiceImpl implements GIACCashReceiptsReportService{
	
	private static Logger log = Logger.getLogger(GIACCashReceiptsReportService.class);
	private GIACCashReceiptsReportDAO giacCashReceiptsReportDAO;
	
	
	public GIACCashReceiptsReportDAO getGiacCashReceiptsReportDAO() {
		return giacCashReceiptsReportDAO;
	}

	public void setGiacCashReceiptsReportDAO(
			GIACCashReceiptsReportDAO giacCashReceiptsReportDAO) {
		this.giacCashReceiptsReportDAO = giacCashReceiptsReportDAO;
	}

	@Override
	public String getDailyCollectionRecord(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("userId", USER.getUserId());
		params.put("dspDate", request.getParameter("dspDate"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		log.info("Getting Daily Collection Report record...");
		Map<String, Object> dailyCollectionRecordMap = TableGridUtil.getTableGrid(request, params);
		JSONObject	objDailyCollectionRecord = new JSONObject(dailyCollectionRecordMap); 
		log.info("Finished getting Daily Collection Report record...");
		return objDailyCollectionRecord.toString();
	}
	
	public String validateGIACS093BranchCd(String branchCd, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", branchCd);
		params.put("userId", userId);
		return this.giacCashReceiptsReportDAO.validateGIACS093BranchCd(params);
	}
	
	public JSONObject populateGiacPdc(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("register", request.getParameter("register"));
		params.put("outstanding", request.getParameter("outstanding"));
		params.put("user", userId);
		
		params = this.giacCashReceiptsReportDAO.populateGiacPdc(params);
		
		JSONObject json = new JSONObject(params);
		return json;
	}

	@Override
	public String validateGIACS281BankAcctCd(HttpServletRequest request)
			throws SQLException {
		return giacCashReceiptsReportDAO.validateGIACS281BankAcctCd(request.getParameter("bankAcctCd"));
	}

	@Override
	public JSONObject getGIACS078InitialValues(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		
		JSONObject json = new JSONObject(this.giacCashReceiptsReportDAO.getGIACS078OInitialValues(params));		
		return json;
	}

	@Override
	public String validateIntmNo(Integer intmNo) throws SQLException {
		Map<String, Object> params = this.giacCashReceiptsReportDAO.validateIntmNo(intmNo);
		return new JSONObject(params).toString();
	}

	@Override
	public String extractGiacs078Records(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("dateTag", request.getParameter("dateTag"));
		params.put("userId", userId);
		
		params = this.giacCashReceiptsReportDAO.extractGiacs078Records(params);
		String extractedRec = params.get("extractedRec").toString();
		System.out.println("======== "+extractedRec);
		return extractedRec;
	}

	@Override
	public Integer countGiacs078ExtractedRecords(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		System.out.println(params.toString());
		
		return this.giacCashReceiptsReportDAO.countGiacs078ExtractedRecords(params);
	}
	
	//john 10.9.2014
	@Override
	public Map<String, Object> getLastExtractParam(String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		return giacCashReceiptsReportDAO.getLastExtractParam(params);
	}

}
