<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="billPremiumsMainDiv" name="billPremiumsMainDiv" style="width: 921px;" changeTagAttr="true">
<div id="invoiceTaxMainDiv" name="invoiceTaxMainDiv"> <!-- added by robert GENQA 4844 09.21.15 -->
	<div id="billPremiumList" style="margin: 10px;" align="center">
		<div style="width: 80%; text-align: center;" id="billPremiumsTable" name="billPremiumsTable">
			<div class="tableHeader" id="taxTableHeader">
				<label style="padding-left:5%; text-align: right;">Tax Code</label>
				<label style="padding-left:10%; text-align: left;">Tax Description</label>
				<label style="padding-left:20%; text-align: right;">Tax Amount</label>
				<label style="padding-left:10%; text-align: left;">Tax Allocation</label>
			</div>
			
			<div class="tableContainer" id="billPremiumsTableContainer" name="tableContainer" style="display: block">
				
			</div>
		</div>
	</div>
	<table width="80%" align="center" cellspacing="1" border="0">
  		<tr>
   			<td class="rightAligned" style="padding-left: 50px" >Tax Description </td>
   			<td class="leftAligned">	  
   				<input type="text" id="txtTaxDesc" name="txtTaxDesc" class="required" readonly="readonly" style="display: none; width: 192.5px;"><br>
   			   	<select class="required" id="selTaxDesc" name="selTaxDesc" style="width:200px;">
	   				<option value=""></option>
	   		   	</select>   		  
   		   	</td>
   		</tr>
   		<tr >
   			<td class="rightAligned">Tax Amount</td>
   			<td class="leftAligned"><input type="text" id="taxChargeAmt" name="taxChargeAmt" class="money required" style="width:192px; text-align: right" lastValidValue=""/></td>
   		</tr>
   		<tr>
   			<td class="rightAligned">Tax Allocation </td>
   			<td class="leftAligned">
   				<select fixedTaxAllocation="${taxCharge.fixedTaxAllocation}" id="taxAllocation" name="taxAllocation" style="width:200px;" class="required">
   					<option></option>
   					<option value="F">FIRST</option>
   					<option value="L">LAST</option>
   					<option value="S">SPREAD</option>
   				</select>
   				<input type="hidden" id="fixedTaxAllocation" name="fixedTaxAllocation" value="${taxCharge.fixedTaxAllocation}" />
   			</td>
   			<td>
   		</tr>
   	</table>
	<table align="center">
		<tr>
			<td style="">
				<input type="button" class="button" style="margin-top: 1px; margin-left: 35px;""  id="btnAddTax" name="btnAddTax" value="Add" />
			</td>
			<td style="">
				<input type="button" class="disabledButton"  id="btnDeleteTax" name="btnDeleteTax" value="Delete" toEnable="true"/>  <!--added by steven 10/08/2012 "toEnable" even if the endt. is cancel it is still enabled-->
			</td>
		</tr>
	</table>
</div> <!-- added by robert GENQA 4844 09.21.15 -->
</div>

<script type="text/javascript">
	objUW.taxCharges = JSON.parse('${taxChargesJSON}'.replace(/\\/g, '\\\\'));
	objUW.taxItems = JSON.parse('${gipiWinvTaxJSON}'.replace(/\\/g, '\\\\'));
	/*Added by apollo cruz 02.18.2015
	to check if there are fixed amout taxes that exceed the prem amt per item group	
	*/
	var tempString = "";
	var tempItemGrp = "";
	var toTrim = false;
	
	var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag;
		
	for(var i = 0; i < objUW.takeupListDtls.length; i++) {
		var winv = objUW.takeupListDtls[i];			
		
		for(var j = 0; j < objUW.taxItems.length; j++) {
			var ti = objUW.taxItems[j];
			
			if(winv.itemGrp == ti.itemGrp) {
				
				for(var k = 0; k < objUW.taxCharges.length; k++) {
					var tc = objUW.taxCharges[k];
					
					if(ti.taxCd == tc.taxCd) {
						ti.taxType = tc.taxType;
					}
				}
				
				if(ti.taxType == "A" && parseFloat(ti.taxAmt) > parseFloat(winv.premAmt)){
					
					if(tempItemGrp == "") {
						tempItemGrp = winv.itemGrp;
						tempString += "<b>Item Group " + tempItemGrp + "</b><br/>";
						tempString += ti.taxDesc;
						toTrim = false;
					} else if(tempItemGrp != winv.itemGrp){
						tempItemGrp = winv.itemGrp;
						
						if(toTrim)
							tempString = tempString.substring(0, tempString.length - 2);
						
						tempString += "<br/><b>Item Group " + tempItemGrp + "</b><br/>";
						tempString += ti.taxDesc;
						toTrim = false;
					}else {
						tempString += ", " + ti.taxDesc + ", ";
						toTrim = true;
					}
					
				}	
			}
		}
	}
	
	if(tempString.trim() != "" && '${allowTaxGreaterThanPremium}' == "N"  && recCount == 0 && polFlag != "4" && objUW.cancelType == ""){
		if(toTrim)
			tempString = tempString.substring(0, tempString.length - 2);
		showConfirmBox("Confirmation", "The following Fixed Amount Taxes exceeds the premium amount of their corresponding Item Group : <br/><br/>" + tempString + "<br/><br/>Do you want to continue?", "Yes", "No", null, showItemInfo);
	}
	
	//end of checking of fixed amount taxes
	
	objUW.paramValueV = '${giisParameters.paramValueV}';
	objUW.paramValueN = '${paramValueN}';
    objUW.varDocStamps = '${docStampVal}';
    objUW.allowUpdateTaxEndtCancellation = '${CheckUpdateTaxEndtCancellation}'; //added by steven 11/19/2012 base on SR 0011233
    objUW.allowTaxGreaterThanPremium = '${allowTaxGreaterThanPremium}';	//added by Gzelle 10272014 based on UW-SPECS-2014-093 - GIPIS026 GIPIS017B BILL PREMIUMS
    objUW.taxChargesParam = JSON.parse('${giisTaxCharges}'.replace(/\\/g, '\\\\'));
    var origTempTaxAmt = 0;
    
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	
	//showTaxList(objUW.taxItems);
	function chkIfTaxExist(taxCd){
		try{
			var exist = false;
			$$("div[name='billPremiumRow']").each(function (div) {
				if (div.getAttribute("taxCd") == taxCd){
					exist = true;
				}
			});
			return exist;
		}catch(e){
			showErrorMessage("chkIfTaxExist", e);
		}		
	}
	
	function populateTaxDtls(obj, index){
		try{
			var options = "";
			$("selTaxDesc").length = 0;
			$("selTaxDesc").update('<option value="" issCd="" lineCd="" primarySw="" taxId="" rate="" taxDesc="" taxCd="" noRateTag=""></option>');
			
			for(var i=0; i<obj.length; i++){			
				if (!chkIfTaxExist(obj[i].taxCd)){		//belle 08.16.2012 already filtered in query //added by steven 07.22.2014 binago ko ung process ng LOV.
					//options+= '<option value="'+obj[i].taxCd+'" allocationTag="'+obj[i].allocationTag+'" issCd="'+obj[i].issCd+'" lineCd="'+obj[i].lineCd+'" primarySw="'+obj[i].primarySw+'" taxId="'+obj[i].taxId+'" rate="'+obj[i].rate+'"taxDesc="'+obj[i].taxDesc+'" taxCd="'+obj[i].taxCd+'">'+obj[i].taxDesc+' </option>'; // old
				//	options+= '<option value="'+obj[i].taxCd+'" taxType="'+obj[i].taxType+'"  tempTaxAmt="'+nvl(obj[i].tempTaxAmt,"0")+'" allocationTag="'+obj[i].allocationTag+'" issCd="'+obj[i].issCd+'" lineCd="'+obj[i].lineCd+'" primarySw="'+obj[i].primarySw+'" taxId="'+obj[i].taxId+'" rate="'+obj[i].rate+'" taxDesc="'+obj[i].taxDesc+'" taxCd="'+obj[i].taxCd+'">'+obj[i].taxDesc+'</option>';  // jhing original
					options+= '<option value="'+obj[i].taxCd+'" taxType="'+obj[i].taxType
								+'"  tempTaxAmt="'+nvl(obj[i].tempTaxAmt,"0")
								+'" allocationTag="'+obj[i].allocationTag
								+'" issCd="'+obj[i].issCd
								+'" lineCd="'+obj[i].lineCd
								+'" primarySw="'+obj[i].primarySw
								+'" taxId="'+obj[i].taxId
								+'" rate="'+obj[i].rate
								+'" taxDesc="'+obj[i].taxDesc 
								+'" takeupAllocTag="'+obj[i].takeupAllocTag 
								+'" taxCd="'+obj[i].taxCd
								+'" noRateTag="'+obj[i].noRateTag
								+'">'+obj[i].taxDesc+'</option>'; // jhing 11.09.2014
				}
			}
			$("selTaxDesc").insert({bottom: options}); 
			$("selTaxDesc").selectedIndex = index;
		}catch(e){
			showErrorMessage("populateTaxDtls", e);			
		}
	}
	
	if (objUW.taxCharges.length > 0){		
		populateTaxDtls(objUW.taxCharges, 0);
	}	
	
	function validateEntries(){
		var isValid = true;
		if ($("selTaxDesc").options[0].getAttribute("taxCd") == null) {
			showMessageBox("Tax Description is required.", imgMessage.ERROR);
			isValid = false;
		}else if (isNaN(unformatCurrency("taxChargeAmt")) || $F("taxChargeAmt") == "") {
			showMessageBox("Invalid Tax Amount. Value should be from 0.01 to 9,999,999,999.99 but must not be greater than Premium Amount.", imgMessage.ERROR);
			$("taxChargeAmt").value = formatCurrency(objUW.origTaxAmt);
			isValid = false;
		}else if($F("taxAllocation") == ""){
			showMessageBox("Required Fields must be entered.", imgMessage.ERROR);
			isValid = false;
		}
			
		return isValid;
	}

	function validateTaxEntry(){
		var isValid = true;
		var origTaxAmt = 0;	
		var rate = parseFloat($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("rate"));
		var taxDesc = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].value;

		new Ajax.Request(contextPath + "/GIPIWinvoiceController?action=validateTaxEntry" , {
			method: "GET",
			parameters: {
				parId : $F("initialParId"),//objUWParList.parId,
				lineCd: (objUWGlobal.packParId != null ? $F("initialLineCd") : objUWParList.lineCd),
				issCd : objUWParList.issCd,
				itemGrp : $F("itemGrp"),
				takeupSeqNo : $F("takeupSeqNo"),
				taxAmt: unformatCurrency("taxChargeAmt"),
				origTaxAmt: parseFloat(objUW.origTaxAmt),  // jhing 11.09.2014 added parsefloat
				premAmt: unformatCurrency("premAmt"),
				taxCd: objUW.taxCd,
				taxId: objUW.taxId
			},
			evalscripts: true,
			asynchronous: false,
			onComplete: function(response) {
				var result = response.responseText;
				if (result != "SUCCESS"){
					isValid = false;
					showMessageBox(result, imgMessage.ERROR);
					//$("taxChargeAmt").value = formatCurrency(origTempTaxAmt);//objUW.origTaxAmt); modified by Gzelle 11032014
					$("taxChargeAmt").value = formatCurrency(objUW.origTaxAmt); // jhing 11.09.2014 reverted to objUW.origTaxAmt
				}
			}	
		});

		return isValid;
	}

	function resetDisplayValues(){
		$("txtTaxDesc").value = "";
		$("txtTaxDesc").hide();
		$("selTaxDesc").show();
		$("selTaxDesc").selectedIndex = 0;
		$("selTaxDesc").options[$("selTaxDesc").selectedIndex].text = "";
		$("taxChargeAmt").value = formatCurrency(0);
		$("taxAllocation").selectedIndex = 0;
		$("btnAddTax").value = "Add";
		disableButton("btnDeleteTax");
		$("selTaxDesc").disabled = false;
		objUW.primarySw = "";
	}	
	
	$("btnAddTax").observe("click", function () {
		try{
			if(objUW.validateEntries()){ // andrew - 09.22.2011
				if ($F("itemGrp") != ""){
					if (validateEntries()) { 
						if (validateTaxEntry()){							
							function add() {
								var itmGrp = $F("itemGrp");
								var takeupSeqNo = $F("takeupSeqNo");
								var taxCd = objUW.taxCd;
								var taxAllocation = $("taxAllocation").options[$("taxAllocation").selectedIndex].value;
								var primarySw = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("primarySw");
								var taxDesc = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxDesc");
								var noRateTag = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("noRateTag");
								var taxId = objUW.taxId;
								changeTag = 1; //added  by steven 11/19/2012
								if ($F("btnAddTax") == "Add"){
									if ($("selTaxDesc").selectedIndex > 0) {
										var itemTable = $("billPremiumsTableContainer");								
										var newDiv = new Element("div");
							
										var content =   
										  	'<label style="padding-left:3%; width:10%; text-align:right;">'+ taxCd +'</label>'+
											'<label style="padding-left:11%; width:25%; text-align:left; ">' + taxDesc + '</label>' +
											'<label style="width:20%; text-align:right; margin-left: 14px;" class="money" id="lblTaxAmount'+ itmGrp + takeupSeqNo + taxCd +'">' + $F("taxChargeAmt") + '</label>' +
											'<label style="padding-left:10%; width:16%; text-align:left; ">' + taxAllocation + '</label>';
										
										newDiv.setAttribute("id", "row"+ itmGrp + "" + takeupSeqNo + taxCd);
										newDiv.setAttribute("name", "billPremiumRow");
										newDiv.setAttribute("taxCd", taxCd);
										newDiv.setAttribute("taxId", taxId);
										newDiv.setAttribute("taxAmt", $F("taxChargeAmt"));
										newDiv.setAttribute("taxAllocation", taxAllocation);
										newDiv.setAttribute("primarySw", primarySw);
										newDiv.setAttribute("taxDesc", taxDesc);
										newDiv.setAttribute("noRateTag", noRateTag);
										newDiv.addClassName("tableRow");
										
										newDiv.update(content);
										itemTable.insert({bottom : newDiv});										
										checkIfToResizeTable("billPremiumsTableContainer", "billPremiumRow");
										checkTableIfEmpty("billPremiumRow", "billPremiumsTable");
										divEventsTax(newDiv); 
										setAddedWinvTax();	
										markRecordAddedUpdateDeleted(objUW.taxItems, taxCd, 0);
										populateTaxDtls(objUW.taxCharges, 0);
										updateTaxTotal("Add", taxCd);
										updateAmountDue();
										//resetDisplayValues();
										//fireEvent($("hiddenButtonUpdate"), "click");
										if($("btnUpdate") != null || $("btnUpdate") != undefined){
											//if(objUWParList.parType == "P"){  //commented by d.alcantara, to allow update of gipi_winstallment for endt
												objUW.recomputeInstallment = true;
												fireEvent($("btnUpdate"), "click");
											//}
										}

										resetDisplayValues();
									}else {
										showMessageBox("Tax Description is required.", imgMessage.ERROR);
									}
								}else{
									$("lblTaxAmount" + itmGrp + takeupSeqNo + taxCd).innerHTML = $F("taxChargeAmt");
									$("lblTaxAllocation" + itmGrp + takeupSeqNo + taxCd).innerHTML = $F("taxAllocation");
									markRecordAddedUpdateDeleted(objUW.taxItems, taxCd, 1);
									populateTaxDtls(objUW.taxCharges, 0);
									updateTaxTotal("Update", taxCd);
									updateTaxAmount(objUW.taxItems, taxCd, unformatCurrency("taxChargeAmt"));
									updateAmountDue();
									//resetDisplayValues();
									//fireEvent($("hiddenButtonUpdate"), "click");
									if($("btnUpdate") != null || $("btnUpdate") != undefined){
										//if(objUWParList.parType == "P"){
											objUW.recomputeInstallment = true; //tonio july 6, 2011
											fireEvent($("btnUpdate"), "click");
										//}							
									}
									resetDisplayValues();
								}	
							}
							
							/*Added by apollo cruz 02.18.2015
							* As per Ma'am VJ, a confirmation message must be displayed instead of not allowing the user to continue
							* if allowTaxGreaterThanPremium = N and the selected Fixed Amount Tax is greater than the Prem Amt.
							*/
							var taxType = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxtype") == null ? objUW.taxType : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxtype");
							if('${allowTaxGreaterThanPremium}' == "N" && taxType == "A" && unformatCurrency("taxChargeAmt") > unformatCurrency("premAmt") && nvl('${endtTax}', 'N') != "Y") {
								showConfirmBox("Confirmation", "Fixed Tax Amount is greater than Premium Amount. Do you want to continue?", "Yes", "No", add, null);
							} else {
								add();
							}
							
						}
					}
				}else {
					showMessageBox("Please select a takeup first.", imgMessage.INFO);
				}
			}
		}catch(e){
			showErrorMessage("btnAddTax",e);
		}
		
	});	

	function setAddedWinvTax(){
		var newObj = new Object();
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		
		try{    
			newObj.parId  		= $F("initialParId");//objUWParList.parId;
			newObj.itemGrp  	= selItemGrp;
			newObj.takeupSeqNo  = selTakeup;
			newObj.taxCd  = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd");
			newObj.taxId  = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId");
			newObj.lineCd  = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("lineCd");
			newObj.issCd  = objUWParList.issCd;
			newObj.taxAllocation  = $("taxAllocation").options[$("taxAllocation").selectedIndex].value;
			newObj.fixedTaxAllocation  = $("taxAllocation").options[$("taxAllocation").selectedIndex].value == "N" ? "Y" : "N";
			newObj.taxAmt  = unformatCurrency("taxChargeAmt");
			newObj.rate  = (parseFloat(unformatCurrency("taxChargeAmt"))/parseFloat(unformatCurrency("premAmt")))*100; //added by steven 11/27/2012 -> old formula: $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("rate"); steven
			newObj.taxDesc = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxDesc");
			newObj.recordStatus		= 0;
			newObj.noRateTag = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("noRateTag");
			newObj.taxType = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxType");

			objUW.taxItems.push(newObj);

			return newObj;			    			
		}catch(e){
			showErrorMessage("setAddedWinvTax", e);
			//showMessageBox("setAddedWinvTax : " + e.message);
		}
	}

	function divEventsTax(div) {
		div.observe("mouseover", function () {
			div.addClassName("lightblue");
		});
		
		div.observe("mouseout", function ()	{
			div.removeClassName("lightblue");
		});

		div.observe("click", function () {
			selectedRowId = div.getAttribute("id");
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow"))	{
				$$("div[name='billPremiumRow']").each(function (r)	{
					if (div.getAttribute("id") != r.getAttribute("id"))	{
						r.removeClassName("selectedRow");
					}else{
						//$("selTaxDesc").options[$("selTaxDesc").selectedIndex].text = r.getAttribute("taxDesc");
						$("selTaxDesc").hide();
						$("txtTaxDesc").show();
						$("txtTaxDesc").value = r.getAttribute("taxDesc");
						$("taxChargeAmt").value = formatCurrency(r.getAttribute("taxAmt"));
						$("taxAllocation").value = r.getAttribute("taxAllocation");
						$("btnAddTax").value = "Update";
						enableButton("btnDeleteTax");
						objUW.origTaxAmt = r.getAttribute("taxAmt").replace(/,/g, "");
						objUW.taxCd = r.getAttribute("taxCd");
						objUW.taxId = r.getAttribute("taxId");
						objUW.primarySw = r.getAttribute("primarySw");
						objUW.rate = r.getAttribute("rate");
						objUW.noRateTag = r.getAttribute("noRateTag");
					}
			    });		
			}else{
				resetDisplayValues();
			} 
		});
	}

/* 	function resetDisplayValues(){
		$("selTaxDesc").selectedIndex = 0;
		$("selTaxDesc").options[$("selTaxDesc").selectedIndex].text = "";
		$("taxChargeAmt").value = formatCurrency(0);
		$("taxAllocation").selectedIndex = 0;
		$("btnAddTax").value = "Add";
		//enableButton("btnAddTax");
		disableButton("btnDeleteTax");
		objUW.primarySw = "";
	} */
	
	$("btnDeleteTax").observe("click", function () {
		//objUW.primarySw = 'N';
		$$("div[name='billPremiumRow']").each(function (row)	{
			if (row.hasClassName("selectedRow"))	{
              if(objUW.primarySw =='Y'){
            	  if('${endtTax}' == 'Y'){
            		  changeTag = 1; //added by steven 11/19/2012
            		  Effect.Fade(row, {
  						duration: .5,
  						afterFinish: function ()	{
  							markRecordAddedUpdateDeleted(objUW.taxItems, row.getAttribute("taxCd"), -1);
  							row.remove();
  							updateTaxTotal("Delete", row.getAttribute("taxCd"));
  							updateAmountDue();
  							populateTaxDtls(objUW.taxCharges, 0);
  							resetDisplayValues();
  							checkTableIfEmpty("billPremiumRow", "billPremiumsTable");
  							objUW.recomputeInstallment = true;
  							fireEvent($("btnUpdate"), "click");
  						}
  					});
            	  }else{
            		  showMessageBox('You cannot delete this record.', imgMessage.ERROR);
            	  }
              } else{
            	  changeTag = 1; //added by steven 11/19/2012
					Effect.Fade(row, {
						duration: .5,
						afterFinish: function ()	{
							markRecordAddedUpdateDeleted(objUW.taxItems, row.getAttribute("taxCd"), -1);
							row.remove();
							updateTaxTotal("Delete", row.getAttribute("taxCd"));
							updateAmountDue();
							populateTaxDtls(objUW.taxCharges, 0);
							resetDisplayValues();
							checkTableIfEmpty("billPremiumRow", "billPremiumsTable");
							objUW.recomputeInstallment = true;
							fireEvent($("btnUpdate"), "click");
						}
					});
		       }
		   	}      
		});
	});

	function prepareParameters(){
		try {			
			var addedModifiedWinvTax = getAddedModifiedJSONObject(objUW.taxItems);
			var deletedWinvTax = getDeletedJSONObject(objUW.taxItems);
			// Sets the parameters
			var objParameters = new Object();
			objParameters.addedModifiedWinvTax = addedModifiedWinvTax;
			objParameters.deletedWinvTax = deletedWinvTax;

			return JSON.stringify(objParameters);
		} catch (e) {
			showErrorMessage("prepareParameters", e);
		}
	}

	//function getAddedModified 
	function getAddedModifiedJSONObject(obj){
		var tempObjArray = new Array();
		for(var i=0; i<obj.length; i++) {	
			if (obj[i].recordStatus == 0){
				tempObjArray.push(obj[i]);
			}else if (obj[i].recordStatus == 1){
				tempObjArray.push(obj[i]);
			}
		}
		
		return tempObjArray;
	}
	
	//function getDeleted 
	function getDeletedJSONObject(obj){
		var tempObjArray = new Array();
		for(var i=0; i<obj.length; i++) {	
			if (obj[i].recordStatus == -1){
				tempObjArray.push(obj[i]);
			}
		}
		
		return tempObjArray;
	}

	function updateTaxTotal(option, taxCd){
		if (option == "Add"){
			if (taxCd != objUW.otherChargesTaxCd){
				$("taxAmt").value = formatCurrency(unformatCurrency("taxAmt") + unformatCurrency("taxChargeAmt"));
			}else{
				$("otherCharges").value = formatCurrency(unformatCurrency("otherCharges") + unformatCurrency("taxChargeAmt"));
			}
		}else if (option == "Delete") {
			if (taxCd != objUW.otherChargesTaxCd){
				$("taxAmt").value = formatCurrency(unformatCurrency("taxAmt") - unformatCurrency("taxChargeAmt"));
			}else{
				$("otherCharges").value = formatCurrency(unformatCurrency("otherCharges") - unformatCurrency("taxChargeAmt"));
			}
		}else {			
			if (taxCd != objUW.otherChargesTaxCd){
				//$("taxAmt").value = formatCurrency(unformatCurrency("taxAmt") + Math.abs(objUW.origTaxAmt - unformatCurrency("taxChargeAmt")));
				//$("taxAmt").value = formatCurrency(unformatCurrency("taxChargeAmt") + Math.abs(unformatCurrency("taxAmt") - objUW.origTaxAmt)); // jhing 11.18.2014 original code 
				$("taxAmt").value = formatCurrency(unformatCurrency("taxChargeAmt") + unformatCurrency("taxAmt") - objUW.origTaxAmt);
			}else{
				//$("otherCharges").value = formatCurrency(unformatCurrency("otherCharges") - unformatCurrency("taxChargeAmt"));
				$("otherCharges").value = unformatCurrency("taxChargeAmt");	//added by Gzelle 02232015
			}
		}
	}

/* 	function objTaxValues(){
		for (var i=0; i<taxItems.length; i++){
			
		}
	} */ //remove by steven 07.22.2014

	function updateAmountDue()	{
		$("amountDue").value = formatCurrency(unformatCurrency("taxAmt") + unformatCurrency("premAmt") + unformatCurrency("otherCharges"));
	}
	
	function markRecordAddedUpdateDeleted(obj, taxCd, param){
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		for (var i=0; i<obj.length; i++){
			// andrew - 09.20.2011 - modified the condition
			//if (obj[i].taxCd == taxCd && obj[i].itemGrp == selItemGrp && obj[i].takeupSeqNo == selTakeup){
			if (obj[i].taxCd == taxCd && obj[i].itemGrp == selItemGrp && obj[i].takeupSeqNo == selTakeup && (obj[i].recordStatus == undefined || obj[i].recordStatus == 0)){ //belle 07.10.12 added condition to update recordStatus of newly added record
				obj[i].recordStatus = param;
			}
		}
	}

	function updateTaxAmount(obj, taxCd, param){
		var selItemGrp = $F("itemGrp");
		var selTakeup  = $F("takeupSeqNo");
		for (var i=0; i<obj.length; i++){
			if (obj[i].taxCd == taxCd && obj[i].itemGrp == selItemGrp && obj[i].takeupSeqNo == selTakeup){
				obj[i].taxAmt = param;
				obj[i].taxAllocation = $F("taxAllocation");
				obj[i].rate = (parseFloat(param)/parseFloat(unformatCurrency("premAmt")))*100; //added by steven 11/27/2012
			}
		}
	}
	
	
	function getRangeAmount() { //added by steven 07.22.2014
		try {
			var result = null;  // added by jhing 11.09.2014 
		    new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getRangeAmount",
							  taxCd : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd"),
							  taxId : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId"),  // added by jhing 11.09.2014
							  parId : $F("initialParId"),//objUWParList.parId, //kenneth SR 22090 04.08.2016
							  premAmt : unformatCurrency("premAmt") ,
							  itemGrp : $F("itemGrp"),
							  takeupSeqNo : $F("takeupSeqNo"),
							  //takeupAllocTag : nvl($F("taxAllocation"),'F') // replaced by jhing 11.09.2014 
							  takeupAllocTag : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("takeupAllocTag")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						//$("taxChargeAmt").value = formatCurrency(nvl(response.responseText,'0')); // replaced by jhing 11.09.2014
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;  // added by jhing 11.09.2014
		} catch (e) {
			showErrorMessage("getRangeAmount",e);
		}
	}	
	
	function getRateAmount() { //added by steven 08.15.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getRateAmount",
							  taxCd : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd"),
							  taxId : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId"),
							  parId : $F("initialParId"),//objUWParList.parId, //kenneth SR 22090 04.08.2016
							  itemGrp : $F("itemGrp"),
							  takeupSeqNo : $F("takeupSeqNo")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getRangeAmount",e);
		}
	}
	
	function getDocStampsTaxAmt() { //added by jhing 11.07.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getDocStampsTaxAmt",
							  taxCd : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd"),
							  taxId : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId"),
							  parId : $F("initialParId"),//objUWParList.parId, //kenneth SR 22090 04.08.2016
							  premAmt : unformatCurrency("premAmt"),
							  itemGrp : $F("itemGrp"),
							  takeupSeqNo : $F("takeupSeqNo"),
							  takeupAllocTag : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("takeupAllocTag")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getDocStampsTaxAmt",e);
		}
	}	
	
	function getFixedAmountTax() { //added by jhing 11.07.2014
		try {
			var result = null;
			new Ajax.Request(contextPath + "/GIPIWinvoiceController", {
				parameters : {action : "getFixedAmountTax",
							  taxCd : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd"),
							  taxId : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId"),
							  parId : $F("initialParId"),//objUWParList.parId, //kenneth SR 22090 04.08.2016
							  premAmt : unformatCurrency("premAmt"),
							  tempTaxAmt : parseFloat(nvl($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0")),
							  itemGrp : $F("itemGrp"),
							  takeupSeqNo : $F("takeupSeqNo"),
							  takeupAllocTag : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("takeupAllocTag")},
			  	asynchronous: false,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						result = nvl(response.responseText,'0');
					}
				}
			});
			return result;
		} catch (e) {
			showErrorMessage("getFixedAmountTax",e);
		}
	}		
	
	function getTaxList(itemGrp) { //added by steven 07.22.2014
		try {
			if(objUWGlobal.packParId == null){ //added by robert GENQA 4844 09.02.15
			if (itemGrp == null) {
				for ( var i = 0; i < objUW.takeupListDtls.length; i++) {
					itemGrp = objUW.takeupListDtls[i].itemGrp;
					break;
				}				
			}
			new Ajax.Request(contextPath + "/GIPIWinvTaxController", {
				parameters : {action : "getTaxList",
							  parId: objUWParList.parId,
							  lineCd: objUWParList.lineCd,
							  issCd: objUWParList.issCd,
							  itemGrp : itemGrp,
							  takeupSeqNo :$F("takeupSeqNo") // jhing 11.09.2014 
							  },
			  	asynchronous: true,
			    evalScripts: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						objUW.taxCharges = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
						if (objUW.taxCharges.length > 0){		
							populateTaxDtls(objUW.taxCharges, 0);
						}	
					}
				}
			});
			} //added by robert GENQA 4844 09.02.15
		} catch (e) {
			showErrorMessage("getRangeAmount",e);
		}
	}
	objUW.getTaxList = getTaxList;
	
	// robert 01.07.2013 copied from devt 
	$("selTaxDesc").observe("change", function () {
		var rate = parseFloat($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("rate"));
		var taxDesc = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxDesc");
		var taxChargeAmt = 0;
		var tax = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].value;
		var taxType = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxType");
		var premAmt = unformatCurrency("premAmt");
		var currencyRt = 1;
		
		$("taxAllocation").value = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");
		objUW.origTaxAmt = unformatCurrency("taxChargeAmt");
		objUW.taxCd = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd");
		objUW.taxId = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId");
		objUW.taxAllocation = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");
		
		function continueSelTaxDesc() {
			//if(taxDesc =='DOCUMENTARY STAMPS' && objUW.paramValueV == 'Y'){
			//added by steven 07.23.2014
			for ( var i = 0; i < objUW.takeupListDtls.length; i++) {
				if(objUW.takeupListDtls[i].itemGrp == $F("itemGrp").trim()){
					currencyRt = objUW.takeupListDtls[i].currencyRt;
					break;
				}
			}	
			
			if (tax == objUW.varDocStamps ) { // jhing 11.07.2014 separated the tax computation for docstamps 
				taxChargeAmt = getDocStampsTaxAmt (); 
			}else if(taxType == "A"){ // added by irwin 7.27.2012
				// $("taxChargeAmt").value = formatCurrency(parseFloat(nvl($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0")) / parseFloat(currencyRt)); // jhing 11.08.2014 commented out and replaced code
				taxChargeAmt = getFixedAmountTax();  // jhing 11.08.2014
			}else if(taxType == "N"){
				taxChargeAmt = getRangeAmount(); //added by steven 07.22.2014 // jhing 11.09.2014 assigned to a variable
				taxChargeAmt = premAmt == 0 ? 0 : taxChargeAmt; //added by pol cruz 02.03.2015
			}else if (taxType == "R"){
				taxChargeAmt = getRateAmount();
				/* Added by christian 09252012
				 * Change the computation of tax_amt for 'DOC STAMPS'                  *
		       	 * Tax amt will be .50c for every 4 pesos and for any amount in excess */
		       	 
		       	/* Commented out by jhing 11.08.2014                                   *
		       	** Docstamps will have a separate function                             *
		       	** due to the different parameters/condition it should consider        */
		       	
			  /*if((premAmt % 4 != 0) && tax == objUW.varDocStamps && objUW.paramValueV == 'Y'){
					//$("taxChargeAmt").value=formatCurrency(($F("premAmt").replace(/,/g,"")/4)*(0.5)+(0.5));
					taxChargeAmt = Math.ceil($F("premAmt").replace(/,/g,"")/4)*(0.5)+(0.5);//cxc to investigate
				} else{
					//$("taxChargeAmt").value=formatCurrency((rate/100)*$F("premAmt").replace(/,/g, ""));
					//taxChargeAmt = (rate/100)*$F("premAmt").replace(/,/g, ""); remove by steven 08.15.2014
					taxChargeAmt = getRateAmount();
				}      
				
				$("taxChargeAmt").value = formatCurrency(parseFloat(taxChargeAmt)+($F("otherCharges") == "" ? 0 : parseFloat($F("otherCharges").replace(/,/g,""))));  */
			}
			
			$("taxChargeAmt").value = formatCurrency(parseFloat(taxChargeAmt)+($F("otherCharges") == "" ? 0 : parseFloat($F("otherCharges").replace(/,/g,""))));  // jhing 11.08.2014 
			objUW.origTaxAmt = parseFloat($("taxChargeAmt").value);
		}
		//objUW.origTaxAmt = nvl($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0"); // jhing 11.08.2014 commented out.
		//origTempTaxAmt = nvl($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0");  // jhing 11.08.2014 commented out. The temp tax should be equal to the computed tax amount and not to giis_tax_charges.tax_amount
    	/*$("taxAllocation").value = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");
		objUW.origTaxAmt = unformatCurrency("taxChargeAmt");
		objUW.taxCd = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd");
		objUW.taxId = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId");
		objUW.taxAllocation = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");*/
		if ($F("itemGrp") != "") { 
			// jhing 11.08.2014 
			continueSelTaxDesc(); 
			origTempTaxAmt  = $("taxChargeAmt").value;
			objUW.origTaxAmt =  $("taxChargeAmt").value; 
			
			$("taxChargeAmt").setAttribute("lastValidValue", $F("taxChargeAmt")); //Apollo Cruz 02.17.2015
			
			/* Commented out by jhing 11.08.2014                                            *
	       	** The validation on allowTaxGreaterThanPremium should fire after the           *
	       	** tax amount has been computed by the function continueSelTaxDesc              */

			
			/*if((nvl($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("tempTaxAmt"), "0")) > premAmt && nvl('${endtTax}', 'N') != 'Y'){	//added by Gzelle 1022014 
				if (polFlag != "4") {	//
					if (objUW.allowTaxGreaterThanPremium == "Y" && parTypeCond == "P" && checkGiisTaxCharges()) {  
						continueSelTaxDesc();
					}else {
						showWaitingMessageBox("Invalid Tax Amount. Tax Amount should not be greater than the Premium.", "E", function(){
							origTempTaxAmt = 0;
							$("taxChargeAmt").value = formatCurrency(0);
							$("taxChargeAmt").select();
						});
					}
				}
			}else {
				continueSelTaxDesc();
			} */
		}else {
			showMessageBox("Please select a takeup first.", imgMessage.INFO);
		}
	});
	
	/* $("selTaxDesc").observe("change", function () {
		var rate = parseFloat($("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("rate"));
		var taxDesc = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxDesc");
		var taxChargeAmt = 0;
		var tax = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].value;
		//if(taxDesc =='DOCUMENTARY STAMPS' && objUW.paramValueV == 'Y'){
		if(tax == objUW.varDocStamps && objUW.paramValueV == 'Y'){
			//$("taxChargeAmt").value=formatCurrency(($F("premAmt").replace(/,/g,"")/4)*(0.5)+(0.5));
			taxChargeAmt = Math.ceil($F("premAmt").replace(/,/g,"")/4)*(0.5)+(0.5);
		} else{
			//$("taxChargeAmt").value=formatCurrency((rate/100)*$F("premAmt").replace(/,/g, ""));
			taxChargeAmt = (rate/100)*$F("premAmt").replace(/,/g, "");
		}
		
		$("taxAllocation").value = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");
		objUW.origTaxAmt = unformatCurrency("taxChargeAmt");
		objUW.taxCd = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd");
		objUW.taxId = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxId");
		objUW.taxAllocation = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("allocationTag");
	}); */
	
	$("selTaxDesc").observe("click", function () {
		if ($("btnAddTax").value != "Add") {
			$("selTaxDesc").selectedIndex = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].selectedIndex;
			showMessageBox("You cannot change this tax. This tax is required for this line.", imgMessage.INFO);
		}
	});
	
	checkTableIfEmpty("billPremiumRow", "billPremiumsTable");
	
	//added by steven 10/08/2012
	var parTypeCond = (objUWGlobal.parType != null ? objUWGlobal.parType : $F("globalParType"));
	//var polFlag = objUWParList.packParId == null ? $F("globalPolFlag"): objUWGlobal.polFlag; -- moved to top by apollo cruz 02.18.2015
 	if(parTypeCond == "E" && "4" == polFlag && '${CheckUpdateTaxEndtCancellation}' != "Y"){  //added by steven 11/19/2012 -> ${CheckUpdateTaxEndtCancellation} base on SR 0011233
		showMessageBox("This is a cancellation type of endorsement, update/s of any details will not be allowed.", imgMessage.WARNING);
		checkIfCancelledEndorsement(); // added by: steven 10/08/2012 - to check if it will disable the fields if PAR is a cancelled endt	
	} 
 	
	//added by robert 01.07.2013 validation for Tax Amount
	var initTaxChargeAmt;
	
	$("taxChargeAmt").observe("focus", function () {
		if ($F("taxChargeAmt") != ""){
			initTaxChargeAmt = $F("taxChargeAmt");
			origTempTaxAmt = $F("taxChargeAmt");
		}
	});
	
	$("taxChargeAmt").observe("keyup", function(){
		if($F("taxChargeAmt").charAt(0) == '-'){
			if(isNaN($F("taxChargeAmt").replace(/-/, ''))){
				$("taxChargeAmt").value = nvl(initTaxChargeAmt,"");
				$("taxChargeAmt").select();
			}else if ($F("taxChargeAmt") != ""){
				initTaxChargeAmt = $F("taxChargeAmt");
			}
		}else{
			if(isNaN($F("taxChargeAmt"))){
				$("taxChargeAmt").value = nvl(initTaxChargeAmt,"");
				$("taxChargeAmt").select();
			}else if ($F("taxChargeAmt") != ""){
				initTaxChargeAmt = $F("taxChargeAmt");
			}
		}
	});
	
	$("taxChargeAmt").observe("change", function () {
		//Added by apollo cruz 02.17.2015 - as per Rai, Fixed Taxed Amounts (taxtype = A) must not be updateable
		var taxType = $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxtype") == null ? objUW.taxType : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxtype");
		var noRateTag = $("selTaxDesc").style.display == "none" ? objUW.noRateTag : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("noRateTag");
		var primarySw = $("selTaxDesc").style.display == "none" ? objUW.primarySw : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("primarySw");
		var taxCd = $("selTaxDesc").style.display == "none" ? objUW.taxCd : $("selTaxDesc").options[$("selTaxDesc").selectedIndex].getAttribute("taxCd");
		
		if(objUW.evat == taxCd){
			showWaitingMessageBox("Update is not allowed for VAT.", "E", function(){
				$("taxChargeAmt").value = $("taxChargeAmt").getAttribute("lastValidValue");
				$("taxChargeAmt").focus();
			});
		} else if(taxType == "A" && nvl('${endtTax}', 'N') != "Y") {
			if(unformatCurrencyValue($F("taxChargeAmt")) != unformatCurrencyValue($("taxChargeAmt").getAttribute("lastValidValue")))
				showWaitingMessageBox("Tax Amount must not be less than " + $("taxChargeAmt").getAttribute("lastValidValue") + " and must not exceed " + $("taxChargeAmt").getAttribute("lastValidValue") + ".", "E", function(){
					$("taxChargeAmt").value = $("taxChargeAmt").getAttribute("lastValidValue");
					$("taxChargeAmt").focus();
				});
		} else if ($F("taxChargeAmt") == null || $F("taxChargeAmt") == ""){
			showWaitingMessageBox("Required fields must be entered", "E", function(){
				$("taxChargeAmt").value = initTaxChargeAmt;
				$("taxChargeAmt").focus();
			});
		} else if(taxType == "R" 
				&& noRateTag == "N" 
				&& nvl(primarySw, "N") == "Y"  
				&& nvl('${endtTax}', 'N') != "Y") {
			if(unformatCurrencyValue($F("taxChargeAmt")) != unformatCurrencyValue($("taxChargeAmt").getAttribute("lastValidValue")))
				showWaitingMessageBox("Tax Amount must not be less than " + $("taxChargeAmt").getAttribute("lastValidValue") + " and must not exceed " + $("taxChargeAmt").getAttribute("lastValidValue") + ".", "E", function(){
					$("taxChargeAmt").value = $("taxChargeAmt").getAttribute("lastValidValue");
					$("taxChargeAmt").focus();
			});
		}else{
			if(parseInt(initTaxChargeAmt) > 9999999999.99 || parseInt(initTaxChargeAmt) < -9999999999.99){
				showWaitingMessageBox("Invalid Tax Amount. Value should be from -9,999,999,999.99 to 9,999,999,999.99.", "E", function(){
					// $("taxChargeAmt").value = formatCurrency(0);      // jhing 11.09.2014 commented out and replace code
					$("taxChargeAmt").value = formatCurrency(origTempTaxAmt); // jhing 11.09.2014 new code
					$("taxChargeAmt").select();
				});
			}else if(Math.abs(parseFloat(unformatCurrency("taxChargeAmt"))) > Math.abs(parseFloat(unformatCurrency("premAmt"))) && nvl('${endtTax}', 'N') != 'Y'){	//added by Gzelle 09162014; marco - 10.22.2014 - added endtTax condition ; jhing 11.08.2014 added call to Math.abs
				if (polFlag != "4") {
					if (objUW.allowTaxGreaterThanPremium == "Y" && parTypeCond == "P" && checkGiisTaxCharges()) {  
						$("taxChargeAmt").value = formatCurrency(nvl(initTaxChargeAmt,0));
					}else if (checkGiisTaxCharges()) {    // jhing 11.10.2014 instead of else used else if checkGiisTaxCharges to prevent firing of validation for non-fixed amount tax type
						showWaitingMessageBox("Invalid Tax Amount. Tax Amount should not be greater than the Premium.", "E", function(){
							$("taxChargeAmt").value = formatCurrency(origTempTaxAmt);
							$("taxChargeAmt").select();
						});
					}
				}
			}else{
				$("taxChargeAmt").value = formatCurrency(nvl(initTaxChargeAmt,0));
			}
		}
	});
	//end robert 01.07.2013
	getTaxList(null); //added by steven 7.22.2014

	function checkGiisTaxCharges() {
		var ret = false;
		for ( var x = 0; x < objUW.taxChargesParam.length; x++) {
			if (objUW.taxChargesParam[x].taxCd == objUW.taxCd && objUW.taxChargesParam[x].taxId == objUW.taxId) {
				if (/*objUW.taxChargesParam[x].noRateTag == "Y" && */objUW.taxChargesParam[x].taxType == "A") {  // jhing 11.10.2014 commented out checking in no_rate_tag
					ret = true;
				}
			}
		}
		return ret;
	}
</script>

