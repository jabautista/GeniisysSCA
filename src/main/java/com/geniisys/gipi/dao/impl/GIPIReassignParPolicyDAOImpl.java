package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIReassignParPolicyDAO;
import com.geniisys.gipi.entity.GIPIReassignParPolicy;
import com.ibatis.sqlmap.client.SqlMapClient;


public class GIPIReassignParPolicyDAOImpl implements GIPIReassignParPolicyDAO{

	private static Logger log = Logger.getLogger(GIPIReassignParPolicyDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveReassignParPolicy(Map<String, Object> parameters)
			throws Exception {
		
		List<GIPIReassignParPolicy> insParams = (List<GIPIReassignParPolicy>) parameters.get("insParams");
		try {
		this.getSqlMapClient().startTransaction();
		this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
		this.getSqlMapClient().startBatch();


		if(insParams != null){
			for(GIPIReassignParPolicy reassignParPolicy: insParams){
				this.getSqlMapClient().insert("setReassignParPolicy", reassignParPolicy);
			}
		log.info("DAO - Reassign Par Policy inserted");
		}


		this.getSqlMapClient().executeBatch();
		this.getSqlMapClient().getCurrentConnection().commit();
		log.info("Updating Reassign Par Policy successful.");
		} catch (SQLException e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
}
