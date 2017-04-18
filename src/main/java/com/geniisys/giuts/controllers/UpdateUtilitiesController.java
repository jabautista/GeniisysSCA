package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIItemService;
import com.geniisys.gipi.service.GIPIPolwcService;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.giuts.service.UpdateUtilitiesService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class UpdateUtilitiesController extends BaseController{
	
	private static final long serialVersionUID = -7051403522507621724L;

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIPolwcService gipiPolwcService = (GIPIPolwcService) APPLICATION_CONTEXT.getBean("gipiPolwcService");
		UpdateUtilitiesService updateUtilitiesService = (UpdateUtilitiesService) APPLICATION_CONTEXT.getBean("updateUtilitiesService");
		try {
			if("showUpdateAddWarrantiesAndClauses".equals(ACTION)){
				System.out.println("UpdateInformation - UpdateAddWarrAndClauses");
				PAGE = "/pages/underwriting/utilities/updateInformation/updateAddWarrantiesAndClauses/updateAddWarrantiesAndClauses.jsp";
			}else if("showUpdateInitialAcceptance".equals(ACTION)){
				System.out.println("UpdateUtilitiesController - showUpdateInitialAcceptance");
				PAGE = "/pages/underwriting/utilities/updateInformation/updateInitialAcceptance/updateInitialAcceptance.jsp";
			}else if("getGipis162BookingList".equals(ACTION)){
				String modId = "GIPIS162";
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("ACTION", ACTION);
				params.put("appUser", USER.getUserId());
				params.put("filter", request.getParameter("objFilter"));
				
				Map<String, Object> bookingList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(bookingList);
				
				System.out.println("Update Policy Booking Tag");
				
				if("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null){
					request.setAttribute("bookingGrid", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingTag/updatePolicyBookingTag.jsp";
					System.out.println(json.toString());
				}else{
					PAGE = "/pages/genericMessage.jsp";
					message = json.toString();					
				}
				
			}else if("getWarrClaTableGrid".equals(ACTION)){
				HashMap<String, Object> params = new HashMap<String, Object>();	
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId"));
				
				Map<String, Object> objWarrCla = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(objWarrCla);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGIPIPolWCTableGrid".equals(ACTION)){
				gipiPolwcService.saveGIPIPolWCTableGrid(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateWarrCla".equals(ACTION)){
				message = gipiPolwcService.validateWarrCla(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGenerateBookingMthPopup".equals(ACTION)){
				request.setAttribute("nextBookingYear", updateUtilitiesService.getNextBookingYear());
				PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingTag/pop-up/generateBookingMonths.jsp";
			}else if("checkBookingYear".equals(ACTION)){
				Integer count = updateUtilitiesService.checkBookingYear(Integer.parseInt(request.getParameter("bookingYear")));
				message = count.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateBookingMonths".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("bookingYear", Integer.parseInt(request.getParameter("bookingYear")));
				params.put("userId", USER.getUserId());
				
				message = updateUtilitiesService.generateBookingMonths(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateGiisBookingMonth".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", USER.getUserId());
				System.out.println("bookings: " + request.getParameter("bookings"));
				params.put("bookings", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("bookings"))));
				
				message = updateUtilitiesService.updateGiisBookingMonth(params);
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("chkBookingMthYear".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("bookingMth", request.getParameter("bookingMth"));
				params.put("bookingYear", Integer.parseInt(request.getParameter("bookingYear")));
				
				message = updateUtilitiesService.chkBookingMthYear(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getCurrentWcCdList".equals(ACTION) || "getWarrClaPrintSeqNoList".equals(ACTION)){ //Kris 05.22.2013
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("policyId", request.getParameter("policyId"));
				params.put("ACTION", ACTION);
				
				List<String> wcCdList = updateUtilitiesService.getCurrentWcCdList(params);
				request.setAttribute("object", (List<String>)StringFormatter.escapeHTMLInList(wcCdList));
				PAGE = "/pages/genericObject.jsp";
			} else if("showGIUTS029".equals(ACTION)){
				JSONObject json = updateUtilitiesService.giuts029NewFormInstance();
				request.setAttribute("jsonGIUTS029", json.toString());
				PAGE = "/pages/underwriting/utilities/updateInformation/updatePictureAttachment/updatePictureAttachment.jsp";
			} else if("getGIUTS029Items".equals(ACTION)){
				JSONObject json = updateUtilitiesService.getGIUTS029ItemList(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGIUTS029ItemAttachments".equals(ACTION)){
				JSONObject json = updateUtilitiesService.getGiuts029AttachmentList(request, USER.getUserId());
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					List<Map<String, Object>> attachments = (List<Map<String, Object>>) JSONUtil.prepareMapListFromJSON(new JSONArray(json.get("rows").toString()));
					List<String> files = new ArrayList<String>();
					for(Map<String, Object> attach : attachments){
						//files.add(attach.get("fileName").toString());
						files.add(StringFormatter.unescapeHTML2(attach.get("fileName").toString()));//added by steven 07.11.2014
					}
					FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGiuts029Attachments", json.toString());
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePictureAttachment/attachments.jsp";
				}
			} else if ("giuts029WriteFilesToServer".equals(ACTION)){
				List<Map<String, Object>> attachments = (List<Map<String, Object>>) JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("files")));
				List<String> files = new ArrayList<String>();
				for(Map<String, Object> attach : attachments){
					files.add(StringFormatter.unescapeHTML2(attach.get("fileName").toString()));//added by steven 07.11.2014
				}
				FileUtil.writeFilesToServer(getServletContext().getRealPath(""), files);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giuts029DeleteFilesFromServer".equals(ACTION)){
				List<Map<String, Object>> attachments = (List<Map<String, Object>>) JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("files")));
				List<String> files = new ArrayList<String>();
				for(Map<String, Object> attach : attachments){
					//files.add(attach.get("fileName").toString());
					files.add(StringFormatter.unescapeHTML2(attach.get("fileName").toString()));//added by steven 07.11.2014
				}
				FileUtil.deleteFilesFromServer(getServletContext().getRealPath(""), files);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("valAddGiuts029".equals(ACTION)){
				updateUtilitiesService.valAddGiuts029(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			} else if("giuts029SaveChanges".equals(ACTION)) {
				updateUtilitiesService.giuts029SaveChanges(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGIUTS012".equals(ACTION)){ // Added by J. Diago 08.14.2013
				PAGE = "/pages/underwriting/reInsurance/confirmBinder/updateBinderStatus.jsp";
			} else if("showUpdateInitialEtc".equals(ACTION)){ // Added by Gzelle 09.13.2013
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/utilities/updateInformation/updateInitialGeneralEndtInfo/updateInitialGeneralEndtInfo.jsp";
			} else if("getGeneralInitialInfo".equals(ACTION)){ 
				message = (new JSONObject(updateUtilitiesService.getGeneralInitialInfo(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getGeneralInitialPackInfo".equals(ACTION)){ 
				message = (new JSONObject(updateUtilitiesService.getGeneralInitialPackInfo(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getEndtInfo".equals(ACTION)){ 
				message = (new JSONObject(updateUtilitiesService.getEndtInfo(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGenInfo".equals(ACTION)){
				message = updateUtilitiesService.saveGenInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveInitialInfo".equals(ACTION)){
				message = updateUtilitiesService.saveInitialInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveGenPackInfo".equals(ACTION)){
				message = updateUtilitiesService.saveGenPackInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveInitialPackInfo".equals(ACTION)){
				message = updateUtilitiesService.saveInitialPackInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveEndtInfo".equals(ACTION)){
				message = updateUtilitiesService.saveEndtText(request, USER);
				PAGE = "/pages/genericMessage.jsp";			
			} else if("validatePackage".equals(ACTION)){
				message = updateUtilitiesService.validatePackage(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("showUpdateInitialEtcPack".equals(ACTION)){	// SR-21812 JET JUN-23-2016
				request.setAttribute("userId", USER.getUserId());
				PAGE = "/pages/underwriting/utilities/updateInformation/updateInitialGeneralEndtInfo/updateInitialGeneralEndtInfoPack.jsp";
			} else if("getPackGeneralInitialInfo".equals(ACTION)){ 
				message = (new JSONObject(updateUtilitiesService.getPackGeneralInitialInfo(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPackEndtInfo".equals(ACTION)){ 
				message = (new JSONObject(updateUtilitiesService.getPackEndtInfo(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("savePackGenInfo".equals(ACTION)){
				message = updateUtilitiesService.savePackGenInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("savePackInitInfo".equals(ACTION)){
				message = updateUtilitiesService.savePackInitInfo(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if("savePackEndtText".equals(ACTION)){
				message = updateUtilitiesService.savePackEndtText(request, USER);
				PAGE = "/pages/genericMessage.jsp"; 				// @#
			} else if("showUpdatePolicyCoverage".equals(ACTION)){
				JSONObject json = updateUtilitiesService.getGiuts027PolicyItemList(request, USER.getUserId()); //new JSONObject(); //
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("policyList", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyCoverage/updatePolicyCoverage.jsp";
				}
			} else if("saveItemCoverage".equals(ACTION)){
				GIPIItemService gipiItemService = (GIPIItemService) APPLICATION_CONTEXT.getBean("gipiItemService");
				message = gipiItemService.updatePolicyItemCoverage(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showUpdatePolicyBookingDateEtc".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGIPIS156Invoice");
				params.put("policyId", request.getParameter("policyId"));
				Map<String, Object> tbgInvoice = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = new JSONObject(tbgInvoice).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIPIS156Invoice", new JSONObject(tbgInvoice));
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/updatePolicyBookingDateEtc.jsp";
				}
			} else if("showUpdateBondPolicy".equals(ACTION)){
				PAGE = "/pages/underwriting/utilities/updateInformation/updateBondPolicy/updateBondPolicy.jsp";
			} else if ("saveGipis047BondUpdate".equals(ACTION)) {
				updateUtilitiesService.saveGipis047BondUpdate(request,USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIPIS156History".equals(ACTION)){
				JSONObject json = updateUtilitiesService.getGIPIS156History(request);
				/*request.setAttribute("jsonGIPIS156History", json);
				PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/history.jsp";*/
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIPIS156History", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/history.jsp";
				}
				
				
			} else if("showBancassuranceDetails".equals(ACTION)) {
				PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/bancassuranceDetails.jsp";
			} else if("showBancassuranceHistory".equals(ACTION)) {
				JSONObject json = updateUtilitiesService.getGIPIS156BancaHistory(request);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIPIS156BancaHistory", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/bancassuranceHistory.jsp";
				}
				
				
			} else if ("updateGIPIS156".equals(ACTION)) {
				updateUtilitiesService.updateGIPIS156(request, USER);
			} else if ("validateGIPIS156AreaCd".equals(ACTION)){
				request.setAttribute("object", updateUtilitiesService.validateGIPIS156AreaCd(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIPIS156BancBranchCd".equals(ACTION)) {
				request.setAttribute("object", updateUtilitiesService.validateGIPIS156BancBranchCd(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("showBankPaymentDetails".equals(ACTION)) {
				PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyBookingDateEtc/bankPaymentDetails.jsp";
			}else if("showUpdateMVFileNo".equals(ACTION)){		
				JSONObject json = updateUtilitiesService.showUpdateMVFileNo(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/utilities/updateInformation/updateMVFileNumber/updateMVFileNumber.jsp";	
				}
			}else if ("saveGipis032MVFileNoUpdate".equals(ACTION)) {
				updateUtilitiesService.saveGipis032MVFileNoUpdate(request, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
				//GIPIS155
			}else if("getGipis155FireItemListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId") == null ? null : request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo") == null ? null : request.getParameter("itemNo"));
				params.put("nbDistrictNo", request.getParameter("nbDistrictNo") == null ? null : request.getParameter("nbDistrictNo"));
				params.put("nbBlockNo", request.getParameter("nbBlockNo") == null ? null : request.getParameter("nbBlockNo"));
				params.put("provinceCd", request.getParameter("provinceCd") == null ? null : request.getParameter("provinceCd"));
				params.put("provinceDesc", request.getParameter("provinceDesc") == null ? null : request.getParameter("provinceDesc"));
				params.put("cityCd", request.getParameter("cityCd") == null ? null : request.getParameter("cityCd"));
				params.put("city", request.getParameter("city") == null ? null : request.getParameter("city"));
				params.put("eqZoneDesc", request.getParameter("eqZoneDesc") == null ? null : request.getParameter("eqZoneDesc"));
				params.put("floodZoneDesc", request.getParameter("floodZoneDesc") == null ? null : request.getParameter("floodZoneDesc"));
				params.put("typhoonZoneDesc", request.getParameter("typhoonZoneDesc") == null ? null : request.getParameter("typhoonZoneDesc"));
				params.put("tariffZoneDesc", request.getParameter("tariffZoneDesc") == null ? null : request.getParameter("tariffZoneDesc"));
				params.put("appUser", USER.getUserId());
				params.put("filter", request.getParameter("objFilter"));
				
				Map<String, Object> fireitemList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(fireitemList);
				
				System.out.println("Update Policy District/Block/EQ/FLD/TPN/TRF ");
				
				if("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null){
					PAGE = "/pages/genericMessage.jsp";
					message = json.toString();						
				}else{
					request.setAttribute("fireitemGrid", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyDistrictEtc/updatePolicyDistrictEtc.jsp";
					System.out.println(json.toString());			
				}				
			}else if("getBlockIdGipis155".equals(ACTION)){
				request.setAttribute("object", (List<String>)StringFormatter.escapeHTMLInList(updateUtilitiesService.getGipis155BlockId(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("saveFireItems".equals(ACTION)){
				message = updateUtilitiesService.saveFireItems(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGipis155TarfHistListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("policyId", request.getParameter("policyId") == null ? null : request.getParameter("policyId"));
				params.put("itemNo", request.getParameter("itemNo") == null ? null : request.getParameter("itemNo"));
				params.put("blockId", request.getParameter("blockId") == null ? null : request.getParameter("blockId"));
				params.put("filter", request.getParameter("objFilter"));
				
				Map<String, Object> tarfHistList = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(tarfHistList);
				
				System.out.println("Getting Tarf Hist :" + params.toString());
				
				if("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null){
					PAGE = "/pages/genericMessage.jsp";
					message = json.toString();						
				}else{
					request.setAttribute("tarfHistGrid", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updatePolicyDistrictEtc/popups/tarfHistory.jsp";
					System.out.println(json.toString());			
				}	
				
				//GIUTS025
			}else if("showGIUTS025".equals(ACTION)){
				JSONObject json = updateUtilitiesService.getInvoiceListGiuts025(request);
				//added by robert SR 5165 11.05.15
				GIISParameterService giisParameterService = (GIISParameterService) APPLICATION_CONTEXT.getBean("giisParameterService");
				String issCd = giisParameterService.getParamValueV2("ISS_CD_RI");
				request.setAttribute("issCdRi", issCd);
				//end robert SR 5165 11.05.15
				if("1".equals(request.getParameter("refresh")) && request.getParameter("refresh") != null){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("invoiceTableGrid", json);
					PAGE = "/pages/underwriting/utilities/updateInformation/updateManualInformation/updateManualInformation.jsp";
				}				
			}else if("saveGiuts025".equals(ACTION)){
				updateUtilitiesService.saveGiuts025(request, USER); //added user by robert SR 5165 11.05.15
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";;
			}
			
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			System.out.println(message);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
	}

}

