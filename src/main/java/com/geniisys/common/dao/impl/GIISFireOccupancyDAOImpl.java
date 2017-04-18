package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISFireOccupancyDAO;
import com.geniisys.fire.entity.GIISFireOccupancy;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISFireOccupancyDAOImpl  implements GIISFireOccupancyDAO {
	
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
	public void saveGiiss097(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISFireOccupancy> delList = (List<GIISFireOccupancy>) params.get("delRows");
			for(GIISFireOccupancy d: delList){
				this.sqlMapClient.update("delFireOccupancy", d.getOccupancyCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISFireOccupancy> setList = (List<GIISFireOccupancy>) params.get("setRows");
			for(GIISFireOccupancy s: setList){
				this.sqlMapClient.update("setFireOccupancy", s);
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
		this.sqlMapClient.update("valDeleteFireOccupancy", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddFireOccupancy", params);		
	}
}