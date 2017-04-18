package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISEndtTextDAO;
import com.geniisys.common.entity.GIISEndtText;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEndtTextDAOImpl implements GIISEndtTextDAO{

	public SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWEndtText> getEndtTextList(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getEndtTextList", params);
	}
	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddEndtText", params);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public void saveGiiss104(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISEndtText> delList = (List<GIISEndtText>) params.get("delRows");
			for(GIISEndtText d : delList){
				this.sqlMapClient.update("delEndtText", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISEndtText> setList = (List<GIISEndtText>) params.get("setRows");
			for(GIISEndtText s: setList){
				this.sqlMapClient.update("setAddEndtText", s);
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
	
	//Gzelle 02062015
	@Override
	public void valDelRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDelEndtText", recId);
	}
	
}
