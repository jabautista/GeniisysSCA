package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIEndtParItemMCDAO;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIEndtParItemMCDAOImpl implements GIPIEndtParItemMCDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIPIParMortgageeDAOImpl.class);
	
	/**
	 * Gets the sql map client.
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

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#getGIPIEndtParItemMC(int, int)
	 */
	@Override
	public GIPIParItemMC getGIPIEndtParItemMC(int parId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		return (GIPIParItemMC) this.getSqlMapClient().queryForObject("getGIPIEndtParItemMC", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#getGIPIEndtParItemMCs(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIParItemMC> getGIPIEndtParItemMCs(int parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIEndtParItemMCs", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#getEndtTax(int)
	 */
	@Override
	public String getEndtTax(int parId) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("getEndtTax", parId);
	}

	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkIfDiscountExists", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#deleteItem(int, int, int)
	 */
	@Override
	public boolean deleteItem(int parId, int[] itemNo, int currentItemNo)
			throws SQLException {
		log.info("Deleting item...");
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("currentItemNo", currentItemNo);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			log.info("Current item no : " + currentItemNo);
			
			for(int i = 0; i < itemNo.length; i++){
				log.info("Deleting item no. : " + itemNo[i]);
				params.put("itemNo", itemNo[i]);
				this.getSqlMapClient().delete("deleteItem", params);
			}
			log.info("Items successfully deleted.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return true;
	}

	@Override
	public String addItem(int parId, int[] itemNo) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		boolean error = false;
		log.info("Adding item...");
		try{
			params.put("parId", parId);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			
			for(int i = 0; i < itemNo.length; i++){
				log.info("Adding item no. : " + itemNo[i]);
				params.put("itemNo", itemNo[i]);
				this.getSqlMapClient().insert("addItem", params);
				
				if (params.get("message") != null) {
					if (!params.get("message").equals("SUCCESS")) {
						error = true;
						break;
					}
				}
			}
			
			if (!error) {
				log.info("Items successfully added.");
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().commitTransaction();
			}
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params.get("message") == null ? "" : params.get("message").toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#checkAddtlInfo(int)
	 */
	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		return (String)this.sqlMapClient.queryForObject("checkAddtlInfo", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#populateOrigItmperil(int)
	 */
	@Override
	public String populateOrigItmperil(int parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		
		log.info("Populating Orig Itmperil for Par : " + parId);
		
		this.getSqlMapClient().update("populateOrigItmperil", params);
		
		return params.get("message") == null ? "" : params.get("message").toString();
	}

	@Override
	public int getDistNo(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return Integer.parseInt(this.sqlMapClient.queryForObject("getDistNo", parId).toString());
	}

	@Override
	public String deleteDistribution(int parId, int distNo) throws SQLException {
		// TODO Auto-generated method stub
		log.info("Deleting item...");
		String message = "SUCCESS";
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("distNo", distNo);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			log.info("dist no : " + distNo);
			
			log.info("Deleting distribution...");
			
			this.getSqlMapClient().delete("deleteDistribution", params);
			
			message = (String)params.get("message");
			message = message == null ? "SUCCESS" : message;
			
			if (message.equals("SUCCESS")) {
				log.info("Distribution successfully deleted.");
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().commitTransaction();
			}
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public boolean deleteWinvRecords(int parId) throws SQLException {
		// TODO Auto-generated method stub
		this.getSqlMapClient().delete("deleteDistribution", parId);
		return true;
	}

}
