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
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.giac.dao.GIACAccTransDAO;
import com.geniisys.giac.entity.GIACAccTrans;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIACAccTransDAOImpl implements GIACAccTransDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACAccTransDAOImpl.class);
	
	/**
	 * Gets Validation details.
	 * 
	 * @param tran ID
	 */
	@Override
	public GIACAccTrans getValidationDetail(Integer tranId) throws SQLException {
		log.info("Get validation detail");
		return (GIACAccTrans) sqlMapClient.queryForObject("getValidationDetail", tranId);
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

	@Override
	public String getTranFlag(Integer tranId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getRecordTranFlag", tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getDCBListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCBListTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiacDCBListTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGiacAcctransDtl(java.lang.Integer)
	 */
	@Override
	public GIACAccTrans getGiacAcctransDtl(Integer gaccTranId)
			throws SQLException {
		return (GIACAccTrans) this.getSqlMapClient().queryForObject("getGiacAcctransDtl", gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGicdSumListTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGicdSumListTableGrid(
			Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return this.getSqlMapClient().queryForList("getGicdSumListTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getOtcSurchargeForTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getOtcSurchargeForTableGrid(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getOtcSurcharge", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getLocmForTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getLocmForTableGrid(
			Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return this.getSqlMapClient().queryForList("locmTableGrid", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#validateGiacs035DCBNo1(java.util.Map)
	 */
	@Override
	public void validateGiacs035DCBNo1(Map<String, Object> params)
			throws SQLException {
		// convert the integer properties
		String dcbYear = (String)params.get("dcbYear");
		String dcbNo   = (String)params.get("dcbNo");
		
		if (dcbYear != null) {
			params.put("dcbYear", (dcbYear.isEmpty() ? null : new Integer(dcbYear)));
		}
		
		if (dcbNo != null) {
			params.put("dcbNo", (dcbNo.isEmpty() ? null : new Integer(dcbNo)));
		}
		
		this.getSqlMapClient().update("validateGiacs035DCBNo1", params);
		Debug.print(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#validateGiacs035DCBNo2(java.util.Map)
	 */
	@Override
	public void validateGiacs035DCBNo2(Map<String, Object> params)
			throws SQLException {
		// convert the integer properties
		String dcbYear = (String)params.get("dcbYear");
		String dcbNo   = (String)params.get("dcbNo");
		
		if (dcbYear != null) {
			params.put("dcbYear", (dcbYear.isEmpty() ? null : new Integer(dcbYear)));
		}
		
		if (dcbNo != null) {
			params.put("dcbNo", (dcbNo.isEmpty() ? null : new Integer(dcbNo)));
		}
		
		this.getSqlMapClient().update("validateGiacs035DCBNo2", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getTranFlagMean(java.lang.String)
	 */
	@Override
	public String getTranFlagMean(String tranFlag) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("getTranFlagMean", tranFlag);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#checkBankInOR(java.util.Map)
	 */
	@Override
	public String checkBankInOR(Map<String, Object> params) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkBankInOR", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getDCBPayModeList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getDCBPayModeList(
			Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getDCBPayMode", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#executeGdbdAmtPreTextItem(java.util.Map)
	 */
	@Override
	public BigDecimal executeGdbdAmtPreTextItem(Map<String, Object> params)
			throws SQLException {
		return (BigDecimal)this.getSqlMapClient().queryForObject("executeGdbdAmtPreTextItem", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGdbdAmtWhenValidate(java.util.Map)
	 */
	@Override
	public BigDecimal getGdbdAmtWhenValidate(Map<String, Object> params)
			throws SQLException {
		return (BigDecimal)this.getSqlMapClient().queryForObject("getGdbdAmtWhenValidate", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getCurrSnameGicdSumRec(java.util.Map)
	 */
	@Override
	public BigDecimal getCurrSnameGicdSumRec(Map<String, Object> params)
			throws SQLException {
		return (BigDecimal)this.getSqlMapClient().queryForObject("getCurrSnameGicdSumRec", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getTotFcAmtForGicdSumRec(java.util.Map)
	 */
	@Override
	public void getTotFcAmtForGicdSumRec(Map<String, Object> params)
			throws SQLException {
		/* Change the type of Currency Rt to BigDecimal if it is not null */
		if (params.get("currencyRt") != null) {
			if (!params.get("currencyRt").toString().isEmpty()) {
				params.put("currencyRt", new BigDecimal(params.get("currencyRt").toString()));
			}
		}
		
		this.getSqlMapClient().update("getTotFcAmtForGicdSumRec", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGcddCollectionAndDeposit(java.util.Map)
	 */
	@Override
	public void getGcddCollectionAndDeposit(Map<String, Object> params)
			throws SQLException {
		// convert the integer properties
		String gaccTranId 	= (String)params.get("gaccTranId");
		String dcbYear 		= (String)params.get("dcbYear");
		String dcbNo   		= (String)params.get("dcbNo");
		String itemNo  		= (String)params.get("itemNo");
		
		if (gaccTranId != null) {
			params.put("gaccTranId", (gaccTranId.isEmpty() ? null : new Integer(gaccTranId)));
		}
		
		if (dcbYear != null) {
			params.put("dcbYear", (dcbYear.isEmpty() ? null : new Integer(dcbYear)));
		}
		
		if (dcbNo != null) {
			params.put("dcbNo", (dcbNo.isEmpty() ? null : new Integer(dcbNo)));
		}
		
		if (itemNo != null) {
			params.put("itemNo", (itemNo.isEmpty() ? null : new Integer(itemNo)));
		}
		
		this.getSqlMapClient().update("getGcddCollectionAndDeposit", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getCheckClassList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<CGRefCodes> getCheckClassList() throws SQLException {
		return this.getSqlMapClient().queryForList("getCheckClass2");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#updateGbdsdInOtc(java.lang.Integer)
	 */
	@Override
	public void updateGbdsdInOtc(Integer depId) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().update("updateGbdsdInOtc", depId);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			this.getSqlMapClient().endTransaction();
		} catch(SQLException e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch(Exception e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#getGbdsdLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getGbdsdLOV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGbdsdLov", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#executeGiacs035BankDepReturnBtn(java.util.Map)
	 */
	@Override
	public void executeGiacs035BankDepReturnBtn(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("executeGiacs035BankDepReturnBtn", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#checkDCBForClosing(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkDCBForClosing(Map<String, Object> params)
			throws SQLException {
		//log.info("Checking of dcb is valid for closing...");
		Debug.print("Checking of dcb is valid for closing... - "+params);
		this.getSqlMapClient().update("checkValidCloseAccTrans", params);
		Debug.print("checkDCBForClosing test - "+params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACAccTransDAO#closeDCB(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String closeDCB(Map<String, Object> params)
			throws SQLException {
		String mesg = "FAILED";
		Debug.print("closeDCB @ DAO - "+params);
		try {
			String updateEntries = (String) params.get("updateEntries");
			Map<String, Object> balanceParams = (Map<String, Object>) params.get("balParam");
			Map<String, Object> accTransMap = (Map<String, Object>) params.get("accTrans");
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			if("Y".equals(updateEntries)) {
				this.getSqlMapClient().startBatch();
				log.info("Balancing accounting entries...");
				this.getSqlMapClient().update("balanceEntriesGIACS035", balanceParams);
				this.getSqlMapClient().executeBatch();
				mesg = (String) balanceParams.get("mesg");
			} else {
				mesg = "Y";
			}
			
			if("Y".equals(mesg)) {
				this.getSqlMapClient().startBatch();
				log.info("Updating giac_acc_trans on dcb closing...");
				this.getSqlMapClient().queryForObject("saveAccTransDCBClosing", accTransMap);
				this.getSqlMapClient().executeBatch();
				mesg = (String) accTransMap.get("mesg");
				System.out.println("acctrans close dcb test mesg - "+(String) accTransMap.get("mesg"));
				if("Y".equals(mesg)) {
					this.getSqlMapClient().startBatch();
					log.info("Updating giac_colln_batch on close DCB...");
					this.getSqlMapClient().update("updateDCBForClosing", accTransMap);
					this.getSqlMapClient().executeBatch();
				}
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return mesg;
	}

	@Override
	public void updateAccTransFlag(Map<String, Object> params)
			throws SQLException {
		log.info("updateAccTransFlag: "+params);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateAccTransFlag", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
	}

	@Override
	public void updateDCBCancel(Map<String, Object> params) throws SQLException {
		log.info("updateDCBCancel :::::::::::::::::::: " + params);
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateDCBCancel", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecAcctEntTranDtl(Integer acctTranId)
			throws SQLException {
		System.out.println(acctTranId);
		List<Map<String, Object>> tranDtl = this.getSqlMapClient().queryForList("getGICLS055TransDtl", acctTranId);
		System.out.println("GIACAccTransTranDtl    "+tranDtl);
		return tranDtl;
	}
	
	@Override
	public String checkDCBFlag(Map<String, Object> params) throws SQLException {  //Deo [03.03.2017]: SR-5939
		return (String) this.getSqlMapClient().queryForObject("checkDCBFlag", params);
	}
}
