package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.giis.dao.GIISSignatoryDAO;
import com.geniisys.giis.entity.GIISSignatory;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSignatoryDAOImpl implements GIISSignatoryDAO{

	private Logger log = Logger.getLogger(GIISSignatoryDAOImpl.class);
	private SqlMapClient sqlMapClient;
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public Map<String, Object> validateSignatoryReport(Map<String, Object> params) throws SQLException {
		log.info("validating signatory report...");
		this.sqlMapClient.update("validateSignatoryReport", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISSignatory(Map<String, Object> params) throws SQLException {
		try {
			List<GIISSignatory> setSignatory = (List<GIISSignatory>) params.get("setSignatory");
			List<GIISSignatory> delSignatory= (List<GIISSignatory>) params.get("delSignatory");
			String userId = (String)params.get("userId");
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			
			log.info("Saving GIIS Signatory...");
			for(GIISSignatory signatory : delSignatory){
				this.sqlMapClient.delete("delGIISSignatory", signatory);
			}
			log.info(delSignatory.size() + " GIIS Signatory/s deleted.");
			
			for(GIISSignatory signatory : setSignatory){
				signatory.setUserId(userId); //marco - 05.23.2013
				this.sqlMapClient.insert("setGIISSignatory", signatory);
			}
			log.info(setSignatory.size() + " GIIS Signatory/s inserted.");
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void updateFilename(Map<String, Object> params) throws SQLException {
		log.info("Updating signatory filename...");
		this.sqlMapClient.update("updateSignatoryFilename", params);
	}

	@Override
	public String getGIISS116UsedSignatories(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGIISS116UsedSignatories", params);
	}

}
