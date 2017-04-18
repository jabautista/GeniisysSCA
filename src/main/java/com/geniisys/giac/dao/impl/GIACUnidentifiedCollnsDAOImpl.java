package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACUnidentifiedCollnsDAO;
import com.geniisys.giac.entity.GIACUnidentifiedCollns;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACUnidentifiedCollnsDAOImpl implements GIACUnidentifiedCollnsDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACOrderOfPaymentDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACUnidentifiedCollnsDAO#getOldItemList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOldItemList(Map<String, Object> params) throws SQLException {
		return sqlMapClient.queryForList("getOldItemDtls", params);
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACUnidentifiedCollnsDAO#getUnidentifiedCollnsListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACUnidentifiedCollns> getUnidentifiedCollnsListing(Map<String, Object> params) throws SQLException {
		return sqlMapClient.queryForList("getUnidentifiedCollnsList", params);
	}



	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACUnidentifiedCollnsDAO#searchOldItemList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> searchOldItemList(Map<String, Object> params) throws SQLException {
		return sqlMapClient.queryForList("searchOldItemDtls", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveUnidentifiedCollnsDtls(Map<String, Object> parameters)
			throws Exception {	
		try{
			List<GIACUnidentifiedCollns> delParams =  (List<GIACUnidentifiedCollns>) parameters.get("delParams");
			List<GIACUnidentifiedCollns> insParams =  (List<GIACUnidentifiedCollns>) parameters.get("insParams");
			
			Map<String, Object> postFormsParams = new HashMap<String, Object>();
			postFormsParams.put("gaccTranId", parameters.get("gaccTranId"));
			postFormsParams.put("fundCd", parameters.get("fundCd"));
			postFormsParams.put("branchCd", parameters.get("branchCd"));
			postFormsParams.put("user", parameters.get("user"));
			postFormsParams.put("moduleName", parameters.get("moduleName"));
			postFormsParams.put("orFlag", parameters.get("orFlag"));
			postFormsParams.put("tranSource", parameters.get("tranSource"));
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(delParams != null){
				Map<String, Object> params =new HashMap<String, Object>();
				for(GIACUnidentifiedCollns unidentifiedCollns: delParams){
					params.put("gaccTranId", unidentifiedCollns.getGaccTranId());
					params.put("itemNo", unidentifiedCollns.getItemNo());
					System.out.println("CC delParams" + params.toString());
					this.getSqlMapClient().delete("deleteUnidentifiedCollns", params);
				}
			}
			
			if(insParams != null){
				GIACUnidentifiedCollns unidentifiedCollnsList = null;
				for(GIACUnidentifiedCollns unidentifiedCollns: insParams){
					unidentifiedCollnsList = new GIACUnidentifiedCollns();
					unidentifiedCollnsList.setGaccTranId(unidentifiedCollns.getGaccTranId());
					unidentifiedCollnsList.setItemNo(unidentifiedCollns.getItemNo());
					unidentifiedCollnsList.setTranType(unidentifiedCollns.getTranType());
					unidentifiedCollnsList.setCollAmt(unidentifiedCollns.getCollAmt());
					unidentifiedCollnsList.setGlAcctId(unidentifiedCollns.getGlAcctId());
					unidentifiedCollnsList.setGlAcctCategory(unidentifiedCollns.getGlAcctCategory());
					unidentifiedCollnsList.setGlCtrlAcct(unidentifiedCollns.getGlCtrlAcct());
					unidentifiedCollnsList.setGlSubAcct1(unidentifiedCollns.getGlSubAcct1());
					unidentifiedCollnsList.setGlSubAcct2(unidentifiedCollns.getGlSubAcct2());
					unidentifiedCollnsList.setGlSubAcct3(unidentifiedCollns.getGlSubAcct3());
					unidentifiedCollnsList.setGlSubAcct4(unidentifiedCollns.getGlSubAcct4());
					unidentifiedCollnsList.setGlSubAcct5(unidentifiedCollns.getGlSubAcct5());
					unidentifiedCollnsList.setGlSubAcct6(unidentifiedCollns.getGlSubAcct6());
					unidentifiedCollnsList.setGlSubAcct7(unidentifiedCollns.getGlSubAcct7());
					unidentifiedCollnsList.setOrPrintTag(unidentifiedCollns.getOrPrintTag());
					unidentifiedCollnsList.setSlCd(unidentifiedCollns.getSlCd());
					unidentifiedCollnsList.setGuncTranId(unidentifiedCollns.getGuncTranId());
					unidentifiedCollnsList.setGuncItemNo(unidentifiedCollns.getGuncItemNo());
					unidentifiedCollnsList.setParticulars(unidentifiedCollns.getParticulars());
					unidentifiedCollnsList.setAppUser(parameters.get("user").toString());		// shan 10.29.2013
					System.out.println("CC addParams " + unidentifiedCollnsList.toString());
					this.getSqlMapClient().insert("saveGIACUnidentifiedCollns", unidentifiedCollnsList);
				}
			}
			
			this.getSqlMapClient().insert("postFormsCommitGiacs014", postFormsParams);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String validateItemNo(Map<String, Object> parameters)
			throws SQLException {
		System.out.println("Validating Item No.: " + parameters.get("itemNo"));
		return (String) this.sqlMapClient.queryForObject("validateItemNo",parameters);
	}

	@Override
	public String validateOldTranNo(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOldTranNo", params);
	}

	@Override
	public String validateOldItemNo(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOldItemNo", params);
	}
	
	public void validateDelRec(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("valDelRecGiacs014", params);
	}
}