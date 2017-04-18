package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACSlTypeDAO;
import com.geniisys.giac.entity.GIACSlType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACSlTypeDAOImpl implements GIACSlTypeDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valDeleteSlType(String slTypeCd) throws SQLException {
		this.sqlMapClient.update("valDeleteSlType", slTypeCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs308(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACSlType> delList = (List<GIACSlType>) params.get("delRows");
			for(GIACSlType d: delList){
				this.sqlMapClient.update("delSlType", d.getSlTypeCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACSlType> oucsList = (List<GIACSlType>) params.get("setRows");
			for(GIACSlType s: oucsList){
				this.sqlMapClient.update("setSlType", s);
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
	public void valAddSlType(String slTypeCd) throws SQLException {
		this.sqlMapClient.update("valAddSlType", slTypeCd);
	}

}
