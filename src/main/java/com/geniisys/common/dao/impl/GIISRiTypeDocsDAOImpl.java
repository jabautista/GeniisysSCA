package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISRiTypeDocsDAO;
import com.geniisys.common.entity.GIISRiTypeDocs;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISRiTypeDocsDAOImpl implements GIISRiTypeDocsDAO {
	
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
	public void saveGiiss074(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRiTypeDocs> delList = (List<GIISRiTypeDocs>) params.get("delRows");
			for(GIISRiTypeDocs d: delList){
				this.sqlMapClient.update("delRiDocType", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRiTypeDocs> setList = (List<GIISRiTypeDocs>) params.get("setRows");
			for(GIISRiTypeDocs s: setList){
				this.sqlMapClient.update("setRiDocType", s);
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
	public String valDeleteRec(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteRiDocType", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRiDocType", params);		
	}
	
	@Override
	public Map<String, Object> validateRiType(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateRiType", params);
		return params;
	}
}
