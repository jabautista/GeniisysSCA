/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWPolBasicDAO;
import com.geniisys.gipi.entity.GIPIWPolBasic;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWPolBasicDAOImpl.
 */
public class GIPIWPolBasicDAOImpl implements GIPIWPolBasicDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolBasicDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolBasicDAO#getWPolBasicFromPar(java.lang.Integer)
	 */
	@Override
	public GIPIWPolBasic getWPolBasicFromPar(Integer parId) throws SQLException {
		GIPIWPolBasic polbas = (GIPIWPolBasic) this.getSqlMapClient().queryForObject("getSublineCdFromPar", parId);
		return polbas;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolBasicDAO#getExpiryDate(java.lang.Integer)
	 */
	@Override
	public Date getExpiryDate(Integer parId) throws SQLException {
		return (Date) this.getSqlMapClient().queryForObject("getExpiryDate", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolBasicDAO#updatePackWPolbas(java.lang.Integer)
	 */
	@Override
	public void updatePackWPolbas(Integer packParId) throws SQLException {
		log.info("Updating pack polbasic info...");
		this.getSqlMapClient().queryForObject("updatePackWPolbas", packParId);
		log.info("Update successful.");
	}

	@Override
	public String getAcctOfName(Integer parId) throws SQLException {
		log.info("Obtaining account name...");
		return (String) this.getSqlMapClient().queryForObject("getAcctOfName", parId);
	}

	@Override
	public String getTakeupTerm(Integer parId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getTakeupTerm", parId);
	}

	@Override
	public void validateBookingDate2(HashMap<String, Object> params)
			throws SQLException {
		try{
			log.info("Validating Booking Date...");
			this.getSqlMapClient().queryForObject("validateBookingDate2",params);
		}catch(SQLException e){
			throw e;
		}
	}

}
