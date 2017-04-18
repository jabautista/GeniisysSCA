package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACPaytReqDocDAO;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPaytReqDocDAOImpl implements GIACPaytReqDocDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public void saveGiacs306(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACPaytReqDocs> delList = (List<GIACPaytReqDocs>) params.get("delRows");
			for(GIACPaytReqDocs d: delList){
				this.sqlMapClient.delete("delPaytReqDoc", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACPaytReqDocs> setList = (List<GIACPaytReqDocs>) params.get("setRows");
			for(GIACPaytReqDocs s: setList){
				this.sqlMapClient.update("setPaytReqDoc", s);
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

	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeletePaytReqDoc", params);
	}

	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddPaytReqDoc", params);	
	}
}
