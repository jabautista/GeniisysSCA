package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.dao.GIISIntreatyDAO;
import com.geniisys.giis.entity.GIISIntreaty;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIntreatyDAOImpl implements GIISIntreatyDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		System.out.println("Validating Intreaty to add :::::::::::::::::::::: " + params);
		this.sqlMapClient.update("valAddIntreaty", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		System.out.println("Validating Intreaty to delete :::::::::::::::::::::: " + params);
		this.sqlMapClient.update("valDeleteIntreaty", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss032(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISIntreaty> delList = (List<GIISIntreaty>) params.get("delRows");
			for(GIISIntreaty d : delList){
				this.sqlMapClient.update("delIntreaty", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISIntreaty> setList = (List<GIISIntreaty>) params.get("setRows");
			for(GIISIntreaty s: setList){
				this.sqlMapClient.update("setIntreaty", s);
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
