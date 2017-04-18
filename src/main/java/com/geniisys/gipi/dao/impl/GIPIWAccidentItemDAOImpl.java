package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.dao.GIPIParItemDAO;
import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.dao.GIPIWAccidentItemDAO;
import com.geniisys.gipi.dao.GIPIWDeductibleDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWAccidentItem;
import com.geniisys.gipi.entity.GIPIWBeneficiary;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWGrpItemsBeneficiary;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWItmperlBeneficiary;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWAccidentItemDAOImpl implements GIPIWAccidentItemDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIPIWAccidentItemDAOImpl.class);
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWDeductibleDAO gipiWDeductibleDAO;
	private GIPIParItemDAO gipiParItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	} 
	
	private GIPIParItemMCDAO itemMcDAO;
	
	public GIPIParItemMCDAO getItemMcDAO() {
		return itemMcDAO;
	}
	
	public void setItemMcDAO(GIPIParItemMCDAO itemMcDAO) {
		this.itemMcDAO = itemMcDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#getGipiWAccidentItem(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWAccidentItem> getGipiWAccidentItem(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWAccidentItems", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveGIPIParAccidentItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIParAccidentItem(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWAccidentItem> accidentItems = (List<GIPIWAccidentItem>) params.get("accidentItems");
			List<GIPIWBeneficiary> beneficiaryItems = (List<GIPIWBeneficiary>) params.get("beneficiaryItems");
			
			String[] delItemNos				= (String[]) params.get("delItemNos");
			String[] delBeneficiaryItemNos	= (String[]) params.get("delBeneficiaryItemNos");
			String[] delBeneficiaryNos		= (String[]) params.get("delBeneficiaryNos");
			String parId 					= (String) params.get("parId").toString();
			
			if (delBeneficiaryItemNos != null && delBeneficiaryNos != null){
				for (int a = 0; a < delBeneficiaryItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delBeneficiaryItemNos[a]);
					paramsDel.put("beneficiaryNo", delBeneficiaryNos[a]);
					System.out.println("Deleting record in GIPI_WBENEFICIARY for item no.: /"+delBeneficiaryItemNos[a]+"/ beneficiaryNo: /"+delBeneficiaryNos[a]);
					this.sqlMapClient.update("delGIPIWBeneficiary2", paramsDel);
				}
			}
			
			System.out.println("Saving record/s For Beneficiary Information:");
			System.out.println("ParID\tItemNo\tBeneficiaryNo\tBeneficiaryName");
			System.out.println("=======================================================================================");
			for(GIPIWBeneficiary ben:beneficiaryItems){
				if (delItemNos != null){
					for (int a = 0; a < delItemNos.length; a++) {
						if (!delItemNos[a].equals(ben.getItemNo())) {
							System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + ben.getBeneficiaryNo() + "\t" + ben.getBeneficiaryName());
							this.getSqlMapClient().insert("setGIPIWBeneficiary", ben);
						}
					}
				} else{
					System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + ben.getBeneficiaryNo() + "\t" + ben.getBeneficiaryName());
					this.getSqlMapClient().insert("setGIPIWBeneficiary", ben);
				}
			}
			System.out.println("=======================================================================================");
			
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo");
			System.out.println("=======================================================================================");
			for(GIPIWAccidentItem accident:accidentItems){
				if (accident.getDelGrpItemsInItems().equals("Y")){
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", accident.getParId());
					paramsDel.put("itemNo", accident.getItemNo());
					System.out.println("Deleting Grouped Items Information first for itemNo: "+accident.getItemNo());
					this.sqlMapClient.update("delGIPIWGroupedItemsPerItem", paramsDel);
				}
				System.out.println(accident.getParId() + "\t" + accident.getItemNo() );
				this.getSqlMapClient().insert("setGipiWAccidentItems", accident);
				if (accident.getPopulatePerils().equals("Y")){
					System.out.println("Overwrite perils for itemNo: "+ accident.getItemNo());
					Map<String, String> paramsOverwrite = new HashMap<String, String>();
					paramsOverwrite.put("parId", accident.getParId());
					paramsOverwrite.put("itemNo", accident.getItemNo());
					this.sqlMapClient.update("populateOverwriteBenefits2", paramsOverwrite);
				}
				if (accident.getAccidentDeleteBills().equals("Y")){
					System.out.println("Deleting Bill for itemNo : "+ accident.getItemNo());
					Map<String, Object> paramsDelBill = new HashMap();
					paramsDelBill.put("parId", accident.getParId());
					paramsDelBill.put("itemNo", accident.getItemNo());
					paramsDelBill.put("premAmt", accident.getPremAmt());
					paramsDelBill.put("annPremAmt", accident.getAnnPremAmt());
					paramsDelBill.put("tsiAmt", accident.getTsiAmt());
					paramsDelBill.put("annTsiAmt", accident.getAnnTsiAmt());
					this.sqlMapClient.update("deleteBillAccidentItem", paramsDelBill);
				}
			}
			System.out.println("=======================================================================================");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}	
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveEndtAccidentItemInfoPage(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	// Created by Irwin
	public void saveEndtAccidentItemInfoPage(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("saving endt accident item info..");
			String pExist1 = "N";
			String pExist2 = "N";
			@SuppressWarnings("unused")
			String vExist  = "N";
			Integer parId = (Integer) params.get("parId");
			String delPolDed = (String) params.get("delPolDed");
			String sublineCd = (String) params.get("sublineCd");
			String gipiWItemExist = (String) params.get("gipiWItemExist");
			String gipiWItemPerilExist = (String) params.get("gipiWItemPerilExist"); 
			String lineCd = (String) params.get("lineCd");
			String issCd = (String) params.get("issCd");
			Integer distNo = (Integer) params.get("distNo");
			System.out.println("gipiWitem exist? :"+gipiWItemExist);
			String[] delItemNos = (String[]) params.get("delItemNos");
			String[] delBeneficiaryItemNos	= (String[]) params.get("delBeneficiaryItemNos");
			String[] delBeneficiaryNos		= (String[]) params.get("delBeneficiaryNos");
			// first get all deleted item numbers and delete discounts.
			
			//DELETE_DISCOUNTS
			log.info("Deleting Discounts...");
			System.out.println(parId);
			//this.getGipiParItemDAO().deleteDiscount2(parId);
			this.getSqlMapClient().delete("deleteDiscount2",parId);
	
			if(delItemNos !=null){
				for (String d: delItemNos){
					//delete accidentWitem details
					Map<String, Object> delParams = new HashMap<String, Object>();
					int itemNo = Integer.parseInt(d);
					delParams.put("parId", parId);
					delParams.put("itemNo", itemNo);
					this.getSqlMapClient().queryForObject("delGIPIWItemAccident", delParams);
				}
			}
			// 2nd delete wbenificiary
			if(delBeneficiaryItemNos != null && delBeneficiaryNos != null){
				for(int a = 0; a< delBeneficiaryItemNos.length; a++){
					Map<String, Object> paramsBefDel = new HashMap<String, Object>();
					paramsBefDel.put("parId", parId.toString());
					paramsBefDel.put("itemNo", delBeneficiaryItemNos[a]);
					paramsBefDel.put("beneficiaryNo", delBeneficiaryNos[a]); //changed by angelo to get the deleted beneficiary number
					log.info("Deleting record in GIPI_WBENEFICIARY for item no.: /"+delBeneficiaryItemNos[a]+"/ beneficiaryNo: /"+delBeneficiaryNos[a]);
					this.sqlMapClient.update("delGIPIWBeneficiary2", paramsBefDel);
				}
			}
			// PRE DELETE WITEM AND DEL REC.
			
			if(delItemNos != null){
				for (String d: delItemNos){
					Map<String , Object> delParams = new HashMap<String, Object>();
					int itemNo = Integer.parseInt(d);
					delParams.put("parId", parId);
					delParams.put("itemNo", itemNo);
					log.info("Pre-deleting WAccident Item...");
					System.out.println("deleting parId: " +parId);
					System.out.println("deleting itemNo: "+itemNo);
					
					// PRE DELETE
					this.getSqlMapClient().queryForObject("preDeleteEndtAccident", delParams);
					
					//DEL - REC
					if("Y" == delPolDed){
						this.gipiWDeductibleDAO.deleteAllWPolicyDeductibles2(parId, "AH", sublineCd);
					}
					this.getSqlMapClient().delete("deleteGIPIEndtParItem", delParams);	
				}
			}
			
			String[] itemNos = (String[]) params.get("itemNos");
			if(itemNos != null){
				Map<String, Object> items = (Map<String, Object>) params.get("items");
				Map<String, Object> itemsAcc = (Map<String, Object>) params.get("itemsAcc");
				for(String i : itemNos){
					GIPIWItem item = (GIPIWItem) items.get(i);
					GIPIWAccidentItem acc = (GIPIWAccidentItem) itemsAcc.get(i);
					log.info("Inserting ACCIDENT Item...");
					log.info("Item Number : " + item.getItemNo());
					//this.gipiWItemDAO.insertGIPIWItem(item);
					this.getSqlMapClient().insert("setGIPIParItem", item);
					log.info("Inserting Accident Additional Info");
					this.getSqlMapClient().insert("setGipiWAccidentItems", acc);
					log.info("Accident items : " + acc.getParId());
				}	
			} 
			
			if (itemNos != null){
				Map<String, Object> items = (Map<String, Object>) params.get("items");
				Map<String, Object> itemsAcc = (Map<String, Object>) params.get("itemsAcc");
				
				for (String i : itemNos){
					GIPIWItem item = (GIPIWItem) items.get(i);
					GIPIWAccidentItem accItem = (GIPIWAccidentItem) itemsAcc.get(i);
					this.getGipiWItemDAO().setGIPIWItemWGroup(item);
					this.insertGIPIWItemAcc(accItem);
				}
			}
						
			//String[] bItemNos = (String[]) params.get("bItemNos");
			String[] bItemNos = (String[]) params.get("beneficiaryNos");
			if(bItemNos != null){
				Map<String, Object> bItems = (Map<String, Object>) params.get("beneficiaryItems");
				for(String i : bItemNos){
					GIPIWBeneficiary bItem = (GIPIWBeneficiary) bItems.get(i);					
					log.info("Inserting beneficiary info..");					
					this.getSqlMapClient().insert("setGIPIWBeneficiary", bItem);
				}
			}
			
			//for item deductibles
			String[] insDedItemNos	= (String[]) params.get("insDedItemNos");
			String[] delDedItemNos	= (String[]) params.get("delDedItemNos");
			
			/*
			if(delDedItemNos != null){
				List<GIPIWDeductible> deductibleDelList = (List<GIPIWDeductible>) params.get("deductibleDelList");
				for (GIPIWDeductible ded : deductibleDelList){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() +") - Deleting record from gipi_wdeductible (item level)..." );
					this.getSqlMapClient().delete("delGipiWDeductibles", ded);
				}
			}
			*/
			if(delDedItemNos != null){
				List<Map<String, Object>> deductibleDelList = (List<Map<String, Object>>) params.get("deductibleDelList");
				for (Map<String, Object> dedd : deductibleDelList){
					//log.info("Item - (parId=" + dedd.getParId() + ", itemNo=" + dedd.getItemNo() + ", dedCd=" + dedd.getDedDeductibleCd() + ") - Deleting record from gipi_wdeductible (item level)..." );
					log.info("Item - (parId=" + dedd.get("parId") + ", itemNo=" + dedd.get("itemNo") + ", dedCd=" + dedd.get("dedDeductibleCd") + ") - Deleting record from gipi_wdeductible (item level)...");
					this.getSqlMapClient().delete("delGipiWDeductibles", dedd);
				}
			}
			
			if(insDedItemNos != null){
				List<GIPIWDeductible> deductibleInsList = (List<GIPIWDeductible>) params.get("deductibleInsList");
				for (GIPIWDeductible ded : deductibleInsList){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() +") - Inserting record to gipi_wdeductible (item level)..." );
					this.getSqlMapClient().insert("saveWDeductible", ded);
				}
			}
			
			//for peril
			Map<String, Object> allEndtPerilParams 	= (Map<String, Object>) params.get("allEndtPerilParams");
			String[] insItemNos 					= (String[]) allEndtPerilParams.get("insItemNos");
			String[] delPerilItemNos 				= (String[]) allEndtPerilParams.get("delPerilItemNos");
			
			if ((insItemNos != null) || (delPerilItemNos != null)){
				this.getGipiWItemPerilDAO().saveEndtItemPeril2(allEndtPerilParams);
			}
			
			/*
			if (itemNos != null){
				Map<String, Object> items = (Map<String, Object>) params.get("items");
				Map<String, Object> itemVes = (Map<String, Object>) params.get("itemVes");
				
				for (String i: itemNos){
					GIPIWItem item = (GIPIWItem) items.get(i);
					GIPIWItemVes ves = (GIPIWItemVes) itemVes.get(i);
					this.getGipiWItemDAO().setGIPIWItemWGroup(item);
					this.insertGIPIWItemVes(ves);
				}
			}
			*/

			// POST FORM COMMIT STARTS HERE.
			String varPost = (String) params.get("varPost");
			String userId = (String) params.get("userId");
			String invoiceSw = (String) params.get("invoiceSw");
			String packPolFlag = (String) params.get("packPolFlag");
			
			System.out.println("varpost "+varPost);
			if ("".equals(varPost) || varPost == null){
				log.info("Inserting PAR history info...");
				Map<String, Object> parHistparams = new HashMap<String, Object>();
				parHistparams.put("parId", parId);
				parHistparams.put("userId", userId);
				parHistparams.put("entrySource", "");
				parHistparams.put("parstatCd", "4");
				this.getSqlMapClient().queryForObject("insertPARHist", parHistparams);
			}
			
			if (("Y".equals(invoiceSw)) || ("".equals(varPost))){
				//DELETE_BILL
				String endtTax = (String) this.getSqlMapClient().queryForObject("getEndtTax", parId); //variables.endt_tax_sw
				if ("Y".equals(endtTax)){
					this.getSqlMapClient().queryForObject("deleteBillsDetails", parId);
				}
				
				//UPDATE_GIPI_WPOLBAS2
				String updateGIPIWPolbas = (String) params.get("updateGIPIWPolbas");
				log.info("updateGIPIWPolbas? "+updateGIPIWPolbas);
				log.info("Updating GIPIWPolbas table...");
				Map<String, Object> updateGIPIWPolbasParams = (Map<String, Object>) params.get("updateGIPIWPolbasParams");
				this.getSqlMapClient().queryForObject("updateAccGipiWPolbas", updateGIPIWPolbasParams);
				
				//CREATE_DISTRIBUTION
				
				if ("Y".equals(gipiWItemExist)){
					log.info("Creating distribution for accident...");
					this.getSqlMapClient().queryForObject("itemAccCreateDistribution", parId);
					pExist1 = "Y";
				}
				
				//POPULATE_ORIG_ITMPERIL and CREATE_WINVOICE
				if (!("Y".equals(endtTax))){
					if ("Y".equals(gipiWItemPerilExist)){
						log.info("Populating original item perils...");
						this.getSqlMapClient().queryForObject("populateOrigItemPeril", parId);
						log.info("Creating invoice...");
						Map<String, Object> invParam = new HashMap<String, Object>();
						invParam.put("policyId", 0);
						invParam.put("polIdN", 0);
						invParam.put("oldParId", 0);
						invParam.put("parId", parId);
						invParam.put("lineCd", lineCd);
						invParam.put("issCd", issCd);
						this.getSqlMapClient().queryForObject("createWInvoice", invParam);
						pExist2 = "Y";
					}
				}
				
				if ("Y".equals(gipiWItemExist)){
					vExist = "Y";
				}
				
				System.out.println("distNo is: "+distNo);
				if ("N".equals(pExist1)){ /*No items found*/
					if (distNo != 0){
						//DELETE_DISTRIBUTION
						log.info("Deleting Accident distribution...");
						this.getSqlMapClient().queryForObject("deleteAccDistribution", distNo);
					}
				}
				
				if (("N".equals(pExist2)) && ("Y".equals(endtTax))){
					log.info("Deleting inv-related records...");
					this.getSqlMapClient().queryForObject("deleteAccInvRelatedRecords", parId);
				}
				
				//ADD_PAR_STATUS_NO
				@SuppressWarnings("unused")
				Integer pDistNo = (distNo == 0 ? null : distNo ); 
				//(ADD_PAR_STATUS_NO)CHANGES_IN_PAR_STATUS
				Integer vParStatus = 0;
				String aItem = (String) params.get("aItem");
				String aPeril = (String) params.get("aPeril");
				String cItem = "";
				String cPeril = "";
				
				if ("N".equals(aItem)){
					cItem = gipiWItemExist;
					cPeril = gipiWItemPerilExist;
				}
				
				Map<String, Object> invParams = new HashMap<String, Object>();
				invParams.put("parId", parId);
				invParams.put("lineCd", lineCd);
				invParams.put("issCd", issCd);
				//testing
				System.out.println("parId : " + invParams.get("parId"));
				System.out.println("lineCd : " + invParams.get("lineCd"));
				System.out.println("issCd : " + invParams.get("issCd"));
				//(ADD_PAR_STATUS_NO)CHANGES_IN_PAR_STATUS/createinvoice
				//statement below commented for now
				this.getSqlMapClient().queryForObject("createInvoiceItem2", invParams);
				this.getSqlMapClient().queryForObject("itemAccCreateDistributionItem", parId);
				
				log.info("aItem+aPeril,cItem+cPeril: "+aItem+aPeril+","+cItem+cPeril);
				if (("N".equals(aItem)) && ("N".equals(cPeril)) && ("Y".equals(endtTax))){
					if ("Y".equals(cItem)){
						vParStatus = 4;
					} else {
						this.getSqlMapClient().queryForObject("createWInvoice1EndtItemPeril", invParams);
						vParStatus = 5;
					}
				} else if (("Y".equals(aPeril)) && ("Y".equals(cPeril))){
					vParStatus = 5;
				} else if (("Y".equals(aItem)) || ("Y".equals(cItem))){
					vParStatus = 4;
				} else {
					vParStatus = 3;
				}
				
				Integer itemRecANoPerilCount = (Integer) params.get("itemRecANoPerilCount");
				String gipiWInvTaxExist = (String) params.get("gipiWInvTaxExist");
				@SuppressWarnings("unused")
				String gipiWInvoiceExist = (String) params.get("gipiWInvoiceExist");
				if (4 == vParStatus){
					if (0 == itemRecANoPerilCount){
						if ("Y".equals(endtTax)){
							if ("N".equals(gipiWInvTaxExist)){
								vParStatus = 5;
							} else {
								vParStatus = 6;
							}
						}
					}
				} 
				
				// Finally update the par status
				log.info("Updating Par Status...");
				Map<String, Object>updateParams = new HashMap<String, Object>();
				updateParams.put("parId", parId);
				updateParams.put("parStatus", vParStatus);
				this.getSqlMapClient().queryForObject("updatePARStatus", updateParams);
				if ("Y".equals(packPolFlag)){
					String packLineCd = (String) params.get("packLineCd");
					String packSublineCd = (String) params.get("packSublineCd");
					Integer packParId = (Integer) params.get("packParId");
					Map<String, Object> itemParams = new HashMap<String, Object>();
					itemParams.put("parId", parId);
					itemParams.put("packLineCd", packLineCd);
					itemParams.put("packSublineCd", packSublineCd);
					log.info("Updating UPDATE_GIPI_WPACK_LINE_SUBLINE..");
					this.getGipiWItemDAO().updateGipiWPackLineSubline(itemParams);
					log.info("Updating package details...");
					this.getSqlMapClient().queryForObject("setPackageMenu1", packParId);
				}

			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}
		
	}
	
	public static Logger getLog() {
		return log;
	}

	public static void setLog(Logger log) {
		GIPIWAccidentItemDAOImpl.log = log;
	}

	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}

	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}

	public GIPIWDeductibleDAO getGipiWDeductibleDAO() {
		return gipiWDeductibleDAO;
	}

	public void setGipiWDeductibleDAO(GIPIWDeductibleDAO gipiWDeductibleDAO) {
		this.gipiWDeductibleDAO = gipiWDeductibleDAO;
	}

	//Jerome Accident item Modal page
	@SuppressWarnings("unchecked")
	@Override
	public String saveGIPIParAccidentItemModal(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWGroupedItems> groupedItems = (List<GIPIWGroupedItems>) params.get("groupedItems");
			List<GIPIWItmperlGrouped> coverageItems = (List<GIPIWItmperlGrouped>) params.get("coverageItems");
			List<GIPIWGrpItemsBeneficiary> beneficiaryItems = (List<GIPIWGrpItemsBeneficiary>) params.get("beneficiaryItems");
			List<GIPIWItmperlBeneficiary> beneficiaryPerils = (List<GIPIWItmperlBeneficiary>) params.get("beneficiaryPerils");
			
			String parId = (String) params.get("parId").toString();
			String itemNo = (String) params.get("itemNo").toString();
			String lineCd = (String) params.get("lineCd").toString();
			String newNoOfPerson = (String) params.get("newNoOfPerson").toString();
			String[] delGroupItemsItemNos = (String[]) params.get("delGroupItemsItemNos");
			String[] delGroupedItemNos = (String[]) params.get("delGroupedItemNos");
			String[] delCoverageGroupedItemNos = (String[]) params.get("delCoverageGroupedItemNos");
			String[] delCoveragePerilCds = (String[]) params.get("delCoveragePerilCds");
			String[] delBenefitGroupedItemNos = (String[]) params.get("delBenefitGroupedItemNos");
			String[] delBenefitBeneficiaryNos = (String[]) params.get("delBenefitBeneficiaryNos");
			String doRenumber = (String) params.get("doRenumber") == null || (String) params.get("doRenumber") == "" ? "N" : (String) params.get("doRenumber");
			String[] popParIds = (String[]) params.get("popParIds");
			String[] popItemNos = (String[]) params.get("popItemNos");
			String[] popGroupedItemNos = (String[]) params.get("popGroupedItemNos");
			String[] popCheckSw = (String[]) params.get("popCheckSw");
			String popBenefitsSw = (String) params.get("popBenefitsSw");
			String popBenefitsGroupedItemNo = (String) params.get("popBenefitsGroupedItemNo");
			String popBenefitsPackBenCd = (String) params.get("popBenefitsPackBenCd");
			
			System.out.println("PAR ID:"+parId +" ,ITEM NO: "+itemNo+" ,LINE CD: "+lineCd+" ,NO OF PERSON: "+newNoOfPerson);
			if (parId != null && itemNo != null){
				Map<String, String> paramsDel = new HashMap<String, String>();
				paramsDel.put("parId", parId);
				paramsDel.put("itemNo", itemNo);
				System.out.println("Deleting record/s For Beneficiary Perils Modal:");
				this.sqlMapClient.update("delGIPIWItmperlBeneficiary", paramsDel);
				this.getSqlMapClient().executeBatch();
			}
			if (delBenefitGroupedItemNos != null && delBenefitBeneficiaryNos != null){
				for (int a = 0; a < delBenefitGroupedItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId);
					paramsDel.put("itemNo", itemNo);
					paramsDel.put("groupedItemNo", delBenefitGroupedItemNos[a]);
					paramsDel.put("beneficiaryNo", delBenefitBeneficiaryNos[a]);
					System.out.println("Deleting record/s For Beneficiary Information Modal: groupedItemNo: "+delBenefitGroupedItemNos[a]+" - beneficiaryNo: "+delBenefitBeneficiaryNos[a]);
					this.sqlMapClient.update("delGIPIWGrpItemsBeneficiary", paramsDel);
					this.getSqlMapClient().executeBatch();
				}
			}
			if (delCoverageGroupedItemNos != null && delCoveragePerilCds != null){
				for (int a = 0; a < delCoverageGroupedItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId);
					paramsDel.put("itemNo", itemNo);
					paramsDel.put("groupedItemNo", delCoverageGroupedItemNos[a]);
					paramsDel.put("perilCd", delCoveragePerilCds[a]);
					paramsDel.put("lineCd", lineCd);
					System.out.println("Deleting record/s For Enrollee Coverage Modal: groupedItemNo: "+delCoverageGroupedItemNos[a]+" - perilCd: "+delCoveragePerilCds[a]);
					this.sqlMapClient.update("delGIPIWItmperlGrouped", paramsDel);
					this.getSqlMapClient().executeBatch();
				}
			}
			if (delGroupItemsItemNos != null && delGroupedItemNos != null){
				for (int a = 0; a < delGroupItemsItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId);
					paramsDel.put("itemNo", delGroupItemsItemNos[a]);
					paramsDel.put("groupedItemNo", delGroupedItemNos[a]);
					System.out.println("Deleting record/s For Grouped Items Information Modal: itemNo: "+delGroupItemsItemNos[a]+" - groupedItemNo: "+delGroupedItemNos[a]);
					this.sqlMapClient.update("delGIPIWGrpItemsBeneficiary2", paramsDel);
					this.sqlMapClient.update("delGIPIWItmperlGrouped2", paramsDel);
					this.sqlMapClient.update("delGIPIWGroupedItems2", paramsDel);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			System.out.println("Saving record/s For Grouped Items Information Modal:");
			System.out.println("ParID \t ItemNo \t GroupedItemNo \t GroupedItemNo");
			System.out.println("=======================================================================================");
			for(GIPIWGroupedItems grp:groupedItems){
				System.out.println(grp.getParId() + "\t" + grp.getItemNo() + "\t" + Integer.parseInt(grp.getGroupedItemNo()) + "\t" + grp.getGroupedItemTitle());
				this.getSqlMapClient().insert("setGipiWGroupedItems2", grp);
				this.getSqlMapClient().executeBatch();
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s For Enrollee Coverage Modal:");
			System.out.println("ParID \t ItemNo \t GroupedItemNo \t PerilCd");
			System.out.println("=======================================================================================");
			for(GIPIWItmperlGrouped cov:coverageItems){
				if (cov.getWcSw().equals("Y")){
					System.out.println("Inserting default values on warranties and clauses: "+cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
					Map<String, String> paramsIns = new HashMap<String, String>();
					paramsIns.put("parId", cov.getParId().toString());
					paramsIns.put("lineCd", cov.getLineCd());
					paramsIns.put("perilCd", cov.getPerilCd());
					this.sqlMapClient.update("preCommitGipis012", paramsIns);
					this.getSqlMapClient().executeBatch();
				}
				System.out.println(cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
				this.getSqlMapClient().insert("setGIPIWItmperlGrouped", cov);
				this.getSqlMapClient().executeBatch();
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s For Beneficiary Information Modal:");
			System.out.println("ParID \t ItemNo \t GroupedItemNo \t BeneficiaryNo");
			System.out.println("=======================================================================================");
			for(GIPIWGrpItemsBeneficiary ben:beneficiaryItems){
				System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + Integer.parseInt(ben.getGroupedItemNo()) + "\t" + ben.getBeneficiaryNo());
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", ben);
				this.getSqlMapClient().executeBatch();
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s For Beneficiary Perils Modal:");
			System.out.println("ParID \t ItemNo \t GroupedItemNo \t BeneficiaryNo \t PerilCd");
			System.out.println("=======================================================================================");
			for(GIPIWItmperlBeneficiary per:beneficiaryPerils){
				System.out.println(per.getParId() + "\t" + per.getItemNo() + "\t" + Integer.parseInt(per.getGroupedItemNo()) + "\t" + per.getBeneficiaryNo() + "\t" + per.getPerilCd());
				this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", per);
				this.getSqlMapClient().executeBatch();
			}
			System.out.println("=======================================================================================");
			
			for(GIPIWGroupedItems grp:groupedItems){
				if (grp.getOverwriteBen().equals("Y")){
					System.out.println("Overwrite perils for itemNo: "+ grp.getItemNo()+" ,GroupedItemno: " + Integer.parseInt(grp.getGroupedItemNo()));
					Map<String, String> paramsOverwrite = new HashMap<String, String>();
					paramsOverwrite.put("parId", grp.getParId());
					paramsOverwrite.put("itemNo", grp.getItemNo());
					paramsOverwrite.put("groupedItemNo", grp.getGroupedItemNo());
					paramsOverwrite.put("packBenCd", grp.getPackBenCd());
					paramsOverwrite.put("lineCd", grp.getLineCd());
					this.sqlMapClient.update("populateOverwriteBenefits", paramsOverwrite);
					this.getSqlMapClient().executeBatch();
				}
			}
			if (doRenumber.equals("Y")){
				Map<String, String> renum = new HashMap<String, String>();
				renum.put("parId", parId);
				renum.put("itemNo", itemNo);
				this.sqlMapClient.update("renumberGroupedItems", renum);
				this.getSqlMapClient().executeBatch();
			}
			
			if (!popBenefitsSw.equals("")){
				if (popParIds != null){
					for (int a = 0; a < popParIds.length; a++) {
						if (popCheckSw[a].equals("Y")){
							Map<String, String> paramsDel = new HashMap<String, String>();
							paramsDel.put("parId", popParIds[a]);
							paramsDel.put("itemNo", popItemNos[a]);
							paramsDel.put("groupedItemNo", popBenefitsGroupedItemNo);
							System.out.println("Deleting before copy/populate :"+paramsDel);
							this.sqlMapClient.update("delGIPIWItmperlGrouped2", paramsDel);
						}	
					}
					for (int a = 0; a < popParIds.length; a++) {
						if (popCheckSw[a].equals("Y")){
							Map<String, String> copyBen = new HashMap<String, String>();
							copyBen.put("parId", popParIds[a]);
							copyBen.put("itemNo", popItemNos[a]);
							copyBen.put("lineCd", lineCd);
							copyBen.put("groupedItemNo",	popBenefitsGroupedItemNo );
							copyBen.put("benefitSw", popBenefitsSw);
							copyBen.put("origGroupedItemNo", popGroupedItemNos[a]);
							copyBen.put("origPackBenCd", popBenefitsPackBenCd);
							System.out.println(popBenefitsSw+"-Benefits for groupedItemNo: "+copyBen);
							this.sqlMapClient.update("copyBenPopulateBen", copyBen);
							this.getSqlMapClient().executeBatch();
							
							Map<String, String> insertRecgrp = new HashMap<String, String>();
							insertRecgrp.put("parId", popParIds[a]);
							insertRecgrp.put("itemNo", popItemNos[a]);
							insertRecgrp.put("lineCd", lineCd);
							insertRecgrp.put("groupedItemNo", popGroupedItemNos[a]);
							insertRecgrp.put("newNoOfPerson", newNoOfPerson);
							System.out.println("insertRecgrpWitem - 0 - "+insertRecgrp);
							this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
							this.getSqlMapClient().executeBatch();
						}
					}
				}
			}	
			
			if (delGroupItemsItemNos != null && delGroupedItemNos != null){
				for (int a = 0; a < delGroupItemsItemNos.length; a++) {
					System.out.println("insertRecgrpWitem - 1 - groupedItemNo: "+delGroupedItemNos[a]);
					Map<String, String> insertRecgrp = new HashMap<String, String>();
					insertRecgrp.put("parId", parId);
					insertRecgrp.put("itemNo", itemNo);
					insertRecgrp.put("lineCd", lineCd);
					insertRecgrp.put("groupedItemNo", delGroupedItemNos[a]);
					insertRecgrp.put("newNoOfPerson", newNoOfPerson);
					this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
					this.getSqlMapClient().executeBatch();
				}
			}
			for(GIPIWItmperlGrouped cov:coverageItems){
				System.out.println("insertRecgrpWitem - 2 - groupedItemNo: "+cov.getGroupedItemNo().toString());
				Map<String, String> insertRecgrp = new HashMap<String, String>();
				insertRecgrp.put("parId", parId);
				insertRecgrp.put("itemNo", itemNo);
				insertRecgrp.put("lineCd", lineCd);
				insertRecgrp.put("groupedItemNo", cov.getGroupedItemNo().toString());
				insertRecgrp.put("newNoOfPerson", newNoOfPerson);
				this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				this.getSqlMapClient().executeBatch();
			}
			for(GIPIWGroupedItems grp:groupedItems){
				System.out.println("insertRecgrpWitem - 3 - groupedItemNo: "+grp.getGroupedItemNo());
				Map<String, String> insertRecgrp = new HashMap<String, String>();
				insertRecgrp.put("parId", parId);
				insertRecgrp.put("itemNo", itemNo);
				insertRecgrp.put("lineCd", lineCd);
				insertRecgrp.put("groupedItemNo", grp.getGroupedItemNo());
				insertRecgrp.put("newNoOfPerson", newNoOfPerson);
				this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> recgrp = new HashMap<String, String>();
			recgrp.put("parId", parId);
			recgrp.put("lineCd", lineCd);
			recgrp.put("itemNo", itemNo);
			this.sqlMapClient.update("insertRecgrpWitemUpload", recgrp);
			this.getSqlMapClient().executeBatch();
			
			//post-form-commit
			Map<String, Object> addParStatus = new HashMap<String, Object>();
			addParStatus.put("parId", Integer.parseInt(parId));
			addParStatus.put("lineCd", lineCd);
			addParStatus.put("issCd", (String) params.get("issCd").toString());
			addParStatus.put("invoiceSw", "N");
			addParStatus.put("itemGrp", null);
			this.sqlMapClient.update("addParStatusNo2", addParStatus);
			this.getSqlMapClient().executeBatch();
			
			Map<String, String> inv = new HashMap<String, String>();
			inv.put("parId", parId.toString());
			inv.put("lineCd", lineCd);
			inv.put("issCd", (String) params.get("issCd").toString());
			inv.put("userId", (String) params.get("userId").toString());
			this.sqlMapClient.update("createInvoiceItemUpload", inv);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			message = "SQL Exception Occured..."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		return message;
	}

	@SuppressWarnings("unchecked")
	//saving grouped items modal for JSON -- angelo
	public String saveGipiWAccidentGroupedItemsModal(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWGroupedItems> setGroupedItems					= (List<GIPIWGroupedItems>) params.get("setGroupedItems");
			List<GIPIWItmperlGrouped> setCoverageItems				= (List<GIPIWItmperlGrouped>) params.get("setCoverageItems");
			List<GIPIWGrpItemsBeneficiary> setBeneficiaryItems 		= (List<GIPIWGrpItemsBeneficiary>) params.get("setBeneficiaryItems");
			List<GIPIWItmperlBeneficiary> setBeneficiaryPerils		= (List<GIPIWItmperlBeneficiary>) params.get("setBeneficiaryPerils");
			
			List<Map<String, Object>> delGroupedItems				= (List<Map<String, Object>>) params.get("delGroupedItems");
			List<Map<String, Object>> delCoverageItems				= (List<Map<String, Object>>) params.get("delCoverageItems");
			List<Map<String, Object>> delBeneficiaryItems			= (List<Map<String, Object>>) params.get("delBeneficiaryItems");
			List<Map<String, Object>> delBeneficiaryPerils			= (List<Map<String, Object>>) params.get("delBeneficiaryPerils");
			
			List<Map<String, Object>> updateGroupedItems			= (List<Map<String, Object>>) params.get("groupedItemsUpdateItems");
			List<Map<String, Object>> updateCoverageItems			= (List<Map<String, Object>>) params.get("coverageUpdateItems");
			
			/*DELETING FROM GROUPED ITEMS TABLES*/
			
			if (delBeneficiaryPerils != null){
				System.out.println("Deleting Beneficiary Perils");
				System.out.println("Par Id\t\tItem No");
				for (Map<String, Object> dbp : delBeneficiaryPerils){
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					System.out.println(dbp.get("parId") + "\t\t" + dbp.get("itemNo"));
					paramsDel.put("parId", dbp.get("parId"));
					paramsDel.put("itemNo", dbp.get("itemNo"));
					System.out.println("Deleting record/s For Beneficiary Perils Modal:");
					this.sqlMapClient.update("delGIPIWItmperlBeneficiary", paramsDel);
				}
			}
			
			if (delBeneficiaryItems != null){
				System.out.println("Deleting Beneficiary Items");
				System.out.println("Par Id\t\tItem No\t\tGrouped Item No\t\tBeneficiary No");
				for (Map<String, Object> dbi : delBeneficiaryItems){
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					System.out.println(dbi.get("parId") + "\t\t" + dbi.get("itemNo") + "\t\t" + dbi.get("groupedItemNo") + "\t\t\t" + dbi.get("beneficiaryNo"));
					paramsDel.put("parId", dbi.get("parId"));
					paramsDel.put("itemNo", dbi.get("itemNo"));
					paramsDel.put("groupedItemNo", dbi.get("groupedItemNo"));
					paramsDel.put("beneficiaryNo", dbi.get("beneficiaryNo"));
					this.sqlMapClient.update("delGIPIWGrpItemsBeneficiary", paramsDel);
				}
			}
			
			if (delCoverageItems != null){
				System.out.println("Deleting Coverage Items");
				System.out.println("Par Id\t\tItem No\t\tGrouped Item No\t\tPeril Cd");
				for (Map<String, Object> dci : delCoverageItems){
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					System.out.println(dci.get("parId") + "\t\t" + dci.get("itemNo") + "\t\t" + dci.get("groupedItemNo") + "\t\t\t" + dci.get("perilCd"));
					paramsDel.put("parId", dci.get("parId"));
					paramsDel.put("itemNo", dci.get("itemNo"));
					paramsDel.put("groupedItemNo", dci.get("groupedItemNo"));
					paramsDel.put("perilCd", dci.get("perilCd"));
					this.sqlMapClient.update("delGIPIWItmperlGrouped", paramsDel);
				}
			}
			
			if (delGroupedItems != null){
				System.out.println("Deleting Grouped Items");
				System.out.println("Par Id\t\tItem No\t\tGrouped Item No");
				for (Map<String, Object> dgi : delGroupedItems){
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					System.out.println(dgi.get("parId") + "\t\t" + dgi.get("itemNo") + "\t\t" + dgi.get("groupedItemNo"));
					paramsDel.put("parId", dgi.get("parId"));
					paramsDel.put("itemNo", dgi.get("itemNo"));
					paramsDel.put("groupedItemNo", dgi.get("groupedItemNo"));
					this.sqlMapClient.update("delGIPIWGrpItemsBeneficiary2", paramsDel);
					this.sqlMapClient.update("delGIPIWItmperlGrouped2", paramsDel);
					this.sqlMapClient.update("delGIPIWGroupedItems2", paramsDel);
				}
			}
			
			/*INSERTING INTO GROUPED ITEM TABLES*/
			
			List<Map<String, Object>> retrievedGroupedItems			= (List<Map<String, Object>>) params.get("groupedItemsForInsert");
			for (Map<String, Object> grpItems : retrievedGroupedItems){
				this.getSqlMapClient().update("insertRetrievedGroupedItems", params);
			}
			
			if (setGroupedItems != null){
				System.out.println("Grouped Items");
				for(GIPIWGroupedItems grp : setGroupedItems){
					System.out.println(grp.getParId() + "\t" + grp.getItemNo() + "\t" + Integer.parseInt(grp.getGroupedItemNo()) + "\t" + grp.getGroupedItemTitle());
					this.getSqlMapClient().insert("setGipiWGroupedItems2", grp);
				}
			}
			
			if (setCoverageItems != null){
				System.out.println("Coverage Items");
				for(GIPIWItmperlGrouped cov : setCoverageItems){
					if (cov.getWcSw().equals("Y")){
						System.out.println("Inserting default values on warranties and clauses: "+cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
						Map<String, String> paramsIns = new HashMap<String, String>();
						paramsIns.put("parId", cov.getParId().toString());
						paramsIns.put("lineCd", cov.getLineCd());
						paramsIns.put("perilCd", cov.getPerilCd());
						this.sqlMapClient.update("preCommitGipis012", paramsIns);
					}
					System.out.println(cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
					this.getSqlMapClient().insert("setGIPIWItmperlGrouped", cov);
				}
			}
			
			if (setBeneficiaryItems != null){
				System.out.println("Beneficiary Items");
				for(GIPIWGrpItemsBeneficiary ben : setBeneficiaryItems){
					System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + Integer.parseInt(ben.getGroupedItemNo()) + "\t" + ben.getBeneficiaryNo());
					this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", ben);
				}
			}
			
			if (setBeneficiaryPerils != null){
				System.out.println("Beneficiary Perils");
				for(GIPIWItmperlBeneficiary per : setBeneficiaryPerils){
					System.out.println(per.getParId() + "\t" + per.getItemNo() + "\t" + Integer.parseInt(per.getGroupedItemNo()) + "\t" + per.getBeneficiaryNo() + "\t" + per.getPerilCd());
					this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", per);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			for(GIPIWGroupedItems grp : setGroupedItems){
				if (grp.getOverwriteBen() != null && grp.getOverwriteBen().equals("Y")){
					System.out.println("Overwrite perils for itemNo: "+ grp.getItemNo()+" ,GroupedItemno: " + Integer.parseInt(grp.getGroupedItemNo()));
					Map<String, String> paramsOverwrite = new HashMap<String, String>();
					paramsOverwrite.put("parId", grp.getParId());
					paramsOverwrite.put("itemNo", grp.getItemNo());
					paramsOverwrite.put("groupedItemNo", grp.getGroupedItemNo());
					paramsOverwrite.put("packBenCd", grp.getPackBenCd());
					paramsOverwrite.put("lineCd", grp.getLineCd());
					this.sqlMapClient.update("populateOverwriteBenefits", paramsOverwrite);
				}
			}

			for (Map<String, Object> grp : updateGroupedItems){
				if (grp.get("popBenefitsSw") != null){
					System.out.println(grp.get("popBenefitsSw")+"-Benefits for groupedItemNo: "+grp.get("groupedItemNo"));
					Map<String, Object> copyBen = new HashMap<String, Object>();
					copyBen.put("parId", grp.get("parId"));
					copyBen.put("itemNo", grp.get("itemNo"));
					copyBen.put("lineCd", grp.get("lineCd"));
					copyBen.put("groupedItemNo", grp.get("groupedItemNo"));
					copyBen.put("benefitSw", grp.get("popBenefitsSw"));
					copyBen.put("origGroupedItemNo", grp.get("popBenefitsGroupedItemNo"));
					copyBen.put("origPackBenCd", grp.get("popBenefitsPackBenCd"));
					this.sqlMapClient.update("copyBenPopulateBen", copyBen);
					
					System.out.println("insertRecgrpWitem - 0 - groupedItemNo: "+grp.get("groupedItemNo"));
					Map<String, Object> insertRecgrp = new HashMap<String, Object>();
					insertRecgrp.put("parId", grp.get("parId"));
					insertRecgrp.put("itemNo", grp.get("itemNo"));
					insertRecgrp.put("lineCd", grp.get("lineCd"));
					insertRecgrp.put("groupedItemNo", grp.get("groupedItemNo"));
					insertRecgrp.put("newNoOfPerson", grp.get("newNoOfPerson"));
					this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				}
			}
			
			/*UPDATING GROUPED ITEM TABLES*/
			
			if (delGroupedItems != null){
				for (Map<String, Object> delGrpItems : delGroupedItems) {
					System.out.println("insertRecgrpWitem - 1 - groupedItemNo: "+delGrpItems.get("groupedItemNo"));
					Map<String, Object> insertRecgrp = new HashMap<String, Object>();
					insertRecgrp.put("parId", delGrpItems.get("parId"));
					insertRecgrp.put("itemNo", delGrpItems.get("itemNo"));
					insertRecgrp.put("lineCd", delGrpItems.get("lineCd"));
					insertRecgrp.put("groupedItemNo", delGrpItems.get("groupedItemNo"));
					insertRecgrp.put("newNoOfPerson", delGrpItems.get("noOfPerson"));
					this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				}
			}
			
			for (Map<String, Object> cov : updateCoverageItems){
				if (cov.get("newNoOfPerson") != null){
					System.out.println("insertRecgrpWitem - 2 - groupedItemNo: " + cov.get("groupedItemNo"));
					Map<String, Object> insertRecgrp = new HashMap<String, Object>();
					insertRecgrp.put("parId", cov.get("parId"));
					insertRecgrp.put("itemNo", cov.get("itemNo"));
					insertRecgrp.put("lineCd", cov.get("lineCd"));
					insertRecgrp.put("groupedItemNo", cov.get("groupedItemNo"));
					insertRecgrp.put("newNoOfPerson", cov.get("newNoOfPerson"));
					this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				} 
			}
			
			for (Map<String, Object> grp : updateGroupedItems){
				if (grp.get("newNoOfPerson") != null){
					System.out.println("insertRecgrpWitem - 3 - groupedItemNo : " + grp.get("groupedItemNo"));
					Map<String, Object> insertRecgrp = new HashMap<String, Object>();
					insertRecgrp.put("parId", grp.get("parId"));
					insertRecgrp.put("itemNo", grp.get("itemNo"));
					insertRecgrp.put("lineCd", grp.get("lineCd"));
					insertRecgrp.put("groupedItemNo", grp.get("groupedItemNo"));
					insertRecgrp.put("newNoOfPerson", grp.get("newNoOfPerson"));
					this.sqlMapClient.update("insertRecgrpWitem", insertRecgrp);
				} 
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			System.out.println("Status : " + message);
		} catch (Exception e){
			message = "SQL Exception Occured..."+e.getCause();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return message;
	}
	
	@Override
	// added additionals functions below.  Created by Irwin
	public GIPIWAccidentItem getEndtGipiWItemAccidentDetails(
			Map<String, Object> params) throws SQLException {
	
			log.info("DAO lineCd: "+params.get("lineCd"));
			log.info("DAO sublineCd: "+params.get("sublineCd"));
			log.info("DAO issCd: "+params.get("issCd"));
			log.info("DAO issueYy: "+params.get("issueYy"));
			log.info("DAO polSeqNo: "+params.get("polSeqNo"));
			log.info("DAO renewNo: "+params.get("renewNo"));
			log.info("DAO itemNo: "+params.get("itemNo"));
			log.info("DAO annTsiAmt: "+params.get("annTsiAmt"));
			log.info("DAO annPremAmt: "+params.get("annPremAmt"));
			
			return (GIPIWAccidentItem) this.sqlMapClient.queryForObject("getEndtGipiWItemAccidentDetails",params);
	
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEndtGipiWItemAccidentDetails2(
			Map<String, Object> params) throws SQLException {
		
		log.info("DAO lineCd: "+params.get("lineCd"));
		log.info("DAO sublineCd: "+params.get("sublineCd"));
		log.info("DAO issCd: "+params.get("issCd"));
		log.info("DAO issueYy: "+params.get("issueYy"));
		log.info("DAO polSeqNo: "+params.get("polSeqNo"));
		log.info("DAO renewNo: "+params.get("renewNo"));
		log.info("DAO itemNo: "+params.get("itemNo"));
		log.info("DAO annTsiAmt: "+params.get("annTsiAmt"));
		log.info("DAO annPremAmt: "+params.get("annPremAmt"));
		
		
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getEndtGipiWItemAccidentDetails2", params);
	}

	@Override
	public String preInsertAccident(Map<String, Object> params)
			throws SQLException {
		log.info("PREINSERT: Validating currency.");
		return (String) this.getSqlMapClient().queryForObject("preInsertAccident", params);
	}

	@Override
	public GIPIWAccidentItem preInsertEndtAccident(Map<String, Object> params)
			throws SQLException {
		log.info("Pre-insert Ent Accident Item.");
		return (GIPIWAccidentItem) this.getSqlMapClient().queryForObject("preInsertEndtAccident", params);
	}

	public void setGipiParItemDAO(GIPIParItemDAO gipiParItemDAO) {
		this.gipiParItemDAO = gipiParItemDAO;
	}

	public GIPIParItemDAO getGipiParItemDAO() {
		return gipiParItemDAO;
	}
	
	@Override
	public String checkUpdateGipiWPolbasValidity(Map<String, Object> params)
			throws SQLException {
		log.info("Checking update GIPIWPolbasic validity...");
		return (String) this.getSqlMapClient().queryForObject("checkGipiWPolbasValidityAcc", params);
	}
	
	public String checkCreateDistributionValidity(Integer parId)
	throws SQLException {
		log.info("Validating distribution...");
		return (String) this.getSqlMapClient().queryForObject("checkCreateDistributionValidityAcc", parId);
	}

	@Override
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException {
		log.info("Validating distribution in reinsurer table...");
		return (String) this.getSqlMapClient().queryForObject("checkGiriDistfrpsExistAcc", parId);
	}

	@Override
	public void changeItemAccGroup(Integer parId) throws SQLException {
		this.getSqlMapClient().queryForObject("changeItemAccGroup", parId);
	}
	
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}
	
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}

	public void insertGIPIWItemAcc(GIPIWAccidentItem itemAcc) throws SQLException{
		/*
		#parId#,#itemNo#,#noOfPersons#,
		#positionCd#,#destination#,#monthlySalary#,
		#salaryGrade#,#dateOfBirth#,#age#,
		#civilStatus#,#height#,#weight#,
		#sex#,#groupPrintSw#,#acClassCd#,
		#levelCd#,#parentLevelCd#
		*/
		
		log.info("parId : " + itemAcc.getParId());
		log.info("itemNo : " + itemAcc.getItemNo());
		log.info("noOfPersons : " + itemAcc.getNoOfPersons());
		log.info("positionCd : " + itemAcc.getPositionCd());
		log.info("destination : " + itemAcc.getDestination());
		log.info("monthlySalary : " + itemAcc.getMonthlySalary());
		log.info("salaryGrade : " + itemAcc.getSalaryGrade());
		log.info("dateOfBirth : " + itemAcc.getDateOfBirth());
		log.info("age : " + itemAcc.getAge());
		log.info("civilStatus : " + itemAcc.getCivilStatus());
		log.info("height : " + itemAcc.getHeight());
		log.info("weight : " + itemAcc.getWeight());
		log.info("sex : " + itemAcc.getSex());
		log.info("groupPrintSw : " + itemAcc.getGroupPrintSw());
		log.info("acClassCd : " + itemAcc.getAcClassCd());
		log.info("levelCd : " + itemAcc.getLevelCd());
		log.info("parentLevelCd : " + itemAcc.getParentLevelCd());
		
		log.info("Inserting accident item information for PAR ID " + itemAcc.getParId() + " ITEM NO. " + itemAcc.getItemNo());
		this.getSqlMapClient().update("setGipiWAccidentItems", itemAcc);
		log.info("Insert successful.");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveGIPIEndtAccidentItemModal(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String saveGIPIEndtAccidentItemModal(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		
		List<GIPIWGroupedItems> groupedItems = (List<GIPIWGroupedItems>) params.get("groupedItems");
		List<GIPIWItmperlGrouped> coverageItems = (List<GIPIWItmperlGrouped>) params.get("coverageItems");
		List<GIPIWGrpItemsBeneficiary> beneficiaryItems = (List<GIPIWGrpItemsBeneficiary>) params.get("beneficiaryItems");
		List<GIPIWItmperlBeneficiary> beneficiaryPerils = (List<GIPIWItmperlBeneficiary>) params.get("beneficiaryPerils");
		
		String popBenefitsSw = (String) params.get("popBenefitsSw");
		String popBenefitsGroupedItemNo = (String) params.get("popBenefitsGroupedItemNo");
		String popBenefitsPackBenCd = (String) params.get("popBenefitsPackBenCd");
		
		String[] delGroupItemsItemNos = (String[]) params.get("delGroupItemsItemNos");
		String[] delGroupedItemNos = (String[]) params.get("delGroupedItemNos");

		String[] delBenPerilGroupedItemNos = (String[]) params.get("delBenPerilGroupedItemNos");
		String[] delBenPerilBeneficiaryNos = (String[]) params.get("delBenPerilBeneficiaryNos");
		String[] delBenefitGroupedItemNos = (String[]) params.get("delBenefitGroupedItemNos");
		String[] delBenefitBeneficiaryNos = (String[]) params.get("delBenefitBeneficiaryNos");
		
		String[] delCoverageGroupedItemNos = (String[]) params.get("delCoverageGroupedItemNos");
		String[] delCoveragePerilCds = (String[]) params.get("delCoveragePerilCds");
		
		String[] popParIds = (String[]) params.get("popParIds");
		String[] popItemNos = (String[]) params.get("popItemNos");
		String[] popGroupedItemNos = (String[]) params.get("popGroupedItemNos");
		String[] popGroupedItemTitles = (String[]) params.get("popGroupedItemTitles");
		String popCheckSw = (String) params.get("popCheckSw");
		
		System.out.println(popBenefitsSw + " - popBenefitsSw");
		
		return message;
	}
	
	public String checkRetrieveGroupedItems(Map<String, Object> params) throws SQLException{
		String message = "";
		message = (String) this.getSqlMapClient().queryForObject("checkRetrieveGroupedItems", params);
		return message;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#retrieveGroupedItems(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> retrieveGroupedItems(Map<String, Object> params)
			throws SQLException {
		log.info("Retrieving grouped items ...");
		
		try{
			List<GIPIWGroupedItems> setGroupedItems = (List<GIPIWGroupedItems>) params.get("setGroupedItems");
			List<Map<String, Object>> delGroupedItems = (List<Map<String, Object>>) params.get("delGroupedItems");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// delete (GIPI_WGROUPED_ITEMS)
			for(Map<String, Object> delMap : delGroupedItems){
				log.info("Deleting record on gipi_wgrouped_items ...");
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			
			// insert/update (GIPI_WGROUPED_ITEMS)
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				log.info("Inserting/Updating record on gipi_wgrouped_items ...");
				this.getSqlMapClient().insert("setGipiWGroupedItems2", groupItem);
			}
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().queryForList("gipis065RetrieveGroupedItems", params);
			log.info("Retrieving grouped items complete ...");
			
			this.getSqlMapClient().getCurrentConnection().rollback();
			
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}		 
	}
	
	public void insertRetrieveGroupedItems(List<GIPIWGroupedItems> retGrpItems){
		/*GIPI_WGROUPED_ITEMS_PKG.insert_retrieved_grouped_items(#parId#, #lineCd#, #sublineCd#, #issCd#,
						 #issueYy#, #polSeqNo#, #renewNo#, #itemNo#,
						 #effDate#, #groupedItemNo#, #groupedItemTitle#, #controlCd#,
						 #controlTypeCd#);*/
		
		for (GIPIWGroupedItems grpItem : retGrpItems){
			Map<String, Object> insertParams = new HashMap<String, Object>();
			insertParams.put("parId", grpItem.getParId());
			insertParams.put("lineCd", grpItem.getLineCd());
			insertParams.put("sublineCd", grpItem.getSublineCd());
			//insertParams.put("issCd", grpItem.get)
		}
	}

	public void insertRetrievedGroupedItems(Map<String, Object> params)
		throws SQLException{
		String[] groupedItemNos = (String[]) params.get("groupedItemNos");
		String[] groupedItemTitles = (String[]) params.get("groupedItemTitles");
		//String[] groupedControlCds = (String[]) params.get("groupedControlCds");
		String[] groupedControlTypeCds = (String[]) params.get("groupedControlTypeCds");
		
		for (int x = 0; x < groupedItemNos.length; x++){
			params.put("groupedItemNo", groupedItemNos[x]);
			if (groupedItemTitles != null){
				params.put("groupedItemTitle", groupedItemTitles[x] == null ? "" : groupedItemTitles[x]);
			}
			
			/*
			if (groupedControlCds != null){
				params.put("groupedControlCd", groupedControlCds[x] == null ? "" : groupedControlCds[x]);
			}
			*/
			
			if (groupedControlTypeCds != null){
				params.put("groupedControlTypeCd", groupedControlTypeCds[x] == null ? "" : groupedControlTypeCds[x]);
			}
			
			params.put("groupedControlCd", "");
			
			System.out.println("Inserting groupedItemNo : " + params.get("groupedItemNo"));
			
			this.getSqlMapClient().update("insertRetrievedGroupedItems", params);
		}
		
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveAccidentItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveAccidentItem(Map<String, Object> params)
			throws SQLException {
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");		
		boolean success = false;
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();	
			
			// delete records on GIPI_WITEM			
			if((String[]) delItemMap.get("delItemNos") != null){
				this.itemMcDAO.deleteItem(params);							
			}	
			
			// insert/update records on GIPI_WITEM			
			if(((List<GIPIWItem>) params.get("itemList")).size() > 0){				
				if(!(insertUpdateItem(params))){					
					throw new SQLException();
				}
			}
			
			List<GIPIWBeneficiary> beneficiaryItems = (List<GIPIWBeneficiary>) params.get("beneficiaryItems");
			String[] delBeneficiaryItemNos	= (String[]) params.get("delBeneficiaryItemNos");
			String[] delBeneficiaryNos		= (String[]) params.get("delBeneficiaryNos");
			String parId 					= (String) params.get("parId").toString();
			
			if (delBeneficiaryItemNos != null && delBeneficiaryNos != null){
				for (int a = 0; a < delBeneficiaryItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delBeneficiaryItemNos[a]);
					paramsDel.put("beneficiaryNo", delBeneficiaryNos[a]);
					System.out.println("Deleting record in GIPI_WBENEFICIARY for item no.: /"+delBeneficiaryItemNos[a]+"/ beneficiaryNo: /"+delBeneficiaryNos[a]);
					this.sqlMapClient.update("delGIPIWBeneficiary2", paramsDel);
				}
			}
			
			System.out.println("Saving record/s For Beneficiary Information:");
			System.out.println("ParID\tItemNo\tBeneficiaryNo\tBeneficiaryName");
			System.out.println("=======================================================================================");
			for(GIPIWBeneficiary ben:beneficiaryItems){
				System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + ben.getBeneficiaryNo() + "\t" + ben.getBeneficiaryName());
				this.getSqlMapClient().insert("setGIPIWBeneficiary", ben);
			}
			System.out.println("=======================================================================================");
			
			// insert, update, delete item deductibles
			if((params.get("deductibleInsList") != null && ((List<GIPIWDeductible>) params.get("deductibleInsList")).size() > 0) ||
				(params.get("deductibleDelList") != null && ((List<Map<String, Object>>) params.get("deductibleDelList")).size() > 0)){				
				this.itemMcDAO.updateDeductibleRecords(params, 2);
			}
			
			// insert, update, delete item peril
			/*if((params.get("itemPerilInsList") != null && ((List<GIPIWItemPeril>) params.get("itemPerilInsList")).size() > 0) ||
				(params.get("itemPerilDelList") != null && ((List<Map<String, Object>>) params.get("itemPerilDelList")).size() > 0)){				
				this.itemMcDAO.updateItemPerilRecords(params);
			}*/
			Map<String, Object> others = (Map<String, Object>) params.get("others");
			if((params.get(/*"itemPerilInsList"*/"perilInsList") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilInsList"*/"perilInsList")).size() > 0) ||
				(params.get(/*"itemPerilDelList"*/"perilDelList") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilDelList"*/"perilDelList")).size() > 0) ||
				("Y".equals(others.get("delDiscSw")))){				
				this.itemMcDAO.updateItemPerilRecords(params);
			}
			
			// insert, update, delete peril deductibles
			if((params.get("perilDedInsList") != null && ((List<GIPIWDeductible>) params.get("perilDedInsList")).size() > 0) ||
				(params.get("perilDedDelList") != null && ((List<Map<String, Object>>) params.get("perilDedDelList")).size() > 0)){				
				this.itemMcDAO.updateDeductibleRecords(params, 3);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();			
		}catch(Exception e){
			e.printStackTrace();	
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
			success = true;
		}
		return success;
	}

	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	private boolean insertUpdateItem(Map<String, Object> params) throws SQLException {
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		List<GIPIWAccidentItem> accidentItems = (List<GIPIWAccidentItem>) params.get("accidentItems");
		
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
		
		boolean result = true;		
		int index = 0;
		
		// check if policy deductibles should be deleted
		if("Y".equals(others.get("deletePolicyDeductible"))){
			log.info("Deleting policy deductibles ...");
			Map<String, Object> delPolDedMap = new HashMap<String, Object>();
			delPolDedMap.put("parId", gipiParList.getParId());
			delPolDedMap.put("lineCd", gipiParList.getLineCd());
			delPolDedMap.put("sublineCd", gipiParList.getSublineCd());			
			this.getSqlMapClient().queryForObject("deletePolDeductibles", delPolDedMap);
			delPolDedMap = null;			
		}
				
		log.info("Item Saving - Deleting discount ...");
		this.getSqlMapClient().queryForObject("deleteDiscount", params.get("parId"));
		vars.put("varInsertDeleteSw", "Y");
		others.put("nbtInvoiceSw", "Y");				
		
		for(GIPIWItem item : itemList){
			Map<String, Object> itemGrpMap = new HashMap<String, Object>();
			itemGrpMap.put("parId", item.getParId());
			itemGrpMap.put("packPolFlag", globals.get("globalPackPolFlag"));
			itemGrpMap.put("currencyCd", item.getCurrencyCd());
			
			if(("".equals((String) vars.get("varPost"))) && "Y".equals((String) others.get("nbtInvoiceSw"))){
				this.getSqlMapClient().queryForObject("changeItemGroup2", itemGrpMap);
				item.setItemGrp((Integer) itemGrpMap.get("itemGrp"));
				pars.put("parDDLCommit", "Y");
			}
			
			if("Y".equals((String) vars.get("varGroupSw"))){
				this.getSqlMapClient().queryForObject("changeItemGroup2", itemGrpMap);
			}
			
			log.info("Item Saving (parId=" + item.getParId() + ", itemNo=" + item.getItemNo()+ ")- Saving record on gipi_witem ...");
			this.getSqlMapClient().insert("setGIPIParItem", item);
			
			if(accidentItems.size() > index){				
				if(Integer.parseInt(accidentItems.get(index).getItemNo()) == item.getItemNo()){
					if (accidentItems.get(index).getDelGrpItemsInItems().equals("Y")){
						Map<String, String> paramsDel = new HashMap<String, String>();
						paramsDel.put("parId", accidentItems.get(index).getParId());
						paramsDel.put("itemNo", accidentItems.get(index).getItemNo());
						System.out.println("Deleting Grouped Items Information first for itemNo: "+accidentItems.get(index).getItemNo());
						this.sqlMapClient.update("delGIPIWGroupedItemsPerItem", paramsDel);
					}
					
					log.info("Item (Saving)- Saving record on accident ...");
					this.getSqlMapClient().insert("setGipiWAccidentItems", accidentItems.get(index));						
					
					if (accidentItems.get(index).getPopulatePerils().equals("Y")){
						System.out.println("Overwrite perils for itemNo: "+ accidentItems.get(index).getItemNo());
						Map<String, String> paramsOverwrite = new HashMap<String, String>();
						paramsOverwrite.put("parId", accidentItems.get(index).getParId());
						paramsOverwrite.put("itemNo", accidentItems.get(index).getItemNo());
						this.sqlMapClient.update("populateOverwriteBenefits2", paramsOverwrite);
					}
					if (accidentItems.get(index).getAccidentDeleteBills().equals("Y")){
						System.out.println("Deleting Bill for itemNo : "+ accidentItems.get(index).getItemNo());
						Map<String, Object> paramsDelBill = new HashMap<String, Object>();
						paramsDelBill.put("parId", accidentItems.get(index).getParId());
						paramsDelBill.put("itemNo", accidentItems.get(index).getItemNo());
						paramsDelBill.put("premAmt", accidentItems.get(index).getPremAmt());
						paramsDelBill.put("annPremAmt", accidentItems.get(index).getAnnPremAmt());
						paramsDelBill.put("tsiAmt", accidentItems.get(index).getTsiAmt());
						paramsDelBill.put("annTsiAmt", accidentItems.get(index).getAnnTsiAmt());
						this.sqlMapClient.update("deleteBillAccidentItem", paramsDelBill);
					}
					index++;					
				}							
			}
			
			params.put("itemGrp", item.getItemGrp());
			params.put("vars", vars);
			params.put("pars", pars);
			params.put("others", others);
			
			if(!(postFormsCommit(params))){
				result = false;
				break;
			}			
		}		
		
		return result;
	}

	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	private boolean postFormsCommit(Map<String, Object> params) throws SQLException {
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");					
		
		if("N".equals((String) vars.get("varPost2"))){
			return false;
		}
		
		// insert record to GIPI_PARHIST
		if("".equals((String) vars.get("varPost"))){
			Map<String, Object> parhistMap = new HashMap<String, Object>();
			parhistMap.put("parId", params.get("parId"));
			parhistMap.put("userId", params.get("userId"));
			log.info("Item (Post Form Commit)- Inserting record to parhist ...");
			this.getSqlMapClient().queryForObject("insertParhist", parhistMap);				
		}
		
		if(("".equals((String) vars.get("varPost"))) && "Y".equals((String) others.get("nbtInvoiceSw"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			// delete co_insurer
			log.info("Item (Post Form Commit)- Deleting co_insurer ...");
			
			this.getSqlMapClient().queryForObject("deleteCoInsurer", params.get("parId"));
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packPolFlag", gipiParList.getPackPolFlag());			
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
			pars.put("parDDLCommit", "Y");
			paramMap.clear();
			
			// delete_bill
			log.info("Item (Post Form Commit)- Deleting bill ...");
			this.getSqlMapClient().queryForObject("deleteBillOnItem", Integer.parseInt(globals.get("globalParId").toString()));
			
			// add_par_status_no			
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("lineCd", gipiParList.getLineCd());
			paramMap.put("issCd", gipiParList.getIssCd());
			paramMap.put("invoiceSw", (String) others.get("nbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp") != null ? params.get("itemGrp").toString() : null);

			log.info("Item (Post Form Commit)- Adding par_status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			paramMap.clear();
			
			// update gipi_wpolbas no_of_item
			log.info("Item (Post Form Commit)- Updating gipi_wpolbas no_of_item ...");
			this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem", gipiParList.getParId());
			paramMap = null;
		}else if("".equals((String) vars.get("varPost"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			// add_par_status_no
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("lineCd", gipiParList.getLineCd());
			paramMap.put("issCd", gipiParList.getIssCd());
			paramMap.put("invoiceSw", others.get("nbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp") != null ? params.get("itemGrp").toString() : null);
			
			log.info("Item (Post Form Commit)- Adding par_status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			paramMap = null;
		}
		if("Y".equals((String) vars.get("varGroupSw"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packPolFlag", gipiParList.getPackPolFlag());
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
		}
		// check_additional_info
		Map<String, Object> paramMap = new HashMap<String, Object>();
		//paramMap.put("parId", gipiParList.getParId());
		///paramMap.put("parStatus", gipiParList.getParStatus());
		//log.info("Item (Post Form Commit)- Checking additional accident info ...");
		//this.getSqlMapClient().update("checkAdditionalInfoAH", paramMap);
		//paramMap.clear();
		
		paramMap.put("parId", gipiParList.getParId());
		paramMap.put("packLineCd", globals.get("globalPackLineCd"));
		paramMap.put("packSublineCd", globals.get("globalPackSublineCd"));
		
		log.info("Item (Post Form Commit)- Updating gipi_wpacksubline ...");
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSubline", paramMap);
		paramMap = null;
		
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#retGrpItmsGipiWGroupedItems(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWGroupedItems> retGrpItmsGipiWGroupedItems(Map<String, Object> params) throws SQLException{
		List<Integer> groupedItemNos = (List<Integer>) params.get("groupedItemNos");
		List<GIPIWGroupedItems> gipiwGroupedItems = new ArrayList<GIPIWGroupedItems>();
		
		for (Integer i : groupedItemNos){
			params.put("groupedItemNo", i);
			gipiwGroupedItems.add((GIPIWGroupedItems) this.getSqlMapClient().queryForObject("retGrpItmsGipiWGroupedItems", params));
		}
		return gipiwGroupedItems;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#retGrpItmsGipiWItmperlGrouped(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIWItmperlGrouped> retGrpItmsGipiWItmperlGrouped(Map<String, Object> params) throws SQLException{
		List<Integer> groupedItemNos = (List<Integer>) params.get("groupedItemNos");
		List<GIPIWItmperlGrouped> gipiwItmperlGrouped = new ArrayList<GIPIWItmperlGrouped>();
		
		for (Integer i : groupedItemNos){
			params.put("groupedItemNo", i);
			gipiwItmperlGrouped.add((GIPIWItmperlGrouped) this.getSqlMapClient().queryForObject("retGrpItmsGipiWItmperlGrouped", params));
		}
		
		return gipiwItmperlGrouped;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#gipis012NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis012NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("DAO - New form instance (GIPIS012)...");
		this.getSqlMapClient().queryForObject("gipis012NewFormInstance", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveGIPIWAccidentItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWAccidentItem(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Accident Items... ");
		try {
			List<Map<String, Object>> setItems = (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems = (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWAccidentItem> accidentItems = (List<GIPIWAccidentItem>) params.get("accidentItems");
			
			List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductRows");
			
			List<GIPIWBeneficiary> setBeneficiaries 		= (List<GIPIWBeneficiary>) params.get("setBeneficiaries");
			List<Map<String, Object>> delBeneficiaries 		= (List<Map<String, Object>>) params.get("delBeneficiaries");			
			List<GIPIWGroupedItems> setGroupedItems 		= (List<GIPIWGroupedItems>) params.get("setGrpItmRows");
			List<Map<String, Object>> delGroupedItems		= (List<Map<String, Object>>) params.get("delGrpItmRows");			
			List<GIPIWGrpItemsBeneficiary> setGrpItmBens	= (List<GIPIWGrpItemsBeneficiary>) params.get("setGrpItmBenRows");
			List<Map<String, Object>> delGrpItmBens			= (List<Map<String, Object>>) params.get("delGrpItmBenRows");
			
			GIPIWPolbas gipiWPolbas						= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc								= (JSONObject) params.get("misc");
			//JSONArray newItemNos						= (JSONArray) params.get("newItemNos");			
			//JSONArray oldItemNos						= (JSONArray) params.get("oldItemNos");
			Map<String, Object> grpItems				= (Map<String, Object>) params.get("renumberedGroupedItems");

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap = null;
			
			if("Y".equals(misc.getString("miscDeletePolicyDeductibles"))){
				paramMap = new HashMap<String, Object>();
				paramMap.put("parId", gipiWPolbas.getParId());
				paramMap.put("lineCd", gipiWPolbas.getLineCd());
				paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
				
				log.info("Deleting policy deductibles ...");
				this.getSqlMapClient().queryForObject("delPolDed", paramMap);
			}
			
			// delete discounts
			if("Y".equals(misc.getString("miscDeletePerilDiscById"))){
				log.info("Deleting peril discount ...");
				this.getSqlMapClient().delete("deleteGIPIWPerilDiscount", gipiWPolbas.getParId());
			}
			
			if("Y".equals(misc.getString("miscDeleteItemDiscById"))){
				log.info("Deleting item discount ...");
				this.getSqlMapClient().delete("deleteGIPIWItemDiscount", gipiWPolbas.getParId());
			}
			
			if("Y".equals(misc.getString("miscDeletePolbasDiscById"))){
				log.info("Deleting polbas discount ...");
				this.getSqlMapClient().delete("deleteGIPIWPolbasDiscount", gipiWPolbas.getParId());
				
				//gipiWPolbas.setDiscountSw("N");
				log.info("Updating gipi_wpolbas (discount_sw) ...");
				//this.getSqlMapClient().update("saveGipiWPolbas", gipiWPolbas);
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", gipiWPolbas.getParId());
				param.put("discountSw", "N");
				this.getSqlMapClient().queryForObject("updateDiscountSw", param);
				param.put("surchargeSw", "N"); 
				this.getSqlMapClient().queryForObject("updateSurchargeSw", param); // added by andrew - 02.08.2012
			}
			
			// delete grouped
			for(Map<String, Object> item : delItems){				
				this.getSqlMapClient().delete("delGIPIWGroupedItemsPerItem", item);
			}
			this.getSqlMapClient().executeBatch();
			
			// GIPI_WITEM (delete)
			for(Map<String, Object> item : delItems){				
				log.info("Deleting record on gipi_witem ...");
				
				// get item attachments
				List<String> attachments = this.getSqlMapClient().queryForList("getItemAttachments", item);
				
				this.getSqlMapClient().delete("delGIPIWItem", item);

				// delete attachments
				FileUtil.deleteFiles(attachments);
			}
			
			System.out.println("here: "+setItems);
			// GIPI_WITEM (insert/update)
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
				
				params.put("itemGrp", item.get("itemGrp"));
				
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscChangeNoOfPerson"))){					
					log.info("Changing number of persons ...");
					this.getSqlMapClient().queryForObject("changeNoOfPersons", item);
				}
				
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscDeleteBill"))){
					log.info("Deleting bill ...");
					this.getSqlMapClient().update("deleteBillAccidentItem", item);
				}
				
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscPlanPopulateBenefits"))){
					log.info("Populating benefits through update of pack_ben_cd ...");
					this.getSqlMapClient().update("populateOverwriteBenefits2", item);
					this.getSqlMapClient().executeBatch();
					
					log.info("Inserting records from grouped tables(witemperil_grouped, wgrouped_items) to witemperil and witem");
					item.put("lineCd", gipiWPolbas.getLineCd());
					this.getSqlMapClient().update("insertRecgrpWitem2", item);
					this.getSqlMapClient().executeBatch();
				}
				
				this.getSqlMapClient().executeBatch();
			}
			
			// GIPI_WACCIDENT_ITEM (insert/update)
			for(GIPIWAccidentItem ac : accidentItems) {
				log.info("Inserting to GIPI_WACCIDENT_ITEM...");
				ac.getItemGrp();
				ac.setHeight(StringEscapeUtils.unescapeHtml(ac.getHeight())); // SR-23642 JET JAN-16-2017
				
				if("Y".equals(ac.getChangeNOP())){
					log.info("Deleting Group Items...");
					HashMap<String, Object> acParams = new HashMap<String, Object>();
					acParams.put("parId", ac.getParId());
					acParams.put("itemNo", ac.getItemNo());
					this.getSqlMapClient().queryForObject("changeNoOfPersons", acParams);
				}
				
				this.getSqlMapClient().insert("setGipiWAccidentItems", ac);
			}
			
			// delete beneficiary
			if(delBeneficiaries != null) {
				for(Map<String, Object> b: delBeneficiaries) {
					log.info("Deleting beneficiaries for item no. "+b.get("itemNo"));
					Map<String, Object> dBI = new HashMap<String, Object>();
					dBI.put("parId", b.get("parId"));
					dBI.put("itemNo", b.get("itemNo"));
					dBI.put("beneficiaryNo", b.get("beneficiaryNo"));
					this.getSqlMapClient().update("delGIPIWBeneficiary2", dBI);
				}
			}
			
			for(GIPIWBeneficiary ben : setBeneficiaries) {
				log.info("Inserting beneficaries for item no. "+ben.getItemNo());
				this.getSqlMapClient().insert("setGIPIWBeneficiary", ben);
			}
			
			// GIPI_WDEDUCTIBLES (delete)
			for(GIPIWDeductible ded : delDeductibles){
				log.info("Deleting record on gipi_wdeductibles ...");
				this.getSqlMapClient().delete("delGipiWDeductible2", ded);
			}
			
			// GIPI_WDEDUCTIBLES (insert/update)
			for(GIPIWDeductible ded : insDeductibles){
				log.info("Inserting/Updating record on gipi_wdeductibles ...");
				this.getSqlMapClient().insert("saveWDeductible", ded);			
			}
			
			// insert/update (GIPI_WGROUPED_ITEMS)
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				log.info("Inserting/Updating record on gipi_wgrouped_items ...");
				this.getSqlMapClient().insert("setGipiWGroupedItems2", groupItem);
			}			

			// insert/update (GIPI_WGRP_ITEMS_BENEFICIARY)
			for(GIPIWGrpItemsBeneficiary grpItemBen : setGrpItmBens){
				log.info("Inserting/Updating record on gipi_wgrp_items_beneficiary ...");
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", grpItemBen);
			}			
			
			this.getSqlMapClient().executeBatch();			
			
			if(params.get("parType").toString().equals("E")) {
				this.getGipiWItemDAO().endtItemPostFormsCommit(params);
				// insert, update, delete item peril
				if((params.get("setPerils") != null && ((List<GIPIWItemPeril>) params.get("setPerils")).size() > 0) ||
						(params.get("delPerils") != null && ((List<GIPIWItemPeril>) params.get("delPerils")).size() > 0) ||
						("Y".equals(params.get("delDiscSw")))){	
						this.getGipiWItemPerilDAO().saveGIPIWItemPeril(params);
						this.getSqlMapClient().executeBatch();
						this.getGipiWItemPerilDAO().endtItemPerilPostFormsCommit(params);
					} 
			} else {
				this.getGipiWItemDAO().parItemPostFormsCommit(params);				
				// insert, update, delete item peril
				if((params.get("setPerils") != null && ((List<GIPIWItemPeril>) params.get("setPerils")).size() > 0) ||
					(params.get("delPerils") != null && ((List<GIPIWItemPeril>) params.get("delPerils")).size() > 0) ||
					("Y".equals(params.get("delDiscSw")))){	
					log.info("entered updateItemPerilRecords");
					this.getGipiWItemPerilDAO().updateItemPerilRecords(params);
					this.getSqlMapClient().executeBatch();
					this.getGipiWItemPerilDAO().parItemPerilPostFormsCommit(params);
				}
			}			
			
			System.out.println("HERE ROLLBACK");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();

			//Save Renumbered Grouped Items
			if(grpItems != null) {
				log.info("Saving renumbered grouped items...");
				this.saveRenumberedGrpItems(grpItems);
			}
		} catch(SQLException e){
			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			log.info(e.getErrorCode());
			
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 
	 * @param param
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public void saveRenumberedGrpItems(Map<String, Object> param) throws SQLException {
		try {
			List<GIPIWGroupedItems> grpItems = (List<GIPIWGroupedItems>) param.get("groupedItems");
			List<GIPIWItmperlGrouped> grpItmPerils = (List<GIPIWItmperlGrouped>) param.get("groupedItmPerils");
			List<GIPIWGrpItemsBeneficiary> grpBenItems = (List<GIPIWGrpItemsBeneficiary>) param.get("groupedBeneficiaries");
			List<GIPIWItmperlBeneficiary> grpBenPerils = (List<GIPIWItmperlBeneficiary>) param.get("groupedBenPerils");
			
			//this.getSqlMapClient().startTransaction();
			//this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for(GIPIWGroupedItems grp:grpItems){
				System.out.println(grp.getParId() + "\t" + grp.getItemNo() + "\t" + Integer.parseInt(grp.getGroupedItemNo()) + "\t" + grp.getGroupedItemTitle());
				this.getSqlMapClient().insert("setGipiWGroupedItems2", grp);
			}


			for(GIPIWItmperlGrouped cov:grpItmPerils){
				if (cov.getWcSw().equals("Y")){
					System.out.println("Inserting default values on warranties and clauses: "+cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
					Map<String, String> paramsIns = new HashMap<String, String>();
					paramsIns.put("parId", cov.getParId().toString());
					paramsIns.put("lineCd", cov.getLineCd());
					paramsIns.put("perilCd", cov.getPerilCd());
					this.sqlMapClient.update("preCommitGipis012", paramsIns);
				}
				System.out.println(cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
				this.getSqlMapClient().insert("setGIPIWItmperlGrouped", cov);
			}

			
			for(GIPIWGrpItemsBeneficiary ben:grpBenItems){
				System.out.println(ben.getParId() + "\t" + ben.getItemNo() + "\t" + Integer.parseInt(ben.getGroupedItemNo()) + "\t" + ben.getBeneficiaryNo());
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", ben);
			}

			for(GIPIWItmperlBeneficiary per:grpBenPerils){
				System.out.println(per.getParId() + "\t" + per.getItemNo() + "\t" + Integer.parseInt(per.getGroupedItemNo()) + "\t" + per.getBeneficiaryNo() + "\t" + per.getPerilCd());
				this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", per);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			//this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#gipis065NewFormInstance(java.util.Map)
	 */
	@Override
	public void gipis065NewFormInstance(Map<String, Object> params)
			throws SQLException {
		log.info("Getting GIPIS065 New Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis065NewFormInstance", params);		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#saveEndtACGroupedItemsModal(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtACGroupedItemsModal(Map<String, Object> params)
			throws SQLException {
		try{
			List<Map<String, Object>> setItems				= (List<Map<String, Object>>) params.get("setItemRows");
			List<GIPIWGroupedItems> setGroupedItems 		= (List<GIPIWGroupedItems>) params.get("setGroupedItems");
			List<Map<String, Object>> delGroupedItems		= (List<Map<String, Object>>) params.get("delGroupedItems");
			List<GIPIWItmperlGrouped> setCoverages			= (List<GIPIWItmperlGrouped>) params.get("setCoverages");
			List<Map<String, Object>> delCoverages			= (List<Map<String, Object>>) params.get("delCoverages");
			List<GIPIWGrpItemsBeneficiary> setBeneficiaries	= (List<GIPIWGrpItemsBeneficiary>) params.get("setBeneficiaries");
			List<Map<String, Object>> delBeneficiaries		= (List<Map<String, Object>>) params.get("delBeneficiaries");
			List<GIPIWItmperlBeneficiary> setBenPerils		= (List<GIPIWItmperlBeneficiary>) params.get("setBenPerils");
			List<Map<String, Object>> delBenPerils			= (List<Map<String, Object>>) params.get("delBenPerils");
			Debug.print("saveEndtACGroupedItemsModal coverages ::: "+setCoverages+"; \n"+delCoverages);
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// GIPI_WITEM (insert/update)
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
			}
			this.getSqlMapClient().executeBatch();
			
			// delete (GIPI_WITMPERL_BENEFICIARY)
			for(Map<String, Object> delMap : delBenPerils){
				log.info("Deleting record on gipi_witmperl_beneficiary ...");
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiary", delMap);
			}
			this.getSqlMapClient().executeBatch();
			
			// delete (GIPI_WGRP_ITEMS_BENEFICIARY)
			for(Map<String, Object> delMap : delBeneficiaries){
				log.info("Deleting record on gipi_wgrp_items_beneficiary ...");
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary", delMap);
			}
			this.getSqlMapClient().executeBatch();
			
			// delete (GIPI_WITMPERL_GROUPED)
			for(Map<String, Object> delMap : delCoverages){
				log.info("Deleting record on gipi_witmperl_grouped ...");
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped", delMap);				
			}
			this.getSqlMapClient().executeBatch();
			
			// delete (GIPI_WGROUPED_ITEMS)
			for(Map<String, Object> delMap : delGroupedItems){
				log.info("Deleting record on gipi_wgrouped_items ...");
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			this.getSqlMapClient().executeBatch();
			
			// insert/update (GIPI_WGROUPED_ITEMS)
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				log.info("Inserting/Updating record on gipi_wgrouped_items ...");
				this.getSqlMapClient().insert("setGipiWGroupedItems2", groupItem);
			}
			this.getSqlMapClient().executeBatch();
			
			// insert/update (GIPI_WITMPERL_GROUPED)
			log.info("Inserting/Updating record on gipi_witmperl_grouped... ");
			for(GIPIWItmperlGrouped cov : setCoverages){
				if(cov.getWcSw() != null){
					if (cov.getWcSw().equals("Y")){ // andrew - 01.12.2012 - to insert the default warranties and clauses
						System.out.println("Test: "+cov.getWcSw());
						System.out.println("Inserting default values on warranties and clauses: "+cov.getParId() + "\t" + cov.getItemNo() + "\t" + cov.getGroupedItemNo() + "\t" + cov.getPerilCd());
						Map<String, String> paramsIns = new HashMap<String, String>();
						paramsIns.put("parId", cov.getParId().toString());
						paramsIns.put("lineCd", cov.getLineCd());
						paramsIns.put("perilCd", cov.getPerilCd());
						this.sqlMapClient.update("preCommitGipis012", paramsIns);
						this.getSqlMapClient().executeBatch();
					}
				}
				
				this.getSqlMapClient().update("setGIPIWItmperlGrouped", cov);
			}
			this.getSqlMapClient().executeBatch();
			
			// insert/update (GIPI_WGRP_ITEMS_BENEFICIARY)
			for(GIPIWGrpItemsBeneficiary ben : setBeneficiaries){
				log.info("Inserting/Updating record on gipi_wgrp_items_beneficiary ...");
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", ben);
			}
			this.getSqlMapClient().executeBatch();
			
			// insert/update (GIPI_WITMPERL_BENEFICIARY)
			for(GIPIWItmperlBeneficiary ben : setBenPerils){
				log.info("Inserting/Updating record on gipi_witmperl_beneficiary ...");
				this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", ben);
			}
			
			this.getSqlMapClient().executeBatch();
			//added this line to update gipi_witem when grouped items are deleted
			for(Map<String, Object> delMap : delGroupedItems){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", (Integer) delMap.get("parId"));
				param.put("itemNo", (Integer) delMap.get("itemNo"));
				this.getSqlMapClient().update("gipis065InsertRecGrpWItem", param);		
			}
			this.getSqlMapClient().executeBatch();
			
			// d.alcantara, added codes to update perils when adding/deleting coverages
			for(Map<String, Object> delMap : delCoverages){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", (Integer) delMap.get("parId"));
				param.put("itemNo", (Integer) delMap.get("itemNo"));
				this.getSqlMapClient().update("gipis065InsertRecGrpWItem", param);		
				break;
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWItmperlGrouped setMap : setCoverages){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", (Integer) setMap.getParId());
				param.put("itemNo", (Integer) setMap.getItemNo());
				this.getSqlMapClient().update("gipis065InsertRecGrpWItem", param);		
				break;
			}
			this.getSqlMapClient().executeBatch();
			
			//added this line to update gipi_witem when grouped items are deleted
			for(Map<String, Object> delMap : delGroupedItems){
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", (Integer) delMap.get("parId"));
				param.put("itemNo", (Integer) delMap.get("itemNo"));
				this.getSqlMapClient().update("gipis065InsertRecGrpWItem", param);		
				break;
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				log.info("Checking record on gipi_wgrouped_items for delete...");
				//if(groupItem.getDeleteSw().equals("Y")){ // andrew - 01.11.2012 - comment out
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("parId", Integer.parseInt(groupItem.getParId()));
				param.put("itemNo", Integer.parseInt(groupItem.getItemNo()));
				
				System.out.println("Inserting record group witem ..."+param);
				this.getSqlMapClient().update("gipis065InsertRecGrpWItem", param);	
				break;
				//}
			}
			this.getSqlMapClient().executeBatch();
			
			System.out.println("Test coverages #::: "+(setCoverages.size()+delCoverages.size()));
			if((setCoverages.size()+delCoverages.size()) > 0) {
				this.getGipiWItemPerilDAO().endtItemPerilPostFormsCommit(params); // andrew - 01.11.2012
			}
			//this.getGipiWItemDAO().endtItemPostFormsCommit(params); // andrew - 01.11.2012 - comment out
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		/*} catch (JSONException e) {			
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;*/
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#gipis065CheckIfPerilExists(java.util.Map)
	 */
	@Override
	public String gipis065CheckIfPerilExists(Map<String, Object> params)
			throws SQLException {
		log.info("Checking for existing perils ...");
		return (String) this.getSqlMapClient().queryForObject("gipis065CheckIfPerilExists", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAccidentItemDAO#gipis065InsertRecGrpWItem(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis065InsertRecGrpWItem(
			Map<String, Object> params) throws SQLException {
		log.info("Inserting record group witem ...");
		this.getSqlMapClient().queryForObject("gipis065InsertRecGrpWItem", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveAccidentGroupedItemsModalTG(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			List<Map<String, Object>> setItems 				= (List<Map<String, Object>>) params.get("setItemRows");
			List<GIPIWAccidentItem> accidentItems 			= (List<GIPIWAccidentItem>) params.get("accidentItems");			
			List<GIPIWGroupedItems> setGroupedItems 		= (List<GIPIWGroupedItems>) params.get("setGroupedItems");
			List<Map<String, Object>> delGroupedItems		= (List<Map<String, Object>>) params.get("delGroupedItems");
			List<GIPIWItmperlGrouped> setCoverages			= (List<GIPIWItmperlGrouped>) params.get("setCoverages");
			List<Map<String, Object>> delCoverages			= (List<Map<String, Object>>) params.get("delCoverages");
			List<GIPIWGrpItemsBeneficiary> setBeneficiaries	= (List<GIPIWGrpItemsBeneficiary>) params.get("setBeneficiaries");
			List<Map<String, Object>> delBeneficiaries		= (List<Map<String, Object>>) params.get("delBeneficiaries");
			List<GIPIWItmperlBeneficiary> setBenPerils		= (List<GIPIWItmperlBeneficiary>) params.get("setBenPerils");
			List<Map<String, Object>> delBenPerils			= (List<Map<String, Object>>) params.get("delBenPerils");
			
			JSONObject misc = (JSONObject) params.get("misc");

			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			// delete (GIPI_WITMPERL_BENEFICIARY)
			for(Map<String, Object> delMap : delBenPerils){				
				log.info("Deleting record on gipi_witmperl_beneficiary (parId, itemNo, groupedItemNo, beneficiaryNo, perilCd)...");
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNoBenNoPerilCd", delMap);
			}
			this.getSqlMapClient().executeBatch();

			// delete (GIPI_WGRP_ITEMS_BENEFICIARY)
			for(Map<String, Object> delMap : delBeneficiaries){
				log.info("Deleting record on gipi_witmperl_beneficiary (parId, itemNo, groupedItemNo, beneficiaryNo)...");
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNoBenNo", delMap);
				
				log.info("Deleting record on gipi_wgrp_items_beneficiary (parId, itemNo, groupedItemNo, beneficiaryNo)...");
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary", delMap);
			}
			this.getSqlMapClient().executeBatch();

			// delete (GIPI_WITMPERL_GROUPED)
			for(Map<String, Object> delMap : delCoverages){
				log.info("Deleting record on gipi_witmperl_grouped (parId, itemNo, groupedItemNo, perilCd)...");
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped", delMap);					
				
				log.info("Inserting record group (insertRecgrpWitem1) ...");
				this.getSqlMapClient().update("insertRecgrpWitem1", delMap);
				this.getSqlMapClient().executeBatch();
			}
			//this.getSqlMapClient().executeBatch();

			// delete (GIPI_WGROUPED_ITEMS)
			for(Map<String, Object> delMap : delGroupedItems){
				log.info("Deleting record on gipi_wgrouped_items ...");				
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiary", delMap);
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary2", delMap);
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delMap);		
				this.getSqlMapClient().executeBatch();
				
				System.out.println("here XXXXX: "+delMap);
				log.info("Inserting record group (insertRecgrpWitem1) ...");
				this.getSqlMapClient().update("insertRecgrpWitem1", delMap);
				this.getSqlMapClient().executeBatch();
								
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
				this.getSqlMapClient().executeBatch();
			}
			

			// insert/update (GIPI_WGROUPED_ITEMS)
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				log.info("Inserting/Updating record on gipi_wgrouped_items ...");
				System.out.println("Test amounts: "+groupItem.getTsiAmt()+", "+groupItem.getPremAmt());
				this.getSqlMapClient().insert("setGipiWGroupedItems2", groupItem);
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscPlanPopulateBenefits"))){
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("parId", groupItem.getParId());
					paramMap.put("itemNo", groupItem.getItemNo());
					paramMap.put("groupedItemNo", groupItem.getGroupedItemNo());
					paramMap.put("packBenCd", groupItem.getPackBenCd());
					paramMap.put("lineCd", groupItem.getLineCd());
					
					System.out.println("Param Map : " + paramMap.toString());
					
					log.info("Populating benefits through update of pack_ben_cd (grouped_items)...");
					this.getSqlMapClient().update("populateOverwriteBenefits", paramMap);
				}
			}
			this.getSqlMapClient().executeBatch();
			
			// insert/update (GIPI_WITMPERL_GROUPED)
			for(GIPIWItmperlGrouped cov : setCoverages){
				Map<String, Object> paramsMap = new HashMap<String, Object>();
				
				paramsMap.put("parId", cov.getParId().toString());
				paramsMap.put("itemNo", cov.getItemNo());
				paramsMap.put("groupedItemNo", cov.getGroupedItemNo());				
				paramsMap.put("lineCd", cov.getLineCd());
				paramsMap.put("perilCd", cov.getPerilCd());				
				
				if (cov.getWcSw().equals("Y")){
					log.info("Inserting default values on warranties and clauses ... ");					
					this.getSqlMapClient().update("preCommitGipis012", paramsMap);
					this.getSqlMapClient().executeBatch();
				}
							
				log.info("Inserting/Updating record on gipi_witmperl_grouped... ");
				
				this.getSqlMapClient().update("setGIPIWItmperlGrouped", cov);
				this.getSqlMapClient().executeBatch();

				log.info("Inserting record group (insertRecgrpWitem1) ...");
				this.getSqlMapClient().update("insertRecgrpWitem1", paramsMap);
				this.getSqlMapClient().executeBatch();
			}
			
			// insert/update (GIPI_WGRP_ITEMS_BENEFICIARY)
			for(GIPIWGrpItemsBeneficiary ben : setBeneficiaries){
				log.info("Inserting/Updating record on gipi_wgrp_items_beneficiary ...");
				this.getSqlMapClient().insert("setGIPIWGrpItemsBeneficiary", ben);
			}
			this.getSqlMapClient().executeBatch();

			// insert/update (GIPI_WITMPERL_BENEFICIARY)
			for(GIPIWItmperlBeneficiary ben : setBenPerils){
				log.info("Inserting/Updating record on gipi_witmperl_beneficiary ...");
				this.getSqlMapClient().insert("setGIPIWItmperlBeneficiary", ben);
			}
			this.getSqlMapClient().executeBatch();
			
			// GIPI_WITEM (insert/update)
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ..."+item);				
				//this.getSqlMapClient().insert("setGIPIWItem2", item); // REMOVED - this is causing the amounts of gipi_witem to revert back if a group item is deleted. - irwin 10.9.2012
				
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscChangeNoOfPerson"))){					
					log.info("Changing number of persons ...");
					this.getSqlMapClient().queryForObject("changeNoOfPersons", item);
				}
				
				this.getSqlMapClient().executeBatch();
				
				if("Y".equals(misc.getString("miscDeleteBill"))){
					log.info("Deleting bill ...");
					this.getSqlMapClient().update("deleteBillAccidentItem", item);
				}
				
				this.getSqlMapClient().executeBatch();				
			}
			// ilipat dito 
			for(Map<String, Object> delMap : delCoverages){
				System.out.println("Inserting record group (delCoverages): "+delMap);
				this.getSqlMapClient().update("insertRecgrpWitem1", delMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIWItmperlGrouped cov : setCoverages){
				Map<String, Object> paramsMap = new HashMap<String, Object>();
				
				paramsMap.put("parId", cov.getParId().toString());
				paramsMap.put("itemNo", cov.getItemNo());
				paramsMap.put("groupedItemNo", cov.getGroupedItemNo());				
				paramsMap.put("lineCd", cov.getLineCd());
				paramsMap.put("premAmt", cov.getPremAmt());
				
				log.info("Inserting record group (setCoverages) - "+paramsMap);
				this.getSqlMapClient().update("insertRecgrpWitem1", paramsMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(Map<String, Object> delMap : delGroupedItems){
				System.out.println("Inserting record group (delGroupedItems): "+delMap);
				this.getSqlMapClient().update("insertRecgrpWitem1", delMap);
				this.getSqlMapClient().executeBatch();
			}
			
			for(GIPIWGroupedItems groupItem : setGroupedItems){
				Map<String, Object> paramsMap = new HashMap<String, Object>();
				
				paramsMap.put("parId", groupItem.getParId().toString());
				paramsMap.put("itemNo", groupItem.getItemNo());
				paramsMap.put("groupedItemNo", groupItem.getGroupedItemNo());				
				paramsMap.put("lineCd", groupItem.getLineCd());
				paramsMap.put("premAmt", groupItem.getPremAmt());
				
				log.info("Inserting record group (setGroupedItems2) - "+paramsMap);
				this.getSqlMapClient().update("insertRecgrpWitem1", paramsMap);
				this.getSqlMapClient().executeBatch();
			}

			// insert/update (GIPI_WACCIDENT_ITEM)
			for(GIPIWAccidentItem ac : accidentItems) {
				log.info("Inserting/Updating record on gipi_waccident_item ...");
				this.getSqlMapClient().insert("setGipiWAccidentItems", ac);				
				this.getSqlMapClient().executeBatch();
			}
			// lipat dito, mula sa taas :p
			if(setCoverages.size() > 0 || delCoverages.size() > 0
					|| delGroupedItems.size() > 0){
				log.info("POST FORM COMMIT FOR ITEM GROUP ITEMS MODAL...");
				System.out.println(params.get("parId"));
				System.out.println(params.get("issCd"));
				System.out.println(params.get("lineCd"));
				this.getSqlMapClient().update("postFormsCommitGipis012ForItemGroup", params);
				this.getSqlMapClient().executeBatch();	
			}
			
			// added for post form commit of item group items modal - irwin 11.29.2011
			
			log.info("updating premiums..");
			System.out.println(params.get("parId"));
			System.out.println(params.get("issCd"));
			System.out.println(params.get("lineCd"));
			this.getSqlMapClient().update("updatePremiumAmts", params);
			
			/*if(setCoverages.size() > 0 || delCoverages.size() > 0){
				log.info("POST FORM COMMIT FOR ITEM GROUP ITEMS MODAL...");
				// apply another set of insertRecgrpWitem1, nakalagay ito sa OK button ng canvas ng coverage - irwin
				for(GIPIWItmperlGrouped cov : setCoverages){
					Map<String, Object> paramsMap = new HashMap<String, Object>();
					paramsMap.put("parId", cov.getParId().toString());
					paramsMap.put("itemNo", cov.getItemNo());
					paramsMap.put("groupedItemNo", cov.getGroupedItemNo());				
					paramsMap.put("lineCd", cov.getLineCd());
					paramsMap.put("perilCd", cov.getPerilCd());			
					
					log.info("Inserting record group (insertRecgrpWitem1) Second round...");
					this.getSqlMapClient().update("insertRecgrpWitem1", paramsMap);
					this.getSqlMapClient().executeBatch();
				}
				
			}*/
			
			this.getSqlMapClient().update("postFormsCommitGipis012ForItemGroup", params);
			this.getSqlMapClient().executeBatch();
			
			//post-form-commit
			// added by andrew - 02.15.2012 - to update the par_status
			Map<String, Object> addParStatus = new HashMap<String, Object>();
			addParStatus.put("parId", Integer.parseInt(params.get("parId").toString()));
			addParStatus.put("lineCd", params.get("lineCd"));
			addParStatus.put("issCd", (String) params.get("issCd").toString());
			addParStatus.put("invoiceSw", "N");
			addParStatus.put("itemGrp", null);
			this.sqlMapClient.update("addParStatusNo2", addParStatus);			
			
			this.getSqlMapClient().executeBatch();			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (JSONException e) {			
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void populateBenefits(Map<String, Object> params)
			throws SQLException {		
		try{
			@SuppressWarnings("unchecked")
			List<GIPIWGroupedItems> groupedItems = (List<GIPIWGroupedItems>) params.get("groupedItemList");
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			
			log.info("Populating benefits ...");
			for(GIPIWGroupedItems gp : groupedItems){				
				paramMap.put("parId", gp.getParId());
				paramMap.put("itemNo", gp.getItemNo());
				paramMap.put("groupedItemNo", gp.getGroupedItemNo());				
				paramMap.put("packBenCd", gp.getPackBenCd());
				paramMap.put("lineCd", gp.getLineCd());
				paramMap.put("delBenSw", params.get("delBenSw"));
				paramMap.put("selectedGroupedItemNo", params.get("selectedGroupedItemNo"));
				paramMap.put("popChecker", params.get("popChecker"));
				params.put("parId", gp.getParId());
				this.getSqlMapClient().update("populateBenefits", paramMap);
				this.getSqlMapClient().executeBatch();	

				log.info("Inserting record group (insertRecgrpWitem1) ...");
				this.getSqlMapClient().update("insertRecgrpWitem1", paramMap);
				this.getSqlMapClient().executeBatch();

			}
						
			 log.info("POST FORM COMMIT FOR ITEM GROUP ITEMS MODAL..."); // Copied from saving of GROUP ITEMS MODAL. Post updating of GIPI_WINVOICE - irwin 9.3.2012
			 System.out.println(params.get("parId"));
			 System.out.println(params.get("issCd"));
			 System.out.println(params.get("lineCd"));
			 this.getSqlMapClient().update("updatePremiumAmts", params);
			 this.getSqlMapClient().update("postFormsCommitGipis012ForItemGroup", params);
			 this.getSqlMapClient().executeBatch(); 
			 
			//post-form-commit
			// added by andrew - 02.15.2012 - to update the par_status --- COPIED FROM SAVING OF MODAL. TO UPDATE PAR STATUS AND UPDATE GIPIW_POLBAS - IRWIN 9.8.2012
			Map<String, Object> addParStatus = new HashMap<String, Object>();
			addParStatus.put("parId", Integer.parseInt(params.get("parId").toString()));
			addParStatus.put("lineCd", params.get("lineCd"));
			addParStatus.put("issCd", (String) params.get("issCd").toString());
			addParStatus.put("invoiceSw", "N");
			addParStatus.put("itemGrp", null);
			this.sqlMapClient.update("addParStatusNo2", addParStatus);	
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}
}
