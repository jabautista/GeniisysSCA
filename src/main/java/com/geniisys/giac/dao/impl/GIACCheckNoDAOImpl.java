package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giac.dao.GIACCheckNoDAO;
import com.geniisys.giac.entity.GIACCheckNo;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCheckNoDAOImpl implements GIACCheckNoDAO{

	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void checkBranchForCheck(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkBranchForCheck", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddGIACS326", params);
	}

	@Override
	public void valDelRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDelGIACS326", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIACS326(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIACCheckNo> delList = (List<GIACCheckNo>) params.get("delRows");
			for(GIACCheckNo d: delList){
				this.getSqlMapClient().update("delGIACCheckNo", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIACCheckNo> setList = (List<GIACCheckNo>) params.get("setRows");
			for(GIACCheckNo s: setList){
				this.getSqlMapClient().update("setGIACCheckNo", s);
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
	
}
