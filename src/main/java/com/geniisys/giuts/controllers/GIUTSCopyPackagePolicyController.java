package com.geniisys.giuts.controllers;

import java.io.IOException;
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
import com.geniisys.common.service.GIISSublineFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.pack.service.GIPIPackPolbasicService;
import com.geniisys.gipi.pack.service.GIPIPackWPolGeninService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIUTSCopyPackagePolicyController", urlPatterns="/GIUTSCopyPackagePolicyController")
public class GIUTSCopyPackagePolicyController extends BaseController {

	/**
	 * 
	 */
	private Logger log = Logger.getLogger(GIUTSCopyPackagePolicyController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try{
			log.info("Initializing : "+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIPolbasicService gipiPolbasicService = (GIPIPolbasicService) APPLICATION_CONTEXT.getBean("gipiPolbasicService");
			GIPIPackPARListService gipiPackPARListService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
			GIPIPackPolbasicService gipiPackPolbasicService = (GIPIPackPolbasicService) APPLICATION_CONTEXT.getBean("gipiPackPolbasicService");
			GIPIPackWPolGeninService gipiPackWPolGeninService = (GIPIPackWPolGeninService) APPLICATION_CONTEXT.getBean("gipiPackWPolGeninService");
			
			if("showCopyPackagePolicy".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/copyUtilities/copyPackPolicy/copyPackPolicy.jsp";
			}else if("getOpFlagGiuts008a".equals(ACTION)){
				GIISSublineFacadeService giisSublineFacadeService = (GIISSublineFacadeService) APPLICATION_CONTEXT.getBean("giisSublineFacadeService");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				
				message = giisSublineFacadeService.getOpFlagGiuts008a(params).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkEndtGiuts008a".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("endtIssCd", request.getParameter("endtIssCd"));
				params.put("endtYy", request.getParameter("endtYy"));
				params.put("endtSeqNo", request.getParameter("endtSeqNo"));
				params = gipiPolbasicService.checkEndtGiuts008a(params);
				
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkPolicyGiuts008a".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params = gipiPolbasicService.checkPolicyGuits008a(params);
				
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generatePackParIdGiuts008a".equals(ACTION)){
				message = gipiPackPARListService.generatePackParIdGiuts008a().toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPackParListGiuts008a".equals(ACTION)){
				Integer packPolicyId = request.getParameter("packPolicyId") == "" ? 0 : Integer.parseInt(request.getParameter("packPolicyId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params = gipiPackPARListService.getPackParListGiuts008a(packPolicyId);
				
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("insertPackParListGiuts008a".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", request.getParameter("parId"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("parYy", request.getParameter("parYy"));
				params.put("parType", request.getParameter("parType"));
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("underwriter", USER.getUserId());
				params.put("address1", request.getParameter("address1"));
				params.put("address2", request.getParameter("address2"));
				params.put("address3", request.getParameter("address3"));
				
				System.out.println(params);
				
				gipiPackPARListService.insertPackParListGiuts008a(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("copyPackPolbasicGiuts008a".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("copyPolId", request.getParameter("copyPolId"));
				params.put("parIssCd", request.getParameter("parIssCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("userId", USER.getUserId());
				params = gipiPackPolbasicService.copyPackPolbasicGiuts008a(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("copyPackWPolGeninGiuts008a".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("copyPolId", request.getParameter("copyPolId"));
				params.put("userId", USER.getUserId());
				
				gipiPackWPolGeninService.copyPackWPolGeninGiuts008a(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
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
