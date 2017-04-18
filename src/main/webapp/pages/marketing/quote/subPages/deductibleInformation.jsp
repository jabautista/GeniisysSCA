<div id="deductibleInformationMainDiv" name="deductibleInformationMainDiv">

	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Deductible Information</label> 
			<span class="refreshers" style="margin-top: 0;"> 
				<label id="deductibleInfoLbl" name="gro">Show</label>
			</span>
		</div>
	</div>
	
	<div id="deductibleInfoSectionDiv" name="deductibleInfoSectionDiv" class="sectionDiv" style="display: none;">
	
		<div id="deductibleInfoTableGrid" style="height: 185px; margin: 15px; width: 890px; "></div>
		
		<div align="right" style="width: 100%; border: 0px;" class="sectionDiv">
			<label style="float: left; margin-top: 6px; margin-left: 615px;">Total Deductible Amount:</label>
			<input type="text" id="totalDeductibleAmount" style="margin-left: 3px; width: 120px; float: left; text-align: right;" readonly="readonly"/>
		</div>
		<table align="center" width="60%">
			<tr>
				<td class="rightAligned">Deductible Title</td>
				<td class="leftAligned" colspan="3">
					<div id="deductibleTitleDiv" class="required" style="width: 100%; height: 21px; margin-top: 0px; border: solid 1px gray">
						<input id="txtDeductibleTitle" class="required" type="text" style="border: none; float: left; width: 93%; height: 13px; margin: 0px;" value="" readonly="readonly">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="deductibleInfoLOV" alt="Go" style="float: right;"/>
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="18%">Rate</td>
				<td class="leftAligned" width="25%"><input type="text" id="txtDeductibleRate" style="width: 96%;"/></td>
				<td class="rightAligned" width="13%">Amount</td>
				<td class="leftAligned" width="25%"><input type="text" id="txtDeductibleAmt" class="money" style="width: 96%;"/></td>
			</tr>
			<tr>
				<td class="rightAligned">Deductible Text</td>
				<td class="leftAligned" colspan="3">
					<textarea id="txtDeductibleText" style="width: 98.5%; resize:none;" maxlength="2000" rows="2" readonly="readonly"></textarea>
				</td>
			</tr>
		</table>
		<div>
			<table align="center">
				<tr>
					<td>
						<input type="button" class="button" id="btnAddDeductibleInfo" value="Add" style="float: left; margin-left: 3px;"/>
						<input type="button" class="button" id="btnDeleteDeductibleInfo" value="Delete" style="float: left; margin-left: 3px;"/>
						<input type="button" class="button" id="btnMaintainDeductible" value="Maintain Deductibles" style="float: left; margin-left: 3px;"/>	
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	try{
		//initializeAccordion();
		disableButton("btnDeleteDeductibleInfo");
		
		try{
			objQuote.objDeductibleInfo = [];
			objQuote.selectedDeductibleIndex = -1;
			var mtgId = null;
			var objDeductibleInfo = new Object(); 
			objDeductibleInfo.objDeductibleInfoTableGrid = JSON.parse('${deductibleInfoList}'.replace(/\\/g, '\\\\'));
			objDeductibleInfo.objDeductibleInfoRows = objDeductibleInfo.objDeductibleInfoTableGrid.rows || [];
			
			var deductibleInfoTableModel = {
				url: contextPath+"/GIPIQuoteDeductiblesController?action=getDeductibleInfoTG&refresh=1&quoteId="+objGIPIQuote.quoteId+"&itemNo="+objQuote.selectedItemInfoRow.itemNo
								+"&perilCd="+objQuote.selectedPerilInfoRow.perilCd+"&lineCd="+objGIPIQuote.lineCd+"&sublineCd="+objGIPIQuote.sublineCd,
				options: {
					id : 3,
					title: "",
					height: "170px",
					width: "890px",
					onCellFocus: function(element, value, x, y, id){
						mtgId = deductibleInfoGrid._mtgId;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							var objSelected = deductibleInfoGrid.geniisysRows[y];
							objQuote.selectedDeductibleIndex = y;
							deductibleInfoGrid.keys.releaseKeys();
							toggleDeductibleInfoButtons();
							setDeductibleInfoForm(objSelected);
						}
						
					},
					onRemoveRowFocus: function(){
						deductibleInfoGrid.keys.releaseKeys();
						objQuote.selectedDeductibleIndex = -1;
						toggleDeductibleInfoButtons();
						setDeductibleInfoForm(null);
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
									titleAlign: 'center',
									width: '65px'
								},
								{	
									id : 'deductibleTitle',
									title: 'Deductible Title',
									titleAlign: 'center',
									width: '180px'
								},
								{	
									id : 'deductibleText',
									title: 'Deductible Text',
									titleAlign: 'center',
									width: '380px'
								},
								{	
									id : 'deductibleRt',
									title: 'Rate',
									titleAlign: 'center',
									width: '100px',
									align: 'right',
									geniisysClass: 'rate'
								},
								{	
									id : 'deductibleAmt',
									title: 'Amount',
									titleAlign: 'center',
									align: 'right',
									width: '140px',
									geniisysClass: 'money'
								},	
							],
							rows: objDeductibleInfo.objDeductibleInfoRows
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
			$("txtDeductibleTitle").value = (obj == null ? "" : obj.deductibleTitle);
			$("txtDeductibleRate").value = (obj == null ? "" : formatToNineDecimal(obj.deductibleRt));
			$("txtDeductibleAmt").value = (obj == null ? "" : formatCurrency(obj.deductibleAmt));
			$("txtDeductibleText").value = (obj == null ? "" : obj.deductibleText);
			deductibleCd = (obj == null ? "" : obj.deductibleCd);
		}
	
		$("deductibleInfoLOV").observe("click",function(){
			//var notIn = createCompletedNotInParam(deductibleInfoGrid, "deductibleCd");
			//showDeductibleInfoLOV(objGIPIQuote.lineCd, objGIPIQuote.sublineCd, notIn);
			showDeductibleInfoLOV(objGIPIQuote.lineCd, objGIPIQuote.sublineCd, "");
		});
		
		function showDeductibleInfoLOV(lineCd, sublineCd, notIn){
			try {
				LOV.show({
					controller: "UnderwritingLOVController",
					urlParameters: {action : "getGIISDeductibleLOV",
									lineCd : lineCd,
									sublineCd : sublineCd,
									notIn : nvl(notIn, ""),
									page : 1},
					title: "Deductibles",
					width: 660,
					height: 320,
					columnModel : [	{	id : "deductibleCd",
										title: "Code",
										width: '80px'
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
										width: '100px',
										align: 'right',
										geniisysClass: 'money'
									},
								],
					draggable: true,
					onSelect : function(row){
						deductibleCd = unescapeHTML2(row.deductibleCd);
						$("txtDeductibleTitle").value = unescapeHTML2(row.deductibleTitle);
						$("txtDeductibleRate").value = unescapeHTML2(formatToNineDecimal(row.deductibleRate));
						$("txtDeductibleAmt").value = unescapeHTML2(formatCurrency(row.deductibleAmt));
						$("txtDeductibleText").value = unescapeHTML2(row.deductibleText);
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
			}
			computeTotalDeductibleAmount();
			deductibleInfoGrid.onRemoveRowFocus();
			$("txtDeductibleTitle").clear();
			$("txtDeductibleRate").clear();
			$("txtDeductibleAmt").clear();
			$("txtDeductibleText").clear();
		});
		
		$("btnDeleteDeductibleInfo").observe("click", function(){
			var rowObj = createDeductibleInfoDtls("Delete");
			objQuote.objDeductibleInfo.splice(objQuote.selectedDeductibleIndex, 1, rowObj);
			deductibleInfoGrid.deleteVisibleRowOnly(objQuote.selectedDeductibleIndex);
			computeTotalDeductibleAmount();
			deductibleInfoGrid.onRemoveRowFocus();
		});
		
		$("btnMaintainDeductible").observe("click", function(){
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, "I");
		});
		
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