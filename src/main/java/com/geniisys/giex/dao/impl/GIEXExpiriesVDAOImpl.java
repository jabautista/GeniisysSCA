package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giex.dao.GIEXExpiriesVDAO;
import com.geniisys.giex.entity.GIEXExpiriesV;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIEXExpiriesVDAOImpl implements GIEXExpiriesVDAO{

	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIEXExpiriesVDAOImpl.class);

	
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
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIEXExpiriesV> getExpiredPolicies(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Expired Policies List...");
		return (List<GIEXExpiriesV>) StringFormatter.escapeHTMLInListOfMap(this.getSqlMapClient().queryForList("getExpiredPolicies", params));
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIEXExpiriesV> getQueriedExpiredPolicies(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Queried Expired Policies List...");
		return this.getSqlMapClient().queryForList("getQueriedExpiredPolicies", params);
	}

	@Override
	public Map<String, Object> preFormGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("preFormGIEXS004", params);
		Debug.print(params);
		return params;
	}

	@Override
	public Map<String, Object> postQueryGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("postQueryGIEXS004", params);
		return params;
	}

	@Override
	public Map<String, Object> checkPolicyGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkPolicyGIEXS004", params);
		
		//List<>
		return params;
	}

	@Override
	public Map<String, Object> checkRenewFlagGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkRenewFlagGIEXS004", params);
		return params;
	}

	@Override
	public Map<String, Object> verifyOverrideRbGIEXS004(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("verifyOverrideRbGIEXS004", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> processPostButtonGIEXS004(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Integer> policyIds = this.getSqlMapClient().queryForList("getPolIdForProcess", params);
			String strPolicyIds = policyIds.toString();
			String polIds = strPolicyIds.substring(1, strPolicyIds.length()-1);
			Debug.print(polIds);
			
			this.getSqlMapClient().update("processPostButtonGIEXS004", params);
			params.put("policyIds", polIds);
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> processPostOnOverrideGIEXS004(
			Map<String, Object> params) throws SQLException {
		/*this.getSqlMapClient().update("processPostOnOverrideGIEXS004", params);
		return params;*/
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Integer> policyIds = this.getSqlMapClient().queryForList("getPolIdForProcess", params);
			String strPolicyIds = policyIds.toString();
			String polIds = strPolicyIds.substring(1, strPolicyIds.length()-1);
			Debug.print(policyIds);
			
			this.getSqlMapClient().update("processPostOnOverrideGIEXS004", params);
			params.put("policyIds", polIds);
			
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> saveProcessTagGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("saveProcessTagGIEXS004", params);
		return params;
	}

	@Override
	public Map<String, Object> purgeBasedNotParam(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().delete("purgeBasedNotParam", params);
		return params;
	}

	@Override
	public Map<String, Object> purgeBasedNotTime(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().delete("purgeBasedNotTime", params);
		return params;
	}

	@Override
	public Map<String, Object> purgeBasedOnBeforeMonth(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().delete("purgeBasedOnBeforeMonth", params);
		return params;
	}

	@Override
	public Map<String, Object> purgeBasedOnBeforeDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().delete("purgeBasedOnBeforeDate", params);
		return params;
	}
	
	@Override
	public Map<String, Object> purgeBasedExactMonth(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().delete("purgeBasedExactMonth", params);
		return params;
	}
	
	@Override
	public Map<String, Object> purgeBasedExactDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().delete("purgeBasedExactDate", params);
		return params;
	}
	
	@Override
	public Map<String, Object> checkNoOfRecordsToPurge(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkNoOfRecordsToPurge", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getPolicyIdGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPolicyIdGiexs006", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiex004InitialVariables() throws SQLException {
		log.info("GETTING GIIEX004 INITIAL VARIABLES");
		return (Map<String, Object>) getSqlMapClient().queryForObject("getGiex004InitialVariables");
	}

	@Override
	public void giexs004ProcessPostButton(Map<String, Object> params)
			throws SQLException {
		log.info("executing giexs004ProcessPostButton, params: "+params);
		
		try{
			getSqlMapClient().update("giexs004ProcessPostButton",params);
		}catch(SQLException e){
			throw e;
		}
	}

	@Override
	public void giexs004ProcessRenewal(Map<String, Object> params)
			throws SQLException {
		try{
			log.info("executing giexs004ProcessRenewal, params: "+params);
			getSqlMapClient().update("giexs004ProcessRenewal", params);
		}catch (SQLException e) {
			throw e;
		}
		
	}

	@Override
	public void giexs004ProcessPolicies(Map<String, Object> params)
			throws SQLException {
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			@SuppressWarnings("unchecked")
			List<Integer> policyIds = this.getSqlMapClient().queryForList("getPolIdForProcess", params);
			String strPolicyIds = policyIds.toString();
			String polIds = strPolicyIds.substring(1, strPolicyIds.length()-1);
			Debug.print(polIds);
			log.info("EXECUTING giexs004ProcessPolicies");
			this.sqlMapClient.update("giexs004ProcessPolicies", params);
			params.put("policyIds", polIds);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String updateExpiryRecord(Map<String, Object> params) throws SQLException {
		log.info("Assign expiry...");
		
		String message = "Assigned";
		List<GIEXExpiriesV> setRows = (List<GIEXExpiriesV>) params.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIEXExpiriesV set : setRows) {
				this.sqlMapClient.insert("updateExpiryRecord", set);
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
		return message;
	}
	
	@Override
	public String updateExpiriesByBatch(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try{
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateExpiriesByBatch", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}
	
	@Override
	public Integer checkExtractUserAccess(Map<String, Object> params) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkExtractUserAccess", params);
	}

	@Override
	public String checkRecords(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkRecords", params);
	}

	@Override
	public String checkSubline(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkSubline", params);
	}

}

