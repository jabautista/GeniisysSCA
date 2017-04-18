package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISNotaryPublic;
import com.geniisys.giis.dao.GIISNotaryPublicDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISNotaryPublicDAOImpl implements GIISNotaryPublicDAO{

	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void saveGiiss016(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss016");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISNotaryPublic> delList = (List<GIISNotaryPublic>) params.get("delRows");
			for(GIISNotaryPublic d: delList){
				this.sqlMapClient.update("giiss016DelRec", String.valueOf(d.getNpNo()));
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISNotaryPublic> setList = (List<GIISNotaryPublic>) params.get("setRows");
			for(GIISNotaryPublic s: setList){
				this.sqlMapClient.update("setGiiss016", s);
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
	public void giiss016ValDelRec(String npNo) throws SQLException {
		this.sqlMapClient.update("giiss016ValDelRec", npNo);		
	}
	
}
