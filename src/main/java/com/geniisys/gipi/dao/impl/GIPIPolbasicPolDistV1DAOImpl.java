package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIPolbasicPolDistV1DAO;
import com.geniisys.gipi.entity.GIPIPolbasicPolDistV1;
import com.geniisys.gipi.exceptions.DistributionException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPolbasicPolDistV1DAOImpl implements GIPIPolbasicPolDistV1DAO {

	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIPIAccidentItemDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1List(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting GIPIPolbasicPolDistV1 List...");
		return this.getSqlMapClient().queryForList("getGIPIPolbasicPolDistV1List", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicPolDistV1DAO#getGIPIPolbasicPolDistV1ListForPerilDist(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1ListForPerilDist(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting GIPIPolbasicPolDistV1 List...");
		return this.getSqlMapClient().queryForList("getGIPIPolbasicPolDistV1ListForPerilDist", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolbasicPolDistV1> getGIPIPolbasicPolDistV1ListOneRiskDist(
			HashMap<String, Object> params) throws SQLException {
		log.info("Getting GIPIPolbasicPolDistV1 List...");
		return this.getSqlMapClient().queryForList("getGIPIPolbasicPolDistV1ListOneRiskDist", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIPolbasicPolDistV1DAO#getGiuws012Currency(java.lang.Integer, java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGiuws012Currency(Integer policyId,
			Integer distNo, Integer distSeqNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("distNo", distNo);
		params.put("distSeqNo", distSeqNo);
		return (Map<String, Object>)this.getSqlMapClient().queryForObject("getGiuws012Currency", params);
	}

	@Override
	public Map<String, Object> createMissingDistRec(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Creating missing distribution records.");
			
			this.sqlMapClient.update("createMissingDistRec", params);
			log.info("createMissingDistRec params: "+params);
			if (!"SUCCESS".equals(params.get("msgAlert"))){
				message = (String) params.get("msgAlert");
				throw new DistributionException((String) params.get("msgAlert"));
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("Done creating missing distritbution records.");
			this.getSqlMapClient().endTransaction();
			params.put("message", message);
		}	
		return params;
	}

}
