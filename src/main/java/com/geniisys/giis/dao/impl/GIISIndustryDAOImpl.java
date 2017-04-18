package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISIndustry;
import com.geniisys.giis.dao.GIISIndustryDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIndustryDAOImpl implements GIISIndustryDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void saveGiiss014(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss014");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISIndustry> delList = (List<GIISIndustry>) params.get("delRows");
			for(GIISIndustry d: delList){
				this.sqlMapClient.update("delIndustry", String.valueOf(d.getIndustryCd()));
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISIndustry> setList = (List<GIISIndustry>) params.get("setRows");
			for(GIISIndustry s: setList){
				this.sqlMapClient.update("setIndustry", s);
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
		this.sqlMapClient.update("valDeleteIndustry", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddIndustry", recId);
	}

	@Override
	public void valUpdateRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valUpdateIndustry", params);
	}
	
}
