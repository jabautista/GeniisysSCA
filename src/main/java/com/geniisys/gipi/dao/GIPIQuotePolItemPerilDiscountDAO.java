package com.geniisys.gipi.dao;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIQuotePolicyBasicDiscount;

public interface GIPIQuotePolItemPerilDiscountDAO {
	
	public void setPolItemPerilDiscount(int quoteId) throws SQLException;
	boolean saveGipiPolItemPerilDetails(int quoteId, BigDecimal gipiQuotePremAmt, Map<String, Object> params) throws Exception;
	boolean deletePolicyDiscount(String[] sequenceList, List<GIPIQuotePolicyBasicDiscount> oldBasicParams) throws SQLException;
}
