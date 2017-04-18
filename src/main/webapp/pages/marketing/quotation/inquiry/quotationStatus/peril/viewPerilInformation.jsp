<div id="perilInformationMainDiv" name="perilInformationMainDiv">
	<div id="perilInformationDiv" name="perilInformationDiv">
		<div id="perilTotalDiv" name="perilTotalDiv" class="sectionDiv" style="padding: 5px 0 5px 0;">
			<table align="center">
				<tr>
					<td class="rightAligned">Total TSI Amt.</td>
					<td><input id="totalTsi" name="totalTsi" class="money" type="text" readonly="readonly" style="margin-right: 50px; width: 200px;" value="" tabindex="401"></td>
					<td class="rightAligned">Total Premium Amt.</td>
					<td><input id="totalPrem" name="totalPrem" class="money" type="text" readonly="readonly" style="width: 200px;" value="" tabindex="402"></td>
				</tr>
			</table>
		</div>
		<div id="perilInformationDiv" name="perilInformationDiv" class="sectionDiv" style="padding-bottom: 10px;">
			<div id="perilInformationTGDiv" name="perilInformationTGDiv" style="height: 230px; width: 99%; padding: 10px 0 0 10px;">
			
			</div>
			<div id="perilInformationTextDiv" name="perilInformationTextDiv" style="margin: 5px 0 0 0;">
				<table align="center">
					<tr>
						<td class="rightAligned">Peril Name</td>
						<td>
							<input id="perilName" name="perilName" class="" type="text" style="float: left; width: 200px; height: 13px; margin: 0px;" readonly="readonly" tabindex="403">
						</td>
						<td class="rightAligned">Peril Rate</td>
						<td><input id="perilRate" name="perilRate" class="moneyRate" type="text" style="width: 200px;" maxlength="13" tabindex="405" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">TSI Amt.</td>
						<td><input id="perilTsiAmt" name="perilTsiAmt" class="money" type="text" align="right" style="width: 200px; margin-right: 25px;" maxlength="17"tabindex="406" readonly="readonly"></td>
						<td class="rightAligned">Premium Amt.</td>
						<td><input id="perilPremAmt" name="perilPremAmt" class="money" type="text" align="right" style="width: 200px;" tabindex="407" readonly="readonly"></td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3">
							<div id="remarksDiv" style="border: 1px solid gray; height: 20px; width: 529px;">
								<textarea id="perilRemarks" name="perilRemarks" style="width: 503px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="50" tabindex="408" readonly="readonly"/></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" tabindex="409"/>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<div id="hiddenDiv" name="hiddenDiv">
				<input id="hidPerilCd" name="hidPerilCd" type="hidden" value="">
				<input id="hidPerilSname" name="hidPerilSname" type="hidden" value="">
				<input id="hidPerilType" name="hidPerilType" type="hidden" value="">
				<input id="hidBasicPerilCd" name="hidBasicPerilCd" type="hidden" value="">
				<input id="hidPrtFlag" name="hidPrtFlag" type="hidden" value="">
				<input id="hidLineCd" name="hidLineCd" type="hidden" value="">
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	initializeAll();
	initializeAllMoneyFields();
	
	objQuote.objPeril = [];
	objQuote.selectedPerilIndex = -1;
	objQuote.selectedPerilInfoRow = "";
	
	var objPerilInfo = new Object();
	objPerilInfo.objPerilInfoTableGrid = {};
	try{
		var perilInfoTableModel = {
			options: {
				id: 2,
				title: '',
              	height: '206px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		perilTableGrid.keys.releaseKeys();
	          		objQuote.selectedPerilIndex = y;
	          		objQuote.selectedPerilInfoRow = perilTableGrid.geniisysRows[y];
	          		populatePerilInfoDtls(true);
	          		objQuoteGlobal.showDeductibleInfoTG(true);
	          		if(objQuoteGlobal.lineCd != "SU"){
	          			enableSubpage("additionalInfoAccordionLbl");
	          		}
	          		objQuoteGlobal.setDeductibleInfoForm(null);
                },
                onRemoveRowFocus: function(){
                	perilTableGrid.keys.releaseKeys();	
                	objQuote.selectedPerilIndex = -1;
                	objQuote.selectedPerilInfoRow = "";
                	populatePerilInfoDtls(false);
                	objQuoteGlobal.showDeductibleInfoTG(false);
                	objQuoteGlobal.setDeductibleInfoForm(null);
                },
                onSort: function(){
                	resetPerilTG();
                	objQuoteGlobal.showDeductibleInfoTG(false);
                	objQuoteGlobal.setDeductibleInfoForm(null);
                },
                toolbar: {
                	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
                	onRefresh: function(){
                		resetPerilTG();
                	},
                	onFilter: function(){
                		resetPerilTG();
                		objQuoteGlobal.showDeductibleInfoTG(false);
                    	objQuoteGlobal.setDeductibleInfoForm(null);
                	}
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
						{	id: 'perilName',
							title: 'Peril Name',
							width: '237px',
							filterOption: true
						},
						{	id: 'perilPremRt',
							title: 'Rate',
							width: '100px',
							geniisysClass: 'rate',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'perilTsiAmt',
							title: 'TSI Amount',
							titleAlign: 'right',
							width: '116px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'perilPremAmt',
							title: 'Prem Amount',
							titleAlign: 'right',
							width: '116px',
							geniisysClass: 'money',
							align: 'right',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'perilCompRem',
							title: 'Remarks',
							width: '297px',
							filterOption: true
						},
						{	id: 'perilQuoteId',
							width: '0px',
							visible: false
						},
						{	id: 'perilItemNo',
							width: '0px',
							visible: false
						},
						{	id: 'perilCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilType',
							width: '0px',
							visible: false
						},
						{	id: 'perilBasicPerilCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilPrtFlag',
							width: '0px',
							visible: false
						},
						{	id: 'perilLineCd',
							width: '0px',
							visible: false
						},
						{	id: 'perilSname',
							width: '0px',
							visible: false
						},
						{	id: 'perilDedFlag',
							width: '0px',
							visible: false
						}
  					],  				
  				rows: []
		};
		perilTableGrid = new MyTableGrid(perilInfoTableModel);
		perilTableGrid.pager = objPerilInfo.objPerilInfoTableGrid;
		perilTableGrid.render('perilInformationTGDiv');
		perilTableGrid.afterRender = function(){
			objQuote.objPeril = perilTableGrid.geniisysRows;
			computePerilTotals();
			populatePerilInfoDtls(false);
		};
	}catch(e){
		showMessageBox("Error in Peril Information TableGrid: " + e, imgMessage.ERROR);
	}
	
	$("editRemarks").observe("click", function(){
		showEditor("perilRemarks", 50, "true");
	});
	
	$("editRemarks").observe("keypress", function (event) {
		if (event.keyCode == 13){
			showEditor("perilRemarks", 50, "true");
		}
	});
	
	function computePerilTotals(){
		var tsiTotal = 0;
		var premTotal = 0;
		for(var i = 0; i < objQuote.objPeril.length; i++){
			if(objQuote.objPeril[i].recordStatus != -1){
				if(objQuote.objPeril[i].perilType == 'B'){
					tsiTotal = parseFloat(tsiTotal) + parseFloat(objQuote.objPeril[i].perilTsiAmt);
				}
				premTotal = parseFloat(premTotal) + parseFloat(objQuote.objPeril[i].perilPremAmt);
			}
		}
		$("totalTsi").value = formatCurrency(tsiTotal);
		$("totalPrem").value = formatCurrency(premTotal);
	}

	function resetPerilTG(){
		objQuote.selectedPerilIndex = -1;
    	objQuote.selectedPerilInfoRow = "";
	}
	
	function populatePerilInfoDtls(populate){
		$("perilName").value = populate ? unescapeHTML2(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilName) : "";
		$("perilTsiAmt").value = populate ? formatCurrency(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilTsiAmt) : "";
		$("perilRemarks").value = populate ? unescapeHTML2(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilCompRem) : "";
		$("perilRate").value = populate ? formatToNineDecimal(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilPremRt) : "";
		$("perilPremAmt").value = populate ? formatCurrency(perilTableGrid.geniisysRows[objQuote.selectedPerilIndex].perilPremAmt) : "";
		
		$("hidPerilType").value = populate ? objQuote.selectedPerilInfoRow.perilType : "";
		$("hidPerilSname").value = populate ? objQuote.selectedPerilInfoRow.perilSname : "";
		$("hidBasicPerilCd").value = populate ? objQuote.selectedPerilInfoRow.perilBasicPerilCd : "";
		$("hidPrtFlag").value = populate ? objQuote.selectedPerilInfoRow.perilPrtFlag : "";
		$("hidLineCd").value = populate ? objQuote.selectedPerilInfoRow.perilLineCd : "";
		$("hidPerilCd").value = populate ? objQuote.selectedPerilInfoRow.perilCd : "";
	}
	objQuoteGlobal.populatePerilInfoDtls = populatePerilInfoDtls;
</script>