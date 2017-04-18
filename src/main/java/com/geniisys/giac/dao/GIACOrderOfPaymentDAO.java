package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giac.entity.GIACOrRel;
import com.geniisys.giac.entity.GIACOrderOfPayment;

public interface GIACOrderOfPaymentDAO {

	Integer saveORInformation(Map<String, Object> allParam, Integer gaccTranId) throws Exception;
	
	GIACOrderOfPayment validateCancelledORInput(String orPrefSuf, Integer orNo) throws Exception;

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
	List<Map<String, Object>> getORList(Map<String, Object> params) throws SQLException;

	
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
	
	 //Map<String, Object>  updateAllPayorItmDtls (Map<String, Object> params) throws SQLException; commented by alfie 03-14-2011
	 void  updateAllPayorItmDtls (List<Map<String, Object>> params) throws Exception;
	 /**
		 * Update selected payor or intermediary details in GIACOrderOfPayment 
		 * @return message
		 * @throws SQLException
		 */
		
	 Map<String, Object>  updateSelectedPayorItmDtls (Map<String, Object> params) throws SQLException;
	 
	 void spoilOR(Map<String, Object> params) throws SQLException, Exception;

	 /**
	 * Gets Order of Payments Listing in table grid
	 * @param fund code, branch code
	 * @return
	 * @throws SQLException
	 */
	 List<Map<String, Object>> getORListTableGrid(Map<String, Object> params) throws SQLException;
	 
	 Map<String, Object> giacs050InsUpdGIOP(Map<String, Object> params) throws SQLException;

	 /*added by alfie 03-14-2011*/
	 String getUpdatedPayorIntmDtls (Map<String, Object> params) throws SQLException;
	 
	 Map<String, Object> spoilPrintedOR(Map<String, Object> params) throws SQLException;
	 
	 List<Map<String, Object>> getCreditMemoDtls(String fundCd) throws SQLException;
	 
	 String checkAttachedOR(Map<String, Object> params) throws SQLException;
	 
	 String validateOr(Map<String, Object> params) throws SQLException;
	 
	 Map<String, Object> insUpdGIOPNewOR(Map<String, Object> params) throws SQLException;
	 
	 void validateOR2(Map<String, Object> params) throws SQLException, InterruptedException;
	 
	 Map<String, Object> generateNewOR(Map<String, Object> params) throws SQLException, InterruptedException;
	 
	 void processPrintedOR(Map<String, Object> params) throws SQLException;	 
	 void checkCommPayts(Integer gaccTranId) throws SQLException;

	 void delOR(Map<String, Object> params)throws SQLException;
	 String getPayorIntmDtls(int tranId) throws SQLException, JSONException;
	 
	 void populateBatchORTempTable(Map<String, Object> params) throws SQLException;
	 String checkOR(String gaccTranId) throws SQLException;
	 Map<String, Object> checkAllORs(Map<String, Object> params) throws SQLException;
	 void uncheckAllORs() throws SQLException;
	 Map<String, Object> getDefaultORValues(Map<String, Object> params) throws SQLException;
	 void generateOrNumbers(Map<String, Object> params) throws SQLException;
	 List<Map<String, Object>> getBatchORReportParams(Map<String, Object> params) throws SQLException;
	 void saveGenerateFlag(Map<String, Object> params) throws SQLException;
	 void processPrintedBatchOR(Map<String, Object> params) throws SQLException;
	 String checkLastPrintedOR(Map<String, Object> params) throws SQLException;
	 void spoilBatchOR(Map<String, Object> params) throws SQLException;
	 void spoilSelectedOR(Map<String, Object> params) throws SQLException;
	 Map<String, Object> getBatchCommSlipParams() throws SQLException;
	 
	 Integer countVehiclesInsured(Integer assdNo) throws SQLException;
	 String checkAPDCPaytDtl(Integer gaccTranId) throws SQLException;
	 
	 //john dolon
	 public List<Map<String, Object>> getCnclCollnBreakDown(Integer tranId) throws SQLException; //10.15.2014
	 public GIACOrRel getGiacOrRel(Integer gaccTranId) throws SQLException; //10.20.2014
	 
	 void checkRecordStatus(Map<String, Object> params) throws SQLException;
}
