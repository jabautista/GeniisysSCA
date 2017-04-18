package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.dao.GIACAdvancedPaytDAO;
import com.geniisys.giac.entity.GIACAdvancedPayt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAdvancedPaytDAOImpl implements GIACAdvancedPaytDAO {
	
	private SqlMapClient sqlMapClient;
	
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void deleteGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPayt)
			throws SQLException {
		
		this.getSqlMapClient().queryForObject("deleteGIACAdvancedPaytEntityParam", giacAdvancedPayt);
	}

	@Override
	public void deleteGIACAdvancedPayt(Map<String, Object> params)
			throws SQLException {
		
		this.getSqlMapClient().queryForObject("deleteGIACAdvancedPaytMapParam", params);
	}

	@Override
	public void setGIACAdvancedPayt(GIACAdvancedPayt giacAdvancedPaytDtls)
			throws SQLException {
		
		this.getSqlMapClient().queryForObject("setGIACAdvancedPayt", giacAdvancedPaytDtls);
	}

	
}
