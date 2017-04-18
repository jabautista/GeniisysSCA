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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIQuoteItemDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.gipi.entity.GIPIQuoteDeductiblesSummary;
import com.geniisys.gipi.entity.GIPIQuoteInvTax;
import com.geniisys.gipi.entity.GIPIQuoteInvoice;
import com.geniisys.gipi.entity.GIPIQuoteInvoiceSummary;
import com.geniisys.gipi.entity.GIPIQuoteItem;
import com.geniisys.gipi.entity.GIPIQuoteItemAC;
import com.geniisys.gipi.entity.GIPIQuoteItemAV;
import com.geniisys.gipi.entity.GIPIQuoteItemCA;
import com.geniisys.gipi.entity.GIPIQuoteItemEN;
import com.geniisys.gipi.entity.GIPIQuoteItemFI;
import com.geniisys.gipi.entity.GIPIQuoteItemMC;
import com.geniisys.gipi.entity.GIPIQuoteItemMH;
import com.geniisys.gipi.entity.GIPIQuoteItemMN;
import com.geniisys.gipi.entity.GIPIQuoteItemPeril;
import com.geniisys.gipi.entity.GIPIQuoteItemPerilSummary;
import com.geniisys.gipi.entity.GIPIQuoteMortgagee;
import com.geniisys.gipi.service.impl.GIPIQuoteInformationService;
import com.seer.framework.db.GenericDAOiBatis;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIQuoteItemDAOImpl.
 */
public class GIPIQuoteItemDAOImpl extends GenericDAOiBatis<GIPIQuoteItem> implements GIPIQuoteItemDAO {

	private static Logger log = Logger.getLogger(GIPIQuoteInformationService.class);
	
	private GIPIQuote gipiQuote;
	
	/**
	 * Instantiates a new gIPI quote item dao impl.
	 * 
	 * @param persistentClass the persistent class
	 */
	public GIPIQuoteItemDAOImpl(Class<GIPIQuoteItem> persistentClass) {
		super(persistentClass);
	}
	
	/**
	 * Instantiates a new gIPI quote item dao impl.
	 */
	public GIPIQuoteItemDAOImpl(){
		super(GIPIQuoteItem.class);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#getGIPIQuoteItemList(int)
	 */
	@Override
	@SuppressWarnings("unchecked")
		public List<GIPIQuoteItem> getGIPIQuoteItemList(int quoteId) throws SQLException {
		log.info("DAO calling getGIPIQuoteItemList Params:("+quoteId+")");
		return getSqlMapClient().queryForList("getGIPIQuoteItemList", quoteId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#getGIPIQuoteItemList(int, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIQuoteItem> getGIPIQuoteItemList(int quoteId, String lineCd) throws SQLException {
		log.info("DAO calling getGIPIQuoteItemList Params:("+quoteId+")");
		//return getSqlMapClient().queryForList("getGIPIQuoteItemList", quoteId);
		List<GIPIQuoteItem> gipiQuoteItemList = null;
		if(lineCd.equals("FI")){
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListFI", quoteId);
		}else if("AC".equals(lineCd) || "PA".equals(lineCd)){
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListAC", quoteId);
		}else if(lineCd.equals("CA") || lineCd.equals("LI")){//Added by Nica 04/27/2011  //added by steven 11/6/2012 -> "LI"
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListCA", quoteId);
		}else if(lineCd.equals("MH")) { //Added by Tonio 04/27/2011
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListMH", quoteId);
		}else if(lineCd.equals("AV")) { //Added by Emman 04/27/2011
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListAV", quoteId);
		}else if(lineCd.equals("EN")) { 
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListEN", quoteId);
		}else if(lineCd.equals("MN") || lineCd.equals("MR")){ //added by steven 11/6/2012 -> "MR"
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListMN", quoteId);
		}else if(lineCd.equals("MC")){
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemListMC", quoteId);
		}else if(lineCd.equals("SU")){
			gipiQuoteItemList = this.getSqlMapClient().queryForList("getGIPIQuoteItemList", quoteId);
		}

		return gipiQuoteItemList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#setGIPIQuoteItem(com.geniisys.gipi.entity.GIPIQuoteItem)
	 */
	@Override
	public void setGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException {
		log.info("DAO calling setGIPIQuoteItem Params:(quoteItem)");
		this.getSqlMapClient().insert("setGIPIQuoteItem", quoteItem);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#saveGIPIQuoteItem(com.geniisys.gipi.entity.GIPIQuoteItem)
	 */
	/**
	 * @deprecated
	 */
	@Override // whofeih
	public void saveGIPIQuoteItem(GIPIQuoteItem quoteItem) throws SQLException {
		log.info("DAO calling saveGIPIQuoteItem Params: quoteItem");
		this.getSqlMapClient().insert("saveGIPIQuoteItem", quoteItem);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#deleteGIPIQuoteAllItems(int)
	 */
	@Override
	public void deleteGIPIQuoteAllItems(int quoteId) throws SQLException {
		log.info("delete all GIPIQuoteItem");
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("quoteId", quoteId);
		this.getSqlMapClient().delete("deleteGIPIQuoteAllItems", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#updateQuoteItemPremAmt(int, int, java.math.BigDecimal)
	 */
	@Override
	public void updateQuoteItemPremAmt(int quoteId, int itemNo, BigDecimal premAmt) throws SQLException {
		log.info("update quote item premium amount ");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		params.put("premAmt", premAmt);
		this.getSqlMapClient().queryForList("updateQuoteItemPremAmt", params);
	}

	/*
	 * (non-Javadoc)
	 * - rencela Transaction
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#saveGIPIQuoteItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteItem(Map<String, Object> preparedParams)
			throws Exception {
		
		Map<String, Object> reuseableQueryParams = new HashMap<String, Object>(); // clear contents before using this map
		String[] 	deleteTags 		= (String[])  preparedParams.get("deleteTags");
		String[] 	itemNos			= (String[])  preparedParams.get("itemNos");
//		String[] 	currencyCodes 	= (String[])  preparedParams.get("currencyCodes");
//		String[] 	currencyRates 	= (String[])  preparedParams.get("currencyRates");
		String 		lineCd			= (String)    preparedParams.get("lineCd");
		int 	 	quoteId			= (Integer)   preparedParams.get("quoteId");
		log.info("Saving Quotation (quoteId=" + quoteId + ")");
		List<GIPIQuoteInvoice> invoiceListFromDB = null;
		List<GIPIQuoteItemMC> itemMCListFromDB = null; // added by: nica 10.08.2010
		GIPIQuote updatedGIPIQuote = (GIPIQuote)preparedParams.get("updatedGIPIQuote"); // contains he update tsiAmount, premAmt, annTsi, annPrem
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			reuseableQueryParams.clear();
			reuseableQueryParams.put("premAmt", updatedGIPIQuote.getPremAmt());
			System.out.println("premAmt: " + updatedGIPIQuote.getPremAmt());	System.out.println("annPremAmt: " + updatedGIPIQuote.getAnnPremAmt());
			System.out.println("tsiAmt: " + updatedGIPIQuote.getTsiAmt());		System.out.println("annTsiAmt: " + updatedGIPIQuote.getAnnTsiAmt());
			reuseableQueryParams.put("annPremAmt", updatedGIPIQuote.getAnnPremAmt());
			reuseableQueryParams.put("tsiAmt", updatedGIPIQuote.getTsiAmt());
			reuseableQueryParams.put("annTsiAmt", updatedGIPIQuote.getAnnTsiAmt());
			this.getSqlMapClient().update("updateQuoteAmts");
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			gipiQuote 	= (GIPIQuote) preparedParams.get("gipiQuote");
			
			// from database
			reuseableQueryParams.clear();
			reuseableQueryParams.put("quoteId", quoteId);
			reuseableQueryParams.put("issCd",	gipiQuote.getIssCd());
			
			invoiceListFromDB	= this.getSqlMapClient().queryForList("getInvoiceByQuoteId", reuseableQueryParams);
			
			{ 	List<GIPIQuoteInvTax> taxListForInvoice = null;
				int invoiceNumber = 0;
				if(invoiceListFromDB!=null){
					for(GIPIQuoteInvoice invSum: invoiceListFromDB){
						reuseableQueryParams.clear();
						invoiceNumber = invSum.getQuoteInvNo();
						reuseableQueryParams.put("quoteInvNo", invoiceNumber);
						reuseableQueryParams.put("lineCd", lineCd);
						reuseableQueryParams.put("issCd", gipiQuote.getIssCd());
						taxListForInvoice = (List<GIPIQuoteInvTax>)this.getSqlMapClient().queryForList("getGIPIQuoteInvTax", reuseableQueryParams);
						invSum.setInvoiceTaxes(taxListForInvoice);
					}
				}
			}
			
			List<GIPIQuoteItem> quoteItemListFromScreen = (List<GIPIQuoteItem>) preparedParams.get("quoteItemList");
			
			this.getSqlMapClient().executeBatch();

			//** DELETE ALL - START 
			this.getSqlMapClient().startBatch();
			
			reuseableQueryParams.clear();
			reuseableQueryParams.put("quoteId", quoteId);
			//log.info("Deleteing all deductibles of " + quoteId);
			//this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles", reuseableQueryParams);
				
			for (GIPIQuoteInvoice invoiceSummary :invoiceListFromDB) {
				reuseableQueryParams.clear();
				reuseableQueryParams.put("quoteId", quoteId);
				reuseableQueryParams.put("quoteInvNo", invoiceSummary.getQuoteInvNo());
			}
			
			reuseableQueryParams.clear();
			reuseableQueryParams.put("quoteId", quoteId);

			if(lineCd.equals("MC")){
				// added by: nica 10.08.2010
				itemMCListFromDB = this.getSqlMapClient().queryForList("getGIPIQuoteItemMCs", reuseableQueryParams);
				log.info("Deleting GIPIQuoteItemMCs...");
				this.getSqlMapClient().delete("deleteAllItemAddInfoMC", reuseableQueryParams);
			}
			this.getSqlMapClient().executeBatch();
			
			{	int itemNo = 0;
				this.getSqlMapClient().startBatch();
				for(GIPIQuoteItem aQuoteItemFromScreen :quoteItemListFromScreen){ // NOT WORKING
					itemNo = aQuoteItemFromScreen.getItemNo();
					reuseableQueryParams.clear();
					reuseableQueryParams.put("quoteId", quoteId);
					reuseableQueryParams.put("itemNo", itemNo);
					this.getSqlMapClient().delete("deleteAllGIPIQuoteMortgagee", reuseableQueryParams);
					this.getSqlMapClient().delete("deleteGIPIQuoteItemAllPerils", reuseableQueryParams);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().startBatch();
			this.deleteGIPIQuoteAllItems(quoteId);
			this.getSqlMapClient().executeBatch();
			// END OF DELETE 

			if(itemNos != null){
				List<GIPIQuoteDeductiblesSummary> deductiblesFromItem = null;
				List<GIPIQuoteItemPeril> itemPerilForItem = null;
				List<GIPIQuoteMortgagee> mortgageesForItem = null;
				Object additionalInformationForItem = null;
				int itemNo = 0;
				
				for(GIPIQuoteItem aQuoteItemFromScreen :quoteItemListFromScreen){
					itemNo = aQuoteItemFromScreen.getItemNo();

					if(!willDelete(itemNos, deleteTags, itemNo)){
						this.getSqlMapClient().startBatch();
						this.getSqlMapClient().insert("saveGIPIQuoteItem", aQuoteItemFromScreen);
						this.getSqlMapClient().executeBatch();

						this.getSqlMapClient().startBatch();
						itemPerilForItem = (List<GIPIQuoteItemPeril>) preparedParams.get("perilList" + aQuoteItemFromScreen.getItemNo());
						if(itemPerilForItem!=null){
							if(itemPerilForItem.size()>0){
								for(GIPIQuoteItemPeril per: itemPerilForItem){
									log.info("DAO - Peril has Warranty? " + per.getTarfCd());
									if(per.getTarfCd().equals("Y")) {
										this.getSqlMapClient().startBatch();
										Map<String, Object> wc = new HashMap<String, Object>();
										wc.put("quoteId", quoteId);
										wc.put("lineCd", lineCd);
										wc.put("perilCd", per.getPerilCd());
										this.getSqlMapClient().update("attachWarranty", wc);
										this.getSqlMapClient().executeBatch();
										log.info("DAO - Warranties for " + per.getPerilCd() + " attached...");
									}
									per.setTarfCd(null);
									log.info("Inserting peril for itemNo " + itemNo);
									per.setLineCd(lineCd);
									this.getSqlMapClient().insert("saveGIPIQuoteItemPeril", per);
								}
							}
						}
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().startBatch();
						additionalInformationForItem = preparedParams.get("additionalInformation" + itemNo);
						if(additionalInformationForItem != null){
							log.info("Inserting additional information for lineCd = " + lineCd);
							if(lineCd.equals("AH")){
								GIPIQuoteItemAC ac = (GIPIQuoteItemAC) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemAC", ac);
							}else if(lineCd.equals("AV")){
								GIPIQuoteItemAV av = (GIPIQuoteItemAV) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemAV", av);
							}else if(lineCd.equals("CA")){
								GIPIQuoteItemCA ca = (GIPIQuoteItemCA) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemCA", ca);
							}else if(lineCd.equals("EN")){
								GIPIQuoteItemEN en = (GIPIQuoteItemEN) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemEN", en);
							}else if(lineCd.equals("FI")){
								GIPIQuoteItemFI fi = (GIPIQuoteItemFI) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemFI", fi);
							}else if(lineCd.equals("MH")){
								GIPIQuoteItemMH mh = (GIPIQuoteItemMH) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemMH", mh);
							}else if(lineCd.equals("MN")){
								GIPIQuoteItemMN mn = (GIPIQuoteItemMN) additionalInformationForItem;
								this.getSqlMapClient().insert("saveGIPIQuoteItemMN", mn);
							}/*else if(lineCd.equals("MC")){
								GIPIQuoteItemMC mc = (GIPIQuoteItemMC) additionalInformationForItem;
								log.info("Saving changes of MC item - Quote ID: " + mc.getQuoteId() +" itemNo: "+ mc.getItemNo());
								this.getSqlMapClient().insert("saveGIPIQuoteItemMC", mc);
								System.out.println("here test");
							} commented by: nica 10.12.2010*/
						}
						
						this.getSqlMapClient().startBatch();
						mortgageesForItem = (List<GIPIQuoteMortgagee>) preparedParams.get("mortgageeList" + aQuoteItemFromScreen.getItemNo());
						if(mortgageesForItem!=null){ 
							if(mortgageesForItem.size()>0){
								for(GIPIQuoteMortgagee mort: mortgageesForItem){
									log.info("Inserting mortgagees for itemNo: " + itemNo);
									this.getSqlMapClient().insert("saveGIPIQuoteMortgagee", mort);
								}
							}
						}
						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().startBatch();
						List<GIPIQuoteDeductibles> rmDeductibles = (List<GIPIQuoteDeductibles>) preparedParams.get("rmDeductibles" + itemNo);
						
						if(rmDeductibles != null) {
							log.info(rmDeductibles.size() + " Deductible records based on TSI to be deleted...");
							for(GIPIQuoteDeductibles d: rmDeductibles) {
								log.info("Deleting deductible for Item " + d.getItemNo());
								this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles2", d);
							}
						}

						this.getSqlMapClient().executeBatch();
						
						this.getSqlMapClient().startBatch();
						deductiblesFromItem = (List<GIPIQuoteDeductiblesSummary>) preparedParams.get("deductibleList" + itemNo);
						rmDeductibles = (List<GIPIQuoteDeductibles>) preparedParams.get("rmDeductibles" + itemNo);
						log.info("Saving Deductibles for Item# " + itemNo + ", number of items - " + deductiblesFromItem.size());
						if(deductiblesFromItem!=null){
							if(deductiblesFromItem.size()>0){
								for(GIPIQuoteDeductiblesSummary deds: deductiblesFromItem){
									if(rmDeductibles != null && rmDeductibles.size() > 0) {
										for(GIPIQuoteDeductibles d: rmDeductibles) {
											if(d.getQuoteId() == deds.getQuoteId() && 
											   d.getItemNo() == deds.getItemNo() &&
											   d.getPerilCd() == deds.getPerilCd()) {
												log.info("No deductibles added due to adding peril in " + itemNo);
											}else{
												log.info("Inserting deductibles for itemNo = " + itemNo);
												this.getSqlMapClient().insert("saveGIPIQuoteDeductibles",deds.toGIPIQuoteDeductible());
											}
										}
									}else{
										log.info("Inserting deductibles for itemNo = " + itemNo);
										this.getSqlMapClient().insert("saveGIPIQuoteDeductibles",deds.toGIPIQuoteDeductible());
									}
								}
							}
						}
						this.getSqlMapClient().executeBatch();
					}else{
						this.getSqlMapClient().startBatch();
						this.deleteAdditionalInformation(lineCd, quoteId, itemNo);					// other information have been pre-deleted
						this.getSqlMapClient().executeBatch();
					}
				} // - end of forEach-loop
				
				 // separate handling for additional information in Motor Car line -- nica 10.12.2010
				if(lineCd.equals("MC")){
					this.getSqlMapClient().startBatch();
					if(itemMCListFromDB.size() >0){
						for(GIPIQuoteItemMC motorCar : itemMCListFromDB){
							if(!willDelete(itemNos, deleteTags, motorCar.getItemNo())){
								this.getSqlMapClient().insert("saveGIPIQuoteItemMC", motorCar);
							}
						}
					}
					this.getSqlMapClient().executeBatch();
					
					this.getSqlMapClient().startBatch();
					for(GIPIQuoteItem itemMC : quoteItemListFromScreen){
						if(!willDelete(itemNos, deleteTags, itemMC.getItemNo())){
							additionalInformationForItem = preparedParams.get("additionalInformation" + itemMC.getItemNo());
							if(additionalInformationForItem != null){
								GIPIQuoteItemMC mc = (GIPIQuoteItemMC) additionalInformationForItem;
								log.info("Saving changes of MC item - Quote ID: " + mc.getQuoteId() +" itemNo: "+ mc.getItemNo());
								this.getSqlMapClient().insert("saveGIPIQuoteItemMC", mc);
							}
						}
					}
					this.getSqlMapClient().executeBatch();
				}
				
				List<GIPIQuoteInvoice> setInvoiceRows = (List<GIPIQuoteInvoice>) preparedParams.get("setInvoiceRows");
				List<GIPIQuoteInvoice> delInvoiceRows = (List<GIPIQuoteInvoice>) preparedParams.get("delInvoiceRows");
				this.getSqlMapClient().startBatch();  // separate handling for invoice
					if(delInvoiceRows!=null)
					for(GIPIQuoteInvoice inv: delInvoiceRows){
						reuseableQueryParams.clear();
						reuseableQueryParams.put("quoteId", inv.getQuoteId());
						reuseableQueryParams.put("quoteInvNo", inv.getQuoteInvNo());
						log.info("Deleting invoice (invoiceNumber=" + inv.getQuoteInvNo() +")");
						this.getSqlMapClient().delete("deleteGIPIQuoteInvoice", reuseableQueryParams);
					}
				this.getSqlMapClient().executeBatch();
				
				if(setInvoiceRows!=null){
					for(GIPIQuoteInvoice inv: setInvoiceRows){
						System.out.println("XXX...reinserting invoice rows...");
						if(inv.getIssCd()==null || inv.getIssCd().isEmpty()){
							inv.setIssCd(gipiQuote.getIssCd());
						}
						this.reinsertInvoice(inv.toGIPIQuoteInvoiceSummary(),lineCd);
					}
				}
			}
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#saveGIPIQuoteItemJSON(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteItemJSON(Map<String, Object> listParams)
			throws Exception {
		log.info("save GIPIQuoteItem JSON");
		Map<String,Object> params = new HashMap<String, Object>();
		
		try{
			List<GIPIQuoteItem> setItemRows = (List<GIPIQuoteItem>) listParams.get("setItemRows");
			System.out.println("setItemRows length: " + setItemRows.size());
			List<GIPIQuoteItem> delItemRows = (List<GIPIQuoteItem>) listParams.get("delItemRows");
			System.out.println("delItemRows length: " + delItemRows.size());
			List<GIPIQuoteItemPerilSummary> setPerilRows = (List<GIPIQuoteItemPerilSummary>) listParams.get("setPerilRows");
			System.out.println("setPerilRows length: " + setPerilRows.size());
			List<GIPIQuoteItemPerilSummary> delPerilRows = (List<GIPIQuoteItemPerilSummary>) listParams.get("delPerilRows");
			System.out.println("delPerilRows length: " + delPerilRows.size());
			List<GIPIQuoteDeductiblesSummary> setDeductibleRows = (List<GIPIQuoteDeductiblesSummary>) listParams.get("setDeductibleRows");
			System.out.println("setDeductibleRows length: " + setDeductibleRows.size());
			List<GIPIQuoteDeductiblesSummary> delDeductibleRows = (List<GIPIQuoteDeductiblesSummary>) listParams.get("delDeductibleRows");
			System.out.println("delDeductibleRows length: " + delDeductibleRows.size());
			List<GIPIQuoteMortgagee> setMortgageeRows = (List<GIPIQuoteMortgagee>) listParams.get("setMortgageeRows");
			System.out.println("setMortgageeRows length: " + setMortgageeRows.size());
			List<GIPIQuoteMortgagee> delMortgageeRows = (List<GIPIQuoteMortgagee>) listParams.get("delMortgageeRows");
			System.out.println("delMortgageeRows length: " + delMortgageeRows.size());
			List<GIPIQuoteInvoice> setInvoiceRows = (List<GIPIQuoteInvoice>) listParams.get("setInvoiceRows");
			System.out.println("setInvoiceRows length: " + setInvoiceRows.size());
			List<GIPIQuoteInvoice> delInvoiceRows = (List<GIPIQuoteInvoice>) listParams.get("delInvoiceRows");
			System.out.println("delInvoiceRows length: " + delInvoiceRows.size());
			
			
			GIPIQuote gipiQuote = (GIPIQuote) listParams.get("gipiQuote");
			if(gipiQuote==null){
				System.out.println("NULL PA RIN");
			}
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
//			  - Gipi_Quote_Dtls.del_gipi_quote_dtls(#quoteId#,#itemNo#,#perilCd#);
			 
			//processAdditionalInformation(listParams); 
			//angelo 05.03.2011 separated function for insertion and deletion para di magka-conflict sa MC line
			delAdditionalInformation(listParams.get("delAIRows"), (String) listParams.get("lineCd"));
			
			for(GIPIQuoteMortgagee mortgagee: delMortgageeRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", mortgagee.getQuoteId());
				params.put("issCd", mortgagee.getIssCd());
				params.put("itemNo", mortgagee.getItemNo());
				params.put("mortgCd", mortgagee.getMortgCd());
				this.getSqlMapClient().delete("deleteGIPIQuoteMortgagee",params);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteDeductiblesSummary deductible : delDeductibleRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles3", deductible.toGIPIQuoteDeductible());
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItemPerilSummary summa: delPerilRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", summa.getQuoteId());
				params.put("itemNo", summa.getItemNo());
				params.put("perilCd", summa.getPerilCd());
				this.getSqlMapClient().delete("delGIPIQuoteItemPeril", params);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItem item: delItemRows){ //********************************************************************************************** 
				//#editing
				params.clear();
				params.put("quoteId", item.getQuoteId());
				params.put("itemNo", item.getItemNo());
				params.put("issCd", gipiQuote.getIssCd());
				params.put("lineCd", gipiQuote.getLineCd());
				
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().delete("delPerilsOfQuoteItem", params);
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().startBatch();
//				this.delGIPIQuoteItem(item.getQuoteId(), item.getItemNo());
				this.delGIPIQuoteItem(params);
//				this.getSqlMapClient().delete("delGIPIQuoteItem", params);
				// delete dependent subinfo first
				this.getSqlMapClient().executeBatch();
			}									//**********************************************************************************************
			
			String lineCd = (String)listParams.get("lineCd");
			for(GIPIQuoteInvoice inv: setInvoiceRows){
				this.reinsertInvoice(inv.toGIPIQuoteInvoiceSummary(), lineCd);
			}
			
			for(GIPIQuoteItem item: setItemRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteItem", item);
				this.getSqlMapClient().executeBatch();
			}
						
			for(GIPIQuoteItemPerilSummary summa: setPerilRows){
				this.getSqlMapClient().startBatch();
				
				this.getSqlMapClient().insert("saveGIPIQuoteItemPeril", summa.toGipiItemPeril());
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteMortgagee mortgagee: setMortgageeRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteMortgagee", mortgagee);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteDeductiblesSummary deductible : setDeductibleRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteDeductibles", deductible.toGIPIQuoteDeductible());
				this.getSqlMapClient().executeBatch();
			}
			
			/*	
			for(GIPIQuoteItemMH item: setItemRowsMH){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteItemMH", item);
				this.getSqlMapClient().executeBatch();
			}*/
			
			//this.getSqlMapClient().endTransaction();
			//additional information
			insertAdditionalInformation(listParams.get("setAIRows"), (String) listParams.get("lineCd"));
			
			if(delItemRows.size()!=0){ // if items have been deleted, trigger delete of invoices
				
			}
			if(gipiQuote != null){// unecessary validation
				System.out.println("#################################################################################");
				params.clear();
				params.put("quoteId", gipiQuote.getQuoteId());
				params.put("issCd", gipiQuote.getIssCd());
				System.out.println("gipiQuote.getQuoteId() = " + gipiQuote.getQuoteId() + ":: gipiQuote.getLineCd() = " + gipiQuote.getLineCd());
				List<GIPIQuoteInvoice> remainingInvoice = (List<GIPIQuoteInvoice>)this.getSqlMapClient().queryForList("getGIPIQuoteInvoicesWithInvTax", params);
				System.out.println("remaining invoice length: " + remainingInvoice.size());
				for(GIPIQuoteInvoice inv: remainingInvoice){
					if(this.willDeleteInvoice(gipiQuote.getQuoteId(), lineCd, inv)){
						System.out.println("invoice shalt be delethed~");
					}else{
						System.out.println("thou shalt not delethe thy invoice");
					}
				}
				System.out.println("#################################################################################");
			}else{
				System.out.println("gipiQuote is NULL");
			}
			//#################################################################################
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * Add / Delete Additional Information
	 * @param listParams
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	private void processAdditionalInformation(Map<String, Object> listParams)throws SQLException{
		log.info("process additional information");
		String lineCd = (String)listParams.get("lineCd");
		Map<String, Object> params = new HashMap<String, Object>();
		Object setAIRows = listParams.get("setAIRows");
		Object delAIRows = listParams.get("delItemRows");

		log.info("processAdditionalInformation - lineCd = " + lineCd);
		if("AC".equals(lineCd) || "PA".equals(lineCd)){
			List<GIPIQuoteItemAC> setList = (List<GIPIQuoteItemAC>) listParams.get("setAIRows");
			List<GIPIQuoteItemAC> delList = (List<GIPIQuoteItemAC>) listParams.get("delAIRows");
			for(GIPIQuoteItemAC ac: delList){
				params.clear();
				params.put("quoteId", ac.getQuoteId());
				params.put("itemNo", ac.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemAC", params);
			}
			for(GIPIQuoteItemAC ac: setList){
				System.out.println("Saving: "+ ac.getItemNo() +" / "+ac.getNoOfPerson());
				this.getSqlMapClient().insert("saveGIPIQuoteItemAC", ac);
			}
		}else if("AV".equals(lineCd)){
			List<GIPIQuoteItemAV> setList = (List<GIPIQuoteItemAV>) setAIRows;
			List<GIPIQuoteItem> delList = (List<GIPIQuoteItem>) delAIRows;
			for(GIPIQuoteItem av: delList){
				params.clear();
				params.put("quoteId", av.getQuoteId());
				params.put("itemNo", av.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemAV", params);
			}
			for(GIPIQuoteItemAV av: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteItemAV", av);
			}
		}else if("CA".equals(lineCd)){
			List<GIPIQuoteItemCA> setList = (List<GIPIQuoteItemCA>) listParams.get("setAIRows");
			List<GIPIQuoteItemCA> delList = (List<GIPIQuoteItemCA>) listParams.get("delAIRows");
			for(GIPIQuoteItemCA ca: delList){
				params.clear();
				params.put("quoteId", ca.getQuoteId());
				params.put("itemNo", ca.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemCA", params);
			}
			for(GIPIQuoteItemCA ca: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteItemCA", ca);
			}
		}else if("EN".equals(lineCd)){
			List<GIPIQuoteItemEN> setList = (List<GIPIQuoteItemEN>) setAIRows;
			List<GIPIQuoteItemEN> delList = (List<GIPIQuoteItemEN>) listParams.get("delAIRows");
			for(GIPIQuoteItemEN en: delList){
				params.clear();
				params.put("quoteId", en.getQuoteId());
				params.put("engBasicInfoNum", en.getEnggBasicInfoNum());
				params.put("itemNo", en.getEnggBasicInfoNum());
				//params.put("itemNo", en.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemEN", params);
			}
			for(GIPIQuoteItemEN en: setList){
				if(en.getQuoteId()!=null) {
					this.getSqlMapClient().insert("saveGIPIQuoteItemEN", en);
				}
			}
		}else if("FI".equals(lineCd)){//***
			List<GIPIQuoteItemFI> setList = (List<GIPIQuoteItemFI>) setAIRows;
			List<GIPIQuoteItem> delList = (List<GIPIQuoteItem>) delAIRows;
			for(GIPIQuoteItem fi: delList){
				params.clear();
				params.put("quoteId", fi.getQuoteId());
				params.put("itemNo", fi.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemFI", params);
			}
			for(GIPIQuoteItemFI fi: setList){
				System.out.println("test :\n" + fi.getDateFrom() + "\n" + fi.getDateTo());
				fi.showAllValuesInConsole();
				this.getSqlMapClient().insert("saveGIPIQuoteItemFI", fi);
			}
		}else if("MN".equals(lineCd)){
			List<GIPIQuoteItemMN> setList = (List<GIPIQuoteItemMN>) setAIRows;
			List<GIPIQuoteItem> delList = (List<GIPIQuoteItem>) delAIRows;
			for(GIPIQuoteItem mn: delList){
				params.clear();
				params.put("quoteId", mn.getQuoteId());
//				params.put("engBasicInfoNum", en.getEnggBasicInfoNum());
				params.put("itemNo", mn.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMN", params);
			}
			for(GIPIQuoteItemMN mn: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteItemMN", mn);
			}
		}else if("MH".equals(lineCd)){
			List<GIPIQuoteItemMH> setList = (List<GIPIQuoteItemMH>) listParams.get("setAIRows");
			List<GIPIQuoteItemMH> delList = (List<GIPIQuoteItemMH>) listParams.get("delAIRows");
			for(GIPIQuoteItemMH mh: delList){
				params.clear();
				params.put("quoteId", mh.getQuoteId());
				params.put("itemNo", mh.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMH", params);
			}
			for(GIPIQuoteItemMH mh: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteItemMH", mh);
			}			
		}else if("MC".equals(lineCd)){
			List<GIPIQuoteItemMC> setList = (List<GIPIQuoteItemMC>) setAIRows;
			List<GIPIQuoteItemMC> delList = (List<GIPIQuoteItemMC>) listParams.get("delAIRows");
			for(GIPIQuoteItemMC mc: delList){
				params.clear();
				params.put("quoteId", mc.getQuoteId());
				params.put("itemNo", mc.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMC", params);
			}
			for(GIPIQuoteItemMC mc: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteItemMC", mc);
			}
		}
	}
	
	/**
	 * Reinsert invoices derived from prepared params one by one
	 * @param invoice
	 * @throws SQLException
	 */
	private void reinsertInvoice(GIPIQuoteInvoiceSummary invoice, String lineCd) throws SQLException{
		log.info("Reinserting invoice...");
		Map<String, Object> params = new HashMap<String, Object>();
		this.getSqlMapClient().startBatch();
		
		params.put("quoteId", 	invoice.getQuoteId());		params.put("quoteInvNo",invoice.getQuoteInvNo());
		params.put("currencyCd",invoice.getCurrencyCd());	params.put("currencyRt",invoice.getCurrencyRt());
		params.put("premAmt", 	invoice.getPremAmt());		params.put("intmNo",	invoice.getIntmNo());
		params.put("taxAmt", 	invoice.getTaxAmt());		params.put("issCd", 	invoice.getIssCd());
		
		this.getSqlMapClient().update("saveGIPIQuoteInvoice2",params);
		
		Integer invoiceNumber = null;
		
		try{
			invoiceNumber = Integer.parseInt(params.get("quoteInvNo").toString());
			log.info("Invoice number of newly added invoice = " + invoiceNumber);
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().startBatch();
		params.clear();
		params.put("quoteId",		invoice.getQuoteId());		params.put("currencyCd",invoice.getCurrencyCd());
		params.put("currencyRate",	invoice.getCurrencyRt());	params.put("issCd",	 	invoice.getIssCd());
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().startBatch();
//		invoice saving successful only when invtax is not included...
		if(invoice.getInvoiceTaxes()!=null && invoiceNumber != null){
			for(GIPIQuoteInvTax invTax: invoice.getInvoiceTaxes()){
				invTax.setQuoteInvNo(invoiceNumber);
				if(invTax.getRecordStatus() == GIPIQuoteInvTax.DELETE_OBJECT){
					params.clear();
					params.put("quoteInvNo", invoiceNumber);
					params.put("issCd", invTax.getIssCd());
					params.put("taxCd", invTax.getTaxCd());
					this.getSqlMapClient().delete("deleteInvTax", params);
				}else{
					log.info("Saving invoice tax of invoiceNumber " + invoiceNumber + "... taxCode = " + invTax.getTaxCd() + "|| amt = " + invTax.getTaxAmt());
					this.getSqlMapClient().insert("saveGIPIQuoteInvTax",invTax);
				}
			}
		}
		this.getSqlMapClient().executeBatch();
	}
	
	/**
	 * Deletes additional information
	 * @param lineCd
	 * @param quoteId
	 * @param itemNo
	 * @throws SQLException
	 */
	private void deleteAdditionalInformation(String lineCd, Integer quoteId, Integer itemNo)throws SQLException{
		System.out.println("DELETING ADDITIONAL INFORMATION--------------------------");
		log.info("DELETE - Additional Information (lineCd=" + lineCd + ",quoteId=" + quoteId +",itemNo="+ itemNo +")");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		
		if(lineCd.equals("AH")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemAC", params);
		}else if(lineCd.equals("AV")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemAV", params);
		}else if(lineCd.equals("CA")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemCA", params);
		}else if(lineCd.equals("EN")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemEN", params);
		}else if(lineCd.equals("FI")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemFI", params);
		}else if(lineCd.equals("MH")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMH", params);
		}else if(lineCd.equals("MN")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMN", params);
		}else if(lineCd.equals("MC")){
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMC", params);
		}
	}
	
	// delete-checking methods
	/**
	 * Check if targetItem parameter has been deleted 
	 * -  use when itemNos != null
	 * @param itemNos
	 * @param deleteTags
	 * @param targetItem
	 * @return
	 */
	private boolean willDelete(String[] itemNos, String[] deleteTags, int targetItem){
		for(int i=0; i<itemNos.length; i++){
			if(Integer.parseInt(itemNos[i]) == targetItem){
				if(deleteTags[i].equals("Y")){
					return true;
				}
				break;
			}
		}
		return false;
	}
	
	/**
	 * Checks if :invoice will be deleted by checking the currency codes and rates
	 * of the existing items in GIPI_Quote_Item
	 * @param quoteId
	 * @param lineCd
	 * @author rencela
	 * @throws SQLException
	 * @return true - if invoice should be deleted
	 */
	private boolean willDeleteInvoice(Integer quoteId, String lineCd, GIPIQuoteInvoice invoice) throws SQLException{
		log.info("will delete invoice -  checking");
		List<GIPIQuoteItem> it = this.getGIPIQuoteItemList(quoteId, lineCd);
		boolean willDelete = true;
		if(it.size()==0){
			for(GIPIQuoteItem item: it){ // check if a related item
				if(item.getCurrencyCd() == invoice.getCurrencyCd() && 
						item.getCurrencyRate() == invoice.getCurrencyRt()){
					willDelete = false;
				}
			}
		}
		return willDelete;
	}
	
	/**
	 * 
	 * @param setRows
	 * @param lineCd
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	private void insertAdditionalInformation(Object setRows, String lineCd) throws SQLException{
		log.info("insert additional information...");
		if("AC".equals(lineCd) || "PA".equals(lineCd)){
			List<GIPIQuoteItemAC> setList = (List<GIPIQuoteItemAC>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR ACCIDENT LINE...");
			for(GIPIQuoteItemAC ac: setList){
				System.out.println(ac.getItemNo() + " - " + ac.getNoOfPerson());
				this.getSqlMapClient().insert("saveGIPIQuoteItemAC", ac);
			}
		}else if("AV".equals(lineCd)){
			List<GIPIQuoteItemAV> setList = (List<GIPIQuoteItemAV>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR AVIATION LINE...");
			for(GIPIQuoteItemAV av: setList){
				System.out.println(av.getItemNo() + " - " + av.getVesselCd());
				this.getSqlMapClient().insert("saveGIPIQuoteItemAV", av);
			}
		}else if("CA".equals(lineCd)){
			List<GIPIQuoteItemCA> setList = (List<GIPIQuoteItemCA>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR CASUALTY LINE...");
			for(GIPIQuoteItemCA ca: setList){
				System.out.println(ca.getItemNo() + " - " + ca.getLocation());
				this.getSqlMapClient().insert("saveGIPIQuoteItemCA", ca);
			}
		}else if("EN".equals(lineCd)){
			List<GIPIQuoteItemEN> setList = (List<GIPIQuoteItemEN>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR ENGINEERING LINE...");
			for(GIPIQuoteItemEN en: setList){
				System.out.println(en.getGipiQuoteItemEN() + " - " + en.getContractProjBussTitle());
				if(en.getQuoteId()!=null) {
					this.getSqlMapClient().insert("saveGIPIQuoteItemEN", en);
				}
			}
		}else if("FI".equals(lineCd)){
			List<GIPIQuoteItemFI> setList = (List<GIPIQuoteItemFI>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR FIRE LINE...");
			for(GIPIQuoteItemFI fi: setList){
				System.out.println(fi.getItemNo() + " - " + fi.getAssignee());
				fi.showAllValuesInConsole();
				this.getSqlMapClient().insert("saveGIPIQuoteItemFI", fi);
			}
		}else if("MN".equals(lineCd)){
			List<GIPIQuoteItemMN> setList = (List<GIPIQuoteItemMN>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MARINE CARGO LINE...");
			for(GIPIQuoteItemMN mn: setList){
				System.out.println(mn.getItemNo() + " - " + mn.getGeogCd());
				this.getSqlMapClient().insert("saveGIPIQuoteItemMN", mn);
			}
		}else if("MH".equals(lineCd)){
			List<GIPIQuoteItemMH> setList = (List<GIPIQuoteItemMH>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MARINE HULL LINE...");
			for(GIPIQuoteItemMH mh: setList){
				System.out.println(mh.getItemNo() + " - " + mh.getVesselCd());
				this.getSqlMapClient().insert("saveGIPIQuoteItemMH", mh);
			}			
		}else if("MC".equals(lineCd)){
			List<GIPIQuoteItemMC> setList = (List<GIPIQuoteItemMC>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MOTOR CAR LINE...");
			for(GIPIQuoteItemMC mc: setList){
				System.out.println(mc.getItemNo() + " - " + mc.getMotorNo());
				this.getSqlMapClient().insert("saveGIPIQuoteItemMC", mc);
			}
		}
	}
	
	/**
	 * 
	 * @param delRows
	 * @param lineCd
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	private void delAdditionalInformation(Object delRows, String lineCd) throws SQLException {
		log.info("delete additional information");
		Map<String, Object> delParams = new HashMap<String, Object>();
		if("AC".equals(lineCd) || "PA".equals(lineCd)){
			log.info("DELETING ACCIDENT ADDITIONAL INFO");
			List<GIPIQuoteItemAC> delList = (List<GIPIQuoteItemAC>) delRows;
			for(GIPIQuoteItemAC ac: delList){
				System.out.println(ac.getItemNo() + " - " + ac.getNoOfPerson());
				delParams.clear();
				delParams.put("quoteId", ac.getQuoteId());
				delParams.put("itemNo", ac.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemAC", delParams);
			}
		}else if("AV".equals(lineCd)){
			log.info("DELETING AVIATION ADDITIONAL INFO");
			List<GIPIQuoteItemAV> delList = (List<GIPIQuoteItemAV>) delRows;
			for(GIPIQuoteItemAV av: delList){
				System.out.println(av.getItemNo() + " - " + av.getVesselCd());
				delParams.clear();
				delParams.put("quoteId", av.getQuoteId());
				delParams.put("itemNo", av.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemAV", delParams);
			}
		}else if("CA".equals(lineCd)){
			log.info("DELETING CASUALTY ADDITIONAL INFO");
			List<GIPIQuoteItemCA> delList = (List<GIPIQuoteItemCA>) delRows;
			for(GIPIQuoteItemCA ca: delList){
				System.out.println(ca.getItemNo() + " - " + ca.getLocation());
				delParams.clear();
				delParams.put("quoteId", ca.getQuoteId());
				delParams.put("itemNo", ca.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemCA", delParams);
			}
		}else if("EN".equals(lineCd)){
			log.info("DELETING ENGINEERING ADDITIONAL INFO");
			List<GIPIQuoteItemEN> delList = (List<GIPIQuoteItemEN>) delRows;
			for(GIPIQuoteItemEN en: delList){
				System.out.println(en.getGipiQuoteItemEN() + " - " + en.getContractProjBussTitle());
				delParams.clear();
				delParams.put("quoteId", en.getQuoteId());
				delParams.put("engBasicInfoNum", en.getEnggBasicInfoNum());
				delParams.put("itemNo", en.getEnggBasicInfoNum());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemEN", delParams);
			}
		}else if("FI".equals(lineCd)){
			log.info("DELETING FIRE ADDITIONAL INFO");
			List<GIPIQuoteItemFI> delList = (List<GIPIQuoteItemFI>) delRows;
			for(GIPIQuoteItemFI fi: delList){
				System.out.println(fi.getItemNo() + " - " + fi.getAssignee());
				delParams.clear();
				delParams.put("quoteId", fi.getQuoteId());
				delParams.put("itemNo", fi.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemFI", delParams);
			}
		}else if("MN".equals(lineCd)){
			log.info("DELETING MARINE CARGO ADDITIONAL INFO");
			List<GIPIQuoteItemMN> delList = (List<GIPIQuoteItemMN>) delRows;
			for(GIPIQuoteItemMN mn: delList){
				System.out.println(mn.getItemNo() + " - " + mn.getGeogCd());
				delParams.clear();
				delParams.put("quoteId", mn.getQuoteId());
				delParams.put("itemNo", mn.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMN", delParams);
			}
		}else if("MH".equals(lineCd)){
			log.info("DELETING MARINE HULL ADDITIONAL INFO");
			List<GIPIQuoteItemMH> delList = (List<GIPIQuoteItemMH>) delRows;
			for(GIPIQuoteItemMH mh: delList){
				System.out.println(mh.getItemNo() + " - " + mh.getVesselCd());
				delParams.clear();
				delParams.put("quoteId", mh.getQuoteId());
				delParams.put("itemNo", mh.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMH", delParams);
			}			
		}else if("MC".equals(lineCd)){
			log.info("DELETING MOTOR CAR ADDITIONAL INFO");
			List<GIPIQuoteItemMC> delList = (List<GIPIQuoteItemMC>) delRows;
			for(GIPIQuoteItemMC mc: delList){
				System.out.println(mc.getItemNo() + " - " + mc.getMotorNo());
				delParams.clear();
				delParams.put("quoteId", mc.getQuoteId());
				delParams.put("itemNo", mc.getItemNo());
				this.getSqlMapClient().delete("deleteGIPIQuoteItemMC", delParams);
			}
		}
	}

	/**
	 * 
	 * @param packQuoteId
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteItem> getGIPIQuoteItemListForPack(Integer packQuoteId)
			throws SQLException {
		List<GIPIQuote> packQuoteList = this.getSqlMapClient().queryForList("getGipiPackQuoteList", packQuoteId);
		List<GIPIQuoteItem> packQuoteItemList = new ArrayList<GIPIQuoteItem>();
		
		for(GIPIQuote quote : packQuoteList){
			String lineCd = !quote.getMenuLineCd().equals("*") ? quote.getMenuLineCd() : quote.getLineCd();
			List<GIPIQuoteItem> quoteItems = new ArrayList<GIPIQuoteItem>();
			
			if(lineCd.equals("EN")){
				quoteItems = this.getSqlMapClient().queryForList("getGIPIQuoteItemListEN2", quote.getQuoteId());	
			}else{
				quoteItems = this.getGIPIQuoteItemList(quote.getQuoteId(), lineCd);
			}
			
			for(GIPIQuoteItem item : quoteItems){
				item.setGipiQuoteItemAC((GIPIQuoteItemAC) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemAC()));
				item.setGipiQuoteItemEN((GIPIQuoteItemEN) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemEN()));
				item.setGipiQuoteItemFI((GIPIQuoteItemFI) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemFI()));
				item.setGipiQuoteItemCA((GIPIQuoteItemCA) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemCA()));
				item.setGipiQuoteItemAV((GIPIQuoteItemAV) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemAV()));
				item.setGipiQuoteItemMC((GIPIQuoteItemMC) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemMC()));
				item.setGipiQuoteItemMH((GIPIQuoteItemMH) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemMH()));
				item.setGipiQuoteItemMN((GIPIQuoteItemMN) StringFormatter.escapeHTMLInObject(item.getGipiQuoteItemMN()));
				packQuoteItemList.add(item);
			}
		}
		return packQuoteItemList;
		
		//return this.getSqlMapClient().queryForList("getGIPIQuoteItemListForPack", packQuoteId);
	}

	/*
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIQuoteItemForPackQuotation(Map<String, Object> listParams)
			throws SQLException, Exception {
		log.info("Saving GIPIQuoteItem for Package Quotation...");
		Map<String,Object> params = new HashMap<String, Object>();
				
		try{
			List<GIPIQuoteItem> setItemRows = (List<GIPIQuoteItem>) listParams.get("setItemRows");
			System.out.println("setItemRows length: " + setItemRows.size());
			List<GIPIQuoteItem> delItemRows = (List<GIPIQuoteItem>) listParams.get("delItemRows");
			System.out.println("delItemRows length: " + delItemRows.size());
			List<GIPIQuoteItemPerilSummary> setPerilRows = (List<GIPIQuoteItemPerilSummary>) listParams.get("setPerilRows");
			System.out.println("setPerilRows length: " + setPerilRows.size());
			List<GIPIQuoteItemPerilSummary> delPerilRows = (List<GIPIQuoteItemPerilSummary>) listParams.get("delPerilRows");
			System.out.println("delPerilRows length: " + delPerilRows.size());
			List<GIPIQuoteDeductiblesSummary> setDeductibleRows = (List<GIPIQuoteDeductiblesSummary>) listParams.get("setDeductibleRows");
			System.out.println("setDeductibleRows length: " + setDeductibleRows.size());
			List<GIPIQuoteDeductiblesSummary> delDeductibleRows = (List<GIPIQuoteDeductiblesSummary>) listParams.get("delDeductibleRows");
			System.out.println("delDeductibleRows length: " + delDeductibleRows.size());
			List<GIPIQuoteMortgagee> setMortgageeRows = (List<GIPIQuoteMortgagee>) listParams.get("setMortgageeRows");
			System.out.println("setMortgageeRows length: " + setMortgageeRows.size());
			List<GIPIQuoteMortgagee> delMortgageeRows = (List<GIPIQuoteMortgagee>) listParams.get("delMortgageeRows");
			System.out.println("delMortgageeRows length: " + delMortgageeRows.size());
			List<GIPIQuoteInvoice> setInvoiceRows = (List<GIPIQuoteInvoice>) listParams.get("setInvoiceRows");
			System.out.println("setInvoiceRows length: " + setInvoiceRows.size());
			List<GIPIQuoteInvoice> delInvoiceRows = (List<GIPIQuoteInvoice>) listParams.get("delInvoiceRows");
			System.out.println("delInvoiceRows length: " + delInvoiceRows.size());
			List<Object> setAIRows = (List<Object>) listParams.get("setAIRows");
			System.out.println("setAIRows length: " + setAIRows.size());
			List<Object> delAIRows = (List<Object>) listParams.get("delAIRows");
			System.out.println("delAIRows length: " + delAIRows.size());
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			for(GIPIQuoteMortgagee mortgagee: delMortgageeRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", mortgagee.getQuoteId());
				params.put("issCd", mortgagee.getIssCd());
				params.put("itemNo", mortgagee.getItemNo());
				params.put("mortgCd", mortgagee.getMortgCd());
				this.getSqlMapClient().delete("deleteGIPIQuoteMortgagee",params);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteDeductiblesSummary deductible : delDeductibleRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles3", deductible.toGIPIQuoteDeductible());
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItemPerilSummary peril: delPerilRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", peril.getQuoteId());
				params.put("itemNo", peril.getItemNo());
				params.put("perilCd", peril.getPerilCd());
				params.put("lineCd", peril.getLineCd());
				this.getSqlMapClient().delete("deleteGipiQuoteItmPeril", params);
				this.getSqlMapClient().executeBatch();
			}
			
			for(Object delAiRow : delAIRows){
				this.getSqlMapClient().startBatch();
				this.deleteAdditionalInfoForPackQuotation(delAiRow);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItem item: delItemRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", item.getQuoteId());
				params.put("itemNo", item.getItemNo());
				this.getSqlMapClient().delete("deleteAllGIPIQuoteMortgagee", params);
				
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().startBatch();
				this.delGIPIQuoteItem(item.getQuoteId(), item.getItemNo());
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItem item: setItemRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("setGipiQuoteItem2", item);
				this.getSqlMapClient().executeBatch();
			}
			
			for(Object setAIRow : setAIRows){
				this.getSqlMapClient().startBatch();
				this.insertAdditionalInfoForPackQuotation(setAIRow);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteItemPerilSummary peril: setPerilRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteItemPeril", peril.toGipiItemPeril());
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().startBatch();
				if((peril.getWcSw()).equals("Y")){
					params.clear();
					params.put("quoteId", peril.getQuoteId());
					params.put("perilCd", peril.getPerilCd());
					params.put("lineCd", peril.getLineCd());
					log.info("Attaching default warranty for quoteId: " + peril.getQuoteId());
					this.getSqlMapClient().insert("attachWarranty", params);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteDeductiblesSummary deductible : setDeductibleRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteDeductibles", deductible.toGIPIQuoteDeductible());
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteMortgagee mortgagee: setMortgageeRows){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveGIPIQuoteMortgagee", mortgagee);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIQuoteInvoice invoice: setInvoiceRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", invoice.getQuoteId());
				params.put("quoteInvNo", invoice.getQuoteInvNo());
				params.put("issCd", invoice.getIssCd());
				params.put("premAmt", invoice.getPremAmt());
				params.put("taxAmt", invoice.getTaxAmt());
				params.put("intmNo", invoice.getIntmNo());
				this.getSqlMapClient().update("updateGIPIQuoteInvoice", params);
				this.getSqlMapClient().executeBatch();
				
				for(GIPIQuoteInvTax invTax: invoice.getInvoiceTaxes()){
					if(invTax.getRecordStatus() == GIPIQuoteInvTax.DELETE_OBJECT){
						this.getSqlMapClient().startBatch();
						params.clear();
						params.put("quoteInvNo", invTax.getQuoteInvNo());
						params.put("issCd", invTax.getIssCd());
						params.put("taxCd", invTax.getTaxCd());
						this.getSqlMapClient().delete("deleteInvTax", params);
						this.getSqlMapClient().executeBatch();
					}else{
						this.getSqlMapClient().startBatch();
						this.getSqlMapClient().insert("saveGIPIQuoteInvTax",invTax);
						this.getSqlMapClient().executeBatch();
					}
				}
				
				String perilChangeTag = "N";
				
				for(GIPIQuoteItemPerilSummary setPeril: setPerilRows){
					if((setPeril.getQuoteId()).equals(invoice.getQuoteId())){
						perilChangeTag = "Y";
					}
				}
				
				for(GIPIQuoteItemPerilSummary delPeril: delPerilRows){
					if((delPeril.getQuoteId()).equals(invoice.getQuoteId())){
						perilChangeTag = "Y";
					}
				}
				
				System.out.println("Peril Change Tag: " + perilChangeTag);
				if(perilChangeTag.equals("Y")){
					this.getSqlMapClient().startBatch();
					params.clear();
					params.put("quoteId", invoice.getQuoteId());
					params.put("currencyCd", invoice.getCurrencyCd());
					params.put("currencyRt", invoice.getCurrencyRt());
					this.getSqlMapClient().update("updateQuoteInvoiceDetails", params);
					System.out.println("Peril has been updated for quoteId: " + invoice.getQuoteId());
					this.getSqlMapClient().executeBatch();
				}
				
			}
						
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * Saves additional information for Package Quotation
	 * @param ai - object that contains the additional information
	 * @throws SQLException
	 */
	
	public void insertAdditionalInfoForPackQuotation(Object ai) throws SQLException{
		if(ai.getClass().equals(GIPIQuoteItemCA.class)){
			GIPIQuoteItemCA ca = (GIPIQuoteItemCA) ai;
			log.info("Saving Casualty additional info for quoteId: " + ca.getQuoteId() + " itemNo: " + ca.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemCA", ca);
		}else if(ai.getClass().equals(GIPIQuoteItemEN.class)){
			GIPIQuoteItemEN en = (GIPIQuoteItemEN) ai;
			en.setEnggBasicInfoNum(1); // this sets the engBasicInfoNum to constant value = 1
			log.info("Saving Engineering additional info for quoteId: " + en.getQuoteId() + " EnggBasicInfoNum: " + en.getEnggBasicInfoNum());
			this.getSqlMapClient().insert("saveGIPIQuoteItemEN", en);
		}else if(ai.getClass().equals(GIPIQuoteItemFI.class)){
			GIPIQuoteItemFI fi = (GIPIQuoteItemFI) ai;
			log.info("Saving Fire additional info for quoteId: " + fi.getQuoteId() + " itemNo: " + fi.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemFI", fi);
		}else if(ai.getClass().equals(GIPIQuoteItemMC.class)){
			GIPIQuoteItemMC mc = (GIPIQuoteItemMC) ai;
			log.info("Saving Motor Car additional info for quoteId: " + mc.getQuoteId() + " itemNo: " + mc.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemMC", mc);
		}else if(ai.getClass().equals(GIPIQuoteItemMN.class)){
			GIPIQuoteItemMN mn = (GIPIQuoteItemMN) ai;
			log.info("Saving Marine Cargo additional info for quoteId: " + mn.getQuoteId() + " itemNo: " + mn.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemMN", mn);
		}else if(ai.getClass().equals(GIPIQuoteItemAC.class)){
			GIPIQuoteItemAC ac = (GIPIQuoteItemAC) ai;
			log.info("Saving Accident additional info for quoteId: " + ac.getQuoteId() + " itemNo: " + ac.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemAC", ac);
		}else if(ai.getClass().equals(GIPIQuoteItemAV.class)){
			GIPIQuoteItemAV av = (GIPIQuoteItemAV) ai;
			log.info("Saving Aviation additional info for quoteId: " + av.getQuoteId() + " itemNo: " + av.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemAV", av);
		}else if(ai.getClass().equals(GIPIQuoteItemMH.class)){
			GIPIQuoteItemMH mh = (GIPIQuoteItemMH) ai;
			log.info("Saving Marine Hull additional info for quoteId: " + mh.getQuoteId() + " itemNo: " + mh.getItemNo());
			this.getSqlMapClient().insert("saveGIPIQuoteItemMH", mh);
		}
	}
	
	public void deleteAdditionalInfoForPackQuotation(Object ai) throws SQLException{
		Map<String, Object> delParams = new HashMap<String, Object>();
		
		if(ai.getClass().equals(GIPIQuoteItemCA.class)){
			GIPIQuoteItemCA ca = (GIPIQuoteItemCA) ai;
			log.info("Deleting Casualty additional info for quoteId: " + ca.getQuoteId() + " itemNo: " + ca.getItemNo());
			delParams.clear();
			delParams.put("quoteId", ca.getQuoteId());
			delParams.put("itemNo", ca.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemCA", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemEN.class)){
			GIPIQuoteItemEN en = (GIPIQuoteItemEN) ai;
			log.info("Deleting Engineering additional info for quoteId: " + en.getQuoteId());
			delParams.put("quoteId", en.getQuoteId());
			delParams.put("engBasicInfoNum", en.getEnggBasicInfoNum());
			delParams.put("itemNo", en.getEnggBasicInfoNum());
			this.getSqlMapClient().delete("delGIPIQuoteItemEN", delParams);
			//this.getSqlMapClient().delete("deleteGIPIQuoteItemEN", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemFI.class)){
			GIPIQuoteItemFI fi = (GIPIQuoteItemFI) ai;
			log.info("Deleting Fire additional info for quoteId: " + fi.getQuoteId() + " itemNo: " + fi.getItemNo());
			delParams.clear();
			delParams.put("quoteId", fi.getQuoteId());
			delParams.put("itemNo", fi.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemFI", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemMC.class)){
			GIPIQuoteItemMC mc = (GIPIQuoteItemMC) ai;
			log.info("Deleting Motor Car additional info for quoteId: " + mc.getQuoteId() + " itemNo: " + mc.getItemNo());
			delParams.clear();
			delParams.put("quoteId", mc.getQuoteId());
			delParams.put("itemNo", mc.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMC", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemMN.class)){
			GIPIQuoteItemMN mn = (GIPIQuoteItemMN) ai;
			log.info("Deleting Marine Cargo additional info for quoteId: " + mn.getQuoteId() + " itemNo: " + mn.getItemNo());
			delParams.clear();
			delParams.put("quoteId", mn.getQuoteId());
			delParams.put("itemNo", mn.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMN", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemAC.class)){
			GIPIQuoteItemAC ac = (GIPIQuoteItemAC) ai;
			log.info("Deleting Accident additional info for quoteId: " + ac.getQuoteId() + " itemNo: " + ac.getItemNo());
			delParams.clear();
			delParams.put("quoteId", ac.getQuoteId());
			delParams.put("itemNo", ac.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemAC", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemAV.class)){
			GIPIQuoteItemAV av = (GIPIQuoteItemAV) ai;
			log.info("Deleting Aviation additional info for quoteId: " + av.getQuoteId() + " itemNo: " + av.getItemNo());
			delParams.clear();
			delParams.put("quoteId", av.getQuoteId());
			delParams.put("itemNo", av.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemAV", delParams);
		}else if(ai.getClass().equals(GIPIQuoteItemMH.class)){
			GIPIQuoteItemMH mh = (GIPIQuoteItemMH) ai;
			log.info("Deleting Marine Hull additional info for quoteId: " + mh.getQuoteId() + " itemNo: " + mh.getItemNo());
			delParams.clear();
			delParams.put("quoteId", mh.getQuoteId());
			delParams.put("itemNo", mh.getItemNo());
			this.getSqlMapClient().delete("deleteGIPIQuoteItemMH", delParams);
		}
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#delGIPIQuoteItem(int, int)
	 */
	@Override
	public void delGIPIQuoteItem(int quoteId, int itemNo) throws SQLException {
		log.info("DAO calling delGIPIQuoteItem Params:("+quoteId+","+itemNo+")");
		Map<String, Integer> param = new HashMap<String, Integer>();
		param.put("quoteId", quoteId);
		param.put("itemNo", itemNo);
		getSqlMapClient().delete("delGIPIQuoteItem",param);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteItemDAO#delGIPIQuoteItem(map)
	 */
	@Override
	public void delGIPIQuoteItem(Map<String, Object> params)
			throws SQLException {
		Integer quoteId = new Integer(params.get("quoteId").toString());
		Integer itemNo = new Integer(params.get("itemNo").toString());
		String issCd = params.get("issCd").toString();
		String lineCd = params.get("lineCd").toString();
		log.info("DAO calling delGIPIQuoteItem Params:("+quoteId+","+itemNo+")");
		Map<String, Integer> param = new HashMap<String, Integer>();
		
		/* Delete 
		 * attached media??
		 * additional info
		 * mortgagee
		 * deductibles
		 * perils
		 */
		// mortgagee 
		params.put("quoteId", quoteId);
		params.put("issCd", issCd);
		params.put("itemNo", itemNo);
		
		this.getSqlMapClient().delete("deleteGIPIQuoteMortgagee2", params);
		
		this.getSqlMapClient().startBatch();
		this.deleteAdditionalInformation(lineCd, quoteId, itemNo);
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().startBatch();
		this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles4", params); // quoteId, itemNo [ignore dedDeductibleCd and perilCd]
		this.getSqlMapClient().executeBatch();
		
		// delete perils
		params.clear();
		params.put("quoteId", quoteId);
		params.put("itemNo", itemNo);
		params.put("lineCd", lineCd);
		
		this.getSqlMapClient().startBatch();
		this.getSqlMapClient().delete("delPerilsOfQuoteItem", params);
		this.getSqlMapClient().executeBatch();
		
		this.getSqlMapClient().startBatch();
		param.clear();
		param.put("quoteId", quoteId);
		param.put("itemNo", itemNo);
		getSqlMapClient().delete("delGIPIQuoteItem",param);
		this.getSqlMapClient().executeBatch();
	}
	
}