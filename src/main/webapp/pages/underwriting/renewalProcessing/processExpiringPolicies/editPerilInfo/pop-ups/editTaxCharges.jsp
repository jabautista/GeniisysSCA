<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="editTaxChargesMainDiv">
	<div id="editTaxChargesSectionDiv" class="sectionDiv" style="width: 662px; margin-top: 20px;">
		<div style="height: 230px; margin-left: 25px;">
			<div id="taxChargesTableGrid" style="height: 200px; width: 612px;; margin-bottom: 5px; margin-top: 15px;"></div>
			<input id="sumTaxAmt" name="sumTaxAmt" type="text" style="width: 164px; float: right; text-align: right; margin-right: 25px;" readonly="readonly"  class="money">
		</div>
		<div  id="editTaxChargesContentsDiv" style="margin-top: 10px;" align="center">
			<table>
				<tr>
					<td class="rightAligned" style="width: 100px;">Tax Description</td>
					<td class="leftAligned"  style="width: 300px;">
						<div style="width: 70px;" class="withIconDiv required">
							<input type="text" id="txtTaxCd" name="txtTaxCd" value="" style="width: 45px;" class="withIcon required" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="taxCdLOV" name="taxCdLOV" alt="Go" />
						</div>
						<input type="text" id="txtTaxDesc" name="txtTaxDesc" value="" style="width: 200px;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="100px">Tax Amount</td>
					<td class="leftAligned" width="290px">
						<input type="text" id="txtTaxAmt" name="txtTaxAmt" style="width: 276px;" class="money"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="hidden" style="display: none;">
			<input type="hidden" id="txtB880PolicyId" name="txtB880PolicyId">
			<input type="hidden" id="txtB880LineCd" name="txtB880LineCd">
			<input type="hidden" id="txtB880IssCd" name="txtB880IssCd">
			<input type="hidden" id="txtB880TaxId" name="txtB880TaxId">
			<input type="hidden" id="txtB880Rate" name="txtB880Rate">
			<input type="hidden" id="txtB880NbtPrimarySw" name="txtB880NbtPrimarySw">	
			<input type="hidden" id="txtB880PerilSw" name="txtB880PerilSw">
			<input type="hidden" id="txtB880AllocationTag" name="txtB880AllocationTag">
			<input type="hidden" id="txtB880NbtTaxAmt" name="txtB880NbtTaxAmt">
			<input type="hidden" id="txtInitialTaxCd" name="txtInitialTaxCd">
			<input type="hidden" id="txtB880NoRateTag" name="txtB880NoRateTag"><!-- added by joanne 01.17.14, for no rate taxes -->
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" class="button" id="btnAddTaxCharges" name="btnAddTaxCharges" value="Add" style=" width: 80px;"/>
			<input type="button" class="button" id="btnDeleteTaxCharges" name="btnDeleteTaxCharges" value="Delete" style=" width: 80px;"/>
		</div>
	</div>
	<div id="editTaxChargesButtonsDiv" name="editTaxChargesButtonsDiv" class="buttonsDiv" style="width: 99%; margin-top: 15px; margin-bottom: 0px;">
		<input type="button" class="button" id="btnOk" name="btnOk" value="Ok">
		<input type="button" class="button" id="btnCancelTax" name="btnCancelTax" value="Cancel">
		<input type="button" class="button" id="btnRecompute" name="btnRecompute" value="Recompute Taxes">
	</div>
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	var objNewGroupTax  = new Object(); 
	var selectedB880 = null;
	var selectedB880Row = new Object();
	var mtgId = null;
	objNewGroupTax .b880ListTableGrid = JSON.parse('${taxChargesTableGrid}'.replace(/\\/g, '\\\\'));
	objNewGroupTax .b880= objNewGroupTax .b880ListTableGrid.rows || [];
	
	try {
		var b880ListingTable = {
			url: contextPath+"/GIEXNewGroupTaxController?action=getGIEXS007B880Info&refresh=1&mode=1&policyId="+$F("txtB240PolicyId"),
			options: {
				newRowPosition: 'bottom',
				width: '612px',
				height: '181px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = b880Grid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						//console.log(JSON.stringify(b880Grid.geniisysRows[y]));
						selectedB880 = y;
						selectedB880Row = b880Grid.geniisysRows[y];
						setB880Info(selectedB880Row);
						removeTaxChargesFocus();
					}
				},
				onRemoveRowFocus : function(){
					setB880Info(null);
					removeTaxChargesFocus();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
				}
			},
			columnModel: [
							{   
								id: 'recordStatus',
							    width: '0',
							    visible: false,
							    editor: 'checkbox' 			
							},
							{	
								id: 'divCtrId',
								width: '0',
								visible: false
							},
							{
								id: 'taxCd',
								title: 'Tax Code',
								width: '100',
								titleAlign: 'right',
								align: 'right',
								editable: false,
								filterOption: true,
								filterOptionType: 'integerNoNegative',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
								}
							}, 
							{
								id: 'taxDesc',
								title: 'Tax Description',
								width: '318',
								editable: false,
								filterOption: true
							},
							{
								id: 'taxAmt',
								/* comment by joanne 060214
								title: 'Tax Amount',
								width: '164',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false,
								filterOption: true,
								filterOptionType: 'number'*/
								width: '0',
								visible: false
							},
							//added by joanne 060214
							{
								id: 'currencyTaxAmt',
								title: 'Tax Amount',
								width: '164',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false,
								filterOption: true,
								filterOptionType: 'number',
								renderer: function (value){
									return nvl(value, "") == "" ? "0.00" : value;
								}
							},
							{	
								id: 'lineCd',
								width: '0',
								visible: false
							},
							{	
								id: 'issCd',
								width: '0',
								visible: false
							},
							{	
								id: 'rate',
								width: '0',
								visible: false
							},
							{	
								id: 'perilSw',
								width: '0',
								visible: false
							},
							{	
								id: 'taxId',
								width: '0',
								visible: false
							},
							{	
								id: 'allocationTag',
								width: '0',
								visible: false
							},
							{	
								id: 'policyId',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtPrimarySw',
								width: '0',
								visible: false
							},
							{	
								id: 'initialTaxCd',
								width: '0',
								visible: false
							},
							{	//added by joanne 01.17.14
								id: 'noRateTag',
								width: '0',
								visible: false
							}
						],
			resetChangeTag: true,
			rows: objNewGroupTax .b880
		};
		b880Grid = new MyTableGrid(b880ListingTable);
		b880Grid.pager = objNewGroupTax .b880ListTableGrid;
		b880Grid.render('taxChargesTableGrid');
		b880Grid.afterRender = function(){
			var rows = b880Grid.geniisysRows;
		      if(rows.length > 0){
		    	  var total = 0;
		    	  for(var i=0; i<rows.length;  i++){
						//total += parseFloat(rows[i].taxAmt); joanne 060214, change to currencyTaxAmt
		    		  	total += parseFloat(nvl(rows[i].currencyTaxAmt, "0"));
					}
			      $("sumTaxAmt").value = formatCurrency(total);
		      }else{
		    	 // clearTotals();
		      }
		   };
	}catch(e) {
		showErrorMessage("b880Grid", e);
	}
	
	function computeNewTaxAmt(policyId, issCd, lineCd, taxCd, taxId, itemNo){
		try{
			new Ajax.Request(contextPath+"/GIEXNewGroupTaxController?action=computeNewTaxAmt", {
				method: "POST",
				parameters: {	policyId					: 	policyId,
							 	issCd 						:	issCd,
							 	lineCd						:	lineCd,
							 	taxCd						:	taxCd,
							 	taxId						:	taxId,
								itemNo						: 	itemNo			
				},
				onComplete: function(response){
					$("txtTaxAmt").value = JSON.parse(response.responseText);
					$("txtB880NbtTaxAmt").value = roundNumber($("txtTaxAmt").value * $("txtB480CurrencyRt").value, 2); //added by joanne 06.02.14
				}
			});
		}catch(e) {
			showErrorMessage("computeNewTaxAmt", e);
		}
	}
	
	function showTaxListLOV(lineCd, issCd, policyId, notIn) {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getTaxListLOV",
											lineCd: lineCd,
											issCd: issCd,
											policyId: policyId,
											notIn: notIn,
											page : 1},
			title: "Tax/Charges",
			width: 500,
			height: 300,
			columnModel: [ {   id: 'recordStatus',
								    title: '',
								    width: '0',
								    visible: false,
								    editor: 'checkbox' 			
								},
								{	id: 'divCtrId',
									width: '0',
									visible: false
								},
								{
									id: 'taxCd',
									title: 'Tax Code',
									width: '60px',
									titleAlign: 'right',
									align: 'right'
								},
								{
									id: 'taxDesc',
									title: 'Desciption',
									width: '250px'
								},
								{
									id: 'rate',
									title: 'Rate',
									width: '50px',
									titleAlign: 'right',
									align: 'right'
								},
								{
									id: 'lineCd',
									title: 'Line Cd',
									width: '80px'
								},
								{
									id: 'issCd',
									title: 'Issue Cd',
									width: '80px'
								},
								{
									id: 'taxId',
									title: 'Tax Id',
									titleAlign: 'right',
									align: 'right',
									width: '40px'
								},
								{	//added by joanne 01.18.14
									id: 'primarySw',
									width: '0',
									visible: false
								},
								{	
									id: 'noRateTag',
									width: '0',
									visible: false
								}
			              ],
			draggable: true,
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtTaxCd").value = row.taxCd;
					$("txtTaxDesc").value = unescapeHTML2(row.taxDesc);
					$("txtB880LineCd").value = unescapeHTML2(row.lineCd);
					$("txtB880IssCd").value = unescapeHTML2(row.issCd);
					$("txtB880TaxId").value = row.taxId;
					$("txtB880Rate").value = unescapeHTML2(row.rate);
					$("txtB880NbtPrimarySw").value = unescapeHTML2(row.primarySw);
					$("txtB880NoRateTag").value = unescapeHTML2(row.noRateTag);
					computeNewTaxAmt($F("txtB240PolicyId"), 
									$F("txtB880IssCd"), 
									$F("txtB880LineCd"), 
									$F("txtTaxCd"), 
									$F("txtB880TaxId"), 
									$F("txtB480ItemNo")); //joanne 03.27.14
				 }
	  		}
		});
	}
	
	function removeTaxChargesFocus(){
		b880Grid.keys.removeFocus(b880Grid.keys._nCurrentFocus, true);
		b880Grid.keys.releaseKeys();
	}
		
	function createTaxCharges(obj){
		try {
			var taxCharges 						= (obj == null ? new Object() : obj);			
			taxCharges.recordStatus 		= (obj == null ? 0 : 1);
			taxCharges.taxCd 					= escapeHTML2($F("txtTaxCd"));
			taxCharges.lineCd 					= escapeHTML2($F("txtB880LineCd"));
			taxCharges.issCd 						= escapeHTML2($F("txtB880IssCd"));
			taxCharges.taxDesc 				= escapeHTML2($F("txtTaxDesc"));
			taxCharges.rate 						= escapeHTML2($F("txtB880Rate"));
			taxCharges.perilSw 				= escapeHTML2($F("txtB880PerilSw"));
			taxCharges.taxId 					= escapeHTML2($F("txtB880TaxId"));
			taxCharges.taxAmt 				=  roundNumber(unformatCurrencyValue($("txtTaxAmt").value) * $("txtB480CurrencyRt").value, 2); // andrew - 07162015 - SR 19843/19598
			taxCharges.allocationTag 		= escapeHTML2($F("txtB880AllocationTag"));
			taxCharges.policyId 				= escapeHTML2(nvl($F("txtB880PolicyId"), $F("txtB240PolicyId")));
			taxCharges.nbtPrimarySw 	= escapeHTML2($F("txtB880NbtPrimarySw"));
			taxCharges.initialTaxCd		 	= escapeHTML2($F("txtInitialTaxCd"));
			taxCharges.noRateTag			= escapeHTML2($F("txtB880NoRateTag")); //joanne 01.18.14
			taxCharges.currencyTaxAmt		= unformatCurrencyValue($F("txtTaxAmt")); //joanne 06.02.14
			return taxCharges;
		} catch (e){
			showErrorMessage("createTaxCharges", e);
		}			
	}
	
	function setB880Info(obj) {
		try {
			$("txtTaxCd").value								= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.taxCd,""))) :null;
			$("txtTaxDesc").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.taxDesc,""))) :null;
			$("txtTaxAmt").value							= nvl(obj,null) != null ? formatCurrency(nvl(obj.currencyTaxAmt/*taxAmt joanne, 060214, change into currencyTaxAmt*/, 0)) :null;
			$("txtB880NbtTaxAmt").value					= nvl(obj,null) != null ? formatCurrency(nvl(obj.taxAmt, 0)) :null; //added by joanne, 06.02.14 
			$("txtB880PolicyId").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.policyId,""))) :null;
			$("txtB880LineCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.lineCd,""))) :null;
			$("txtB880IssCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.issCd,""))) :null;
			$("txtB880TaxId").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.taxId,""))) :null;
			$("txtB880Rate").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.rate,""))) :null;
			$("txtB880NbtPrimarySw").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.nbtPrimarySw,""))) :null;
			$("txtB880PerilSw").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilSw,""))) :null;
			$("txtB880AllocationTag").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.allocationTag,""))) :null;
			$("txtInitialTaxCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.taxCd,""))) :null;
			//added by joanne, 01.17.14, for without rate taxes
			$("txtB880NoRateTag").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.noRateTag,""))) :null;
			$("btnAddTaxCharges").value 				= obj == null ? "Add" : "Update" ;
			$("btnAddTaxCharges").value				!= "Add" ? enableButton("btnDeleteTaxCharges") : disableButton("btnDeleteTaxCharges");
			//added by joanne, 010914, to disallow update/delete of required taxes
			nvl(obj,null) == null ? enableSearch("taxCdLOV") : disableSearch("taxCdLOV");
			if($("txtB880NoRateTag").value !='Y' && nvl(obj,null) != null){ //modify by joanne 01.17.14 change txtB880NbtPrimarySw into txtB880NoRateTag
				$("txtTaxAmt").setAttribute("readOnly","readonly");	
			}else{
				$("txtTaxAmt").readOnly=false;	
			}
		} catch(e) {
			showErrorMessage("setB880Info", e);
		}
	}
	
	function updateWitemGIEXS007(){
		try{
			var action = "";
			if($F("txtIsGpa") == 'Y'){
				action = "/GIEXItmperilGroupedController?action=updateWitemGrpGIEXS007";
			}else{
				action = "/GIEXItmperilController?action=updateWitemGIEXS007";
			}
			new Ajax.Request(contextPath+action, {
				method: "POST",
				parameters: {policyId					: 	$F("txtB240PolicyId"),
										itemNo					: 	$F("txtB480ItemNo"),
										//groupedItemNo	: 	$F("txtB480GrpItemNo"),
										recomputeTax		: 	"Y",
										taxSw						: 	$F("txtTaxSw"),
										summarySw		: 		$F("txtSummarySw") //added by joanne 06.03.14
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						//added by joanne 06.02.14, to display changes when recompute button is click
						b880Grid.url = contextPath + "/GIEXNewGroupTaxController?action=getGIEXS007B880Info&refresh=1&mode=1&policyId="+$F("txtB240PolicyId");
						b880Grid._refreshList();
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("updateWitemGIEXS007", e);
		}
	}
	
	function createNotInParamWithException(tablegrid, property, except){
		try{
			var initialNotIn = tablegrid.createNotInParam(property);
			var finalNotIn = '';
			var withPrevious = false;
			if(initialNotIn != ''){
				var tempArr = initialNotIn.split(',');
				for ( var i = 0; i < tempArr.length; i++) {
					if(tempArr[i] != except){
						if(withPrevious) finalNotIn += ",";
						finalNotIn += tempArr[i];
						withPrevious = true;	
					}
				}
				finalNotIn = (finalNotIn != "" ? "("+finalNotIn+")" : "");
			}
			return finalNotIn;
		}catch(e){
			showErrorMessage("createNotInParamWithException",e);
		}
	}
	
	//added by joanne 06.02.2014, for foreign currencies
	$("txtTaxAmt").observe("change", function(){ 
		$("txtB880NbtTaxAmt").value = roundNumber($("txtTaxAmt").value * $("txtB480CurrencyRt").value, 2);
	});
	
	$("taxCdLOV").observe("click", function () {
		var notIn = createNotInParamWithException(b880Grid, "taxCd", $F("txtTaxCd"));
		showTaxListLOV($F("txtLineCd"), $F("txtIssCd"), $F("txtB240PolicyId"), notIn);
	});

	$("btnOk").observe("click", function(){
		if (changeTag == 1) {	//added by Gzelle 01272015
			$("txtTaxSw").value = 'Y';
			fetchNewGroupTax();
			saveGIEXNewGroupTax();
		}else{
			taxChargesDetails.close();
		}
	});
	
	$("btnCancelTax").observe("click", function(){
		taxChargesDetails.close();
	});
	
	$("btnRecompute").observe("click", function(){
		updateWitemGIEXS007();
	});
	
	$("btnAddTaxCharges").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("editTaxChargesContentsDiv")){	
			var taxCharges = createTaxCharges();
			if($F("btnAddTaxCharges") == "Add"){	
				b880Grid.addBottomRow(taxCharges);
				//added by joanne 01.18.14, so that changes in sum will apply when tax is added/updated
				var rows = b880Grid.geniisysRows;
			      if(rows.length > 0){
			    	  var total = 0;
			    	  for(var i=0; i<rows.length;  i++){
							//total += parseFloat(rows[i].taxAmt); joanne 060214, change into currencyTaxAmt
			    		  	total += parseFloat(nvl(rows[i].currencyTaxAmt, "0"));
						}
				  		$("sumTaxAmt").value = formatCurrency(total);
			      }
			} else {				
				b880Grid.updateRowAt(taxCharges, selectedB880);
				//added by joanne 01.18.14, so that changes in sum will apply when tax is added/updated
				var rows = b880Grid.geniisysRows;
			      if(rows.length > 0){
			    	  var total = 0;
			    	  for(var i=0; i<rows.length;  i++){
			    			//total += parseFloat(rows[i].taxAmt); joanne 060214, change into currencyTaxAmt
			    		  	total += parseFloat(nvl(rows[i].currencyTaxAmt, "0"));
						}
				  		$("sumTaxAmt").value = formatCurrency(total);
			      }
			}
			changeTag = 1;
			setB880Info(null);
		}
	});
	
	$("btnDeleteTaxCharges").observe("click", function(){
		if(nvl(selectedB880Row.nbtPrimarySw,"N")=="N"){ //added by steven 8/28/2012
			if (nvl(b880Grid,null) instanceof MyTableGrid);
			//added by joanne 01.18.14, so that changes in sum will apply when tax is deleted
			var rows = b880Grid.geniisysRows;
		      if(rows.length > 0){
		    	  var total = 0;
		    	  for(var i=0; i<rows.length;  i++){
						//total += parseFloat(rows[i].taxAmt); joanne 060214, change into currencyTaxAmt
		    		  	total += parseFloat(nvl(rows[i].currencyTaxAmt, "0"));
					}
		    	//total = total - selectedB880Row.taxAmt; joanne 060214, change into currencyTaxAmt
		    	total = total - nvl(selectedB880Row.currencyTaxAmt, "0"); 
			  	$("sumTaxAmt").value = formatCurrency(total);
		      }
			b880Grid.deleteRow(selectedB880);
			setB880Info(null);
			changeTag = 1;	//added by Gzelle 01272015
		}else{
			showMessageBox("You cannot delete this record.",imgMessage.INFO);
		}
	});
	
	function deleteModNewGroupTax(initialTaxCd, policyId){
		try{
			new Ajax.Request(contextPath+"/GIEXNewGroupTaxController?action=deleteModNewGroupTax", {
				method: "POST",
				parameters: {taxCd				: 		initialTaxCd,
										 policyId			:		policyId}
			});
		}catch(e) {
			showErrorMessage("deleteModNewGroupTax", e);
		}
	}
	
	function fetchNewGroupTax(){
		try {
			objNewGroupTax.modNewGroupTaxObj = b880Grid.getModifiedRows();
			var modRows = b880Grid.getModifiedRows();
			for(var i=0; i<modRows.length;  i++){
				var taxCd = modRows[i].taxCd;
				var initialTaxCd = modRows[i].initialTaxCd;
				var policyId = modRows[i].policyId;
				if (initialTaxCd != taxCd){
					deleteModNewGroupTax(initialTaxCd, policyId);
				}
			}
			objNewGroupTax.addNewGroupTaxObj = b880Grid.getNewRowsAdded().concat(modRows);
			objNewGroupTax.delNewGroupTaxObj = b880Grid.getDeletedRows();
		} catch (e){
			showErrorMessage("fetchNewGroupTax", e);
		}
	}
	
	function saveGIEXNewGroupTax(){
		new Ajax.Request(contextPath+"/GIEXNewGroupTaxController?action=saveGIEXNewGroupTax",{
			method: "POST",
			parameters: {
				parameters: JSON.stringify(objNewGroupTax)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				showNotice("Saving Tax/Charges. Please wait...");
			},
			onSuccess: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						$("txtTaxSw").value = 'N';	//added by Gzelle 01272015
						changeTag = 0;				//added by Gzelle 01272015
						taxChargesDetails.close();
					}
				}
			}
		});	
	}
	
</script>