package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.dao.GIRIEndttextDAO;
import com.geniisys.giri.entity.GIRIEndttext;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIEndttextDAOImpl implements GIRIEndttextDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIRIEndttextDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> getRiDtlsGIUTS024(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getRiDtlsGIUTS024", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIEndttext> getRiDtlsList(HashMap<String, Object> params)
			throws SQLException {
		log.info("Getting Reinsurance Details List...");
		return this.getSqlMapClient().queryForList("getRiDtlsList", params);
	}

	@Override
	public void updateCreateEndtTextBinder(Map<String, Object> params)
			throws Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateCreateEndtTextBinder", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void deleteRiDtlsGIUTS024(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().delete("deleteRiDtlsGIUTS024", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtTextBinder(Map<String, Object> params)
			throws SQLException {
		List<GIRIEndttext> setItemRows = (List<GIRIEndttext>) params.get("setItemRows");
		List<GIRIEndttext> delItemRows = (List<GIRIEndttext>) params.get("delItemRows");
		String userId = (String) params.get("userId");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
		
			for (GIRIEndttext item : delItemRows){
				log.info("deleteRiDtlsGIUTS024");
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("riCd", item.getRiCd());
				params2.put("fnlBinderId", item.getFnlBinderId());
				System.out.println("params2::::::::::::::::::::::::::::"+params2);
				this.getSqlMapClient().delete("deleteRiDtlsGIUTS024", params2);
			}			
			this.sqlMapClient.executeBatch();
			
			for (GIRIEndttext item : setItemRows){
				log.info("updateCreateEndtTextBinder");
				item.setAppUser(userId);
				this.getSqlMapClient().insert("updateCreateEndtTextBinder", item);
			}
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
}
