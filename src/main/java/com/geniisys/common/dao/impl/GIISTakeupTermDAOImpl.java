package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTakeupTermDAO;
import com.geniisys.common.entity.GIISTakeupTerm;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTakeupTermDAOImpl implements GIISTakeupTermDAO{

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
	public void saveGiiss211(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTakeupTerm> delList = (List<GIISTakeupTerm>) params.get("delRows");
			for(GIISTakeupTerm d: delList){
				this.sqlMapClient.update("delTakeupTerm", d.getTakeupTerm());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTakeupTerm> setList = (List<GIISTakeupTerm>) params.get("setRows");
			for(GIISTakeupTerm s: setList){
				this.sqlMapClient.update("setTakeupTerm", s);
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
	public void valDeleteRec(String takeupTerm) throws SQLException {
		this.sqlMapClient.update("valDeleteTakeupTerm", takeupTerm);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddTakeupTerm", params);		
	}
}
