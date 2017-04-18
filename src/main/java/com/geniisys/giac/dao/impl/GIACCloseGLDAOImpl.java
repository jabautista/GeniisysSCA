package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCloseGLDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCloseGLDAOImpl implements GIACCloseGLDAO{
	
	private static Logger log = Logger.getLogger(GIACCloseGLDAO.class);
	
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

	@Override
	public String getCloseGLParams(String paramId) throws SQLException {
		return (String) getSqlMapClient().queryForObject(paramId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getModuleId() throws SQLException {
		return (Map<String, Object>) getSqlMapClient().queryForObject("getModuleId");
	}

	@Override
	public Map<String, Object> closeGenLedger(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			log.info("Closing General Ledger...");
			System.out.println("Parameters: "+ params.toString());
			this.getSqlMapClient().insert("closeMonthYear", params);
			log.info("Closing Successful.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
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

	@Override
	public Map<String, Object> closeGenLedgerConfirmation(
			Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			log.info("Closing General Ledger with confirmation...");
			System.out.println("Parameters: "+ params.toString());
			this.getSqlMapClient().insert("confirmCloseMonthYear", params);
			log.info("Closing with confirmation Successful.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
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
