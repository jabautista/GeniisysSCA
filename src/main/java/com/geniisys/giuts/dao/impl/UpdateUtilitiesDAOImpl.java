package com.geniisys.giuts.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIEndtText;
import com.geniisys.gipi.entity.GIPIPackEndtText;
import com.geniisys.gipi.entity.GIPIPackPolgenin;
import com.geniisys.gipi.entity.GIPIPolgenin;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.giuts.dao.UpdateUtilitiesDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class UpdateUtilitiesDAOImpl implements UpdateUtilitiesDAO{
	
	private Logger log = Logger.getLogger(UpdateUtilitiesDAOImpl.class);
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Integer getNextBookingYear() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNextBookingYear");
	}

	@Override
	public Integer checkBookingYear(Integer bookingYear) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkBookingYear", bookingYear);
	}

	@Override
	public String generateBookingMonths(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();			

			this.getSqlMapClient().update("generateBookingMonths", params);	
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "Success";
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			message = message == "Success" ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) :message;	
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}

	@Override
	public String updateGiisBookingMonths(Map<String, Object> params) throws SQLException {
		String message = "";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> bookings = (List<Map<String, Object>>) params.get("bookings");
			for (Map<String, Object> b: bookings){
				b.put("userId", params.get("userId")); //marco - 05.07.2013
				b.put("remarks", StringEscapeUtils.unescapeHtml((String) b.get("remarks"))); //shan 05.23.2013 as per SR-13175
				log.info("Policy Booking: " + b);
				this.getSqlMapClient().update("updateGiisBookingMonth", b);
				message = "Success";
			}

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = message == "Success" ? ExceptionHandler.handleException(e, (GIISUser) params.get("USER")) : message;
		}catch(Exception e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			throw new SQLException();
		}finally{
			System.out.println(message);
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}

	@Override
	public String chkBookingMthYear(Map<String, Object> params) throws SQLException {
		log.debug("Checking Booking Month and Year..");
		return (String) this.getSqlMapClient().queryForObject("chkBookingMthYear", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> getCurrentWcCdList(Map<String, Object> params) throws SQLException {
		List<String> genericList = null;
		
		log.info("Retrieving list by "+params.get("ACTION"));
		if(params.get("ACTION").equals("getCurrentWcCdList")){
			genericList = this.getSqlMapClient().queryForList("getWcCdList",params);
		} else if(params.get("ACTION").equals("getWarrClaPrintSeqNoList")){
			genericList = this.getSqlMapClient().queryForList("getWarrClaPrintSeqNoList",params);
		}
		log.info("list by "+params.get("ACTION")+" retrieved.");
		return genericList;
	}

	@Override
	public void giuts029NewFormInstance(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("giuts029NewFormInstance", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void giuts029SaveChanges(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			List<Map<String, Object>> delRows = (List<Map<String, Object>>) params.get("delRows");
		
			for(Map<String, Object> d: delRows){	
//				d.put("fileName", StringFormatter.unescapeHTML2((String) d.get("fileName")));
				this.sqlMapClient.update("giuts029DelRows",  d);
			}
			
			for(Map<String, Object> s: setRows){
//				s.put("appUser", params.get("appUser"));
				this.sqlMapClient.update("giuts029SetRows", s);
			}			

			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void saveGipis047BondUpdate(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			log.info("Saving Update Bond Policy Basic Information:" + params.get("policyId"));
			this.getSqlMapClient().insert("saveGipis047BondUpdate", params);
			log.info("Finished.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
	}

	@Override
	public void updateGIPIS156(Map<String, Object> params) throws SQLException,
			Exception {
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("updateGIPIS156", params);
			this.getSqlMapClient().executeBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> invoiceList = (List<Map<String, Object>>) params.get("invoiceList");
			
			for(int x = 0; x < invoiceList.size(); x++){
				this.getSqlMapClient().update("updateGIPIS156Invoice", invoiceList.get(x));
				this.getSqlMapClient().executeBatch();
				System.out.println("invoice : ");
				System.out.println(invoiceList.get(x));
			}			
			
			// apollo 08.06.2015 - SR#19928 - to update booking dates in gipi_polbasic
			if(!"1".equals(params.get("noOfTakeup").toString().trim())) {
				this.getSqlMapClient().insert("updatePolbasicBookingDate", params.get("policyId").toString());
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
			
		} catch (Exception e) {
			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
			
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public String validateGIPIS156AreaCd(String areaCd) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("validateGIPIS156AreaCd", areaCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONObject validateGIPIS156BancBranchCd(String areaCd,
			String branchCd) throws SQLException, JSONException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("areaCd", areaCd);
		params.put("branchCd", branchCd);
		
		
		return new JSONObject((Map<String, Object>) this.getSqlMapClient().queryForObject("validateGIPIS156BancBranchCd", params));
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGeneralInitialInfo(Map<String, Object> params) throws SQLException {
		List<GIPIPolgenin> list = this.getSqlMapClient().queryForList("getGeneralInitialInfo", params);
		params.put("list", list);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGeneralInitialPackInfo(Map<String, Object> params) throws SQLException {
		List<GIPIPackPolgenin> list = this.getSqlMapClient().queryForList("getGeneralInitialPackInfo", params);
		params.put("list", list);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getEndtInfo(Map<String, Object> params) throws SQLException {
		List<GIPIEndtText> list = this.getSqlMapClient().queryForList("getEndtInfo", params);
		params.put("list", list);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveGenInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPolgenin> setRows = (List<GIPIPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPolgenin gipiPolgenin : setRows) {
				log.info("saving general information : "+setRows);
				this.sqlMapClient.insert("setGenInfo", gipiPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInitialInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPolgenin> setRows = (List<GIPIPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPolgenin gipiPolgenin : setRows) {
				log.info("saving initial information : "+setRows);
				this.sqlMapClient.insert("setInitialInfo", gipiPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveGenPackInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPackPolgenin> setRows = (List<GIPIPackPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPackPolgenin gipiPackPolgenin : setRows) {
				log.info("saving general pack information : "+setRows);
				this.sqlMapClient.insert("setGenPackInfo", gipiPackPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveInitialPackInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPackPolgenin> setRows = (List<GIPIPackPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPackPolgenin gipiPackPolgenin : setRows) {
				log.info("saving initial pack information : "+setRows);
				this.sqlMapClient.insert("setInitialPackInfo", gipiPackPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveEndtText(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIEndtText> setRows = (List<GIPIEndtText>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIEndtText gipiEndtText  : setRows) {
				log.info("saving endorsement text : "+setRows);
				this.sqlMapClient.insert("setEndtText", gipiEndtText);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validatePackage(Integer packPolicyId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkPackagePolicy", packPolicyId);
	}
	
	// SR-21812 JET JUN-27-2016
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackGeneralInitialInfo(Map<String, Object> params) throws SQLException {
		List<GIPIPackPolgenin> list = this.getSqlMapClient().queryForList("getPackGeneralInitialInfo", params);
		params.put("list", list);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPackEndtInfo(Map<String, Object> params) throws SQLException {
		List<GIPIPackEndtText> list = this.getSqlMapClient().queryForList("getPackEndtInfo", params);
		params.put("list", list);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String savePackGenInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPackPolgenin> setRows = (List<GIPIPackPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPackPolgenin gipiPackPolgenin : setRows) {
				log.info("saving general pack information : "+setRows);
				this.sqlMapClient.insert("setPackGenInfo", gipiPackPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String savePackInitInfo(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPackPolgenin> setRows = (List<GIPIPackPolgenin>) params.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPackPolgenin gipiPackPolgenin : setRows) {
				log.info("saving initial pack information : "+setRows);
				this.sqlMapClient.insert("setPackInitInfo", gipiPackPolgenin);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String savePackEndtText(Map<String, Object> params) throws SQLException {
		String message = "";
		List<GIPIPackEndtText> setRows = (List<GIPIPackEndtText>) params.get("setRows");
		try {		
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIPIPackEndtText gipiPackEndtText  : setRows) {
				log.info("saving endorsement text : "+setRows);
				this.sqlMapClient.insert("setPackEndtText", gipiPackEndtText);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			message = "SUCCESS";
		} catch (SQLException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			message = "FAILED";
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	// @#

	@SuppressWarnings("unchecked")
	@Override
	public void saveGipis032MVFileNoUpdate(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIPIVehicle> setRows = (List<GIPIVehicle>) params.get("setRows");
			
			for(GIPIVehicle s: setRows){
				log.info("Saving Update MV File Number: policy_no = " + s.getPolicyId() + ", item_no = " + s.getItemNo());
				this.getSqlMapClient().insert("saveGipis032MVFileNoUpdate", s);
			}
			log.info("Finished.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
		
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getGipis155BlockId(Map<String, Object> params) throws SQLException{
		List<String> genericList = null;		
		log.info("Getting block Id : " + params.toString());
		genericList = sqlMapClient.queryForList("getBlockIdGipis155", params);
		
		System.out.println(genericList.toString());
		
		return genericList;
	}
	
	public String saveFireItems(Map<String, Object> params, String userId) throws SQLException, Exception{
		String msg = "";
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> modifiedRows = (List<Map<String, Object>>) params.get("modifiedRows");
			
			for(Map<String, Object> m: modifiedRows){
				m.put("userId", userId);
				log.info("Updating Fire Item : " + params.toString());
				this.sqlMapClient.update("updateGIPIS155FireItem", m);
				
				if (!m.get("tarfCd").equals(m.get("origTarfCd"))){
					log.info("Inserting Tarf History : " + params.toString());
					m.put("oldTarfCd", m.get("origTarfCd"));
					m.put("newTarfCd", m.get("tarfCd"));
					this.sqlMapClient.insert("insertGIPIS155TarfHist", m);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			msg = "SUCCESS";
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return msg;
	}
	
	
	public void saveGiuts025(Map<String, Object> params) throws SQLException, Exception{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			/* for polbasic */
			Map<String, Object> polbasic = new HashMap<String, Object>();
			polbasic.put("policyId", params.get("policyId"));
			polbasic.put("newRefPolNo", params.get("newRefPolNo"));
			polbasic.put("newManualRenewNo", params.get("newManualRenewNo"));
			polbasic.put("userId", params.get("userId")); //added by robert SR 5165 11.05.15
			polbasic.put("newRefAcceptNo", params.get("newRefAcceptNo")); //added by robert SR 5165 11.05.15
			
			log.info("Updating GIPI_POLBASIC : "+polbasic.toString());
			this.sqlMapClient.update("updateGipiPolbasicGiuts025", polbasic);
			
			/* for modified invoices */
			@SuppressWarnings("unchecked")
			List<Map<String, Object>> modifiedRows = (List<Map<String, Object>>) params.get("modifiedRows");
			
			for(Map<String, Object> m: modifiedRows){
				log.info("Updating GIPI_INVOICE : " + m.toString());
				m.put("userId", params.get("userId")); //added by robert SR 5165 11.05.15
				this.sqlMapClient.update("updateGipiInvoiceGiuts025", m);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
	}

	@Override
	public void valAddGiuts029(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGiuts029",params);
	}
}
