package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.controllers.GICLAdviceController;
import com.geniisys.giex.dao.GIEXExpiryDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXExpiryDAOImpl implements GIEXExpiryDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIEXExpiryDAOImpl.class);

	
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
	public Map<String, Object> getLastExtractionHistory(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getLastExtractionHistory", params);
		Debug.print(params);
		return params ;
	}
	
	@Override 
	public Map<String, Object> extractExpiringPolicies(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().update("extractExpiringPolicies", params);
			Debug.print(params);
			return params ;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
	
	@Override 
	public Map<String, Object> extractExpiringPoliciesFinal(Map<String, Object> params)
			throws SQLException {
			this.getSqlMapClient().update("extractExpiringPolicies", params);
			Debug.print(params);
			return params ;
	}

	@Override
	public Map<String, Object> updateBalanceClaimFlag(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("updateBalanceClaimFlag", params);
			Debug.print(params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
		return params ;
	}

	@Override
	public Map<String, Object> arValidationGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("arValidationGIEXS004", params);
		Debug.print(params);
		return params ;
	}

	@Override
	public Map<String, Object> updateF000Field(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updateF000Field", params);
		Debug.print(params);
		return params ;
	}

	@Override
	public GIEXExpiry getGIEXS007B240Info(Map<String, Object> params)
			throws SQLException {
		log.info("Getting B240 Info");
		return (GIEXExpiry) this.getSqlMapClient().queryForObject("getGIEXS007B240Info", params);
	}

	@Override
	public String checkRecordUser(Map<String, Object> params)
			throws SQLException {
		System.out.println("params:"+params);
		return (String) this.sqlMapClient.queryForObject("checkRecordUser", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getRenewalNoticePolicyId(Map<String, Object> params)
			throws SQLException {
		return (List<String>) this.sqlMapClient.queryForList("getRenewalNoticePolicyId", params);
	}

	@Override
	public String checkPolicyIdGiexs006(Integer policyId)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkPolicyIdGiexs006", policyId);
	}

	@Override
	public void generateRenewalNo(Map<String, Object> params)
			throws Exception {
		//this.sqlMapClient.insert("generateRenewalNo", params);
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("GENERATING RENEWAL NO.");
			//this.sqlMapClient.insert("generateRenewalNo2", params);
			this.sqlMapClient.insert("generateRenewalNo", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			GICLAdviceController.genAccMessage = ExceptionHandler.extractSqlExceptionMessage(e);			
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;		
		} finally {			
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void generatePackRenewalNo(Map<String, Object> params)
			throws Exception {
		this.sqlMapClient.insert("generatePackRenewalNo", params);	
		
	}

	@Override
	public Integer checkGenRnNo(Map<String, Object> params) throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("checkGenRnNo", params);
	}

	@Override
	public String checkRecordUserNr(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkRecordUserNr", params);
	}

	@Override
	public String getGiispLineCdGiexs006(String param) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGiispLineCdGiexs006", param);
	}

	@Override
	public String changeIncludePackValue(String lineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("changeIncludePackValue", lineCd);
	}

	@Override
	public void updatePrintTag(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			log.info("UPDATING PRINT TAG AND DATE. Params: "+params);
			this.sqlMapClient.insert("updatePrintTag", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			GICLAdviceController.genAccMessage = ExceptionHandler.extractSqlExceptionMessage(e);			
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;		
		} finally {			
			this.sqlMapClient.endTransaction();
		}
		
	}
}
