package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giis.dao.GIISIntmSpecialRateDAO;
import com.geniisys.giis.entity.GIISIntmSpecialRate;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIntmSpecialRateDAOImpl implements GIISIntmSpecialRateDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void populatePerils(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giiss082populatePerils", params);
	}

	@Override
	public void copyIntmRate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("copyIntmRate", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS082(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISIntmSpecialRate> delList = (List<GIISIntmSpecialRate>) params.get("delRows");
			for(GIISIntmSpecialRate d: delList){
				this.getSqlMapClient().update("delIntmSpecialRate", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISIntmSpecialRate> setList = (List<GIISIntmSpecialRate>) params.get("setRows");
			for(GIISIntmSpecialRate s: setList){
				this.getSqlMapClient().update("setIntmSpecialRate", s);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String getPerilList(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGIISS082PerilList", params);
	}
	
}
