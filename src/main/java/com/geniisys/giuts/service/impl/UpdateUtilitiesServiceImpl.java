package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIEndtText;
import com.geniisys.gipi.entity.GIPIPackEndtText;
import com.geniisys.gipi.entity.GIPIPackPolgenin;
import com.geniisys.gipi.entity.GIPIPolgenin;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.giuts.dao.UpdateUtilitiesDAO;
import com.geniisys.giuts.service.UpdateUtilitiesService;
import com.seer.framework.util.StringFormatter;

public class UpdateUtilitiesServiceImpl implements UpdateUtilitiesService{

	public UpdateUtilitiesDAO updateUtilitiesDAO;	
	
	
	public UpdateUtilitiesDAO getUpdateUtilitiesDAO() {
		return updateUtilitiesDAO;
	}

	public void setUpdateUtilitiesDAO(UpdateUtilitiesDAO updateUtilitiesDAO) {
		this.updateUtilitiesDAO = updateUtilitiesDAO;
	}

	@Override
	public Integer getNextBookingYear() throws SQLException {
		return this.updateUtilitiesDAO.getNextBookingYear();
	}

	@Override
	public Integer checkBookingYear(Integer bookingYear) throws SQLException {
		return this.updateUtilitiesDAO.checkBookingYear(bookingYear);
	}

	@Override
	public String generateBookingMonths(Map<String, Object> params) throws SQLException {
		return this.updateUtilitiesDAO.generateBookingMonths(params);
	}

	@Override
	public String updateGiisBookingMonth(Map<String, Object> params) throws SQLException {		
		return this.updateUtilitiesDAO.updateGiisBookingMonths(params);
	}

	@Override
	public String chkBookingMthYear(Map<String, Object> params) throws SQLException {
		return this.updateUtilitiesDAO.chkBookingMthYear(params);
	}

	@Override
	public List<String> getCurrentWcCdList(Map<String, Object> params) throws SQLException {
		return this.getUpdateUtilitiesDAO().getCurrentWcCdList(params);
	}

	@Override
	public JSONObject getGIUTS029ItemList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIUTS029ItemList");
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> tbgItems = TableGridUtil.getTableGrid(request, params);	
		return new JSONObject(tbgItems);
	}

	public JSONObject giuts029NewFormInstance() throws SQLException, JSONException {
		Map<String, Object> result = new HashMap<String, Object>(); 
		this.getUpdateUtilitiesDAO().giuts029NewFormInstance(result);
		return new JSONObject(result);
	}

	@Override
	public JSONObject getGiuts029AttachmentList(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIUTS029AttachmentList");
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		Map<String, Object> tbgAttachments = TableGridUtil.getTableGrid(request, params);	
		return new JSONObject(tbgAttachments);
	}
	
	private Object prepareGIUTS029Params(JSONArray jsonArray, String userId, String mode) throws JSONException { //added by steven 07.14.2014
		List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();
		for (int i = 0; i < jsonArray.length(); i++) {
			Map<String, Object> paramObj = new HashMap<String, Object>();
			JSONObject json = jsonArray.getJSONObject(i);
			if (mode.equals("set") && (json.getString("recordStatus").equals("0") || json.getString("recordStatus").equals("1"))) {
				paramObj.put("appUser", userId);
				paramObj.put("policyId", json.getString("policyId"));
				paramObj.put("itemNo", json.getString("itemNo"));
				paramObj.put("fileName", StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("fileName"))));
				paramObj.put("remarks", StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("remarks"))));
				paramList.add(paramObj);
				
			}else if (mode.equals("del") && json.getString("recordStatus").equals("-1")) {
				paramObj.put("appUser", userId);
				paramObj.put("policyId", json.getString("policyId"));
				paramObj.put("itemNo", json.getString("itemNo"));
				paramObj.put("fileName", StringFormatter.unescapeBackslash(StringEscapeUtils.unescapeHtml(json.getString("fileName"))));
				paramList.add(paramObj);
			}
		}
		return paramList;
	}

	@Override
	public void giuts029SaveChanges(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params = new HashMap<String, Object>();		
//		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("setRows"))));
//		params.put("delRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("delRows"))));
		params.put("setRows", prepareGIUTS029Params(new JSONArray(objParams.getString("setRows")), userId, "set")); //added by steven 07.14.2014
		params.put("delRows", prepareGIUTS029Params(new JSONArray(objParams.getString("delRows")), userId, "del"));
		params.put("appUser", userId);
		
		// get attachments
		List<Map<String, Object>> attachments = (List<Map<String, Object>>) params.get("delRows");
		List<String> files = new ArrayList<String>();
		
		if (!attachments.isEmpty()) {
			for (Map<String, Object> attachment : attachments) {
				files.add(attachment.get("fileName").toString());
			}
		}
		
		this.updateUtilitiesDAO.giuts029SaveChanges(params);
		
		// delete files
		FileUtil.deleteFiles(files);
	}

	@Override
	public JSONObject getGiuts027PolicyItemList(HttpServletRequest request, String userId) throws SQLException, JSONException {
		String newAction = "getGiuts027PolicyItemList";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", newAction);
		params.put("userId", userId);
		params.put("policyId", (request.getParameter("policyId") != null && !request.getParameter("policyId").equals("")) ? Integer.parseInt(request.getParameter("policyId")) : null);
		
		Map<String, Object> policyList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = policyList != null ? new JSONObject(policyList) : new JSONObject();
		return json;
	}

	@Override
	public void saveGipis047BondUpdate(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("npNo", request.getParameter("npNo"));
		params.put("collFlag", request.getParameter("collFlag"));
		params.put("waiverLimit", request.getParameter("waiverLimit"));
		params.put("policyId", request.getParameter("policyId"));
		System.out.println("steven params::" + params);
		this.getUpdateUtilitiesDAO().saveGipis047BondUpdate(params);
	}

	@Override
	public JSONObject getGIPIS156History(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS156History");
		params.put("policyId", request.getParameter("policyId"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		Map<String, Object> gipis156HistoryTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIPIS156History = new JSONObject(gipis156HistoryTable);
		return jsonGIPIS156History;
	}

	@Override
	public String validateGIPIS156AreaCd(HttpServletRequest request)
			throws SQLException {
		return updateUtilitiesDAO.validateGIPIS156AreaCd(request.getParameter("areaCd"));
	}

	@Override
	public JSONObject validateGIPIS156BancBranchCd(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		String areaCd = request.getParameter("areaCd");
		String branchCd = request.getParameter("branchCd");
		return updateUtilitiesDAO.validateGIPIS156BancBranchCd(areaCd, branchCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGeneralInitialInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGeneralInitialInfo");
		params.put("policyId", request.getParameter("policyId"));
		params = this.updateUtilitiesDAO.getGeneralInitialInfo(params);
		List<GIPIPolgenin> list = (List<GIPIPolgenin>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("row", new JSONArray(list));
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGeneralInitialPackInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGeneralInitialPackInfo");
		params.put("policyId", request.getParameter("policyId"));
		params = this.updateUtilitiesDAO.getGeneralInitialPackInfo(params);
		List<GIPIPackPolgenin> list = (List<GIPIPackPolgenin>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("row", new JSONArray(list));
		
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEndtInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getEndtInfo");
		params.put("policyId", request.getParameter("policyId"));
		params = this.updateUtilitiesDAO.getEndtInfo(params);
		List<GIPIEndtText> list = (List<GIPIEndtText>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("row", new JSONArray(list));
		return params;
	}

	@Override
	public String saveGenInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPolgenin.class));
		System.out.println("GENERAL INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().saveGenInfo(params);
	}

	@Override
	public String saveInitialInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPolgenin.class));
		System.out.println("INITIAL INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().saveInitialInfo(params);
	}

	@Override
	public String saveGenPackInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPackPolgenin.class));
		System.out.println("GENERAL PACK INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().saveGenPackInfo(params);
	}

	@Override
	public String saveInitialPackInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPackPolgenin.class));
		System.out.println("INITIAL PACK INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().saveInitialPackInfo(params);
	}

	@Override
	public String saveEndtText(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIEndtText.class));
		System.out.println("ENDORSEMENT TEXT : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().saveEndtText(params);
	}

	@Override
	public String validatePackage(HttpServletRequest request)throws SQLException {
		return updateUtilitiesDAO.validatePackage(request.getParameter("packPolicyId").equals("") ? null : Integer.parseInt(request.getParameter("packPolicyId")));
	}

	// SR-21812 JET JUN-27-2016
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackGeneralInitialInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPackGeneralInitialInfo");
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params = this.updateUtilitiesDAO.getPackGeneralInitialInfo(params);
		List<GIPIPackPolgenin> list = (List<GIPIPackPolgenin>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("row", new JSONArray(list));
		
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackEndtInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPackEndtInfo");
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params = this.updateUtilitiesDAO.getPackEndtInfo(params);
		List<GIPIPackEndtText> list = (List<GIPIPackEndtText>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("row", new JSONArray(list));
		return params;
	}
	
	@Override
	public String savePackGenInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPackPolgenin.class));
		System.out.println("GENERAL PACK INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().savePackGenInfo(params);
	}
	
	@Override
	public String savePackInitInfo(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPackPolgenin.class));
		System.out.println("INITIAL PACK INFO : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().savePackInitInfo(params);
	}
	
	@Override
	public String savePackEndtText(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("param"));
		Map<String, Object> params =  new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GIPIPackEndtText.class));
		System.out.println("ENDORSEMENT PACK TEXT : " + objParams.get("setRows"));
		return this.getUpdateUtilitiesDAO().savePackEndtText(params);
	}
	// @#
	
	@Override
	public JSONObject showUpdateMVFileNo(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showUpdateMVFileNo");
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> tbgUpdateMVFileNo = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonUpdateMVFileNo = new JSONObject(tbgUpdateMVFileNo);
		request.setAttribute("jsonUpdateMVFileNo", jsonUpdateMVFileNo);
		return jsonUpdateMVFileNo;
	}

	@Override
	public void saveGipis032MVFileNoUpdate(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		/*params.put("policyId", request.getParameter("policyId"));
		params.put("mvFileNo", request.getParameter("mvFileNo"));
		params.put("itemNo", request.getParameter("itemNo"));*/
		params.put("userId", USER.getUserId());
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), USER.getUserId(), GIPIVehicle.class));
		updateUtilitiesDAO.saveGipis032MVFileNoUpdate(params);
		
	}
	
	public List<String> getGipis155BlockId(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		
		return updateUtilitiesDAO.getGipis155BlockId(params);
	}
	
	public String saveFireItems(HttpServletRequest request, String userId) throws SQLException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("modifiedRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("modifiedRows"))));
		
		return updateUtilitiesDAO.saveFireItems(params, userId);
	}
	
	public JSONObject getInvoiceListGiuts025(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getInvoiceListGiuts025");
		params.put("policyId", request.getParameter("policyId"));
		params.put("issCd", request.getParameter("issCd"));
		
		Map<String, Object> invoiceList = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonInvoiceList = new JSONObject(invoiceList);
		
		return jsonInvoiceList;
	}
	//added USER by robert SR 5165 11.05.15
	public void saveGiuts025(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, Exception{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("newRefPolNo", request.getParameter("newRefPolNo"));
		params.put("newManualRenewNo", request.getParameter("newManualRenewNo"));
		params.put("newRefAcceptNo", request.getParameter("newRefAcceptNo")); //added by robert SR 5165 11.05.15
		params.put("userId", USER.getUserId()); //added by robert SR 5165 11.05.15
		params.put("modifiedRows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("modifiedRows"))));
		
		this.updateUtilitiesDAO.saveGiuts025(params);
	}
	
	@Override
	public void updateGIPIS156(HttpServletRequest request, GIISUser USER)
			throws Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("policyId", request.getParameter("policyId"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("bookingMth", request.getParameter("bookingMth"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		params.put("regPolicySw", request.getParameter("regPolicySw"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		params.put("areaCd", request.getParameter("areaCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("managerCd", request.getParameter("managerCd"));
		
		JSONObject objInvoice = new JSONObject(request.getParameter("objInvoice"));
		JSONArray arr = new JSONArray(objInvoice.getString("setRows"));
		
		List<Map<String, Object>> invoiceList = new ArrayList<Map<String, Object>>();
		
		for(int i = 0; i < arr.length(); i++){
			
			JSONObject rec = arr.getJSONObject(i);
			
			Map<String, Object> invoiceMap = new HashMap<String, Object>();
			invoiceMap.put("policyId", request.getParameter("policyId"));
			invoiceMap.put("issCd", rec.getString("issCd"));
			invoiceMap.put("premSeqNo", rec.getString("premSeqNo"));
			invoiceMap.put("multiBookingMm", rec.getString("multiBookingMm"));
			invoiceMap.put("multiBookingYy", rec.getString("multiBookingYy"));
			invoiceMap.put("userId", USER.getUserId());
			
			invoiceList.add(invoiceMap);
		}
		
		System.out.println("invoiceList");
		System.out.println(invoiceList);
		
		params.put("invoiceList", invoiceList);
		
		//System.out.println("PARAMS : " + params);
		updateUtilitiesDAO.updateGIPIS156(params);
	}

	@Override
	public JSONObject getGIPIS156BancaHistory(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS156BancaHistory");
		params.put("policyId", request.getParameter("policyId"));
		Map<String, Object> gipis156BancaHistoryTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIPIS156BancaHistory = new JSONObject(gipis156BancaHistoryTable);
		return jsonGIPIS156BancaHistory;
	}

	@Override
	public void valAddGiuts029(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("fileName", request.getParameter("fileName"));
		updateUtilitiesDAO.valAddGiuts029(params);
	}
}
