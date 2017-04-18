/**
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACModuleEntryDAO;
import com.geniisys.giac.entity.GIACModuleEntry;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACModuleEntryDAOImpl implements GIACModuleEntryDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs321(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			/*List<GIACModuleEntry> delList = (List<GIACModuleEntry>) params.get("delRows");
			for(GIACModuleEntry d: delList){
				this.sqlMapClient.update("delModuleEntry", d);
			}
			this.sqlMapClient.executeBatch();*/
			
			List<GIACModuleEntry> setList = (List<GIACModuleEntry>) params.get("setRows");
			for(GIACModuleEntry s: setList){
				this.sqlMapClient.update("setModuleEntry", s);
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
		this.sqlMapClient.update("valDelRec", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRec", params);	
	}

}
