package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIWItmperlGroupedService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIPIWItmperlGroupedController", urlPatterns={"/GIPIWItmperlGroupedController"})
public class GIPIWItmperlGroupedController extends BaseController{
	
	private static final long serialVersionUID = 1L;
	public static String exceptionMessage = "";

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWItmperlGroupedService groupedService = (GIPIWItmperlGroupedService) appContext.getBean("gipiWItmperlGroupedService");
			if("getItmperlGroupedTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo") != null ? request.getParameter("groupedItemNo") : null);				
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				tgParams.put("groupedItemNo", groupedItemNo);				
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgItmperlGrouped = TableGridUtil.getTableGrid2(request, tgParams);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgItmperlGrouped)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("days",groupedService.checkDuration(request.getParameter("fromDate"), request.getParameter("toDate")));
					tgItmperlGrouped.put("gipiWItmperlGrouped", tgItmperlGrouped.get("rows"));
					request.setAttribute("accItmperlGrouped", new JSONObject(tgItmperlGrouped));					
					PAGE = "/pages/underwriting/parTableGrid/accident/subPages/groupedItems/subPages/accCoverageTableGridListing.jsp";
				}
			} else if ("getEndtCoveragePerilAmounts".equals(ACTION)){
				JSONObject json = groupedService.getEndtCoveragePerilAmounts(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteItmPerilGrouped".equals(ACTION)){
				groupedService.deleteWItmperlGrouped(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showEnrolleeCoverageOverlay".equals(ACTION)){
				Integer parId = Integer.parseInt(request.getParameter("parId"));
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
				Integer groupedItemNo = Integer.parseInt(request.getParameter("groupedItemNo"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("parId", parId);
				params.put("itemNo", itemNo);
				params.put("groupedItemNo", groupedItemNo);
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("issueYy", request.getParameter("issueYy"));
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				params.put("pageSize", 50);
				
				Map<String, Object> enrolleeCoverageTG = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(enrolleeCoverageTG);
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					HashMap<String, Object> covVars = groupedService.getCoverageVars(params);
					request.setAttribute("covVars", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(covVars)));
					request.setAttribute("packBenCd", request.getParameter("packBenCd"));
					request.setAttribute("enrolleeCoverageTGJson", json);
					PAGE = "/pages/underwriting/endt/jsonAccident/overlay/enrolleeCoverageOverlay.jsp";
				}
			}else if("deleteItmPerl".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = groupedService.deleteItmPerl(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("checkOpenAlliedPeril".equals(ACTION)){
				message = groupedService.checkOpenAlliedPeril(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveCoverage".equals(ACTION)){
				groupedService.saveCoverage(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("computeTsi".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = groupedService.computeTsi(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("validateAllied".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = groupedService.validateAllied(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("computePremium".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = groupedService.computePremium(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
				PAGE = "/pages/genericObject.jsp";
			}else if("autoComputePremRt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = groupedService.autoComputePremRt(request);
				StringFormatter.escapeHTMLInMap(params);
				request.setAttribute("object", new JSONObject(params));
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
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
