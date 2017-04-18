package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import com.geniisys.common.dao.GIISMCColorDAO;
import com.geniisys.common.entity.GIISMCColor;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMCColorDAOImpl  implements GIISMCColorDAO {
	
	/** The SQl Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log */
	private static Logger log = Logger.getLogger(GIISMCColorDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss114(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();	
			
			List<GIISMCColor> delBasicList = (List<GIISMCColor>) params.get("delRowsBasic");
			for(GIISMCColor d: delBasicList){
				this.sqlMapClient.update("delMCBasicColor", d.getBasicColorCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISMCColor> delList = (List<GIISMCColor>) params.get("delRows");
			for(GIISMCColor d: delList){
				this.sqlMapClient.update("delMCColor", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISMCColor> setList = (List<GIISMCColor>) params.get("setRows");
			for(GIISMCColor s: setList){
				this.sqlMapClient.update("setMCColor", s);
			}
			
			List<GIISMCColor> updateList = (List<GIISMCColor>) params.get("updateRowsBasic");
			for(GIISMCColor u: updateList){
				this.sqlMapClient.update("updateMCBasicColor", u);
			}
			this.sqlMapClient.executeBatch();
			
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
	public void valDeleteRecBasic(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteMCBasicColor", recId);
	}
	
	@Override
	public void valDeleteRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valDeleteMCColor", recId);
	}

	@Override
	public void valAddRecBasic(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddMCBasicColor", params);		
	}
	
	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddMCColor", params);		
	}	
}