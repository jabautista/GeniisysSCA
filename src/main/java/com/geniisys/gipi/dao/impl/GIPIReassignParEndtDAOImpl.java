package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIReassignParEndtDAO;
import com.geniisys.gipi.entity.GIPIReassignParEndt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIReassignParEndtDAOImpl implements GIPIReassignParEndtDAO{

	private static Logger log = Logger.getLogger(GIPIReassignParEndtDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String checkUser(Map<String, Object> params) throws SQLException {
		log.info("Checking User...");
		log.info("User ID: "+ params.get("userId") + "Underwriter: "+params.get("underwriter"));
		return (String) this.getSqlMapClient().queryForObject("checkUserGIPIS057",params);
	}
	
	@Override
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> saveReassignParEndt(Map<String, Object> params)
			throws SQLException {
		
		try {
			List<GIPIReassignParEndt> insParams = (List<GIPIReassignParEndt>) params.get("insParams");
			List<Map<String, Object>> postFormParams = (List<Map<String, Object>>) params.get("postFormParams");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
	
			if(insParams != null){
				for(GIPIReassignParEndt reassignParEndt: insParams){
					System.out.println("PAR ID: "+ reassignParEndt.getParId());
					this.getSqlMapClient().insert("saveReassignParEndt", reassignParEndt);
				}
				log.info("DAO - Reassign Par Endorsement inserted.");
			}
			//Post Form Commit
			System.out.println("postFormParams: " + postFormParams.toString());
			if(postFormParams != null){
				for (Map<String, Object> map : postFormParams) {
					System.out.println("PAR ID: "+ map.get("parId"));
					this.getSqlMapClient().insert("createTransferWorkflow",map);
					log.info("DAO - Post Form Commit finished.");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return postFormParams;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
}

