package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.dao.GIPIWCasualtyItemDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWCasualtyItem;
import com.geniisys.gipi.entity.GIPIWCasualtyPersonnel;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.exceptions.PostedRIExistingException;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWCasualtyItemDAOImpl implements GIPIWCasualtyItemDAO{
	
	private SqlMapClient sqlMapClient;
	private GIPIParItemMCDAO itemMcDAO;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	
	private static Logger log = Logger.getLogger(GIPIWCasualtyItemDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}	
	
	public GIPIParItemMCDAO getItemMcDAO() {
		return itemMcDAO;
	}
	public void setItemMcDAO(GIPIParItemMCDAO itemMcDAO) {
		this.itemMcDAO = itemMcDAO;
	}	

	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}

	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#getGipiWCasualtyItem(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWCasualtyItem> getGipiWCasualtyItem(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWCasualtyItems", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#saveGIPIParCasualtyItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIParCasualtyItem(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIWCasualtyItem> casualtyItems = (List<GIPIWCasualtyItem>) params.get("casualtyitems");
			List<GIPIWGroupedItems> groupedItems = (List<GIPIWGroupedItems>) params.get("groupedItems");
			List<GIPIWCasualtyPersonnel> personnelItems = (List<GIPIWCasualtyPersonnel>) params.get("personnelItems");
			
			String[] delGroupItemsItemNos	= (String[]) params.get("delGroupItemsItemNos");
			String[] delGroupedItemNos		= (String[]) params.get("delGroupedItemNos");
			String[] delPersonnelItemNos	= (String[]) params.get("delPersonnelItemNos");
			String[] delPersonnelNos		= (String[]) params.get("delPersonnelNos");
			String parId 					= params.get("parId").toString();
			
			if (delGroupItemsItemNos != null && delGroupedItemNos != null){
				for (int a = 0; a < delGroupItemsItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delGroupItemsItemNos[a]);
					paramsDel.put("groupedItemNo", delGroupedItemNos[a]);
					System.out.println("Deleting record in GIPI_WGROUPED_ITEMS for item no.: /"+delGroupItemsItemNos[a]+"/ groupedItemNo: /"+delGroupedItemNos[a]);
					this.sqlMapClient.update("delGIPIWGroupedItems2", paramsDel);
				}
			}
			
			if (delPersonnelItemNos != null && delPersonnelNos != null){
				for (int a = 0; a < delPersonnelItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delPersonnelItemNos[a]);
					paramsDel.put("personnelNo", delPersonnelNos[a]);
					System.out.println("Deleting record in GIPI_WCASUALTY_PERSONNEL for item no.: /"+delPersonnelItemNos[a]+"/ personnelNo: /"+delPersonnelNos[a]);
					this.sqlMapClient.update("delGIPIWCasualtyPersonnel2", paramsDel);
				}
			}
			
			System.out.println("Saving record/s For Group Items:");
			System.out.println("ParID\tItemNo\tGroupItemNo\tGroupItemTitle");
			System.out.println("=======================================================================================");
			for(GIPIWGroupedItems group:groupedItems){
				System.out.println(group.getParId() + "\t" + group.getItemNo() + "\t" + group.getGroupedItemNo() + "\t" + group.getGroupedItemTitle());
				this.getSqlMapClient().insert("setGipiWGroupedItems", group);
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s For Personnel Items:");
			System.out.println("ParID\tItemNo\tPersonnelNo\tPersonnelName");
			System.out.println("=======================================================================================");
			for(GIPIWCasualtyPersonnel personnel:personnelItems){
				System.out.println(personnel.getParId() + "\t" + personnel.getItemNo() + "\t" + personnel.getPersonnelNo() + "\t" + personnel.getPersonnelName());
				this.getSqlMapClient().insert("setGipiWCasualtyPersonnel", personnel);
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo");
			System.out.println("=======================================================================================");
			for(GIPIWCasualtyItem casualty:casualtyItems){
				System.out.println(casualty.getParId() + "\t" + casualty.getItemNo() );
				this.getSqlMapClient().insert("setGipiWCasualtyItems", casualty);
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
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#gipis061NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis061NewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("gipis061NewFormInstance", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#saveGIPIEndtCasualtyItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIEndtCasualtyItem(Map<String, Object> allParams)
			throws SQLException, ParseException {	
		log.info("Saving endt casualty items ...");
		try{
			List<GIPIWItem> setItems				= (List<GIPIWItem>) allParams.get("setItems");
			List<Map<String, Object>> delItems		= (List<Map<String, Object>>) allParams.get("delItems");
			List<GIPIWCasualtyItem> casualtyItems 	= (List<GIPIWCasualtyItem>) allParams.get("casualtyItems");
			Map<String, Integer> itemNoList 		= (Map<String, Integer>) allParams.get("itemNoList");
			
			// casualty_personnel
			List<GIPIWCasualtyPersonnel> insPersonnels 	= (List<GIPIWCasualtyPersonnel>) allParams.get("setPersonnels");
			List<Map<String, Object>> delPersonnels		= (List<Map<String, Object>>) allParams.get("delPersonnels");
			
			// grouped_items
			List<GIPIWGroupedItems> insGroupedItems 	= (List<GIPIWGroupedItems>) allParams.get("setGroupedItems");
			List<Map<String, Object>> delGroupedItems	= (List<Map<String, Object>>) allParams.get("delGroupedItems");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles = (List<GIPIWDeductible>) allParams.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles = (List<GIPIWDeductible>) allParams.get("delDeductRows");
			
			// item perils
			List<GIPIWItemPeril> insItemPerils		= (List<GIPIWItemPeril>) allParams.get("setItemPerils");
			List<Map<String, Object>> delItemPerils	= (List<Map<String, Object>>) allParams.get("delItemPerils");
			List<Map<String, Object>> setPerilWCs	= (List<Map<String, Object>>) allParams.get("setPerilWCs");
			
			JSONArray misc = (JSONArray) allParams.get("misc");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);			
			this.getSqlMapClient().startBatch();
			
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
				this.getSqlMapClient().delete("delGIPIWItem", item);
			}
			
			// GIPI_WITEM
			for(GIPIWItem item : setItems){
				log.info("Inserting/updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem", item);
				
				allParams.put("packLineCd", item.getPackLineCd());
				allParams.put("packSublineCd", item.getPackSublineCd());				
			}
			
			// GIPI_WCASUALTY_ITEM
			for(GIPIWCasualtyItem casualtyItem : casualtyItems){
				if(itemNoList.get(casualtyItem.getItemNo()) != null){
					log.info("Inserting/updating record on gipi_wcasualty_item ...");
					this.getSqlMapClient().insert("setGipiWCasualtyItems", casualtyItem);
				}				
			}
			
			// GIPI_WCASUALTY_PERSONNEL (delete)
			for(Map<String, Object> delMap : delPersonnels){
				log.info("Deleting record on gipi_wcasualty_personnel ...");
				this.getSqlMapClient().delete("delGIPIWCasualtyPersonnel2", delMap);
			}
			
			// GIPI_WCASUALTY_PERSONNEL (insert/update)
			for(GIPIWCasualtyPersonnel cp : insPersonnels){
				log.info("Inserting/updating record on gipi_wcasualty_personnel ...");
				this.getSqlMapClient().insert("setGipiWCasualtyPersonnel", cp);
			}
			
			// GIPI_WGROUPED_ITEMS (delete)
			for(Map<String, Object> delMap : delGroupedItems){
				log.info("Deleting record on gipi_wgrouped_items ...");
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			
			// GIPI_WGROUPED_ITEMS (insert/update)
			for(GIPIWGroupedItems gi : insGroupedItems){
				log.info("Inserting/updating record on gipi_wwgrouped_items ...");
				this.getSqlMapClient().insert("setGipiWGroupedItems", gi);
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
			
			this.getSqlMapClient().executeBatch();		
			this.postFormsCommit(allParams);
			this.getSqlMapClient().getCurrentConnection().commit();	
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (JSONException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();			
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/**
	 * 
	 * @param allParams
	 * @throws SQLException
	 * @throws JSONException
	 * @throws ParseException
	 */
	private void postFormsCommit(Map<String, Object> allParams) throws SQLException, JSONException, ParseException {		
		JSONArray vars = (JSONArray) allParams.get("vars");		
		JSONArray misc = (JSONArray) allParams.get("misc");
		GIPIWPolbas gipiWPolbas = (GIPIWPolbas) allParams.get("gipiWPolbas");
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		Map<String, Object> param = new HashMap<String, Object>();
		
		if(!("Y".equals(vars.getJSONObject(0).getString("varPost")))){			
			param.put("parId", (Integer) allParams.get("parId"));
			param.put("userId", (String) allParams.get("userId"));
			
			log.info("Post-Forms-Commit : Inserting record to parhist ...");
			this.getSqlMapClient().queryForObject("insertParhist", param);
		}
		
		if("Y".equals(misc.getJSONObject(0).getString("miscNbtInvoiceSw"))){
			if(!("Y".equals(vars.getJSONObject(0).getString("varPost")))){
				log.info("Post-Forms-Commit : Changing item group ...");
				this.getSqlMapClient().queryForObject("changeItemGrp", (Integer) allParams.get("parId"));
				
				if(!("Y".equals(vars.getJSONObject(0).getString("varEndtTaxSw")))){					
					log.info("Post-Forms-Commit : Deleting bill ...");
					//this.getSqlMapClient().queryForObject("deleteBillOnItem", (Integer) allParams.get("parId"));
					this.getSqlMapClient().update("deleteBillsDetails", allParams.get("parId"));
				}				
				
				param.clear();
				param.put("parId", (Integer) allParams.get("parId"));
				param.put("negateItem", vars.getJSONObject(0).getString("varVNegateItem"));
				param.put("prorateFlag", vars.getJSONObject(0).getString("varVProrateFlag"));
				param.put("compSw", vars.getJSONObject(0).getString("varCompSw"));
				param.put("endtExpDate", vars.getJSONObject(0).get("varVEndtExpiryDate").equals(null) ? null : sdf.parse(vars.getJSONObject(0).getString("varVEndtExpiryDate")));
				param.put("effDate", vars.getJSONObject(0).get("varVEffDate").equals(null) ? null : sdf.parse(vars.getJSONObject(0).getString("varVEffDate")));				
				param.put("shortRtPct", new BigDecimal(vars.getJSONObject(0).getString("varVShortRtPercent").isEmpty() ? "0.00" : vars.getJSONObject(0).getString("varVShortRtPercent")));
				param.put("expDate", vars.getJSONObject(0).get("varVExpiryDate").equals(null) ? null : sdf.parse(vars.getJSONObject(0).getString("varVExpiryDate")));				
				
				log.info("Post-Forms-Commit : Updating GIPI_WPOLBAS ...");
				this.getSqlMapClient().queryForObject("updateGipiWpolbasEndt" + allParams.get("lineCd"), param);				
				
				param.clear();				
				param.put("parId", (Integer) allParams.get("parId"));
				log.info("Post-Forms-Commit : Creating distribution item ...");
				this.getSqlMapClient().queryForObject("gipis061CreateDistributionItem", param);
				misc.getJSONObject(0).put("miscItemFound", (String) param.get("exist"));
				
				if(!("Y".equals(vars.getJSONObject(0).getString("varEndtTaxSw")))){
					param.clear();
					param.put("parId", (Integer) allParams.get("parId"));
					log.info("Post-Forms-Commit : Populating Orig item peril and creating winvoice ...");
					this.getSqlMapClient().queryForObject("populateOrigItemPerilEndt", param);
					misc.getJSONObject(0).putOnce("miscPerilFound", (String) param.get("exist"));
				}
				
				if("N".equals(misc.getJSONObject(0).getString("miscItemFound"))){
					log.info("Post-Forms-Commit : Deleting distribution ...");
					this.getSqlMapClient().queryForObject("gipis061DeleteDistribution", (Integer) allParams.get("parId"));
				}
				
				if(("N".equals(misc.getJSONObject(0).getString("miscPerilFound"))) && !("Y".equals(vars.getJSONObject(0).getString("varEndtTaxSw")))){
					log.info("Post-Forms-Commit : Deleting record on gipi_winvperl ...");
					this.getSqlMapClient().delete("delGIPIWInvPerl", (Integer) allParams.get("parId"));
					log.info("Post-Forms-Commit : Deleting record on gipi_winv_tax ...");
					this.getSqlMapClient().delete("deleteAllGIPIWinvTax", (Integer) allParams.get("parId"));
					log.info("Post-Forms-Commit : Delete record on gipi_winvoice ...");
					this.getSqlMapClient().delete("delGIPIWInvoice", (Integer) allParams.get("parId"));
				}
				
				param.clear();
				param.put("parId", (Integer) allParams.get("parId"));
				param.put("lineCd", (String) allParams.get("lineCd"));
				param.put("issCd", gipiWPolbas.getIssCd());
				param.put("negateItem", vars.getJSONObject(0).getString("varVNegateItem"));
				param.put("prorateFlag", vars.getJSONObject(0).getString("varVProrateFlag"));
				param.put("compSw", vars.getJSONObject(0).getString("varCompSw"));
				param.put("endtExpiryDate", sdf.parse(vars.getJSONObject(0).getString("varVEndtExpiryDate")));
				param.put("effDate", sdf.parse(vars.getJSONObject(0).getString("varVEffDate")));
				param.put("expiryDate", vars.getJSONObject(0).get("varVExpiryDate").equals(null) ? null : sdf.parse(vars.getJSONObject(0).getString("varVExpiryDate")));
				param.put("shortRtPercent", new BigDecimal(vars.getJSONObject(0).getString("varVShortRtPercent").isEmpty() ? "0.00" : vars.getJSONObject(0).getString("varVShortRtPercent")));
				
				log.info("Post-Forms-Commit : Applying changes in par status ...");
				this.getSqlMapClient().queryForObject("gipis061AddParStatusNo", param);
				
				vars.getJSONObject(0).put("varEndtTaxSw", (String) param.get("varEndtTaxSw"));
				
				param.clear();
				param.put("parId", (Integer) allParams.get("parId"));
				param.put("endtTaxSw", (String) vars.getJSONObject(0).getString("varEndtTaxSw"));
				log.info("Post-Forms-Commit : Validating par status ...");
				this.getSqlMapClient().queryForObject("validateParStatusEndt", param);				
			}
		}
		
		if("Y".equals(vars.getJSONObject(0).getString("varGroupSw"))){			
			log.info("Post-Forms-Commit : Changing item group ...");
			this.getSqlMapClient().queryForObject("changeItemGrp", (Integer) allParams.get("parId"));
		}
		
		param.clear();
		param.put("parId", (Integer) allParams.get("parId"));
		param.put("packLineCd", (String) allParams.get("packLineCd"));
		param.put("packSublineCd", (String) allParams.get("packSublineCd"));
		param.put("packPolFlag", vars.getJSONObject(0).getString("varVPackPolFlag"));
		
		log.info("Post-Forms-Commit : Updating gipi_wpack_line_subline ...");
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSublineEndt", param);
		
		if("Y".equals(vars.getJSONObject(0).getString("varVPackPolFlag"))){
			log.info("Post-Forms-Commit : Setting package menu ...");
			this.getSqlMapClient().queryForObject("setPackageMenu1", vars.getJSONObject(0).getString("varVPackPolFlag"));
		}			
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#saveCasualtyItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveCasualtyItem(Map<String, Object> params)
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

			// insert, update, delete item deductibles
			if((params.get("deductibleInsList") != null && ((List<GIPIWDeductible>) params.get("deductibleInsList")).size() > 0) ||
				(params.get("deductibleDelList") != null && ((List<Map<String, Object>>) params.get("deductibleDelList")).size() > 0)){				
				this.itemMcDAO.updateDeductibleRecords(params, 2);
			}
			
			//start of grouped & personnel items
			List<GIPIWGroupedItems> groupedItems = (List<GIPIWGroupedItems>) params.get("groupedItems");
			List<GIPIWCasualtyPersonnel> personnelItems = (List<GIPIWCasualtyPersonnel>) params.get("personnelItems");
			String[] delGroupItemsItemNos	= (String[]) params.get("delGroupItemsItemNos");
			String[] delGroupedItemNos		= (String[]) params.get("delGroupedItemNos");
			String[] delPersonnelItemNos	= (String[]) params.get("delPersonnelItemNos");
			String[] delPersonnelNos		= (String[]) params.get("delPersonnelNos");
			String parId 					= params.get("parId").toString();
			
			if (delGroupItemsItemNos != null && delGroupedItemNos != null){
				for (int a = 0; a < delGroupItemsItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delGroupItemsItemNos[a]);
					paramsDel.put("groupedItemNo", delGroupedItemNos[a]);
					System.out.println("Deleting record in GIPI_WGROUPED_ITEMS for item no.: /"+delGroupItemsItemNos[a]+"/ groupedItemNo: /"+delGroupedItemNos[a]);
					this.sqlMapClient.update("delGIPIWGroupedItems2", paramsDel);
				}
			}
			
			if (delPersonnelItemNos != null && delPersonnelNos != null){
				for (int a = 0; a < delPersonnelItemNos.length; a++) {
					Map<String, String> paramsDel = new HashMap<String, String>();
					paramsDel.put("parId", parId.toString());
					paramsDel.put("itemNo", delPersonnelItemNos[a]);
					paramsDel.put("personnelNo", delPersonnelNos[a]);
					System.out.println("Deleting record in GIPI_WCASUALTY_PERSONNEL for item no.: /"+delPersonnelItemNos[a]+"/ personnelNo: /"+delPersonnelNos[a]);
					this.sqlMapClient.update("delGIPIWCasualtyPersonnel2", paramsDel);
				}
			}
			
			System.out.println("Saving record/s For Group Items:");
			System.out.println("ParID\tItemNo\tGroupItemNo\tGroupItemTitle");
			System.out.println("=======================================================================================");
			for(GIPIWGroupedItems group:groupedItems){
				System.out.println(group.getParId() + "\t" + group.getItemNo() + "\t" + group.getGroupedItemNo() + "\t" + group.getGroupedItemTitle());
				this.getSqlMapClient().insert("setGipiWGroupedItems", group);
			}
			System.out.println("=======================================================================================");
			
			System.out.println("Saving record/s For Personnel Items:");
			System.out.println("ParID\tItemNo\tPersonnelNo\tPersonnelName");
			System.out.println("=======================================================================================");
			for(GIPIWCasualtyPersonnel personnel:personnelItems){
				System.out.println(personnel.getParId() + "\t" + personnel.getItemNo() + "\t" + personnel.getPersonnelNo() + "\t" + personnel.getPersonnelName());
				this.getSqlMapClient().insert("setGipiWCasualtyPersonnel", personnel);
			}
			System.out.println("=======================================================================================");
			//end of grouped & personnel items
			
			// insert, update, delete item peril
			/*if((params.get("itemPerilInsList") != null && ((List<GIPIWItemPeril>) params.get("itemPerilInsList")).size() > 0) ||
				(params.get("itemPerilDelList") != null && ((List<Map<String, Object>>) params.get("itemPerilDelList")).size() > 0)){				
				this.itemMcDAO.updateItemPerilRecords(params);
			}*/
			//BRYAN - implementing JSON 11.30.2010
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
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
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
	public boolean insertUpdateItem(Map<String, Object> params) throws SQLException {
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		List<GIPIWCasualtyItem> casualtyitems = (List<GIPIWCasualtyItem>) params.get("casualtyitems");
		
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
			
			if(casualtyitems.size() > index){				
				if(Integer.parseInt(casualtyitems.get(index).getItemNo()) == item.getItemNo()){
					log.info("Item (Saving)- Saving record on casualty ...");
					this.getSqlMapClient().insert("setGipiWCasualtyItems", casualtyitems.get(index));						
					index++;					
				}							
			}
			
			params.put("itemGrp", item.getItemGrp());
			params.put("vars", vars);
			params.put("pars", pars);
			params.put("others", others);
			
			if(!(postFormsCommitItems(params))){
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
	private boolean postFormsCommitItems(Map<String, Object> params) throws SQLException {
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
		/*paramMap.put("parId", gipiParList.getParId());
		paramMap.put("parStatus", gipiParList.getParStatus());
		log.info("Item (Post Form Commit)- Checking additional motorcar info ...");
		this.getSqlMapClient().queryForObject("checkAdditionalInfoAV", paramMap);
		paramMap.clear();*/
		
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
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#gipis011NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis011NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS011 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis011NewFormInstance", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWCasualtyItemDAO#saveGIPIWCasualtyItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWCasualtyItem(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving casualty items ...");
		
		try{
			List<Map<String, Object>> setItems 		= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems 		= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWCasualtyItem> casualtyItems	= (List<GIPIWCasualtyItem>) params.get("casualtyItems");
			
			// grouped_items
			List<GIPIWGroupedItems> insGroupedItems 	= (List<GIPIWGroupedItems>) params.get("setGroupedItems");
			List<Map<String, Object>> delGroupedItems	= (List<Map<String, Object>>) params.get("delGroupedItems");
			
			// casualty_personnel
			List<GIPIWCasualtyPersonnel> insPersonnels 	= (List<GIPIWCasualtyPersonnel>) params.get("setPersonnels");
			List<Map<String, Object>> delPersonnels		= (List<Map<String, Object>>) params.get("delPersonnels");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles	= (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles	= (List<GIPIWDeductible>) params.get("delDeductRows");
			
			GIPIWPolbas gipiWPolbas 		= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc 				= (JSONObject) params.get("misc");
			Map<String, Object> paramMap 	= null;
			
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
			
			// GIPI_WCASUALTY_ITEM (insert/update)
			for(GIPIWCasualtyItem casualty : casualtyItems){
				log.info("Inserting/Updating record on gipi_wcasualty_item ...");
				this.getSqlMapClient().insert("setGipiWCasualtyItems", casualty);
			}
			
			// GIPI_WGROUPED_ITEMS (delete)
			for(Map<String, Object> delMap : delGroupedItems){
				log.info("Deleting record on gipi_wgrouped_items ...");
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			
			// GIPI_WGROUPED_ITEMS (insert/update)
			for(GIPIWGroupedItems gi : insGroupedItems){
				log.info("Inserting/updating record on gipi_wwgrouped_items ...");
				this.getSqlMapClient().insert("setGipiWGroupedItems", gi);
			}
			
			// GIPI_WCASUALTY_PERSONNEL (delete)
			for(Map<String, Object> delMap : delPersonnels){
				log.info("Deleting record on gipi_wcasualty_personnel ...");
				this.getSqlMapClient().delete("delGIPIWCasualtyPersonnel2", delMap);
			}
			
			// GIPI_WCASUALTY_PERSONNEL (insert/update)
			for(GIPIWCasualtyPersonnel cp : insPersonnels){
				log.info("Inserting/updating record on gipi_wcasualty_personnel ...");
				this.getSqlMapClient().insert("setGipiWCasualtyPersonnel", cp);
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
			
			if(params.get("parType").toString().equals("E")){ //added by steven 9/10/2012 for endorsement 
				this.getGipiWItemDAO().endtItemPostFormsCommit(params);
				
				// insert, update, delete item peril // ibalik after matapos sa table grid
				if((params.get("setPerils") != null && ((List<GIPIWItemPeril>) params.get("setPerils")).size() > 0) ||
					(params.get("delPerils") != null && ((List<GIPIWItemPeril>) params.get("delPerils")).size() > 0) ||
					("Y".equals(params.get("delDiscSw")))){	
					log.info("entered endorsement updateItemPerilRecords");
					this.getGipiWItemPerilDAO().saveGIPIWItemPeril(params);
					this.getSqlMapClient().executeBatch();
					this.getGipiWItemPerilDAO().endtItemPerilPostFormsCommit(params);
				} 
			} else {	
				this.getGipiWItemDAO().parItemPostFormsCommit(params);
				
				// insert, update, delete item peril // ibalik after matapos sa table grid
				if((params.get(/*"itemPerilInsList"*/"setPerils") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilInsList"*/"setPerils")).size() > 0) ||
					(params.get(/*"itemPerilDelList"*/"delPerils") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilDelList"*/"delPerils")).size() > 0) ||
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
