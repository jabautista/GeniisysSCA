package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.controllers.GIPIWItmperlGroupedController;
import com.geniisys.gipi.dao.GIPIWItmperlGroupedDAO;
import com.geniisys.gipi.entity.GIPIWGroupedItems;
import com.geniisys.gipi.entity.GIPIWItem;
import com.geniisys.gipi.entity.GIPIWItmperlGrouped;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWItmperlGroupedDAOImpl implements GIPIWItmperlGroupedDAO{
	
	private Logger log = Logger.getLogger(GIPIWItmperlGroupedDAOImpl.class);
	
	private SqlMapClient sqlMapClient;	

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWItmperlGrouped> getGipiWItmperlGrouped(Integer parId,
			Integer itemNo) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return this.getSqlMapClient().queryForList("getGIPIWItmperlGrouped", params);
	}

	@Override
	public String isExist(Integer parId, Integer itemNo) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		params.put("itemNo", itemNo.toString());
		return (String) this.getSqlMapClient().queryForObject("isExistGIPIWItmperlGrouped", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<GIPIWItmperlGrouped> getGipiWItmperlGrouped2(Integer parId) throws SQLException{
		return (List<GIPIWItmperlGrouped>) this.getSqlMapClient().queryForList("getGIPIWItmperlGrouped2", parId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> negateDeleteItemGroup(Map<String, Object> params)
			throws SQLException {
		log.info("Negate/Delete Item Group ...");
		
		try{
			List<Map<String, Object>> delGroupedItemRows = (List<Map<String, Object>>) params.get("delGroupedItemRows");
			GIPIWItem gipiWItem = (GIPIWItem) params.get("gipiWItem");
			GIPIWGroupedItems gipiWGroupedItems = (GIPIWGroupedItems) params.get("gipiWGroupedItems");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println(gipiWGroupedItems.getItemNo());
			System.out.println(gipiWGroupedItems.getGroupedItemTitle());
			// delete
			for(Map<String, Object> delMap : delGroupedItemRows){
				log.info("Deleting gipi_witmperl_grouped ...");
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delMap);
			}
			
			log.info("Inserting record to gipi_witem ...");
			this.getSqlMapClient().insert("setGIPIWItem", gipiWItem);
			
			log.info("Inserting record to gipi_wgrouped_items ...");
			this.getSqlMapClient().insert("setGipiWGroupedItems2", gipiWGroupedItems);
			
			this.getSqlMapClient().executeBatch();			
			
			log.info("Negating/Deleting Item Group ...");
			this.getSqlMapClient().update("negateDeleteItemGroup", params);
			
			params.put("groupTsiAmt", params.get("tsiAmt"));
			params.put("groupPremAmt", params.get("premAmt"));
			params.put("groupAnnTsiAmt", params.get("annTsiAmt"));
			params.put("groupAnnPremAmt", params.get("annPremAmt"));
			params.put("groupGIPIWItmperlGrouped", params.get("gipiWItmperlGrouped"));
			
			this.getSqlMapClient().executeBatch();
			
			params.put("tsiAmt", null);
			params.put("premAmt", null);
			params.put("annTsiAmt", null);
			params.put("annPremAmt", null);
			params.put("gipiWItmperlGrouped", null);
			
			log.info("Inserting record group witem ...");
			this.getSqlMapClient().update("gipis065InsertRecGrpWItem", params);
			
			//this.getSqlMapClient().getCurrentConnection().rollback();bakit siya naka rollback???? changed - irwin 11.23.11
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
		
		return params;
	}
	
	/*
	 * Created a newer function. Irwin 11.23.11 
	 * */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> negateDeleteItemGroupNew(Map<String, Object> params)
			throws SQLException {
		log.info("Negate/Delete Item Group ...");
		
		try{
			List<Map<String, Object>> delGroupedItemRows = (List<Map<String, Object>>) params.get("delGroupedItemRows");
			GIPIWItem gipiWItem = (GIPIWItem) params.get("gipiWItem");
			GIPIWGroupedItems gipiWGroupedItems = (GIPIWGroupedItems) params.get("gipiWGroupedItems");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println(gipiWGroupedItems.getItemNo());
			System.out.println(gipiWGroupedItems.getGroupedItemTitle());
			
			Map<String, Object> delParams = new HashMap<String, Object>();
			delParams.put("parId", gipiWGroupedItems.getParId());
			delParams.put("itemNo", gipiWGroupedItems.getItemNo());
			delParams.put("groupedItemNo", gipiWGroupedItems.getGroupedItemNo());
			
			// deleting the perils of the negated item group
			log.info("Deleting gipi_witmperl_grouped of the negated item group...");
			this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delParams);
			
			// deleting beneficiary, perils and etc of the deleted item group and deletes the item group
			log.info("Deleting related records of the deleted item group(not negated)");
			for(Map<String, Object> delMap : delGroupedItemRows){
				
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNo",delMap);
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary2", delMap);
				
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delMap);
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			
			System.out.println(gipiWItem.getProrateFlag());
			log.info("Inserting record to gipi_witem ...");
			this.getSqlMapClient().insert("setGIPIWItem", gipiWItem);
			
			System.out.println("Delete Switch is: "+gipiWGroupedItems.getDeleteSw());
			log.info("Inserting record to gipi_wgrouped_items ...");
			this.getSqlMapClient().insert("setGipiWGroupedItems2", gipiWGroupedItems);
			
			this.getSqlMapClient().executeBatch();			
			
			Debug.print(params);
			log.info("Negating/Deleting Item Group ...");
			this.getSqlMapClient().update("negateDeleteItemGroup", params);
			
			params.put("groupTsiAmt", params.get("tsiAmt"));
			params.put("groupPremAmt", params.get("premAmt"));
			params.put("groupAnnTsiAmt", params.get("annTsiAmt"));
			params.put("groupAnnPremAmt", params.get("annPremAmt"));
			params.put("groupGIPIWItmperlGrouped", params.get("gipiWItmperlGrouped"));
			
			this.getSqlMapClient().executeBatch();
			
			params.put("tsiAmt", null);
			params.put("premAmt", null);
			params.put("annTsiAmt", null);
			params.put("annPremAmt", null);
			params.put("gipiWItmperlGrouped", null);
			
			log.info("Inserting record group witem ...");
			this.getSqlMapClient().update("gipis065InsertRecGrpWItem", params);
			
			//this.getSqlMapClient().getCurrentConnection().rollback();bakit siya naka rollback???? changed - irwin 11.23.11
			this.getSqlMapClient().executeBatch();
			
			//Added by: Nica 10/08/2012 - to update GIPI_WPOLBAS, Bill and Distribution
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("parId", params.get("parId"));
			paramMap.put("userId", params.get("userId"));
			paramMap.put("itemNo", params.get("itemNo"));
			paramMap.put("varPackageSw", "N"); 
			paramMap.put("varDelDiscSw", "N");
			paramMap.put("varNegateItem", "Y");
		
			this.getSqlMapClient().update("endtItemPerilPostFormsCommit", paramMap);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
		
		return params;
	}
	@SuppressWarnings("unchecked")
	public void untagDeleteItemGroup(Map<String, Object> params)
		throws SQLException {
		log.info("Untaging delete Item Group ...");
		try{
			List<Map<String, Object>> delGroupedItemRows = (List<Map<String, Object>>) params.get("delGroupedItemRows");
			GIPIWItem gipiWItem = (GIPIWItem) params.get("gipiWItem");
			GIPIWGroupedItems gipiWGroupedItems = (GIPIWGroupedItems) params.get("gipiWGroupedItems");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> delParams = new HashMap<String, Object>();
			delParams.put("parId", gipiWGroupedItems.getParId());
			delParams.put("itemNo", gipiWGroupedItems.getItemNo());
			delParams.put("groupedItemNo", gipiWGroupedItems.getGroupedItemNo());
			
			// deleting the perils of the item group
			
			log.info("Deleting gipi_witmperl_grouped of the negated item group...");
			this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delParams);
			this.getSqlMapClient().executeBatch();
			
			// deleting beneficiary, perils and etc of the deleted item group and deletes the item group
			log.info("Deleting related records of the deleted item group(not negated)");
			for(Map<String, Object> delMap : delGroupedItemRows){
				
				this.getSqlMapClient().delete("delGIPIWItmperlBeneficiaryGrpItemNo",delMap);
				this.getSqlMapClient().delete("delGIPIWGrpItemsBeneficiary2", delMap);
				
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped2", delMap);
				this.getSqlMapClient().delete("delGIPIWGroupedItems2", delMap);
			}
			this.getSqlMapClient().executeBatch();
			
			System.out.println(gipiWItem.getProrateFlag());
			log.info("Inserting record to gipi_witem ...");
			this.getSqlMapClient().insert("setGIPIWItem", gipiWItem);
			this.getSqlMapClient().executeBatch();
			
			//set the delete sw to "N"
			gipiWGroupedItems.setDeleteSw("N");
			log.info("Inserting record to gipi_wgrouped_items ...");
			this.getSqlMapClient().insert("setGipiWGroupedItems2", gipiWGroupedItems);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
	}

	@Override
	public String checkIfBackEndt(Map<String, Object> params)
			throws SQLException {
		log.info("Checking if backward endt ...");		
		return (String) this.getSqlMapClient().queryForObject("checkIfBackEndtForWItmperlGrouped", params);
	}
	
	@Override
	public void getEndtCoveragePerilAmounts(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getEndtCoveragePerilAmounts", params);
	}

	@Override
	public void deleteWItmperlGrouped(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			log.info("Start of deleteWItmperlGrouped...");
			this.getSqlMapClient().delete("delGIPIWItmperlGrouped4", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: insertRecGrpWItem2 :::");
			this.getSqlMapClient().insert("insertRecGrpWItem2", params);
			this.getSqlMapClient().executeBatch();
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of deleteWItmperlGrouped...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCoverageVars(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.getSqlMapClient().queryForObject("getCoverageVars", params);
	}

	@Override
	public Map<String, Object> deleteItmperl(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("deleteItmperl", params);
		return params;
	}

	@Override
	public String checkOpenAlliedPeril(
			Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkOpenAlliedPeril", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveCoverage(Map<String, Object> params, String userId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving enrollee coverages...");
			
			List<GIPIWItmperlGrouped> setRows = (List<GIPIWItmperlGrouped>) params.get("setRows");
			List<GIPIWItmperlGrouped> delRows = (List<GIPIWItmperlGrouped>) params.get("delRows");
			List<Map<String, Object>> setWcRows = (List<Map<String, Object>>) params.get("setWcRows");
			
			for (GIPIWItmperlGrouped del : delRows){
				log.info("DELETING: " + del);
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("parId", del.getParId());
				delParams.put("itemNo", del.getItemNo());
				delParams.put("groupedItemNo", del.getGroupedItemNo());
				delParams.put("perilCd", del.getPerilCd());
				this.getSqlMapClient().delete("delGIPIWItmperlGrouped", delParams);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIPIWItmperlGrouped set : setRows){
				log.info("INSERTING: " + set);
				this.getSqlMapClient().insert("setGIPIWItmperlGrouped", set);
			}
			this.getSqlMapClient().executeBatch();
			
			for (Map<String, Object> set : setWcRows){
				log.info("INSERTING: " + set);
				set.put("appUser", userId);
				this.getSqlMapClient().insert("setDefaultWC", set);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("setAmountCovered", params);
			this.getSqlMapClient().executeBatch();
			
			//if((String)params.get("itmperilExist") == "N"){
				log.info("::: insertRecGrpWItem2 :::");
				this.getSqlMapClient().insert("insertRecGrpWItem2", params);
				this.getSqlMapClient().executeBatch();
			//}
			
			log.info("::: postSaveGroupedItems :::");
			this.getSqlMapClient().update("postSaveGroupedItems", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			ExceptionHandler.logException(e);
			GIPIWItmperlGroupedController.exceptionMessage = ExceptionHandler.extractSqlExceptionMessage(e);			
			this.sqlMapClient.getCurrentConnection().rollback();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving enrollee coverages...");
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> computeTsi(Map<String, Object> params)
			throws SQLException {
		System.out.println("grouped items compute tsi: "+params);
		this.getSqlMapClient().update("computeWItmperlGrpTsi", params);
		return params;
	}

	@Override
	public Map<String, Object> computePremium(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("computeWItmperlGrpPremium", params);
		return params;
	}

	@Override
	public Map<String, Object> autoComputePremRt(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("autoComputePremRt", params);
		return params;
	}

	@Override
	public Map<String, Object> validateAllied(Map<String, Object> params)
			throws SQLException {
		System.out.println("Grouped validate Allied: "+params);
		this.getSqlMapClient().update("validateAllied", params);
		return params;
	}
	
	@Override
	public int checkDuration(String date1, String date2) throws SQLException {
		log.info("checking duration of date: "+date1 +" and "+date2);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("date1", date1);
		params.put("date2", date2);
		return (Integer) this.getSqlMapClient().queryForObject("checkDuration", params);
	}	
}
