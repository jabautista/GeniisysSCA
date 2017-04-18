package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISCaTrtyTypeDAO;
import com.geniisys.common.entity.GIISCaTrtyType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCaTrtyTypeDAOImpl  implements GIISCaTrtyTypeDAO {
	
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
	public void saveGiiss094(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCaTrtyType> delList = (List<GIISCaTrtyType>) params.get("delRows");
			for(GIISCaTrtyType d: delList){
				this.sqlMapClient.update("delCaTrtyType", d.getCaTrtyType());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCaTrtyType> setList = (List<GIISCaTrtyType>) params.get("setRows");
			for(GIISCaTrtyType s: setList){
				this.sqlMapClient.update("setCaTrtyType", s);
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
	public void valAddRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valAddCaTrtyType", recId);		
	}
}