package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACJvTranDAO;
import com.geniisys.giac.entity.GIACJvTran;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACJvTranDAOImpl implements GIACJvTranDAO {
	
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
	public void saveGiacs323(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACJvTran> delList = (List<GIACJvTran>) params.get("delRows");
			for(GIACJvTran d: delList){
				this.sqlMapClient.update("delJvTran", d.getJvTranCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACJvTran> setList = (List<GIACJvTran>) params.get("setRows");
			for(GIACJvTran s: setList){
				this.sqlMapClient.update("setJvTran", s);
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
		this.sqlMapClient.update("valDeleteJvTran", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddJvTran", recId);		
	}
}
