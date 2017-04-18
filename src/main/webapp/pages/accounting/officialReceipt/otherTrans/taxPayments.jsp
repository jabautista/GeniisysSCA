<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="taxPaymentsMainDiv" name="taxPaymentsMainDiv" class="sectionDiv" style="height: 540px;">
	<div id="taxPaymentsTableGridDiv" name="taxPaymentsTableGridDiv" style="height: 320px; width: 100%; float: left; padding: 10px 0px 0px 10px;"></div>
	<div id="totalAmtDiv" name="totalAmtDiv" style="width: 100%; text-align: right; float: left;">
		Total Tax Amount &nbsp<input id="totalTaxAmt" name="totalTaxAmt" type="text" readonly="readonly" class="money" style="width: 105px; margin-right: 30px;">
	</div>
	<div id="taxPaymentsInfoDiv" name="taxPaymentsInfoDiv" style="height: 125px; float: left; margin: 15px 0px 0px 100px;">
		<table style="margin-left: 50px;">
			<tr>
				<td class="rightAligned">Item No</td>
				<td><input id="itemNo" name="itemNo" class="required integerNoNegativeUnformatted" type="text" style="width: 202px; margin-right: 40px;" maxlength="5"></td>
				<td class="rightAligned">Tax Name</td>
				<td>
					<span class="lovSpan required" style="width: 220px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 190px; border: none;" name="taxName" id="taxName" readonly="readonly" class="required"/>
						<img id="imgSearchTax" alt="Go" style="float: right; height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
					</span>
					<input id="taxCd" name="taxCd" type="hidden">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Tran Type</td>
				<td>
					<select id="selTranType" class="required" style="width: 210px; margin-right: 40px;">
						<option value=""></option>
						<c:forEach var="tranType" items="${tranTypes}">
							<option desc="${tranType.rvMeaning}" value="${tranType.rvLowValue}">${tranType.rvLowValue} - ${tranType.rvMeaning}</option>
						</c:forEach>
					</select>
					<input id="txtTranType" name="txtTranType" type="text" class="required" style="width: 202px; display: none; margin-right: 40px;" readonly="readonly">
				</td>
				<td class="rightAligned">SL Name</td>
				<td>
					<span id="slSpan" class="lovSpan" style="width: 220px;">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 190px; border: none;" name="slName" id="slName" readonly="readonly"/>
						<img id="imgSearchSl" alt="Go" style="height: 18px; margin-top: 1px; display: none;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png"/>
					</span>
					<input id="slCd" name="slCd" type="hidden">
					<input id="slTypeCd" name="slTypeCd" type="hidden">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Fund Code</td>
				<td>
					<select id="selFundCd" class="required" style="width: 210px; margin-right: 40px;">
						<option value=""></option>
						<c:forEach var="fund" items="${fundList}">
							<option label="${fund.gibrBranchCd}" value="${fund.gibrGfunFundCd}" desc="${fund.gibrBranchName}">${fund.gibrGfunFundDesc} - ${fund.gibrBranchName} </option>
						</c:forEach>
					</select>
					<input id="txtFundCd" name="txtFundCd" type="text" class="required" style="width: 202px; display: none; margin-right: 40px;" readonly="readonly">
				</td>
				<td class="rightAligned">Tax Amount</td>
				<td><input id="taxAmt" name="taxAmt" class="required money" type="text" style="width: 213px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Branch</td>
				<td>
					<select id="selBranchCd" style="width: 210px; margin-right: 40px; display: none;">
						<option value=""></option>
						<c:forEach var="branch" items="${fundList}">
							<option  label="${branch.gibrGfunFundCd}" value="${branch.gibrBranchCd}">${branch.gibrBranchName}</option>
						</c:forEach>
					</select> <!-- changed by shan : 11.20.2013-->					
					<input id="txtBranchCd" name="txtBranchCd" type="text" class="required" style="width: 202px; margin-right: 40px;" readonly="readonly">
				</td>
				<td class="rightAligned">Remarks</td>
				<td>
					<div style="border: 1px solid gray; height: 20px; width: 220px;">
						<textarea id="remarks" name="remarks" style="width: 190px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="4000"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv">
		<input id="btnAdd" name="btnAdd" type="button" class="button" value="Add">
		<input id="btnDelete" name="btnDelete" type="button" class="button" value="Delete">
	</div>
</div>
<div id="buttonsDiv2" name="buttonsDiv2" class="buttonsDiv">
	<input id="btnCancel" name="btnCancel" type="button" class="button" value="Cancel">
	<input id="btnSave" name="btnSave" type="button" class="button" value="Save">
</div>

<script type="text/javascript">
	objTaxPayt = new Object();
	objTaxPayt.variables = JSON.parse('${formVariables}');
	objTaxPayt.itemList = JSON.parse('${itemList}');
	objTaxPayt.taxPaytTableGrid = JSON.parse('${taxPaymentsJSON}');
	objTaxPayt.taxPaytRows = objTaxPayt.taxPaytTableGrid.rows || [];
	objTaxPayt.rows = "";
	changeTag = 0;
	selectedIndex = -1;
	selectedRow = null;
	
	//marco - 11.18.2013
	var disableForm = false;
	if(objACGlobal.tranFlagState == 'C' || objACGlobal.tranFlagState == 'D' || objACGlobal.queryOnly == "Y"){
		disableForm = true;
	}
	
	try{
		taxPaytTableModel = {
			url: contextPath+"/GIACTaxPaymentsController?action=showTaxPayments&refresh=1&gaccTranId="+objACGlobal.gaccTranId,
			options: {
	          	height: '285px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedIndex = y;
	          		selectedRow = taxPaytTableGrid.geniisysRows[y];
	          		populateFields(true);
	          		toggleFields(true);
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	populateFields(false);
	            	toggleFields(false);
	            },
	            prePager: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{	id: 'itemNo',
							title: 'Item No.',
							width: '60px',
							filterOption: true,
					    	filterOptionType: 'integerNoNegative',
					    	renderer: function (value){
								return formatNumberDigits(value, 5);
							}
						},
						{	id: 'transaction',
							title: 'Tran Type',
							width: '153px',
							filterOption: true
						},
						{	id: 'fundCd',
							title: 'Fund Code',
							width: '78px',
							filterOption: true
						},
						{	id: 'branchName',
							title: 'Branch',
							width: '110px',
							filterOption: true
						},
						{	id: 'taxName',
							title: 'Tax',
							width: '191px',
							filterOption: true
						},
						{	id: 'slName',
							title: 'SL',
							width: '158px',
							filterOption: true
						},
						{	id: 'taxAmt',
							title: 'Tax Amount',
							width: '110px',
							align: 'right',
							filterOption: true,
							filterOptionType: 'number',
							renderer: function (value){
								return formatCurrency(value);
							}
						}
						],  				
			rows: objTaxPayt.taxPaytRows
		};
		taxPaytTableGrid = new MyTableGrid(taxPaytTableModel);
		taxPaytTableGrid.pager = objTaxPayt.taxPaytTableGrid;
		taxPaytTableGrid.render('taxPaymentsTableGridDiv');
		taxPaytTableGrid.afterRender = function(){
			objTaxPayt.rows = taxPaytTableGrid.geniisysRows;
			taxPaytTableGrid.onRemoveRowFocus();
			
			//added by shan for GIACS070 08.28.2013
			if(disableForm){
				disableGIACS021();
			}
		};
	}catch(e){
		showMessageBox("Error in Comm Fund Slip TableGrid: " + e, imgMessage.ERROR);
	}
	
	function whenNewFormInstance(){
		initializeAll();
		initializeAllMoneyFields();
		setModuleId("GIACS021");
		setDocumentTitle("Tax Payments");
		$("totalTaxAmt").value = formatCurrency(nvl(objTaxPayt.variables.totalTax, "0"));
		$("itemNo").value = getMaxItem();
	}
	
	function getMaxItem(){
		var maxItem = 0;
		for(var i = 0; i < objTaxPayt.itemList.length; i++){
			if(parseInt(objTaxPayt.itemList[i]) > parseInt(maxItem)){
				maxItem = objTaxPayt.itemList[i];
			}
		}
		return formatNumberDigits(maxItem + 1, 5);
	}
	
	function toggleFields(toggle){
		if(toggle){
			disableInputField("itemNo");
			disableInputField("taxAmt");
			disableInputField("remarks");
			$("selTranType").hide();
			$("txtTranType").show();
			$("selFundCd").hide();
			$("txtFundCd").show();
			//$("selBranchCd").hide();
			//$("txtBranchCd").show();
			$("imgSearchTax").hide();
			$("imgSearchSl").hide();
			
			if(!disableForm){ //marco - added condition - 11.18.2013
				$("btnAdd").value = "Update";
				enableButton("btnDelete");
			}
			
			if(nvl(selectedRow.recordStatus, 2) == 0){
				enableButton("btnAdd");
			}else{
				disableButton("btnAdd");
			}
			
			if($F("slTypeCd") != ""){
				$("slName").addClassName("required");
				$("slSpan").addClassName("required");
			}
		}else{
			enableInputField("itemNo");
			enableInputField("taxAmt");
			enableInputField("remarks");
			$("selTranType").show();
			$("txtTranType").hide();
			$("selFundCd").show();
			$("txtFundCd").hide();
			//$("selBranchCd").show();
			//$("txtBranchCd").hide();
			$("slName").removeClassName("required");
			$("slSpan").removeClassName("required");
			$("slName").setStyle("background-color", "white");
			$("slSpan").setStyle("background-color", "white");
			
			if(!disableForm){ //marco - added condition - 11.18.2013
				$("imgSearchTax").show();
				$("imgSearchSl").hide();
				$("btnAdd").value = "Add";
				enableButton("btnAdd");
			}
			disableButton("btnDelete");
			
			//marco - 11.20.2013
			if(nvl(objACGlobal.previousModule, "") == "GIACS016" && !disableForm){
				for(var i = 0; i < $("selFundCd").options.length; i++){
					if($("selFundCd").options[i].getAttribute("label") == objACGlobal.branchCd){
						$("selFundCd").selectedIndex = i;
						$("txtFundCd").value = $("selFundCd").options[i].value;
					}
				}
				
				for(var i = 0; i < $("selBranchCd").options.length; i++){
					if($("selBranchCd").options[i].value == objACGlobal.branchCd){
						$("selBranchCd").selectedIndex = i;
						$("txtBranchCd").value = $("selBranchCd").options[i].innerHTML;
					}
				}
			}
			$("selBranchCd").disable();
			//end
		}
		taxPaytTableGrid.keys.removeFocus(taxPaytTableGrid.keys._nCurrentFocus, true);
    	taxPaytTableGrid.keys.releaseKeys();
	}
	
	function populateFields(pop){
		$("itemNo").value = pop ? formatNumberDigits(selectedRow.itemNo, 5) : "";
		$("txtTranType").value = pop ? selectedRow.transactionType + " - " + unescapeHTML2(selectedRow.transactionDesc) : "";
		$("txtFundCd").value = pop ? unescapeHTML2(selectedRow.fundCd) : "";
		$("txtBranchCd").value = pop ? unescapeHTML2(selectedRow.branchName) : "";
		$("taxCd").value = pop ? selectedRow.taxCd : "";
		$("taxName").value = pop ? unescapeHTML2(selectedRow.taxName) : "";
		$("slCd").value = pop ? selectedRow.slCd : "";
		$("slTypeCd").value = pop ? selectedRow.slTypeCd : "";
		$("slName").value = pop ? unescapeHTML2(selectedRow.slName) : "";		
		$("taxAmt").value = pop ? formatCurrency(selectedRow.taxAmt) : "";
		$("remarks").value = pop ? unescapeHTML2(selectedRow.remarks) : "";
		
		if(!pop){
			$("itemNo").value = getMaxItem();
			$("selTranType").value = "";
			$("selFundCd").value = "";
			//$("selBranchCd").value = "";
			$("txtBranchCd").value = "";
		}
	}
	
	function searchTax(){
		if($F("selFundCd") != "" && selectedIndex == -1){
			try{
				LOV.show({
					controller: "AccountingLOVController",
					urlParameters: {
						action : "getGIACTaxesLOV",
						fundCd : $F("selFundCd")
					},
					title: "List of Values",
					width: 375,
					height: 386,
					columnModel:[
									{	id : "taxCd",
										title: "Tax Code",
										width: "120px",
									},
					             	{	id : "taxName",
										title: "Tax Name",
										width: "240px"
									}
								],
					draggable: true,
					onSelect : function(row){
						if(row != undefined) {
							$("taxCd").value = row.taxCd;
							$("taxName").value = unescapeHTML2(row.taxName);
							
							if(nvl(row.slTypeCd, "") != ""){
								$("slTypeCd").value = row.slTypeCd;
								$("slName").addClassName("required");
								$("slSpan").addClassName("required");
								$("imgSearchSl").show();
							}
						}
					}
				});
			}catch(e){
				showErrorMessage("searchTax", e);
			}
		}
	}
	
	function searchSl(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action : "getGIACSlLOV",
					slTypeCd : $F("slTypeCd")
				},
				title: "List of Values",
				width: 375,
				height: 386,
				columnModel:[
								{	id : "slCd",
									title: "SL Code",
									width: "120px",
								},
				             	{	id : "slName",
									title: "SL Name",
									width: "240px"
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						$("slCd").value = row.slCd;
						$("slTypeCd").value = row.slTypeCd;
						$("slName").value = unescapeHTML2(row.slName);
					}
				}
			});
		}catch(e){
			showErrorMessage("searchSl", e);
		}
	}
	
	function validateTaxAmt(){
		var taxAmt = parseFloat(unformatCurrencyValue(nvl($F("taxAmt"), 0)));
		
		
		
		if(parseInt(nvl($F("selTranType"), 1)) == 2 && taxAmt > 0){
			$("taxAmt").value = formatCurrency(taxAmt * -1);
		}else if(parseInt(nvl($F("selTranType"), 1)) == 1 && taxAmt < 0){
			$("taxAmt").value = formatCurrency(taxAmt * -1);
		}
	}
	
	function addTaxPayment(){
		if(checkAllRequiredFieldsInDiv("taxPaymentsInfoDiv")){
			$("totalTaxAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("totalTaxAmt"))) + parseFloat(unformatCurrencyValue($F("taxAmt"))));
			var row = createTaxPayt();
			objTaxPayt.rows.push(row);
			objTaxPayt.itemList.push(parseInt(row.itemNo));
			taxPaytTableGrid.addBottomRow(row);
			taxPaytTableGrid.onRemoveRowFocus();
			changeTag = 1;
		}
	}
	
	function deleteTaxPayment(){
		if(selectedRow.orPrintTag == "Y"){
			showMessageBox("Delete not allowed. This record was created before the OR was printed.", "E");
		}else{
			for(var i = 0; i < objTaxPayt.itemList.length; i++){
				if(parseInt(objTaxPayt.itemList[i]) == parseInt(selectedRow.itemNo)){
					objTaxPayt.itemList.splice(i, 1);
				}
			}
			$("totalTaxAmt").value = formatCurrency(parseFloat(unformatCurrencyValue($F("totalTaxAmt"))) - parseFloat(selectedRow.taxAmt));
			selectedRow.recordStatus = -1;
			objTaxPayt.rows.splice(selectedIndex, 1, selectedRow);
			taxPaytTableGrid.deleteVisibleRowOnly(selectedIndex);
			taxPaytTableGrid.onRemoveRowFocus();
			changeTag = 1;
		}
	}
	
	function createTaxPayt(){
		var obj = new Object();
		obj.gaccTranId = objACGlobal.gaccTranId;
		obj.itemNo = removeLeadingZero($F("itemNo"));
		obj.transactionType = $F("selTranType");
		obj.transactionDesc = $("selTranType").options[$("selTranType").selectedIndex].getAttribute("desc");
		obj.transaction = $("selTranType").options[$("selTranType").selectedIndex].text;
		obj.fundCd = $F("selFundCd");
		obj.taxCd = $F("taxCd");
		obj.taxName = $F("taxName");
		obj.branchCd = $("selFundCd").options[$("selFundCd").selectedIndex].label; //$F("selBranchCd");
		obj.branchName = $F("txtBranchCd"); //$("selBranchCd").options[$("selBranchCd").selectedIndex].text;
		obj.taxAmt = unformatCurrencyValue($F("taxAmt"));
		obj.orPrintTag = "N";
		obj.remarks = $F("remarks");
		obj.slCd = $F("slCd");
		obj.slTypeCd = $F("slTypeCd");
		obj.slName = $F("slName");
		obj.recordStatus = 0;
		return obj;
	}
	
	function saveTaxPayments(){
		try{
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objTaxPayt.rows);
			objParams.delRows = getDeletedJSONObjects(objTaxPayt.rows);
			
			new Ajax.Request(contextPath+"/GIACTaxPaymentsController",{
				method: "POST",
				parameters:{
					action : "saveTaxPayments",
					gaccTranId : objACGlobal.gaccTranId,
					fundCd : objACGlobal.fundCd,
					branchCd : objACGlobal.branchCd,
					tranSource : objACGlobal.tranSource,
					orFlag : objACGlobal.orFlag,
					parameters : JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				onComplete: function(response){
					hideNotice("");
					changeTag = 0;
					if(checkCustomErrorOnResponse(response)) {
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							if($("otherTransTab4") != null){
								fireEvent($("otherTransTab4"), "click");
							}
						});
					}
				}
			});
		}catch(e){
			showErrorMessage("saveTaxPayments", e);
		}
	}
	
	//added by shan for GIACS070 08.28.2013
	function disableGIACS021(){
		disableButton("btnAdd");
		disableButton("btnSave");
		$("imgSearchTax").hide();
		disableSearch("imgSearchTax");
		
		$$("span").each(function(span){
			if (span.hasClassName("required")){
				span.removeClassName("required");
				span.style.backgroundColor = "#EEEEEE";
			}
		});
		$("remarks").readOnly = true;
		$("imgSearchTax").style.backgroundColor = "#EEEEEE" ;	
		
		reqDiv = new Array("taxPaymentsInfoDiv");
		disableCancelORFields(reqDiv);		
	}
	
	
	$("itemNo").observe("change", function(){
		for(var i = 0; i < objTaxPayt.itemList.length; i++){
			if(parseInt(removeLeadingZero($F("itemNo"))) == objTaxPayt.itemList[i]){
				$("itemNo").value = getMaxItem();
				showMessageBox("This Item No. already exists.", "I");
				return false;
			}
		}
		$("itemNo").value = formatNumberDigits(nvl($F("itemNo"), getMaxItem()), 5);
	});
	
	$("selTranType").observe("change", function(){
		$("txtTranType").value = $("selTranType").options[$("selTranType").selectedIndex].text;
		validateTaxAmt();
	});
	
	$("selFundCd").observe("change", function(){
		//$("selBranchCd").value = $("selFundCd").options[$("selFundCd").selectedIndex].label;
		$("txtFundCd").value = $("selFundCd").options[$("selFundCd").selectedIndex].text;
		$("txtBranchCd").value = $("selFundCd").options[$("selFundCd").selectedIndex].getAttribute("desc");
	});
	
	/*$("selBranchCd").observe("change", function(){
		$("selFundCd").value = $("selBranchCd").options[$("selBranchCd").selectedIndex].label;
		$("txtFundCd").value = $("selBranchCd").options[$("selBranchCd").selectedIndex].label;
		$("txtBranchCd").value = $("selBranchCd").options[$("selBranchCd").selectedIndex].text;
	});*/
	
	$("taxAmt").observe("change", function(){
		if(parseFloat(unformatCurrencyValue(nvl($F("taxAmt"), 0))) == 0){
			showWaitingMessageBox("Amount should not be zero.", "I", function(){
				$("taxAmt").value = "";
			});
			return false;
		}else if(parseFloat(unformatCurrencyValue(nvl($F("taxAmt"), 0))) > 999999999.99){
			showWaitingMessageBox("Invalid amount. Valid value should be from 0.01 to 999,999,999.99.", "I", function(){
				$("taxAmt").value = "";
			});
			return false;
		}
		validateTaxAmt();
	});
	
	$("editRemarks").observe("click", function(){
		if (objACGlobal.queryOnly == "Y"){	//condition added by shan 8.28.2013
			showEditor("remarks", 4000, "true");
		}else{
			if(selectedIndex != -1){
				showEditor("remarks", 4000, "true");
			}else{
				showEditor("remarks", 4000, "false");
			}
		}
	});
	
	$("imgSearchTax").observe("click", searchTax);
	$("imgSearchSl").observe("click", searchSl);
	$("btnAdd").observe("click", addTaxPayment);
	$("btnDelete").observe("click", deleteTaxPayment);
	
	whenNewFormInstance();
	observeSaveForm("btnSave", saveTaxPayments);
	observeCancelForm("btnCancel", saveTaxPayments, function(){
		fireEvent($("acExit"), "click");
	});

	
</script>