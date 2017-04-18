package com.geniisys.gicl.dao.impl;


import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLClmRecoveryDistDAO;
import com.geniisys.gicl.dao.GICLRecoveryRidsDAO;
import com.geniisys.gicl.entity.GICLClmRecoveryDist;
import com.geniisys.gicl.entity.GICLRecoveryRids;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmRecoveryDistDAOImpl implements GICLClmRecoveryDistDAO {
	
	private Logger log = Logger.getLogger(GICLClmRecoveryDAOImpl.class);
	private SqlMapClient sqlMapClient;
	private GICLRecoveryRidsDAO giclRecoveryRidsDAO;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public GICLRecoveryRidsDAO getGiclRecoveryRidsDAO() {
		return giclRecoveryRidsDAO;
	}

	public void setGiclRecoveryRidsDAO(GICLRecoveryRidsDAO giclRecoveryRidsDAO) {
		this.giclRecoveryRidsDAO = giclRecoveryRidsDAO;
	}
	
	@Override
	public void distributeRecovery(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("distributeRecovery", params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
	
	@Override
	public void negateDistRecovery(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("negateDistRecovery", params);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		}finally{
			this.sqlMapClient.endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveRecoveryDist(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Recovery Distribution.");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLClmRecoveryDist> setRecovDist = (List<GICLClmRecoveryDist>) params.get("setRecovDist");
			//List<GICLRecoveryRids> setRecovRIDist = (List<GICLRecoveryRids>) params.get("setRecovRIDist");
			List<GICLClmRecoveryDist> delRecovDist = (List<GICLClmRecoveryDist>) params.get("delRecovDist");
			//List<GICLRecoveryRids> delRecovRIDist = (List<GICLRecoveryRids>) params.get("delRecovRIDist");
			
			//for ri recovery dist
			//delete
			/*for (GICLRecoveryRids del2: delRecovRIDist){
				if (del2.getRecoveryId() != null || StringUtils.isEmpty(del2.getRecoveryId().toString())){
					Map<String, Object> delRec2 = new HashMap<String, Object>();
					delRec2.put("userId", params.get("userId"));
					delRec2.put("recoveryId", del2.getRecoveryId());
					delRec2.put("recoveryPaytId", del2.getRecoveryPaytId());
					delRec2.put("recDistNo", del2.getRecDistNo());
					delRec2.put("grpSeqNo", del2.getGrpSeqNo());
					
					this.sqlMapClient.delete("delGiclRecovRids", delRec2);
					log.info("deleteRIClmRecoveryDist params :: "+delRec2);
				}
			}
			this.getSqlMapClient().executeBatch();*/
			
			//update
			/*for (GICLRecoveryRids set2: setRecovRIDist){
				if (set2.getRecoveryId() != null || StringUtils.isEmpty(set2.getRecoveryId().toString())){
					Map<String, Object> saveRec2 = new HashMap<String, Object>();
					saveRec2.put("userId", params.get("userId"));
					saveRec2.put("recoveryId", set2.getRecoveryId());
					saveRec2.put("recoveryPaytId", set2.getRecoveryPaytId());
					saveRec2.put("recDistNo", set2.getRecDistNo());
					saveRec2.put("grpSeqNo", set2.getGrpSeqNo());
					saveRec2.put("riCd", set2.getRiCd());
					saveRec2.put("shareRiPct", set2.getShareRiPct());
					saveRec2.put("shrRiRecoveryAmt", set2.getShrRiRecoveryAmt());
					log.info("saveClmRecoveryRIDist params :: "+saveRec2.toString());
					
					this.giclRecoveryRidsDAO.delGiclRecovRids(saveRec2);
					log.info("updRIClmRecoveryDist params :: "+saveRec2);
				}
			}
			this.getSqlMapClient().executeBatch();*/
				
			//for recovery dist
			//delete
			for (GICLClmRecoveryDist del: delRecovDist){
				if (del.getRecoveryId() != null || StringUtils.isEmpty(del.getRecoveryId().toString())){
					Map<String, Object> delRec = new HashMap<String, Object>();
					delRec.put("userId", params.get("userId"));
					delRec.put("recoveryId", del.getRecoveryId());
					delRec.put("recoveryPaytId", del.getRecoveryPaytId());
					delRec.put("recDistNo", del.getRecDistNo());
					delRec.put("grpSeqNo", del.getGrpSeqNo());
					
					this.sqlMapClient.delete("delGiclRecovRids", delRec);
					this.getSqlMapClient().executeBatch();
					
					this.sqlMapClient.update("delDistRecovery", delRec);
					this.getSqlMapClient().executeBatch();
					log.info("deleteClmRecoveryDist params :: "+delRec);
				}
			}
			
			
			//update
			for (GICLClmRecoveryDist set: setRecovDist){
				if (set.getRecoveryId() != null || StringUtils.isEmpty(set.getRecoveryId().toString())){
					Map<String, Object> saveRec = new HashMap<String, Object>();
					saveRec.put("userId", params.get("userId"));
					saveRec.put("recoveryId", set.getRecoveryId());
					saveRec.put("recoveryPaytId", set.getRecoveryPaytId());
					saveRec.put("recDistNo", set.getRecDistNo());
					saveRec.put("grpSeqNo", set.getGrpSeqNo());
					saveRec.put("sharePct", set.getSharePct());
					saveRec.put("shrRecoveryAmt", set.getShrRecoveryAmt());
					
					this.sqlMapClient.update("updDistRecovery", saveRec);
					this.getSqlMapClient().executeBatch();
					log.info("updClmRecoveryDist params :: "+saveRec);
					
					
					//pol cruz, 10.21.2013
					//for updating ri shares when parent record was udapted
					Map<String, Object> updateRiSharesMap = new HashMap<String, Object>();
					updateRiSharesMap.put("userId", params.get("userId"));
					updateRiSharesMap.put("recoveryId", set.getRecoveryId().toString());
					updateRiSharesMap.put("recoveryPaytId", set.getRecoveryPaytId().toString());
					this.sqlMapClient.update("updateGICLS054RiShares", updateRiSharesMap);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Recovery Information.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}


	
}
