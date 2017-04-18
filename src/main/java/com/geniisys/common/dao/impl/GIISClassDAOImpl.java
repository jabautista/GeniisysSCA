package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISClassDAO;
import com.geniisys.common.entity.GIISClass;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISClassDAOImpl implements GIISClassDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss063(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISClass> delList = (List<GIISClass>) params.get("delRows");
			for(GIISClass d: delList){
				this.sqlMapClient.update("delClass", d.getClassCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISClass> setList = (List<GIISClass>) params.get("setRows");
			for(GIISClass s: setList){
				this.sqlMapClient.update("setClass", s);
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
		this.sqlMapClient.update("valDeleteClass", recId);
	}
	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddClass", recId);		
	}
	@Override
	public void valAddRec2(String recDesc) throws SQLException {
		this.sqlMapClient.update("valAddClass2", recDesc);
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
}
