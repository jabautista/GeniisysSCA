package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWEndtTextDAO;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWEndtTextDAOImpl implements GIPIWEndtTextDAO {
	
	private Logger log = Logger.getLogger(GIPIWEndtTextDAOImpl.class);
	private SqlMapClient sqlMapClient;	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String getEndtText(int parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getEndtText", parId);
	}
	
	@Override
	public String getEndtTax(Integer parId) throws SQLException, Exception {
		log.info("Getting endt tax...");
		return (String) this.getSqlMapClient().queryForObject("getEndtTax", parId);
	}

	@Override
	public GIPIWEndtText getGIPIWEndttext(Integer parId) throws SQLException {
		log.info("Getting record on gipi_wendttext ...");
		return (GIPIWEndtText) this.getSqlMapClient().queryForObject("getGIPIWEndttext", parId);
	}

	@Override
	public String CheckUpdateTaxEndtCancellation() throws SQLException {
		log.info("Checking param_name ALLOW_UPDATE_TAX_ENDT_CANCELLATION...");
		return (String) this.getSqlMapClient().queryForObject("CheckUpdateTaxEndtCancellation");
	}	
}
