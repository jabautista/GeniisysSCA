package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISSectionOrHazardDAO;
import com.geniisys.common.entity.GIISSectionOrHazard;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSectionOrHazardDAOImpl implements GIISSectionOrHazardDAO {
	
	/** The SQl Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIISReinsurerDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss020(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISSectionOrHazard> delList = (List<GIISSectionOrHazard>) params.get("delRows");
			for(GIISSectionOrHazard d: delList){
				this.sqlMapClient.update("delSectionOrHazardGiiss020", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISSectionOrHazard> setList = (List<GIISSectionOrHazard>) params.get("setRows");
			for(GIISSectionOrHazard s: setList){
				this.sqlMapClient.update("setSectionOrHazardGiiss020", s);
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
		this.sqlMapClient.update("valDeleteSectionOrHazard", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddSectionOrHazard", params);		
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteSectionOrHazard", params);		
	}
}
