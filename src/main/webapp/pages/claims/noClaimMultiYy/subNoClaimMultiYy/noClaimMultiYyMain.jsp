<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="claimListingMainDiv" name="claimListingMainDiv">
	<div id="claimListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="claimListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Certificate of No Claim Multi Year</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="noClaimMultiYyPolicyListTableGridSectionDiv" class="sectionDiv">
		<div id="noClaimMultiYyPolicyDetailsTableGridDiv" class="sectionDiv" style="border: none;">
				<table border="0" style="margin: auto; margin-top: 10px; margin-bottom: 10px;">
					<tr>
						<td class="rightAligned">No Claim No.</td>			
						<td class="leftAligned">
							<!-- <div style="width: 185px;" class="required withIconDiv"> -->
								<input type="text" id="txtNoClaimNo" name="txtNoClaimNo" value="" style="width: 185px;" readonly="readonly">
							<!-- 	<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoClaim" name="itemNoClaim" alt="Go" />
							</div> -->
							<input type="checkbox" id="chkNoClaimCancel" name="chkNoClaimCancel" value="Y" disabled="disabled"/>
						</td>
						<td class="rightAligned">Cancelled</td>
						<td class="rightAligned" style="width: 120px;"></td>
						<td class="leftAligned">
							<input type="button" id="cancelNoClaim" name="cancelNoClaim" style="width: 120px;" value="Cancel No Claim" class="button">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Assured Name</td>			
						<td class="leftAligned" colspan="2">
							<div style="width: 85px;" class="required withIconDiv">
								<!-- changed integerUnformatted, added maxlength on txtAssdNo: shan 10.14.2013 -->
								<input type="text" id="txtAssdNo" name="txtAssdNo" value="" readonly="readonly" maxlength="10" style="width: 60px;" class="required withIcon integerNoNegativeUnformattedNoComma"> 
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemAssdNo" name="itemAssdNo" alt="Go" />
							</div>
							<input type="text" id="txtAssdName" name="txtAssdName" value="" style="width: 179px;" readonly="readonly">
						</td>
						<td class="rightAligned">Car Company</td>			
						<td class="leftAligned">
							<input type="text" id="txtCarCompany" name="txtCarCompany" value="" style="width: 270px;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Plate No.</td>			
						<td class="leftAligned" colspan="2">
							<div style="width: 276px;" class="withIconDiv"> <!-- remove class required - christian 12.07.2012  -->
								<input type="text" id="txtPlateNo" name="txtPlateNo" value="" readonly="readonly" maxlength="10" style="width: 220px;" class="withIcon"> <!-- added maxlength : shan 10.14.2013 -->
								<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemPlateNo" name="itemPlateNo" alt="Go" />
							</div>
						</td>
						<td class="rightAligned">Make</td>			
						<td class="leftAligned">
							<input type="text" id="txtMake" name="txtMake" value="" style="width: 270px;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Serial No.</td>			
						<td class="leftAligned" colspan="2">
							<input type="text" id="txtSerialNo" name="txtSerialNo" readonly="readonly" maxlength="20" value="" style="width: 270px;" > <!-- added maxlength : shan 10.14.2013 -->
						</td>
						<td class="rightAligned">Basic Color</td>			
						<td class="leftAligned">
							<input type="text" id="txtBasicColor" name="txtBasicColor" value="" style="width: 270px;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Motor No.</td>			
						<td class="leftAligned" colspan="2">
							<input type="text" id="txtMotorNo" name="txtMotorNo" readonly="readonly" maxlength="20" value="" style="width: 270px;" > <!-- added maxlength : shan 10.14.2013 -->
						</td>
						<td class="rightAligned">Color</td>			
						<td class="leftAligned">
							<input type="text" id="txtColor" name="txtColor" value="" style="width: 270px;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>			
						<td class="leftAligned" colspan="4">
							<!-- changed from text to textarea : shan 10.14.2013 -->
							<!-- <input type="text" id="txtRemarks" name="txtRemarks" value="" style="width: 685px;">  -->
							<div style="border: 1px solid gray; height: 20px; width: 686px;" changeTagAttr="true">
								<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtRemarks" name="txtRemarks" draggable="false" style="width: 660px; border: none; height: 13px; "></textarea>
								<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
							</div>
						</td>
					</tr>
					<!--User Id and Last Update changed from hidden to text : shan 10.14.2013 -->
					 <tr>
						<td class="rightAligned">User Id</td>			
						<td class="leftAligned" colspan="2"> 
							<input type="text" id="txtUserId" name="txtUserId" value="" style="width: 185px;" readonly="readonly">
							<input type="hidden" id="hidden" name="hidden" value="Y" disabled="disabled"/>
						 </td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned">
							<input type="text" id="txtLastUpdate" name="txtLastUpdate" value="" style="width: 270px;" readonly="readonly">
						 </td>
					</tr>
				</table>
		</div>
		<input type="hidden" id="hidNoClaimNo" name="hidNoClaimNo">
		<input type="hidden" id="hidNoClaimNo2" name="hidNoClaimNo2">
		<div id="tableGridOuterDiv" style="width: 920px; height: 220px; padding-right: 115px; padding-left: 115px; padding-bottom: 10px; border: none;" class="sectionDiv">		
		</div>
		<div id="detailsDiv" style="width: 920px;" align="center">
				<input type="button" id="noClaimPolicyDetails" name="noClaimPolicyDetails" style="width: 120px; margin-top: 10px; margin-bottom: 20px;" value="Details" class="button">
		</div>
	</div>
	
	<div id="addDeleteDiv" style="width: 920px; padding-bottom: 30px;" align="center">
				<input type="button" id="noClaimMultiSave" name="noClaimMultiSave" style="width: 120px; margin-top: 10px; margin-bottom: 20px;" value="Save" class="button">
				<input type="button" id="noClaimMultiCancel" name="noClaimMultiCancel" style="width: 120px; margin-bottom: 40px;" value="Cancel" class="button">
				<input type="button" id="noClaimMultiPrint" name="noClaimMultiPrint" style="width: 120px; margin-bottom: 40px;" value="Print" class="button">
	</div>
</div>
<script>
	
	var viewPolicy = false; //created variable to determine if user wants to exit to view policy information by MAC 11/22/2013.
	try{
		initializeAll();
		objCLMItem.noClaimId = $F("hidNoClaimNo");
		objCLM.noClaims = JSON.parse('${noClaimDtls}'.replace(/\\/g, '\\\\'));
		noClaimDetails 	= JSON.parse('${noClaimMultiYyDetails}'.replace(/\\/g, '\\\\'));
		
		var noClaimId		    	= noClaimDetails.noClaimId;
		var ncIssCd		    		= "";
		var ncIssueYy		    	= "";
		var ncSeqNo		    		= "";
		var assdNo			    	= "";
		var noIssueDate	    		= "";
		var motorNo		    		= "";
		var serialNo		    	= "";
		var plateNo		    		= "";
		var modelYear		    	= "";
		var makeCd			    	= "";
		var motcarCompCd	    	= "";
		var basicColorCd	    	= "";
		var colorCd		    		= "";
		var cancelTag		    	= "";
		var remarks			    	= "";
		var cpiRecNo		    	= "";
		var cpiBranchCd	    		= "";
		var lastUpdate		    	= "";
		var ncIssueDate      		= "";
		var object 					= null;
		
		var exitPage = "";		//added by shan 10.16.2013
		
		$("hidNoClaimNo").value = noClaimId;
		
		$("txtNoClaimNo").value 	= nvl(noClaimDetails.noClaimNo,"");
		$("txtAssdNo").value		= nvl(noClaimDetails.assdNo,"");
		switch(noClaimDetails.cancelTag){
			case 'Y':{
				$("chkNoClaimCancel").checked = true;
				cancelTag = "Y";
				$("cancelNoClaim").value = "Activate No Claim";
				break;
			} 
			case "N" :{
				$("chkNoClaimCancel").checked = false;
				cancelTag = "N";
				$("cancelNoClaim").value = "Cancel No Claim";
				break;
			}
		}
		$("txtAssdName").value  	= unescapeHTML2(nvl(noClaimDetails.assdName,""));
		$("txtCarCompany").value	= unescapeHTML2(nvl(noClaimDetails.carCompany,""));
		$("txtPlateNo").value		= unescapeHTML2(nvl(noClaimDetails.plateNo,""));
		$("txtMake").value			= noClaimDetails.modelYear == null &&  noClaimDetails.make == null ? "" : nvl(noClaimDetails.modelYear,"")+" - "+nvl(noClaimDetails.make,"");
		$("txtSerialNo").value		= unescapeHTML2(nvl(noClaimDetails.serialNo,""));
		$("txtMotorNo").value		= unescapeHTML2(nvl(noClaimDetails.motorNo,"")); //lara - 11/05/2013
		$("txtRemarks").value		= unescapeHTML2(nvl(noClaimDetails.remarks,""));
		$("txtBasicColor").value	= noClaimDetails.basicColorCd == null && noClaimDetails.basicColor == null ? "" : nvl(noClaimDetails.basicColorCd,"")+" - "+nvl(noClaimDetails.basicColor,"");
		$("txtColor").value			= noClaimDetails.colorCd == null && noClaimDetails.color == null ? "" : nvl(noClaimDetails.colorCd,"")+" - "+nvl(noClaimDetails.color,"");
		$("txtUserId").value		= nvl(noClaimDetails.userId,"");
		$("txtLastUpdate").value 	= noClaimDetails.lastUpdate == null ? "" : dateFormat(noClaimDetails.lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
		
		
		var plateNo 		= nvl($F("txtPlateNo"),"");
		var serialNo 		= nvl($F("txtSerialNo"),"");
		var motorNo			= nvl($F("txtMotorNo"),"");
		var assdNo 			= nvl($F("txtAssdNo"),"");
		var basicColorCd	= nvl(noClaimDetails.basicColorCd,"");
		var colorCd			= nvl(noClaimDetails.colorCd,"");
		

		if((plateNo != null)||(plateNo != "")||(serialNo != null)||(motorNo != null)){
				getPolicyListByPlateNo(plateNo, serialNo, motorNo);
		}		
		/* if((plateNo != null)||(plateNo != "")){
				getPolicyListByPlateNo(plateNo,noClaimDetails.noClaimId);
						
		}else{
				getPolicyListByPlateNo(null);
		}		
		}else if(serialNo != null){
			getPolicyListBySerialNo(serialNo,noClaimDetails.noClaimId);		
		}else if(motorNo != null){
			getPolicyListByMotorNo(motorNo,noClaimDetails.noClaimId);
	    }else{		
	    	getPolicyListByPlateNo(null,null);
		} */		
		
		//Added by Christian 01252013
		if($F("txtNoClaimNo") == null || $F("txtNoClaimNo") == ""){
			$("itemAssdNo").show();
			$("noClaimMultiSave").value = "Save";
		}else{
			$("itemAssdNo").hide();
			disableButton("noClaimMultiSave");
		}
		
		$("itemAssdNo").observe("click", function(){
			showNoClaimMultiYyLOV();
		});
		
		
		//added by shan 10.14.2013
		$("editRemarks").observe("click", function () {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), remarksUpdated);
		});
		
		$("noClaimMultiCancel").observe("click",function(){
			/* commented out by shan 10.16.2013
			objCLMGlobal = new Object();
			setDocumentTitle("No Claim Multi Year Listing");
			objCLMGlobal.callingForm = "GICLS062"; 
			showNoClaimMultiYyList();
			*/
			if(changeTag == 1) {
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
						function(){
							exitPage = exitModule;
							fireEvent($("noClaimMultiSave"), "click");
						}, 
						exitModule, 
						"");
			} else {
				exitModule();
			}
		});		
		
		
		//observeReloadForm("reloadForm",showNoClaimMutiYyPolicyList);
		
		$("noClaimPolicyDetails").observe("click",function(){
			if(tableGridId == "noClaimPolicyGrid"){
				if(objCLMGlobal.noClaimTypeListSelectedIndex == null){
					showMessageBox("Please select a record first.", "E");
				}else{
					if(changeTag == 1) {
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
							viewPolicy = true;
							fireEvent($("noClaimMultiSave"), "click");
						}, function(){
							viewPolicyDetails();
						}, "");
					} else {
						viewPolicyDetails();
					}
				}
			}
		});
		
		function viewPolicyDetails(){
			var objec = noClaimPolicyGrid.geniisysRows[objCLMGlobal.noClaimTypeListSelectedIndex];
			goToBasicInfo(objec,$F("hidNoClaimNo"));
			changeTag = 0;
		}
		
		$("itemPlateNo").observe("click",function(){
			var assdNo = $F("txtAssdNo");
			showNoClaimMultiYyPlateNoLOV(assdNo);
		});				
		
		$("cancelNoClaim").observe("click", function(){
			var message = $F("cancelNoClaim") == "Cancel No Claim" ? "Do you want to cancel this transaction?" : "Do you want to activate this transaction?";
			
			showConfirmBox("Confirmation", message, "Yes", "No", 
					function(){
						if ($F("cancelNoClaim") == "Cancel No Claim"){
							$("chkNoClaimCancel").checked = true;
							cancelTag = "Y";
							$("cancelNoClaim").value = "Activate No Claim";
							$("noClaimMultiSave").value = "Update";
							enableButton("noClaimMultiSave");
						}else{
							$("chkNoClaimCancel").checked = false;
							cancelTag = "N";
							$("cancelNoClaim").value = "Cancel No Claim";
							$("noClaimMultiSave").value = "Update";
							enableButton("noClaimMultiSave");
						} 	
					},
					
					null
			);
		});
		
		$("claimListingExit").observe("click", function (){
			/* commented out by shan 10.16.2013
			objCLMGlobal = new Object();
			setDocumentTitle("No Claim Multi Year Listing");
			objCLMGlobal.callingForm = "GICLS062"; 
			showNoClaimMultiYyList();
			*/
			fireEvent($("noClaimMultiCancel"), "click");
		});
		
		$("noClaimMultiSave").observe("click",function(){
			var isComplete = checkAllRequiredFields();
			if (isComplete){
				if (($F("txtPlateNo") == "" || $F("txtPlateNo") == null) && 
					($F("txtSerialNo") == "" || $F("txtSerialNo") == null) && 
					($F("txtMotorNo") == "") || $F("txtMotorNo") == null){
					showMessageBox("Please enter the plate number or select it from the list of values.", imgMessage.INFO);
					return false;
				}
				if($F("noClaimMultiSave")== "Save"){
					saveNewDetails();
				}
				else{
					noClaimId = noClaimDetails.noClaimId;
					$("hidNoClaimNo").value = noClaimId;
					saveNewDetails();
				}
			}
			
			
		});
		
		$("noClaimMultiPrint").observe("click", function(){
			if(objCLMGlobal.noClaimTypeListSelectedIndex == null){
				showMessageBox("Please select a record first.", "E");
			}else{
				if($F("chkNoClaimCancel") == "Y"){
					showMessageBox("Cannot print cancelled transaction.", imgMessage.INFO);
					return false;
				}
				/* checkVersionGICLS062();	 */
				
				 // irwin
				 
				function printGiclr062(){
					
					/*var content = contextPath+"/PrintNoClaimCertificateController?action=populateGICLR026" */ //
							// commented by Kris 12.06.2012: should call populateGICLR062 
					var content = contextPath+"/PrintNoClaimCertificateController?action=populateGICLR062"
					+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")
					+"&noClaimId="+nvl($F("hidNoClaimNo"), "")
					+"&moduleId=GICLS062"+"&policyId="+nvl(objCLMGlobal.noClaimPolicyId, "");
						
					printGenericReport(content, "No Claim Multi Year Certificate");
				} 
				
				
				
				showGenericPrintDialog("No Claim Multi Year Printing", printGiclr062, null);
			}		 
		});

		//added by shan 10.16.2013
		function exitModule(){
			objCLMGlobal = new Object();
			setDocumentTitle("No Claim Multi Year Listing");
			objCLMGlobal.callingForm = "GICLS062"; 
			showNoClaimMultiYyList();
		}	
		
		function saveNewDetails(){
			var a = $("noClaimMultiSave").value ;
			switch(a){
			case "Save" : {
				validateBeforeSaving();
				
				} 
				break;
			case "Update" : {
				populateNoClmMultiYyDetails(); //moved by Christian 01252013
				updateDtls();
				}
				break;
			}
			//populateNoClmMultiYyDetails();
		}
		
		function populateNoClmMultiYyDetails(){
			try{
				new Ajax.Request(contextPath + "/GICLNoClaimMultiYyController?action=populateNoClmMultiYyDtls",{
					method: "GET",
					asynchronous: false,//modified by Christian 01252013
					evalScripts: true,
					parameters:{
						assdNo 	: $F("txtAssdNo"),
						plateNo : $F("txtPlateNo"),
						serialNo : $F("txtSerialNo"),
						motorNo : $F("txtMotorNo")	
					},
					onComplete: function(response){
						var details = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
						modelYear = nvl(details.modelYear,"");
						makeCd = nvl(details.makeCd,"");
						motcarCompCd = nvl(details.carCompanyCd,"");
						basicColorCd = nvl(details.basicColorCd,"");
						colorCd = details.colorCd;
						$("txtCarCompany").value 	= nvl(details.carCompany,"");
						$("txtMake").value			= nvl(details.modelYear,"")+" - "+nvl(details.make,"");
						$("txtBasicColor").value 	= nvl(details.basicColorCd,"")+" - "+nvl(details.basicColor,"");
						$("txtColor").value 		= nvl(details.colorCd,"")+" - "+nvl(details.color,"");
						
						/* if("Save".equals(a)){
							getAdditionalDtls();
						}else{
							updateDtls();
						}
						
						switch (letter) {
						   case 'a': a += 1; break;
						   case 'b': b += 1; break;
						   case 'c': c += 1; break;
						   case 'd': d += 1; break;
						   case 'e': e += 1; break;
						   case 'f': f += 1; break;
						} */
					}	
				});
			}catch(e){
				showErrorMessage("populateNoClmMultiYyDetails",e);
			}
		}
		
		function validateBeforeSaving(){
			try{
				new Ajax.Request(contextPath+"/GICLNoClaimMultiYyController?action=validateSaving",{
					method: "GET",
					asynchonous: true,
					evalScripts: true,
					parameters:{
						assdNo 	: $F("txtAssdNo"),
						plateNo : $F("txtPlateNo"),
						serialNo : $F("txtSerialNo"),
						motorNo : $F("txtMotorNo")
					},
					onComplete: function(response){
						var exist = response.responseText.replace(/\\/g,'\\\\');
						if(!exist.empty()){
							showMessageBox(response.responseText, imgMessage.ERROR);
						}else{
							populateNoClmMultiYyDetails();
							getAdditionalDtls();
						}
					}				
				});
			}catch(e){
				showErrorMessage("validateSaving",e);
			}
		}
		function updateDtls(){
			try{
				new Ajax.Request(contextPath +"/GICLNoClaimMultiYyController?action=updateDtls",{
					method: "GET",
					evalScripts: true,
					asynchronous: false,
					parameters:{
						noClaimId: $F("hidNoClaimNo")
					},
					onComplete: function(response){
						var addtlnal = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
						$("txtUserId").value		= nvl(userId,"");
						ncIssCd	= nvl(addtlnal.ncIssCd,"");
						ncIssueYy = nvl(addtlnal.ncIssueYy,"");
						noClaimId = nvl($F("hidNoClaimNo"),"");
						ncSeqNo = nvl(addtlnal.ncSeqNo,"");
						noClaimNo = ncIssCd+" - "+ncIssueYy+" - "+lpad(ncSeqNo,7,"0");
						$("txtNoClaimNo").value = noClaimNo;
						assdNo 	= nvl($F("txtAssdNo"),"");
						plateNo = nvl($F("txtPlateNo"),"");
						serialNo = nvl($F("txtSerialNo"),"");
						motorNo = nvl($F("txtMotorNo"),"");
						modelYear = nvl(modelYear,"");
						remarks = unescapeHTML2(nvl($F("txtRemarks")),"");
						lastUpdate = addtlnal.ncLastUpdate,"MM-dd-yyyy HH:mm:ss";
						ncIssueDate = addtlnal.ncIssueDate;
						$("txtLastUpdate").value 	= dateFormat(addtlnal.ncLastUpdate,'mm-dd-yyyy hh:MM:ss TT');
						/* if(plateNo != null){
							getPolicyListByPlateNo(plateNo, serialNo,motorNo, noClaimDetails.noClaimId);
						}else{/*  if(serialNo != null){
							getPolicyListBySerialNo(serialNo);
						}else if(motorNo != null){
							getPolicyListByMotorNo(motorNo); 	
							getPolicyListByPlateNo(null,null ,null,null );
						} */	
						getSaveNoClmMultiYy();
					}
				});
			}catch(e){
				showErrorMessage("updateDtls",e);
			}
		}
		
		
		function getAdditionalDtls(){
			try{
				new Ajax.Request(contextPath +"/GICLNoClaimMultiYyController?action=additionalDtls",{
					method: "GET",
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						var addtlnal = JSON.parse(response.responseText.replace(/\\/g,'\\\\'));
						
						$("txtUserId").value	= nvl(userId,"");
						ncIssCd					= nvl(addtlnal.ncIssCd,"");
						ncIssueDate 			= addtlnal.ncIssueDate;
						lastUpdate 				= addtlnal.ncLastUpdate;
						ncIssueYy 				= nvl(addtlnal.ncIssueYy,"");
						noClaimId 				= addtlnal.ncNoClaimId;
						$("hidNoClaimNo").value = addtlnal.ncNoClaimId;
						ncSeqNo = nvl(addtlnal.ncSeqNo,"");
						
						$("txtNoClaimNo").value 	= addtlnal.ncNoClaimNo;
						$("txtLastUpdate").value 	= dateFormat(addtlnal.ncLastUpdate,"mm-dd-yyyy hh:MM TT");
						
						assdNo 	= nvl($F("txtAssdNo"),"");
						plateNo = nvl($F("txtPlateNo"),"");
						serialNo = nvl($F("txtSerialNo"),"");
						motorNo = nvl($F("txtMotorNo"),"");
						//modelYear = nvl(modelYear,"");
						remarks = unescapeHTML2(nvl($F("txtRemarks")),"");
						
						if(plateNo != null||(serialNo != null)||(motorNo != null)){
							getPolicyListByPlateNo(plateNo, serialNo, motorNo);
						}

						/* if(plateNo != null){
							getPolicyListByPlateNo(plateNo,serialNo,motorNo,noClaimDetails.noClaimId);
						}else{/*  if(serialNo != null){
							getPolicyListBySerialNo(serialNo);
						}else if(motorNo != null){
							getPolicyListByMotorNo(motorNo); 
							getPolicyListByPlateNo(null,null,null,null );
						}	 */
						getSaveNoClmMultiYy();
					}
				});
			}catch(e){
				showErrorMessage("getAdditionalDtls",e);
			}
		}
		
		function getSaveNoClmMultiYy(){
			try{
				new Ajax.Request(contextPath+"/GICLNoClaimMultiYyController?action=saveNoClmMultiYy",{
					method: "GET",
					evalScripts: true,
					asynchronous: true,
					parameters:{
						
						noClaimId		:noClaimId,		   	
						ncIssCd			:ncIssCd,			
						ncIssueYy		:ncIssueYy,		   	
						ncSeqNo			:ncSeqNo,			
						assdNo			:assdNo,			   	
						noIssueDate		:noIssueDate,		
						motorNo		  	:motorNo,		  	
						serialNo		:serialNo,			
						plateNo		  	:plateNo,		  	
						modelYear		:modelYear,			
						makeCd			:makeCd,			   	
						motcarCompCd	:motcarCompCd,	
						basicColorCd	:basicColorCd,	
						colorCd		  	:colorCd,		  	
						cancelTag		:cancelTag,			
						remarks			:remarks,			   	
						cpiRecNo		:cpiRecNo,			
						cpiBranchCd		:cpiBranchCd,		
						userId			:userId,			   	
						lastUpdate		:lastUpdate,		   	
						ncIssueDate   	:ncIssueDate  
					},
					onComplete: function(response){
						var res = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (res.message == "SUCCESS"){
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								if (exitPage != ""){
									exitPage();
								}else{
									changeTag = 0;
									$("itemAssdNo").hide();
									$("itemPlateNo").hide();
									
									viewNoClaimMultiYyPolicyListing($F("hidNoClaimNo"));
								}
							});							
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
				});
			}catch(e){
				showErrorMessage("getSaveEditDetails",e);
			}
		}
		
		function printNoClaimCert2(){
			try{
				Modalbox.show(contextPath+"/PrintNoClaimCertificateController?action=showPrintNC2&ajaxModal=1&reportVersion="+reportVersion,
						{title: title,
						 width: 500});
			}catch(e){
				showErrorMessage("printNoClaimCert2",e);
			}
			
		}
		
		function checkVersionGICLS062(){
			try{
				new Ajax.Request(contextPath+"/GICLNoClaimController?action=checkVersionGICLS062",{
					evalScripts: true,
					asynchronous: false,
					method:"GET",
					onCreate: showNotice("Loading, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)) {
							var version = response.responseText;
								objCLM.noClaims.reportId = "GICLR062";
								if(version == 'FPAC' || version == 'SEICI' || version == 'PNB' || version == 'UCPB'){
									title = "Print No Claim Multi Year Certificate";
									reportVersion = version;
									printNoClaimCert2();
								}else{
									title = "Print No Claim Multi Year Certificate";
									reportVersion = version;
									printNoClaimCert2(); 									
								}
							objCLM.noClaims.version = version;
							var paramsObject = noClaimPolicyGrid.geniisysRows[objCLMGlobal.noClaimTypeListSelectedIndex];
							populatePrintParams(paramsObject);
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}catch(e){
				shoeErrorMessage("checkVersionGICLS062",e);
			}
		}
		
		function populatePrintParams(object){
			try{
				objCLM.noClaims.effDate 			        = dateFormat(object.effDate, "mm-dd-yyyy hh:MM tt");
				var lossDate								= dateFormat(object.dateOfLos,"mm-dd-yyyy")+" "+dateFormat(object.timeOfLoss,"hh:mm tt");
				objCLM.noClaims.ncLossDate 					= lossDate;
				objCLM.noClaims.expiryDate 					= dateFormat(object.expiryDate,"mm-dd-yyyy hh:MM tt");
				objCLM.noClaims.lineCd 						= object.lineCd;
				objCLM.noClaims.sublineCd 					= object.sublineCd;
				objCLM.noClaims.issCd 						= object.issCd;
				objCLM.noClaims.issueYy 					= object.issueYy;
				objCLM.noClaims.polSeqNo 					= object.polSeqNo;
				objCLM.noClaims.renewNo 					= object.renewNo;
				objCLM.noClaims.assdName 					= $F("txtAssdName");
				var makeText								= $F("txtMake").split("-");
				var modelYear								= makeText[0];
				var make									= makeText[1];
				objCLM.noClaims.modelYear 					= nvl(modelYear,"");
				objCLM.noClaims.carCompany 					= nvl($F("txtCarCompany"),"");
				objCLM.noClaims.make 						= nvl(make,"");
				objCLM.noClaims.plateNo 					= nvl(plateNo,"");
				objCLM.noClaims.motorNo 					= nvl(motorNo,"");
				objCLM.noClaims.serialNo					= nvl(serialNo,"");
				objCLM.noClaims.ncIssueDate	 				= dateFormat(object.dateIssued,"mm-dd-yyyy hh:MM tt");
				objCLM.noClaims.menuLineCd	 				= nvl(object.menuLineCd,"");
				objCLM.noClaims.lineCdMC	 				= nvl(object.lineCdMC,"");
				var noClaimNo								=$F("txtNoClaimNo");
				objCLM.noClaims.noClaimNo 					= noClaimNo;
			}catch(e){
				showErrorMessage("populatePrintParams",e);
			}
		}
		
			
	}catch(e){
		showErrorMessage("noClaimMultiYyMain.jsp",e);
	}
	
	observeReloadForm("reloadForm", function(){
		if (noClaimDetails.noClaimId != null ){		// for edit
			viewNoClaimMultiYyPolicyListing(noClaimDetails.noClaimId);	
			//$("txtRemarks").setAttribute("readonly","readonly");
			disableButton("noClaimMultiSave");
			$("itemAssdNo").hide();
			$("itemPlateNo").hide();
		}else{	// for add
			$$("div#noClaimMultiYyPolicyDetailsTableGridDiv input[type='text'], div#noClaimMultiYyPolicyDetailsTableGridDiv textarea").each(function(txt){
				txt.clear();
			});	
			
		}
	});	
	
	$("txtRemarks").observe("change", function () {
		$("noClaimMultiSave").value = "Update";
		enableButton("noClaimMultiSave");
	});
	
	function remarksUpdated(){
		$("noClaimMultiSave").value = "Update";
		enableButton("noClaimMultiSave");
	}
	
	hideNotice();
</script>