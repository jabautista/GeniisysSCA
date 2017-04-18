package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACDeferredDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACDeferredDAOImpl implements GIACDeferredDAO {
	
	private Logger log = Logger.getLogger(GIACDeferredDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String checkIss(Map<String, Object> params) throws SQLException {
		log.info("Checking user iss " + params);
		return (String) this.getSqlMapClient().queryForObject("checkIss", params);
	}
	
	@Override
	public String checkIfDataExists(Map<String, Object> params) throws SQLException {
		log.info("Checking if data already extracted for " + params);
		return (String) this.getSqlMapClient().queryForObject("checkIfDataExists", params);
	}

	@Override
	public String checkGenTag(Map<String, Object> params) throws SQLException {
		log.info("Checking gen tag for " + params);
		return (String) this.getSqlMapClient().queryForObject("checkGenTag", params);
	}

	@Override
	public String checkStatus(Map<String, Object> params) throws SQLException {
		log.info("Checking status of 24th method transactions for " + params);
		return (String) this.getSqlMapClient().queryForObject("checkStatus", params);
	}
	
	@Override
	public void setTranFlag(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> tranFlagParams = new HashMap<String, Object>();
			tranFlagParams.put("year", params.get("year"));
			tranFlagParams.put("mM", params.get("mM"));
			tranFlagParams.put("appUser", params.get("appUser"));
			
			log.info("Updating tran flag for " + tranFlagParams);
			this.getSqlMapClient().update("setTranFlag", tranFlagParams);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String extractMethod(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
//			Map<String, Object> param = new HashMap<String, Object>();
//			param.put("year", params.get("year"));
//			param.put("mM", params.get("mM"));
//			param.put("procedureId", params.get("procedureId"));
//			param.put("appUser", params.get("appUser"));
			
			log.info("Extracting methods....." + params);
			this.getSqlMapClient().insert("extractMethod", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("msg");
			log.info("Extraction Process: " + message);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String checkIfComputed(Map<String, Object> params) throws SQLException {
		log.info("Checking if data has been computed: " + params);
		return (String) this.getSqlMapClient().queryForObject("checkIfComputed", params);
	}
	
	@Override
	public String computeMethod(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("year", params.get("year"));
			param.put("mM", params.get("mM"));
			param.put("procedureId", params.get("procedureId"));
			param.put("appUser", params.get("appUser"));
			
			if (params.get("isComputed").equals("Y")) {
				log.info("Compute procedures for data that has already been computed: " + param);
				this.getSqlMapClient().insert("callComputeProcedures", param);
				this.getSqlMapClient().executeBatch();
			}else {
				log.info("Computation On Progress." + params);
				this.getSqlMapClient().insert("computeMethod", param);
				this.getSqlMapClient().executeBatch();
			} 
			
			message = "Done";
			log.info("Computation Finished.");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String cancelAcctEnries(Map<String, Object> params) throws SQLException {
		log.info("Cancel Accounting Entries");
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating Giac Deferred tables..");
			this.getSqlMapClient().update("cancelAcctEntries", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("message");
			System.out.println(message);
			log.info("Giac Deferred tables updated for: "+ params);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String reversePostedTrans(Map<String, Object> params) throws SQLException {
		log.info("Start of Reverse Posted Trans...");
		String status = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Processing Reversing of Posted Transactions...record(s): ");
			this.getSqlMapClient().insert("reversePostedTrans", params);
			this.getSqlMapClient().executeBatch();
			
			status = (String) params.get("status");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return status;
	}
	
	@Override
	public String generateAcctEntries(Map<String, Object> params) throws SQLException {
		log.info("Start of Generate Accounting Entries...");
		String status = "";
		try {
			String table = (String) params.get("table");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("table: "+table);
			if (table.equals("reversal")) {
				log.info("Reversing Posted Transactions...");
				this.getSqlMapClient().insert("reversePostedTrans", params);
				this.getSqlMapClient().executeBatch();
			}else if (table.equals("gdGross")) {
				log.info("Processing Gross Premiums...");
				this.getSqlMapClient().insert("genAcctEntriesGross", params);
				this.getSqlMapClient().executeBatch();
			}else if (table.equals("gdRiPrem")) {
				log.info("Processing RI Premiums...");
				this.getSqlMapClient().insert("genAcctEntriesRiPrem", params);
				this.getSqlMapClient().executeBatch();
			}else if (table.equals("gdCommInc")) {
				log.info("Processing Commission Income...");
				this.getSqlMapClient().insert("genAcctEntriesCommInc", params);
				this.getSqlMapClient().executeBatch();
			}else if (table.equals("gdCommExp")) {
				log.info("Processing Commission Expense...");
				this.getSqlMapClient().insert("genAcctEntriesCommExp", params);
				this.getSqlMapClient().executeBatch();
			}
			
			status = (String) params.get("status");
			log.info("Accounting Entries Generated... "+status);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
//			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return status;
	}
	
	@Override
	public String setGenTag(Map<String, Object> params) throws SQLException {
		log.info("Final Process for Generate Accounting Entries");
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating Giac Deferred Extract table..");
			this.getSqlMapClient().update("setGenTag", params);
			this.getSqlMapClient().executeBatch();
			
			message = (String) params.get("message");
			log.info("Giac Deferred Extract table updated for: "+ params);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

}
