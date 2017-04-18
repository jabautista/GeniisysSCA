package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISAccessoryDAO;
import com.geniisys.common.entity.GIISAccessory;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISAccessoryDAOImpl  implements GIISAccessoryDAO {
	
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
	public void saveGiiss107(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISAccessory> delList = (List<GIISAccessory>) params.get("delRows");
			for(GIISAccessory d: delList){
				this.sqlMapClient.update("delAccessory", d.getAccessoryCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISAccessory> setList = (List<GIISAccessory>) params.get("setRows");
			for(GIISAccessory s: setList){
				this.sqlMapClient.update("setAccessory", s);
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
		this.sqlMapClient.update("valDeleteAccessory", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAccessory", recId);		
	}
}