package com.geniisys.quote.dao.impl;

import java.sql.SQLException;

import org.apache.log4j.Logger;

import com.geniisys.quote.dao.GIPIQuoteDAO;
import com.geniisys.quote.entity.GIPIQuote;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteDAOImpl implements GIPIQuoteDAO{
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIQuoteDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIPIQuote getQuotationDetailsByQuoteId(Integer quoteId)
			throws SQLException {
		log.info("GETTING QUOTATION INFORMATION OF QUOTE ID: "+quoteId);
		return (GIPIQuote) this.getSqlMapClient().queryForObject("getQuotationInfoByQuoteId", quoteId);
	}

	@Override
	public String getVatTag(Integer quoteId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getVatTag", quoteId);
	}
	

}
