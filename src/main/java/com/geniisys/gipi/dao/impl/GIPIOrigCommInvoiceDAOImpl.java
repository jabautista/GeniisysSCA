package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIOrigCommInvoiceDAO;
import com.geniisys.gipi.entity.GIPIOrigCommInvoice;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIOrigCommInvoiceDAOImpl implements GIPIOrigCommInvoiceDAO {
	
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
	public List<GIPIOrigCommInvoice> getGipiOrigCommInvoice(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting gipi_orig_comm_invoice records...");
		List<GIPIOrigCommInvoice> gipiOrigCommInvoiceList = this.getSqlMapClient().queryForList("getGipiOrigCommInvoice", params);
		return gipiOrigCommInvoiceList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getInvoiceCommissions(HashMap<String, Object> params) throws SQLException {
		
		return this.sqlMapClient.queryForList("getInvoiceCommissions",params);
	}
}
