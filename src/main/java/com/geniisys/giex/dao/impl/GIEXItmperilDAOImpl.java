package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giex.dao.GIEXItmperilDAO;
import com.geniisys.giex.entity.GIEXItmperil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXItmperilDAOImpl implements GIEXItmperilDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIEXItmperilDAOImpl.class);
	
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

	@Override
	public void deleteItmperilByPolId(Integer policyId) throws SQLException {
		log.info("Delete Item Peril By Pol ID");
		this.getSqlMapClient().delete("deleteItmperilByPolId", policyId);
	}

	@Override
	public Map<String, Object> deletePerilGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("deletePerilGIEXS007", params);
		return params;
	}

	@Override
	public Map<String, Object> createPerilGIEXS007(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("deleteExpiryPerils", params);
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().update("createPerilGIEXS007", params);
			this.sqlMapClient.executeBatch();			

			//joanne 05.05.14
			this.getSqlMapClient().insert("insertGroupPeril", params);		
			this.sqlMapClient.executeBatch();
			
			params.put("createPeril", "Y"); //added by joanne 06.032014
			this.getSqlMapClient().update("updateWitemGIEXS007", params);
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().update("deleteGiexNewGroupDeductibles", params);
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().update("populateExpiryDeductibles", params);
			this.sqlMapClient.executeBatch();
			
			
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIEXItmperil(Map<String, Object> params)
			throws SQLException {
		List<GIEXItmperil> addItmperilDtl = (List<GIEXItmperil>) params.get("addItmperilDtlObj");
		List<GIEXItmperil> delItmperilDtl = (List<GIEXItmperil>) params.get("delItmperilDtlObj");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIEXItmperil itmperilDtl : delItmperilDtl){
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("policyId", itmperilDtl.getPolicyId());
				params2.put("itemNo", itmperilDtl.getItemNo());
				params2.put("perilCd", itmperilDtl.getPerilCd());
				this.getSqlMapClient().delete("deleteItmperil", params2);
			}			
			this.sqlMapClient.executeBatch();
			
			for (GIEXItmperil itmperilDtl : addItmperilDtl){
				log.info("Inserting GIEXItmperil...");
				this.getSqlMapClient().insert("setB490Dtls", itmperilDtl);
			}
			this.sqlMapClient.executeBatch();
			
			//joanne 05.02.14, insert in group perils when peril is added/modified
			for (GIEXItmperil itmperilDtl : addItmperilDtl){
				Map<String, Object> paramsPeril = new HashMap<String, Object>();
				paramsPeril.put("policyId", itmperilDtl.getPolicyId().toString());
				paramsPeril.put("userId", itmperilDtl.getUserId().toString());
				this.getSqlMapClient().insert("insertGroupPeril", paramsPeril);
			}			
			this.sqlMapClient.executeBatch();
			
			//joanne 05.02.14, insert in group perils when peril is deleted
			for (GIEXItmperil itmperilDtl : delItmperilDtl){
				Map<String, Object> paramsPeril2 = new HashMap<String, Object>();
				paramsPeril2.put("policyId", itmperilDtl.getPolicyId().toString());
				paramsPeril2.put("userId", itmperilDtl.getUserId().toString());
				this.getSqlMapClient().insert("insertGroupPeril", paramsPeril2);
			}			
			this.sqlMapClient.executeBatch();
			
			//recompute taxes when peril is added/modified
			for (GIEXItmperil itmperilDtl : addItmperilDtl){
				Map<String, Object> params3 = new HashMap<String, Object>();
				params3.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				params3.put("itemNo", Integer.toString(itmperilDtl.getItemNo()));
				params3.put("recomputeTax", params.get("recomputeTax"));
				params3.put("taxSw", params.get("taxSw"));
				params3.put("createPeril", "N"); //added by joanne 06.032014
				params3.put("summarySw", params.get("summarySw")); //added by joanne 06.032014
				log.info("updateWitemGIEXS007...");
				this.getSqlMapClient().update("updateWitemGIEXS007", params3);
			}
			this.sqlMapClient.executeBatch();
			
			//Added by Joanne 02.21.14, to recompute taxes when peril is deleted
			for (GIEXItmperil itmperilDtl : delItmperilDtl){
				Map<String, Object> params4 = new HashMap<String, Object>();
				params4.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				params4.put("itemNo", Integer.toString(itmperilDtl.getItemNo()));
				params4.put("recomputeTax", params.get("recomputeTax"));
				params4.put("taxSw", params.get("taxSw"));
				params4.put("createPeril", "N"); //added by joanne 06.032014
				params4.put("summarySw", params.get("summarySw")); //added by joanne 06.032014
				log.info("updateWitemGIEXS007...");
				this.getSqlMapClient().update("updateWitemGIEXS007", params4);
			}
			this.sqlMapClient.executeBatch();
			
			//Added by Joanne 04.15.14, to recompute deductibles when peril is deleted
			for (GIEXItmperil itmperilDtl : delItmperilDtl){
				Map<String, Object> params5 = new HashMap<String, Object>();
				params5.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				log.info("updateTsiDeductibles...");
				this.getSqlMapClient().update("updateTsiDeductibles", params5);
			}
			this.sqlMapClient.executeBatch();
			
			//Added by Joanne 04.15.14, to recompute deductibles when peril is added/modified
			for (GIEXItmperil itmperilDtl : addItmperilDtl){
				Map<String, Object> params6 = new HashMap<String, Object>();
				params6.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				log.info("updateTsiDeductibles...");
				this.getSqlMapClient().update("updateTsiDeductibles", params6);
			}
			this.sqlMapClient.executeBatch();
			
			Map<String, Object> postFormsCommitParams = new HashMap<String, Object>();
			postFormsCommitParams.put("policyId", params.get("policyId"));
			postFormsCommitParams.put("packPolicyId", params.get("packPolicyId"));
			log.info("postFormsCommitGIEXS007 - policyId: " + params.get("policyId") + " packPolicyId: " + params.get("packPolicyId"));
			this.getSqlMapClient().insert("postFormsCommitGIEXS007", postFormsCommitParams);
			
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> computeTsiGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("computeTsiGIEXS007", params);
		return params;
	}
	
	@Override
	public Map<String, Object> computePremiumGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("computePremiumGIEXS007", params);
		return params;
	}

	@Override
	public Map<String, Object> updateWitemGIEXS007(Map<String, Object> params)
			throws SQLException {
		//modified by joanne 06.02.14, add commit
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			params.put("createPeril", "N"); //added by joanne 06.032014
			this.getSqlMapClient().update("updateWitemGIEXS007",params);
		
			this.getSqlMapClient().getCurrentConnection().commit();
			return null;
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void deleteOldPEril(Map<String, Object> params) throws SQLException {
		log.info("Delete Old Peril");
		this.getSqlMapClient().delete("deleteItmperil", params);
	}

	@Override
	public String computeDeductibleAmt(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("computeDeductibleAmt", params);
	}

	@Override
	public Map<String, Object> validateItemperil(Map<String, Object> params) //joanne 12-02-13
			throws SQLException {
		this.getSqlMapClient().update("validateItemperil", params);
		return params;
	}

	@Override
	public Map<String, Object> deleteItemperil(Map<String, Object> params) //joanne 12-05-13
			throws SQLException {
		this.getSqlMapClient().update("deleteItemperil", params);
		return params;
	}
}
