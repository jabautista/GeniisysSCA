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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWCommInvoiceDAO;
import com.geniisys.gipi.entity.GIPIWCommInvoice;
import com.geniisys.gipi.entity.GIPIWCommInvoicePeril;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWCommInvoiceDAOImpl.
 */
public class GIPIWCommInvoiceDAOImpl implements GIPIWCommInvoiceDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWCommInvoiceDAOImpl.class);
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getWCommInvoice(int, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCommInvoice> getWCommInvoice(int parId, int itemGroup)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGroup", itemGroup);
		
		log.info("DAO - Retrieving Commission Invoices...");
		List<GIPIWCommInvoice> wcommInvoice = this.getSqlMapClient().queryForList("getWCommInvoice", params);
		
		/*
		 * check if parent intm no is null.
		 * if yes, then set parent intm to intm. for display purpose only.
		 */
		
		if (wcommInvoice != null) {
			for (int i = 0; i < wcommInvoice.size(); i++) {
				if (wcommInvoice.get(i).getParentIntermediaryNo() < 0) {
					wcommInvoice.get(i).setParentIntermediaryNo(wcommInvoice.get(i).getIntermediaryNo());
					wcommInvoice.get(i).setParentIntermediaryName(wcommInvoice.get(i).getIntermediaryName());
				}
			}
		}
		
		log.info("DAO - " + wcommInvoice.size() + " Commission Invoice(s) retrieved.");
		
		return wcommInvoice;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getWCommInvoice(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCommInvoice> getWCommInvoice(int parId)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		
		log.info("DAO - Retrieving Commission Invoices...");
		List<GIPIWCommInvoice> wcommInvoice = this.getSqlMapClient().queryForList("getWCommInvoice2", params);
		
		/*
		 * check if parent intm no is null.
		 * if yes, then set parent intm to intm. for display purpose only.
		 */
		
		if (wcommInvoice != null) {
			for (int i = 0; i < wcommInvoice.size(); i++) {
				if (wcommInvoice.get(i).getParentIntermediaryNo() < 0) {
					wcommInvoice.get(i).setParentIntermediaryNo(wcommInvoice.get(i).getIntermediaryNo());
					wcommInvoice.get(i).setParentIntermediaryName(wcommInvoice.get(i).getIntermediaryName());
				}
			}
		}
		
		log.info("DAO - " + wcommInvoice.size() + " Commission Invoice(s) retrieved.");
		
		return wcommInvoice;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#saveWCommInvoice(int, java.math.BigDecimal, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public boolean saveWCommInvoice(List<GIPIWCommInvoice> commInvoices) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = null;
		int count = 0;
		
		log.info("DAO - Saving Commission Invoice...");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIPIWCommInvoice commInvoice : commInvoices) {
				log.info("DAO - Saving Commission Invoice " + ++count);
				params = new HashMap<String, Object>();
				
				params.put("intmNo", commInvoice.getIntermediaryNo());
				params.put("sharePercentage", commInvoice.getSharePercentage());
				params.put("takeupSeqNo", commInvoice.getTakeupSeqNo());
				params.put("itemGroup", commInvoice.getItemGroup());
				params.put("parId", commInvoice.getParId());
				params.put("premiumAmount", commInvoice.getPremiumAmount());
				params.put("commissionAmount", commInvoice.getCommissionAmount());
				params.put("withholdingTax", commInvoice.getWithholdingTax());
				
				this.getSqlMapClient().update("setWCommInvoice", params);
				
				//commInvoices.remove(commInvoice);
				
				log.info("Commission Invoice " + count + " saved.");
			}			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();			
			
			log.info("DAO - Commission Invoice successfully saved.");
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#deleteWCommInvoice(int, int)
	 */
	@Override
	public boolean deleteWCommInvoice(int parId, int itemGroup) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGroup", itemGroup);
		
		log.info("DAO - Deleting Commission Invoice...");
		this.getSqlMapClient().delete("deleteWCommInvoice", params);
		log.info("DAO - Commission Invoice deleted.");
		
		return true;
	}
	


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#deleteWCommInvoice2(java.util.List)
	 */
	@Override
	public boolean deleteWCommInvoice2(List<GIPIWCommInvoice> commInvoices)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = null;
		int count = 0;
		
		log.info("DAO - Saving Commission Invoice...");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIPIWCommInvoice commInvoice : commInvoices) {
				log.info("DAO - Deleting Commission Invoice " + ++count);
				params = new HashMap<String, Object>();
				
				params.put("intmNo", commInvoice.getIntermediaryNo());
				params.put("takeupSeqNo", commInvoice.getTakeupSeqNo());
				params.put("itemGroup", commInvoice.getItemGroup());
				params.put("parId", commInvoice.getParId());
				
				this.getSqlMapClient().delete("deleteWCommInvoice2", params);
				
				log.info("Commission Invoice " + count + " deleted.");
			}			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();			
			
			log.info("DAO - Commission Invoice successfully deleted.");
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#checkPerilCommRate(java.util.Map)
	 */
	@Override
	public String checkPerilCommRate(Map<String, Object> params)
			throws SQLException {
		// TODO Auto-generated method stub
		String result = (String)this.getSqlMapClient().queryForObject("checkPerilCommRate", params);
		
		if (result == null) {
			result = new String("");
		}
		
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getAccountingParameter(java.lang.String)
	 */
	@Override
	public String getAccountingParameter(String paramName) throws SQLException {
		// TODO Auto-generated method stub
		String result = null;
		
		/*
		 * NOTE:(String) and not .toString() - to handle null value returned 
		 */
		log.info("Retrieving accounting parameter...");
		result = (String)this.getSqlMapClient().queryForObject("getAccountingParameter", paramName);
		log.info("Account parameter Successfully retrieved.");
		
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getApplyBtnMap(int, int, int, int, int, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal)
	 */
	@Override
	public Map<String, Object> getApplyBtnMap(int parId, int itemGrp,
			int intmNo, int intmNoNbt, int takeupSeqNo,
			BigDecimal sharePercentage, BigDecimal sharePercentageNbt,
			BigDecimal prevSharePercentage, String lineCd, String issCd,
			String intmTypeNbt, String recordStatus, String perilCd,
			BigDecimal commissionAmt, BigDecimal commissionAmtNbt,
			BigDecimal premiumAmt, BigDecimal commissionRate,
			BigDecimal wholdingTax) throws SQLException {
		// TODO Auto-generated method stub		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGrp", itemGrp);
		params.put("intermediaryNo", intmNo);
		params.put("intermediaryNoNbt", intmNoNbt);
		params.put("takeupSeqNo", takeupSeqNo);
		params.put("sharePercentage", sharePercentage);
		params.put("sharePercentageNbt", sharePercentageNbt);
		params.put("prevSharePercentage", prevSharePercentage);
		params.put("lineCd", lineCd);
		params.put("issCd", issCd);
		params.put("intmTypeNbt", intmTypeNbt);
		params.put("recordStatus", recordStatus);
		params.put("perilCd", perilCd);
		params.put("commissionAmt", commissionAmt);
		params.put("commissionAmtNbt", commissionAmtNbt);
		//emman 04.05.10 - convert to string for handling varchar INOUT
		params.put("premiumAmt", premiumAmt.toString());
		params.put("commissionRate", commissionRate.toString());
		params.put("wholdingTax", wholdingTax.toString());
		this.getSqlMapClient().update("applyBtn", params);
		
		//emman 04.05.10 - convert from string to the original data type
		String varTaxAmt = (String)params.remove("varTaxAmt");
		String varSharePercentage = (String)params.remove("varSharePercentage");
		params.put("varTaxAmt", (varTaxAmt == null) ? new BigDecimal(0) : new BigDecimal(varTaxAmt));
		params.put("varSharePercentage", (varSharePercentage == null) ? new BigDecimal(0) : new BigDecimal(varSharePercentage));
		
		return params;
	}

	/*@Override
	public Map<String, Object> populateWcommInvPerils(int parId, int itemGrp,
			int takeupSeqNo, String lineCd, int intmNo, String nbtIntmType,
			String nbtRetOrig, String perilCd, String nbtPerilCd,
			BigDecimal sharePercentage, BigDecimal prevSharePercentage,
			BigDecimal premiumAmt, BigDecimal commissionRate,
			BigDecimal commissionAmt, BigDecimal nbtCommissionAmt,
			BigDecimal wholdingTax, String issCd, BigDecimal varRate) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("itemGrp", Integer.toString(itemGrp));
		params.put("takeupSeqNo", takeupSeqNo);
		params.put("lineCd", lineCd);
		params.put("intmNo", intmNo);
		params.put("nbtIntmType", nbtIntmType);
		params.put("nbtRetOrig", nbtRetOrig);
		params.put("perilCd", perilCd);
		//params.put("nbtPerilCd", nbtPerilCd);
		params.put("sharePercentage", sharePercentage.toString());
		params.put("prevSharePercentage", prevSharePercentage.toString());
		params.put("premiumAmt", premiumAmt.toString());
		params.put("commissionRate", commissionRate.toString());
		params.put("commissionAmt", commissionAmt.toString());
		params.put("nbtCommissionAmt", nbtCommissionAmt.toString());
		params.put("wholdingTax", wholdingTax.toString());
		params.put("varRate", varRate.toString());
		params.put("issCd", issCd);
		
		log.info("Invoice DAO populate... ");
		log.info("parId: " + parId);
		log.info("itemGrp: " + itemGrp);
		log.info("takeupSeqNo: " + takeupSeqNo);
		log.info("lineCd: " + lineCd);
		log.info("intmNo: " + intmNo);
		log.info("nbtIntmType: " + nbtIntmType);
		log.info("nbtRetOrig: " + nbtRetOrig);
		log.info("perilCd: " + perilCd);
		log.info("nbtPerilCd: " + nbtPerilCd);
		log.info("sharePercentage: " + sharePercentage);
		log.info("prevSharePercentage: " + prevSharePercentage);
		log.info("premiumAmt: " + premiumAmt);
		log.info("commissionRate: " + commissionRate);
		log.info("commissionAmt: " + commissionAmt);
		log.info("nbtCommissionAmt: " + nbtCommissionAmt);
		log.info("wholdingTax: " + wholdingTax);
		log.info("ISS Code: " + issCd);
		
		this.getSqlMapClient().update("populateWcommInvPerils", params);
		
		//conversions (integer to string, vice versa)
		int paramItemGrp = (params.get("itemGrp") == null) ? 0 : Integer.parseInt(params.remove("itemGrp").toString());
		
		params.put("itemGrp", paramItemGrp);
		
		return params;
	}*/
	
	@Override
	public void populateWcommInvPerils(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("populateWcommInvPerils", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#validateIntmNo(int, int, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> validateIntmNo(int parId, int intmNo,
			String lineCd, String lovTag, String globalCancelTag) throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		params.put("intmNo", intmNo);
		params.put("lineCd", lineCd);
		params.put("lovTag", lovTag);
		params.put("globalCancelTag", globalCancelTag);
		
		this.getSqlMapClient().update("validateIntmNo", params);
		
		log.info("Message : " + params.get("message"));
		
		return params;
	}

	@Override
	public Map<String, Object> getParTypeAndEndtTax(int parId)
			throws SQLException {
		// TODO Auto-generated method stub
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", parId);
		
		this.getSqlMapClient().update("getParTypeAndEndtTax", params);
		
		log.info("Par Type : " + params.get("parType"));
		log.info("Endt Tax : " + params.get("endtTax"));
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#executeGipis085WhenNewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGipis085WhenNewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("wcommInvoiceNewFormInstance", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#executeBancassuranceGetDefaultTaxRt(java.util.Map)
	 */
	@Override
	public void executeBancassuranceGetDefaultTaxRt(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("bancassuranceGetDefaultTaxRt", params);
			
			this.getSqlMapClient().executeBatch();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#executeBancassuranceProcessCommission(java.util.Map)
	 */
	@Override
	public void executeBancassuranceProcessCommission(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("bancassuranceProcessCommission", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#validateGipis085IntmNo(java.util.Map)
	 */
	@Override
	public void validateGipis085IntmNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGipis085IntmNo", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#populateWcommInvPerils2(java.util.Map)
	 */
	@Override
	public void populateWcommInvPerils2(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("populateWcommInvPerils2", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getIntmdryRate(java.util.Map)
	 */
	@Override
	public void getIntmdryRate(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getIntmdryRate", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getAdjustIntmdryRate(java.util.Map)
	 */
	@Override
	public BigDecimal getAdjustIntmdryRate(Map<String, Object> params)
			throws SQLException {
		return (BigDecimal)this.getSqlMapClient().queryForObject("getAdjustIntmdryRate", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#populatePackagePerils(java.util.Map)
	 */
	@Override
	public void populatePackagePerils(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("populatePackagePerils", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getPackageIntmRate(java.util.Map)
	 */
	@Override
	public BigDecimal getPackageIntmRate(Map<String, Object> params)
			throws SQLException {
		BigDecimal intmRate;
		this.getSqlMapClient().update("getGipis085PackageIntmRate", params);
		
		intmRate = (BigDecimal) params.get("varRate");
		
		if (intmRate == null) {
			intmRate = new BigDecimal("0");
		}
		
		return intmRate;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#saveGipiWcommInvoice(java.util.List, java.util.List, java.util.List, java.util.List)
	 */
	@Override
	public void saveGipiWcommInvoice(
			List<GIPIWCommInvoice> setWcommInvoiceList,
			List<GIPIWCommInvoice> delWcommInvoiceList,
			List<GIPIWCommInvoicePeril> setWcommInvoicePerilList,
			List<GIPIWCommInvoicePeril> delWcommInvoicePerilList,
			String parId, String coinsurerSw)
			throws SQLException {
		try {
			List<GIPIWCommInvoice> setWcommInvoiceList2 = setWcommInvoiceList;
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			// insert/delete on order to avoid having error on foreign key constraints
			
			// delete GIPI_WCOMM_INV_PERILS
			
			this.getSqlMapClient().startBatch();
			this.deleteGipiWcommInvoicePeril(delWcommInvoicePerilList);
			this.getSqlMapClient().executeBatch();
			
			// delete GIPI_WCOMM_INVOICES
			
			this.getSqlMapClient().startBatch();
			this.deleteGipiWcommInvoice(delWcommInvoiceList);
			this.getSqlMapClient().executeBatch();
			System.out.println("di na tumuloy");
			// insert/update GIPI_WCOMM_INVOICES
			this.getSqlMapClient().startBatch();
			this.setGipiWcommInvoice(setWcommInvoiceList2);
			this.getSqlMapClient().executeBatch();
			
			// insert/update GIPI_WCOMM_INV_PERILS
			this.getSqlMapClient().startBatch();
			this.setGipiWcommInvoicePeril(setWcommInvoicePerilList);
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWCommInvoice x: setWcommInvoiceList2) {
				System.out.println("Test invoices::: "+x.getParentIntermediaryName()+"-"+x.getSpecialRate()+"-"+x.getLicTag());
			}
			// post-forms-commit
			if (setWcommInvoiceList != null) {
				for (GIPIWCommInvoice wcommInvoice : setWcommInvoiceList) {
					System.out.println("parent:"+ wcommInvoice.getParentIntermediaryNo());
					System.out.println("parent lictag: "+ wcommInvoice.getParentIntmLicTag());
					System.out.println("parent special rate: "+ wcommInvoice.getParentIntmSpecialRate());
					
					System.out.println("special rate: "+ wcommInvoice.getSpecialRate());
					System.out.println("lictag: "+ wcommInvoice.getLicTag());
					// modified condition - christian 08.25.2012
						//modified by d.alcantara, 12.04.2012, nasa procedure yung tamang conditions nito
					/*if("N".equals(wcommInvoice.getParentIntmLicTag()) && "Y".equals(wcommInvoice.getParentIntmSpecialRate())){*/
					//if("N".equals(wcommInvoice.getLicTag()) && "Y".equals(wcommInvoice.getSpecialRate())){
						System.out.println("post-form-commit: gipis085PopulateGipiWcommInvDtl");
						this.getSqlMapClient().startBatch();
						this.getSqlMapClient().update("gipis085PopulateGipiWcommInvDtl", wcommInvoice);
						this.getSqlMapClient().executeBatch();
					//}
					
					// added par status update,  irwin  - 7.19.2012;
					Map<String, Object> temp = new HashMap<String, Object>();
					temp.put("parId", wcommInvoice.getParId());
					temp.put("parStatus", "6");
					getSqlMapClient().update("updatePARStatus", temp);
				}
			}
			
			
			
			// key-del-rec
			// post-forms-commit
			if (delWcommInvoiceList != null) {
				for (GIPIWCommInvoice wcommInvoice : delWcommInvoiceList) {
					this.getSqlMapClient().startBatch();
					this.getSqlMapClient().delete("gipis085DeleteGipiWcommInvDtl", wcommInvoice);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			log.info("GIPIS085 records successfully saved!");
			
			//Apollo 10.02.2014
			this.getSqlMapClient().update("setDefaultCredBranch", parId); 
			this.getSqlMapClient().update("recomputeGIPIS085Amounts", parId);
			
			if("Y".equals(coinsurerSw)) {
				this.getSqlMapClient().delete("delAllRelatedCoInsRecs", Integer.parseInt(parId));
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	private void setGipiWcommInvoice(List<GIPIWCommInvoice> setWcommInvoiceList)
		throws SQLException {
		log.info("Saving GIPI_WCOMM_INVOICES records...");
		log.info("Par Id\tItem Group\tTakeup Seq No\tIntm No");
		log.info("=======================================================================================");
		
		if (setWcommInvoiceList != null) {
			for (GIPIWCommInvoice wcommInvoice: setWcommInvoiceList) {
				log.info(wcommInvoice.getParId()+"\t"+wcommInvoice.getItemGroup()+"\t"+wcommInvoice.getTakeupSeqNo()+"\t"+wcommInvoice.getIntermediaryNo()+"\t\t["+wcommInvoice.getSpecialRate());
				this.getSqlMapClient().insert("setWCommInvoice", wcommInvoice);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}
	
	private void deleteGipiWcommInvoice(List<GIPIWCommInvoice> delWcommInvoiceList)
		throws SQLException {
		log.info("Deleting GIPI_WCOMM_INVOICES records...");
		log.info("Par Id\tItem Group\tTakeup Seq No\tIntm No");
		log.info("=======================================================================================");
		
		if (delWcommInvoiceList != null) {
			for (GIPIWCommInvoice wcommInvoice: delWcommInvoiceList) {
				log.info(wcommInvoice.getParId()+"\t"+wcommInvoice.getItemGroup()+"\t"+wcommInvoice.getTakeupSeqNo()+"\t"+wcommInvoice.getIntermediaryNo());
				this.getSqlMapClient().insert("deleteWCommInvoice2", wcommInvoice);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully deleted!");
	}
	
	private void setGipiWcommInvoicePeril(List<GIPIWCommInvoicePeril> setWcommInvoicePerilList)
		throws SQLException {
		log.info("Saving GIPI_WCOMM_INV_PERIL records...");
		log.info("Par Id\tItem Group\tTakeup Seq No\tIntm No\tPeril Cd");
		log.info("=======================================================================================");
		
		if (setWcommInvoicePerilList != null) {
			for (GIPIWCommInvoicePeril wcommInvoicePeril: setWcommInvoicePerilList) {
				log.info(wcommInvoicePeril.getParId()+"\t"+wcommInvoicePeril.getItemGroup()+"\t"+wcommInvoicePeril.getTakeupSeqNo()+"\t"+wcommInvoicePeril.getIntermediaryIntmNo()+"\t"+wcommInvoicePeril.getPerilCd());
				this.getSqlMapClient().insert("saveWCommInvoicePeril", wcommInvoicePeril);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully saved!");
	}
	
	private void deleteGipiWcommInvoicePeril(List<GIPIWCommInvoicePeril> delWcommInvoicePerilList)
		throws SQLException {
		log.info("Deleting GIPI_WCOMM_INV_PERIL records...");
		log.info("Par Id\tItem Group\tTakeup Seq No\tIntm No\tPeril Cd");
		log.info("=======================================================================================");
		
		if (delWcommInvoicePerilList != null) {
			for (GIPIWCommInvoicePeril wcommInvoicePeril: delWcommInvoicePerilList) {
				log.info(wcommInvoicePeril.getParId()+"\t"+wcommInvoicePeril.getItemGroup()+"\t"+wcommInvoicePeril.getTakeupSeqNo()+"\t"+wcommInvoicePeril.getIntermediaryIntmNo()+"\t"+wcommInvoicePeril.getPerilCd());
				this.getSqlMapClient().insert("deleteWCommInvoicePeril", wcommInvoicePeril);
			}
		}
		
		log.info("=======================================================================================");
		log.info("Records successfully deleted!");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getPackParlistParams(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPackParlistParams(Integer packParId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPackParlistParams", packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#executeGIPIS160WhenNewFormInstance(java.util.Map)
	 */
	@Override
	public void executeGIPIS160WhenNewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("endtBondWCommInvoiceNewFormInstance", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCommInvoiceDAO#getWCommInvoiceTableGrid(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getWCommInvoiceTableGrid(
			Map<String, Object> params) throws SQLException {
		log.info("Getting comm invoice table grid records..");
		log.info("Par Id: " + params.get("parId"));
		log.info("Item Grp: " + params.get("itemGrp"));
		log.info("Takeup Seq No: " + params.get("takeupSeqNo"));
		
		return this.getSqlMapClient().queryForList("getWCommInvoiceListTableGrid", params);
	}

	@Override
	public void applySlidingCommission(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("applySlidingCommission: Getting Rate");
			this.getSqlMapClient().update("applySlidingCommission", params);
			
			this.getSqlMapClient().executeBatch();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info("SQL Error: " + e.getMessage());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getCommInvDfltIntms(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getCommInvDfltIntms", params);
	}
}
