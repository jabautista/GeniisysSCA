<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="cargoCarrierTable" name="cargoCarrierTable" style="width : 100%;">
	<div id="cargoCarrierTableGridSectionDiv" class="">
		<div id="cargoCarrierTableGridDiv" style="padding: 10px;">
			<div id="cargoCarrierTableGrid" style="height: 0px; width: 900px;"></div>
		</div>
	</div>	
</div>
<table align="center" width="600px;" border="0">
	<tr>
		<td class="rightAligned" style="width:90px;">Vessel Name </td>
		<td class="leftAligned" colspan="3">
			<div style="float:left; border: solid 1px gray; width: 490px; height: 21px; margin-right:4px;" class="required">
				<input type="hidden" id="carrierVesselCd" name="carrierVesselCd" />
				<input tabindex="2001" type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 463px; border: none;" name="carrierVesselName" id="carrierVesselName" readonly="readonly" class="required" value="" tabindex="19" />
				<img id="hrefCarrierVessel" alt="goCarrierVessel" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />
			</div>			
		</td>
	</tr>
	<tr>
		<td class="rightAligned">Plate No. </td>
		<td class="leftAligned" ><input tabindex="2002" id="carrierPlateNo" name="carrierPlateNo" type="text" style="width: 180px;" readonly="readonly"/></td>
		<td class="rightAligned" style="width:100px;">Serial No. </td>
		<td class="leftAligned" ><input tabindex="2003" id="carrierSerialNo" name="carrierSerialNo" type="text" style="width: 180px;" readonly="readonly"/></td>
	</tr>	
	<tr>
		<td class="rightAligned">Motor No. </td>
		<td class="leftAligned" ><input tabindex="2004" id="carrierMotorNo" name="carrierMotorNo" type="text" style="width: 180px;" readonly="readonly"/></td>
		<td class="rightAligned" style="width:100px;" for="carrierLimitLiab">Limit of Liability </td>
		<td class="leftAligned" >
			<!-- 
			<input tabindex="2005" id="carrierLimitLiab" name="carrierLimitLiab" type="text" style="width: 180px;" class="money2" maxlength="13" min="0.00" max="9999999999.99" errorMsg="Invalid Limit of Liability. Value should be from 0.00 to 9,999,999,999.99"/>
			 -->
			<input tabindex="2005" id="carrierLimitLiab" name="carrierLimitLiab" type="text" style="width: 180px;" class="applyDecimalRegExp" regExpPatt="pDeci1002" maxlength="13" min="0.00" max="9999999999.99" />
		</td>
	</tr>
	<tr>
		<td class="rightAligned">ETD </td>
		<td class="leftAligned">
			<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:4px;">
    			<input tabindex="2006" style="width: 164px; border: none; margin-top : 0px; float : left;" id="carrierEtd" name="carrierEtd" type="text" value="" readonly="readonly" />
    			<img id="hrefCarrierEtdDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEtd'),this, null);" alt="ETD" />
			</div>
		</td>
		<td class="rightAligned">Origin </td>
		<td class="leftAligned" ><input tabindex="2007" id="carrierOrigin" name="carrierOrigin" type="text" style="width: 180px;" class="allCaps" maxlength="50" /></td>		
	</tr>
	<tr>
		<td class="rightAligned">ETA </td>
		<td class="leftAligned">
			<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:3px;">
    			<input tabindex="2008" style="width: 164px; border: none; margin-top : 0px; float : left;" id="carrierEta" name="carrierEta" type="text" value="" readonly="readonly" />
    			<img id="hrefCarrierEtaDate" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEta'),this, null);" alt="ETA" />
			</div>
		</td>
		<td class="rightAligned">Destination </td>
		<td class="leftAligned" ><input tabindex="2009" id="carrierDestn" name="carrierDestn" type="text" style="width: 180px;" class="allCaps" maxlength="50" /></td>
	</tr>
	<tr>
		<td class="rightAligned" style="width: 150px;">Voy Limit </td>
		<td class="leftAligned" colspan="3">
			<div style="float:left; border: solid 1px gray; width: 490px; height: 21px; margin-right:4px;">
				<textarea tabindex="2010" onKeyDown="limitText(this,400);" onKeyUp="limitText(this,400);" id="carrierVoyLimit" name="carrierVoyLimit" style="width: 464px; border: none; height : 13px; resize : none;"></textarea>
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
			<input tabindex="2011" type="button" class="button" 		id="btnAddCarrier" 		name="btnAddCarrier" 		value="Add" 		style="width: 60px;" />
			<input tabindex="2012" type="button" class="disabledButton" id="btnDeleteCarrier" 	name="btnDeleteCarrier" 	value="Delete" 		style="width: 60px;" />
		</td>
	</tr>
</table>
<script type="text/javascript">
	retrieveCargoCarriers(objUWParList.parId, 0);
	
	function selectCarrierVessel(){
		try{
			var notIn = "";
			var withPrevious = false;
			var itemNo = $F("itemNo");

			var objArrFiltered = objGIPIWCargoCarrier.filter(function(obj){	return parseInt(obj.itemNo) == itemNo && nvl(obj.recordStatus, 0) != -1;	});

			for(var i=0, length=objArrFiltered.length; i < length; i++){			
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objArrFiltered[i].vesselCd + "'";
				withPrevious = true;
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			
			showCarrierVesselLOV(objUWParList.parId, notIn);
		}catch(e){
			showErrorMessage("selectCarrierVessel", e);
		}
	}

	$("hrefCarrierVessel").observe("click", selectCarrierVessel);
	
	function addCarrier(){
		try{
			var newObj 	= setCargoCarrier();			
			
			if($F("btnAddCarrier") == "Update"){								
				addModedObjByAttr(objGIPIWCargoCarrier, newObj, "vesselCd");							
				tbgCargoCarriers.updateVisibleRowOnly(newObj, tbgCargoCarriers.getCurrentPosition()[1]);
			}else{
				addNewJSONObject(objGIPIWCargoCarrier, newObj);
				tbgCargoCarriers.addBottomRow(newObj);			
			}
			
			setCargoCarrierFormTG(null);
			($$("div#listOfCarriersInfo [changed=changed]")).invoke("removeAttribute", "changed");
			updateTGPager(tbgCargoCarriers);
			
		}catch(e){
			showErrorMessage("addCarrier", e);
		}
	}
	
	$("btnAddCarrier").observe("click", function() {
		//if(checkIfItemExists($F("itemNo"))){
			if($F("carrierVesselCd").empty() && $F("carrierVesselName").empty()){
				//showMessageBox("Vessel name is required for multiple carrier.", imgMessage.ERROR);
				customShowMessageBox("Required fields must be entered.", imgMessage.ERROR, "carrierVesselName");
				return false;
			}
			
			addCarrier();
		//} else{
		//	return false;
		//}		
	});
	
	function deleteCarrier(){
		try{			
			//tbgMortgagee.deleteRow(tbgMortgagee.getCurrentPosition()[1]);
			var delObj = setCargoCarrier();
			addDelObjByAttr(objGIPIWCargoCarrier, delObj, "vesselCd");			
			tbgCargoCarriers.deleteVisibleRowOnly(tbgCargoCarriers.getCurrentPosition()[1]);
			setCargoCarrierFormTG(null);
			updateTGPager(tbgCargoCarriers);		
		}catch(e){
			showErrorMessage("deleteCarrier", e);			
		}
	}
	
	$("btnDeleteCarrier").observe("click", function() {
		if(objGIPIWCargoCarrier.filter(function(obj){	return nvl(obj.recordStatus, 0) != -1 && obj.itemNo == $F("itemNo");	}).length == 1){
			showMessageBox("Item No. " + $F("itemNo") + " has no corresponding vessel.", imgMessage.INFO);
			return false;
		}
		
		deleteCarrier();
		//if(checkIfItemExists($F("itemNo"))){
		//	deleteCarrier();
		//} else{
		//	return false;
		//}			
	});
	
	$("carrierVesselName").observe("keyup", function(event){
		$("carrierVesselCd").value = "";
		$("carrierVesselName").value = "";
	});
	
	$("carrierEtd").observe("blur", function(){
		var etd = $F("carrierEtd");
		var eta = $F("carrierEta");
		
		if(!(etd.blank()) && !(eta.blank())){
			if(!(eta.blank())){
				etd = makeDate(etd);
				eta = makeDate(eta);
				
				if(!(etd <= eta)){
					//$("eta").value = $F("etd");
					$("carrierEtd").value = $("carrierEtd").getAttribute("lastValidValue");
					customShowMessageBox("Departure date should not be later than the arrival date (" + dateFormat(eta, 'mmmm dd, yyyy') + ").",
							imgMessage.INFO, "carrierEtd");
				}else{
					$("carrierEtd").setAttribute("lastValidValue", $F("carrierEtd"));	
				}
			}
		}else if(!($F("carrierEtd").blank())){
			$("carrierEtd").setAttribute("lastValidValue", $F("carrierEtd"));	
		}
	});

	$("carrierEta").observe("blur", function(){
		var etd = $F("carrierEtd");
		var eta = $F("carrierEta");

		if(!(etd.blank()) && !(eta.blank())){
			etd = makeDate(etd);
			eta = makeDate(eta);

			if(!(eta >= etd)){
				//$("eta").value = $F("etd");
				$("carrierEta").value = $("carrierEta").getAttribute("lastValidValue");
				customShowMessageBox("Arrival date should not be earlier than the departure date (" + dateFormat(etd, 'mmmm dd, yyyy') + ").", 
						imgMessage.INFO, "carrierEta");
			}else{
				$("carrierEta").setAttribute("lastValidValue", $F("carrierEta"));	
			}
		}else if(!($F("carrierEta").blank())){
			$("eta").setAttribute("lastValidValue", $F("carrierEta"));	
		}
	});
	
	$("editVoyLimit").observe("click", function() {
		showOverlayEditor("carrierVoyLimit", 400, $("carrierVoyLimit").hasAttribute("readonly"));
	});
</script>