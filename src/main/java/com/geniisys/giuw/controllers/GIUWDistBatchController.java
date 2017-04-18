package com.geniisys.giuw.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.entity.GIACDirectClaimPayment;
import com.geniisys.giuw.entity.GIUWDistBatch;
import com.geniisys.giuw.entity.GIUWDistBatchDtl;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;
import com.geniisys.giuw.service.GIUWDistBatchService;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIUWDistBatchController extends BaseController{
	
	private Logger log = Logger.getLogger(GIUWDistBatchController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			GIUWDistBatchService giuwDistBatchServ = (GIUWDistBatchService) APPLICATION_CONTEXT.getBean("giuwDistBatchService");
			
			if("getGiuwDistBatch".equals(ACTION)){
				Integer batchId = request.getParameter("batchId")== "" ? null : Integer.parseInt(request.getParameter("batchId"));
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("batchId", batchId);
				params.put("lineCd", lineCd);
				GIUWDistBatch giuwDistBatch = giuwDistBatchServ.getGIUWDistBatch(params);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInObject(giuwDistBatch));
				request.setAttribute("giuwDistBatch", json);
				PAGE = "/pages/underwriting/distribution/batchDistribution/batchDistributionShare.jsp";
			}else if("saveBatchDistribution".equals(ACTION)){
				String parameters = request.getParameter("parameters");
				message = giuwDistBatchServ.saveBatchDistribution(parameters, USER);
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("saveBatchDistrShare".equals(ACTION)){
				String parameters = request.getParameter("parameters");
				giuwDistBatchServ.saveBatchDistributionShare(parameters, USER, Integer.parseInt(request.getParameter("batchId")));
				
				// for saving of dist share in dist tables : shan 08.08.2014	
				Integer batchId = request.getParameter("batchId")== "" ? null : Integer.parseInt(request.getParameter("batchId"));
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("batchId", batchId);
				p.put("lineCd", lineCd);
				GIUWDistBatch giuwDistBatch = giuwDistBatchServ.getGIUWDistBatch(p);
				JSONObject json = new JSONObject(StringFormatter.escapeHTMLInObject(giuwDistBatch));
				
				List<GIUWPolDistPolbasicV> policies = giuwDistBatchServ.getPoliciesByBatchId(request, USER.getUserId());
				Iterator<GIUWPolDistPolbasicV> iter = policies.iterator();
				GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
				System.out.println("=== policy count: " + policies.size());
				
				while(iter.hasNext()){
					GIUWPolDistPolbasicV pol = iter.next();
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", pol.getParId());
					params.put("policyId", pol.getPolicyId());
					params.put("distNo", pol.getDistNo());
					log.info("Retrieving dist shares of Policy No: " + pol.getPolicyNo() + " PAR_ID: " + pol.getParId() + " Policy_id: " + pol.getPolicyId());
					List<GIUWPolDist> polDist = distService.getGIUWPolDistGiuws013(params);
					
					// setting parameters for saving updated policy dist shares
					JSONObject updatedPolicy = giuwDistBatchServ.updatePolicyDistShare(polDist, json.toString());
					updatedPolicy.put("parId", pol.getParId());
					updatedPolicy.put("policyId", pol.getPolicyId());
					updatedPolicy.put("distNo", pol.getDistNo());
					updatedPolicy.put("userId", USER.getUserId());
					updatedPolicy.put("lineCd", pol.getLineCd());
					updatedPolicy.put("sublineCd", pol.getSublineCd());
					updatedPolicy.put("polFlag", pol.getPolFlag());
					updatedPolicy.put("parType", "");
					updatedPolicy.put("batchDistSw", "Y");
					updatedPolicy.put("batchId", pol.getBatchId());
					
					System.out.println(updatedPolicy.get("giuwWpolicydsDtlSetRows"));
					// saving records to distribution tables
					distService.saveOneRiskDistGiuws013(updatedPolicy.toString(), USER);
					System.out.println("Adjusting distribution records of : "+params.toString());
					distService.adjustAllWTablesGIUWS004(params);
				}				
				
				JSONObject res = new JSONObject();
				res.put("msg", "SUCCESS");
				res.put("batchFlag", json.get("batchFlag"));
				// end 08.08.2014
				
				message = res.toString();	// "SUCCESS"; changed by shan 08.11.2014
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkExistingBinder".equals(ACTION)){
				List<GIUWPolDistPolbasicV> policies = giuwDistBatchServ.getPoliciesByBatchId(request, USER.getUserId());
				Iterator<GIUWPolDistPolbasicV> iter = policies.iterator();
				GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
				System.out.println("=== policy count: " + policies.size());
				message = "SUCCESS";
				while(iter.hasNext()){
					GIUWPolDistPolbasicV pol = iter.next();
					System.out.println("Policy No: "+pol.getPolicyNo());
					String count = distService.checkBinderExist(pol.getPolicyId(), pol.getDistNo());
					
					if (count != null && count.equals("1")){
						message = pol.getPolicyNo();
						break;
					}
				}
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTreatyExpiry".equals(ACTION)){
				List<GIUWPolDistPolbasicV> policies = giuwDistBatchServ.getPoliciesByBatchId(request, USER.getUserId());
				Iterator<GIUWPolDistPolbasicV> iter = policies.iterator();
				GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
				System.out.println("+++ policy count: " + policies.size());
				
				while(iter.hasNext()){
					GIUWPolDistPolbasicV pol = iter.next();
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("batchId", pol.getBatchId());
					p.put("lineCd", pol.getLineCd());
					GIUWDistBatch giuwDistBatch = giuwDistBatchServ.getGIUWDistBatch(p);
					List<GIUWDistBatchDtl> giuwDistBatchDtl = giuwDistBatch.getGiuwDistBatchDtlList();
					System.out.println("**** dist batch share count: "+giuwDistBatchDtl.size());
					Iterator<GIUWDistBatchDtl> batchDtlIter = giuwDistBatchDtl.iterator();
					
					while (batchDtlIter.hasNext()){
						GIUWDistBatchDtl dtl = batchDtlIter.next();
						
						String lineCd = pol.getLineCd();
						Integer shareCd = dtl.getShareCd();
						Integer parId = pol.getParId();
						Map<String, Object> par = new HashMap<String, Object>();
						par.put("lineCd", lineCd);
						par.put("shareCd", shareCd);
						par.put("parId", parId);
						Map<String, Object> parOut = distService.getTreatyExpiry(par);
						parOut.put("policyNo", pol.getPolicyNo());
						message = new JSONObject(StringFormatter.replaceQuotesInMap(parOut)).toString();
						if (parOut.get("vExpired").equals("Y")){
							break;
						}						
					}					
				}
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("getPoliciesByParam".equals(ACTION)){
				message = giuwDistBatchServ.getPoliciesByParam(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp"; 
			}
		
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(JSONException e){
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
