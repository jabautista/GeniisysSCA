package com.geniisys.quote.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.quote.dao.GIPIQuoteInvoiceDAO;
import com.geniisys.quote.entity.GIPIQuoteInvoice;
import com.geniisys.quote.entity.GIPIQuoteInvtax;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteInvoiceDAOImpl implements GIPIQuoteInvoiceDAO{
	private Logger log = Logger.getLogger(GIPIQuoteInvoiceDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public GIPIQuoteInvoice getGipiQuoteInvoiceDtls(Map<String, Object> params)
			throws SQLException {
		return (GIPIQuoteInvoice) this.getSqlMapClient().queryForObject("getGipiQuoteInvoiceDtls", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInvoice(Map<String, Object> allParams, Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving Invoice.");
			
			List<GIPIQuoteInvtax> setRows = (List<GIPIQuoteInvtax>) allParams.get("setRows");
			List<GIPIQuoteInvtax> delRows = (List<GIPIQuoteInvtax>) allParams.get("delRows");
			
			this.getSqlMapClient().update("updateGIPIQuoteInvoiceIntm", params);
			
			for (GIPIQuoteInvtax del:delRows){
				log.info("DELETING: "+ del);
				this.getSqlMapClient().delete("deleteGIIMM002InvTax", del);
			}
			
			for (GIPIQuoteInvtax set:setRows){
				log.info("INSERTING: "+ set);
				set.setQuoteId(Integer.parseInt((String)params.get("quoteId")));
				this.getSqlMapClient().insert("setGIIMM002InvTax", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Invoice.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Map<String, Object> checkTaxType(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkTaxType", params);
		return params;
	}
}
