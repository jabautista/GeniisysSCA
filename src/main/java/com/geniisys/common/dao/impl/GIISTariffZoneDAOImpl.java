package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISTariffZoneDAO;
import com.geniisys.common.entity.GIISTariffZone;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTariffZoneDAOImpl implements GIISTariffZoneDAO {
	
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
	
	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddTariffZone", recId);		
	}
	
	@Override
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteTariffZone", recId);
	}	
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss054(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTariffZone> delList = (List<GIISTariffZone>) params.get("delRows");
			for(GIISTariffZone d: delList){
				this.sqlMapClient.update("delTariffZone", d.getTariffZone());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTariffZone> setList = (List<GIISTariffZone>) params.get("setRows");
			for(GIISTariffZone s: setList){
				this.sqlMapClient.update("setTariffZone", s);
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
	public Integer checkGiiss054UserAccess(String userId) throws SQLException {	
		return (Integer) this.sqlMapClient.queryForObject("checkGiiss054UserAccess",userId);
	}	
}