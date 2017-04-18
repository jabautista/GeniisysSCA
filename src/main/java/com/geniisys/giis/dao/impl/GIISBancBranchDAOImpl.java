package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISBancBranch;
import com.geniisys.giis.dao.GIISBancBranchDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBancBranchDAOImpl implements GIISBancBranchDAO{
	
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
	public void saveGiiss216(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss216");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISBancBranch> setList = (List<GIISBancBranch>) params.get("setRows");
			for(GIISBancBranch s: setList){
				this.sqlMapClient.update("saveGiiss216", s);
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
	public void valAddRecGiiss216(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRecGiiss216", params);
	}

}
