package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.giuts.dao.BatchPostingDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class BatchPostingDAOImpl implements BatchPostingDAO {
	
	private static Logger log = Logger.getLogger(BatchPostingDAO.class);
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getParListByParameter(Map<String, Object> params) throws SQLException {
		List<GIPIPARList> list = this.getSqlMapClient().queryForList("getParListByParameter", params);
		params.put("list", list);
		return params;
	}

	@Override
	public void deleteLog(Map<String, Object> param) throws SQLException {
		try {
			log.info("Start of delete...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting error log and posted log for user: " + param);
			this.getSqlMapClient().delete("deleteLog", param);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
		
	}

	@Override
	public String checkIfBackEndt(Map<String, Object> param) throws SQLException {
		return (String) getSqlMapClient().queryForObject("checkIfBackEndt1", param);
	}

	@Override
	public String batchPost(Map<String, Object> param) throws SQLException {
		String skipPar = "N";
		String bookingMsg = null;
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of Initial Posting Process...");
			log.info("Getting parameters..");
			Integer parId = (Integer) param.get("parId");
			String lineCd = (String) param.get("lineCd");
			String issCd = (String) param.get("issCd");
			String userId = (String) param.get("userId");
			String backEndt = (String) param.get("backEndt");
			String credBranchConf = (String) param.get("credBranchConf");
			String moduleId = (String) param.get("moduleId");
			String policyId = "";
			

			log.info("Checking PAR Cancellation message...");
			Map<String, Object> paramCheck = new HashMap<String, Object>();
			paramCheck.put("parId", parId);
			this.getSqlMapClient().update("checkCancellationMsgBatchPosting", paramCheck);
			this.getSqlMapClient().executeBatch();
			log.info("Checking PAR Cancellation message " + paramCheck);
			if (paramCheck.get("msgAlert") != null) {
				skipPar = "Y";
			}log.info("===================================================");
			
			log.info("Checking if Backward Endt...");
			Map<String, Object> paramBackEndt = new HashMap<String, Object>();
			paramBackEndt.put("parId", parId);
			this.getSqlMapClient().update("checkIfBackEndt", paramBackEndt);
			this.getSqlMapClient().executeBatch();
			log.info("Checking if Backward Endt for " + paramBackEndt);
			
			if (paramBackEndt.get("msgAlert") != null) {
				skipPar = "Y";
			}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Start of Validation for Installment...");
				Map<String, Object> paramValInstallment = new HashMap<String, Object>();
				paramValInstallment.put("parId", parId);
				paramValInstallment.put("moduleId", moduleId);
				this.getSqlMapClient().update("validateInstallmentBatchPosting", paramValInstallment);
				this.getSqlMapClient().executeBatch();
				log.info("Validating Installment for " + paramValInstallment);
			}log.info("===================================================");
				
				log.info("Start of posting details...When Post Btn Pressed");
				Map<String, Object> paramWhenPostBtn = new HashMap<String, Object>();
				paramWhenPostBtn.put("parId", parId.toString());
				paramWhenPostBtn.put("lineCd", lineCd);
				paramWhenPostBtn.put("issCd", issCd);
				paramWhenPostBtn.put("userId", userId);
				paramWhenPostBtn.put("credBranchConf", credBranchConf);
				paramWhenPostBtn.put("moduleId", moduleId);
				if (skipPar.equals("N")) {
					this.getSqlMapClient().update("whenPostBtnBatchPosting", paramWhenPostBtn);
					this.getSqlMapClient().executeBatch();
					bookingMsg = (String) paramWhenPostBtn.get("bookingMsg");
					log.info("When Post Button Pressed batch posting parameters : " + paramWhenPostBtn);
				}
				
				if (paramWhenPostBtn.get("msgAlert") != null) {
					skipPar = "Y";
				}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Start of Posting...");
				Map<String, Object> paramPostingProcessA = new HashMap<String, Object>();
				paramPostingProcessA.put("userId", userId);
				paramPostingProcessA.put("parId", parId.toString());
				paramPostingProcessA.put("moduleId", moduleId);
				this.getSqlMapClient().update("postingProcessABatchPosting", paramPostingProcessA);
				this.getSqlMapClient().executeBatch();
				log.info("Posting Process A parameters : " + paramPostingProcessA);
				
				if (paramPostingProcessA.get("msgAlert") != null) {
					skipPar = "Y";
				}
			}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Post Pol PAR..");
				Map<String, Object> paramPostPolPar = new HashMap<String, Object>();
				paramPostPolPar.put("parId", parId.toString());
				paramPostPolPar.put("lineCd", lineCd);
				paramPostPolPar.put("issCd", issCd);
				paramPostPolPar.put("userId", userId);
				paramPostPolPar.put("changeStat", paramWhenPostBtn.get("changeStat"));
				paramPostPolPar.put("moduleId", moduleId);
				this.getSqlMapClient().update("postPolParBatchPosting", paramPostPolPar);
				this.getSqlMapClient().executeBatch();
				policyId = paramPostPolPar.get("policyId").toString();
				log.info("Post Pol PAR parameters : " + paramPostPolPar);
				
				if (paramPostPolPar.get("msgAlert") != null) {
					skipPar = "Y";
				}
			}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Posting Process B...");
				Map<String, Object> paramPostingProcessB = new HashMap<String, Object>();
				paramPostingProcessB.put("parId", parId.toString());
				paramPostingProcessB.put("userId", userId);
				paramPostingProcessB.put("moduleId", moduleId);
				this.getSqlMapClient().update("postingProcessBBatchPosting", paramPostingProcessB);
				this.getSqlMapClient().executeBatch();
				log.info("Posting Process B parameters : " + paramPostingProcessB);
				if (paramPostingProcessB.get("msgAlert") != null) {
					skipPar = "Y";
				}
			}log.info("End of Initial Posting Process...");
			
			log.info("===================================================");
			log.info("Start of Final Posting Process...");
			
			if (skipPar.equals("N")) {
				log.info("Posting Process C...");
				log.info("policyId "+policyId);
				log.info("parId"+parId);
				Map<String, Object> paramPostingProcessC = new HashMap<String, Object>();
				paramPostingProcessC.put("parId", parId.toString());
				paramPostingProcessC.put("lineCd", lineCd);
				paramPostingProcessC.put("issCd", issCd);
				paramPostingProcessC.put("policyId", policyId);
				paramPostingProcessC.put("userId", userId);
				paramPostingProcessC.put("moduleId", moduleId);
				this.getSqlMapClient().update("postingProcessCBatchPosting", paramPostingProcessC);
				this.getSqlMapClient().executeBatch();
				log.info("Posting Process C parameters : " + paramPostingProcessC);
				if (paramPostingProcessC.get("msgAlert") != null) {
					skipPar = "Y";
				}
			}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Update Quote...");
				Map<String, Object> paramUpdateQuote = new HashMap<String, Object>();
				paramUpdateQuote.put("parId", parId.toString());
				paramUpdateQuote.put("userId", userId);
				this.getSqlMapClient().update("updateQuoteBatchPosting", paramUpdateQuote);
				this.getSqlMapClient().executeBatch();
				log.info("Update Quote parameters : " + paramUpdateQuote);
				log.info("===================================================");
				log.info("Delete PAR...");
				Map<String, Object> paramDeletePar = new HashMap<String, Object>();
				paramDeletePar.put("userId", userId);
				paramDeletePar.put("parId", parId.toString());
				paramDeletePar.put("lineCd", lineCd);
				paramDeletePar.put("issCd", issCd);
				this.getSqlMapClient().update("deleteParBatchPosting", paramDeletePar);
				this.getSqlMapClient().executeBatch();
				log.info("Delete PAR parameters : " + paramDeletePar);
				log.info("===================================================");
				log.info("Posting Process D...");
				this.getSqlMapClient().update("postingProcessDBatchPosting", paramUpdateQuote);
				this.getSqlMapClient().executeBatch();
				log.info("Posting Process parameters : " + paramUpdateQuote);
				log.info("===================================================");
				log.info("Posting Process E...");
				Map<String, Object> paramPostingProcessE = new HashMap<String, Object>();
				paramPostingProcessE.put("parId", parId.toString());
				paramPostingProcessE.put("userId", userId);
				paramPostingProcessE.put("moduleId", moduleId);
				this.getSqlMapClient().update("postingProcessEBatchPosting", paramPostingProcessE);
				this.getSqlMapClient().executeBatch();
				
				if (paramPostingProcessE.get("msgAlert") != null) {
					skipPar = "Y";
				}
			}log.info("===================================================");
			
			if (skipPar.equals("N")) {
				log.info("Posting Process F...");
				Map<String, Object> paramPostingProcessF = new HashMap<String, Object>();
				paramPostingProcessF.put("userId", userId);
				paramPostingProcessF.put("parId", parId.toString());
				paramPostingProcessF.put("backEndt", backEndt);
				this.getSqlMapClient().update("postingProcessFBatchPosting", paramPostingProcessF);
				this.getSqlMapClient().executeBatch();
				log.info("Posting Process F parameters : " + paramPostingProcessF);
			}
			
			if (skipPar.equals("N")) {
				log.info("Posting Initial Process Commit..." + skipPar);
				
				log.info("Inserting Posted PAR to log...");
				Map<String, Object> paramPostPostedLog = new HashMap<String, Object>();
				paramPostPostedLog.put("userId", userId);
				paramPostPostedLog.put("parId", parId);
				if (bookingMsg != null) {
					log.info("Inserting Booking Month Message...");
					paramPostPostedLog.put("remarks", bookingMsg);
				}
				this.getSqlMapClient().update("postPostedLog", paramPostPostedLog);
				this.getSqlMapClient().executeBatch();
				log.info("Inserting Par : " + parId + ", to GIIS_POSTED_LOG");
				
				
				this.getSqlMapClient().getCurrentConnection().commit();
			}else if (skipPar.equals("Y")) {
				log.info("Checking Booking Month...");
				if (bookingMsg != null) {
					log.info("Inserting Booking Month Message...");
					Map<String, Object> paramPostErrorLog = new HashMap<String, Object>();
					paramPostErrorLog.put("userId", userId);
					paramPostErrorLog.put("parId", parId);
					paramPostErrorLog.put("remarks", bookingMsg);
					paramPostErrorLog.put("moduleId", moduleId);
					this.getSqlMapClient().update("postErrorLog", paramPostErrorLog);
					this.getSqlMapClient().executeBatch();
				}
				log.info("Posting Initial Process Rollback..." + skipPar);
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
			
		} catch (SQLException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
		return skipPar;
	}

}
