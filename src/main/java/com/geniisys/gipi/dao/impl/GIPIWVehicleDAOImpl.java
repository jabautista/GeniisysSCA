package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIWItemDAO;
import com.geniisys.gipi.dao.GIPIWItemPerilDAO;
import com.geniisys.gipi.dao.GIPIWVehicleDAO;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.entity.GIPIWItemPeril;
import com.geniisys.gipi.entity.GIPIWMcAcc;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWVehicle;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWVehicleDAOImpl implements GIPIWVehicleDAO{
	
	private SqlMapClient sqlMapClient;
	private GIPIWItemDAO gipiWItemDAO;
	private GIPIWItemPerilDAO gipiWItemPerilDAO;
	
	private Logger log = Logger.getLogger(GIPIWVehicleDAOImpl.class);
	
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

	@Override
	public Map<String, Object> gipis010NewFormInstance(
			Map<String, Object> params) throws SQLException {
		log.info("Getting GIPIS010 New Form Instance Variables ...");
		this.getSqlMapClient().queryForObject("gipis010NewFormInstance1", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWVehicle(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Saving Motorcar Items ...");
		
		try{
			List<Map<String, Object>> setItems 			= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems 			= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWVehicle> vehicleItems				= (List<GIPIWVehicle>) params.get("vehicleItems");
			
			// mortgagees
			List<GIPIParMortgagee> insMortgagees		= (List<GIPIParMortgagee>) params.get("setMortgagees");
			List<Map<String, Object>> delMortgagees		= (List<Map<String, Object>>) params.get("delMortgagees");
			
			// accessories
			List<GIPIWMcAcc> insAccessories				= (List<GIPIWMcAcc>) params.get("setAccessories");
			List<Map<String, Object>> delAccessories	= (List<Map<String, Object>>) params.get("delAccessories");
			
			// deductibles
			List<GIPIWDeductible> insDeductibles		= (List<GIPIWDeductible>) params.get("setDeductRows");
			List<GIPIWDeductible> delDeductibles		= (List<GIPIWDeductible>) params.get("delDeductRows");
			
			GIPIWPolbas gipiWPolbas						= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc								= (JSONObject) params.get("misc");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap				= null;
			
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
			
			// GIPI_WVEHICLE (insert/update)
			for(GIPIWVehicle vehicle : vehicleItems){
				log.info("Inserting/Updating record on gipi_wvehicle ...");
				log.info("REG TYPE: " + vehicle.getRegType());
				this.getSqlMapClient().insert("setGIPIWVehicleNew", vehicle); //modified by herbert 06222015 for COC Authentication
				
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
			
			// GIPI_WMCACC (delete)
			for(Map<String, Object> delAcc : delAccessories){
				log.info("Deleting record on gipi_wmcacc ...");				
				this.getSqlMapClient().delete("delGipiWMcAccWithAccCd", delAcc);
			}
			
			// GIPI_WMCACC (insert/update)
			for(GIPIWMcAcc acc : insAccessories){
				log.info("Inserting/Updating record on gipi_wmcacc ...");
				this.getSqlMapClient().insert("setGipiWMcAcc", acc);
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
			if(params.get("parType").toString().equals("E")) {
				this.getGipiWItemDAO().endtItemPostFormsCommit(params);
			} else {
				this.getGipiWItemDAO().parItemPostFormsCommit(params);
			}
			
			if(params.get("parType").toString().equals("E")){
				// insert, update, delete item peril
				if((params.get("setPerils") != null && ((List<GIPIWItemPeril>) params.get("setPerils")).size() > 0) ||
					(params.get("delPerils") != null && ((List<GIPIWItemPeril>) params.get("delPerils")).size() > 0) ||
					("Y".equals(params.get("delDiscSw")))){	
					this.getGipiWItemPerilDAO().saveGIPIWItemPeril(params);
					this.getSqlMapClient().executeBatch();
					this.getGipiWItemPerilDAO().endtItemPerilPostFormsCommit(params);
				} 
			} else {
				// insert, update, delete item peril
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
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public String checkCOCSerialNoInPolicyAndPar(Map<String, Object> params)
			throws SQLException {
		log.info("Checking COC Serial No. in Policy and Par ...");
		return (String) this.getSqlMapClient().queryForObject("checkCOCSerialNoInPolicyAndPar", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String validateOtherInfo(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Validating other info ...");
		
		String result = "";
		try{
			List<Map<String, Object>> setItems 			= (List<Map<String, Object>>) params.get("setItems");
			List<Map<String, Object>> delItems 			= (List<Map<String, Object>>) params.get("delItems");
			List<GIPIWVehicle> vehicleItems				= (List<GIPIWVehicle>) params.get("vehicleItems");
			
			GIPIWPolbas gipiWPolbas						= (GIPIWPolbas) params.get("gipiWPolbas");
			JSONObject misc								= (JSONObject) params.get("misc");			
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> paramMap = null;			
			
			Map<String, Object> paramsForValidation = new HashMap<String, Object>();
			paramsForValidation.put("parId", gipiWPolbas.getParId());
			
			 for (Map<String, Object> map : setItems) {// added by Kenneth L. 03.27.2014
				 if(gipiWPolbas.getParId() == map.get("parId")){
					 paramsForValidation.put("itemNo", map.get("itemNo"));
				 }
			 }
			 
			// GIPI_WITEM (delete)
			for(Map<String, Object> item : delItems){
				if("Y".equals(misc.getString("miscDeletePolicyDeductibles"))){
					paramMap = new HashMap<String, Object>();
					paramMap.put("parId", gipiWPolbas.getParId());
					paramMap.put("lineCd", gipiWPolbas.getLineCd());
					paramMap.put("sublineCd", gipiWPolbas.getSublineCd());
					
					log.info("Deleting policy deductibles ...");
					this.getSqlMapClient().queryForObject("deletePolDeductibles", paramMap);					
				}			
				
				log.info("Deleting record on gipi_witem ...");
				this.getSqlMapClient().delete("delGIPIWItem", item);
			}
			
			// GIPI_WITEM (insert/update)
			for(Map<String, Object> item : setItems){
				log.info("Inserting/Updating record on gipi_witem ...");				
				this.getSqlMapClient().insert("setGIPIWItem2", item);
			}
			
			// GIPI_WVEHICLE (insert/update)
			for(GIPIWVehicle vehicle : vehicleItems){
				log.info("Inserting/Updating record on gipi_wvehicle ...");
				this.getSqlMapClient().insert("setGIPIWVehicle1", vehicle);
			}
			
			this.getSqlMapClient().executeBatch();
			System.out.println(paramsForValidation);
			result = (String) this.getSqlMapClient().queryForObject("validateOtherInfo", paramsForValidation);// changed by Kenneth L. 03.27.2014
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getMessage());
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return result;
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

	@Override
	public void gipis060ValidateItem(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("gipis060ValidateItem", params);		
	}
	
	@Override
	public Map<String, Object> validatePlateNo(Map<String, Object> params)
			throws SQLException {
		log.info("Validating plate no ...");
		this.getSqlMapClient().queryForObject("validateMCPlateNo", params);
		return params;
	}

	@Override
	public String validateCocSerialNo(Map<String, Object> params)
			throws SQLException {
		log.info("Validating coc serial no ...");
		return (String) this.getSqlMapClient().queryForObject("validateMCCocSerialNo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWVehicle> getVehiclesForPAR(Integer parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getAllVehiclesForPAR", parId);
	}
}
