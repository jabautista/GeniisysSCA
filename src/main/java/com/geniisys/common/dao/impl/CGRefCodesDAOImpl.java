package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.CGRefCodesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class CGRefCodesDAOImpl implements CGRefCodesDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	/** The logger **/
	private Logger log = Logger.getLogger(CGRefCodesDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.CGRefCodesDAO#checkCharRefCodes(java.util.Map)
	 */
	@Override
	public void checkCharRefCodes(Map<String, Object> params)
			throws SQLException {
		log.info("check char ref codes");
		this.getSqlMapClient().update("checkCharRefCodes", params);
	}

	@Override
	public String validateMemoType(String memoType) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("validateMemoType", memoType);
	}

	@Override
	public String validateGIACS127TranClass(Map<String, Object> params)
			throws SQLException {
		return  (String) this.getSqlMapClient().queryForObject("validateGIACS127TranClass", params);
	}

	@Override
	public String validateGIACS127JVTran(String jvTranCd) throws SQLException {
			return (String) this.getSqlMapClient().queryForObject("validateGIACS127JVTran", jvTranCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getFileSourceList() throws SQLException {
		// TODO Auto-generated method stub
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getGIACS601Transactions");
	}

}
