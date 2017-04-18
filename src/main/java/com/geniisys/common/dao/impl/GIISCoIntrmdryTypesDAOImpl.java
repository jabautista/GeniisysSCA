package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISCoIntrmdryTypesDAO;
import com.geniisys.common.entity.GIISCoIntrmdryTypes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCoIntrmdryTypesDAOImpl  implements GIISCoIntrmdryTypesDAO {
	
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
	public void saveGiiss075(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCoIntrmdryTypes> delList = (List<GIISCoIntrmdryTypes>) params.get("delRows");
			for(GIISCoIntrmdryTypes d: delList){
				this.sqlMapClient.update("delCoIntrmdryTypes", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCoIntrmdryTypes> setList = (List<GIISCoIntrmdryTypes>) params.get("setRows");
			for(GIISCoIntrmdryTypes s: setList){
				this.sqlMapClient.update("setCoIntrmdryTypes", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteCoIntrmdryTypes", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddCoIntrmdryTypes", params);		
	}
}