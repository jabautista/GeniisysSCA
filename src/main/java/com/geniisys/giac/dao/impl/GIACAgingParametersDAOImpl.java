/**
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACAgingParametersDAO;
import com.geniisys.giac.entity.GIACAgingParameters;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAgingParametersDAOImpl implements GIACAgingParametersDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiacs310(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACAgingParameters> delList = (List<GIACAgingParameters>) params.get("delRows");
			for(GIACAgingParameters d: delList){
				this.sqlMapClient.update("delAgingParameters", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACAgingParameters> setList = (List<GIACAgingParameters>) params.get("setRows");
			for(GIACAgingParameters s: setList){
				this.sqlMapClient.update("setAgingParameters", s);
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
	public void copyRecords(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.update("copyRecordsGiacs310", params);			
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
