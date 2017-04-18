package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


import com.geniisys.gicl.dao.GICLMcPartCostDAO;
import com.geniisys.gicl.entity.GICLMcPartCost;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMcPartCostDAOImpl implements GICLMcPartCostDAO {
	
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
	public void saveGicls058(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLMcPartCost> delList = (List<GICLMcPartCost>) params.get("delRows");
			for(GICLMcPartCost d: delList){
				this.sqlMapClient.update("delMcPartCost", d.getPartCostId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLMcPartCost> setList = (List<GICLMcPartCost>) params.get("setRows");
			for(GICLMcPartCost s: setList){
				this.sqlMapClient.update("setMcPartCost", s);
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
		this.sqlMapClient.update("valDeleteMcPartCost", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddMcPartCost", params);		
	}

	@Override
	public String checkModelYear(Map<String, Object> params)throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valModelYear", params);
	}
}
