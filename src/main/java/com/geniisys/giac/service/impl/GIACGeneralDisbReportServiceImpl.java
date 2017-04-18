package com.geniisys.giac.service.impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACGeneralDisbReportDAO;
import com.geniisys.giac.service.GIACGeneralDisbReportService;
import com.seer.framework.util.StringFormatter;

public class GIACGeneralDisbReportServiceImpl implements GIACGeneralDisbReportService{

	public Logger log = Logger.getLogger(GIACGeneralDisbReportServiceImpl.class);
	
	public GIACGeneralDisbReportDAO giacGeneralDisbReportDAO;

	public GIACGeneralDisbReportDAO getGiacGeneralDisbReportDAO() {
		return giacGeneralDisbReportDAO;
	}

	public void setGiacGeneralDisbReportDAO(
			GIACGeneralDisbReportDAO giacGeneralDisbReportDAO) {
		this.giacGeneralDisbReportDAO = giacGeneralDisbReportDAO;
	}

	@Override
	public String getGIACS273InitialFundCd() throws SQLException {
		return this.giacGeneralDisbReportDAO.getGIACS273InitialFundCd();
	}

	@Override
	public String validateGIACS273DocCd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("documentCd", request.getParameter("documentCd"));
		
		return this.giacGeneralDisbReportDAO.validateGIACS273DocCd(params);
	}

	@Override
	public String getGiacs512CutOffDate(String extractYear) throws SQLException {
		return this.getGiacGeneralDisbReportDAO().getGiacs512CutOffDate(extractYear);
	}

	@Override
	public String validateGiacs512BeforeExtract(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("extractYear", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
		params.put("intmNo", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.put("type", request.getParameter("type"));
		params.put("userId", userId);
		
		return this.getGiacGeneralDisbReportDAO().validateGiacs512BeforeExtract(params);
	}

	@Override
	public String validateGiacs512BeforePrint(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("extractYear", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
		params.put("userId", userId);
		params.put("type", request.getParameter("type"));
		
		return this.getGiacGeneralDisbReportDAO().validateGiacs512BeforePrint(params);
	}

	@Override
	public Map<String, Object> cpcExtractPremComm(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("extractYear", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
		params.put("intmNo", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.put("cutOffDate", request.getParameter("cutOffDate"));
		params.put("userId", userId);
		params.put("recordCount", null);
		
		return this.getGiacGeneralDisbReportDAO().cpcExtractPremComm(params);
	}

	@Override
	public Map<String, Object> cpcExtractOsDtl(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("extractYear", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
		params.put("intmNo", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.put("userId", userId);
		params.put("recordCount", null);
		
		return this.getGiacGeneralDisbReportDAO().cpcExtractOsDtl(params);
	}

	@Override
	public Map<String, Object> cpcExtractLossPaid(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("extractYear", (request.getParameter("year") != null && !request.getParameter("year").equals("")) ? Integer.parseInt(request.getParameter("year")) : null);
		params.put("intmNo", (request.getParameter("intmNo") != null && !request.getParameter("intmNo").equals("")) ? Integer.parseInt(request.getParameter("intmNo")) : null);
		params.put("userId", userId);
		params.put("recordCount", null);
		
		return this.getGiacGeneralDisbReportDAO().cpcExtractLossPaid(params);
	}

	@Override
	public String getGiacs190SlTypeCd() throws SQLException {
		return getGiacGeneralDisbReportDAO().getGiacs190SlTypeCd();
	}
	
	public String giacs149WhenNewFormInstance(String vUpdate) throws SQLException{
		return this.giacGeneralDisbReportDAO.giacs149WhenNewFormInstance(vUpdate);
	}
	
	public Integer countTaggedVouchers(String intmNo) throws SQLException{
		return this.giacGeneralDisbReportDAO.countTaggedVouchers(intmNo);
	}
	
	public JSONObject showOvrideCommVoucher(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getOverrideCommVoucherList");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("workflowColValue", request.getParameter("workflowColValue"));
		params.put("userId", userId);
		
		System.out.println(params.toString());
		
		Map<String, Object> overrideCommVoucherTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommVoucher = new JSONObject(overrideCommVoucherTableGrid);
		request.setAttribute("overrideCommVoucherTableGrid", jsonCommVoucher);
		return jsonCommVoucher;
	}
	
	public JSONObject computeGIACS149Totals(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));		
		params.put("userId", userId);
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params = this.giacGeneralDisbReportDAO.computeGIACS149Totals(params);
		
		return new JSONObject(params);
	}
	public String updateCommVoucherAmount(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("transactionType", request.getParameter("tranType"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("instNo", request.getParameter("instNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("chldIntmNo", request.getParameter("chldIntmNo"));
		params.put("inputVat", request.getParameter("inputVat"));
		params.put("advances", request.getParameter("advances"));
		params.put("userId", userId);
		
		return this.giacGeneralDisbReportDAO.updateCommVoucherAmount(params);
	}
	
	public JSONArray updateCommVoucherPrintTag(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("vouchers"))));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("workflowColValue", request.getParameter("workflowColValue"));
		params.put("userId", userId);
		
		JSONArray json = new JSONArray((List<Map<String, Object>>)this.giacGeneralDisbReportDAO.updateCommVoucherPrintTag(params));
		return json ;
	}
	
	public Map<String, Object> getCvPrefGIACS149(Map<String, Object> params) throws SQLException{
		return this.giacGeneralDisbReportDAO.getCvPrefGIACS149(params);
	}
	
	public JSONObject checkCvSeqGIACS149(HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("docName", request.getParameter("docName"));
		params.put("userId", userId);
		
		params = this.giacGeneralDisbReportDAO.checkCvSeqGIACS149(params);
		
		return new JSONObject(params);
	}
	
	public String updateVatGIACS149(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkedVouchers"))));
		
		return this.giacGeneralDisbReportDAO.updateVatGIACS149(params);
	}
	
	public JSONObject populateCvSeqGIACS149(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		/*params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		params.put("transactionType", request.getParameter("transactionType"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("instNo", Integer.parseInt(request.getParameter("instNo")));
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		params.put("chldIntmNo", Integer.parseInt(request.getParameter("chldIntmNo")));*/
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkedVouchers"))));
		params.put("cvNo", request.getParameter("cvNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("docName", request.getParameter("docName"));
		params.put("userId", userId);
		params.put("voucherNo", request.getParameter("voucherNo"));
		
		System.out.println("==== "+params.toString());
		params = this.giacGeneralDisbReportDAO.populateCvSeqGIACS149(params);
		
		return new JSONObject(params);
	}	
	
	public String updateUnprintedVoucher(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		/*params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("transactionType", request.getParameter("transactionType"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("instNo", request.getParameter("instNo"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("chldIntmNo", request.getParameter("chldIntmNo"));*/
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkedVouchers"))));
		params.put("voucherNo", request.getParameter("voucherNo"));
		params.put("voucherPrefSuf", request.getParameter("voucherPrefSuf"));
		params.put("userId", userId);
		
		return this.giacGeneralDisbReportDAO.updateUnprintedVoucher(params);
	}
	
	@Override
	public JSONArray getGpcvGIACS149(Integer intmNo) throws SQLException {
		JSONArray json = new JSONArray((List<Map<String, Object>>) this.giacGeneralDisbReportDAO.gpcvGetGIACS149(intmNo));
		
		return json;
	}
	
	public void updateGpcvGIACS149(JSONArray gpcv, HttpServletRequest request, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gpcv", JSONUtil.prepareMapListFromJSON(gpcv));
		params.put("voucherNo", request.getParameter("voucherNo"));
		params.put("cvPref", request.getParameter("cvPref"));
		params.put("userId", userId);
		
		this.giacGeneralDisbReportDAO.updateGpcvGIACS169(params);
	}
	
	public void delWorkflowRec(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("eventDesc", request.getParameter("eventDesc"));
		params.put("moduleId", "GIACS221");
		params.put("userId", userId);
		//params.put("colValue", request.getParameter("colValue"));
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkedVouchers"))));
		
		this.giacGeneralDisbReportDAO.delWorkflowRec(params);		
	}
	
	public List<Map<String, Object>> prepareGpcvForUpdate(JSONArray rows, String userId) throws SQLException, JSONException{
		Map<String, Object> list = null;
		JSONObject json = null;
		List<Map<String, Object>> items = new ArrayList<Map<String,Object>>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			list = new HashMap<String, Object>();
			
			list.put("gfundFundCd", json.getString("gfunFundCd"));
			list.put("gibrBranchCd", json.getString("gibrBranchCd"));
			list.put("gaccTranId", json.getInt("gaccTranId"));
			list.put("transactionType", json.getString("transactionType"));
			list.put("issCd", json.getString("issCd"));
			list.put("premSeqNo", json.getInt("premSeqNo"));
			list.put("instNo", json.getInt("instNo"));
			list.put("intmNo", json.getInt("intmNo"));
			list.put("chldIntmNo", json.getInt("chldIntmNo"));
			list.put("printDate", json.getString("printDate"));
			list.put("ocvNo", json.getString("ocvNo"));
			list.put("ocvPrefSuf", json.getString("ocvPrefSuf"));
			list.put("refNo", json.getString("refNo"));
			list.put("lastUpdate", json.getString("lastUpdate"));
			list.put("recUserId", json.getString("userId"));
			
			items.add(list);
		}
		
		return items;
	}
	
	public void gpcvRestore(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("gpcvSelect"))));// this.prepareGpcvForUpdate(new JSONArray(request.getParameter("gpcvSelect")), userId));
		params.put("appUser", userId);
		params.put("stat", request.getParameter("stat"));
		params.put("voucherNo", request.getParameter("voucherNo"));
		params.put("voucherPrefSuf", request.getParameter("voucherPrefSuf"));
		params.put("ocvBranch", request.getParameter("ocvBranch"));
		params.put("docName", request.getParameter("docName"));
		/*params.put("ocvNo", request.getParameter("ocvNo"));
		params.put("ocvPrefSuf", request.getParameter("ocvPrefSuf"));*/
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("workflowColValue", request.getParameter("workflowColValue"));
		
		this.giacGeneralDisbReportDAO.gpcvRestore(params);
	}
	
	public String updateDocSeqGIACS149(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		/*params.put("gfunFundCd", request.getParameter("gfunFundCd"));
		params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
		params.put("ocvPrefSuf", request.getParameter("ocvPrefSuf"));*/
		params.put("vouchers", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("checkedVouchers"))));
		params.put("docName", request.getParameter("docName"));
		params.put("userId", userId);
		
		return this.giacGeneralDisbReportDAO.updateDocSeqGIACS149(params);
	}

	@Override
	public JSONObject showBankFiles(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBankFiles");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String checkViewRecords(HttpServletRequest request)throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkViewRecords");
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("intm", request.getParameter("intm").equals("")?null:Integer.parseInt(request.getParameter("intm")));
		System.out.println(giacGeneralDisbReportDAO.checkViewRecords(params));
		return giacGeneralDisbReportDAO.checkViewRecords(params);
	}

	@Override
	public void invalidateBankFile(HttpServletRequest request, GIISUser USER)throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "invalidateBankFile");
		params.put("appUser", USER.getUserId());
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("intm", request.getParameter("intm").equals("")?null:Integer.parseInt(request.getParameter("intm")));
		this.giacGeneralDisbReportDAO.invalidateBankFile(params);
	}

	@Override
	public void processViewRecords(HttpServletRequest request, GIISUser USER)throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("intm", request.getParameter("intm").equals("")?null:Integer.parseInt(request.getParameter("intm")));
		this.giacGeneralDisbReportDAO.processViewRecords(params);
	}

	@Override
	public JSONObject showViewRecords(HttpServletRequest request)throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecords");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public JSONObject showViewRecordsViaBankFile(HttpServletRequest request)throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecordsViaBankFile");		
		params.put("bankFileNo", request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo")));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public JSONObject showViewDetailsViaRecords(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDetailsViaRecords");		
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("parentIntmType", request.getParameter("parentIntmType"));
		params.put("parentIntmNo", request.getParameter("parentIntmNo").equals("")?null:Integer.parseInt(request.getParameter("parentIntmNo")));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public JSONObject showViewDetailsViaBankFiles(HttpServletRequest request)throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDetailsViaBankFiles");		
		params.put("bankFileNo", request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo")));
		params.put("parentIntmType", request.getParameter("parentIntmType"));
		params.put("parentIntmNo", request.getParameter("parentIntmNo").equals("")?null:Integer.parseInt(request.getParameter("parentIntmNo")));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String generateBankFile(HttpServletRequest request, GIISUser USER)throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("intmType", request.getParameter("intmType"));
		params.put("intm", request.getParameter("intm").equals("")?null:Integer.parseInt(request.getParameter("intm")));
		params.put("parentIntmNo", request.getParameter("parentIntmNo").equals("")?null:Integer.parseInt(request.getParameter("parentIntmNo")));
		params.put("viewSw", request.getParameter("viewSw"));
		return this.giacGeneralDisbReportDAO.generateBankFile(params);
	}

	@Override
	public Map<String, Object> getDetailsTotal(HttpServletRequest request) throws SQLException, JSONException,ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parentIntmType", request.getParameter("parentIntmType"));
		params.put("parentIntmNo", request.getParameter("parentIntmNo").equals("")?null:Integer.parseInt(request.getParameter("parentIntmNo")));
		if (request.getParameter("subAct").equals("viewDetailsViaRecords")) {
			params.put("asOfDate", request.getParameter("asOfDate"));
			params.put("ACTION", "getDetailsTotalViaRecords");
			params = this.giacGeneralDisbReportDAO.getDetailsTotalViaRecords(params);
		}else {
			params.put("bankFileNo", request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo")));
			params.put("ACTION", "getDetailsTotalViaBankFiles");
			params = this.giacGeneralDisbReportDAO.getDetailsTotalViaBankFiles(params);
		}
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}

	@Override
	public String generateSummaryForBank(HttpServletRequest request)throws SQLException, IOException {
		String companyCode = this.giacGeneralDisbReportDAO.getCompanyCode();
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankFileNo", request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo")));
		Integer bankFileNo = request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo"));
		List<Map<String, Object>> summaryForBank = this.giacGeneralDisbReportDAO.getSummaryForBank(params);
	
		return request.getHeader("Referer") + "ups/" + generateUPSFile(summaryForBank, companyCode, request.getSession().getServletContext().getRealPath(""), bankFileNo);
	}
	
	private String generateUPSFile(List<Map<String, Object>> rows, String companyCode, String realPath, Integer bankFileNo) throws IOException, SQLException {
		SimpleDateFormat sdf = new SimpleDateFormat("MMddyyyyHHmmss");
		String fileName = "PAY" + companyCode + "_" + sdf.format(new Date()) + ".UPS";
		realPath = realPath + "/ups\\";

		StringBuilder strBuilder = new StringBuilder();

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("bankFileNo", bankFileNo);
		
		List<Map<String, Object>> summaryForBank = this.getGiacGeneralDisbReportDAO().getSummaryForBank(params);

		for (Map<String, Object> record : summaryForBank) {
			System.out.println(record.get("textToWrite"));
			strBuilder.append(record.get("textToWrite"));
			strBuilder.append(System.getProperty("line.separator"));
		}
		
		File file = new File(realPath + fileName);
		FileUtils.writeStringToFile(file, strBuilder.toString());

		params.put("fileName", file.getName());
		giacGeneralDisbReportDAO.updateFileName(params);
		
		return file.getName();
	}
	
	@Override
	public Map<String, Object> getTotal(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		if (request.getParameter("subAct").equals("viewRecordsViaBankFile")) {
			params.put("bankFileNo", request.getParameter("bankFileNo").equals("")?null:Integer.parseInt(request.getParameter("bankFileNo")));
			params = this.giacGeneralDisbReportDAO.getTotalViaBankFile(params);
		}else if (request.getParameter("subAct").equals("processViewRecords")) {
			params.put("ACTION", "getTotalViaRecords");
			params = this.giacGeneralDisbReportDAO.getTotalViaRecords(params);
		}
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}	

}
