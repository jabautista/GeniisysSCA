package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISBancArea;
import com.geniisys.giis.dao.GIISBancAreaDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBancAreaDAOImpl implements GIISBancAreaDAO{
	
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
	public void saveGiiss215(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISBancArea> setList = (List<GIISBancArea>) params.get("setRows");
			for(GIISBancArea s: setList){
				this.sqlMapClient.update("saveGiiss215", s);
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
	public void giiss215ValAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giiss215ValAddRec", params);		
	}

}
