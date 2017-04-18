package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIOrigCommInvPerilDAO;
import com.geniisys.gipi.entity.GIPIOrigCommInvPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOrigCommInvPerilDAOImpl implements GIPIOrigCommInvPerilDAO {
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIOrigCommInvoiceDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIOrigCommInvPeril> getGipiOrigCommInvPeril(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting gipi_orig_comm_inv_peril records...");
		List<GIPIOrigCommInvPeril> gipiOrigCommInvPeril = this.getSqlMapClient().queryForList("getGipiOrigCommInvPeril", params);
		return gipiOrigCommInvPeril;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getCommInvPerils(HashMap<String, Object> params) throws SQLException {

		return this.sqlMapClient.queryForList("getCommInvPerils",params);
	}
}
