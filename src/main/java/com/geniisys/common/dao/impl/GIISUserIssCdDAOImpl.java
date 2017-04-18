/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISUserIssCdDAO;
import com.geniisys.common.entity.GIISUserIssCd;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;


/**
 * The Class GIISUserIssCdDAOImpl.
 */
public class GIISUserIssCdDAOImpl implements GIISUserIssCdDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIISUserDAOImpl.class);
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
	 * @see com.geniisys.common.dao.GIISUserIssCdDAO#deleteGiisUserIssCd(java.lang.String)
	 */
	@Override
	public void deleteGiisUserIssCd(String userID) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserIssCd", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserIssCdDAO#getGiisUserIssCdList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserIssCd> getGiisUserIssCdList(String userID) throws SQLException {
		log.info("getGiisUserIssCdList");
		return this.getSqlMapClient().queryForList("getGiisUserIssCdList", userID);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserIssCdDAO#setGiisUserIssCd(com.geniisys.common.entity.GIISUserIssCd)
	 */
	@Override
	public void setGiisUserIssCd(GIISUserIssCd userIssCd) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserIssCd", userIssCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#checkUserPerIssCdAcctg2(java.util.Map)
	 */
	@Override
	public String checkUserPerIssCdAcctg2(Map<String, Object> params)
			throws SQLException {
		//log.info("checkUserPerIssCdAcctg2...");
		Debug.print("checkUserPerIssCdAcctg2 - "+params);
		return (String) this.getSqlMapClient().queryForObject("checkUserPerIssCdAcctg2", params);
	}
}
