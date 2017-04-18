<div id="deductibleInfoSectionDiv" name="deductibleInfoSectionDiv" class="sectionDiv" changeTagAttr="true">

	<div id="deductibleInfoTableGrid" style="height: 230px; margin: 10px;"></div>
	
	<div align="right" style="width: 100%; border: 0px; margin-bottom: 20px;" class="sectionDiv">
		<label style="float: left; margin-top: 6px; margin-left: 630px;">Total Deductible Amount:</label>
		<input type="text" id="totalDeductibleAmount" style="margin-left: 3px; width: 122px; float: left; text-align: right;" readonly="readonly" tabindex="501"/>
	</div>
	<table align="center" width="60%">
		<tr>
			<td class="rightAligned">Deductible Title</td>
			<td class="leftAligned" colspan="3">
				<div id="deductibleTitleDiv" class="required" style="width: 100%; height: 21px; margin-top: 0px; border: solid 1px gray">
					<input id="txtDeductibleTitle" class="required" type="text" style="border: none; float: left; width: 93%; height: 13px; margin: 0px;" value="" readonly="readonly" tabindex="502">
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="deductibleInfoLOV" alt="Go" style="float: right;" tabindex="503"/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" width="13%">Rate</td>
			<td class="leftAligned" width="25%">
				<input type="text" id="txtDeductibleRate" readonly="readonly" style="width: 96%; text-align: right;" tabindex="504"/>
				<input id="deductibleType" name="deductibleType" type="hidden" value="">
			</td>
			<td class="rightAligned" width="13%">Amount</td>
			<td class="leftAligned" width="25%"><input type="text" id="txtDeductibleAmt" class="money" readonly="readonly" style="width: 96%;" tabindex="505"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Deductible Text</td>
			<td class="leftAligned" colspan="3">
				<textarea id="txtDeductibleText" style="width: 98.5%; resize:none;" maxlength="2000" rows="2" readonly="readonly" tabindex="506"></textarea>
			</td>
		</tr>
	</table>
	<div style="margin-bottom: 9px; margin-top: 5px;">
		<table align="center">
			<tr>
				<td>
					<input type="button" class="button" id="btnAddDeductibleInfo" value="Add" style="float: left; margin-left: 3px; width: 90px;" tabindex="507"/>
					<input type="button" class="button" id="btnDeleteDeductibleInfo" value="Delete" style="float: left; margin-left: 8px; width: 90px;" tabindex="508"/>
					<!-- <input type="button" class="button" id="btnMaintainDeductible" value="Maintain Deductibles" style="float: left; margin-left: 3px;"/> -->	
				</td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	try{
		disableButton("btnDeleteDeductibleInfo");
		
		try{
			objQuote.objDeductibleInfo = [];
			objQuote.selectedDeductibleIndex = -1;
			var objDeductibleInfo = new Object(); 
			
			objDeductibleInfo.objDeductibleInfoTableGrid = {};
			
			var deductibleInfoTableModel = {
				options: {
					id : 3,
					title: "",
					height: "206px",
					width: "900px",
					onCellFocus: function(element, value, x, y, id){
						var objSelected = deductibleInfoGrid.geniisysRows[y];
						objQuote.selectedDeductibleRow = deductibleInfoGrid.geniisysRows[y];
						objQuote.selectedDeductibleIndex = y;
						deductibleInfoGrid.keys.releaseKeys();
						toggleDeductibleInfoButtons();
						setDeductibleInfoForm(objSelected);
						disableSearch("deductibleInfoLOV");
					},
					onRemoveRowFocus: function(){
						deductibleInfoGrid.keys.releaseKeys();
						objQuote.selectedDeductibleIndex = -1;
						toggleDeductibleInfoButtons();
						setDeductibleInfoForm(null);
						enableSearch("deductibleInfoLOV");
					},
					beforeSort: function(){
						if (changeTag == 1){
							showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", objQuoteGlobal.saveAllQuotationInformation, showQuotationInformation,"");
							return false;
						} else {
							return true;
						}
					},
					onSort: function(){
						setDeductibleInfoForm(null);
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh : function() {
							objQuote.selectedDeductibleIndex = -1;
							objQuote.selectedDeductibleRow = "";
						}
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
									id: 'quoteId',
									width: '0',
									visible: false
								},
								{										
									id: 'itemNo',
									width: '0',
									visible: false
								},
								{	
									id: 'perilCd',
									width: '0',
									visible: false
								},
								{	
									id : 'deductibleCd',
									title: 'Code',
									titleAlign: 'left',
									width: '65px',
									filterOption: true
								},
								{	
									id : 'deductibleTitle',
									title: 'Deductible Title',
									titleAlign: 'left',
									width: '180px',
									filterOption: true
								},
								{	
									id : 'deductibleText',
									title: 'Deductible Text',
									titleAlign: 'left',
									width: '390px',
									filterOption: true
								},
								{	
									id : 'deductibleRt',
									title: 'Rate',
									titleAlign: 'right',
									width: '115px',
									align: 'right',
									geniisysClass: 'rate',
									filterOption: true,
									filterOptionType: 'integer'
								},
								{	
									id : 'deductibleAmt',
									title: 'Amount',
									titleAlign: 'right',
									align: 'right',
									width: '128px',
									geniisysClass: 'money',
									filterOption: true,
									filterOptionType: 'numberNoNegative'
								},	
							],
							rows: [],
							id: 26665
			};
			deductibleInfoGrid = new MyTableGrid(deductibleInfoTableModel);
			deductibleInfoGrid.pager = objDeductibleInfo.objDeductibleInfoTableGrid;
			deductibleInfoGrid.render("deductibleInfoTableGrid");
			deductibleInfoGrid.afterRender = function (){
				objQuote.objDeductibleInfo = deductibleInfoGrid.geniisysRows;
				computeTotalDeductibleAmount();
			};
		}catch(e){
			showErrorMessage("deductibleInformationTableGrid page", e);
		}
 
		$("txtDeductibleRate").observe("change", function(){
			if(isNaN($F("txtDeductibleRate"))){
				$("txtDeductibleRate").clear();
				customShowMessageBox("Field must be of form 990.999999990.", "E", "txtDeductibleRate");
			}else if($F("txtDeductibleRate") > 100 || $F("txtDeductibleRate") < 0){
				$("txtDeductibleRate").clear();
				customShowMessageBox("Must be in range 0.000000000 to 100.000000000.", "E", "txtDeductibleRate");
			}else{
				if(deductibleCd != null){
					$("txtDeductibleAmt").clear();
					$("txtDeductibleRate").value = formatToNineDecimal($F("txtDeductibleRate"));	
				}
			}
		});
		
		$("txtDeductibleAmt").observe("change", function(){
			if(isNaN($F("txtDeductibleAmt")) || $F("txtDeductibleAmt") > 100000000000000){
				$("txtDeductibleAmt").clear();
				customShowMessageBox("Field must be of form 99,999,999,999,999.99.", "E", "txtDeductibleAmt");
			}else if($F("txtDeductibleAmt") < 0){
				$("txtDeductibleAmt").clear();
				customShowMessageBox("Must be in range 0.00 to 99,999,999,999,999.99.", "E", "txtDeductibleAmt");
			}else{
				if(deductibleCd != null){
					$("txtDeductibleRate").clear();
					$("txtDeductibleAmt").value = formatCurrency($F("txtDeductibleAmt"));	
				}
			}
		});
		
		function setDeductibleInfoForm(obj){
			$("txtDeductibleTitle").value = (obj == null ? "" : unescapeHTML2(obj.deductibleTitle));
			$("txtDeductibleRate").value = (obj == null ? "" : unescapeHTML2(formatToNineDecimal(obj.deductibleRt)));
			$("txtDeductibleAmt").value = (obj == null ? "" : unescapeHTML2(formatCurrency(obj.deductibleAmt)));
			$("txtDeductibleText").value = (obj == null ? "" : unescapeHTML2(obj.deductibleText));
			deductibleCd = (obj == null ? "" : obj.deductibleCd);
		}
		
		objQuoteGlobal.setDeductibleInfoForm = setDeductibleInfoForm;
		
		function getDeductibleInfoLOV(){
			var notIn = "";
			var withPrevious = false;
			var selectedPeril = unformatCurrencyValue($F("perilTsiAmt")); //added by steven 12/21/2012
			for(var i = 0; i<objQuote.objDeductibleInfo.length; i++){
				if(objQuote.objDeductibleInfo[i].recordStatus != -1){
					notIn += withPrevious ? "," : "";
					notIn = notIn +"\'"+objQuote.objDeductibleInfo[i].deductibleCd+"\'";
					withPrevious = true;
				}
			}
			if(objQuote.selectedPerilInfoRow.perilCd != undefined){
// 				notIn = notIn != "" ? "("+notIn+")" : "";
				showDeductibleInfoLOV(objGIPIQuote.lineCd, objGIPIQuote.sublineCd, notIn,selectedPeril);	
				//showDeductibleInfoLOV(objGIPIQuote.lineCd, objGIPIQuote.sublineCd, "");
			}else{
				showMessageBox("Please select a peril first.", "I");
			}
		}
	
		$("deductibleInfoLOV").observe("click",getDeductibleInfoLOV);
		
		$("deductibleInfoLOV").observe("keypress", function (event) {
			if (event.keyCode == 13){
				getDeductibleInfoLOV();
			}
		});
		
		function showDeductibleInfoLOV(lineCd, sublineCd, notIn, perilTsiAmount){ //added by steven 12/21/2012 "perilTsiAmount"
			try {
				LOV.show({
					controller: "UnderwritingLOVController",
					urlParameters: {action : "getQuoteDeductibleLOV", //marco - 07.01.2013 - getGIISDeductibleLOV
									lineCd : lineCd,
									sublineCd : sublineCd,
									notIn : notIn != "" ? "("+notIn+")" : "",
									page : 1},
					title: "Deductibles",
					width: 660,
					height: 320,
					columnModel : [	{	id : "deductibleCd",
										title: "Code",
										width: '65px'
									},
									{	id : "deductibleTitle",
										title: "Title",
										width: '220px'
									},
									{	id : "deductibleTypeDesc",
										title: "Type",
										width: '150px'
									},	
									{	id : "deductibleRate",
										title: "Rate",
										width: '100px',
										align: 'right',
										geniisysClass: 'money'
									},
									{	id : "deductibleAmt",
										title: "Amount",
										width: '104px',
										align: 'right',
										geniisysClass: 'money'
									},
								],
					draggable: true,
					onSelect : function(row){
						if(row != undefined){ //added by steven 12/21/2012 commented-out the code below.
							onQuoteDeductibleSelected(row, perilTsiAmount);
							deductibleCd = unescapeHTML2(row.deductibleCd);
							$("deductibleType").value = unescapeHTML2(row.deductibleType); //added by steven 1/3/2013
						}
// 						deductibleCd = unescapeHTML2(row.deductibleCd); 
// 						$("txtDeductibleTitle").value = unescapeHTML2(row.deductibleTitle);
// 						$("txtDeductibleRate").value = unescapeHTML2(formatToNineDecimal(row.deductibleRate));
// 						$("txtDeductibleAmt").value = unescapeHTML2(formatCurrency(row.deductibleAmt));
// 						$("txtDeductibleText").value = unescapeHTML2(row.deductibleText);
					}
				});
			} catch (e){
				showErrorMessage("showDeductibleInfoLOV", e);
			}
		}
	
		$("btnAddDeductibleInfo").observe("click", function(){
			if(checkAllRequiredFieldsInDiv("deductibleTitleDiv")){
				var rowObj = createDeductibleInfoDtls($("btnAddDeductibleInfo").value);
				if($("btnAddDeductibleInfo").value == "Add"){
					objQuote.objDeductibleInfo.push(rowObj);
					deductibleInfoGrid.addBottomRow(rowObj);			
				}else{
					objQuote.objDeductibleInfo.splice(objQuote.selectedDeductibleIndex, 1, rowObj);
					deductibleInfoGrid.updateVisibleRowOnly(rowObj, objQuote.selectedDeductibleIndex);
				}
				hidObjGIIMM002.perilChangeTag = 1; //added by steven 1/3/2013
			}
			computeTotalDeductibleAmount();
			deductibleInfoGrid.onRemoveRowFocus();
			$("txtDeductibleTitle").clear();
			$("txtDeductibleRate").clear();
			$("txtDeductibleAmt").clear();
			$("txtDeductibleText").clear();
			clearChangeAttribute("deductibleInfoSectionDiv");
		});
		
		$("btnDeleteDeductibleInfo").observe("click", function(){
			var rowObj = createDeductibleInfoDtls("Delete");
			objQuote.objDeductibleInfo.splice(objQuote.selectedDeductibleIndex, 1, rowObj);
			deductibleInfoGrid.deleteVisibleRowOnly(objQuote.selectedDeductibleIndex);
			computeTotalDeductibleAmount();
			deductibleInfoGrid.onRemoveRowFocus();
			hidObjGIIMM002.perilChangeTag = 1; //added by steven 1/3/2013
			changeTag = 1;
		});
		
		/* $("btnMaintainDeductible").observe("click", function(){
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		}); */
		
		function computeTotalDeductibleAmount(){
			var deductibleTotalAmt = 0;
			var dedAmt = 0;
			for(var i = 0; i < objQuote.objDeductibleInfo.length; i++){
				if(objQuote.objDeductibleInfo[i].recordStatus != -1){
					if(objQuote.objDeductibleInfo[i].deductibleAmt == null){
						dedAmt = 0;	
					}else if(objQuote.objDeductibleInfo[i].deductibleAmt == 0){
						dedAmt = 0;
					}else{
						dedAmt = unformatCurrencyValue(objQuote.objDeductibleInfo[i].deductibleAmt);
					}
					deductibleTotalAmt = parseFloat(deductibleTotalAmt) + parseFloat(dedAmt);	
				}
			}
			$("totalDeductibleAmount").value = formatCurrency(deductibleTotalAmt);
		}
		
		function toggleDeductibleInfoButtons(){
			if(objQuote.selectedDeductibleIndex == -1){
				$("btnAddDeductibleInfo").value = "Add";
				disableButton($("btnDeleteDeductibleInfo"));
			}else{
				$("btnAddDeductibleInfo").value = "Update";
				enableButton($("btnDeleteDeductibleInfo"));
			}
		}
		
		function createDeductibleInfoDtls(func){
			var deductibleInfo = new Object();
			deductibleInfo.quoteId = objGIPIQuote.quoteId;
			deductibleInfo.itemNo = objQuote.selectedItemInfoRow.itemNo;
			deductibleInfo.perilCd = objQuote.selectedPerilInfoRow.perilCd;
			deductibleInfo.deductibleCd	= deductibleCd;
			deductibleInfo.deductibleType = escapeHTML2($F("deductibleType")); //added by steven 1/3/2013
			deductibleInfo.deductibleTitle = escapeHTML2($F("txtDeductibleTitle"));
			deductibleInfo.deductibleText = escapeHTML2($F("txtDeductibleText"));
			deductibleInfo.deductibleRt = escapeHTML2($F("txtDeductibleRate"));
			deductibleInfo.deductibleAmt = escapeHTML2($F("txtDeductibleAmt"));
			deductibleInfo.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			return deductibleInfo;
		}
		
	}catch(e){
		showErrorMessage("deductibleInformation page", e);
	}
</script>
