package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


import com.geniisys.gicl.dao.GICLReassignClaimRecordDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReassignClaimRecordDAOImpl implements GICLReassignClaimRecordDAO{
	public SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String updateClaimRecord(Map<String, Object> params)
			throws SQLException {
		String message = "Reassigned";
		List<GICLClaims> setRows = (List<GICLClaims>) params.get("setRows");
		
		try {
			System.out.println("here");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println("updateClaimRecord: "+params);
			
			for (GICLClaims set : setRows) {
				this.sqlMapClient.insert("updateClaimRecord", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(Exception e){	
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		} 
		return message;
	}

	@Override
	public String checkIfCanReassignClaim(String userId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkIfCanReassignClaim", userId);
	}
}
