package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTypeOfBodyDAO;
import com.geniisys.common.entity.GIISTypeOfBody;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTypeOfBodyDAOImpl implements GIISTypeOfBodyDAO {
	
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
	public void saveGiiss117(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTypeOfBody> delList = (List<GIISTypeOfBody>) params.get("delRows");
			for(GIISTypeOfBody d: delList){
				this.sqlMapClient.update("delBodyType", d.getTypeOfBodyCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTypeOfBody> setList = (List<GIISTypeOfBody>) params.get("setRows");
			for(GIISTypeOfBody s: setList){
				this.sqlMapClient.update("setBodyType", s);
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
	public String valDeleteRec(String airTypeCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteBodyType", airTypeCd);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddBodyType", recId);		
	}
}
