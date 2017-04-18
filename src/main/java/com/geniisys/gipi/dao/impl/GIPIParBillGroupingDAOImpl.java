package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIParBillGroupingDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIParBillGroupingDAOImpl implements GIPIParBillGroupingDAO {
	
	private SqlMapClient sqlMapClient; 
	
	private Logger log = Logger.getLogger(GIPIParBillGroupingDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public void deleteDistWorkTables(Integer parId) throws SQLException {
		this.getSqlMapClient().delete("deleteDistWorkTables", parId);
		log.info("Deleting distribution work tables for parId = " + parId);
	}

}
