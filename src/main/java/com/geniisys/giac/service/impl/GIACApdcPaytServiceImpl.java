package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACApdcPaytDAO;
import com.geniisys.giac.entity.GIACApdcPayt;
import com.geniisys.giac.entity.GIACApdcPaytDtl;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.entity.GIACDCBUser;
import com.geniisys.giac.entity.GIACPdcPremColln;
import com.geniisys.giac.entity.GIACPdcReplace;
import com.geniisys.giac.service.GIACApdcPaytService;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.StringFormatter;

public class GIACApdcPaytServiceImpl implements GIACApdcPaytService{

	private GIACApdcPaytDAO giacApdcPaytDAO;
	private GIACBranchService giacBranchService;
	private GIISUserFacadeService giisUserFacadeService;
	private GIACDCBUserService giacDCBUserService;
	private static Logger log = Logger.getLogger(GIACApdcPaytServiceImpl.class);
	private DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");

	public GIACApdcPaytDAO getGiacApdcPaytDAO() {
		return giacApdcPaytDAO;
	}

	public void setGiacApdcPaytDAO(GIACApdcPaytDAO giacApdcPaytDAO) {
		this.giacApdcPaytDAO = giacApdcPaytDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytService#getApdcPaytListing(java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getApdcPaytListing(Map<String, Object> params)
			throws SQLException {
		log.info("getApdcPaytListing");
		params.put("keyword", '%'+params.get("keyword").toString().toUpperCase()+'%');
		List<GIACApdcPayt> payorLOV = this.giacApdcPaytDAO.getApdcPaytListing(params);
		PaginatedList paginatedList = new PaginatedList(payorLOV, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage((Integer) params.get("page"));
		return paginatedList;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytService#popApdc(java.util.Map)
	 */
	public Map<String, Object> popApdc(Map<String, Object> params)
			throws SQLException {
		return this.giacApdcPaytDAO.popApdc(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytService#generateApdcId()
	 */
	public Integer generateApdcId() throws SQLException {
		return this.giacApdcPaytDAO.generateApdcId();
	}

	/*
	 * +(non-Javadoc)
	 * @see com.geniisys.giac.service.GIACApdcPaytService#saveAcknowledgmentReceipt(java.util.Map)
	 */
	public void saveAcknowledgmentReceipt(Map<String, Object> allParams)
			throws Exception {
		String parameter = allParams.get("parameters").toString();
		JSONObject paramsObj = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		//params for delete
		/*
		params.put("delGiacApdcPayt", allParams.get("deletedApdcId"));
		params.put("delGiacApdcPaytDtl", this.prepareDelAckReceiptObj(new JSONArray((String) allParams.get("deletedApdcPaytDtlObj")), "apdcPaytDtl"));
		params.put("delGiacPdcPremColln", this.prepareDelAckReceiptObj(new JSONArray((String) allParams.get("deletedPremCollnObj")), "pdcPremColln"));*/
		params.put("delGiacApdcPayt", paramsObj.getString("deletedApdcId"));
		params.put("delGiacApdcPaytDtl", this.prepareDelAckReceiptObj(new JSONArray(paramsObj.getString("deletedApdcPaytDtlObj")), "apdcPaytDtl"));
		params.put("delGiacPdcPremColln", this.prepareDelAckReceiptObj(new JSONArray(paramsObj.getString("deletedPremCollnObj")), "pdcPremColln"));
		
		//params for insert
		/*
		if (!"{}".equals(allParams.get("apdcPaytObj"))){
			params.put("giacApdcPayt", this.prepareApdcPaytObject(new JSONObject((String) allParams.get("apdcPaytObj"))));
		} else {
			params.put("giacApdcPayt", null);
		}
		params.put("giacApdcPaytDtl", this.prepareApdcPaytDtlObject(new JSONArray((String) allParams.get("apdcPaytDtlObj"))));
		params.put("giacInsertedPdcPremColln", this.preparePdcPremCollnObjectForInsert(new JSONArray((String) allParams.get("insertedPremCollnObj"))));
		params.put("giacUpdatedPdcPremColln", this.preparePdcPremCollnObjectForUpdate(new JSONArray((String) allParams.get("updatedPremCollnObj"))));*/
		System.out.println("estong tutong : " + paramsObj.getString("apdcPaytObj"));
		if (!"{}".equals(paramsObj.getString("apdcPaytObj"))){
			params.put("giacApdcPayt", this.prepareApdcPaytObject(new JSONObject((String) paramsObj.getString("apdcPaytObj"))));
		} else {
			params.put("giacApdcPayt", null);
		}
		params.put("giacApdcPaytDtl", this.prepareApdcPaytDtlObject(new JSONArray(paramsObj.getString("apdcPaytDtlObj"))));
		params.put("giacInsertedPdcPremColln", this.preparePdcPremCollnObjectForInsert(new JSONArray(paramsObj.getString("addedPremCollnObj"))));
		params.put("giacUpdatedPdcPremColln", this.preparePdcPremCollnObjectForUpdate(new JSONArray(paramsObj.getString("updatedPremCollnObj"))));
		
		//params for pdc replace
		//params.put("pdcReplaceList", this.preparePdcReplaceObj(new JSONArray((String) allParams.get("pdcReplaceObj"))));
		params.put("pdcReplaceList", this.preparePdcReplaceObj(new JSONArray(paramsObj.getString("pdcReplaceObjectList"))));
		
		this.giacApdcPaytDAO.saveAcknowledgmentReceipt(params);
	}
	
	/**
	 * 
	 * @param apdcPaytObj
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public GIACApdcPayt prepareApdcPaytObject(JSONObject apdcPaytObj) throws JSONException, ParseException{
		GIACApdcPayt apdcPayt = new GIACApdcPayt();
		
		apdcPayt.setAddress1(apdcPaytObj.isNull("address1") ? null : apdcPaytObj.getString("address1"));
		apdcPayt.setAddress1(apdcPaytObj.isNull("address2") ? null : apdcPaytObj.getString("address2"));
		apdcPayt.setAddress1(apdcPaytObj.isNull("address3") ? null : apdcPaytObj.getString("address3"));
		apdcPayt.setApdcDate(apdcPaytObj.isNull("apdcDate") ? null : sdf.parse(apdcPaytObj.getString("apdcDate")));
		apdcPayt.setApdcFlag(apdcPaytObj.isNull("apdcFlag") ? null : apdcPaytObj.getString("apdcFlag"));
		apdcPayt.setApdcId(apdcPaytObj.isNull("apdcId") ? null : apdcPaytObj.getInt("apdcId"));
		apdcPayt.setApdcNo(apdcPaytObj.isNull("apdcNo") ? null : apdcPaytObj.getString("apdcNo"));
		apdcPayt.setApdcPref(apdcPaytObj.isNull("apdcPref") ? null : apdcPaytObj.getString("apdcPref"));
		apdcPayt.setBranchCd(apdcPaytObj.isNull("branchCd") ? null : apdcPaytObj.getString("branchCd"));
		apdcPayt.setCashierCd(apdcPaytObj.isNull("cashierCd") ? null : apdcPaytObj.getInt("cashierCd"));
		apdcPayt.setCicPrintTag(apdcPaytObj.isNull("cicPrintTag") ? null : apdcPaytObj.getString("cicPrintTag"));
		apdcPayt.setFundCd(apdcPaytObj.isNull("fundCd") ? null : apdcPaytObj.getString("fundCd"));
		apdcPayt.setParticulars(apdcPaytObj.isNull("particulars") ? null : apdcPaytObj.getString("particulars"));
		apdcPayt.setPayor(apdcPaytObj.isNull("payor") ? null : apdcPaytObj.getString("payor"));
		apdcPayt.setRefApdcNo(apdcPaytObj.isNull("refApdcNo") ? null : apdcPaytObj.getString("refApdcNo"));
		
		return apdcPayt;
	}
	
	//temporary
	public List<GIACApdcPaytDtl> prepareApdcPaytDtlObject(JSONArray apdcPaytDtlObjArray) throws JSONException, ParseException{
		List<GIACApdcPaytDtl> apdcPaytDtlList = new ArrayList<GIACApdcPaytDtl>();
		
		JSONObject tempApdcPaytDtl = null;
		
		for (int i = 0; i < apdcPaytDtlObjArray.length(); i++){			
			GIACApdcPaytDtl apdcPaytDtl = new GIACApdcPaytDtl();
			tempApdcPaytDtl = apdcPaytDtlObjArray.getJSONObject(i);		
			
			apdcPaytDtl.setApdcId(tempApdcPaytDtl.isNull("apdcId") ? null : tempApdcPaytDtl.getInt("apdcId"));
			apdcPaytDtl.setPdcId(tempApdcPaytDtl.isNull("pdcId") ? null : tempApdcPaytDtl.getInt("pdcId"));
			apdcPaytDtl.setItemNo(tempApdcPaytDtl.isNull("itemNo") ? null : tempApdcPaytDtl.getInt("itemNo"));
			apdcPaytDtl.setBankCd(tempApdcPaytDtl.isNull("bankCd") ? null : tempApdcPaytDtl.getString("bankCd"));
			apdcPaytDtl.setCheckClass(tempApdcPaytDtl.isNull("checkClass") ? null :  tempApdcPaytDtl.getString("checkClass"));
			apdcPaytDtl.setCheckNo(tempApdcPaytDtl.isNull("checkNo") ? null :  tempApdcPaytDtl.getString("checkNo"));
			apdcPaytDtl.setCheckDate(tempApdcPaytDtl.isNull("checkDate") ? null : sdf.parse(tempApdcPaytDtl.getString("checkDate")));
			apdcPaytDtl.setCheckAmt(tempApdcPaytDtl.isNull("checkAmt") ? null :  new BigDecimal(tempApdcPaytDtl.getString("checkAmt").replaceAll(",", "")));
			apdcPaytDtl.setCurrencyCd(tempApdcPaytDtl.isNull("currencyCd") ? null : tempApdcPaytDtl.getInt("currencyCd"));
			apdcPaytDtl.setCurrencyRt(tempApdcPaytDtl.isNull("currencyRt") ? null : new BigDecimal(tempApdcPaytDtl.getString("currencyRt")));
			apdcPaytDtl.setFcurrencyAmt(tempApdcPaytDtl.isNull("fcurrencyAmt") || "".equals(tempApdcPaytDtl.getString("fcurrencyAmt")) ? null : new BigDecimal(tempApdcPaytDtl.getString("fcurrencyAmt").replaceAll(",", "")));
			apdcPaytDtl.setParticulars(tempApdcPaytDtl.isNull("particulars") ? null : tempApdcPaytDtl.getString("particulars"));
			apdcPaytDtl.setPayor(tempApdcPaytDtl.isNull("payor") ? null : tempApdcPaytDtl.getString("payor"));
			apdcPaytDtl.setAddress1(tempApdcPaytDtl.isNull("address1") ? null : tempApdcPaytDtl.getString("address1"));
			apdcPaytDtl.setAddress2(tempApdcPaytDtl.isNull("address2") ? null : tempApdcPaytDtl.getString("address2"));
			apdcPaytDtl.setAddress3(tempApdcPaytDtl.isNull("address3") ? null : tempApdcPaytDtl.getString("address3"));
			apdcPaytDtl.setTin(tempApdcPaytDtl.isNull("tin") ? null : tempApdcPaytDtl.getString("tin"));
			apdcPaytDtl.setCheckFlag(tempApdcPaytDtl.isNull("checkFlag") ? null : tempApdcPaytDtl.getString("checkFlag"));
			apdcPaytDtl.setGrossAmt(tempApdcPaytDtl.isNull("grossAmt") || "".equals(tempApdcPaytDtl.getString("grossAmt")) ? null :  new BigDecimal(tempApdcPaytDtl.getString("grossAmt").replaceAll(",", "")));
			apdcPaytDtl.setCommissionAmt(tempApdcPaytDtl.isNull("commissionAmt") || "".equals(tempApdcPaytDtl.getString("commissionAmt")) ? null :  new BigDecimal(tempApdcPaytDtl.getString("commissionAmt").replace(",", "")));
			apdcPaytDtl.setVatAmt(tempApdcPaytDtl.isNull("vatAmt") || "".equals(tempApdcPaytDtl.getString("vatAmt")) ? null :  new BigDecimal(tempApdcPaytDtl.getString("vatAmt")));
			apdcPaytDtl.setFcGrossAmt(tempApdcPaytDtl.isNull("fcGrossAmt") || "".equals(tempApdcPaytDtl.getString("fcGrossAmt")) ? null : new BigDecimal(tempApdcPaytDtl.getString("fcGrossAmt")));
			apdcPaytDtl.setFcCommAmt(tempApdcPaytDtl.isNull("fcCommAmt") || "".equals(tempApdcPaytDtl.getString("fcCommAmt")) ? null : new BigDecimal(tempApdcPaytDtl.getString("fcCommAmt")));
			apdcPaytDtl.setFcTaxAmt(tempApdcPaytDtl.isNull("fcTaxAmt") || "".equals(tempApdcPaytDtl.getString("fcTaxAmt")) ? null : new BigDecimal(tempApdcPaytDtl.getString("fcTaxAmt")));
			apdcPaytDtl.setReplaceDate(tempApdcPaytDtl.isNull("replaceDate") ? null : sdf.parse(tempApdcPaytDtl.getString("replaceDate")));
			apdcPaytDtl.setPayMode(tempApdcPaytDtl.isNull("payMode") ? null : tempApdcPaytDtl.getString("payMode"));
			apdcPaytDtl.setIntermediary(tempApdcPaytDtl.isNull("intermediary") ? null :  tempApdcPaytDtl.getString("intermediary"));
			apdcPaytDtl.setBankBranch(tempApdcPaytDtl.isNull("bankBranch") ? null :  tempApdcPaytDtl.getString("bankBranch"));
			
			apdcPaytDtlList.add(apdcPaytDtl);
		}
		System.out.println("PDC SIZE :  " + apdcPaytDtlList.size());
		return apdcPaytDtlList;
	}
	
	public List<GIACPdcPremColln> preparePdcPremCollnObjectForInsert(JSONArray pdcPremCollnObjArray) throws JSONException{
		List<GIACPdcPremColln> pdcPremCollnList = new ArrayList<GIACPdcPremColln>();
		JSONObject pdcPremCollnObj = null;
		
		for (int i = 0; i < pdcPremCollnObjArray.length(); i++){
			GIACPdcPremColln pdcPremColln = new GIACPdcPremColln();
			pdcPremCollnObj = pdcPremCollnObjArray.getJSONObject(i);
			
			pdcPremColln.setPdcId(pdcPremCollnObj.isNull("pdcId") ? null : pdcPremCollnObj.getInt("pdcId"));
			pdcPremColln.setTranType(pdcPremCollnObj.isNull("tranType") ? null : pdcPremCollnObj.getInt("tranType"));
			pdcPremColln.setIssCd(pdcPremCollnObj.isNull("issCd") ? null : pdcPremCollnObj.getString("issCd"));
			pdcPremColln.setPremSeqNo(pdcPremCollnObj.isNull("premSeqNo") ? null : pdcPremCollnObj.getInt("premSeqNo"));
			pdcPremColln.setInstNo(pdcPremCollnObj.isNull("instNo") ? null : pdcPremCollnObj.getInt("instNo"));
			pdcPremColln.setCollnAmt(pdcPremCollnObj.isNull("collnAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("collnAmt")));
			pdcPremColln.setCurrCd(pdcPremCollnObj.isNull("currCd") || "".equals(pdcPremCollnObj.getString("currCd")) ? null : Integer.parseInt(pdcPremCollnObj.getString("currCd")));
			pdcPremColln.setCurrRt(pdcPremCollnObj.isNull("currRt") || "".equals(pdcPremCollnObj.getString("currRt")) ? null : new BigDecimal(pdcPremCollnObj.getString("currRt")));
			pdcPremColln.setfCurrAmt(pdcPremCollnObj.isNull("fcurrAmt") || "".equals(pdcPremCollnObj.getString("fcurrAmt")) ? null : new BigDecimal(pdcPremCollnObj.getString("fcurrAmt")));
			pdcPremColln.setPremAmt(pdcPremCollnObj.isNull("premAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("premAmt")));
			pdcPremColln.setTaxAmt(pdcPremCollnObj.isNull("taxAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("taxAmt")));
			pdcPremColln.setInsertTag(pdcPremCollnObj.isNull("insertTag") ? null : pdcPremCollnObj.getString("insertTag"));
			
			pdcPremCollnList.add(pdcPremColln);
		}
		
		return pdcPremCollnList;
	}
	
	public List<Map<String, Object>> preparePdcPremCollnObjectForUpdate(JSONArray pdcPremCollnObjArray) throws JSONException {
		List<Map<String, Object>> pdcPremCollnList = new ArrayList<Map<String,Object>>();
		JSONObject pdcPremCollnObj = null;
		
		for (int i = 0; i < pdcPremCollnObjArray.length(); i++){
			Map<String, Object> pdcPremCollnObjMap = new HashMap<String, Object>();
			pdcPremCollnObj = pdcPremCollnObjArray.getJSONObject(i);
			
			pdcPremCollnObjMap.put("pdcId", pdcPremCollnObj.isNull("pdcId") ? null : pdcPremCollnObj.getInt("pdcId"));
			pdcPremCollnObjMap.put("tranType", pdcPremCollnObj.isNull("lastTransactionType") ? null : pdcPremCollnObj.getInt("lastTransactionType"));
			pdcPremCollnObjMap.put("issCd", pdcPremCollnObj.isNull("issCd") ? null : pdcPremCollnObj.getString("issCd"));
			pdcPremCollnObjMap.put("premSeqNo", pdcPremCollnObj.isNull("lastPremSeqNo") ? null : pdcPremCollnObj.getInt("lastPremSeqNo"));
			pdcPremCollnObjMap.put("instNo", pdcPremCollnObj.isNull("instNo") ? null : pdcPremCollnObj.getInt("instNo"));
			pdcPremCollnObjMap.put("collnAmt", pdcPremCollnObj.isNull("collnAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("collnAmt")));
			pdcPremCollnObjMap.put("currCd", pdcPremCollnObj.isNull("currCd") || "".equals(pdcPremCollnObj.getString("currCd")) ? null : Integer.parseInt(pdcPremCollnObj.getString("currCd")));
			pdcPremCollnObjMap.put("currRt", pdcPremCollnObj.isNull("currRt") || "".equals(pdcPremCollnObj.getString("currRt")) ? null : new BigDecimal(pdcPremCollnObj.getString("currRt")));
			pdcPremCollnObjMap.put("fcurrAmt", pdcPremCollnObj.isNull("fcurrAmt") || "".equals(pdcPremCollnObj.getString("fcurrAmt")) ? null : new BigDecimal(pdcPremCollnObj.getString("fcurrAmt")));
			pdcPremCollnObjMap.put("premAmt", pdcPremCollnObj.isNull("premAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("premAmt")));
			pdcPremCollnObjMap.put("taxAmt", pdcPremCollnObj.isNull("taxAmt") ? null : new BigDecimal(pdcPremCollnObj.getString("taxAmt")));
			pdcPremCollnObjMap.put("insertTag", pdcPremCollnObj.isNull("insertTag") ? null : pdcPremCollnObj.getString("insertTag"));
			pdcPremCollnObjMap.put("newPremSeqNo", pdcPremCollnObj.isNull("premSeqNo") ? null : pdcPremCollnObj.getInt("premSeqNo"));
			pdcPremCollnObjMap.put("newTranType", pdcPremCollnObj.isNull("tranType") ? null : pdcPremCollnObj.getInt("tranType"));
			
			pdcPremCollnList.add(pdcPremCollnObjMap);
		}
		
		return pdcPremCollnList;
	}
	
	public List<Map<String, Object>> prepareDelAckReceiptObj(JSONArray delAckReceiptObjArray, String param) throws JSONException{
		List<Map<String, Object>> delApdcPaytParamsList = new ArrayList<Map<String,Object>>();
		JSONObject delAckReceiptObj = null;
		
		if (delAckReceiptObjArray.equals("[]")){
			return null;
		} else {
			for (int i = 0; i < delAckReceiptObjArray.length(); i++){
				Map<String, Object> delApdcPaytParams = new HashMap<String, Object>();
				delAckReceiptObj = delAckReceiptObjArray.getJSONObject(i);
				if (param == "apdcPayt"){
					delApdcPaytParams.put("apdcId", delAckReceiptObj.getInt("apdcId"));
				} else if (param == "apdcPaytDtl") {
					delApdcPaytParams.put("pdcId", delAckReceiptObj.getInt("pdcId"));
				} else if (param == "pdcPremColln") {
					delApdcPaytParams.put("pdcId", delAckReceiptObj.getInt("pdcId"));
					delApdcPaytParams.put("tranType", delAckReceiptObj.getInt("tranType"));
					delApdcPaytParams.put("issCd", delAckReceiptObj.getString("issCd"));
					delApdcPaytParams.put("premSeqNo", delAckReceiptObj.getInt("premSeqNo"));
				}
				delApdcPaytParamsList.add(delApdcPaytParams);
			}
			return delApdcPaytParamsList;
		}
	}
	
	public List<GIACPdcReplace> preparePdcReplaceObj(JSONArray pdcReplaceObj) throws JSONException, ParseException{
		List<GIACPdcReplace> pdcReplaceList = new ArrayList<GIACPdcReplace>();
		JSONObject pdcRepObj = null;
		JSONArray pdcRepArray = null;
		
		for (int i = 0; i < pdcReplaceObj.length(); i++){
			pdcRepObj = pdcReplaceObj.getJSONObject(i);
			pdcRepArray = pdcRepObj.getJSONArray("rows");
			for (int j = 0; j < pdcRepArray.length(); j++){
				JSONObject replaceObject = pdcRepArray.getJSONObject(j);
				GIACPdcReplace giacPdcReplace = new GIACPdcReplace();
				
				giacPdcReplace.setPdcId(pdcRepObj.isNull("pdcId") ? null : pdcRepObj.getInt("pdcId"));
				giacPdcReplace.setItemNo(replaceObject.isNull("itemNo") ? null : replaceObject.getInt("itemNo"));
				giacPdcReplace.setPayMode(replaceObject.isNull("payMode") ? null : replaceObject.getString("payMode"));
				giacPdcReplace.setBankCd(replaceObject.isNull("bankCd") ? null : replaceObject.getString("bankCd"));
				giacPdcReplace.setCheckClass(replaceObject.isNull("checkClass") ? null : replaceObject.getString("checkClass"));
				giacPdcReplace.setCheckNo(replaceObject.isNull("checkNo") ? null : replaceObject.getString("checkNo"));
				giacPdcReplace.setCheckDate(replaceObject.isNull("checkDate") || "".equals(replaceObject.getString("checkDate")) ? null : sdf.parse(replaceObject.getString("checkDate")));
				giacPdcReplace.setAmount(replaceObject.isNull("amount") || "".equals(replaceObject.getString("amount")) ? null : new BigDecimal(replaceObject.getString("amount")));
				giacPdcReplace.setCurrencyCd(replaceObject.isNull("currencyCd") ? null : replaceObject.getInt("currencyCd"));
				giacPdcReplace.setGrossAmt(replaceObject.isNull("grossAmt") || "".equals(replaceObject.getString("grossAmt")) ? null : new BigDecimal(replaceObject.getString("grossAmt")));
				giacPdcReplace.setCommissionAmt(replaceObject.isNull("commissionAmt") || "".equals(replaceObject.getString("commissionAmt")) ? null : new BigDecimal(replaceObject.getString("commissionAmt")));
				giacPdcReplace.setVatAmt(replaceObject.isNull("vatAmt") || "".equals(replaceObject.getString("vatAmt")) ? null : new BigDecimal(replaceObject.getString("vatAmt")));
				giacPdcReplace.setRefNo(replaceObject.isNull("refNo") ? null : replaceObject.getString("refNo"));
				
				pdcReplaceList.add(giacPdcReplace);
			}
		}
		
		return pdcReplaceList;
	}
	
	public String verifyApdcNo(Map<String, Object> params) throws SQLException{
		return this.giacApdcPaytDAO.verifyApdcNo(params);
	}
	
	public Integer getDocSeqNo(Map<String, Object> params) throws SQLException{
		this.giacApdcPaytDAO.getDocSeqNo(params);
		Integer docSeqNo = (Integer) params.get("docSeqNo");
		return docSeqNo;
	}
	
	public void savePrintChanges(Map<String, Object> params) throws Exception{
		this.giacApdcPaytDAO.savePrintChanges(params);
	}
	
	public GIACApdcPayt getApdcPayt(Map<String, Object> params) throws SQLException{
		return this.giacApdcPaytDAO.getApdcPayt(params);
	}

	@Override
	public JSONObject getGIACApdcPaytListing(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		log.info("Retrieving apdc payt listing...");
		//GIACBranch giacBranch = giacBranchService.getBranchDetails();
		String branchCd = (request.getParameter("branchCd")==null || "".equals(request.getParameter("branchCd")) ? this.giisUserFacadeService.getGroupIssCd(userId) : request.getParameter("branchCd"));
		GIACBranch giacBranch = giacBranchService.getBranchDetails2(branchCd);
		String apdcFlag = (request.getParameter("apdcFlag")==null || "".equals(request.getParameter("apdcFlag")) || "undefined".equals(request.getParameter("apdcFlag")) ? "N" : request.getParameter("apdcFlag")); //benjo 11.08.2016 SR-5802
		
		if(request.getParameter("refresh") == null || !request.getParameter("refresh").equals("1")){
			GIACDCBUser cashierDetail = giacDCBUserService.getDCBCashierCd(giacBranch.getGfunFundCd(), giacBranch.getBranchCd(), userId);
			request.setAttribute("cashierCd", (cashierDetail == null ? "" : cashierDetail.getCashierCd()));		
			request.setAttribute("moduleId", request.getParameter("moduleId"));
			request.setAttribute("branchCd", request.getParameter("branchCd"));
		}
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));	
		params.put("fundCd", giacBranch.getGfunFundCd());
		params.put("branchCd", giacBranch.getBranchCd());
		params.put("apdcFlag", apdcFlag); //benjo 11.08.2016 SR-5802
		Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);		
		JSONObject json = new JSONObject(tranListTableGrid);
		return json;
	}

	public void setGiacBranchService(GIACBranchService giacBranchService) {
		this.giacBranchService = giacBranchService;
	}

	public GIACBranchService getGiacBranchService() {
		return giacBranchService;
	}

	@Override
	public void delGIACApdcPayt(Integer apdcId) throws SQLException {
		this.giacApdcPaytDAO.delGIACApdcPayt(apdcId);
	}

	@Override
	public void cancelGIACApdcPayt(Integer apdcId, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("apdcId", apdcId);
		this.giacApdcPaytDAO.cancelGIACApdcPayt(params);
	}

	@Override
	public void saveGIACApdcPayt(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("appUser", userId);
		params.put("setApdcPayt", JSONUtil.prepareObjectFromJSON(new JSONObject(paramsObj.getString("apdcPaytObj")), userId, GIACApdcPayt.class));
		params.put("setApdcPaytDtls", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setApdcPaytDtlObj")), userId, GIACApdcPaytDtl.class));
		params.put("delApdcPaytDtls", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delApdcPaytDtlObj")), userId, GIACApdcPaytDtl.class));
		params.put("setPdcPremCollns", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setPremCollnObj")), userId, GIACPdcPremColln.class));
		params.put("delPdcPremCollns", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delPremCollnObj")), userId, GIACPdcPremColln.class));
		
		this.giacApdcPaytDAO.saveGIACApdcPayt(params);
	}

	@Override
	public GIACApdcPayt getGIACApdcPayt(Integer apdcId) throws SQLException {
		return this.giacApdcPaytDAO.getGIACApdcPayt(apdcId);
	}

	@Override
	public void showGIACApdcPayt(HttpServletRequest request, ApplicationContext appContext, String userId)
			throws SQLException, JSONException {
		//GIACBranchService branchDetailService = (GIACBranchService) appContext.getBean("giacBranchService");
		GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) appContext.getBean("giacParameterFacadeService"); //benjo 11.08.2016 SR-5802
		LOVHelper lovHelper = (LOVHelper) appContext.getBean("lovHelper");
		String branchCd = (request.getParameter("branchCd")==null || "".equals(request.getParameter("branchCd")) ? this.giisUserFacadeService.getGroupIssCd(userId) : request.getParameter("branchCd"));
		GIACBranch giacBranch = giacBranchService.getBranchDetails2(branchCd);
		GIACDCBUser cashierDetail = new GIACDCBUser();
		cashierDetail = giacDCBUserService.getDCBCashierCd(giacBranch.getGfunFundCd(), giacBranch.getBranchCd(), userId);
		request.setAttribute("cashierCd", cashierDetail.getCashierCd());
		System.out.println("cashierCd : " + cashierDetail.getCashierCd());
		System.out.println("showAcknowledgmentReceipt for Branch "+giacBranch.getBranchName());
		
		request.setAttribute("branchDetails", giacBranch);
		request.setAttribute("currency", lovHelper.getList(LOVHelper.CURRENCY_CODES));
		String[] checkClass = {"GIAC_CHK_DISBURSEMENT.CHECK_CLASS"};
		request.setAttribute("checkClass", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, checkClass));
		String[] transType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
		request.setAttribute("tranTypeLOV", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transType));
		
		Map<String, Object> popApdcMap = new HashMap<String, Object>();
		popApdcMap.put("fundCd", giacBranch.getGfunFundCd());
		popApdcMap.put("branchCd", giacBranch.getBranchCd());
		popApdcMap.put("apdcFlag", "N");
		this.popApdc(popApdcMap);
		
		request.setAttribute("docPrefSuf", popApdcMap.get("docPrefSuf"));
		request.setAttribute("orParticularsText", popApdcMap.get("orParticularsText"));
		request.setAttribute("defaultCurrency", popApdcMap.get("defaultCurrency"));
		request.setAttribute("premTaxPriority", popApdcMap.get("premTaxPriority"));
		request.setAttribute("moduleId", request.getParameter("moduleId"));
		request.setAttribute("apdcSW", giacParamService.getParamValueV2("APDC_SW")); //benjo 11.08.2016 SR-5802
		
		GIACApdcPayt giacApdcPayt = null;
		if(!request.getParameter("apdcId").equals("")){
			Integer apdcId = Integer.parseInt(request.getParameter("apdcId"));
			giacApdcPayt = this.getGIACApdcPayt(apdcId);
			//request.setAttribute("giacApdcPayt", new JSONObject(StringFormatter.replaceQuotesInObject(giacApdcPayt))); //marco - 04.15.2013 - replaced with escapeHTMLInObject
			request.setAttribute("giacApdcPayt", new JSONObject(StringFormatter.escapeHTMLInObject(giacApdcPayt)));
		} else {
			giacApdcPayt = new GIACApdcPayt();
			giacApdcPayt.setFundCd(giacBranch.getGfunFundCd());
			giacApdcPayt.setBranchCd(giacBranch.getBranchCd());
			giacApdcPayt.setApdcPref((String) popApdcMap.get("docPrefSuf"));
			giacApdcPayt.setApdcFlag((String) popApdcMap.get("apdcFlag"));
			giacApdcPayt.setApdcFlagMeaning((String) popApdcMap.get("dspStatus"));
			giacApdcPayt.setCashierCd(cashierDetail.getCashierCd());
			//request.setAttribute("giacApdcPayt", new JSONObject(giacApdcPayt)); //marco - 04.15.2013 - added with escapeHTMLInObject
			request.setAttribute("giacApdcPayt", new JSONObject(StringFormatter.escapeHTMLInObject(giacApdcPayt)));
		}
		
		Map<String, Object> grid = new HashMap<String, Object>();
		grid.put("apdcId", request.getParameter("apdcId"));
		grid.put("ACTION", "getApdcPaytDtlTableGrid");
		grid = TableGridUtil.getTableGrid(request, grid);
		System.out.println("showGIACApdcPayt ::::::::::::::::::" + grid);
		request.setAttribute("postDatedChecksTableGrid", new JSONObject(grid));	
		
		///added by jdiago 08.08.2014 : fetch all item numbers with pageSize default of 100,
		Map<String, Object> itemNo = new HashMap<String, Object>();
		itemNo.put("apdcId", request.getParameter("apdcId"));
		itemNo.put("ACTION", "getApdcPaytDtlTableGrid");
		itemNo.put("pageSize", 100);
		itemNo = TableGridUtil.getTableGrid(request, itemNo);
		request.setAttribute("itemNosList", new JSONObject(itemNo));
	}

	@Override
	public JSONObject getBreakdownAmounts(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionType", request.getParameter("transactionType"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", Integer.parseInt(request.getParameter("premSeqNo")));
		params.put("instNo", Integer.parseInt(request.getParameter("instNo")));
		params.put("collectionAmt", new BigDecimal(request.getParameter("collectionAmt").replaceAll(",", "")));
		this.giacApdcPaytDAO.getBreakdownAmounts(params);
		return new JSONObject(params);
	}

	public void setGiisUserFacadeService(GIISUserFacadeService giisUserFacadeService) {
		this.giisUserFacadeService = giisUserFacadeService;
	}

	public GIISUserFacadeService getGiisUserFacadeService() {
		return giisUserFacadeService;
	}

	public void setGiacDCBUserService(GIACDCBUserService giacDCBUserService) {
		this.giacDCBUserService = giacDCBUserService;
	}

	public GIACDCBUserService getGiacDCBUserService() {
		return giacDCBUserService;
	}

	@Override
	public void valDelApdc(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("pdcId", request.getParameter("pdcId"));
		this.giacApdcPaytDAO.valDelApdc(params);
	}
}
