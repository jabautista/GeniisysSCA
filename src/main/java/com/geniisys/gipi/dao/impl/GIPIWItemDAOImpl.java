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

import org.apache.commons.lang.ArrayUtils;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.Debug;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWItemDAOImpl.
 */
public class GIPIWItemDAOImpl implements GIPIWItemDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWItemDAOImpl.class);

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#getGIPIWItem(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getGIPIWItem(Integer parId) throws SQLException {
		return this.getSqlMapClient().queryForList("getWItem", parId);
	}

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
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#updateItemValues(java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.math.BigDecimal, java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public boolean updateItemValues(BigDecimal tsiAmt, BigDecimal premAmt,
			BigDecimal annTsiAmt, BigDecimal annPremAmt, Integer parId,
			Integer itemNo) throws SQLException {
		log.info("Updating item details...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tsiAmt", tsiAmt);
		params.put("premAmt", premAmt);
		params.put("annTsiAmt", annTsiAmt);
		params.put("annPremAmt", annPremAmt);
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().queryForObject("updateItemValues", params);
		log.info("Updating successful.");
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#getWItemCount(java.lang.Integer)
	 */
	@Override
	public Integer getWItemCount(Integer parId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getWItemCount", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#updateWPolbas(java.lang.Integer)
	 */
	@Override
	public void updateWPolbas(Integer parId) throws SQLException {
		log.info("Updating polbasic details...");
		this.getSqlMapClient().queryForObject("updateWPolbas", parId);
		log.info("Update successful.");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#getTsi(java.lang.Integer)
	 */
	@Override
	public void getTsi(Integer parId) throws SQLException {
		log.info("Getting TSI...");
		this.getSqlMapClient().queryForObject("getTsi", parId);
		log.info("Successful.");
	}
	
	@Override
	public GIPIWItem getTsiPremAmt(Integer parId, Integer itemNo)
			throws SQLException {
		Map<String , String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return (GIPIWItem) this.sqlMapClient.queryForObject("getTsiPremAmt", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWItemDAO#getDistinctItemNos(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getDistinctItemNos(int parId) throws SQLException {		
		List<GIPIWItem> gipiWitems = this.sqlMapClient.queryForList("getDistinctItemNo", parId);
		List<Integer> itemNos = new ArrayList<Integer>();
		if (gipiWitems != null) {
			log.info("Records obtained : " + gipiWitems.size());
			for (int i = 0; i < gipiWitems.size(); i++) {
				itemNos.add(gipiWitems.get(i).getItemNo());
				log.info("Item No " + i + ":" + itemNos.get(i));
			}
		}
		return itemNos;
	}

	@Override
	public void delGIPIWItem(Integer parId, Integer itemNo) throws SQLException {
		log.info("Deleting GIPIWItem records for PAR ID "+parId+" ITEM NO "+itemNo);
		Map<String , Object> params = new HashMap<String, Object>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		this.getSqlMapClient().queryForObject("delGIPIWItem", params);
	}

	@Override
	public void insertGIPIWItem(GIPIWItem item) throws SQLException {
		log.info("Inserting GIPIWItem for PAR NO "+item.getParId()+" ITEM NO "+item.getItemNo());
		log.info("regionCd: "+item.getRegionCd());
		this.getSqlMapClient().insert("setGIPIWItem", item);
		log.info("Item inserted.");
	}

	@Override
	public void updateGipiWPackLineSubline(Map<String, Object> params)
			throws SQLException {
		log.info("Updating pack details based on lines and sublines...");
		this.getSqlMapClient().queryForObject("updateGipiWPackLineSubline", params);
	}
	
	public void setGIPIWItemWGroup(GIPIWItem item) throws SQLException {
		log.info("Inserting GIPIWItem for PAR NO "+item.getParId()+" ITEM NO "+item.getItemNo());
		log.info("regionCd: "+item.getRegionCd());
		log.info("desc2: "+item.getItemDesc2());
		this.getSqlMapClient().queryForObject("setGIPIWItemWGroup", item);
		log.info("Item inserted.");
	}
	
	public String validateEndtAddItem(Map<String, Object> params) throws SQLException {
		log.info("Validating addition of items...");
		return (String) this.getSqlMapClient().queryForObject("validateEndtAddItem", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIWItem> getEndtAddItemList(Map<String, Object> params) throws SQLException {
		log.info("Getting list items for addition...");
		return (List<GIPIWItem>) this.getSqlMapClient().queryForList("getEndtAddItemList", params);
	}

	public void deleteItem(Integer parId, Integer itemNo) throws SQLException {
		log.info("Deleting item no "+itemNo+" for Par id "+parId+" and related records....");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().queryForObject("deleteItem", params);
	}

	@Override
	public void updateItemGroup(Integer parId, Integer itemGrp, Integer itemNo)
			throws SQLException {
		log.info("Grouping items per Bill...");
		Map<String,Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemGrp", itemGrp);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().update("updateItemGroup", params);
		
	}

	@Override
	public Map<String, Object> getPlanDetails(Map<String, Object> params)
			throws SQLException {
		log.info("Getting item plan details...");
		log.info("parId: "+params.get("parId"));
		log.info("packParId: "+params.get("packParId"));
		log.info("packLineCd: "+params.get("packLineCd"));
		log.info("packSublineCd: "+params.get("packSublineCd"));
		this.getSqlMapClient().update("getPlanDetails", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemMC(int parId) throws SQLException {
		log.info("Getting item and vehicle info ...");		
		return (List<GIPIWItem>) this.getSqlMapClient().queryForList("getGIPIWItemMCForPar", parId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemFI(int parId) throws SQLException {
		log.info("Getting item and fire info ...");
		return (List<GIPIWItem>) this.getSqlMapClient().queryForList("getGIPIWItemFIForPar", parId);
	}	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemEN(int parId) throws SQLException {
		log.info("Getting item and engineering info ...");
		return this.getSqlMapClient().queryForList("getGIPIWItemENForPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemAC(int parId) throws SQLException {
		log.info("DAO - Getting List of Items for AC ...");
		List<GIPIWItem> ahItem = this.getSqlMapClient().queryForList("getGIPIWItemACForPar", parId);
		log.info("DAO - Retrieved " + ahItem.size() + " items for accident...");
		return ahItem;
	}
	
	@Override
	public void parItemPostFormsCommit(Map<String, Object> params)
			throws SQLException, JSONException {
		JSONObject vars = (JSONObject) params.get("vars");
		JSONObject pars = (JSONObject) params.get("pars");
		JSONObject misc = (JSONObject) params.get("misc");
		
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		System.out.println("pasok sa parItemPostFormsCommit");
		System.out.println(vars.getString("varPost2"));
		if( "N".equals(vars.getString("varPost2"))){
			return;
		}
		if(vars.isNull("varPost")){
			paramMap.put("parId", params.get("parId"));
			paramMap.put("userId", params.get("userId"));
			
			log.info("Post-Forms-Commit : Inserting record to parhist ...");
			this.getSqlMapClient().queryForObject("insertParhist", paramMap);
		}
		
		if(vars.isNull("varPost") && "Y".equals(misc.getString("miscNbtInvoiceSw"))){
			log.info("Post-Forms-Commit : Deleting co_insurer ...");
			this.getSqlMapClient().queryForObject("deleteCoInsurer", params.get("parId"));
			
			paramMap.put("packPolFlag", vars.getString("varVPackPolFlag"));
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
			
			pars.put("paramDdlCommit", "Y");
			
			log.info("Post-Forms-Commit : Deleting bill ...");
			this.getSqlMapClient().queryForObject("deleteBillsDetails", params.get("parId"));
			
			paramMap.put("lineCd", gipiWPolbas.getLineCd());
			paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
			paramMap.put("issCd", gipiWPolbas.getIssCd());
			paramMap.put("invoiceSw", misc.getString("miscNbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp"));
			paramMap.put("appUser", params.get("userId"));	//Gzelle 10092014
			
			//Ditong procedure ung previous na may commit sa loob ng procedure
			log.info("Post-Forms-Commit : Adding par status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			
			log.info("Post-Forms-Commit : Updating gipi_wpolbas no. of items ...");
			this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem", gipiWPolbas.getParId());			
		}else if (vars.isNull("varPost")){// mukang di rin kasama to
			paramMap.put("lineCd", gipiWPolbas.getLineCd());
			paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
			paramMap.put("issCd", gipiWPolbas.getIssCd());
			paramMap.put("invoiceSw", misc.getString("miscNbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp"));			
			log.info("Post-Forms-Commit : Adding par status no ...");
			
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
		}
		
		// hindi in process to
		if("Y".equals(vars.getString("varGroupSw"))){
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
		}
		
		log.info("Post-Forms-Commit : Updating gipi_wpacksubline ...");
		this.getSqlMapClient().queryForObject("updateGipiWPackLineSublineByParId", gipiWPolbas.getParId());
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemCA(int parId) throws SQLException {
		log.info("Getting item and casualty info ...");
		return this.getSqlMapClient().queryForList("getGIPIWItemCAForPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemMN(int parId) throws SQLException {
		log.info("Getting item and marine cargo info ...");
		return this.getSqlMapClient().queryForList("getGIPIWItemMNForPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemAV(int parId) throws SQLException {
		log.info("Getting item and aviation info...");
		return this.getSqlMapClient().queryForList("getGIPIWItemAVForPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getParItemMH(int parId) throws SQLException {
		log.info("Getting item and marine hull info...");
		return this.getSqlMapClient().queryForList("getGIPIWItemMHForPar", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getPackParPolicyItems(int packParId) throws SQLException {
		log.info("Getting pack policy items ...");		
		return this.getSqlMapClient().queryForList("getGIPIWItemForPackPolicyItems", packParId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getPackParPolicyItems2(Integer packParId) throws SQLException {
		log.info("Getting pack policy items ...");		
		return this.getSqlMapClient().queryForList("getGIPIWItemForPackPolicyItems", packParId);
	}

	@Override
	public Map<String, Object> gipiw095NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS095 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis095NewFormInstance", params);
		return params;
	}
	
	@Override
	public Map<String, Object> gipiw096NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS096 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis096NewFormInstance", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void savePackagePolicyItems(Map<String, Object> params)
			throws SQLException, JSONException {		
		log.info("Saving Package Policy Items ...");
		
		try{
			List<Map<String, Object>> setItems = (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems = (List<Map<String, Object>>) params.get("delItems");
			
			List<Map<String, Object>> delPackInvTaxes	= (List<Map<String, Object>>) params.get("delPackInvTaxes");
			List<Map<String, Object>> delCommInvPerils	= (List<Map<String, Object>>) params.get("delCommInvPerils");
			List<Map<String, Object>> delCommInvoices	= (List<Map<String, Object>>) params.get("delCommInvoices");
			List<Map<String, Object>> delInvoices		= (List<Map<String, Object>>) params.get("delInvoices");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// GIPI_WPACKAGE_INV_TAX (delete)
			for(Map<String, Object> packInvTax : delPackInvTaxes){
				log.info("Deleting record on gipi_wpackage_inv_tax ...");
				this.getSqlMapClient().delete("deleteGIPIWPackageInvTaxByParIdItemGrp", packInvTax);
			}
			
			// GIPI_WCOMM_INV_PERILS (delete)
			for(Map<String, Object> commInvPeril : delCommInvPerils){
				log.info("Deleting record on gipi_wcomm_inv_perils ...");
				this.getSqlMapClient().delete("deleteGIPIWCommInvPerilsByParIdItemGrp", commInvPeril);
			}
			
			// GIPI_WCOMM_INVOICES (delete)
			for(Map<String, Object> commInvoice : delCommInvoices){
				log.info("Deleting record on gipi_wcomm_invoices ...");
				this.getSqlMapClient().delete("deleteWCommInvoice", commInvoice);
			}
			
			// GIPI_WINVOICE (delete)
			for(Map<String, Object> invoice : delInvoices){
				log.info("Deleting record on gipi_winvoice ...");
				this.getSqlMapClient().delete("deleteGIPIWInvoiceByParIdItemGrp", invoice);				
			}
			
			// GIPI_WITEM (delete)
			for(Map<String, Object> item : delItems){				
				log.info("Deleting record on gipi_witem ...");
				this.getSqlMapClient().delete("delGIPIWItem", item);
			}
			
			// GIPI_WITEM (insert/update)			
			for(Map<String, Object> item : setItems){
				System.out.println("item group :"+item.get("itemGrp"));
				System.out.println(item);
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
			}
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().startBatch();
			this.gipis095PostFormsCommit(params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
//			throw new SQLException(e.getCause());
			throw e; //replace by steven 2.4.2013; nirereset kasi ung taas na code ung e.getErrorCode() into "0".
		}finally{
			this.getSqlMapClient().endTransaction();			
		}
	}
	
	@SuppressWarnings("unchecked")
	private void gipis095PostFormsCommit(Map<String, Object> params) throws SQLException, JSONException {
		JSONObject vars = (JSONObject) params.get("vars");
		Integer packParId = (Integer) params.get("packParId");
		
		if("Y".equalsIgnoreCase(vars.getString("varSwitchInsert")) || "Y".equalsIgnoreCase(vars.getString("varSwitchDelete"))){
			log.info("Post-Forms-Commit : Updating gipi_wpack_line_subline ...");
			this.getSqlMapClient().queryForObject("updateGIPIWPackLineSublineGIPIS095", packParId);
			
			if("Y".equalsIgnoreCase(vars.getString("varSwitchInsert"))){
				log.info("Post-Forms-Commit : Updating gipi_pack_parlist (Insert Switch) ...");
				this.getSqlMapClient().queryForObject("gipis095PostFormsCommitInsertSw", packParId);
			}
			
			if("Y".equalsIgnoreCase(vars.getString("varSwitchDelete"))){
				log.info("Post-Forms-Commit : Updating gipi_pack_par_list (Delete Switch) ...");
				this.getSqlMapClient().queryForObject("gipis095PostFormsCommitDeleteSw", packParId);
			}
			
			log.info("Post-Forms-Commit : Changing item group (Package) ...");
			this.getSqlMapClient().queryForObject("gipis095ChangeItemGroup", packParId);
			
			log.info("Post-Forms-Commit : Updating gipi_wpolbas and gipi_pack_wpolbas ...");
			this.getSqlMapClient().queryForObject("gipis095UpdateGIPIPackWPolbas", packParId);
			
			log.info("Post-Forms-Commit : Updating gipi_wpolbas bank_ref_no ...");
			this.getSqlMapClient().queryForObject("gipis095UpdateGIPIWPolbasRefNo", packParId);
			
			/*log.info("Post-Forms-Commit : Deleting bill (Package) ...");
			this.getSqlMapClient().queryForObject("gipis095DeleteBill", packParId);
			
			log.info("Post-Forms-Commit : Delete distribution (Package) ...");
			this.getSqlMapClient().queryForObject("gipis095DeleteDistribution", packParId);*/	
			
			//added by steven 06.06.2013; commented the code above.
			List<Map<String, Object>> insertedItems = (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> deletedItems = (List<Map<String, Object>>) params.get("delItems");
			List<Map<String, Object>> setItems = new ArrayList<Map<String,Object>>();
			List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
			Map<String, Object> itemParams = new HashMap<String, Object>();
			int[] parIdAddArray = {};
			int[] parIdDelArray = {};
			boolean exist = false;
			
			for(Map<String, Object> item : insertedItems){
				itemParams.put("parId", item.get("parId"));
				itemParams.put("packParId", params.get("packParId"));
				itemParams.put("appUser", params.get("appUser"));
				itemParams.put("itemGrp", item.get("itemGrp"));
				setItems.add(itemParams);
				itemParams = new HashMap<String, Object>();
			}
			for(Map<String, Object> item : deletedItems){
				itemParams.put("parId", item.get("parId"));
				itemParams.put("packParId", params.get("packParId"));
				itemParams.put("appUser", params.get("appUser"));
				itemParams.put("itemGrp", item.get("itemGrp"));
				delItems.add(itemParams);
				itemParams = new HashMap<String, Object>();
			}
			
			for(Map<String, Object> itemAdded : setItems){	
				exist = false;
				for (int i = 0; i < parIdAddArray.length; i++) {
					if ((Integer)itemAdded.get("parId") == parIdAddArray[i]) {
						exist = true;
					}
				}
				if (!exist) {
					System.out.println("Parameters:::::: parId=" + itemAdded.get("parId") + " packParId=" + itemAdded.get("packParId")+ " itemGrp=" + itemAdded.get("itemGrp"));
					log.info("Post-Forms-Commit : Deleting bill (Package) ...");
					this.getSqlMapClient().queryForObject("gipis095DeleteBill2", itemAdded);
					log.info("Post-Forms-Commit : Delete distribution (Package) ...");
					this.getSqlMapClient().queryForObject("gipis095DeleteDistribution2", itemAdded);
					parIdAddArray = ArrayUtils.add(parIdAddArray, (Integer)itemAdded.get("parId"));
				}
			}
			
			for(Map<String, Object> itemDeleted : delItems){
				exist = false;
				for (int i = 0; i < parIdDelArray.length; i++) {
					if ((Integer)itemDeleted.get("parId") == parIdDelArray[i]) {
						exist = true;
					}
				}
				if (!exist) {
					System.out.println("Parameters:::::: parId=" + itemDeleted.get("parId") + " packParId=" + itemDeleted.get("packParId")+ " itemGrp=" + itemDeleted.get("itemGrp"));
					log.info("Post-Forms-Commit : Deleting bill (Package) ...");
					this.getSqlMapClient().queryForObject("gipis095DeleteBill2", itemDeleted);
					this.getSqlMapClient().queryForObject("gipis095DeleteWcommInvDtl", itemDeleted); //added by steven 10.18.2013
					log.info("Post-Forms-Commit : Delete distribution (Package) ...");
					this.getSqlMapClient().queryForObject("gipis095DeleteDistribution2", itemDeleted);
					parIdDelArray = ArrayUtils.add(parIdDelArray, (Integer)itemDeleted.get("parId"));
				}
			}
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItem> getPackageRecords(int packParId) throws SQLException {
		log.info("Getting package item line and subline list ...");
		return (List<GIPIWItem>) this.getSqlMapClient().queryForList("getPackageRecords", packParId);
	}
	
	@SuppressWarnings("unchecked")
	public void endtItemPostFormsCommit(Map<String, Object> params)
			throws SQLException, JSONException {
		
			JSONObject vars = (JSONObject) params.get("vars");
			JSONObject pars = (JSONObject) params.get("pars");
			JSONObject misc = (JSONObject) params.get("misc");
			List<Map<String, Object>> setItems	= (List<Map<String, Object>>) params.get("setItems");

			GIPIWPolbas gipiWPolbas = (GIPIWPolbas) params.get("gipiWPolbas");

			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("userId", params.get("userId"));
			paramMap.put("parId", params.get("parId"));
			paramMap.put("packParId", params.get("packParId"));
			paramMap.put("varPost", vars.isNull("varPost") ? null : vars.isNull("varPost"));
			paramMap.put("varPost2", vars.getString("varPost2"));
			paramMap.put("nbtInvoiceSw", misc.getString("miscNbtInvoiceSw"));
			/*paramMap.put("varEndtTaxSw", vars.getString("varEndtTaxSw"));*/
			paramMap.put("varGroupSw", vars.getString("varGroupSw"));
			paramMap.put("varNegateItem", vars.getString("varNegateItem"));
			paramMap.put("confirmAction1", misc.getInt("confirmAction1"));
			paramMap.put("confirmAction2", misc.getInt("confirmAction2"));
			System.out.println("endtItemPostFormsCommit PARAMETERS :: " + paramMap);
			
			this.getSqlMapClient().update("endtItemPostFormsCommit", paramMap);
		
		
/*		if ("N".equals(vars.getString("varPost2"))) {
			return;
		}
		if (vars.isNull("varPost")) {
			paramMap.put("parId", params.get("parId"));
			paramMap.put("userId", params.get("userId"));

			log.info("Post-Forms-Commit : Inserting record to parhist ...");
			this.getSqlMapClient().queryForObject("insertParhist", paramMap);
		}

		if (vars.isNull("varPost") && "Y".equals(misc.getString("miscNbtInvoiceSw"))) {
			
			log.info("Post-Forms-Commit : Deleting co_insurer ...");
			this.getSqlMapClient().queryForObject("deleteCoInsurer",
					params.get("parId"));
			
			//paramMap.put("packPolFlag", vars.getString("varVPackPolFlag"));
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);

			pars.put("paramDdlCommit", "Y");
			
			if((vars.isNull("varEndtTaxSw") ? "N" : vars.getString("varEndtTaxSw")) != "Y"){
				log.info("Post-Forms-Commit : Deleting bill ...");
				this.getSqlMapClient().queryForObject("deleteBillsDetails", params.get("parId"));
			}
						
			log.info("Post-Forms-Commit : Updating GIPIWPolbas ...");
			this.getSqlMapClient().queryForObject("updateGipiWpolbasEndtFI",params.get("parId"));
			
			if(setItems.size() > 0) {
				this.getSqlMapClient().update("gipis039CreateDistribution",params.get("parId"));
			} 

			if((vars.isNull("varEndtTaxSw") ? "N" : vars.getString("varEndtTaxSw")) != "Y"){
				
			}
			
			if(setItems.size() > 0) {
				this.getSqlMapClient().update("gipis039DeleteDistribution",params.get("parId"));
			} 
			
			paramMap.put("lineCd", gipiWPolbas.getLineCd());
			paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
			paramMap.put("issCd", gipiWPolbas.getIssCd());
			paramMap.put("invoiceSw", misc.getString("miscNbtInvoiceSw"));
			paramMap.put("itemGrp", null);
			log.info("Post-Forms-Commit : Adding par status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);

			log.info("Post-Forms-Commit : Updating gipi_wpolbas no. of items ...");
			this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem",gipiWPolbas.getParId());
			
		} else if (vars.isNull("varPost")) {
			paramMap.put("lineCd", gipiWPolbas.getLineCd());
			paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
			paramMap.put("issCd", gipiWPolbas.getIssCd());
			paramMap.put("invoiceSw", misc.getString("miscNbtInvoiceSw"));
			paramMap.put("itemGrp", null);
			log.info("Post-Forms-Commit : Adding par status no ...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
		}

		if ("Y".equals(vars.getString("varGroupSw"))) {
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
		}

		log.info("Post-Forms-Commit : Updating gipi_wpacksubline ...");
		this.getSqlMapClient().queryForObject("updateGipiWPackLineSublineByParId", gipiWPolbas.getParId());
		
		
		}*/
	}
	
	public Integer checkItemExist(Integer parId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkItemExist", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveEndtPackagePolicyItems(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Endt Package Policy Items ...");
		
		try{
			List<Map<String, Object>> setItems = (List<Map<String, Object>>) params.get("setItems");
			List<GIPIWItem> delItems = (List<GIPIWItem>) params.get("delItems");
			Integer packParId = (Integer)params.get("packParId");
			String lineCd 	  = (String) params.get("lineCd");
			String sublineCd  = (String) params.get("sublineCd");
			String issCd      = (String) params.get("issCd");
			Integer issueYy   = (Integer) params.get("issueYy");
			Integer polSeqNo  = (Integer) params.get("polSeqNo");
			Integer renewNo   = (Integer) params.get("renewNo");
			String userId     = (String) params.get("userId");
			
			Map<String, Object> itemParams = new HashMap<String, Object>();
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//Deletion of GIPI_WITEM
			for(GIPIWItem item : delItems){
				Integer gipiWItemCount = this.checkItemExist(item.getParId());
				
				if(gipiWItemCount == 1){
					itemParams.clear();
					itemParams.put("parId", item.getParId());
					itemParams.put("parStatus", 99);
					itemParams.put("appUser", userId);
					Debug.print(itemParams);
					this.getSqlMapClient().update("updatePARStatus", itemParams);
					this.getSqlMapClient().executeBatch();
				}
				
				//this.deleteEndtPackPolItems(item, userId);
				Map<String, Object> delParams = new HashMap<String, Object>();
				log.info("Deleting record on gipi_witem ...");
				delParams.put("parId", item.getParId());
				delParams.put("itemNo", item.getItemNo());
				delParams.put("itemGrp", item.getItemGrp());
				delParams.put("itemGroup", item.getItemGrp());
				delParams.put("packLineCd", item.getPackLineCd());
				delParams.put("appUser", userId);
				
				Debug.print("Deletion parameters: " + delParams);
				
				log.info("Deleting record on gipi_wpackage_inv_tax ...");
				this.getSqlMapClient().delete("deleteGIPIWPackageInvTaxByParIdItemGrp", delParams);
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting record on gipi_wcomm_inv_perils ...");
				this.getSqlMapClient().delete("deleteGIPIWCommInvPerilsByParIdItemGrp", delParams);
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting record on gipi_wcomm_invoices ...");
				this.getSqlMapClient().delete("deleteWCommInvoice", delParams);
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting record on gipi_winvoice ...");
				this.getSqlMapClient().delete("deleteGIPIWInvoiceByParIdItemGrp", delParams);
				this.getSqlMapClient().executeBatch();
				
				log.info("Deleting other related records...");
				this.getSqlMapClient().delete("gipis096DelRecords", delParams);
				this.getSqlMapClient().executeBatch();
				
			    log.info("Deleting record on gipi_witem ...");
				this.getSqlMapClient().delete("delGIPIWItem", delParams);
				this.getSqlMapClient().executeBatch();
			}
			
			// Insert/Update of GIPI_WITEM			
			for(Map<String, Object> item : setItems){
				String recordStatus = (String) item.get("recordStatus");
				Integer parId = (Integer) item.get("parId");
				Integer itemNo = (Integer) item.get("itemNo");
				String packLineCd = (String) item.get("packLineCd");
				String packSublineCd = (String) item.get("packSublineCd");
				
				if(recordStatus.equals("0")){
					//PRE-INSERT Block B480
					itemParams.clear();
					itemParams.put("parId", parId);
					itemParams.put("parStatus", 3);
					itemParams.put("appUser", userId);
					this.getSqlMapClient().update("updatePARStatus", itemParams);
					this.getSqlMapClient().executeBatch();
				}
				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
				this.getSqlMapClient().executeBatch();
				
				if(recordStatus.equals("0")){
					//POST-INSERT Block B480
					log.info("Inserting record on gipi_witem table with par_id = " + parId + " & item_no= " + itemNo);
					itemParams.clear();
					itemParams.put("parId", parId);
					itemParams.put("itemNo", itemNo);
					itemParams.put("packLineCd", packLineCd);
					itemParams.put("packSublineCd", packSublineCd);
					itemParams.put("lineCd", lineCd);
					itemParams.put("sublineCd", sublineCd);
					itemParams.put("issCd", issCd);
					itemParams.put("issueYy", issueYy);
					itemParams.put("polSeqNo", polSeqNo);
					itemParams.put("renewNo", renewNo);
					itemParams.put("appUser", userId);
					Debug.print(itemParams);
					this.getSqlMapClient().insert("popPack", itemParams);
				}
				this.getSqlMapClient().executeBatch();
			}
			
			//POST-FORMS-COMMIT
			if(setItems.size() > 0 || delItems.size() > 0){
				log.info("POST-FORMS-COMMIT(GIPIS096) for pack_par_id: " + packParId);
				itemParams.clear();
				itemParams.put("packParId", packParId);
				itemParams.put("appUser", userId);
				this.getSqlMapClient().update("postFormsCommitGIPIS096", itemParams);
				this.getSqlMapClient().executeBatch();
			}
			
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
	
	@SuppressWarnings("unused")
	private void deleteEndtPackPolItems(GIPIWItem item, String userId) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("Deleting record on gipi_witem ...");
		params.put("parId", item.getParId());
		params.put("itemNo", item.getItemNo());
		params.put("itemGrp", item.getItemGrp());
		params.put("itemGroup", item.getItemGrp());
		params.put("packLineCd", item.getPackLineCd());
		params.put("appUser", userId);
		
		Debug.print(params);
		
		log.info("Deleting record on gipi_wpackage_inv_tax ...");
		this.getSqlMapClient().delete("deleteGIPIWPackageInvTaxByParIdItemGrp", params);
		
		log.info("Deleting record on gipi_wcomm_inv_perils ...");
		this.getSqlMapClient().delete("deleteGIPIWCommInvPerilsByParIdItemGrp", params);
		
		log.info("Deleting record on gipi_wcomm_invoices ...");
		this.getSqlMapClient().delete("deleteWCommInvoice", params);
		
		log.info("Deleting record on gipi_winvoice ...");
		this.getSqlMapClient().delete("deleteGIPIWInvoiceByParIdItemGrp", params);
		
		log.info("Deleting other related records...");
		this.getSqlMapClient().delete("gipis096DelRecords", params);
		
	    log.info("Deleting record on gipi_witem ...");
		this.getSqlMapClient().delete("delGIPIWItem", params);
	}

	@Override
	public Map<String, Object> gipis096ValidateItemNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gipis096ValidateItemNo", params);
		return params;
	}

	@Override
	public void renumber(Integer parId, GIISUser USER) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Renumbering items ...");	//modified by Gzelle 09302014
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("appUser", USER.getUserId());
			this.getSqlMapClient().queryForObject("renumber2", params);
			
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

	@Override	//added by Gzelle 10242014
	public String checkGetDefCurrRt() throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkGetDefCurrRt");
	}
}
