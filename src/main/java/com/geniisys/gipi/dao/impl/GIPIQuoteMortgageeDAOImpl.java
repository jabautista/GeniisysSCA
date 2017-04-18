/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIPIQuoteMortgageeDAOImpl.
 */
public class GIPIQuoteMortgageeDAOImpl implements GIPIQuoteMortgageeDAO{
	private static Logger log = Logger.getLogger(GIPIQuoteMortgageeDAOImpl.class);
/** The sql map client. */
private SqlMapClient sqlMapClient;

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#getGIPIQuoteMortgagee(Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteMortgagee> getGIPIQuoteMortgagee(Integer quoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIQuoteMortgagee", quoteId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#getGIPIQuoteLevelMortgagee(Integer)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteMortgagee> getGIPIQuoteLevelMortgagee(Integer quoteId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIQuoteLevelMortgagee", quoteId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#saveGIPIQuoteMortgagee(com.geniisys.gipi.entity.GIPIQuoteMortgagee)
	 */
	@Override
	public void saveGIPIQuoteMortgagee(GIPIQuoteMortgagee gipiQuoteMortgagee)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIQuoteMortgagee", gipiQuoteMortgagee);
	}
	
	public void saveGIPIQuoteMortgagee(Map<String, Object>params)throws SQLException{
		this.getSqlMapClient().insert("saveGIPIQuoteMortgagee2",params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#getPackQuotationsMortgagee(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteMortgagee> getPackQuotationsMortgagee(
			Integer packQuoteId) throws SQLException {
		log.info("GETTING PACK QUOTATIONS MORTGAGEE FOR PACK QUOTE ID:"+packQuoteId);
		return this.getSqlMapClient().queryForList("getPackQuotationsMortgagee", packQuoteId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#savePackQuotationMortgagee(java.util.Map)
	 */
	@Override
	public void savePackQuotationMortgagee(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			String parameter = (String) params.get("parameter");
			String issCd = (String) params.get("issCd");
			String appUser = (String) params.get("appUser");
			JSONObject objParameters = new JSONObject(parameter);
			JSONArray addRows = new JSONArray(objParameters.getString("addRows"));
			JSONArray modRows = new JSONArray(objParameters.getString("modRows"));
			
			
			Map<String, Object>mortParam = null;
			// INSERT NEW PACK QUOTE MORTGAGEE
			//Map<String, Object> 
			for (int i = 0; i < addRows.length(); i++) {
				mortParam = new HashMap<String, Object>();
				log.info("INSERTING MORTGAGEE FOR QUOTATION: "+addRows.getJSONObject(i).getInt("quoteId"));
				mortParam.put("quoteId", addRows.getJSONObject(i).getInt("quoteId"));
				mortParam.put("issCd", issCd);
				mortParam.put("itemNo",0);
				mortParam.put("mortgCd", addRows.getJSONObject(i).getString("mortgCd"));
				mortParam.put("amount", addRows.getJSONObject(i).getString("amount").replaceAll(",", ""));
				mortParam.put("remarks", StringEscapeUtils.unescapeHtml(addRows.getJSONObject(i).getString("remarks")));
				mortParam.put("userId", appUser);
				this.saveGIPIQuoteMortgagee(mortParam);
			}
			
			for (int u = 0; u < modRows.length(); u++) {
				mortParam = new HashMap<String, Object>();
				log.info("UPDATING MORTGAGEE FOR QUOTATION: "+modRows.getJSONObject(u).getInt("quoteId"));
				log.info("OLD MORTGAGEE CD: "+modRows.getJSONObject(u).getString("oldMortgCd")+"NEW MORTGaGEE CD: "+modRows.getJSONObject(u).getString("newMortgCd"));
				mortParam.put("quoteId", modRows.getJSONObject(u).getInt("quoteId"));
				mortParam.put("issCd", issCd);
				mortParam.put("issCd", issCd);
				mortParam.put("itemNo",0);
				mortParam.put("mortgCd", modRows.getJSONObject(u).getString("newMortgCd"));
				mortParam.put("amount", modRows.getJSONObject(u).getString("amount").replaceAll(",", ""));
				mortParam.put("remarks", StringEscapeUtils.unescapeHtml(modRows.getJSONObject(u).getString("remarks")));
				mortParam.put("userId", appUser);
				mortParam.put("oldMortgCd", modRows.getJSONObject(u).getString("oldMortgCd"));
				this.getSqlMapClient().insert("updateGIPIQuoteMortgagee", mortParam);
			}
			
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#deleteAllGIPIQuoteMortgagee(java.lang.Integer, java.lang.String)
	 */
	@Override
	public void deleteAllGIPIQuoteMortgagee(Integer quoteId, String issCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("issCd", issCd);
		this.getSqlMapClient().delete("deleteAllGIPIQuoteMortgagee", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#deleteGIPIQuoteMortgagee(java.lang.Integer, java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override // added transactions - irwin
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Integer itemNo, String issCd, String mortgCd)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			params.put("itemNo", itemNo);
			params.put("issCd", issCd);
			params.put("mortgCd", mortgCd);
			//this.getSqlMapClient().delete("deleteAllGIPIQuoteMortgagee", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteMortgageeDAO#deleteGIPIQuoteMortgagee(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void deleteGIPIQuoteMortgagee(Integer quoteId, Map<String, Object> params)
			throws SQLException {
		params.put("quoteId", quoteId); //Added by Jerome 09.06.2016 SR 5643
		this.getSqlMapClient().delete("deleteGIPIQuoteMortgagee2", params);
	}
	
}