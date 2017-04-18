package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIQuotePolItemPerilDiscountDAO;
import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;
import com.geniisys.gipi.service.GIPIQuotePolItemPerilDiscountService;

public class GIPIQuotePolItemPerilDiscountServiceImpl implements GIPIQuotePolItemPerilDiscountService{
	
	private GIPIQuotePolItemPerilDiscountDAO gipiQuotePolItemPerilDiscountDAO;
	
	@Override
	public void computePolicyItemPerilPremium(int quoteId) throws SQLException {
		// TODO Auto-generated method stub
		getGipiQuotePolItemPerilDiscountDAO().setPolItemPerilDiscount(quoteId);
	}

	public void setGipiQuotePolItemPerilDiscountDAO(
			GIPIQuotePolItemPerilDiscountDAO gipiQuotePolItemPerilDiscountDAO) {
		this.gipiQuotePolItemPerilDiscountDAO = gipiQuotePolItemPerilDiscountDAO;
	}

	public GIPIQuotePolItemPerilDiscountDAO getGipiQuotePolItemPerilDiscountDAO() {
		return gipiQuotePolItemPerilDiscountDAO;
	}

	@Override
	public boolean saveGipiPolItemPerilDetails(int quoteId, BigDecimal gipiQuotePremAmt, Map<String, Object> params) throws Exception {
		this.gipiQuotePolItemPerilDiscountDAO.saveGipiPolItemPerilDetails(quoteId, gipiQuotePremAmt, params);
		return false;
	}
	
	public boolean deletePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list, int sequenceNo) throws SQLException {
		//log.info("Deleting Basic Policy Discount...");
		boolean result = true;

		//log.info("Deleting Result:"+result);
		return result;
	}


}
