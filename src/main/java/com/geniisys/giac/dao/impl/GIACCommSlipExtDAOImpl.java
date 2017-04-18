package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.giac.dao.GIACCommSlipExtDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCommSlipExtDAOImpl implements GIACCommSlipExtDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACCommSlipExtDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void populateBatchCommSlip(Map<String, Object> params)
			throws SQLException {
		System.out.println("insert params comm slip nieko : " + params);
		this.getSqlMapClient().update("populateBatchCommSlip", params);
	}

	@Override
	public Map<String, Object> getCommSlipNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getCommSlipNo", params);
		return params;
	}

	@Override
	public void tagAll(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("tagAllCommSlip", params);
	}

	@Override
	public void untagAll() throws SQLException {
		this.getSqlMapClient().update("untagAllCommSlip");
	}

	@Override
	public Map<String, Object> generateCommSlipNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("generateCommSlipNo", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGenerateFlag(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving Generate Flag...");
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> row : setRows){
				this.getSqlMapClient().update("saveGenerateFlag", row);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBatchCommSlipReports()
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBatchCommSlipReports");
	}

	@Override
	public Map<String, Object> updateCommSlip(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("updateCommSlip", params);
		return params;
	}

	@Override
	public void clearCommSlipNo(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("clearCommSlipNo", params);
	}
	
}
