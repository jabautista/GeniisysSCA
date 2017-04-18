package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIInstallment;

public interface GIUTSChangeInPaymentTermDAO {
	//GIUTSChangeInPaymentTerm getGIUTS022InvoiceInfo(Integer policyId) throws SQLException;
	public Map<String, Object> updatePaymentTerm(Map<String, Object> params) throws SQLException;
	String updateDueDate(Map<String, Object> allParams) throws SQLException;
	List<GIPIInstallment> getInstallmentChange(String issCd, Integer premSeqNo) throws SQLException;
	String validateFullyPaid (Map<String, Object> params)throws SQLException;
	Map<String, Object> validateInceptExpiry(Map<String, Object> params) throws SQLException;
	String updateDueDateInvoice(Map<String, Object> allParams) throws SQLException;
	String checkIfCanChange(Map<String, Object> params) throws SQLException;
	String updateWorkflowSwitch (Map<String, Object> allParams) throws SQLException;
	public Map<String, Object> updateAllocation(Map<String, Object> params) throws SQLException;
	public Map<String, Object> updateTaxAllocation(Map<String, Object> allParams) throws SQLException;
	Map<String, Object> getDueDate(Map<String, Object> params) throws SQLException; //carlo SR 5928 02-14-2017
}
