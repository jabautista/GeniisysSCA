package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISCaLocationDAO;
import com.geniisys.common.entity.GIISCaLocation;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCaLocationDAOImpl implements GIISCaLocationDAO {
	
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
	public void saveGiiss217(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCaLocation> delList = (List<GIISCaLocation>) params.get("delRows");
			for(GIISCaLocation d: delList){
				this.sqlMapClient.update("delCaLocation", d.getLocationCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCaLocation> setList = (List<GIISCaLocation>) params.get("setRows");
			for(GIISCaLocation s: setList){
				this.sqlMapClient.update("setCaLocation", s);
				System.out.println("fons");
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
		this.sqlMapClient.update("valDeleteCaLocation", recId);
	}
}
