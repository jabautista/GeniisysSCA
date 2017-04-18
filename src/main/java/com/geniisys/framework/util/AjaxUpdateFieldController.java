/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Oct 15, 2010
 ***************************************************/
package com.geniisys.framework.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ajaxtags.helpers.AjaxXmlBuilder;
import org.ajaxtags.servlets.BaseAjaxServlet;
import org.apache.log4j.Logger;

import org.springframework.context.ApplicationContext;

import com.geniisys.giac.service.GIACDirectClaimPaymentService;
import com.geniisys.gicl.entity.GICLClaims;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class AjaxUpdateFieldController extends BaseAjaxServlet {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(AjaxUpdateFieldController.class);
	
	/*
	 * (non-Javadoc)
	 * @see org.ajaxtags.servlets.BaseAjaxServlet#getXmlContent(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public String getXmlContent(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		String ACTION = request.getParameter("action");
		AjaxXmlBuilder builder = new AjaxXmlBuilder();
		
		if (ACTION == null) {
			ACTION = "";
		}
		
		System.out.println("ACTION = " + ACTION);
		
		try{
		if("populateClaimDetails".equals(ACTION)){ // deprecate
			GIACDirectClaimPaymentService directClaimPaymentService = (GIACDirectClaimPaymentService) APPLICATION_CONTEXT.getBean("giacDirectClaimPaymentService");
			String claimId = request.getParameter("claimId");
			GICLClaims claims = directClaimPaymentService.getClaimDetails(Integer.parseInt(claimId));
			
			
			String claimNumber =	claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
									claims.getIssCd() + "-" + 
									StringFormatter.zeroPad(claims.getClaimYy(), 2) + "-" + 
									StringFormatter.zeroPad(claims.getClaimSequenceNo(), 7);
			builder.addItem("txtClaimNumber", claimNumber);
			System.out.println("txtClaimNumber = " + claimNumber);
			 
			String policyNumber = claims.getLineCode() + "-" + claims.getSublineCd() + "-" + 
							claims.getIssCd() + "-" + 
							StringFormatter.zeroPad(claims.getClaimYy(),2) + "-" + 
							StringFormatter.zeroPad(claims.getPolicySequenceNo(),7) + "-" + 
							StringFormatter.zeroPad(claims.getRenewNo(),2);
			builder.addItem("txtPolicyNumber", policyNumber);
			System.out.println("txtPolicyNumber = " + policyNumber);
			
			
			builder.addItem("txtAssuredName", claims.getAssuredName());
			System.out.println("txtAssuredName = " + claims.getAssuredName());
		}
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		return builder.toString();
	}

}
