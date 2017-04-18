package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACOucsDAO;
import com.geniisys.giac.entity.GIACOucs;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACOucsDAOImpl implements GIACOucsDAO {

	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs305(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACOucs> delList = (List<GIACOucs>) params.get("delRows");
			for(GIACOucs d: delList){
				this.sqlMapClient.update("delOuc", d.getOucId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACOucs> oucsList = (List<GIACOucs>) params.get("setRows");
			for(GIACOucs s: oucsList){
				this.sqlMapClient.update("setOucs", s);
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

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valDeleteOuc(Integer oucId) throws SQLException {
		this.sqlMapClient.update("valDeleteOuc", oucId);
	}

	@Override
	public void valAddOuc(Integer oucCd) throws SQLException {
		this.sqlMapClient.update("valAddOuc", oucCd);
	}
	
}
