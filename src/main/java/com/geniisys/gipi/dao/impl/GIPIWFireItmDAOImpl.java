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
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWFireItmDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWFireItm;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWFireItmDAOImpl.
 */
public class GIPIWFireItmDAOImpl implements GIPIWFireItmDAO {

	/** The log. */
	private Logger log = Logger.getLogger(GIPIWFireItmDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	
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
	
	public GIPIWItemDAO getGipiWItemDAO() {
		return gipiWItemDAO;
	}

	public void setGipiWItemDAO(GIPIWItemDAO gipiWItemDAO) {
		this.gipiWItemDAO = gipiWItemDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#getGIPIWFireItems(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWFireItm> getGIPIWFireItems(int parId) throws SQLException {		
		return this.getSqlMapClient().queryForList("getGIPIWFireItems", parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#delGIPIWFireItem(java.util.List)
	 */
	@Override
	public void delGIPIWFireItem(List<GIPIWFireItm> wFireItem)
			throws SQLException {
		// 		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#deleteGIPIWFireItem(java.util.Map)
	 */
	@Override
	public void deleteGIPIWFireItem(Map<String, Object> params)
			throws SQLException {
		// 		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#saveGIPIWFireItem(com.geniisys.gipi.entity.GIPIWFireItm)
	 */
	@Override
	public void saveGIPIWFireItem(GIPIWFireItm wFireItem) throws SQLException {		
		this.getSqlMapClient().insert("saveGIPIWFireItem", wFireItem);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#setGIPIWFireItem(java.util.List)
	 */
	@Override
	public void setGIPIWFireItem(List<GIPIWFireItm> wFireItem)
			throws SQLException {		
		log.info("DAO Calling setGIPIWFireItem...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving Record/s");
			System.out.println("ParID\tItemNo\tDstrctNo\tEQZone\tTarfCd\tBlockNo");
			System.out.println("=======================================================================================");
			for(GIPIWFireItm fire : wFireItem){
				System.out.println(fire.getParId() + "\t" + fire.getItemNo() + "\t" + fire.getDistrictNo() + "\t" +
						fire.getEqZone() + "\t" + fire.getTarfCd() + "\t" + fire.getBlockNo());
				this.getSqlMapClient().insert("saveGIPIWFireItem", fire);				
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
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#getAssuredMailingAddress(int)
	 */
	@Override
	public Map<String, Object> getAssuredMailingAddress(int assdNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", assdNo);
		this.getSqlMapClient().update("getAssdMailAddrss", params);		
		return params;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#getFireAdditionalParams()
	 */
	@Override
	public Map<String, Object> getFireAdditionalParams() throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		this.getSqlMapClient().update("getFireParameters", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#getFireTariff(java.util.Map)
	 */
	@Override
	public BigDecimal getFireTariff(Map<String, Object> params)
			throws SQLException {
		
		BigDecimal tariffRate = null;
		this.getSqlMapClient().update("getFireTariffRate", params);
		tariffRate = (BigDecimal) params.get("tariffRate");
		System.out.println(params);
		return tariffRate;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#checkAddtlInfo(int)
	 */
	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		return (String)this.sqlMapClient.queryForObject("checkAddtlInfoFI", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#getGIPIS039BasicVarValues(java.util.Map)
	 */
	@Override
	public Map<String, Object> getGIPIS039BasicVarValues(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIPIS039BasicVarValues", params);
		return params;
	}
	
	/*added by nica
	 * save item information in gipi_witem and gipi_wfireitm  
	 */	
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveFireItem(Map<String, Object> params) throws SQLException {
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		boolean success = false;
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//delete records on GIPI_WITEM
			if ((String[]) delItemMap.get("delItemNos") != null){
				deleteItem(params);
			}
			if(((List<GIPIWItem>) params.get("itemList")).size()>0){
				if(!(insertUpdateItem(params))){
					throw new SQLException();
				}
			}
			
			// insert, update, delete item deductibles
			if((params.get("deductibleInsList") != null && ((List<GIPIWDeductible>) params.get("deductibleInsList")).size()>0)||
				(params.get("deductibleDelList") != null && ((List<Map<String, Object>>) params.get("deductibleDelList")).size()>0)){
				updateDeductibleRecords(params, 2);
			}
			
			// insert, update, delete mortgagee
			if((params.get("mortgageeInsList")!= null && ((List<GIPIParMortgagee>)params.get("mortgageeInsList")).size() > 0)||
				(params.get("mortgageeDelList") != null && ((List<GIPIParMortgagee>)params.get("mortgageeDelList")).size() >0)){
				updateMortgageeRecords(params);
			}
			
			//insert, update, delete item peril
			Map<String, Object> others = (Map<String, Object>) params.get("others");
			if((params.get("perilInsList")!= null && ((List<GIPIWItemPeril>)params.get("perilInsList")).size()>0)||
				(params.get("perilDelList") != null && ((List<GIPIWItemPeril>)params.get("perilDelList")).size() >0) ||
				("Y".equals(others.get("delDiscSw")))){
				updateItemPerilRecords(params);
			}
			
			// insert, update, delete peril deductibles
			if((params.get("perilDedInsList") != null && ((List<GIPIWDeductible>) params.get("perilDedInsList")).size()>0) ||
				(params.get("perilDedDelList") != null && ((List<Map<String, Object>>) params.get("perilDedDelList")).size() >0)){
				updateDeductibleRecords(params, 3);
			}
			
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			System.out.println("Rollback");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
			success = true;
		}
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> vars = (Map<String, Object>) params.get("vars");
			GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
			
			if("Y".equals((String) vars.get("varGroupSw"))){
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("parId", gipiParList.getParId());
				paramMap.put("packPolFlag", gipiParList.getPackPolFlag());
				
				log.info("Item Saving - Changing item_grp on gipi_witem...");
				this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
				paramMap = null;
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
		}
		return success;
	}
	
	@SuppressWarnings("unchecked")
	private void deleteItem (Map<String, Object> params) throws SQLException{
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		String[] parIds = (String[]) delItemMap.get("delParIds");
		String[] itemNos = (String[]) delItemMap.get("delItemNos");
		
		for (int index=0, length= itemNos.length; index<length; index++){
			Map<String, Object> deleteMap = new HashMap<String, Object>();
			deleteMap.put("parId", parIds[index]);
			deleteMap.put("itemNo", itemNos[index]);
			log.info("Item Saving (parId=" + parIds[index] +", itemNo=" + itemNos[index]+") - Deleting record on gipi_witem...");
			this.getSqlMapClient().delete("deleteGIPIParItem", deleteMap);
		}
	}
	
	@SuppressWarnings("unchecked")
	private boolean insertUpdateItem(Map<String, Object> params) throws SQLException{
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		List<GIPIWFireItm> fireItemList = (List<GIPIWFireItm>) params.get("fireItemList");
		
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		Map<String, Object> fireItemMap = (Map<String, Object>) params.get("fireItemMap");
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		boolean result = true;
		int index =0;
		
		if((String[])delItemMap.get("delItemNos") != null || (String[]) fireItemMap.get("itemNos") != null){
			log.info("Item Saving - Deleting discount...");
			this.getSqlMapClient().queryForObject("deleteDiscount", params.get("parId"));
			vars.put("varInsertDeleteSW", "Y");
			others.put("nbtInvoiceSw", "Y");
		}
		
		for(GIPIWItem item: itemList){
			Map<String, Object> itemGrpMap = new HashMap<String, Object>();
			itemGrpMap.put("parId", item.getParId());
			itemGrpMap.put("packPolFlag", globals.get("globalPackPolFlag"));
			itemGrpMap.put("currencyCd", item.getCurrencyCd());
			log.info("Item Saving(parId=" + item.getParId() + ", itemNo=" + item.getItemNo() +")-Saving record on gipi_witem...");
			this.getSqlMapClient().insert("setGIPIParItem", item);
			
			if(fireItemList.size()>0){
				log.info("Item(Saving)- Saving record on gipi_wfireItem..");
				this.getSqlMapClient().insert("saveGIPIWFireItem", fireItemList.get(index));
				index++;
			}
			params.put("itemGrp", item.getItemGrp());
			params.put("vars", vars);
			params.put("pars", pars);
			params.put("others", others);
			
			if(!(postFormCommit(params))){
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
	private boolean postFormCommit (Map<String, Object> params) throws SQLException{
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		@SuppressWarnings("unused")
		Map<String, Object> pars = (Map<String, Object>) params.get("pars");
		Map<String, Object> others = (Map<String, Object>) params.get("others");
		
		GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
		
		if ("N".equals((String)vars.get("varPost2"))){
			return false;
		}
		
		if("".equals((String) vars.get("varPost"))){
			Map<String, Object> parhistMap = new HashMap<String, Object>();
			parhistMap.put("parId", params.get("parId"));
			parhistMap.put("userId", params.get("userId"));
			log.info("Item (Post Form Commit)- Inserting record to parhist...");
			this.getSqlMapClient().queryForObject("insertParhist", parhistMap);
		}
		if("".equals((String) vars.get("varPost")) && "Y".equals((String) others.get("nbtInvoiceSw"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			//Delete co_insurer
			log.info("Item(Post Form Commit)- Deleting co_insurer...");
			this.getSqlMapClient().queryForObject("deleteCoInsurer", params.get("parId"));
			paramMap.clear();
			
			//delete_bill
			log.info("Item (Post Form Commit)- Deleting bill...");
			this.getSqlMapClient().queryForObject("deleteBillOnItem", Integer.parseInt(globals.get("globalParId").toString()));
			
			//add_par_status_no
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("lineCd", gipiParList.getLineCd());
			paramMap.put("issCd", gipiParList.getIssCd());
			paramMap.put("invoiceSw", (String) others.get("nbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp") != null ? params.get("itemGrp").toString(): null);
			log.info("Item (Post Form Commit)- Adding par_status_no...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			paramMap.clear();
			
			
			//update gipi_wpolbas no_of_items
			log.info("Item (Post Form Commit)- Updating gipi_wpolbas no_of_items...");
			this.getSqlMapClient().queryForObject("updateGipiWPolbasNoOfItem", gipiParList.getParId());
			paramMap = null;
			
		}else if("".equals((String) vars.get("varPost"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			//add_par_status_no
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("lineCd", gipiParList.getLineCd());
			paramMap.put("issCd", gipiParList.getIssCd());
			paramMap.put("invoiceSw", (String) others.get("nbtInvoiceSw"));
			paramMap.put("itemGrp", params.get("itemGrp") != null ? params.get("itemGrp").toString() : null);
			log.info("Item (Post Form Commit)- Adding par_status_no...");
			this.getSqlMapClient().queryForObject("addParStatusNo2", paramMap);
			paramMap = null;
		}
			/*if("Y".equals((String) vars.get("varGroupSw"))){
				Map<String,Object> paramMap = new HashMap<String, Object>();
				paramMap.put("parId", gipiParList.getParId());
				paramMap.put("packPolFlag", gipiParList.getPackPolFlag());
				this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
			}*/
				
			//check additional info
			log.info("Item (Post Form Commit)- Checking Fire additional info...");
			this.getSqlMapClient().queryForObject("checkAdditionalInfoFI",  gipiParList.getParId());
			
			//update gipi_packline_subline
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packLineCd", globals.get("globalPackLineCd"));
			paramMap.put("packSublineCd", globals.get("globalPackSublineCd"));
			log.info("Item (Post Form Commit)- Updating gipi_WPack_line_Subline...");
			this.getSqlMapClient().queryForObject("updateEndtGipiWpackLineSubline", paramMap);
			paramMap = null;
		
		return true;
	}
	
	/**
	 * 
	 * @param param
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
	private void updateMortgageeRecords(Map<String, Object> param) throws SQLException{
		if(param.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) param.get("mortgageeInsList")).size()>0){
			for(GIPIParMortgagee m : (List<GIPIParMortgagee>)param.get("mortgageeInsList")){
				log.info("Item - (parId =" + m.getParId() + ", itemNo=" + m.getItemNo() + ", mortgCd=" + m.getMortgCd()+") - Inserting record to gipi_wmortgagee...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}
		}
		if(param.get("mortgageeDelList")!= null && ((List<Map<String,Object>>)param.get("mortgageeDelList")).size()>0){
			for(Map<String, Object> m: (List<Map<String, Object>>) param.get("mortgageeDelList")){
				log.info("Item - (par_id=" + m.get("parId") +", itemNo=" + m.get("itemNo") +", mortgCd=" + m.get("mortgCd")+") - Deleting record from gipi_wmortgagee...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", m);
			}
		}
	}
	
	/**
	 * 
	 * @param param
	 * @param deductibleLevel
	 * @throws SQLException
	 */
	@SuppressWarnings("unchecked")
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
	@SuppressWarnings("unchecked")
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
		
		/*********** MODIFIED BY BJGA 11.26.2010 to support JSON implementation*************/
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
	// end

	@Override
	public Map<String, Object> gipis003NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS003 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis003NewFormInstance", params);
		return params;
	}
	
	public void gipis039NewFormInstance(Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS039 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis039NewFormInstance", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWFireItm(Map<String, Object> params)
			throws SQLException, JSONException {		
		log.info("Saving Fire Items ... ");
		
		try{			
			List<Map<String, Object>> setItems	= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems	= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWFireItm> fireItems		= (List<GIPIWFireItm>) params.get("fireItems");
			
			// mortgagees
			List<GIPIParMortgagee> insMortgagees	= (List<GIPIParMortgagee>) params.get("setMortgagees");
			List<Map<String, Object>> delMortgagees	= (List<Map<String, Object>>) params.get("delMortgagees");
			
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
			
			// GIPI_WFIREITM (insert/update)
			for(GIPIWFireItm fire : fireItems){
				log.info("Inserting/Updating record on gipi_wfireitm ...");
				this.getSqlMapClient().insert("saveGIPIWFireItem", fire);
			}
			
			// GIPI_WMORTGAGEE (delete)
			for(Map<String, Object> delMap : delMortgagees){
				log.info("Deleting record on gipi_wmortgagee ...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", delMap);
			}
			
			// GIPI_WMORTGAGEE (insert/update)
			for(GIPIParMortgagee m : insMortgagees){
				log.info("Inserting/Updating record on gipi_wmortgagee ...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
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
			
			//marco - 08.05.2014 - reset status of GIPI_INSP_DATA if all items of inspection report are deleted
			this.getSqlMapClient().update("updateInspReportStatus", params);
			this.getSqlMapClient().executeBatch();
			
			if(params.get("parType").toString().equals("E")){
				this.getGipiWItemDAO().endtItemPostFormsCommit(params);
				
				// insert, update, delete item peril // ibalik after matapos sa table grid
				if((params.get("setPerils") != null && ((List<GIPIWItemPeril>) params.get("setPerils")).size() > 0) ||
					(params.get("delPerils") != null && ((List<GIPIWItemPeril>) params.get("delPerils")).size() > 0) ||
					("Y".equals(params.get("delDiscSw")))){	
					this.getGipiWItemPerilDAO().saveGIPIWItemPeril(params);
					this.getSqlMapClient().executeBatch();
					this.getGipiWItemPerilDAO().endtItemPerilPostFormsCommit(params);
				} 
			} else {
				this.getGipiWItemDAO().parItemPostFormsCommit(params);
				
				// insert, update, delete item peril // ibalik after matapos sa table grid
				//Map<String, Object> others = (Map<String, Object>) params.get("others");
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
			log.info("error code : "+e.getErrorCode());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	/**
	 * 
	 * @return
	 */
	public GIPIWItemPerilDAO getGipiWItemPerilDAO() {
		return gipiWItemPerilDAO;
	}

	/**
	 * 
	 * @param gipiWItemPerilDAO
	 */
	public void setGipiWItemPerilDAO(GIPIWItemPerilDAO gipiWItemPerilDAO) {
		this.gipiWItemPerilDAO = gipiWItemPerilDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWFireItmDAO#gipis03B9540WhenValidateItem(java.util.Map)
	 */
	@Override
	public void gipis03B9540WhenValidateItem(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gipis039B540WhenValidateItem", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getTariffZoneOccupancyValue(Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> param = new ArrayList<Map<String, Object>>();
		param = (List<Map<String, Object>>) getSqlMapClient().queryForList("getTariffZoneOccupancyValue", params);

		for (Map<String, Object> paramResult : param) {
		   params.put("occupancyCd", paramResult.get("occupancyCd"));
		   params.put("tariffZone", paramResult.get("tariffZone"));
		   params.put("tariffZoneDesc", paramResult.get("tariffZoneDesc"));
		   params.put("occupancyDesc", paramResult.get("occupancyDesc"));
		}
		return params;
	}
}
