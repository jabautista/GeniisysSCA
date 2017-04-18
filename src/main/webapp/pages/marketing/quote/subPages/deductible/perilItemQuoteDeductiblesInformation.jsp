<div id="perilItemQuoteDeductibleSectionDiv" name="perilItemQuoteDeductibleSectionDiv" class="sectionDiv" changeTagAttr="true">

	<div id="perilItemQuoteDeductibleTableGrid" style="height: 230px; margin: 10px;"></div>
	
	<div align="right" style="width: 100%; border: 0px; margin-bottom: 20px;" class="sectionDiv">
		<label style="float: left; margin-top: 6px; margin-left: 630px;">Total Deductible Amount:</label>
		<input type="text" id="totalDeductibleAmount3" style="margin-left: 3px; width: 122px; float: left; text-align: right;" readonly="readonly" tabindex="501"/>
	</div>
	<table align="center" width="60%" style="margin-top: 10px;">
		<tr>
			<td class="rightAligned">Deductible Title </td>
			<td class="leftAligned" colspan="3">
				<div style="float: left; border: solid 1px gray; width: 100%; height: 21px; margin-right: 3px;" class="required">
					<input type="hidden" id="txtDeductibleCd3" name="txtDeductibleCd3" />
					<input class="required" type="text" tabindex="3001" style="float: left; margin-top: 0px; margin-right: 3px; width: 93.5%; border: none;" name="txtDeductibleDesc3" id="txtDeductibleDesc3" readonly="readonly" value="" />
					<img id="hrefDeductible3" alt="goDeductible" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
				</div>				
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="13%">Rate </td>
			<td class="leftAligned" width="25%"><input tabindex="3002" id="deductibleRate3" name="deductibleRate3" type="text" style="width: 96%; text-align: right;" maxlength="13" readonly="readonly"/></td>		
			<td class="rightAligned" width="13%">Amount </td>
			<td class="leftAligned" width="25%"><input tabindex="3003" id="inputDeductibleAmount3" name="inputDeductibleAmount3" type="text" style="width: 96%; text-align: right;" class="" maxlength="17" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible Text </td>
			<td class="leftAligned" colspan="3"><textarea tabindex="3004" id="deductibleText3" name="deductibleText3" style="width: 98.5%; resize: none;" maxlength="2000" rows="2" readonly="readonly"></textarea></td>
		</tr>
		<tr>
			<td></td>
			<td colspan="3">
				<table>
					<tr>
						<td><input tabindex="3005" type="checkbox" id="aggregateSw3" name="aggregateSw3" /></td>
						<td class="rightAligned">Aggregate</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<div style="width: 100%; margin-bottom: 10px;" align="center" id="dedButtonsDiv3">
		<input tabindex="3006" id="btnAddDeductible3" class="button" type="button" value="Add" style="width: 60px; margin: 5px 0px 5px 0px;" />
		<input tabindex="3007" id="btnDeleteDeductible3" class="button" type="button" value="Delete" style="width: 60px;" />
	</div>
</div>

<script type="text/javascript">

	var objSelected = null;
	var rowIndex = -1;

	function setQuotePerilItem(obj){
		$("txtDeductibleCd3").value				= (obj == null ? "" : obj.dedDeductibleCd);
		$("txtDeductibleDesc3").value			= (obj == null ? "" : obj.deductibleTitle);
		$("deductibleText3").value				= (obj == null ? "" : obj.deductibleText);
		$("deductibleRate3").value				= (obj == null ? "" : formatToNineDecimal(obj.deductibleRate)); //Modified by Jerome 11.07.2016 SR 5737
		$("btnAddDeductible3").value			= (obj == null ? "Add" : "Update");
		
		$("inputDeductibleAmount3").value 		= (obj == null ? "" : formatCurrency(obj.deductibleAmt));
		$("aggregateSw3").checked				= (obj == null ? false : nvl(obj.aggregateSW, "N") == "Y" ? true : false);
				
		if(obj == null){
			$("hrefDeductible3").show();
			disableButton("btnDeleteDeductible3");
		}else{
			$("hrefDeductible3").hide();
			enableButton("btnDeleteDeductible3");
		}
		
	}
	
	objQuoteGlobal.setQuotePerilItem = setQuotePerilItem;
	
	try{				
		/*var objPerilItemQuotationDeduc = new Object();
		objPerilItemQuotationDeduc.objPerilItemQuotationDeducListing = [];
		objPerilItemQuotationDeduc.objRows = objPerilItemQuotationDeduc.objPerilItemQuotationDeducListing.rows || [];*/
		
		objQuote.objPerilItemQuotationDeduc = [];
		var objPerilItemQuotationDeduc = new Object();
		objPerilItemQuotationDeduc.objPerilItemQuotationDeducListing = [];
		
		var amtTotal = 0;
		var tbPerilItemQuotationDeductibles = {
			options : {
				height: "206px",
				width: "900px",
				masterDetail : true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objSelected = tbgPerilItemQuotationDeductible.geniisysRows[y];
					
					tbgPerilItemQuotationDeductible.keys.releaseKeys();
					setQuotePerilItem(objSelected);
					disableSearch("hrefDeductible3");
				},
				onCellBlur : function(){
					//
				},
				onRemoveRowFocus : function(){
					setQuotePerilItem(null);
					enableSearch("hrefDeductible3");
				},
				masterDetailValidation : function(){
				},
				masterDetailSaveFunc : function(){
				},
				masterDetailNoFunc : function(){
					setQuotePerilItem(null);
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
				},
				onRefresh : function(){
					setQuotePerilItem(null);
				}
			},
			columnModel : [
				{
					id : 'recordStatus',
					width : '20px',
					editor : 'checkbox',
					visible : false
				},
				{
					id : 'divCtrId',
					width : '0px',
					visible : false
				},
				{
					id : 'quoteId',
					width : '0px',
					visible : false
				},
				{
					id : 'aggregateSW',
					title: '&#160;&#160;A',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		        	
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		} 		
		            	}})	
				},
				{
					id : 'ceilingSw',
					title: '&#160;&#160;C',
					width : '23px',
					align : 'center',
					titleAlign : 'center',
					defaultValue: false,
				  	otherValue: false,				  	
				  	editable: false,
				  	sortable : false,
				  	editor: new MyTableGrid.CellCheckbox({					  	
						getValueOf: function(value){		      		
							if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}            		
		            	}})
				},
				{
					id : 'itemNo',
					title : 'Item No.',
					width : '60px',
					sortable : false,				
					renderer : function(value){
						return lpad(value.toString(), 9, "0");
	           		}
	           },
	           {
					id : 'deductibleTitle',
					title : 'Deductible Title',
					width : '234px',
					filterOption : true
	           },
	           {
					id : 'deductibleText',
					title : 'Deductible Text',
					width : '250px',
					filterOption : true
	           },
	           {
					id : "deductibleRate",
					title : "Rate",
					width : '100px',
					align : 'right',			
					renderer : function(value){
						if(value != null){
							return formatToNineDecimal(value);
						}else{
							return "";
						}						
	          		}
			   },
	           {
					id : 'deductibleAmt',
					title : 'Amount',
					width : '150px',
					type : 'number',
					geniisysClass : 'money'
	           }
			],
			//rows : objPerilItemQuotationDeduc.objRows
			rows : []
		};
	
		tbgPerilItemQuotationDeductible = new MyTableGrid(tbPerilItemQuotationDeductibles);
		tbgPerilItemQuotationDeductible.pager = objPerilItemQuotationDeduc.objPerilItemQuotationDeducListing;
		tbgPerilItemQuotationDeductible.render('perilItemQuoteDeductibleTableGrid');
		tbgPerilItemQuotationDeductible.afterRender = function(){
			objQuote.objPerilItemQuotationDeduc = tbgPerilItemQuotationDeductible.geniisysRows;
			setQuotePerilItem(null);
			if(tbgPerilItemQuotationDeductible.geniisysRows.length != 0){
				amtTotal=tbgPerilItemQuotationDeductible.geniisysRows[0].totalDeductible;
			}
			$("totalDeductibleAmount3").value = formatCurrency(amtTotal).truncate(13, "...");
		}; 	
	}catch(e){
		showErrorMessage("PerilItem Quotation Deductible Listing", e);
	}
	
	$("btnDeleteDeductible3").observe("click", function ()	{
		try {
			deleteRec();
		} catch (e) {
			showErrorMessage("btnDeleteDeductible3" , e);
		}		
	}); 
	
	function deleteRec(){
		objSelected.recordStatus = -1;
		tbgPerilItemQuotationDeductible.deleteRow(rowIndex);
		computeTotalAmountInTable(-1*parseFloat(nvl(unformatCurrency("inputDeductibleAmount3"),0)));
		changeTag = 1;
		setQuotePerilItem(null);
	}
	
	$("btnAddDeductible3").observe("click", function ()	{
		try {
			if(checkAllRequiredFieldsInDiv("perilItemQuoteDeductibleSectionDiv")){
				addRec();
			}	
		} catch (e) {
			showErrorMessage("btnAddDeductible3" , e);
		}		
	});
	
	function addRec(){
		try {			
			var dept = setDeductibleObj();
			if($F("btnAddDeductible3") == "Add"){
				tbgPerilItemQuotationDeductible.addBottomRow(dept);
				computeTotalAmountInTable(unformatCurrency("inputDeductibleAmount3"));
			} else {
				tbgPerilItemQuotationDeductible.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setQuotePerilItem(null);
			tbgPerilItemQuotationDeductible.keys.removeFocus(tbgPerilItemQuotationDeductible.keys._nCurrentFocus, true);
			tbgPerilItemQuotationDeductible.keys.releaseKeys();
			clearChangeAttribute("perilItemQuoteDeductibleSectionDiv");
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setDeductibleObj(){
		try{
			var objDeductible = new Object();
			
			objDeductible.quoteId				= objGIPIQuote.quoteId;
			objDeductible.dedLineCd				= objGIPIQuote.lineCd;
			objDeductible.dedSublineCd			= objGIPIQuote.sublineCd;
			
			objDeductible.itemNo 			= objQuote.selectedItemInfoRow.itemNo;
			objDeductible.perilCd 			= objQuote.selectedPerilInfoRow.perilCd;
			objDeductible.dedDeductibleCd 	= escapeHTML2($F("txtDeductibleCd3"));	
			objDeductible.deductibleTitle 	= escapeHTML2($F("txtDeductibleDesc3"));	
			objDeductible.deductibleAmt 	= $F("inputDeductibleAmount3") == "" ? null : $F("inputDeductibleAmount3"); 
			objDeductible.deductibleRate 	= $F("deductibleRate3") == "" ? null : $F("deductibleRate3"); 
			objDeductible.deductibleText	= escapeHTML2($F("deductibleText3"));	
			objDeductible.aggregateSW		= $("aggregateSw3").checked ? "Y" : "N";	
			//objDeductible.ceilingSw		 	= $("ceilingSw2").checked ? "Y" : "N"; 	
			objDeductible.deductibleType 	= $("txtDeductibleCd3").getAttribute("deductibleType");
			
			objDeductible.maxAmt			= $("txtDeductibleCd3").getAttribute("maxAmt");
			objDeductible.minAmt			= $("txtDeductibleCd3").getAttribute("minAmt");
			objDeductible.rangeSw			= $("txtDeductibleCd3").getAttribute("rangeSw");
			
			return objDeductible;
		}catch(e){
			showErrorMessage("setDeductibleObj", e);
		}
	}
	
	function quoteDeductibleLOV(tableGrid){
		try {	
			var notIn = "";
			var withPrevious = false;	
			
			for(var i=0, length=tableGrid.geniisysRows.length; i < length; i++){
				if(nvl(tableGrid.geniisysRows[i].recordStatus, 0) != -1){ //marco - 04.11.2013 - added condition to include deleted records in LOV
					if(withPrevious){
						notIn += ",";
					}
					notIn += "'" + tableGrid.geniisysRows[i].dedDeductibleCd + "'";
					withPrevious = true;
				}
			}
			
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var lineCd 		= objGIPIQuote.lineCd;
			var sublineCd 	= objGIPIQuote.sublineCd;
			
			
			if(objQuote.selectedPerilInfoRow.perilCd != undefined){
				showDeductibleLOV1(lineCd, sublineCd, 3, notIn);
			}else{
				showMessageBox("Please select a peril first.", "I");
			}
			
		} catch (e){
			showErrorMessage("quoteDeductibleLOV1", e);
		}
	}
	
	function showDeductibleLOV1(lineCd, sublineCd, dedLevel, notIn) {
		try {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISDeductibleLOV",
					lineCd : lineCd,
					sublineCd : sublineCd,
					notIn : notIn,
					page : 1
				},
				title : "Deductibles",
				width : 660,
				height : 320,
				columnModel : [ {
					id : "deductibleCd",
					title : "Code",
					width : '80px',
					renderer: function(value){
					       var str = value;
					       var dedCd = str.replace("slash", "/");
	         		   return  dedCd;}
				}, {
					id : "deductibleTitle",
					title : "Title",
					width : '220px'
				}, {
					id : "deductibleTypeDesc",
					title : "Type",
					width : '150px'
				}, {
					id : "deductibleRate",
					title : "Rate",
					width : '100px',
					align : 'right',
					geniisysClass : 'money'
				}, {
					id : "deductibleAmt",
					title : "Amount",
					width : '100px',
					align : 'right',
					geniisysClass : 'money'
				}, ],
				draggable : true,
				onSelect : function(row) {
					if (row != undefined) {
						onDeductibleSelected1(row, dedLevel);
						$("deductibleText" + dedLevel).setAttribute("changed",
								"changed");
						changeTag = 1;
					}
				}
			});
		} catch (e) {
			showErrorMessage("showDeductibleLOV1", e);
		}
	}
	
	function onDeductibleSelected1(deductible, dedLevel) {
		var amount = deductible.deductibleAmt;
		var rate = deductible.deductibleRate;
		
		$("txtDeductibleCd" + dedLevel).value = deductible.deductibleCd.replace("slash", "/"); //[10.20.16] SR-22912 (.replace("slash", "/") added by: june mark
		$("txtDeductibleCd" + dedLevel).writeAttribute("deductibleType",
				deductible.deductibleType);
		$("txtDeductibleCd" + dedLevel).writeAttribute("minAmt",
				deductible.minimumAmount);
		$("txtDeductibleCd" + dedLevel).writeAttribute("maxAmt",
				deductible.maximumAmount);
		$("txtDeductibleCd" + dedLevel).writeAttribute("rangeSw",
				deductible.rangeSw);
		$("txtDeductibleDesc" + dedLevel).value = unescapeHTML2(deductible.deductibleTitle);
		$("inputDeductibleAmount" + dedLevel).value = (amount == null
				|| amount == "" ? "" : formatCurrency(amount));
		$("deductibleRate" + dedLevel).value = (rate == null || rate == "" ? ""
				: formatToNineDecimal(rate));
		$("deductibleText" + dedLevel).value = (unescapeHTML2(deductible.deductibleText)
				.replace(/\\n/g, "\n"));

		if (deductible.deductibleType == "T") {
			var itemNum = 1 < dedLevel ? objQuote.selectedItemInfoRow.itemNo: 0;
			// var rate =
			// $("inputDeductible"+dedLevel).options[index].getAttribute("dRate");
			var minAmt = deductible.minimumAmount;
			var maxAmt = deductible.maximumAmount;
			var rangeSw = deductible.rangeSw;
			
			var amount = parseFloat(getAmount1(dedLevel, itemNum))
					* (parseFloat(rate) / 100);
			
			if (rate != null) {
				if (minAmt != null && maxAmt != null) {
					if (rangeSw == "H") {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
								.min(Math.max(amount, minAmt), maxAmt));
					} else if (rangeSw == "L") {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
								.min(Math.max(amount, minAmt), maxAmt));
					} else {
						$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
					}
				} else if (minAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.max(amount, minAmt));
				} else if (maxAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(Math
							.min(amount, maxAmt));
				} else {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(amount);
				}
			} else {
				if (minAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(minAmt);
				} else if (maxAmt != null) {
					$("inputDeductibleAmount" + dedLevel).value = formatCurrency(maxAmt);
				}
			}
		}
	}

	function getAmount1(dedLevel, itemNo){
		try {
			var amount = 0;
			
			if (dedLevel == 1){
				$$("div[name='hidPeril']").each(function(peril){
					if(peril.down("input", 3).value == "B"){
						amount+= parseFloat(peril.down("input", 2).value.replace(/,/g, ""));
					}
				});
			} else if (dedLevel == 2){
				amount = parseFloat($F("txtTsiAmt").replace(/,/g, ""));	
			} else if (dedLevel == 3){
				amount = parseFloat(objQuote.selectedPerilInfoRow.perilTsiAmt);	
			}
			return amount;
		} catch (e){
			showErrorMessage("getAmount1", e);
		}
	} 
	$("hrefDeductible3").observe("click", function(){
		quoteDeductibleLOV(tbgPerilItemQuotationDeductible); 
	});
	
	function computeTotalAmountInTable(deductibleAmt) {
		try {
			var total=unformatCurrency("totalDeductibleAmount3");
			total =parseFloat(total) + (parseFloat(nvl(deductibleAmt,0)));
			$("totalDeductibleAmount3").value = formatCurrency(total).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}
</script>