package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giuw.controllers.PostDistributionController;
import com.geniisys.giuw.dao.PostDistributionDAO;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;
import com.geniisys.giuw.exceptions.PostingDistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class PostDistributionDAOImpl implements PostDistributionDAO{
	
	protected static String message = "";
	
	private static Logger log = Logger.getLogger(PostDistributionDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String postBatchDistribution(Map<String, Object> params)
			throws SQLException, PostingDistributionException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String batchId = (String)params.get("batchId");
			String userId = (String) params.get("userId");
			Integer limit = 10;
			
			PostDistributionController.percentStatus = getRandomNumber(limit)+"%";
			PostDistributionController.messageStatus = "Checking details...";
			
			List<GIUWPolDist> giuwPolDistList = this.getSqlMapClient().queryForList("getGiuwPolDistByBatchId", batchId);
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			paramMap.clear();
			paramMap.put("batchId", batchId);
			
			this.getSqlMapClient().update("checkRiShare", paramMap);
			
			String vFaculSw = (String) paramMap.get("vFaculSw");
			
			log.info("Performing batch distribution for batch_id: " + batchId + " Faculsw: " + vFaculSw + " User: " + userId);
			
			this.getSqlMapClient().executeBatch();
			
			for(GIUWPolDist polDist : giuwPolDistList){
				PostDistributionController.policyNo = "";
				PostDistributionController.policyTitle = "";
				
				paramMap.clear();
				paramMap.put("policyId", polDist.getPolicyId());
				paramMap.put("distNo", polDist.getDistNo());
				paramMap.put("batchId", batchId);
				paramMap.put("vFaculSw", vFaculSw);
				paramMap.put("userId", userId);
				paramMap.put("appUser", userId);
				
				// shan 08.29.2014
				//this.sqlMapClient.update("deleteReinsertGIUWS004", paramMap);
				this.sqlMapClient.update("adjustAllWTablesGIUWS004", paramMap);
				this.sqlMapClient.update("adjustOneRiskShareWdistfrps", polDist.getDistNo());
				// end 08.29.2014
				
				List<GIUWPolDistPolbasicV> polDistPolBasicV = this.getSqlMapClient().queryForList("getGIUWPolDistPolbasicV", paramMap);
				
				for(GIUWPolDistPolbasicV v: polDistPolBasicV){
					PostDistributionController.policyNo = v.getPolicyNo();
					
					if(v.getEndtSeqNo() > 0){
						PostDistributionController.policyTitle = "For endt. No. ";
					}else{
						PostDistributionController.policyTitle = "For policy No. ";
					}
					
					paramMap.put("lineCd", v.getLineCd());
					paramMap.put("sublineCd", v.getSublineCd());
					paramMap.put("issCd", v.getIssCd());
					paramMap.put("issueYy", v.getIssueYy());
					paramMap.put("polSeqNo", v.getPolSeqNo());
					paramMap.put("renewNo", v.getRenewNo());
					break;
					
				}
				
				Debug.print(paramMap);
				
				log.info("Posting Distribution: " + PostDistributionController.policyNo);
												
				PostDistributionController.percentStatus = 11+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = "DELETING DISTRIBUTION TABLES...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().delete("deleteDistTablesGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.percentStatus = 21+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = "UPDATING DISTRIBUTION TABLES...";
				
				PostDistributionController.messageStatus = "POST_WPOLICYDS_DTL...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("postWpolicydsDtlGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.messageStatus = "POST_WITEMDS_DTL...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("postWitemdsDtlGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
								
				PostDistributionController.percentStatus = 31+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = "POST_WITEMPERILDS_DTL...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("postWitemPerildsDtlGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.messageStatus = "POST_WPERILDS_DTL...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("postWperildsDtlGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.percentStatus = 41+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = "TRANSFER_WPOLICYDS...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("transferWpolicyds", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.messageStatus = "TRANSFER_WITEMDS...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("transferWitemds", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.percentStatus = 51+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = "TRANSFER_WITEMPERILDS...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("transferWitemPerilds", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.messageStatus = "TRANSFER_WPERILDS...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("transferWperilds", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.percentStatus = 61+getRandomNumber(limit)+"%";
				PostDistributionController.messageStatus = vFaculSw.equals("N") ? "DELETING WORKING TABLES..." : "CREATING REINSURANCE RECORDS...";
				log.info(PostDistributionController.messageStatus);
				this.getSqlMapClient().update("tableUpdatesGiuws015ProcessA", paramMap);
				this.getSqlMapClient().executeBatch();
				
				PostDistributionController.percentStatus = 71+getRandomNumber(limit)+"%";
				this.getSqlMapClient().update("tableUpdatesGiuws015ProcessB", paramMap);
				this.checkReturnMsg(paramMap);
				this.getSqlMapClient().executeBatch();
				Debug.print("After: " + paramMap);
				
				PostDistributionController.percentStatus = 81+getRandomNumber(limit)+"%";
				this.getSqlMapClient().update("adjustFinalGiuws015", paramMap);
				this.getSqlMapClient().executeBatch();
				
			}
			
			if(giuwPolDistList.size() > 0){
				Map<String, Object> distBatchMap = new HashMap<String, Object>();
				distBatchMap.put("batchId", batchId);
				distBatchMap.put("userId", userId);
				distBatchMap.put("batchQty", giuwPolDistList.size());
				distBatchMap.put("batchFlag", vFaculSw.equals("Y")? "2" : "3");
				Debug.print(distBatchMap);
				
				log.info("Updating batch distribution flag...");
				this.getSqlMapClient().update("updateGiuwDistBatch", distBatchMap);
				this.getSqlMapClient().executeBatch();
			}
			
			PostDistributionController.messageStatus = "Posting distribution Successful.";
			log.info(PostDistributionController.messageStatus);
			PostDistributionController.percentStatus = "100%";
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(com.geniisys.giuw.exceptions.PostingDistributionException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e) {
			PostDistributionController.errorStatus = "Error exception occured."+e.getCause();
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
	private void checkReturnMsg(Map<String, Object> params) throws PostingDistributionException{
		message = (String) ((params.get("msgAlert") == null) ? "Posting distribution Successful." : params.get("msgAlert"));
		if (!message.equals("Posting distribution Successful.")){
			log.info("Error on Checking details...");
			PostDistributionController.errorStatus = message;
			throw new PostingDistributionException(message);
		}
	}
	
	private int getRandomNumber(Integer limit){
		Random generator = new Random();
		int rn = generator.nextInt(limit);
		return rn;
	}

}
