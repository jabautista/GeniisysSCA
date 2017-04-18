<!-- Remarks: For deletion
Date : 03-20-2012
Developer: Steven P. Ramirez
Replacement : /pages/marketing/quotation/subPages/quotationCarrierInfoTableGrid.jsp
 -->
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" style="width: 100%; margin-bottom: 1px;" name="outerDiv">
	<div id="innerDiv" >
   		<label>Quotation Information</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label id="hideForm" name="hideForm" style="margin-left: 5px;">Hide</label>
	   		<label id="reloadForm" name="reloadForm">Reload Form</label>
   		</span>
   	</div>
</div>

<div id="carrierInfoMainDiv" name="carrierInfoMainDiv" style="margin-top: 1px; display: none;">
	<form id="carrierInfoMainForm" name="carrierInfoMainForm">
		<input type="hidden" id="lineCd" value="MH"/>
		<input type="hidden" id="lineName" value=""/>
		<input type="hidden" name="quoteId"  	id="quoteId" 	value="${gipiQuote.quoteId}" />
		<div id="carDiv" name="carDiv" class="sectionDiv">
			<div id="quoteInfo" name="quoteInfo" style="margin: 10px;">
				<table align="center">
					<tr>
						<td class="rightAligned">Quotation No. </td>
						<td class="leftAligned"><input type="text" style="width: 250px;" id="quoteNo" name="quoteNo" readonly="readonly" value="${gipiQuote.quoteNo}" />
						<td class="rightAligned">Assured Name </td>
						<td class="leftAligned">
							<input type="text" style="width: 250px;" id="assuredName" name="assuredName" readonly="readonly" value="${gipiQuote.assdName}" />
							<input type="hidden" id="assuredNo" name="assuredNo" value="${gipiQuote.assdNo}" />
						</td>	
					</tr>
				</table>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Carrier Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
		
				
		<div id="carrierInfoDivAndFormDiv" name="carrierInfoDivAndFormDiv" class="sectionDiv"  align="center">
			<div id="carrierInfoDiv" name="carrierInfoDiv" style="margin: 10px; width: 600px;">
				<div class="tableHeader" id="carrierInfoTable" name="carrierInfoTable">
					<label style="width: 430px; text-align: left; margin-left: 5px;">Carrier/Conveyance</label>
					<label style="width: 130px; text-align: left; margin-left: 5px;">Vessel Flag</label>
				</div>
				<div id="forDeleteDiv" name="forDeleteDiv" style="visibility: hidden;">
				</div>
				<div id="forInsertDiv" name="forInsertDiv" style="visibility: hidden;">
				</div>
				<div class="tableContainer" id="carrierInfoList" name="carrierInfoList">
					<c:forEach var="carrier" items="${carriers}">
						<div id="carrier${fn:replace(carrier.vesselCd, ' ', '_')}" name="rowCarrier" class="tableRow">
							<input type="hidden" id="vesselCd${fn:replace(carrier.vesselCd, ' ', '_')}"   	name="vesselCd"     value="${fn:replace(carrier.vesselCd, ' ', '_')}" />
							<input type="hidden" id="vesselName${fn:replace(carrier.vesselCd, ' ', '_')}" 	name="vesselName" 	value="${carrier.vesselName}" />
							<input type="hidden" id="vesselFlag${fn:replace(carrier.vesselCd, ' ', '_')}" 	name="vesselFlag"	value="${carrier.vesselFlag}" />
							<input type="hidden" id="vesselType${fn:replace(carrier.vesselCd, ' ', '_')}" 	name="vesselType"	value="${carrier.vesselType}" />
							<input type="hidden" id="recFlag${fn:replace(carrier.vesselCd, ' ', '_')}"  		name="recFlag" 		value="${carrier.recFlag}" />
							<label style="width: 430px; text-align: left; margin-left: 5px;" title="${carrier.vesselName}" name="vesselName" id="vesselName${carrier.vesselCd}">${carrier.vesselName}</label>
							<label style="width: 130px; text-align: left; margin-left: 5px;" title="${carrier.vesselType}">${carrier.vesselType}</label>
					 	</div>
					</c:forEach>
				</div> 
			</div>
			
			<div id="carrierInfoFormDiv" name="carrierInfoFormDiv" style="width: 100%; margin: 10px 0px 5px 0px" changeTagAttr="true">
				<table align="center" width="50%">
					<tr>
						<td class="rightAligned" width="20%">Carrier/Conveyance</td>
						<td class="leftAligned" width="80%">
							<span class="required lovSpan" style="width: 220px;">
								<input id="hidVesFlag" name="hidVesFlag" type="hidden">
								<input id="inputVessel" name="inputVessel" type="text" readonly="readonly" style="border: none; float: left; width: 175px; height: 13px; margin: 0px;" class="required">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCarrierName" name="searchCarrierName" alt="Go" style="float: right;"/>
							</span>
							<!-- <input type="text" id="inputVesselDisplay" readonly="readonly" class="required" style="width: 100%; display: none;" /> -->	<!-- Patrick -->					
							<%-- <select id="inputVessel" name="inputVessel" style="width: 100%;" class="required">
								<option value=""></option>
								<optgroup label="Aircraft">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'A' eq vessel.vesselFlag}">
											<option value="${fn:replace(vessel.vesselCd, ' ', '_')}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>									
									</c:forEach>
								</optgroup>
								<optgroup label="Inland">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'I' eq vessel.vesselFlag}">
											<option value="${fn:replace(vessel.vesselCd, ' ', '_')}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>									
									</c:forEach>
								</optgroup>
								<optgroup label="Vessel">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'V' eq vessel.vesselFlag}">
											<option value="${fn:replace(vessel.vesselCd, ' ', '_')}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>
									</c:forEach>
								</optgroup>
							</select> --%>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Vessel Flag</td>
						<td class="leftAligned"><input type="text" id="inputVesselFlag" name="inputVesselFlag" style="width: 60%" readonly="readonly"/></td>
					</tr>
				</table>				
			</div>		
			<div style="margin-bottom: 10px;" changeTagAttr="true">
				<input type="button" class="button" style="width: 60px;" id="btnAdd" name="btnAdd" value="Add" />
				<input type="button" class="button" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="carrierInfoButtonsDiv">
			<input type="button" class="button" style="width: 130px;" id="btnMaintainVessel" name="btnMaintainVessel" value="Maintain Vessel Info" />
			<input type="button" class="button" style="width: 130px;" id="btnMaintainInland" name="btnMaintainInland" value="Maintain Inland Info" />
			<input type="button" class="button" style="width: 130px;" id="btnMaintainAircraft" name="btnMaintainAircraft" value="Maintain Aircraft Info" />
			<input type="button" class="button" style="width: 150px;" id="btnEditQuotation" name="btnEditQuotation" value="Edit Basic Quotation Info" />
			<input type="button" class="button" style="width: 70px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>
<script type="text/javascript">
    setModuleId("GIIMM009"); 
	var pageActions = {none: 0, save : 1, reload : 2, cancel : 3};
	var pAction = pageActions.none;
	//var parType = $("policyNo") == null ? "P" : "E"; 
	addStyleToInputs();
	initializeAll();
	//initializeTable("tableContainer", "rowCarrier", "", "");
	setDocumentTitle("Carrier Information");
	checkTableIfEmpty("rowCarrier", "carrierInfoDiv");
	checkIfToResizeTable("carrierInfoList", "rowCarrier");
	initializeAccordion();
	$("btnDelete").disable();
	//hideAddedCarriers();

	$("btnAdd").observe("click", addCarrier);
	$("btnDelete").observe("click", deleteCarrier);
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, imgMessage.INFO);
		} else {
			pAction = pageActions.save;
			saveQuoteCarrierInfo();
		}
	});
	
	$("reloadForm").observe("click", function () {
		if(changeTag > 0) {
			showConfirmBox("Reload Engineering Basic Info.", "Reloading form will disregard all changes. Proceed?", "Yes", "No", function(){
																																	showQuotationCarrierInfoPage();
																																	changeTag = 0;
																																	} , "");
		}else{
			showQuotationCarrierInfoPage();
			changeTag = 0;
		}	
	});
	
	$("hideForm").observe("click", function (){
		if ($("hideForm").innerHTML == "Show")  {
			$("carDiv").show();
			$("hideForm").innerHTML = "Hide";
		}else{
			$("hideForm").innerHTML = "Show";
			$("carDiv").hide();
		}
	});
	
	$("btnEditQuotation").observe("click", function(){
		editQuotation(contextPath+"/GIPIQuotationController?action=editQuotation&quoteId="+$F("quoteId")+"&ajax=1");
	});
	
	$("searchCarrierName").observe("click", function(){
		var notIn = "";
		var withPrevious = false;
		$$("div#rowCarrier div[name='row']").each(function(row){
			if(withPrevious) notIn += ",";
			notIn += "'"+row.down("input", 0).value+"'";
			withPrevious = true;
		});
		notIn = (notIn != "" ? "("+notIn+")" : "");
		getCarrierVesselLOV("" , notIn);		
	});
	
	/* $("inputVessel").observe("change", function (){
		var index = $("inputVessel").selectedIndex;
		toggleVessel(index);	
	}); */

/* 	$("inputVessel").observe("keypress", function (){
		var index = $("inputVessel").selectedIndex;
		toggleVessel(index);	
	}); */
	
	$$("div[name='rowCarrier']").each(function (row){
		loadRowMouseOverMouseOutObserver(row);
		
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			
			//book1
			if (row.hasClassName("selectedRow")){
				($$("div#carrierInfoList div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");				
				setCarrierInfoForm(true, row);
			} else {
				setCarrierInfoForm(false, null);
			} 
		});		
	});
	
	function saveAndReload(){
		pAction = pageActions.reload;
		saveQuoteCarrierInfo();
	}
	
	function saveAndCancel(){
		pAction = pageActions.cancel;
		saveQuoteCarrierInfo();
	}
	
/* 	function toggleVessel(index){
		$("inputVesselFlag").value = $("inputVessel").options[index].getAttribute("vesselType");
	} */

	function setCarrierInfoForm(bool, row){
		try {
			if(!bool){
				//$("inputVessel").selectedIndex = 0;
				$("inputVessel").value = "";
				/* $("inputVesselDisplay").clear();
				$("inputVesselDisplay").hide(); */
				//$("inputVessel").show();
				$("inputVesselFlag").value = "";
			} else {
				/* var s = $("inputVessel");
				var rowSelected;
				for (var i=0; i<s.length; i++)	{
					
					if (s.options[i].value == row.down("input", 0).value)	{
						s.selectedIndex = i;
						rowSelected = row.down("input", 1).value;
					}
				}
				s.hide(); */
				$("inputVessel").value = row.down("input", 1).value;
				//$("inputVesselDisplay").value = rowSelected;
				//$("inputVesselDisplay").show();
				$("inputVesselFlag").value = row.down("input", 3).value;
			}
			
			//$("inputVesselFlag").value = (!bool ? "" : row.down("input", 3).value);
			function enableSearch(){ // Patrick
				$("searchCarrierName").show();
			}
			function disableSearch(){ // Patrick
				$("searchCarrierName").hide();
			}
			//(!bool ? $("inputVessel").enable() : $("inputVessel").disable());
			(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
			(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
			(row == null ? enableSearch() : disableSearch());
		} catch(e){
			showErrorMessage("setCarrierInfoForm", e);
			//showMessageBox("setCarrierInfoForm : " + e.message);
		}
	}

	function addCarrier(){
		try {
			var vesselCd   = $("inputVessel").getAttribute("vesselCd");
			var vesselName = $F("inputVessel");  //$("inputVessel").options[$("inputVessel").selectedIndex].text;
			var vesselFlag = $("hidVesFlag").value;  //$("inputVessel").options[$("inputVessel").selectedIndex].getAttribute("vesselFlag");
			var vesselType = $F("inputVesselFlag");
			
			var exists = false;
			$$("input[name='vesselCd']").each(function (v){
				if (v.value == vesselCd){
					exists = true;
				}
			});

			if ($("inputVessel").value == "") {
				showMessageBox("Required fields must be entered.", imgMessage.ERROR);
				$("inputVessel").focus();
				return false;
			} else if (exists == true){
				showMessageBox("Carrier/Conveyance already exists in the list.", imgMessage.ERROR);
				$("inputVessel").focus();
				return false;
			} 
	
			var carrierInfoDiv = $("carrierInfoList");
			var forInsertDiv   = $("forInsertDiv");
			
			var insertContent  = '<input type="hidden" id="insVesselCd'+ vesselCd +'"   	name="insVesselCd"     	value="'+ vesselCd +'" />'+
								 '<input type="hidden" id="insVesselName'+ vesselCd +'" 	name="insVesselName" 	value="'+ vesselName +'" />'+
								 '<input type="hidden" id="insVesselFlag'+ vesselCd +'" 	name="insVesselFlag"	value="'+ vesselFlag +'" />'+
								 '<input type="hidden" id="insVesselType'+ vesselCd +'" 	name="insVesselType"	value="'+ vesselType +'" />'+
								 '<input type="hidden" id="insRecFlag'+ vesselCd +'"  		name="insRecFlag" 		value="" />';
		    
			var viewContent	   = '<input type="hidden" id="vesselCd'+ vesselCd +'"   	name="vesselCd"    	value="'+ vesselCd +'" />'+
						 		 '<input type="hidden" id="vesselName'+ vesselCd +'" 	name="vesselName" 	value="'+ vesselName +'" />'+
								 '<input type="hidden" id="vesselFlag'+ vesselCd +'" 	name="vesselFlag"	value="'+ vesselFlag +'" />'+
								 '<input type="hidden" id="vesselType'+ vesselCd +'" 	name="vesselType"	value="'+ vesselType +'" />'+
								 '<input type="hidden" id="recFlag'+ vesselCd +'"  		name="recFlag" 		value="" />'+
								 '<label style="width: 430px; text-align: left; margin-left: 5px;" title="'+ vesselName +'" name="vesselName" id="vesselName'+ vesselCd +'">'+ vesselName +'</label>'+
								 '<label style="width: 130px; text-align: left; margin-left: 5px;" title="'+ vesselType +'">'+ vesselType +'</label>';
							
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "carrier"+vesselCd);
			//newDiv.setAttribute("row", "carrier"+vesselCd);
			newDiv.setAttribute("name", "rowCarrier");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			newDiv.update(viewContent);
			carrierInfoDiv.insert({bottom : newDiv});
			var insertDiv = new Element("div");
			insertDiv.setAttribute("id", "insCarrier"+vesselCd);
			insertDiv.setAttribute("name", "insCarrier");
			insertDiv.setStyle("visibility: hidden;");
			insertDiv.update(insertContent);
			forInsertDiv.insert({bottom : insertDiv});
			newDiv.observe("mouseover", function ()	{
				newDiv.addClassName("lightblue");
			});
			
			newDiv.observe("mouseout", function ()	{
				newDiv.removeClassName("lightblue");
			});
	
			//book2
			newDiv.observe("click", function(row){
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow"))	{
					($$("div#carrierInfoList div:not([id='" + "carrier"+vesselCd + "'])")).invoke("removeClassName", "selectedRow");
					setCarrierInfoForm(true, newDiv);
				} else {
					setCarrierInfoForm(false, null);
				} 
			});
			
			Effect.Appear(newDiv, {
				duration: .5,
				afterFinish: function () {
					setCarrierInfoForm(false, null);
				}
			});
			checkTableIfEmpty("rowCarrier", "carrierInfoDiv");
			checkIfToResizeTable("carrierInfoList", "rowCarrier");
			//hideAddedCarriers();
		} catch (e){
			showErrorMessage("addCarrier", e);
			//showMessageBox("addCarrier : " + e.message);
		}
	}

	//unhide the deleted carrier in the LOV
/* 	function showDeletedCarrier(row) {
		var vesselOpt = $("inputVessel").options;
		for(var i=0; i<vesselOpt.length; i++) {
			if (row.id.substring(7) == vesselOpt[i].value) {
				vesselOpt[i].show();
				vesselOpt[i].disabled = false;
			}
		}	
	} */

	//hide a selected carrier in the LOV
/* 	function hideAddedCarriers() {
		var vesselOpt = $("inputVessel").options;
		$$("div[name='rowCarrier']").pluck("id").findAll(function(row) {
			for (var i=0; i<vesselOpt.length; i++) {
				if (row.substring(7) == vesselOpt[i].value) {
					vesselOpt[i].hide();
					vesselOpt[i].disabled = true;
				}
			}
		});
	} */

	function deleteCarrier(){
		try {
			$$("div[name='rowCarrier']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					var vesselCd      = (row.down("input", 0).value).replace('_', ' ');
					var forDeleteDiv  = $("forDeleteDiv");
					var deleteContent = '<input type="hidden" id="delVesselCd'+ vesselCd +'"   	name="delVesselCd"     	value="'+ vesselCd +'" />';
					var deleteDiv     = new Element("div");

					//showDeletedCarrier(row);
					
					deleteDiv.setAttribute("id", "delCarrier"+vesselCd);
					deleteDiv.setStyle("visibility: hidden;");
					deleteDiv.update(deleteContent);
							
					forDeleteDiv.insert({bottom : deleteDiv});
	
					$$("div[name='insCarrier']").each(function(div){
						var id = div.getAttribute("id");
						if(id == "insCarrier"+vesselCd){
							div.remove();
						}
					});
					
					Effect.Fade(row, {
						duration: .5,
						afterFinish: function () {
							row.remove();
							setCarrierInfoForm(false, null);
							checkTableIfEmpty("rowCarrier", "carrierInfoDiv");
							checkIfToResizeTable("carrierInfoList", "rowCarrier");
						}
					});
				}
			});
		} catch(e){
			showErrorMessage("deleteCarrier", e);
			//showMessageBox("deleteCarrier : " + e.message);
		}			
	}

	function saveQuoteCarrierInfo()	{
		try {
			if ($$("div[name='rowCarrier']").size() == 1 && $$("div[name='rowCarrier']")[0].down("input", 0).value == "MULTI" && $("quoteId") == null){
					showMessageBox("Another Carrier/Conveyance of must exist when using MULTIVESSEL.");
					$("inputVessel").focus();
			} else {
				new Ajax.Request(contextPath + "/GIPIQuoteVesAirController?action=saveCarrierInfo", {
					method: "POST",
					asynchronous: true,
					postBody: changeSingleAndDoubleQuotes(fixTildeProblem(Form.serialize("carrierInfoMainForm"))),
					onCreate: function () {
						setCursor("wait");
						//$("carrierInfoMainForm").disable();
						/* $("btnSave").disable();
						$("btnEditQuotation").disable(); */ // Patrick
						showNotice("Saving, please wait...");
					}, 
					onComplete: function (response)	{
						hideNotice();
						setCursor("default");
						//$("carrierInfoMainForm").enable();
						/* $("btnSave").enable();
						$("btnEditQuotation").enable(); */ // Patrick
						//pAction = pageActions.none;	
						
						if (checkErrorOnResponse(response))	{
							/* $("forInsertDiv").update("");
							$("forDeleteDiv").update("");	 */	//Patrick					
							setCarrierInfoForm(false, null);
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							changeTag = 0;
							carrierInfoExitCtr = 0;
							lastAction();
							lastAction = "";					
						}										
					}
				});
			}
		} catch (e){
			showErrorMessage("saveQuoteCarrierInfo", e);
			//showMessageBox("saveCarrierInfo : " + e.message);
		} 
	}

	initializeChangeTagBehavior(saveQuoteCarrierInfo);
	//setCarrierInfoForm(false, null);
	$("lineCd").value = objGIPIQuote.lineCd; // andrew - 01.17.2012 - added to hold the lineCd when Exit is pressed
	$("lineName").value = objGIPIQuote.lineName; // andrew - 01.17.2012 - added to hold the lineCd when Exit is pressed
	
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveQuoteCarrierInfo();
						showQuotationListing();
					}, function(){
						showQuotationListing();
						changeTag = 0;
					}, "");
		}else{
			showQuotationListing();
		}
	});
</script>