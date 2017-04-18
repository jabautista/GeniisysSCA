package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.Debug;
import com.geniisys.giuw.dao.GIUWDistBatchDAO;
import com.geniisys.giuw.entity.GIUWDistBatch;
import com.geniisys.giuw.entity.GIUWDistBatchDtl;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUWDistBatchDAOImpl implements GIUWDistBatchDAO{

	private Logger log = Logger.getLogger(GIUWDistBatchDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public GIUWDistBatch getGIUWDistBatch(Map<String, Object> params)
			throws SQLException {
		return (GIUWDistBatch) this.getSqlMapClient().queryForObject("getGiuwDistBatch", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveBatchDistribution(Map<String, Object> params)
			throws Exception {
		String del = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
		String message = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			List<GIUWPolDistPolbasicV> giuwPolDistPolbasicV = (List<GIUWPolDistPolbasicV>) params.get("giuwPolDistPolbasicV");
			String userId = (String) params.get("userId");
			
			if(giuwPolDistPolbasicV.size() > 0){
				this.getSqlMapClient().startBatch();
				
				Map<String, Object> paramMap = new HashMap<String, Object>();
				Integer newBatchId = (Integer) this.getSqlMapClient().queryForObject("generateNewBatchId");
				
				paramMap.clear();
				paramMap.put("newBatchId", newBatchId);
				paramMap.put("batchFlag", 1);
				paramMap.put("userId", userId);
				paramMap.put("batchQty", giuwPolDistPolbasicV.size());
				
				this.getSqlMapClient().insert("insertGiuwDistBatch", paramMap);
				Debug.print(paramMap);
				this.getSqlMapClient().executeBatch();
				
				for(GIUWPolDistPolbasicV v : giuwPolDistPolbasicV){
					paramMap.clear();
					paramMap.put("newBatchId", newBatchId);
					paramMap.put("userId", userId);
					paramMap.put("distNo", v.getDistNo());
					this.getSqlMapClient().update("updateGiuwPolDistBatchId", paramMap);
					log.info("Updating batchId to " + newBatchId + " for distNo = " + v.getDistNo());
					this.getSqlMapClient().executeBatch();
					//added edgar 12/15/2014
					Map<String, Object> param1 = new HashMap<String, Object>();
					param1.put("distNo", v.getDistNo());
					this.sqlMapClient.update("deleteWorkingBinders", param1);
					this.getSqlMapClient().executeBatch();
				}

				message = "SUCCESS" + del + newBatchId;
				this.getSqlMapClient().getCurrentConnection().commit();
			}
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "ERROR";
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "ERROR";
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveBatchDistributionShare(Map<String, Object> params) 
			throws Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			List<GIUWDistBatchDtl> setDistBatchDtl = (List<GIUWDistBatchDtl>) params.get("setDistBatchDtl");
			List<GIUWDistBatchDtl> delDistBatchDtl = (List<GIUWDistBatchDtl>) params.get("delDistBatchDtl");
			
			this.getSqlMapClient().startBatch();
			
			//deletes batch distribution share
			for(GIUWDistBatchDtl del : delDistBatchDtl){
				this.getSqlMapClient().delete("delGiuwDistBatchDtl", del);
				this.getSqlMapClient().executeBatch();
			}
			
			//insert or updates batch distribution share
			for(GIUWDistBatchDtl set : setDistBatchDtl){
				this.getSqlMapClient().update("setGiuwDistBatchDtl", set);
				this.getSqlMapClient().executeBatch();
			}
			
			// updates batch_flag to 1 : shan 08.11.2014
			this.sqlMapClient.update("updateBatchFlag1", Integer.parseInt(params.get("batchId").toString()));
			
			this.getSqlMapClient().getCurrentConnection().commit();
		
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
			
	}
	
	@SuppressWarnings("unchecked")
	public List<GIUWPolDistPolbasicV> getPoliciesByBatchId(Map<String, Object> params) throws SQLException{
		log.info("Getting policy list with BATCH_ID " + params.get("batchId"));
		return (List<GIUWPolDistPolbasicV>) this.sqlMapClient.queryForList("getPoliciesByBatchId", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDistPolbasicV> getPoliciesByParam(Map<String, Object> params) throws SQLException {
		log.info("Retrieving dist batch policies: "+params.toString());
		return (List<GIUWPolDistPolbasicV>) this.sqlMapClient.queryForList("getPoliciesByParam", params);
	}

}
