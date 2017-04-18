package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXPolwcDAO;
import com.geniisys.gixx.entity.GIXXPolwc;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXPolwcDAOImpl implements GIXXPolwcDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXPolwcDAOImpl.class);
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<GIXXPolwc> getGIXXRelatedWcInfo(Map<String, Object> params) throws SQLException {
		log.info("Retrieving related warranties and clauses for extractId=" + params.get("extractId"));
		return this.getSqlMapClient().queryForList("getGIXXRelatedWcInfo", params);
	}
	
}
