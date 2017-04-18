package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISCargoClassDAO;
import com.geniisys.common.entity.GIISCargoClass;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCargoClassDAOImpl  implements GIISCargoClassDAO {
	
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
	public void saveGiiss051(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCargoClass> delList = (List<GIISCargoClass>) params.get("delRows");
			for(GIISCargoClass d: delList){
				this.sqlMapClient.update("delCargoClass", d.getCargoClassCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCargoClass> setList = (List<GIISCargoClass>) params.get("setRows");
			for(GIISCargoClass s: setList){
				this.sqlMapClient.update("setCargoClass", s);
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
	public void valDeleteRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valDeleteCargoClass", recId);
	}

	@Override
	public void valAddRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valAddCargoClass", recId);		
	}
}