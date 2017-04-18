package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLBatchCsrDAO;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLBatchCsr;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLBatchCsrDAOImpl implements GICLBatchCsrDAO{
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/** The log. */
	private static Logger log = Logger.getLogger(GICLBatchCsrDAOImpl.class);

	@Override
	public GICLBatchCsr getGICLBatchCsr(Map<String, Object> params)
			throws SQLException {
		return (GICLBatchCsr) this.getSqlMapClient().queryForObject("getGiclBatchCsr", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Integer generateBatchNumber(Map<String, Object> params)
			throws SQLException, Exception {
		GICLBatchCsr batchCsr = (GICLBatchCsr) params.get("batchCsr");
		List<GICLAdvice> adviceList = (List<GICLAdvice>) params.get("adviceList");
		String userId = (String) params.get("userId");
		Integer batchCsrId = 0;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Generating batch number for batch CSR...");
			
			if(adviceList.size() == 0){
				throw new SQLException("No gicl_advice record is tagged for Batch Number generation");
			}
			
			Map<String, Object> paramResults = new HashMap<String, Object>();
			
			paramResults.clear();
			paramResults.put("issCd",  batchCsr.getIssueCode());
			paramResults.put("userId", userId);
			paramResults.put("appUser", userId);
			
			this.getSqlMapClient().update("generateBatchNumberA", paramResults);
			this.getSqlMapClient().executeBatch();
			
			batchCsrId = Integer.parseInt(paramResults.get("batchCsrId").toString());
			batchCsr.setFundCd((String)paramResults.get("fundCd"));
			batchCsr.setIssueCode((String)paramResults.get("issCd"));
			batchCsr.setBatchYear(Integer.parseInt(paramResults.get("batchYear").toString()));
			batchCsr.setBatchSequenceNumber(Integer.parseInt(paramResults.get("batchSeqNo").toString()));
			batchCsr.setUserId(userId);
			batchCsr.setBatchCsrId(batchCsrId);
			
			this.getSqlMapClient().insert("setGiclBatchCsr", batchCsr);
			this.getSqlMapClient().executeBatch();
			
			log.info(adviceList.size() + " gicl_advice record/s tagged for batch CSR WITH batch_csr_id= "+batchCsrId);
			for(GICLAdvice adv : adviceList){
				Map<String, Object> adviceMap = new HashMap<String, Object>();
				adviceMap.clear();
				adviceMap.put("appUser", userId);
				adviceMap.put("batchCsrId", batchCsrId);
				adviceMap.put("claimId", adv.getClaimId());
				adviceMap.put("adviceId", adv.getAdviceId());
				adviceMap.put("lineCd", adv.getLineCode());
				adviceMap.put("issCd", adv.getIssueCode());
				adviceMap.put("adviceYear", adv.getAdviceYear());
				adviceMap.put("adviceSeqNo", adv.getAdviceSequenceNumber());
				adviceMap.put("userId", userId);
				adviceMap.put("msgAlert", "");
				adviceMap.put("workFlowMsg", "");
				log.info("Tagged advice id: " + adviceMap.get("adviceId"));
				
				this.getSqlMapClient().update("generateBatchNumberB", adviceMap); 
				if(adviceMap.get("msgAlert") != null || adviceMap.get("workFlowMsg") != null){
					throw new SQLException();
				}
				
				this.getSqlMapClient().update("updateGICLAdviceBatchCsrId", adviceMap);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of generate batch number");
		}
		return batchCsrId;
	}

	@Override
	public void cancelBatchCsr(Map<String, Object> params) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Cancelling batch CSR with batchCsrId="+params.get("batchCsrId"));
			
			@SuppressWarnings("unchecked")
			List<GICLAdvice> adviceList = this.getSqlMapClient().queryForList("getAdviceByBatchCsrId", params);
			log.info("Total No. of gicl_advices to be cancelled: " + adviceList.size());
			
			for(GICLAdvice adv : adviceList){
				Map<String, Object> adviceMap = new HashMap<String, Object>();
				adviceMap.put("batchCsrId", adv.getBatchCsrId());
				adviceMap.put("adviceId", adv.getAdviceId());
				adviceMap.put("claimId", adv.getClaimId());
				adviceMap.put("userId", params.get("userId"));
				this.getSqlMapClient().update("cancelBatchCsr", adviceMap);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of Cancelling Batch CSR.");
		}
		
	}

	@Override
	public Map<String, Object> gicls043C024PostQuery(Map<String, Object> params)
			throws SQLException, Exception {
		this.getSqlMapClient().update("gicls043C024PostQuery", params);
		return params;
	}

	@Override
	public void saveBatchCsr(Map<String, Object> params) throws SQLException,
			Exception {
		try{
			GICLBatchCsr batchCsr = (GICLBatchCsr) params.get("batchCsr");
			log.info("Updating Batch CSR with batch_csr_id="+batchCsr.getBatchCsrId());
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("setGiclBatchCsr", batchCsr);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
			log.info("End of saving batch CSR");
		}
		
	}

	@Override
	public String getBatchCsrReportId(Map<String, Object> params)
			throws SQLException, Exception {
		return (String) this.getSqlMapClient().queryForObject("getBCSRReportId", params);
	}

	

}
