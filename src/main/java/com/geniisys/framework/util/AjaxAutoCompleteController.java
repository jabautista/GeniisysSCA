package com.geniisys.framework.util;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ajaxtags.helpers.AjaxXmlBuilder;
import org.ajaxtags.servlets.BaseAjaxServlet;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.service.GIISIntermediaryService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * Controller for handling auto-complete searches
 * @author eman
 *
 */
public class AjaxAutoCompleteController extends BaseAjaxServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The log	 */
	private static Logger log = Logger.getLogger(AjaxAutoCompleteController.class);

	/*
	 * (non-Javadoc)
	 * @see org.ajaxtags.servlets.BaseAjaxServlet#getXmlContent(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
	 */
	@Override
	public String getXmlContent(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		String ACTION = request.getParameter("action");
		AjaxXmlBuilder xmlBuilder = new AjaxXmlBuilder();
		
		if (ACTION == null) {
			ACTION = "";
		}
		
		if ("getGIPICommInvoiceDropdownIntmList".equals(ACTION)) {
			GIISIntermediaryService intermediaryService = (GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
			
			if (request.getParameter("changedTag") != null) {
				if (!"N".equals(request.getParameter("recordSelected"))) {
					return "";
				}
			}
			
			String tranType = request.getParameter("tranType");
			String issCd = request.getParameter("issCd");
			String premSeqNo = request.getParameter("premSeqNo");
			String intmName = request.getParameter("intmName");
			List<GIISIntermediary> intmList = intermediaryService.getGIPICommInvoiceIntmList(tranType, issCd, premSeqNo, intmName);
			
			log.info("Tran Type: " + tranType);
			log.info("Iss Cd: " + issCd);
			log.info("Prem Seq No: " + premSeqNo);
			log.info("Intm Name: " + request.getParameter("intmName"));
			log.info("Size of List: " + ((intmList == null) ? "0" : intmList.size()));
			
			//xmlBuilder.addItems(test, "1", "1");
			for (GIISIntermediary intm : intmList) {
				if (intm.getIntmNo() != null) {
					xmlBuilder.addItem(intm.getIntmName(), intm.getIntmNo().toString());
				}
			}
		}
		
		return xmlBuilder.toString();
	}

}
