package com.geniisys.quote.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.quote.dao.GIPIQuoteItmperilDAO;
import com.geniisys.quote.entity.GIPIQuoteItmperil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteItmperilDAOImpl implements GIPIQuoteItmperilDAO{
	private Logger log = Logger.getLogger(GIPIQuoteInvoiceDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePerilInfo(Map<String, Object> rowParams, Map<String, Object> params) 
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving peril info...");
			
			List<GIPIQuoteItmperil> setRows = (List<GIPIQuoteItmperil>) rowParams.get("setRows");
			List<GIPIQuoteItmperil> delRows = (List<GIPIQuoteItmperil>) rowParams.get("delRows");
			
			for (GIPIQuoteItmperil del:delRows){
				log.info("DELETING: "+ del);
				this.getSqlMapClient().delete("deleteGIIMM002PerilInfo", del);
			}
			
			for (GIPIQuoteItmperil set:setRows){
				log.info("INSERTING: "+ set);
				this.getSqlMapClient().insert("setGIIMM002PerilInfo", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving peril info...");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItmperil> getItmperils(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuoteItmperil> itmPerils = (List<GIPIQuoteItmperil>)this.getSqlMapClient().queryForList("getItmperils", params);
		return itmPerils;
	}
	
}
