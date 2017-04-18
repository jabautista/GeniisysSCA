package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLReserveDsDAO;
import com.geniisys.gicl.entity.GICLReserveDs;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReserveDsDAOImpl implements GICLReserveDsDAO{

	private Logger log = Logger.getLogger(GICLReserveDsDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLReserveDsDAO#saveReserveDs(java.util.Map)
	 */
	@Override
	public String saveReserveDs(GICLReserveDs giclReserveDs) throws SQLException {
		log.info("Save Reserve DS - Start");
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().insert("saveReserveDS", giclReserveDs);
			this.getSqlMapClient().executeBatch();
		}catch (Exception e) {
			e.printStackTrace();
			log.error(e.getMessage());
			message = ExceptionHandler.handleException(e, null);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("save reserve ds - end");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public Map<String, Object> validateXolDeduc(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateXolDeducGICLS024", params);
		System.out.println("validateXolDeduc result: "+params);
		return params;
	}

	@Override
	public Map<String, Object> continueXolDeduc(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("continueXolDeducGICLS024", params);
		System.out.println("continueXolDeduc result: "+params);
		return params;
	}

	@Override
	public Map<String, Object> checkXOLAmtLimits(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkXOLAmtLimitsGICLS024", params);
		System.out.println("checkXOLAmtLimits result: "+params);
		return params;
	}

	@Override
	public Map<String, Object> updateShrLossResGICLS024(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateShrLossResGICLS024", params);
			this.sqlMapClient.executeBatch();
			
			Map<String, Object> clmResParams = new HashMap<String, Object>();
			clmResParams.put("userId", params.get("userId"));
			clmResParams.put("claimId", params.get("claimId"));
			clmResParams.put("perilCd", params.get("perilCd"));
			clmResParams.put("itemNo", params.get("itemNo"));
			clmResParams.put("lossReserve", params.get("c022LossReserve"));
			clmResParams.put("expenseReserve", params.get("c022ExpenseReserve"));
			this.getSqlMapClient().update("updateResAmtsGICLS024", clmResParams);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> resHistParams = new HashMap<String, Object>();
			resHistParams.put("userId", params.get("userId"));
			resHistParams.put("claimId", params.get("claimId"));
			resHistParams.put("clmResHistId", params.get("clmResHistId"));
			resHistParams.put("bookingMonth", params.get("bookingMonth"));
			resHistParams.put("bookingYear", params.get("bookingYear"));
			resHistParams.put("remarks", params.get("remarks"));
			this.getSqlMapClient().update("updateResHistGICLS024", resHistParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> updateShrPctGICLS024(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateShrPctGICLS024", params);
			this.sqlMapClient.executeBatch();
			
			Map<String, Object> clmResParams = new HashMap<String, Object>();
			clmResParams.put("userId", params.get("userId"));
			clmResParams.put("claimId", params.get("claimId"));
			clmResParams.put("perilCd", params.get("perilCd"));
			clmResParams.put("itemNo", params.get("itemNo"));
			clmResParams.put("lossReserve", params.get("c022LossReserve"));
			clmResParams.put("expenseReserve", params.get("c022ExpenseReserve"));
			this.getSqlMapClient().update("updateResAmtsGICLS024", clmResParams);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> resHistParams = new HashMap<String, Object>();
			resHistParams.put("userId", params.get("userId"));
			resHistParams.put("claimId", params.get("claimId"));
			resHistParams.put("clmResHistId", params.get("clmResHistId"));
			resHistParams.put("bookingMonth", params.get("bookingMonth"));
			resHistParams.put("bookingYear", params.get("bookingYear"));
			resHistParams.put("remarks", params.get("remarks"));
			this.getSqlMapClient().update("updateShrPctGICLS024", resHistParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public Map<String, Object> updateShrExpResGICLS024(
			Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateShrExpResGICLS024", params);
			this.sqlMapClient.executeBatch();
			
			Map<String, Object> clmResParams = new HashMap<String, Object>();
			clmResParams.put("userId", params.get("userId"));
			clmResParams.put("claimId", params.get("claimId"));
			clmResParams.put("perilCd", params.get("perilCd"));
			clmResParams.put("itemNo", params.get("itemNo"));
			clmResParams.put("lossReserve", params.get("c022LossReserve"));
			clmResParams.put("expenseReserve", params.get("c022ExpenseReserve"));
			this.getSqlMapClient().update("updateResAmtsGICLS024", clmResParams);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> resHistParams = new HashMap<String, Object>();
			resHistParams.put("userId", params.get("userId"));
			resHistParams.put("claimId", params.get("claimId"));
			resHistParams.put("clmResHistId", params.get("clmResHistId"));
			resHistParams.put("bookingMonth", params.get("bookingMonth"));
			resHistParams.put("bookingYear", params.get("bookingYear"));
			resHistParams.put("remarks", params.get("remarks"));
			this.getSqlMapClient().update("updateShrPctGICLS024", resHistParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
}