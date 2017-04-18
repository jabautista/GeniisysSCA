/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.giac.entity.GIACOrRel;
import com.geniisys.giac.entity.GIACOrderOfPayment;

/**
 * The Interface GIACOrderOfPaymentService.
 */
public interface GIACOrderOfPaymentService {
	
	/**
	 * Get Company Details.
	 * 
	 * @return the GIACOrderOfPayment
	 * @throws SQLException the sQL exception
	 */
	//public GIACOrderOfPayment getCompanyDetails() throws SQLException;
	
	/**
	 * Save all details in a transaction
	 * 
	 * @throws SQLException the sQL exception
	 */
	public Integer saveORInformation(Map<String, Object> allParam, Integer gaccTranId) throws Exception;
	
	public GIACOrderOfPayment validateCancelledORInput(String orPrefSuf, Integer orNo) throws Exception;

	/**
	 * Gets GIACOrderOfPayment details of the specified Transaction ID
	 * @param tranId The transaction Id
	 * @return
	 * @throws SQLException
	 */
	GIACOrderOfPayment getGIACOrderOfPaymentDtl(int tranId) throws SQLException;
	
	/**
	 * Gets RV Meaning of specified domain and low value.
	 * Transfer this procedure if another DAO for CG_REF_CODES_PKG is created - emman 07.22.10
	 * @param rvDomain The domain
	 * @param rvLowValue The low value
	 * @return
	 * @throws SQLException
	 */
	String getRVMeaning(String rvDomain, String rvLowValue) throws SQLException;
	
	/**
	 * @param workFlow tranId
	 * @return orTag
	 * @throws SQLException
	 */
	String getOrTag(Integer tranID) throws SQLException;
	
	/**
	 * Gets Order of Payments Listing
	 * @param keyword, fund code, branch code
	 * @return
	 * @throws SQLException
	 */
	JSONArrayList getORList(Integer pageNo, Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GIACOrderOfPayment details of the specified Transaction ID
	 * @param tranId The transaction Id
	 * @return
	 * @throws SQLException
	 */
	GIACOrderOfPayment getGIACOrDtl(int tranId) throws SQLException;
	
	/**
	 * Update payor or intermediary details in GIACOrderOfPayment 
	 * @return message
	 * @throws SQLException
	 */
	
	 //Map<String, Object>  updateAllPayorItmDtls (Map<String, Object> params) throws SQLException;
	 
	 /**
		 * Update selected payor or intermediary details in GIACOrderOfPayment 
		 * @return message
		 * @throws SQLException
		 */
		
	 Map<String, Object>  updateSelectedPayorItmDtls (Map<String, Object> params) throws SQLException;
	 
	 void spoilOR(Map<String, Object> params) throws SQLException, Exception;
 
	 /**
	  * 
	  * @param jsonArray
	  * @return message
	  * @throws SQLException
	  */
	 void updateAllPayorItmDtls2 (JSONArray jsonPremCollnsDtls) throws SQLException, JSONException;

	 /**
	  * Gets the map that will be used for the display of table grid for the OR Listing
	  * @param params
	  * @return
	  * @throws SQLException
	  * @throws JSONException
	  */
	 Map<String, Object> getORListTableGridMap(Map<String, Object> params) throws SQLException, JSONException;
	 
	 Map<String, Object> giacs050InsUpdGIOP(Map<String, Object> params) throws SQLException;
	 
	 String getUpdatedPayorIntmDtls(JSONArray jsonArray) throws SQLException, JSONException;
	 
	 Map<String, Object> spoilPrintedOR(Map<String, Object> params) throws SQLException;
	 
	 List<Map<String, Object>> getCreditMemoDtls(String fundCd) throws SQLException;
	 
	 String checkAttachedOR(Map<String, Object> params) throws SQLException;
	 
	 String validateOr(Map<String, Object> params) throws SQLException;
	 
	 Map<String, Object> insUpdGIOPNewOR(Map<String, Object> params) throws SQLException;
	 
	 void validateOR2(Map<String, Object> params) throws SQLException, InterruptedException;
	 
	 Map<String, Object> generateNewOR(Map<String, Object> params) throws SQLException, InterruptedException;
	 
	 void processPrintedOR(Map<String, Object> params) throws SQLException;
	 void checkCommPayts(HttpServletRequest request) throws SQLException;

	 public void delOR(Map<String, Object> params)throws SQLException;
	 String getPayorIntmDtls(int tranId) throws SQLException, JSONException;

	 void populateBatchORTempTable(HttpServletRequest request) throws SQLException;
	 JSONObject getBatchORList(HttpServletRequest request) throws SQLException, JSONException;
	 String checkOR(HttpServletRequest request) throws SQLException;
	 Map<String, Object> checkAllORs(HttpServletRequest request) throws SQLException;
	 void uncheckAllORs() throws SQLException;
	 Map<String, Object> getDefaultORValues(HttpServletRequest request, String userId) throws SQLException;
	 void generateOrNumbers(HttpServletRequest request, String userId) throws SQLException;
	 List<Map<String, Object>> getBatchORReportParams(HttpServletRequest request) throws SQLException;
	 void saveGenerateFlag(HttpServletRequest request) throws SQLException, JSONException;
	 void processPrintedBatchOR(HttpServletRequest request, String userId) throws SQLException;
	 String checkLastPrintedOR(HttpServletRequest request) throws SQLException;
	 void spoilBatchOR(HttpServletRequest request, String userId) throws SQLException;
	 void spoilSelectedOR(HttpServletRequest request, String userId) throws SQLException;
	 Map<String, Object> getBatchCommSlipParams() throws SQLException;
	 
	 JSONObject getGiacs213VehicleListing(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 Integer countVehiclesInsured(Integer assdNo) throws SQLException;
	 
	 JSONObject getGiacs214PolbasicListing(HttpServletRequest request, String userId) throws SQLException, JSONException;
	 JSONObject getGiacs214InvoiceListing(HttpServletRequest request) throws SQLException, JSONException;
	 JSONObject getGiacs214AgingSoaDetails(HttpServletRequest request) throws SQLException, JSONException;
	 String checkAPDCPaytDtl(Integer gaccTranId) throws SQLException;
	 
	 //john 10.15.2014
	 public List<Map<String, Object>> getCnclCollnBreakDown(HttpServletRequest request) throws SQLException;
	 public GIACOrRel getGiacOrRel(Integer tranId) throws SQLException;
	 
	 void checkRecordStatus(HttpServletRequest request) throws SQLException;
}
