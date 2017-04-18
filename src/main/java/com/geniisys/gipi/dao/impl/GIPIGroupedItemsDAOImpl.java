package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.gipi.dao.GIPIGroupedItemsDAO;
import com.geniisys.gipi.entity.GIPIGroupedItems;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIGroupedItemsDAOImpl implements GIPIGroupedItemsDAO {
	
	private Logger log = Logger.getLogger(GIPIGroupedItemsDAOImpl.class);	
	
	private SqlMapClient sqlMapClient;	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIGroupedItems> getGIPIGroupedItemsEndt(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPI_GROUPED_ITEMS for endorsement - "+params);
		return this.getSqlMapClient().queryForList("getGIPIGroupedItemdEndt", params);		
	}

	@Override
	public String checkIfGroupItemIsZeroOutOrNegated(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Checking if record is zero out or negated ...");
		return (String) this.getSqlMapClient().queryForObject("checkIfGroupItemIsZeroOutOrNegated", params);
	}

	@Override
	public String checkIfPrincipalEnrollee(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if principal enrollee ...");
		return (String) this.getSqlMapClient().queryForObject("checkIfPrincipalEnrollee", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIGroupedItems> getCasualtyGroupedItems(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getCasualtyGroupedItems",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIGroupedItems> getAccidentGroupedItems(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getAccidentGroupedItems",params);
	}
	
}
