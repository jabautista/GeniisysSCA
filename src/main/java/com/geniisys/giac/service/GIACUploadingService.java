package com.geniisys.giac.service;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;

public interface GIACUploadingService {
	String checkFileName (HttpServletRequest request) throws SQLException;
	Map<String, Object> readFile (File fileName, Map<String, Object> params) throws SQLException, Exception;
	Integer countExcelRows (File file) throws IOException;
	void createFile(List<String> queryList) throws IOException;
	JSONObject getProcessDataList(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> showGiacs603Head(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs603RecList(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> showGiacs603Legend(HttpServletRequest request) throws SQLException;
	Map<String, Object> showGiacUploadDvPaytDtl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void saveGiacs603DVPaytDtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void delGiacs603DVPaytDtl(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> showGiacUploadJvPaytDtl(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void saveGiacs603JVPaytDtl(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void delGiacs603JVPaytDtl(HttpServletRequest request) throws SQLException, JSONException;
	void checkDataGiacs603(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void cancelFileGiacs603(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void validateUploadGiacs603(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getDefaultBank(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> processGiacs603(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs603CheckForOverride(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giacs603UploadPayments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> checkPaymentDetails(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validatePrintOr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validatePrintDv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validatePrintJv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkDcbNoGiacs603(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	//shan 06.09.2015 : conversion of GIACS607
	Map<String, Object> getGIACS607Parameters(String userId) throws SQLException;
	String getGIACS607Legend(String rvDomain) throws SQLException;
	JSONObject getGIACS607GUFDetails(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGIACS607GUPCRecords(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGIACS607GUDVDetails(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIACS607Gudv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGIACS607GUJVDetails(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIACS607Gujv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGIACS607GUCDetails(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIACS607Gucd(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkNetCollnGIACS607(HttpServletRequest request) throws SQLException, JSONException;
	void updateGIACS607GrossTag(HttpServletRequest request) throws SQLException;
	void cancelFileGIACS607(HttpServletRequest request) throws SQLException;
	String checkOrPaytsGIACS607(String tranId) throws SQLException;
	void validateBeforeUploadGIACS607(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> validatePolicyGIACS607(HttpServletRequest request, String userId) throws SQLException;
	String checkUserBranchAccessGIACS607(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> checkUploadGIACS607(HttpServletRequest request, String userId) throws SQLException;
	Integer getParentIntmNoGIACS607(String intmNo) throws SQLException;
	void uploadPaymentsGIACS607(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validateOnPrintBtnGIACS607(HttpServletRequest request, String userId) throws SQLException;
	void checkDcbNoGiacs607(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//end conversion of GIACS607
	
	//john 9.3.2015 : conversion of GIACS604
	Map<String, Object> showGiacs604Head(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs604RecList(HttpServletRequest request) throws SQLException, JSONException;
	void checkDataGiacs604(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs604ValidatePrintOr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs604ValidatePrintDv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs604ValidatePrintJv(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void cancelFileGiacs604(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> showGiacUploadDvPaytDtlGiacs604(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> showGiacUploadJvPaytDtlGiacs604(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void checkForClaim(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkForOverride(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void giacs604UploadPayments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkDcbNoGiacs604(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//end of conversion
	
	//john 9.22.2015 : conversion of GIACS608
	Map<String, Object> showGiacs608Legend(HttpServletRequest request) throws SQLException;
	Map<String, Object> giacs608Guf(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs608RecList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs608GiupTableTotal(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGIACS608GUCDetails(HttpServletRequest request) throws SQLException, JSONException;
	void saveGIACS608Gucd(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> showGiacUploadDvPaytDtlGiacs608(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> showGiacUploadJvPaytDtlGiacs608(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void checkDataGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkCollectionAmountGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkPaymentDetailsGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getParametersGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void proceedUploadGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	
	Map<String, Object> giacs608ValidatePrintOr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkDcbNoGiacs608(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkNetCollnGIACS608(HttpServletRequest request) throws SQLException, JSONException;
	
	//GIACS610
	Map<String, Object> showGiacs610Legend(HttpServletRequest request) throws SQLException;
	Map<String, Object> showGiacs610Guf(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject showGiacs610RecList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkDataGiacs610(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkValidatedGiacs610(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getDefaultBankGiacs610(HttpServletRequest request, String userId) throws SQLException;
	void checkDcbNoGiacs610(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void uploadPaymentsGiacs610(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//Deo [10.06.2016]: add start
	void validateUploadTranDate(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void cancelFileGiacs610(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> giacs610ValidatePrintOr(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void preUploadCheck(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getValidRecords(HttpServletRequest request) throws SQLException;
	JSONObject setTaggedRows(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiacs610JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//Deo [10.06.2016]: add ends
	
	//Deo: GIACS609 conversion start
	Map<String, Object> showGiacs609Head(HttpServletRequest request) throws SQLException, JSONException;
	String getGiacs609legend() throws SQLException;
	JSONObject showGiacs609RecList(HttpServletRequest request) throws SQLException, JSONException;
	Map<String, Object> getGiacs609Parameters(String userId) throws SQLException;
	JSONObject getGiacs609CollnDtls(HttpServletRequest request) throws SQLException, JSONException;
	void saveGiacs609CollnDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<Map<String, Object>> getGiacs609ORCollnDtls(HttpServletRequest request) throws SQLException;
	void validateCollnAmtGiacs609(HttpServletRequest request) throws SQLException, JSONException;
	JSONObject getGiacs609DVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs609DVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	JSONObject getGiacs609JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void saveGiacs609JVDtls(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void checkDataGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> validatePrintGiacs609(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> uploadBeginGiacs609(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> validateTranDateGiacs609(HttpServletRequest request, String userId) throws SQLException;
	Map<String, Object> checkUploadAllGiacs609(HttpServletRequest request, String userId) throws SQLException;
	void uploadPaymentsGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void cancelFileGiacs609(HttpServletRequest request, String userId) throws SQLException, JSONException;
	//Deo: GIACS609 conversion ends
}
