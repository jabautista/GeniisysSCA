package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giis.dao.GIISSlidCommDAO;
import com.geniisys.giis.entity.GIISSlidComm;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSlidCommDAOImpl implements GIISSlidCommDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void checkRate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("checkRateGIISS220", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS220(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISSlidComm> delList = (List<GIISSlidComm>) params.get("delRows");
			for(GIISSlidComm d: delList){
				this.getSqlMapClient().update("delSlidComm", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISSlidComm> setList = (List<GIISSlidComm>) params.get("setRows");
			for(GIISSlidComm s: setList){
				this.getSqlMapClient().update("setSlidComm", s);
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

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRateList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getSlidCommRateList", params) ;
	}
	
}
