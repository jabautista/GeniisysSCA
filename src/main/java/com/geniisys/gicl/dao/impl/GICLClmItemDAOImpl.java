package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmItemDAOImpl implements GICLClmItemDAO{

	private Logger log = Logger.getLogger(GICLClmItemDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient){
		this.sqlMapClient = sqlMapClient;
	}
	
	public SqlMapClient getSqlMapClient(){
		return this.sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLClmItemDAO#updGiclClmItem(java.util.Map)
	 */
	@Override
	public void updGiclClmItem(Map<String, Object> params) throws SQLException {
		log.info("Updating gicl_clm_item...");
		this.sqlMapClient.update("updGiclClmItem", params);
	}
	
	public void addPersonnel(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("setPersonnel", params);
	}
	
	public void deletePersonnel(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.delete("deletePersonnel",params);
	}
	
}
