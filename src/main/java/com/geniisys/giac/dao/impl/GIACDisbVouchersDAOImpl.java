/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao.impl
	File Name: GIACDisbVouchersDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.giac.dao.GIACDisbVouchersDAO;
import com.geniisys.giac.entity.GIACDisbVouchers;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;

public class GIACDisbVouchersDAOImpl extends DAOImpl implements GIACDisbVouchersDAO{
	private static Logger log = Logger.getLogger(GIACDisbVouchersDAOImpl.class);
	@Override
	public GIACDisbVouchers getGiacs016GiacDisb(Integer gprqRefId)
			throws SQLException {
		log.info("RETRIEVING GIAC_DISB_VOUCHERS INFO");
		return (GIACDisbVouchers) getSqlMapClient().queryForObject("getGiacs016GiacDisb", gprqRefId);
	}
	
	@Override
	public GIACDisbVouchers getDisbVoucherInfo(Map<String, Object> params) throws SQLException, Exception {
		GIACDisbVouchers dv = null;
		
		try {
			
			log.info("DAO - Retrieving disbursement voucher information...");
			dv = (GIACDisbVouchers) this.getSqlMapClient().queryForObject("getGIACS002DisbInfo", params);
			//System.out.println("retrieved fundDesc: " + dv.getFundDesc() + "\tbranchname: " + dv.getBranchName());
		
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}
		
		
		return dv;
	}

	@Override
	public GIACDisbVouchers getDefaultVoucher(Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving default disbursement voucher information...");
		return (GIACDisbVouchers) this.getSqlMapClient().queryForObject("getGIACS002DefaultDV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkFundBranchFK(Map<String, Object> params) throws SQLException {
		log.info("DAO - Checking fund and branch codes...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkFundBranchFK", params);
	}

	@Override
	public String getPrintTagMean(String printTag) throws SQLException {
		log.info("DAO - Retrieving print tag meaning...");
		return (String) this.getSqlMapClient().queryForObject("getPrintTagMean", printTag);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateAcctEntriesBeforeApproving(Map<String, Object> params) throws SQLException {
		Map<String, Object> params1 = new HashMap<String, Object>(params);
		
		log.info("DAO - Validating accounting entries...");
		params1 = (Map<String, Object>) this.getSqlMapClient().queryForObject("validateAcctEntriesBeforeApproving", params);
		System.out.println("params: " + params);
		System.out.println("params1: " + params1);
		return params;
	}

	@Override
	public Map<String, Object> approveValidatedDV(Map<String, Object> params) throws SQLException, Exception {
		log.info("DAO - approving DV...");
		Map<String, Object> params1 = new HashMap<String, Object>(params);
		System.out.println("params1 after assignment: " + params1);
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// 1. Delete workflow records
			log.info("DAO - Deleting workflow records...");
			this.getSqlMapClient().update("deleteWorkflowRec3", params1);
			log.info("DAO - Workflow records deleted.");
			
			System.out.println("params before approval: " + params);
			// 2.update gidv items - approved by, approve date, dv flag.
			log.info("Updating voucher info...");
			//this.getSqlMapClient().update("approveValidatedDV", params);
			//params = (Map<String, Object>) 
					this.getSqlMapClient().queryForObject("approveValidatedDV", params);
			log.info("DAO - Voucher info updated.");
			
			System.out.println("params after approval: " + params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("End of voucher approval.");
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("params before return: " + params);
		return params;
	}

	@Override
	public GIACPaytReqDocs getPaytReqNumberingScheme(Map<String, Object> params) throws SQLException {
		log.info("Retrieving numbering scheme...");
		return  (GIACPaytReqDocs) this.getSqlMapClient().queryForObject("getPaytReqNumberingScheme", params);
	}

	@Override
	public Map<String, Object> saveVocuher(Map<String, Object> params) throws SQLException, Exception {
		//return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateInsert", params);		
		Map<String, Object> params1 = new HashMap<String, Object>(params);
		System.out.println("params1 after assignment: " + params1);
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// 1. Pre-Insert validation
			log.info("Pre-Insert validation and generation of sequence numbers...");
			this.getSqlMapClient().queryForObject("validateInsert", params1);
			System.out.println("params1: " + params1);
			log.info("Pre-insert validation and generation of sequence numbers done.");
			
			// 2. Insertion to table
			Map<String, Object> params2 = new HashMap<String, Object>(params1);
			params2.put("printDate", params.get("printDate"));
			params2.put("dvTag", params.get("dvTag"));
			System.out.println("params2 ito ung iinsert nia: " + params2);
			
			log.info("Inserting voucher into table...");
			this.getSqlMapClient().insert("insertUpdateVoucher", params2);
			log.info("Voucher successfully inserted.");
		
			System.out.println("params2 after insertion. " +params2 );
			
			// 3. Post-insert trigger
			Map<String, Object> params3 = new HashMap<String, Object>(params1);
			log.info("Post-insert validation started...");
			this.getSqlMapClient().queryForObject("postInsertVoucher", params3);
			log.info("Post-insert validation done.");
			
			System.out.println("params3 after post-insert: " + params3);
			
			params1.put("message", params3.get("message"));
			params1.put("workflowMsgr", params3.get("workflowMsgr"));
			
			System.out.println("params1 after postinsert: " + params1);
			
			// 4. do post-forms commit
			log.info("Executing Post-Forms-Commit...");
			this.getSqlMapClient().update("doPostFormsCommitGIACS002", params3);
			log.info("Post-Forms-Commit done.");
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Disbursement Voucher successfully saved.");
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("params1 before return: " + params1);
		return params1;
	}

	@Override
	public void validateGIACS002DocCd(Map<String, Object> params) throws SQLException {
		log.info("Validating document code...");
		this.getSqlMapClient().queryForObject("validateGIACS002DocCd", params);		
	}

	@Override
	public String checkIfOfppr(Integer gaccTranId) throws SQLException {
		log.info("Validating if document code is OFPPR...");
		return (String) this.getSqlMapClient().queryForObject("checkIfOfppr", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> verifyOfpprTrans(Map<String, Object> params) throws SQLException {
		log.info("Verifying if OFPPR Transaction...");
		System.out.println("params: "+params);
		params = (Map<String, Object>) this.getSqlMapClient().queryForObject("verifyOfpprTrans", params);
		System.out.println("params after: "+params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkCollectionDtl(Map<String, Object> params) throws SQLException, Exception {
		try {
			
			log.info("Checking collection details...");
			return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkCollectionDtl", params);
			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Checking collection details done.");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void preCancelDV(Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Updating giac_payt_requests_dtl and giac_cm_dm tables...");
			this.getSqlMapClient().update("preCancelDV", params);		
			
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Updating done.");
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Map<String, Object> cancelDV(Map<String, Object> params) throws SQLException, Exception {
		Map<String, Object> params1 = new HashMap<String, Object>(params);
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Cancellation of DV started...");
			this.getSqlMapClient().queryForObject("cancelDV", params1);
			System.out.println("params1: " + params1);
			log.info("Cancellation of DV done.");
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Disbursement Voucher successfully cancelled.");
			this.getSqlMapClient().endTransaction();
		}
		
		return params1;
	}

	@Override
	public String validateIfReleasedCheck(Map<String, Object> params) throws SQLException {
		log.info("Validating if check is already released...");
		return (String) this.getSqlMapClient().queryForObject("validateIfReleasedCheck", params);
	}

	@Override
	public Integer getTranSeqNo(Integer gaccTranId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getTranSeqNo", gaccTranId);
	}

	@Override
	public String validateAcctgEntriesBeforePrint(Integer gaccTranId) throws SQLException, Exception {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("Validating accounting entries...");
			this.getSqlMapClient().queryForObject("validateAcctgEntriesBeforePrint", gaccTranId);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			log.info("Validation of accounting entries done.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public void deleteWorkflowRecords(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("deleteWorkflowRecords", params);
	}

	@Override
	public String getDefaultBranchCd(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getDefaultBranchCd", userId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPaytRequests> getDocSeqNoList(Map<String, Object> params) throws SQLException {
		System.out.println("params: "+params);
		return this.getSqlMapClient().queryForList("getDocSeqNoList", params);
	}
	
}
