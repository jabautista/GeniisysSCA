package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISNonRenewReasonDAO;
import com.geniisys.common.entity.GIISNonRenewReason;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISNonRenewReasonDAOImpl implements GIISNonRenewReasonDAO{
	
	private SqlMapClient sqlMapClient;

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
	public Map<String, Object> validateReasonCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateReasonCd", params);
		Debug.print(params);
		return params ;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss210(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISNonRenewReason> delList = (List<GIISNonRenewReason>) params.get("delRows");
			for(GIISNonRenewReason d: delList){
				this.sqlMapClient.update("delNonRenewReason", d.getNonRenReasonCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISNonRenewReason> setList = (List<GIISNonRenewReason>) params.get("setRows");
			for(GIISNonRenewReason s: setList){
				this.sqlMapClient.update("setNonRenewReason", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteNonRenewReason", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddNonRenewReason", params);		
	}

}
