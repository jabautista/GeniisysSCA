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

import com.geniisys.common.dao.GIISUserGrpDtlDAO;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserGrpDtlDAOImpl.
 */
public class GIISUserGrpDtlDAOImpl implements GIISUserGrpDtlDAO {

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
	 * @see com.geniisys.common.dao.GIISUserGrpDtlDAO#getGiisUserGrpDtlGrpList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserGrpDtl> getGiisUserGrpDtlGrpList(String userGrp) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserGrpDtlGrpList", userGrp);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpDtlDAO#setGiisUserGrpDtl(com.geniisys.common.entity.GIISUserGrpDtl)
	 */
	@Override
	public void setGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserGrpDtl", giisUserGrpDtl);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpDtlDAO#deleteGiisUserGrpDtl(com.geniisys.common.entity.GIISUserGrpDtl)
	 */
	@Override
	public void deleteGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserGrpDtl", giisUserGrpDtl);
	}

	@Override
	public void valAddDeleteDtl(Map<String, Object> params) throws SQLException {
		if(params.get("action").toString().equals("add")){
			this.getSqlMapClient().update("valAddUserGrpDtl", params);
		}else{
			this.getSqlMapClient().update("valDelUserGrpDtl", params);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllIssCodes(Map<String, Object> params)
			throws SQLException, JSONException {
		return this.getSqlMapClient().queryForList("getAllIssCodesGiiss041", params);
	}

}
