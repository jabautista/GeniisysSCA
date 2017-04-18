package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giuts.service.GIUTS008CopyPolicyService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIUTS008CopyPolicyController", urlPatterns="/GIUTS008CopyPolicyController")
public class GIUTS008CopyPolicyController extends BaseController {

	/**
	 * 
	 */
	private Logger log = Logger.getLogger(GIUTS008CopyPolicyController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIUTS008CopyPolicyService giuts008CopyPolicyService = (GIUTS008CopyPolicyService) APPLICATION_CONTEXT.getBean("giuts008CopyPolicyService");
			if("validateCopyLineCd".equals(ACTION)){
				//String lineCd = request.getParameter("lineCd"); replaced by: Nica 05.04.2013
				//message = giuts008CopyPolicyService.validateLineCd(lineCd);
				message = giuts008CopyPolicyService.validateGIUTS008LineCd(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateOpFlag".equals(ACTION)){
				String lineCd = request.getParameter("lineCd");
				String sublineCd = request.getParameter("sublineCd");
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",lineCd);
				params.put("sublineCd",sublineCd);
				message = giuts008CopyPolicyService.validateOpFlag(params);			
				PAGE = "/pages/genericMessage.jsp";			
			}else if("checkUserPerIssCd".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("issCd",request.getParameter("issCd"));
				params.put("moduleId",request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = giuts008CopyPolicyService.validateUserPassIssCd(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPolicyId".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd",request.getParameter("sublineCd"));
				params.put("issCd",request.getParameter("issCd"));
				params.put("issueYy",Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo",Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo",Integer.parseInt(request.getParameter("renewNo")));
				message = giuts008CopyPolicyService.getPolicyId(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("copyMainQuery".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();
				String oldPar = "";
				String newPar = "";
				Integer parSeqNo = null;
				params.put("nbtLineCd",request.getParameter("nbtLineCd"));
				params.put("nbtSublineCd",request.getParameter("nbtSublineCd"));
				params.put("policyId",Integer.parseInt(request.getParameter("policyId")));
				params.put("nbtEndtSeqNo",Integer.parseInt(request.getParameter("nbtEndtSeqNo")));
				params.put("lineCd",request.getParameter("lineCd"));
				params.put("sublineCd",request.getParameter("sublineCd"));
				params.put("issCd",request.getParameter("issCd"));
				params.put("issueYy",Integer.parseInt(request.getParameter("issueYy")));
				params.put("renewNo",Integer.parseInt(request.getParameter("renewNo")));
				params.put("nbtEndtIssCd",request.getParameter("nbtEndtIssCd"));
				params.put("nbtEndtYy",Integer.parseInt(request.getParameter("nbtEndtYy")));
				params.put("nbtEndtSeqNo",Integer.parseInt(request.getParameter("nbtEndtSeqNo")));
				params.put("nbtIssCd",request.getParameter("nbtIssCd"));
				params.put("nbtIssueYy",Integer.parseInt(request.getParameter("nbtIssueYy")));
				params.put("nbtPolSeqNo",Integer.parseInt(request.getParameter("nbtPolSeqNo")));
				params.put("nbtRenewNo",Integer.parseInt(request.getParameter("nbtRenewNo")));
				params.put("nbtEndtIssCd",request.getParameter("nbtEndtIssCd"));
				params.put("nbtEndtYy",Integer.parseInt(request.getParameter("nbtEndtYy")));
				params.put("userId",request.getParameter("userId"));
				params.put("newParNo", newPar);
				params.put("oldParNo", oldPar);
				HashMap<String, Object> result = new HashMap<String, Object>();
				//message = giuts008CopyPolicyService.copyPARPolicyMainQuery(params).toString();
				params = giuts008CopyPolicyService.copyPARPolicyMainQuery(params);
				message = QueryParamGenerator.generateQueryParams(params);
				request.setAttribute("result", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(result)));
				newPar = (String) params.get("newPar");
				oldPar = (String) params.get("oldPar");
				parSeqNo = (Integer) params.get("parSeqNo");
				//message = parSeqNo.toString();
				PAGE = "/pages/genericMessage.jsp";
				//PAGE = "/pages/underwriting/utilities/copyPolicyEndt/subPages/copyPolicyOverlay.jsp";
				//PAGE = "/pages/genericMessage.jsp";
			}else if("showCopyOverlay".equals(ACTION)){
				//HashMap<String, Object> parNumber = new HashMap<String, Object>();
				 //parNumber.put("oldPar",request.getParameter("oldPar"));
				//parNumber.put("newPar",request.getParameter("newPar"));
				//message = QueryParamGenerator.generateQueryParams(parNumber);
				//System.out.println(new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(parNumber)));
				request.setAttribute("oldPar",request.getParameter("oldPar"));
				request.setAttribute("newPar",request.getParameter("newPar"));
				PAGE = "/pages/underwriting/utilities/copyPolicyEndt/subPages/copyPolicyOverlay.jsp";
			}else if("copyPolicyEndtToPAR".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giuts008CopyPolicyService.copyPolicyEndtToPAR(request, USER))));
				PAGE = "/pages/genericObject.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
