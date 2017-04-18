package com.geniisys.giac.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACUploadingDAO {
	String checkFileName (Map<String, Object> params) throws SQLException;
	String getATMTag (String sourceCd) throws SQLException;
	String getGIACS601ORTag (String sourceCd) throws SQLException;
	List<String> uploadExcel(Map<String, Object> params, List<Map<String, Object>> recordList) throws SQLException, Exception;
	Map<String, Object> showGiacs603Head(Map<String, Object> params) throws SQLException;
	List<String> showGiacs603Legend() throws SQLException;
	Map<String, Object> showGiacUploadDvPaytDtl(Map<String, Object> params) throws SQLException;
	void setGiacs603DVPaytDtl(Map<String, Object> params) throws SQLException;
	void delGiacs603DVPaytDtl(Map<String, Object> params) throws SQLException;
	Map<String, Object> showGiacUploadJvPaytDtl(Map<String, Object> params) throws SQLException;
	void setGiacs603JVPaytDtl(Map<String, Object> params) throws SQLException;
	void delGiacs603JVPaytDtl(Map<String, Object> params) throws SQLException;
	void checkDataGiacs603(Map<String, Object> params) throws SQLException;
	void cancelFileGiacs603(Map<String, Object> params) throws SQLException;
	void validateUploadGiacs603(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDefaultBank(Map<String, Object> params) throws SQLException;
	Map<String, Object> processGiacs603(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs603CheckForOverride(Map<String, Object> params) throws SQLException;
	void giacs603UploadPayments(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkPaymentDetails(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePrintOr(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePrintDv(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePrintJv(Map<String, Object> params) throws SQLException;
	void checkDcbNoGiacs603(Map<String, Object> params) throws SQLException;
	
	//shan 06.09.2015 : conversion of GIACS607
	Map<String, Object> getGIACS607Parameters(Map<String, Object> params) throws SQLException;
	String getGIACS607Legend(String rvDomain) throws SQLException;
	Map<String, Object> getGIACS607GUFDetails (Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIACS607GUDVDetails (Map<String, Object> params) throws SQLException;
	void saveGIACS607Gudv(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGIACS607GUJVDetails (Map<String, Object> params) throws SQLException;
	void saveGIACS607Gujv(Map<String, Object> params) throws SQLException;
	void saveGIACS607Gucd(Map<String, Object> params) throws SQLException;
	void checkNetCollnGIACS607(Map<String, Object> params) throws SQLException;
	void updateGIACS607GrossTag(Map<String, Object> params) throws SQLException;
	void cancelFileGIACS607(Map<String, Object> params) throws SQLException;
	String checkOrPaytsGIACS607(String tranId) throws SQLException;
	void validateBeforeUploadGIACS607(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePolicyGIACS607(Map<String, Object> params) throws SQLException;
	String checkUserBranchAccessGIACS607(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkUploadGIACS607(Map<String, Object> params) throws SQLException;
	Integer getParentIntmNoGIACS607(String intmNo) throws SQLException;
	void uploadPaymentsGIACS607(Map<String, Object> params) throws SQLException;	
	Map<String, Object> validateOnPrintBtnGIACS607(Map<String, Object> params) throws SQLException;
	void checkDcbNoGiacs607(Map<String, Object> params) throws SQLException;
	//end conversion of GIACS607
	
	//john 09.03.2015 : conversion of GIACS604
	Map<String, Object> showGiacs604Head(Map<String, Object> params) throws SQLException;
	void checkDataGiacs604(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs604ValidatePrintOr(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs604ValidatePrintDv(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs604ValidatePrintJv(Map<String, Object> params) throws SQLException;
	void cancelFileGiacs604(Map<String, Object> params) throws SQLException;
	Map<String, Object> showGiacUploadDvPaytDtlGiacs604(Map<String, Object> params) throws SQLException;
	Map<String, Object> showGiacUploadJvPaytDtlGiacs604(Map<String, Object> params) throws SQLException;
	void checkForClaim(Map<String, Object> params) throws SQLException;
	void checkForOverride(Map<String, Object> params) throws SQLException;
	void giacs604UploadPayments(Map<String, Object> params) throws SQLException;
	void checkDcbNoGiacs604(Map<String, Object> params) throws SQLException;
	
	//john 09.22.2015 : conversion of GIACS608
	List<String> showGiacs608Legend() throws SQLException;
	Map<String, Object> giacs608Guf(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs608GiupTableTotal(Map<String, Object> params) throws SQLException;
	void saveGIACS608Gucd(Map<String, Object> params) throws SQLException;
	Map<String, Object> showGiacUploadDvPaytDtlGiacs608(Map<String, Object> params) throws SQLException;
	Map<String, Object> showGiacUploadJvPaytDtlGiacs608(Map<String, Object> params) throws SQLException;
	void checkDataGiacs608(Map<String, Object> params) throws SQLException;
	void checkCollectionAmountGiacs608(Map<String, Object> params) throws SQLException;
	void checkPaymentDetailsGiacs608(Map<String, Object> params) throws SQLException;
	Map<String, Object> getParametersGiacs608(Map<String, Object> params) throws SQLException;
	void proceedUploadGiacs608(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> giacs608ValidatePrintOr(Map<String, Object> params) throws SQLException;
	void checkDcbNoGiacs608(Map<String, Object> params) throws SQLException;
	void checkNetCollnGIACS608(Map<String, Object> params) throws SQLException;
	
	//GIACS610
	List<String> showGiacs610Legend() throws SQLException;
	Map<String, Object> showGiacs610Guf(Map<String, Object> params) throws SQLException;
	void checkDataGiacs610(Map<String, Object> params) throws SQLException;
	void checkValidatedGiacs610(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDefaultBankGiacs610(Map<String, Object> params) throws SQLException;
	void checkDcbNoGiacs610(Map<String, Object> params) throws SQLException;
	void uploadPaymentsGiacs610(Map<String, Object> params) throws SQLException;
	//Deo [10.06.2016]: add start
	void validateUploadTranDate(Map<String, Object> params) throws SQLException;
	void cancelFileGiacs610(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs610ValidatePrintOr(Map<String, Object> params) throws SQLException;
	void preUploadCheck(Map<String, Object> params) throws SQLException;
	List<String> getValidRecords(Map<String, Object> params) throws SQLException;
	void saveGiacs610JVDtls(Map<String, Object> params) throws SQLException;
	//Deo [10.06.2016]: add ends
	
	//Deo: GIACS609 conversion start
	Map<String, Object> showGiacs609Head(Map<String, Object> params) throws SQLException;
	String getGiacs609legend() throws SQLException;
	Map<String, Object> getGiacs609Parameters(Map<String, Object> params) throws SQLException;
	void saveGiacs609CollnDtls(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getGiacs609ORCollnDtls(Map<String, Object> params) throws SQLException;
	void validateCollnAmtGiacs609(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiacs609DVDtls (Map<String, Object> params) throws SQLException;
	void saveGiacs609DVDtls(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiacs609JVDtls (Map<String, Object> params) throws SQLException;
	void saveGiacs609JVDtls(Map<String, Object> params) throws SQLException;
	void checkDataGiacs609(Map<String, Object> params) throws SQLException;
	Map<String, Object> validatePrintGiacs609(Map<String, Object> params) throws SQLException;
	Map<String, Object> uploadBeginGiacs609(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateTranDateGiacs609(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkUploadAllGiacs609(Map<String, Object> params) throws SQLException;
	void uploadPaymentsGiacs609(Map<String, Object> params) throws SQLException;
	void cancelFileGiacs609(Map<String, Object> params) throws SQLException;
	//Deo: GIACS609 conversion ends
}
