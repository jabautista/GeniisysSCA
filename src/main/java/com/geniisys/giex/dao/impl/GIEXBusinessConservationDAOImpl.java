package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.framework.util.Debug;
import com.geniisys.giex.dao.GIEXBusinessConservationDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXBusinessConservationDAOImpl implements GIEXBusinessConservationDAO{
	private SqlMapClient sqlMapClient;
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> extractPolicies(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("extractPolicies", params);
		Debug.print(params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIEXExpiry> getBusConDetails(HashMap<String, Object> params)
			throws SQLException, JSONException {
		List<GIEXExpiry> expiryListing = new ArrayList<GIEXExpiry>();
		expiryListing = this.getSqlMapClient().queryForList("getBusConDetails", params);
		return expiryListing;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIEXExpiry> getBusConPackDetails(HashMap<String, Object> params)
			throws SQLException, JSONException {
		List<GIEXExpiry> packListing = new ArrayList<GIEXExpiry>();
		packListing = this.getSqlMapClient().queryForList("getBusConPackDetails", params);
		return packListing;
	}
}
