/**
 * 
 */
package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLBatchOSPrintingDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author steven
 *
 */
public class GICLBatchOSPrintingDAOImpl implements GICLBatchOSPrintingDAO{
	
	private static Logger log = Logger.getLogger(GICLBatchOSPrintingDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBatchOSRecord(Map<String, Object> params)
			throws SQLException, Exception {
		log.info("Getting All Records in Batch O/S Printing");
		String id = params.get("action").equals("getBatchOSRecord") ? "getGICLS207AllRecord" : "getGICLS207LossExpRecord";
		log.info("Parameters: " + params);
		return getSqlMapClient().queryForList(id,params);
	}

	@Override
	public void extractOSDetail(String tranId) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting Record...");
			log.info("Parameter use::::: tranId: "+ tranId);
			this.getSqlMapClient().insert("extractOSDetail",tranId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}	
}
