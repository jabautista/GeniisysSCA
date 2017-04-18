package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.derby.tools.sysinfo;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gism.dao.GISMMessagesReceivedDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMMessagesReceivedDAOImpl implements GISMMessagesReceivedDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GISMMessagesReceivedDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getMessageDetail(Integer messageId) throws SQLException,
			JSONException {
		log.info("Getting details for Message Id " + messageId);
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getMsgReceivedDtl", messageId);
	}

	@Override
	public void replyToMessage(Map<String, Object> params) throws SQLException {
		log.info("Inserting message reply...");
		log.info(params);
		this.getSqlMapClient().update("replyToMessage", params);
	}

	@Override
	public void gisms008Assign(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("gisms008Assign", params);
			this.sqlMapClient.executeBatch();
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public void gisms008Purge(Map<String, Object> params) throws SQLException, JSONException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			JSONArray arr = (JSONArray) params.get("arr");
			
			System.out.println("***ROWS***");
			for(int x = 0; x < arr.length(); x++){
				JSONObject rec = arr.getJSONObject(x);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("cellphoneNo", rec.getString("cellphoneNo"));
				map.put("keyword", rec.getString("keyword"));
				map.put("message", rec.getString("message"));
				map.put("userId", params.get("userId"));
				
				this.getSqlMapClient().update("gisms008Purge", map);
				this.sqlMapClient.executeBatch();
			}
			
			
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
