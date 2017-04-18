package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gism.dao.GISMRecipientGroupDAO;
import com.geniisys.gism.entity.GISMRecipientGroup;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMRecipientGroupDAOImpl implements GISMRecipientGroupDAO {
	
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
	public void saveGisms003(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GISMRecipientGroup> delList = (List<GISMRecipientGroup>) params.get("delRows");
			for(GISMRecipientGroup d: delList){
				this.sqlMapClient.update("delRecipientGroup", d.getGroupCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GISMRecipientGroup> setList = (List<GISMRecipientGroup>) params.get("setRows");
			for(GISMRecipientGroup s: setList){
				this.sqlMapClient.update("setRecipientGroup", s);
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
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteRecipientGroup", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddRecipientGroup", recId);		
	}
}
