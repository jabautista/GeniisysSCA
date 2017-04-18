/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service.impl
	File Name: GIACDisbVouchersServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACDisbVouchersDAO;
import com.geniisys.giac.entity.GIACDisbVouchers;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;
import com.geniisys.giac.service.GIACDisbVouchersService;

public class GIACDisbVouchersServiceImpl implements GIACDisbVouchersService{
	
	private GIACDisbVouchersDAO giacDisbVouchersDAO;
	
	
	/**
	 * @return the giacDisbVouchersDAO
	 */
	public GIACDisbVouchersDAO getGiacDisbVouchersDAO() {
		return giacDisbVouchersDAO;
	}


	/**
	 * @param giacDisbVouchersDAO the giacDisbVouchersDAO to set
	 */
	public void setGiacDisbVouchersDAO(GIACDisbVouchersDAO giacDisbVouchersDAO) {
		this.giacDisbVouchersDAO = giacDisbVouchersDAO;
	}


	@Override
	public GIACDisbVouchers getGiacs016GiacDisb(Integer gprqRefId)
			throws SQLException {
		return getGiacDisbVouchersDAO().getGiacs016GiacDisb(gprqRefId);
	}


	@Override
	public GIACDisbVouchers getDisbVoucherInfo(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGiacDisbVouchersDAO().getDisbVoucherInfo(params);
	}


	@Override
	public GIACDisbVouchers getDefaultVoucher(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDisbVouchersDAO().getDefaultVoucher(params);
	}


	@Override
	public Map<String, Object> checkFundBranchFK(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDisbVouchersDAO().checkFundBranchFK(params);
	}


	@Override
	public String getPrintTagMean(String printTag) throws SQLException {
		return this.getGiacDisbVouchersDAO().getPrintTagMean(printTag);
	}


	@Override
	public Map<String, Object> validateAcctEntriesBeforeApproving(
			Map<String, Object> params) throws SQLException {
		return this.getGiacDisbVouchersDAO().validateAcctEntriesBeforeApproving(params);
	}


	@Override
	public Map<String, Object> approveValidatedDV(Map<String, Object> params) throws Exception {
		return this.getGiacDisbVouchersDAO().approveValidatedDV(params);
	}


	@Override
	public GIACPaytReqDocs getPaytReqNumberingScheme(Map<String, Object> params) throws SQLException {
		return this.getGiacDisbVouchersDAO().getPaytReqNumberingScheme(params);
	}


	@Override
	public Map<String, Object> saveVocuher(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacDisbVouchersDAO().saveVocuher(params);
	}


	@Override
	public void validateGIACS002DocCd(Map<String, Object> params) throws SQLException {
		this.getGiacDisbVouchersDAO().validateGIACS002DocCd(params);		
	}


	@Override
	public String checkIfOfppr(Integer gaccTranId) throws SQLException {
		return this.getGiacDisbVouchersDAO().checkIfOfppr(gaccTranId);
	}


	@Override
	public Map<String, Object> verifyOfpprTrans(Map<String, Object> params) throws SQLException {
		return this.getGiacDisbVouchersDAO().verifyOfpprTrans(params);
	}


	@Override
	public Map<String, Object> checkCollectionDtl(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacDisbVouchersDAO().checkCollectionDtl(params);
	}


	@Override
	public void preCancelDV(Map<String, Object> params) throws SQLException, Exception {
		this.getGiacDisbVouchersDAO().preCancelDV(params);		
	}


	@Override
	public Map<String, Object> cancelDV(Map<String, Object> params) throws SQLException, Exception {
		return this.getGiacDisbVouchersDAO().cancelDV(params);
	}


	@Override
	public String validateIfReleasedCheck(Map<String, Object> params) throws SQLException {
		return this.getGiacDisbVouchersDAO().validateIfReleasedCheck(params);
	}


	@Override
	public Integer getTranSeqNo(Integer gaccTranId) throws SQLException {
		return this.getGiacDisbVouchersDAO().getTranSeqNo(gaccTranId);
	}


	@Override
	public String validateAcctgEntriesBeforePrint(Integer gaccTranId) throws SQLException, Exception {
		return this.getGiacDisbVouchersDAO().validateAcctgEntriesBeforePrint(gaccTranId);
	}


	@Override
	public void deleteWorkflowRecords(Map<String, Object> params) throws SQLException {
		this.getGiacDisbVouchersDAO().deleteWorkflowRecords(params);		
	}


	@Override
	public String getDefaultBranchCd(String userId) throws SQLException {
		return this.getGiacDisbVouchersDAO().getDefaultBranchCd(userId);
	}


	@Override
	public List<GIACPaytRequests> getDocSeqNoList(Map<String, Object> params) throws SQLException {
		return this.getGiacDisbVouchersDAO().getDocSeqNoList(params);
	}

}
