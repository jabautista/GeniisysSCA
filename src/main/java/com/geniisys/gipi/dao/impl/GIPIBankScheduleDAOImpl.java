package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.dao.GIPIBankScheduleDAO;
import com.geniisys.gipi.entity.GIPIBankSchedule;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIBankScheduleDAOImpl implements GIPIBankScheduleDAO{
	
	private SqlMapClient sqlMapClient;
	
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}


	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIBankSchedule> getBankCollections(HashMap<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getBankCollections", params);
	}

}
