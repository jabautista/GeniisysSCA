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
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIWCommInvoiceDAO;
import com.geniisys.gipi.entity.GIPIWCommInvoice;
import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;
import com.geniisys.gipi.service.GIPIWCommInvoiceService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWCommInvoiceServiceImpl.
 */
public class GIPIWCommInvoiceServiceImpl implements GIPIWCommInvoiceService{

	/** The gipi w comm invoice dao. */
	private GIPIWCommInvoiceDAO gipiWCommInvoiceDAO;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParItemFacadeServiceImpl.class);
	
	/**
	 * Sets the gipi w comm invoice dao.
	 * 
	 * @param gipiWCommInvoiceDAO the new gipi w comm invoice dao
	 */
	public void setGipiWCommInvoiceDAO(GIPIWCommInvoiceDAO gipiWCommInvoiceDAO) {
		this.gipiWCommInvoiceDAO = gipiWCommInvoiceDAO;
	}
	
	/**
	 * Gets the gipi w comm invoice dao.
	 * 
	 * @return the gipi w comm invoice dao
	 */
	public GIPIWCommInvoiceDAO getGipiWCommInvoiceDAO() {
		return gipiWCommInvoiceDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getWCommInvoice(int, int)
	 */
	@Override
	public List<GIPIWCommInvoice> getWCommInvoice(int parId, int itemGroup)
			throws SQLException {
		
		log.info("Retrieving Commission Invoices...");
		List<GIPIWCommInvoice> wcommInvoice = this.getGipiWCommInvoiceDAO().getWCommInvoice(parId, itemGroup);
		log.info(wcommInvoice.size() + " Commission Invoice(s) retrieved.");
		
		return wcommInvoice;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getWCommInvoice(int)
	 */
	@Override
	public List<GIPIWCommInvoice> getWCommInvoice(int parId)
			throws SQLException {
		List<GIPIWCommInvoice> wcommInvoice = this.getGipiWCommInvoiceDAO().getWCommInvoice(parId);		
		return wcommInvoice;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#saveWCommInvoice(int, java.math.BigDecimal, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public boolean saveWCommInvoice(List<GIPIWCommInvoice> commInvoices) throws SQLException {		
		log.info("Saving Commission Invoice...");
		this.getGipiWCommInvoiceDAO().saveWCommInvoice(commInvoices);
		log.info("Commission Invoice successfully saved.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#deleteWCommInvoice(int, int)
	 */
	@Override
	public boolean deleteWCommInvoice(int parId, int itemGroup)
			throws SQLException {		
		log.info("Deleting Commission Invoice...");
		this.getGipiWCommInvoiceDAO().deleteWCommInvoice(parId, itemGroup);
		log.info("Commission Invoice successfully deleted.");
		
		return true;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#deleteWCommInvoice2(java.util.List)
	 */
	@Override
	public boolean deleteWCommInvoice2(List<GIPIWCommInvoice> commInvoices)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().deleteWCommInvoice2(commInvoices);		
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#checkPerilCommRate(java.util.Map)
	 */
	@Override
	public String checkPerilCommRate(Map<String, Object> params)
			throws SQLException {
		
		return this.getGipiWCommInvoiceDAO().checkPerilCommRate(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getAccountingParameter(java.lang.String)
	 */
	@Override
	public String getAccountingParameter(String paramName) throws SQLException {		
		return this.getGipiWCommInvoiceDAO().getAccountingParameter(paramName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getApplyBtnMap(int, int, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public Map<String, Object> getApplyBtnMap(int parId, int itemGrp,
			int intmNo, int intmNoNbt, int takeupSeqNo,
			BigDecimal sharePercentage, BigDecimal sharePercentageNbt,
			BigDecimal prevSharePercentage, String lineCd, String issCd,
			String intmTypeNbt, String recordStatus, String perilCd,
			BigDecimal commissionAmt, BigDecimal commissionAmtNbt,
			BigDecimal premiumAmt, BigDecimal commissionRate,
			BigDecimal wholdingTax) throws SQLException {

		return this.getGipiWCommInvoiceDAO().getApplyBtnMap(parId, itemGrp, intmNo, intmNoNbt, takeupSeqNo, sharePercentage, sharePercentageNbt, prevSharePercentage, lineCd, issCd, intmTypeNbt, recordStatus, perilCd, commissionAmt, commissionAmtNbt, premiumAmt, commissionRate, wholdingTax);
	}

	/*
	 @Override
	public Map<String, Object> populateWcommInvPerils(int parId, int itemGrp,
			int takeupSeqNo, String lineCd, int intmNo, String nbtIntmType,
			String nbtRetOrig, String perilCd, String nbtPerilCd,
			BigDecimal sharePercentage, BigDecimal prevSharePercentage,
			BigDecimal premiumAmt, BigDecimal commissionRate,
			BigDecimal commissionAmt, BigDecimal nbtCommissionAmt,
			BigDecimal wholdingTax, String issCd, BigDecimal varRate) throws SQLException {

		return this.getGipiWCommInvoiceDAO().populateWcommInvPerils(parId, itemGrp, takeupSeqNo, lineCd, intmNo, nbtIntmType, nbtRetOrig, perilCd, nbtPerilCd, sharePercentage, prevSharePercentage, premiumAmt, commissionRate, commissionAmt, nbtCommissionAmt, wholdingTax, issCd, varRate);
	}*/
	
	@Override
	public void populateWcommInvPerils(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().populateWcommInvPerils(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#validateIntmNo(int, int, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> validateIntmNo(int parId, int intmNo,
			String lineCd, String lovTag, String globalCancelTag) throws SQLException {
		return this.getGipiWCommInvoiceDAO().validateIntmNo(parId, intmNo, lineCd, lovTag, globalCancelTag);
	}

	@Override
	public Map<String, Object> getParTypeAndEndtTax(int parId)
			throws SQLException {
		return this.getGipiWCommInvoiceDAO().getParTypeAndEndtTax(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#executeGipis085WhenNewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGipis085WhenNewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().executeGipis085WhenNewFormInstance(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#executeBancassuranceGetDefaultTaxRt(java.util.Map)
	 */
	@Override
	public void executeBancassuranceGetDefaultTaxRt(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().executeBancassuranceGetDefaultTaxRt(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#executeBancassuranceProcessCommission(java.util.Map)
	 */
	@Override
	public void executeBancassuranceProcessCommission(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().executeBancassuranceProcessCommission(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#validateGipis085IntmNo(java.util.Map)
	 */
	@Override
	public void validateGipis085IntmNo(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().validateGipis085IntmNo(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#populateWcommInvPerils2(java.util.Map)
	 */
	@Override
	public void populateWcommInvPerils2(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().populateWcommInvPerils2(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getIntmdryRate(java.util.Map)
	 */
	@Override
	public void getIntmdryRate(Map<String, Object> params) throws SQLException {
		this.getGipiWCommInvoiceDAO().getIntmdryRate(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getAdjustIntmdryRate(java.util.Map)
	 */
	@Override
	public BigDecimal getAdjustIntmdryRate(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWCommInvoiceDAO().getAdjustIntmdryRate(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#populatePackagePerils(java.util.Map)
	 */
	@Override
	public void populatePackagePerils(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().populatePackagePerils(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getPackageIntmRate(java.util.Map)
	 */
	@Override
	public BigDecimal getPackageIntmRate(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWCommInvoiceDAO().getPackageIntmRate(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#saveGipiWcommInvoice(java.lang.String)
	 */
	@Override
	public void saveGipiWcommInvoice(String strParameters) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(strParameters);
		List<GIPIWCommInvoice> setWcommInvoiceList = this.prepareGipiWcommInvoiceForInsert(new JSONArray(objParameters.getString("setWcominvRows")));
		List<GIPIWCommInvoice> delWcommInvoiceList = this.prepareGipiWcommInvoiceForDelete(new JSONArray(objParameters.getString("delWcominvRows")));
		List<GIPIWCommInvoicePeril> setWcommInvoicePerilList = this.prepareGipiWcommInvoicePerilForInsert(new JSONArray(objParameters.getString("setWcominvperRows")));
		List<GIPIWCommInvoicePeril> delWcommInvoicePerilList = this.prepareGipiWcommInvoicePerilForDelete(new JSONArray(objParameters.getString("delWcominvperRows")));
		String parId = objParameters.get("parId").toString();
		
		String coinsurerSw = "";
		
		if(objParameters.has("coinsurerSw"))
			coinsurerSw = objParameters.get("coinsurerSw").toString();
		
		this.getGipiWCommInvoiceDAO().saveGipiWcommInvoice(setWcommInvoiceList, delWcommInvoiceList, setWcommInvoicePerilList, delWcommInvoicePerilList, parId, coinsurerSw);
	}
	
	/**
	 * 
	 * @param setWcominvRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWCommInvoice> prepareGipiWcommInvoiceForInsert(JSONArray setWcominvRows)
		throws JSONException, ParseException {
		List<GIPIWCommInvoice> wcommInvoiceList = new ArrayList<GIPIWCommInvoice>();
		GIPIWCommInvoice wcommInvoice;
		
		for (int i = 0; i < setWcominvRows.length(); i++) {
			wcommInvoice = new GIPIWCommInvoice();
			
			wcommInvoice.setParId(setWcominvRows.getJSONObject(i).isNull("parId") ? null : setWcominvRows.getJSONObject(i).getInt("parId"));
			wcommInvoice.setIntermediaryNo(setWcominvRows.getJSONObject(i).isNull("intermediaryNo") ? null : setWcominvRows.getJSONObject(i).getInt("intermediaryNo"));
			wcommInvoice.setItemGroup(setWcominvRows.getJSONObject(i).isNull("itemGroup") ? null : setWcominvRows.getJSONObject(i).getInt("itemGroup"));
			wcommInvoice.setTakeupSeqNo(setWcominvRows.getJSONObject(i).isNull("takeupSeqNo") ? null : setWcominvRows.getJSONObject(i).getInt("takeupSeqNo"));
			wcommInvoice.setSharePercentage(setWcominvRows.getJSONObject(i).isNull("sharePercentage") ? null : ("".equals(setWcominvRows.getJSONObject(i).getString("sharePercentage").trim())) ? null : new BigDecimal(setWcominvRows.getJSONObject(i).getString("sharePercentage")));
			wcommInvoice.setCommissionAmount(setWcominvRows.getJSONObject(i).isNull("commissionAmount") ? null : ("".equals(setWcominvRows.getJSONObject(i).getString("commissionAmount").trim())) ? null : new BigDecimal(setWcominvRows.getJSONObject(i).getString("commissionAmount")));
			wcommInvoice.setPremiumAmount(setWcominvRows.getJSONObject(i).isNull("premiumAmount") ? null : ("".equals(setWcominvRows.getJSONObject(i).getString("premiumAmount").trim())) ? null : new BigDecimal(setWcominvRows.getJSONObject(i).getString("premiumAmount")));
			wcommInvoice.setWithholdingTax(setWcominvRows.getJSONObject(i).isNull("withholdingTax") ? null : ("".equals(setWcominvRows.getJSONObject(i).getString("withholdingTax").trim())) ? null : new BigDecimal(setWcominvRows.getJSONObject(i).getString("withholdingTax")));
			wcommInvoice.setParentIntermediaryNo(setWcominvRows.getJSONObject(i).isNull("parentIntermediaryNo") ? null : setWcominvRows.getJSONObject(i).getInt("parentIntermediaryNo"));
			wcommInvoice.setParentIntmLicTag(setWcominvRows.getJSONObject(i).isNull("parentIntmLicTag") ? null : setWcominvRows.getJSONObject(i).getString("parentIntmLicTag"));
			wcommInvoice.setParentIntmSpecialRate(setWcominvRows.getJSONObject(i).isNull("parentIntmSpecialRate") ? null : setWcominvRows.getJSONObject(i).getString("parentIntmSpecialRate"));
			wcommInvoice.setLicTag(setWcominvRows.getJSONObject(i).isNull("licTag") ? null : setWcominvRows.getJSONObject(i).getString("licTag")); /*added by christian 08.25.2012*/
			wcommInvoice.setSpecialRate(setWcominvRows.getJSONObject(i).isNull("specialRate") ? null : setWcominvRows.getJSONObject(i).getString("specialRate")); /*added by christian 08.25.2012*/
			System.out.println("Test Lic Tag - "+wcommInvoice.getLicTag()+" / "+wcommInvoice.getSpecialRate());
			wcommInvoiceList.add(wcommInvoice);
		}
		System.out.println("wcommInvoiceList length - "+wcommInvoiceList.size());
		return wcommInvoiceList;
	}
	
	/**
	 * 
	 * @param delWcominvRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWCommInvoice> prepareGipiWcommInvoiceForDelete(JSONArray delWcominvRows)
		throws JSONException, ParseException {
		List<GIPIWCommInvoice> wcommInvoiceList = new ArrayList<GIPIWCommInvoice>();
		GIPIWCommInvoice wcommInvoice;
		System.out.println(delWcominvRows);
		System.out.println("delWcominvRows size:"+delWcominvRows.length());
		for (int i = 0; i < delWcominvRows.length(); i++) {
			wcommInvoice = new GIPIWCommInvoice();
			
			wcommInvoice.setParId(delWcominvRows.getJSONObject(i).isNull("parId") ? null : delWcominvRows.getJSONObject(i).getInt("parId"));
			wcommInvoice.setIntermediaryNo(delWcominvRows.getJSONObject(i).isNull("intermediaryNo") ? null : delWcominvRows.getJSONObject(i).getInt("intermediaryNo"));
			wcommInvoice.setItemGroup(delWcominvRows.getJSONObject(i).isNull("itemGroup") ? null : delWcominvRows.getJSONObject(i).getInt("itemGroup"));
			wcommInvoice.setTakeupSeqNo(delWcominvRows.getJSONObject(i).isNull("takeupSeqNo") ? null : delWcominvRows.getJSONObject(i).getInt("takeupSeqNo"));
			
			wcommInvoiceList.add(wcommInvoice);
		}
		
		return wcommInvoiceList;
	}
	
	/**
	 * 
	 * @param setWcominvperRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWCommInvoicePeril> prepareGipiWcommInvoicePerilForInsert(JSONArray setWcominvperRows)
		throws JSONException, ParseException {
		List<GIPIWCommInvoicePeril> wcommInvoicePerilList = new ArrayList<GIPIWCommInvoicePeril>();
		GIPIWCommInvoicePeril wcommInvoicePeril;
		
		for (int i = 0; i < setWcominvperRows.length(); i++) {
			wcommInvoicePeril = new GIPIWCommInvoicePeril();
			
			wcommInvoicePeril.setParId(setWcominvperRows.getJSONObject(i).isNull("parId") ? null : setWcominvperRows.getJSONObject(i).getInt("parId"));
			wcommInvoicePeril.setIntermediaryIntmNo(setWcominvperRows.getJSONObject(i).isNull("intermediaryIntmNo") ? null : setWcominvperRows.getJSONObject(i).getInt("intermediaryIntmNo"));
			wcommInvoicePeril.setItemGroup(setWcominvperRows.getJSONObject(i).isNull("itemGroup") ? null : setWcominvperRows.getJSONObject(i).getInt("itemGroup"));
			wcommInvoicePeril.setTakeupSeqNo(setWcominvperRows.getJSONObject(i).isNull("takeupSeqNo") ? null : setWcominvperRows.getJSONObject(i).getInt("takeupSeqNo"));
			wcommInvoicePeril.setPerilCd(setWcominvperRows.getJSONObject(i).isNull("perilCd") ? null : setWcominvperRows.getJSONObject(i).getInt("perilCd"));
			wcommInvoicePeril.setCommissionRate(setWcominvperRows.getJSONObject(i).isNull("commissionRate") ? null : ("".equals(setWcominvperRows.getJSONObject(i).getString("commissionRate").trim())) ? null : new BigDecimal(setWcominvperRows.getJSONObject(i).getString("commissionRate")));
			wcommInvoicePeril.setCommissionAmount(setWcominvperRows.getJSONObject(i).isNull("commissionAmount") ? null : ("".equals(setWcominvperRows.getJSONObject(i).getString("commissionAmount").trim())) ? null : new BigDecimal(setWcominvperRows.getJSONObject(i).getString("commissionAmount")));
			wcommInvoicePeril.setPremiumAmount(setWcominvperRows.getJSONObject(i).isNull("premiumAmount") ? null : ("".equals(setWcominvperRows.getJSONObject(i).getString("premiumAmount").trim())) ? null : new BigDecimal(setWcominvperRows.getJSONObject(i).getString("premiumAmount")));
			wcommInvoicePeril.setWithholdingTax(setWcominvperRows.getJSONObject(i).isNull("withholdingTax") ? null : ("".equals(setWcominvperRows.getJSONObject(i).getString("withholdingTax").trim())) ? null : new BigDecimal(setWcominvperRows.getJSONObject(i).getString("withholdingTax")));
			
			wcommInvoicePerilList.add(wcommInvoicePeril);
		}
		
		return wcommInvoicePerilList;
	}
	
	/**
	 * 
	 * @param delWcominvperRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<GIPIWCommInvoicePeril> prepareGipiWcommInvoicePerilForDelete(JSONArray delWcominvperRows)
		throws JSONException, ParseException {
		List<GIPIWCommInvoicePeril> wcommInvoicePerilList = new ArrayList<GIPIWCommInvoicePeril>();
		GIPIWCommInvoicePeril wcommInvoicePeril;
		
		for (int i = 0; i < delWcominvperRows.length(); i++) {
			wcommInvoicePeril = new GIPIWCommInvoicePeril();
			
			wcommInvoicePeril.setParId(delWcominvperRows.getJSONObject(i).isNull("parId") ? null : delWcominvperRows.getJSONObject(i).getInt("parId"));
			wcommInvoicePeril.setIntermediaryIntmNo(delWcominvperRows.getJSONObject(i).isNull("intermediaryIntmNo") ? null : delWcominvperRows.getJSONObject(i).getInt("intermediaryIntmNo"));
			wcommInvoicePeril.setItemGroup(delWcominvperRows.getJSONObject(i).isNull("itemGroup") ? null : delWcominvperRows.getJSONObject(i).getInt("itemGroup"));
			wcommInvoicePeril.setTakeupSeqNo(delWcominvperRows.getJSONObject(i).isNull("takeupSeqNo") ? null : delWcominvperRows.getJSONObject(i).getInt("takeupSeqNo"));
			wcommInvoicePeril.setPerilCd(delWcominvperRows.getJSONObject(i).isNull("perilCd") ? null : delWcominvperRows.getJSONObject(i).getInt("perilCd"));
			
			wcommInvoicePerilList.add(wcommInvoicePeril);
		}
		
		return wcommInvoicePerilList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#prepareGIPIWCommInvoicesForDelete(org.json.JSONArray)
	 */
	@Override
	public List<Map<String, Object>> prepareGIPIWCommInvoicesForDelete(
			JSONArray delRows) throws JSONException {
		List<Map<String, Object>> wcommInvoices = new ArrayList<Map<String, Object>>();
		Map<String, Object> wcommInvoiceMap = null;
		JSONObject objWCommInvoice = null;
		
		for(int i=0, length=delRows.length(); i < length; i++){
			wcommInvoiceMap = new HashMap<String, Object>();
			objWCommInvoice = delRows.getJSONObject(i);
			
			wcommInvoiceMap.put("parId", objWCommInvoice.isNull("parId") ? null : objWCommInvoice.getInt("parId"));
			wcommInvoiceMap.put("itemGrp", objWCommInvoice.isNull("itemGrp") ? null : objWCommInvoice.getInt("itemGrp"));
			wcommInvoiceMap.put("takeupSeqNo", objWCommInvoice.isNull("takeupSeqNo") ? null : objWCommInvoice.get("takeupSeqNo"));
			wcommInvoiceMap.put("intrmdryIntmNo", objWCommInvoice.isNull("intrmdryIntmNo") ? null : objWCommInvoice.getInt("intrmdryIntmNo"));
			
			wcommInvoices.add(wcommInvoiceMap);
			wcommInvoiceMap = null;
		}		
		
		return wcommInvoices;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getPackParlistParams(java.lang.Integer)
	 */
	@Override
	public List<Map<String, Object>> getPackParlistParams(Integer packParId)
			throws SQLException {
		return this.getGipiWCommInvoiceDAO().getPackParlistParams(packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#prepareWtRateRecordGroupMap(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> prepareWtRateRecordGroupMap(
			HashMap<String, Object> params) throws SQLException, JSONException, ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		JSONObject objParams = new JSONObject((String) params.remove("parameters"));
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		//params.put("filter", this.prepareWtRateListingFilter((String) params.get("filter")));
		//System.out.println("Emman wtRateList: " + objParams.getString("wtRateList"));
		List<Map<String, Object>> list = this.prepareWtRateRows(new JSONArray(objParams.getString("wtRateList")));
		//System.out.println("Emman list size: " + list.size());
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.escapeHTMLInList(list)));
		//System.out.println("Emman params: " + params.toString());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param rows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	private List<Map<String, Object>> prepareWtRateRows(JSONArray rows) throws JSONException, ParseException {
		List<Map<String, Object>> wtRateList = new ArrayList<Map<String, Object>>();
		Map<String, Object> wtRate = null;
		JSONObject objWtRate = null;
		
		for(int i=0, length=rows.length(); i < length; i++){
			wtRate = new HashMap<String, Object>();
			objWtRate = rows.getJSONObject(i);
			
			wtRate.put("rec", objWtRate.isNull("rec") ? null : objWtRate.getInt("rec"));
			wtRate.put("wtr", objWtRate.isNull("wtr") ? null : objWtRate.getLong("wtr"));
			wtRate.put("pol", objWtRate.isNull("pol") ? null : StringEscapeUtils.unescapeHtml(objWtRate.getString("pol")));
			wtRate.put("rowNum", i + 1);
			wtRate.put("rowCount", rows.length());
			
			wtRateList.add(wtRate);
			wtRate = null;
		}
		
		return wtRateList;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	@SuppressWarnings("unused")
	private HashMap<String, Object> prepareWtRateListingFilter(String filter) throws JSONException{
		HashMap<String, Object> wtRateList = new HashMap<String, Object>();
		JSONObject jsonFilter = null;
		
		if(null == filter){
			jsonFilter = new JSONObject();
		}else{
			jsonFilter = new JSONObject(filter);
		}
		
		wtRateList.put("wtr", jsonFilter.isNull("wtr") ? null : jsonFilter.getLong("wtr"));
		wtRateList.put("pol", jsonFilter.isNull("pol") ? "" : jsonFilter.getString("pol"));
		wtRateList.put("rec", jsonFilter.isNull("rec") ? null : jsonFilter.getInt("rec"));
		
		return wtRateList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#executeGIPIS160WhenNewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGIPIS160WhenNewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().executeGIPIS160WhenNewFormInstance(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#getWCommInvoiceTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getWCommInvoiceTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> wcominvList = this.getGipiWCommInvoiceDAO().getWCommInvoiceTableGrid(params);
		
		//params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(wcominvList)));
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.escapeHTMLInListOfMap(wcominvList))); //belle 08.01.2012
		grid.setNoOfPages(wcominvList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWCommInvoiceService#applySlidingCommission(java.util.Map)
	 */
	@Override
	public void applySlidingCommission(Map<String, Object> params)
			throws SQLException {
		this.getGipiWCommInvoiceDAO().applySlidingCommission(params);
		
	}

	@Override
	public List<Integer> getCommInvDfltIntms(Map<String, Object> params)
			throws SQLException {
		return gipiWCommInvoiceDAO.getCommInvDfltIntms(params);
	}
}
