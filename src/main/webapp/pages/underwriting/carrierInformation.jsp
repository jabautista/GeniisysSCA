<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="carrierInfoMainDiv" name="carrierInfoMainDiv" style="margin-top: 1px;">
	<form id="carrierInfoMainForm" name="carrierInfoMainForm">
		<c:if test="${'Y' ne isPack}" >
			<jsp:include page="subPages/parInformation.jsp"></jsp:include>
		</c:if>		

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
						<div id='carrier${fn:join(fn:split(carrier.vesselCd, "  "), "")}' name="rowCarrier" class="tableRow">
							<input type="hidden" id='vesselCd${fn:join(fn:split(carrier.vesselCd, "  "), "")}'   	name="vesselCd"     value="${carrier.vesselCd}" />
							<input type="hidden" id='vesselName${fn:join(fn:split(carrier.vesselCd, "  "), "")}' 	name="vesselName" 	value="${carrier.vesselName}" />
							<input type="hidden" id='vesselFlag${fn:join(fn:split(carrier.vesselCd, "  "), "")}'	name="vesselFlag"	value="${carrier.vesselFlag}" />
							<input type="hidden" id='vesselType${fn:join(fn:split(carrier.vesselCd, "  "), "")}' 	name="vesselType"	value="${carrier.vesselType}" />
							<input type="hidden" id='recFlag${fn:join(fn:split(carrier.vesselCd, " "), "")}'  		name="recFlag" 		value="${carrier.recFlag}" />
							
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
							<input type="text" id="inputVesselDisplay" readonly="readonly" class="required" style="width: 100%; display: none;" />
							<select id="inputVessel" name="inputVessel" style="width: 100%;" class="required">
								<option value=""></option>
								<optgroup label="Aircraft">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'A' eq vessel.vesselFlag}">
											<option value="${vessel.vesselCd}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>									
									</c:forEach>
								</optgroup>
								<optgroup label="Inland">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'I' eq vessel.vesselFlag}">
											<option value="${vessel.vesselCd}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>									
									</c:forEach>
								</optgroup>
								<optgroup label="Vessel">
									<c:forEach var="vessel" items="${vessels}">
										<c:if test="${'V' eq vessel.vesselFlag}">
											<option value="${vessel.vesselCd}" vesselFlag="${vessel.vesselFlag}" vesselType="${vessel.vesselType}" >${vessel.vesselName}</option>
										</c:if>									
									</c:forEach>
								</optgroup>
							</select>
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
			<input type="button" class="button" id="btnMaintVessel" 	name="btnMaintVessel" 	value="Maintain Vessel Info" />
			<input type="button" class="button" id="btnMaintInland" 	name="btnMaintInland" 	value="Maintain Inland Info" />
			<input type="button" class="button" id="btnMaintAircraft" 	name="btnMaintAircraft" value="Maintain Aircraft Info" />
			<input type="button" class="button" style="width: 90px;" id="btnCancel" name="btnCancel" value="Cancel" />
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>
<script type="text/javascript">
	var parType = $("policyNo") == null ? "P" : "E"; 
	addStyleToInputs();
	initializeAll();
	initializeTable("tableContainer", "rowCarrier", "", "");
	if("${isPack}" != "Y") setDocumentTitle("Carrier Information");
	checkTableIfEmpty("rowCarrier", "carrierInfoDiv");
	checkIfToResizeTable("carrierInfoList", "rowCarrier");
	initializeAccordion();

	// modified by: nica 10.28.2010 for page to be reusable by endt carrier information
	if (parType == "P"){
		setModuleId("GIPIS007");
	}else if(parType == "E"){
		setModuleId("GIPIS076");
	}

	hideAddedCarriers();

	$("btnAdd").observe("click", addCarrier);
	$("btnDelete").observe("click", deleteCarrier);
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox("No changes to save.");
		} else {
			saveCarrierInfo(true);
		}
	});
	
	$("btnCancel").observe("click", function() {
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function() {
						saveCarrierInfo();
						showListing();
					},
					showListing, 
					"");
		} else {
			showListing();			
		}
	});

	function showListing(){
		if(objUWGlobal.packParId != null){
			showPackParListing();
		} else {
			if (parType == "P"){
				showParListing();
			}else if(parType == "E"){
				showEndtParListing();
			}
		}
	}
	
	observeReloadForm("reloadForm", showCarrierInfoPage);
	
	$("inputVessel").observe("change", function (){
		var index = $("inputVessel").selectedIndex;
		toggleVessel(index);	
	});

	$("inputVessel").observe("keypress", function (){
		var index = $("inputVessel").selectedIndex;
		toggleVessel(index);	
	});

	$$("div[name='rowCarrier']").each(function (row){
		row.observe("click", function(){
			if (row.hasClassName("selectedRow")){
				setCarrierInfoForm(true, row);
			} else {
				setCarrierInfoForm(false, null);
			} 
		});
	});	
		
	function toggleVessel(index){
		$("inputVesselFlag").value = $("inputVessel").options[index].getAttribute("vesselType");
	}

	/*
	function setCarrierInfoForm(bool, row){
		try {
			if(!bool){
				$("inputVessel").selectedIndex = 0;
				$("inputVesselDisplay").clear();
				$("inputVesselDisplay").hide();
				$("inputVessel").show();
				$("inputVesselFlag").value = "";
			} else {
				var s = $("inputVessel");
				var rowSelected;
				for (var i=0; i<s.length; i++)	{
					
					if (s.options[i].value == row.down("input", 0).value)	{
						s.selectedIndex = i;
						rowSelected = row.down("input", 1).value;
					}
				}
				s.hide();
				$("inputVesselDisplay").value = rowSelected;
				$("inputVesselDisplay").show();
				$("inputVesselFlag").value = row.down("input", 3).value;
			}
			
			//$("inputVesselFlag").value = (!bool ? "" : row.down("input", 3).value);
			
			//(!bool ? $("inputVessel").enable() : $("inputVessel").disable());
			(row == null ? enableButton("btnAdd") : disableButton("btnAdd"));
			(row == null ? disableButton("btnDelete") : enableButton("btnDelete"));
		} catch(e){
			showErrorMessage("setCarrierInfoForm", e);
			//showMessageBox("setCarrierInfoForm : " + e.message);
		}
	}*/
	
	function addCarrier(){
		try {
			var vesselCd   = $F("inputVessel");
			var vesselId   = $F("inputVessel").split(' ').join('');
			var vesselName = $("inputVessel").options[$("inputVessel").selectedIndex].text;
			var vesselFlag = $("inputVessel").options[$("inputVessel").selectedIndex].getAttribute("vesselFlag");
			var vesselType = $F("inputVesselFlag");
	
			var exists = false;
			$$("input[name='vesselCd']").each(function (v){
				if (v.value == vesselCd){
					exists = true;
				}
			});
	
			if (vesselCd == "") {
				showMessageBox("Carrier/Conveyance is required.", imgMessage.ERROR);
				$("inputVessel").focus();
				return false;
			} else if (exists == true){
				showMessageBox("Carrier/Conveyance already exists in the list.", imgMessage.ERROR);
				$("inputVessel").focus();
				return false;
			} 
	
			var carrierInfoDiv = $("carrierInfoList");
			var forInsertDiv   = $("forInsertDiv");
			
			var insertContent  = '<input type="hidden" id="insVesselCd'+ vesselId +'"   	name="insVesselCd"     	value="'+ vesselCd +'" />'+
								 '<input type="hidden" id="insVesselName'+ vesselId +'" 	name="insVesselName" 	value="'+ vesselName +'" />'+
								 '<input type="hidden" id="insVesselFlag'+ vesselId +'" 	name="insVesselFlag"	value="'+ vesselFlag +'" />'+
								 '<input type="hidden" id="insVesselType'+ vesselId +'" 	name="insVesselType"	value="'+ vesselType +'" />'+
								 '<input type="hidden" id="insRecFlag'+ vesselId +'"  		name="insRecFlag" 		value="" />';
		    
			var viewContent	   = '<input type="hidden" id="vesselCd'+ vesselId +'"   	name="vesselCd"    	value="'+ vesselCd +'" />'+
						 		 '<input type="hidden" id="vesselName'+ vesselId +'" 	name="vesselName" 	value="'+ vesselName +'" />'+
								 '<input type="hidden" id="vesselFlag'+ vesselId +'" 	name="vesselFlag"	value="'+ vesselFlag +'" />'+
								 '<input type="hidden" id="vesselType'+ vesselId +'" 	name="vesselType"	value="'+ vesselType +'" />'+
								 '<input type="hidden" id="recFlag'+ vesselId +'"  		name="recFlag" 		value="" />'+
								 '<label style="width: 430px; text-align: left; margin-left: 5px;" title="'+ vesselName +'" name="vesselName" id="vesselName'+ vesselCd +'">'+ vesselName +'</label>'+
								 '<label style="width: 130px; text-align: left; margin-left: 5px;" title="'+ vesselType +'">'+ vesselType +'</label>';
							
			var newDiv = new Element("div");
			newDiv.setAttribute("id", "carrier"+vesselId);
			newDiv.setAttribute("name", "rowCarrier");
			newDiv.addClassName("tableRow");
			newDiv.setStyle("display: none;");
			newDiv.update(viewContent);
	
			carrierInfoDiv.insert({bottom : newDiv});
	
			var insertDiv = new Element("div");
			insertDiv.setAttribute("id", "insCarrier"+vesselId);
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
	
			newDiv.observe("click", function(){
				newDiv.toggleClassName("selectedRow");
				if (newDiv.hasClassName("selectedRow"))	{
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
			hideAddedCarriers();
		} catch (e){
			showErrorMessage("addCarrier", e);
			//showMessageBox("addCarrier : " + e.message);
		}
	}

	//unhide the deleted carrier in the LOV
	function showDeletedCarrier(row) {
		var vesselOpt = $("inputVessel").options;
		for(var i=0; i<vesselOpt.length; i++) {
			if (row.id.substring(7) == vesselOpt[i].value) {
				vesselOpt[i].show();
				vesselOpt[i].disabled = false;
			}
		}	
	}

	//hide a selected carrier in the LOV
	function hideAddedCarriers() {
		var vesselOpt = $("inputVessel").options;
		$$("div[name='rowCarrier']").pluck("id").findAll(function(row) {
			for (var i=0; i<vesselOpt.length; i++) {
				if (row.substring(7) == vesselOpt[i].value) {
					vesselOpt[i].hide();
					vesselOpt[i].disabled = true;
				}
			}
		});
	}

	function deleteCarrier(){
		try {
			$$("div[name='rowCarrier']").each(function (row)	{
				if (row.hasClassName("selectedRow"))	{
					var vesselCd      = row.down("input", 0).value;
					var vesselId      = vesselCd.split(' ').join('');
					var forDeleteDiv  = $("forDeleteDiv");
					var deleteContent = '<input type="hidden" id="delVesselCd'+ vesselId +'"   	name="delVesselCd"     	value="'+ vesselCd +'" />';
					var deleteDiv     = new Element("div");

					showDeletedCarrier(row);
					
					deleteDiv.setAttribute("id", "delCarrier"+vesselId);
					deleteDiv.setStyle("visibility: hidden;");
					deleteDiv.update(deleteContent);
							
					forDeleteDiv.insert({bottom : deleteDiv});
	
					$$("div[name='insCarrier']").each(function(div){
						var id = div.getAttribute("id");
						if(id == "insCarrier"+vesselId){
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

	$("btnMaintVessel").observe("click", function() {
		showMessageBox("Under Construction.");
	});

	$("btnMaintInland").observe("click", function() {
		showMessageBox("Under Construction.");
	});

	$("btnMaintAircraft").observe("click", function() {
		showMessageBox("Under Construction.");
	});

	initializeChangeTagBehavior(saveCarrierInfo);
	setCarrierInfoForm(false, null);
</script>