package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISNationalityDAO;
import com.geniisys.common.entity.GIISNationality;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISNationalityDAOImpl implements GIISNationalityDAO {
	
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
	public void saveGicls184(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISNationality> delList = (List<GIISNationality>) params.get("delRows");
			for(GIISNationality d: delList){
				this.sqlMapClient.update("delNationality", d.getNationalityCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISNationality> setList = (List<GIISNationality>) params.get("setRows");
			for(GIISNationality s: setList){
				this.sqlMapClient.update("setNationality", s);
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
		this.sqlMapClient.update("valDeleteNationality", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddNationality", recId);		
	}
}
