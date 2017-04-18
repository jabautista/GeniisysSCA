/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: BatchDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Dec 20, 2011
	Description: 
*/
package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.entity.GIACBatchDV;
import com.geniisys.gicl.controllers.BatchController;
import com.geniisys.gicl.dao.BatchDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLBatchCsr;
import com.geniisys.gicl.exceptions.BatchException;
import com.geniisys.gipi.controllers.PostParController;

public class BatchDAOImpl extends DAOImpl implements BatchDAO{

	protected static String message = "";
	private static Logger log = Logger.getLogger(BatchDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public String generateAE(Map<String, Object> params) throws SQLException,
			BatchException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object>mainParams = new HashMap<String, Object>();
			Integer limit = 10;
			GIACBatchDV newBatchDV = (GIACBatchDV) params.get("newBatchDV");
			String fundCd = (String) this.getSqlMapClient().queryForObject("getGIACParamValueV3", "FUND_CD");
			System.out.println("Fund Cd: "+fundCd);
			List<Map<String, Object>> adviceList = (List<Map<String, Object>>) params.get("objectSelectedAdviceRows");
			System.out.println("adviceList lengtg: "+adviceList.size());
			
			for (Map<String, Object> advice : adviceList) {
				advice.put("userId", params.get("userId"));
				System.out.println("advice ID: "+advice.get("adviceId"));
				this.getSqlMapClient().insert("giacs086ValidateAdvice", advice);				
			}
			
			log.info("START OF GENERATING ACCOUNTING ENTRIES");
			BatchController.messageStatus = "Request is going on.";
			
			log.info("insert into giac_batch_dv");
			BatchController.percentStatus = getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in BATCH DV.";
			mainParams.put("userId", params.get("userId"));
			mainParams.put("payeeClassCd", newBatchDV.getPayeeClassCd());
			mainParams.put("payeeCd", newBatchDV.getPayeeCd());
			mainParams.put("particulars", newBatchDV.getParticulars());
			mainParams.put("totalPaidAmt", newBatchDV.getTotalPaidAmt());
			mainParams.put("totalFcurrAmt", newBatchDV.getTotalFcurrAmt());
			mainParams.put("currencyCd", newBatchDV.getCurrencyCd());
			mainParams.put("convertRate", newBatchDV.getConvertRate());
			mainParams.put("payeeRemarks", newBatchDV.getPayeeRemarks());
			mainParams.put("issCd", params.get("issCd"));
			mainParams.put("fundCd", fundCd);
			System.out.println("before insert into giac_batch: "+mainParams);
			this.getSqlMapClient().update("setGiacBatchDv",mainParams);
			this.getSqlMapClient().executeBatch();
			System.out.println("after insert: "+mainParams);
			//retrieves the generated batch_dv_id
			int batchDvId = (Integer) mainParams.get("batchDvId");
			this.checkReturnMsg(mainParams);
			
			//insert per advice settlement and create new dynamic record group with distinct iss_cd 
			log.info("insert into giac_batch_dv_dtl");
			BatchController.percentStatus = 21+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in BATCH DV DETAILS.";
			
			for (Map<String, Object> advice : adviceList) {
				advice.put("batchDvId", batchDvId);
				advice.put("userId", params.get("userId"));
				//System.out.println(advice);
				System.out.println("advice ID: "+advice.get("adviceId"));
				System.out.println("claim ID: "+advice.get("claimId"));
				
				Map<String, Object> lossExpParams = new HashMap<String, Object>(); // bonok start :: 12.14.2015 :: UCPB SR 21147
				lossExpParams.put("claimId", advice.get("claimId"));
				lossExpParams.put("adviceId", advice.get("adviceId"));
				
				List<?> list = getSqlMapClient().queryForList("getGiclClmLossExp", lossExpParams); // bonok end :: 12.14.2015 :: UCPB SR 21147
				//List<?> list = getSqlMapClient().queryForList("getGiclClmLossExp", advice.get("claimId"));
				for (Object o: list) {
					Map<String, Object> a = (Map<String, Object>) o; 
					advice.put("clmLossId", Integer.parseInt(a.get("clmLossId").toString()));
					advice.put("paidAmt2", a.get("paidAmt")); // bonok :: 2.22.2016 :: UCPB SR 21664
					advice.put("paidAmt", a.get("paidAmt")); // john :: 5.19.2016 :: NIA SR 22379
					this.getSqlMapClient().insert("setGiacBatchDvDtl", advice);
				}
				this.getSqlMapClient().executeBatch(); // bonok :: 12.14.2015 :: UCPB SR 21147
				//updates the gicl_advice table
				this.getSqlMapClient().update("updateGICLAdviceBatchDvId", advice);
				//updates the gicl_acct_entries table
				this.getSqlMapClient().update("updateGICLAcctEntriesByAdvice",advice);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Adding records in PAYMENT REQUEST.");
			BatchController.percentStatus = 31+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in PAYMENT REQUEST.";
			this.getSqlMapClient().insert("setGiacPaytRequestBatch",mainParams);
			this.getSqlMapClient().executeBatch();
			
			log.info("Adding records in PAYMENT REQUEST DETAILS.");
			BatchController.percentStatus = 31+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in PAYMENT REQUEST DETAILS.";
			mainParams.put("payee", newBatchDV.getDspPayee());
			mainParams.put("userId2", params.get("userId"));
			System.out.println("MAIN PARAMS CURRENT PARAMETERS: "+mainParams);
			this.getSqlMapClient().update("addPaymentRequestDetails", mainParams);
			System.out.println("mainParams post addPaymentRequestDetails params: "+mainParams);
			this.getSqlMapClient().executeBatch();
			
			log.info("Adding records in DIRECT CLAIM PAYMENTS.");
			BatchController.percentStatus = 61+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in DIRECT CLAIM PAYMENTS.";
			 //loop per advice settlement again
			Map<String, Object>dcpParams = null;
			Integer itemNo = 0;
			for (Map<String, Object> advice : adviceList) {
				dcpParams = new HashMap<String, Object>();
				System.out.println("AdviceId 2: "+advice.get("adviceId"));
				itemNo = itemNo + 1;
				advice.put("batchDvId", batchDvId);
				advice.put("userId", params.get("userId"));
				dcpParams.put("userId", params.get("userId"));
				dcpParams.put("payeeClassCd", newBatchDV.getPayeeClassCd());
				dcpParams.put("payeeCd", newBatchDV.getPayeeCd());
				dcpParams.put("claimId", advice.get("claimId"));
				dcpParams.put("adviceId", advice.get("adviceId"));
				//dcpParams.put("paidAmt", new BigDecimal(advice.get("paidAmt") == null? "0" : advice.get("paidAmt").toString()));
				//replace issueCode parameter by issCd since no such parameter name found in parameter map addRecsInDirectClaimPaymentsMap3 in GIACBatchDV.xml by MAC 11/11/2013. 
				//replacing the parameter name will allow insertion of record in GIAC_DIRECT_CLAIM_PAYTS by MAC 11/11/2013.
				dcpParams.put("issCd", advice.get("issueCode")); 
				//dcpParams.put("convRt", new BigDecimal(advice.get("convRt")== null ? "0" :advice.get("convRt").toString())); 
				//dcpParams.put("convertRate", new BigDecimal(advice.get("convertRate")== null ? "0": advice.get("convertRate").toString())); 
				//dcpParams.put("clmLossId", advice.get("clmLossId")); john
				//dcpParams.put("netAmt", new BigDecimal(advice.get("netAmt")== null ? "0" : advice.get("netAmt").toString())); 
				//dcpParams.put("currencyCd", advice.get("currencyCode"));
				//dcpParams.put("payeeType", advice.get("payeeType"));
				dcpParams.put("riIssCd", mainParams.get("riIssCd"));
				dcpParams.put("dvTranId", mainParams.get("dvTranId"));
				dcpParams.put("jvTranId", mainParams.get("jvTranId"));
				dcpParams.put("userId2", params.get("userId"));
				dcpParams.put("itemNo", itemNo); // added by: Nica 11.28.2012
				dcpParams.put("batchDvId", batchDvId); // added by: Nante 8.28.2012
				log.info("dcpParams: "+dcpParams);
				//this.getSqlMapClient().update("addRecsInDirectClaimPayments", dcpParams);
				//this.getSqlMapClient().update("addRecsInDirectClaimPayments2", dcpParams); // replaced by: Nica 11.28.2012
				
				Map<String, Object> lossExpParams2 = new HashMap<String, Object>(); // bonok start :: 12.14.2015 :: UCPB SR 21147
				lossExpParams2.put("claimId", advice.get("claimId"));
				lossExpParams2.put("adviceId", advice.get("adviceId"));
				
				List<?> list = getSqlMapClient().queryForList("getGiclClmLossExp", lossExpParams2); // bonok end :: 12.14.2015 :: UCPB SR 21147
				
				//List<?> list = getSqlMapClient().queryForList("getGiclClmLossExp", advice.get("claimId"));
				for (Object o: list) {
					Map<String, Object> a = (Map<String, Object>) o; 
					dcpParams.put("clmLossId", Integer.parseInt(a.get("clmLossId").toString()));
					dcpParams.put("paidAmt", new BigDecimal(a.get("paidAmt") == null? "0" : a.get("paidAmt").toString()));
					dcpParams.put("netAmt", new BigDecimal(a.get("netAmt")== null ? "0" : a.get("netAmt").toString()));
					
					//nieko 01192017, SR 5901
					//dcpParams.put("convertRate", new BigDecimal(a.get("currencyRate")== null ? "0": a.get("currencyRate").toString()));
					//dcpParams.put("convRt", new BigDecimal(a.get("currencyRate")== null ? "0" :a.get("currencyRate").toString()));
					
					//nieko 01192017, SR 5901
					dcpParams.put("convertRate", new BigDecimal(a.get("convertRate")== null ? "0": a.get("convertRate").toString()));
					dcpParams.put("convRt", new BigDecimal(a.get("convRt")== null ? "0" :a.get("convRt").toString()));
					
					dcpParams.put("currencyCd", Integer.parseInt(a.get("currencyCd").toString()));
					dcpParams.put("payeeType", a.get("payeeType"));
					//this.getSqlMapClient().update("addRecsInDirectClaimPayments3", dcpParams); // replaced by: Nante 8.28.2012
					this.getSqlMapClient().update("addRecsInClaimPayments", dcpParams); // bonok :: 12.14.2015 :: UCPB SR 21147
				}
				this.getSqlMapClient().executeBatch(); // bonok :: 12.14.2015 :: UCPB SR 21147
				
				this.getSqlMapClient().update("insertGiacTaxesWheld", dcpParams); // bonok :: 12.14.2015 :: UCPB SR 21147
				this.getSqlMapClient().executeBatch(); // bonok :: 12.14.2015 :: UCPB SR 21147
				//updates the gicl_advice table
			}
			this.checkReturnMsg(dcpParams);
			this.getSqlMapClient().executeBatch();
			PostParController.workflowMsgr = (String) ((dcpParams.get("workflowMsgr") == null) ? "" : dcpParams.get("workflowMsgr"));
			
			BatchController.percentStatus = 81+getRandomNumber(limit)+"%";
			System.out.println("vCheck: "+mainParams.get("vCheck"));
			if (mainParams.get("vCheck").equals("N")) {
				BatchController.errorStatus = "BCS entries do not tally. Generate AE Failed.";
				this.getSqlMapClient().getCurrentConnection().rollback();
			}else{
				BatchController.messageStatus = "Generate AE Complete.";
				BatchController.percentStatus = "100%";
				//BatchController.genericId  = (String) mainParams.get("batchDvId");
				//requery the generated batch
				GIACBatchDV generatedBatch = (GIACBatchDV) this.getSqlMapClient().queryForObject("getGiacBatchDv",batchDvId);
				System.out.println("batchDvID:"+batchDvId);
				System.out.println("generatedBatch: "+generatedBatch);
				BatchController.GIACBatchDv = new JSONObject(generatedBatch);
				//message = 
				this.getSqlMapClient().getCurrentConnection().commit();
			}
			
			
			//this.getSqlMapClient().getCurrentConnection().rollback(); // SET MUNA SA ROLLBACK FOR TESTING
			return BatchController.messageStatus;
		}catch (SQLException e){
			BatchController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
	}
	
	private int getRandomNumber(Integer limit){
		Random generator = new Random();
		int rn = generator.nextInt(limit);
		return rn;
	}


	@SuppressWarnings("unchecked")
	@Override
	public String approveBatchCsr(Map<String, Object> params)
			throws SQLException, BatchException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GICLBatchCsr batchCsr = (GICLBatchCsr) params.get("batchCsr");
			String userId = (String) params.get("userId");
			Integer limit = 10;
			
			log.info("APPROVING BATCH CSR with batch_csr_id: " + batchCsr.getBatchCsrId());
			BatchController.messageStatus = "Request is going on.";
			BatchController.percentStatus = getRandomNumber(limit)+"%";
			
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("appUser", userId);
			paramMap.put("apprvdTag", "Y");
			paramMap.put("batchCsrId", batchCsr.getBatchCsrId());
			this.getSqlMapClient().update("updateGICLAdviceApprvdTag", paramMap);
			this.getSqlMapClient().executeBatch();
			
			BatchController.messageStatus = "Adding records in PAYMENT REQUEST.";
			BatchController.percentStatus = 11+getRandomNumber(limit)+"%";
			paramMap.put("fundCd", batchCsr.getFundCd());
			paramMap.put("issCd", batchCsr.getIssueCode());
			paramMap.put("userId", userId);
			this.getSqlMapClient().update("insertIntoGiacPaytRequests", paramMap);
			this.checkReturnMsg(paramMap);
			log.info(BatchController.messageStatus);
			this.getSqlMapClient().executeBatch();
			
			batchCsr.setReferenceId((Integer)paramMap.get("refId"));
			
			BatchController.messageStatus = "Adding records in ACCTRANS.";
			BatchController.percentStatus = 21+getRandomNumber(limit)+"%";
			this.getSqlMapClient().update("insertIntoAcctrans", paramMap);
			this.checkReturnMsg(paramMap);
			log.info(BatchController.messageStatus + " - Reference Id = "+ paramMap.get("refId")); 
			this.getSqlMapClient().executeBatch();
			
			batchCsr.setTranId((Integer) paramMap.get("tranId"));
			
			BatchController.messageStatus = "Adding records in PAYMENT_REQUEST_DETAILS.";
			BatchController.percentStatus = 31+getRandomNumber(limit)+"%";
			paramMap.put("payeeCd", batchCsr.getPayeeCode());
			paramMap.put("payeeClassCd", batchCsr.getPayeeClassCode());
			paramMap.put("payeeAmt", batchCsr.getLossAmount());
			paramMap.put("currencyCd", batchCsr.getCurrencyCode());
			paramMap.put("convertRate", batchCsr.getConvertRate());
			paramMap.put("batchCsrId", batchCsr.getBatchCsrId());
			paramMap.put("particulars", batchCsr.getParticulars());  
			paramMap.put("reqDtlNo", batchCsr.getReqDtlNo());
			paramMap.put("lossAmt", batchCsr.getLossAmount());
			paramMap.put("refId", batchCsr.getReferenceId());
			paramMap.put("tranId", batchCsr.getTranId());
			paramMap.put("userId", userId);
			this.getSqlMapClient().update("insertIntoGrqd", paramMap);
			this.checkReturnMsg(paramMap);
			log.info(BatchController.messageStatus+ " - TranId = "+ paramMap.get("tranId"));
			this.getSqlMapClient().executeBatch();
			
			batchCsr.setParticulars((String)paramMap.get("particulars"));
			batchCsr.setReqDtlNo((Integer) paramMap.get("reqDtlNo"));
			
			BatchController.messageStatus = "Adding records in PAYMENT_REQUEST_DETAILS.";
			BatchController.percentStatus = 41+getRandomNumber(limit)+"%";
			
			List<GICLAdvice> adviceList = this.getSqlMapClient().queryForList("getAdviseListForBatchCsrApproval", batchCsr.getBatchCsrId());
			System.out.println("Advise list length: "+ adviceList.size());
			
			BatchController.percentStatus = 51+getRandomNumber(limit)+"%";
			Integer varItemNo = 1;
			
			for(GICLAdvice adv : adviceList){
				Map<String, Object> adviceMap = new HashMap<String, Object>();
				adviceMap.clear();
				adviceMap.put("batchCsrId", batchCsr.getBatchCsrId());
				adviceMap.put("tranId", batchCsr.getTranId());
				adviceMap.put("claimId", adv.getClaimId());
				adviceMap.put("adviceId", adv.getAdviceId());
				adviceMap.put("payeeClassCd", adv.getPayeeClassCd());
				adviceMap.put("payeeCd", adv.getPayeeCd());
				adviceMap.put("userId", userId);
				adviceMap.put("appUser", userId);
				adviceMap.put("itemNo", varItemNo);
				this.getSqlMapClient().update("insertIntoGiacTaxesWheld", adviceMap);
				this.checkReturnMsg(adviceMap);
				varItemNo = (Integer) adviceMap.get("newItemNo");
				this.getSqlMapClient().executeBatch();
				System.out.println("Var Item Number: " + varItemNo);
				log.info(BatchController.messageStatus+" - Advice_id: "+adv.getAdviceId()+" Claim_id: "+adv.getClaimId());
			}
			
			BatchController.messageStatus = "Adding records in DIRECT_CLAIM_PAYMENTS.";
			BatchController.percentStatus = 61+getRandomNumber(limit)+"%";
			
			List<GICLAdvice> giclAdvices = this.getSqlMapClient().queryForList("getGiclAdviceListByBatchCsrId", batchCsr.getBatchCsrId());
			System.out.println(giclAdvices.size()+" records with batch_csr_id = "+batchCsr.getBatchCsrId());
			
			BatchController.percentStatus = 71+getRandomNumber(limit)+"%";
			
			for(GICLAdvice advice : giclAdvices){
				Map<String, Object> advMap = new HashMap<String, Object>();
				advMap.clear();
				advMap.put("adviceId", advice.getAdviceId());
				advMap.put("tranId", batchCsr.getTranId());
				advMap.put("userId", userId);
				advMap.put("appUser", userId);
				
				if(!(advice.getIssueCode().equals("RI"))){
					this.getSqlMapClient().update("insertIntoGdcp", advMap);
				}else{
					this.getSqlMapClient().update("insertIntoGicp", advMap);
				}
				this.checkReturnMsg(advMap);
				this.getSqlMapClient().executeBatch();
			}
			
			BatchController.messageStatus = "Adding records in ACCOUNTING_ENTRIES.";
			BatchController.percentStatus = 81+getRandomNumber(limit)+"%";
			
			paramMap.put("batchCsrId", batchCsr.getBatchCsrId());
			paramMap.put("tranId", batchCsr.getTranId());
			paramMap.put("fundCd", batchCsr.getFundCd());
			paramMap.put("issCd", batchCsr.getIssueCode());
			paramMap.put("userId", userId);
			paramMap.put("appUser", userId);
			
			this.getSqlMapClient().update("aegInsUpdtGiacAcctEntries", paramMap);
			this.checkReturnMsg(paramMap);
			this.getSqlMapClient().executeBatch();
			
			batchCsr.setBatchFlag("A");
			
			BatchController.messageStatus = "Saving changes.";
			BatchController.percentStatus = 91+getRandomNumber(limit)+"%";
			
			this.getSqlMapClient().update("updateApprovedBatchCsr", batchCsr);
			this.getSqlMapClient().executeBatch();
			
			BatchController.messageStatus = "Approving of Batch CSR successful.";
			BatchController.percentStatus = "100%";
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit(); 
			
			return BatchController.messageStatus;
		}catch(SQLException e){ //jeffdojello 07.15.2014
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			BatchController.errorStatus =  ExceptionHandler.extractSqlExceptionMessage(e);
			throw e;
		}catch (Exception e){
			BatchController.errorStatus = e.getCause().toString(); 		//Halley 11.5.2013 
			//BatchController.errorStatus = "Error exception occured."+e.getCause();  
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return BatchController.messageStatus;
	}

	
	private void checkReturnMsg(Map<String, Object> params) throws BatchException{
		message = (String) ((params.get("msgAlert") == null) ? "Generate AE Complete." : params.get("msgAlert"));
		if (params.get("msgType") != null && params.get("msgType").toString().equals("confirm")){
			BatchController.errorStatus = (String) params.get("msgType");
			throw new BatchException(message);
		}else if (!message.equals("Generate AE Complete.")){
			log.info("Error on Checking details...");
			BatchController.errorStatus = message;
			throw new BatchException(message);
		}
		log.info("checkReturnMsg message: "+message);
	}

	@Override
	public String postRecovery(Map<String, Object> params) throws SQLException,
			BatchException {
		try{
			Integer limit = 25;
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("[postRecovery] insert into acct trans...");
			BatchController.percentStatus = getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Inserting records into giac_acctrans...";
			Map<String, Object> postParams = params;
			this.getSqlMapClient().update("insAcctTransGICLS055", postParams); //insert_into_acctrans
			this.getSqlMapClient().executeBatch();
			this.checkReturnRecMsg(postParams);
			
			System.out.println("[postRecovery] insert into acct entries..."+postParams);
			BatchController.percentStatus = 25+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Inserting records into giac_acct_entries...";
			this.getSqlMapClient().update("insUpdAcctEntriesGICLS055", postParams);   //aeg_ins_updt_giac_acct_entries - update acct entries
			this.getSqlMapClient().executeBatch();
			
			System.out.println("[postRecovery] updating recovery acct..."+postParams);
			postParams.put("recAcctFlag", "A");
			postParams.put("tranDate", new Date());
			BatchController.percentStatus = 50+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Updating gicl_recovery_acct..."; // not found in fmb
			this.getSqlMapClient().update("setRecoveryAcct2", postParams);
			this.getSqlMapClient().executeBatch();
			
			System.out.println("[postRecovery] update recovery payt..."+postParams);
			BatchController.percentStatus = 75+getRandomNumber(limit)+"%";
			BatchController.messageStatus = "Adding records in PAYMENT REQUEST.";
			this.getSqlMapClient().insert("updateRecoveryForPost", postParams); //update recovery
			this.getSqlMapClient().executeBatch();
			BatchController.messageStatus = "Loss Recovery Adjusting Entries Generated.";
			BatchController.percentStatus = "100%";
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return BatchController.messageStatus;
		}catch (Exception e){
			BatchController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return BatchController.messageStatus;
	}

	private void checkReturnRecMsg(Map<String, Object> params) throws BatchException {
		message = (String) ((params.get("msgAlert") == null) ? "Recovery Generated." : params.get("msgAlert"));
		if (params.get("msgType") != null && params.get("msgType").toString().equals("confirm")){
			BatchController.errorStatus = (String) params.get("msgType");
			throw new BatchException(message);
		}else if (!message.equals("Recovery Generated.")){
			log.info("Error on Checking details...");
			BatchController.errorStatus = message;
			throw new BatchException(message);
		}
		log.info("checkReturnRecMsg message: "+message);
	}
}
