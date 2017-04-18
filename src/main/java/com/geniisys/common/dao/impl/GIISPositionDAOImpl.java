package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISPositionDAO;
import com.geniisys.common.entity.GIISPosition;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPositionDAOImpl implements GIISPositionDAO {
	
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
	public void saveGiiss023(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISPosition> delList = (List<GIISPosition>) params.get("delRows");
			for(GIISPosition d: delList){
				this.sqlMapClient.update("delPosition", d.getPositionCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISPosition> setList = (List<GIISPosition>) params.get("setRows");
			for(GIISPosition s: setList){
				this.sqlMapClient.update("setPosition", s);
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
	public String valDeleteRec(String positionCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeletePosition", positionCd);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddPosition", params);		
	}
}
