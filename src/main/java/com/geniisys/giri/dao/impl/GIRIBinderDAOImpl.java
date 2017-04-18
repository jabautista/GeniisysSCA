package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giri.dao.GIRIBinderDAO;
import com.geniisys.giri.entity.GIRIBinder;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIBinderDAOImpl implements GIRIBinderDAO{
	
	private Logger log = Logger.getLogger(GIRIDistFrpsDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIBinderDAO#getPostedDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPostedDtls(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getPostedDtls", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIBinderDAO#updateGiriBinderGiris026(java.util.Map)
	 */
	@Override
	public void updateGiriBinderGiris026(Map<String, Object> params) throws SQLException {
		try{
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> modifiedBinderDtls = (List<Map<String, Object>>) params.get("modifiedBinderDtls");
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(Map<String, Object> modifiedBinderDtl: modifiedBinderDtls){
				Debug.print("Map of updated info: " + modifiedBinderDtl);
				modifiedBinderDtl.put("appUser", params.get("appUser"));
				this.sqlMapClient.update("updateGiriBinderGiris026", modifiedBinderDtl);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIBinderDAO#checkIfBinderExists(java.lang.String)
	 */
	@Override
	public String checkIfBinderExists(String parId) throws SQLException {
		log.info("Checking if posted binder exists...");
		return (String) this.getSqlMapClient().queryForObject("checkIfBinderExists", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giri.dao.GIRIBinderDAO#updateRevSwRevDate(java.lang.String)
	 */
	@Override
	public void updateRevSwRevDate(String parId) throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();

			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.update("updateRevSwRevDate", parId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<GIRIBinder> getBinderDetails(Map<String, Object> params)
	throws SQLException {
		log.info("getBinderDetails");
		return sqlMapClient.queryForList("getBinderDetails", params);
	}

	@Override
	public void updateBinderPrintDateCnt(Integer fnlBinderId)
			throws SQLException {
		log.info("updateBinderPrintDateCnt");
		this.getSqlMapClient().update("updateBinderPrintDateCnt", fnlBinderId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getFnlBinderId(Map<String, Object> params)
			throws SQLException {
		log.info("getFnlBinderId");
		return sqlMapClient.queryForList("getFnlBinderId", params);
	}

	@Override
	public void updateAcceptanceInfo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("updateAcceptanceInfo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBinders(Integer policyId) throws SQLException {
		return this.getSqlMapClient().queryForList("getBinders", policyId);
	}

	@Override
	public HashMap<String, Object> updateBinderStatusGIUTS012(
			HashMap<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateBinderStatusGIUTS012", params);
			this.sqlMapClient.executeBatch();
			
			System.out.println("updateBinderStatusGIUTS012 params: " + params);
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBinder(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getBinder", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPolicyFrps(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getPolicyFrps", params);
	}

	@Override
	public String checkBinderAccess(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giris015CheckBinderAccess", params);
	}
	
	//benjo 07.20.2015 UCPBGEN-SR-19626
	@Override
	public void checkRIPlacementAccess(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giris015CheckRIPlacementAccess", params);
	}
}

