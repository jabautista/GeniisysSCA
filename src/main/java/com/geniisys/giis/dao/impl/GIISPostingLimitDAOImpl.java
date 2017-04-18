package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.dao.GIISPostingLimitDAO;
import com.geniisys.giis.entity.GIISPostingLimit;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPostingLimitDAOImpl implements GIISPostingLimitDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String validateCopyUser(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateCopyUser", params);
	}
	
	@Override
	public String validateCopyBranch(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateCopyBranch", params);
	}

	@Override
	public String validateLineName(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateLineName", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void savePostingLimits(Map<String, Object> params) throws SQLException {
		try {
			List<GIISPostingLimit> setEvents = (List<GIISPostingLimit>) params.get("setEvents");
			List<GIISPostingLimit> delEvents = (List<GIISPostingLimit>) params.get("delEvents");
			this.sqlMapClient.startTransaction();			
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			for (GIISPostingLimit del : delEvents) {
				this.sqlMapClient.delete("deletePostingLimit", del);
			}
			for (GIISPostingLimit set : setEvents) {
				this.sqlMapClient.insert("savePostingLimits", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void saveCopyToAnotherUser(Map<String, Object> params) throws SQLException {
		try {
			this.sqlMapClient.startTransaction();			
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			Map<String, Object> copyParams = new HashMap<String, Object>();
				copyParams.put("appUser", params.get("appUser"));	//added by Gzelle 05.23.2013 - SR13166
				copyParams.put("copyToUser", params.get("copyToUser"));
				copyParams.put("copyToBranch", params.get("copyToBranch"));
				copyParams.put("copyFromUser", params.get("copyFromUser"));
				copyParams.put("copyFromBranch", params.get("copyFromBranch"));
				copyParams.put("populateAllSw", params.get("populateAllSw"));
			this.sqlMapClient.insert("saveCopyToAnotherUser", copyParams);
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
}
