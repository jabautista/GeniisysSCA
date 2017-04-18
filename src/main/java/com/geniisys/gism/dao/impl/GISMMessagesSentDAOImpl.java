package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gism.dao.GISMMessagesSentDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMMessagesSentDAOImpl implements GISMMessagesSentDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GISMMessagesSentDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void resendMessage(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Resending message...");
			log.info("Message ID: " + params.get("messageId"));
			this.getSqlMapClient().update("resendMessage", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void cancelMessage(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Cancelling message...");
			log.info("Message ID: " + params.get("messageId"));
			this.getSqlMapClient().update("cancelMessage", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveMessages(Map<String, Object> params) throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving messages...");
		
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			List<Map<String, Object>> delRows = (List<Map<String, Object>>) params.get("delRows");
			List<Map<String, Object>> delDtlRows = (List<Map<String, Object>>) params.get("delDtlRows");
			
			for(Map<String, Object> row : delDtlRows){
				log.info("Deleting detail...");
				log.info(row);
				this.getSqlMapClient().delete("deleteDetail", row);
				this.getSqlMapClient().executeBatch();
			}
			
			for(Map<String, Object> row : delRows){
				log.info("Deleting message...");
				log.info(row);
				this.getSqlMapClient().delete("deleteMessage", row);
				this.getSqlMapClient().executeBatch();
			}
			
			for(Map<String, Object> row : setRows){
				if(row.get("msgId") == null || row.get("msgId").equals("")){
					row.put("msgId", this.getSqlMapClient().queryForObject("getMessageId"));
				}
				row.put("userId", params.get("userId"));
				
				log.info("Setting message...");
				log.info(row);
				this.getSqlMapClient().update("setMessage", row);
				this.getSqlMapClient().executeBatch();
				
				JSONObject paramsObj = new JSONObject(row);
				List<Map<String, Object>> details = JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("details")));
				
				for(Map<String, Object> detail : details){
					if(detail.get("recordStatus") != null && (detail.get("recordStatus").equals(0) || detail.get("recordStatus").equals(1))){
						detail.put("msgId", row.get("msgId"));
						detail.put("userId", params.get("userId"));
						
						log.info("Setting detail...");
						log.info(detail);
						this.getSqlMapClient().update("setDetail", detail);
					}
				}
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving messages...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String validateCellphoneNo(Map<String, Object> params) throws SQLException {
		try{
			String message = "0";
			log.info("Validating Cellphone Number...");
			
			if(params.get("default").equals("Y")){
				params.put("provider", "GLOBE_NUMBER");
				message = (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
				
				params.put("provider", "SMART_NUMBER");
				message = message.equals("1") ? "1" : (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
				
				params.put("provider", "SUN_NUMBER");
				message = message.equals("1") ? "1" : (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
			}else{
				if(params.get("globe").equals("Y")){
					params.put("provider", "GLOBE_NUMBER");
					message = (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
				}
				
				if(params.get("smart").equals("Y")){
					params.put("provider", "SMART_NUMBER");
					message = message.equals("1") ? "1" : (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
				}
				
				if(params.get("sun").equals("Y")){
					params.put("provider", "SUN_NUMBER");
					message = message.equals("1") ? "1" : (String) this.getSqlMapClient().queryForObject("validateCellphoneNo", params);
				}
			}
			
			if(message.equals("1")){
				return "SUCCESS";
			}else{
				return "INVALID";
			}
		}catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}
	
}
