<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<jsp:include page="/pages/underwriting/subPages/listOfCarriersTable.jsp"></jsp:include>
	<table align="center" width="600px;" border="0">
		<tr>
			<td class="rightAligned" style="width:90px;">Vessel Name </td>
			<td class="leftAligned" colspan="3">
				<select  id="carrier" name="carrier" style="width: 492px;" class="required">
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
			<td>
				<input id="carrierEta" 		name="carrierEta" 		type="hidden" style="width: 180px;" />
				<input id="carrierEtd" 		name="carrierEtd" 		type="hidden" style="width: 180px;" />
				<input id="carrierOrigin" 	name="carrierOrigin" 	type="hidden" style="width: 180px;"/>
				<input id="carrierDestn" 	name="carrierDestn" 	type="hidden" style="width: 180px;"/>
				<input id="carrierDeleteSw" name="carrierLimitLiab" type="hidden" style="width: 180px;"/>
				<input id="carrierVoyLimit" name="carrierLimitLiab" type="hidden" style="width: 180px;"/>
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
	
<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

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
		$("carrierEtd").value = "";
		$("carrierEta").value = "";
		$("carrierOrigin").value = "";
		$("carrierDestn").value = "";
		$("carrierDeleteSw").value = "";
		$("carrierVoyLimit").value = "";
		$("carrierPlateNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("plateNo");
		$("carrierSerialNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("serialNo");
		$("carrierMotorNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("motorNo");
	});

	$("btnAddCarrier").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			addCarrier();
		} else{
			return false;
		}		
	});

	$$("div[name='carr']").each(
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
						$$("div[name='carr']").each(function (li)	{
							if (acc.getAttribute("id") != li.getAttribute("id"))	{
								li.removeClassName("selectedRow");
							}	
						});
						/*var no = acc.getAttribute("id");
						var item = acc.getAttribute("item");		
						var cd = acc.getAttribute("carrCd");	
						var cdName = acc.getAttribute("carrName");	
						var cdPlate = acc.getAttribute("carrPlate");	
						var cdMotor = acc.getAttribute("carrMotor");	
						var cdSerial = acc.getAttribute("carrSerial");	
						var cdLimit = acc.getAttribute("carrLimit");	*/
						var cd = acc.down("input",2).value;	
						var cdName = acc.down("input",3).value;	
						var cdPlate = acc.down("input",4).value;	
						var cdMotor = acc.down("input",5).value;		
						var cdSerial = acc.down("input",6).value;	
						var cdLimit = acc.down("input",7).value;	
						var cdEta = acc.down("input",8).value;
						var cdEtd = acc.down("input",9).value;
						var cdOrigin = acc.down("input",10).value;
						var cdDetsn = acc.down("input",11).value;
						var cdDeleteSw = acc.down("input",12).value;
						var cdVoyLimit = acc.down("input",13).value;
						$("carrier").value = cd;
						$("carrierPlateNo").value = cdPlate;
						$("carrierMotorNo").value = cdMotor;
						$("carrierSerialNo").value = cdSerial;
						$("carrierLimitLiab").value = cdLimit;
						$("carrierEtd").value = cdEtd;
						$("carrierEta").value = cdEta;
						$("carrierOrigin").value = cdOrigin;
						$("carrierDestn").value = cdDetsn;
						$("carrierDeleteSw").value = cdDeleteSw;
						$("carrierVoyLimit").value = cdVoyLimit;
						getDefaults();
					} else {
						clearForm();
					}
				}); 
				
			}	
	);	

	function addCarrier() {	
		try	{
			var cParId = $F("globalParId");
			var cItemNo = $F("itemNo");
			var cCD = $("carrier").value;
			var cDesc = $("carrier").options[$("carrier").selectedIndex].text;
			var cPlateNo = $("carrierPlateNo").value;
			var cMotorNo = $("carrierMotorNo").value;
			var cSerialNo = $("carrierSerialNo").value;
			var cVesselLimitOfLiab = $("carrierLimitLiab").value;
			var cEtas = $("carrierEta").value;
			var cEtds = $("carrierEtd").value;
			var cOrigins = $("carrierOrigin").value;
			var cDestns = $("carrierDestn").value;
			var cDeleteSws = $("carrierDeleteSw").value;
			var cVoyLimits = $("carrierVoyLimit").value;
			var exists = false;
			
			if (cCD == "" || cDesc == "") {
				showNotice("Please complete fields.");
				exists = true;
			}
			
			$$("div[name='carr']").each( function(a)	{
				if (a.getAttribute("carrCd") == cCD && a.getAttribute("item") == cItemNo && $F("btnAddCarrier") != "Update")	{
					exists = true;
					showNotice("Record already exists!");
				}
			});

			hideNotice("");
			
			if (!exists)	{
				var content = '<input type="hidden" id="cParIds" 		name="cParIds" 	    value="'+cParId+'" />'+
			 	  			  '<input type="hidden" id="cItemNos" 		name="cItemNos" 	value="'+cItemNo+'" />'+ 
							  '<input type="hidden" id="cCds"			name="cCds" 		value="'+cCD+'" />'+ 
						 	  '<input type="hidden" id="cDescs" 		name="cDescs" 	    value="'+cDesc+'" />'+  
						 	  '<input type="hidden" id="cPlateNo" 		name="cPlateNo" 	value="'+cPlateNo+'" />'+ 
						 	  '<input type="hidden" id="cMotorNo" 		name="cMotorNo" 	value="'+cMotorNo+'" />'+ 
						 	  '<input type="hidden" id="cSerialNo" 		name="cSerialNo" 	value="'+cSerialNo+'" />'+ 
						 	  '<input type="hidden" id="cVesselLimitOfLiab"   name="cVesselLimitOfLiab"  value="'+cVesselLimitOfLiab+'" class="money" />'+
						 	  '<input type="hidden" id="cEtas"  		name="cEtas" 		value="'+cEtas+'" />'+
						      '<input type="hidden" id="cEtds"  		name="cEtds" 		value="'+cEtds+'" />'+
							  '<input type="hidden" id="cOrigins"  		name="cOrigins" 	value="'+cOrigins+'" />'+
							  '<input type="hidden" id="cDestns"  		name="cDestns" 		value="'+cDestns+'" />'+
							  '<input type="hidden" id="cDeleteSws"  	name="cDeleteSws" 	value="'+cDeleteSws+'" />'+
							  '<input type="hidden" id="cVoyLimits"  	name="cVoyLimits" 	value="'+cVoyLimits+'" />'+ 
						 	  '<label name="textCarrier" style="width: 25%; margin-right:2px;" for="carrier'+cDesc+'">'+cDesc.truncate(20, "...")+'</label>'+
						 	  '<label name="textCarrier" style="width: 16%; margin-right:2px;" for="carrier'+cPlateNo+'">'+(cPlateNo == "" ? "---" :cPlateNo.truncate(20, "..."))+'</label>'+
						 	  '<label name="textCarrier" style="width: 16%; margin-right:2px;" for="carrier'+cMotorNo+'">'+(cMotorNo == "" ? "---" :cMotorNo.truncate(20, "..."))+'</label>'+
						 	  '<label name="textCarrier" style="width: 16%; margin-right:2px;" for="carrier'+cSerialNo+'">'+(cSerialNo == "" ? "---" :cSerialNo.truncate(20, "..."))+'</label>'+
							  '<label name="textCarrier" style="width: 25%; text-align: right;" class="money" for="carrier'+cVesselLimitOfLiab+'">'+(cVesselLimitOfLiab == "" ? "---" :cVesselLimitOfLiab.truncate(20, "..."))+'</label>'; 
							  			   
				if ($F("btnAddCarrier") == "Update") {	 				 
					$("rowCarr"+cItemNo+cCD).update(content);					
					updateTempCarrierItemNos();
				} else {
					var newDiv = new Element('div');
					newDiv.setAttribute("name","carr");
					newDiv.setAttribute("id","rowCarr"+cItemNo+cCD);
					newDiv.setAttribute("item",cItemNo);
					newDiv.setAttribute("carrCd",cCD); 
					newDiv.setAttribute("carrName",cDesc);
					newDiv.setAttribute("carrPlate",cPlateNo);
					newDiv.setAttribute("carrMotor",cMotorNo);
					newDiv.setAttribute("carrSerial",cSerialNo);
					newDiv.setAttribute("carrLimit",cVesselLimitOfLiab);
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
							$$("div[name='carr']").each(function (li)	{
									if (newDiv.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});
							/*var no = newDiv.getAttribute("id");
							var item = newDiv.getAttribute("item");		
							var cd = newDiv.getAttribute("carrCd");	
							var cdName = newDiv.getAttribute("carrName");	
							var cdPlate = newDiv.getAttribute("carrPlate");	
							var cdMotor = newDiv.getAttribute("carrMotor");	
							var cdSerial = newDiv.getAttribute("carrSerial");	
							var cdLimit = newDiv.getAttribute("carrLimit");	*/
							var cd = newDiv.down("input",2).value;	
							var cdName = newDiv.down("input",3).value;	
							var cdPlate = newDiv.down("input",4).value;	
							var cdMotor = newDiv.down("input",5).value;		
							var cdSerial = newDiv.down("input",6).value;	
							var cdLimit = newDiv.down("input",7).value;			
							var cdEta = newDiv.down("input",8).value;
							var cdEtd = newDiv.down("input",9).value;
							var cdOrigin = newDiv.down("input",10).value;
							var cdDetsn = newDiv.down("input",11).value;
							var cdDeleteSw = newDiv.down("input",12).value;
							var cdVoyLimit = newDiv.down("input",13).value;
							$("carrier").value = cd;
							$("carrierPlateNo").value = cdPlate;
							$("carrierMotorNo").value = cdMotor;
							$("carrierSerialNo").value = cdSerial;
							$("carrierLimitLiab").value = cdLimit;
							$("carrierEtd").value = cdEtd;
							$("carrierEta").value = cdEta;
							$("carrierOrigin").value = cdOrigin;
							$("carrierDestn").value = cdDetsn;
							$("carrierDeleteSw").value = cdDeleteSw;
							$("carrierVoyLimit").value = cdVoyLimit;
							getDefaults();
						} else {
							clearForm();
						} 
					}); 
		
					Effect.Appear(newDiv, {
						duration: .5, 
						afterFinish: function ()	{
						checkTableItemInfoAdditional("carrierTable","carrierListing","carr","item",$F("itemNo"));
						}
					});
					updateTempCarrierItemNos();
				}
				clearForm();
			}
		} catch (e)	{
			showErrorMessage("addCarrier", e);
		}
	}
	
 
	$("btnDeleteCarrier").observe("click", function() {
		if(checkIfItemExists($F("itemNo"))){
			deleteCarrier();
		} else{
			return false;
		}			
	});
	
	function deleteCarrier(){
		$$("div[name='carr']").each(function (acc)	{
			if (acc.hasClassName("selectedRow")){
				Effect.Fade(acc, {
					duration: .5,
					afterFinish: function ()	{
						var itemNo		= $F("itemNo");
						var cCd			= $F("carrier");
						var listingDiv 	= $("carrierListing");
						var newDiv 		= new Element("div");
						newDiv.setAttribute("id", "row"+itemNo+cCd); 
						newDiv.setAttribute("name", "rowDelete"); 
						newDiv.addClassName("tableRow");
						newDiv.setStyle("display : none");
						newDiv.update(										
							'<input type="hidden" name="delCarrItemNos" 	value="'+itemNo+'" />' +
							'<input type="hidden" name="delCarrCds" 	value="'+cCd+'" />');
						listingDiv.insert({bottom : newDiv});
						updateTempCarrierItemNos();
						acc.remove();
						clearForm();
						checkTableItemInfoAdditional("carrierTable","carrierListing","carr","item",$F("itemNo"));		
					} 
				});
			}
		});
	}	

	function getDefaults(){
		$("btnAddCarrier").value = "Update";
		enableButton("btnDeleteCarrier");
	}

	function clearForm(){
		$("carrier").selectedIndex = 0;
		$("carrierPlateNo").value = "";
		$("carrierMotorNo").value = "";
		$("carrierSerialNo").value = "";
		$("carrierLimitLiab").value = "";
		$("btnAddCarrier").value = "Add";
		disableButton("btnDeleteCarrier");
		$$("div[name='carr']").each(function (div) {
			div.removeClassName("selectedRow");
		});
		checkTableItemInfoAdditional("carrierTable","carrierListing","carr","item",$F("itemNo"));
		$("carrierEtd").value = "";
		$("carrierEta").value = "";
		$("carrierOrigin").value = "";
		$("carrierDestn").value = "";
		$("carrierDeleteSw").value = "";
		$("carrierVoyLimit").value = "";
		computeTotalAmountInTable("carrierTable","carr",7,"item",$F("itemNo"),"listOfCarrierTotalAmtDiv");
	}

	
	$("carrier").observe("change", function() {
		$("carrierPlateNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("plateNo");
		$("carrierMotorNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("motorNo");
		$("carrierSerialNo").value = $("carrier").options[$("carrier").selectedIndex].getAttribute("serialNo");
	});	

	$("carrier").observe("click", function() {
		$("carrier").observe("change", function() {
			var cCD = $("carrier").value;
			var cItemNo	= $F("itemNo");
			var exist = "N";
			$$("div[name='carr']").each( function(a)	{
				a.removeClassName("selectedRow");
				if (a.getAttribute("carrCd") == cCD && a.getAttribute("item") == cItemNo)	{
					exist = "Y";
					a.toggleClassName("selectedRow");
					
					/*var no = a.getAttribute("id");
					var item = a.getAttribute("item");		
					var cd = a.getAttribute("carrCd");	
					var cdName = a.getAttribute("carrName");	
					var cdPlate = a.getAttribute("carrPlate");	
					var cdMotor = a.getAttribute("carrMotor");	
					var cdSerial = a.getAttribute("carrSerial");	
					var cdLimit = a.getAttribute("carrLimit");		*/		
					var cd = a.down("input",2).value;	
					var cdName = a.down("input",3).value;	
					var cdPlate = a.down("input",4).value;	
					var cdMotor = a.down("input",5).value;		
					var cdSerial = a.down("input",6).value;	
					var cdLimit = a.down("input",7).value;
					var cdEta = a.down("input",8).value;
					var cdEtd = a.down("input",9).value;
					var cdOrigin = a.down("input",10).value;
					var cdDetsn = a.down("input",11).value;
					var cdDeleteSw = a.down("input",12).value;
					var cdVoyLimit = a.down("input",13).value;
					$("carrier").value = cd;
					$("carrierPlateNo").value = cdPlate;
					$("carrierMotorNo").value = cdMotor;
					$("carrierSerialNo").value = cdSerial;
					$("carrierLimitLiab").value = cdLimit;
					$("carrierEtd").value = cdEtd;
					$("carrierEta").value = cdEta;
					$("carrierOrigin").value = cdOrigin;
					$("carrierDestn").value = cdDetsn;
					$("carrierDeleteSw").value = cdDeleteSw;
					$("carrierVoyLimit").value = cdVoyLimit;
					updateTempCarrierItemNos();
				} 
			});
			buttonAdd(exist);
		});
	});		

	function buttonAdd(exist){
		if (exist == "Y"){
			getDefaults();
		} else {
			$("btnAddCarrier").value = "Add";
			disableButton("btnDeleteCarrier");
		}		
	}

	function updateTempCarrierItemNos(){
		var temp = $F("tempCarrierItemNos").blank() ? "" : $F("tempCarrierItemNos");
		$("tempCarrierItemNos").value = temp + $F("itemNo") + " ";
	}

	clearForm();
</script>	
	