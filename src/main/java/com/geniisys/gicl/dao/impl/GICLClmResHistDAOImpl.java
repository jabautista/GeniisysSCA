package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmResHistDAO;
import com.geniisys.gicl.entity.GICLClmResHist;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmResHistDAOImpl implements GICLClmResHistDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	private static Logger log = Logger.getLogger(GICLClmResHistDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClmResHistDAO#getLossExpenseReserve(java.util.Map)
	 */
	@Override
	public Map<String, Object> getLossExpenseReserve(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getLossExpReserve", params);
		return params;
	}

	@Override
	public void setPaytHistoryRemarks(List<GICLClmResHist> params)
			throws SQLException { // Udel 4.13.2012 
		try {
			log.info("Starting transaction...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GICLClmResHist rec : params){
				this.sqlMapClient.update("setPaytHistoryRemarks", rec);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Transaction commited, finished.");
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error(e.getStackTrace());
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String checkPaytHistory(GICLClmResHist param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPaytHistory", param);
	}

	@Override
	public void updateClaimResHistRemarks(Map<String, Object> params)
			throws SQLException {
		try {
			log.info("Starting transaction...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.sqlMapClient.update("setPaytHistoryRemarks", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Transaction commited, finished.");
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error(e.getStackTrace());
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClmResHistDAO#getLatestClmResHist(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public GICLClmResHist getLatestClmResHist(Map<String, Object> params)
			throws SQLException {
		log.info("get latest clm res history");
		GICLClmResHist clmResHist = null;
		List<GICLClmResHist> histList = (List<GICLClmResHist>) this.sqlMapClient.queryForList("getLatestClmResHist", params);
		if(histList!=null){
			
			Iterator<GICLClmResHist> iter = histList.iterator();
			GICLClmResHist tmp = null;
			while(iter.hasNext()){
				tmp = iter.next();
				System.out.println("------rehist: " + tmp.getClmResHistId() + " - claimId: " + tmp.getClaimId());
				clmResHist = tmp;
			}
			
//			if(histList.size()==1){
//				clmResHist = histList.get(0);
//			}
		}
//		GICLClmResHist clmResHist = (GICLClmResHist)this.sqlMapClient.queryForObject("getLatestClmResHist", params);
		return clmResHist;
	}
}