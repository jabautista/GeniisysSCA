package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACOrderOfPaymentDAO;
import com.geniisys.giac.entity.GIACOrRel;
import com.geniisys.giac.entity.GIACOrderOfPayment;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.seer.framework.util.StringFormatter;

public class GIACOrderOfPaymentServiceImpl implements GIACOrderOfPaymentService{
	
	/** The gipi par item dao. */
	private GIACOrderOfPaymentDAO giacOrderOfPaymentDAO;
	
	/**
	 * @return the giacOrderOfPaymentDAO
	 */
	public GIACOrderOfPaymentDAO getGiacOrderOfPaymentDAO() {
		return giacOrderOfPaymentDAO;
	}

	/**
	 * @param giacOrderOfPaymentDAO the giacOrderOfPaymentDAO to set
	 */
	public void setGiacOrderOfPaymentDAO(GIACOrderOfPaymentDAO giacOrderOfPaymentDAO) {
		this.giacOrderOfPaymentDAO = giacOrderOfPaymentDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#saveORInformation(java.util.Map, java.lang.Integer)
	 */
	@Override
	public Integer saveORInformation(Map<String, Object> allParam, Integer gaccTranId) throws Exception {
		return giacOrderOfPaymentDAO.saveORInformation(allParam, gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#validateCancelledORInput(java.lang.String, java.lang.Integer)
	 */
	@Override
	public GIACOrderOfPayment validateCancelledORInput(String orPrefSuf, Integer orNo) throws Exception {
		return giacOrderOfPaymentDAO.validateCancelledORInput(orPrefSuf, orNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getGIACOrderOfPaymentDtl(int)
	 */
	@Override
	public GIACOrderOfPayment getGIACOrderOfPaymentDtl(int tranId)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getGIACOrderOfPaymentDtl(tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getRVMeaning(java.lang.String, java.lang.String)
	 */
	@Override
	public String getRVMeaning(String rvDomain, String rvLowValue)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getRVMeaning(rvDomain, rvLowValue);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getOrTag(java.lang.Integer)
	 */
	@Override
	public String getOrTag(Integer tranID) throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getOrTag(tranID);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getORList(java.lang.Integer, java.util.Map)
	 */
	@Override
	public JSONArrayList getORList(Integer pageNo, Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> orList = this.getGiacOrderOfPaymentDAO().getORList(params);
		JSONArrayList orArray = new JSONArrayList(orList, pageNo);
		return orArray;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getGIACOrderOfPaymentDtl(int)
	 */
	@Override
	public GIACOrderOfPayment getGIACOrDtl(int tranId) throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getGIACOrDtl(tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#updateAllPayorItmDtls(java.util.Map)
	 */
	//@Override commented by alfie 03-14-2011
	/*public  Map<String, Object>  updateAllPayorItmDtls(Map<String, Object> params)	throws SQLException {
		return  (Map<String, Object>) this.getGiacOrderOfPaymentDAO().updateAllPayorItmDtls(params);
	}*/

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#updateSelectedPayorItmDtls(java.util.Map)
	 */
	@Override
	public Map<String, Object> updateSelectedPayorItmDtls(Map<String, Object> params) throws SQLException {
		return  (Map<String, Object>) this.getGiacOrderOfPaymentDAO().updateSelectedPayorItmDtls(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#spoilOR(java.util.Map)
	 */
	@Override
	public void spoilOR(Map<String, Object> params) throws SQLException, Exception {
		this.getGiacOrderOfPaymentDAO().spoilOR(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#updateAllPayorItmDtls2(java.lang.String)
	 */
	@SuppressWarnings("unused")
	@Override
	public void updateAllPayorItmDtls2(JSONArray jsonPremCollnsDtls)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		List<Map<String, Object>> paramListing = new ArrayList<Map<String, Object>>();
		//JSONArray jsonArrayPremCollnsDtls = (JSONArray) jsonPremCollnsDtls;
		JSONObject jCurrentPremColln = null;
		
		String stringDatatypeVar = "issCd lineCd payorBtn";
		String integerDatatypeVar = "premSeqNo tranId policyId";
		String[] stringDatatypeVariables = stringDatatypeVar.split(" ");
		String[] integerDataTypeVariables = integerDatatypeVar.split(" ");
		for(int i=0; i < jsonPremCollnsDtls.length(); i++){

			jCurrentPremColln = jsonPremCollnsDtls.getJSONObject(i);
			
			for (int j=0; j<stringDatatypeVariables.length; j++) {
				System.out.println("UpdateAllPayorItmDtls2 : " + jCurrentPremColln.toString());
				params.put(stringDatatypeVariables[j], jCurrentPremColln.isNull(stringDatatypeVariables[j]) ? null : jCurrentPremColln.getString(stringDatatypeVariables[j]));
			}
			
			for (int k=0; k<integerDataTypeVariables.length; k++) {
				params.put(integerDataTypeVariables[k], jCurrentPremColln.isNull(integerDataTypeVariables[k]) ? null : jCurrentPremColln.getInt(integerDataTypeVariables[k]));
			}
			
			paramListing.add(params);
			break; //added by robert 01.10.2013
		}
	
		try {
			this.getGiacOrderOfPaymentDAO().updateAllPayorItmDtls(paramListing);
		} catch (Exception e) {			
			e.printStackTrace();
		}
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getORListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getORListTableGridMap(Map<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareORListDetailFilter((String) params.get("filter")));
		List<Map<String, Object>> orList = (List<Map<String, Object>>) 
			StringFormatter.escapeHTMLInListOfMap(this.getGiacOrderOfPaymentDAO().getORListTableGrid(params)); // mark jm 07.06.2011 replaced replacedQuotesInList to escapeHTMLInListOfMap 
		
		params.put("rows", new JSONArray(orList));
		grid.setNoOfPages(orList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareORListDetailFilter(String filter) throws JSONException {
		Map<String, Object> orList = new HashMap<String, Object>();
		JSONObject jsonORListFilter = null;
		
		if (null == filter) {
			jsonORListFilter = new JSONObject();
		} else {
			jsonORListFilter = new JSONObject(filter);
		}
		
		orList.put("dcbNo", jsonORListFilter.isNull("dcbNo") ? "" : jsonORListFilter.getString("dcbNo").toUpperCase());
		orList.put("orNo", jsonORListFilter.isNull("orNo") ? "" : jsonORListFilter.getString("orNo").toUpperCase());
		orList.put("orDate", jsonORListFilter.isNull("orDate") ? "" : jsonORListFilter.getString("orDate").toUpperCase());
		orList.put("lastUpdate", jsonORListFilter.isNull("lastUpdate") ? "" : jsonORListFilter.getString("lastUpdate")); // Added by Jerome Bautista 11.03.2015 SR 20144
		orList.put("payor", jsonORListFilter.isNull("payor") ? "" : jsonORListFilter.getString("payor").toUpperCase());
		orList.put("orStatus", jsonORListFilter.isNull("orStatus") ? "" : jsonORListFilter.getString("orStatus").toUpperCase());
		orList.put("dcbUserId", jsonORListFilter.isNull("dcbUserId") ? "" : jsonORListFilter.getString("dcbUserId").toUpperCase());
		
		return orList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#giacs050InsUpdGIOP(java.util.Map)
	 */
	@Override
	public Map<String, Object> giacs050InsUpdGIOP(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().giacs050InsUpdGIOP(params);
	}

	/*added by alfie 03-14-2011*/
	@SuppressWarnings("unused")
	@Override
	public String getUpdatedPayorIntmDtls(JSONArray jsonArray)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		String msg 	= null;
		String msg2 = "";
		
		JSONObject jCurrentPremColln = null;
		
		String integerDatatypeVar = "tranId policyId";
		
		String[] integerDataTypeVariables = integerDatatypeVar.split(" ");
		for(int i=0; i < jsonArray.length(); i++){

			jCurrentPremColln = jsonArray.getJSONObject(i);
			
			for (int k=0; k<integerDataTypeVariables.length; k++) {
				params.put(integerDataTypeVariables[k], jCurrentPremColln.isNull(integerDataTypeVariables[k]) ? null : jCurrentPremColln.getInt(integerDataTypeVariables[k]));
			}
			
			msg2+=this.getGiacOrderOfPaymentDAO().getUpdatedPayorIntmDtls(params) + " ";
			break; //added by robert 01.10.2013
		}
		
		msg="Transaction No. " + params.get("tranId") + " was updated to " + msg2;
		
		return msg;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#spoilPrintedOR(java.util.Map)
	 */
	@Override
	public Map<String, Object> spoilPrintedOR(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().spoilPrintedOR(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#getCreditMemoDtls(java.lang.String)
	 */
	@Override
	public List<Map<String, Object>> getCreditMemoDtls(String fundCd) throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getCreditMemoDtls(fundCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#checkAttachedOR(java.util.Map)
	 */
	@Override
	public String checkAttachedOR(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().checkAttachedOR(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#validateOr(java.util.Map)
	 */
	@Override
	public String validateOr(Map<String, Object> params) throws SQLException {
		return this.getGiacOrderOfPaymentDAO().validateOr(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOrderOfPaymentService#insUpdGIOPNewOR(java.util.Map)
	 */
	@Override
	public Map<String, Object> insUpdGIOPNewOR(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().insUpdGIOPNewOR(params);
	}


	@Override
	public void validateOR2(Map<String, Object> params)
			throws SQLException, InterruptedException {
		this.getGiacOrderOfPaymentDAO().validateOR2(params);
	}


	@Override
	public Map<String, Object> generateNewOR(Map<String, Object> params)
			throws SQLException, InterruptedException {
		return this.getGiacOrderOfPaymentDAO().generateNewOR(params);
	}


	@Override
	public void processPrintedOR(Map<String, Object> params)
			throws SQLException {
		this.getGiacOrderOfPaymentDAO().processPrintedOR(params);
	}

	@Override
	public void checkCommPayts(HttpServletRequest request) throws SQLException {		
		this.getGiacOrderOfPaymentDAO().checkCommPayts(Integer.parseInt(request.getParameter("gaccTranId")));
	}

	@Override
	public void delOR(Map<String, Object> params) throws SQLException {
		this.getGiacOrderOfPaymentDAO().delOR(params);
	}

	@Override
	public String getPayorIntmDtls(int tranId) throws SQLException,
			JSONException {
		return this.getGiacOrderOfPaymentDAO().getPayorIntmDtls(tranId);
	}

	@Override
	public void populateBatchORTempTable(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("calledByUpload", request.getParameter("calledByUpload"));
		//params.put("uploadQuery", request.getParameter("uploadQuery")); //Deo [10.06.2016]: comment out
		params.put("uploadQuery", request.getParameter("uploadQuery") == null || request.getParameter("uploadQuery").isEmpty() ? -1 : request.getParameter("uploadQuery")); //Deo [10.06.2016]: replacement
		this.getGiacOrderOfPaymentDAO().populateBatchORTempTable(params);
	}
	
	@Override
	public JSONObject getBatchORList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBatchORList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("calledByUpload", request.getParameter("calledByUpload"));
		params.put("uploadQuery", request.getParameter("uploadQuery"));
		params.put("dspOrDate", request.getParameter("dspOrDate"));
		params.put("payor", request.getParameter("payor"));
		params.put("orType", request.getParameter("orType"));

		if(!("1".equals(request.getParameter("refresh")))){
			this.populateBatchORTempTable(request);
		}
		
		Map<String, Object> batchORTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(batchORTG);
	}

	@Override
	public String checkOR(HttpServletRequest request) throws SQLException {
		return this.getGiacOrderOfPaymentDAO().checkOR(request.getParameter("gaccTranId"));
	}
	
	public Map<String, Object> checkAllORs(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orDate", request.getParameter("dspOrDate"));
		params.put("payor", request.getParameter("payor"));
		return this.getGiacOrderOfPaymentDAO().checkAllORs(params);
	}
	
	public void uncheckAllORs()
			throws SQLException {
		this.getGiacOrderOfPaymentDAO().uncheckAllORs();
	}

	@Override
	public Map<String, Object> getDefaultORValues(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("oneORSequence", request.getParameter("oneORSequence"));
		params.put("vatNonVatSeries", request.getParameter("vatNonVatSeries"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		return this.getGiacOrderOfPaymentDAO().getDefaultORValues(params);
	}

	@Override
	public void generateOrNumbers(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("oneORSequence", request.getParameter("oneORSequence"));
		params.put("vatNonVatSeries", request.getParameter("vatNonVatSeries"));
		params.put("vatPref", request.getParameter("vatPref"));
		params.put("vatSeq", request.getParameter("vatSeq"));
		params.put("nonVatPref", request.getParameter("nonVatPref"));
		params.put("nonVatSeq", request.getParameter("nonVatSeq"));
		params.put("otherPref", request.getParameter("otherPref"));
		params.put("otherSeq", request.getParameter("otherSeq"));
		params.put("userId", userId);
		this.getGiacOrderOfPaymentDAO().generateOrNumbers(params);
	}

	@Override
	public List<Map<String, Object>> getBatchORReportParams(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("orType", request.getParameter("orType"));
		return this.getGiacOrderOfPaymentDAO().getBatchORReportParams(params);
	}

	@Override
	public void saveGenerateFlag(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setRows"))));
		this.getGiacOrderOfPaymentDAO().saveGenerateFlag(params);
	}

	@Override
	public void processPrintedBatchOR(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("orType", request.getParameter("orType"));
		params.put("lastOrNo", request.getParameter("lastOrNo"));
		params.put("userId", userId);
		this.getGiacOrderOfPaymentDAO().processPrintedBatchOR(params);
	}

	@Override
	public String checkLastPrintedOR(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lastOrNo", request.getParameter("lastOrNo"));
		params.put("lastOrPrinted", request.getParameter("lastOrPrinted"));
		params.put("orType", request.getParameter("orType"));
		return this.getGiacOrderOfPaymentDAO().checkLastPrintedOR(params);
	}

	@Override
	public void spoilBatchOR(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lastOrNo", request.getParameter("lastOrNo"));
		params.put("orType", request.getParameter("orType"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		this.getGiacOrderOfPaymentDAO().spoilBatchOR(params);
	}

	@Override
	public void spoilSelectedOR(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("orPref", request.getParameter("orPref"));
		params.put("orNo", request.getParameter("orNo"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userId", userId);
		this.getGiacOrderOfPaymentDAO().spoilSelectedOR(params);
	}

	@Override
	public Map<String, Object> getBatchCommSlipParams() throws SQLException {
		return this.getGiacOrderOfPaymentDAO().getBatchCommSlipParams();
	}
	
	
	public JSONObject getGiacs213VehicleListing(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs213VehicleListing");
		params.put("assdNo", request.getParameter("assdNo"));
		params.put("userId", userId);
		Map<String, Object> vehicleList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(vehicleList);
	}
	
	public Integer countVehiclesInsured(Integer assdNo) throws SQLException{
		return this.giacOrderOfPaymentDAO.countVehiclesInsured(assdNo);
	}
	
	public JSONObject getGiacs214PolbasicListing(HttpServletRequest request, String userId) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs214PolbasicListing");
		params.put("assdNo", request.getParameter("assdNo"));
		params.put("userId", userId);
		
		Map<String, Object> vehicleList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(vehicleList);
	}
	
	public JSONObject getGiacs214InvoiceListing(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs214InvoiceListing");
		params.put("policyId", request.getParameter("policyId"));
		
		Map<String, Object> vehicleList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(vehicleList);
	}
	
	public JSONObject getGiacs214AgingSoaDetails(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs214AgingSoaDetails");
		params.put("assdNo", request.getParameter("assdNo"));
		
		Map<String, Object> vehicleList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(vehicleList);
	}

	@Override
	public String checkAPDCPaytDtl(Integer gaccTranId)
			throws SQLException {
		return this.getGiacOrderOfPaymentDAO().checkAPDCPaytDtl(gaccTranId);
	}
	
	//john 10.15.2014
	public List<Map<String, Object>> getCnclCollnBreakDown(HttpServletRequest request) throws SQLException {
		return giacOrderOfPaymentDAO.getCnclCollnBreakDown(Integer.parseInt(request.getParameter("gaccTranId")));
	}
	
	//john 10.20.2014
	public GIACOrRel getGiacOrRel(Integer tranId) throws SQLException {
		return giacOrderOfPaymentDAO.getGiacOrRel(tranId);
	}
	
	@Override
	public void checkRecordStatus(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", request.getParameter("tranId"));
		params.put("moduleId", request.getParameter("moduleId"));
		this.getGiacOrderOfPaymentDAO().checkRecordStatus(params);
	}
}
