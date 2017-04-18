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
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIWDeductible;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWDeductibleController.
 */
public class GIPIWDeductibleController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 545721130784332908L;
	private static Logger log = Logger.getLogger(GIPIWDeductibleController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */	
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		log.info("");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			 
			GIPIWDeductibleFacadeService gipiWDeductible = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService"); // +env
			
			int parId 			= Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId"));
			String lineCd 		= (request.getParameter("globalLineCd") == null) ? "" : request.getParameter("globalLineCd");
			String sublineCd 	= (request.getParameter("globalSublineCd") == null) ? "" : request.getParameter("globalSublineCd");
			int dedLevel = (request.getParameter("dedLevel") == null ? 0 : Integer.parseInt(request.getParameter("dedLevel")));					

			if("showDeductiblePage".equalsIgnoreCase(ACTION)){								
				List<GIPIWDeductible> wdeductibles = gipiWDeductible.getWDeductibles(parId, dedLevel);
				request.setAttribute("wdeductibles", wdeductibles);
				//StringFormatter.replaceQuotesInList(wdeductibles);
				request.setAttribute("objDeductibles", new JSONArray((List<GIPIWDeductible>)StringFormatter.escapeHTMLInList(wdeductibles)));
				
/*				if (1 < dedLevel) {
					String[] itemArgs = {Integer.toString(parId)}; 
					LOVHelper itemLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					List<LOV> itemsList = itemLovHelper.getList(LOVHelper.WITEM_LISTING, itemArgs);
					
					request.setAttribute("itemsList", itemsList);
					
					if (3 == dedLevel) {
						String[] perilArgs = {Integer.toString(parId), lineCd}; 
						LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
						List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);

						request.setAttribute("dedPerilsList", perilsList);
					}
				}
*/				if (3 > dedLevel) {
					String[] perilArgs = {Integer.toString(parId), lineCd}; 
					LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env					
					List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);
					request.setAttribute("dedPerilsList", perilsList);
				}

				String[] dedArgs = {lineCd, sublineCd}; 
				LOVHelper dedLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
				List<LOV> deductiblesList = dedLovHelper.getList(LOVHelper.POLICY_DEDUCTIBLE, dedArgs);				
				StringFormatter.replaceQuotesInList(deductiblesList);				
				//request.setAttribute("deductiblesList", deductiblesList);
				System.out.println("SIZE: " + deductiblesList.size());
				request.setAttribute("objDeductibleListing", new JSONArray(deductiblesList));
				request.setAttribute("dedLevel", dedLevel);
				
				PAGE = "/pages/underwriting/subPages/deductible.jsp";
			} else if("saveDeductibles".equalsIgnoreCase(ACTION)) {				
				Map<String, Object> params = new HashMap<String, Object>();
				
				String[] itemNos 		 = request.getParameterValues("dedItemNo"+dedLevel);
				String[] perilCds 		 = request.getParameterValues("dedPerilCd"+dedLevel);
				String[] deductibleCds 	 = request.getParameterValues("dedDeductibleCd"+dedLevel);
				String[] deductibleAmts  = request.getParameterValues("dedAmount"+dedLevel);
				String[] deductibleRts 	 = request.getParameterValues("dedRate"+dedLevel);
				String[] deductibleTexts = request.getParameterValues("dedText"+dedLevel);
				String[] aggregateSws 	 = request.getParameterValues("dedAggregateSw"+dedLevel);
				String[] ceilingSws 	 = request.getParameterValues("dedCeilingSw"+dedLevel);
				
				params.put("itemNos", itemNos);
				params.put("perilCds", perilCds);
				params.put("deductibleCds",deductibleCds);
				params.put("deductibleAmounts", deductibleAmts);
				params.put("deductibleRates", deductibleRts);
				params.put("deductibleTexts", deductibleTexts);
				params.put("aggregateSws", aggregateSws);
				params.put("ceilingSws", ceilingSws);
				params.put("parId", parId);
				params.put("dedLineCd", lineCd);
				params.put("dedSublineCd", sublineCd);
				params.put("userId", USER.getUserId());
				
				gipiWDeductible.saveGIPIWDeductible(params, dedLevel);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("checkDeductibles".equals(ACTION)){
				String deductibleType = request.getParameter("deductibleType");
				int	itemNo = Integer.parseInt(request.getParameter("itemNo"));
				
				message = gipiWDeductible.checkWDeductible(parId, deductibleType, dedLevel, itemNo);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deletePerilDeductibles".equals(ACTION)){
				//String nbtSublineCd	= (request.getParameter("nbtSublineCd") == null) ? "" : request.getParameter("nbtSublineCd");
				//System.out.println("DELETING DEDUCTIBLES PRIOR TO PERIL COPYING...");
				//System.out.println("nbtSubline: "+sublineCd);
				gipiWDeductible.deleteWPerilDeductibles(parId, lineCd, sublineCd);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deletePolicyDeductibles2".equals(ACTION)){
				gipiWDeductible.deleteWPerilDeductibles(parId, lineCd, sublineCd);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteGipiWdeductibles2".equals(ACTION)) {
				gipiWDeductible.deleteGipiWDeductibles2(parId, lineCd, sublineCd);
				message = 
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPolicyDeductibleTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer paramParId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", paramParId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgPolicyDeductibles = TableGridUtil.getTableGrid2(request, tgParams);
				tgParams.put("allRecords", gipiWDeductible.getAllGIPIWDeductibles(paramParId));
				request.setAttribute("tgPolicyDeductibles", new JSONObject(tgPolicyDeductibles));
				
				PAGE = "/pages/underwriting/common/deductibles/policy/policyDeductibleTableGridListing.jsp";
			} else if("getItemDeductibleTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer paramParId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", paramParId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgItemDeductibles = TableGridUtil.getTableGrid(request, tgParams);
				//tgItemDeductibles.put("allRecords", (List<GIPIWDeductible>) StringFormatter.escapeHTMLInList(gipiWDeductible.getWDeductibles(paramParId, dedLevel)));
				request.setAttribute("tgItemDeductibles", new JSONObject(tgItemDeductibles));
				
				PAGE = "/pages/underwriting/common/deductibles/item/itemDeductibleTableGridListing.jsp";
			} else if("getPerilDeductibleTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer paramParId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				Integer perilCd = Integer.parseInt(request.getParameter("perilCd") != null ? request.getParameter("perilCd") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", paramParId);
				tgParams.put("itemNo", itemNo);
				tgParams.put("perilCd", perilCd);
				//tgParams.put("pageSize", 5);
				
				Map<String, Object> tgPerilDeductibles = TableGridUtil.getTableGrid(request, tgParams);	
				//tgPerilDeductibles.put("allRecords", (List<GIPIWDeductible>) StringFormatter.escapeHTMLInList(gipiWDeductible.getWDeductibles(paramParId, dedLevel)));
				request.setAttribute("tgPerilDeductibles", new JSONObject(tgPerilDeductibles));
				
				PAGE = "/pages/underwriting/common/deductibles/peril/perilDeductibleTableGridListing.jsp";
			} else if("refreshPolicyDeductibleTable".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();				
				
				tgParams.put("ACTION", "getPolicyDeductibleTableGrid");		
				tgParams.put("parId", Integer.parseInt(request.getParameter("parId")));
				tgParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				//tgParams.put("pageSize", 5);
				
				tgParams = TableGridUtil.getTableGrid(request, tgParams);
				
				message = (new JSONObject(tgParams)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
			} else if("refreshItemDeductibleTable".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();				
				
				tgParams.put("ACTION", "getItemDeductibleTableGrid");		
				tgParams.put("parId", Integer.parseInt(request.getParameter("parId")));
				tgParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				//tgParams.put("pageSize", 5);
				
				tgParams = TableGridUtil.getTableGrid(request, tgParams);
				
				message = (new JSONObject(tgParams)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
				
				//request.setAttribute("object", new JSONObject(tgParams));
				//PAGE = "/pages/genericObject.jsp";
			} else if("refreshPerilDeductibleTable".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();				
				
				tgParams.put("ACTION", "getPerilDeductibleTableGrid");
				tgParams.put("parId", Integer.parseInt(request.getParameter("parId")));
				tgParams.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
				tgParams.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
				//tgParams.put("pageSize", 5);
				
				tgParams = TableGridUtil.getTableGrid(request, tgParams);
				
				message = (new JSONObject(tgParams)).toString();				
				//PAGE = "/pages/genericJSONParseMessage.jsp";
				PAGE = "/pages/genericMessage.jsp";
				
				//request.setAttribute("object", new JSONObject(tgParams));
				//PAGE = "/pages/genericObject.jsp";
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
