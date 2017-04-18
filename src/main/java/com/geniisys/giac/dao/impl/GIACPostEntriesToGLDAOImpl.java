package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACPostEntriesToGLDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPostEntriesToGLDAOImpl implements GIACPostEntriesToGLDAO{

	private Logger log = Logger.getLogger(GIACPostEntriesToGLDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Integer getGLNo() throws SQLException {		
		return (Integer) this.sqlMapClient.queryForObject("getGIACS410GLNo");
	}

	@Override
	public Integer getFinanceEnd() throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getGIACS410FinanceEnd");
	}

	@Override
	public Integer getFiscalEnd() throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getGIACS410FiscalEnd");
	}

	@Override
	public Integer validateTranYear(String tranYear) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("validateGIACS410TranYear", tranYear);
	}

	@Override
	public String validateTranMonth(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateGIACS410TranMonth", params);
	}

	@Override
	public void checkIsPrevMonthClosed(Map<String, Object> params)throws SQLException {
		this.sqlMapClient.update("checkIsPrevMonthClosed", params);
	}

	@Override
	public Map<String, Object> postToGL(Map<String, Object> params) throws SQLException {
		System.out.println("Post to GL params: " + params.toString());
		this.sqlMapClient.update("postToGL", params);
		return params;
	}

}
