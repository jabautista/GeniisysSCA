<div id="enrolleeCoverageMainDiv" class="sectionDiv" style="width:720px; margin-top: 5px; margin-left: 5px;">
	<div id="enrolleeInfoDiv" class="sectionDiv" style="border-right: 0px; border-left: 0px; border-top: 0px;">
		<table align="center">
			<tr>
				<td><label>Enrollee:</label></td>
				<td style="padding-left: 5px;">
					<input id="dspGroupedItemNo" type="text" readonly="readonly" style="width: 100px;" value="" tabindex="-1">
				</td>
				<td>
					<input id="dspEnrolleeName" type="text" readonly="readonly" style="width: 300px;" value="" tabindex="-1">
				</td>
			</tr>
		</table>
	</div>
	<div id="amountsDiv" class="sectionDiv" style="border-right: 0px; border-left: 0px;">
		<table align="center">
			<tr>
				<td><label style="width: 116px; text-align: right;">TSI Amount:</label></td>
				<td><input id="dspTsiAmt" type="text" readonly="readonly" style="width: 215px;" class="money2" readonly="readonly" tabindex="-1"></td>
				<td><label style="width: 125px; text-align: right;">Premium Amount:</label></td>
				<td><input id="dspPremAmt" type="text" readonly="readonly" style="width: 215px;" class="money2" readonly="readonly" tabindex="-1"></td>
			</tr>
			<tr>
				<td><label>Annual TSI Amount:</label></td>
				<td><input id="dspAnnTsiAmt" type="text" readonly="readonly" style="width: 215px;" class="money2" readonly="readonly" tabindex="-1"></td>
				<td><label style="width: 125px; text-align: right;">Annual Premium:</label></td>
				<td><input id="dspAnnPremAmt" type="text" readonly="readonly" style="width: 215px;" class="money2" readonly="readonly" tabindex="-1"></td>
			</tr>
		</table>
	</div>
	<div id="enrolleeCoverageTGDiv" style="width: 700px; height: 240px; padding: 5px 0 0 10px; float: left;">
	</div>
	<div id="infoDiv" style="float: left; width: 700px;">
		<table align="center">
			<tr>
				<td class="rightAligned" >Peril Name </td>
				<td class="leftAligned" >
					<div style="float: left; border: solid 1px gray; width: 220px; height: 21px; margin-right: 3px;" class="required">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 192px; border: none;" name="cPerilName" id="cPerilName" readonly="readonly" class="required" tabindex="2101"/>
						<img id="searchPeril" alt="goCPeril" style="height: 18px; margin-top: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" tabindex=""/>						
					</div>
				</td>
				<td class="rightAligned" style="width:110px;">Peril Rate </td>
				<td class="leftAligned" >
					<input id="cPremRt" name="cPremRt" type="text" style="width: 215px; text-align: right;" value="" maxlength="13" class="required moneyRate" regExpPatt="pDeci0309" max="100.000000000" min="0.000000000" hasOwnBlur="N" hasOwnChange="Y" oldValue="" tabindex="2105"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >TSI Amt. </td>
				<td class="leftAligned" >
					<input id="cTsiAmt" name="cTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money" oldValue="" tabindex="2102"/>
				</td>
				<td class="rightAligned" >Premium Amt. </td>
				<td class="leftAligned" >
					<input id="cPremAmt" name="cPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money applyDecimalRegExp" regExpPatt="nDeci1002" max="9999999999.99" min="-9999999999.99" hasOwnBlur="N" hasOwnChange="Y" oldValue="" tabindex="2106"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Ann TSI Amt. </td>
				<td class="leftAligned" >
					<input id="cAnnTsiAmt" name="cAnnTsiAmt" type="text" style="width: 215px;" value="" maxlength="18" class="required money" readonly="readonly" tabindex="2103"/>
				</td>
				<td class="rightAligned" >Ann Premium Amt. </td>
				<td class="leftAligned" >
					<input id="cAnnPremAmt" name="cAnnPremAmt" type="text" style="width: 215px;" value="" maxlength="14" class="required money" readonly="readonly" tabindex="2107"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >No. of Days </td>
				<td class="leftAligned" >
					<input id="cNoOfDays" name="cNoOfDays" type="text" style="width: 215px; text-align: right;" value="" maxlength="6" class="integerNoNegativeUnformattedNoComma" errorMsg="Entered No. of Days is invalid. Valid value is from 0 to 999,999" tabindex="2104"/ oldValue="">
				</td>
				<td class="rightAligned" >Base Amount </td>
				<td class="leftAligned" >
					<input id="cBaseAmt" name="cBaseAmt" type="text" style="width: 215px;" value=""  maxlength="18" class="money" tabindex="2108" oldValue=""/>
				</td>
			</tr>
		</table>
	</div>
	<table align="center" style="margin-bottom: 5px">
		<tr>
			<td>
				<input type="button" class="button" id="btnAddCoverage" value="Add" tabindex="2109"/>
				<input type="button" class="button" id="btnDeleteCoverage" value="Delete" tabindex="2110"/>
			</td>
		</tr>
	</table>
	<div id="hiddenDiv">
		<input id="cLineCdHid" type="hidden">
		<input id="cPerilCdHid" type="hidden">
		<input id="cPerilTypeHid" type="hidden">
		<input id="cRecFlagHid" type="hidden">
		<input id="cAggregateSwHid" type="hidden">
		<input id="cRiCommRateHid" type="hidden">
		<input id="cRiCommAmtHid" type="hidden">
		<input id="cPremAmtHid" type="hidden">
		<input id="cAnnPremAmtHid" type="hidden">
		<input id="cTsiAmtHid" type="hidden">
		<input id="cAnnTsiAmtHid" type="hidden">
		<input id="cBascPerlCdHid" type="hidden">
	</div>
</div>
<div style="width: 100%; float: left; padding-top: 5px;">
	<table align="center" style="margin-bottom: 5px;">
		<tr>
			<td>
				<input type="button" class="button" id="btnCopyBenefits" value="Copy Benefits" style="width: 95px;" tabindex="2201"/>
				<input type="button" class="button" id="btnCancelCoverage" name="btnCancelCoverage" value="Cancel" style="width: 85px;" tabindex="2202"/>
				<input type="button" class="button" id="btnSaveCoverage" value="Save" style="width: 85px;" tabindex="2203"/>
			</td>
		</tr>
	</table>
</div>

<script type="text/javascript">
	var perilRG = "";
	var perilRGLength = 0;
	var selectedCovRow = "";
	var selectedCovIndex = -1;
	
	var parId = objGroupedItems.selectedRow.parId;
	var itemNo = objGroupedItems.selectedRow.itemNo;
	var groupedItemNo = objGroupedItems.selectedRow.groupedItemNo;
	var covVars = JSON.parse('${covVars}');
	
	var objCoverage = new Object();
	objCoverage.objCoverageTableGrid = JSON.parse('${enrolleeCoverageTGJson}');
	objCoverage.objCoverageRows = objCoverage.objCoverageTableGrid.rows || [];
	objCoverage.coverage = [];
	objCoverage.warranty = [];

	$("dspGroupedItemNo").value = formatNumberDigits(objGroupedItems.selectedRow.groupedItemNo, 9);
	$("dspEnrolleeName").value = unescapeHTML2(objGroupedItems.selectedRow.groupedItemTitle);
	disableButton("btnDeleteCoverage");
	populateFieldsOnLoad();
	initializeAllMoneyFields();
	
	try{
		var coverageTableModel = {
			url: contextPath+"/GIPIWItmperlGroupedController?action=showEnrolleeCoverageOverlay&refresh=1&parId="+parId+"&itemNo="+itemNo+
					"&groupedItemNo="+groupedItemNo,
			options: {
				id: 2,
	          	height: '206px',
	          	width: '700px',
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedCovIndex = y;
	          		selectedCovRow = coverageTableGrid.geniisysRows[y];
	          		coverageTableGrid.keys.releaseKeys();
	          		populateCoverageFields(true);
	            },
	            onRemoveRowFocus: function(){
	            	selectedCovIndex = -1;
	            	selectedCovRow = "";
	            	coverageTableGrid.keys.releaseKeys();
	            	populateCoverageFields(false);
	            },
	            prePager: function(){
					if(changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
					} else {
						coverageTableGrid.onRemoveRowFocus();
						return true;
					}
				},
	            beforeSort: function(){
	            	if(changeTag == 1){
	            		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
	            		return false;
	            	}
	            },
	            onSort: function(){
	            	coverageTableGrid.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [],
	            	onRefresh: function(){
	            		coverageTableGrid.onRemoveRowFocus();
	            	},
	            	onFilter: function(){
	            		coverageTableGrid.onRemoveRowFocus();
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
					width: '152px',
					filterOption: true
				},
				{	id: 'premRt',
					title: 'Prem %',
					width: '80px',
					align: 'right',
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'rate'
				},
				{	id: 'tsiAmt',
					title: 'TSI Amount',
					width: '97px',
					align: 'right',
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{	id: 'annTsiAmt',
					title: 'Ann TSI Amt',
					width: '107px',
					align: 'right',
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{	id: 'premAmt',
					title: 'Premium Amt',
					width: '97px',
					align: 'right',
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{	id: 'annPremAmt',
					title: 'Ann Prem Amt',
					width: '107px',
					align: 'right',
					filterOption: true,
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{	id: 'aggregateSw',
					sortable: false,
					align: 'center',
					title: 'SW',
					width: '23px',
					editable: false,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}
		            	}
		            })
				},
				/*benjo 12.16.2015 UCPBGEN-SR-20835*/
				{	id: 'origAnnPremAmt',
					width: '0',
					visible: false
				}
			],
			rows: objCoverage.objCoverageRows
		};
		coverageTableGrid = new MyTableGrid(coverageTableModel);
		coverageTableGrid.pager = objCoverage.objCoverageTableGrid;
		coverageTableGrid.render('enrolleeCoverageTGDiv');
		coverageTableGrid.afterRender = function(){
			coverageTableGrid.keys.releaseKeys();
			objCoverage.coverage = coverageTableGrid.geniisysRows;
			preparePerilRecordGroup();
		};
	}catch(e){
		showErrorMessage("Error in Enrollee Coverage TableGrid", e);
	}
		
	$("searchPeril").observe("click", function(){
		getCoveragePerilLOV();
	});
	
	$("cPremRt").observe("focus", function(){
		if(checkPeril()){
			$("cTsiAmt").setAttribute("oldValue", $F("cTsiAmt"));
			$("cPremAmt").setAttribute("oldValue", $F("cPremAmt"));
			$("cPremRt").setAttribute("oldValue", $F("cPremRt"));
		}
	});
	
	$("cPremRt").observe("change", function(){
		if($F("cPremRt") != "" && parseFloat($F("cPremRt")) < 0){
			showMessageBox("Rate must not be less than zero (0%).", "E");
			$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			/* showWaitingMessageBox("Rate must not be less than zero (0%).", "E", function(){
				$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			}); */
		}else if($F("cPremRt") != "" && parseFloat($F("cPremRt")) > 100){
			showMessageBox("Rate must not be greater than a hundred (100%).", "E");
			$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			/* showWaitingMessageBox("Rate must not be greater than a hundred (100%).", "E", function(){
				$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			}); */
		}else if(isNaN($F("cPremRt"))){
			showMessageBox("Field must be of form 990.999999999", "E");
			$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			/* showWaitingMessageBox("Field must be of form 990.999999999", "E", function(){
				$("cPremRt").value = $("cPremRt").getAttribute("oldValue");
			}); */
		}else{
			computeTsi(false);
		}
	});
	
	$("cTsiAmt").observe("focus", function(){
		if(checkPeril()){
			$("cTsiAmt").setAttribute("oldValue", $F("cTsiAmt"));
			$("cPremAmt").setAttribute("oldValue", $F("cPremAmt"));
			$("cPremRt").setAttribute("oldValue", $F("cPremRt"));	
		}
	});
	
	$("cTsiAmt").observe("change", function(){
		if(parseFloat(unformatCurrencyValue($F("cTsiAmt"))) <= 0 && $F("cRecFlagHid") == "A"){
			showMessageBox("Valid TSI Amt is required.", "E");
			$("cTsiAmt").value = formatCurrency(nvl($("cTsiAmt").getAttribute("oldValue"), "0.00"));
			/* showWaitingMessageBox("Valid TSI Amt is required.", "E", function(){
				$("cTsiAmt").value = formatCurrency(nvl($("cTsiAmt").getAttribute("oldValue"), "0.00"));
			}); */
		}else if(($F("cNoOfDays") != "" && $F("cNoOfDays") != 0) && ($F("cBaseAmt") != "" && parseFloat($F("cBaseAmt")) != 0)){
			showConfirmBox("Confirmation", "Changing TSI amount will delete base amount and set number of days to its default value, " + 
				"do you want to continue?", "Yes", "No",
				function(){
					validateAllied("", "Y", "Y", true);
				},
				function(){
					$("cTsiAmt").value = formatCurrency(nvl($("cTsiAmt").getAttribute("oldValue"), "0.00"));
				}, "");
		}else{
			validateAllied("", "Y", "Y", true);	
		}
	});
	
	$("cPremAmt").observe("focus", function(){
		if(checkPeril()){
			$("cTsiAmt").setAttribute("oldValue", $F("cTsiAmt"));
			$("cPremAmt").setAttribute("oldValue", $F("cPremAmt"));	
		}
	});
	
	$("cPremAmt").observe("change", function(){
		if(isNaN($F("cPremAmt"))){
			showMessageBox("Field must be of form 99,999,999,999,990.09.", "E");
			$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			/* showWaitingMessageBox("Field must be of form 99,999,999,999,990.09.", "E", function(){
				$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			}); */
		}else if(parseInt(nvl($F("cPremAmt"), 0)) < 0 && $F("cRecFlagHid") == "A"){
			showMessageBox("Premium must not be less than zero.", "E");
			$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			/* showWaitingMessageBox("Premium must not be less than zero.", "E", function(){
				$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			}); */
		}else if(parseFloat(unformatCurrencyValue($F("cTsiAmt"))) != 0 && parseFloat(unformatCurrencyValue($F("cPremAmt"))) > parseFloat(unformatCurrencyValue($F("cTsiAmt")))){ //benjo 12.16.2015 UCPBGEN-SR-2015
			showMessageBox("Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen", "I");
			$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			/* showWaitingMessageBox("Premium Rate exceeds 100%, please check your Premium Computation Conditions at Basic Information Screen", "I", function(){
				$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
			}); */
		}else{
			computePremium();
		}
	});
	
	$("cNoOfDays").observe("focus", function(){
		if(checkPeril()){
			$("cTsiAmt").setAttribute("oldValue", $F("cTsiAmt"));
			$("cPremAmt").setAttribute("oldValue", $F("cPremAmt"));
			$("cPremRt").setAttribute("oldValue", $F("cPremRt"));
		}
	});
	
	$("cNoOfDays").observe("change", function(){
		if($F("cNoOfDays") != "" && isNaN($F("cNoOfDays")) || $F("cNoOfDays").include(".")){
			showMessageBox("Legal characters are 0-9 - + E", "E");
			$("cNoOfDays").value = "";
		}else if(($F("cNoOfDays") == "0" || $F("cNoOfDays") == "") && (parseFloat($F("cBaseAmt")) != 0 || $F("cBaseAmt") != "")){
			$("cTsiAmt").value = "";
			$("cBaseAmt").setAttribute("oldValue", $F("cBaseAmt"));
			fireEvent($("cTsiAmt"), "change");
			$("cTsiAmt").value = "0.00";
			$("cBaseAmt").value = $("cBaseAmt").getAttribute("oldValue");
		}else{
			if((parseInt(nvl($F("cNoOfDays"), "0")) != 0) && (parseFloat(nvl($F("cBaseAmt"), "0.00")) != 0.00)){
				$("cTsiAmt").value = formatCurrency(parseFloat($F("cNoOfDays")) * parseFloat(unformatCurrencyValue($F("cBaseAmt"))));
				if(parseFloat(unformatCurrencyValue($F("cTsiAmt"))) != parseFloat(unformatCurrencyValue($("cTsiAmt").getAttribute("oldValue")))){
					validateAllied("", "Y", "Y", false);
				}
			}
		}
	});
	
	$("cBaseAmt").observe("focus", function(){
		if(checkPeril()){
			$("cTsiAmt").setAttribute("oldValue", $F("cTsiAmt"));
			$("cPremAmt").setAttribute("oldValue", $F("cPremAmt"));
			$("cPremRt").setAttribute("oldValue", $F("cPremRt"));	
		}
	});
	
	$("cBaseAmt").observe("change", function(){
		if(($F("cBaseAmt") == "0" || $F("cBaseAmt") == "") && (parseFloat($F("cNoOfDays")) != 0 || $F("cNoOfDays") != "")){
			$("cTsiAmt").value = "";
			$("cNoOfDays").setAttribute("oldValue", $F("cNoOfDays"));
			fireEvent($("cTsiAmt"), "change");
			$("cTsiAmt").value = "0.00";
			$("cNoOfDays").value = $("cNoOfDays").getAttribute("oldValue");
		}else if((parseInt(nvl($F("cNoOfDays"), "0")) != 0) && (parseFloat(nvl($F("cBaseAmt"), "0.00")) != 0.00)){
			$("cTsiAmt").value = formatCurrency(parseFloat($F("cNoOfDays")) * parseFloat(unformatCurrencyValue($F("cBaseAmt"))));
			if(parseFloat(unformatCurrencyValue($F("cTsiAmt"))) != parseFloat(unformatCurrencyValue($("cTsiAmt").getAttribute("oldValue")))){
				validateAllied("", "Y", "Y", false);
			}
		}
	});
	
	$("btnAddCoverage").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("infoDiv")){
			if(parseFloat(unformatCurrencyValue($F("cTsiAmt"))) <= 0 && $F("cRecFlagHid") == "A"){
				showMessageBox("Valid TSI Amt is required.", "E");
				$("cTsiAmt").value = "0.00";
			}else{
				addCoverage();
			}
		}
	});
	
	$("btnDeleteCoverage").observe("click", function(){
		deleteItmPerl();
	});
	
	$("btnCopyBenefits").observe("click", function(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showCopyBenefitsOverlay();	
		}
	});
	
	function populateFieldsOnLoad(){
		$("dspTsiAmt").value = formatCurrency(nvl(covVars.tsiAmt, 0));
		$("dspPremAmt").value = formatCurrency(nvl(covVars.premAmt, 0));
		$("dspAnnTsiAmt").value = formatCurrency(nvl(covVars.annTsiAmt, 0));
		$("dspAnnPremAmt").value = formatCurrency(nvl(covVars.annPremAmt, 0));
		$("cTsiAmtHid").value = formatCurrency(nvl(covVars.tsiAmt, 0));
		$("cPremAmtHid").value = formatCurrency(nvl(covVars.premAmt, 0));
		$("cAnnTsiAmtHid").value = formatCurrency(nvl(covVars.annTsiAmt, 0));
		$("cAnnPremAmtHid").value = formatCurrency(nvl(covVars.annPremAmt, 0));
	}
		
	function populateCoverageFields(populate){
		$("cPerilName").value = populate ? unescapeHTML2(selectedCovRow.perilName) : "";
		$("cTsiAmt").value = populate ? formatCurrency(nvl(selectedCovRow.tsiAmt, 0)) : "";
		$("cAnnTsiAmt").value = populate ? formatCurrency(nvl(selectedCovRow.annTsiAmt, 0)) : "";
		$("cNoOfDays").value = populate ? nvl(selectedCovRow.noOfDays, "") : "";
		$("cPremRt").value = populate ? formatToNineDecimal(nvl(selectedCovRow.premRt, 0)) : "";
		$("cPremAmt").value = populate ? formatCurrency(nvl(selectedCovRow.premAmt, 0)) : "";
		$("cAnnPremAmt").value = populate ? formatCurrency(nvl(selectedCovRow.annPremAmt, 0)) : "";
		$("cBaseAmt").value = populate ? formatCurrency(nvl(selectedCovRow.baseAmt, "")) : "";
		$("cLineCdHid").value = populate ? selectedCovRow.lineCd : "";
		$("cPerilCdHid").value = populate ? selectedCovRow.perilCd : "";
		$("cPerilTypeHid").value = populate ? selectedCovRow.perilType : "";
		$("cRecFlagHid").value = populate ? selectedCovRow.recFlag : "";
		$("cAggregateSwHid").value = populate ? selectedCovRow.aggregateSw : "";
		$("cRiCommRateHid").value = populate ? selectedCovRow.riCommRate : "";
		$("cRiCommAmtHid").value = populate ? selectedCovRow.riCommAmt : "";
		$("cBascPerlCdHid").value = populate ? selectedCovRow.bascPerlCd : "";
		$("btnAddCoverage").value = populate ? "Update" : "Add";
		populate ? enableButton("btnDeleteCoverage") : disableButton("btnDeleteCoverage");
		populate ? disableSearch("searchPeril") : enableSearch("searchPeril");
	}
	
	function checkPeril(){
		if($F("cPerilName") == ""){
			showWaitingMessageBox("Please select peril first.", "I", function(){
				return false;	
			});
		}
		return true;
	}
	
	function computeTsi(isTsi){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=computeTsi",{
			parameters : {
				tsiAmt		   : unformatCurrencyValue($F("cTsiAmt")),
				premRt 		   : $F("cPremRt"),
				annTsiAmt 	   : unformatCurrencyValue($F("cAnnTsiAmt")),
				annPremAmt	   : unformatCurrencyValue($F("cAnnPremAmt")),
				dspTsiAmt	   : unformatCurrencyValue($F("cTsiAmtHid")),
				dspPremAmt     : unformatCurrencyValue($F("cPremAmtHid")),
				dspAnnTsiAmt   : unformatCurrencyValue($F("cAnnTsiAmtHid")),
				dspAnnPremAmt  : unformatCurrencyValue($F("cAnnPremAmtHid")),
				provPremPct    : objGroupedItems.vars.provPremPct,
				provPremTag    : objGroupedItems.vars.provPremTag,
				premAmt		   : unformatCurrencyValue($F("cPremAmt")),
				oldTsiAmt	   : unformatCurrencyValue($("cTsiAmt").getAttribute("oldValue")),
				oldPremAmt	   : unformatCurrencyValue($("cPremAmt").getAttribute("oldValue")),
				oldPremRt      : $("cPremRt").getAttribute("oldValue"),
				changedTag	   : objGroupedItems.vars.changedTag,
				perilType      : $F("cPerilTypeHid"),
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				shortRtPct 	   : objGroupedItems.vars.shortRtPct,
				parId          : objGroupedItems.vars.parId,
				itemNo	       : objGroupedItems.vars.itemNo,
				perilCd        : $F("cPerilCdHid"),
				toDate         : nvl(objGroupedItems.selectedRow.toDate, "") == "" ? null : dateFormat(objGroupedItems.selectedRow.toDate, 'mm-dd-yyyy'),
				fromDate       : nvl(objGroupedItems.selectedRow.fromDate, "") == "" ? null : dateFormat(objGroupedItems.selectedRow.fromDate, 'mm-dd-yyyy'),
				effDate		   : objGroupedItems.vars.effDate,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				inceptDate	   : objGroupedItems.vars.inceptDate,
				expiryDate	   : objGroupedItems.vars.expiryDate,
				lineCd		   : objGroupedItems.vars.lineCd,
				sublineCd	   : objGroupedItems.vars.sublineCd,
				issCd		   : objGroupedItems.vars.issCd,
				issueYy		   : objGroupedItems.vars.issueYy,
				polSeqNo	   : objGroupedItems.vars.polSeqNo,
				renewNo	       : objGroupedItems.vars.renewNo
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						$("cAnnTsiAmt").value = formatCurrency(obj.annTsiAmt);
						$("cAnnPremAmt").value = formatCurrency(obj.annPremAmt);
						$("cPremAmtHid").value = formatCurrency(obj.dspPremAmt);
						$("cAnnPremAmtHid").value = formatCurrency(obj.dspAnnPremAmt);
						$("cTsiAmtHid").value = formatCurrency(obj.dspTsiAmt);
						$("cAnnTsiAmtHid").value = formatCurrency(obj.dspAnnTsiAmt);
						$("cPremAmt").value = formatCurrency(obj.premAmt);
						if(isTsi){
							$("cNoOfDays").value = $F("cNoOfDays") == "0" ? "0" : "";
							$("cBaseAmt").value = parseFloat($F("cBaseAmt")) == 0 ? "0.00" : "";
						}
					}else{
						showMessageBox(obj.message, "I");
					}
				}
			}
		});
	}
	
	function computePremium(){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=computePremium",{
			parameters : {
				premAmt		   : unformatCurrencyValue($F("cPremAmt")),
				tsiAmt 		   : unformatCurrencyValue($F("cTsiAmt")),
				annPremAmt 	   : $("btnAddCoverage").value == "Add" ? $("cAnnPremAmt").readAttribute("endtAnnPremAmt") : selectedCovRow.origAnnPremAmt, //unformatCurrencyValue($F("cAnnPremAmt")),  //benjo 12.16.2015 UCPBGEN-SR-20835
				dspPremAmt 	   : unformatCurrencyValue($F("cPremAmtHid")),
				dspAnnPremAmt  : unformatCurrencyValue($F("cAnnPremAmtHid")),
				provPremPct    : objGroupedItems.vars.provPremPct,
				provPremTag    : objGroupedItems.vars.provPremTag,
				annTsiAmt 	   : unformatCurrencyValue($F("cAnnTsiAmt")),
				oldPremAmt 	   : $("cPremAmt").getAttribute("oldValue"),
				premRt 		   : $F("cPremRt"),
				changedTag	   : objGroupedItems.vars.changedTag,
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				fromDate       : nvl(objGroupedItems.selectedRow.fromDate, "") == "" ? null : dateFormat(objGroupedItems.selectedRow.fromDate, 'mm-dd-yyyy'),
				toDate         : nvl(objGroupedItems.selectedRow.toDate, "") == "" ? null : dateFormat(objGroupedItems.selectedRow.toDate, 'mm-dd-yyyy'),
				effDate		   : objGroupedItems.vars.effDate,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				inceptDate	   : objGroupedItems.vars.inceptDate,
				expiryDate	   : objGroupedItems.vars.expiryDate,
				compSw		   : objGroupedItems.vars.compSw,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				parId          : objGroupedItems.vars.parId,
				itemNo	       : objGroupedItems.vars.itemNo,
				lineCd 	       : objGroupedItems.vars.lineCd,
				sublineCd	   : objGroupedItems.vars.sublineCd,
				issCd	       : objGroupedItems.vars.issCd,
				issueYy	       : objGroupedItems.vars.issueYy,
				polSeqNo       : objGroupedItems.vars.polSeqNo,
				renewNo	       : objGroupedItems.vars.renewNo,
				perilCd 	   : $F("cPerilCdHid")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						if(parseFloat(unformatCurrencyValue($F("cAnnTsiAmt"))) < obj.annPremAmt){ //benjo 12.16.2015 UCPBGEN-SR-2015
							showMessageBox("Annual Premium Amount must not be higher than Annual TSI Amount", "I");
							$("cPremAmt").value = formatCurrency($("cPremAmt").getAttribute("oldValue"));
						}else{
							$("cPremRt").value = formatToNineDecimal($F("cPremRt"));
							$("cAnnPremAmt").value = formatCurrency(obj.annPremAmt);
							$("cPremAmtHid").value = formatCurrency(obj.dspPremAmt);
							$("cAnnPremAmtHid").value = formatCurrency(obj.dspAnnPremAmt);
							autoComputePremRt();
						}
					}else{
						showMessageBox(obj.message, "I");
					}
				}
			}
		});
	}
	
	function autoComputePremRt(){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=autoComputePremRt",{
			parameters : {
				parId		: objGroupedItems.vars.parId,
				premAmt		: unformatCurrencyValue($F("cPremAmt")),
				tsiAmt		: unformatCurrencyValue($F("cTsiAmt")),
				prorateFlag : objGroupedItems.vars.prorateFlag,
				premRt      : $F("cPremRt")  
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("cPremRt").value = formatToNineDecimal(obj.premRt);
				}
			}
		});
	}
	
	function getCoveragePerilLOV(){
		var notIn = createNotInParamCoverage();
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action    : "getCoveragePerilLOV",
								parId     : parId,
								lineCd    : $F("globalLineCd"),
								sublineCd : $F("globalSublineCd"),
								notIn     : notIn,
								perilType : notIn == "" ? "B" : ""
								},
				title: "List of Perils",
				width: 600,
				height: 386,
				columnModel:[
				             	{	id : "perilName",
									title: "Peril Name",
									width: '140px'
								},
								{	id : "perilSname",
									title: "Short Name",
									width: '80px'
								},
								{	id : "perilType",
									title: "Type",
									width: '40px'
								},
								{	id : "basicPerilName",
									title: "Basic Peril Name",
									width: '110px'
								},
								{	id : "prtFlag",
									title: "Print Rate",
									width: '60px'
								},
								{	id : "perilSname",
									title: "Short Name",
									width: '75px'
								},
								{	id : "perilCd",
									title: "Peril Code",
									width: '70px'
								}
							],
				draggable: true,
				onSelect : function(row){
					if(row != undefined) {
						if(nvl(objGroupedItems.vars.polFlagSw, "N") != "Y"){
							validateAllied(row, "N", "N", false);
						}
					}
				}
			});
		}catch(e){
			showErrorMessage("getCoveragePerilLOV",e);
		}
	}
	
	function createNotInParamCoverage(){
		var notIn = "";
		var withPrevious = false;
		for(var i = 0; i < objCoverage.coverage.length; i++){
			if(objCoverage.coverage[i].recordStatus != -1){
				notIn += withPrevious ? "," : "";
				notIn = notIn + objCoverage.coverage[i].perilCd;
				withPrevious = true;
			}
		}
		return notIn;
	}
	
	function preparePerilRecordGroup(){
		perilRG = ",";
		perilRGLength = 0;
		for(var i = 0; i < objCoverage.coverage.length; i++){
			if(objCoverage.coverage[i].recordStatus != -1 && objCoverage.coverage[i].perilCd != nvl($F("cPerilCdHid"), 0)){
				perilRG = perilRG + nvl(objCoverage.coverage[i].perilCd, "0") + ",";
				perilRG = perilRG + unformatCurrencyValue(nvl(objCoverage.coverage[i].annTsiAmt, "0")) + ",";
				perilRG = perilRG + nvl(objCoverage.coverage[i].perilType, "0") + ",";
				perilRG = perilRG + nvl(objCoverage.coverage[i].bascPerlCd, "0") + ",";
				perilRG = perilRG + unformatCurrencyValue(nvl(objCoverage.coverage[i].tsiAmt, "0")) + ",";
				perilRGLength += 5;
			}
		}
	}
	
	function validateAllied(row, postSw, tsiLimitSw, fromTsi){
		preparePerilRecordGroup();
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=validateAllied",{
			parameters : {
				lineCd			: nvl(objGroupedItems.vars.packPolFlag, "N") == "Y" ? objGroupedItems.vars.packLineCd : objGroupedItems.vars.lineCd, 
				perilCd			: nvl(row.perilCd, $F("cPerilCdHid")),
				perilType		: nvl(row.perilType, $F("cPerilTypeHid")),
				bascPerlCd	    : nvl(row.bascPerlCd, $F("cBascPerlCdHid")),
				tsiAmt			: unformatCurrencyValue($F("cTsiAmt")),
				premAmt			: unformatCurrencyValue($F("cPremAmt")),
				parId			: objGroupedItems.vars.parId,
				sublineCd		: objGroupedItems.vars.sublineCd,
				issCd			: objGroupedItems.vars.issCd,
				issueYy			: objGroupedItems.vars.issueYy,
				polSeqNo		: objGroupedItems.vars.polSeqNo,
				renewNo			: objGroupedItems.vars.renewNo,
				postSw			: postSw,
				tsiLimitSw		: tsiLimitSw,
				annTsiAmt		: unformatCurrencyValue($F("cAnnTsiAmt")),
				oldTsiAmt		: unformatCurrencyValue($("cTsiAmt").getAttribute("oldValue")),
				itemNo			: objGroupedItems.vars.itemNo,
				groupedItemNo	: objGroupedItems.selectedRow.groupedItemNo,
				effDate			: objGroupedItems.vars.effDate,
				expiryDate		: objGroupedItems.vars.expiryDate,
				perilList		: perilRG,
				perilCount		: perilRGLength,
				backEndt		: nvl($F("globalBackEndt"), "N")
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						if(postSw == "N"){
							getPerilAmounts(row);
						}else{
							computeTsi(fromTsi);
						}
					}else{
						if(postSw == "Y"){
							$("cTsiAmt").value = formatCurrency($("cTsiAmt").getAttribute("oldValue"));
							if(fromTsi){
								
							}else{
								$("cNoOfDays").value = 	$("cNoOfDays").getAttribute("oldValue");
								$("cBaseAmt").value = 	formatCurrency($("cBaseAmt").getAttribute("oldValue"));
							}
						}
						showMessageBox(obj.message, "E");
						// replaced the showWaitingMessage temporarily due to a bug with the overlay
					}
				}
			}
		});
	}
	
	function getPerilAmounts(row){
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController", { 
			parameters : {
				action 	      : "getEndtCoveragePerilAmounts",
				parId 		  : objGroupedItems.vars.parId,			
				itemNo 		  : objGroupedItems.vars.itemNo,
				groupedItemNo : objGroupedItems.selectedRow.groupedItemNo,
				perilCd       : row.perilCd,
				perilType 	  : row.perilType,
				backEndt 	  : nvl($F("globalBackEndt"), "N")
			},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var result = JSON.parse(response.responseText);
					if(result.messageType == "INFO") {
						$("cTsiAmt").value = formatCurrency(result.tsiAmt);
						$("cPremAmt").value = formatCurrency(result.premAmt);
						$("cAnnTsiAmt").value = formatCurrency(nvl(result.annTsiAmt, "0"));
						$("cAnnPremAmt").value = formatCurrency(nvl(result.annPremAmt, "0"));
						$("cAnnPremAmt").writeAttribute("endtAnnPremAmt", result.annPremAmt); //benjo 12.16.2015 UCPBGEN-SR-20835
						$("cPremRt").value = formatToNineDecimal(result.premRt);
						$("cRecFlagHid").value = nvl(result.recFlag, "A");
						$("cRiCommRateHid").value = formatToNineDecimal(result.riCommRt);
						$("cRiCommAmtHid").value = formatCurrency(result.riCommAmt);
						$("cBaseAmt").value = formatCurrency(result.baseAmt);
						$("cAggregateSwHid").value = result.aggregateSw;
						if(result.message != "SUCCESS"){
							showMessageBox(result.message, imgMessage.INFO);
						}
						setPeril(row);
					} else if(result.messageType = "ERROR"){
						showMessageBox(result.message, imgMessage.ERROR);
					}
				}
			}
		});
	}
	
	function deleteItmPerl(){
		preparePerilRecordGroup();
		new Ajax.Request(contextPath + "/GIPIWItmperlGroupedController?action=deleteItmPerl",{
			parameters : {
				perilCd			: $F("cPerilCdHid"),
				perilType		: $F("cPerilTypeHid"),
				lineCd			: nvl(objGroupedItems.vars.packPolFlag, "N") == "Y" ? objGroupedItems.vars.packLineCd : objGroupedItems.vars.lineCd,
				itemNo			: objGroupedItems.vars.itemNo,
				groupedItemNo	: objGroupedItems.selectedRow.groupedItemNo,
				bascPerlCd	    : $F("cBascPerlCdHid"),
				recFlag 		: $F("cRecFlagHid"),
				sublineCd		: objGroupedItems.vars.sublineCd,
				issCd			: objGroupedItems.vars.issCd,
				issueYy			: objGroupedItems.vars.issueYy,
				polSeqNo		: objGroupedItems.vars.polSeqNo,
				renewNo			: objGroupedItems.vars.renewNo,
				effDate			: objGroupedItems.vars.effDate,
				expiryDate		: objGroupedItems.vars.expiryDate,
				perilList		: perilRG,
				perilCount		: perilRGLength
			},
			asynchronous : false,
			evalScripts : true,
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.message == "SUCCESS"){
						deleteCoverage();
					}else{
						showMessageBox(obj.message, "E");
					}
				}
			}
		});
	}
	
	function setPeril(row){
		if(row.wcSw == "Y"){
			showConfirmBox("Confirmation", "Peril has attached warranties and clauses, " + 
					"would like to use these as your default values on warranties and clauses?", "Yes", "No",
					function(){
						attachDefaultWarranties(row);
					},
					function(){
						populatePeril(row);
					}, "");
		}else{
			populatePeril(row);
		}
	}
	
	function populatePeril(row){
		$("cPerilCdHid").value = row.perilCd;
		$("cPerilTypeHid").value = row.perilType;
		$("cLineCdHid").value = row.lineCd;
		$("cBascPerlCdHid").value = row.bascPerlCd;
		$("cPerilName").value = unescapeHTML2(row.perilName);
	}
	
	function attachDefaultWarranties(row){
		var objWarranty = new Object();
		objWarranty.parId = parId;
		objWarranty.lineCd = row.lineCd;
		objWarranty.perilCd = row.perilCd;
		objCoverage.warranty.push(objWarranty);
		populatePeril(row);
	}
	
	function addCoverage(){
		var rowObj = setCoverage($("btnAddCoverage").value);
		if($("btnAddCoverage").value == "Add"){
			objCoverage.coverage.push(rowObj);
			coverageTableGrid.addBottomRow(rowObj);
		}else{
			objCoverage.coverage.splice(selectedCovIndex, 1, rowObj);
			coverageTableGrid.updateVisibleRowOnly(rowObj, selectedCovIndex);
		}
		changeTag = 1;
		updateAmounts();
		preparePerilRecordGroup();
		coverageTableGrid.onRemoveRowFocus();
	}
	
	function deleteCoverage(){
		recomputeAmounts();
		selectedCovRow.recordStatus = -1;
		objCoverage.coverage.splice(selectedCovIndex, 1, selectedCovRow);
		coverageTableGrid.deleteVisibleRowOnly(selectedCovIndex);
		preparePerilRecordGroup();
		coverageTableGrid.onRemoveRowFocus();
		changeTag = 1;
	}
		
	function setCoverage(func){
		var obj = new Object();
		obj.parId = parId;
		obj.itemNo = itemNo;
		obj.groupedItemNo = groupedItemNo;
		obj.lineCd = $F("cLineCdHid");
		obj.perilCd = $F("cPerilCdHid");
		obj.recFlag = $F("cRecFlagHid");
		obj.noOfDays = $F("cNoOfDays");
		obj.baseAmt = $F("cBaseAmt");
		obj.premRt = $F("cPremRt");
		obj.tsiAmt = $F("cTsiAmt");
		obj.premAmt = $F("cPremAmt");
		obj.annTsiAmt = $F("cAnnTsiAmt");
		obj.annPremAmt = $F("cAnnPremAmt");
		obj.aggregateSw = $F("cAggregateSwHid");
		obj.riCommRate = $F("cRiCommRateHid");
		obj.riCommAmt = $F("cRiCommAmtHid");
		obj.perilName = $F("cPerilName");
		obj.perilType = $F("cPerilTypeHid");
		obj.bascPerlCd = $F("cBascPerlCdHid");
		obj.recordStatus = func == "Add" ? 0 : 1;
		obj.origAnnPremAmt = func == "Add" ? $("cAnnPremAmt").readAttribute("endtAnnPremAmt") : selectedCovRow.origAnnPremAmt; //benjo 12.16.2015 UCPBGEN-SR-20835
		return obj;
	}
	
	function saveCoverage(){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(objCoverage.coverage);
		objParams.delRows = getDeletedJSONObjects(objCoverage.coverage);
		objParams.setWcRows = objCoverage.warranty;
		
		new Ajax.Request(contextPath+"/GIPIWItmperlGroupedController?action=saveCoverage",{
			method: "POST",
			parameters:{
				parameters     : JSON.stringify(objParams),
				parId          : objGroupedItems.vars.parId,
				itemNo 	       : objGroupedItems.vars.itemNo,
				groupedItemNo  : objGroupedItems.selectedRow.groupedItemNo,
				tsiAmt 		   : unformatCurrencyValue($F("dspTsiAmt")),
				premAmt 	   : unformatCurrencyValue($F("dspPremAmt")),
				annTsiAmt 	   : unformatCurrencyValue($F("dspAnnTsiAmt")),
				annPremAmt 	   : unformatCurrencyValue($F("dspAnnPremAmt")),
				lineCd 		   : objGroupedItems.vars.lineCd,
				sublineCd 	   : objGroupedItems.vars.sublineCd,
				issCd 	  	   : objGroupedItems.vars.issCd,
				issueYy    	   : objGroupedItems.vars.issueYy,
				polSeqNo  	   : objGroupedItems.vars.polSeqNo,
				renewNo 	   : objGroupedItems.vars.renewNo,
				effDate 	   : objGroupedItems.vars.effDate,
				itmperilExist  : objGroupedItems.vars.itmperilExist,
				prorateFlag	   : objGroupedItems.vars.prorateFlag,
				compSw		   : objGroupedItems.vars.compSw,
				endtExpiryDate : objGroupedItems.vars.endtExpiryDate,
				shortRtPercent : objGroupedItems.vars.shortRtPct,
				endtTaxSw	   : objGroupedItems.vars.endtTaxSw,
				packLineCd	   : objGroupedItems.vars.packLineCd,
				packSublineCd  : objGroupedItems.vars.packSublineCd,
				parStatus	   : objGroupedItems.vars.parStatus,
				packPolFlag    : objGroupedItems.vars.packPolFlag
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving Enrollee Coverages, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				changeTag = 0;
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
					if (response.responseText == "SUCCESS"){
						showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
							changeTag = 0;
							coverageTableGrid.keys.releaseKeys();
							enrolleeOverlay.close();
							groupedItemsOverlay.close();
							objUW.showEndtAccidentGroupedItemsOverlay();
						});
					}
				}
			}
		});
	}
	
	function recomputeAmounts(){
		var dspTsiAmt = unformatCurrencyValue($F("dspTsiAmt"));
		var dspPremAmt = unformatCurrencyValue($F("dspPremAmt"));
		var dspAnnTsiAmt = unformatCurrencyValue($F("dspAnnTsiAmt"));
		var dspAnnPremAmt = unformatCurrencyValue($F("dspAnnPremAmt"));
		
		if(selectedCovRow.perilType == "B"){
			dspTsiAmt = parseFloat(dspTsiAmt) - parseFloat(unformatCurrencyValue(selectedCovRow.tsiAmt));
			dspAnnTsiAmt = parseFloat(dspAnnTsiAmt) - parseFloat(unformatCurrencyValue(selectedCovRow.tsiAmt));	
		}
		dspPremAmt = parseFloat(dspPremAmt) - parseFloat(unformatCurrencyValue(selectedCovRow.premAmt));
		dspAnnPremAmt = parseFloat(dspAnnPremAmt) - parseFloat(unformatCurrencyValue(selectedCovRow.premAmt));
		
		$("dspTsiAmt").value = formatCurrency(dspTsiAmt);
		$("dspAnnTsiAmt").value = formatCurrency(dspAnnTsiAmt);
		$("dspPremAmt").value = formatCurrency(dspPremAmt);
		$("dspAnnPremAmt").value = formatCurrency(dspAnnPremAmt);
	}
	
	function updateAmounts(){
		$("dspTsiAmt").value = $F("cTsiAmtHid");
		$("dspAnnTsiAmt").value = $F("cAnnTsiAmtHid");
		$("dspPremAmt").value = $F("cPremAmtHid");
		$("dspAnnPremAmt").value = $F("cAnnPremAmtHid");
	}
	
	function showCopyBenefitsOverlay(){
		copyBenefitsOverlay = Overlay.show(contextPath+"/GIPIWGroupedItemsController", {
			urlParameters: {
				action        : "showCopyBenefitsOverlay",
				parId		  : objGroupedItems.vars.parId,
				itemNo		  : objGroupedItems.vars.itemNo,
				groupedItemNo : groupedItemNo,
				packBenCd	  : '${packBenCd}'
			},
			urlContent : true,
			draggable: true,
		    title: "Copy Benefits",
		    height: 310,
		    width: 650
		});
	}
	
	observeSaveForm("btnSaveCoverage", saveCoverage);
	observeCancelForm("btnCancelCoverage", saveCoverage, function(){
		changeTag = 0;
		enrolleeOverlay.close();
	});
</script>