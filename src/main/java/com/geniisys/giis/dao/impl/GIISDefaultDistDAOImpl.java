package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giis.dao.GIISDefaultDistDAO;
import com.geniisys.giis.entity.GIISDefaultDist;
import com.geniisys.giis.entity.GIISDefaultDistPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISDefaultDistDAOImpl implements GIISDefaultDistDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss165(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer defaultNo = null;
			
			List<GIISDefaultDist> delList = (List<GIISDefaultDist>) params.get("delRows");
			for(GIISDefaultDist d: delList){
				this.getSqlMapClient().update("delDefaultDist", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISDefaultDist> setList = (List<GIISDefaultDist>) params.get("setRows");
			for(GIISDefaultDist s: setList){
				if(s.getDefaultNo() == null){
					Integer defaultNoNextVal = (Integer) this.getSqlMapClient().queryForObject("getDefaultNoNextVal");
					s.setDefaultNo(defaultNoNextVal);
				}
				this.getSqlMapClient().update("setDefaultDist", s);
				
				if(s.getChildTag().toString().equals("Y")){
					defaultNo = s.getDefaultNo();
				}
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISDefaultDistPeril> delPerilList = (List<GIISDefaultDistPeril>) params.get("delPerilRows");
			for(GIISDefaultDistPeril d: delPerilList){
				this.getSqlMapClient().update("delDefaultDistPeril", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISDefaultDistPeril> setPerilList = (List<GIISDefaultDistPeril>) params.get("setPerilRows");
			for(GIISDefaultDistPeril s: setPerilList){
				if(s.getChildTag().toString().equals("Y")){
					s.setDefaultNo(defaultNo);
				}
				
				this.getSqlMapClient().update("setDefaultDistPeril", s);
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
	public void valDeleteRec(Integer defaultNo) throws SQLException {
		this.getSqlMapClient().update("giiss165ValDeleteRec", defaultNo);
	}

	@Override
	public void checkDistRecords(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkGiiss165DistRecords", params);
	}

	@Override
	public Map<String, Object> getDistPerilVariables(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getDistPerilVariables", params);
		return params;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giss165ValAddRec", params);
	}
	
}
