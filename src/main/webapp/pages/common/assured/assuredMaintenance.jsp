<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<input type="hidden" id="divToShow" name="divToShow" value="${divToShow}" />
<input type="hidden" id="hidViewOnly" name="hidViewOnly" value="false" />
<!-- <div id="assuredMaintenanceMenu">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="assuredMaintenanceAdd"  style="display: none;">Create New Assured</a></li>
				<li><a id="assuredMaintenanceExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div> -->
<div id="assuredMaintenanceMainDiv"> <!-- style="margin-top: 1px; display: none;" --> <!-- Patrick  --> 
	<div id="assuredMaintenanceMenu"> 
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="assuredMaintenanceAdd"  style="display: none;">Create New Assured</a></li>
					<li><a id="assuredMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div> <!-- Patrick  -->
	<form id="assuredMaintenanceForm" name="assuredMaintenanceForm" >
		<div id="assuredMaintenanceFormDiv" changeTagAttr="true">
			<jsp:include page="../subPages/assured/assuredType.jsp"></jsp:include>
			<jsp:include page="../subPages/assured/vatType.jsp"></jsp:include>
			<jsp:include page="../subPages/assured/basicInformation.jsp"></jsp:include>
			<jsp:include page="../subPages/assured/addressAndContact.jsp"></jsp:include>
			<jsp:include page="../subPages/assured/otherInformation.jsp"></jsp:include>
		</div>
	</form>
	<div class="buttonsDiv">		
		<input type="button" class="button" id="btnDefaultIntermediary" name="btnDefaultIntermediary" value="Default Intermediary" tabindex="33" />
		<input type="button" class="button" id="btnIndividualInformation" name="btnIndividualInformation" value="Individual Information" tabindex="34"/>
		<input type="button" class="button" id="btnGroupInformation" name="btnGroupInformation" value="Group Information" tabindex="35" />
		<input type="button" class="button" id="btnCancelAssured" name="btnCancelAssured" value="Cancel" tabindex="36" />
		<input type="button" class="button" id="btnSaveAssured" name="btnSaveAssured" value="Save" tabindex="37" />
	</div>
</div>

<script type="text/javascript" defer="defer">
	initializeAll();
	makeInputFieldUpperCase();
	oldFormContent = Form.serialize("assuredMaintenanceForm");
	setModuleId("GIISS006B");
	setDocumentTitle("Maintain Assured");
	
	//added enchancement - irwin, 11.20.2012
	var objAssdParams = {};
	objAssdParams.requireAssdBirthmonth = '${requireAssdBirthmonth}';
	objAssdParams.requireAssdBirthdate = '${requireAssdBirthdate}';
	objAssdParams.requireAssdBirthyear = '${requireAssdBirthyear}';
	objAssdParams.requireAssdEmail = '${requireAssdEmail}';
	objAssdParams.requireAssdContactno = '${requireAssdContactno}';
	objAssdParams.requireAssdFieldsOptional = '${requireAssdFieldsOptional}';
	objAssdParams.defaultAssdControlType = '${defaultAssdControlType}';
	objAssdParams.systemYear = parseInt('${systemYear}');
	objAssdParams.requireDfltIntmPerAssd = '${requireDfltIntmPerAssd}'; //benjo 09.07.2016 SR-5604
	
	var saveCtr = 0; //Patrick  02.20.2012
	var toggleLogout = false; //Kenneth L. 05.07.2014
	
	if(assuredMaintainExitCtr==1){
		//$("assuredMaintenanceMenu").hide();
		assuredMaintainExitCtr = 3;
		assuredMaintainGimmExitCtr = 2;
	}
 
	// added by andrew - 03.02.2011
	if($F("hidViewOnly") == "true"){
		disableFields();
	}

	function disableFields(){
		try {
			$$("input[type='text']").each(function(input){
				input.writeAttribute("readonly");
			});
			$$("input[type='radio']").each(function(radio){
				radio.disable();
			});
			$$("select").each(function(select){ // Nica 06.20.2012
				select.disable();
			});
			
			$("editRemarks").stopObserving("click");
			
			$("editRemarks").observe("click", function () {
				showEditor("remarks", 4000, 'true');
			});

			$("remarks").writeAttribute("readonly");
			$("activeTag").disable();
			$("industry").disable();
			$("controlType").disable();
			//$("btnSaveAssured").disable(); // by Bonok: testcase 01.04.2012
			disableButton("btnSaveAssured");

			//disableButton("addNo");
			//disableButton("btnSaveAssured");
		} catch (e) {
			showErrorMessage("disableFields", e);
		}
	}
	//end andrew
	/*if (Object.isUndefined($("parCreationMainDiv"))){
		$("btnCancelAssured").hide();
	}*/

	/* $("reloadForm").observe("click", function () {
		//showMaintainAssuredForm($F("generatedAssuredNo")); // comment out by andrew - 03.02.2011
		maintainAssured("assuredListingMainDiv", $F("generatedAssuredNo"), 'true'); // andrew - 03.02.2011
	}); */ // comment out by robert - 07.08.2011

	$("reloadForm").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					function(){
						//maintainAssured("assuredListingMainDiv", "");
						changeTag = 0; // Patrick 02.20.2012
						//updateMainContentsDiv("/GIISAssuredController?action=maintainAssured&assuredNo="+$F("generatedAssuredNo")+"&divToShow=assuredListingMainDiv",
						//		"Creating assured form, please wait..."); replaced by: Nica 06.20.2012
						var showCreateNew = nvl(saveCtr, 0) == 1 ? true : false;
						maintainAssuredTG("assuredListingTGMainDiv", $F("generatedAssuredNo"), $("hidViewOnly").value, showCreateNew); // added by: Nica 06.20.2012
					}, "");
		} else {
			//maintainAssured("assuredListingMainDiv", "");
			//updateMainContentsDiv("/GIISAssuredController?action=maintainAssured&assuredNo="+$F("generatedAssuredNo")+"&divToShow=assuredListingMainDiv",
			//		"Creating assured form, please wait...");
			maintainAssuredTG("assuredListingTGMainDiv", $F("generatedAssuredNo"), $("hidViewOnly").value); // added by: Nica 06.20.2012
		}
	}); // robert - 07.08.2011
 
	//observeReloadForm("reloadForm", maintainAssuredTG("assuredListingTGMainDiv"));
	
/* 	 $("addNo").observe("click", function () {
		var newRow = new Element("div");
		var ctt = new Element("select");
		ctt.writeAttribute("name", "contactNoType");
		ctt.setStyle("width: 218px;");
		ctt.update($("contactNoType").innerHTML);
		addStyleToNewElement(ctt);

		ctt.observe("change", function () {
			var i = ctt.options[ctt.selectedIndex].text.indexOf(" ");
			if ($((ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize()) != null) {
				showMessageBox("Contact number type already exists!");
				ctt.selectedIndex = 0;
				ctt.next("input", 0).removeAttribute("id");
				ctt.next("input", 0).removeAttribute("name");
				return false;
			} else {
				ctt.next("input", 0).writeAttribute("id", (ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize());
				ctt.next("input", 0).writeAttribute("name", (ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize());
			}
		});
 	
		var newNumber = new Element("input");
		newNumber.writeAttribute("type", "text");
		newNumber.writeAttribute("maxlength", "40");
		newNumber.setStyle("width: 210px; margin-left: 4px;");
		addStyleToNewElement(newNumber);

		var newDelete = new Element("input");
		newDelete.writeAttribute("type", "button");
		newDelete.addClassName("button");
		newDelete.writeAttribute("value", "Delete");
		newDelete.setStyle("margin-left: 3px; margin-bottom: 5px;");
		newDelete.observe("click", function () {
			newNumber.up("div", 0).remove();
		});
		
		newRow.appendChild(ctt);
		newRow.appendChild(newNumber);
		newRow.appendChild(newDelete);
		
		$("contactNumbers").insert({bottom: newRow});
	}); */
	
	$("btnSaveAssured").observe("click", function () {
		toggleLogout = false; //Kenneth L. 05.07.2014
		/*newFormContent = Form.serialize("assuredMaintenanceForm");
		if (oldFormContent != newFormContent) {
			showConfirmBox("Save changes message", "Do you want to save changes you've made?", "Yes", "No", aa, ab);
			return false;
		}*/
		//checks if billing address is empty, if true, copies inserted mail address
		if(changeTag == 1){
			/* commented out by reymon 03042013
			** not needed since reference code was already cleared during validation
			if (refCdExisting == "Y"){
				showMessageBox("This Reference Number/Code Already Exists.", imgMessage.INFO);
			}*/
			if ($F("billAddress1") == ""){
				$("billAddress1").value = $F("mailAddress1");
			}
			if ($F("billAddress2") == ""){
				$("billAddress2").value = $F("mailAddress2");
			}
			if ($F("billAddress3") == ""){
				$("billAddress3").value = $F("mailAddress3");
			}
			//If TIN No. is null, display maintained DEFAULT_REASON in GIIS_PARAMETERS in No TIN Reason field. 
			if ($F("tinNo") == "" && $F("noTINReason") == ""){
				$("noTINReason").value = '${defaultReason}';
			}
			if ($("selectedAssuredType").innerHTML == "Individual" && ($F("firstName").blank() || $F("lastName").blank())) { //added this condition to allow saving on corporate
				customShowMessageBox("Required fields must be entered", imgMessage.ERROR, $F("firstName").blank() ? "firstName" : "lastName");
				return false;
			}else if ($F("assuredNameMaint").blank() || $F("industry").blank() || $F("controlType").blank() || $F("mailAddress1").blank()) {
				//marco - 07.08.2014
				var field = null;
				$w("assuredNameMaint industry controlType mailAddress1").each(function(e){
					if($F(e).blank() && field == null){
						field = e;
					}
				});
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, field);
				return false;
			} else{
				// enhancement - irwin 11.20.2012
				if(nvl(objAssdParams.requireAssdFieldsOptional,"") != ""){
					//var fields = {"phoneNo",""}
					var fieldIds = [];
					$$(".mandatoryEnchancement").each(function (f) {
						if(f.hasClassName("required")){
							fieldIds.push(f.id);
						}
					});
					var text = "";
					var firstId = "";
					for ( var i = 0; i < fieldIds.length; i++) {
						if($F(fieldIds[i]) == ""){
							if (firstId == ""){ // get the idea of the first null mandatory id
								firstId = fieldIds[i];
							}
							
							//marco - added conditions for corporate type
							if($("personal").checked){
								text += (text == "" ? "" : ", ") + $(fieldIds[i]).getAttribute("lbl");
							}else{
								if($(fieldIds[i]).getAttribute("lbl") == "Birth Month" ||
									$(fieldIds[i]).getAttribute("lbl") == "Birth Date" ||
									$(fieldIds[i]).getAttribute("lbl") == "Birth Year"){
									
									if($("corporate").checked){
										if(!text.include("Date of Incorporation")){
											text += (text == "" ? "" : ", ") + "Date of Incorporation";
										}
									}else if($("joint").checked){
										if(!text.include("Birthdate/Date of Incorporation")){
											text += (text == "" ? "" : ", ") + "Birthdate/Date of Incorporation";
										}
									}
								}else{
									text += (text == "" ? "" : ", ") + $(fieldIds[i]).getAttribute("lbl");
								}
							}
						}
					}
					
					checkBirthDateSysdate();  //moved by christian 01042013
					if(text !="" && objAssdParams.requireAssdFieldsOptional == "Y"){
						showConfirmBox("Confirmation", "There are missing information ("+text+").  Do you wish to continue saving the record?", "Yes", "No",
								function(){saveAssured("Y");}, function(){
									$(firstId).focus();
								});
					}else if(text !=""  && objAssdParams.requireAssdFieldsOptional == "N"){
						showWaitingMessageBox("There are missing information ("+text+"). Please provide necessary information needed.","I",function(){$(firstId).focus();});
					}else{
						if(checkBirthDateSysdate()){  // marco - 12.11.2012 - temp solution
							saveAssured("Y");
						}
					}
				}else{
					if(checkBirthDateSysdate()){  // marco - 12.11.2012 - temp solution
						saveAssured("Y");
					}	
				}
				
				//changeTag = 0;
				/* if (checkIfAssuredIsExisting() && $F("assuredNo") == ""){
					var message = "";
					if ($("selectedAssuredType").innerHTML != "Individual"){
						message = 'Assured is already existing. Do you want to create a new record?';
					} else {
						message = 'Assured with the same first name and last name already exists. Do you want to continue?';
					}
					showConfirmBox('ASSURED', message,
							"Yes", "No",
							showCommonAssured, "");
				} else {
					saveAssured();
				} */
			}
		} else {
			//showMessageBox(objCommonMessage.NO_CHANGES,imgMessage.INFO);
			customShowMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO, "assuredNameMaint"); //Kenneth L. 05.07.2014
		}
		 
	});
	
	function checkBirthDateSysdate(){ // marco - added - 12.11.2012
		var sysdate = new Date();
		var date = Date.parse($F("birthmonth")+"-"+$F("birthDate")+"-"+$F("birthYear"));
		//if(date2 > sysdate.toString("MM-dd-yyyy")){ modified by christian 01042012
		if($F("birthmonth") != "" && $F("birthDate") != "" & $F("birthYear") != ""){ // marco - 01.28.2013
			if(compareDatesIgnoreTime(date, sysdate) == -1){
				if($("personal").checked){
					showMessageBox("Birthdate cannot be later than current date.", "I");
				}else if($("corporate").checked){
					showMessageBox("Date of Incorporation cannot be later than current date.", "I");
				}else if($("joint").checked){
					showMessageBox("Birthdate/Date of Incorporation cannot be later than current date.", "I");
				}
				return false;
			}else{
				return true;
			}
		}else if($F("birthmonth") != "" && $F("birthYear") != ""){
			if(getMonthYear(sysdate) < getMonthYear(date)){
				if($("personal").checked){
					showMessageBox("Birthdate cannot be later than current date.", "I");
				}else if($("corporate").checked){
					showMessageBox("Date of Incorporation cannot be later than current date.", "I");
				}else if($("joint").checked){
					showMessageBox("Birthdate/Date of Incorporation cannot be later than current date.", "I");
				}
				return false;
			}else{
				return true;
			}
		}
		return true;
	}
		
	function getMonthYear(date){
		date.setHours(0);
		date.setMinutes(0);
		date.setSeconds(0);
		date.setMilliseconds(0);
		date.setDate(01);
		return date;
	}
	
	function saveAssured(refresh){ //refresh parameters added by: Nica 06.20.2012
		new Ajax.Request(contextPath+"/GIISAssuredController?action=saveAssured", {
			method: "POST",
			postBody: Form.serialize("assuredMaintenanceForm"),
			evalScripts: true,
			asynchronous: true,
			onCreate: function () {
				$("assuredMaintenanceForm").disable();
				showNotice("Saving assured, please wait...");
			},
			onComplete: function (response) {
				if (checkErrorOnResponse(response)) {
					objUW.hidObjGIISS006B.modifySw = "Y"; //marco - 07.09.2014
					/* benjo 09.07.2016 SR-5604 */
					/*if(toggleLogout){ //Kenneth L. 05.07.2014
						showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
					}else{
						customShowMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, "smoothmenu1");
					}*/
					if(refresh == "N"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){checkDfltIntm("Y")});
					}else{
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){checkDfltIntm("N")});
					}
					/* end SR-5604 */
					changeTag = 0; //
					buttonCtr = 1; //
					saveCtr = 1; // Patrick 02.20.2012
					var showCreateNew = nvl($("assuredNo").value, 0) == 0 ? true : false;
					hideNotice(response.responseText.split(",")[0]);
					$("generatedAssuredNo").value = formatNumberDigits(response.responseText.split(",")[1], 12);
					$("assuredMaintenanceForm").enable();
					$("assuredNo").value = response.responseText.split(",")[1];
					//$("assuredName").value = response.responseText.split(",")[2];
					$("personal").disable(); // added by grace to disable corporate_tag after saving - 05.05.11 
					$("corporate").disable(); // added by grace to disable corporate_tag after saving - 05.05.11
					$("joint").disable(); // added by grace to disable corporate_tag after saving - 05.05.11
					//Effect.Appear($F("divToShow"), {duration: .3});	// <== mark jm 04.15.2011 @UCPBGEN
					//Effect.Fade("assuredDiv", {duration: .3}); // <== mark jm 04.15.2011 @UCPBGEN
					//showAssuredListing(); // comment out by andrew - 04.29.2011
					/* updateMainContentsDiv("/GIISAssuredController?action=maintainAssured&assuredNo="+$F("generatedAssuredNo")+"&divToShow=assuredListingMainDiv",
					"Creating assured form, please wait..."); */ // Patrick
					if(refresh == "Y"){ // added by: Nica 06.20.2012
						maintainAssuredTG("assuredListingTGMainDiv", $F("generatedAssuredNo"), $("hidViewOnly").value, showCreateNew); // added by: Nica 06.20.2012
					}
					lastAction(); //Patrick 02.15.2012
					lastAction = "";
				}
			}
		});
	}

	function showCommonAssured(){
		Modalbox.show(contextPath+"/GIISAssuredController?action=showSameAssuredName&ajaxModal=1",
				{title: 'Assured',
				width: 800});
		Modalbox.resizeToContent();
	} 
	
	var moduleId = "GIISS006B"; // andrew - 05.11.2011 - there is no 'GIIS006D' module
	var mgrSw = '${mgrSw}';
	
	/*
	observeAccessibleModule2(accessType.BUTTON, "", "btnDefaultIntermediary", function() {
	//$("btnDefaultIntermediary").observe("click", function () {
		//var moduleId = "GIISS006D"; //added this to display line codes
		var moduleId = "GIISS006B"; // andrew - 05.11.2011 - there is no 'GIIS006D' module
		var mgrSw = '${mgrSw}';
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
			//changeTag = 1;
			//return false;
		} else if(mgrSw == 'N') {
			showMessageBox("You are not allowed to access default intermediary...see your DBA or any MIS personnel for authority.", imgMessage.INFO);
			return false;
		} else {
			Modalbox.show(contextPath+'/GIISAssuredController?action=showDefaultIntermediaryPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1&moduleId='+moduleId, {
				//title: 'Default Intermediary Information',
				title: 'Line',
				width: 500
			});
			Modalbox.resizeToContent();
		}
	});*/
	
	 $("btnDefaultIntermediary").observe("click", function(){
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
		} else if(mgrSw == 'N' && nvl(objAssdParams.requireDfltIntmPerAssd,"N") == "N") { //benjo 09.07.2016 SR-5604
			showMessageBox("You are not allowed to access default intermediary...see your DBA or any MIS personnel for authority.", imgMessage.INFO);
		}else{
			if(changeTag == 1){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			}else{
				/* Modalbox.show(contextPath+'/GIISAssuredController?action=showDefaultIntermediaryPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1&moduleId='+moduleId, {
					title: 'Default Intermediary Information',
					width: 500
				});
				Modalbox.resizeToContent(); */
				
				//marco - 07.09.2014
				defaultIntmOverlay = Overlay.show(contextPath+"/GIISAssuredController", {
					urlParameters: {
						action: "showDefaultIntermediaryPage",
						assdNo: $F("generatedAssuredNo"),
						moduleId: moduleId
					},
					urlContent : true,
					draggable: true,
				    title: "Default Intermediary Information",
				    height: 250,
				    width: 450
				});
			}
			
		}
	}); 
	
	function showDefaultIntermediaryPage(){
		
		Modalbox.show(contextPath+'/GIISAssuredController?action=showDefaultIntermediaryPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1&moduleId='+moduleId, {
			title: 'Line',
			width: 500
		});
		Modalbox.resizeToContent();
	}

	/* $("btnIndividualInformation").observe("click", function () {
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
			return false;
		} else {
			var aName = $F("assdName").blank() ? $F("lastName") + ", " + $F("firstName") : $F("assdName");
			Effect.ScrollTo('notice', {duration: .2}); 
			Modalbox.show(contextPath+'/GIISAssuredController?action=showIndividualInformationPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1&assuredName='+aName, {
				//title: 'Individual Information', Title should be Personal Information.
				title: 'Personal Information',
				width: 650
			});
			Modalbox.resizeToContent();
		}
	});  */
	
	//observeAccessibleModule2(accessType.BUTTON, "", "btnIndividualInformation", function(){
	$("btnIndividualInformation").observe("click", function () {
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
			return false;
		} else {
			var aName = $F("assdName").blank() ? $F("lastName") + ", " + $F("firstName") : $F("assdName");
			//Effect.ScrollTo('notice', {duration: .2});
			/*Modalbox.show(contextPath+'/GIISAssuredController?action=showIndividualInformationPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1&assuredName='+aName, {
				//title: 'Individual Information', Title should be Personal Information.
				title: 'Personal Information',
				width: 650
			});*/// replaced by: Nica 1.10.2013
			
			/* Modalbox.show(contextPath+'/GIISAssuredController?ajaxModal=1', {
				title: 'Personal Information',
				width: 650,
				params:{
					action: "showIndividualInformationPage",
					assdNo: $F("generatedAssuredNo"),
					assuredName: escapeHTML2(aName) //added escapeHTML2 by reymon 02152013
				}
			});
			Modalbox.resizeToContent(); */
			
			//marco - 07.09.2014
			individualInfoOverlay = Overlay.show(contextPath+"/GIISAssuredController", {
				urlParameters: {
					action: "showIndividualInformationPage",
					assdNo: $F("generatedAssuredNo"),
					assuredName: escapeHTML2(aName)
				},
				urlContent : true,
				draggable: true,
			    title: "Personal Information",
			    height: 500,
			    width: 640
			});
		}
	});
	/* $("btnGroupInformation").observe("click", function () {
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
			return false;
		} else {
			Modalbox.show(contextPath+'/GIISAssuredController?action=showGroupInformationPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1', {
				//title: 'Group Information',  Label shold be Group
				title: 'Group',
				width: 700
			});
			Modalbox.resizeToContent();
		} 
	}); */ //Patrick
	
	//observeAccessibleModule2(accessType.BUTTON, "", "btnGroupInformation", function(){ //PATRICK
	$("btnGroupInformation").observe("click", function () {
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		if ($F("generatedAssuredNo").blank()) {
			showMessageBox("No assured information yet.", imgMessage.WARNING);
			return false;
		} else {
			/* Modalbox.show(contextPath+'/GIISAssuredController?action=showGroupInformationPage&assdNo='+$F("generatedAssuredNo")+'&ajaxModal=1', {
				//title: 'Group Information',  Label shold be Group
				title: 'Group Information',
				width: 700,
				overlayClose: false,
				headerClose: false
			});
			Modalbox.resizeToContent(); */
			
			//marco - 07.09.2014
			groupInfoOverlay = Overlay.show(contextPath+"/GIISAssuredController", {
				urlParameters: {
					action: "showGroupInformationPage",
					assdNo: $F("generatedAssuredNo"),
					moduleId: moduleId
				},
				urlContent : true,
				draggable: true,
			    title: "Group Information",
			    height: 250,
			    width: 580
			});
		}
	});
	
	/* $("btnCancelAssured").observe("click", function(){
		Effect.Appear($F("divToShow"), {duration: .3});
		Effect.Fade("assuredDiv", {duration: .3});
	});  */ // --robert - 07.08.2011
	
	$("btnCancelAssured").observe("click", function(){
		toggleLogout = false; //Kenneth L. 05.07.2014
		if(changeTag == 1 && parentAssuredDisable == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", saveAndExitAssdMain, exitAssdMain, "");
		} else {
			exitAssdMain();
		}
	}); // ++robert - 07.08.2011
	
	$("assuredMaintenanceForm").focusFirstElement();

	$$("select[name='contactNoType']").each(function (ctt) {
		ctt.observe("change", function () {
			var i = ctt.options[ctt.selectedIndex].text.indexOf(" ");
			if ($((ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize()) != null) {
				showMessageBox("Contact number type already exists!", imgMessage.ERROR);
				ctt.selectedIndex = 0;
				ctt.next("input", 0).removeAttribute("id");
				ctt.next("input", 0).removeAttribute("name");
				return false;
			} else {
				ctt.next("input", 0).writeAttribute("id", (ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize());
				ctt.next("input", 0).writeAttribute("name", (ctt.options[ctt.selectedIndex].text.substring(0, 1).toLowerCase()+ctt.options[ctt.selectedIndex].text.substring(1, i)+"-No").camelize());
			}
		});
	});

	/*
	if (modules.all(function (mod) {return mod != 'GIISS006D';})) {
		$("btnDefaultIntermediary").hide();
	}

	if (modules.all(function (mod) {return mod != 'GIISS006C';})) {
		$("btnIndividualInformation").hide();
	}
	
	if (modules.all(function (mod) {return mod != 'GIISS006E';})) {
		$("btnGroupInformation").hide();
	}*/

	$("remarks").setStyle("border: none; margin: 0;");
	//$("remarks").up("div", 0).setStyle("float: left; border: 1px solid gray; padding: 0; background-color: #fff;"); - removed. causing problems in createPackPar- irwin
	//$("remarks").up("div", 0).next().setStyle("margin-left: 5px;");
	
	//$("assuredMaintenanceExit").observe("click",  showAssuredListing); // --robert - 07.08.2011
		
	function exitAssdMain(){
		//Effect.Appear($F("divToShow"), {duration: .3});
		//Effect.Fade("assuredDiv", {duration: .3});
		showAssuredListingTableGrid();
	}; // ++robert - 07.08.2011
	
	function saveAndExitAssdMain(){
		if (checkAllRequiredFieldsInDiv("assuredMaintenanceFormDiv") && checkBirthDateSysdate()){ //Kenneth L. 05.07.2014
			saveAssured("N"); //benjo 09.07.2016 SR-5604
			//exitAssdMain(); //benjo 09.07.2016 SR-5604
			changeTag = 0;
		}
	};// ++robert - 07.08.2011
	
	$("assuredMaintenanceExit").observe("click", function(){
		toggleLogout = false; //Kenneth L. 05.07.2014
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){ 
																									parentAssuredDisable = 1;
																									saveAndExitAssdMain();
																									//changeTag = 0; //Kenneth L. 05.07.2014
																								  }, function() {
																									   parentAssuredDisable = 1;
																									   exitAssdMain();
																									   changeTag = 0;
																								  }, "");
		} else {
			parentAssuredDisable = 1;
			exitAssdMain();
		}
	});// ++robert - 07.08.2011
	
	 //Added by grace 05.05.2011
	$("assuredMaintenanceAdd").observe("click", function () {
		//maintainAssured("assuredListingMainDiv", "");
		/* commented out by reymon 03052013
		updateMainContentsDiv("/GIISAssuredController?action=maintainAssured&assuredNo=&divToShow=assuredListingMainDiv",
		"Creating assured form, please wait...");*/
		maintainAssuredTG("assuredListingTGMainDiv", ""); //added reymon 03052013
	}); 
	
	$("industry").observe("change", function (event) {
		//if($("selectedAssuredType").innerHTML == 'Corporate' && $F("industry") == 28) { //marco - 11.29.2012 - modified condition
		if($("selectedAssuredType").innerHTML == 'Corporate' && $("industry").options[$("industry").selectedIndex].innerHTML == "INDIVIDUAL") {
			showWaitingMessageBox("Record has been tagged as Corporate. Individual entry is not possible.", imgMessage.INFO, function(){
				$("industry").selectedIndex = 0;
			});
		}
	}); // ++robert - 07.13.2011
	
	$("referenceCode").observe("change", function (event) {
		if($F("referenceCode") != ""){
			checkRefCd(this.value);
		}else{
			refCdExisting = "N";
		}
	}); 
	
	var refCdExisting = "N";
	function checkRefCd(refCd){
		new Ajax.Request(contextPath+"/GIISAssuredController", {
			method: "POST",
			parameters: {action : $F("generatedAssuredNo") == "" ? "checkRefCd" : "checkRefCd2",
								refCd : refCd,
								assdNo: $F("generatedAssuredNo")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var msg = response.responseText;
					if (msg != ""){
						showMessageBox(msg, imgMessage.INFO);
						//refCdExisting = "Y"; commented out by reymon 03042013
						$("referenceCode").value = ""; //added by reymon 03042013 to clear reference code
					}else{
						refCdExisting = "N";
					}
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function observeGoToModule2(id, func){ //Patrick - recreated so that changeTag will not be changed when you choose the "No" option - 02.20.2012
		$(id).stopObserving("click");
		$(id).observe("click", function () {
			if(changeTag == 1) {
				if (changeTagFunc == null || changeTagFunc == undefined || changeTagFunc == ""){
					func(); 
				}else{
					showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
							function(){
								changeTagFunc(); 
								lastAction = func;
								if (changeTag == 0){
									changeTagFunc = "";
									func();
								}
							}, 
							function(){
								func();
							}, 
							"");
				}	
			}else{
				func(); 
			}
		});		
	}
	
	function observeAccessibleModule2(type, moduleId, elementId, func){ // Patric 02.20.2012
		try{
			if(checkUserModule(moduleId)){
				if (func != "" && func != null){
					if (accessType.ROW == type) {
						$(elementId).observe("dblclick", func);
					} else {
						if (accessType.SUBPAGE == type) {
							func();
							return;
						}	
						observeGoToModule2(elementId, func);
					}
				}
			}  else {		
				switch(type) {
					case accessType.MENU: 
						disableMenu(elementId);
						break;
					case accessType.BUTTON:
						disableButton(elementId);
						break;
					case accessType.SUBPAGE:
						disableSubpage(elementId);
						break;
					case accessType.TOOLBUTTON:
						disableToolButton(elementId);
						break;
					case accessType.TAB:
						disableTab(elementId);
						$(elementId+"Disabled").title = objCommonMessage.NO_MODULE_ACCESS;
						break;
				} 
			} 
		} catch (e) {
			showErrorMessage("observeAccessibleModule2", e);
		}
	}
	
	// enchancement modification - irwin - 11.20.2012
	function populateYear(){
		try{
			
			var startYear = parseInt(1899); //marco - 06.03.2015 - GENQA SR 4528 - from UCPB 16606
			var body = "<option></option>";
			for ( var i = 0; i < (objAssdParams.systemYear - startYear); i++) {
				body += "<option value="+(objAssdParams.systemYear - i)+">"+ (objAssdParams.systemYear - i) + "</option>"; 
			}
			$("birthYear").update(body);
			
		}catch(e){  
			showErrorMessage("populateYear");
		}
	}
	
	function populateBirthDate(){
		try{
			var tempDate = $("birthDate").value; // marco - 12.11.2012 - temp solution
			
			$("birthDate").value = "";
			var days = parseInt(31);
			var year = $F("birthYear");
			if($F("birthmonth") == "April" || $F("birthmonth") == "June" || $F("birthmonth") == "September"
				|| $F("birthmonth") == "November" 	
				){
				
				days = 30;
					
			}else if($F("birthmonth") == "February"){
				days = 28;
				if(year != ""){
					year = parseInt(year);	
					if((year % 400) == 0 || (((year % 4) == 0) && ((year % 100) != 0))){ // if leap year
						days = 29;
					}	
				}
				
			}
			var body = "<option></option>";
			for ( var i = days - 1; i >= 0 ; i--) {
				body += "<option>"+ (days - i) + "</option>"; 
			}
			$("birthDate").update(body);
			$("birthDate").value = tempDate; // marco - 12.11.2012 - temp solution
		}catch(e){  
			showErrorMessage("populateBirthDate");
		}
	}
	
	$("birthmonth").observe("change", populateBirthDate);
	$("birthYear").observe("change", populateBirthDate);
	
	$("emailAddress").observe("change", function(){
		if ($F("emailAddress") != "" && !validateEmail($F("emailAddress"))) {
			$("emailAddress").value = "";		
			showMessageBox("Invalid email address.", imgMessage.ERROR);
			return false;
		} 
	});
	
	$("tinNo").observe("change", function(){
		if($F("tinNo") == ""){
			$("noTINReason").addClassName("required");
			$("noTINReason").setAttribute("lbl","No TIN Reason");
			enableInputField("noTINReason");	//marco - 07.08.2014
		}else{
			$("noTINReason").value = "";		//
			disableInputField("noTINReason");	//
			$("noTINReason").removeClassName("required");
		}
	});
	
	
	if(nvl(objAssdParams.requireAssdBirthmonth,"N") == "Y"){
		$("birthmonth").addClassName("required");
		$("birthmonth").setAttribute("lbl","Birth Month");
	}
	if(nvl(objAssdParams.requireAssdBirthdate,"N") == "Y"){
		$("birthDate").addClassName("required");
		$("birthDate").setAttribute("lbl","Birth Date");
	}
	if(nvl(objAssdParams.requireAssdBirthyear,"N") == "Y"){
		$("birthYear").addClassName("required");
		$("birthYear").setAttribute("lbl","Birth Year");
	}
	if(nvl(objAssdParams.requireAssdEmail,"N") == "Y"){
		$("emailAddress").addClassName("required");
		$("emailAddress").setAttribute("lbl","Email Address");
	}
	if(nvl(objAssdParams.requireAssdContactno,"N") == "Y"){
		$("phoneNo").addClassName("required");
		$("phoneNo").setAttribute("lbl","Contact Number");
	}
	if(nvl($F("assuredNo"),"") == ""){
		$("controlType").value = objAssdParams.defaultAssdControlType;
	}
	if(nvl($F("tinNo"),"") == ""){
		$("noTINReason").addClassName("required");
		$("noTINReason").setAttribute("lbl","No TIN Reason");
	}
	if(nvl(objAssdParams.requireDfltIntmPerAssd,"N") == "Y" && nvl($F("assuredNo"), "") != ""){ //benjo 09.07.2016 SR-5604
		checkDfltIntm("N");
	}
	
	//benjo 09.07.2016 SR-5604
	function checkDfltIntm(exitSw){
		if(nvl($F("hidViewOnly"),"false") != "true"){ //benjo 03.07.2017 SR-5893
			new Ajax.Request(contextPath+"/GIISAssuredController", {
				method: "POST",
				parameters: {action: "checkDfltIntm",
					         assdNo: $F("assuredNo"),
					         moduleId: moduleId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText=="SUCCESS"){
							if(exitSw=="Y"){
								exitAssdMain();
							}
						}else{
							showWaitingMessageBox(response.responseText, imgMessage.INFO, function(){
								defaultIntmOverlay = Overlay.show(contextPath+"/GIISAssuredController", {
									urlParameters: {
										action: "showDefaultIntermediaryPage",
										assdNo: $F("generatedAssuredNo"),
										moduleId: moduleId
									},
									urlContent : true,
									draggable: true,
								    title: "Default Intermediary Information",
								    height: 250,
								    width: 450
								});
							});
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});	
		}else{
			if(exitSw=="Y"){
				exitAssdMain();
			}
		}
	}
	
	// end of enhancement
	// ++robert - 07.08.2011
	//changeTag = 0;
	
	function onLogout(){	//Kenneth L. 05.07.2014
		if (checkAllRequiredFieldsInDiv("assuredMaintenanceFormDiv")){
			saveAssured();
		}
	}
	
	$("logout").observe("click", function(){
		toggleLogout = true;
	});
	
	initializeChangeTagBehavior(onLogout); //Kenneth L. 05.07.2014
	initializeChangeAttribute();
	initializeAccordion();
	
	populateYear();
	// populate year first then if this is not a new record, populate the values for month and year, then populate default values for birthDate then the value from assured.
	// this arrangement can't be change
	if(nvl($F("assuredNo"),"") != ""){
		$("birthYear").value = "${assured.birthYear}";
		$("birthmonth").value = "${assured.birthMonth}";
	}
	populateBirthDate();
	
	// after populate default date values, set value from assured
	
	if(nvl($F("assuredNo"),"") != ""){
		$("birthDate").value = "${assured.birthDate}";
	}
</script>