/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISLostBidDAO;
import com.geniisys.common.entity.GIISLostBid;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISLostBidDAOImpl.
 */
public class GIISLostBidDAOImpl implements GIISLostBidDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISLostBid.class);

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLostBidDAO#getLostBidReasonList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLostBid> getLostBidReasonList(String userId) throws SQLException {
		log.info("DAO - Retrieving Lost Bid");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		List<GIISLostBid> lostBid = this.getSqlMapClient().queryForList("getLostBidReason",param); 
		log.info("DAO - Lost Bid Reasons Retrieved");
		return lostBid;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLostBidDAO#getLostBidReasonListByLineCd(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLostBid> getLostBidReasonListByLineCd(String lineCd) {
		List<GIISLostBid> list = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", lineCd);
		try {
			list = sqlMapClient.queryForList("getLostBidReasonListByLineCd", param);
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean saveLostBidReason(Map<String, Object> allParameters) throws Exception {
		/*log.info("DAO - Saving reason...");
		this.sqlMapClient.insert("addLostBidReason", newLostBid);
		log.info("DAO - Reason Saved.");*/
		Map<String, Object> delParams = (Map<String, Object>) allParameters.get("delParams");
		Map<String, Object> insParams = (Map<String, Object>) allParameters.get("insParams");
		
		String[] reasonCds = (String[]) insParams.get("reasonCds");
		String[] descriptions = (String[]) insParams.get("descriptions");
		String[] remarks = (String[]) insParams.get("remarks");
		String[] lineCds = (String[]) insParams.get("lineCds");
 		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.deleteLostBidReason(delParams);
			
			if(reasonCds != null) {
				GIISLostBid lostBid = null;
				log.info("DAO - Inserting lost bid reason...");
				for(int i=0; i<reasonCds.length; i++) {
					lostBid = new GIISLostBid();
					lostBid.setReasonCd(Integer.parseInt(reasonCds[i]));
					lostBid.setReasonDesc(descriptions[i]);
					lostBid.setRemarks(remarks[i]);
					lostBid.setLineCd(lineCds[i]);
					
					this.getSqlMapClient().insert("setLostBidReason", lostBid);
				}
				log.info("DAO - Reason/s inserted");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return true;
	}
	
	@SuppressWarnings("unchecked")
	public void saveLostBidReason2(Map<String, Object> allParameters) throws Exception {
		List<GIISLostBid> delReasons =  (List<GIISLostBid>) allParameters.get("delParams");
		List<GIISLostBid> insReasons =  (List<GIISLostBid>) allParameters.get("insParams");
 		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			
			if(delReasons != null){
				for(GIISLostBid del : delReasons){
					this.sqlMapClient.delete("delLostBidReason", del);
				}	
				log.info("DAO - Reason/s deleted");
			}
			
			if(insReasons != null){
				for(GIISLostBid set : insReasons){					
					this.getSqlMapClient().insert("setLostBidReason", set);
				}	
					log.info("DAO - Reason/s inserted");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Updating Reasons successful.");
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public boolean deleteLostBidReason(Map<String, Object> params) throws SQLException {
		/*log.info("Deleting Reason...");
		this.getSqlMapClient().delete("delLostBidReason", lostBidCd);
		log.info("Reason Deleted...");*/
		String[] reasonCds = (String[]) params.get("reasonCds");
		if(reasonCds != null) {
			Map<String, Object> delParams = new HashMap<String, Object>();
			log.info("DAO: Deleting Reason...");
			for(int i=0; i<reasonCds.length; i++) {
				delParams.put("reasonCds", reasonCds[i]);
				this.getSqlMapClient().delete("delLostBidReason", Integer.parseInt(reasonCds[i]));
			}
			log.info("DAO: " + reasonCds.length + " reason/s deleted...");
		}
		return true;
	}
		
	@Override
	public Integer generateReasonCd() throws SQLException {
		log.info("DAO - Generating ReasonCd");
		Integer reasonCd = (Integer) this.getSqlMapClient().queryForObject("generateReasonCd");
		log.info("DAO - Reason Cd generated: " + reasonCd);
		return reasonCd;
	}
	
	public Integer generateReasonCd2() throws SQLException {
		log.info("DAO - Generating ReasonCd");
		Integer reasonCd = (Integer) this.getSqlMapClient().queryForObject("generateReasonCd2");
		log.info("DAO - Reason Cd generated: " + reasonCd);
		return reasonCd;
	}
	
	@Override
	public Map<String, Object> valUpdateRec(Map<String, Object>  params) throws SQLException {
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("result", this.sqlMapClient.queryForObject("valUpdateReason",params));
		return param;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss204(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLostBid> delList = (List<GIISLostBid>) params.get("delRows");
			for(GIISLostBid d: delList){
				this.sqlMapClient.update("delReason", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISLostBid> setList = (List<GIISLostBid>) params.get("setRows");
			for(GIISLostBid s: setList){
				this.sqlMapClient.update("setReason", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(Map<String, Object>  params) throws SQLException {
		this.sqlMapClient.update("valDeleteReason", params);
	}

	@Override
	public void valAddRec(Map<String, Object>  params) throws SQLException {
		this.sqlMapClient.update("valAddReason", params);		
	}
}
