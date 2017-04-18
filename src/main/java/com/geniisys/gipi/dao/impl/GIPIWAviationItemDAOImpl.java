package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.dao.GIPIWAviationItemDAO;
import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWAviationItem;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWAviationItemDAOImpl implements GIPIWAviationItemDAO{
	
	private Logger log = Logger.getLogger(GIPIWAviationItemDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIParItemMCDAO itemMcDAO;
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
		
	public GIPIParItemMCDAO getItemMcDAO() {
		return itemMcDAO;
	}
	public void setItemMcDAO(GIPIParItemMCDAO itemMcDAO) {
		this.itemMcDAO = itemMcDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWAviationItem", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#getGipiWAviationItem(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWAviationItem> getGipiWAviationItem(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGipiWAviationItems", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#saveGipiWAviation(java.util.List)
	 */
	@Override
	public void saveGipiWAviation(List<GIPIWAviationItem> aviationItems)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo\tVesselCd");
			System.out.println("=======================================================================================");
			for(GIPIWAviationItem av : aviationItems){
				System.out.println(av.getParId() + "\t" + av.getItemNo() + "\t" + av.getVesselCd());
				this.getSqlMapClient().insert("saveGIPIWAviationItem", av);	
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
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#preCommitAviationItem(java.lang.Integer, java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> preCommitAviationItem(Integer parId,
			Integer itemNo, String vesselCd) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		params.put("vesselCd", vesselCd);
		this.sqlMapClient.update("preCommitAviationItem", params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#saveAvaiationItem(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public boolean saveAvaiationItem(Map<String, Object> params)
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
	public boolean insertUpdateItem(Map<String, Object> params) throws SQLException {
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		List<GIPIWAviationItem> aviationList = (List<GIPIWAviationItem>) params.get("aviationList");
		
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
			
			if(aviationList.size() > index){				
				if(Integer.parseInt(aviationList.get(index).getItemNo()) == item.getItemNo()){
					log.info("Item (Saving)- Saving record on aviation ...");
					this.getSqlMapClient().insert("saveGIPIWAviationItem", aviationList.get(index));						
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
		//log.info("Item (Post Form Commit)- Checking additional aviation info ...");
		//this.getSqlMapClient().queryForObject("checkAdditionalInfoAV", paramMap);
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
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#gipis019NewFormInstance(java.util.Map)
	 */
	@Override
	public Map<String, Object> gipis019NewFormInstance(
			Map<String, Object> newInstanceMap) throws SQLException {
		log.info("Getting GIPIS019 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis019NewFormInstance", newInstanceMap);
		return newInstanceMap;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWAviationItemDAO#saveGIPIWAviationItm(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWAviationItm(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Aviation Items ... ");	
		try{			
			List<Map<String, Object>> setItems		= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems		= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWAviationItem> aviationItems	= (List<GIPIWAviationItem>) params.get("aviationItems");
			
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
			
			// GIPI_WAVIATION_ITEM (insert/update)
			for(GIPIWAviationItem av : aviationItems){
				log.info("Inserting/Updating record on gipi_waviation_item ...");
				this.getSqlMapClient().insert("saveGIPIWAviationItem", av);
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
