package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gism.dao.GISMMessageTemplateDAO;
import com.geniisys.gism.entity.GISMMessageTemplate;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMMessageTemplateDAOImpl implements GISMMessageTemplateDAO {
	
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
	public void saveGisms002(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GISMMessageTemplate> delList = (List<GISMMessageTemplate>) params.get("delRows");
			for(GISMMessageTemplate d: delList){
				this.sqlMapClient.update("delMessageTemplate", d.getMessageCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GISMMessageTemplate> setList = (List<GISMMessageTemplate>) params.get("setRows");
			for(GISMMessageTemplate s: setList){
				this.sqlMapClient.update("setMessageTemplate", s);
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
		this.sqlMapClient.update("valDeleteMessageTemplate", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddMessageTemplate", recId);		
	}
}
