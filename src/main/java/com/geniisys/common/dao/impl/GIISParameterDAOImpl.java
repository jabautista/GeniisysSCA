/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.dao.GIISParameterDAO;
import com.geniisys.common.entity.GIISParameter;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISParameterDAOImpl.
 */
public class GIISParameterDAOImpl implements GIISParameterDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISParameterDAO#getParamValueV(GIISParameter)
	 */
	@Override
	public GIISParameter getParamValueV(String paramName) throws SQLException {
		return (GIISParameter) this.getSqlMapClient().queryForObject("getParamValueV", paramName);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISParameterDAO#getParamValueV(java.lang.String)
	 */
	@Override
	public String getParamValueV2(String paramName) throws SQLException {
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("paramName", paramName);
		return (String) this.getSqlMapClient().queryForObject("getParamValueV2", params);
	}

	@Override
	public Integer getParamValueN(String paramName1) throws SQLException {
		//HashMap<String, Object> params = new HashMap<String, Object>();
		//params.put("paramName1", paramName1);
		Integer paramValueN = (Integer)this.getSqlMapClient().queryForObject("getParamValueN", paramName1);
		return paramValueN;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISParameter> getParamValues(String paramName) throws SQLException {
		return (List<GIISParameter>)this.getSqlMapClient().queryForList("getParamValues", paramName);
	}

	@Override
	public String getParamByIssCd(String paramName) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getParamByIssCd", paramName);
	}

	@Override
	public String getEngineeringParameterizedSubline(String sublineName)
			throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("getEngineeringParamSublineCd", sublineName);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISParameterDAO#getENParamSublineNames(java.lang.String)
	 */
	@Override
	public String getENParamSublineNames(String sublineCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getEngineeringSublineNames", sublineCd);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISParameter> getAllENParamSublineNames() throws SQLException {
		return this.getSqlMapClient().queryForList("getAllEngParamSublineNames");
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getContextParameters() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getContextParameters");
	}
	
	@Override
	public Map<String, Object> initializeParamsGIEXS001(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("initializeParamsGIEXS001", params);
		Debug.print(params);
		return params ;
	}

	@Override
	public Map<String, Object> initDateFormatGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("initDateFormatGIEXS004", params);
		return params;
	}

	@Override
	public Map<String, Object> initLineCdGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("initLineCdGIEXS004", params);
		return params;
	}

	@Override
	public Map<String, Object> initSublineCdGIEXS004(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("initSublineCdGIEXS004", params);
		return params;
	}

	@Override
	public String getFormattedSysdate() throws SQLException {		
		return (String) this.sqlMapClient.queryForObject("getFormattedSysdate");
	}

	@Override
	public Map<String, Object> getGiiss085Rec(Map<String, Object> params)
			throws SQLException {	
		HashMap<String, Object> param = new HashMap<String, Object>();	
		param.put("paramName", (String) params.get("paramName"));		
		param.put("currRecord", this.sqlMapClient.queryForObject("getGiiss085Rec",params));
		return param;	
	}		
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss085(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();	
			List<GIISParameter> setList = (List<GIISParameter>) params.get("parameters");
			for(GIISParameter s: setList){
				this.sqlMapClient.update("setGiiss085", s);		
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

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss061(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();	
			List<GIISParameter> setList = (List<GIISParameter>) params.get("setRows");
			for(GIISParameter s: setList){
				this.sqlMapClient.update("setGiiss061", s);		
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valAddProgramParameter", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteProgramParameter", params);
	}
	
	@Override
	public void valAssdNameFormat(String assdNameFormat) throws SQLException {
		this.sqlMapClient.update("valAssdNameFormat", assdNameFormat);		
	}
	
	@Override
	public void valIntmNameFormat(String intmNameFormat) throws SQLException {
		this.sqlMapClient.update("valIntmNameFormat", intmNameFormat);		
	}
	
	@Override
	public void valGisms011AddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddNetworkNumber", params);		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGisms011(Map<String, Object> params) throws SQLException, JSONException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();	
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			for (Map<String, Object> s : setRows) {
				this.sqlMapClient.update("setGisms011", s);	
			}	
			this.sqlMapClient.executeBatch();	
			
			List<Map<String, Object>> delRows = (List<Map<String, Object>>) params.get("delRows");
			for (Map<String, Object> d : delRows) {
				this.sqlMapClient.update("delGisms011", d);	
			}	
			this.sqlMapClient.executeBatch();
			
			List<Map<String, Object>> nameFormat = (List<Map<String, Object>>) params.get("nameFormat");
			for (Map<String, Object> n : nameFormat) {
				this.sqlMapClient.update("setGisms011NameFormat", n);	
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

}
