package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLMcDepreciationDAO;
import com.geniisys.gicl.entity.GICLMcDepreciation;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMcDepreciationDAOImpl implements GICLMcDepreciationDAO{
private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls059(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLMcDepreciation> delList = (List<GICLMcDepreciation>) params.get("delRows");
			for(GICLMcDepreciation d: delList){
				this.sqlMapClient.update("delGICLMcDepreciation", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLMcDepreciation> setList = (List<GICLMcDepreciation>) params.get("setRows");
			for(GICLMcDepreciation s: setList){
				this.sqlMapClient.update("setGICLMcDepreciation", s);
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGICLMcDepreciation", params);		
	}
}
