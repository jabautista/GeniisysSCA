package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACIntmPcommRtDAO;
import com.geniisys.giac.entity.GIACIntmPcommRt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACIntmPcommRtDAOImpl implements GIACIntmPcommRtDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddIntmPcommRt", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs334(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACIntmPcommRt> delList = (List<GIACIntmPcommRt>) params.get("delRows");
			for(GIACIntmPcommRt d : delList){
				this.sqlMapClient.update("delIntmPcommRt", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIACIntmPcommRt> setList = (List<GIACIntmPcommRt>) params.get("setRows");
			for(GIACIntmPcommRt s: setList){
				this.sqlMapClient.update("setIntmPcommRt", s);
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
