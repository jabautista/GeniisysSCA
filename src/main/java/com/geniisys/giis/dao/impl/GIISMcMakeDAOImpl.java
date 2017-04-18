package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISMCEngineSeries;
import com.geniisys.common.entity.GIISMCMake;
import com.geniisys.giis.dao.GIISMcMakeDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMcMakeDAOImpl implements GIISMcMakeDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS103(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISMCMake> delList = (List<GIISMCMake>) params.get("delRows");
			for(GIISMCMake d: delList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("makeCd", d.getMakeCd());
				delParams.put("carCompanyCd", d.getCarCompanyCd());
				this.getSqlMapClient().update("delMcMake", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISMCMake> setList = (List<GIISMCMake>) params.get("setRows");
			for(GIISMCMake s: setList){
				this.getSqlMapClient().update("setMcMake", s);
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddMcMake", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteMcMake", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS103Engine(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISMCEngineSeries> delList = (List<GIISMCEngineSeries>) params.get("delRows");
			for(GIISMCEngineSeries d: delList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("makeCd", d.getMakeCd());
				delParams.put("carCompanyCd", d.getCarCompanyCd());
				delParams.put("seriesCd", d.getSeriesCd());
				this.getSqlMapClient().update("delMcEngine", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISMCEngineSeries> setList = (List<GIISMCEngineSeries>) params.get("setRows");
			for(GIISMCEngineSeries s: setList){
				this.getSqlMapClient().update("setMcEngine", s);
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
	public void valAddEngine(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddMcEngine", params);
	}

	@Override
	public void valDeleteEngine(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteMcEngine", params);
	}
	
}
