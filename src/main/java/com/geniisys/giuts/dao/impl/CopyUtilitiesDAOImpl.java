package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giuts.dao.CopyUtilitiesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class CopyUtilitiesDAOImpl implements CopyUtilitiesDAO{

	private Logger log = Logger.getLogger(GIUTS008CopyPolicyDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public HashMap<String, Object> summarizePolToPar(
			HashMap<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("populateSummaryGIUTS009: "+params);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("populateSummaryGIUTS009", params);
			this.getSqlMapClient().executeBatch();
			
			System.out.println("populateOtherInfoGIUTS009: "+params);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("populateOtherInfoGIUTS009", params);
			this.getSqlMapClient().executeBatch();
			
			System.out.println("continueSummaryTab: "+params);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("continueSummary", params);
			this.getSqlMapClient().executeBatch();
			
			System.out.println("updating summarized PAR: "+params);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateSummarizedPAR", params);
			this.getSqlMapClient().executeBatch();
			
			params.put("txtResult", "success");
			
			this.getSqlMapClient().getCurrentConnection().commit();
			//this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e){
			params.put("txtResult", "error");
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public void checkIfPolicyExists(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkExistingPolicyGIUTS009", params);
	}

	@Override
	public void checkPolicy(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkPolicyGIUTS009", params);
	}

	@Override
	public void validateLine(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateLineGIUTS009", params);
	}

	@Override
	public void validateIssCd(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateIssCdGIUTS009", params);
	}

	// GIUTS008A start
	@Override
	public String validateLineCdGiuts008a(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineCdGiuts008a", params);
	}

	@Override
	public String validateIssCdGiuts008a(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateIssCdGiuts008a", params);
	}

	@Override
	public HashMap<String, Object> copyPackPolicyGiuts008a(HashMap<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("copyPackPolicyGiuts008a", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
		
		
	}

	@Override
	public void validateParIssCd(HashMap<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateParIssCdGIUTS009", params);
	}

}
