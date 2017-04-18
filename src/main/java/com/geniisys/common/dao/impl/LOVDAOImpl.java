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

import com.geniisys.common.dao.LOVDAO;
import com.geniisys.common.entity.LOV;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class LOVDAOImpl.
 */
public class LOVDAOImpl implements LOVDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;

	/** The log. */
	Logger log = Logger.getLogger(LOVDAOImpl.class);

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.common.dao.LOVDAO#getListREFCODES(java.lang.String,
	 * java.lang.String[])
	 */
	@Override
	@SuppressWarnings("unchecked")
	public List<LOV> getListREFCODES(String domain, String[] args)
			throws SQLException {
		return getSqlMapClient().queryForList("getCgRefCodesListing", domain);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see com.geniisys.common.dao.LOVDAO#getListPACKAGES(java.lang.String,
	 * java.lang.String[])
	 */
	@SuppressWarnings("unchecked")
	public List<LOV> getListPACKAGES(String domain, String[] args)
			throws SQLException {
		if (null != args) {			
			if (args.length > 1) {
				Map<String, String> params = new HashMap<String, String>();
				for (int x = 0; x < args.length; x++) {
					params.put("param" + (x + 1) + "", args[x]);
				}
				log.info("Params: " + params);
				return getSqlMapClient().queryForList(domain, params);
			} else {
				log.info(args[0]);
				return getSqlMapClient().queryForList(domain, args[0]);
			}
		} else {
			log.info("args is null.");
			return getSqlMapClient().queryForList(domain);
		}
	}

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
	 * @param sqlMapClient
	 *            the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

}
