<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div style="margin-bottom: 10px; margin-top: 10px;">
	<jsp:include page="/pages/underwriting/endt/marineCargo/subPages/endtListOfCarriersTable.jsp"></jsp:include>
	<table align="center" width="600px;" border="0">
		<tr>
			<td class="rightAligned" style="width:90px;">Vessel Name </td>
			<td class="leftAligned" colspan="3">
				<input type="text" id="txtCarrierDisplay" readonly="readonly" class="required" style="width: 485px; display: none;"/>
				<select  id="carrier" name="carrier" style="width: 493px;" class="required">
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
			<td class="leftAligned" ><input id="carrierLimitLiab" name="carrierLimitLiab" type="text" style="width: 180px;" class="money" maxlength="14"/></td>
		</tr>	
		<tr>
			<td class="rightAligned">ETD </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:4px;">
	    			<input style="width: 158px; border: none;" id="carrierEtd" name="carrierEtd" type="text" value="" readonly="readonly"/>
	    			<img id="imgCarrierEtdDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEtd'),this, null);" alt="ETD" />
				</div>
			</td>
			<td class="rightAligned" style="width:100px;">Destination </td>
			<td class="leftAligned" ><input id="carrierDestn" name="carrierDestn" type="text" style="width: 180px;" maxlength="50"/></td>
		</tr>
		<tr>
			<td class="rightAligned">ETA </td>
			<td class="leftAligned" >
				<div style="float:left; border: solid 1px gray; width: 186px; height: 21px; margin-right:4px;">
	    			<input style="width: 158px; border: none;" id="carrierEta" name="carrierEta" type="text" value="" readonly="readonly"/>
	    			<img id="imgCarrierEtaDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('carrierEta'),this, null);" alt="ETA" />
				</div>
			</td>
			<td class="rightAligned" style="width:100px;">Origin </td>
			<td class="leftAligned" ><input id="carrierOrigin" name="carrierOrigin" type="text" style="width: 180px;" maxlength="50"/></td>
		</tr>	
		<tr>
			<td class="rightAligned">Voy Limit </td>
			<td class="leftAligned" colspan="3">
				<div style="border: 1px solid gray; height: 20px; width: 492px; float: left;">
					<textarea id="carrierVoyLimit" name="carrierVoyLimit" style="width: 462px; border: none; height: 13px;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editVoyLimit" />
				</div>
			</td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td class="rightAligned" style="text-align: left; padding-left: 5px;">
				<input type="button" class="button" 		id="btnAddCarrier" 	name="btnAddCarrier" 		value="Add" 		style="width: 60px;" />
				<input type="button" class="disabledButton" id="btnDeleteCarrier" 	name="btnDeleteCarrier" 	value="Delete" 		style="width: 60px;" />
			</td>
		</tr>
	</table>
</div>		
<script type="text/javascript">
	objCargoCarriers = JSON.parse('${objCargoCarriers}'.replace(/\\/g, '\\\\'));
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	$("carrierEta").observe("blur", function () {
		if (!$F("carrierEtd").blank() && !$F("carrierEta").blank()) {
			var etd = Date.parse($F("carrierEtd"));
			var eta = Date.parse($F("carrierEta"));

			if(eta <= etd){
				showMessageBox("Arrival date should not be earlier than the departure date ("+dateFormat(etd, 'mmmm dd, yyyy')+").");
				if ($F("btnAddCarrier") == "Update") {
					var currEta = objCurrCargoCarrier.eta == null || objCurrCargoCarrier.eta == "" ? "" : dateFormat(objCurrCargoCarrier.eta, "mm-dd-yyyy"); 
					$("carrierEta").value = currEta;
				} else {
					$("carrierEta").value = "";
				}
			}
		}
	});
		  
	$("carrierEtd").observe("blur", function () {
		if (!$F("carrierEtd").blank() && !$F("carrierEta").blank()) {
			var etd = Date.parse($F("carrierEtd"));
			var eta = Date.parse($F("carrierEta"));

			if(etd >= eta){
				showMessageBox("Departure date should not be later than the arrival date ("+dateFormat(eta, 'mmmm dd, yyyy')+").");
				if ($F("btnAddCarrier") == "Update") {
					var currEtd = objCurrCargoCarrier.etd == null || objCurrCargoCarrier.etd == "" ? "" : dateFormat(objCurrCargoCarrier.etd, "mm-dd-yyyy");
					$("carrierEtd").value = currEtd;
				} else {
					$("carrierEtd").value = "";
				}
			}
		}
	});
	
	$("carrierLimitLiab").observe("blur", function() {
		if (parseInt($F('carrierLimitLiab').replace(/,/g, "")) < -9999999999.99) {
			showMessageBox("Entered Limit of Liability is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR);
			$("carrierLimitLiab").focus();
			$("carrierLimitLiab").value = "";
		} else if (parseInt($F('carrierLimitLiab').replace(/,/g, "")) >  9999999999.99){
			showMessageBox("Entered Limit of Liability is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR);
			$("carrierLimitLiab").focus();
			$("carrierLimitLiab").value = "";
		}
	});
	
	$("carrier").observe("change", function() {
		$("carrierLimitLiab").value = "";
		$("carrierEtd").value 		= "";
		$("carrierEta").value 		= "";
		$("carrierOrigin").value 	= "";
		$("carrierDestn").value 	= "";	
		$("carrierVoyLimit").value 	= "";
		$("carrierPlateNo").value 	= $("carrier").options[$("carrier").selectedIndex].getAttribute("plateNo");
		$("carrierSerialNo").value 	= $("carrier").options[$("carrier").selectedIndex].getAttribute("serialNo");
		$("carrierMotorNo").value 	= $("carrier").options[$("carrier").selectedIndex].getAttribute("motorNo");
	});

	$("btnAddCarrier").observe("click", addCarrier);
	$("btnDeleteCarrier").observe("click", deleteCarrier);

	$$("div[name='rowCarrier']").each(
		function (acc)	{
			acc.observe("mouseover", function ()	{
				acc.addClassName("lightblue");
			});
			
			acc.observe("mouseout", function ()	{
				acc.removeClassName("lightblue");
			});

			acc.observe("click", function ()	{
				acc.toggleClassName("selectedRow");
				if (acc.hasClassName("selectedRow"))	{
					$$("div[name='rowCarrier']").each(function (li)	{
						if (acc.getAttribute("id") != li.getAttribute("id"))	{
							li.removeClassName("selectedRow");
						}	
					});

					for(var i=0; i<objCargoCarriers.length; i++) {
						if (objCargoCarriers[i].itemNo == $F("itemNo") 
								&& objCargoCarriers[i].vesselCd == acc.getAttribute("carrCd")
								&& objCargoCarriers[i].recordStatus != -1) {
							objCurrCargoCarrier = objCargoCarriers[i]; 
							setCarrierForm(objCurrCargoCarrier);
							break;
						}
					}					
				} else {
					setCarrierForm(null);
				}
			}); 
			
		}	
	);	
	
	function addCarrier() {	
		try	{		
			var itemNo 		= $F("itemNo");
			var vesselCd 	= $F("txtCarrierDisplay") != "" ? $("txtCarrierDisplay").getAttribute("vesselCd") : $F("carrier");
			var vesselName  = $F("txtCarrierDisplay") != "" ? $F("txtCarrierDisplay") : $("carrier").options[$("carrier").selectedIndex].text;
			var plateNo 	= $("carrierPlateNo").value;
			var motorNo 	= $("carrierMotorNo").value;
			var serialNo 	= $("carrierSerialNo").value;
			var vesselLimitOfLiab = $("carrierLimitLiab").value;
						
			if (vesselCd == "") {
				showMessageBox("Please select carrier first.");
				return;
			}
						
			var content = '<label name="textCarrier" style="width: 240px; margin-left:5px;" for="carrier'+vesselName+'">'+vesselName.truncate(30, "...")+'</label>'+
					 	  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+plateNo+'">'+(plateNo == "" ? "---" : plateNo.truncate(20, "..."))+'</label>'+
					 	  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+motorNo+'">'+(motorNo == "" ? "---" : motorNo.truncate(20, "..."))+'</label>'+
					 	  '<label name="textCarrier" style="width: 140px; margin-left:5px;" for="carrier'+serialNo+'">'+(serialNo == "" ? "---" : serialNo.truncate(20, "..."))+'</label>'+
						  '<label name="textCarrier" style="width: 180px; text-align: right; margin-left: 5px;" class="money" for="carrier'+vesselLimitOfLiab+'">'+(vesselLimitOfLiab == "" ? "---" :vesselLimitOfLiab.truncate(20, "..."))+'</label>'; 
						  			   
			if ($F("btnAddCarrier") == "Update") {	 				 				
				setJSONCarrier(1);
				var id = "rowCarrier"+itemNo+vesselCd.trim();
				if ($(id) == null) {
					id = "rowCarrier"+itemNo+"_"+vesselCd.trim();
				}
				
				$(id).update(content);
				fireEvent($(id), "click");
			} else {
				setJSONCarrier(0);					
				var newDiv = new Element('div');
				newDiv.setAttribute("name","rowCarrier");
				newDiv.setAttribute("id","rowCarrier"+itemNo+vesselCd.trim());
				newDiv.writeAttribute("item", itemNo);
				newDiv.writeAttribute("carrCd", vesselCd);
				newDiv.addClassName("tableRow");
 
				newDiv.update(content);
				$('carrierListing').insert({bottom: newDiv});
						 
				newDiv.observe("mouseover", function ()	{
					newDiv.addClassName("lightblue");
				});
				
				newDiv.observe("mouseout", function ()	{
					newDiv.removeClassName("lightblue");
				});
				
				newDiv.observe("click", function ()	{	
					newDiv.toggleClassName("selectedRow");
					if (newDiv.hasClassName("selectedRow"))	{
						$$("div[name='rowCarrier']").each(function (li)	{
								if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}
						});

						for(var i=0; i<objCargoCarriers.length; i++) {
							if (objCargoCarriers[i].itemNo == $F("itemNo")
									&& objCargoCarriers[i].vesselCd == newDiv.getAttribute("carrCd")
									&& objCargoCarriers[i].recordStatus != -1) {
								objCurrCargoCarrier = objCargoCarriers[i];
								setCarrierForm(objCurrCargoCarrier);
								break;
							}	
						}
					}
				}); 
		
				Effect.Appear(newDiv, {
					duration: .5, 
					afterFinish: function ()	{
						checkTableIfEmpty2("rowCarrier", "carrierTable");
						checkIfToResizeTable2("carrierListing", "rowCarrier");												
					}
				});
				setCarrierForm(null);
			}		
			computeTotalAmountInTable2("carrierTable","rowCarrier",4,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
		} catch (e)	{
			showErrorMessage("addCarrier", e);
			//showMessageBox("addCarrier : " + e.message);
		}
	}	
	
	function deleteCarrier(){
		objCurrCargoCarrier.recordStatus = -1;
		$$("div[name='rowCarrier']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{																		
						//updateTempCarrierItemNos();
						acc.remove();
												
						setCarrierForm(null);
						checkTableIfEmpty2("rowCarrier", "carrierTable");
						checkIfToResizeTable2("carrierListing", "rowCarrier");
						computeTotalAmountInTable2("carrierTable","rowCarrier",4,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
						//checkTableItemInfoAdditional("carrierTable","carrierListing","rowCarrier","item",$F("itemNo"));		
					} 
				});
			}
		});
	}	

	function setJSONCarrier(recordStatus){				
		var tempObj = recordStatus == 0 ? new Object() : objCurrCargoCarrier;
		tempObj.recordStatus 	= recordStatus;
		tempObj.parId 			= $F("globalParId");
		tempObj.itemNo 			= $F("itemNo");
		tempObj.userId 			= "${PARAMETERS['userId']}"; //userId;
		tempObj.vesselCd 		= $F("txtCarrierDisplay") != "" ? $("txtCarrierDisplay").getAttribute("vesselCd") : $F("carrier");
		tempObj.vesselName		= $F("txtCarrierDisplay") != "" ? $F("txtCarrierDisplay") : $("carrier").options[$("carrier").selectedIndex].text;
		tempObj.plateNo 		= $F("carrierPlateNo").trim() == "" ? null : $F("carrierPlateNo");
		tempObj.motorNo 		= $F("carrierMotorNo").trim() == "" ? null : $F("carrierMotorNo");
		tempObj.serialNo 		= $F("carrierSerialNo").trim() == "" ? null : $F("carrierSerialNo");
		tempObj.vesselLimitOfLiab = $F("carrierLimitLiab") == "" ? null : $("carrierLimitLiab").value.replace(/,/g, "");
		tempObj.etd 			= $F("carrierEtd").trim() == "" ? null : Date.parse($F("carrierEtd"));
		tempObj.eta 			= $F("carrierEta").trim() == "" ? null : Date.parse($F("carrierEta"));
		tempObj.origin 			= $F("carrierOrigin").trim() == "" ? null : $F("carrierOrigin");
		tempObj.destn 			= $F("carrierDestn").trim() == "" ? null : $F("carrierDestn");
		tempObj.voyLimit 		= $F("carrierVoyLimit").trim() == "" ? null : $F("carrierVoyLimit");
		
		if (recordStatus == 0) {
			objCargoCarriers.push(tempObj);
		}
	}

	$("editVoyLimit").observe("click", function () { 
		showEditor("carrierVoyLimit", 400);
	});
	
	$("carrierVoyLimit").observe("keyup", function () {
		limitText(this, 400);
	});	
</script>	
	