package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXVehicleDAO;
import com.geniisys.gixx.entity.GIXXVehicle;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXVehicleDAOImpl implements GIXXVehicleDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXVehicleDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	
	/*@SuppressWarnings("unchecked")
	@Override
	public List<GIXXVehicle> getGIXXCargoCarrierTG(Map<String, Object> params) throws SQLException {
		log.info("Retrieving list of cargo carriers...");
		return this.getSqlMapClient().queryForList("getGIXXCargoCarrierTG", params);
	}*/
	
	@Override
	public GIXXVehicle getGIXXVehicleInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Vehicle information...");
		return (GIXXVehicle) this.getSqlMapClient().queryForObject("getGIXXVehicleItemInfo", params);
	}
	
	

}
