package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACJournalEntryDAO;
import com.geniisys.giac.service.GIACJournalEntryService;
import com.seer.framework.util.StringFormatter;

/**
 * @author steven
 * @date 03.18.2013
 */
public class GIACJournalEntryServiceImpl implements GIACJournalEntryService{
	
	private GIACJournalEntryDAO giacJournalEntryDAO;

	/**
	 * @return the giacJournalEntryDAO
	 */
	public GIACJournalEntryDAO getGiacJournalEntryDAO() {
		return giacJournalEntryDAO;
	}

	/**
	 * @param giacJournalEntryDAO the giacJournalEntryDAO to set
	 */
	public void setGiacJournalEntryDAO(GIACJournalEntryDAO giacJournalEntryDAO) {
		this.giacJournalEntryDAO = giacJournalEntryDAO;
	}

	@Override
	public JSONObject getJournalListing(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranId", request.getParameter("tranId"));
		params.put("tranFlag", request.getParameter("tranFlag"));
		Map<String, Object> journalListing = TableGridUtil.getTableGrid(request, params);
		JSONObject	objJournalListing = new JSONObject(journalListing); 		
		return objJournalListing;
	}

	@Override
	public void getJournalEntries(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		String action2 = request.getParameter("action2");
		String fundCd = request.getParameter("fundCd");
		String branchCd = request.getParameter("branchCd");
		String tranId = request.getParameter("tranId");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		params.put("fundCd", fundCd);
		params.put("branchCd", branchCd);
		params.put("tranId", tranId);
		JSONObject objJournalEntries = new JSONObject();
		Map<String, Object> journalEntriesMap = new HashMap<String, Object>();
		if (!fundCd.equals("") && !branchCd.equals("") && !tranId.equals("")){
			journalEntriesMap.put("row", StringFormatter.escapeHTMLInList(getGiacJournalEntryDAO().getJournalEntries(params)));
			objJournalEntries = new JSONObject(journalEntriesMap);
			request.setAttribute("pageStatus", "edit");
		}
		else{
			journalEntriesMap.put("row", StringFormatter.escapeHTMLInList(getGiacJournalEntryDAO().getNewJournalEntries(params)));
			objJournalEntries = new JSONObject(journalEntriesMap);
			request.setAttribute("pageStatus", "add");
		}
		if (request.getParameter("pageStatus").equals("add") || request.getParameter("pageStatus").equals("added")) {
			request.setAttribute("pageStatus", "added");
		}
		System.out.println("objJournalEntries : "+ objJournalEntries.toString());
		request.setAttribute("objJournalEntries", objJournalEntries);
		request.setAttribute("checkORInfo", getGiacJournalEntryDAO().checkORInfo((String) params.get("tranId")));
		request.setAttribute("checkOP", getGiacJournalEntryDAO().getGIACParamValue("WITH_OP"));
		request.setAttribute("uploadImplSw", getGiacJournalEntryDAO().getGIACParamValue("UPLOAD_IMPLEMENTATION_SW"));
		request.setAttribute("sapIntegrationSw", getGiacJournalEntryDAO().getGIACParamValue("SAP_INTEGRATION_SW"));
		request.setAttribute("allowPrintForOpenJV", getGiacJournalEntryDAO().getGIACParamValue("ALLOW_PRINT_FOR_OPEN_JV"));
		request.setAttribute("pFundCd", getGiacJournalEntryDAO().getGIACParamValue("FUND_CD"));
		request.setAttribute("pBranchCd", getGiacJournalEntryDAO().getPbranchCd(userId));
		if (action2.equals("getCancelJV")) {
			request.setAttribute("isCancelJV", "Y");
		}else{
			request.setAttribute("isCancelJV", "N");
		}
		request.setAttribute("fundCd", fundCd);
		request.setAttribute("branchCd", branchCd);
		request.setAttribute("tranId", tranId);
	}

	@Override
	public List<Map<String, Object>> setGiacAcctrans(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGiacAcctrans", prepareGiacAcctransParams(new JSONArray(objParams.getString("setGiacAcctrans")),USER));
		return getGiacJournalEntryDAO().setGiacAcctrans(params);
	}

	private List<Map<String, Object>> prepareGiacAcctransParams(JSONArray params, GIISUser USER) throws JSONException {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		for (int i = 0; i < params.length(); i++) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			JSONObject rec = params.getJSONObject(i);
			paramMap.put("tranId", rec.getString("tranId"));
			paramMap.put("fundCd", rec.getString("fundCd"));
			paramMap.put("branchCd", rec.getString("branchCd"));
			paramMap.put("tranYy", rec.getString("tranYy"));
			paramMap.put("tranMm", rec.getString("tranMm"));
			paramMap.put("tranSeqNo", rec.getString("tranSeqNo"));
			paramMap.put("tranDate", rec.getString("tranDate"));
			paramMap.put("tranFlag", rec.getString("tranFlag"));
			paramMap.put("jvTranTag", rec.getString("jvTranTag"));
			paramMap.put("tranClass", rec.getString("tranClass"));
			paramMap.put("particulars", rec.getString("particulars"));
			paramMap.put("userId", USER.getUserId());
			paramMap.put("remarks", rec.getString("remarks"));
			paramMap.put("jvTranType", rec.getString("jvTranType"));
			paramMap.put("jvTranMm", rec.getString("jvTranMm"));
			paramMap.put("jvTranYy", rec.getString("jvTranYy"));
			paramMap.put("refJvNo", rec.getString("refJvNo"));
			paramMap.put("jvPrefSuff", rec.getString("jvPrefSuff"));
			//paramMap.put("createBy", USER.getUserId()); Commented out by Jerome Bautista 
			paramMap.put("createBy", rec.getString("createBy")); //Added by Jerome Bautista SR 4730 07.02.2015
			paramMap.put("aeTag", rec.getString("aeTag"));
			paramMap.put("sapIncTag", rec.getString("sapIncTag"));
			paramMap.put("uploadTag", rec.getString("uploadTag"));
			paramList.add(paramMap);
		}
		return paramList;
	}

	@Override
	public JSONObject getJVTranType(HttpServletRequest request)
			throws SQLException,JSONException {
		String jvTranTag = request.getParameter("jvTranTag");
		JSONObject jvTranTypeObj = new JSONObject();
		Map<String, Object> jvTranTypeMap = new HashMap<String, Object>();
		jvTranTypeMap.put("row", getGiacJournalEntryDAO().getJVTranType(jvTranTag));
		jvTranTypeObj = new JSONObject(jvTranTypeMap);
		return jvTranTypeObj;
	}

	@Override
	public String validateTranDate(HttpServletRequest request)
			throws SQLException, ParseException {
		String result = new String();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("tranDate", request.getParameter("tranDate"));
		
		String tranDate = request.getParameter("tranDate");
		String fmMonth = dateFormatter(tranDate,"MM-dd-yyyy","MMMM"); 
		String year = dateFormatter(tranDate,"MM-dd-yyyy","yyyy");
		String month = dateFormatter(tranDate,"MM-dd-yyyy","MM"); 
		result = getGiacJournalEntryDAO().validateTranDate(params);
		result = result +","+ getGiacJournalEntryDAO().getGIACParamValue("ALLOW_TRAN_FOR_CLOSED_MONTH")+","+fmMonth+","+year+","+month;
		return result;
	}

	private String dateFormatter(String tranDate, String inDate, String outDate) throws ParseException {
		SimpleDateFormat dt = new SimpleDateFormat(inDate); 
		Date date = dt.parse(tranDate); 
		SimpleDateFormat dt1 = new SimpleDateFormat(outDate);
		System.out.println(dt1.format(date));
		return dt1.format(date);
	}

	@Override
	public Map<String, Object> printOpt(HttpServletRequest request)
			throws SQLException, JSONException {
		Integer tranId = Integer.parseInt(request.getParameter("tranId"));
		Map<String, Object> printOptParams = new HashMap<String, Object>();
		printOptParams.put("row", getGiacJournalEntryDAO().printOpt(tranId));
		return printOptParams;
	}

	@Override
	public String checkUserPerIssCdAcctg(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", null);
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		return getGiacJournalEntryDAO().checkUserPerIssCdAcctg(params);
	}

	@Override
	public String checkCommPayts(HttpServletRequest request)
			throws SQLException {
		return getGiacJournalEntryDAO().checkCommPayts(request.getParameter("tranId"));
	}

	@Override
	public List<Map<String, Object>> saveCancelOpt(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception{
		Map<String, Object> cancelOptParams = new HashMap<String, Object>();
		cancelOptParams.put("setCancelOpt", prepareCancelOptParams(request,USER));
		return getGiacJournalEntryDAO().saveCancelOpt(cancelOptParams);
	}

	private List<Map<String, Object>> prepareCancelOptParams(HttpServletRequest request, GIISUser USER) {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", request.getParameter("tranId"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("jvNo", request.getParameter("jvNo"));
		params.put("userId", USER.getUserId());
		params.put("msg", null);
		paramList.add(params);
		return paramList;
	}

	@Override
	public String getDetailModule(HttpServletRequest request)
			throws SQLException {
		return getGiacJournalEntryDAO().getDetailModule(request.getParameter("tranId"));
	}

	@Override
	public List<Map<String, Object>> showDVInfo(HttpServletRequest request)
			throws SQLException, Exception {
		Map<String, Object> dvInfoParams = new HashMap<String, Object>();
		dvInfoParams.put("dvInfoParams", prepareDVInfoParams(request));
		return getGiacJournalEntryDAO().showDVInfo(dvInfoParams);
	}
	
	private List<Map<String, Object>> prepareDVInfoParams(HttpServletRequest request) {
		List<Map<String, Object>> paramList = new ArrayList<Map<String,Object>>();
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", request.getParameter("tranId"));
		params.put("calledForm", null);
		params.put("dvTag", null);
		params.put("cancelDv", null);
		params.put("refId", null);
		params.put("paytRequestMenu", null);
		params.put("cancelReq", null);
		paramList.add(params);
		return paramList;
	}

	@Override
	public String validateJVCancel(HttpServletRequest request) throws SQLException, Exception {
		return giacJournalEntryDAO.validateJVCancel(request.getParameter("tranId"));
	}
}
