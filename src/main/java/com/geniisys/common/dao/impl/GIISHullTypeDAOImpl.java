package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISHullTypeDAO;
import com.geniisys.common.entity.GIISHullType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISHullTypeDAOImpl implements GIISHullTypeDAO{
	
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
	public void saveGiiss046(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISHullType> delList = (List<GIISHullType>) params.get("delRows");
			for(GIISHullType d: delList){
				this.sqlMapClient.update("delHullType", d.getHullTypeCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISHullType> setList = (List<GIISHullType>) params.get("setRows");
			for(GIISHullType s: setList){
				this.sqlMapClient.update("setHullType", s);
			}
			
			System.out.println(params);
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
	public void valDeleteRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valDeleteHullType", recId);
	}

	@Override
	public void valAddRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valAddHullType", recId);		
	}
}