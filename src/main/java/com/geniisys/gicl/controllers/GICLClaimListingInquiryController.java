package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLossCtgryService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClaimListingInquiryService;
import com.geniisys.gicl.service.GICLClmRecoveryService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLClaimListingInquiryController", urlPatterns={"/GICLClaimListingInquiryController"})
public class GICLClaimListingInquiryController extends BaseController {

	private static final long serialVersionUID = -5149745550734999239L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			@SuppressWarnings("unused")
			GICLClmRecoveryService giclClmRecoveryService = (GICLClmRecoveryService) APPLICATION_CONTEXT.getBean("giclClmRecoveryService");
			GIISLossCtgryService lossCatService = (GIISLossCtgryService) APPLICATION_CONTEXT.getBean("giisLossCtgryService");
			GICLClaimListingInquiryService giclClaimListingInquiryService = (GICLClaimListingInquiryService) APPLICATION_CONTEXT.getBean("giclClaimListingInquiryService"); //02.07.2013 gzelle
			PAGE = "/pages/genericMessage.jsp";
			
			if("showClaimListingPerColor".equals(ACTION)){				
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giclClaimListingInquiryService.showClaimListingPerColor(request, USER);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerColor", new JSONObject());
					PAGE = "/pages/claims/inquiry/claimListing/perColor/perColor.jsp";					
				}
			}else if ("validateColorPerColor".equals(ACTION)) {
				message = giclClaimListingInquiryService.validateColorPerColor(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateBasicColorPerColor".equals(ACTION)) {
				message = giclClaimListingInquiryService.validateBasicColorPerColor(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showClaimListingPerBill".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giclClaimListingInquiryService.showClaimListingPerBill(request, USER);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonClmListPerBill", new JSONObject());
					PAGE = "/pages/claims/inquiry/claimListing/perBill/perBill.jsp";
				}
			}else if("validatePayees".equals(ACTION)){
				message = giclClaimListingInquiryService.validatePayees(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePayeeClass".equals(ACTION)){
				message = giclClaimListingInquiryService.validatePayeeClass(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateDocNumber".equals(ACTION)){
				message = giclClaimListingInquiryService.validateDocNumber(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showClaimListingPerPayee".equals(ACTION)){
				JSONObject jsonClmListPerPayee = giclClaimListingInquiryService.showClaimListingPerPayee(request,USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerPayee.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerPayee", jsonClmListPerPayee);
					PAGE = "/pages/claims/inquiry/claimListing/perPayee/perPayee.jsp";					
				}
			}else if ("showPerPayeeDtl".equals(ACTION)) {
				JSONObject jsonPerPayeeDtl = giclClaimListingInquiryService.showPerPayeeDtl(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPerPayeeDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPerPayeeDtl", jsonPerPayeeDtl);
					PAGE = "/pages/claims/inquiry/claimListing/perPayee/subPages/perPayeeDtl.jsp";					
				}
			}else if("showClmListingPerAdjuster".equals(ACTION)){
				JSONObject json = giclClaimListingInquiryService.showClmListingPerAdjuster(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/claimListing/perAdjuster/perAdjuster.jsp";					
				}
			}else if ("validatePayeePerAdjuster".equals(ACTION)) {
				message = giclClaimListingInquiryService.validatePayeePerAdjuster(request);
				PAGE = "/pages/genericMessage.jsp";				
			}  else if("validateGICLS251AssuredLov".equals(ACTION)) {
				PAGE = "/pages/genericMessage.jsp";
			} else if("showRecoveryDetails".equals(ACTION)){
				JSONObject jsonRecoveryDetails = giclClaimListingInquiryService.getRecoveryDetails(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRecoveryDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRecoveryDetails", jsonRecoveryDetails);
					PAGE = "/pages/claims/inquiry/claimListing/recoveryDetails/recoveryDetails.jsp";					
				}
			
			} else if("showGICLS258Details".equals(ACTION)){
				JSONObject jsonRecoveryDetails = giclClaimListingInquiryService.getGICLS258Details(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRecoveryDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRecoveryDetails", jsonRecoveryDetails);
					PAGE = "/pages/claims/inquiry/claimListing/recoveryDetails/recoveryDetails.jsp";					
				}
			
			} else if ("showProcessorHistory".equals(ACTION)) {
				JSONObject jsonProcessorHistory = giclClaimListingInquiryService.showClaimListingPerUser(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonProcessorHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonProcessorHistory", jsonProcessorHistory);
					PAGE = "/pages/claims/inquiry/claimListing/perUser/processorHistory.jsp";					
				}
			} else if ("showClaimStatusHistory".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClaimStatusHistory");
				params.put("claimId", request.getParameter("claimId"));
				
				Map<String, Object> claimStatusHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonClaimStatusHistory = new JSONObject(claimStatusHistoryTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClaimStatusHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClaimStatusHistory", jsonClaimStatusHistory);
					PAGE = "/pages/claims/inquiry/claimListing/perUser/claimStatusHistory.jsp";					
				}
			} else if ("showClaimListingPerMake".equals(ACTION)) {
				JSONObject jsonMakeDetails = giclClaimListingInquiryService.showClaimListingPerMake(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonMakeDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonMakeDetails", jsonMakeDetails);
					PAGE = "/pages/claims/inquiry/claimListing/perMake/perMake.jsp";					
				}
			} else if ("showClaimListingPerMotorcarReplacementParts".equals(ACTION)) {
				JSONObject jsonMCReplacementPartDetails = giclClaimListingInquiryService.showClaimListingPerMotorcarReplacementParts(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonMCReplacementPartDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonMCReplacementPartDetails", jsonMCReplacementPartDetails);
					PAGE = "/pages/claims/inquiry/claimListing/perMotorcarReplacementParts/perMotorcarReplacementParts.jsp";					
				}
			}else if("getLossDtlsField".equals(ACTION)){
				JSONObject jsonLossDtlsField = giclClaimListingInquiryService.getLossDtlsField(request);				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossDtlsField.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLossDtlsField", jsonLossDtlsField);
					request.setAttribute("claimId", request.getParameter("claimId"));
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));	
					request.setAttribute("lossExpCd", request.getParameter("lossExpCd"));	
					PAGE = "/pages/claims/inquiry/claimListing/perMotorcarReplacementParts/lossDetails.jsp";
				}
			} else if ("getPayorDetails".equals(ACTION)) {
				JSONObject jsonPayorDetails = giclClaimListingInquiryService.getPayorDetails(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPayorDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPayorDetails", jsonPayorDetails);
					PAGE = "/pages/claims/inquiry/claimListing/recoveryDetails/recoveryDetails.jsp";					
				}		
			} else if("showHistory".equals(ACTION)) {
				JSONObject jsonHistoryDetails = giclClaimListingInquiryService.getHistory(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonHistoryDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPayorDetails", jsonHistoryDetails);
					PAGE = "/pages/claims/inquiry/claimListing/recoveryDetails/recoveryDetails.jsp";					
				}
			} else if("showClaimListingPerUser".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmListPerUser");				
				params.put("lineCd", "MC");
				params.put("issCd", "HO");
				params.put("appUser", USER.getUserId());
				params.put("inHouAdj",request.getParameter("inHouAdj"));
				params.put("searchByOpt", request.getParameter("searchByOpt"));
				params.put("dateAsOf", request.getParameter("dateAsOf"));
				params.put("dateTo", request.getParameter("dateTo"));
				params.put("dateFrom", request.getParameter("dateFrom"));
				
				Map<String, Object> clmListPerUserTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonClmListPerUser = new JSONObject(clmListPerUserTableGrid);

				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerUser.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerUser", jsonClmListPerUser);
					PAGE = "/pages/claims/inquiry/claimListing/perUser/perUser.jsp";				
				}
			}else if("showClaimListingPerVessel".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getClmListPerVessel");
				params.put("vesselCd", request.getParameter("vesselCd"));
				params.put("searchBy", request.getParameter("searchByOpt"));
				params.put("dateAsOf", request.getParameter("dateAsOf"));
				params.put("dateTo", request.getParameter("dateTo"));
				params.put("dateFrom", request.getParameter("dateFrom"));
				params.put("userId", USER.getUserId());
				System.out.println("parameters: " + params);
				
				Map<String, Object> clmListPerVesselTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonClmListPerVessel = new JSONObject(clmListPerVesselTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerVessel.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerVessel", jsonClmListPerVessel);
					PAGE = "/pages/claims/inquiry/claimListing/perVessel/perVessel.jsp";				
				}
				
			}else if("showClaimListingPerCedingCompany".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("ACTION", "getClmListPerCeding");
				params.put("appUser", USER.getUserId());
				params.put("riCd", request.getParameter("riCd"));
				params.put("searchByOpt", request.getParameter("searchByOpt"));
				params.put("dateAsOf", request.getParameter("dateAsOf"));
				params.put("dateFrom", request.getParameter("dateFrom"));
				params.put("dateTo", request.getParameter("dateTo"));
				
				Map<String, Object> clmListPerCedingTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonClmListPerCeding = new JSONObject(clmListPerCedingTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerCeding.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerCeding", jsonClmListPerCeding);
					PAGE = "/pages/claims/inquiry/claimListing/perCedingCompany/perCedingCompany.jsp";					
				}
			}else if("showClaimListingPerIntermediary".equals(ACTION)){
				JSONObject jsonClmListPerIntermediary = giclClaimListingInquiryService.showClaimListingPerIntermediary(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerIntermediary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerIntermediary", jsonClmListPerIntermediary);
					PAGE = "/pages/claims/inquiry/claimListing/perIntermediary/perIntermediary.jsp";					
				}
			}else if("showClaimListingPerMotorshop".equals(ACTION)){
				JSONObject jsonClmListPerIntermediary = giclClaimListingInquiryService.showClaimListingPerMotorshop(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerIntermediary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerIntermediary", jsonClmListPerIntermediary);
					PAGE = "/pages/claims/inquiry/claimListing/perMotorshop/perMotorshop.jsp";					
				}
//				PAGE = "/pages/claims/inquiry/claimListing/perMotorshop/perMotorshop.jsp";
			} else if ("showClaimListingPerMotorcarReplacementParts".equals(ACTION)) {
				/*JSONObject jsonMCRepParts = giclClaimListingInquiryService.showClaimListingPerMotorcarReplacementParts(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonMCRepParts.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonMCRepParts", jsonMCRepParts);
					PAGE = "/pages/claims/inquiry/claimListing/perMotorcarReplacementParts/perMotorcarReplacementParts.jsp";					
				}	*/
				PAGE = "/pages/claims/inquiry/claimListing/perMotorcarReplacementParts/perMotorcarReplacementParts.jsp";
			}else if("showClaimDetails".equals(ACTION)){
				JSONObject jsonClaimDetailsPerIntermediary = giclClaimListingInquiryService.getClaimDetails(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClaimDetailsPerIntermediary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClaimDetailsPerIntermediary", jsonClaimDetailsPerIntermediary);
					PAGE = "/pages/claims/inquiry/claimListing/perIntermediary/claimDetails.jsp";					
				}
			} else if("showClaimListingPerPlateNo".equals(ACTION)){
				JSONObject jsonClmListPerPlateNo = giclClaimListingInquiryService.showClaimListingPerPlateNo(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerPlateNo.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerPlateNo", jsonClmListPerPlateNo);
					PAGE = "/pages/claims/inquiry/claimListing/perPlateNo/perPlateNo.jsp";					
				}
			} else if("showClaimListingPerRecoveryType".equals(ACTION)){
				JSONObject jsonClmListPerRecoveryType = giclClaimListingInquiryService.showClaimListingPerRecoveryType(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerRecoveryType.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerRecoveryType", jsonClmListPerRecoveryType);
					PAGE = "/pages/claims/inquiry/claimListing/perRecoveryType/perRecoveryType.jsp";					
				}
			} else if("showPerRecoveryTypeDetails".equals(ACTION)){
				PAGE = "/pages/claims/inquiry/claimListing/perRecoveryType/perRecoveryTypeDetails.jsp";					
			} else if("getClmListPerPolicy".equals(ACTION)){
				JSONObject jsonClmListPerPolicy = giclClaimListingInquiryService.showClaimListingPerPolicy(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerPolicy.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerPolicy", jsonClmListPerPolicy);
					PAGE = "/pages/claims/inquiry/claimListing/perPolicy/perPolicy.jsp";					
				}
			} else if("getClmListPerPackagePolicy".equals(ACTION)){
				JSONObject jsonClmListPerPackagePolicy = giclClaimListingInquiryService.showClaimListingPerPackagePolicy(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerPackagePolicy.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmListPerPackagePolicy", jsonClmListPerPackagePolicy);
					PAGE = "/pages/claims/inquiry/claimListing/perPackagePolicy/perPackagePolicy.jsp";					
				}
		  } else if("showClaimListingPerAssured".equals(ACTION)) {
			  JSONObject jsonClmListPerAssured = giclClaimListingInquiryService.showClaimListingPerAssured(request, USER);
			  if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerAssured.toString();
					PAGE = "/pages/genericMessage.jsp";
			  }else{
					request.setAttribute("jsonClmListPerAssured", jsonClmListPerAssured);
					PAGE = "/pages/claims/inquiry/claimListing/perAssured/perAssured.jsp";					
			  }
		  } else if("showPerAssuredFreeText".equals(ACTION)) {
			  JSONObject jsonClmListPerAssured = giclClaimListingInquiryService.showPerAssuredFreeText(request, USER);
			  if("1".equals(request.getParameter("refresh"))){
					message = jsonClmListPerAssured.toString();
					PAGE = "/pages/genericMessage.jsp";
			  }else{
					request.setAttribute("jsonClmListPerAssured", jsonClmListPerAssured);
					PAGE = "/pages/claims/inquiry/claimListing/perAssured/perAssured.jsp";					
			  }
		  }	else if("showClaimListingPerCargoType".equals(ACTION)){
				JSONObject json = giclClaimListingInquiryService.showClaimListingPerCargoType(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/claimListing/perCargoType/perCargoType.jsp";					
				}
		  } else if("showClaimListingPerLawyer".equals(ACTION)){
			  if("1".equals(request.getParameter("refresh"))){
				  	JSONObject json = giclClaimListingInquiryService.showClaimListingPerLawyer(request, USER);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
			  } else {
				  request.setAttribute("jsonClmListPerLawyer", new JSONObject());
				  PAGE = "/pages/claims/inquiry/claimListing/perLawyer/perLawyer.jsp";
			  }
		  } 
		  else if("validateCargoClassPerCargoClass".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateCargoClassPerCargoClass(request);
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("validateCargoTypePerCargoClass".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateCargoTypePerCargoClass(request);
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("fetchCorrespondingCargoTypeBasedOnClassCd".equals(ACTION)){
			  JSONObject cargoTypeDetails = giclClaimListingInquiryService.fetchCorrespondingCargoTypeBasedOnClassCd(request);
			  message = cargoTypeDetails.toString();
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("fetchValidCargo".equals(ACTION)){
			  JSONArray cargoTypeDetails = giclClaimListingInquiryService.fetchValidCargo(request);
			  message = cargoTypeDetails.toString();
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("validateMotorshop".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateMotorshop(request);
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("showClaimListingPerNatureOfLoss".equals(ACTION)){
			  JSONObject json = giclClaimListingInquiryService.showClaimListingPerNatureOfLoss(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/claimListing/perNatureOfLoss/perNatureOfLoss.jsp";				
				}
		  } else if("fetchCorrespondingNatureOfLossBasedOnLineCd".equals(ACTION)){
			  JSONObject json = lossCatService.fetchCorrespondingNatureOfLossBasedOnLineCd(request);
			  message = json.toString();
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("validateLineCdByLineName".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateLineCdByLineName(request);
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("validateLossCatDescPerLineCd".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateLossCatDescPerLineCd(request);
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("fetchValidLossCatDesc".equals(ACTION)){
			  JSONObject lossCatDets = giclClaimListingInquiryService.fetchValidLossCatDesc(request);
			  message = lossCatDets.toString();
			  PAGE = "/pages/genericMessage.jsp";
		  } else if("fetchValidLineCd".equals(ACTION)){
			  JSONArray lineCdList = giclClaimListingInquiryService.fetchValidLineCd(request);
			  message = lineCdList.toString();
			  PAGE = "/pages/genericMessage.jsp"; 
		  } else if("showClaimListingPerBlock".equals(ACTION)){				  
				JSONObject json = giclClaimListingInquiryService.showClaimListingPerBlock(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/claims/inquiry/claimListing/perBlock/perBlock.jsp";					
				}	
		  } else if ("validateDistrictPerBlock".equals(ACTION)) {
				message = giclClaimListingInquiryService.validateDistrictPerBlock(request);
				PAGE = "/pages/genericMessage.jsp";
		  } else if ("validateBlockPerBlock".equals(ACTION)) {
				message = giclClaimListingInquiryService.validateBlockPerBlock(request);
				PAGE = "/pages/genericMessage.jsp";
		  } else if("getBlockByDistrictNo".equals(ACTION)){
			  JSONObject blockDetails = giclClaimListingInquiryService.getBlockByDistrictNo(request);
			  message = blockDetails.toString();
			  PAGE = "/pages/genericMessage.jsp";
			  
		  } else if("showClaimListingPerThirdParty".equals(ACTION)){
			  JSONObject json = giclClaimListingInquiryService.showClaimListingPerThirdParty(request, USER);;
			  if("1".equals(request.getParameter("refresh"))){
				  message = json.toString();
				  PAGE = "/pages/genericMessage.jsp";
			  }else{
				  PAGE = "/pages/claims/inquiry/claimListing/perThirdParty/perThirdParty.jsp";					
			  }	
		  } else if("fetchValidThirdParty".equals(ACTION)){
			  JSONArray payeeClassCdList = giclClaimListingInquiryService.fetchValidThirdParty(request, USER);
			  message = payeeClassCdList.toString();
			  PAGE = "/pages/genericMessage.jsp"; 
		  } else if("validateClassPerClass".equals(ACTION)){
			  JSONArray validPayeeDetList = giclClaimListingInquiryService.validateClassPerClass(request);
			  message = validPayeeDetList.toString();
			  PAGE = "/pages/genericMessage.jsp"; 
		  } else if("validatePayeePerClassCd".equals(ACTION)){
			  JSONArray validPayeeDetList = giclClaimListingInquiryService.validatePayeePerClassCd(request);
			  message = validPayeeDetList.toString();
			  PAGE = "/pages/genericMessage.jsp"; 
		  
		  }	else if("validateLawyer".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateLawyer(request);
			  PAGE = "/pages/genericMessage.jsp";
		  }else if("showClaimListingPerPolicyWithEnrollees".equals(ACTION)){
				if("1".equals(request.getParameter("refresh"))){
					JSONObject json = giclClaimListingInquiryService.getClaimsWithEnrollees(request, USER.getUserId());
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					request.setAttribute("sysdate", sdf.format(new Date()));
					PAGE = "/pages/claims/inquiry/claimListing/perPolicyWithEnrollees/perPolicyWithEnrollees.jsp";
				}
		  }else if("validateGICLS278Field".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateGICLS278Field(request);
			  PAGE = "/pages/genericMessage.jsp";
		  }else if("validateGICLS278Entries".equals(ACTION)){
			  message = giclClaimListingInquiryService.validateGICLS278Entries(request, USER.getUserId());
			  PAGE = "/pages/genericMessage.jsp";
		  }else if("populateGicls256Totals".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclClaimListingInquiryService.populateGicls256Totals(request, USER))));
				PAGE = "/pages/genericObject.jsp";
		  }else if("validateGicls277PayeeName".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giclClaimListingInquiryService.validateGicls277PayeeName(request))));
				PAGE = "/pages/genericObject.jsp";
		  }else if("showGicls276RecoveryDetails".equals(ACTION)){
				JSONObject jsonRecoveryDetails = giclClaimListingInquiryService.showGicls276RecoveryDetails(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRecoveryDetails.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRecoveryDetails", jsonRecoveryDetails);
					PAGE = "/pages/claims/inquiry/claimListing/perLawyer/subPages/recoveryDetails.jsp";
				}
			}  
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
