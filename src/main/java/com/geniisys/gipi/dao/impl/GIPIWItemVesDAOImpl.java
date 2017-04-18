package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIPARListDAO;
import com.geniisys.gipi.dao.GIPIParItemDAO;
import com.geniisys.gipi.dao.GIPIWDeductibleDAO;
import com.geniisys.gipi.dao.GIPIWEndtTextDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.dao.GIPIWItemVesDAO;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWItemVes;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWItemVesDAOImpl implements GIPIWItemVesDAO {
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWItemVesDAOImpl.class);
	
	private GIPIParItemDAO gipiParItemDAO;
	private GIPIWDeductibleDAO gipiWDeductibleDAO;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	private GIPIPARListDAO gipiParListDAO;
	private GIPIWEndtTextDAO gipiWEndtTextDAO;

	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#getGipiWItemVes(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItemVes> getGipiWItemVes(Integer parId) throws SQLException {
		log.info("Getting vessel items listing for PAR ID "+parId+"...");
		List<GIPIWItemVes> ves = this.getSqlMapClient().queryForList("getGipiWItemVes", parId);
		log.info("Vessel records obtained count: "+ves.size());
		return ves;
	}
	
	/**
	 * @param gipiWDeductibleDAO the gipiWDeductibleDAO to set
	 */
	public void setGipiWDeductibleDAO(GIPIWDeductibleDAO gipiWDeductibleDAO) {
		this.gipiWDeductibleDAO = gipiWDeductibleDAO;
	}

	/**
	 * @return the gipiWDeductibleDAO
	 */
	public GIPIWDeductibleDAO getGipiWDeductibleDAO() {
		return gipiWDeductibleDAO;
	}

	/**
	 * @param gipiWItemDAO the gipiWItemDAO to set
	 */
	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}

	/**
	 * @return the gipiWItemDAO
	 */
	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#saveGIPIParMarineHullItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIParMarineHullItem(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWItemVes> marineHullItems= (List <GIPIWItemVes>) params.get("marineHullItems");
			
			@SuppressWarnings("unused")
			String parId = params.get("parId").toString();
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo");
			System.out.println("=======================================================================================");
			for(GIPIWItemVes marineHull:marineHullItems){
				System.out.println(marineHull.getParId() + "\t" + marineHull.getItemNo() );
				this.getSqlMapClient().insert("setGipiWItemVes", marineHull);
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
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#getEndtGipiWItemVesDetails(java.util.Map)
	 */
	@Override
	public GIPIWItemVes getEndtGipiWItemVesDetails(Map<String, Object> params)
			throws SQLException {
  		log.info("DAO lineCd: "+params.get("lineCd"));
		log.info("DAO sublineCd: "+params.get("sublineCd"));
		log.info("DAO issCd: "+params.get("issCd"));
		log.info("DAO issueYy: "+params.get("issueYy"));
		log.info("DAO polSeqNo: "+params.get("polSeqNo"));
		log.info("DAO renewNo: "+params.get("renewNo"));
		log.info("DAO itemNo: "+params.get("itemNo"));
		log.info("DAO annTsiAmt: "+params.get("annTsiAmt"));
		log.info("DAO annPremAmt: "+params.get("annPremAmt"));
		this.getSqlMapClient().queryForObject("getEndtGipiWItemVesDetails", params);
		return (GIPIWItemVes) this.getSqlMapClient().queryForObject("getEndtGipiWItemVesDetails", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#validateVessel(java.util.Map)
	 */
	@Override
	public String validateVessel(Map<String, Object> params)
			throws SQLException {
		log.info("DAO lineCd: "+params.get("lineCd"));
		log.info("DAO sublineCd: "+params.get("sublineCd"));
		log.info("DAO issCd: "+params.get("issCd"));
		log.info("DAO issueYy: "+params.get("issueYy"));
		log.info("DAO polSeqNo: "+params.get("polSeqNo"));
		log.info("DAO renewNo: "+params.get("renewNo"));
		log.info("DAO vesselName: "+params.get("vesselName"));
		return (String) this.getSqlMapClient().queryForObject("validateVessel", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#saveEndtMarineHullItemInfoPage(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtMarineHullItemInfoPage(Map<String, Object> params)
			throws SQLException {
		try{
			String pExist1 = "N";
			String pExist2 = "N";
			String vExist  = "N";
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving changes in Endt Marine Hull Item Info page...");

			Integer parId = (Integer) params.get("parId");
			String delPolDed = (String) params.get("delPolDed");
			
			String sublineCd = (String) params.get("sublineCd");
			//String[] delItemNos = (String[]) params.get("delItemNos");
			
			//DELETE_DISCOUNTS
			String deleteParDiscounts = (String) params.get("deleteParDiscounts");
			String updateGIPIWPolbas = (String) params.get("updateGIPIWPolbas");
			Map<String, Object> updateGIPIWPolbasParams = (Map<String, Object>) params.get("updateGIPIWPolbasParams");
			log.info("deleteParDiscounts: " + deleteParDiscounts);
			if ("Y" == deleteParDiscounts){
				this.getGipiParItemDAO().deleteDiscount2(parId);
				this.updateGipiWPolbas2(updateGIPIWPolbasParams);
			}
			
			/*String deleteItemNos = (String) params.get("deleteItemNos");
			System.out.println("deleteItemNos: "+deleteItemNos);
			if ("".equals(deleteItemNos)){
				
			} else {
				String[] delItems = deleteItemNos.split(",");
				for (int x=0; x<delItems.length; x++){
					//wait lang
					this.getGipiWItemDAO().deleteItem(parId, Integer.parseInt((delItems[x]).trim()));
				}
			}*/
			
			/*if (delItemNos != null){
				this.getGipiParItemDAO().deleteDiscount(parId);
				for (String d: delItemNos){
					Map<String, Object> delParams = new HashMap<String, Object>();
					int itemNo = Integer.parseInt(d);
					delParams.put("parId", parId);
					delParams.put("itemNo", itemNo);
					this.delGIPIWItemVes(delParams);
					
					//pre-delete for GIPIWItem
					this.getSqlMapClient().queryForObject("preDeleteMarineHull", params);
					
					//key-delrec for GIPIWItem
					log.info("delPolDed: "+delPolDed);
					if ("Y" == delPolDed){
						this.getGipiWDeductibleDAO().deleteAllWPolicyDeductibles2(parId, "MH", sublineCd);
					}
					this.getGipiWItemDAO().delGIPIWItem(parId, itemNo);
				}
			}*/
			if (params.get("itemDelList") != null && ((List<GIPIWItem>) params.get("itemDelList")).size() > 0){
				this.getGipiParItemDAO().deleteDiscount(parId);
				for (GIPIWItem item : (List<GIPIWItem>) params.get("itemDelList")){
					Map<String, Object> delParams = new HashMap<String, Object>();
					delParams.put("parId", item.getParId());
					delParams.put("itemNo", item.getItemNo());
					
					this.getGipiWItemDAO().deleteItem(item.getParId(), item.getItemNo());
					this.delGIPIWItemVes(delParams);
					
					//pre-delete for GIPIWItem
					this.getSqlMapClient().queryForObject("preDeleteMarineHull", params);
					
					//key-delrec for GIPIWItem
					if ("Y" == delPolDed){
						this.getGipiWDeductibleDAO().deleteAllWPolicyDeductibles2(parId, "MH", sublineCd);
					}
					this.getGipiWItemDAO().delGIPIWItem(item.getParId(), item.getItemNo());
				}
			}
			
			if ("Y" == delPolDed){
				this.getGipiWDeductibleDAO().deleteAllWPolicyDeductibles2(parId, "MH", sublineCd);
			}
			
			String[] itemNos = (String[]) params.get("itemNos");
			
			/*if (itemNos != null){
				Map<String, Object> items = (Map<String, Object>) params.get("items");
				Map<String, Object> itemVes = (Map<String, Object>) params.get("itemVes");
				
				for (String i: itemNos){
					GIPIWItem item = (GIPIWItem) items.get(i);
					GIPIWItemVes ves = (GIPIWItemVes) itemVes.get(i);
					this.getGipiWItemDAO().setGIPIWItemWGroup(item);
					this.insertGIPIWItemVes(ves);
				}
			}*/
			
			if (params.get("itemInsList") != null && ((List<GIPIWItem>) params.get("itemInsList")).size() > 0){
				List<GIPIWItemVes> itemves = (List<GIPIWItemVes>) params.get("itemVesInsList");
				for (GIPIWItem item : (List<GIPIWItem>) params.get("itemInsList")){
					this.getGipiWItemDAO().setGIPIWItemWGroup(item);
					for (GIPIWItemVes ves : itemves){
						if (item.getItemNo() == ves.getItemNo()){
							this.insertGIPIWItemVes(ves);
						}
					}
				}
			}
			
			//POST-FORMS-COMMIT
			String varPost = (String) params.get("varPost");
			String userId = (String) params.get("userId");
			String invoiceSw = (String) params.get("invoiceSw");
			String packPolFlag = (String) params.get("packPolFlag");
			String gipiWItemExist = (String) params.get("gipiWItemExist"); 
			String gipiWItemPerilExist = (String) params.get("gipiWItemPerilExist"); 
			log.info("gipiWItemExist: "+gipiWItemExist);
			log.info("gipiWItemPerilExist: "+gipiWItemPerilExist);
			String lineCd = (String) params.get("lineCd");
			String issCd = (String) params.get("issCd");
			Integer distNo = (Integer) params.get("distNo");
			
			System.out.println("userId: "+userId);
			System.out.println("invoiceSw: "+invoiceSw);
			System.out.println("varPost: "+varPost);
			System.out.println("packPolFlag: "+packPolFlag);
			
			if ("".equals(varPost)){
				this.getGipiParListDAO().insertParHist(parId, userId, "", "4");
			}
			
			if (("Y".equals(invoiceSw)) || ("".equals(varPost))){
				
				//CHANGE_ITEM_GROUP
				this.changeItemVesGroup(parId); //included to check on deleted items
				
				//DELETE_BILL
				String endtTax = this.getGipiWEndtTextDAO().getEndtTax(parId); //variables.endt_tax_sw
				if ("Y".equals(endtTax)){
					this.getGipiParListDAO().deleteBill(parId);
				}
				this.getSqlMapClient().executeBatch();
				
				//UPDATE_GIPI_WPOLBAS2
				log.info("updateGIPIWPolbas? "+updateGIPIWPolbas);
				if ("Y".equals(updateGIPIWPolbas)){
					
					this.updateGIPIWPolbas(updateGIPIWPolbasParams);
				}
				this.getSqlMapClient().executeBatch();
				//CREATE_DISTRIBUTION
				if ("Y".equals(gipiWItemExist)){
					log.info("Creating distribution...");
					this.getSqlMapClient().queryForObject("itemVesCreateDistribution", parId);
					pExist1 = "Y";
				}
				this.getSqlMapClient().executeBatch();
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
						log.info("Create WInvoice process...");
						log.info("policyId: "+0);
						log.info("polIdN: "+0);
						log.info("oldParId: "+0);
						log.info("parId: "+parId);
						log.info("lineCd: "+lineCd);
						log.info("issCd: "+issCd);
						this.getSqlMapClient().queryForObject("createWInvoice", invParam);
						pExist2 = "Y";
					}
				}
				
				if ("Y".equals(gipiWItemExist)){
					vExist = "Y";
				}
				
				if ("N".equals(pExist1)){ //No items found
					if (distNo != 0){
						//DELETE_DISTRIBUTION
						log.info("Deleting distribution...");
						this.getSqlMapClient().queryForObject("deleteItemVesDistribution", distNo);
					}
				}
				
				if (("N".equals(pExist2)) && ("Y".equals(endtTax))){
					log.info("Deleting inv-related records...");
					this.getSqlMapClient().queryForObject("deleteItemVesInvRelatedRecords", parId);
				}
				
				//ADD_PAR_STATUS_NO
				//Integer pDistNo = (distNo == 0 ? null : distNo ); 
				//CHANGES_IN_PAR_STATUS
				Integer vParStatus = 0;
				String aItem = (String) params.get("aItem");
				String aPeril = (String) params.get("aPeril");
				String cItem = "N";
				String cPeril = "N";
				
				if ("N".equals(aItem)){
					cItem = gipiWItemExist;
					cPeril = gipiWItemPerilExist;
				}
				
				Map<String, Object> invParams = new HashMap<String, Object>();
				invParams.put("parId", parId);
				invParams.put("lineCd", lineCd);
				invParams.put("issCd", issCd);
				this.getSqlMapClient().queryForObject("createInvoiceItem", invParams);
				this.getSqlMapClient().queryForObject("itemVesCreateDistributionItem", parId);
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
				
				//VALIDATE_PAR_STATUS
				String gipiWInvTaxExist = (String) params.get("gipiWInvTaxExist");
				String gipiWInvoiceExist = (String) params.get("gipiWInvoiceExist");
				Integer itemWithPerilCount = (Integer) params.get("itemWithPerilCount"); //VARIABLE.COUNTER
				if (4 == vParStatus){
					if (0 == itemWithPerilCount){
						if ("Y".equals(endtTax)){
							if ("N".equals(gipiWInvTaxExist)){
								vParStatus = 5;
							} else {
								vParStatus = 6;
							}
						}
					}
				} 
				
				this.getGipiParListDAO().updatePARStatus(parId, vParStatus);
				
				//UPDATE_GIPI_WPACK_LINE_SUBLINE
				if ("Y".equals(packPolFlag)){
					String packLineCd = (String) params.get("packLineCd");
					String packSublineCd = (String) params.get("packSublineCd");
					Integer packParId = (Integer) params.get("packParId");
					Map<String, Object> itemParams = new HashMap<String, Object>();
					itemParams.put("parId", parId);
					itemParams.put("packLineCd", packLineCd);
					itemParams.put("packSublineCd", packSublineCd);
					this.getGipiWItemDAO().updateGipiWPackLineSubline(itemParams);
					this.getGipiParListDAO().setPackageMenu(packParId);
				}
			}
			
			/****** SAVING ITEM DEDUCTIBLES ***********/
			
			String[] insDedItemNos	= (String[]) params.get("insDedItemNos");
			String[] delDedItemNos	= (String[]) params.get("delDedItemNos");
			
			if(delDedItemNos != null){
				//updateDeductibleRecords(params, 2);
				List<Map<String, Object>> deductibleDelList = (List<Map<String, Object>>) params.get("deductibleDelList");
				for (Map<String, Object> ded : deductibleDelList){
					log.info("Item - (parId=" + ded.get("parId") + ", itemNo=" + ded.get("itemNo") + ", dedCd=" + ded.get("dedDeductibleCd") +") - Deleting record from gipi_wdeductible (item level)..." );
					this.getSqlMapClient().delete("delGipiWDeductibles", ded);
					
				}
			}
			
			if(insDedItemNos != null){
				//updateDeductibleRecords(params, 2);
				System.out.println("DAO pasok sa insert ng ded");
				List<GIPIWDeductible> deductibleInsList = (List<GIPIWDeductible>) params.get("deductibleInsList");
				for (GIPIWDeductible ded : deductibleInsList){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() +") - Inserting record to gipi_wdeductible (item level)..." );
					this.getSqlMapClient().insert("saveWDeductible", ded);
					log.info("Deductible successfully inserted.");
				}
			}
			/******END OF SAVING ITEM DEDUCTIBLES********/
			
			/****** SAVING ENDT PERIL*****/
			Map<String, Object> allEndtPerilParams 	= (Map<String, Object>) params.get("allEndtPerilParams");
			String[] insItemNos 					= (String[]) allEndtPerilParams.get("insItemNos");
			String[] delPerilItemNos 				= (String[]) allEndtPerilParams.get("delPerilItemNos");
			
			if ((insItemNos != null) || (delPerilItemNos != null)){
				this.getGipiWItemPerilDAO().saveEndtItemPeril2(allEndtPerilParams);
			}
			
			/*****END OF SAVING ENDT PERIL******/
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Completed saving Marine Hull Item Screen changes.");
			
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
	
	/**
	 * 
	 * @param updateGIPIWPolbasParams
	 * @throws SQLException
	 */
	private void updateGIPIWPolbas(Map<String, Object> updateGIPIWPolbasParams) throws SQLException{
		log.info("Updating GIPIWPolbas table...");
		//Map<String, Object> updateGIPIWPolbasParams = (Map<String, Object>) params.get("updateGIPIWPolbasParams");
		log.info("parId: "+updateGIPIWPolbasParams.get("parId"));
		log.info("negateItem: "+updateGIPIWPolbasParams.get("negateItem"));
		log.info("prorateFlag: "+updateGIPIWPolbasParams.get("prorateFlag"));
		log.info("compSw: "+updateGIPIWPolbasParams.get("compSw"));
		log.info("endtExpiryDate: "+updateGIPIWPolbasParams.get("endtExpiryDate"));
		log.info("effDate: "+updateGIPIWPolbasParams.get("effDate"));
		log.info("shortRtPercent: "+updateGIPIWPolbasParams.get("shortRtPercent"));
		log.info("expiryDate: "+updateGIPIWPolbasParams.get("expiryDate"));
		this.getSqlMapClient().queryForObject("updateVesGipiWPolbas", updateGIPIWPolbasParams);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#updateGipiWPolbas2(java.util.Map)
	 */
	public void updateGipiWPolbas2(Map<String, Object> updateGIPIWPolbasParams) throws SQLException {
		log.info("Updating GIPIWPolbas table...");
		this.getSqlMapClient().queryForObject("updateVesGipiWPolbas", updateGIPIWPolbasParams);
	}
	
	/**
	 * @param gipiParItemDAO the gipiParItemDAO to set
	 */
	public void setGipiParItemDAO(GIPIParItemDAO gipiParItemDAO) {
		this.gipiParItemDAO = gipiParItemDAO;
	}

	/**
	 * @return the gipiParItemDAO
	 */
	public GIPIParItemDAO getGipiParItemDAO() {
		return gipiParItemDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#delGIPIWItemVes(java.util.Map)
	 */
	@Override
	public void delGIPIWItemVes(Map<String, Object> params) throws SQLException {
		log.info("Deleting vessels for PAR NO. "+params.get("parId")+"/ ITEM NO. "+params.get("itemNo")+".");

		
		//key-delrec
		this.getSqlMapClient().queryForObject("delGIPIWItemVes", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#preInsertMarineHull(java.util.Map)
	 */
	@Override
	public String preInsertMarineHull(Map<String, Object> params)
			throws SQLException {
		log.info("PREINSERT: Validating currency.");
		return (String) this.getSqlMapClient().queryForObject("preInsertMarineHull", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#insertGIPIWItemVes(com.geniisys.gipi.entity.GIPIWItemVes)
	 */
	@Override
	public void insertGIPIWItemVes(GIPIWItemVes itemVes) throws SQLException {
		//#parId#, #itemNo#, #vesselCd#, #recFlag#, #deductText#, #geogLimit#, #dryDate#, #dryPlace# 
		log.info("parId: "+itemVes.getParId());
		log.info("itemNo: "+itemVes.getItemNo());
		log.info("vesselCd: "+itemVes.getVesselCd());
		log.info("recFlag: "+itemVes.getRecFlag());
		log.info("deductText: "+itemVes.getDeductText());
		log.info("geogLimit: "+itemVes.getGeogLimit());
		log.info("dryDate: "+itemVes.getDryDate());
		log.info("dryPlace: "+itemVes.getDryPlace());
		
		log.info("Inserting vessel for PAR ID "+itemVes.getParId()+ " ITEM NO "+itemVes.getItemNo());
		this.getSqlMapClient().insert("setGipiWItemVes", itemVes);
		log.info("Insert successful.");
	}

	/**
	 * @param gipiParListDAO the gipiParListDAO to set
	 */
	public void setGipiParListDAO(GIPIPARListDAO gipiParListDAO) {
		this.gipiParListDAO = gipiParListDAO;
	}

	/**
	 * @return the gipiParListDAO
	 */
	public GIPIPARListDAO getGipiParListDAO() {
		return gipiParListDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#checkItemVesAddtlInfo(java.lang.Integer)
	 */
	@Override
	public String checkItemVesAddtlInfo(Integer parId) throws SQLException {
		log.info("Checking items with no corresponding vessel info...");
		return (String) this.getSqlMapClient().queryForObject("checkItemVesAddtlInfo", parId);
	}

	/**
	 * @param gipiWEndtTextDAO the gipiWEndtTextDAO to set
	 */
	public void setGipiWEndtTextDAO(GIPIWEndtTextDAO gipiWEndtTextDAO) {
		this.gipiWEndtTextDAO = gipiWEndtTextDAO;
	}

	/**
	 * @return the gipiWEndtTextDAO
	 */
	public GIPIWEndtTextDAO getGipiWEndtTextDAO() {
		return gipiWEndtTextDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#changeItemVesGroup(java.lang.Integer)
	 */
	@Override
	public void changeItemVesGroup(Integer parId) throws SQLException {
		log.info("Updating item group infos...");
		//CHANGE_ITEM_GRP
		this.getSqlMapClient().queryForObject("changeItemVesGroup", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#checkUpdateGipiWPolbasValidity(java.util.Map)
	 */
	@Override
	public String checkUpdateGipiWPolbasValidity(Map<String, Object> params)
			throws SQLException {
		log.info("Checking update GIPIWPolbasic validity...");
		return (String) this.getSqlMapClient().queryForObject("checkUpdateGipiWPolbasValidity", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#checkCreateDistributionValidity(java.lang.Integer)
	 */
	@Override
	public String checkCreateDistributionValidity(Integer parId)
			throws SQLException {
		log.info("Validating distribution...");
		String msgCode = (String) this.getSqlMapClient().queryForObject("checkCreateDistributionValidity", parId);
		if ("0".equals(msgCode)){
			String z = (String) this.getSqlMapClient().queryForObject("checkCreateDistributionItemValidity", parId);
			msgCode =  z != "0" ? z : msgCode; 
		}
		return msgCode;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#checkGiriDistfrpsExist(java.lang.Integer)
	 */
	@Override
	public String checkGiriDistfrpsExist(Integer parId) throws SQLException {
		log.info("Validating distribution in reinsurer table...");
		return (String) this.getSqlMapClient().queryForObject("checkGiriDistfrpsExist", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#itemVesCreateDistribution(java.lang.Integer)
	 */
	@Override
	public void itemVesCreateDistribution(Integer parId) throws SQLException {
		log.info("Creating distribution...");
		this.getSqlMapClient().queryForObject("itemVesCreateDistribution", parId);
	}

	/**
	 * @param gipiWItemPerilDAO the gipiWItemPerilDAO to set
	 */
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}

	/**
	 * @return the gipiWItemPerilDAO
	 */
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#saveGIPIEndtItemVes(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIEndtItemVes(Map<String, Object> allParams)
			throws SQLException, ParseException {
		log.info("Saving endt marine hull items ...");
		try{
			List<GIPIWItem> setItems				= (List<GIPIWItem>) allParams.get("setItems");
			List<Map<String, Object>> delItems		= (List<Map<String, Object>>) allParams.get("delItems");
			List<GIPIWItemVes> vesItems 			= (List<GIPIWItemVes>) allParams.get("vesItems");
			Map<String, Integer> itemNoList 		= (Map<String, Integer>) allParams.get("itemNoList");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles = (List<GIPIWDeductible>) allParams.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles = (List<GIPIWDeductible>) allParams.get("delDeductRows");
			
			// item perils
			List<GIPIWItemPeril> insItemPerils		= (List<GIPIWItemPeril>) allParams.get("setItemPerils");
			List<Map<String, Object>> delItemPerils	= (List<Map<String, Object>>) allParams.get("delItemPerils");
			List<Map<String, Object>> setPerilWCs	= (List<Map<String, Object>>) allParams.get("setPerilWCs");
			
			JSONArray misc = (JSONArray) allParams.get("misc");
			
			//this.getSqlMapClient().startTransaction();
			//this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);			
			//this.getSqlMapClient().startBatch();
			
			for(Map<String, Object> item : delItems){
				if("Y".equals(misc.getJSONObject(0).getString("miscDeletePolicyDeductibles"))){
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("parId", (Integer) allParams.get("parId"));
					param.put("lineCd", (String) allParams.get("lineCd"));
					param.put("sublineCd", (String) allParams.get("sublineCd"));
					
					log.info("Deleting policy deductibles ...");
					this.getSqlMapClient().queryForObject("deletePolDeductibles", param);
				}				
				
				log.info("Deleting record on gipi_witem ...");
				this.getSqlMapClient().queryForObject("preDeleteMarineHull", item);
				this.getSqlMapClient().delete("delGIPIWItemVes", item);
				this.getSqlMapClient().delete("delGIPIWItem", item);
			}
			
			for(GIPIWItem item : setItems){
				log.info("Inserting/updating record on gipi_witem ...");	
				log.info("REC FLAG: "+item.getRecFlag());
				this.getSqlMapClient().insert("setGIPIWItem", item);
				//insert GIPI_WITEM_VES
				for (GIPIWItemVes itemVes : vesItems){
					if (itemVes.getItemNo() == item.getItemNo()){
						//if(itemNoList.get(itemVes.getItemNo()) != null){
							this.insertGIPIWItemVes(itemVes);
						//}
					}
				}
				
				allParams.put("packLineCd", item.getPackLineCd());
				allParams.put("packSublineCd", item.getPackSublineCd());				
			}
			
			// delete discounts
			if("Y".equals(misc.getJSONObject(0).getString("miscDeletePerilDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWPerilDiscount", (Integer) allParams.get("parId"));
			}
			
			if("Y".equals(misc.getJSONObject(0).getString("miscDeleteItemDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWItemDiscount", (Integer) allParams.get("parId"));
			}
			
			if("Y".equals(misc.getJSONObject(0).getString("miscDeletePolbasDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWPolbasDiscount", (Integer) allParams.get("parId"));
			}
			
			// GIPI_WITMPERL (delete)
			for(Map<String, Object> delMap : delItemPerils){
				log.info("Deleting record on gipi_witmperl ...");
				this.getSqlMapClient().delete("deleteEndtItemPeril", delMap);
			}
			
			// GIPI_WITMPERL (insert/update)
			for(GIPIWItemPeril peril : insItemPerils){
				log.info("Inserting/updating record on gipi_witmperl ...");
				this.getSqlMapClient().insert("insertEndtItemPeril", peril);
			}
			
			// inculde peril's warranty and clauses
			for(Map<String, Object> wc : setPerilWCs){
				log.info("Inserting peril's warranty and clauses ...");
				this.getSqlMapClient().insert("includeWC", wc);
			}
			
			// GIPI_WDEDUCTIBLES (delete)
			for(GIPIWDeductible ded : delDeductibles){
				log.info("Deleting record on gipi_wdeductibles ...");
				this.getSqlMapClient().delete("delGipiWDeductible2", ded);
			}
			
			// GIPI_WDEDUCTIBLES (insert/update)
			for(GIPIWDeductible ded : insDeductibles){
				log.info("Inserting/updating record on gipi_wdeductibles ...");				
				this.getSqlMapClient().insert("saveWDeductible", ded);
			}
			
			//this.getSqlMapClient().executeBatch();			
			this.postFormsCommit(allParams);
			//this.getSqlMapClient().getCurrentConnection().commit();	
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (JSONException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			//this.getSqlMapClient().getCurrentConnection().rollback();			
		} finally{
			//this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 
	 * @param params
	 * @throws SQLException
	 * @throws ParseException
	 */
	@SuppressWarnings({ "unused" })
	private void postFormsCommit(Map<String, Object> params) throws SQLException, ParseException{
		try {
			JSONArray vars 			= (JSONArray) params.get("vars");
			JSONArray misc 			= (JSONArray) params.get("misc");
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			
			String pExist1 = "N";
			String pExist2 = "N";
			String vExist  = "N";
	
			Integer parId 		= (Integer) params.get("parId");
			String distNo 		= (String) params.get("distNo");
			String delPolDed 	= (String) params.get("delPolDed");
			String sublineCd 	= (String) params.get("sublineCd");
			String lineCd 		= (String) params.get("lineCd");
			String issCd 		= (String) params.get("issCd");
			String packPolFlag 	= gipiWPolbas.getPackPolFlag();
			
			//POST-FORMS-COMMIT
			String varPost 				= vars.getJSONObject(0).getString("varPost");
			String userId 				= (String) params.get("userId");
			String invoiceSw 			= misc.getJSONObject(0).getString("miscNbtInvoiceSw");//(String) params.get("invoiceSw");
			String gipiWItemExist 		= misc.getJSONObject(0).getString("miscGIPIWItemExist");//(String) params.get("gipiWItemExist"); 
			String gipiWItemPerilExist 	= misc.getJSONObject(0).getString("miscGIPIWItemPerilExist");//(String) params.get("gipiWItemPerilExist"); 

			log.info("gipiWItemExist: "+gipiWItemExist);
			log.info("gipiWItemPerilExist: "+gipiWItemPerilExist);
			System.out.println("userId: "+userId);
			System.out.println("invoiceSw: "+invoiceSw);
			System.out.println("varPost: "+varPost);
			System.out.println("packPolFlag: "+packPolFlag);
			
			if ("".equals(varPost) || varPost.isEmpty()){
				this.getGipiParListDAO().insertParHist(parId, userId, "", "4");
			}
			
			if ("Y".equals(invoiceSw) 
					|| "".equals(varPost)
					|| varPost.isEmpty()
					|| "null".equals(varPost)){
				
				//CHANGE_ITEM_GROUP
				this.changeItemVesGroup(parId); //included to check on deleted items
				
				//DELETE_BILL
				String endtTax = null;
				try {
					endtTax = this.getGipiWEndtTextDAO().getEndtTax(parId);
				} catch (Exception e) {
					e.printStackTrace();
					log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
				} //variables.endt_tax_sw
				if ("Y".equals(endtTax)){
					this.getGipiParListDAO().deleteBill(parId);
				}
				this.getSqlMapClient().executeBatch();
				
				//UPDATE_GIPI_WPOLBAS2
				String updateGIPIWPolbas = misc.getJSONObject(0).getString("miscUpdateGIPIWPolbas");//(String) params.get("updateGIPIWPolbas");
				//Map<String, Object> updateGIPIWPolbasParams = (Map<String, Object>) params.get("updateGIPIWPolbasParams");
				log.info("updateGIPIWPolbas? "+updateGIPIWPolbas);
				if ("Y".equals(updateGIPIWPolbas)){
					this.updateGIPIWPolbas(params);
				}
				this.getSqlMapClient().executeBatch();
				//CREATE_DISTRIBUTION
				if ("Y".equals(gipiWItemExist)){
					log.info("Creating distribution...");
					this.getSqlMapClient().queryForObject("itemVesCreateDistribution", parId);
					pExist1 = "Y";
				}
				this.getSqlMapClient().executeBatch();
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
						log.info("Create WInvoice process...");
						log.info("policyId: "+0);
						log.info("polIdN: "+0);
						log.info("oldParId: "+0);
						log.info("parId: "+parId);
						log.info("lineCd: "+lineCd);
						log.info("issCd: "+issCd);
						this.getSqlMapClient().queryForObject("createWInvoice", invParam);
						pExist2 = "Y";
					}
				}
				
				if ("Y".equals(gipiWItemExist)){
					vExist = "Y";
				}
				
				if ("N".equals(pExist1)){ //No items found
					if (!("0".equals(distNo))){
						//DELETE_DISTRIBUTION
						log.info("Deleting distribution...");
						this.getSqlMapClient().queryForObject("deleteItemVesDistribution", distNo);
					}
				}
				
				if (("N".equals(pExist2)) && ("Y".equals(endtTax))){
					log.info("Deleting inv-related records...");
					this.getSqlMapClient().queryForObject("deleteItemVesInvRelatedRecords", parId);
				}
				
				//ADD_PAR_STATUS_NO
				String pDistNo = ("0".equals(distNo) ? null : distNo ); 
				//CHANGES_IN_PAR_STATUS
				Integer vParStatus = 0;
				String aItem = misc.getJSONObject(0).getString("miscAItem");//(String) params.get("aItem");
				String aPeril = misc.getJSONObject(0).getString("miscAPeril");//(String) params.get("aPeril");
				String cItem = "N";
				String cPeril = "N";
				
				if ("N".equals(aItem)){
					cItem = gipiWItemExist;
					cPeril = gipiWItemPerilExist;
				}
				
				Map<String, Object> invParams = new HashMap<String, Object>();
				invParams.put("parId", parId);
				invParams.put("lineCd", lineCd);
				invParams.put("issCd", issCd);
				this.getSqlMapClient().queryForObject("createInvoiceItem", invParams);
				this.getSqlMapClient().queryForObject("itemVesCreateDistributionItem", parId);
				log.info("aItem+aPeril,cItem+cPeril: "+aItem+aPeril+","+cItem+cPeril);
				if (("N".equals(aItem)) && ("N".equals(cPeril)) && ("Y".equals(endtTax))){
					System.out.println("A");
					if ("Y".equals(cItem)){
						System.out.println("B");
						vParStatus = 4;
					} else {
						System.out.println("C");
						this.getSqlMapClient().queryForObject("createWInvoice1EndtItemPeril", invParams);
						vParStatus = 5;
					}
				} else if (("Y".equals(aPeril)) && ("Y".equals(cPeril))){
					System.out.println("D");
					vParStatus = 5;
				} else if (("Y".equals(aItem)) || ("Y".equals(cItem))){
					System.out.println("E");
					vParStatus = 4;
				} else {
					System.out.println("F");
					vParStatus = 3;
				}
				
				//VALIDATE_PAR_STATUS
				String gipiWInvTaxExist = misc.getJSONObject(0).getString("miscGIPIWInvTaxExist");//(String) params.get("gipiWInvTaxExist");
				String gipiWInvoiceExist = misc.getJSONObject(0).getString("miscGIPIWInvoiceExist");//(String) params.get("gipiWInvoiceExist");
				Integer itemWithPerilCount = misc.getJSONObject(0).getInt("miscItemWithPerilCount");//(Integer) params.get("itemWithPerilCount"); //VARIABLE.COUNTER
				log.info("gipiWInvTaxExist: "+gipiWInvTaxExist);
				log.info("itemWithPerilCount: "+itemWithPerilCount);
				if (4 == vParStatus){
					if (0 == itemWithPerilCount){
						if ("Y".equals(endtTax)){
							if ("0".equals(gipiWInvTaxExist)){
								System.out.println("G");
								vParStatus = 5;
							} else {
								System.out.println("H");
								vParStatus = 6;
							}
						}
					}
				} 
				
				this.getGipiParListDAO().updatePARStatus(parId, vParStatus);
				
				//UPDATE_GIPI_WPACK_LINE_SUBLINE
				if ("Y".equals(packPolFlag)){
					String packLineCd = (String) params.get("packLineCd");
					String packSublineCd = (String) params.get("packSublineCd");
					Integer packParId = (Integer) params.get("packParId");
					Map<String, Object> itemParams = new HashMap<String, Object>();
					itemParams.put("parId", parId);
					itemParams.put("packLineCd", packLineCd);
					itemParams.put("packSublineCd", packSublineCd);
					this.getGipiWItemDAO().updateGipiWPackLineSubline(itemParams);
					this.getGipiParListDAO().setPackageMenu(packParId);
				}
			}
		} catch (JSONException e1) {			
			e1.printStackTrace();
		}
		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#gipis009NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis009NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS009 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis009NewFormInstance", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemVesDAO#saveGIPIWItemVes(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWItemVes(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Marine Hull Items...");
		
		try {
			List<Map<String, Object>> setItems	= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems	= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWItemVes> mhItems			= (List<GIPIWItemVes>) params.get("mhItems");
			
			List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductRows");
			
			GIPIWPolbas gipiWPolbas				= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc						= (JSONObject) params.get("misc");
			Map<String, Object> paramMap		= null;
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
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
			
			// GIPI_WITEM (delete)
			for(Map<String, Object> item : delItems){
				log.info("Deleting record on gipi_witem ...");
				
				// get item attachments
				List<String> attachments = this.getSqlMapClient().queryForList("getItemAttachments", item);
				
				this.getSqlMapClient().delete("delGIPIWItem", item);
				
				// delete attachments
				FileUtil.deleteFiles(attachments);
			}
			
			// GIPI_WITEM (insert/update)
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
				
				params.put("itemGrp", item.get("itemGrp"));
			}
			
			// GIPI_WITEM_VES (insert/update)
			for(GIPIWItemVes mh : mhItems) {
				log.info("Inserting/updating items on gipi_witem_ves...");
				this.getSqlMapClient().insert("setGipiWItemVes", mh);
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
			
			this.getSqlMapClient().executeBatch();
			
			if(params.get("parType").toString().equals("E")){
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

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
}