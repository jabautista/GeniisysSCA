/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACAgingSoaDetailDAO;
import com.geniisys.giac.entity.GIACAgingSoaDetail;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAgingSoaDetailDAOImpl implements GIACAgingSoaDetailDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACAgingSoaDetailDAOImpl.class);
	
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

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACAgingSoaDetail> getInstnoDetails(String issCd, Integer premSeqNo) throws SQLException {
		log.info("");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("issCd", issCd);
		param.put("premSeqNo", premSeqNo);
		System.out.println("Params: " + param);
		return (List<GIACAgingSoaDetail>) sqlMapClient.queryForList("getInstnoDetails", param);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPolicyDetails(Map<String, Object> params)
			throws SQLException {
		return (List<Map<String, Object>>) sqlMapClient.queryForList("getPolDetails", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAgingSoaDetailDAO#getAgingSoaDetails(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACAgingSoaDetail> getAgingSoaDetails(String keyword, String issCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("keyword", keyword);
		params.put("issCd", issCd);
		return this.getSqlMapClient().queryForList("getGiacAgingSOADetails", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBillInfo(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getBillInfo", params);
	}

	@Override
	public GIACAgingSoaDetail getInstInfo(Map<String, Object> params)
			throws SQLException {		
		return (GIACAgingSoaDetail) this.sqlMapClient.queryForObject("getInstInfo", params);
	}

	@Override
	public Map<String, Object> getPolicyDtlsGIACS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getPolicyDtlsGIACS007", params);
		return params;
	}

	@Override
	public GIACAgingSoaDetail getInvoiceSoaDetails(Map<String, Object> params) throws SQLException {
		return (GIACAgingSoaDetail) this.getSqlMapClient().queryForObject("getInvoiceSoaDetails", params);
	}

}
