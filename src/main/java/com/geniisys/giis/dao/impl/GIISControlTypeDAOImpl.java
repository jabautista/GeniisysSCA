package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giis.dao.GIISControlTypeDAO;
import com.geniisys.giis.entity.GIISControlType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISControlTypeDAOImpl implements GIISControlTypeDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS108(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISControlType> delList = (List<GIISControlType>) params.get("delRows");
			for(GIISControlType d: delList){
				this.getSqlMapClient().update("delControlType", d.getControlTypeCd());
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISControlType> setList = (List<GIISControlType>) params.get("setRows");
			for(GIISControlType s: setList){
				this.getSqlMapClient().update("setControlType", s);
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
		this.getSqlMapClient().update("valAddControlType", params);
	}

	@Override
	public void valDelRec(String controlTypeCd) throws SQLException {
		this.getSqlMapClient().update("valDelControlType", controlTypeCd);
	}
	
}
