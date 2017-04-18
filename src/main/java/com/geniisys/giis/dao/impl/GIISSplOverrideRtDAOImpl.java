package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISSplOverrideRt;
import com.geniisys.giis.dao.GIISSplOverrideRtDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSplOverrideRtDAOImpl implements GIISSplOverrideRtDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String getGiiss202SelectedPerils(Map<String, Object> params)
			throws SQLException, Exception {
		return (String) this.getSqlMapClient().queryForObject("getGiiss202SelectedPerils", params);
	}

	@Override
	public void saveGiiss202(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss202");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISSplOverrideRt> delList = (List<GIISSplOverrideRt>) params.get("delRows");
			for(GIISSplOverrideRt d: delList){
				this.sqlMapClient.update("delGiiss202", d);
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISSplOverrideRt> setList = (List<GIISSplOverrideRt>) params.get("setRows");
			for(GIISSplOverrideRt s: setList){
				this.sqlMapClient.update("setGiiss202", s);
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
	public void populateGiiss202(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("populateGiiss202", params);
	}

	@Override
	public void copyGiiss202(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("copyGiiss202", params);
	}

}
