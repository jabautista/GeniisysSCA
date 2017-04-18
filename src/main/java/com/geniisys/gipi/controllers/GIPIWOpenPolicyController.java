/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.geniisys.gipi.service.GIPIWOpenPolicyService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIPIWOpenPolicyController.
 */
public class GIPIWOpenPolicyController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIQuotationController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWOpenPolicyService gipiWOpenPolicyService = (GIPIWOpenPolicyService) APPLICATION_CONTEXT.getBean("gipiWOpenPolicyService");
			GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
			//LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
			
			Integer parId = Integer.parseInt((request.getParameter("globalParId") == null) ? "0": request.getParameter("globalParId"));
			if ("showOpenPolicyDetails".equals(ACTION)) {
				log.info("Opening open policy details...");
				System.out.println("parId: "+parId);
				
				//obtaining open policy details
				GIPIWOpenPolicy openPolicy = gipiWOpenPolicyService.getWOpenPolicy(parId);
				request.setAttribute("openPolicy", openPolicy);
				Integer assdNo = Integer.parseInt(request.getParameter("globalAssdNo"));
				String lineCd = request.getParameter("lineCd");
				String inceptDate = request.getParameter("doi");
				String expiryDate = request.getParameter("doe");
				System.out.println("assdNo: "+assdNo);
				System.out.println("lineCd: "+lineCd);
				System.out.println("inceptDate: "+inceptDate);
				System.out.println("expiryDate: "+expiryDate);
				/*String[] param = {lineCd, assdNo, inceptDate, expiryDate};
				request.setAttribute("polbasicListing", lovHelper.getList(LOVHelper.POLBASIC_LISTING, param));
				List<LOV> bas = lovHelper.getList(LOVHelper.POLBASIC_LISTING, param);
				for (LOV lov : bas){
					System.out.println(lov.getCode());
					System.out.println(lov.getDesc());
				}*/
				request.setAttribute("polbasicListing", gipiPolbasicService.getPolbasicForOpenPolicy(lineCd, assdNo, inceptDate, expiryDate));
				PAGE = "/pages/underwriting/pop-ups/openPolicy.jsp";
			} else if ("saveOpenPolicy".equals(ACTION)) {
				log.info("Saving open policy...");
				String lineCd = request.getParameter("globalLineCd");
				String opSublineCd = request.getParameter("opSublineCd");
				String opIssCd = request.getParameter("opIssCd");
				Integer opIssueYy = Integer.parseInt(request.getParameter("opIssYear"));
				Integer opPolSeqno = Integer.parseInt(request.getParameter("opPolSeqNo"));
				Integer opRenewNo= Integer.parseInt(request.getParameter("opRenewNo"));
				String decltnNo = request.getParameter("declaration");
				//DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss");
				//Date effDate = df.parse(request.getParameter("globalEffDate"));
				String effDate = request.getParameter("globalEffDate");
				String openPolicyChanged = request.getParameter("openPolicyChanged");
				System.out.println(effDate);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("lineCd", lineCd);
				params.put("opSublineCd", opSublineCd);
				params.put("opIssCd", opIssCd);
				params.put("opIssueYy", opIssueYy);
				params.put("opPolSeqno", opPolSeqno);
				params.put("opRenewNo", opRenewNo);
				params.put("decltnNo", decltnNo);
				params.put("effDate", effDate);
				params.put("openPolicyChanged", openPolicyChanged);
				
				gipiWOpenPolicyService.saveOpenPolicyDetails(params);
				message = "SAVING SUCCESSFUL.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePolicyDate".equals(ACTION)){
				/*String lineCd = request.getParameter("globalLineCd");
				String opSublineCd = request.getParameter("opSublineCd");
				String opIssCd = request.getParameter("opIssCd");
				Integer opIssueYy = Integer.parseInt(request.getParameter("opIssYear"));
				Integer opPolSeqno = Integer.parseInt(request.getParameter("opPolSeqNo"));
				Integer opRenewNo = Integer.parseInt(request.getParameter("opRenewNo"));*/
				//String effDate = request.getParameter("globalEffDate");
				//String expiryDate = request.getParameter("globalExpiryDate");
				
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");  
				DateFormat df2 = new SimpleDateFormat("MM-dd-yyyy");
				
				Date doi = (request.getParameter("doi")).equals("") ? null : df2.parse(request.getParameter("doi"));
				Date doe = (request.getParameter("doe")).equals("") ? null : df2.parse(request.getParameter("doe"));
				
				Date effDate = (request.getParameter("globalEffDate")).equals("") ? doi : df.parse(request.getParameter("globalEffDate"));
				Date expiryDate = (request.getParameter("globalExpiryDate")).equals("") ? doe : df.parse(request.getParameter("globalExpiryDate"));
				
				System.out.println("effDate: "+effDate);
				System.out.println("expiryDate: "+expiryDate);
				
				Map<String, Object> params = this.getPolbasicParams(request);//new HashMap<String, Object>();
				/*params.put("lineCd", lineCd);
				params.put("opSublineCd", opSublineCd);
				params.put("opIssCd", opIssCd);
				params.put("opIssueYy", opIssueYy);
				params.put("opPolSeqno", opPolSeqno);
				params.put("opRenewNo", opRenewNo);*/
				params.put("effDate", effDate);
				params.put("expiryDate", expiryDate);
				
				params = gipiWOpenPolicyService.validatePolicyDate(params);
				
				String message1 = (String) params.get("message1");
				String message2 = (String) params.get("message2");
				String messageCode = (String) params.get("messageCode");
				message = message1 +","+ message2 +","+ messageCode;
				PAGE = "/pages/genericMessage.jsp";
			} else if("isPolExist".equals(ACTION)){
				String isExist = gipiPolbasicService.isPolExist(this.getPolbasicParams(request));
				log.info("Policy exist: "+isExist);
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";
			} else if("validatePolExist".equals(ACTION)) {
				Map<String, Object> params = this.getPolbasicParams(request);
				params.put("assdNo", request.getParameter("assdNo").equals("") ? 0 : Integer.parseInt(request.getParameter("assdNo")));
				System.out.println("validatePolExist(initial): "+params);
				params = gipiPolbasicService.getValidRefPolNo(params);
				log.info("valid ref pol no map : "+params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			} else if("getRefPolNo2".equals(ACTION)){
				String refPolNo = gipiPolbasicService.getRefPolNo2(this.getPolbasicParams(request));
				message = refPolNo;
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
	private Map<String, Object> getPolbasicParams(HttpServletRequest request){
		String lineCd = request.getParameter("globalLineCd");
		String opSublineCd = request.getParameter("opSublineCd");
		String opIssCd = request.getParameter("opIssCd");
		Integer opIssueYy = Integer.parseInt(request.getParameter("opIssYear"));
		Integer opPolSeqno = Integer.parseInt(request.getParameter("opPolSeqNo"));
		Integer opRenewNo = Integer.parseInt(request.getParameter("opRenewNo"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);
		params.put("opSublineCd", opSublineCd);
		params.put("opIssCd", opIssCd);
		params.put("opIssueYy", opIssueYy);
		params.put("opPolSeqno", opPolSeqno);
		params.put("opRenewNo", opRenewNo);
		return params;
	}
}
