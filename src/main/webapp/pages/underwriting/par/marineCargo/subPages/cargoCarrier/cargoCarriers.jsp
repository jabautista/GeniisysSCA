<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<jsp:include page="/pages/underwriting/par/marineCargo/subPages/cargoCarrier/cargoCarrierListing.jsp"></jsp:include>
<table align="center" width="600px;" border="0">
	<tr>
		<td class="rightAligned" style="width:90px;">Vessel Name </td>
		<td class="leftAligned" colspan="3">
			<input type="text" id="carrierVesselName" name="carrierVesselName" style="width : 484px; display : none;" class="required" />
			<select id="carrierVesselCd" name="carrierVesselCd" style="width: 492px;" class="required">
				<option value="" plateNo="" serialNo="" motorNo=""></option>
				<c:forEach var="carrierList" items="${vesselCarrierListing}">
					<option value="${carrierList.vesselCd}" plateNo="${carrierList.plateNo}" serialNo="${carrierList.serialNo}" motorNo="${carrierList.motorNo}">${carrierList.vesselName}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Plate No. </td>
		<td class="leftAligned" ><input id="carrierPlateNo" name="carrierPlateNo" type="text" style="width: 180px;" readonly="readonly"/></td>
		<td class="rightAligned" style="width:100px;">Serial No. </td>
		<td class="leftAligned" ><input id="carrierSerialNo" name="carrierSerialNo" type="text" style="width: 180px;" readonly="readonly"/></td>
	</tr>	
	<tr>
		<td class="rightAligned">Motor No. </td>
		<td class="leftAligned" ><input id="carrierMotorNo" name="carrierMotorNo" type="text" style="width: 180px;" readonly="readonly"/></td>
		<td class="rightAligned" style="width:100px;">Limit of Liability </td>
		<td class="leftAligned" ><input id="carrierLimitLiab" name="carrierLimitLiab" type="text" style="width: 180px;" class="money2" maxlength="13" min="0.00" max="9999999999.99" errorMsg="Invalid Limit of Liability. Value should be from 0.00 to 9,999,999,999.99"/></td>
	</tr>
	<tr>
		<td class="rightAligned">ETD </td>
		<td class="leftAligned">
			<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:4px;">
    			<input style="width: 164px; border: none; margin-top : 0px; float : left;" id="carrierEtd" name="carrierEtd" type="text" value="" readonly="readonly" tabindex="20"/>
    			<img id="hrefCarrierEtdDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEtd'),this, null);" alt="ETD" />
			</div>
		</td>
		<td class="rightAligned">Origin </td>
		<td class="leftAligned" ><input id="carrierOrigin" name="carrierOrigin" type="text" style="width: 180px;" /></td>		
	</tr>
	<tr>
		<td class="rightAligned">ETA </td>
		<td class="leftAligned">
			<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
    			<input style="width: 164px; border: none; margin-top : 0px; float : left;" id="carrierEta" name="carrierEta" type="text" value="" readonly="readonly" tabindex="21"/>
    			<img id="hrefCarrierEtaDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEta'),this, null);" alt="ETA" />
			</div>
		</td>
		<td class="rightAligned">Destination </td>
		<td class="leftAligned" ><input id="carrierDestn" name="carrierDestn" type="text" style="width: 180px;" /></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Voy Limit </td>
		<td class="leftAligned" colspan="3">
			<div style="border: 1px solid gray; height: 20px; width: 490px;">
				<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,400);" id="carrierVoyLimit" name="carrierVoyLimit" style="width: 90%; border: none; height : 13px;"></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" class="hover" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="edit" id="editVoyLimit">
			</div>			
		</td>
	</tr>
	<tr>
		<td>			
			<input id="carrierDeleteSw" name="carrierDeleteSw" 	type="hidden" style="width: 180px;"/>			
		</td>
	</tr>	
</table>
<table align="center">
	<tr>
		<td class="rightAligned" style="text-align: left; padding-left: 5px;">
			<input type="button" class="button" 		id="btnAddCarrier" 		name="btnAddCarrier" 		value="Add" 		style="width: 60px;" />
			<input type="button" class="disabledButton" id="btnDeleteCarrier" 	name="btnDeleteCarrier" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>

<script type="text/javascript">
	/*
	setTableList(objGIPIWCargoCarrier, "cargoCarrierListing", "rowCargoCarrier", "cargoCarrierTable",
			 "itemNo vesselCd", "carriers");
	
	$$("div#cargoCarrierTable div[name='rowCargoCarrier']").each(function(row){
		loadRowObserver(row);
	});

	function loadRowObserver(row){
		loadRowMouseOverMouseOutObserver(row);

		row.observe("click", function(){
			row.toggleClassName("selectedRow");
			if(row.hasClassName("selectedRow")){				
				var id = row.getAttribute("id");				
				$$("div#cargoCarrierTable div:not([id='" + id + "'])").invoke("removeClassName", "selectedRow");
				loadSelectedCarrier(row);				
			}else{
				setCargoCarrierForm(null);
			}
		});
	}
	*/

	showCargoCarrierListing();
	
	function setCargoCarrier(){
		try{
			var newObj = new Object();

			newObj.parId				= $F("globalParId").empty() ? null : $F("globalParId");
			newObj.itemNo				= $F("itemNo").empty() ? null : $F("itemNo");
			newObj.vesselCd				= $F("carrierVesselCd").empty() ? null : $F("carrierVesselCd");
			newObj.vesselName			= escapeHTML2($("carrierVesselCd").options[$("carrierVesselCd").selectedIndex].text);
			newObj.plateNo				= $F("carrierPlateNo").empty() ? null : escapeHTML2($F("carrierPlateNo"));
			newObj.motorNo				= $F("carrierMotorNo").empty() ? null : escapeHTML2($F("carrierMotorNo"));
			newObj.serialNo				= $F("carrierSerialNo").empty() ? null : escapeHTML2($F("carrierSerialNo"));
			newObj.vesselLimitOfLiab	= $F("carrierLimitLiab").empty() ? null : $F("carrierLimitLiab");
			newObj.eta					= $F("carrierEta").empty() ? null : $F("carrierEta");
			newObj.etd					= $F("carrierEtd").empty() ? null : $F("carrierEtd");
			newObj.origin				= $F("carrierOrigin").empty() ? null : escapeHTML2($F("carrierOrigin"));
			newObj.destn				= $F("carrierDestn").empty() ? null : escapeHTML2($F("carrierDestn"));
			newObj.deleteSw				= $F("carrierDeleteSw").empty() ? null : $F("carrierDeleteSw");
			newObj.voyLimit				= $F("carrierVoyLimit").empty() ? null : escapeHTML2($F("carrierVoyLimit"));
			newObj.userId				= $F("userId");		

			return newObj;
		}catch(e){
			showErrorMessage("setCargoCarrier", e);
		}
	}

	function addCarrier(){
		try{
			var obj 	= setCargoCarrier();
			var content = prepareCarrier(obj);

			if($F("btnAddCarrier") == "Update"){
				addModedObjByAttr(objGIPIWCargoCarrier, obj, "vesselCd");
				$("rowCargoCarrier" + obj.itemNo + "_" + obj.vesselCd).update(content);
				$("rowCargoCarrier" + obj.itemNo + "_" + obj.vesselCd).removeClassName("selectedRow");
			}else{
				addNewJSONObject(objGIPIWCargoCarrier, obj);

				var table = $("cargoCarrierListing");
				var newDiv = new Element("div");
				
				newDiv.setAttribute("id", "rowCargoCarrier" + obj.itemNo + "_" + obj.vesselCd);
				newDiv.setAttribute("name", "rowCargoCarrier");
				newDiv.setAttribute("item", obj.itemNo);
				newDiv.setAttribute("vesselCd", obj.vesselCd);		
				newDiv.addClassName("tableRow");

				newDiv.update(content);
				table.insert({bottom : newDiv});

				loadCargoCarrierRowObserver(newDiv);				
				
				new Effect.Appear("rowCargoCarrier" + obj.itemNo + "_" + obj.vesselCd, {
					duration : 0.2
				});

				//($$("div#cargoCarrierTable div:not([item='" + obj.itemNo + "'])")).invoke("hide");
				//$("cargoCarrierTable").show();
			}

			//checkPopupsTableWithTotalAmountbyObject(objGIPIWCargoCarrier, "cargoCarrierTable", "cargoCarrierListing",
			//		"rowCargoCarrier", "vesselLimitOfLiab", "cargoCarrierTotalAmountDiv", "cargoCarrierTotalAmount");
			
			toggleSubpagesRecord(objGIPIWCargoCarrier, objItemNoList, $F("itemNo"), "rowCargoCarrier", "vesselCd",
					"cargoCarrierTable", "cargoCarrierTotalAmountDiv", "cargoCarrierTotalAmount", "cargoCarrierListing", "vesselLimitOfLiab", true);

			setCargoCarrierForm(null);
			($$("div#listOfCarriersInfo [changed=changed]")).invoke("removeAttribute", "changed");
		}catch(e){
			showErrorMessage("addCarrier", e);
		}
	}

	$("btnAddCarrier").observe("click", function(){
		/*
		if(($$("div#itemTable .selectedRow")).length < 1){
			showMessageBox("Please select an item first.", imgMessage.ERROR);
			return false;
		}else{
			addCarrier();
		}
		*/
		if($F("vesselCd") == objFormVariables.varVMultiCarrier){
			addCarrier();
		}else{
			showMessageBox("Selected vessel code does not match with the existing vessel code in the parameters table.", imgMessage.ERROR);
			return false;
		}
	});

	$("btnDeleteCarrier").observe("click", function(){
		if(($$("div#cargoCarrierTable div[item='" + $F("itemNo") + "']")).length == 1){
			showMessageBox("Item No. " + $F("itemNo") + " has no corresponding carrier vessel.", imgMessage.INFO);
			return false;
		}else{
			$$("div#cargoCarrierTable .selectedRow").each(function(row){
				Effect.Fade(row, {
					duration : 0.3,
					afterFinish : function(){
						var deleteObject = setCargoCarrier();						
						addDelObjByAttr(objGIPIWCargoCarrier, deleteObject, "vesselCd");
						row.remove();
						setCargoCarrierForm(null);
						filterLOV3("carrierVesselCd", "rowCargoCarrier", "vesselCd", "item", deleteObject.itemNo);
						checkPopupsTableWithTotalAmountbyObject(objGIPIWCargoCarrier, "cargoCarrierTable", "cargoCarrierListing",
								"rowCargoCarrier", "vesselLimitOfLiab", "cargoCarrierTotalAmountDiv", "cargoCarrierTotalAmount");
					}
				});
			});
		}		
	});

	$("carrierVesselCd").observe("change", function(){
		$("carrierLimitLiab").value = "";
		$("carrierEtd").value 		= "";
		$("carrierEta").value 		= "";
		$("carrierOrigin").value 	= "";
		$("carrierDestn").value 	= "";
		$("carrierDeleteSw").value 	= "";
		$("carrierVoyLimit").value 	= "";
		$("carrierPlateNo").value 	= $("carrierVesselCd").options[$("carrierVesselCd").selectedIndex].getAttribute("plateNo");
		$("carrierSerialNo").value 	= $("carrierVesselCd").options[$("carrierVesselCd").selectedIndex].getAttribute("serialNo");
		$("carrierMotorNo").value 	= $("carrierVesselCd").options[$("carrierVesselCd").selectedIndex].getAttribute("motorNo");
	});

	$("editVoyLimit").observe("click", function(){
		showEditor("carrierVoyLimit", 400);
	});

	$("carrierEtd").observe("blur", function(){
		var etd = $F("carrierEtd");
		var eta = $F("carrierEta");

		if(!(etd.blank()) && !(eta.blank())){
			if(!(eta.blank())){
				etd = makeDate(etd);
				eta = makeDate(eta);

				if(!(etd <= eta)){
					$("eta").value = $F("etd");
					customShowMessageBox("Departure date should not be later than the arrival date (" + dateFormat(eta, 'mmmm dd, yyyy') + ")." +
							" Will copy arrival date value from depature date.", imgMessage.INFO, "etd");
				}
			}
		}
	});

	$("carrierEta").observe("blur", function(){
		var etd = $F("carrierEtd");
		var eta = $F("carrierEta");

		if(!(etd.blank()) && !(eta.blank())){
			etd = makeDate(etd);
			eta = makeDate(eta);

			if(!(eta >= etd)){
				$("eta").value = $F("etd");
				customShowMessageBox("Arrival date should not be earlier than the departure date (" + dateFormat(etd, 'mmmm dd, yyyy') + ")." +
						" Will copy arrival date value from departure date.", imgMessage.INFO, "eta");
			}
		}
	});

	$("carrierEtd").observe("keyup", function(event){	if(event.keyCode == 46){	$("carrierEtd").value = "";	}});
	$("carrierEta").observe("keyup", function(event){	if(event.keyCode == 46){	$("carrierEta").value = "";	}});
</script>