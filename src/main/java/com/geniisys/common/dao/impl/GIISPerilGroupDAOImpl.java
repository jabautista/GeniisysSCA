package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


import com.geniisys.common.dao.GIISPerilGroupDAO;
import com.geniisys.common.entity.GIISPerilGroup;
import com.geniisys.common.entity.GIISPerilGroupDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPerilGroupDAOImpl implements GIISPerilGroupDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss213(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISPerilGroup> delList = (List<GIISPerilGroup>) params.get("delRows");
			for(GIISPerilGroup d: delList){
				this.sqlMapClient.update("delPerilGroup", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPerilGroup> setList = (List<GIISPerilGroup>) params.get("setRows");
			for(GIISPerilGroup s: setList){
				this.sqlMapClient.update("setPerilGroup", s);
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
		this.sqlMapClient.update("valDeletePerilGroup", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddPerilGroup", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss213Dtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISPerilGroupDtl> delList = (List<GIISPerilGroupDtl>) params.get("delRows");
			for(GIISPerilGroupDtl d: delList){
				this.sqlMapClient.update("delPerilGroupDtl", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPerilGroupDtl> setList = (List<GIISPerilGroupDtl>) params.get("setRows");
			for(GIISPerilGroupDtl s: setList){
				this.sqlMapClient.update("setPerilGroupDtl", s);
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