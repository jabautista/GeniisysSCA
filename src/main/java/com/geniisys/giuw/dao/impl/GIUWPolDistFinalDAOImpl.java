package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giuw.dao.GIUWPolDistFinalDAO;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUWPolDistFinalDAOImpl implements GIUWPolDistFinalDAO {
	
	private static Logger log = Logger.getLogger(GIUWPolDistFinalDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> compareGIPIItemItmperil(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("compGipiItemItmperilGIUWS010", params);
		return params;
	}

	@Override
	public void createItemsGiuws010(Map<String, Object> params)
			throws Exception {
		
		String delDistTableSw = (String) (params.get("delDistTable") == null ? "N" : params.get("delDistTable"));
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if(delDistTableSw.equals("Y")){
				log.info("Recreating items for distNo: " + params.get("distNo"));
				this.getSqlMapClient().startBatch();
					this.getSqlMapClient().delete("deleteDistWorkingTables", params);
				    this.getSqlMapClient().delete("delDistMasterTables", params); //edgar 09/16/2014
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().startBatch();
				Debug.print(params);
				this.getSqlMapClient().update("createItemsGIUWS010", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveSetUpGroupsForDistrFinalItem(Map<String, Object> allParams)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Map<String,Object> params = new HashMap<String, Object>();
			
			List<GIUWWitemds> setRows = (List<GIUWWitemds>) allParams.get("setRows");
			System.out.println("SetRows: " + setRows.size());
			Integer distNo   = 	allParams.get("distNo") == null ? null : (Integer) allParams.get("distNo");
			Integer policyId = 	allParams.get("policyId") == null ? null : (Integer) allParams.get("policyId");
			String lineCd    = 	(String)(allParams.get("lineCd")== null ? "" : allParams.get("lineCd"));
			String sublineCd =  (String)(params.get("sublineCd")== null ? "" : allParams.get("sublineCd"));
			String issCd     =  (String)(allParams.get("issCd") == null ? "" : allParams.get("issCd"));
			String packPolFlag =(String)(allParams.get("packPolFlag")== null ? "" : allParams.get("packPolFlag"));
			String userId =     (String)(allParams.get("userId")== null ? "" : allParams.get("userId")); 
					
			/*Pre-commit trigger (FORM Level)*/			
			this.getSqlMapClient().startBatch();
			params.clear();
			params.put("distNo", distNo);
			params.put("userId", userId);
			this.getSqlMapClient().update("preCommitGIUWS010", params);
			this.getSqlMapClient().executeBatch();
			
			for(GIUWWitemds set : setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().startBatch();
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("distSeqNo", set.getOrigDistSeqNo());
					params.put("userId", userId);
					params.put("itemNo", set.getItemNo()) ; // added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
					//this.getSqlMapClient().update("delGIUWWitemds", params); // commented out by jhing 12.05.2014
					this.getSqlMapClient().update("delGIUWWitemds2", params); //  jhing 12.05.2014
					this.getSqlMapClient().executeBatch();
				}
			}
			
			/*Pre-update trigger (C150 block)*/
			for(GIUWWitemds set : setRows){
				this.getSqlMapClient().startBatch();
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("distSeqNo", set.getDistSeqNo());
					params.put("tsiAmt", set.getTsiAmt());
					params.put("premAmt", set.getPremAmt());
					params.put("annTsiAmt", set.getAnnTsiAmt());
					params.put("itemGrp", set.getItemGrp());
					params.put("policyId", policyId);
					params.put("userId", userId);
					this.getSqlMapClient().insert("preUpdateGIUWS010", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			/*Main Saving - Key-Commit*/			
			for(GIUWWitemds set : setRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("setGIUWWitemds", set);
				this.getSqlMapClient().executeBatch();
			}
			
			/*Post-update trigger (C150 block)*/
			for(GIUWWitemds set : setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().startBatch();
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("origDistSeqNo", set.getOrigDistSeqNo());
					params.put("tsiAmt", set.getTsiAmt());
					params.put("premAmt", set.getPremAmt());
					params.put("annTsiAmt", set.getAnnTsiAmt());
					params.put("userId", userId);
					this.getSqlMapClient().update("postUpdateGIUWS010", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			/*Post-Form-Commit trigger (FORM Level)*/
			this.getSqlMapClient().startBatch();
			params.clear();
			params.put("distNo", distNo);
			params.put("policyId", policyId);
			params.put("lineCd", lineCd);
			params.put("sublineCd", sublineCd);
			params.put("issCd", issCd);
			params.put("packPolFlag", packPolFlag);
			params.put("userId", userId);
			this.getSqlMapClient().update("createRegroupedDistRecsGIUWS010", params);	
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Map<String, Object> compareGIPIItemItmperilGiuws018(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("compGipiItemItmperilGIUWS018", params);
		return params;
	}

	@Override
	public void createItemsGiuws018(Map<String, Object> params)
			throws SQLException, Exception {
		String delDistTableSw = (String) (params.get("delDistTable") == null ? "N" : params.get("delDistTable"));
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if(delDistTableSw.equals("Y")){
				log.info("Recreating items for distNo: " + params.get("distNo"));
				this.getSqlMapClient().startBatch();
					this.getSqlMapClient().delete("deleteDistWorkingTables", params);
				this.sqlMapClient.delete("delDistMasterTables", params);	// shan 07.28.2014
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().startBatch();
				Debug.print(params);
				this.getSqlMapClient().update("createItemsGIUWS018", params);
			this.getSqlMapClient().executeBatch();
		
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveSetUpPerilGrpDistFinal(Map<String, Object> allParams)
	throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Map<String,Object> params = new HashMap<String, Object>();
			
			List<GIUWWPerilds> setRows = (List<GIUWWPerilds>) allParams.get("setRows");
			Integer distNo   = 	allParams.get("distNo") == null ? null : (Integer) allParams.get("distNo");
			Integer policyId = 	allParams.get("policyId") == null ? null : (Integer) allParams.get("policyId");
			String lineCd    = 	(String)(allParams.get("lineCd")== null ? "" : allParams.get("lineCd"));
			String sublineCd =  (String)(allParams.get("sublineCd")== null ? "" : allParams.get("sublineCd"));
			String issCd     =  (String)(allParams.get("issCd") == null ? "" : allParams.get("issCd"));
			String packPolFlag =(String)(allParams.get("packPolFlag")== null ? "" : allParams.get("packPolFlag"));
			String userId    =  (String)(allParams.get("userId")== null ? "" : allParams.get("userId")); 
			
			/*added by Gzelle 07032014 - get item no*/
			log.info("Getting records in giuw_witemperil_ds...");
			List<Map<String, Object>> list =  this.getSqlMapClient().queryForList("getGiuwWitemperildsRec", distNo);
			this.sqlMapClient.executeBatch();
					
			/*Pre-commit trigger (FORM Level)*/			
			this.getSqlMapClient().startBatch();
			params.clear();
			params.put("distNo", distNo);
			params.put("userId", userId);
			this.getSqlMapClient().update("preCommitGIUWS018", params);
			this.getSqlMapClient().executeBatch();
						
			for(GIUWWPerilds set : setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().startBatch();
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("distSeqNo", set.getOrigDistSeqNo());
					params.put("userId", userId);
					params.put("perilCd", set.getOrigPerilCd()); // jhing 12.05.2014 added peril_cd
					//this.getSqlMapClient().update("delGIUWWPerilds", params); // jhing 12.10.2014 replaced with:
					this.getSqlMapClient().update("delGIUWWPerilds2", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			/*Pre-update trigger (C150 block)*/
			for(GIUWWPerilds set : setRows){
				this.getSqlMapClient().startBatch();
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("distSeqNo", set.getDistSeqNo());
					params.put("tsiAmt", set.getTsiAmt());
					params.put("premAmt", set.getPremAmt());
					params.put("annTsiAmt", set.getAnnTsiAmt());
					params.put("itemGrp", set.getItemGrp());
					params.put("policyId", policyId);
					params.put("perilType", set.getPerilType());
					params.put("userId", userId);
					this.getSqlMapClient().insert("preUpdateGIUWS018", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			/*Main Saving - Key-Commit*/			
			for(GIUWWPerilds set : setRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("setGIUWWPerilds", set);
				this.getSqlMapClient().executeBatch();
			}
			
			/*Post-update trigger (C150 block)*/
			for(GIUWWPerilds set : setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().startBatch();
					params.clear();
					params.put("distNo", set.getDistNo());
					params.put("origDistSeqNo", set.getOrigDistSeqNo());
					params.put("tsiAmt", set.getTsiAmt());
					params.put("premAmt", set.getPremAmt());
					params.put("annTsiAmt", set.getAnnTsiAmt());
					params.put("perilType", set.getPerilType());
					params.put("userId", userId);
					this.getSqlMapClient().update("postUpdateGIUWS018", params);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			// jhing 11.28.2014 commented out whole block. Insertion of records in 
			// GIUW_WITEMDS, GIUW_WITEMPERILDS will be handled in the revised codes for createRegroupedDistRecsGIUWS018Final
			
			//modified by Gzelle 07092014 - to consider item no
			/*for(GIUWWPerilds set : setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					for (int j = 0; j < list.size(); j++) {
						if (set.getOrigDistSeqNo().toString().equals(list.get(j).get("distSeqNo").toString()) &&
								set.getPerilCd().toString().equals(list.get(j).get("perilCd").toString())) {
							/*Post-Form-Commit trigger (FORM Level)*/
			/*				this.getSqlMapClient().startBatch();
							params.clear();
							params.put("distNo", distNo);
							params.put("policyId", policyId);
							params.put("lineCd", lineCd);
							params.put("sublineCd", sublineCd);
							params.put("issCd", issCd);
							params.put("packPolFlag", packPolFlag);
							params.put("itemNo", list.get(j).get("itemNo"));
							params.put("distSeqNo", set.getDistSeqNo());
							params.put("perilType", set.getPerilType());
							params.put("perilCd", set.getPerilCd());
							log.info("createRegroupedDistRecsGIUWS018: "+params);
							this.getSqlMapClient().update("createRegroupedDistRecsGIUWS018", params);	
							this.getSqlMapClient().executeBatch();
						}
					}
				}
			} */
			
			/*Post-Form-Commit trigger (FORM Level)*/
			this.getSqlMapClient().startBatch();
			params.clear();
			params.put("distNo", distNo);
			params.put("policyId", policyId);
			params.put("lineCd", lineCd);
			params.put("sublineCd", sublineCd);
			params.put("issCd", issCd);
			params.put("packPolFlag", packPolFlag);
			this.getSqlMapClient().update("createRegroupedDistRecsGIUWS018Final", params);	
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	//edgar 09/11/2014
	@Override
	public Map<String, Object> checkPostedBinder(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("checkPostedBinder2", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}
	
	// added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
	@Override
	public void validateSetupDistPerAction (Map<String, Object> params)
			throws SQLException, Exception {
			this.sqlMapClient.queryForObject("validate_setupDistPer_action", params);
	}
	
	

}
