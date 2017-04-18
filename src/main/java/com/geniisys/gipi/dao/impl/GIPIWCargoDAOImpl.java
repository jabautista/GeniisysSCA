package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.dao.GIPIWCargoDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWCargo;
import com.geniisys.gipi.entity.GIPIWCargoCarrier;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWCargoDAOImpl implements GIPIWCargoDAO{

	private Logger log = Logger.getLogger(GIPIWCargoDAOImpl.class);
	
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

	private GIPIParItemMCDAO itemMcDAO;
	public GIPIParItemMCDAO getItemMcDAO() {
		return itemMcDAO;
	}
	public void setItemMcDAO(GIPIParItemMCDAO itemMcDAO) {
		this.itemMcDAO = itemMcDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#getGipiWCargo(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCargo> getGipiWCargo(Integer parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWCargos", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#saveGIPIParMarineCargo(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIParMarineCargo(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWCargo> marineCargoItems    = (List<GIPIWCargo>) params.get("marineCargoItems");
			String[] delItemNos 			  	 = (String[]) params.get("delItemNos");
			String parId 					     = params.get("parId").toString();
			List<GIPIWCargoCarrier> carrierItems = (List<GIPIWCargoCarrier>) params.get("carrierItems");
			String[] delCarrItemNos				 = (String[]) params.get("delCarrItemNos");
			String[] delCarrCds					 = (String[]) params.get("delCarrCds");
			
			HashMap<String, Object> paramsMulti = new HashMap<String, Object>();
			paramsMulti.put("paramName", "VESSEL_CD_MULTI");
			String multiVesselCd = (String) this.getSqlMapClient().queryForObject("getParamValueV2", paramsMulti);
			System.out.println("Multi Vessel Cd: "+multiVesselCd);
			
			if (delCarrItemNos != null && delCarrCds != null){
				for (int a = 0; a < delCarrItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delCarrItemNos[a]);
					paramsDel.put("vesselCd", delCarrCds[a]);
					System.out.println("Deleting record in GIPI_WCARGO_CARRIER for item no.: /"+delCarrItemNos[a]+"/ vessel cd: /"+delCarrCds[a]);
					this.sqlMapClient.update("delGIPIWCargoCarrier2", paramsDel);
				}
			}
			
			if (delItemNos != null){
				for (int a = 0; a < delItemNos.length; a++) {
					System.out.println("Deleting record/s:");
					System.out.println("ItemNo: "+delItemNos[a]);
					Map<String, Object> paramsDel = new HashMap<String, Object>();
					//paramsDel.put("parId", parId.toString());
					//paramsDel.put("itemNo", delItemNos[a]);
					paramsDel.put("parId", parId); //andrew - 09.21.2010 - changed the data type
					paramsDel.put("itemNo", Integer.parseInt(delItemNos[a])); //andrew - 09.21.2010 - changed the data type
					this.sqlMapClient.update("preDeleteGIPIWCargo", paramsDel);
				}
				System.out.println("Done Deleting for pre-delete");
			}
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo\tVesselCd");
			System.out.println("=======================================================================================");
			for(GIPIWCargo cargo : marineCargoItems){
				Map<String, Object> paramsCargo = new HashMap<String, Object>();
				paramsCargo.put("parId", cargo.getParId());
				paramsCargo.put("itemNo", cargo.getItemNo());
				
				if (!cargo.getVesselCd().equals(multiVesselCd)){
					System.out.println("Deleting record in GIPI_WCARGO_CARRIER for item no. "+cargo.getItemNo());
					this.sqlMapClient.update("delGIPIWCargoCarrier", paramsCargo);
				}	
				
				System.out.println(cargo.getParId() + "\t" + cargo.getItemNo() + "\t" + cargo.getVesselCd());
				if (cargo.getDeleteWVes().equals("Y")){
					this.sqlMapClient.update("deleteGIPIWVesAccumulation", paramsCargo);
				}
				this.getSqlMapClient().insert("setGIPIWCargo", cargo);				
			}
			System.out.println("=======================================================================================");
			
			for(GIPIWCargoCarrier cargoCarrier : carrierItems){
				if (delItemNos != null){
					for (int a = 0; a < delItemNos.length; a++) {
						if (!delItemNos[a].equals(cargoCarrier.getItemNo())) {
							System.out.println("Saving record/s for Carrier List: "+cargoCarrier.getParId() + "\t" + cargoCarrier.getItemNo() + "\t" + cargoCarrier.getVesselCd());
							this.getSqlMapClient().insert("setGIPIWCargoCarrier", cargoCarrier);
						}
					}
				} else{
					System.out.println("Saving record/s for Carrier List: "+cargoCarrier.getParId() + "\t" + cargoCarrier.getItemNo() + "\t" + cargoCarrier.getVesselCd());
					this.getSqlMapClient().insert("setGIPIWCargoCarrier", cargoCarrier);
				}	
			}
			
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
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#saveGIPIEndtMarineCargo(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIEndtMarineCargo(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		try {
			List<GIPIWItem> setItems 					= (List<GIPIWItem>) params.get("setItems");
			List<Map<String, Object>> delItems 			= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWItemPeril> setItemPerils			= (List<GIPIWItemPeril>) params.get("setItemPerils");
			List<Map<String, Object>> delItemPerils		= (List<Map<String, Object>>) params.get("delItemPerils");
			List<GIPIWDeductible> setDeductibles 		= (List<GIPIWDeductible>) params.get("setDeductibles");
			List<GIPIWDeductible> delDeductibles 		= (List<GIPIWDeductible>) params.get("delDeductibles");
			List<Map<String, Object>> setPerilWCs 		= (List<Map<String, Object>>) params.get("setPerilWCs");
			List<GIPIWCargoCarrier> setCargoCarriers 	= (List<GIPIWCargoCarrier>) params.get("setCargoCarriers");
			List<Map<String, Object>> delCargoCarriers 	= (List<Map<String, Object>>) params.get("delCargoCarriers");
			JSONObject miscVariables = (JSONObject) params.get("miscVariables");
			JSONObject formVariables = (JSONObject) params.get("formVariables");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(miscVariables.getString("miscDeletePolicyDeductibles").equals("Y")){
				Map<String, Object> tempMap = new HashMap<String, Object>();
				tempMap.put("parId", formVariables.getInt("parId"));
				tempMap.put("lineCd", formVariables.getString("lineCd"));
				tempMap.put("sublineCd", formVariables.getString("sublineCd"));
				this.getSqlMapClient().delete("deleteWPolicyDeductibles2", tempMap);
			}
			
			// DELETE ITEMS
			for(Map<String, Object> delItem: delItems) {
				this.getSqlMapClient().delete("preDeleteGIPIWCargo", delItem);
				this.getSqlMapClient().delete("delGIPIWItem", delItem);
			}
			
			// INSERT/UPDATE ITEMS
			for(GIPIWItem setItem: setItems) {
				this.getSqlMapClient().insert("setGIPIWItem", setItem);
				this.getSqlMapClient().insert("setGIPIWCargo", setItem.getGipiWCargo());
			}
			
			// DELETE CARGO CARRIERS
			for(Map<String, Object> delCargo: delCargoCarriers) {
				this.getSqlMapClient().delete("delGIPIWCargoCarrier2", delCargo);
			}
			
			// INSERT CARGO CARRIERS
			for(GIPIWCargoCarrier setCargo: setCargoCarriers) {
				this.getSqlMapClient().insert("setGIPIWCargoCarrier", setCargo);
			}
			
			// DELETE ITEM PERILS
			for(Map<String, Object> delPeril: delItemPerils) {
				this.getSqlMapClient().delete("deleteEndtItemPeril", delPeril);
			}
			
			// INSERT/UPDATE ITEM PERILS 
			for(GIPIWItemPeril setPeril : setItemPerils) {
				this.getSqlMapClient().insert("insertEndtItemPeril", setPeril);
			}
			
			// INCLUDE PERIL WARRANTY AND CLAUSES
			for(Map<String, Object> setWC : setPerilWCs) {
				this.getSqlMapClient().insert("includeWC", setWC);
			}
			
			// DELETE ITEM DEDUCTIBLES
			for(GIPIWDeductible delDed: delDeductibles) {
				this.getSqlMapClient().delete("delGipiWDeductible2", delDed);
			}
			
			// INSERT/UPDATE ITEM DEDUCTIBLES
			for(GIPIWDeductible setDed: setDeductibles) {
				this.getSqlMapClient().insert("saveWDeductible", setDed);
			}
			
			// delete discounts
			if("Y".equals(miscVariables.getString("miscDeletePerilDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWPerilDiscount", formVariables.getInt("parId"));
			}
			
			if("Y".equals(miscVariables.getString("miscDeleteItemDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWItemDiscount", formVariables.getInt("parId"));
			}
			
			if("Y".equals(miscVariables.getString("miscDeletePolbasDiscById"))){
				this.getSqlMapClient().delete("deleteGIPIWPolbasDiscount", formVariables.getInt("parId"));
			}			
			
			this.getSqlMapClient().executeBatch();
			this.endtPostFormsCommit(params);
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}			
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#saveMarineCargoItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveMarineCargoItem(Map<String, Object> params)
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
			
			List<GIPIWCargoCarrier> carrierItems = (List<GIPIWCargoCarrier>) params.get("carrierItems");
			for(GIPIWCargoCarrier cargoCarrier : carrierItems){
				System.out.println("Saving record/s for Carrier List: "+cargoCarrier.getParId() + "\t" + cargoCarrier.getItemNo() + "\t" + cargoCarrier.getVesselCd());
				this.getSqlMapClient().insert("setGIPIWCargoCarrier", cargoCarrier);
			}
			
			// insert, update, delete item deductibles
			if((params.get("deductibleInsList") != null && ((List<GIPIWDeductible>) params.get("deductibleInsList")).size() > 0) ||
				(params.get("deductibleDelList") != null && ((List<Map<String, Object>>) params.get("deductibleDelList")).size() > 0)){				
				this.itemMcDAO.updateDeductibleRecords(params, 2);
			}
			
			// insert, update, delete item peril
			if((params.get("itemPerilInsList") != null && ((List<GIPIWItemPeril>) params.get("itemPerilInsList")).size() > 0) ||
				(params.get("itemPerilDelList") != null && ((List<Map<String, Object>>) params.get("itemPerilDelList")).size() > 0)){				
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
		List<GIPIWCargo> marineCargoItems = (List<GIPIWCargo>) params.get("marineCargoItems");
		
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
		
		HashMap<String, Object> paramsMulti = new HashMap<String, Object>();
		paramsMulti.put("paramName", "VESSEL_CD_MULTI");
		String multiVesselCd = (String) this.getSqlMapClient().queryForObject("getParamValueV2", paramsMulti);
		System.out.println("Multi Vessel Cd: "+multiVesselCd);
		
		String[] delItemNos 			  	 = (String[]) params.get("delItemNos");
		Integer parId 					     = (Integer) params.get("parId");
		String[] delCarrItemNos				 = (String[]) params.get("delCarrItemNos");
		String[] delCarrCds					 = (String[]) params.get("delCarrCds");
		
		if (delCarrItemNos != null && delCarrCds != null){
			for (int a = 0; a < delCarrItemNos.length; a++) {
				Map<String, String> paramsDel = new HashMap<String, String>();
				paramsDel.put("parId", parId.toString());
				paramsDel.put("itemNo", delCarrItemNos[a]);
				paramsDel.put("vesselCd", delCarrCds[a]);
				System.out.println("Deleting record in GIPI_WCARGO_CARRIER for item no.: /"+delCarrItemNos[a]+"/ vessel cd: /"+delCarrCds[a]);
				this.sqlMapClient.update("delGIPIWCargoCarrier2", paramsDel);
			}
		}
		
		if (delItemNos != null){
			for (int a = 0; a < delItemNos.length; a++) {
				System.out.println("Deleting record/s:");
				System.out.println("ItemNo: "+delItemNos[a]);
				Map<String, Object> paramsDel = new HashMap<String, Object>();
				paramsDel.put("parId", parId); //andrew - 09.21.2010 - changed the data type
				paramsDel.put("itemNo", Integer.parseInt(delItemNos[a])); //andrew - 09.21.2010 - changed the data type
				this.sqlMapClient.update("preDeleteGIPIWCargo", paramsDel);
			}
			System.out.println("Done Deleting for pre-delete");
		}
		
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
			
			if(marineCargoItems.size() > index){		
				if(Integer.parseInt(marineCargoItems.get(index).getItemNo()) == item.getItemNo()){
					Map<String, Object> paramsCargo = new HashMap<String, Object>();
					paramsCargo.put("parId", marineCargoItems.get(index).getParId());
					paramsCargo.put("itemNo", marineCargoItems.get(index).getItemNo());
					
					if (!marineCargoItems.get(index).getVesselCd().equals(multiVesselCd)){
						System.out.println("Deleting record in GIPI_WCARGO_CARRIER for item no. "+marineCargoItems.get(index).getItemNo());
						this.sqlMapClient.update("delGIPIWCargoCarrier", paramsCargo);
					}	
					
					System.out.println(marineCargoItems.get(index).getParId() + "\t" + marineCargoItems.get(index).getItemNo() + "\t" + marineCargoItems.get(index).getVesselCd());
					if (marineCargoItems.get(index).getDeleteWVes().equals("Y")){
						this.sqlMapClient.update("deleteGIPIWVesAccumulation", paramsCargo);
					}
					
					log.info("Item (Saving)- Saving record on marine cargo ...");
					this.getSqlMapClient().insert("setGIPIWCargo", marineCargoItems.get(index));						
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
		//paramMap.put("parStatus", gipiParList.getParStatus());
		//log.info("Item (Post Form Commit)- Checking additional marine cargo info ...");
		//this.getSqlMapClient().queryForObject("checkAdditionalInfoMN", paramMap);
		//paramMap.clear();
		
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
	 * @param allParams
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	public void endtPostFormsCommit(Map<String, Object> allParams) throws SQLException, JSONException, ParseException {		
		JSONObject vars = (JSONObject) allParams.get("formVariables");		
		JSONObject misc = (JSONObject) allParams.get("miscVariables");
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) allParams.get("gipiWPolbas");
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		Map<String, Object> param = new HashMap<String, Object>();
		
		if(!("Y".equals(vars.getString("varPost")))){			
			param.put("parId", (Integer) vars.getInt("parId"));
			param.put("userId", (String) vars.getString("userId"));
			
			log.info("Post-Forms-Commit : Inserting record to parhist ...");
			this.getSqlMapClient().queryForObject("insertParhist", param);
		}
		
		if("Y".equals(misc.getString("miscNbtInvoiceSw"))){
			if(!("Y".equals(vars.getString("varPost")))){
				log.info("Post-Forms-Commit : Changing item group ...");
				this.getSqlMapClient().queryForObject("changeItemGrp", (Integer) vars.getInt("parId"));
				
				if(!("Y".equals(vars.getString("varEndtTaxSw")))){					
					log.info("Post-Forms-Commit : Deleting bill ...");
					//this.getSqlMapClient().queryForObject("deleteBillOnItem", (Integer) vars.getInt("parId"));
					this.getSqlMapClient().update("deleteBillsDetails", vars.getInt("parId"));
				}				
				
				param.clear();
				param.put("parId", (Integer) vars.getInt("parId"));
				param.put("negateItem", vars.getString("varVNegateItem"));
				param.put("prorateFlag", vars.getString("varVProrateFlag"));
				param.put("compSw", vars.getString("varCompSw"));
				param.put("endtExpDate", vars.get("varVEndtExpiryDate").equals(null) ? null : sdf.parse(vars.getString("varVEndtExpiryDate")));
				param.put("effDate", vars.get("varVEffDate").equals(null) ? null : sdf.parse(vars.getString("varVEffDate")));				
				param.put("shortRtPct", new BigDecimal(vars.getString("varVShortRtPercent").isEmpty() ? "0.00" : vars.getString("varVShortRtPercent")));
				param.put("expDate", vars.get("varVExpiryDate").equals(null) ? null : sdf.parse(vars.getString("varVExpiryDate")));				
				
				log.info("Post-Forms-Commit : Updating GIPI_WPOLBAS ...");
				this.getSqlMapClient().queryForObject("updateGipiWpolbasEndt" + vars.getString("lineCd"), param);				
				
				param.clear();				
				param.put("parId", (Integer) vars.getInt("parId"));
				log.info("Post-Forms-Commit : Creating distribution item ...");
				this.getSqlMapClient().queryForObject("gipis061CreateDistributionItem", param);
				misc.put("miscItemFound", (String) param.get("exist"));
				
				if(!("Y".equals(vars.getString("varEndtTaxSw")))){
					param.clear();
					param.put("parId", (Integer) vars.getInt("parId"));
					log.info("Post-Forms-Commit : Populating Orig item peril and creating winvoice ...");
					this.getSqlMapClient().queryForObject("populateOrigItemPerilEndt", param);
					misc.putOnce("miscPerilFound", (String) param.get("exist"));
				}
				
				if("N".equals(misc.getString("miscItemFound"))){
					log.info("Post-Forms-Commit : Deleting distribution ...");
					this.getSqlMapClient().queryForObject("gipis061DeleteDistribution", (Integer) vars.getInt("parId"));
				}
				
				if(("N".equals(misc.getString("miscPerilFound"))) && !("Y".equals(vars.getString("varEndtTaxSw")))){
					log.info("Post-Forms-Commit : Deleting record on gipi_winvperl ...");
					this.getSqlMapClient().delete("delGIPIWInvPerl", (Integer) vars.getInt("parId"));
					log.info("Post-Forms-Commit : Deleting record on gipi_winv_tax ...");
					this.getSqlMapClient().delete("deleteAllGIPIWinvTax", (Integer) vars.getInt("parId"));
					log.info("Post-Forms-Commit : Delete record on gipi_winvoice ...");
					this.getSqlMapClient().delete("delGIPIWInvoice", (Integer) vars.getInt("parId"));
				}
				
				param.clear();
				param.put("parId", (Integer) vars.getInt("parId"));
				param.put("lineCd", (String) vars.getString("lineCd"));
				param.put("issCd", gipiWPolbas.getIssCd());
				param.put("negateItem", vars.getString("varVNegateItem"));
				param.put("prorateFlag", vars.getString("varVProrateFlag"));
				param.put("compSw", vars.getString("varCompSw"));
				param.put("endtExpiryDate", sdf.parse(vars.getString("varVEndtExpiryDate")));
				param.put("effDate", sdf.parse(vars.getString("varVEffDate")));
				param.put("expiryDate", vars.get("varVExpiryDate").equals(null) ? null : sdf.parse(vars.getString("varVExpiryDate")));
				param.put("shortRtPercent", new BigDecimal(vars.getString("varVShortRtPercent").isEmpty() ? "0.00" : vars.getString("varVShortRtPercent")));
				
				log.info("Post-Forms-Commit : Applying changes in par status ...");
				this.getSqlMapClient().queryForObject("gipis061AddParStatusNo", param);
				
				vars.put("varEndtTaxSw", (String) param.get("varEndtTaxSw"));
				
				param.clear();
				param.put("parId", (Integer) vars.getInt("parId"));
				param.put("endtTaxSw", (String) vars.getString("varEndtTaxSw"));
				log.info("Post-Forms-Commit : Validating par status ...");
				this.getSqlMapClient().queryForObject("validateParStatusEndt", param);				
			}
		}
		
		if("Y".equals(vars.getString("varGroupSw"))){			
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGrp", (Integer) vars.getInt("parId"));
		}
		
		param.clear();
		param.put("parId", (Integer) vars.getInt("parId"));
		param.put("packLineCd", (String) allParams.get("packLineCd"));
		param.put("packSublineCd", (String) allParams.get("packSublineCd"));
		param.put("packPolFlag", vars.getString("varVPackPolFlag"));
		
		log.info("Post-Forms-Commit : Updating gipi_wpack_line_subline ...");
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSublineEndt", param);
		
		if("Y".equals(vars.getString("varVPackPolFlag"))){
			log.info("Post-Forms-Commit : Setting package menu ...");
			this.getSqlMapClient().queryForObject("setPackageMenu1", vars.getString("varVPackPolFlag"));
		}			
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#gipis068NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis068NewFormInstance(
			Map<String, Object> params) throws SQLException {
		
		this.getSqlMapClient().queryForObject("gipis061NewFormInstance", params);
		
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#gipis006NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis006NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS006 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis006NewFormInstance", params);
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCargoDAO#saveGIPIWCargo(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWCargo(Map<String, Object> params) throws SQLException, JSONException {
		log.info("Saving Marine Cargo Items ... ");
		
		try{			
			List<Map<String, Object>> setItems	= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems	= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWCargo> cargoItems			= (List<GIPIWCargo>) params.get("cargoItems");			
			
			// cargo carrier
			List<GIPIWCargoCarrier> setCarriers		= (List<GIPIWCargoCarrier>) params.get("setCarrierRows");
			List<Map<String, Object>> delCarriers	= (List<Map<String, Object>>) params.get("delCarrierRows");
			
			// ves accumulation
			List<Map<String, Object>> delVesAccumulations = (List<Map<String, Object>>) params.get("delVesAccumuRows");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductRows");
			
			GIPIWPolbas gipiWPolbas				= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc						= (JSONObject) params.get("misc");
			Map<String, Object> paramMap		= null;
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
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
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
				
				params.put("itemGrp", item.get("itemGrp"));
			}
			
			// GIPI_WCARGO (insert/update)
			for(GIPIWCargo cargo : cargoItems){
				log.info("Inserting/Updating record on gipi_wcargo ...");
				this.getSqlMapClient().insert("setGIPIWCargo", cargo);
			}
			
			// GIPI_WCARGO_CARRIER (delete)
			for(Map<String, Object> delCarrier : delCarriers){				
				log.info("Deleting record on gipi_wcargo_carrier ...");
				this.getSqlMapClient().delete("delGIPIWCargoCarrier2", delCarrier);
			}
			
			// GIPI_WCARGO_CARRIER (insert/update)
			for(GIPIWCargoCarrier carrier : setCarriers){
				log.info("Inserting/Updating record on gipi_wcargo_carrier ...");
				this.getSqlMapClient().insert("setGIPIWCargoCarrier", carrier);
			}
			
			// GIPI_WVES_ACCUMULATION
			for(Map<String, Object> delVesAccumu : delVesAccumulations){
				log.info("Deleting record on gipi_wves_accumulation ...");
				this.getSqlMapClient().delete("deleteGIPIWVesAccumulation", delVesAccumu);
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
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}
	
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}
	
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}	
}
