package com.geniisys.gism.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.gism.dao.GISMUserRouteDAO;
import com.geniisys.gism.entity.GISMUserRoute;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GISMUserRouteDAOImpl  implements GISMUserRouteDAO {
	
	/** The SQl Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log */
	private static Logger log = Logger.getLogger(GISMUserRouteDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGisms010(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();	
			
			List<GISMUserRoute> setList = (List<GISMUserRoute>) params.get("setRows");
			for(GISMUserRoute s: setList){
				this.sqlMapClient.update("setUserRoute", s);
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