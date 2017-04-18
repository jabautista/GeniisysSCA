/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISSublineDAO;
import com.geniisys.common.entity.GIISSubline;
import com.geniisys.common.entity.GIISSublineMain;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISSublineDAOImpl.
 */
public class GIISSublineDAOImpl implements GIISSublineDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISSublineDAOImpl.class);
	
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
	
	
	
	//subline listing
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISSublineDAO#getGIISSublineListing(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIISSubline> getGIISSublineListing(String sublineCd) {
		List<GIISSubline> list = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("sublineCd", sublineCd);
		try {
			list = getSqlMapClient().queryForList("getSublineName",param);
		} catch (SQLException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISSublineDAO#getGIISSublineListingByLineCd(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISSubline> getGIISSublineListingByLineCd(String lineCd) {
		List<GIISSubline> list = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", lineCd);
		try {
			list = getSqlMapClient().queryForList("getGIISSublineListingByLineCd", param);
		} catch (SQLException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISSublineDAO#getSublineDetails(java.lang.String, java.lang.String)
	 */
	@Override
	public GIISSubline getSublineDetails(String lineCd, String sublineCd)
			throws SQLException {
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		return (GIISSubline) this.sqlMapClient.queryForObject("getSublineDetails",params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISSublineDAO#getSublineName(java.lang.String, java.lang.String)
	 */
	@Override
	public String getSublineName(String lineCd, String sublineCd)
			throws SQLException {
		System.out.println("DAO - " + lineCd + sublineCd);
		@SuppressWarnings("unused")
		GIISSubline subline = (GIISSubline) this.getSqlMapClient().queryForObject("getSublineName2", lineCd, sublineCd);
		return (String) this.getSqlMapClient().queryForObject("getSublineName2", lineCd, sublineCd);
	}
	
	@Override
	public Map<String, Object> validateSublineCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateSublineCd", params);
		Debug.print(params);
		return params ;
	}
	
	@Override
	public Map<String, Object> validatePurgeSublineCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePurgeSublineCd", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISSubline> validateSublineCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return (List<GIISSubline>) sqlMapClient.queryForList("validateSublineCdGiexs006", params);
	}

	@Override
	public String getOpFlagGiuts008a(Map<String, Object> params)
			throws SQLException {
		return (String) sqlMapClient.queryForObject("getOpFlagGiuts008a", params);
	}

	@Override
	public GIISSubline getSublineDetails2(Map<String, String> params)
			throws SQLException {
		return (GIISSubline) sqlMapClient.queryForObject("getSublineDetails2", params);
	}
	public String validateAddSubline(Map<String, Object> params) throws SQLException {
		log.info("start of validating ADD Subline");
		String msg = (String) this.getSqlMapClient().queryForObject("validateAddSubline", params);
		return msg;
	}
	
	public String validateAcctSublineCd(String acctSublineCd)throws SQLException {
		log.info("start of validating Subline");
		return (String) this.sqlMapClient.queryForObject("validateAcctSublineCd", acctSublineCd);
	}
	
	public String validateDeleteSubline(Map<String, Object> params) throws SQLException {
		log.info("start of validating Subline");
		String msg = (String) this.getSqlMapClient().queryForObject("validateSublineDel", params);
		return msg;
	}
	
		

	@SuppressWarnings("unchecked")
	@Override
	public String saveInvoice(Map<String, Object> allParams)
			throws SQLException {
		String message = "SUCCESS";
		
		List<GIISSublineMain> setRows = (List<GIISSublineMain>) allParams.get("setRows");
		List<GIISSublineMain> updateRows = (List<GIISSublineMain>) allParams.get("updateRows");
		List<GIISSublineMain> delRows = (List<GIISSublineMain>) allParams.get("delRows");
		System.out.println(" setRows "+setRows);
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("start of saving Line");
				
			for(GIISSublineMain del : delRows){
				log.info("DELETING: "+ del);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("sublineCd", del.getSublineCd());
				params.put("lineCd",allParams.get("lineCd"));
				this.getSqlMapClient().delete("deleteSublineMaintenanceRow", params);
			}
			for(GIISSublineMain set : setRows){
				log.info("INSERTING: "+ set);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",allParams.get("lineCd"));
				params.put("sublineCd", set.getSublineCd().toUpperCase());
				params.put("sublineName", set.getSublineName().toUpperCase());
				params.put("sublineTime", set.getSublineTime());
				params.put("acctSublineCd",set.getAcctSublineCd());
				params.put("minPremAmt", set.getMinPremAmt());
				params.put("remarks", set.getRemarks());
				params.put("openPolicySw", set.getOpenPolicySw());
				params.put("opFlag", set.getOpFlag());
				params.put("alliedPrtTag", set.getAlliedPrtTag());
				params.put("timeSw", set.getTimeSw());
				params.put("noTaxSw", set.getNoTaxSw());
				params.put("excludeTag", set.getExcludeTag());
				params.put("profCommTag", set.getProfCommTag());
				params.put("nonRenewalTag", set.getNonRenewalTag());
				params.put("edstSw", set.getEdstSw());
				params.put("enrolleeTag", set.getEnrolleeTag());
				params.put("appUser", allParams.get("appUser"));
				params.put("microSw", set.getMicroSw()); //apollo 05.20.2015 sr#4245
				this.sqlMapClient.insert("addSublineMaintenanceRow", params);
			}
			for(GIISSublineMain update : updateRows){
				log.info("UPDATING: "+ update);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",allParams.get("lineCd"));
				params.put("sublineCd", update.getSublineCd().toUpperCase());
				params.put("sublineName", update.getSublineName().toUpperCase());
				params.put("sublineTime", update.getSublineTime());
				params.put("acctSublineCd",update.getAcctSublineCd());
				params.put("minPremAmt", update.getMinPremAmt());
				params.put("remarks", update.getRemarks());
				params.put("openPolicySw", update.getOpenPolicySw());
				params.put("opFlag", update.getOpFlag());
				params.put("alliedPrtTag", update.getAlliedPrtTag());
				params.put("timeSw", update.getTimeSw());
				params.put("noTaxSw", update.getNoTaxSw());
				params.put("excludeTag", update.getExcludeTag());
				params.put("profCommTag", update.getProfCommTag());
				params.put("nonRenewalTag", update.getNonRenewalTag());
				params.put("edstSw", update.getEdstSw());
				params.put("enrolleeTag", update.getEnrolleeTag());
				params.put("appUser", allParams.get("appUser"));
				params.put("microSw", update.getMicroSw()); //apollo 05.20.2015 sr#4245
				this.sqlMapClient.insert("setSublineMaintenanceRow", params);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Line.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validateAcctSublineCd(Map<String, Object> allParams) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateAcctSublineCd", allParams);
	}

	@Override
	public String validateOpenSw(Map<String, Object> allParams) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOpenSw", allParams);
	}

	@Override
	public String validateOpenFlag(Map<String, Object> allParams) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOpenFlag", allParams);
	}
}
