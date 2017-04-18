/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

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

import com.geniisys.gipi.dao.GIPIWInvoiceDAO;

import com.geniisys.gipi.entity.GIPIOrigInvoice;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.entity.GIPIWinvTax;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWInvoiceFacadeServiceImpl.
 */
public class GIPIWInvoiceFacadeServiceImpl implements GIPIWInvoiceFacadeService{

/** The gipi w invoice dao. */
private GIPIWInvoiceDAO  gipiWInvoiceDao;
private GIPIPARListService gipiParListService;

	/**
 * @return the gipiParListService
 */
public GIPIPARListService getGipiParListService() {
	return gipiParListService;
}

/**
 * @param gipiParListService the gipiParListService to set
 */
public void setGipiParListService(GIPIPARListService gipiParListService) {
	this.gipiParListService = gipiParListService;
}

	/**
	 * Sets the gipi w invoice dao.
	 * 
	 * @param gipiWInvoiceDAO the new gipi w invoice dao
	 */
	public void setGipiWInvoiceDAO(GIPIWInvoiceDAO gipiWInvoiceDAO) {
		this.gipiWInvoiceDao = gipiWInvoiceDAO;
	}
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWInvoiceFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi w invoice dao.
	 * 
	 * @return the gipi w invoice dao
	 */
	public GIPIWInvoiceDAO getGipiWInvoiceDAO() {
		return gipiWInvoiceDao;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#getGIPIWInvoice(int, int)
	 */
	@Override
	public List<GIPIWInvoice> getGIPIWInvoice(int parId, int itemGrp) throws SQLException {
		@SuppressWarnings("unused")
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		log.info("Retrieving WInvoice...");
		List<GIPIWInvoice> gipiWInvoice = gipiWInvoiceDao.getGIPIWInvoice(parId, itemGrp);
		log.info("WInvoice Size():" + gipiWInvoice.size());
		return gipiWInvoice;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#getGIPIWInvoice2(int)
	 */
	@Override
	
	public List<GIPIWInvoice> getGIPIWInvoice2(int parId) throws SQLException {
		log.info("Retrieving WInvoice2...");
		List<GIPIWInvoice> gipiWInvoice = gipiWInvoiceDao.getGIPIWInvoice2(parId);
		log.info("WInvoice Size():" + gipiWInvoice.size());
		return gipiWInvoice;
	}
	
	public List<GIPIWInvoice> getGIPIWInvoice3(int parId) throws SQLException, ParseException {
		log.info("Retrieving WInvoice3...");
		List<GIPIWInvoice> gipiWInvoice = gipiWInvoiceDao.getGIPIWInvoice3(parId);
		log.info("WInvoice Size():" + gipiWInvoice.size());
		return gipiWInvoice;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#getItemGrpWinvoice(int)
	 */
	public List<GIPIWInvoice>  getItemGrpWinvoice(int parId)
	throws SQLException {
		log.info("Retrieving Distinct WInvoice...");
		List<GIPIWInvoice> gipiWinvoice = gipiWInvoiceDao. getItemGrpWinvoice(parId);
		log.info(" Distinct Winvoice Size():" + gipiWinvoice.size());
		return gipiWinvoice;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#getTakeupWinvoice(int)
	 */
	public List<GIPIWInvoice> getTakeupWinvoice(int parId)
	throws SQLException {
		log.info("Retrieving Distinct takeup WInvoice...");
		List<GIPIWInvoice> gipiWinvoice = gipiWInvoiceDao. getTakeupWinvoice(parId);
		log.info(" Distinct takeup Winvoice Size():" + gipiWinvoice.size());
		return gipiWinvoice;
	}
	/*public GIPIWInvoice getGIPIWInvoice(int parId, int itemGrp) throws SQLException {
		log.info("Retrieving WInvoice...");
		GIPIWInvoice gipiWInvoice = gipiWInvoiceDao.getGIPIWInvoice(parId, itemGrp);
		log.info("WInvoice Size():" + gipiWInvoice.getItemGrp());
		return gipiWInvoice;
	}*/
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#saveWInvoice(java.util.Map)
	 */
	@Override
	public void saveWInvoice(String allParameters, Map<String, Object> params)	throws SQLException, ParseException, JSONException {
		JSONObject objParameters = new JSONObject(allParameters);
		Debug.print("JSON: " + objParameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("modifiedWInvoice", this.prepareWInvoice(new JSONArray(objParameters.getString("modifiedWInvoice"))));
		allParams.put("allWInvoice", this.prepareWInvoice(new JSONArray(objParameters.getString("allWInvoiceDtls")))); //added by steven 08.26.2014
		allParams.put("addedModifiedWinvTax", this.prepareAddModifiedTaxInfo(new JSONArray(objParameters.getString("addedModifiedWinvTax"))));
		allParams.put("deletedWinvTax", this.prepareTaxInfoToDelete(new JSONArray(objParameters.getString("deletedWinvTax"))));
		allParams.put("addedModifiedInstallment", this.prepareAddModifiedInstallment(new JSONArray(objParameters.getString("addedModifiedInstallment"))));
		allParams.put("parListParams", params);
		Debug.print("After prepare: " + allParams);
		
		this.getGipiWInvoiceDAO().saveGIPIWInvoice(allParams);
		
		/*Integer parId = (Integer) parameters.get("parId");
		Integer itemGrp = (Integer) parameters.get("itemGrp");
		String insured = (String) parameters.get("insured");
		String[] property = (String[]) parameters.get("property");
		String[] takeupSeqNo =(String[]) parameters.get("takeupSeqNo");
		String[] multiBookingMM = (String[]) parameters.get("multiBookingMM");
		String[] multiBookingYY = (String[]) parameters.get("multiBookingYY");
		String[] refInvNo = (String[]) parameters.get("refInvNo");
		String[] policyCurrency = (String[]) parameters.get("policyCurrency");
		String[] dueDate = (String[]) parameters.get("dueDate");
		String[] otherCharges = (String[]) parameters.get("otherCharges");
		String[] taxAmt = (String[]) parameters.get("taxAmt"); 
		String premAmt = (String) parameters.get("premAmt");
		String[] paytTerms = (String[]) parameters.get("paytTerms");
		String premSeqNo = (String) parameters.get("premSeqNo");
		String[] remarks = (String[]) parameters.get("remarks");
		String noOfTakeup = (String) parameters.get("noOfTakeup");
		String[] payType = (String[]) parameters.get("payType");
		String[] cardName = (String[]) parameters.get("selCreditCard") ;
		String[] cardNo = (String[]) parameters.get("cardNo");
		String[] expiryDate = (String[]) parameters.get("cardExpiryDate");
		String[] approvalCd = (String[]) parameters.get("approvalCd");
		String[] riCommVat = (String[]) parameters.get("riCommVat");
		String[] riCommAmt = (String[]) parameters.get("riCommAmt");
		String[] changedTag = (String[]) parameters.get("changedTag");
		GIPIWInvoice winvoice = null;
		//System.out.println("service impl" + takeupSeqNo+expiryDate);
		
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		System.out.println("take up length: " + takeupSeqNo.length);
		for(int i=0; i<takeupSeqNo.length; i++){
			winvoice = new GIPIWInvoice();
			winvoice.setParId(parId);
			winvoice.setItemGrp(itemGrp);
			winvoice.setInsured(insured);
			winvoice.setProperty(property[i]);
			winvoice.setTakeupSeqNo(takeupSeqNo[i] == "" ? null : Integer.parseInt(takeupSeqNo[i]));
			winvoice.setMultiBookingMM(multiBookingMM[i]);
			winvoice.setMultiBookingYY(multiBookingYY[i] == "" ? null : Integer.parseInt(multiBookingYY[i]));
		//	winvoice.setPolicyCurrency(policyCurrency[i]);
			winvoice.setPremAmt(premAmt == null ? null : new BigDecimal(premAmt.replaceAll(",", "")));
			System.out.println("TAXAMT: " + taxAmt[i]);
			winvoice.setTaxAmt(new BigDecimal(taxAmt[i].replaceAll(",", "") == "" ? "0.00" : taxAmt[i].replaceAll(",", "")));
			winvoice.setPaytTerms(paytTerms[i]);
			winvoice.setRefInvNo(refInvNo[i] == "" ? null : refInvNo[i]);
			winvoice.setOtherCharges(otherCharges[i] == "" ? null : new BigDecimal(otherCharges[i].replaceAll(",", "")));
			winvoice.setDueDate(dueDate[i] == null ? null : df.parse(dueDate[i]));
			winvoice.setPayType(payType==null?null:payType[i]==""?null:payType[i]);
			winvoice.setRemarks(remarks[i]);
			winvoice.setNoOfTakeup(Integer.parseInt(noOfTakeup));
			winvoice.setCardName(cardName[i]);
			winvoice.setCardNo(cardNo[i] == "" ? null: Integer.parseInt(cardNo[i]));
			winvoice.setApprovalCd(approvalCd[i]== "" ? null : approvalCd[i]);
			winvoice.setExpiryDate(expiryDate[i] == "" ? null : df.parse(expiryDate[i]));
			winvoice.setRiCommAmt(riCommAmt == null ? null : riCommAmt[i] == null ?  new BigDecimal(0): new BigDecimal(riCommAmt[i]));
			winvoice.setRiCommVat(riCommVat == null ? null : riCommVat[i] == null ? new BigDecimal(0) : new BigDecimal(riCommVat[i]));
		   System.out.println(cardName[i]);
		   System.out.println(takeupSeqNo[i]);
		//   System.out.println(payType[i]);
//		System.out.println(winvoice.getPaytTerms());
//		System.out.println(winvoice.getMultiBookingMM());
//		System.out.println(winvoice.getMultiBookingYY());
		//System.out.println(winvoice);
		this.getGipiWInvoiceDAO().saveGIPIWInvoice(winvoice);
		}*/
		//return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#deleteGIPIWinvoice(int)
	 */
	public boolean deleteGIPIWinvoice(int parId)
	throws SQLException {

			log.info("Deleting all Winvoice...");
			this.getGipiWInvoiceDAO().deleteGIPIWinvoice(parId);
			log.info("Winvoice deleted.");

			return true;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#winvoiceNewFormInst(int, java.lang.String, int)
	 */
	@Override
	public Map<String, Object> winvoiceNewFormInst(int packParId,
			String issCd, int parId) throws SQLException {
		return this.gipiWInvoiceDao.winvoiceNewFormInst(packParId, issCd, parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWInvoiceFacadeService#winvoicePostFormsCommit3(java.lang.Integer)
	 */
	@Override
	public void winvoicePostFormsCommit3(Integer parId) throws SQLException {
		this.gipiWInvoiceDao.winvoicePostFormsCommit3(parId);		
	}

	@Override
	public boolean updatePaytTermsGIPIWInvoice(Integer parId, Integer itemGrp,
			Integer takeupSeqNo, String paytTerms) throws SQLException {
		log.info("Updating payment term. . . ");
		this.gipiWInvoiceDao.updatePaytTermsGIPIWInvoice(parId, itemGrp, takeupSeqNo, paytTerms);
		log.info("Payment term updated. . . ");
		return true;
	}

	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWInvoiceDao.isExist(parId);
	}

	@Override
	public Map<String, String> checkPolicyCurrency(String currencyDesc,
			Integer parId) throws SQLException {
		log.info("checking policy currency. . . ");
		return this.gipiWInvoiceDao.checkPolicyCurrency(currencyDesc, parId);
	}
	
	public Map<String, String> getWInvoiceInputVatRate(Integer parId) throws SQLException{
		log.info("retrieving input vat rate. . . ");
			return this.gipiWInvoiceDao.getWInvoiceInputVatRate(parId);
	
	}

	@Override
	public void createWInvoice(Integer parId, String lineCd, String issCd) throws SQLException{
		log.info("Inserting into Gipi_WInvoice with parId = " + parId);
		this.gipiWInvoiceDao.createWInvoice(parId, lineCd, issCd);
	}

	@Override
	public Map<String, Object> getWinvoiceBondDtls(Map<String, Object> params) throws SQLException {
		log.info("retrieving bond details. . . ");
		return this.gipiWInvoiceDao.getWinvoiceBondDtls(params);
	}

	@Override
	public List<GIPIWInvoice> getTakeUpListDtls(Integer parId) throws SQLException {
		return this.gipiWInvoiceDao.getTakeUpListDtls(parId);
	}

	@Override
	public void saveBondBillDtls(String parameters, Map<String, Object> gipiWInvoiceParams) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameters);
		
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("addModifiedTakeUp", this.prepareAddModifiedTakeUp(new JSONArray(objParameters.getString("addModifiedTakeUp"))));
		allParams.put("deletedTakeUp", new JSONArray(objParameters.getString("deletedTakeUp")));
		allParams.put("addModifiedTaxInfo", this.prepareAddModifiedTaxInfo(new JSONArray(objParameters.getString("addModifiedTaxInfo"))));
		allParams.put("deletedTaxInfo", this.prepareTaxInfoToDelete(new JSONArray(objParameters.getString("deletedTaxInfo"))));
		allParams.put("postFormsParams", gipiWInvoiceParams);
		
		Debug.print("addModifiedTakeUp: " + this.prepareAddModifiedTakeUp(new JSONArray(objParameters.getString("addModifiedTakeUp"))));
		Debug.print("deletedTakeUp: " + new JSONArray(objParameters.getString("deletedTakeUp")));
		Debug.print("addModifiedTaxInfo: " + this.prepareAddModifiedTaxInfo(new JSONArray(objParameters.getString("addModifiedTaxInfo"))));
		Debug.print("deletedTaxInfo: " + this.prepareTaxInfoToDelete(new JSONArray(objParameters.getString("deletedTaxInfo"))));
		
		this.gipiWInvoiceDao.saveBondBillDtls(allParams, gipiWInvoiceParams);
	}
	
	public List<GIPIWInvoice> prepareAddModifiedTakeUp(JSONArray setRows) throws JSONException, ParseException{
		GIPIWInvoice takeUp = null;
		JSONObject json = null;
		List<GIPIWInvoice> setTakeUp = new ArrayList<GIPIWInvoice>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");

		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			
			takeUp = new GIPIWInvoice();						
			takeUp.setParId(json.isNull("parId") ? null : json.getInt("parId"));
			takeUp.setItemGrp(json.isNull("itemGrp") ? null : json.getInt("itemGrp"));
			takeUp.setInsured(json.isNull("insured") ? null : json.getString("insured"));
			takeUp.setProperty(json.isNull("property") ? null : json.getString("property"));
			takeUp.setTakeupSeqNo(json.isNull("takeupSeqNo") ? null : json.getInt("takeupSeqNo"));
			takeUp.setMultiBookingMM(json.isNull("multiBookingMM") ? null : json.getString("multiBookingMM"));
			takeUp.setMultiBookingYY(json.isNull("multiBookingYY") ? null : json.getInt("multiBookingYY"));
			takeUp.setRefInvNo(json.isNull("refInvNo") ? null : json.getString("refInvNo"));
			takeUp.setPolicyCurrency(json.isNull("policyCurrency") ? null : json.getString("policyCurrency"));
			takeUp.setPaytTerms(json.isNull("paytTerms") ? null : json.getString("paytTerms"));
			takeUp.setDueDate(json.isNull("dueDate") ? null : df.parse(json.getString("dueDate")));
			takeUp.setOtherCharges(json.isNull("otherCharges") ? null : new BigDecimal(json.getString("otherCharges")));
			takeUp.setTaxAmt(json.isNull("taxAmt") ? null : new BigDecimal(json.getString("taxAmt")));
			takeUp.setPremAmt(json.isNull("premAmt") ? null : new BigDecimal(json.getString("premAmt")));
			takeUp.setPremSeqNo(json.isNull("premSeqNo") ? null : json.getInt("premSeqNo"));
			takeUp.setRemarks(json.isNull("remarks") ? null : json.getString("remarks"));
			takeUp.setRiCommAmt(json.isNull("riCommAmt") ? null : new BigDecimal(json.getString("riCommAmt")));
			takeUp.setPayType(json.isNull("payType") ? null : json.getString("payType"));
			takeUp.setCardName(json.isNull("cardName") ? null : json.getString("cardName"));
			takeUp.setCardNo(json.isNull("cardNo") ? null : json.getInt("cardNo"));
			takeUp.setExpiryDate(json.isNull("expiryDate") ? null : df.parse(json.getString("expiryDate")));
			takeUp.setApprovalCd(json.isNull("approvalCd") ? null : json.getString("approvalCd"));
			takeUp.setRiCommVat(json.isNull("riCommVat") ? null : new BigDecimal(json.getString("riCommVat")));
			takeUp.setChangedTag(json.isNull("changedTag") ? null : json.getString("changedTag"));
			takeUp.setNoOfTakeup(json.isNull("noOfTakeup") ? null : json.getInt("noOfTakeup"));
			
			setTakeUp.add(takeUp);
		}	
		
		return setTakeUp;
	}
	
	public List<GIPIWinvTax> prepareAddModifiedTaxInfo(JSONArray setRows) throws JSONException, ParseException{
		GIPIWinvTax taxInfo = null;
		JSONObject json = null;
		List<GIPIWinvTax> setTaxInfo = new ArrayList<GIPIWinvTax>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			
			taxInfo = new GIPIWinvTax();						
			taxInfo.setTaxId(json.isNull("taxId") ? null : json.getInt("taxId"));
			taxInfo.setTaxCd(json.isNull("taxCd") ? null : json.getInt("taxCd"));
			//taxInfo.setTaxAmt(json.isNull("taxAmt") ? null : new BigDecimal(json.getString("taxAmt"))); removed by Joms Diago 03112013
			taxInfo.setTaxAmt(json.isNull("taxAmt") ? null : new BigDecimal(json.getString("taxAmt").replaceAll(",",""))); // Added by Joms Diago 03112013
			taxInfo.setParId(json.isNull("parId") ? null : json.getInt("parId"));
			taxInfo.setTakeupSeqNo(json.isNull("takeupSeqNo") ? null : json.getInt("takeupSeqNo"));
			taxInfo.setLineCd(json.isNull("lineCd") ? null : json.getString("lineCd"));
			taxInfo.setIssCd(json.isNull("issCd") ? null : json.getString("issCd"));
			taxInfo.setItemGrp(json.isNull("itemGrp") ? null : json.getInt("itemGrp"));
			taxInfo.setRate(json.isNull("rate") ? null : new BigDecimal(json.getString("rate")));
			//System.out.println("RATE::: " +json.getString("rate"));//BELLE
			taxInfo.setTaxAllocation(json.isNull("taxAllocation") ? null : json.getString("taxAllocation"));
			taxInfo.setFixedTaxAllocation(json.isNull("fixedTaxAllocation") ? null : json.getString("fixedTaxAllocation"));
		
			setTaxInfo.add(taxInfo);
		}	
		
		return setTaxInfo;
	}
	
	public List<Map<String, Object>> prepareTaxInfoToDelete(JSONArray delRows) throws JSONException, ParseException{
		List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> delItem = null;
		for(int index=0; index<delRows.length(); index++) {
			
			delItem = new HashMap<String, Object>();
			delItem.put("parId", delRows.getJSONObject(index).isNull("parId") ? null : delRows.getJSONObject(index).getInt("parId"));
			delItem.put("itemGrp", delRows.getJSONObject(index).isNull("itemGrp") ? null : delRows.getJSONObject(index).getInt("itemGrp"));
			delItem.put("takeupSeqNo", delRows.getJSONObject(index).isNull("takeupSeqNo") ? null : delRows.getJSONObject(index).getInt("takeupSeqNo"));
			delItem.put("taxCd", delRows.getJSONObject(index).isNull("taxCd") ? null : delRows.getJSONObject(index).getInt("taxCd"));
			delItem.put("issCd", delRows.getJSONObject(index).isNull("issCd") ? null : delRows.getJSONObject(index).getString("issCd"));
			delItem.put("lineCd", delRows.getJSONObject(index).isNull("lineCd") ? null : delRows.getJSONObject(index).getString("lineCd"));
			
			delItems.add(delItem);
		}
		
		return delItems;
	}
	
	public List<GIPIWInvoice> prepareWInvoice(JSONArray setRows) throws JSONException, ParseException{
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWInvoice modifiedGipiWInvoice = null;
		JSONObject json = null;
		List<GIPIWInvoice> setModifiedGipiWInvoice = new ArrayList<GIPIWInvoice>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			modifiedGipiWInvoice  = new GIPIWInvoice(); 
			modifiedGipiWInvoice.setTakeupSeqNo(json.getInt("takeupSeqNo")); 
			modifiedGipiWInvoice.setItemGrp(json.getInt("itemGrp"));
			modifiedGipiWInvoice.setParId(json.getInt("parId"));
			modifiedGipiWInvoice.setProperty(json.isNull("property") ? null : json.getString("property").isEmpty() ? null : json.getString("property")); 
			modifiedGipiWInvoice.setRefInvNo(json.isNull("refInvNo") ? null : json.getString("refInvNo").isEmpty() ? null : json.getString("refInvNo"));
			modifiedGipiWInvoice.setRemarks(json.isNull("remarks") ? null : json.getString("remarks").isEmpty() ? null : json.getString("remarks"));
			modifiedGipiWInvoice.setMultiBookingMM(json.getString("multiBookingMM"));
			modifiedGipiWInvoice.setMultiBookingYY(json.getInt("multiBookingYY"));
			modifiedGipiWInvoice.setPayType(json.getString("payType"));
			modifiedGipiWInvoice.setPaytTerms(json.getString("paytTerms"));
			modifiedGipiWInvoice.setDueDate(json.get("dueDate").toString().equals("") ? null : sdf.parse(json.get("dueDate").toString())); // added null validation
			modifiedGipiWInvoice.setPremAmt(json.isNull("premAmt") ? null : json.getString("premAmt").isEmpty() ? null : new BigDecimal((json.getString("premAmt"))));
			modifiedGipiWInvoice.setTaxAmt(json.isNull("taxAmt") ? null : json.getString("taxAmt").isEmpty() ? null : new BigDecimal((json.getString("taxAmt"))));
			modifiedGipiWInvoice.setOtherCharges(json.isNull("otherCharges") ? null : json.getString("otherCharges").isEmpty() ? null : new BigDecimal((json.getString("otherCharges"))));
			modifiedGipiWInvoice.setCardName(json.isNull("cardName") ? null : json.getString("cardName").isEmpty() ? null : json.getString("cardName")); //setRow.getString("cardName")
			modifiedGipiWInvoice.setCardNo(json.isNull("cardNo") ? null : json.getString("cardNo").isEmpty() ? null : json.getInt("cardNo")); //setRow.getInt("cardNo") //change by steven 07.22.2014
			modifiedGipiWInvoice.setExpiryDate(json.isNull("expiryDate") ? null : json.getString("expiryDate").isEmpty() ? null : sdf.parse((json.getString("expiryDate"))));
			modifiedGipiWInvoice.setApprovalCd(json.isNull("approvalCd") ? null : json.getString("approvalCd").isEmpty() ? null : json.getString("approvalCd"));
			modifiedGipiWInvoice.setRiCommAmt(json.isNull("riCommAmt") ? null : new BigDecimal(json.getString("riCommAmt")));
			modifiedGipiWInvoice.setRiCommVat(json.isNull("riCommVat") || json.getString("riCommVat").trim().equals("") ? null : new BigDecimal(json.getString("riCommVat")));
			modifiedGipiWInvoice.setPolicyCurrency(json.isNull("policyCurrency") ? null : json.getString("policyCurrency"));
			setModifiedGipiWInvoice.add(modifiedGipiWInvoice);
		}
		return setModifiedGipiWInvoice;
	}
		
	public List<GIPIWInstallment> prepareAddModifiedInstallment(JSONArray setRows) throws JSONException, ParseException{
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWInstallment installmentInfo = null;
		JSONObject json = null;
		List<GIPIWInstallment> setTaxInfo = new ArrayList<GIPIWInstallment>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			
			installmentInfo = new GIPIWInstallment();						
			installmentInfo.setTakeupSeqNo(json.getInt("takeupSeqNo")); 
			installmentInfo.setItemGrp(json.getInt("itemGrp"));
			installmentInfo.setParId(json.getInt("parId"));
			installmentInfo.setInstNo(json.getInt("instNo"));
			installmentInfo.setPremAmt(json.isNull("sharePct") ? null : json.getString("sharePct").isEmpty() ? null : new BigDecimal((json.getString("sharePct"))));
			installmentInfo.setPremAmt(json.isNull("premAmt") ? null : json.getString("premAmt").isEmpty() ? null : new BigDecimal((json.getString("premAmt"))));
			installmentInfo.setTaxAmt(json.isNull("taxAmt") ? null : json.getString("taxAmt").isEmpty() ? null : new BigDecimal((json.getString("taxAmt"))));
			installmentInfo.setSharePct(json.isNull("sharePct") ? null : json.getString("sharePct").isEmpty() ? null : new BigDecimal((json.getString("sharePct"))));
			installmentInfo.setDueDate(json.isNull("dueDate") ? null : sdf.parse(json.get("dueDate").toString()));
			
			System.out.println("DUE DATE Installment: " +( json.isNull("dueDate") ? null : sdf.parse(json.get("dueDate").toString())) + " percentage: " + json.getString("sharePct"));
			
			setTaxInfo.add(installmentInfo);
		}	
		
		return setTaxInfo;
	}

	@Override
	public Map<String, Object> getTempTakeupListDtls(Map<String, Object> params) throws SQLException {		
		return this.gipiWInvoiceDao.getTempTakeupListDtls(params);
	}

	@Override
	public Map<String, String> isExist2(Integer parId) throws SQLException {
		return this.gipiWInvoiceDao.isExist2(parId);
	}

	@Override
	public Map<String, Object> validateTaxEntry(Map<String, Object> params) throws SQLException {
		return this.getGipiWInvoiceDAO().validateTaxEntry(params);
	}

	@Override
	public List<Map<String, Object>> prepareGIPIWInvoiceForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> invoices = new ArrayList<Map<String, Object>>();
		Map<String, Object> invoiceMap = null;
		JSONObject objInvoice = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			invoiceMap = new HashMap<String, Object>();
			objInvoice = delRows.getJSONObject(i);
			
			invoiceMap.put("parId", objInvoice.isNull("parId") ? null : objInvoice.getInt("parId"));
			invoiceMap.put("itemGrp", objInvoice.isNull("itemGrp") ? null : objInvoice.getInt("itemGrp"));
			
			invoices.add(invoiceMap);
			invoiceMap = null;
		}
		
		return invoices;
	}
	
	public List<Map<String, Object>> prepareWInvoice2(JSONArray setRows) throws JSONException, ParseException{
		List<Map<String, Object>> invoices = new ArrayList<Map<String, Object>>();
		Map<String, Object> invoiceMap = null;
		JSONObject objInvoice = null;
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0, length=setRows.length(); i < length; i++){
			invoiceMap = new HashMap<String, Object>();
			objInvoice = setRows.getJSONObject(i);
			
			invoiceMap.put("parId", objInvoice.isNull("parId") ? null : objInvoice.getInt("parId"));
			invoiceMap.put("itemGrp", objInvoice.isNull("itemGrp") ? null : objInvoice.getInt("itemGrp"));
			invoiceMap.put("takeupSeqNo", objInvoice.isNull("takeupSeqNo") ? null : objInvoice.getInt("takeupSeqNo"));
			invoiceMap.put("paytTerms", objInvoice.isNull("paytTerms") ? null : objInvoice.getString("paytTerms"));
			invoiceMap.put("dueDate", objInvoice.isNull("dueDate") ? null : sdf.parse(objInvoice.get("dueDate").toString()));
			
			invoices.add(invoiceMap);
			Debug.print("allWInvoiceDtls: " + invoices);			
			invoiceMap = null;
		}
		
		return invoices;
	}

	@Override
	public List<GIPIWInvoice> getLeadPolGipiWInvoice(Integer parId)
			throws SQLException {
		List<GIPIWInvoice>  leadWInvoice = this.getGipiWInvoiceDAO().getLeadPolGipiWInvoice(parId);
		for(GIPIWInvoice inv : leadWInvoice){
			inv.setGipiOrigInv((GIPIOrigInvoice) StringFormatter.escapeHTMLInObject(inv.getGipiOrigInv()));
		}
		return leadWInvoice;
	}

	@Override
	public Map<String, Object> getAnnualAmt(Map<String, Object> params) throws SQLException {
		return this.getGipiWInvoiceDAO().getAnnualAmt(params);
	}

	@Override
	public BigDecimal getWInvoiceInputVatRate2(Integer parId)
			throws SQLException {		
		return (BigDecimal) this.gipiWInvoiceDao.getWInvoiceInputVatRate2(parId);
	}

	@Override
	public void gipis026ValidateBookingDate(Map<String, Object> params)
			throws SQLException {
		this.gipiWInvoiceDao.gipis026ValidateBookingDate(params);		
	}

	@Override
	public String validateBondDueDate(Map<String, Object> params)
			throws SQLException {
		return new JSONObject(this.getGipiWInvoiceDAO().validateBondDueDate(params)).toString();
	}
	
	@Override
	public void deleteWDistTables(HttpServletRequest request) throws SQLException {
		Integer parId = 0;
		if(request.getParameter("parId") != null || request.getParameter("parId") != ""){
			parId = Integer.parseInt(request.getParameter("parId"));
		}
		this.getGipiWInvoiceDAO().deleteWDistTables(parId);
	}

	@Override
	public String checkForPostedBinders(HttpServletRequest request) throws SQLException {
		Integer parId = 0;
		if(request.getParameter("parId") != null || request.getParameter("parId") != ""){
			parId = Integer.parseInt(request.getParameter("parId"));
		}
		return this.getGipiWInvoiceDAO().checkForPostedBinders(parId);
	}

	@Override
	public String getRangeAmount(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));
		params.put("parId", request.getParameter("parId"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		params.put("takeupAllocTag", request.getParameter("takeupAllocTag"));
		return this.getGipiWInvoiceDAO().getRangeAmount(params);
	}

	@Override
	public String getRateAmount(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));
		params.put("parId", request.getParameter("parId"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		return this.getGipiWInvoiceDAO().getRateAmount(params);
	}
	
	@Override
	public String getDocStampsTaxAmt (HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));		
		params.put("parId", request.getParameter("parId"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		params.put("takeupAllocTag", request.getParameter("takeupAllocTag"));
		return this.getGipiWInvoiceDAO().getDocStampsTaxAmt(params);
	}	
	
	@Override
	public String getFixedAmountTax (HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));		
		params.put("parId", request.getParameter("parId"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("taxAmount", request.getParameter("tempTaxAmt"));
	    params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		params.put("takeupAllocTag", request.getParameter("takeupAllocTag"));
		return this.getGipiWInvoiceDAO().getFixedAmountTax(params);
	}		
	@Override
	public String getCompTaxAmt (HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("taxCd", request.getParameter("taxCd"));
		params.put("taxId", request.getParameter("taxId"));		
		params.put("parId", request.getParameter("parId"));
	    params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("takeupSeqNo", request.getParameter("takeupSeqNo"));
		return this.getGipiWInvoiceDAO().getCompTaxAmt(params);
	}			

	@Override
	public Map<String, Object> validateBondsTaxEntry(Map<String, Object> params) throws SQLException {
		return this.getGipiWInvoiceDAO().validateBondsTaxEntry(params);
	}

	@Override
	public String recreateInvoice(HttpServletRequest request) throws SQLException {
		Map<String, Object> parameters = new HashMap<String, Object>();
		parameters.put("newParId", request.getParameter("parId"));
		parameters.put("lineCd", request.getParameter("lineCd"));
		parameters.put("issCd", request.getParameter("issCd"));
		return this.getGipiWInvoiceDAO().recreateInvoice(parameters);
	}	
	
}
