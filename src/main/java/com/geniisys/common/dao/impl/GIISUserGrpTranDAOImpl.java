/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.dao.GIISUserGrpTranDAO;
import com.geniisys.common.entity.GIISTransaction;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.geniisys.common.entity.GIISUserGrpTran;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserGrpTranDAOImpl.
 */
public class GIISUserGrpTranDAOImpl implements GIISUserGrpTranDAO {

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
	 * @see com.geniisys.common.dao.GIISUserGrpTranDAO#getGiisUserGrpTranList(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISTransaction> getGiisUserGrpTranList(int userGrp) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserGrpTranList", userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpTranDAO#deleteGiisUserGrpTran(com.geniisys.common.entity.GIISUserGrpTran)
	 */
	@Override
	public void deleteGiisUserGrpTran(GIISUserGrpTran userGrpTran) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserGrpTran", userGrpTran);
	}

	@Override
	public void valAddUserGrpTran(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("valAddUserGrpTran", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveUserGrpTran(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISUserGrpTran> delList = (List<GIISUserGrpTran>) params.get("delTranRows");
			for(GIISUserGrpTran d: delList){
				this.getSqlMapClient().update("delUserGrpTran", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpTran> setList = (List<GIISUserGrpTran>) params.get("setTranRows");
			for(GIISUserGrpTran s: setList){
				this.getSqlMapClient().update("setUserGrpTran", s);
				this.getSqlMapClient().update("giiss041IncAllModules", s);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpDtl> delDtlList = (List<GIISUserGrpDtl>) params.get("delDtlRows");
			for(GIISUserGrpDtl d: delDtlList){
				this.getSqlMapClient().update("delUserGrpDtl", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpDtl> setDtlList = (List<GIISUserGrpDtl>) params.get("setDtlRows");
			for(GIISUserGrpDtl s: setDtlList){
				this.getSqlMapClient().update("setUserGrpDtl", s);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpLine> delLineList = (List<GIISUserGrpLine>) params.get("delLineRows");
			for(GIISUserGrpLine d: delLineList){
				this.getSqlMapClient().update("delUserGrpLine", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISUserGrpLine> setLineList = (List<GIISUserGrpLine>) params.get("setLineRows");
			for(GIISUserGrpLine s: setLineList){
				this.getSqlMapClient().update("setUserGrpLine", s);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
