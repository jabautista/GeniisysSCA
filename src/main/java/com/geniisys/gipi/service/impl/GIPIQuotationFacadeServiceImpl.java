/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Jun 13, 2011
 ***************************************************/
/**
 * 
 */
package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.service.GIPIQuotationFacadeService;

/**
 * @author rencela
 *
 */
public class GIPIQuotationFacadeServiceImpl implements
		GIPIQuotationFacadeService {
	private static Logger log = Logger.getLogger(GIPIQuotationFacadeServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotationFacadeService#getGIPIQuotationListing(java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIPIQuote> getGIPIQuotationListing(String userId, String lineCd) {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotationFacadeService#getQuotationDetailsByQuoteId(int)
	 */
	@Override
	public GIPIQuote getQuotationDetailsByQuoteId(int quoteId)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotationFacadeService#getQuoteIdByParams(com.geniisys.gipi.entity.GIPIQuote)
	 */
	@Override
	public GIPIQuote getQuoteIdByParams(GIPIQuote gipiQuote)
			throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotationFacadeService#saveGIPIQuoteDetails(com.geniisys.gipi.entity.GIPIQuote)
	 */
	@Override
	public void saveGIPIQuoteDetails(GIPIQuote gipiQuote) throws SQLException {
		// TODO Auto-generated method stub
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIQuotationFacadeService#prepareGIPIQuoteJSONObject(org.json.JSONObject, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public GIPIQuote prepareGIPIQuoteJSONObject(JSONObject jsonObject,
			GIISUser USER) throws JSONException {
		log.info("prepareGIPIQuoteJSONObject");
		GIPIQuote gipiQuote = new GIPIQuote();
		gipiQuote.setQuoteId(JSONUtil.getInteger(jsonObject, "quoteId"));
		gipiQuote.setLineCd(JSONUtil.getString(jsonObject, "lineCd"));
		gipiQuote.setSublineCd(JSONUtil.getString(jsonObject, "sublineCd"));
		gipiQuote.setIssCd(JSONUtil.getString(jsonObject, "issCd"));
		gipiQuote.setQuotationYy(JSONUtil.getInteger(jsonObject, "quotationYy"));
		
		gipiQuote.setPremAmt(JSONUtil.getBigDecimal(jsonObject, "premAmt"));
		gipiQuote.setTsiAmt(JSONUtil.getBigDecimal(jsonObject, "tsiAmt"));
		gipiQuote.setAnnPremAmt(JSONUtil.getBigDecimal(jsonObject, "annPremAmt"));
		gipiQuote.setAnnTsiAmt(JSONUtil.getBigDecimal(jsonObject, "annTsiAmt"));
		
		return gipiQuote;
	}
	
}