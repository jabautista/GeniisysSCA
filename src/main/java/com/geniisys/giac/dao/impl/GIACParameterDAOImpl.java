package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACParameterDAO;
import com.geniisys.giac.entity.GIACParameter;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACParameterDAOImpl implements GIACParameterDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	private static Logger log = Logger.getLogger(GIACParameterDAOImpl.class);
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACParameterDAO#getParamValueN(java.lang.String)
	 */
	@Override
	public Integer getParamValueN(String paramName1) throws SQLException {
		Integer paramValueN = (Integer)this.getSqlMapClient().queryForObject("getGIACParamValueN", paramName1);
		return paramValueN;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACParameterDAO#getParamValueV(java.lang.String)
	 */
	@Override
	public GIACParameter getParamValueV(String paramName) throws SQLException {
		return (GIACParameter) this.getSqlMapClient().queryForObject("getGIACParamValueV", paramName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACParameterDAO#getParamValueV2(java.lang.String)
	 */
	@Override
	public String getParamValueV2(String paramName) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("paramName", paramName);
		String result = (String) this.getSqlMapClient().queryForObject("getGIACParamValueV2", params);
		log.info("GIAC PARAMETER: "+paramName);
		log.info("RETRIEVED GIAC PARAMETER: "+result);
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACParameterDAO#getParamValues(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACParameter> getParamValues(String paramName)
			throws SQLException {
		return (List<GIACParameter>)this.getSqlMapClient().queryForList("getGIACParamValues", paramName);
	}

	@Override
	public String getGlobalBranchCdByUserId(String paramName)
			throws SQLException {
		return (String) getSqlMapClient().queryForObject("getGlobalBranchCdByUserId", paramName);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs301(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACParameter> delList = (List<GIACParameter>) params.get("delRows");
			for(GIACParameter d: delList){
				this.sqlMapClient.update("delAcctgParameters", d.getParamName());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACParameter> setList = (List<GIACParameter>) params.get("setRows");
			for(GIACParameter s: setList){
				this.sqlMapClient.update("setAcctgParameters", s);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void valDeleteRec(String paramName) throws SQLException {
		this.sqlMapClient.update("valDeleteAcctgParameters", paramName);
	}

	@Override
	public void valAddRec(String paramName) throws SQLException {
		this.sqlMapClient.update("valAddAcctgParameters", paramName);		
	}
	
	//john 10.23.2014
	@Override
	public BigDecimal getParamValueN2(String paramName1) throws SQLException {
		BigDecimal paramValueN = (BigDecimal)this.getSqlMapClient().queryForObject("getGIACParamValueN3", paramName1);
		return paramValueN;
	}

}
