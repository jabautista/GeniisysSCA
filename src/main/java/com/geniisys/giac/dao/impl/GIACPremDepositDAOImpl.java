/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACPremDepositDAO;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.entity.GIACPremDeposit;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPremDepositDAOImpl implements GIACPremDepositDAO {

	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACPremDepositDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getGIACPremDeposit(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPremDeposit> getGIACPremDeposit(int tranId) throws SQLException {
		return (List<GIACPremDeposit>) this.getSqlMapClient().queryForList("getGIACPremDeposit", tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getGIACAcctrans(int, java.lang.String, java.lang.String)
	 */
	@Override
	public GIACAccTrans getGIACAcctrans(int tranId, String gfunFundCd,
			String gibrBranchCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranId", tranId);
		params.put("gfunFundCd", gfunFundCd);
		params.put("gibrBranchCd", gibrBranchCd);
		return (GIACAccTrans) this.getSqlMapClient().queryForObject("getGIACAcctrans", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getTotalCollections(int)
	 */
	@Override
	public BigDecimal getTotalCollections(int tranId) throws SQLException {
		return (BigDecimal) this.getSqlMapClient().queryForObject("getTotalCollections", tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getDefaultCurrency(int)
	 */
	@Override
	public Map<String, Object> getDefaultCurrency(Integer currencyCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("currency cd: " + currencyCd);
		params.put("currencyCd", currencyCd);
		this.getSqlMapClient().update("getDfltCurrencyDtls", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getOldItemNoList(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOldItemNoList(Integer transactionType,
			String controlModule, String keyword, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("transactionType", transactionType);
		params.put("controlModule", controlModule);
		params.put("keyword", keyword);
		params.put("appUser", userId);
		return this.getSqlMapClient().queryForList("getOldItemNoList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getGIACPremDepositModuleRecords(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIACPremDepositModuleRecords(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIACPremDepositModuleRecords", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getOldItemNoListFor4()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOldItemNoListFor4(String keyword) throws SQLException {
		return this.getSqlMapClient().queryForList("getOldItemNoListFor4", keyword);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getGIACPremDeposit2(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPremDeposit> getGIACPremDeposit2() throws SQLException {
		return this.getSqlMapClient().queryForList("getGIACPremDeposit2");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getCollectionAmtSumFor2List()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCollectionAmtSumFor2List() throws SQLException {
		return this.getSqlMapClient().queryForList("getCollectionAmtSumFor2");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getCollectionAmtSumFor4List()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getCollectionAmtSumFor4List()
			throws SQLException {
		return this.getSqlMapClient().queryForList("getCollectionAmtSumFor4");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getGIACAgingSOAPOlicy()
	 */
	@Override
	public Map<String, Object> getGIACAgingSOAPolicy(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIACAgingSOAPolicy", params);
		return params;
	}

	/*(
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#validateRiCd(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateRiCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateRiCd", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#validateTranType1(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateTranType1(Map<String, Object> params)
			throws SQLException {
		log.info("Validating Tran Type 1: ");
		this.getSqlMapClient().update("validateTranType1", params);
		log.info("Validation success!");
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getParSeqNo2(java.util.Map)
	 */
	@Override
	public Map<String, Object> getParSeqNo2(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getParSeqNo2", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#deleteGIACPremDeposit(java.util.List)
	 */
	@Override
	public void deleteGIACPremDeposit(List<Map<String, Object>> giacPremDeps)
			throws SQLException {
		log.info("Deleting GIAC Prem Deposit records...");
		
		for (Map<String, Object> params : giacPremDeps) {
			log.info("Tran Id\tItem No\tTran Type");
			log.info("------------------------------");
			GIACPremDeposit premDep = new GIACPremDeposit();
			premDep.setGaccTranId((params.get("gaccTranId") == null) ? null : new Integer(params.get("gaccTranId").toString()));
			premDep.setItemNo((params.get("itemNo") == null) ? null : new Integer(params.get("itemNo").toString()));
			premDep.setTransactionType((params.get("transactionType") == null) ? null : new Integer(params.get("transactionType").toString()));
			
			log.info(premDep.getGaccTranId() + "\t" + premDep.getItemNo() + "\t" + premDep.getTransactionType());
			this.getSqlMapClient().delete("deleteGIACPremDeposit", premDep);
		}
		
		log.info("------------------------------");
		log.info("Records successfully deleted!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#setGIACPremDeposit(java.util.List)
	 */
	@Override
	public void setGIACPremDeposit(List<GIACPremDeposit> giacPremDeps)
			throws SQLException {
		log.info("Saving GIAC Prem Deposit records...");
		//log.info("Gacc Tran Id\tItem No\tTransaction Type");
		log.info("Old Tran Id\tOld Item No\tOld Tran Type");
		log.info("=======================================================================================");
		
		for (GIACPremDeposit premDep : giacPremDeps) {
			//log.info(premDep.getGaccTranId() + "\t" + premDep.getItemNo() + "\t" + premDep.getTransactionType());
			log.info(premDep.getOldTranId() + "\t" + premDep.getOldItemNo() + "\t" + premDep.getOldTranType());
			this.getSqlMapClient().insert("setGIACPremDeposit", premDep);
		}
			
		log.info("=======================================================================================");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#saveGIACPremDeposit(java.util.List, java.util.List, java.lang.String, java.lang.String, int, java.lang.String, java.lang.String, java.lang.String, java.lang.String, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String saveGIACPremDeposit(List<GIACPremDeposit> giacPremDeps, List<Map<String, Object>> delGiacPremDeps,
			  String gaccBranchCd, String gaccFundCd, int gaccTranId, String moduleName,
			  String genType, String tranSource, String orFlag, GIISUser USER) throws SQLException {
		String message = new String("SUCCESS");
		Map<String, Object> params;
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// set user_id for giacCommPayts records
			if (giacPremDeps != null) {
				for (int i = 0; i < giacPremDeps.size(); i++) {
					giacPremDeps.get(i).setUserId(USER.getUserId());
				}
			}
			
			// delete
			if (delGiacPremDeps != null) {
				this.getSqlMapClient().startBatch();
				this.deleteGIACPremDeposit(delGiacPremDeps);
				this.getSqlMapClient().executeBatch();
			}
			
			// insert/update
			if (giacPremDeps != null) {
				this.getSqlMapClient().startBatch();
				this.setGIACPremDeposit(giacPremDeps);
				this.getSqlMapClient().executeBatch();
			}
			
			// post-forms-commit
			
			// update_giac_text
			params = new HashMap<String, Object>();
			params.put("appUser", USER.getUserId());
			params.put("gaccTranId", gaccTranId);
			params.put("genType", genType);
			params.put("tranSource", tranSource);
			params.put("orFlag", orFlag);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateGiacText", params);
			this.getSqlMapClient().executeBatch();
			
			// aeg_parameters
			params = new HashMap<String, Object>();
			params.put("appUser", USER.getUserId());
			if (giacPremDeps != null) {
				for (GIACPremDeposit premDep : giacPremDeps) {
					params.put("gaccBranchCd", gaccBranchCd);
					params.put("gaccFundCd", gaccFundCd);
					params.put("gaccTranId", gaccTranId);
					params.put("moduleName", moduleName);
					params.put("depFlag", premDep.getDepFlag());
					params.put("b140IssCd", premDep.getB140IssCd());
					params.put("b140PremSeqNo", premDep.getB140PremSeqNo() == null ? null : premDep.getB140PremSeqNo().toString());
					
					log.info("Dep Flag: " + premDep.getDepFlag());
					log.info("B140 Iss Cd: " + premDep.getB140IssCd());
					
					log.info("Aeg parameters: ");
					log.info("gaccBranchCd: " + params.get("gaccBranchCd"));
					log.info("gaccFundCd: " + params.get("gaccFundCd"));
					log.info("gaccTranId: " + params.get("gaccTranId"));
					log.info("moduleName: " + params.get("moduleName"));
					log.info("depFlag: " + params.get("depFlag"));
					log.info("b140IssCd: " + params.get("b140IssCd"));
					log.info("b140PremSeqNo: "+ params.get("b140PremSeqNo"));
					
					this.getSqlMapClient().startBatch();
					this.getSqlMapClient().update("aegParameters", params);
					this.getSqlMapClient().executeBatch();
					
					message = (String)params.get("message");
					
					log.info("message: " + message);
					if (!"SUCCESS".equals(message)) {
						if ("No data found in giac_module_entries.".equals(message)) {
							message = "Error on saving item " + premDep.getItemNo() + ": " + message;
						}
						break;
					}
				}
			} else {
				params.put("gaccBranchCd", gaccBranchCd);
				params.put("gaccFundCd", gaccFundCd);
				params.put("gaccTranId", gaccTranId);
				params.put("moduleName", moduleName);
				params.put("depFlag", null);
				params.put("b140IssCd", null);
				params.put("b140PremSeqNo", null);
				
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("aegParameters", params);
				this.getSqlMapClient().executeBatch();
			}
			
			if (!"SUCCESS".equals(message)) {
				this.getSqlMapClient().getCurrentConnection().rollback();
			} else {
				this.getSqlMapClient().getCurrentConnection().commit();
			}
			//this.sqlMapClient.commitTransaction();
		} catch(SQLException e) {
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch(Exception e) {
			message = e.getMessage();
			log.info(e.getMessage());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#executeCollectionDefaultAmount(java.util.Map)
	 */
	@Override
	public void executeCollectionDefaultAmount(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("collectionDefaulAmount", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#getParSeqNo(java.util.Map)
	 */
	@Override
	public void getParSeqNo(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getParSeqNo", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#validateTranType2(java.util.Map)
	 */
	@Override
	public void validateTranType2(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateTranType2", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPremDepositDAO#checkGipdGipdFKConstraint(java.util.Map)
	 */
	@Override
	public String checkGipdGipdFKConstraint(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkGipdGipdFKConstraint", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveGIACPremDep(Map<String, Object> allParams)
			throws SQLException {
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving premium deposits..."+allParams);
			
			List<GIACPremDeposit> setRows = (List<GIACPremDeposit>) allParams.get("setRows");
			List<GIACPremDeposit> delRows = (List<GIACPremDeposit>) allParams.get("delRows");
			
			for (GIACPremDeposit del:delRows){
				log.info("deleting: "+ del);
				this.getSqlMapClient().delete("deleteGIACPremDeposit", del);
				this.getSqlMapClient().executeBatch();
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", allParams.get("userId"));
				params.put("gaccTranId", allParams.get("gaccTranId"));
				params.put("gaccBranchCd", allParams.get("gaccBranchCd"));
				params.put("gaccFundCd", allParams.get("gaccFundCd"));
				params.put("depFlag", null);
				params.put("b140IssCd", null);
				params.put("b140PremSeqNo", null);
				
				this.getSqlMapClient().insert("aegParametersGIACS026", params);
			}
			
			for (GIACPremDeposit set:setRows){
				log.info("inserting: "+ set);
				this.getSqlMapClient().insert("setGIACPremDeposit", set);
				this.getSqlMapClient().executeBatch();
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", allParams.get("userId"));
				params.put("gaccTranId", allParams.get("gaccTranId"));
				params.put("gaccBranchCd", allParams.get("gaccBranchCd"));
				params.put("gaccFundCd", allParams.get("gaccFundCd"));
				params.put("depFlag", set.getDepFlag());
				params.put("b140IssCd", set.getB140IssCd());
				params.put("b140PremSeqNo", set.getB140PremSeqNo());
				
				this.getSqlMapClient().insert("aegParametersGIACS026", params);
			}
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateGiacText", allParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e){
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			message = "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause();
			log.error(message);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving premium deposits.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractPremDeposit(String userId) throws SQLException {
		String message = "Extracting Premium Deposit";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of extract premium deposit...");
			this.getSqlMapClient().delete("extractPremDeposit", userId);
			this.getSqlMapClient().executeBatch();

			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractWidNoReversal(Map<String, Object> params) throws SQLException {
		String totalRow = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of extract premium deposit...");
			this.getSqlMapClient().insert("extractWidNoReversal", params);
			this.getSqlMapClient().executeBatch();
			
			totalRow = (String) params.get("totalRow");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return totalRow;
	}

	@Override		/*added by kenneth for print premium deposit 06.25.2013*/
	public String extractWidReversal(Map<String, Object> params) throws SQLException {
		String totalRow = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start of extract premium deposit...");
			this.getSqlMapClient().insert("extractWidReversal", params);
			this.getSqlMapClient().executeBatch();
			
			totalRow = (String) params.get("totalRow");
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return totalRow;
	}

	@SuppressWarnings("unchecked")		/*added by kenneth for print premium deposit 06.25.2013*/
	@Override		
	public Map<String, Object> getLastExtract(String userId) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getLastExtract", userId);
	}
}
