package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.common.entity.GIISEvent;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.PasswordEncoder;
import com.geniisys.gipi.dao.GIPIUserEventDAO;
import com.geniisys.gipi.dao.GUEAttachDAO;
import com.geniisys.gipi.entity.GIPIUserEvent;
import com.geniisys.gipi.entity.GUEAttach;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIUserEventDAOImpl implements GIPIUserEventDAO{

	private SqlMapClient sqlMapClient;
	private GUEAttachDAO gueAttachDAO;
	private static Logger log = Logger.getLogger(GIPIUserEventDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIUserEvent> getGIPIUserEventTableGrid(
			Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving GIPI User Events Listing...");
		List<GIPIUserEvent> userEvents = this.getSqlMapClient().queryForList("getGIPIUserEventTableGrid", params);
		
		log.info("DAO - " + userEvents.size() + " GIPI User Event/s retrieved." );
		return userEvents;		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIUserEvent> getGIPIUserEventDetailTableGrid(
			Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving GIPI User Events Details Listing...");
		List<GIPIUserEvent> userEventDetailListing = this.getSqlMapClient().queryForList("getGIPIUserEventDetailTableGrid", params);
		log.info("DAO - " + userEventDetailListing.size() + " GIPI User Event Detail/s retrieved." );
		return userEventDetailListing;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveCreatedEvent(Map<String, Object> params)
			throws SQLException, Exception {
		Map<String, Object> createParams = null;
		try {
			List<GIISUser> users = (List<GIISUser>) params.get("users");
			List<Map<String, Object>> tranDtls = (List<Map<String, Object>>) params.get("tranDtls");
			GIISEvent event = (GIISEvent) params.get("event");
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			
			log.info("Saving GIPI User Events...");
			createParams = new HashMap<String, Object>();
			createParams.put("appUser", params.get("userId"));
			createParams.put("eventCd", event.getEventCd());
			createParams.put("eventDesc", event.getEventDesc());
			createParams.put("eventType", event.getEventType());
			createParams.put("remarks", params.get("remarks"));
			createParams.put("status", params.get("status"));
			createParams.put("statusDesc", params.get("statusDesc"));
			createParams.put("dateDue", params.get("dateDue"));
			createParams.put("createTag", params.get("createTag"));
			
			List<String> emailAddresses = new ArrayList<String>();
			if(tranDtls != null && tranDtls.size() > 0){
				for(Map<String, Object> tranDtl: tranDtls){
					createParams.put("colValue", tranDtl.get("colValue"));
					createParams.put("tranDtl", tranDtl.get("tranDtl"));
					
					for(GIISUser user : users){
						createParams.put("userId", user.getCreateUser());
						emailAddresses.add(PasswordEncoder.doDecrypt(user.getEmailAdd()));
						this.sqlMapClient.insert("saveCreatedEvent", createParams);
					}
				}
			} else {
				for(GIISUser user : users){
					createParams.put("userId", user.getCreateUser());
					emailAddresses.add(PasswordEncoder.doDecrypt(user.getEmailAdd()));
					this.sqlMapClient.insert("saveCreatedEvent", createParams);
				}
			}
			
			this.sqlMapClient.executeBatch();
			if("ERROR".equals(createParams.get("messageType"))){
				this.sqlMapClient.getCurrentConnection().rollback();
			} else {				
				if(params.get("attachments") != null){
					Map<String, Object> attachParams = new HashMap<String, Object>();
					attachParams.put("attachments", params.get("attachments"));
					attachParams.put("appUser", params.get("userId"));
					attachParams.put("tranId", createParams.get("message"));
					System.out.println(attachParams);
					this.sqlMapClient.startBatch();
					List<String> files = this.gueAttachDAO.setGUEAttach(attachParams);
					this.sqlMapClient.executeBatch();
					createParams.put("files", files);
				}
				createParams.put("emailAddresses", emailAddresses);
				createParams.put("tranDtls", tranDtls);
				
				this.sqlMapClient.getCurrentConnection().commit();
			}
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();			
		}
		return createParams;
	}

	@Override
	public void setWorkflowGICLS010(Map<String, Object> params)	throws SQLException {
		// TODO Auto-generated method stub
		this.getSqlMapClient().insert("setWorkflowGICLS010", params);
	}

	public void setGueAttachDAO(GUEAttachDAO gueAttachDAO) {
		this.gueAttachDAO = gueAttachDAO;
	}

	public GUEAttachDAO getGueAttachDAO() {
		return gueAttachDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> transferEvents(Map<String, Object> params)
			throws SQLException, JSONException, Exception {
		Map<String, Object> transferParams = null;
		Map<String, Object> delParams = null;
		
		List<Map<String, Object>> createParamsList = new ArrayList<Map<String,Object>>();
		try {
			List<Map<String, Object>> usersMapList = (List<Map<String, Object>>) params.get("users");
			List<GIPIUserEvent> gipiUserEvents = (List<GIPIUserEvent>) params.get("userEvents");
			GIISEvent event = (GIISEvent) params.get("event");
			String appUser = (String) params.get("userId");					
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);		
			this.sqlMapClient.startBatch();
						
			for(GIPIUserEvent userEvent : gipiUserEvents){
				log.info("Transferring GIPI User Events...");
				log.info("TRAN ID : " + userEvent.getTranId());
				transferParams = new HashMap<String, Object>();
				transferParams.put("appUser", appUser);
				transferParams.put("eventCd", event.getEventCd());
				transferParams.put("eventType", event.getEventType());
				transferParams.put("multipleAssignSw", event.getMultipleAssignSw());
				transferParams.put("eventDesc", event.getEventDesc());
				transferParams.put("tranId", userEvent.getTranId());
				transferParams.put("eventModCd", userEvent.getEventModCd());
				transferParams.put("eventColCd", userEvent.getEventColCd());
				transferParams.put("eventUserMod", userEvent.getEventUserMod());
				transferParams.put("remarks", params.get("remarks"));
				transferParams.put("status", params.get("status"));
				transferParams.put("statusDesc", params.get("statusDesc"));
				transferParams.put("dateDue", params.get("dateDue"));
				transferParams.put("receiverTag", event.getReceiverTag());
				
				List<String> emailAddresses = new ArrayList<String>();
				for(Map<String, Object> map: usersMapList){										
					if(map.get("tranId").equals(userEvent.getTranId()) 
							&& map.get("eventUserMod").equals(userEvent.getEventUserMod()) 
							&& map.get("eventColCd").equals(userEvent.getEventColCd())){
						transferParams.put("userId", map.get("userId"));
						emailAddresses.add(PasswordEncoder.doDecrypt(map.get("emailAdd").toString()));
						System.out.println(transferParams);
						System.out.println("USER : " + transferParams.get("userId"));
						this.sqlMapClient.insert("transferEvent", transferParams);
					}
				}
				delParams = new HashMap<String, Object>();
				delParams.put("tranId", userEvent.getTranId());
				delParams.put("eventColCd", userEvent.getEventColCd());	
				delParams.put("eventUserMod", userEvent.getEventUserMod());	
				this.sqlMapClient.delete("delGIPIUserEvent", transferParams);
				
				this.sqlMapClient.executeBatch();
				if("ERROR".equals(transferParams.get("messageType"))){
					this.sqlMapClient.getCurrentConnection().rollback();
				} else {				
					List<GUEAttach> attachments = this.gueAttachDAO.getGUEAttachListing(userEvent.getTranId());
					List<String> files = new ArrayList<String>();
					for(GUEAttach attach: attachments){
						files.add(attach.getFileName());
					}
					transferParams.put("files", files);
					transferParams.put("emailAddresses", emailAddresses);
					createParamsList.add(transferParams);
				}
			}			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();			
		}
		return createParamsList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void deleteEvents(Map<String, Object> params) throws SQLException {
		try {
			List<GIPIUserEvent> gipiUserEvents = (List<GIPIUserEvent>) params.get("userEvents");
			//String appUser = (String) params.get("userId");					
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);		
			this.sqlMapClient.startBatch();
			
			log.info("Deleting GIPI User Events...");
			for(GIPIUserEvent gipiUserEvent : gipiUserEvents){
				this.sqlMapClient.delete("delUserEvent", gipiUserEvent);
			}
			
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();	
		}
	
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIUserEventDtls(Map<String, Object> params)
			throws SQLException {
		try {
			List<GIPIUserEvent> gipiUserEvents = (List<GIPIUserEvent>) params.get("userEvents");
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);		
			this.sqlMapClient.startBatch();
			
			log.info("Updating GIPI User Events status...");
			for(GIPIUserEvent gipiUserEvent : gipiUserEvents){
				this.sqlMapClient.delete("updateGIPIUserEventStatus", gipiUserEvent);
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
}
