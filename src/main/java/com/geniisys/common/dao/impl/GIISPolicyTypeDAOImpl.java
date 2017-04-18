package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISPolicyTypeDAO;
import com.geniisys.common.entity.GIISPolicyType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPolicyTypeDAOImpl implements GIISPolicyTypeDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddPolicyType", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGiiss091(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISPolicyType> delList = (List<GIISPolicyType>) params.get("delRows");
			for(GIISPolicyType d : delList){
				this.sqlMapClient.update("delPolicyType", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISPolicyType> setList = (List<GIISPolicyType>) params.get("setRows");
			for(GIISPolicyType s: setList){
				System.out.println("Policy type save parameters dao : " + s);
				this.sqlMapClient.update("setPolicyType", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelPolicyType", params);
	}

	@Override
	public void valTypeDesc(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valTypeDesc", params);
	}
}
