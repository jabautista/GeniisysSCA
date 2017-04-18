package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.TreatyPerilsDAO;
import com.geniisys.common.entity.GIISTrtyPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class TreatyPerilsDAOImpl implements TreatyPerilsDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddA6401Rec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddA6401Rec", params);
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveA6401(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTrtyPeril> delList = (List<GIISTrtyPeril>) params.get("delRows");
			for(GIISTrtyPeril d : delList){
				this.sqlMapClient.update("delA6401", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISTrtyPeril> setList = (List<GIISTrtyPeril>) params.get("setRows");
			for(GIISTrtyPeril s: setList){
				this.sqlMapClient.update("setA6401", s);
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
	public void valAddTrtyPerilXolRec(Map<String, Object> params)
			throws SQLException {
		//this.sqlMapClient.update("valAddTrtyPerilXolRec", params); nieko 02142017, SR 23828
		this.sqlMapClient.update("valAddTrtyPerilXolRec2", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveTrtyPerilXol(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTrtyPeril> delList = (List<GIISTrtyPeril>) params.get("delRows");
			for(GIISTrtyPeril d : delList){
				this.sqlMapClient.update("delTrtyPerilXol", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISTrtyPeril> setList = (List<GIISTrtyPeril>) params.get("setRows");
			for(GIISTrtyPeril s: setList){
				this.sqlMapClient.update("setTrtyPerilXol", s);
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

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllPerils(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getAllTreatyPerils", params);
	}
	
}
