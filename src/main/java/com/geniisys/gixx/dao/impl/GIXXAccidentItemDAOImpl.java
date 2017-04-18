package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.controller.GIXXAccidentItemController;
import com.geniisys.gixx.dao.GIXXAccidentItemDAO;
import com.geniisys.gixx.entity.GIXXAccidentItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXAccidentItemDAOImpl implements GIXXAccidentItemDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXAccidentItemDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public GIXXAccidentItem getGIXXAccidentItemInto(Map<String, Object> params) throws SQLException {
		log.info("retrieving accident item info for extractId=" +params.get("extractId") + " and itemNo=" + params.get("itemNo") );
		return (GIXXAccidentItem) this.getSqlMapClient().queryForObject("getGIXXAccidentItem", params);
	}

}
