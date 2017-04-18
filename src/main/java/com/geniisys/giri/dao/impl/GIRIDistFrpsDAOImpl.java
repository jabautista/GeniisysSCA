package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.giri.dao.GIRIDistFrpsDAO;
import com.geniisys.giri.entity.GIRIDistFrps;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIDistFrpsDAOImpl implements GIRIDistFrpsDAO{

	private Logger log = Logger.getLogger(GIRIDistFrpsDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIDistFrps> getGIRIFrpsList(HashMap<String, Object> params)
			throws SQLException {
		List<GIRIDistFrps> frpsList = new ArrayList<GIRIDistFrps>();
		frpsList = this.getSqlMapClient().queryForList("getGIRIFrpsListTableGrid", params);
		return frpsList;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDistFrpsWDistFrpsV(
			Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getDistFrpsWDistFrpsV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap<String, Object>> getGIRIWFrperils(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting GIRI_WFrperil list..."+params);
		return this.getSqlMapClient().queryForList("getGIRIWFrperil", params);
	}

	@Override
	public HashMap<String, Object> getWFrperilSums(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting WFrPeril Sums...");
		this.getSqlMapClient().update("getWFrperilSums", params);
		return (HashMap<String, Object>) params;
	}
	
	@Override
	public Map<String, Object> updateDistFrpsGiuts004(Map<String, Object> params)
		throws SQLException {
		this.getSqlMapClient().update("updateDistFrpsGiuts004", params);
		Debug.print(params);
		return params ;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getDistFrpsWDistFrpsV2(Map<String, Object> params) throws SQLException {
		Debug.print(params);
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getDistFrpsWDistFrpsV2", params);
	}

}
