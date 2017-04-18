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

import org.json.JSONException;

import com.geniisys.common.dao.GIISUserGrpLineDAO;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserGrpLineDAOImpl.
 */
public class GIISUserGrpLineDAOImpl implements GIISUserGrpLineDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpLineDAO#getGiisUserGrpLineList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserGrpLine> getGiisUserGrpLineList(String userGrp) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserGrpLineList", userGrp);
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
	 * @see com.geniisys.common.dao.GIISUserGrpLineDAO#setGiisUserGrpLine(com.geniisys.common.entity.GIISUserGrpLine)
	 */
	@Override
	public void setGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserGrpLine", giisUserGrpLine);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpLineDAO#deleteGiisUserGrpLine(com.geniisys.common.entity.GIISUserGrpLine)
	 */
	@Override
	public void deleteGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserGrpLine", giisUserGrpLine);
	}

	@Override
	public void valDeleteLine(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteLineGiiss041", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllLineCodes(Map<String, Object> params)
			throws SQLException, JSONException {
		return this.getSqlMapClient().queryForList("getAllLineCodesGiiss041", params);
	}

}
