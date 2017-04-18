package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giex.dao.GIEXNewGroupDeductiblesDAO;
import com.geniisys.giex.entity.GIEXItmperil;
import com.geniisys.giex.entity.GIEXNewGroupDeductibles;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXNewGroupDeductiblesDAOImpl implements GIEXNewGroupDeductiblesDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIEXNewGroupDeductiblesDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIEXNewGroupDeductibles(Map<String, Object> params)
			throws SQLException {
		List<GIEXNewGroupDeductibles> addNewGroupDed = (List<GIEXNewGroupDeductibles>) params.get("addNewGroupDedObj");
		List<GIEXNewGroupDeductibles> delNewGroupDed = (List<GIEXNewGroupDeductibles>) params.get("delNewGroupDedObj");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(addNewGroupDed.size() > 0 || delNewGroupDed.size() > 0){
				Integer policyId = Integer.parseInt(params.get("policyId").toString());
				this.getSqlMapClient().insert("insertNewGroupDeductibles", policyId);
			}
			
			for (GIEXNewGroupDeductibles newGroupDed : delNewGroupDed){
				log.info("Deleting GIEXNewGroupDeductibles...");
				Map<String, Object> delParam = new HashMap<String, Object>();
				delParam.put("policyId", newGroupDed.getPolicyId());
				delParam.put("itemNo", newGroupDed.getItemNo());
				delParam.put("perilCd", newGroupDed.getPerilCd());
				delParam.put("dedDeductibleCd", newGroupDed.getDedDeductibleCd());
				this.getSqlMapClient().delete("deleteNewGroupDeductibles", delParam);
			}			
			this.sqlMapClient.executeBatch();
			
			for (GIEXNewGroupDeductibles newGroupDed : addNewGroupDed){
				//joanne 06.05.2014, add parameter
				Map<String, Object> paramsnewGroupDed = new HashMap<String, Object>();
				paramsnewGroupDed.put("deductibleLocalAmt", newGroupDed.getDeductibleLocalAmt());
				log.info("Inserting GIEXNewGroupDeductibles...");
				this.getSqlMapClient().insert("setNewGroupDeductibles", newGroupDed);
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

	@Override
	public void deleteModNewGroupDeductibles(Map<String, Object> params)
			throws SQLException {
		log.info("Delete GIEXNewGroupDeductibles");
		this.getSqlMapClient().delete("deleteNewGroupDeductibles", params);
	}

	@Override
	public Integer validateIfDeductibleExists(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("valIfDeductibleExists", params);
	}
	
	@Override
	public String countTsiDed (String policyId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("countTsiDed", policyId);
	}

	@Override
	public String getDeductibleCurrency(String policyId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getDeductibleCurrency", policyId);
	}
	
}
