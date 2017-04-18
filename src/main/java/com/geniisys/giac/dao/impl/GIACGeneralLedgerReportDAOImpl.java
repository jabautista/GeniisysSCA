package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACGeneralLedgerReportDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACGeneralLedgerReportDAOImpl implements GIACGeneralLedgerReportDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACGeneralLedgerReportDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> getGiacs503NewFormInstance() throws SQLException {
		log.info("Retrieving new form instance values...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", null);
		params.put("month", null);
		params.put("firstPostingDate", null);
		System.out.println("params before: "+params);
		this.getSqlMapClient().queryForObject("getGiacs503NewFormInstance", params);
		System.out.println("params returned: "+params);
		return params;
	}

	@Override
	public Map<String, Object> postGiacs503SL(Map<String, Object> params) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			System.out.println("params before: "+params);
			log.info("Posting SL records...");
			this.getSqlMapClient().queryForObject("postGiacs503SL", params);
			System.out.println("params after: "+params);
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Integer validateGiacs503BeforePrint(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("validateGiacs503BeforePrint", params);
	}

	@Override
	public String extractGiacs501(Map<String, Object> params) throws SQLException {
		log.info("Extracting Monthly Trial Balance...");
		
		String message = "Extract: Done";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("extracting aging of collections");
			this.getSqlMapClient().insert("extractGiacs501", params);
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
	public String validatePayeeCdGiacs110(String payeeCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayeeCdGiacs110", payeeCd);
	}

	@Override
	public String validateTaxCdGiacs110(Integer whtaxId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateTaxCdGiacs110", whtaxId);
	}

	@Override
	public String validatePayeeNoGiacs110(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validatePayeeNoGiacs110", params);
	}

	@Override
	public String extractMotherAccounts(Map<String, Object> params) throws SQLException {
		log.info("Extracting Trial Balance As Of : extracMotherAccounts...");
		
		String message = "extracMotherAccounts: Done";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("extracting aging of collections");
			this.getSqlMapClient().insert("extractMotherAccounts", params);
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
	public String extractMotherAccountsDetail(Map<String, Object> params) throws SQLException {
		log.info("Extracting Trial Balance As Of : extracMotherAccountsDetail...");
		
		String message = "extracMotherAccountsDetail: Done";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("extracting aging of collections");
			this.getSqlMapClient().insert("extractMotherAccountsDetail", params);
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
	public String checkExtractGIACS115(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkExtractGIACS115", params);
	}

	@Override
	public String extractGIACS115(Map<String, Object> params) throws SQLException {
		Integer count = 0;
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("extractGIACS115", params);
			this.sqlMapClient.executeBatch();
			
			count = (Integer) params.get("count");
			
			System.out.println("extractGiacs115 params: "+params);
			this.sqlMapClient.getCurrentConnection().commit();
			//this.sqlMapClient.getCurrentConnection().rollback();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return count.toString();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateCSVGIACS115(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateCSVGIACS115", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateSAWTCSVGIACS115(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateSAWTCSVGIACS115", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateDATMAPRows(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateDatMAPGIACS115", params);
	}

	@Override
	public Map<String, Object> generateDATMAPDetails(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("generateDATMAPDetails", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateDATMAPAnnualRows(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateDATMAPAnnualGIACS115", params);
	}

	@Override
	public Map<String, Object> generateDATMAPAnnualDetails(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("generateDATMAPAnnualDetails", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateDATSAWTRows(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateDATSAWTGIACS115", params);
	}

	@Override
	public Map<String, Object> generateDATSAWTDetails(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("generateDATSAWTDetails", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	//added by robert SR 5473 03.14.16
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateCSVRLFSLS(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateCSVRLFSLS", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateDATRLFSLSRows(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("generateDATRLFSLSRows", params);
	}

	@Override
	public Map<String, Object> generateDATRLFSLSDetails(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("generateDATRLFSLSDetails", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		}catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	//end of codes by robert SR 5473 03.14.16
}
