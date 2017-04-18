package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISEngPrincipalDAO;
import com.geniisys.common.entity.GIISEngPrincipal;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEngPrincipalDAOImpl implements GIISEngPrincipalDAO {

	private SqlMapClient sqlMapClient;
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss068(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISEngPrincipal> delList = (List<GIISEngPrincipal>) params.get("delRows");
			for(GIISEngPrincipal d: delList){
				this.sqlMapClient.update("delEngPrincipal", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISEngPrincipal> setList = (List<GIISEngPrincipal>) params.get("setRows");
			for(GIISEngPrincipal s: setList){
				this.sqlMapClient.update("setEngPrincipal", s);
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
		this.sqlMapClient.update("valDeleteEngPrincipal", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddEngPrincipal", params);
	}

}
