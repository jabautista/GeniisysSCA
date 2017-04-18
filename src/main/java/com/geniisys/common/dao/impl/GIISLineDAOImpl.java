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

import com.geniisys.common.dao.GIISLineDAO;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIISLineDAOImpl.
 */
public class GIISLineDAOImpl implements GIISLineDAO {
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISLineDAOImpl.class);
	
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

	//for line listing
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLineDAO#getLineListing()
	 */
	@SuppressWarnings("unchecked")
	public List<GIISLine> getLineListing() {
		List<GIISLine> list = null;		
		try {
			list = getSqlMapClient().queryForList("getLineListing");
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLineDAO#getLineListingByUserId(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIISLine> getLineListingByUserId(String userId) {
		List<GIISLine> list = null;
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", userId);
		try {
			list = getSqlMapClient().queryForList("getLineListingByUserId", userId);
		} catch (SQLException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return list;
	}
	
	//get lineName using lineCd
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLineDAO#getGIISLineName(java.lang.String)
	 */
	public GIISLine getGIISLineName(String lineCd) throws SQLException {
		return (GIISLine) getSqlMapClient().queryForObject("getGIISLineNameByLineCd", lineCd);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISLineDAO#getGiisLineList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getGiisLineList() throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisLineList");
	}

	@Override
	public String getPackPolFlag(String lineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getPackPolFlag", lineCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getCheckedLineIssourceList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getCheckedLineIssourceList", params);
	}

	@Override
	public String getMenuLineCd(String lineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getMenuLineCd", lineCd);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIISLine> getPolLinesForAssd(Integer assdNo) throws SQLException{
		return this.getSqlMapClient().queryForList("getPolLinesForAssd", assdNo);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getCheckedPackLineIssourceList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getCheckedPackLineIssourceList", params);
	}
	
	@Override
	public Map<String, Object> validatePolLineCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePolLineCd", params);
		Debug.print(params);
		return params ;
	}
	
	@Override
	public Map<String, Object> validateLineCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePurgeLineCd", params);
		log.info("dao :" + params.toString());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> validateLineCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return (List<GIISLine>) this.sqlMapClient.queryForList("validateLineCdGiexs006", params);
	}

	@Override
	public GIISLine getGiisLineGiuts036(String lineCd)
			throws SQLException {
		return (GIISLine) this.sqlMapClient.queryForObject("getLineCdGiuts036", lineCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getAllRecapsCd()
			throws SQLException {
		return this.sqlMapClient.queryForList("getRecapsCdList");
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInvoice(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISLine> setRows = (List<GIISLine>) allParams.get("setRows");
		List<GIISLine> delRows = (List<GIISLine>) allParams.get("delRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("start of saving Line");
			
			
			
			for(GIISLine del : delRows){
				log.info("DELETING: "+ del);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", del.getLineCd());
				this.getSqlMapClient().delete("deleteLineMaintenanceRow", params);
			}
			for(GIISLine set : setRows){
				log.info("INSERTING: "+ set);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", set.getLineCd());
				params.put("lineName", set.getLineName());
				params.put("acctlineCd", set.getAcctlineCd());
				params.put("menuLineCd", set.getMenuLineCd());
				params.put("recapsLineCd", set.getRecapsLineCd());
				params.put("minPremAmt", set.getMinPremAmt());
				params.put("remarks", set.getRemarks());
				params.put("packPolFlag", set.getPackPolFlag());
				params.put("profCommTag", set.getProfCommTag());
				params.put("nonRenewalTag", set.getNonRenewalTag());
				params.put("appUser", set.getAppUser()); // added By Kenneth L. 04.21.2014
				this.sqlMapClient.insert("setLineMaintenanceRow", params);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Line.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validateDeleteLine(String lineCdToDelete) throws SQLException {
		log.info("start of validating Line");
		return (String) this.sqlMapClient.queryForObject("validateDeleteLine", lineCdToDelete);
				
	}

	@Override
	public String validateAddLine(String lineCdToAdd) throws SQLException {
		log.info("start of validating Line");
		return (String) this.sqlMapClient.queryForObject("validateAddLine", lineCdToAdd);
	}

	@Override
	public String validateAcctLineCd(String acctLineCd)
			throws SQLException {
		log.info("start of validating Line");
		return (String) this.sqlMapClient.queryForObject("validateAcctLineCd", acctLineCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getLineListingLOV(Map<String, Object> params)	throws SQLException {
		return this.sqlMapClient.queryForList("getLineListingLOV", params);
	}

	@Override
	public String validateLineCdGiris051(Map<String, Object> params)
			throws SQLException {
		log.info("Start validating GIRIS051 Line");
		return (String) this.sqlMapClient.queryForObject("validateLineCd", params);
	}

	@Override
	public String getLineCd(String lineName) throws SQLException {
		log.info("Validating Line Name...");
		return (String) this.sqlMapClient.queryForObject("getLineCd", lineName);
	}

	@Override
	public Map<String, Object> getLineNameGicls201(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Line Name for GICLS201..."+params.toString());
		this.sqlMapClient.update("getLineNameGicls201", params);
		return params;
	}

	@Override
	public String validateGIRIS051LinePPW(String lineName) throws SQLException {
		log.info("Validating Line Name for GIRIS051 Expiry PPW..."+lineName);
		this.sqlMapClient.queryForObject("validateGIRIS051LinePPW", lineName);
		return (String) this.sqlMapClient.queryForObject("validateGIRIS051LinePPW", lineName);
	}

	@Override
	public String validateLineCd2(String lineCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateLineCd2", lineCd);
	}

	@Override
	public Map<String, Object> validateGIACS102LineCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIACS102LineCd", params);
		return params;
	}
	//added by steven 12.12.2013
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss001(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLine> delList = (List<GIISLine>) params.get("delRows");
			for(GIISLine d: delList){
				this.sqlMapClient.update("delGIISLine", d.getLineCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISLine> setList = (List<GIISLine>) params.get("setRows");
			for(GIISLine s: setList){
				this.sqlMapClient.update("setGIISLine", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteGIISLine", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGIISLine", params);		
	}
	
	@Override
	public void valMenuLineCd(String recId) throws SQLException {
		this.sqlMapClient.update("valMenuLineCd", recId);
	}
	//end steven

	@Override
	public String getGiisLineName2(String lineCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getLineName", lineCd);
	}
}
