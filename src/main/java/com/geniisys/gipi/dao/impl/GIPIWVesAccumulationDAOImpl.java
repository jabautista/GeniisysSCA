package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWVesAccumulationDAO;
import com.geniisys.gipi.entity.GIPIWVesAccumulation;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GIPIWVesAccumulationDAOImpl implements GIPIWVesAccumulationDAO {
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIPIWVesAccumulation.class);	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWVesAccumulation> getGIPIWVesAccumulation(Integer parId)
			throws SQLException {
		log.info("DAO calling getGIPIWVesAccumulation ...");
		return (List<GIPIWVesAccumulation>) StringFormatter.escapeHTMLJavascriptInList(this.getSqlMapClient().queryForList("getGIPIWVesAccumulation", parId));
	}

}
