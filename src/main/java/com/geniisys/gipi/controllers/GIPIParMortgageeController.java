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
import java.util.ArrayList;
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
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.pack.entity.GIPIPackMortgagee;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIParMortgageeController.
 */
public class GIPIParMortgageeController extends BaseController{
	
	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParMortgageeController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			/* default attributes */
			log.info("Initializing: " + this.getClass().getSimpleName());			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env
			/* end of default attributes */
			
			int parId = Integer.parseInt(request.getParameter("parId")== null ? "0" : request.getParameter("parId"));
			
			if("getItemParMortgagee".equals(ACTION)){
				GIPIParMortgageeFacadeService mortgageeFacadeService = (GIPIParMortgageeFacadeService)APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				
				//GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				
				String issCd = request.getParameter("issCd");//par.getIssCd();
				
				String[] args = {String.valueOf(parId), issCd};
				List<LOV> mortgageeList = null;//helper.getList(LOVHelper.MORTGAGEE_LISTING, args);				
				
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				List<GIPIParMortgagee> mortgagees = null;
				
				if(itemNo > 0){
					mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING_POLICY, args);
					mortgagees = mortgageeFacadeService.getGIPIParMortgagee(parId);
				}else if(itemNo == 0){
					mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING_ITEM, args);					
					mortgagees = mortgageeFacadeService.getGIPIWMortgageeByItemNo(request);
				}
				
				//mortgagees = mortgageeFacadeService.getGIPIWMortgagee(parId);
				request.setAttribute("parId", parId);
				request.setAttribute("mortgagees", mortgagees);
				request.setAttribute("objMortgagees", new JSONArray(mortgagees));
				request.setAttribute("mortgageeListing", mortgageeList);
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/pop-ups/mortgageeInformation.jsp";
			} else if("getGIPIWMortgageeTableGrid".equals(ACTION)){
				GIPIParMortgageeFacadeService mortgService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("request", request);
				params.put("USER", USER);
				params.put("helper", (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"));
				
				mortgService.newFormInstance(params);
				
				PAGE = "/pages/underwriting/common/mortgagee/mortgageeTableGridListing.jsp";
			} else if("getItemParMortgageeForPack".equals(ACTION)){
				GIPIParMortgageeFacadeService mortgageeFacadeService = (GIPIParMortgageeFacadeService)APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				GIPIPackWPolBasService gipiPackWPolbasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService"); // +env
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				
				GIPIPackWPolBas par =  gipiPackWPolbasService.getGIPIPackWPolBas(parId);			
				
				String issCd = par.getIssCd();
				
				String[] args = {issCd};
				List<LOV> mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);				
				
				int itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				List<GIPIParMortgagee> mortgagees = null;
				
				if(itemNo > 0){					
					mortgagees = mortgageeFacadeService.getGIPIParMortgagee(parId);
				}else if(itemNo == 0){
					mortgagees = mortgageeFacadeService.getGIPIWMortgageeByItemNo(request);
				}
				
				request.setAttribute("parId", parId);
				request.setAttribute("mortgagees", mortgagees);
				request.setAttribute("objMortgagees", new JSONArray(mortgagees));
				request.setAttribute("mortgageeListing", mortgageeList);
				request.setAttribute("itemNo", itemNo);
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/pop-ups/mortgageeInformation.jsp";				
			} else if("saveGipiParItemMortgagee".equals(ACTION)){
				GIPIParMortgageeFacadeService mortgageeFacadeService = (GIPIParMortgageeFacadeService)APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				GIPIWPolbas par =  gipiWPolbasService.getGipiWPolbas(parId);			
				
				String issCd = par.getIssCd();
				
				String[] mortgCds	= request.getParameterValues("insMortgAmounts");
				String[] amounts	= request.getParameterValues("insMortgCds");
				String[] itemNos	= request.getParameterValues("insMortgItemNos");
				
				String[] delItemNos 	= request.getParameterValues("delMortgageeItemNos");
				String[] delMortgCds	= request.getParameterValues("delMortgCds");
				
				if(delItemNos != null){					
					Map<String, Object> delMortgagee = new HashMap<String, Object>();
					delMortgagee.put("parId", parId);
					delMortgagee.put("issCd", issCd);
					delMortgagee.put("delItemNos", delItemNos);
					delMortgagee.put("delMortgCds", delMortgCds);
					delMortgagee.put("userId", USER.getUserId());
					mortgageeFacadeService.deleteGIPIParMortgagee(delMortgagee);
				}
				
				if(itemNos != null){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("mortgCds", mortgCds);
					params.put("amounts", amounts);
					params.put("itemNos", itemNos);
					params.put("userId", USER.getUserId());
					params.put("parId", parId);
					params.put("issCd", issCd);				
					
					mortgageeFacadeService.saveGIPIParMortgagee(params);
				}				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPackParMortgagees".equals(ACTION)){
				GIPIParMortgageeFacadeService mortgageeFacadeService = (GIPIParMortgageeFacadeService)APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				GIPIPackWPolBasService gipiPackWPolbasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService"); // +env
				LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // + env
				Integer packParId = Integer.parseInt(request.getParameter("packParId")== null ? "0" : request.getParameter("packParId"));
				
				GIPIPackWPolBas packPar =  gipiPackWPolbasService.getGIPIPackWPolBas(packParId);			
				
				String issCd = packPar.getIssCd();
				String[] args = {issCd};
				
				List<LOV> mortgageeList = helper.getList(LOVHelper.MORTGAGEE_LISTING, args);
				
				List<GIPIPackMortgagee> packMortgagees = mortgageeFacadeService.getPackParMortgagees(packParId);
				List<GIPIParMortgagee> parMortgagees = getPARMortgageesList(packMortgagees);
				StringFormatter.replaceQuotesInList(parMortgagees);
				request.setAttribute("mortgageeListing", mortgageeList);
				request.setAttribute("objMortgagees", new JSONArray(parMortgagees));
				request.setAttribute("policies", packMortgagees);
				
				PAGE = "/pages/underwriting/packPar/subPages/packMortgagee.jsp";
			} else if("refreshMortgageeTable".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				
				params.put("ACTION", "getGIPIWMortgageeTableGrid");		
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				params.put("issCd", request.getParameter("issCd"));
				//params.put("pageSize", 5);
				
				params = TableGridUtil.getTableGrid(request, params);	//Gzelle 02032015 changed to getTableGrid
				
				message = (new JSONObject(params)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}
	
	private List<GIPIParMortgagee> getPARMortgageesList(List<GIPIPackMortgagee> list){
		List<GIPIParMortgagee> parMortgageesList = new ArrayList<GIPIParMortgagee>();
		
		for (GIPIPackMortgagee packMortgs : list){
			List<GIPIParMortgagee> gipiParMortgagees = new ArrayList<GIPIParMortgagee>();
			gipiParMortgagees = packMortgs.getGipiParMortgagees();
			for(GIPIParMortgagee parMortgs : gipiParMortgagees){
				parMortgs.setMortgCd(parMortgs.getMortgCd().replaceAll(" ", "_"));
				GIPIParMortgagee mortgs  = parMortgs;
				parMortgageesList.add(mortgs);
			}
		}
		return parMortgageesList;
	}
}
