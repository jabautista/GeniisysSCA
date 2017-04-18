/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIParItemDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIParItemDAOImpl.
 */
public class GIPIParItemDAOImpl implements GIPIParItemDAO{

	/** The log. */
	private Logger log = Logger.getLogger(GIPIParMortgageeDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;	
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteAllGIPIParItem(int)
	 */
	@Override
	public void deleteAllGIPIParItem(int parId) throws SQLException {
		this.getSqlMapClient().delete("deleteAllGIPIParItem", parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteGIPIParItem(int, int)
	 */
	@Override
	public void deleteGIPIParItem(int parId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		this.getSqlMapClient().delete("deleteGIPIParItem", params);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteGIPIEndtParItem(int, int)
	 */
	@Override
	public void deleteGIPIEndtParItem(int parId, int itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		this.getSqlMapClient().delete("deleteGIPIEndtParItem", params);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#delGIPIParItem(java.util.List)
	 */
	@Override
	public void delGIPIParItem(List<GIPIItem> items) throws SQLException {
		log.info("DAO calling delGIPIParItem...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Deleting record/s");
			System.out.println("ParID\tItemNo\tItemTitle");
			System.out.println("=======================================================================================");
			
			for(GIPIItem item : items){
				System.out.println(item.getParId() + "\t" + item.getItemNo() + "\t" + item.getItemTitle());
				this.deleteGIPIParItem(item.getParId(), item.getItemNo());
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
	}	
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#delGIPIEndtParItem(java.util.List)
	 */
	@Override
	public void delGIPIEndtParItem(List<GIPIItem> items) throws SQLException {
		log.info("DAO calling delGIPIParItem...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Deleting record/s");
			System.out.println("ParID\tItemNo\tItemTitle");
			System.out.println("=======================================================================================");
			
			for(GIPIItem item : items){
				System.out.println(item.getParId() + "\t" + item.getItemNo() + "\t" + item.getItemTitle());
				this.deleteGIPIEndtParItem(item.getParId(), item.getItemNo());
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#saveGIPIParItem(com.geniisys.gipi.entity.GIPIItem)
	 */
	@Override
	public void saveGIPIParItem(GIPIItem parItem) throws SQLException {
		this.getSqlMapClient().insert("saveGIPIParItem", parItem);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#setGIPIParItem(java.util.List)
	 */
	@Override
	public void setGIPIParItem(List<GIPIItem> items) throws SQLException {
		log.info("DAO calling setGIPIParItem...");		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving record/s");
			System.out.println("ParID\tItemNo\tItemTitle");
			System.out.println("=======================================================================================");
			for(GIPIItem item : items){				
				System.out.println(item.getParId() + "\t" + item.getItemNo() + "\t" + item.getItemTitle());	
				System.out.println("region Cd sa DAO: "+item.getRegionCd());
				this.getSqlMapClient().insert("setGIPIParItem", item);				
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#confirmCopyItemPerilInfo(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyItemPerilInfo(Integer parId, String lineCd, String sublineCd)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);		
		return this.getSqlMapClient().queryForObject("confirmCopyItemPerilInfo", params).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deletePolDeductibles(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void deletePolDeductibles(Integer parId, String lineCd,
			String sublineCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		this.getSqlMapClient().queryForObject("deletePolDeductibles", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#confirmRenumber(int)
	 */
	@Override
	public String confirmRenumber(int parId) throws SQLException {		
		return this.getSqlMapClient().queryForObject("confirmRenumber", parId).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#renumber(int)
	 */
	@Override
	public void renumber(int parId) throws SQLException {
		this.getSqlMapClient().queryForList("renumber", parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#confirmAssignDeductibles(int, int)
	 */
	@Override
	public String confirmAssignDeductibles(int parId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);		
		return (String)this.getSqlMapClient().queryForObject("confirmAssignDeductibles", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#assignDeductibles(int, int)
	 */
	@Override
	public void assignDeductibles(int parId, int itemNo) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().queryForList("assignDeductibles", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#confirmCopyItem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyItem(Integer parId, String lineCd, String sublineCd)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		return (String)this.getSqlMapClient().queryForObject("confirmCopyItem", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#checkIfDiscountExists(int)
	 */
	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {		
		return (String)this.getSqlMapClient().queryForObject("checkIfDiscExists", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#getMaxWItemNo(int)
	 */
	@Override
	public int getMaxWItemNo(int parId) throws SQLException {		
		return (Integer)this.getSqlMapClient().queryForObject("getMaxWItemNo", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#copyItem(int, int, int)
	 */
	@Override
	public void copyItem(int parId, int itemNo, int newItemNo) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("newItemNo", newItemNo);
		this.getSqlMapClient().queryForObject("copyItem", params);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#copyAdditionalInfoMC(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoMC(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("newItemNo", newItemNo);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		System.out.println("Copy Addtl Item Info. "+parId+" "+itemNo+" "+newItemNo+" "+lineCd+" "+sublineCd);
		this.getSqlMapClient().queryForObject("copyAdditionalInfoMC", params);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteItemDeductible(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void deleteItemDeductible(int parId, int itemNo, String lineCd,
			String sublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);		
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		this.getSqlMapClient().queryForObject("deleteItemDeductible", params);
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#copyItemPeril(int, int, int)
	 */
	@Override
	public void copyItemPeril(int parId, int itemNo, int newItemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("newItemNo", newItemNo);
		this.getSqlMapClient().queryForObject("copyItemPeril", params);
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#checkGIPIWItem(int, int, int)
	 */
	@Override
	public String checkGIPIWItem(int checkBoth, int parId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("checkBoth", checkBoth);
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return (String)this.getSqlMapClient().queryForObject("checkGIPIWItem", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#postDeleteGIPIWItem(int, java.lang.String, java.lang.String)
	 */
	@Override
	public void postDeleteGIPIWItem(int parId, String lineCd, String sublineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		this.getSqlMapClient().queryForObject("postDeleteGIPIWItem", params);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#insertParhist(int, java.lang.String)
	 */
	@Override
	public void insertParhist(int parId, String userName) throws SQLException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("userName", userName);
		this.getSqlMapClient().queryForObject("insertParhist", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteDiscount(int)
	 */
	@Override
	public void deleteDiscount(int parId) throws SQLException {		
		this.getSqlMapClient().queryForObject("deleteDiscount", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#updateGIPIWPackLineSubline(int, java.lang.String, java.lang.String)
	 */
	@Override
	public void updateGIPIWPackLineSubline(int parId, String packLineCd,
			String packSublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packLineCd", packLineCd);
		params.put("packSublineCd", packSublineCd);
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSubline", params);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteCoInsurer(int)
	 */
	@Override
	public void deleteCoInsurer(int parId) throws SQLException {		
		this.getSqlMapClient().queryForObject("deleteCoInsurer", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteBill(int)
	 */
	@Override
	public void deleteBill(int parId) throws SQLException {		
		this.getSqlMapClient().queryForObject("deleteBillOnItem", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#changeItemGroup(int, java.lang.String)
	 */
	@Override
	public void changeItemGroup(int parId, String packPolFlag)
			throws SQLException {
		log.info("Changing item group no for PAR ID "+parId+" PACK POL FLAG "+packPolFlag+"...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packPolFlag", packPolFlag);
		this.getSqlMapClient().queryForObject("changeItemGroup", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#addParStatusNo(int, java.lang.String, int, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> addParStatusNo(int parId, String lineCd, int parStatus,
			String invoiceSw, String issCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("parStatus", parStatus);
		params.put("invoiceSw", invoiceSw);
		params.put("issCd", issCd);
		this.getSqlMapClient().update("addParStatusNo", params);
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#updateGipiWPolbasNoOfItem(int)
	 */
	@Override
	public void updateGipiWPolbasNoOfItem(int parId) throws SQLException {		
		this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#checkAdditionalInfoMC(int)
	 */
	@Override
	public String checkAdditionalInfoMC(int parId) throws SQLException {		
		return (String)this.getSqlMapClient().queryForObject("checkAdditionalInfoMC", parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#checkAdditionalInfoFI(int)
	 */
	@Override
	public String checkAdditionalInfoFI(int parId) throws SQLException {		
		return (String)this.getSqlMapClient().queryForObject("checkAdditionalInfoFI", parId);
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#getMaxRiskItemNo(int, int)
	 */
	@Override
	public int getMaxRiskItemNo(int parId, int riskNo) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", parId);
		param.put("riskNo", riskNo);
		return (Integer)this.getSqlMapClient().queryForObject("getMaxRiskItemNo", param);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#getMaxEndtParItemNo(int)
	 */
	@Override
	public int getMaxEndtParItemNo(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return (Integer)this.getSqlMapClient().queryForObject("getMaxEndtParItemNo", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#confirmCopyEndtParItem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyEndtParItem(Integer parId, String lineCd,
			String sublineCd) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		return (String)this.getSqlMapClient().queryForObject("confirmCopyEndtParItem", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#copyAdditionalInfoMCEndt(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoMCEndt(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("newItemNo", newItemNo);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		this.getSqlMapClient().queryForObject("copyAdditionalInfoMCEndt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#validateNegateItem(int, int)
	 */
	@Override
	public String validateNegateItem(int parId, int itemNo) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return (String)this.getSqlMapClient().queryForObject("validateNegateItem", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#checkBackEndtBeforeDelete(int, int)
	 */
	@Override
	public String checkBackEndtBeforeDelete(int parId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		return (String)this.getSqlMapClient().queryForObject("checkBackEndtBeforeDelete", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#extractExpiry(int)
	 */
	@Override
	public Date extractExpiry(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return (Date)this.getSqlMapClient().queryForObject("extractExpiry", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#deleteDiscount2(int)
	 */
	@Override
	public void deleteDiscount2(int parId) throws SQLException {
		// TODO Auto-generated method stub
		this.getSqlMapClient().queryForObject("deleteDiscount2", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#negateItem(int, int)
	 */
	@Override
	public Map<String, Object> negateItem(int parId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().update("negateItem", params);
		
		//convert to big decimals
		String premAmt = (String)params.remove("premAmt");
		String tsiAmt = (String)params.remove("tsiAmt");
		String annPremAmt = (String)params.remove("annPremAmt");
		String annTsiAmt = (String)params.remove("annTsiAmt");
		
		log.info("Prem Amt : " + premAmt);
		log.info("Tsi Amt : " + tsiAmt);
		log.info("Ann Prem Amt : " + annPremAmt);
		log.info("Ann Tsi Amt : " + annTsiAmt);
		
		params.put("premAmt", (premAmt == null) ? " " : ((premAmt.equals("")) ? " " : new BigDecimal(premAmt)));
		params.put("tsiAmt", (tsiAmt == null) ? " " : ((tsiAmt.equals("")) ? " " : new BigDecimal(tsiAmt)));
		params.put("annPremAmt", (annPremAmt == null) ? " " : ((annPremAmt.equals("")) ? " " : new BigDecimal(annPremAmt)));
		params.put("annTsiAmt", (annTsiAmt == null) ? " " : ((annTsiAmt.equals("")) ? " " : new BigDecimal(annTsiAmt)));
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#createEndtParDistribution1(int, int)
	 */
	@Override
	public String createEndtParDistribution1(int parId, int distNo)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("distNo", distNo);
		this.getSqlMapClient().update("createEndtParDistribution1", params);
		log.info("Message 1: " + params.get("message1"));
		log.info("Message 2 : " + params.get("message2"));
		message = params.get("message1") == null ? "SUCCESS" : params.get("message1").toString();
		message = message + " " + (params.get("message2") == null ? "SUCCESS" : params.get("message2").toString());
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#createEndtParDistribution2(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public String createEndtParDistribution2(int parId, int distNo,
			String recExistsAlert, String distributionAlert) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("distNo", distNo);
		params.put("recExistsAlert", recExistsAlert);
		params.put("distributionAlert", distributionAlert);
		this.getSqlMapClient().update("createEndtParDistribution2", params);
		message = params.get("message1") == null ? "SUCCESS" : params.get("message1").toString();
		return message;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#createEndtInvoiceItem(int)
	 */
	@Override
	public String createEndtInvoiceItem(int parId) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		this.getSqlMapClient().update("createEndtInvoiceItem", params);
		return params.get("message") == null ? "SUCCESS" : params.get("message").toString();
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#createEndtParDistribution1(int, int)
	 */
	@Override
	public String createEndtDistributionItem1(int parId, int distNo)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("distNo", distNo);
		this.getSqlMapClient().update("createEndtParDistItem1", params);
		message = params.get("message1") == null ? "SUCCESS" : params.get("message1").toString();
		message = message + " " + (params.get("message2") == null ? "SUCCESS" : params.get("message2").toString());
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#createEndtParDistribution2(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public String createEndtDistributionItem2(int parId, int distNo,
			String recExistsAlert, String distributionAlert) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("distNo", distNo);
		params.put("recExistsAlert", recExistsAlert);
		params.put("distributionAlert", distributionAlert);
		this.getSqlMapClient().update("createEndtParDistItem2", params);
		message = params.get("message1") == null ? "SUCCESS" : params.get("message1").toString();
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#addEndtParStatusNo(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.math.BigDecimal, java.lang.String)
	 */
	@Override
	public String addEndtParStatusNo(int parId, String lineCd, String issCd,
			String endtTaxSw, String coInsSw, String negateItem,
			String prorateFlag, String compSw, String endtExpiryDate,
			String effDate, BigDecimal shortRtPercent, String expiryDate)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		params.put("endtTaxSw", endtTaxSw);
		params.put("coInsSw", coInsSw);
		params.put("negateItem", negateItem);
		params.put("prorateFlag", prorateFlag);
		params.put("compSw", compSw);
		params.put("endtExpiryDate", endtExpiryDate);
		params.put("effDate", effDate);
		params.put("shortRtPercent", shortRtPercent);
		params.put("expiryDate", expiryDate);
		log.info("Par Id: " + parId);
		log.info("Line Cd: " + lineCd);
		log.info("Iss Cd: " + issCd);
		log.info("endt Tax SW: " + endtTaxSw);
		log.info("Co Ins Sw: " + coInsSw);
		log.info("Negate Item : " + negateItem);
		log.info("Prorate Flag: " + prorateFlag);
		log.info("Comp Sw: " + compSw);
		log.info("Endt Expiry Date: " + endtExpiryDate);
		log.info("Eff Data: " + effDate);
		log.info("Short Rt Percent: " + shortRtPercent);
		log.info("Expiry Date: " + expiryDate);
		this.getSqlMapClient().update("addEndtParStatusNo", params);
		message = (String)params.get("message");
		message = message == null ? "An error has occured." : message;
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#setPackageMenu(int, int)
	 */
	@Override
	public boolean setPackageMenu(int parId, int packParId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packParId", packParId);
		this.getSqlMapClient().update("setPackageMenu", params);
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#updateEndtGipiWpackLineSubline(int, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean updateEndtGipiWpackLineSubline(int parId, String packLineCd,
			String packSublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("packLineCd", packLineCd);
		params.put("packSublineCd", packSublineCd);
		this.getSqlMapClient().update("updateEndtGipiWpackLineSubline", params);
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#endtParValidateOtherInfo(int, int, java.lang.String)
	 */
	@Override
	public String endtParValidateOtherInfo(int parId, int funcPart,
			String alertConfirm) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		String message;
		params.put("parId", parId);
		params.put("funcPart", funcPart);
		params.put("alertConfirm", alertConfirm);
		message = (String)this.getSqlMapClient().queryForObject("endtParValidateOtherInfo", params);
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemDAO#copyAdditionalInfoFIEndt(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoFIEndt(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("newItemNo", newItemNo);
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		this.getSqlMapClient().queryForObject("copyAdditionalInfoFIEndt", params);
	}
}
