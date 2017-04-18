package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLCasualtyDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GICLCasualtyDtlController", urlPatterns={"/GICLCasualtyDtlController"})
public class GICLCasualtyDtlController extends BaseController{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Logger log = Logger.getLogger(GICLCasualtyDtlController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			log.info("initializing :"+this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLCasualtyDtlService casualtyService = (GICLCasualtyDtlService) APPLICATION_CONTEXT.getBean("giclCasualtyDtlService");
			if("getCasualtyDtl".equals(ACTION)){
				/*log.info("Getting casualty item information...");
				casualtyService.getGiclCasualtyDtlGrid(request, USER);*/
				
				Integer claimId = Integer.parseInt(request.getParameter("claimId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclCasualtyDtlGrid");
				params.put("claimId", claimId);
				Map<String, Object> casualtyItemInfo = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(casualtyItemInfo); 
				
				request.setAttribute("casualtyItemInfo", json);
				
				GIISParameterFacadeService paramService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("ora2010Sw", paramService.getParamValueV2("ORA2010_SW"));
				request.setAttribute("vLocLoss", paramService.getParamValueV2("VALIDATE LOCATION OF LOSS"));
				PAGE = ("1".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/casualty/casualtyItemInfo.jsp" : "/pages/genericObject.jsp");
			}else if("validateClmItemNo".equals(ACTION)){
				log.info("Validating item no. ... ");
				message = casualtyService.validateClmItemNo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveClmItemCasualty".equals(ACTION)){
				message = casualtyService.saveClmItemCasualty(request, USER);
				PAGE= "/pages/genericMessage.jsp";
		    }else if("getPersonnel".equals(ACTION)){
		    	
		    	Integer claimId = Integer.parseInt(request.getParameter("claimId"));
		    	Integer itemNo = request.getParameter("itemNo") == null || "".equals(request.getParameter("itemNo")) ? null :Integer.parseInt(request.getParameter("itemNo")); 
		    	Map<String, Object> params = new HashMap<String, Object>();
		    	
		    	System.out.println("::::::::::::::::::::::::::::::::::::::"+claimId+":::::::::::::::::::::::::::::::::::");
		    	params.put("ACTION","getPersonnelList");
		    	params.put("claimId", claimId);
		    	params.put("itemNo", itemNo);
		    	Map<String, Object> personnelList = TableGridUtil.getTableGrid(request, params);
		    	
		    	System.out.println("::::::::::::::::::"+personnelList+"::::::::::::::::::::::::::::::");
		    	
		    	JSONObject json = new JSONObject(personnelList);
		    	
		    	request.setAttribute("personnelList", json);
		    	PAGE = ("0".equals(request.getParameter("ajax")) ? "/pages/claims/claimItemInfo/casualty/personnelTableGrid.jsp" : "/pages/genericObject.jsp");
		    }else if("validateGroupItemNo".equals(ACTION)){
		    	DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>(); 
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("inceptDate", request.getParameter("inceptDate") == null || "".equals(request.getParameter("inceptDate")) ? null :date.parse(request.getParameter("inceptDate")));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("groupItemNo", request.getParameter("groupItemNo"));
				casualtyService.validateGroupItemNo(params);
				StringFormatter.escapeHTMLInMap(params);
				
				message = QueryParamGenerator.generateQueryParams(params); 
				PAGE = "/pages/genericMessage.jsp";
		    }else if("validatePersonnelNo".equals(ACTION)){
		    	DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
				Map<String, Object> params = new HashMap<String, Object>(); 
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("polIssCd", request.getParameter("polIssCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("polEffDate", request.getParameter("polEffDate") == null || "".equals(request.getParameter("polEffDate")) ? null :date.parse(request.getParameter("polEffDate")));
				params.put("expiryDate", request.getParameter("expiryDate") == null || "".equals(request.getParameter("expiryDate")) ? null :date.parse(request.getParameter("expiryDate")));
				params.put("lossDate", request.getParameter("lossDate") == null || "".equals(request.getParameter("lossDate")) ? null :date.parse(request.getParameter("lossDate")));
				params.put("inceptDate", request.getParameter("inceptDate") == null || "".equals(request.getParameter("inceptDate")) ? null :date.parse(request.getParameter("inceptDate")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
				params.put("personnelNo", Integer.parseInt(request.getParameter("personnelNo")));
				casualtyService.validatePersonnelNo(params);
				StringFormatter.escapeHTMLInMap(params);
				
				message = QueryParamGenerator.generateQueryParams(params); 
				PAGE = "/pages/genericMessage.jsp";
		    }else if("showGICLS260CasualtyItemInfo".equals(ACTION)){
				Map<String, Object>params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclCasualtyDtlGridGicls260");
				params.put("pageSize", 5);
				params.put("userId", USER.getUserId());
				params.put("claimId", request.getParameter("claimId"));
				params = TableGridUtil.getTableGrid(request, params);
				String json = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("url", request.getParameter("url"));
					request.setAttribute("jsonClaimItem", json);
					PAGE = "/pages/claims/inquiry/claimInformation/itemInformation/casualty/casualtyItemMain.jsp";
				}else{
					message = json;
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		}
		catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}
		catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}
		finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
