package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACEndOfMonthReportsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACEndOfMonthReportsDAOImpl implements GIACEndOfMonthReportsDAO{
	
	private static Logger log = Logger.getLogger(GIACEndOfMonthReportsDAO.class);
	
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
	public void giacs138ExtractRecord(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Starting populate_policy procedure... Parameters:" + params.toString());
			this.getSqlMapClient().insert("giacs138PopulatePolicy", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Starting populate_details procedure... Parameters:" + params.toString());
			this.getSqlMapClient().insert("giacs138PopulateDetails", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("Starting populate_sum procedure... Parameters:" + params.toString());
			this.getSqlMapClient().insert("giacs138PopulateSum", params);
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

	@Override
	public void giacs128ExtractRecord(Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Initializing Tables... Parameters:" + params.toString());
			this.getSqlMapClient().insert("giacs128ExtractRecord", params);
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

	@Override
	public String deleteGiacProdExt() throws SQLException {
		String message = "Delete Production Table";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().delete("deleteGiacProdExt");
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
		return message;
	}

	@Override
	public String insertGiacProdExt(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Insert Production Table");
			this.getSqlMapClient().insert("insertGiacProdExt", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("message");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> checkPrevExt(GIISUser userId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("checkPrevExt", userId);
	}
}
