package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISPayeeClassDAO;
import com.geniisys.common.entity.GIISPayeeClass;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPayeeClassDAOImpl implements GIISPayeeClassDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls140(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISPayeeClass> delList = (List<GIISPayeeClass>) params.get("delRows");
			for(GIISPayeeClass d: delList){
				this.sqlMapClient.update("delPayeeClass", d.getPayeeClassCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPayeeClass> setList = (List<GIISPayeeClass>) params.get("setRows");
			for(GIISPayeeClass s: setList){
				this.sqlMapClient.update("setPayeeClass", s);
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
		this.sqlMapClient.update("valDeletePayeeClass", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddPayeeClass", recId);		
	}
}
