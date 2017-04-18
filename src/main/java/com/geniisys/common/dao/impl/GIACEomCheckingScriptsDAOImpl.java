package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIACEomCheckingScriptsDAO;
import com.geniisys.common.entity.GIACEomCheckingScripts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACEomCheckingScriptsDAOImpl implements GIACEomCheckingScriptsDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveGiacs352(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACEomCheckingScripts> delList = (List<GIACEomCheckingScripts>) params.get("delRows");
			for(GIACEomCheckingScripts d : delList){
				this.sqlMapClient.update("delEomCheckingScript", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIACEomCheckingScripts> setList = (List<GIACEomCheckingScripts>) params.get("setRows");
			for(GIACEomCheckingScripts s: setList){
				this.sqlMapClient.update("setEomCheckingScript", s);
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
	
}
