package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIQuotePrincipalDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuotePrincipal;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuotePrincipalDAOImpl implements GIPIQuotePrincipalDAO{
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuoteVesAirDAOImpl.class);
	
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

	/**
	 * @return the log
	 */
	public static Logger getLog() {
		return log;
	}

	/**
	 * @param log the log to set
	 */
	public static void setLog(Logger log) {
		GIPIQuotePrincipalDAOImpl.log = log;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePrincipal> getPrincipalList(Integer quoteId, String principalType) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("principalType", principalType);
		Debug.print("PARAMETERS: " + params);
		return this.getSqlMapClient().queryForList("getPrincipalContractorListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuotePrincipal> getPrincipalListForPackQuote(
			Integer packQuoteId, String principalType) throws SQLException {
		List<GIPIQuotePrincipal> packPrincList = new ArrayList<GIPIQuotePrincipal>();
		List<GIPIQuote> packQuoteList = this.getSqlMapClient().queryForList("getPackQuoteListForENInfo", packQuoteId);
		for(GIPIQuote quote: packQuoteList){
			List<GIPIQuotePrincipal> principalList = this.getSqlMapClient().queryForList("getGIPIQuotePrincipalList", quote.getQuoteId());
			for(GIPIQuotePrincipal principal : principalList){
				packPrincList.add(principal);
			}
		}
		return packPrincList;
	}
}
