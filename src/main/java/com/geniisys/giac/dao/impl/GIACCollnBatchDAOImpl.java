package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCollnBatchDAO;
import com.geniisys.giac.entity.GIACCollnBatch;
import com.geniisys.gipi.dao.impl.GIPIPARListDAOImpl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCollnBatchDAOImpl implements GIACCollnBatchDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPARListDAOImpl.class);
	
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
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollnBatchDAO#getDCBNo(java.lang.String, java.lang.String)
	 */
	@Override
	public GIACCollnBatch getDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fundCd", fundCd);
		param.put("branchCd", branchCd);
		param.put("tranDate", tranDate);
		return (GIACCollnBatch) this.getSqlMapClient().queryForObject("getDCBNo", param);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollnBatchDAO#getNewDCBNo(java.lang.String, java.lang.String)
	 */
	@Override
	public GIACCollnBatch getNewDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException {
		log.info("Get new DCB Number");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("fundCd", fundCd);
		param.put("branchCd", branchCd);
		param.put("tranDate", tranDate);
		System.out.println("Params: " + param);
		return (GIACCollnBatch) this.getSqlMapClient().queryForObject("getNewDCBNo", param);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollnBatchDAO#getDCBDateLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCBDateLOV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getDCBDateLOVMap", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCollnBatchDAO#getDCBNoLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCBNoLOV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getDCBNoLOV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACCollnBatch> getDCBNosList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting DCB List for Maintenance...");
		return this.getSqlMapClient().queryForList("getDCBNoForMaint", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveCollnBatch(Map<String, Object> params) throws SQLException {
		try {
			List<GIACCollnBatch> addedDCB = (List<GIACCollnBatch>) params.get("setRows");
			List<Map<String, Object>> deletedDCB = (List<Map<String, Object>>) params.get("delRows");
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting dcb items...");
			for(Map<String, Object> delDCB: deletedDCB) {
				this.getSqlMapClient().delete("deleteGIACCollnBatch", delDCB);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			for(GIACCollnBatch insDCB: addedDCB) {
				log.info("Inserting/Updating records in giac_colln_batch - "+insDCB.getDcbFlag()+","+insDCB.getDcbNo()+","+insDCB.getFundCd());
				this.getSqlMapClient().update("saveGIACCollnBatch", insDCB);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public Integer generateDCBNo() throws SQLException {
		log.info("DAO - Generating DCBNo");
		Integer dcbNo = (Integer) this.getSqlMapClient().queryForObject("generateDCBNo");
		log.info("DAO - DCB No. generated: " + dcbNo);
		return dcbNo;
	}

	@Override
	public String getClosedTag(HashMap<String, Object> params)
			throws SQLException {
		return  (String) this.getSqlMapClient().queryForObject("getCloseTag", params);
	}

}
