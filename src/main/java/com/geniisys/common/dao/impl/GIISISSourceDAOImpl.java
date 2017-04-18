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

import com.geniisys.common.dao.GIISISSourceDAO;
import com.geniisys.common.entity.GIISISSource;
import com.geniisys.common.entity.GIISIssourcePlace;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISISSourceDAOImpl.
 */
public class GIISISSourceDAOImpl implements GIISISSourceDAO{
	
	
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
	 * @see com.geniisys.common.dao.GIISISSourceDAO#getIssueSourceAllList()
	 */
	@SuppressWarnings("unchecked")
	public List<GIISISSource> getIssueSourceAllList() throws SQLException{
		return this.getSqlMapClient().queryForList("getIssueSourceAllList");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISISSourceDAO#getDefaultIssCd(java.lang.String, java.lang.String)
	 */
	@Override
	public String getDefaultIssCd(String riSwitch, String userId)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("riSwitch", riSwitch);
		param.put("userId", userId);
		return (String) this.getSqlMapClient().queryForObject("getDefaultIssCd", param);
	}
	
	@Override
	public Map<String, Object> validatePolIssCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePolIssCd", params);
		Debug.print(params);
		return params ;
	}
	
	@Override
	public Map<String, Object> validateIssCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validatePurgeIssCd", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> validateIssCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return (List<GIISISSource>) sqlMapClient.queryForList("validateIssCdGiexs006", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> getIssueSourceListing(Map<String, Object> params)	throws SQLException {
		return this.sqlMapClient.queryForList("getIssueSourceListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> getAllIssueSourceListing(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getAllIssueSourceListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISISSource> getIssueSourceListingLOV(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getIssueSourceListingLOV", params);
	}

	@Override
	public Map<String, Object> getIssNameGicls201(Map<String, Object> params)		throws SQLException {
		this.sqlMapClient.update("getIssNameGicls201", params);
		return params;
	}

	@Override
	public String getIssCdForBatchPosting(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getIssCdForBatchPosting", params);
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiiss004(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISISSource> delList = (List<GIISISSource>) params.get("delRows");
			for(GIISISSource d: delList){
				this.sqlMapClient.update("delISSource", d.getIssCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISISSource> setList = (List<GIISISSource>) params.get("setRows");
			for(GIISISSource s: setList){
				System.out.println("======== " +s.getIssCd());
				this.sqlMapClient.update("setISSource", s);
				System.out.println("===== done setISSource");
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteISSource", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddISSource", params);		
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiiss004Place(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISIssourcePlace> delList = (List<GIISIssourcePlace>) params.get("delRows");
			for(GIISIssourcePlace d: delList){
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("issCd", d.getIssCd());
				p.put("placeCd", d.getPlaceCd());
				this.sqlMapClient.update("delISSourcePlace", p);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISIssourcePlace> setList = (List<GIISIssourcePlace>) params.get("setRows");
			for(GIISIssourcePlace s: setList){
				System.out.println(s.toString());
				this.sqlMapClient.update("setISSourcePlace", s);
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
	public void valDeletePlaceRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteISSourcePlace", params);
	}

	@Override
	public void valAddPlaceRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddISSourcePlace", params);		
	}

	@Override
	public String getAcctIssCdList() throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getAcctIssCdList");
	}
}
