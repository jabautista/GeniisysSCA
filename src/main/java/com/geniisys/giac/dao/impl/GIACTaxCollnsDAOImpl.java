package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACTaxCollnsDAO;
import com.geniisys.giac.entity.GIACTaxCollns;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACTaxCollnsDAOImpl implements GIACTaxCollnsDAO {

	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACTaxCollnsDAOImpl.class);
	
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}



	@SuppressWarnings("unchecked")
	@Override
	public List<GIACTaxCollns> getTaxCollnsListing(Integer gaccTranId)
			throws SQLException {
		log.info("");
		return (List<GIACTaxCollns>) this.getSqlMapClient().queryForList("getGIACTaxCollnsListing", gaccTranId);
	}

}
