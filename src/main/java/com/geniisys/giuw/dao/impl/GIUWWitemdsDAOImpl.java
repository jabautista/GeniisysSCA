package com.geniisys.giuw.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giuw.dao.GIUWWitemdsDAO;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.ibatis.sqlmap.client.SqlMapClient;


public class GIUWWitemdsDAOImpl implements GIUWWitemdsDAO {
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWWitemds> getGiuwWitemdsForDistrFinal(
			HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiuwWitemdsForDistrFinal", params);
	}
	
	// added by jhing 12.05.2014 for batch soln to FULLWEB SIT SR0003785, SR0003784, SR0003783, SR0003721, SR0003712, SR0003451, SR0003720, SR0002871
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGiuwWitemdsOthPgeDistGrps (		
			HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiuwWitemdsOthPageDistGrps", params);
	}		
	
}
