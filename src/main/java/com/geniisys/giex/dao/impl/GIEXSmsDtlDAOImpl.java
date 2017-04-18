package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giex.dao.GIEXSmsDtlDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXSmsDtlDAOImpl implements GIEXSmsDtlDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIEXSmsDtlDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public Map<String, Object> checkSMSAssured(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkSMSAssured", params);
		return params;
	}
	
	@Override
	public Map<String, Object> checkSMSIntm(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkSMSIntm", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void updateSMSTags(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIEXExpiry> rows = (List<GIEXExpiry>) params.get("rows");
			for (GIEXExpiry row : rows){
				System.out.println("LOOP: " + row.getAssdSms() + " and " + row.getIntmSms() + " and policy id: " + row.getPolicyId());
				Map<String, Object> rowParams = new HashMap<String, Object>();
				rowParams.put("policyId", row.getPolicyId());
				rowParams.put("assdSms", row.getAssdSms());
				rowParams.put("intmSms", row.getIntmSms());
				this.getSqlMapClient().update("updateSMSTags", rowParams);
			}
			this.getSqlMapClient().executeBatch();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void sendSMS(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIEXExpiry> rows = (List<GIEXExpiry>) params.get("rows");
			for (GIEXExpiry row : rows){
				System.out.println("policy: " + row.getPolicyId() + " = assdSms: " + row.getAssdSms() + " and intmSMS: " + row.getIntmSms());
				Map<String, Object> rowParams = new HashMap<String, Object>();
				rowParams.put("policyId", row.getPolicyId());
				rowParams.put("assdSms", row.getAssdSms());
				rowParams.put("intmSms", row.getIntmSms());
				this.getSqlMapClient().update("updateSMSTags", rowParams);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().insert("generateSMS", params.get("userId"));
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveSMS(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving SMS Renewal...");
			List<GIEXExpiry> rows = (List<GIEXExpiry>) params.get("rows");
			for(GIEXExpiry row : rows){
				Map<String, Object> setParams = new HashMap<String, Object>();
				setParams.put("policyId", row.getPolicyId());
				setParams.put("renewFlag", row.getRenewFlag());
				setParams.put("remarks", row.getRemarks());
				this.getSqlMapClient().insert("saveSMSRenewal", setParams);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

}
