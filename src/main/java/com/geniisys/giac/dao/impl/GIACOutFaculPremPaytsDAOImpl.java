package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACOutFaculPremPaytsDAO;
import com.geniisys.giac.entity.GIACOutFaculPremPaymt;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIACOutFaculPremPaytsDAOImpl implements GIACOutFaculPremPaytsDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACOutFaculPremPaytsDAOImpl.class);
	
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
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBinderList(Map<String, Object> params) throws SQLException {
		log.info("DAO - Retrieving Binder Listing...");
		Debug.print("PARAMS: " + params);
		List<Map<String, Object>> giacOutFaculPremPaymt = this.getSqlMapClient().queryForList("getBinderListTableGrid", params);
		log.info("DAO - " + giacOutFaculPremPaymt.size() + " Binder retrieved." );
		return giacOutFaculPremPaymt;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBinderList2(Map<String, Object> params)
			throws SQLException {
		System.out.println("PARAMS: " + params);
		List<Map<String, Object>> gridDtls = this.getSqlMapClient().queryForList("getBinderListTableGrid2", params);
		//System.out.println("SIZE: " + gridDtls.size() + " gridDtls: rownum" + gridDtls.get(0).get("rowNum") + " gridDtls: rowCount" + gridDtls.get(0).get("rowCount"));
		
		return gridDtls;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> validateBinderNo(Map<String, Object> params) throws SQLException {
		Debug.print("PARAMS BINDER DAO: " + params);
		List<Map<String, Object>> binderDtls = sqlMapClient.queryForList("validateBinderNo", params);
		System.out.println("Binder Size: " + binderDtls.size());
		return binderDtls;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBreakdownAmts(Map<String, Object> params)	throws SQLException {
		return (Map<String, Object>) sqlMapClient.queryForObject("getBreakdownAmts", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllOutFaculPremPayts(Map<String, Object> params) throws SQLException {
		return sqlMapClient.queryForList("getAllOutFaculPremPayts", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveOutFaculPremPayts(Map<String, Object> allParams) throws SQLException {
		try {
			
			List<GIACOutFaculPremPaymt> addedOutFaculPremPayts = (List<GIACOutFaculPremPaymt>) (allParams.get("addModifiedOutFaculPremPayts"));
			List<Map<String, Object>> deletedOutFaculPremPayts = (List<Map<String, Object>>) (allParams.get("deletedOutFaculPremPayts"));
			Map<String, Object> postFormsCommitParams = (Map<String, Object>) allParams.get("postFormsCommitParams");
			
			System.out.println("DAO IMPL post forms params: gaacTranId: " + postFormsCommitParams.get("gaccTranId") + " transource: " + postFormsCommitParams.get("tranSource") + " orFlag: " + postFormsCommitParams.get("orFlag"));
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			
			//Delete OutFaculPremPayts details
			for(Map<String, Object> deletedOutFaculPremPayt: deletedOutFaculPremPayts){
				Debug.print("Map of deleted info: " + deletedOutFaculPremPayt);
				this.sqlMapClient.delete("deletedOutFaculPremPayt", deletedOutFaculPremPayt);
				log.info("DAO - deletedOutFaculPremPayt deleted.");
				this.getSqlMapClient().executeBatch();
			}
			
			//Insert Added OutFaculPremPayts
			for(GIACOutFaculPremPaymt addedOutFaculDtls: addedOutFaculPremPayts){
				// Retrieves next record_no ::: SR-19631 : shan 08.17.2015
				Integer nextRecordNo = 0;
				if (addedOutFaculDtls.getTranType() == 2 || addedOutFaculDtls.getTranType() == 4){
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("gaccTranId", addedOutFaculDtls.getGaccTranId());
					nextRecordNo = this.getNextRecordNo(map);
					addedOutFaculDtls.setRecordNo(nextRecordNo);
				}else{
					addedOutFaculDtls.setRecordNo(0);
				}
				// end SR-19631
				log.info("DAO - Inserting GIACOutFaculPremPaymt ..." + addedOutFaculDtls.getRecordNo());
				this.sqlMapClient.insert("saveOutFaculPremPayts", addedOutFaculDtls);
				log.info("DAO - GIACOutFaculPremPaymt inserted.");
				this.getSqlMapClient().executeBatch();
			}
			
			// SR-19631 : shan 08.17.2015			
			// Updates rev_gacc_tran_id of corresponding tran type 1 or 3 :: for DELETE
			for(Map<String, Object> deletedOutFaculPremPayt: deletedOutFaculPremPayts){
				if (deletedOutFaculPremPayt.get("tranType").equals(2) || deletedOutFaculPremPayt.get("tranType").equals(4)){
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("paytGaccTranId", deletedOutFaculPremPayt.get("paytGaccTranId"));
					map.put("gaccTranId", deletedOutFaculPremPayt.get("gaccTranId"));
					map.put("riCd", deletedOutFaculPremPayt.get("riCd"));
					map.put("binderId", deletedOutFaculPremPayt.get("binderId"));
					map.put("userId", postFormsCommitParams.get("userId"));
					map.put("addDelSw", 2);
					System.out.println("Updating rev_Columns : " + map.toString());
					this.sqlMapClient.update("updateRevColumnsGiac019", map);
				}
			}
			
			// Updates rev_gacc_tran_id of corresponding tran type 1 or 3 :: for INSERT
			for(GIACOutFaculPremPaymt addedOutFaculDtls: addedOutFaculPremPayts){
				if (addedOutFaculDtls.getTranType() == 2 || addedOutFaculDtls.getTranType() == 4){
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("paytGaccTranId", addedOutFaculDtls.getPaytGaccTranId());
					map.put("gaccTranId", addedOutFaculDtls.getGaccTranId());
					map.put("riCd", addedOutFaculDtls.getRiCd());
					map.put("binderId", addedOutFaculDtls.getBinderId());
					map.put("revRecordNo", addedOutFaculDtls.getRecordNo());
					map.put("userId", postFormsCommitParams.get("userId"));
					map.put("addDelSw", 1);
					System.out.println("Updating rev_Columns : " + map.toString());
					this.sqlMapClient.update("updateRevColumnsGiac019", map);
				}
			}
			
			// Renumbers record_no (applicable only to reversals)
			this.sqlMapClient.update("renumberGiacs019", postFormsCommitParams);			
			// end SR-19631
			
			//POST FORMS COMMIT
			System.out.println("PostForms Commit Params: "+postFormsCommitParams);
			if("OR".equals((String) postFormsCommitParams.get("tranSource")) || "OP".equals((String) postFormsCommitParams.get("tranSource"))) {
			//if (postFormsCommitParams.get("tranSource") == "OR" || postFormsCommitParams.get("tranSource") == "OP") {
				if (!("P".equals((String) postFormsCommitParams.get("orFlag")))) {
					log.info("Updating OP Text.....");
					this.sqlMapClient.update("updateOPTextGiacs019", postFormsCommitParams.get("gaccTranId"));
					log.info("Finished Updating OP Text.....");
				}
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting Accounting Entries.....");
			this.sqlMapClient.insert("aegParametersGIACS019", postFormsCommitParams);
			log.info("Finished Inserting Accounting Entries.....");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
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
	 * @see com.geniisys.giac.dao.GIACOutFaculPremPaytsDAO#getDisbursementAmt(java.util.Map)
	 */
	@Override
	public BigDecimal getDisbursementAmt(Map<String, Object> params) throws SQLException {
		return (BigDecimal) this.sqlMapClient.queryForObject("getDisbursementAmt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACOutFaculPremPaytsDAO#getOverrideDisbursementAmt(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getOverrideDisbursementAmt(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getOverrideDisbursement", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getRevertDisbursementAmt(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getRevertDisbursementAmt", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getFaculIssCdPremSeqNo(Map<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getFaculIssCdPremSeqNo", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> postFormsCommitOutFacul(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.sqlMapClient.queryForObject("postFormsCommitOutFacul", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getOverrideDetails(Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getOverrideDetails",params);
	}
	
	public Map<String, Object> validateBinderNo2(Map<String, Object> params) throws SQLException{
		log.info("validating binder no 2: "+params.toString());
		this.sqlMapClient.update("validateBinderNo2", params);
		return params;
	}
	
	public Integer getNextRecordNo(Map<String, Object> params) throws SQLException{ // SR-19631 : shan 08.17.2015
		System.out.println("getNextRecordNo : " + params.toString());
		return (Integer) this.sqlMapClient.queryForObject("getNextRecNoGiacs019", params);
	}
}
