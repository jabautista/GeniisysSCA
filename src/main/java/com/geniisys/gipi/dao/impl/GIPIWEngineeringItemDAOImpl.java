package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIWEngineeringItemDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWEngineeringItem;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWLocation;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWEngineeringItemDAOImpl implements GIPIWEngineeringItemDAO{

/*	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return null;
	}

	@Override
	public Map<String, Object> preCommitENItem(Integer parId)
			throws SQLException {
		return null;
	}*/

	/*	@Override
	public void saveGIPIWEngineering(List<GIPIWEngineeringItem> enItems)
			throws SQLException {
		
	}*/
	
	private Logger log = Logger.getLogger(GIPIWEngineeringItemDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}
	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWEngineeringItemDAO#getGipiWENItems(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWEngineeringItem> getGipiWENItems(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIWENItems", parId);
	}	

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWEngineeringItemDAO#saveEngineeringItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveEngineeringItem(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Engineering items");
		try {
			List<Map<String, Object>> setItems =  (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems = (List<Map<String, Object>>) params.get("delItems");
			
			List<GIPIWDeductible> insDeductibles = (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles = (List<GIPIWDeductible>) params.get("delDeductRows");
			
			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap = null;
			JSONObject misc = (JSONObject) params.get("misc");			
			
			// GIPI_WITEM (pre-delete)
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
			for(Map<String, Object> item: setItems) {
				log.info("Inserting/Updating record on gipi_witem ...");
				this.getSqlMapClient().insert("setGIPIWItem2", item);
				
				params.put("itemGrp", item.get("itemGrp"));
			}
			
			// GIPI_WDEDUCTIBLES (delete)
			for(GIPIWDeductible ded: delDeductibles) {
				log.info("Deleting record on gipi_wdeductibles ...");
				this.getSqlMapClient().delete("delGipiWDeductible2", ded);
			}
			
			// GIPI_WDEDUCTIBLES (insert/update)
			for(GIPIWDeductible ded: insDeductibles) {
				log.info("Inserting/Updating records on gipi_wdeductibles ...");
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
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	public boolean insertUpdateItem(Map<String, Object> params) throws SQLException {
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		//List<GIPIWAviationItem> aviationList = (List<GIPIWAviationItem>) params.get("aviationList");
		
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
		
		boolean result = true;		
		//int index = 0;
		
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
				
		/*log.info("Item Saving - Deleting discount ...");
		this.getSqlMapClient().queryForObject("deleteDiscount", params.get("parId"));
		vars.put("varInsertDeleteSw", "Y");
		others.put("nbtInvoiceSw", "Y");*/				
		
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
	public boolean postFormsCommit(Map<String, Object> params) throws SQLException{
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
			
			log.info("Item (Post Form Commit)- Deleting co_insurer ...");
			
			this.getSqlMapClient().queryForObject("deleteCoInsurer", params.get("parId"));
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packPolFlag", gipiParList.getPackPolFlag());			
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
			pars.put("parDDLCommit", "Y");
			
			paramMap.clear();
			
			log.info("Item (Post Form Commit)- Deleting bill ...");
			this.getSqlMapClient().queryForObject("deleteBillOnItem", Integer.parseInt(globals.get("globalParId").toString()));
						
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("lineCd", gipiParList.getLineCd());
			paramMap.put("issCd", gipiParList.getIssCd());
			paramMap.put("invoiceSw", (String) others.get("nbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp") != null ? params.get("itemGrp").toString() : null);
			
			log.info("Item (Post Form Commit)- Adding par_status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			paramMap.clear();
			
			log.info("Item (Post Form Commit)- Updating gipi_wpolbas no_of_item ...");
			this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem", gipiParList.getParId());
			paramMap = null;
		}else if("".equals((String) vars.get("varPost"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
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

		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		paramMap.put("parId", gipiParList.getParId());
		paramMap.put("packLineCd", globals.get("globalPackLineCd"));
		paramMap.put("packSublineCd", globals.get("globalPackSublineCd"));
		
		log.info("Item (Post Form Commit)- Updating gipi_wpacksubline ...");
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSubline", paramMap);
		paramMap = null;
		
		return true;
	}
	
	/**
	 * 
	 * @param params
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	private void deleteItem (Map<String, Object> params) throws SQLException{
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		String[] parIds = (String[]) delItemMap.get("delParIds");
		String[] itemNos = (String[]) delItemMap.get("delItemNos");
		
		for (int index=0, length= itemNos.length; index<length; index++){
			Map<String, Object> deleteMap = new HashMap<String, Object>();
			deleteMap.put("parId", parIds[index]);
			deleteMap.put("itemNo", itemNos[index]);
			log.info("Item Saving (parId=" + parIds[index] +", itemNo=" + itemNos[index]+") - Deleting record on GIPI_WLOCATION");
			this.getSqlMapClient().delete("delGipiWLocation", deleteMap);
			log.info("Item Saving (parId=" + parIds[index] +", itemNo=" + itemNos[index]+") - Deleting record on gipi_witem...");
			this.getSqlMapClient().delete("deleteGIPIParItem", deleteMap);
		}
	}
	
	/**
	 * 
	 * @param param
	 * @param deductibleLevel
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	private void updateDeductibleRecords(Map<String,Object> param, int deductibleLevel) throws SQLException{
		if(deductibleLevel == 2){
			if(param.get("deductibleDelList") != null && ((List<Map<String, Object>>)param.get("deductibleDelList")).size()>0){
				for(Map<String, Object> dedMap : (List<Map<String, Object>>) param.get("deductibleDelList")){
					log.info("Item - (parId=" + dedMap.get("parId") + ", itemNo=" + dedMap.get("itemNo") + ", dedCd=" + dedMap.get("dedDeductibleCd") + ") - Deleting record in gipi_wdeductibles (item level)...");
					this.getSqlMapClient().delete("delGipiWDeductibles", dedMap);
				}
			}
			if(param.get("deductibleInsList") != null && ((List<GIPIWDeductible>) param.get("deductibleInsList")).size()>0){
				for (GIPIWDeductible ded : (List<GIPIWDeductible>) param.get("deductibleInsList")){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() +") - Inserting record to gipi_wdeductible (item level)..." );
					this.getSqlMapClient().insert("saveWDeductible", ded);
				}
			}
		}else if(deductibleLevel == 3){
			if(param.get("perilDedDelList") != null && ((List<Map<String, Object>>) param.get("perilDedDelList")).size()>0){
				for (Map<String, Object> dedMap : (List<Map<String, Object>>) param.get("perilDedDelList")){
					log.info("Item - (parId=" + dedMap.get("parId") + ", itemNo=" + dedMap.get("itemNo") + ", dedCd=" + dedMap.get("dedDeductibleCd") + ") - Deleting record in gipi_wdeductibles (peril level)..." );
					this.getSqlMapClient().delete("delGipiWDeductibles", dedMap);
				}
			}
			if(param.get("perilDedInsList") != null && ((List<GIPIWDeductible>) param.get("perilDedInsList")).size()>0){
				for (GIPIWDeductible ded : (List<GIPIWDeductible>) param.get("perilDedInsList")){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() + ") - Inserting record to gipi_wdeductibles (peril level)...");
					this.getSqlMapClient().insert("saveWDeductible", ded);
				}
			}
		}
	}
	
	/**
	 * 
	 * @param param
	 * @throws SQLException
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	private void updateItemPerilRecords(Map<String, Object> param) throws SQLException{
		Map<String, Object> others	= (Map<String, Object>) param.get("others");
		Map<String, Object> globals = (Map<String, Object>) param.get("globals");
		String delDiscItemNos = (String) others.get("deldiscItemNos");
		String[] masterItemNos = (String[]) param.get("masterItemNos");
		Integer parId = (Integer) param.get("parId");
		
		if ("Y".equals(others.get("delDiscSw"))){
			log.info("Deleting discounts in all levels for par_id "+parId);
			this.getSqlMapClient().delete("deleteAllDiscounts", parId);
		}
		
		//ALL GIPIS038 PROCEDURES BEFORE INSERT/DELETE/UPDATE PERIL DATA
		if ((param.get("itemPerilDelList") != null && ((List<Map<String, Object>>) param.get("itemPerilDelList")).size() > 0)
				|| (param.get("itemPerilInsList") != null && ((List<Map<String, Object>>) param.get("itemPerilInsList")).size() > 0)){
			
			log.info("Saving item peril ...");
			
			//DEDUCT DISCOUNTS
			if ("".equals(delDiscItemNos)){
				//do nothing
			} else {
				log.info("Deleting discounts...");
				Map<String, Object> delDiscParams = new HashMap<String, Object>();
				delDiscParams.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
				delDiscParams.put("itemNo", Integer.parseInt(delDiscItemNos));
				this.getSqlMapClient().update("deleteDiscounts", delDiscParams);
			}
			
			//DELETE OTHER DISCOUNTS
			if(masterItemNos != null && masterItemNos.length > 0){
				Map<String, Object> perilMap = null;
				for(int i=0, length=masterItemNos.length; i<length; i++){
					System.out.println("masterItemNos: "+masterItemNos[i]);
					perilMap = new HashMap<String, Object>();
					perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
					perilMap.put("itemNo", Integer.parseInt(masterItemNos[i]));
					System.out.println("delDiscSw: "+others.get("delDiscSw"));
					if("Y".equals((String) others.get("delDiscSw"))){
						log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo") + ") - Deleting other discount ...");
						this.getSqlMapClient().queryForObject("deleteOtherDiscount", perilMap);
					}
					perilMap = null;
				}
			}
		}
		
		//DELETE
		if(param.get("perilDelList") != null && ((List<Map<String, Object>>) param.get("perilDelList")).size() > 0){			
			for(GIPIWItemPeril p : (List<GIPIWItemPeril>) param.get("perilDelList")){
				Map<String, Object> perilMap = new HashMap<String, Object>();
				perilMap.put("parId", p.getParId());
				perilMap.put("itemNo", p.getItemNo());
				perilMap.put("lineCd", p.getLineCd());
				perilMap.put("perilCd", p.getPerilCd());
				log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo") + ", perilCd= "+perilMap.get("perilCd")+") - Deleting item peril ...");
				this.getSqlMapClient().delete("deleteItemPeril", perilMap);
			}
		}
		
		//INSERT AND UPDATE
		List<GIPIWItemPeril> listing = (List<GIPIWItemPeril>) param.get("perilInsList");
		System.out.println("DAO - eto size nung insert: "+listing.size());
		Map<String, Object> perilMap = null;
		if(param.get("perilInsList") != null && ((List<Map<String, Object>>) param.get("perilInsList")).size() > 0){
			for(GIPIWItemPeril p : (List<GIPIWItemPeril>) param.get("perilInsList")){
				log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Inserting record to peril ...");	
				log.info("tsiAmt: "+p.getTsiAmt());
				log.info("premRt: "+p.getPremRt());
				log.info("premAmt: "+p.getPremAmt());
				log.info("parId: "+p.getParId());
				log.info("itemNo: "+p.getItemNo());
				log.info("perilCd: "+p.getPerilCd());
				this.getSqlMapClient().insert("addItemPeril", p);
			}				
		}
			
		//ALL GIPIS038 PROCEDURES AFTER INSERT/DELETE/UPDATE PERIL DATA
		
		//adds warranty and clauses
		if(param.get("wcInsList") != null && ((List<GIPIWPolicyWarrantyAndClause>) param.get("wcInsList")).size() > 0){
			for (GIPIWPolicyWarrantyAndClause wc : (List<GIPIWPolicyWarrantyAndClause>) param.get("wcInsList")){
				log.info("Inserting warranties and clauses...");
				this.getSqlMapClient().queryForObject("saveWPolWC", wc);
			}
		}
		
		if ((param.get("itemPerilDelList") != null && ((List<Map<String, Object>>) param.get("itemPerilDelList")).size() > 0)
				|| (param.get("itemPerilInsList") != null && ((List<Map<String, Object>>) param.get("itemPerilInsList")).size() > 0)){
		
			//DELETE BILLS
			log.info("Item Peril (parId=" + parId + ") - Deleting bill details ...");
			//Map<String, Object> parParam = new HashMap<String, Object>();
			//parParam.put("parId", parId);
			this.getSqlMapClient().delete("deleteBills", parId);
			
			//INSERT TO PARHIST
			log.info("Item Peril (parId=" + parId + ") - Inserting record to parhist ...");
			perilMap = new HashMap<String, Object>();
			perilMap.put("parId", parId);
			perilMap.put("userId", param.get("userId"));
			perilMap.put("entrySource", "");
			perilMap.put("parstatCd", "5");					
			this.getSqlMapClient().queryForObject("insertPARHist", perilMap);
			perilMap = null;
			
			//UPDATE PACK WPOLBAS
			if(globals.get("globalPackParId") != null & Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Updating pack_wpolbas ...");
				this.getSqlMapClient().queryForObject("updatePackWPolbas", Integer.parseInt(globals.get("globalPackParId").toString()));
			}
			
			//log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Deleting bill details ...");
			//this.getSqlMapClient().queryForObject("deleteBillsDetails", p.getParId());
			
			//CREATE WINVOICE
			if(globals.get("globalPackParId") != null & Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par ...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
				perilMap.put("lineCd", (String) globals.get("globalLineCd"));
				perilMap.put("issCd", (String) globals.get("globalIssCd"));						
				this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				perilMap = null;
			}else{
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
				perilMap.put("lineCd", (String) globals.get("globalLineCd"));
				perilMap.put("issCd", (String) globals.get("globalIssCd"));						
				log.info("parId: "+perilMap.get("parId"));
				log.info("lineCd: "+perilMap.get("lineCd"));
				log.info("issCd: "+perilMap.get("issCd"));
				if("Y".equals((String) globals.get("globalPackPolFlag"))){
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par ...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}else{
					log.info("Item Peril (parId=" + parId + ") - Creating winvoice for par ...");
					this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
				}
				
				perilMap = null;
			}
			
			//GET TSI
			log.info("Item Peril (parId=" + parId + ") - Getting tsi amt ...");
			this.getSqlMapClient().queryForObject("getTsi2", parId);
			
			//SETTING PAR STATUS WITH PERIL
			if(globals.get("globalPackParId") != null && Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
				perilMap.put("packParId", Integer.parseInt(globals.get("globalPackParId").toString()));						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril", perilMap);
				perilMap = null;
			}else{
				log.info("Item Peril (parId=" + parId + ") - Setting par_status with peril ...");						
				this.getSqlMapClient().queryForObject("setParStatusToWithPeril1", Integer.parseInt(globals.get("globalParId").toString()));						
			}
			
			//SETTING PLAN DETAILS
			log.info("Updating plan details...");
			//String planSw = (String) others.get("planSw");
			System.out.println("PLANCD: "+others.get("planCd"));
			//Integer planCd = (others.get("planCd")).equals(null) ? null : (Integer) others.get("planCd");
			Map<String, Object> planParam = new HashMap<String, Object>();
			planParam.put("parId", parId);
			planParam.put("planSw", others.get("planSw"));
			planParam.put("planCd", others.get("planCd"));
			planParam.put("planChTag", others.get("planChTag"));
			this.getSqlMapClient().queryForObject("updatePlanDetails", planParam);
			if (!("0".equals(globals.get("globalPackParId")))){
				this.getSqlMapClient().queryForObject("updatePackPlanDetails", planParam);
			}
		}
		/*log.info("Saving item peril...");
		String[] masterItemNos = (String[]) param.get("masterItemNos");
		
		if(param.get("itemPerilDelList")!= null && ((List<Map<String, Object>>) param.get("itemPerilDelList")).size()>0){
			for(Map<String, Object> perilMap : (List <Map<String, Object>>) param.get("itemPerilDelList")){
				log.info("Item Peril(parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo")+") - Deleting item peril");
				this.getSqlMapClient().delete("deleteItemPeril", perilMap);
			}
		}
		if(masterItemNos !=null && masterItemNos.length >0){
			String[] masterTsiAmts 		= 	(String[]) param.get("masterTsiAmts");
			String[] masterPremAmts		=	(String[]) param.get("masterPremAmts");
			String[] masterAnnTsiAmts	=	(String[]) param.get("masterAnnTsiAmts");
			String[] masterAnnPremAmts	=	(String[]) param.get("masterAnnPremAmts");
			String[] discDeleteds		=	(String[]) param.get("discDeleteds");
			
			Map<String, Object> globals =	(Map<String, Object>)param.get("globals");
			Map<String, Object> others	=	(Map<String, Object>)param.get("others");
			
			Map<String, Object> perilMap = null;
			
			for(int i=0; i<masterItemNos.length; i++){
				perilMap = new HashMap<String, Object>();
				perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
				perilMap.put("itemNo", Integer.parseInt(masterItemNos[i]));
				perilMap.put("tsiAmt", new BigDecimal(masterTsiAmts[i] == "" ? "0.00" : masterTsiAmts[i].replaceAll(",", "")));
				perilMap.put("premAmt", new BigDecimal( masterTsiAmts[i]=="" ? "0.00" : masterPremAmts[i].replaceAll(",", "")));
				perilMap.put("annTsiAmt", new BigDecimal(masterAnnTsiAmts[i]=="" ? "0.00" : masterAnnTsiAmts[i].replaceAll(",", "")));
				perilMap.put("annPremAmt", new BigDecimal(masterAnnTsiAmts[i]=="" ? "0.00" : masterAnnPremAmts[i].replaceAll(",", "")));
				
				log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo")+ ") - Updating item values...");
				this.getSqlMapClient().queryForObject("updateItemValues", perilMap);
				log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo")+ ") - Updating Item...");
				this.getSqlMapClient().queryForObject("updateWItem", perilMap);
				
				if("Y".equals((String) others.get("deldiscSw"))){
					if("N".equals(discDeleteds[i])){
						log.info("Item Peril (parId=" + perilMap.get("parId") + ", itemNo=" + perilMap.get("itemNo")+ ") - Deleting other discount...");
						this.getSqlMapClient().queryForObject("deleteOtherDiscount", perilMap);
					}
				}
				perilMap = null;
			}
			
			if(param.get("itemPerilInsList") != null && ((List<Map<String, Object>>) param.get("itemPerilInsList")).size()>0){
				String[] wsSws = (String[]) param.get("wcSws");
				
				for(GIPIWItemPeril p : (List<GIPIWItemPeril>) param.get("itemPerilInsList")){
					if(wsSws != null){
						log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Inserting peril to wc...");
						perilMap = new HashMap<String, Object>();
						perilMap.put("parId", p.getParId());
						perilMap.put("lineCd", p.getLineCd());
						perilMap.put("perilCd", p.getPerilCd());
						this.getSqlMapClient().queryForObject("insertPerilToWC", perilMap);
						perilMap = null;
					}
					log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Inserting record to peril...");
					this.getSqlMapClient().insert("addItemPeril", p);
					
					log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Inserting record to parhist...");
					perilMap = new HashMap<String, Object>();
					perilMap.put("parId", p.getParId());
					perilMap.put("userId", param.get("userId"));
					perilMap.put("entrySource", "");
					perilMap.put("parstatCd", "5");
					this.getSqlMapClient().queryForObject("insertPARHist", perilMap);
					perilMap = null;
					
					log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Updating gipi_wpolbas... ");
					this.getSqlMapClient().queryForObject("updateWPolbas", p.getParId());
					
					if(globals.get("globalPackParId") != null & Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
						log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Updating pack_wpolbas...");
						this.getSqlMapClient().queryForObject("updatePackWPolbas", Integer.parseInt(globals.get("globalPackParId").toString()));
					}
					log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Deleting bill details...");
					this.getSqlMapClient().queryForObject("deleteBillsDetails", p.getParId());
					
					if(globals.get("globalPackParId") != null & Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
						log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Creating winvoice for par...");
						perilMap = new HashMap<String, Object>();
						perilMap.put("parId", Integer.parseInt(globals.get("globalParid").toString()));
						perilMap.put("lineCd", (String) globals.get("globalLineCd"));
						perilMap.put("issCd", (String) globals.get("globalIssCd"));
						this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
						perilMap = null;
					}else{
						perilMap = new HashMap<String, Object>();
						perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
						perilMap.put("lineCd", (String) globals.get("globalLineCd"));
						perilMap.put("issCd", (String) globals.get("globalIssCd"));
						
						if("Y".equals((String) globals.get("globalPackPolFlag"))){
							log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Creating winvoice for par...");
							this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
						}else{
							log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Creating winvoice for par...");
							this.getSqlMapClient().queryForObject("createWInvoiceForPAR", perilMap);
						}
						perilMap = null;
					}
				
					log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Getting tsi amt...");
					this.getSqlMapClient().queryForObject("getTsi", p.getParId());
					
					if(globals.get("globalPackParId") != null & Integer.parseInt(globals.get("globalPackParId").toString()) != 0){
						log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Setting par_status with peril...");
						perilMap = new HashMap<String, Object>();
						perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
						perilMap.put("parId", Integer.parseInt(globals.get("globalPackParId").toString()));
						this.getSqlMapClient().queryForObject("setParStatusToWithPeril", perilMap);
						perilMap = null;
					}else{
						log.info("Item Peril (parId=" + p.getParId() + ", itemNo=" + p.getItemNo() + ") - Setting par_status with peril...");
						perilMap = new HashMap<String, Object>();
						perilMap.put("parId", Integer.parseInt(globals.get("globalParId").toString()));
						this.getSqlMapClient().queryForObject("setParStatusToWithPeril", perilMap);
						perilMap = null;
					}
				}
			}
		}*/
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWEngineeringItemDAO#saveEndtEngineeringItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtEngineeringItem(Map<String, Object> params)	throws SQLException {
		try{
			List<GIPIWItem> addModifiedEngineeringItem = (List<GIPIWItem>) params.get("addModifiedEngineeringItem");
			List<Map<String, Object>> deletedEngineeringItem = (List<Map<String, Object>>) params.get("deletedEngineeringItem");
			// deductibles
			List<GIPIWDeductible> insDeductibles = (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles = (List<GIPIWDeductible>) params.get("delDeductRows");
			
			// item perils
			List<GIPIWItemPeril> insItemPerils		= (List<GIPIWItemPeril>) params.get("setItemPerils");
			List<Map<String, Object>> delItemPerils	= (List<Map<String, Object>>) params.get("delItemPerils");
			
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//Save engineering item information data
			for(GIPIWItem engineeringEndtItems: addModifiedEngineeringItem){
				this.getSqlMapClient().insert("setGIPIWItem", engineeringEndtItems);			
			}
			
			//Delete engineering item information data
			for(Map<String, Object> deleteItems: deletedEngineeringItem){
				Debug.print("Map of deleted info: " + deleteItems);
				this.getSqlMapClient().delete("deleteItem", deleteItems);			
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
			
			// GIPI_WITMPERL (delete)
			for(Map<String, Object> delMap : delItemPerils){
				log.info("Deleting record on gipi_witmperl ...");
				this.getSqlMapClient().delete("deleteEndtItemPeril", delMap);
			}
			
			// GIPI_WITMPERL (insert/update)
			for(GIPIWItemPeril peril : insItemPerils){
				log.info("Inserting/updating record on gipi_witmperl ... " + peril.getRecFlag());
				this.getSqlMapClient().insert("insertEndtItemPeril", peril);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
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
		
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWEngineeringItemDAO#getWLocPerItem(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWLocation> getWLocPerItem(int parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getItemWLocations", parId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWEngineeringItemDAO#gipis004NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis004NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting new instance variables for engineering item...");
		this.getSqlMapClient().queryForObject("gipis004NewFormInstance", params);
		return params;
	}
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}
	
}
