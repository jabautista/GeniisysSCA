package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giex.dao.GIEXItmperilGroupedDAO;
import com.geniisys.giex.entity.GIEXItmperilGrouped;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXItmperilGroupedDAOImpl implements GIEXItmperilGroupedDAO {

	private SqlMapClient sqlMapClient;

	private Logger log = Logger.getLogger(GIEXItmperilDAOImpl.class);

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public Map<String, Object> deletePerilGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("deletePerilGrpGIEXS007", params);
		return params;
	}

	@Override
	public Map<String, Object> createPerilGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("createPerilGrpGIEXS007", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIEXItmperilGrouped(Map<String, Object> params)
			throws SQLException {
		List<GIEXItmperilGrouped> addItmperilDtl = (List<GIEXItmperilGrouped>) params
				.get("addItmperilDtlObj");
		List<GIEXItmperilGrouped> delItmperilDtl = (List<GIEXItmperilGrouped>) params
				.get("delItmperilDtlObj");
		List<GIEXItmperilGrouped> modItmperilDtlObj = (List<GIEXItmperilGrouped>) params //Added by Jerome Bautista 12.04.2015 SR 21016
				.get("modItmperilDtlObj");

		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			for (GIEXItmperilGrouped itmperilDtl : delItmperilDtl) {
				log.info("Deleting GIEXItmperilGrouped...");
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("policyId", itmperilDtl.getPolicyId());
				params2.put("itemNo", itmperilDtl.getItemNo());
				//params2.put("groupedItemNo", itmperilDtl.getGroupedItemNo()); //Commented out and replaced by code below - Jerome Bautista 12.03.2015 SR 21016
				params2.put("groupedItemNo", params.get("groupedItemNo"));
				params2.put("perilCd", itmperilDtl.getPerilCd());
				this.getSqlMapClient().delete("deleteItmperilGrp", params2);
			}
			this.sqlMapClient.executeBatch();

			for (GIEXItmperilGrouped itmperilDtl : addItmperilDtl) {
				log.info("Inserting GIEXItmperilGrouped...");
				this.getSqlMapClient().insert("setB490GrpDtls", itmperilDtl);
			}
			this.sqlMapClient.executeBatch();

			for (GIEXItmperilGrouped itmperilDtl : modItmperilDtlObj) { //Added by Jerome Bautista 12.04.2015 SR 21016
				/*Map<String, Object> params3 = new HashMap<String, Object>();
				
				params3.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				params3.put("itemNo", Integer.toString(itmperilDtl.getItemNo()));
				//params3.put("groupedItemNo", Integer.toString(itmperilDtl.getGroupedItemNo()));
				params3.put("groupedItemNo", params.get("groupedItemNo"));
				params3.put("recomputeTax", params.get("recomputeTax"));
				params3.put("taxSw", params.get("taxSw"));*/
				log.info("Updating GIEXItmPerilGrouped...");
				this.getSqlMapClient().update("setB490GrpDtls", itmperilDtl);
			}
			this.sqlMapClient.executeBatch();
			
			for (GIEXItmperilGrouped itmperilDtl : modItmperilDtlObj) {
				Map<String, Object> params3 = new HashMap<String, Object>();
				params3.put("policyId", Integer.toString(itmperilDtl.getPolicyId()));
				params3.put("itemNo", Integer.toString(itmperilDtl.getItemNo()));
				//params3.put("groupedItemNo", Integer.toString(itmperilDtl.getGroupedItemNo())); //Commented out and replaced by code below - Jerome Bautista 12.04.2015 SR 21016
				params3.put("groupedItemNo", params.get("groupedItemNo"));
				params3.put("recomputeTax", params.get("recomputeTax"));
				params3.put("taxSw", params.get("taxSw"));
				log.info("updateWitemGrpGIEXS007...");
				this.getSqlMapClient().update("updateWitemGrpGIEXS007", params3);
			}
			this.sqlMapClient.executeBatch();
			
			Map<String, Object> postFormsCommitParams = new HashMap<String, Object>();
			postFormsCommitParams.put("policyId", params.get("policyId"));
			postFormsCommitParams.put("packPolicyId", params.get("packPolicyId"));
			log.info("postFormsCommitGIEXS007 - policyId: " + params.get("policyId") + " packPolicyId: " + params.get("packPolicyId"));
			this.getSqlMapClient().insert("postFormsCommitGIEXS007", postFormsCommitParams);
			
			this.sqlMapClient.executeBatch();

			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}

	}

	@Override
	public Map<String, Object> updateWitemGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updateWitemGrpGIEXS007", params);
		return params;
	}

	@Override
	public void deleteOldPErilGrp(Map<String, Object> params)
			throws SQLException {
		log.info("Delete Old Peril Grp");
		this.getSqlMapClient().delete("deleteItmperilGrp", params);
	}

}
