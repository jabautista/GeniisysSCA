package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISIndustryGroup;
import com.geniisys.giis.dao.GIISIndustryGroupDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIndustryGroupDAOImpl implements GIISIndustryGroupDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddIndustryGroup", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelIndustryGroup", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss205(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISIndustryGroup> delList = (List<GIISIndustryGroup>) params.get("delRows");
			for(GIISIndustryGroup d : delList){
				this.sqlMapClient.update("delIndustryGroup", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISIndustryGroup> setList = (List<GIISIndustryGroup>) params.get("setRows");
			for(GIISIndustryGroup s: setList){
				this.sqlMapClient.update("setIndustryGroup", s);
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
}
