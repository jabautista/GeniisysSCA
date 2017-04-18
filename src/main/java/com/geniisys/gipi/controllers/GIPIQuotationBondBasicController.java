package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteBondBasic;
import com.geniisys.gipi.service.GIPIQuoteBondBasicService;
import com.geniisys.gipi.service.GIPIQuoteCosignService;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIQuotationBondBasicController extends BaseController{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIQuotationBondBasicController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			/* Definition services needed */
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", gipiQuote);
				request.setAttribute("gipiQuoteJSON", new JSONObject((GIPIQuote) StringFormatter.escapeHTMLInObject(gipiQuote)));
			}

			if ("showQuoteBondPolicyData".equals(ACTION)){
				log.info("Getting Bond Policy Data, quote id:"+quoteId);
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				GIPIQuoteBondBasicService bondService = (GIPIQuoteBondBasicService) APPLICATION_CONTEXT.getBean("gipiQuoteBondBasicService");
				
				//obtaining bond details
				GIPIQuoteBondBasic bond = bondService.getGIPIQuoteBondBasic(quoteId);
				request.setAttribute("bond", bond);
				
				//obtaining obligee listing
				request.setAttribute("obligeeListing", lovHelper.getList(LOVHelper.OBLIGEE_LISTING));
				
				//obtaining principal signor
				String assdNo = gipiQuote.getAssdNo()==null?"0":gipiQuote.getAssdNo().toString();
				String[] args = {assdNo};
				request.setAttribute("prinSigListing", lovHelper.getList(LOVHelper.PRINCIPAL_SIGNATORY_LISTING, args));
				
				//obtaining notary public listing
				request.setAttribute("notaryPublicListing", lovHelper.getList(LOVHelper.NOTARY_PUBLIC_LISTING));
				
				//obtaining bond clause listing
				String sublineCd = gipiQuote.getSublineCd();
				String[] param = {sublineCd};
				request.setAttribute("bondClauseListing", lovHelper.getList(LOVHelper.BOND_CLAUSE_LISTING, param));
				
				PAGE = "/pages/marketing/quotation/quotationBondPolicyData.jsp";
			}else if("saveBondPolicyData".equals(ACTION)){
				log.info("Saving Bond Policy Data, quote id:"+quoteId);
				GIPIQuoteBondBasicService bondService = (GIPIQuoteBondBasicService) APPLICATION_CONTEXT.getBean("gipiQuoteBondBasicService");
				GIPIQuoteCosignService cosignService = (GIPIQuoteCosignService) APPLICATION_CONTEXT.getBean("gipiQuoteCosignService");
				
				GIPIQuoteBondBasic bondPolicy = new GIPIQuoteBondBasic();
				bondPolicy = bondService.prepareBondPolicyData(request, USER);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("bondPolicy", bondPolicy);
				params.put("setRows", cosignService.prepareGIPIQuoteCosignJSON(new JSONArray(request.getParameter("setRows")), USER.getUserId()));
				params.put("delRows", cosignService.prepareGIPIQuoteCosignJSON(new JSONArray(request.getParameter("delRows")), USER.getUserId()));
				
				message = bondService.saveBondPolicyData(params);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
