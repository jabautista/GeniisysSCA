/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIMCUploadDAO;
import com.geniisys.gipi.entity.GIPIMCUpload;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWVehicle;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIMCUploadDAOImpl.
 */
public class GIPIMCUploadDAOImpl implements GIPIMCUploadDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private Logger log = Logger.getLogger(GIPIMCUploadDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIMCUploadDAO#validateUploadFile(java.lang.String)
	 */
	@Override
	public String validateUploadFile(String fileName) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateUploadFile", fileName);
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIMCUploadDAO#setGipiMCUpload(java.util.List)
	 */
	@Override
	public void setGipiMCUpload(List<GIPIMCUpload> mcUploads) throws SQLException {
		log.info("DAO calling setGipiMCUpload...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			for (GIPIMCUpload mcUpload: mcUploads) {
				this.getSqlMapClient().insert("setGipiMCUpload", mcUpload);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Saving of fleet data is successful!");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setRecordsOnUpload(Map<String, Object> params) throws SQLException {
		try {
			List<GIPIWItem> gipiWItem = (List<GIPIWItem>) params.get("gipiWItem");
			List<GIPIWVehicle> gipiWVehicle = (List<GIPIWVehicle>) params.get("gipiWVehicle");
			List<GIPIMCUpload> gipiMCUpload = (List<GIPIMCUpload>) params.get("fleetUploads"); 
			List<Map<String, Object>> gipiMCErrorLog = (List<Map<String, Object>>) params.get("errorLogs");
			Integer parId = (Integer) params.get("parId");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().delete("delGIPIMCErrorLog", (String) params.get("appUser"));
			this.getSqlMapClient().executeBatch();
			
			System.out.println("Inserting uploaded fleet to GIPI_WITEM...");
			for(GIPIWItem item: gipiWItem) {
				this.getSqlMapClient().insert("setGIPIWItem", item);
			}
			this.getSqlMapClient().executeBatch();
			
			Integer parStatus = (Integer) this.getSqlMapClient().queryForObject("gipis031GetParStatus", parId);
			if(gipiWItem.size() > 0 && parStatus < 4) {
				Map<String, Object> updateMap = new HashMap<String, Object>();
				updateMap.put("parId", parId);
				updateMap.put("parStatus", 4);
				updateMap.put("appUser", params.get("appUser"));
				this.getSqlMapClient().update("updatePARStatus", updateMap);
				this.getSqlMapClient().executeBatch();
			}
			
			System.out.println("Inserting uploaded fleet to GIPI_WVEHICLES...");
			for(GIPIWVehicle vehicle: gipiWVehicle) {
				this.getSqlMapClient().insert("setGIPIWVehicle1", vehicle);
			}
			this.getSqlMapClient().executeBatch();
			
			System.out.println("Inserting uploaded fleet to GIPI_MCUPLOADS...");
			for (GIPIMCUpload mcUpload: gipiMCUpload) {
				this.getSqlMapClient().insert("setGipiMCUpload1", mcUpload);
			}
			this.getSqlMapClient().executeBatch();
			
			System.out.println("Inserting error logs to GIPI_MC_ERROR_LOG...");
			for(Map<String, Object> error: gipiMCErrorLog) {
				this.getSqlMapClient().insert("setGIPIMCErrorLog", error);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIMCUpload> getUploadedMC(String fileName)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiMCUpload", fileName);
	}

	@Override
	public Integer getNextUploadNo() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNextUploadNo");
	}

}
