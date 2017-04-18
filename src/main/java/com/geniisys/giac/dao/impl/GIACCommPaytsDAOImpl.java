package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;

import com.geniisys.giac.dao.GIACCommPaytsDAO;
import com.geniisys.giac.entity.GIACCommPayts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCommPaytsDAOImpl implements GIACCommPaytsDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;

	/** The log. */
	private Logger log = Logger.getLogger(GIACCommPaytsDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getGIACCommPayts(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACCommPayts> getGIACCommPayts(int gaccTranId)
			throws SQLException {
		return (List<GIACCommPayts>)this.getSqlMapClient().queryForList("getGIACCommPayts", gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getGiacs020BasicVarValues(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, Object> getGiacs020BasicVarValues(Integer gaccTranId, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", gaccTranId);
		params.put("userId", userId);
		this.getSqlMapClient().update("getGIACS020BasicVarValues", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getBillNoList(java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBillNoList(Integer tranType, String issCd,
			Integer gaccTranId, String keyword) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tranType", tranType);
		params.put("issCd", issCd);
		params.put("gaccTranId", gaccTranId);
		params.put("keyword", keyword);
		return this.getSqlMapClient().queryForList("getBillNoList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getGIPICommInvoice(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIPICommInvoice(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs020GetGIPICommInvoice", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#chkModifiedComm(java.lang.String, java.lang.String)
	 */
	@Override
	public String chkModifiedComm(String premSeqNo, String issCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("premSeqNo", premSeqNo);
		params.put("issCd", issCd);
		return (String)this.getSqlMapClient().queryForObject("chkModifiedComm", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#validateGIACS020IntmNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateGIACS020IntmNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGIACS020IntmNo", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#commPaytsIntmNoPostText(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsIntmNoPostText(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giacs020IntmNoPostText", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#commPaytsParam2MgmtComp(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsParam2MgmtComp(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giacs020Param2MgmtComp", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getCommPaytsDefPremPct(java.util.Map)
	 */
	@Override
	public Map<String, Object> getCommPaytsDefPremPct(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getCommPaytsDefPremPct", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#commPaytsCompSummary(java.util.Map)
	 */
	@Override
	public Map<String, Object> commPaytsCompSummary(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs020CompSummary", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#preInsertGiacs020CommPayts(java.util.Map)
	 */
	@Override
	public Map<String, Object> preInsertGiacs020CommPayts(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("preInsertGIACS020CommPayts", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#deleteGIACCommPayts(java.util.List)
	 */
	@Override
	public void deleteGIACCommPayts(List<GIACCommPayts> giacCommPayts)
			throws SQLException {
		log.info("Deleting GIAC Comm Payts records...");
		log.info("Gacc Tran Id\tIntm No\tIss Cd\tPrem Seq No\tRecord No");
		log.info("=======================================================================================");
		
		if (giacCommPayts != null) {
			for (GIACCommPayts commPayts : giacCommPayts) {
				log.info(commPayts.getGaccTranId() + "\t" + commPayts.getIntmNo() + "\t" + commPayts.getIssCd() + "\t" + commPayts.getPremSeqNo() + "\t" + commPayts.getRecordNo());
				this.getSqlMapClient().delete("deleteGIACCommPayts", commPayts);
				log.info("SPOILING CFS: ");
				log.info(+commPayts.getGaccTranId() + "\t" + commPayts.getIntmNo() + "\t" + commPayts.getIssCd() + "\t" + commPayts.getPremSeqNo() + "\t" + commPayts.getRecordNo());
				this.getSqlMapClient().update("spoilCFS", commPayts);	// to spoil CFS : shan 10.31.2014
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully deleted!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#setGIACCommPayts(java.util.List)
	 */
	@Override
	public void setGIACCommPayts(List<GIACCommPayts> giacCommPayts)
			throws SQLException {
		log.info("Saving GIAC Comm Payts records...");
		log.info("Gacc Tran Id\tIntm No\tIss Cd\tPrem Seq No\tUser Id");
		log.info("=======================================================================================");
		
		if  (giacCommPayts != null) {
			for (GIACCommPayts commPayts : giacCommPayts) {
				log.info(commPayts.getGaccTranId() + "\t" + commPayts.getIntmNo() + "\t" + commPayts.getIssCd() + "\t" + commPayts.getPremSeqNo() + "\t" + commPayts.getUserId());
				this.getSqlMapClient().insert("setGIACCommPayts", commPayts);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#saveGIACCommPayts(java.util.List, java.util.List, java.util.Map)
	 */
	@Override
	public Map<String, Object> saveGIACCommPayts(List<GIACCommPayts> giacCommPayts,
			List<GIACCommPayts> delGiacCommPayts, Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			params.put("message", new String("SUCCESS"));
			
			// set user_id for giacCommPayts records
			if (giacCommPayts != null) {
				for (int i = 0; i < giacCommPayts.size(); i++) {
					giacCommPayts.get(i).setUserId((params.get("appUser") == null) ? null : params.get("appUser").toString());
				}
			}
			
			// insert/update
			this.getSqlMapClient().startBatch();
			//this.setGIACCommPayts(giacCommPayts); replaced by robert SR 19752 07.28.15 
			if  (giacCommPayts != null) {
				for (GIACCommPayts commPayts : giacCommPayts) {
					log.info(commPayts.getGaccTranId() + "\t" + commPayts.getIntmNo() + "\t" + commPayts.getIssCd() + "\t" + commPayts.getPremSeqNo() + "\t" + commPayts.getUserId());
					if(commPayts.getRecordSeqNo() == null ){
						Map<String, Object> parameters = new HashMap<String, Object>();
						parameters.put("gaccTranId", commPayts.getGaccTranId().toString());
						parameters.put("intmNo", commPayts.getIntmNo().toString());
						parameters.put("issCd", commPayts.getIssCd());
						parameters.put("premSeqNo", commPayts.getPremSeqNo().toString());
						parameters.put("commTag", commPayts.getCommTag());
						parameters.put("recordNo", commPayts.getRecordNo().toString());
						this.getSqlMapClient().update("getRecordSeqNo", parameters);
						commPayts.setRecordSeqNo(Integer.parseInt(parameters.get("recordSeqNo").toString()));
					}
					this.getSqlMapClient().insert("setGIACCommPayts", commPayts);
					this.getSqlMapClient().executeBatch();
				}
			} //end robert SR 19752 07.28.15 
			this.getSqlMapClient().executeBatch();
			
			// delete
			this.getSqlMapClient().startBatch();
			this.deleteGIACCommPayts(delGiacCommPayts);
			this.getSqlMapClient().executeBatch();
			
			// key-delrec
			if (giacCommPayts != null) {
				this.getSqlMapClient().startBatch();
				for (GIACCommPayts commPayts : giacCommPayts) {
					this.getSqlMapClient().delete("deleteGIACPremDepByRecordNo", commPayts);
				}
				this.getSqlMapClient().executeBatch();
			}
			//added by robert SR 19752 08.13.15 to renumber recordSeqNo
			if (giacCommPayts != null) {
				this.getSqlMapClient().startBatch();
				Map<String, Object> renumParams = new HashMap<String, Object>();
				renumParams.put("appUser", params.get("appUser"));
				renumParams.put("gaccTranId", params.get("gaccTranId"));
				this.getSqlMapClient().queryForObject("renumberCommPayts", renumParams);
				this.getSqlMapClient().executeBatch();
			}
			//end robert SR 19752 08.13.15
			// post-forms-commit
			if (params!= null) {
				List<GIACCommPayts> commPaytsList = new ArrayList<GIACCommPayts>();
				
				if (giacCommPayts != null) {
					commPaytsList.addAll(giacCommPayts);
				}
				
				if (delGiacCommPayts != null) {
					commPaytsList.addAll(delGiacCommPayts);
				}
				
				for (GIACCommPayts commPayts : commPaytsList) {		
					params.put("issCd", commPayts.getIssCd());
					params.put("premSeqNo", (commPayts.getPremSeqNo() == null) ? null : commPayts.getPremSeqNo().toString());
					params.put("intmNo", (commPayts.getIntmNo() == null) ? null : commPayts.getIntmNo().toString());
					params.put("recordNo", (commPayts.getRecordNo() == null) ? null : commPayts.getRecordNo().toString());
					params.put("disbComm", (commPayts.getDisbComm() == null) ? null : commPayts.getDisbComm().toString());
					params.put("drvCommAmt", (commPayts.getDrvCommAmt() == null) ? null : commPayts.getDrvCommAmt().toString());
					params.put("currencyCd", (commPayts.getCurrencyCd() == null) ? null : commPayts.getCurrencyCd().toString());
					params.put("convertRate", (commPayts.getConvertRate() == null) ? null : commPayts.getConvertRate().toString());
					
					log.info("Executing GIACS020 Post-Forms-Commit trigger.");
					log.info("User Id: " + params.get("appUser"));
					log.info("Global Tran Source: " + params.get("globalTranSource"));
					log.info("Global OR Flag: " + params.get("globalOrFlag"));
					log.info("Gacc Branch Cd: " + params.get("gaccBranchCd"));
					log.info("Gacc Fund Cd: " + params.get("gaccFundCd"));
					log.info("Gacc Tran Id: " + params.get("gaccTranId"));
					log.info("Iss Cd: " + params.get("issCd"));
					log.info("Prem Seq No: " + params.get("premSeqNo"));
					log.info("Intm No: " + params.get("intmNo"));
					log.info("Record No: " + params.get("recordNo"));
					log.info("Disb Comm: " + params.get("disbComm"));
					log.info("Drv Comm Amt: " + params.get("drvCommAmt"));
					log.info("Currency Cd: " + params.get("currencyCd"));
					log.info("Convert Rate: " + params.get("convertRate"));
					log.info("Var Module Name: " + params.get("varModuleName"));
					log.info("Var Module Id: " + params.get("varModuleId"));
					log.info("Var Gen Type: " + params.get("varGenType"));
					
					this.getSqlMapClient().startBatch();
					params = this.executeGiacs020PostFormsCommit(params);
					this.getSqlMapClient().executeBatch();
					
					log.info("GIACS020 Post-Forms-Commit successful.");
				}
			}
			
			log.info(params.get("message"));
			
			if (params.get("message") != null) {
				if (!"SUCCESS".equals(params.get("message"))) {
					this.getSqlMapClient().getCurrentConnection().rollback();
				} else {
					this.getSqlMapClient().getCurrentConnection().commit();
				}
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		} catch(SQLException e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch(Exception e) {
			log.info(e.getMessage());
			params.put("message", e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#executeGiacs020PostFormsCommit(java.util.Map)
	 */
	@Override
	public Map<String, Object> executeGiacs020PostFormsCommit(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("executeGIACS020PostFormsCommit", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#getGcopInv(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGcopInv(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGcopInv", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#checkGcopInvChkTag(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkGcopInvChkTag(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("chkGcopInvChkTag", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACCommPaytsDAO#executeGIACS020DeleteRecord(java.util.Map)
	 */
	@Override
	public String executeGIACS020DeleteRecord(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs020KeyDelrec", params);
		return (String)params.get("message");
	}

	@Override
	public String checkRelCommWUnprintedOr(Map<String, Object> params)
			throws SQLException {
		JSONArray objArray = new JSONArray();
		this.getSqlMapClient().update("checkRelCommWUnprintedOr",params);
		objArray.put(params);
		return objArray.toString();
	}
	
	public Map<String, Object> getParam2FullPremPayt(Map<String, Object> params) throws SQLException{
		log.info("getParam2FullPremPayt: "+params.toString());
		this.getSqlMapClient().update("giacs020Param2FullPremPayt", params);
		return params;
	}
	
	public String validateGIACS020BillNo(Map<String, Object> params) throws SQLException{	// SR-4185, 4274, 4275, 4276, 4277 [GIACS020] : shan 05.20.2015
		log.info("validateGIACS020BillNo: " + params.toString());
		return (String) this.getSqlMapClient().queryForObject("validateGIACS020BillNo", params);
	}
	
	@Override
	public String checkingIfPaidOrUnpaid(Map<String, Object> params) throws SQLException { //SR20909 :: john 11.9.2015
		//this.sqlMapClient.update("checkingIfPaidOrUnpaid", params); //Commented out and replaced by code below - Jerome Bautista 03.04.2016 SR 21279
		return (String) this.getSqlMapClient().queryForObject("checkingIfPaidOrUnpaid", params); 
	}

	@Override
	public void checkCommPaytStatus(Integer gaccTranId)
			throws SQLException {
		System.out.println("@CHECK COMM PAYT *** " + gaccTranId.toString());
		this.getSqlMapClient().update("checkCommPaytStatus", gaccTranId);
	}
}
