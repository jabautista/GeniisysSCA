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

import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIParItemMCDAOImpl.
 */
public class GIPIParItemMCDAOImpl implements GIPIParItemMCDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIPIParItemMCDAOImpl.class);
	
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#deleteGIPIParItemMC(int, int)
	 */
	@Override
	public void deleteGIPIParItemMC(int parId, int itemNo) throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().delete("deleteGIPIWitem", params);	
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getGIPIParItemMC(int, int)
	 */
	@Override
	public GIPIParItemMC getGIPIParItemMC(int parId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		return (GIPIParItemMC) this.getSqlMapClient().queryForObject("getGIPIParItemMC", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getGIPIParItemMCs(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIParItemMC> getGIPIParItemMCs(int parId) throws SQLException {		
		return this.getSqlMapClient().queryForList("getGIPIParItemMCs", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getGIPIParItemMCs(int, int)
	 */
	@Override
	public List<GIPIParItemMC> getGIPIParItemMCs(int parId, int itemNo)
			throws SQLException {
		return null;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#saveGIPIParItemMC(com.geniisys.gipi.entity.GIPIItem)
	 */
	@Override
	public void saveGIPIParItemMC(GIPIItem itemMC) throws SQLException {
		this.getSqlMapClient().insert("saveGIPIWitem", itemMC);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getGIPIItems(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIItem> getGIPIItems(int parId) throws SQLException {		
		return this.getSqlMapClient().queryForList("getGIPIItems", parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#checkForExistingDeductibles(int, int)
	 */
	@Override
	public String checkForExistingDeductibles(int parId, int itemNo)
			throws SQLException {
		Map<String, Integer> params = new HashMap<String, Integer>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		
		return this.getSqlMapClient().queryForObject("checkForExistingDeductibles", params).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getParNo(int)
	 */
	@Override
	public String getParNo(int parId) throws SQLException {		
		return this.getSqlMapClient().queryForObject("getParNo", parId).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getAssuredName(java.lang.String)
	 */
	@Override
	public String getAssuredName(String assdNo) throws SQLException {		
		return this.getSqlMapClient().queryForObject("getAssuredName", assdNo).toString();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#saveGIPIWVehicle(com.geniisys.gipi.entity.GIPIParItemMC)
	 */
	@Override
	public void saveGIPIWVehicle(GIPIParItemMC parItemMC) throws SQLException {
		this.getSqlMapClient().insert("saveGIPIWVehicle", parItemMC);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#checkCOCSerialNoInPar(int, int, int, java.lang.String)
	 */
	@Override
	public String checkCOCSerialNoInPar(int parId, int itemNo, int cocSerialNo,
			String cocType) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("cocSerialNo", cocSerialNo);
		params.put("cocType", cocType);
		return (String)this.getSqlMapClient().queryForObject("checkCOCSerialNoInPar", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#checkCOCSerialNoInPolicy(int)
	 */
	@Override
	public String checkCOCSerialNoInPolicy(int cocSerialNo) throws SQLException {		
		return (String)this.getSqlMapClient().queryForObject("checkCOCSerialNoInPolicy", cocSerialNo);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#validateOtherInfo(int)
	 */
	@Override
	public String validateOtherInfo(int parId) throws SQLException {		
		return (String)this.getSqlMapClient().queryForObject("validateOtherInfo", parId);
	}

	@Override
	public void setGIPIWVehicle(List<GIPIParItemMC> itemMCs)
			throws SQLException {
		log.info("DAO calling setGIPIWVehicle...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving record/s:");
			System.out.println("ParID\tItemNo\tMotorNo");
			System.out.println("=======================================================================================");
			for(GIPIParItemMC v : itemMCs){
				System.out.println(v.getParId() + "\t" + v.getItemNo() + "\t" + v.getMotorNo());
				this.getSqlMapClient().insert("setGIPIWVehicle", v);				
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#getEndtTax(int)
	 */
	@Override
	public String getEndtTax(int parId) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("getEndtTax", parId);
	}

	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkIfDiscountExists", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#deleteEndtItem(int, int, int)
	 */
	@Override
	public boolean deleteEndtItem(int parId, int[] itemNo, int currentItemNo)
			throws SQLException {
		log.info("Deleting item...");
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("currentItemNo", currentItemNo);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			log.info("Current item no : " + currentItemNo);
			
			for(int i = 0; i < itemNo.length; i++){
				log.info("Deleting item no. : " + itemNo[i]);
				params.put("itemNo", itemNo[i]);
				this.getSqlMapClient().delete("deleteItem", params);
			}
			log.info("Items successfully deleted.");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#addEndtItem(int, int[])
	 */
	@Override
	public String addEndtItem(int parId, int[] itemNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		boolean error = false;
		log.info("Adding item...");
		try{
			params.put("parId", parId);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			
			for(int i = 0; i < itemNo.length; i++){
				log.info("Adding item no. : " + itemNo[i]);
				params.put("itemNo", itemNo[i]);
				this.getSqlMapClient().insert("addItem", params);
				
				if (params.get("message") != null) {
					if (!params.get("message").equals("SUCCESS")) {
						error = true;
						break;
					}
				}
			}
			
			if (!error) {
				log.info("Items successfully added.");
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().commitTransaction();
			}
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params.get("message") == null ? "" : params.get("message").toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#checkAddtlInfo(int)
	 */
	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		return (String)this.sqlMapClient.queryForObject("checkAddtlInfoMC", parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIEndtParItemMCDAO#populateOrigItmperil(int)
	 */
	@Override
	public String populateOrigItmperil(int parId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		
		log.info("Populating Orig Itmperil for Par : " + parId);
		
		this.getSqlMapClient().update("populateOrigItmperil", params);
		
		return params.get("message") == null ? "" : params.get("message").toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#getDistNo(int)
	 */
	@Override
	public int getDistNo(int parId) throws SQLException {
		return Integer.parseInt(this.sqlMapClient.queryForObject("getDistNo", parId).toString());
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#deleteDistribution(int, int)
	 */
	@Override
	public String deleteDistribution(int parId, int distNo) throws SQLException {
		log.info("Deleting item...");
		String message = "SUCCESS";
		try{
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("parId", parId);
			params.put("distNo", distNo);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			log.info("par Id : " + parId);
			log.info("dist no : " + distNo);
			
			log.info("Deleting distribution...");
			
			this.getSqlMapClient().delete("deleteDistribution", params);
			
			message = (String)params.get("message");
			message = message == null ? "SUCCESS" : message;
			
			if (message.equals("SUCCESS")) {
				log.info("Distribution successfully deleted.");
				this.getSqlMapClient().executeBatch();
				this.getSqlMapClient().commitTransaction();
			}
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#deleteWinvRecords(int)
	 */
	@Override
	public boolean deleteWinvRecords(int parId) throws SQLException {		
		this.getSqlMapClient().delete("deleteWinvRecords", parId);
		return true;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#validateEndtParMCItemNo(int, int, java.lang.String, java.util.Date)
	 */
	@Override
	public String validateEndtParMCItemNo(int parId, int itemNo,
			String dfltCoverage, String expiryDate) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("dfltCoverage", dfltCoverage);
		params.put("expiryDate", expiryDate);
		this.getSqlMapClient().update("validateEndtParMCItemNo", params);
		return (String)params.get("message");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParItemMCDAO#validateEndtMotorItemAddtlInfo(int, int, java.math.BigDecimal, java.lang.String, java.lang.String)
	 */
	@Override
	public void validateEndtMotorItemAddtlInfo(int parId, int itemNo,
			BigDecimal towing, String cocType, String plateNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		params.put("towing", towing);
		params.put("cocType", cocType);
		params.put("plateNo", plateNo);
		this.getSqlMapClient().update("validateEndtMotorItemAddtlInfo", params);
	}

	@Override
	public Map<String, Object> gipis010NewFormInstance(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("gipis010NewFormInstance", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public boolean saveItemMotorCar(Map<String, Object> params)
			throws SQLException {
		
		//Map<String, Object> insItemMap = (Map<String, Object>) params.get("insItemMap");
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");		
		boolean success = false;
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			
			
			// delete records on GIPI_WITEM			
			if((String[]) delItemMap.get("delItemNos") != null){
				deleteItem(params);							
			}			
			
			// insert/update records on GIPI_WITEM			
			if(((List<GIPIWItem>) params.get("itemList")).size() > 0){				
				if(!(insertUpdateItem(params))){					
					throw new SQLException();
				}
			}
			
			if((params.get("polDeductibleDelList") != null && ((List<GIPIWDeductible>) params.get("polDeductibleDelList")).size() > 0)){				
					updateDeductibleRecords(params, 1);
				}
			
			// insert, update, delete item deductibles
			if((params.get("deductibleInsList") != null && ((List<GIPIWDeductible>) params.get("deductibleInsList")).size() > 0) ||
				(params.get("deductibleDelList") != null && ((List<Map<String, Object>>) params.get("deductibleDelList")).size() > 0)){				
				updateDeductibleRecords(params, 2);
			}
			
			// insert, update, delete mortgagee
			if((params.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeInsList")).size() > 0) || 
				(params.get("mortgageeDelList") != null && ((List<GIPIParMortgagee>) params.get("mortgageeDelList")).size() > 0)){				
				updateMortgageeRecords(params);
			}
			
			// insert, update, delete accessory
			if((params.get("accessoryInsList") != null && ((List<GIPIWMcAcc>) params.get("accessoryInsList")).size() > 0) ||
				(params.get("accessoryDelList") != null && ((List<Map<String, Object>>) params.get("accessoryDelList")).size() > 0)){				
				updateAccessoryRecords(params);
			}
			
			// insert, update, delete item peril
			Map<String, Object> others = (Map<String, Object>) params.get("others");
			if((params.get(/*"itemPerilInsList"*/"perilInsList") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilInsList"*/"perilInsList")).size() > 0) ||
				(params.get(/*"itemPerilDelList"*/"perilDelList") != null && ((List<GIPIWItemPeril>) params.get(/*"itemPerilDelList"*/"perilDelList")).size() > 0) ||
				("Y".equals(others.get("delDiscSw")))){				
				updateItemPerilRecords(params);
			} 
			
			// insert, update, delete peril deductibles
			if((params.get("perilDedInsList") != null && ((List<GIPIWDeductible>) params.get("perilDedInsList")).size() > 0) ||
				(params.get("perilDedDelList") != null && ((List<Map<String, Object>>) params.get("perilDedDelList")).size() > 0)){				
				updateDeductibleRecords(params, 3);
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
		
		/*try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> vars = (Map<String, Object>) params.get("vars");			
			GIPIPARList gipiParList = (GIPIPARList) params.get("gipiParList");
			
			if("Y".equals((String) vars.get("varGroupSw"))){
				Map<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("parId", gipiParList.getParId());
				paramMap.put("packPolFlag", gipiParList.getPackPolFlag());
				
				log.info("Item Saving  - Changing item_grp on gipi_witem ...");
				this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
				paramMap = null;				
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();			
		}*/
		
		return success;
	}
	
	@SuppressWarnings("unchecked")
	public void deleteItem(Map<String, Object> params) throws SQLException {		
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		String[] parIds = (String[]) delItemMap.get("delParIds");
		String[] itemNos = (String[]) delItemMap.get("delItemNos");
		
		for(int index=0, length = itemNos.length; index < length; index++){
			Map<String, Object> deleteMap = new HashMap<String, Object>();
			deleteMap.put("parId", parIds[index]);
			deleteMap.put("itemNo", itemNos[index]);
			log.info("Item Saving (parId=" + parIds[index]+ ", itemNo=" + itemNos[index] + ") - Deleting record on gipi_witem ...");
			this.getSqlMapClient().delete("deleteGIPIParItem", deleteMap);
		}
	}
	
	@SuppressWarnings("unchecked")
	public boolean insertUpdateItem(Map<String, Object> params) throws SQLException {
		List<GIPIWItem> itemList = (List<GIPIWItem>) params.get("itemList");
		List<GIPIParItemMC> vehicleList = (List<GIPIParItemMC>) params.get("vehicleList");
		
		Map<String, Object> delItemMap = (Map<String, Object>) params.get("delItemMap");
		Map<String, Object> vehicleMap = (Map<String, Object>) params.get("vehicleMap");
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
				
		// pre-delete trigger on GIPI_WITEM and pre-insert trigger on GIPI_WVEHICLE
		if((String[]) delItemMap.get("delItemNos") != null || (String[]) vehicleMap.get("itemItemNos") != null){
			log.info("Item Saving - Deleting discount ...");
			this.getSqlMapClient().queryForObject("deleteDiscount", params.get("parId"));
			vars.put("varInsertDeleteSw", "Y");
			others.put("nbtInvoiceSw", "Y");				
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
			
			if(vehicleList.size() > index){				
				if(Integer.parseInt(vehicleList.get(index).getItemNo()) == item.getItemNo()){
					log.info("Item (Saving)- Saving record on gipi_wvehicle ...");
					this.getSqlMapClient().insert("setGIPIWVehicle", vehicleList.get(index));						
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

	@Override
	public Map<String, Object> preFormsCommit(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().queryForObject("gipis010PreFormsCommit", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public boolean postFormsCommit(Map<String, Object> params) throws SQLException{
		//Map<String, Object> insItemMap = (Map<String, Object>) params.get("insItemMap");		
		Map<String, Object> globals = (Map<String, Object>) params.get("globals");
		Map<String, Object> vars = (Map<String, Object>) params.get("vars");
		//Map<String, Object> pars = (Map<String, Object>) params.get("pars");
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
			
			/*// commented by mark jm
			// change item group
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packPolFlag", gipiParList.getPackPolFlag());			
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
			pars.put("parDDLCommit", "Y");
			*/
			
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
		/*// commented by mark jm
		if("Y".equals((String) vars.get("varGroupSw"))){
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("parId", gipiParList.getParId());
			paramMap.put("packPolFlag", gipiParList.getPackPolFlag());
			this.getSqlMapClient().queryForObject("changeItemGroup", paramMap);
		}
		*/
		// check_additional_info
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("parId", gipiParList.getParId());
		paramMap.put("parStatus", gipiParList.getParStatus());
		log.info("Item (Post Form Commit)- Checking additional motorcar info ...");
		this.getSqlMapClient().queryForObject("checkAdditionalInfoMC2", paramMap);
		paramMap.clear();
		
		paramMap.put("parId", gipiParList.getParId());
		paramMap.put("packLineCd", globals.get("globalPackLineCd"));
		paramMap.put("packSublineCd", globals.get("globalPackSublineCd"));
		
		log.info("Item (Post Form Commit)- Updating gipi_wpacksubline ...");
		this.getSqlMapClient().queryForObject("updateGIPIWPackLineSubline", paramMap);
		paramMap = null;
		
		return true;
	}	
	
	@SuppressWarnings("unchecked")
	private void updateMortgageeRecords(Map<String, Object> param) throws SQLException {		
		if(param.get("mortgageeDelList") != null && ((List<Map<String, Object>>) param.get("mortgageeDelList")).size() > 0){			
			for(Map<String, Object> m : (List<Map<String, Object>>) param.get("mortgageeDelList")){				
				log.info("Item - (parId=" + m.get("parId") + ", itemNo=" + m.get("itemNo") + ", mortgCd=" + m.get("mortgCd") + ") - Deleting record in gipi_wmortgagee ...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", m);
			}			
		}
		
		if(param.get("mortgageeInsList") != null && ((List<GIPIParMortgagee>) param.get("mortgageeInsList")).size() > 0){
			for(GIPIParMortgagee m : (List<GIPIParMortgagee>) param.get("mortgageeInsList")){
				log.info("Item - (parId=" + m.getParId() + ", itemNo=" + m.getItemNo() + ", mortgCd=" + m.getMortgCd() + ") - Inserting record to gipi_wmortgagee ...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}
		}
	}
	
	@SuppressWarnings("unchecked")
	private void updateAccessoryRecords(Map<String, Object> param) throws SQLException {
		if(param.get("accessoryDelList") != null && ((List<Map<String, Object>>) param.get("accessoryDelList")).size() > 0){
			for(Map<String, Object> accMap : (List<Map<String, Object>>) param.get("accessoryDelList")){
				log.info("Item - (parId=" + accMap.get("parId") + ", itemNo=" + accMap.get("itemNo") + ", accCd=" + accMap.get("accCd") + ") - Deleting record in gipi_wmcacc ...");
				this.getSqlMapClient().delete("delGipiWMcAccWithAccCd", accMap);
			}
		}
		
		if(param.get("accessoryInsList") != null && ((List<GIPIWMcAcc>) param.get("accessoryInsList")).size() > 0){
			for(GIPIWMcAcc acc : (List<GIPIWMcAcc>) param.get("accessoryInsList")){
				log.info("Item - (parId=" + acc.getParId() + ", itemNo=" + acc.getItemNo() + ", accCd=" + acc.getAccessoryCd() + ") - Inserting record to gipi_wmcacc ...");
				this.getSqlMapClient().insert("setGipiWMcAccByParams", acc);
			}
		}		
	}
	
	@SuppressWarnings("unchecked")
	public void updateDeductibleRecords(Map<String, Object> param, int deductibleLevel) throws SQLException {		
		if(deductibleLevel == 2){
			if(param.get("deductibleDelList") != null && ((List<Map<String, Object>>) param.get("deductibleDelList")).size() > 0){
				for(Map<String, Object> dedMap : (List<Map<String, Object>>) param.get("deductibleDelList")){
					log.info("Item - (parId=" + dedMap.get("parId") + ", itemNo=" + dedMap.get("itemNo") + ", dedCd=" + dedMap.get("dedDeductibleCd") + ") - Deleting record in gipi_wdeductibles (item level) ...");
					this.getSqlMapClient().delete("delGipiWDeductibles", dedMap);
				}
			}
			
			if(param.get("deductibleInsList") != null && ((List<GIPIWDeductible>) param.get("deductibleInsList")).size() > 0){
				for(GIPIWDeductible ded : (List<GIPIWDeductible>) param.get("deductibleInsList")){					
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() + ") - Inserting record to gipi_wdeductibles (item level) ...");
					this.getSqlMapClient().insert("saveWDeductible", ded);									
				}
			}
		}else if(deductibleLevel == 3){
			if(param.get("perilDedDelList") != null && ((List<Map<String, Object>>) param.get("perilDedDelList")).size() > 0){
				for(Map<String, Object> dedMap : (List<Map<String, Object>>) param.get("perilDedDelList")){
					log.info("Item - (parId=" + dedMap.get("parId") + ", itemNo=" + dedMap.get("itemNo") + ", dedCd=" + dedMap.get("dedDeductibleCd") + ") - Deleting record in gipi_wdeductibles (peril level) ...");
					this.getSqlMapClient().delete("delGipiWDeductibles", dedMap);
				}
			}
			
			if(param.get("perilDedInsList") != null && ((List<GIPIWDeductible>) param.get("perilDedInsList")).size() > 0){
				for(GIPIWDeductible ded : (List<GIPIWDeductible>) param.get("perilDedInsList")){
					log.info("Item - (parId=" + ded.getParId() + ", itemNo=" + ded.getItemNo() + ", dedCd=" + ded.getDedDeductibleCd() + ") - Inserting record to gipi_wdeductibles (peril level) ...");
					this.getSqlMapClient().insert("saveWDeductible", ded);
				}
			}
		}else if(deductibleLevel == 1){ //added by BRYAN for deleting policy deductibles when necessary
			if(param.get("polDeductibleDelList") != null && ((List<GIPIWDeductible>) param.get("polDeductibleDelList")).size() > 0){
				for(Map<String, Object> dedMap : (List<Map<String, Object>>) param.get("polDeductibleDelList")){
					log.info("Item - (parId=" + dedMap.get("parId") + ", itemNo=" + dedMap.get("itemNo") + ", dedCd=" + dedMap.get("dedDeductibleCd") + ") - Deleting record in gipi_wdeductibles (policy level) ...");
					this.getSqlMapClient().delete("delGipiWDeductibles", dedMap);
				}
			}
		}
		
	}
	
	@SuppressWarnings("unchecked")
	public void updateItemPerilRecords(Map<String, Object> param) throws SQLException {
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
	}
	
	@SuppressWarnings("unused")
	private Map<String, Integer> getItemNumbersForInsertUpdate(List<GIPIWItem> itemList){
		Map<String, Integer> itemNumbersMap = new HashMap<String, Integer>();
		
		for(GIPIWItem item : itemList){
			itemNumbersMap.put(String.valueOf(item.getItemNo()), item.getItemNo());			
		}
		
		return itemNumbersMap;
	}
}
