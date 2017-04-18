package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISReportParameterDAO;
import com.geniisys.common.entity.GIISReportParameter;
import com.geniisys.giis.entity.GIISPeril;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISReportParameterDAOImpl implements GIISReportParameterDAO{
	/** The SQL Map Client.	 */
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISReportParameterDAOImpl.class);
	
	
	/**
	 * Gets the SQL Map Client.
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the SQL Map Client.
	 * @param sqlMapClient
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveReportParameter(Map<String, Object> params)
			throws SQLException {	
		String message = "SUCCESS";
		List<GIISReportParameter> setRows = (List<GIISReportParameter>) params.get("setRows");
		List<GIISReportParameter> delRows = (List<GIISReportParameter>) params.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for(GIISReportParameter del : delRows){
				this.sqlMapClient.delete("deleteInReportParameter", del);
			}
			for(GIISReportParameter set : setRows){					
				this.getSqlMapClient().insert("setReportParameter", set);
			}				
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: "
					+ e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);		
		return params;
	}
}
