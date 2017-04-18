package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACInwClaimPaytsDAO;
import com.geniisys.giac.entity.GIACInwClaimPayts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACInwClaimPaytsDAOImpl implements GIACInwClaimPaytsDAO {
	
	/** The logger	 */
	private static Logger log = Logger.getLogger(GIACInwClaimPaytsDAOImpl.class);
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#getGIACInwClaimPayts(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACInwClaimPayts> getGIACInwClaimPayts(Integer gaccTranId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIACInwClaimPayts", gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#getClaimPolicyAndAssured(java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getClaimPolicyAndAssured(Integer claimId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		
		this.getSqlMapClient().update("getClaimPolicyAndAssured", params);
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#getClmLossIdListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getClmLossIdListing(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getClmLossIdListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#validatePayee(java.util.Map)
	 */
	@Override
	public void validatePayee(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validatePayee", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#executeGiacs018PreInsertTrigger(java.util.Map)
	 */
	@Override
	public void executeGiacs018PreInsertTrigger(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("executeGIACS018PreInsertTrigger", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#executeGiacs018PostFormsCommit(java.util.Map)
	 */
	@Override
	public void executeGiacs018PostFormsCommit(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("executeGIACS018PostFormsCommit", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#delGIACInwClaimPayts(java.util.List)
	 */
	@Override
	public void delGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList)
			throws SQLException {
		log.info("Deleting GIAC Inw Claim Payts records...");
		log.info("Gacc Tran Id\tClaim Id\tClm Loss Id");
		log.info("=======================================================================================");
		
		if (inwClaimPaytsList != null) {
			for (GIACInwClaimPayts inwClaimPayts : inwClaimPaytsList) {
				log.info(inwClaimPayts.getGaccTranId()+"\t"+inwClaimPayts.getClaimId()+"\t"+inwClaimPayts.getClmLossId());
				this.getSqlMapClient().delete("delGIACInwClaimPayts", inwClaimPayts);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#setGIACInwClaimPayts(java.util.List)
	 */
	@Override
	public void setGIACInwClaimPayts(List<GIACInwClaimPayts> inwClaimPaytsList)
			throws SQLException {
		log.info("Saving GIAC Inw Claim Payts records...");
		log.info("Gacc Tran Id\tClaim Id\tClm Loss Id");
		log.info("=======================================================================================");
		
		if (inwClaimPaytsList != null) {
			for (GIACInwClaimPayts inwClaimPayts : inwClaimPaytsList) {
				log.info(inwClaimPayts.getGaccTranId()+"\t"+inwClaimPayts.getClaimId()+"\t"+inwClaimPayts.getClmLossId());
				this.getSqlMapClient().insert("setGIACInwClaimPayts", inwClaimPayts);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACInwClaimPaytsDAO#saveGIACInwClaimPayts(java.util.List, java.util.List, java.util.Map)
	 */
	@Override
	public Map<String, Object> saveGIACInwClaimPayts(
			List<GIACInwClaimPayts> setInwClaimPaytsList,
			List<GIACInwClaimPayts> delInwClaimPaytsList,
			Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// insert/update
			this.getSqlMapClient().startBatch();
			this.setGIACInwClaimPayts(setInwClaimPaytsList);
			this.getSqlMapClient().executeBatch();
			
			// delete
			this.getSqlMapClient().startBatch();
			this.delGIACInwClaimPayts(delInwClaimPaytsList);
			this.getSqlMapClient().executeBatch();
			
			// key-delrec
			if (delInwClaimPaytsList != null) {
				log.info("Executing KEY-DELREC trigger...");
				log.info("=======================================================================================");
				this.getSqlMapClient().startBatch();
				for (GIACInwClaimPayts inwClaimPayts : delInwClaimPaytsList) {
					Map<String, Object> delrecParams = new HashMap<String, Object>();
					delrecParams.put("gaccTranId", inwClaimPayts.getGaccTranId());
					delrecParams.put("transactionType", inwClaimPayts.getTransactionType());
					delrecParams.put("claimId", inwClaimPayts.getClaimId());
					delrecParams.put("adviceId", inwClaimPayts.getAdviceId());
					delrecParams.put("varGenType", params.get("varGenType"));
					delrecParams.put("appUser", params.get("userId"));// shan 09.18.2014
					log.info("Gacc Tran Id: " + delrecParams.get("gaccTranId"));
					log.info("Transaction Type: " + delrecParams.get("transactionType"));
					log.info("Claim Id: " + delrecParams.get("claimId"));
					log.info("Advice Id: " + delrecParams.get("adviceId"));
					log.info("Var Gen Type: " + delrecParams.get("varGenType"));
					this.getSqlMapClient().update("executeGIACS018KeyDelrec", delrecParams);
				}
				this.getSqlMapClient().executeBatch();
				log.info("=======================================================================================");
				log.info("SUCCESS!");
			}
			
			// post-insert
			if (setInwClaimPaytsList != null) {
				log.info("Executing POST-INSERT trigger...");
				log.info("=======================================================================================");
				this.getSqlMapClient().startBatch();
				for (GIACInwClaimPayts inwClaimPayts : setInwClaimPaytsList) {
					Map<String, Object> postInsertParams = new HashMap<String, Object>();
					postInsertParams.put("transactionType", inwClaimPayts.getTransactionType());
					postInsertParams.put("claimId", inwClaimPayts.getClaimId());
					postInsertParams.put("adviceId", inwClaimPayts.getAdviceId());
					postInsertParams.put("appUser", params.get("userId"));// shan 09.18.2014
					log.info("Transaction Type: " + postInsertParams.get("transactionType"));
					log.info("Claim Id: " + postInsertParams.get("claimId"));
					log.info("Advice Id: " + postInsertParams.get("adviceId"));
					this.getSqlMapClient().update("executeGIACS018PostInsert", postInsertParams);
				}
				this.getSqlMapClient().executeBatch();
				log.info("=======================================================================================");
				log.info("SUCCESS!");
			}
			
			// post-forms commit
			if (setInwClaimPaytsList != null || delInwClaimPaytsList != null) {
				log.info("Executing POST-FORMS-COMMIT trigger...");
				System.out.println("=======================================================================================");
				this.getSqlMapClient().startBatch();
				this.executeGiacs018PostFormsCommit(params);
				this.getSqlMapClient().executeBatch();
				log.info("execute batch::: "+params);
				log.info("SUCCESS".equals(params.get("message")) ? "SUCCESS!" : "ERROR!");
			}
			
			if (params.get("message") != null) {
				if ("SUCCESS".equals(params.get("message"))) {
					this.getSqlMapClient().getCurrentConnection().commit();
				} else {
					this.getSqlMapClient().getCurrentConnection().rollback();
				}
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		} catch (SQLException e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}
}
