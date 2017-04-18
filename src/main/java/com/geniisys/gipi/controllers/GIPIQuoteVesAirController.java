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
import java.util.List;
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
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteVesAir;
import com.geniisys.gipi.service.GIPIQuoteFacadeService;
import com.geniisys.gipi.service.GIPIQuoteVesAirService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWVesAirController.
 */
public class GIPIQuoteVesAirController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8593125639134510971L;
	private static Logger log = Logger.getLogger(GIPIQuoteVesAirController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIQuoteFacadeService serv = (GIPIQuoteFacadeService) APPLICATION_CONTEXT.getBean("gipiQuoteFacadeService"); // +env
			GIPIQuoteVesAirService gipiQuoteVesAir = (GIPIQuoteVesAirService) APPLICATION_CONTEXT.getBean("gipiQuoteVesAirService");
				
			int quoteId = Integer.parseInt((request.getParameter("quoteId") == null) ? "0" : request.getParameter("quoteId"));
			GIPIQuote gipiQuote = null;
			if (quoteId != 0)	{
				gipiQuote = serv.getQuotationDetailsByQuoteId(quoteId);
				gipiQuote.setQuoteId(quoteId);
				request.setAttribute("gipiQuote", StringFormatter.escapeHTMLInObject2(gipiQuote));//reymon 04222013
			}
						
			if("showQuoteVesAirPage".equals(ACTION)){
				List<GIPIQuoteVesAir> carriers = gipiQuoteVesAir.getQuoteVesAir(quoteId);
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> vessels = lovHelper.getList(LOVHelper.VESSEL_LISTING);
				System.out.println("vessels size: " + vessels.size());
				
				request.setAttribute("carriers", carriers);
				request.setAttribute("vessels", vessels);
			
				PAGE = "/pages/marketing/quotation/subPages/quotationCarrierInfo.jsp";
			}else if ("showQuoteVesAirPageTableGrid".equals(ACTION)){ //added by: steven 3.13.2012
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIPIQuoteVesAir2");
				params.put("quoteId", quoteId);
				
				Map<String, Object> gipiQuoteVesAirTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject objGipiQuoteVesAirTableGrid = new JSONObject(StringFormatter.replaceQuotesInMap(gipiQuoteVesAirTableGrid));//reymon 04222013
				
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("objGipiQuoteVesAirTableGrid", objGipiQuoteVesAirTableGrid);
					PAGE = "/pages/marketing/quotation/subPages/quotationCarrierInfoTableGrid.jsp";
				}else{
					message = objGipiQuoteVesAirTableGrid.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}
			} else if ("saveCarrierInfo".equals(ACTION)){				
				String[] delVesselCds = request.getParameterValues("delVesselCd");
				Map<String, Object> delParams = new HashMap<String, Object>();
				
				delParams.put("vesselCds", delVesselCds);
				delParams.put("quoteId", quoteId);
							
				String[] vesselCds = request.getParameterValues("insVesselCd");
				String[] recFlags  = request.getParameterValues("insRecFlag");
				
				Map<String, Object> insParams = new HashMap<String, Object>();
				
				insParams.put("vesselCds", vesselCds);
				insParams.put("recFlags", recFlags);
				insParams.put("quoteId", quoteId);
				
				
				Map<String, Object> allParameters = new HashMap<String, Object>();
				allParameters.put("delParams", delParams);
				allParameters.put("insParams", insParams);
				
				gipiQuoteVesAir.saveQuoteVesAir(allParameters);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveCarrierInfoTableGrid".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("param"));
				System.out.println(objParams.toString());
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("delParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delCarrierInfo")), USER.getUserId(), GIPIQuoteVesAir.class));
				params.put("insParams", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setCarrierInfo")), USER.getUserId(), GIPIQuoteVesAir.class));
				gipiQuoteVesAir.saveQuoteVesAir(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			
			}else if("checkIfQuoteVesAirRecExist".equals(ACTION)){
				log.info("Checking quote_ves_air records for quote_id: " + quoteId);
				Map isExistQuoteVesAir = new HashMap();
				isExistQuoteVesAir =  gipiQuoteVesAir.isGIPIQuoteVesAirExist(quoteId);
				String isExist = (String) isExistQuoteVesAir.get("exist");
				message = isExist;
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPackQuoteCarrierInfoPage".equals(ACTION)){
				Integer packQuoteId = request.getParameter("packQuoteId")== null ? 0 : Integer.parseInt(request.getParameter("packQuoteId"));
				log.info("Retrieving carrier information for pack_quote_id: " + packQuoteId);
				List<GIPIQuote> packQuoteList = serv.getPackQuoteListForCarrierInfo(packQuoteId);
				List<GIPIQuoteVesAir> packQuoteVesAir = gipiQuoteVesAir.getPackQuoteVesAir(packQuoteId);
				StringFormatter.escapeHTMLInList(packQuoteVesAir);
				request.setAttribute("objPackQuoteVesAir", new JSONArray(packQuoteVesAir));
				request.setAttribute("packQuoteList", packQuoteList);
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				List<LOV> vessels = lovHelper.getList(LOVHelper.VESSEL_LISTING);
				request.setAttribute("vessels", vessels);
				PAGE = "/pages/marketing/quotation-pack/quotationCarrierInformation-pack/packQuotationCarrierInfoMain.jsp";
			}else if("saveCarrierInfoForPackQuote".equals(ACTION)){
				JSONArray setRows = new JSONArray(request.getParameter("setRows"));
				JSONArray delRows = new JSONArray(request.getParameter("delRows"));
				List<GIPIQuoteVesAir> setVesAirList = (List<GIPIQuoteVesAir>) JSONUtil.prepareObjectListFromJSON(setRows, USER.getUserId(), GIPIQuoteVesAir.class);
				List<GIPIQuoteVesAir> delVesAirList = (List<GIPIQuoteVesAir>) JSONUtil.prepareObjectListFromJSON(delRows, USER.getUserId(), GIPIQuoteVesAir.class);
				gipiQuoteVesAir.saveCarrierInfoForPackQuotation(setVesAirList, delVesAirList);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
			
		} catch (SQLException e) {
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

}
