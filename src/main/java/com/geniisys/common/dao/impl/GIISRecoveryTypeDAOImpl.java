package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISRecoveryTypeDAO;
import com.geniisys.common.entity.GIISRecoveryType;
import com.ibatis.sqlmap.client.SqlMapClient;
import common.Logger;

public class GIISRecoveryTypeDAOImpl implements GIISRecoveryTypeDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISRecoveryTypeDAO.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public Map<String, Object> getRecTypeDescGicls201(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Recovery Type Desc for GICLS201..."); 
		this.sqlMapClient.update("getRecTypeDescGicls201", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls101(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRecoveryType> delList = (List<GIISRecoveryType>) params.get("delRows");
			for(GIISRecoveryType d: delList){
				this.sqlMapClient.update("delRecoveryType", d.getRecTypeCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRecoveryType> setList = (List<GIISRecoveryType>) params.get("setRows");
			for(GIISRecoveryType s: setList){
				this.sqlMapClient.update("setRecoveryType", s);
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
		this.sqlMapClient.update("valDeleteRecoveryType", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddRecoveryType", recId);		
	}

}
