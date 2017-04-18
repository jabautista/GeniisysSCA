package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISEQZoneDAO;
import com.geniisys.common.entity.GIISEQZone;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISEQZoneDAOImpl implements GIISEQZoneDAO {
	
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
	public void saveGiiss011(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISEQZone> delList = (List<GIISEQZone>) params.get("delRows");
			for(GIISEQZone d: delList){
				this.sqlMapClient.update("delEQZone", d.getEqZone());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISEQZone> setList = (List<GIISEQZone>) params.get("setRows");
			for(GIISEQZone s: setList){
				this.sqlMapClient.update("setEQZone", s);
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
		this.sqlMapClient.update("valDeleteEQZone", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddEQZone", params);		
	}
}