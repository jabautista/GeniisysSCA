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

<div id="packQuoteCarrierInfoMainDiv" name="packQuoteCarrierInfoMainDiv" style="margin-top: 1px;">
	<form id="packQuoteCarrierInfoMainForm" name="packQuoteCarrierInfoMainForm">
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationInfoHeader.jsp"></jsp:include>		
		<jsp:include page="/pages/marketing/quotation-pack/packQuotationCommon/packQuotationSubQuotesTable.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Carrier Information</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
			</div>
		</div>
	
		<div id="packQuoteCarrierDivAndFormDiv" name="packQuoteCarrierInfoDivAndFormDiv" class="sectionDiv"  align="center">
			<div id="packCarrierInfoTable" name="packCarrierInfoTable" style="margin: 10px; width: 600px;">
				<div class="tableHeader" id="packCarrierInfoTableHeader" name="packCarrierInfoTableHeader">
					<label style="width: 430px; text-align: left; margin-left: 5px;">Carrier/Conveyance</label>
					<label style="width: 130px; text-align: left; margin-left: 5px;">Vessel Flag</label>
				</div>
				<div class="tableContainer" id="packQuoteCarrierInfoList" name="packQuoteCarrierInfoList"></div>
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
				<input type="button" class="disabledButton" style="width: 60px;" id="btnDelete" name="btnDelete" value="Delete"/>
			</div>	
		</div>
		
		<div class="buttonsDiv" id="packQuoteCarrierInfoButtonsDiv">
			<input type="button" class="button" id="btnEditQuotation" name="btnEditQuotation" value="Edit Package Quotation"/>
			<input type="button" class="button" style="width: 90px;" id="btnSave" name="btnSave" value="Save" />
		</div>
	</form>
</div>

<script type="text/javascript">
	hideNotice();
	setModuleId("GIIMM009");
	changeTag = 0;
	objCurrPackQuote = null;

	var objPackQuoteVesAir = JSON.parse('${objPackQuoteVesAir}'.replace(/\\/g, '\\\\'));
	
	observeReloadForm($("reloadForm"), showPackCarrierInfoPage);

	function createPackQuoteVesAirRow(objVesAir){
		var vesselName = objVesAir.vesselName == null || objVesAir.vesselName == "" ? "&nbsp;" : unescapeHTML2(objVesAir.vesselName);
		var vesselType = objVesAir.vesselType == null || objVesAir.vesselType == "" ? "&nbsp;" : unescapeHTML2(objVesAir.vesselType);

		var content = '<label style="width: 430px; text-align: left; margin-left: 5px;" title="'+ objVesAir.vesselName +'">'+ vesselName +'</label>'+
		 			  '<label style="width: 130px; text-align: left; margin-left: 5px;" title="'+ objVesAir.vesselType +'">'+ vesselType +'</label>';

		var newDiv = new Element("div");
		newDiv.setAttribute("id", "vessel"+objVesAir.quoteId+objVesAir.vesselCd.replace(/ /g, "_"));
		newDiv.setAttribute("name", "vesselRow");
		newDiv.setAttribute("quoteId", objVesAir.quoteId);
		newDiv.setAttribute("vesselCd", objVesAir.vesselCd);
		newDiv.setAttribute("vesselType", objVesAir.vesselType);
		newDiv.setAttribute("vesselFlag", objVesAir.vesselFlag);
		newDiv.setAttribute("recFlag", objVesAir.recFlag);
		newDiv.addClassName("tableRow");
		newDiv.update(content);
		return newDiv;
	}

	function setPackCarrierInfoForm(obj){
		$("inputVessel").value 			= obj == null ? "" : obj.vesselCd;
		$("inputVesselDisplay").value 	= obj == null ? "" : unescapeHTML2(obj.vesselName);
		$("inputVesselFlag").value 		= obj == null ? "" : unescapeHTML2(obj.vesselType);

		(obj == null ? enableButton($("btnAdd")) : disableButton($("btnAdd")));
		(obj == null ? disableButton($("btnDelete")) : enableButton($("btnDelete")));

		if(obj == null){
			$("inputVessel").show();
			$("inputVesselDisplay").hide();
		}else{
			$("inputVessel").hide();
			$("inputVesselDisplay").show();
		}
	}

	function setQuoteCarrierObject(quoteId){
		var carrier = new Object();
		var selCarrier = $("inputVessel").options[$("inputVessel").selectedIndex];
		
		carrier.quoteId = quoteId;
		carrier.vesselFlag = escapeHTML2(selCarrier.getAttribute("vesselFlag"));
		carrier.vesselName = escapeHTML2(selCarrier.innerHTML);
		carrier.recFlag = "C";
		carrier.vesselCd = selCarrier.value;
		carrier.vesselType = selCarrier.getAttribute("vesselType");

		return carrier;
	}

	function setPackQuoteCarrierListing(objArray){
		objArray = objArray.filter(function(obj){ return nvl(obj.recordStatus, 0) != -1; });

		for(var i=0; i<objArray.length; i++){
			var row = createPackQuoteVesAirRow(objArray[i]);
			$("packQuoteCarrierInfoList").insert({bottom : row});
			setPackQuoteCarrierRowObserver(row);
			row.setStyle("display : none;");
		}
		resizeTableBasedOnVisibleRows("packCarrierInfoTable", "packQuoteCarrierInfoList");
	}

	function setPackQuoteCarrierRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			($$("div#packQuoteCarrierInfoList div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
			if(row.hasClassName("selectedRow")){
				for(var i=0; i<objPackQuoteVesAir.length; i++){
					if(objPackQuoteVesAir[i].quoteId == row.getAttribute("quoteId") &&
					   objPackQuoteVesAir[i].vesselCd == row.getAttribute("vesselCd")){
						setPackCarrierInfoForm(objPackQuoteVesAir[i]);
					}
				}
			}else{
				setPackCarrierInfoForm(null);
			}
		});
	}

	function checkIfVesselCdExist(quoteId, vesselCd){
		var exist = false;
		for(var i=0; i<objPackQuoteVesAir.length; i++){
			if(objPackQuoteVesAir[i].quoteId == quoteId &&
			   objPackQuoteVesAir[i].vesselCd == vesselCd &&
			   objPackQuoteVesAir[i].recordStatus != -1){
				exist = true;
				break;
			}
		}
		return exist;
	}

	function filterPackQuoteCarrierLOV(){
		(($$("select#inputVessel option[disabled='disabled']")).invoke("show")).invoke("removeAttribute", "disabled");

		if(getSelectedRow("quoteRow") != null){
			var quoteId = getSelectedRow("quoteRow").getAttribute("quoteId");
			for(var i=0; i<objPackQuoteVesAir.length; i++){
				if(objPackQuoteVesAir[i].quoteId == quoteId &&
				   objPackQuoteVesAir[i].recordStatus != -1){
				   (($$("select#inputVessel option[value='" + unescapeHTML2(objPackQuoteVesAir[i].vesselCd) + "']")).invoke("hide")).invoke("setAttribute", "disabled", "disabled");
				}
			}
		}
		
		$("inputVessel").options[0].show();
		$("inputVessel").options[0].disabled = false;
		$("inputVessel").show();
	}

	function setQuoteListForCarrierInfoRowObserver(row){
		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			($$("div#packQuoteCarrierInfoList div[name='vesselRow']")).invoke("removeClassName", "selectedRow");

			if(row.hasClassName("selectedRow")){
				($$("div#packQuotationTableDiv div:not([id='" + row.id + "'])")).invoke("removeClassName", "selectedRow");
				($$("div#packQuoteCarrierInfoList div[name='vesselRow']")).invoke("show");				
				($$("div#packQuoteCarrierInfoList div:not([quoteId='" + row.getAttribute("quoteId") + "'])")).invoke("hide");
			}else{
				($$("div#packQuoteCarrierInfoList div[name='vesselRow']")).invoke("hide");
			}
			filterPackQuoteCarrierLOV();
			resizeTableBasedOnVisibleRows("packCarrierInfoTable", "packQuoteCarrierInfoList");
			setPackCarrierInfoForm(null);
		});
	}

	function savePackQuoteCarrierInfo(){
		try{
			var addedRows = getAddedJSONObjects(objPackQuoteVesAir);
			var modifiedRows = getModifiedJSONObjects(objPackQuoteVesAir);
			var delRows = getDeletedJSONObjects(objPackQuoteVesAir);
			var setRows = addedRows.concat(modifiedRows);

			new Ajax.Request(contextPath+"/GIPIQuoteVesAirController",{
				method: "POST",
				asynchronous: true,
				parameters:{
					action: "saveCarrierInfoForPackQuote",
					setRows: prepareJsonAsParameter(setRows),
					delRows: prepareJsonAsParameter(delRows)
				},
				onCreate:function(){
					showNotice("Saving Carrier Information, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
							clearObjectRecordStatus(objPackQuoteVesAir);
							changeTag = 0;
						}else{
							showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
						}
					}else{
						showMessageBox(nvl(response.responseText, "An error occured while saving."), imgMessage.ERROR);
					}
				}
			});
			
		}catch(e){
			showErrorMessage("savePackQuoteCarrierInfo", e);
		}
	}

	setPackQuoteCarrierListing(objPackQuoteVesAir);

	$$("div[name='quoteRow']").each(function(row){
		setQuoteListForCarrierInfoRowObserver(row);
	});

	$("inputVessel").observe("change", function (){
		var index = $("inputVessel").selectedIndex;
		$("inputVesselFlag").value = $("inputVessel").options[index].getAttribute("vesselType");	
	});

	$("inputVessel").observe("keypress", function (){
		var index = $("inputVessel").selectedIndex;
		$("inputVesselFlag").value = $("inputVessel").options[index].getAttribute("vesselType");	
	});

	$("btnSave").observe("click", function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES);
		}else{
			savePackQuoteCarrierInfo();
		}
	});

	$("btnEditQuotation").observe("click", function(){
		function goToBasicQuotationInfo(){
			editPackQuotation(objMKGlobal.lineName, objMKGlobal.lineCd, objMKGlobal.packQuoteId);
		}
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", savePackQuoteCarrierInfo, goToBasicQuotationInfo, "");
		}else{
			goToBasicQuotationInfo();
		}
	});

	$("btnAdd").observe("click", function(){
		var selectedQuote = getSelectedRow("quoteRow");
		var vesselCd = $("inputVessel").options[$("inputVessel").selectedIndex].value;
		
		if (selectedQuote == null){
			showMessageBox("There is no quotation selected.", imgMessage.ERROR);
		}else if(vesselCd == ""){
			showMessageBox("Carrier/Conveyance is required.", imgMessage.ERROR);
			$("inputVessel").focus();
			return false;
		}else if(checkIfVesselCdExist(selectedQuote.getAttribute("quoteId"), vesselCd)){
			showMessageBox("Carrier/Conveyance already exists.", imgMessage.ERROR);
			$("inputVessel").focus();
			return false;
		}else{
			var quoteId = selectedQuote.getAttribute("quoteId");
			var addedCarrier = setQuoteCarrierObject(quoteId);
			addedCarrier.recordStatus = 0;
			objPackQuoteVesAir.push(addedCarrier);
			var addedRow = createPackQuoteVesAirRow(addedCarrier);
			$("packQuoteCarrierInfoList").insert({bottom : addedRow});
			setPackQuoteCarrierRowObserver(addedRow);
			filterPackQuoteCarrierLOV();
			resizeTableBasedOnVisibleRows("packCarrierInfoTable", "packQuoteCarrierInfoList");
			setPackCarrierInfoForm(null);
		}
		
	});

	$("btnDelete").observe("click", function(){
		var selectedVessel = getSelectedRow("vesselRow");
		for(var i=0; i<objPackQuoteVesAir.length; i++){
			if(objPackQuoteVesAir[i].quoteId == selectedVessel.getAttribute("quoteId")
			   && objPackQuoteVesAir[i].vesselCd == selectedVessel.getAttribute("vesselCd")){
				objPackQuoteVesAir[i].recordStatus = -1;
			}
		}
		selectedVessel.remove();
		filterPackQuoteCarrierLOV();
		resizeTableBasedOnVisibleRows("packCarrierInfoTable", "packQuoteCarrierInfoList");
		setPackCarrierInfoForm(null);
	});

	initializeChangeTagBehavior(savePackQuoteCarrierInfo);
	$("gimmExit").stopObserving("click"); // andrew - 02.09.2012
	$("gimmExit").observe("click", function(){
		showPackQuotationListing();
	});
</script>