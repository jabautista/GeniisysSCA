package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISAirTypeDAO;
import com.geniisys.common.entity.GIISAirType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISAirTypeDAOImpl implements GIISAirTypeDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss048(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISAirType> delList = (List<GIISAirType>) params.get("delRows");
			for(GIISAirType d: delList){
				this.sqlMapClient.update("delAirType", d.getAirTypeCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISAirType> setList = (List<GIISAirType>) params.get("setRows");
			for(GIISAirType s: setList){
				this.sqlMapClient.update("setAirType", s);
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
	public String valDeleteRec(String airTypeCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteAirType", airTypeCd);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAirType", recId);		
	}
}
