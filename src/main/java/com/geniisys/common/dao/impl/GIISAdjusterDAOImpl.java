package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISAdjusterDAO;
import com.geniisys.common.entity.GIISAdjuster;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISAdjusterDAOImpl implements GIISAdjusterDAO {
	
	private SqlMapClient sqlMapClient;

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls210(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISAdjuster> delList = (List<GIISAdjuster>) params.get("delRows");
			for(GIISAdjuster d: delList){
				this.sqlMapClient.update("delAdjuster", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISAdjuster> setList = (List<GIISAdjuster>) params.get("setRows");
			for(GIISAdjuster s: setList){
				this.sqlMapClient.update("setAdjuster", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteAdjuster", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddAdjuster", params);
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Integer getLastPrivAdjNo(Integer adjCompanyCd) throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getLastPrivAdjNo", adjCompanyCd);
	}

}
