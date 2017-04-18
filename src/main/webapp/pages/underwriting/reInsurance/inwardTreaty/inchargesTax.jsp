<div class="sectionDiv" id="inchargesTaxInfoDiv" name="inchargesTaxInfoDiv" style="border: none;">
	<div id="inchargesTaxTableGridDiv" style="padding: 10px 0 10px 10px;">
		<div id="inchargesTaxTableGrid" style="height: 210px"></div>
	</div>
	<div id="inchargesTaxContainerDiv" name="inchargesTaxContainerDiv" class="sectionDiv" style="border: none; margin-bottom: 10px;">
		<table align="center">
			<tr>
				<td align="right" style="width: 100px;">Tax Type</td>
				<td align="left" style="padding-left: 5px;">
					<select id="txtTaxType" name="txtTaxType" style="width: 238px;" class="required">
						<option value=""></option>
						<option value="I">I - Input Vat</option>
						<option value="W">W - Withholding Tax</option>
					</select>
				</td>
				<td align="right" style="width: 130px;">Charge Amount</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" style="width: 236px;" id="txtChargeAmt" name="txtChargeAmt" class="money required" readonly="readonly" value="${chargeAmount}"/>
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">Tax</td>
				<td align="left" style="padding-left: 5px;">
					<span class="lovSpan required" style="width: 236px;">
						<input type="hidden" id="txtTaxCd" name="txtTaxCd" lastValidValue="" value=""/>
						<input type="text" style="width: 210px; float: left; border: none; height: 13px; margin: 0;" id="txtTaxName" name="txtTaxName" class="required" lastValidValue="" readonly="readonly" ignoreDelKey="1" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTax" name="searchTax" alt="Go" style="float: right;"/>
					</span>						
				</td>
				<td align="right" style="width: 130px;">Tax Percentage</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" style="width: 236px;" id="txtTaxPct" name="txtTaxPct" class="rightAligned required" readonly="readonly" value="" />
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">SL Code</td>
				<td align="left" style="padding-left: 5px;">
					<span class="lovSpan required" style="width: 236px;">
						<input type="hidden" id="txtSlTypeCd" name="txtSlTypeCd" lastValidValue="" value=""/>
						<input type="text" style="width: 210px; float: left; border: none; height: 13px; margin: 0;" id="txtSlCd" name="txtSlCd" class="required" lastValidValue="" readonly="readonly" ignoreDelKey="1" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSl" name="searchSl" alt="Go" style="float: right;"/>
					</span>						
				</td>
				<td align="right" style="width: 130px;">Tax Amount</td>
				<td align="left" style="padding-left: 5px;">
					<input type="text" style="width: 236px;" id="txtTaxAmt" name="txtTaxAmt" class="money required" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td align="right" style="width: 100px;">Charge</td>
				<td align="left" style="padding-left: 5px;">
					<input type="hidden" id="txtChargeCd" name="txtChargeCd" value="${chargeCd}"/>
					<input type="text" style="width: 230px;" id="txtCharge" name="txtCharge" class="required" readonly="readonly" value="${charge}"/>
				</td>
			</tr>
		</table>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddTax" name="btnAddTax" class="button" type="button" value="Add" />
			<input type="button" id="btnDeleteTax" name="btnDeleteTax" class="disabledButton" type="button" value="Delete" />			
		</div>
	</div>
	<div class="buttonsDiv" style="margin-bottom: 15px">
		<input type="button" id="btnSaveTax" name="btnSaveTax" class="button" value="Save" style="width: 90px;"/>
		<input type="button" id="btnTaxReturn" name="btnTaxReturn" class="button" value="Return" style="width: 90px;"/>
	</div>
</div>
<script type="text/javascript">
	var changeTagTax = 0;
	var objInchargesTax = JSON.parse('${giriInchargesTax}');
	var objInchargesTaxTG = JSON.parse('${giriInchargesTaxTG}');
	var inchargesTaxTableModel = {
		url : contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd="+encodeURIComponent($F("txtChargeCd")),
		options: {
			width: '1053px',
			masterDetail : true,
			masterDetailRequireSaving : true,
			pager: {},
			onCellFocus : function(element, value, x, y, id) {
				var objSelected = tbgInchargesTax.geniisysRows[y];
				tbgInchargesTax.keys.releaseKeys();
				setInchargesTaxForm(objSelected);
			},			
			onRemoveRowFocus : function(element, value, x, y, id){
				setInchargesTaxForm(null);
			},
			beforeSort: function(){
				if(changeTagTax == 1){						
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			masterDetailValidation : function(){
				if(changeTagTax == 1){
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSaveTax").click();
			},
			masterDetailNoFunc : function(){
				
			},
			toolbar:{
				elements: [MyTableGrid.REFRESH_BTN]
			}
		},									
		columnModel: [
			{	id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{	id: 'intreatyId',
				width: '0',
				visible: false 
			},
			{	id: 'taxType',
				width: '45',
				title: '&nbsp;&nbsp;Type',
				titleAlign : 'center',
				align: 'center',
				editable: false
			},
			{	id: 'taxCd',
				width: '80',
				title: '&nbsp;&nbsp;&nbsp;Tax Code',
				titleAlign : 'center',
				align: 'center',
				editable: false,
				renderer : function(value){
					return lpad(value.toString(), 5, "0");
	       		}
			},
			{	id: 'taxName',
				width: '250',
				title: 'Tax Name',
				editable: false,
				renderer : function(value){
					return unescapeHTML2(value);
	       		}
			},
			{	id: 'slTypeCd',
				width: '0',
				visible: false 
			},
			{	id: 'slCd',
				width: '100',
				title: '&nbsp;&nbsp;&nbsp;SL Code',
				titleAlign : 'center',
				align: 'center',
				editable: false,
				renderer : function(value){
					return lpad(value.toString(), 12, "0");
	       		}
			},
			{	id: 'charge',
				width: '250',
				title: 'Charge',
				editable: false,
				renderer : function(value){
					return unescapeHTML2(value);
	       		}
			},
			{	id: 'chargeCd',
				width: '0',
				visible: false 
			},
			{	id: 'chargeAmt',
				width: '100',
				title: 'Charge Amount',
				titleAlign : 'right',
				align: 'right',
				editable: false,
				type : 'number',
				geniisysClass : 'money'
			},
			{	id: 'taxPct',
				width: '100',
				title: 'Tax Pct.',
				titleAlign : 'right',
				align: 'right',
				editable: false,
				type : 'number',
				geniisysClass : 'rate'
			},
			{	id: 'taxAmt',
				width: '100',
				title: 'Tax Amount',
				titleAlign : 'right',
				align: 'right',
				editable: false,
				type : 'number',
				geniisysClass : 'money'
			}
		],
		rows: objInchargesTaxTG.rows || []
	};
	tbgInchargesTax = new MyTableGrid(inchargesTaxTableModel);
	tbgInchargesTax.pager = objInchargesTaxTG;
	tbgInchargesTax.render('inchargesTaxTableGrid');
	tbgInchargesTax.afterRender = function(){
		setInchargesTaxForm(null);
	};
	
	function setTaxReadOnly(){
		if(nvl($F("intrtyFlag"), "1") != "1"){
			$("txtTaxType").disabled = true;
			$("searchTax").hide();
			$("searchSl").hide();
			disableButton("btnAddTax");
			disableButton("btnDeleteTax");
			disableButton("btnSaveTax");
		}
	}
	
	function setInchargesTaxForm(obj){
		$("txtTaxType").value   = obj == null ? "" : obj.taxType;
		$("txtTaxCd").value     = obj == null ? "" : obj.taxCd;
		$("txtTaxName").value 	= obj == null ? "" : unescapeHTML2(obj.taxName);
		$("txtSlTypeCd").value 	= obj == null ? "" : obj.slTypeCd;
		$("txtSlCd").value 		= obj == null ? "" : obj.slCd;
		$("txtTaxPct").value 	= obj == null ? "" : formatToNineDecimal(obj.taxPct);
		$("txtTaxAmt").value    = obj == null ? "" : formatCurrency(obj.taxAmt);
		
		if(obj == null){
			$("txtTaxType").disabled = false;
			$("searchTax").show();
			$("searchSl").show();
			enableButton("btnAddTax");
			disableButton("btnDeleteTax");
		}else{
			$("txtTaxType").disabled = true;
			$("searchTax").hide();
			$("searchSl").hide();
			disableButton("btnAddTax");
			enableButton("btnDeleteTax");
		} 
		
		setTaxReadOnly();
	}
	
	function saveInchargesTax(){
		var objParameters = new Object();
		objParameters.intreatyId      = $F("intreatyId");
		objParameters.chargeCd        = $F("txtChargeCd");
		objParameters.delInchargesTax = getDeletedJSONObjects(objInchargesTax);
		objParameters.addInchargesTax = getAddedAndModifiedJSONObjects(objInchargesTax);
			
		new Ajax.Request(contextPath + "/GIRIIntreatyController?action=saveInchargesTax", {
			method : "POST",
			parameters : {parameters : JSON.stringify(objParameters)},
			asynchronous: false,
			evalScripts: true,
			onComplete : 
				function(response){
					if(checkErrorOnResponse(response)){
						if(response.responseText == "SUCCESS"){
							changeTagTax = 0;
							showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
								tbgCharges._refreshList();
								reloadInchargesTax();
							});
						}else{
							showMessageBox(res.message, "E");
						}
					}else{
						showMessageBox(response.responseText, "E");
					}
				}
		});
	}
	
	function reloadInchargesTax(){
		var charge = $F("txtCharge");
		var chargeCd = $F("txtChargeCd");
		var chargeAmount = $F("txtChargeAmt");
		
		inchargesTaxWin.close();
		
		var contentDiv = new Element("div", {id : "modal_content_tax"});
	    var contentHTML = '<div id="modal_content_tax"></div>';
	    
	    inchargesTaxWin = Overlay.show(contentHTML, {
							id: 'modal_dialog_tax',
							title: "Taxes",
							width: 1100,
							height: 460,
							draggable: true
						});
	    
	    new Ajax.Updater("modal_content_tax", contextPath+"/GIRIIntreatyController", {
			evalScripts: true,
			asynchronous: false,
			parameters:{
				action: "showInchargesTax",
				intreatyId: $F("intreatyId"),
				charge: charge,
				chargeCd: chargeCd,
				chargeAmount: chargeAmount
			},
			onCreate: function(){
				showNotice("Processing, please wait...");
			},
			onComplete: function(response){
				hideNotice();
				if (!checkErrorOnResponse(response)){
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	function createNotInParamTaxes(objArray, funcFilter, attr, attr2){
		try{
			var notIn = "";
			var withPrevious = false;

			var objArrFiltered = objArray.filter(funcFilter);

			for(var i=0, length=objArrFiltered.length; i < length; i++){			
				if(withPrevious){
					notIn += ",";
				}
				notIn += "'" + objArrFiltered[i][attr] +"-"+ objArrFiltered[i][attr2] + "'";
				withPrevious = true;
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			
			return notIn;
		}catch(e){
			showErrorMessage("createNotInParamInObj", e);
		}
	}
	
	$("searchTax").observe("click", function() {
		if($F("txtTaxType").blank()){
			customShowMessageBox("Please select tax type first.", imgMessage.ERROR, "txtTaxType");
			return false;
		}else{
			var notIn = "";
			notIn = createNotInParamTaxes(objInchargesTax, function(obj){return nvl(obj.recordStatus, 0) != -1;}, "taxType", "taxCd");
			
			LOV.show({
				controller: "UWReinsuranceLOVController",
				urlParameters: {action : "getGIRIS056TaxesLOV",
								taxType : $F("txtTaxType"),
								notIn : notIn,
								page : 1},
				title: "Charges",
				width: 435,
				height: 320,
				columnModel : [	{	id : "taxCd",
									title: "Tax Code",
									width: '100px',
									renderer : function(value){
										return lpad(value.toString(), 5, "0");
					           		}
								},
								{	id : "taxName",
									title: "Tax Name",
									width: '300px'
								},
								{	id: "slTypeCd",
									width: '0',
									visible: false 
								},
								{	id: "taxPct",
									width: '0',
									visible: false 
								}
							],
				draggable: true,
				onSelect: function(row){
					if(row != null || row != undefined){
						$("txtTaxCd").value   = row.taxCd;
						$("txtTaxName").value = unescapeHTML2(row.taxName);
						$("txtSlTypeCd").value = row.slTypeCd;
						$("txtSlCd").value = "";
						$("txtTaxPct").value  = formatToNineDecimal(row.taxPct);
						$("txtTaxAmt").value  = formatCurrency(unformatNumber($F("txtChargeAmt")) * row.taxPct / 100);
					}			   
				},
				onCancel: function(){
					$("taxName").focus();
				},
				onUndefinedRow:	function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "taxName");
				}
			});	
		}
	});
	
	$("searchSl").observe("click", function() {
		if($F("txtTaxType").blank()){
			customShowMessageBox("Please select tax type first.", imgMessage.ERROR, "txtTaxType");
			return false;
		}else if($F("txtTaxCd").blank()){
			customShowMessageBox("Please select tax first.", imgMessage.ERROR, "txtTaxName");
			return false;
		}else{
			LOV.show({
				controller: "UWReinsuranceLOVController",
				urlParameters: {action : "getGIRIS056SlLOV",
								slTypeCd : $F("txtSlTypeCd"),
								page : 1
							   },
				title: "Sl Codes",
				width: 435,
				height: 320,
				columnModel : [	{	id : "slCd",
									title: "Sl Code",
									width: '120px',
									renderer : function(value){
										return lpad(value.toString(), 12, "0");
					           		}
								},
								{	id : "slName",
									title: "Sl Name",
									width: '300px',
									renderer : function(value){
										return unescapeHTML2(value);
					           		}
								}
							],
				draggable: true,
				onSelect: function(row){
					if(row != null || row != undefined){
						$("txtSlCd").value = lpad(row.slCd.toString(), 12, "0");
					}			   
				},
				onCancel: function(){
					$("txtSlCd").focus();
				},
				onUndefinedRow:	function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSlCd");
				}
			});
		}
	});
	
	$("btnAddTax").observe("click", function(){
		if($F("txtTaxType").blank()){
			customShowMessageBox("Please select tax type first.", imgMessage.ERROR, "txtTaxType");
			return false;
		}else if($F("txtTaxCd").blank()){
			customShowMessageBox("Please select tax first.", imgMessage.ERROR, "txtTaxName");
			return false;
		}else if($F("txtSlCd").blank()){
			customShowMessageBox("Please select sl code first.", imgMessage.ERROR, "txtSlCd");
			return false;
		}else{
			var newObj = new Object();
			newObj.intreatyId = $F("intreatyId");
			newObj.taxType 	  = $F("txtTaxType");
			newObj.taxCd      = $F("txtTaxCd");
			newObj.taxName    = unescapeHTML2($F("txtTaxName"));
			newObj.chargeCd   = $F("txtChargeCd");
			newObj.charge     = unescapeHTML2($F("txtCharge"));
			newObj.chargeAmt  = parseFloat(unformatNumber($F("txtChargeAmt")));
			newObj.slTypeCd   = $F("txtSlTypeCd");
			newObj.slCd 	  = parseFloat(unformatNumber($F("txtSlCd")));
			newObj.taxPct 	  = parseFloat(unformatNumber($F("txtTaxPct")));
			newObj.taxAmt     = parseFloat(unformatNumber($F("txtTaxAmt")));
			
			newObj.recordStatus = 0;
			tbgInchargesTax.addBottomRow(newObj);
			addNewJSONObject(objInchargesTax, newObj);
			newObj = null;
			changeTagTax = 1;
			setInchargesTaxForm(null);
			updateTGPager(tbgInchargesTax);
		}
	});
	
	$("btnDeleteTax").observe("click", function (){
		var deletedObj = new Object();
		deletedObj.intreatyId = $F("intreatyId");
		deletedObj.taxType 	  = $F("txtTaxType");
		deletedObj.taxCd      = $F("txtTaxCd");
		deletedObj.taxName    = unescapeHTML2($F("txtTaxName"));
		deletedObj.chargeCd   = $F("txtChargeCd");
		deletedObj.charge     = unescapeHTML2($F("txtCharge"));
		deletedObj.chargeAmt  = parseFloat(unformatNumber($F("txtChargeAmt")));
		deletedObj.slTypeCd   = $F("txtSlTypeCd");
		deletedObj.slCd 	  = parseFloat(unformatNumber($F("txtSlCd")));
		deletedObj.taxPct 	  = parseFloat(unformatNumber($F("txtTaxPct")));
		deletedObj.taxAmt     = parseFloat(unformatNumber($F("txtTaxAmt")));
		
		addDelObjByAttr(objInchargesTax, deletedObj, "intreatyId taxType taxCd chargeCd");
		tbgInchargesTax.deleteVisibleRowOnly(tbgInchargesTax.getCurrentPosition()[1]);
		changeTagTax = 1;
		setInchargesTaxForm(null);
		updateTGPager(tbgInchargesTax);
	});
	
	$("btnSaveTax").observe("click", function(){
		if(changeTagTax == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
			return false;
		}else{
			saveInchargesTax();
		}
	});
	
	$("btnTaxReturn").observe("click", function(){
		if(changeTagTax == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveInchargesTax();
					},
					function(){
						changeTagTax = 0;
						inchargesTaxWin.close();
					},
					"");
		} else {
			inchargesTaxWin.close();
			showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd"));
		}
	});
	
	$("txtTaxType").observe("change", function(){
		$("txtTaxCd").value = "";
		$("txtTaxName").value = "";
		$("txtSlTypeCd").value = "";
		$("txtSlCd").value = "";
		$("txtTaxPct").value = "";
		$("txtTaxAmt").value = "";
	});
</script>