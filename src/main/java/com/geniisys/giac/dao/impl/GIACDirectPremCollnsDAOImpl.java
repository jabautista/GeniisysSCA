/**
 * 
\ * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giac.dao.GIACDirectPremCollnsDAO;
import com.geniisys.giac.entity.GIACDirectPremCollns;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIACDirectPremCollnsDAOImpl.
 */
public class GIACDirectPremCollnsDAOImpl implements GIACDirectPremCollnsDAO{
	
	@SuppressWarnings("unused")
	private static String message = "SUCCESS";
	private Logger log = Logger.getLogger(GIACDirectPremCollnsDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#validateBillNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateBillNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.queryForObject("validateBillNo", params);
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#validateOpenPolicy(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateOpenPolicy(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateOpenPolicy", params);
		return params; 
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#getInvoiceListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInvoiceListing(Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving invoice listing...");
		List<Map<String, Object>> invoiceListing = this.sqlMapClient.queryForList("getInvoiceListing", params);
		log.info("DAO - Invoice listing retrieved");
		return invoiceListing;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInvoiceListingForPartial(Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving invoice listing for Partial...");
		List<Map<String, Object>> invoiceListing = this.sqlMapClient.queryForList("getInvoiceListingForPartial", params);
		log.info("DAO - Invoice listing retrieved");
		return invoiceListing;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#getDefaultTaxValueType(java.util.Map, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getDefaultTaxValueType(Map<String, Object> params, Integer taxType) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction(); //added by alfie 11.26.2010
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if (taxType == 1){
				this.sqlMapClient.queryForObject("getDefaultTaxValueType1", params);
			}else if (taxType == 2){
				//this.sqlMapClient.queryForObject("getDefaultTaxValueType2", params); replaced by: Nica 06.22.2012
				this.sqlMapClient.queryForObject("reverseTranType1Or3", params); // as GEN-2012-202_GIACS007_V01_04192012
			}else if (taxType == 3){
				this.sqlMapClient.queryForObject("getDefaultTaxValueType3", params);
			}else if (taxType == 4){
				//this.sqlMapClient.queryForObject("getDefaultTaxValueType4", params);
				this.sqlMapClient.queryForObject("reverseTranType1Or3", params); // as GEN-2012-202_GIACS007_V01_04192012
			}
			this.getSqlMapClient().executeBatch();
			if ("Y".equals(params.get("commitTag"))){ //benjo 11.03.2015 GENQA-SR-5015
				this.getSqlMapClient().getCurrentConnection().commit(); //robert 09.07.2012
			}
			//this.getSqlMapClient().getCurrentConnection().rollback();  //added by alfie 11.26.2010
			
		} catch(SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
				
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#saveDirectPremCollnsDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String saveDirectPremCollnsDtls(Map<String, Object> allParams) throws SQLException {
		List<GIACDirectPremCollns> giacDirectPremCollns = (List<GIACDirectPremCollns>) allParams.get("giacDirectPremCollns");
		List<GIACDirectPremCollns> listToDelete = (List<GIACDirectPremCollns>) allParams.get("listToDelete");
		List<Map<String, Object>> chkAdvPaytParamsList = (List<Map<String, Object>>) allParams.get("chkAdvPaytParamsList");
		List<Map<String, Object>> taxDefaultParams = (List<Map<String, Object>>) allParams.get("taxDefaultParams");
		List<Map<String, Object>> taxCollnsListToDelete = (List<Map<String, Object>>) allParams.get("taxCollnsListToDelete");
		Map<String, Object> aegParams = (Map<String, Object>)allParams.get("aegParams");
	
		List<GIACDirectPremCollns> giacDirectPremCollnsAll =  (List<GIACDirectPremCollns>) allParams.get("giacDirectPremCollnsAll");
		Map<String, Object> genAcctEntrYParams = (Map<String, Object>) allParams.get("genAcctEntrYParams");
		Map<String, Object> genAcctEntrNParams = (Map<String, Object>) allParams.get("genAcctEntrNParams");
		Map<String, Object> genOpTextParams = (Map<String, Object>) allParams.get("genOpTextParams");
		Integer gaccTranId = Integer.parseInt(allParams.get("gaccTranId").toString());
		List<Map<String, Object>> updateGiacOrderOfPaymtsParam = (List<Map<String, Object>>) allParams.get("updateGiacOrderOfPaymtsParam");
		String appUser = allParams.get("appUser").toString();
		String fundCd = genAcctEntrYParams.get("fundCd").toString();
		System.out.println("FUND CD:::::::::::::::::::"+fundCd);
		
		//Map<String, Object> giacParams = (Map<String, Object>) allParams.get("giacParams");
		String msgAlert = "";
		try{
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//if (giacDirectPremCollns.size() > 0){
			//this.saveGiacDirectPremCollns(giacDirectPremCollns, appUser);
			//}
			
			if (listToDelete.size() > 0){
				this.deleteDirectPremCollnList(listToDelete, appUser);
				this.deleteAdvancePayment(listToDelete, appUser); // added by: Nica 08.14.2012 - delete the records from giac_advanced_payt table
				//this.deleteTaxCollnsAssociated(taxCollnsListToDelete, appUser);
			}
			this.getSqlMapClient().executeBatch();
			
			this.saveGiacDirectPremCollns(giacDirectPremCollns, appUser);
			this.getSqlMapClient().executeBatch();
			//Debug.print("TAX DEFAULT PARAMS: " + taxDefaultParams);
			//this.generateTaxDefaults(taxDefaultParams, appUser);
			
			this.checkAdvancePayment(chkAdvPaytParamsList, appUser); // added by: Nica 08.04.2012 - to insert record in giac_advanced_payt table if inc_tag = 'Y'
			this.getSqlMapClient().executeBatch();
			
			this.aegDeleteAcctEntriesY(aegParams);
			this.deleteTaxCollnsAssociated(taxCollnsListToDelete, appUser);
			this.getSqlMapClient().executeBatch();
			Debug.print("TAX DEFAULT PARAMS: " + taxDefaultParams);
			this.generateTaxDefaults(taxDefaultParams, appUser);
			this.getSqlMapClient().executeBatch();
			
			this.genAcctEntrY(genAcctEntrYParams, appUser);
			this.getSqlMapClient().executeBatch();
			
			this.genAcctEntrN(genAcctEntrNParams, giacDirectPremCollnsAll, appUser);
			this.getSqlMapClient().executeBatch();
			
			if(allParams.get("tranSource") != null && allParams.get("tranSource").equals("OR")) { // andrew - added condition when to invoke checkOrFlag method - 4.29.2013
				this.checkOrFlag(gaccTranId);
				this.getSqlMapClient().executeBatch();
			}
			
			this.updateGiacOrderOfPaymts(updateGiacOrderOfPaymtsParam);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> deleteOpText = new HashMap<String, Object>();
			deleteOpText.put("gaccTranId", gaccTranId);
			deleteOpText.put("moduleName", "GIACS007");
			this.getSqlMapClient().delete("deleteGIACOpText4", deleteOpText);
			this.getSqlMapClient().executeBatch();
			
			//this.genOpText(genOpTextParams, giacDirectPremCollnsAll, listToDelete, appUser, giacDirectPremCollns);
			this.genOpTextGIACS007(genOpTextParams, appUser); // added by: Robert 04.08.2013 - modified procedure of genOpText for sr 12709
			this.getSqlMapClient().executeBatch();
			
			this.sqlMapClient.update("updateOpTextGiacs007", deleteOpText);
			this.getSqlMapClient().executeBatch();
			
			/*this.updateGiacOrderOfPaymts(updateGiacOrderOfPaymtsParam);
			this.getSqlMapClient().executeBatch();*/
			
			this.getSqlMapClient().delete("deleteGIACTaxCollns2", gaccTranId);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		//this.sqlMapClient.insert("saveDirectPremCollnsDtls", allParams);		
		return msgAlert;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#saveDirectPremCollnsAcctDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveDirectPremCollnsAcctDtls(Map<String, Object> allParams) throws SQLException {

		List<GIACDirectPremCollns> giacDirectPremCollnsAll =  (List<GIACDirectPremCollns>) allParams.get("giacDirectPremCollnsAll");
		Map<String, Object> genAcctEntrYParams = (Map<String, Object>) allParams.get("genAcctEntrYParams");
		Map<String, Object> genAcctEntrNParams = (Map<String, Object>) allParams.get("genAcctEntrNParams");
		@SuppressWarnings("unused")
		Map<String, Object> genOpTextParams = (Map<String, Object>) allParams.get("genOpTextParams");
		Integer gaccTranId = Integer.parseInt(allParams.get("gaccTranId").toString());
		List<Map<String, Object>> updateGiacOrderOfPaymtsParam = (List<Map<String, Object>>) allParams.get("updateGiacOrderOfPaymtsParam");
		String appUser = allParams.get("appUser").toString();
		try{	
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.genAcctEntrY(genAcctEntrYParams, appUser);
			this.genAcctEntrN(genAcctEntrNParams, giacDirectPremCollnsAll, appUser);
			this.checkOrFlag(gaccTranId);
			//this.genOpText(genOpTextParams, giacDirectPremCollnsAll, appUser);
			this.updateGiacOrderOfPaymts(updateGiacOrderOfPaymtsParam);  //post forms commit for giacs007 are all here
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//errMsg = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//errMsg = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 
	 * @param giacDirectPremCollns
	 * @return
	 * @throws SQLException
	 */
	public boolean saveGiacDirectPremCollns(List<GIACDirectPremCollns> giacDirectPremCollns, String appUser) throws SQLException{
		log.info("Saving GiacDirectPremCollns Details...");
		boolean result = false;
		for(GIACDirectPremCollns giacDirectPremColln: giacDirectPremCollns){
			System.out.println("inserting " + giacDirectPremColln.toString() + " record");
			giacDirectPremColln.setAppUser(appUser);
			this.getSqlMapClient().insert("saveDirectPremCollnsDtls", giacDirectPremColln);
			
			if(giacDirectPremColln.getTaxAmt().equals(new BigDecimal(0))){ //marco - 01.29.2015
				Map<String, Object> taxParams = new HashMap<String, Object>();
				taxParams.put("gaccTranId", giacDirectPremColln.getGaccTranId());
				taxParams.put("b160IssCd", giacDirectPremColln.getIssCd());
				taxParams.put("b160PremSeqNo", giacDirectPremColln.getPremSeqNo());
				taxParams.put("instNo", giacDirectPremColln.getInstNo());
				this.getSqlMapClient().delete("deleteGIACTaxCollnsRecs", taxParams);
			}
			
			this.getSqlMapClient().update("checkTotalPayments", giacDirectPremColln);
		}	
		result = true;
		log.info("Saving Result: "+ result);
		return result;
	}

	/**
	 * 
	 * @param listToDelete
	 * @return
	 * @throws SQLException
	 */
	public boolean deleteDirectPremCollnList(List<GIACDirectPremCollns> listToDelete, String appUser) throws SQLException{
		boolean result = false;
		System.out.println("Deleting...");
		for(GIACDirectPremCollns giacDirectPremColln: listToDelete){
			Debug.print("DELETE: " + giacDirectPremColln);
			giacDirectPremColln.setAppUser(appUser);
			this.getSqlMapClient().delete("delPremCollnsDtls", giacDirectPremColln);	
		}	
		System.out.println("Delete success.");
		result = true;
		return result;
	}

	/**
	 * 
	 * @param params
	 * @throws SQLException
	 */
	private void deleteTaxCollnsAssociated(List<Map<String, Object>> params, String appUser) throws SQLException {
		
		log.info("Deleting tax collections..");
		int numberOfDeleted = 0;
		
		for (Map<String, Object> p: params) {
			 log.info("Deleting " + p.toString());
			 p.put("appUser", appUser);
			 numberOfDeleted = this.getSqlMapClient().delete("deleteGIACTaxCollnsRecs",p);
			 
			 log.info("Number of delete tax collections record: " + numberOfDeleted);
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectPremCollnsDAO#getDirectPremCollnsDtls(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDirectPremCollnsDtls(Integer gaccTranId) throws SQLException {
		List<Map<String, Object>> getDirectPremCollnsDtls = this.getSqlMapClient().queryForList("getDirectPremCollnsDtls", gaccTranId);
		return getDirectPremCollnsDtls;
	}
	
	/**
	 * 
	 * @param taxDefaultParams
	 * @return
	 * @throws SQLException
	 */
	public boolean generateTaxDefaults(List<Map<String, Object>> taxDefaultParams, String appUser) throws SQLException{
		boolean result = false;
		System.out.println("generateTaxDefaults Size: " + taxDefaultParams.size());
		for (int i=0; i<taxDefaultParams.size(); i++) {
			Map<String, Object> params = taxDefaultParams.get(i);
			BigDecimal taxAmt = (BigDecimal) params.get("sumTaxTotal");
			//System.out.println("Check tax amt - "+taxAmt+" /// "+(taxAmt.compareTo(new BigDecimal("0")))+" /// "+new BigDecimal("0"));
			System.out.println("RECORDSTATUS-" + Integer.parseInt(params.get("recordStatus").toString())+": "+params);
			if (Integer.parseInt(params.get("recordStatus").toString()) != -1 && taxAmt.compareTo(new BigDecimal("0")) != 0) {
				System.out.println("inserting " + i + " tax record: "+params);
				params.put("appUser", appUser);
				this.getSqlMapClient().insert("generateTaxDefaults", params);
			}
		}
		result = true;
		return result;
	}
	
	public String aegDeleteAcctEntriesY(Map<String, Object> params) throws SQLException {
		System.out.println("Params before: " + params);
		this.getSqlMapClient().queryForObject("aegDeleteAcctEntriesY", params);
		System.out.println("Params after: " + params);
		return params.get("msgAlert") == null ? null : params.get("msgAlert").toString();
	}
	
	public String genAcctEntrY(Map<String, Object> params, String appUser) throws SQLException {
		params.put("appUser", appUser);
		Debug.print("genAcctEntrY before: " + params);
		this.getSqlMapClient().queryForObject("genAcctEntrY", params);
		Debug.print("genAcctEntrY after: " + params);
		return params.get("msgAlert") == null ? null : params.get("msgAlert").toString();
	}
	
	public String genAcctEntrN(Map<String, Object> params, List<GIACDirectPremCollns> listParams, String appUser) throws SQLException {
		Debug.print("genAcctEntrN before: " + params);
		for (int i=0; i < listParams.size(); i++) {
			params.put("issCd", listParams.get(i).getIssCd());
			params.put("premSeqNo", listParams.get(i).getPremSeqNo());
			params.put("tranType", listParams.get(i).getTranType());
			params.put("appUser", appUser);
			this.getSqlMapClient().queryForObject("genAcctEntrN", params);
		}
		Debug.print("genAcctEntrN after: " + params);
		return params.get("msgAlert") == null ? null : params.get("msgAlert").toString();
	}
	
	public String genOpText(Map<String, Object> params, List<GIACDirectPremCollns> listParams, List<GIACDirectPremCollns> listToDelete, String appUser, List<GIACDirectPremCollns> giacDirectPremCollns) throws SQLException {
		System.out.println("\n genOpText before: " + params);
		for (int i=0; i < listParams.size(); i++){
			if (!checkIfDeleted(listToDelete, listParams.get(i).getPremSeqNo(), listParams.get(i).getInstNo(), listParams.get(i).getTranType())){
				params.put("issCd", listParams.get(i).getIssCd());
				params.put("premSeqNo", listParams.get(i).getPremSeqNo());
				params.put("tranType", listParams.get(i).getTranType());
				params.put("instNo", listParams.get(i).getInstNo());
				params.put("premAmt", listParams.get(i).getPremAmt());
				params.put("premVatable", listParams.get(i).getPremVatable());
				params.put("premVatExempt", listParams.get(i).getPremVatExempt());
				params.put("premZeroRated", listParams.get(i).getPremZeroRated());
				params.put("appUser", appUser);
				System.out.println("GENOPTEXT1 INSIDE BEFORE!: " + params);
				this.getSqlMapClient().queryForObject("genOpText", params);
				System.out.println("GENOPTEXT1 INSIDE AFTER!: " + params);
			}
		}
		/*for (int i=0; i < giacDirectPremCollns.size(); i++){
			if (checkIfDeleted(listToDelete, giacDirectPremCollns.get(i).getPremSeqNo(), giacDirectPremCollns.get(i).getInstNo(), giacDirectPremCollns.get(i).getTranType()) ) {
				params.put("issCd", listParams.get(i).getIssCd());
				params.put("premSeqNo", listParams.get(i).getPremSeqNo());
				params.put("tranType", listParams.get(i).getTranType());
				params.put("instNo", listParams.get(i).getInstNo());
				params.put("premAmt", listParams.get(i).getPremAmt());
				params.put("premVatable", listParams.get(i).getPremVatable());
				params.put("premVatExempt", listParams.get(i).getPremVatExempt());
				params.put("premZeroRated", listParams.get(i).getPremZeroRated());
				params.put("appUser", appUser);
				System.out.println("GENOPTEXT2 INSIDE BEFORE: " + params);
				this.getSqlMapClient().queryForObject("genOpText", params);
				System.out.println("GENOPTEXT2 INSIDE AFTER: " + params);
			}
		}*/
		for (GIACDirectPremCollns prem: giacDirectPremCollns){
			if (checkIfDeleted(listToDelete, prem.getPremSeqNo(), prem.getInstNo(), prem.getTranType()) ) {
				params.put("issCd", prem.getIssCd());
				params.put("premSeqNo", prem.getPremSeqNo());
				params.put("tranType", prem.getTranType());
				params.put("instNo", prem.getInstNo());
				params.put("premAmt", prem.getPremAmt());
				params.put("premVatable", prem.getPremVatable());
				params.put("premVatExempt", prem.getPremVatExempt());
				params.put("premZeroRated", prem.getPremZeroRated());
				params.put("appUser", appUser);
				System.out.println("GENOPTEXT2 INSIDE BEFORE: " + params);
				this.getSqlMapClient().queryForObject("genOpText", params);
				System.out.println("GENOPTEXT2 INSIDE AFTER: " + params);
			}
		}
		System.out.println("genOpText after: " + params+"\n");
		return "";
	}
	
	public boolean checkIfDeleted(List<GIACDirectPremCollns> listToDelete, Integer premSeqNo, Integer instNo, Integer tranType){
		boolean exists = false;
		for (int i=0; i < listToDelete.size(); i++){
			System.out.println("listToDelete.get(i).getPremSeqNo(): " + listToDelete.get(i).getPremSeqNo() + " premSeqNo: " + premSeqNo + " listToDelete.get(i).getInstNo(): " + listToDelete.get(i).getInstNo() + " INSTNO:  " + instNo + " listToDelete.get(i).getTranType(): " + listToDelete.get(i).getTranType() + " TRANTYPE: " + tranType);
			if (listToDelete.get(i).getPremSeqNo().equals(premSeqNo) && listToDelete.get(i).getInstNo().equals(instNo) && listToDelete.get(i).getTranType().equals(tranType)){
				System.out.println("EXISTSSSSS - "+tranType+" - "+premSeqNo);
				exists = true;
				return exists;
			}
		}
		return exists;
	}
	
	public boolean checkReinsert(List<GIACDirectPremCollns> listToReinsert, Integer premSeqNo, Integer instNo, Integer tranType){
		boolean exists = false;
		for (int i=0; i < listToReinsert.size(); i++){
			if (listToReinsert.get(i).getPremSeqNo().equals(premSeqNo) && listToReinsert.get(i).getInstNo().equals(instNo) && listToReinsert.get(i).getTranType().equals(tranType)){
				return true;
			}
		}
		return exists;
	}
	
	
	public void checkOrFlag(Integer gaccTranId) throws SQLException{
		log.info("Check OR Flag");
		log.info("GaccTranID: "  + gaccTranId);
		this.getSqlMapClient().queryForObject("checkOrFlag", gaccTranId);
	}
	
	public void updateGiacOrderOfPaymts(List<Map<String, Object>> listParams) throws SQLException{
		System.out.println(" updateGiacOrderOfPaymts size:" + listParams.size());
		for (int i=0; i < listParams.size(); i++){
			this.getSqlMapClient().update("updateGiacOrderOfPaymts", listParams.get(i));
			System.out.println("After updateGiacOrderOfPaymts: " + listParams.get(i));
		}
	}

	@Override
	public Map<String, Object> checkPremiumPaytForSpecial(
			Map<String, Object> params) throws SQLException {
		
		this.getSqlMapClient().queryForObject("checkPremiumPaytForSpecial", params);
		
		return params;
	}



	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getInvoiceListingTableGrid(
			HashMap<String, Object> params) throws SQLException {
		
		log.info("DAO - Retrieving invoice listing...");
		List<Map<String, Object>> invoiceListing = this.sqlMapClient.queryForList("getInvoiceListingTableGrid", params);
		log.info("DAO - Invoice listing retrieved");
		return invoiceListing;
	}



	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEnteredBillDetails(Map<String, Object> param)
			throws SQLException {
		
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getEnteredBillDetails", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACDirectPremCollns> getRelatedDirectPremCollns(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedDirectPremCollns",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPolicyInvoices(
			Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> invoiceListing = this.sqlMapClient.queryForList("getPolicyInvoices", params);
		log.info("Invoice listing retrieved");
		return invoiceListing;
	}

	@Override
	public Map<String, Object> validateGIACS007PremSeqNo(
			Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("validateGIACS007PremSeqNo params: "+params);
			this.getSqlMapClient().update("validateGIACS007PremSeqNo", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> setPremTaxTranType(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("setPremTaxTranType", params);
		return params;
	}

	@Override
	public String checkIfInvoiceExists(Map<String, Object> params)
			throws SQLException {
		System.out.println("checkIfInvoiceExists(DAO) - "+params);
		return (String) this.getSqlMapClient().queryForObject("checkIfInvoiceExists", params);
	}

	@Override
	public String getIncTagForAdvPremPayts(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getIncTagForAdvPremPayts", params);
	}
	
	public void checkAdvancePayment(List<Map<String, Object>> chkAdvPaytParamsList, String appUser) throws SQLException{
		for(Map<String, Object> params : chkAdvPaytParamsList){
			params.put("appUser", appUser);
			log.info("checkAdvancePayment Parameters: "+params);
			this.getSqlMapClient().update("checkAdvPayt", params);
		}
	}
	
	public void deleteAdvancePayment(List<GIACDirectPremCollns> listToDelete, String appUser) throws SQLException{
		for(GIACDirectPremCollns directPremCollns : listToDelete){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("appUser", appUser);
			params.put("gaccTranId", directPremCollns.getGaccTranId());
			params.put("issCd", directPremCollns.getIssCd());
			params.put("premSeqNo", directPremCollns.getPremSeqNo());
			params.put("instNo", directPremCollns.getInstNo());
			this.getSqlMapClient().delete("deleteGIACAdvancedPaytMapParam", params);
		}
	}

	@Override
	public String checkSpecialBill(Map<String, Object> params) throws SQLException{
		String checkBill = "";
		try {
			checkBill = (String) this.getSqlMapClient().queryForObject("checkSpecialBill", params);
			System.out.println("checkBill ["+params+"]: "+checkBill);
		} catch(SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			if(e.getMessage().indexOf("ORA-00942") > 0 && e.getErrorCode() == 942) {
				checkBill = "ORA-00942";
			} else {
				throw new SQLException(e.getCause());
			}
		}
		log.info("checkSpecialBill result - "+checkBill);
		return checkBill;
	}

	@Override
	public Map<String, Object> getDirectPremTotals(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDirectPremTotals", params);
		log.info("Direct Prem Total - "+params);
		return params;
	}

	@Override
	public Integer getNumberOfInst(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNumberOfInst", params);
	}
	
	public String genOpTextGIACS007(Map<String, Object> params, String appUser) throws SQLException {
		params.put("appUser", appUser);
		System.out.println("GENOPTEXT1 INSIDE BEFORE!: " + params);
		this.getSqlMapClient().queryForObject("genOpTextGIACS007", params);
		System.out.println("GENOPTEXT1 INSIDE AFTER!: " + params);
		return "";
	}

	@Override
	public Map<String, Object> validatePolicy(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("validateGIACS007Policy", params);
		return params;
	}
	
	@Override
	public String checkPreviousInst(Map<String, Object> params)
			throws SQLException {
		System.out.println("checkPreviousInst(DAO) - "+params);
		return (String) this.getSqlMapClient().queryForObject("checkPreviousInst", params);
	}
	
}
