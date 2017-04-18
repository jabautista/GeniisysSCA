package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIInspDataDtlDAO;
import com.geniisys.gipi.entity.GIPIInspDataDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIInspDataDtlDAOImpl implements GIPIInspDataDtlDAO{

	private Logger log = Logger.getLogger(GIPIInspDataDtlDAO.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public GIPIInspDataDtl getInspDataDtl(Integer inspNo)
		throws SQLException {
		log.info("Getting inspection data details for inspNo : " + inspNo);
		return (GIPIInspDataDtl) this.getSqlMapClient().queryForObject("getInspDataDtl", inspNo);
	}
	
	//update statements may be transferred
	public void setInspDataDtl(GIPIInspDataDtl inspDataDtl)
		throws SQLException {
		this.getSqlMapClient().update("setInspDataDtl", inspDataDtl);
	}
	
	public void deleteInspDataDtl(Integer inspNo)
		throws SQLException {
		this.getSqlMapClient().delete("delInspDataDtl", inspNo);
	}
}
