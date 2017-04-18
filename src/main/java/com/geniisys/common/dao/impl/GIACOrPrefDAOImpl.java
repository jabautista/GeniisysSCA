package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIACOrPrefDAO;
import com.geniisys.common.entity.GIACOrPref;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACOrPrefDAOImpl implements GIACOrPrefDAO {
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs355(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACOrPref> delList = (List<GIACOrPref>) params.get("delRows");
			for(GIACOrPref d: delList){
				this.sqlMapClient.update("delOrPref", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACOrPref> setList = (List<GIACOrPref>) params.get("setRows");
			for(GIACOrPref s: setList){
				this.sqlMapClient.update("setOrPref", s);
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
		this.sqlMapClient.update("valDeleteOrPref", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddOrPref", params);
	}

}
