<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div id="postParDiv" name="postParDiv" class="sectionDiv" style="width: 460px; margin: 10px 40px;" align="center">
	<div style="float:left; width:100%; margin-top:10px; margin-bottom:15px;">
		<label style="margin-left:10px;">PAR NO : <b>${!empty gipiParlist ? gipiParlist.parNo :gipiPackParList.parNo}</b></label>
	</div>	
	<div id="progressBarMainDiv" name="progressBarMainDiv" style="float:left; width:90%; margin-left:4.5%; heigth: 15px; border:1px solid #456179;">
	 	<div id="progressBarDivDummy" name="progressBarDivDummy" style="display:none; width:0%; float:left; background-color:red;">&nbsp;</div>
	 	<div id="progressBarDiv" name="progressBarDiv" style="width:0%; float:left; background-color:#456179; color:white;">&nbsp;</div>
	</div>
	<div id="statusMainDiv" name="statusMainDiv" style="float:left; width:310px; margin-left:4.5%; margin-top:5px; height:20px auto;">
		<div style="float:left; width:100%; text-align:left;">&nbsp;</div>
	</div><jsp:include page="/pages/underwriting/authenticateDiv.jsp"></jsp:include>
	<div style="float:left; width:100%; margin-top:15px; margin-bottom:10px;">
		<input type="button" class="button" id="btnPostOk" name="btnPostOk" value="Ok" style="display:none;width:80px"/>
		<input type="button" class="button" id="btnPost" name="btnPost" value="Post" style="width:80px"/>
		<input type="button" class="button" id="btnPostCancel" name="btnPostCancel" value="Cancel" style="width:80px"/>
	</div>		
	<input type="hidden" id="isBackEndt" name="isBackEndt" value="${backEndt }" /> 
	<!-- <input type="hidden" id="backEndt" name="backEndt" value="N" />  -->
	<input type="hidden" id="backEndt" name="backEndt" /> <!-- bonok :: 07.17.2013 :: set initial value to null because it causes new posted policies to have a value in back_stat -->
	<input type="hidden" id="credBranchConf" name="credBranchConf" value="N" />
	<input type="hidden" id="hidUseDefaultTin" name="hidUseDefaultTin" value="N" />
	<input type="hidden" id="packWPolbasAnnTsiAmt" name="packWPolbasAnnTsiAmt" value="${gipiPackWPolBas.annTsiAmt }" />
	<input type="hidden" id="chkDfltIntmSw" name="chkDfltIntmSw" value="N" /> <!-- benjo 08.24.2016 SR-5604 -->
</div>

<script>
	addStyleToInputs();
	initializeAll();
	var parDetails = {};
	var pack = "N";
	var bookingMsg = true;
	var cancellationMsg = JSON.parse('${cancellationMsg}'.replace(/\\/g, '\\\\'));
	var changeStat = "N";
	var parNo = ('${!empty gipiParlist ? gipiParlist.parNo :gipiPackParList.parNo}');
	var policyNo = "";
	var autoPrintBinders = '${autoPrintBinders}'; // added by robert SR 4961 09.16.15
	var girir001PrinterName = '${girir001PrinterName}'; // added by robert SR 4961 09.16.15
	$("btnPostCancel").observe("click", function(){
		if(updater != undefined){
			updater.stop();
		}
		
		overlayPost.close(); // andrew - 07.15.2011
	});
	
	if (nvl(objUWGlobal.packParId,null) == null){
		pack = "N";
	}else{
		parDetails = JSON.parse('${gipiParlistJSON}'.replace(/\\/g, '\\\\'));
		pack = "Y"; 
		policyNo = ('${gipiPackWPolBas.lineCd}') + " - " + ('${gipiPackWPolBas.sublineCd}') + " - " + ('${gipiPackWPolBas.issCd}')
					+ " - " + formatNumberDigits(('${gipiPackWPolBas.issueYy}'),2) + " - " + formatNumberDigits(('${gipiPackWPolBas.polSeqNo}'),7) + " - " + formatNumberDigits(('${gipiPackWPolBas.renewNo}'),2);
	}	 

	// to show/hide COC authentication checkbox
	// as per SPECS no: GENWEB UW_SPECS-2012-00001
	if ($('pluginExists').value == "N"){
			$("allowAuthenticateCOC").value = 'N'
			$("authenticateCOC").checked = false; //created by herbert 06232015
		}
	else
	{
		if ($("allowAuthenticateCOC").value == 'Y') {
			$("authenticateMainDiv").show();
			$("authenticateCOC").checked = true;
		} else {
			$("authenticateMainDiv").hide();
			$("authenticateCOC").checked = false;
		}
	}
	
	function checkCancellationPackMsg(action, parId){
		function showCancellation(){
			if (cancellationMsg.length > 0){
				showConfirmBox("",cancellationMsg[0].msgAlert,
						"Ok", "Cancel", 
						function(){
							changeStat = "Y";
							showCancellation();
						}, 
						function(){
							overlayPost.close();
						},"");
				cancellationMsg.splice(0,1);
			}else{
				if (changeStat == "Y" && objUWGlobal.parType == "E" && $("packWPolbasAnnTsiAmt").value == '0'){
					showConfirmBox("","Effectve TSI for package "+policyNo+" is zero. This will cause to change your policy status as cancellation endorsement. Continue?",
							"Ok", "Cancel", 
							function(){
								postPAR(action, parId);
							}, 
							function(){
								overlayPost.close();
							});
				}else{	
					postPAR(action, parId);
				}
			}	 
		}	
		
		showCancellation();
	}	
	
	function continueCompletePosting(){
		try {
			if(autoPrintBinders == "Y"){
				getBindersForPrinting();
			}
			
			showPolicyPrintingPage(); 
			disableMenu("basic");
			disableMenu("itemInfo");
			disableMenu("clauses");
			disableMenu("bill");
			disableMenu("distribution");
			disableMenu("enterInvoiceCommission");
			disableMenu("post");
			disableMenu("print");
			disableMenu("packagePolicyItems");
			disableMenu("coInsurance");
			$("roadMap").hide();
			
			if(pack != "Y") {
				if($F("globalLineCd") == "SU" || objUWGlobal.menuLineCd == "SU") disableMenu("bondPolicyData");
			}
			
			$("btnPostOk").focus();
		} catch (e){
			showErrorMessage("continueCompletePosting", e);
		}
	}
	
	function registerCOCs(parId){
		try{
			new Ajax.Request("COCAuthenticationController", {
				method: "POST",
				parameters: {
					action: "registerCOCs",
					useDefaultTin: $F("hidUseDefaultTin"),
					isPackage: pack,
					parId: parId		
				},
				onCreate: showNotice("Authenticating COC/s, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						if(response.responseText == "false"){ // without error
							showWaitingMessageBox("Authentication successful.", "S", continueCompletePosting);
						} else if(response.responseText == "true"){ // with error
							showWaitingMessageBox("The service returned errors while authenticating the items. Please contact your administrator to verify the details.", "I", continueCompletePosting);
						} else {
							showWaitingMessageBox(response.responseText, "I", continueCompletePosting);	
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("registerCOCs", e);
		}
	}
	
	function postPAR(action, parId){
		if (pack == "Y" && changeStat == "N" && cancellationMsg.length != 0){
			checkCancellationPackMsg(action, parId);
			return false;
		}

		try{
			new Ajax.Request("PostParController", {
				method: "POST",
				parameters: {
					action: action,
					parId: parId,
					backEndt: $("backEndt").value,
					changeStat: changeStat,
					credBranchConf : $F("credBranchConf"),
					authenticateCOC: $("authenticateCOC").checked ? "Y" : "N", // for COC authentication
					useDefaultTin: $F("hidUseDefaultTin"),
					chkDfltIntmSw: $F("chkDfltIntmSw") //benjo 08.24.2016 SR-5604
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function () {
					disableButton("btnPost");
					disableButton("btnPostCancel");
				},
				onComplete: function(response) {					
					var text = response.responseText;
					
					//Added by Apollo Cruz 11.27.2014
					if(text.include("Geniisys Exception")) {
						var geniisysExceptionMsg = "There is no setup for default distribution. Please contact your system administrator."; 
						if(response.responseText.contains(geniisysExceptionMsg)){
							showMessageBox(geniisysExceptionMsg, imgMessage.ERROR);
							updater.stop();
							overlayPost.close();
							return;
						} else if (text.include("COC_NO_TIN") && $F("hidUseDefaultTin") != "Y") {
							var msg = text.split("#");
							showConfirmBox("Confirmation", msg[2].substring(0, msg[2].indexOf(resultMessageDelimiter)), "Proceed", "Cancel", 
								function() {
									$("hidUseDefaultTin").value = "Y";
									postPAR(action, parId);
								},
								function(){									
									overlayPost.close();
								});
							
							updater.stop();
							return;
						} else {
							var msg1 = text.split("#");
							var str = msg1[2];
							var res = str.indexOf(resultMessageDelimiter);
							var msg2 = str.substring(0,res);
							showMessageBox(msg2, msg1[1]);
							
							updater.stop();
							overlayPost.close();
							return;						
						}
					}
					
					var arr = text.split(resultMessageDelimiter);
					if (bookingMsg && nvl(arr[3],"") != ""){ //for booking update message
						bookingMsg = false;
						showWaitingMessageBox(arr[3], "I", function(){
								if (arr[0] != "Posting record Successful.") {
									showMessageBox(arr[0], "E");
								}
							});
					}
					
					if (arr[0] == "Posting record Successful.") {
						updater.stop();
						$("progressBarDiv").style.width = "100%";
						$("progressBarDiv").update("100%");
						$("statusMainDiv").down("div",0).update(arr[0]);
						$("btnPostCancel").hide();
						$("btnPost").hide();
						$("btnPostOk").show();
						okObserve();
						good("postParDiv");
						$("progressBarDiv").style.background = "green";																				
						
						if($("authenticateCOC").checked == true){
							registerCOCs(parId);
						} else {
							continueCompletePosting();
						}
					} else if ((arr[0].include("Crediting Branch")) && arr[1] == "confirm" && $F("credBranchConf") != "Y") { // andrew - 07.20.2011 - for user confirmation when mandatory_cred_branch is N and cred_branch is null
						showConfirmBox("Confirmation", arr[0], "Yes", "No", 
							function() {
								$("credBranchConf").value = "Y";
								postPAR(action, parId);
							},
							function() {
								updater.stop();
								overlayPost.close();
							});						
					} else if ((arr[0].include("Default Intermediary")) && arr[1] == "confirm" && $F("chkDfltIntmSw") != "Y") { //benjo 08.24.2016 SR-5604
						showConfirmBox("Confirmation", arr[0], "Yes", "No", 
								function() {
									$("chkDfltIntmSw").value = "Y";
									postPAR(action, parId);
								},
								function() {
									updater.stop();
									overlayPost.close();
								});
					} else {
						enableButton("btnPostCancel");
						disableButton("btnPost");
					}				
				}
			});
			
			try {
				updater = new Ajax.PeriodicalUpdater('progressBarDivDummy','PostParController', {
                	asynchronous:true, 
                	frequency: 1, 
                	method: "GET",
                	onSuccess: function(request) {
						var text = request.responseText;
						var arr = text.split(resultMessageDelimiter);
						$("progressBarDiv").style.width = arr[0];
						$("progressBarDiv").update(((arr[0] == "0%")? "<font color='#456179'>"+arr[0]+"</font>":arr[0]));
						$("statusMainDiv").down("div",0).update((arr[1] == "") ? "&nbsp;" : arr[1]);
						function checkError(params){
							if (nvl(arr[2],"") == ""){
								if (arr[0] == "100%") {
									$("progressBarDiv").style.width = arr[0];
									updater.stop();
								}	
							} else {
								$("statusMainDiv").down("div",0).update("<font color='red'><b>ERROR:</b></font> "+arr[1]);
								if (params){
								    //belle 11.21.2012 added validation as per mam VJ
									if(arr[2] == "Invalid Installment") {
								    	showWaitingMessageBox("There was an error in Invoice Premium Details, payment term will be updated to COD. Please check and provide the correct payment term.", "E", function(){
								    			overlayPost.close(); 
								    			showBillPremium();
								    		});
									} else {
										showWaitingMessageBox(arr[2], "E", function(){overlayPost.close();});
									}
								}
								$("progressBarDiv").style.background = "red";
								bad("postParDiv");
								updater.stop();
							}
						}
						if (bookingMsg && nvl(arr[3],"") != ""){ //for booking update message
							bookingMsg = false;
							checkError(false);
							showWaitingMessageBox(arr[3], "I", function(){if (nvl(arr[2],"") != ""){showMessageBox(arr[2], "E");}});
						}else{
							checkError(true);
						}	
					}
				});
			} catch(e) {
				showErrorMessage("postPAR Periodical Updater", e);
	        } finally {
		        initializeAll();
	        }  
		}catch(e){
			showErrorMessage("postPAR",e);
		}	
	}	

	function validateMC(parId, lineCd, issCd, callPosting, index){
		try{
			new Ajax.Request("PostParController", {
				method: "POST",
				parameters: {
					action: "validateMC",
					parId: parId,
					lineCd: lineCd,
					issCd: issCd,
					backEndt: $("backEndt").value
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					var res = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
					var arr = [];
					var withBookMsg = false;
					function showResult(){
						if (arr.length > 0){
							//showWaitingMessageBox(unescapeHTML2(arr[0]), (withBookMsg ? "I" :"W"), function(){showResult();}); adpascual - 05.11.2012 - commented out and replace by the line below
							showScrollingMessageBox(unescapeHTML2(arr[0]),(withBookMsg ? "I" :"W"), function(){showResult();});
							withBookMsg = withBookMsg ? false :withBookMsg;
							arr.splice(0,1);
						}else{
							if (nvl(pack,"N") == "Y"){
								if (nvl(callPosting,false)){
									postPAR("postPackPar", objUWParList.packParId);
								}else{
									postPackagePerPar(Number(index)+1);
								}	
							}else{	
								postPAR("postPar", objUWParList.parId);
							}
						}		
					}	
					if (nvl(res.msgIcon1,"W") != "E"){
						if (nvl(res.msgAlert5,"") != "") arr = arr.concat(res.msgAlert5.split(resultMessageDelimiter)); withBookMsg = true;
						if (nvl(res.msgAlert1,"") != "") arr = arr.concat(res.msgAlert1.split(resultMessageDelimiter));
						if (nvl(res.msgAlert2,"") != "") arr = arr.concat(res.msgAlert2.split(resultMessageDelimiter));
						if (nvl(res.msgAlert3,"") != "") arr = arr.concat(res.msgAlert3.split(resultMessageDelimiter));
						if (nvl(res.msgAlert4,"") != "") arr = arr.concat(res.msgAlert4.split(resultMessageDelimiter));
						showResult();
					}else{
						if (nvl(res.msgAlert5,"") != ""){
							showWaitingMessageBox(unescapeHTML2(res.msgAlert5), "I", function(){nvl(pack,"N") == "Y" ? postPAR("postPackPar", objUWParList.packParId) :postPAR("postPar", objUWParList.parId);});
						} else if (nvl(res.msgAlert4,"") != "") { //added ,"" by robert 11.08.2013
							//showWaitingMessageBox(unescapeHTML2(res.msgAlert4), "E", function(){overlayPost.close();});
							showScrollingMessageBox(unescapeHTML2(res.msgAlert4), "E", function(){overlayPost.close();});
						} else{		
							nvl(pack,"N") == "Y" ? postPAR("postPackPar", objUWParList.packParId) :postPAR("postPar", objUWParList.parId);
						}	
					}	

				}
			});		
		}catch(e){
			showErrorMessage("validateMC",e);
		}				
	}	

	function getParCancellationMsg(){
		try{
			new Ajax.Request("PostParController", {
				method: "POST",
				parameters: {
					action: "getParCancellationMsg",
					parId: $F("globalParId")
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					cancellationMsg = JSON.parse((response.responseText).replace(/\\/g, '\\\\'));
				}
			});
		}catch(e){
			showErrorMessage("getParCancellationMsg",e);
		}
	}			

	function continueParPosting(){
		try{
			if ($F("globalLineCd") == "MC"){
				validateMC($F("globalParId"), $F("globalLineCd"), $F("globalIssCd"));
			}else{	
				postPAR("postPar", objUWParList.parId);
			}	
		}catch(e){
			showErrorMessage("continueParPosting",e);
		}
	}	
	
	function checkAllRequiredFieldsInDiv2(divId) { //Added by Jerome 08.15.2016 SR 5589 
		try{
			var isComplete = true;
			$$("div#"+divId+" input[type='text'].required, div#"+divId+" textarea.required, div#"+divId+" select.required, div#"+divId+" input[type='file'].required").each(function (o) {
				if (o.value.blank()){
					isComplete = false;
					customShowMessageBox("Cannot post par. Endorsement Text is required.", "I", o.id);
					throw $break;
				}
			});
			return isComplete;
		}catch(e){
			showErrorMessage("checkAllRequiredFieldsInDiv2",e);
		}
		
	}
	
	$("btnPost").observe("click", function () {

		if(!checkAllRequiredFieldsInDiv2("otherDetails")){ //Added by Jerome 08.15.2016 SR 5589
			return false;
		}
		
		if (nvl(objUWGlobal.packParId,null) == null){
			if (cancellationMsg.length == 0 && nvl($F("globalParType"),objUWParList.parType) == "E"){
				getParCancellationMsg();
			}
			
			if (cancellationMsg.length != 0){
				function showCancellation(){
					if (cancellationMsg.length > 0){
						showConfirmBox("",cancellationMsg[0].msgAlert,
								"Ok", "Cancel", showCancellation, function(){overlayPost.close();});
						cancellationMsg.splice(0,1);
					}else{
						continueParPosting();
					}		
				}	
				
				showCancellation();
			}else{
				continueParPosting();
			}	
		}else{
			postPackagePerPar(0);	
		}
		//jmm SR-22834
		notEqualRiCd = false
		validatePolNo2 = "";
		postValidate = "";
	});
	
	function postPackagePerPar(index){
		var ok = false;
		for(var a=index; a<parDetails.length; a++){
			if (parDetails[a].lineCd == "MC"){
				ok = (a==(parDetails.length-1));
				validateMC(parDetails[a].parId, parDetails[a].lineCd, parDetails[a].issCd, (a==(parDetails.length-1)), a);
				return false;
			}else{	
				if (a==(parDetails.length-1)){
					if (!ok) postPAR("postPackPar", objUWParList.packParId); 
				}	
			}
		}
	}	

	function okObserve(){
		$("btnPostOk").observe("click", function(){
			//hideOverlay();
			overlayPost.close(); // andrew - 07.15.2011
		});
	}
	if ($("isBackEndt").value == "Y"){
		showConfirmBox4("Message", "This is a backward endorsement since its effectivity is earlier than the effectivity date of "+
				"previous endorsement(s).  Annualize amount of the previous endorsement(s) will be "+
				"calculated again.  Would you like to include non-affecting changes of this endorsement"+ 
				"like date, address, etc., in updating previous endorsement(s)?  Remember that all "+
				"information herein will be the current  information of the policy.  Continue with the updates?",  
				"With Updates", "Without Updates", "Cancel", onOkFunc, onCancelFunc, function onCancel() {
																						overlayPost.close();
																					 }); //switched showConfirmBox2 to showConfirmBox4 by June Mark SR5797 [10.27.16]
	}
	function onOkFunc() {
		$("backEndt").value = "Y";
	}	
	function onCancelFunc() {
		$("backEndt").value = "N";
	}
	
	// added by robert SR 4961 09.16.15
	function getBindersForPrinting(){
		new Ajax.Request(contextPath + "/GIPIParMCItemInformationController?action=getDistNo", {
			method : "GET",
			parameters : {
				globalParId : objUWParList.parId
			},
			asynchronous : false,
			evalScripts : true,
			onComplete :
				function(response){
					if (checkErrorOnResponse(response)) {
						pDistNo = parseInt(response.responseText);
						var content = contextPath+"/GIRIWFrpsRiController?action=getPrintFrps&distNo="+pDistNo;
						new Ajax.Request(content, {
								method: "GET",
								evalScripts: true,
								asynchronous: true,
								onComplete: function(response){
									if (checkErrorOnResponse(response)){
										obj = JSON.parse(response.responseText);
										for(var i=0; i<obj.length; i++){
											printBinder(obj[i].lineCd, obj[i].binderYy, obj[i].binderSeqNo, obj[i].fnlBinderId);	
										}
									}
								}
							});
					}
				}
		});
	}

	function printBinder(lineCd, binderYy, binderSeqNo, fnlBinderId){
		var content = contextPath+"/ReinsuranceAcceptanceController?action=doPrintFrps&lineCd="+lineCd+"&binderYy="+binderYy+"&binderSeqNo="+binderSeqNo+"&fnlBinderId="+fnlBinderId;
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : 1,
						 	 printerName : girir001PrinterName},
				evalScripts: true,
				asynchronous: true,
				onCreate   : showNotice("Printing Binder Report, please wait..."),
				onComplete: function(response){
					if (response.responseText.include("No suitable print service found.")) {
						showMessageBox("Automatic printing of binders is not successful. Please check the printer indicated in the Underwriting parameter 'GIRIR001_PRINTER_NAME'. ", "I");
						return false;
					}else if (checkErrorOnResponse(response)){
						showMessageBox("Printing complete.", "S");
					}
				}
			});
	}
	// end robert SR 4961 09.16.15
	$("btnPost").focus();
	if(notEqualRiCd && postValidate == "Y"){ //jmm SR - 22834
		 var msg = "Ceding company entered does not tally with the policy for endorsement entered. Do you want to proceed? Pressing '\Yes\' will update the ceding company on the policy entered "+globalPolNo+"."
				showConfirmBox("Confirmation", msg, "Yes", "No",
						function(){
					
						},
						function(){
							overlayPost.close();
						});
			    
	}
</script>