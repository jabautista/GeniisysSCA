package com.geniisys.gipi.service;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;

public interface GIPIQuotePolItemPerilDiscountService {
	
	public void computePolicyItemPerilPremium(int quoteId) throws SQLException;
	boolean saveGipiPolItemPerilDetails(int quoteId, BigDecimal gipiQuotePremAmt, Map<String, Object> params) throws Exception; 
	public boolean deletePolicyDiscount(List<GIPIQuotePolicyBasicDiscount> list, int sequenceNo) throws SQLException;
}
