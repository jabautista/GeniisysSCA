package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISBondClassClauseDAO;
import com.geniisys.common.entity.GIISBondClassClause;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBondClassClauseDAOImpl implements GIISBondClassClauseDAO {
	
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
	public void saveGiiss099(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISBondClassClause> delList = (List<GIISBondClassClause>) params.get("delRows");
			for(GIISBondClassClause d: delList){
				this.sqlMapClient.update("delBondClassClause", d.getClauseType());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBondClassClause> setList = (List<GIISBondClassClause>) params.get("setRows");
			for(GIISBondClassClause s: setList){
				this.sqlMapClient.update("setBondClassClause", s);
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
		this.sqlMapClient.update("valDeleteBondClassClause", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddBondClassClause", recId);		
	}
}
