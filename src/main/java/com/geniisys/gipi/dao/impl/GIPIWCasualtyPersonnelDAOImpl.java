package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWCasualtyPersonnelDAO;
import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;
import com.ibatis.sqlmap.client.SqlMapClient;


public class GIPIWCasualtyPersonnelDAOImpl implements GIPIWCasualtyPersonnelDAO{

	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIPIWCasualtyPersonnelDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCasualtyPersonnel> getGipiWCasualtyPersonnel(Integer parId)
			throws SQLException {
		log.info("DAO calling getGipiWCasualtyPersonnel ...");
		return this.getSqlMapClient().queryForList("getGipiWCasualtyPersonnel", parId);
	}
	
	@Override
	public Map<String, Object> getCasualtyPersonnelDetails(
			Map<String, Object> params) throws SQLException {
		log.info("DAO calling getCasualtyPersonnelDetails ...");
		this.getSqlMapClient().queryForObject("getCasualtyPersonnelDetails", params);
		return params;		
	}

}
