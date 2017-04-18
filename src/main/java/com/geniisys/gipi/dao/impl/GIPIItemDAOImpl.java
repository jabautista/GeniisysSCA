package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIItemDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIItemDAOImpl implements GIPIItemDAO{
	
	private static Logger log = Logger.getLogger(GIPIItemDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItem> getGIPIItemForEndt(int parId) throws SQLException {	
		List<GIPIItem> gipiItems = this.getSqlMapClient().queryForList("getGIPIItemForEndt", parId);
		return gipiItems;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItem> getRelatedItemInfo(HashMap<String, Object> params)throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedItemInfo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getItemGroupList(HashMap<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBillPremiumMainList", params);
	}

	@Override
	public String getNonMCItemTitle(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getNonMCItemTitle", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String updatePolicyItemCoverage(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIPIItem> setRows = (List<GIPIItem>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating policy coverage...");
			for(GIPIItem set : setRows){
				Map<String, Object> upd = new HashMap<String, Object>();
				upd.put("policyId", set.getPolicyId());
				upd.put("itemNo", set.getItemNo());
				upd.put("coverageCd", set.getCoverageCd());
				upd.put("userId", allParams.get("userId"));
				System.out.println("update: "+upd);
				this.getSqlMapClient().update("updatePolicyItemCoverage", upd);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch(SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally{
			this.getSqlMapClient().endTransaction();
			log.info("Updating policy coverage done.");
		}
		return message;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getEndtItemList(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getEndtItemList", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItem> getItemAnnTsiPrem(int parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getItemAnnTsiPrem", parId);//monmon
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAttachments(Integer policyId, Integer itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("itemNo", itemNo);
		
		return this.getSqlMapClient().queryForList("getAttachmentList", params);
	}
}
