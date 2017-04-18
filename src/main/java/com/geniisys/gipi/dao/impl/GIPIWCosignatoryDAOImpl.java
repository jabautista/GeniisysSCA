package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWCosignatoryDAO;
import com.geniisys.gipi.entity.GIPIWCosignatory;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWCosignatoryDAOImpl implements GIPIWCosignatoryDAO{
	
private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	private static Logger log = Logger.getLogger(GIPIWCosignatoryDAOImpl.class);

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCosignatory> getGIPIWCosignatory(Integer parId)
			throws SQLException {
		log.info("Getting signatory listing...");
		return this.getSqlMapClient().queryForList("getGIPIWCosignatory", parId);
	}

	@Override
	public void deleteGIPIWCosignatory(Integer parId, Integer cosignId)
			throws SQLException {
		log.info("Deleting signatory with par_id = "+parId+" and cosign_id = "+cosignId+"...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("cosignId", cosignId);
		this.getSqlMapClient().queryForObject("deleteGIPIWCosignatory", params);
		log.info("Deleted.");
	}

	@Override
	public void insertGIPIWCosignatory(Map<String, Object> wCosignatory)
			throws SQLException {
		log.info("Inserting cosignatory...");
		this.getSqlMapClient().insert("insertGIPIWCosignatory", wCosignatory);
		log.info("Inserted.");
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWCosignatoryPageChanges(Map<String, Object> params)
			throws SQLException {
		log.info("Saving cosignatory page changes...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Integer parId = (Integer) params.get("parId");
			
			//getting all documents
			List<GIPIWCosignatory> cosignorListing = this.getGIPIWCosignatory(parId);
		
			//temporarily deleting
			for (GIPIWCosignatory cos: cosignorListing){
				this.deleteGIPIWCosignatory(cos.getParId(), cos.getCosignId());
			}
			
			String[] cosignIds = (String[]) params.get("cosignIds");
			
			if (cosignIds != null){
				for (int i=0; i<cosignIds.length; i++){
					Map<String, Object> cosignMap = (Map<String, Object>) params.get(cosignIds[i]);
					this.insertGIPIWCosignatory(cosignMap);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

}
