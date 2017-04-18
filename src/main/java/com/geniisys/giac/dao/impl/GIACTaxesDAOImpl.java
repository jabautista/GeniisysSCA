package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACTaxesDAO;
import com.geniisys.giac.entity.GIACTaxes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTaxesDAOImpl implements GIACTaxesDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteGIACTaxes", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddGIACTaxes", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIACS320(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIACTaxes> delList = (List<GIACTaxes>) params.get("delRows");
			for(GIACTaxes d: delList){
				this.getSqlMapClient().update("delGIACTaxes", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIACTaxes> setList = (List<GIACTaxes>) params.get("setRows");
			for(GIACTaxes s: setList){
				this.getSqlMapClient().update("setGIACTaxes", s);
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
	public Integer checkAccountCode(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkAccountCode", params);
	}
	
}
