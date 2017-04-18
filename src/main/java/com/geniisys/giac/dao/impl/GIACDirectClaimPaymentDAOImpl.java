/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Create Date	:	Oct 7, 2010
 ***************************************************/
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACDirectClaimPaymentDAO;
import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLClaims;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author rencela
 */
public class GIACDirectClaimPaymentDAOImpl implements GIACDirectClaimPaymentDAO{

	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIACDirectClaimPaymentDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#getClaimDetails(java.lang.Integer)
	 */
	@Override
	public GICLClaims getClaimDetails(Integer claimId) throws SQLException {
		log.info("Retrieving get claim details");
		return (GICLClaims) this.sqlMapClient.queryForObject("getClaimDetails", claimId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#computeAdviceDefaultAmount(java.util.Map)
	 */
	@Override
	public Map<String, Object> computeAdviceDefaultAmount(
			Map<String, Object> params) throws SQLException {
		log.info("Compute advice default amount");
		this.sqlMapClient.update("computeAdviceDefaultAmount", params);		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#getAdviceSequenceListing(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLAdvice> getAdviceSequenceListing(String moduleId, String keyword)
			throws SQLException {
		log.info("Retrieving Advice Sequence Listing");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", moduleId);
		params.put("keyword", keyword);
		return this.getSqlMapClient().queryForList("getAdviceSequenceListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#saveDirectClaimPayment(com.geniisys.giac.entity.GIACDirectClaimPayment)
	 */
	@Override
	public void saveDirectClaimPayment1(GIACDirectClaimPayment directClaimPayment)
			throws SQLException {
		log.info("Proceeding to Save...");
		System.out.println("Ibatis processing START ------");
		if(directClaimPayment.getPayeeClassCd().equals("Loss")){
			directClaimPayment.setPayeeClassCd("L");
		}else if(directClaimPayment.getPayeeClassCd().equals("Expense")){
			directClaimPayment.setPayeeClassCd("E");
		}
		
		this.sqlMapClient.insert("saveDirectClaimPayment", directClaimPayment);
		//this.sqlMapClient.insert("setDirectClaimPayment", directClaimPayment);
		System.out.println("Ibatis processing END   ------");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#getDirectClaimPaymentByGaccTranId(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACDirectClaimPayment> getDirectClaimPaymentByGaccTranId(
			Integer gaccTranId) throws SQLException {
		log.info("Retrieving Direct Claim Payments");
		
		List<GIACDirectClaimPayment> dcps = this.sqlMapClient.queryForList("getDirectClaimPaymentByGaccTranId", gaccTranId);
		for(GIACDirectClaimPayment dcp: dcps){
			if(dcp.getGiclAdvice()!=null){
				dcp.setAdviceSequenceNumber(dcp.getGiclAdvice().getAdviceNo());
			}
			if(dcp.getGiclClaims()!=null){
				dcp.setAssuredName(dcp.getGiclClaims().getAssuredName());
			}
		}
		return dcps;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#dcpPostFormsCommit(java.util.Map)
	 */
	@Override
	public Map<String, Object> dcpPostFormsCommit(Map<String, Object> params)
			throws SQLException {
		log.info("Direct Claim Payments - Post Forms Commit");
		this.sqlMapClient.update("dcpPostFormsCommit", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACDirectClaimPaymentDAO#saveDirectClaimPayments(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveDirectClaimPayments(Map<String, Object> params)
			throws SQLException {
		log.info("Save Direct claim payments..");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			List<GIACDirectClaimPayment> setRows = (List<GIACDirectClaimPayment>) params.get("setRows");
			List<GIACDirectClaimPayment> delRows = (List<GIACDirectClaimPayment>) params.get("delRows");
			
			this.getSqlMapClient().startBatch();
			Map<String, Object> qParam = new HashMap<String, Object>();
			log.info("Deleting Direct Claim Payments...");
			for(GIACDirectClaimPayment dcp: delRows){
				dcp.displayDetailsInConsole();
				qParam.clear();
				qParam.put("adviceId", dcp.getAdviceId());
				qParam.put("gaccTranId", dcp.getGaccTranId());
				qParam.put("claimId", dcp.getClaimId());
//				qParam.put("claimLossId", dcp.getClaimLossId());
				qParam.put("appUser", dcp.getUserId()); // andrew - 03.14.2011 - for application user
				this.sqlMapClient.delete("deleteDirectClaimPayment", qParam);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			for(GIACDirectClaimPayment dcp: setRows){
				log.info("Saving Added/Modified Direct Claim Payment (gaccTranId=" + dcp.getGaccTranId() + ",adviceId=" + dcp.getAdviceId() + ")");
				System.out.println("dcp gaccTranID: " + dcp.getGaccTranId() + " - dcp claimID: " + dcp.getClaimId() + " - dcp claimLossID: " + dcp.getClaimLossId());
				this.sqlMapClient.insert("setDirectClaimPayments", dcp);
			}
			this.getSqlMapClient().executeBatch();
			
			// POST FORMS COMMIT
			Map<String, Object> postParams = params;
			postParams.remove("setRows");
			postParams.remove("delRows");
			System.out.println("GIACS017 Post Forms Commit: "+postParams);
			this.getSqlMapClient().update("giacs017PostFormsCommit", postParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> getGDCPAmountSum(Integer gaccTranId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", gaccTranId);
		this.getSqlMapClient().queryForObject("getGDCPAmountSum", params);
		System.out.println("Retrieved GDCP Sum - "+params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDCPFromClaim(Map<String, Object> params, String action)
			throws SQLException {
		Map<String, Object> dcp = (Map<String, Object>) this.getSqlMapClient().queryForObject(action, params);
		System.out.println(action+": "+dcp);
		return dcp;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEnteredAdviceDetails(
			Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> dcps = this.getSqlMapClient().queryForList("getEnteredAdviceDetails", params);
		System.out.println("Retrived dcps: "+dcps.size());
		return dcps.size() < 1 ? null : dcps.get(0);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCPFromBatch(Map<String, Object> params)
			throws SQLException {
		List<Map<String, Object>> dcps = this.getSqlMapClient().queryForList("getDCPFromBatch", params);
		System.out.println("Retrieved dcp from batch: "+dcps.size());
		return dcps;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getListOfPayees(Map<String, Object> params)
			throws SQLException {
		List<Map<String, Object>> listOfPayees = this.getSqlMapClient().queryForList("getListOfPayees", params);
		return listOfPayees;
	}
	
}