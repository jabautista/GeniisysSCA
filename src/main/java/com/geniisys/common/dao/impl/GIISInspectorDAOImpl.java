package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISInspectorDAO;
import com.geniisys.common.entity.GIISInspector;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISInspectorDAOImpl implements GIISInspectorDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISInspector> getInspectorListing(String keyword)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getInspectorListing", keyword);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss169(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISInspector> delList = (List<GIISInspector>) params.get("delRows");
			for(GIISInspector d: delList){
				this.sqlMapClient.update("delInsp", d.getInspCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISInspector> setList = (List<GIISInspector>) params.get("setRows");
			for(GIISInspector s: setList){
				this.sqlMapClient.update("setInsp", s);
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
		this.sqlMapClient.update("valDeleteInsp", recId);
	}

	@Override
	public void valAddRec(String inspName) throws SQLException {
		this.sqlMapClient.update("valAddInsp", inspName);		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISInspector> getInspNameList() throws SQLException {
		return this.sqlMapClient.queryForList("getInspNameListGiiss169");
	}
}
