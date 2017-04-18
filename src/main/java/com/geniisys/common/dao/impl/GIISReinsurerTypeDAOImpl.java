package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISReinsurerTypeDAO;
import com.geniisys.common.entity.GIISReinsurerType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISReinsurerTypeDAOImpl  implements GIISReinsurerTypeDAO {
	
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
	public void saveGiiss025(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISReinsurerType> delList = (List<GIISReinsurerType>) params.get("delRows");
			for(GIISReinsurerType d: delList){
				this.sqlMapClient.update("delReinsurerType", d.getRiType());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISReinsurerType> setList = (List<GIISReinsurerType>) params.get("setRows");
			for(GIISReinsurerType s: setList){
				this.sqlMapClient.update("setReinsurerType", s);
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
		this.sqlMapClient.update("valDeleteReinsurerType", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddReinsurerType", recId);		
	}
}