package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISEventDAO;
import com.geniisys.common.entity.GIISEvent;
import com.geniisys.common.entity.GIISEventsColumn;
import com.geniisys.common.entity.GIISEventsDisplay;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEventDAOImpl implements GIISEventDAO {

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISEventDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISEvent> getGIISEventListing() throws SQLException {		
		return this.getSqlMapClient().queryForList("getGIISEventListing");
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISEvents(Map<String, Object> params) throws SQLException {
		try {
			List<GIISEvent> setEvents = (List<GIISEvent>) params.get("setEvents");
			List<GIISEvent> delEvents = (List<GIISEvent>) params.get("delEvents");
			
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			
			log.info("Saving GIIS Events...");
			for(GIISEvent event : delEvents){
				this.sqlMapClient.delete("delGIISEvent", event);
			}
			log.info(delEvents.size() + " GIIS Event/s deleted.");
			
			for(GIISEvent event : setEvents){
				this.sqlMapClient.insert("setGIISEvent", event);
			}
			log.info(setEvents.size() + " GIIS Event/s inserted.");
			
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
	public void createTransferEvent(Map<String, Object> params)
			throws SQLException {
		try {		
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);			
			this.sqlMapClient.startBatch();
			
			this.sqlMapClient.queryForList("createTransferEvent", params);
			
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
	public void valDeleteGIISEvents(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteGIISEvents", recId);
	}


	@Override
	public void valDeleteGIISEventsColumn(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteGIISEventsColumn", recId);
	}

	@Override
	public void valAddGIISEventsColumn(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valAddGIISEventsColumn", params);		
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setGIISEventsColumn(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISEventsColumn> delList = (List<GIISEventsColumn>) params.get("delRows");
			for(GIISEventsColumn d: delList){
				Map<String, Object> paraMap = new HashMap<String, Object>();
				paraMap.put("eventColCd", d.getEventColCd());
				this.sqlMapClient.update("delGIISEventsColumn", paraMap);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISEventsColumn> setList = (List<GIISEventsColumn>) params.get("setRows");
			for(GIISEventsColumn s: setList){
				this.sqlMapClient.update("setGIISEventsColumn", s);
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
	public void valAddGIISEventsDisplay(Map<String, Object> params)throws SQLException {
		this.sqlMapClient.update("valAddGIISEventsDisplay", params);		
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setGIISEventsDisplay(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISEventsDisplay> delList = (List<GIISEventsDisplay>) params.get("delRows");
			for(GIISEventsDisplay d: delList){
				Map<String, Object> paraMap = new HashMap<String, Object>();
				paraMap.put("eventColCd", d.getEventColCd());
				paraMap.put("dspColId", d.getDspColId());
				this.sqlMapClient.update("delGIISEventsDisplay", paraMap);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISEventsDisplay> setList = (List<GIISEventsDisplay>) params.get("setRows");
			for(GIISEventsDisplay s: setList){
				this.sqlMapClient.update("setGIISEventsDisplay", s);
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
}
