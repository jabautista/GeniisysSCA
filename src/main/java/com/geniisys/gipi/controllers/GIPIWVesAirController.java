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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWVesAirService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWVesAirController.
 */
public class GIPIWVesAirController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8593125639134510971L;
	private static Logger log = Logger.getLogger(GIPIWVesAirController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("doProcessing...");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWVesAirService gipiWVesAir = (GIPIWVesAirService) APPLICATION_CONTEXT.getBean("gipiWVesAirService");
						
			int parId 	    = Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			int assdNo		= Integer.parseInt((request.getParameter("globalAssdNo") == null) ? "0" : request.getParameter("globalAssdNo"));
			String assdName	= (request.getParameter("globalAss12dName") == null ? "" : request.getParameter("globalAssdName"));
			String parNo	= (request.getParameter("globalParNo") == null ? "" : request.getParameter("globalParNo"));
			String parType  = (request.getParameter("globalParType") == null ? "" : request.getParameter("globalParType"));
			String policyNo = (request.getParameter("globalPolicyNo") == null ? "" : request.getParameter("globalPolicyNo"));
			
			if("showWVesAirPage".equals(ACTION)){
				log.info("Getting carrier info page...");
				System.out.println("parId: "+parId);
				Map<String, Object> params1 = new HashMap<String, Object>();
				Map<String, Object> paramsGiiss039 = new HashMap<String, Object>(); //Added by Jerome 08.31.2016 SR 5623
				Map<String, Object> paramsGiiss049 = new HashMap<String, Object>(); //Added by Jerome 08.31.2016 SR 5623
				Map<String, Object> paramsGiiss050 = new HashMap<String, Object>(); //Added by Jerome 08.31.2016 SR 5623
				String getGiiss039Access = ""; //Added by Jerome 08.31.2016 SR 5623
				String getGiiss049Access = ""; //Added by Jerome 08.31.2016 SR 5623
				String getGiiss050Access = ""; //Added by Jerome 08.31.2016 SR 5623
				
				paramsGiiss039.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 08.31.2016 SR 5623
				paramsGiiss039.put("issCd", request.getParameter("issCd"));
				paramsGiiss039.put("moduleId", "GIISS039");
				paramsGiiss039.put("userId", USER.getUserId());
				
				paramsGiiss049.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 08.31.2016 SR 5623
				paramsGiiss049.put("issCd", request.getParameter("issCd"));
				paramsGiiss049.put("moduleId", "GIISS049");
				paramsGiiss049.put("userId", USER.getUserId());
				
				paramsGiiss050.put("lineCd", request.getParameter("lineCd")); //Added by Jerome 08.31.2016 SR 5623
				paramsGiiss050.put("issCd", request.getParameter("issCd"));
				paramsGiiss050.put("moduleId", "GIISS050");
				paramsGiiss050.put("userId", USER.getUserId());
				
				params1.put("ACTION","getGIPIWVesAir2");
				params1.put("moduleId", request.getParameter("moduleId") == null ? "GIPIS007" : request.getParameter("moduleId"));
				params1.put("appUser", USER.getUserId());
				params1.put("parId", Integer.toString(parId));
				
				getGiiss039Access = gipiWVesAir.checkUserPerIssCdAcctg2(paramsGiiss039); //Added by Jerome 08.31.2016 SR 5623
				getGiiss049Access = gipiWVesAir.checkUserPerIssCdAcctg2(paramsGiiss049); //Added by Jerome 08.31.2016 SR 5623
				getGiiss050Access = gipiWVesAir.checkUserPerIssCdAcctg2(paramsGiiss050); //Added by Jerome 08.31.2016 SR 5623
				
				Map<String, Object> carInfoTableGrid = TableGridUtil.getTableGrid(request, params1);
				//JSONObject jsonCarInfoTableGrid = new JSONObject(carInfoTableGrid);
				JSONObject jsonCarInfoTableGrid = new JSONObject(StringFormatter.replaceQuotesInMap(carInfoTableGrid)); //added by jeffdojello 04.23.2013
				System.out.println(jsonCarInfoTableGrid.getJSONArray("rows").toString());
				request.setAttribute("jsonCarInfoTableGrid", jsonCarInfoTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					request.setAttribute("jsonCarInfoTableGrid", jsonCarInfoTableGrid);
					PAGE = "/pages/underwriting/carrierInformationTableGrid.jsp";
				}else{
					message = jsonCarInfoTableGrid.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
				/*List<GIPIWVesAir> carriers = gipiWVesAir.getWVesAir(parId);
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> vessels = lovHelper.getList(LOVHelper.VESSEL_LISTING);
				System.out.println("vessels size: " + vessels.size());
				
				request.setAttribute("carriers", carriers);
				request.setAttribute("vessels", vessels);*/
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("parType", parType); // added by: nica 10.27.2010
				request.setAttribute("isPack", request.getParameter("isPack")); // andrew - 03.28.2011
				request.setAttribute("giiss039Access", getGiiss039Access); //Added by Jerome 08.31.2016 SR 5623 
				request.setAttribute("giiss049Access", getGiiss049Access);
				request.setAttribute("giiss050Access", getGiiss050Access);
				
				// added by: nica 10.27.2010
				if(parType.equals("E")){
					request.setAttribute("policyNo", policyNo);
				}
				
			} else if ("saveCarrierInfo".equals(ACTION)){
				gipiWVesAir.saveGIPIWVesAir(request, USER.getUserId());
				System.out.println(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				/*String[] delVesselCds = request.getParameterValues("delVesselCd");
				Map<String, Object> delParams = new HashMap<String, Object>();
				
				delParams.put("vesselCds", delVesselCds);
				delParams.put("parId", parId);
							
				String[] vesselCds = request.getParameterValues("insVesselCd");
				String[] recFlags  = request.getParameterValues("insRecFlag");
				
				Map<String, Object> insParams = new HashMap<String, Object>();
				
				insParams.put("vesselCds", vesselCds);
				insParams.put("recFlags", recFlags);
				insParams.put("parId", parId);
				insParams.put("userId", USER.getUserId());
				
				
				Map<String, Object> allParameters = new HashMap<String, Object>();
				allParameters.put("delParams", delParams);
				allParameters.put("insParams", insParams);
				
				gipiWVesAir.saveWVesAir(allParameters);*/
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showPackCarrierInfoPage".equals(ACTION)){
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));				
				String packLineCd = request.getParameter("packLineCd");
				request.setAttribute("assdNo", assdNo);
				request.setAttribute("assdName", assdName);
				request.setAttribute("parNo", parNo);
				request.setAttribute("packLineCd", packLineCd);
				request.setAttribute("isPack", "Y");
				request.setAttribute("packParList", new JSONArray(gipiParListService.getPackItemParList(packParId, packLineCd)));
				PAGE = "/pages/underwriting/packPar/packCarrierInfo/packCarrierInformationMain.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
