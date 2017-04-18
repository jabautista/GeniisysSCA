package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISIntmTypeComrtDAO;
import com.geniisys.common.entity.GIISIntmTypeComrt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIntmTypeComrtDAOImpl implements GIISIntmTypeComrtDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void saveGiiss084(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISIntmTypeComrt> delList = (List<GIISIntmTypeComrt>) params.get("delRows");
			for(GIISIntmTypeComrt d : delList){
				this.sqlMapClient.update("delCoIntmTypeComrt", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			@SuppressWarnings("unchecked")
			List<GIISIntmTypeComrt> setList = (List<GIISIntmTypeComrt>) params.get("setRows");
			for(GIISIntmTypeComrt s: setList){
				System.out.println("Co-Intm Type Comm Rate save parameters dao : " + s);
				this.sqlMapClient.update("setCoIntmTypeComrt", s);
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giiss084ValAddRec", params);
	}
}
