<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="batchCVMainDiv" name="batchCVMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Commission Voucher Batch Printing</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div class="sectionDiv">
		<div id="batchCVHeaderDiv" align="center">
			<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
				<tr>
					<td class="rightAligned" style="" id="">Company</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="fundCd" name="headerField" style="width: 60px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="101" lastValidValue="" ignoreDelKey="true"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundCd" name="searchFundCd" alt="Go" style="float: right;"/>
						</span>
						<input id="fundDesc" name="headerField" type="text" style="width: 450px;" value="" readonly="readonly" tabindex="102"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="batchCVDiv1" class="sectionDiv" style="height: 490px;"> <!-- AFP SR-18481 : shan 05.21.2015 -->
		<div id="batchCVTGDiv" style="padding: 10px 0 0 10px; height: 335px;"></div>
		
		<div style="float: left;">
			<table style="margin-left: 235px;">
				<tr>
					<td class="rightAligned">Tagged Totals</td>
					<td><input id="taggedActualComm" name="cvTotals" type="text" readonly="readonly" style="width: 137px; margin: 0px 3px 0px 3px; text-align: right;" tabindex="103"/></td>
					<td><input id="taggedCommPayable" name="cvTotals" type="text" readonly="readonly" style="width: 133px; margin-right: 3px; text-align: right;" tabindex="104"/></td>
					<td><input id="taggedCommPaid" name="cvTotals" type="text" readonly="readonly" style="width: 128px; margin-right: 3px; text-align: right;" tabindex="105"/></td>
					<td><input id="taggedNetDue" name="cvTotals" type="text" readonly="readonly" style="width: 132px; margin-right: 3px; text-align: right;" tabindex="106"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Grand Totals</td>
					<td><input id="grandActualComm" name="cvTotals" type="text" readonly="readonly" style="width: 137px; margin: 0px 3px 0px 3px; text-align: right;" tabindex="107"/></td>
					<td><input id="grandCommPayable" name="cvTotals" type="text" readonly="readonly" style="width: 133px; margin-right: 3px; text-align: right;" tabindex="108"/></td>
					<td><input id="grandCommPaid" name="cvTotals" type="text" readonly="readonly" style="width: 128px; margin-right: 3px; text-align: right;" tabindex="109"/></td>
					<td><input id="grandNetDue" name="cvTotals" type="text" readonly="readonly" style="width: 132px; margin-right: 3px; text-align: right;" tabindex="110"/></td>
				</tr>
			</table>
		</div>
		
		<div style="float: left;">
			<div style="float: left;">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td>
							<label style="margin: 5px 3px 0px 30px;">Intermediary Name</label>
							<input id="intmName" name="intmName" type="text" style="width: 580px; float: left; margin-left: 3px;" readonly="readonly" tabindex="111">
							<input id="intmNo" name="intmNo" type="hidden">
						</td>
					</tr>
					<tr>
						<td>
							<label style="margin: 5px 3px 0px 26px;">Parent Intermediary</label>
							<input id="parentIntmName" name="parentIntmName" type="text" style="width: 580px; float: left; margin-left: 3px;" readonly="readonly" tabindex="112">
						</td>
					</tr>
				</table>
			</div>
			<input id="btnDetails" name="btnDetails" type="button" class="disabledButton" value="Details" style="width: 120px; margin: 28px 0px 0px 30px; float: left;" tabindex="113">
		</div>
	</div>
	
	<div id="batchCVDiv2" class="sectionDiv" style="height: 490px;"> <!-- start AFP SR-18481 : shan 05.21.2015 -->
		<div id="commDueTGDiv" style="padding: 10px 0 0 10px; margin-left: 120px; height: 335px;"></div>
		
		<div style="float: left;">
			<table style="margin-left: 507px;">
				<tr>
					<td class="rightAligned">Tagged Total</td>
					<td><input id="taggedNetCommDue" type="text" readonly="readonly" style="width: 215px; margin-right: 3px; text-align: right;"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Grand Total</td>
					<td><input id="grandNetCommDue" type="text" readonly="readonly" style="width: 215px; margin-right: 3px; text-align: right;"/></td>
				</tr>
			</table>
		</div>
		
		<div style="float: left;">
			<div style="float: left;">
				<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
					<tr>
						<td>
							<label style="margin: 5px 3px 0px 30px;">Intermediary Name</label>
							<input id="intmNameCommDue" name="intmNameCommDue" type="text" style="width: 580px; float: left; margin-left: 3px;" readonly="readonly" tabindex="111">
							<input id="intmNoCommDue" name="intmNoCommDue" type="hidden">
						</td>
					</tr>
					<tr>
						<td>
							<label style="margin: 5px 3px 0px 26px;">Parent Intermediary</label>
							<input id="parentIntmNameCommDue" name="parentIntmNameCommDue" type="text" style="width: 580px; float: left; margin-left: 3px;" readonly="readonly" tabindex="112">
						</td>
					</tr>
				</table>
			</div>
			<input id="btnDetailsCommDue" name="btnDetailsCommDue" type="button" class="disabledButton" value="Details" style="width: 120px; margin: 28px 0px 0px 30px; float: left;" tabindex="113">
		</div>
	</div> <!-- end AFP SR-18481 : shan 05.21.2015 -->
	
	<div class="sectionDiv" style="padding: 7px 0 12px 0; margin-bottom: 30px;">
		<div id="printerDiv">
			<table style="margin: 10px 30px 0 20px; float: left;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 215px;" disabled="disabled" tabindex="114">
							<option value="screen">Screen</option>
							<option value="printer">Printer</option>
							<option value="local">Local Printer</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer Name</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 215px;" class="" disabled="disabled" tabindex="115">
							<option></option>
							<c:forEach var="p" items="${printers}">
								<option value="${p.name}">${p.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
		
		<table style="float: left;">
			<tr>
				<td style="padding: 1px;">
					<input title="Untag All" type="radio" id="untagAll" name="tagUntagRG" style="margin: 7px 5px 5px 15px; float: left;" checked="checked" disabled="disabled" tabindex="116">
					<label for="untagAll" style="margin-top: 7px;">Untag All</label>
					<input title="Tag All" type="radio" id="tagAll" name="tagUntagRG" style="margin: 7px 5px 5px 20px; float: left;" disabled="disabled" tabindex="117">
					<label for="tagAll" style="margin-top: 7px;">Tag All</label>
				</td>
				<td class="rightAligned" colspan="2">
					Start With
					<input id="cvPref" name="cvPref" type="text" style="width: 100px;" maxlength="10" readonly="readonly" tabindex="118">
					<input id="cvSeqNo" name="cvSeqNo" type="text" style="width: 100px; text-align: right;" maxlength="10" readonly="readonly" tabindex="119">
				</td>
			</tr>
			<tr>
				<td>
					<input id="btnGenerate" name="controlButton" type="button" class="disabledButton" value="Generate CV Number" style="width: 180px; margin-top: 5px;" tabindex="120">
				</td>
				<td>
					<input id="btnPrint" name="controlButton" type="button" class="disabledButton" value="Print CV" style="width: 180px; margin-top: 5px;" tabindex="121">
				</td>
				<td>
					<input id="btnStop" name="controlButton" type="button" class="disabledButton" value="STOP PRINTING" style="width: 180px; margin-top: 5px;" tabindex="122">
				</td>
			</tr>
		</table>
	</div>
	
</div>

<script type="text/javascript">
	var selectedRow = {};
	var selectedIndex = -1;
	var cvOverrideTag = '${cvOverrideTag}';
	var userHasOverride = '${userHasOverride}' == "TRUE" ? true : false;
	
	var selCommDueIndex = -1;		// start AFP SR-18481 : shan 05.21.2015
	var selCommDueRow = {};
	var objBankFileNo = null;
	var objCommDueList = [];
	var taggedCommDueList = [];
	var executedGIACS158 = false;
	var printedCommDue = false;
	var generatedCVNo = false;
	objGIACS251 = new Object();
	
	if (objACGlobal.previousModule == "GIACS158"){
		objBankFileNo = '${bankFileNo}';
		objCommDueList = JSON.parse('${commDueList}');	

		try{
			commDueTGModel = {
				id: 201,
				url: contextPath+"/GIACCommissionVoucherController?action=getCommDueList&refresh=1&bankFileNo="+objBankFileNo,
				options: {
		          	height: '306px',
		          	width: '700px',
		          	hideColumnChildTitle: true,
					validateChangesOnPrePager: false,
		          	onCellFocus: function(element, value, x, y, id){
		          		selCommDueIndex = y;
		          		selCommDueRow = commDueTG.geniisysRows[selCommDueIndex];
		            	populateCommDueFields(selCommDueRow);
		            },
		            onRemoveRowFocus: function(){
		            	selCommDueIndex = -1;
		            	selCommDueRow = null;
		            	commDueTG.keys.releaseKeys();
		            	populateCommDueFields(null);
		            },
		            onSort: function(){
		            	commDueTG.onRemoveRowFocus();
		            	recheckRows();
		            },
		            postPager: function(){
		            	commDueTG.onRemoveRowFocus();
		            	recheckRows();
		            },
		            toolbar: {
		            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
		            	onRefresh: function(){
			            	commDueTG.onRemoveRowFocus();
			            	$("untagAll").checked = true;
			            	fireEvent($("untagAll"), "click");
		            	},
		            	onFilter: function(){
			            	commDueTG.onRemoveRowFocus();
			            	$("untagAll").checked = true;
			            	fireEvent($("untagAll"), "click");
		            	},
		            	onSave: function(){
		            		saveGenerateFlag("N");
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
							{
								id: 'generateFlag',
								title: '&#160;G',
				            	width: '30px',
				            	altTitle: 'Generate',
				            	titleAlign: 'center',
				            	sortable: false,
				            	editable: true,
				            	hideSelectAllBox: true,
				            	editor: new MyTableGrid.CellCheckbox({
						            getValueOf: function(value){
						            	return value ? "Y" : "N";
					            	}
				            	})
							},
							{	id: 'cvPref cvNo',
								title: 'Comm Voucher No',
								width: '170px',
								children: [
									{	id: 'cvPref',
										width: 90
									},
									{	id: 'cvNo',
										width: 170,
										align: 'right',
										renderer : function(value){
											return nvl(value, "") == "" ? "" : lpad(value, 12, "0");
										}
									}
								]
							},
							{	id: 'intmNo',
								title: 'Intm No',
								align: 'right',
								width: '150px',
								filterOption: true,
								filterOptionType: 'integerNoNegative'
							},
							{	id: 'netCommDue',
								title: 'Net Comm Due',
								titleAlign: 'right',
								align: 'right',
								width: '220px',
								geniisysClass: 'money',
								filterOption: true,
								filterOptionType: 'numberNoNegative'
							},
							{	id: 'intmName',
								visible: false,
								width: '0px'
							},
							{	id: 'parentIntmName',
								visible: false,
								width: '0px'
							}
							],
				rows: []
			};
			commDueTG = new MyTableGrid(commDueTGModel);
			commDueTG.pager = {};
			commDueTG.render('commDueTGDiv');
			commDueTG.afterRender = function(){
				commDueTG.onRemoveRowFocus();
				observeGenerateCheckboxCommDue();
				setTotalsCommDue();
				if (!executedGIACS158){
					executedGIACS158 = true;
					getCVSeqNo();
				}
			};
		}catch(e){
			showMessageBox("Error in Batch Commission Due TableGrid: " + e, imgMessage.ERROR);
		}
		
		$("btnDetailsCommDue").observe("click", showCommDueDetailsOverlay);
		//getCVSeqNo();
	}	// end AFP SR-18481 : shan 05.21.2015
	
	try{
		var batchCVTGModel = {
			id: 202,			// AFP SR-18481 : shan 05.21.2015
			url: contextPath+"/GIACCommissionVoucherController?action=getBatchCV&refresh=1",
			options: {
	          	height: '306px',
	          	width: '900px',
	          	hideColumnChildTitle: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedIndex = y;
	          		selectedRow = batchCVTG.geniisysRows[selectedIndex];
	          		$("intmNo").value = selectedRow.intmNo;
	          		$("intmName").value = unescapeHTML2(selectedRow.intmName);
	          		$("parentIntmName").value = unescapeHTML2(selectedRow.parentIntmName);
	          		enableButton("btnDetails");
	          		batchCVTG.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	$("intmNo").value = "";
	            	$("intmName").value = "";
	            	$("parentIntmName").value = "";
	            	disableButton("btnDetails");
	            	batchCVTG.releaseKeys();
	            },
	            onSort: function(){
	            	batchCVTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		batchCVTG.onRemoveRowFocus();
	            		tagAll(false);
	            	},
	            	onFilter: function(){
	            		batchCVTG.onRemoveRowFocus();
	            	},
	            	onSave: function(){
	            		saveGenerateFlag("N");
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
						{
							id: 'generateFlag',
							title: '&#160;G',
			            	width: '23px',
			            	altTitle: 'Generate',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: true,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "Y" : "N";
				            	}
			            	})
						},
						{
							id: 'printTag',
							title: '&#160;P',
			            	width: '23px',
			            	altTitle: 'Print Tag',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: false,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "P" : "N";
				            	}
			            	})
						},
						{	id: 'cvPref cvNo',
							title: 'Comm Voucher No',
							width: '170px',
							children: [
								{	id: 'cvPref',
									width: 65
								},
								{	id: 'cvNo',
									width: 100,
									align: 'right',
									renderer : function(value){
										return nvl(value, "") == "" ? "" : lpad(value, 12, "0");
									}
								}
							]
						},
						{	id: 'intmNo',
							title: 'Intm No',
							align: 'right',
							width: '90px',
							filterOption: true,
							filterOptionType: 'integerNoNegative'
						},
						{	id: 'actualComm',
							title: 'Actual Comm',
							titleAlign: 'right',
							align: 'right',
							width: '145px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'commPayable',
							title: 'Comm Payable',
							titleAlign: 'right',
							align: 'right',
							width: '145px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'commPaid',
							title: 'Comm Paid',
							titleAlign: 'right',
							align: 'right',
							width: '140px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						},
						{	id: 'netDue',
							title: 'Net Due',
							titleAlign: 'right',
							align: 'right',
							width: '144px',
							geniisysClass: 'money',
							filterOption: true,
							filterOptionType: 'numberNoNegative'
						}
						],
			rows: []
		};
		batchCVTG = new MyTableGrid(batchCVTGModel);
		batchCVTG.pager = {};
		batchCVTG.render('batchCVTGDiv');
		batchCVTG.afterRender = function(){
			batchCVTG.onRemoveRowFocus();
			observeGenerateCheckbox();
			setTotals();
		};
	}catch(e){
		showMessageBox("Error in Batch Commission Voucher TableGrid: " + e, imgMessage.ERROR);
	}
	
	function saveGenerateFlag(postFunc){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(batchCVTG.geniisysRows);
		
		if(objParams.setRows.length > 0){
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
				method: "POST",
				parameters: {
					action : "saveGenerateFlag",
					parameters : JSON.stringify(objParams)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						if(postFunc == "Y"){
							generateCVNo();
						}
					}
				}
			});
		}else{
			if(postFunc == "Y"){
				generateCVNo();
			}
		}
	}
	
	function generateCVNo(){
		var action = "generateCVNo";	// start AFP SR-18481 : shan 05.21.2015
		var filter = "";
		var intmList = null;
		var commDueList = [];
		
		if (objACGlobal.previousModule == "GIACS158"){
			action = "generateCVNoCommDue";
			filter = JSON.stringify(commDueTG.objFilter);
			for (var i=0; i<taggedCommDueList.length; i++){
				if (intmList == null){
					intmList = '';
				}
				intmList = intmList + taggedCommDueList[i].intmNo + ',';

				commDueList.push({intmNo: taggedCommDueList[i].intmNo,
								  bankFileNo: objBankFileNo});				
			}
			if (intmList != null){
				intmList = '(' + intmList.substring(0, intmList.length - 1) + ')';
			}
		}	// end AFP SR-18481 : shan 05.21.2015
		
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action: action,			// start AFP SR-18481 : shan 05.21.2015
				commDueList: prepareJsonAsParameter(commDueList),
				cvPref: $F("cvPref"),
				cvNo: $F("cvSeqNo"),
				bankFileNo: objBankFileNo,
				filter: filter,
				intmList: intmList		// end AFP SR-18481 : shan 05.21.2015
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if (objACGlobal.previousModule == "GIACS158"){	// AFP SR-18481 : shan 05.21.2015
						var result = JSON.parse(response.responseText);
						objGIACS251.maxCVNo = parseInt(result.maxCVNo);
						taggedCommDueList = result.list.rows;
						commDueTG.url = commDueTG.url + '&intmList='+intmList;
						commDueTG._refreshList();
						$("mtgRefreshBtn"+commDueTG._mtgId).hide();
						$("mtgFilterBtn"+commDueTG._mtgId).hide();
						$("tagAll").disable();
						$("untagAll").disable();
						disableButton("btnGenerate");
						recheckRows();
						generatedCVNo = true;
					}else{
						batchCVTG.url = contextPath +"/GIACCommissionVoucherController?action=getBatchCV&refresh=1&intmNo=&cvPref=&cvNo=";
						batchCVTG._refreshList();
					}
					enableButton("btnPrint");
				}
			}
		});
	}
	
	function setTotals(){
		if(batchCVTG.geniisysRows.length > 0){
			var row = batchCVTG.geniisysRows[0];
			$("taggedActualComm").value = formatCurrency(nvl(row.taggedActualComm, "0"));
			$("taggedCommPayable").value = formatCurrency(nvl(row.taggedCommPayable, "0"));
			$("taggedCommPaid").value = formatCurrency(nvl(row.taggedCommPaid, "0"));
			$("taggedNetDue").value = formatCurrency(nvl(row.taggedNetDue, "0"));
				
			$("grandActualComm").value = formatCurrency(nvl(row.grandActualComm, "0"));
			$("grandCommPayable").value = formatCurrency(nvl(row.grandCommPayable, "0"));
			$("grandCommPaid").value = formatCurrency(nvl(row.grandCommPaid, "0"));
			$("grandNetDue").value = formatCurrency(nvl(row.grandNetDue, "0"));
		}else{
			$$("input[name='cvTotals']").each(function(i){
				i.value = "0.00";
			});
		}
	}
	
	function observeGenerateCheckbox(){
		var checkboxList = "";
		$$("input[type='checkbox']").each(function(c){
			if(c.id.indexOf("mtgInput"+batchCVTG._mtgId) != -1 &&			// AFP SR-18481 : shan 05.21.2015
				!c.disabled && c.id != "mtgSelectAll"+batchCVTG._mtgId &&			// AFP SR-18481 : shan 05.21.2015
				parseInt((c.id.split(",")[0]).substr(c.id.split(",")[0].length-1)) == 2){
				checkboxList += c.id + " ";
			}
		});
		
		$w(checkboxList).each(function(c){
			$(c).observe("click", function(){
				var index = c.split(",")[1];
				var row = batchCVTG.geniisysRows[index];
				
				if($(c).checked){
					checkPolicyStatus(row.intmNo, row.cvPref, row.cvNo, row, c);
				}else{
					$("taggedActualComm").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedActualComm"))) - parseFloat(nvl(row.actualComm, 0)));
					$("taggedCommPayable").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedCommPayable"))) - parseFloat(nvl(row.commPayable, 0)));
					$("taggedCommPaid").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedCommPaid"))) - parseFloat(nvl(row.commPaid, 0)));
					$("taggedNetDue").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedNetDue"))) - parseFloat(nvl(row.netDue, 0)));
					
					batchCVTG.geniisysRows[index].generateFlag = "N";
					batchCVTG.updateVisibleRowOnly(batchCVTG.geniisysRows[index], index);
				}
			});
		});
	}
	
	function checkPolicyStatus(intmNo, cvPref, cvNo, row, id){
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action : "checkPolicyStatus",
				intmNo: intmNo,
				cvPref: cvPref,
				cvNo: cvNo
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					confirmTagging(trim(response.responseText), row, id);
				}
			}
		});
	}
	
	function confirmTagging(status, row, id){
		var index = id.split(",")[1];
		
		function overrideCV(){
			showGenericOverride("GIACS155", "OV", function(ovr, userId, result){
				if(result == "FALSE"){
					showMessageBox("User " + userId + " is not allowed for override.", imgMessage.ERROR);
					$("txtOverrideUserName").clear();
					$("txtOverridePassword").clear();
					$("txtOverrideUserName").focus();
					return false;
				} else {
					if(result == "TRUE"){
						tag();
						ovr.close();
						delete ovr;
					}
				}
			}, untag);
		}
		
		function checkAmounts(){
			if(cvOverrideTag == "N" && row.actualComm != row.commPayable){
				showWaitingMessageBox("There are partially-paid policies for this intermediary. " + 
					"These will not be included in printing. You can view the status of the records in Details window.", "I", tag);
			}else if(cvOverrideTag == "Y" && userHasOverride && row.actualComm != row.commPayable){
				showWaitingMessageBox("There are partially-paid policies for this intermediary, " + 
					"you can view the status of the records in Details window.", "I", tag);
			}else if(cvOverrideTag == "Y" && !userHasOverride && row.actualComm != row.commPayable){
				showConfirmBox("Confirmation", "There are partially-paid policies for this intermediary, " + 
					"you can view the status of the records in Details window. Would you like to override?", "Yes", "No", overrideCV, untag, "2");
			}else{
				tag();
			}
		}
		
		function tag(){
			$(id).checked = true;
			$("taggedActualComm").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedActualComm"))) + parseFloat(nvl(row.actualComm, 0)));
			$("taggedCommPayable").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedCommPayable"))) + parseFloat(nvl(row.commPayable, 0)));
			$("taggedCommPaid").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedCommPaid"))) + parseFloat(nvl(row.commPaid, 0)));
			$("taggedNetDue").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedNetDue"))) + parseFloat(nvl(row.netDue, 0)));
			
			batchCVTG.geniisysRows[index].generateFlag = "Y";
			batchCVTG.updateVisibleRowOnly(batchCVTG.geniisysRows[index], index);
		}
		
		function untag(){
			$(id).checked = false;
			batchCVTG.geniisysRows[index].generateFlag = "N";
			batchCVTG.updateVisibleRowOnly(batchCVTG.geniisysRows[index], index);
		}
		
		function confirmCancelled(){
			showConfirmBox("Confirmation", "There are cancelled policies for this intermediary. " + 
				"These will not be included in printing. You can view the status of the records in Details window. Do you want to continue?",
				"Yes", "No", checkAmounts, untag, "2");
		}
		
		if(status == "A"){
			showWaitingMessageBox("All policies of selected intm are spoiled/cancelled.", "I", untag);
		}else if(status == "S"){
			showConfirmBox("Confirmation", "There are spoiled policies for this intermediary. " + 
				"These will not be included in printing. You can view the status of the records in Details window. Do you want to continue?",
				"Yes", "No", checkAmounts, untag, "2");
		}else if(status == "C"){
			confirmCancelled();
		}else if(status == "B"){
			showConfirmBox("Confirmation", "There are spoiled policies for this intermediary. " + 
				"These will not be included in printing. You can view the status of the records in Details window. Do you want to continue?",
				"Yes", "No", confirmCancelled, untag, "2");
		}else{
			checkAmounts();
		}
	}
	
	function newFormInstance(){
		resetForm();
		initializeAll();
		makeInputFieldUpperCase();
		setModuleId("GIACS251");
		setDocumentTitle("Commission Voucher Batch Printing");
		hideToolbarButton("btnToolbarPrint");
		
		if (objACGlobal.previousModule == null){	// AFP SR-18481 : shan 05.21.2015
			$("batchCVDiv1").show();
			$("batchCVDiv2").hide();
		}else if (objACGlobal.previousModule == "GIACS158"){
			$("batchCVDiv2").show();
			$("batchCVDiv1").hide();
			$("fundCd").value = unescapeHTML2('${fundCd}');
			$("fundDesc").value = unescapeHTML2('${fundDesc}');
			$("reloadForm").hide();
		}
	}
	
	function resetForm(){
		$("fundCd").focus();
		$("fundCd").value = "";
		$("fundCd").setAttribute("lastValidValue", "");
		$("fundDesc").value = "";
		
		$("cvPref").value = "";
		$("cvSeqNo").value = "";
		
		$("tagAll").disable();
		$("untagAll").disable();
		$("untagAll").checked = true;
		
		$("fundCd").readOnly = false;
		enableSearch("searchFundCd");
		
		disableButton("btnGenerate");
		disableButton("btnPrint");
		disableButton("btnStop");
		disableButton("btnDetails");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		
		toggleControls(false);
	}
	
	function clearTG(){
		batchCVTG.url = contextPath +"/GIACCommissionVoucherController?action=getBatchCV";
		batchCVTG._refreshList();
	}
	
	function getCVSeqNo(){
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action: "getCVSeqNo",
				fundCd: $F("fundCd")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("cvPref").value = nvl(obj.cvPref, "");
					$("cvSeqNo").value = nvl(obj.cvSeqNo, 0);
					executeQuery();
				}
			}
		});
	}
	function executeQuery(){
		if (objACGlobal.previousModule == null){	// start AFP SR-18481 : shan 05.21.2015
			batchCVTG.url = contextPath +"/GIACCommissionVoucherController?action=getBatchCV&intmNo=&cvPref=&cvNo=&refresh=1&popTempTable=Y"+
						"&fundCd="+$F("fundCd");
			batchCVTG._refreshList();
			batchCVTG.url = contextPath +"/GIACCommissionVoucherController?action=getBatchCV&intmNo=&cvPref=&cvNo=&refresh=1&fundCd="+$F("fundCd");
			
			enableButton("btnGenerate");			

			if(batchCVTG.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved.", "I");
			}
			enableToolbarButton("btnToolbarEnterQuery");
			$("tagAll").enable();
			$("untagAll").enable();
			
			toggleControls(true);
		}else if (objACGlobal.previousModule == "GIACS158"){
			taggedCommDueList = [];
			toggleControls(true);
			getNullCommDueCount();
			$("untagAll").checked = true;
			disableButton("btnGenerate");
			disableButton("btnPrint");
			disableButton("btnStop");
			generatedCVNo = false;
			
			$("mtgRefreshBtn"+commDueTG._mtgId).show();
			$("mtgFilterBtn"+commDueTG._mtgId).show();
			commDueTG.url = contextPath+"/GIACCommissionVoucherController?action=getCommDueList&refresh=1&bankFileNo="+objBankFileNo;
			commDueTG._refreshList();
			
			if(commDueTG.geniisysRows.length == 0){
				showMessageBox("Query caused no records to be retrieved.", "I");
			}
		}	// end AFP SR-18481 : shan 05.21.2015		
		
		$("fundCd").readOnly = true;
		disableSearch("searchFundCd");
		$("fundCd").focus();
		
		disableToolbarButton("btnToolbarExecuteQuery");		// AFP SR-18481 : shan 05.21.2015
	}
	
	function showDetailsOverlay(){
		cvDetailsOverlay = Overlay.show(contextPath+"/GIACCommissionVoucherController", {
			urlParameters: {
				action: "showCvDetailsOverlay",
				intmNo: selectedRow.intmNo,
				cvPref: selectedRow.cvPref,
				cvNo: selectedRow.cvNo
			},
			urlContent : true,
			draggable: true,
			showNotice: true,
		    title: "Details",
		    height: 455,
		    width: 875
		});
	}
	
	function showFundLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGiacs251FundLOV",
					filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%"
				},
				title: "Valid values for company",
				width: 365,
				height: 386,
				columnModel:[
								{	id: "fundCd",
									title: "Company",
									width: "100px"
								},
								{	id: "fundDesc",
									title: "Company Description",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("fundCd") != $("fundCd").getAttribute("lastValidValue") ? nvl($F("fundCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("fundCd").value = unescapeHTML2(row.fundCd);
						$("fundDesc").value = unescapeHTML2(row.fundDesc);
						$("fundCd").setAttribute("lastValidValue", unescapeHTML2(row.fundCd));
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function(){
					$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("fundCd").value = $("fundCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showFundLOV", e);
		}
	}
	
	function getBatchCVReports(){
		if(!checkAllRequiredFieldsInDiv("printerDiv")){
			return;
		}
		
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action: "getBatchCVReports"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var rows = JSON.parse(response.responseText);
					if($F("selDestination") == "screen"){
						printBatchToScreen(rows);
					}else if($F("selDestination") == "printer"){
						toggleOnPrint(false);
						printBatchToPrinter(rows, 0);
					}else if($F("selDestination") == "local"){
						toggleOnPrint(false);
						printBatchToLocal(rows);
					}
				}
			}
		});
	}
	
	function printBatchToScreen(rows){
		var reports = [];
		var cvDate = dateFormat(new Date(), 'mm-dd-yyyy');
		for(var i = 0; i < rows.length; i++){
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR251&callingForm=GIACS251"+
							"&intmNo="+rows[i].intmNo+"&cvNo="+rows[i].cvNo+"&cvPref="+rows[i].cvPref+"&cvDate="+cvDate+
							"&branchCd="+rows[i].issCd+"&reportTitle=Commission Voucher&reportId=GIACR251"+
							"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			reports.push({reportUrl : content, reportTitle : "Commission Voucher"});
		}
		showMultiPdfReport(reports);
		
		if (objACGlobal.previousModule == "GIACS158" && generatedCVNo){	// AFP SR-18481 : shan 05.21.2015
			validatePrinting(rows);
		}
	}
	
	function printBatchToPrinter(rows, i){
		var cvDate = dateFormat(new Date(), 'mm-dd-yyyy');
		var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR251&callingForm=GIACS251"+
						"&intmNo="+rows[i].intmNo+"&cvNo="+rows[i].cvNo+"&cvPref="+rows[i].cvPref+"&cvDate="+cvDate+
						"&branchCd="+rows[i].issCd+"&reportTitle=Commission Voucher&reportId=GIACR251"+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		new Ajax.Request(content, {
			asynchronous: false,
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(rows.length != parseInt(i)+1){
						printBatchToPrinter(rows, ++i);
					}else{
						if (objACGlobal.previousModule == "GIACS158" && generatedCVNo){	// AFP SR-18481 : shan 05.21.2015
							validatePrinting(rows);
						}else{
							updateTags(rows);
						}
					}
				}
			}
		});
	}
	
	function printBatchToLocal(rows){
		var printerName = null;
		var cvDate = dateFormat(new Date(), 'mm-dd-yyyy');
		
		if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").selectPrinter, null) == null ||
			nvl($("geniisysAppletUtil").printBatchJRPrintFileToPrinter, null) == null){
			showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
				toggleOnPrint(true);
			});
			return;
		}else{
			printerName = $("geniisysAppletUtil").selectPrinter();
		}
		
		if(printerName == "" || printerName == null){
			showWaitingMessageBox("No printer selected.", "I", function(){
				toggleOnPrint(true);
			});
			return;
		}
		
		for(var i = 0; i < rows.length; i++){
			var content = contextPath+"/GeneralDisbursementPrintController?action=printGIACR251&callingForm=GIACS251"+
							"&intmNo="+rows[i].intmNo+"&cvNo="+rows[i].cvNo+"&cvPref="+rows[i].cvPref+"&cvDate="+cvDate+
							"&branchCd="+rows[i].issCd+"&reportTitle=Commission Voucher&reportId=GIACR251"+
							"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			new Ajax.Request(content, {
				evalScripts: true,
				asynchronous: false,
				parameters: {
					destination: "LOCAL"
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						printBatchToLocalPrinter(response.responseText, printerName);
					}
				}
			});
		}
		if (objACGlobal.previousModule == "GIACS158" && generatedCVNo){	// AFP SR-18481 : shan 05.21.2015
			validatePrinting(rows);
		}else{
			updateTags(rows);
		}
	}
	
	function updateTags(rows){
		var objParams = new Object();
		objParams.setRows = rows;
		
		try{
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
				method: "POST",
				parameters: {
					action: "updateTags",
					fundCd: $F("fundCd"),
					parameters : JSON.stringify(objParams)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						$("cvPref").value = nvl(obj.cvPref, "");
						$("cvSeqNo").value = nvl(obj.cvSeqNo, 0);
						toggleOnPrint(true);
						executeQuery();
					}
				}
			});
		}catch(e){
			showMessageBox(e, imgMessage.ERROR);
		}
	}
	
	function toggleControls(toggle){
		toggle ? $("selDestination").enable() : $("selDestination").disable();
		toggle ? null : $("selPrinter").disable();
		toggle ? $("untagAll").enable() : $("untagAll").disable();
		toggle ? $("tagAll").enable() : $("tagAll").disable();
		
		$("selDestination").value = "screen";
		$("selPrinter").value = "";
		$("selPrinter").removeClassName("required");
	}
	
	function tagAll(tag){
		var action = tag ? "tagAll" : "untagAll";	// start AFP SR-18481 : shan 05.21.2015
		var bankFileNo = null;
		var params = tag ? JSON.stringify(batchCVTG.objFilter) : null;
		
		if (objACGlobal.previousModule == "GIACS158"){
			filter = commDueTG.objFilter;
			action = "getCommDueListByParam";
			bankFileNo = objBankFileNo;
			params =JSON.stringify(commDueTG.objFilter);
			commDueTG.onRemoveRowFocus();
		}	// end AFP SR-18481 : shan 05.21.2015
		
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action: action,	// AFP SR-18481 : shan 05.21.2015
				params: params,	// AFP SR-18481 : shan 05.21.2015
				bankFileNo:	bankFileNo	// AFP SR-18481 : shan 05.21.2015
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if (objACGlobal.previousModule == "GIACS158"){	// AFP SR-18481 : shan 05.21.2015
						taggedCommDueList = tag ? JSON.parse(response.responseText) : [];
						setTotalsCommDue();
						recheckRows();
						tag ? enableButton("btnGenerate") : disableButton("btnGenerate");
						tag ? null : disableButton("btnPrint");
					}else{
						batchCVTG.url = contextPath +"/GIACCommissionVoucherController?action=getBatchCV&refresh=1";
						batchCVTG._refreshList();
						tag ? null : disableButton("btnPrint");
					}
				}
			}
		});
	}
	
	function toggleOnPrint(toggle){
		$w("untagAll tagAll selDestination selPrinter").each(function(i){
			toggle ? $(i).enable() : $(i).disable();
		});
		
		if(toggle && ($F("selDestination") == "local") || $F("selDestination") == "screen"){
			$("selPrinter").disable();
		}
		
		toggle ? enableButton("btnPrint") : disableButton("btnPrint");
		toggle ? disableButton("btnStop") : enableButton("btnStop");
	}
	
	function stopPrinting(){
		if (objACGlobal.previousModule == "GIACS158" && generatedCVNo){	// start AFP SR-18481 : shan 05.21.2015
			showLastCVNoOverlay();
		}else{
			toggleOnPrint(true);
		}
	}
	
	function populateCommDueFields(row){
		$("intmNoCommDue").value = row == null ? "" : row.intmNo;
  		$("intmNameCommDue").value = row == null ? "" : unescapeHTML2(row.intmName);
  		$("parentIntmNameCommDue").value = row == null ? "" : unescapeHTML2(row.parentIntmName);
  		row == null ? disableButton("btnDetailsCommDue") : enableButton("btnDetailsCommDue");
    	commDueTG.keys.removeFocus(commDueTG.keys._nCurrentFocus, true);
  		commDueTG.releaseKeys();	
	}
	
	function setTotalsCommDue(){
		var taggedNetComm = 0;
		for (var i=0; i < taggedCommDueList.length; i++){
			taggedNetComm = parseFloat(taggedNetComm) + parseFloat(taggedCommDueList[i].netCommDue);	
		}
		
		$("taggedNetCommDue").value = formatCurrency(taggedNetComm);
		
		if(commDueTG.geniisysRows.length > 0){
			var row = commDueTG.geniisysRows[0];
			$("grandNetCommDue").value = formatCurrency(nvl(row.sumNetCommDue, "0"));
		}else{
			$("grandNetCommDue").value = formatCurrency("0");
		}
	}
	
	function observeGenerateCheckboxCommDue(){
		var checkboxList = "";
		$$("input[type='checkbox']").each(function(c){
			if(c.id.indexOf("mtgInput"+commDueTG._mtgId) != -1 && 
				!c.disabled && c.id != "mtgSelectAll"+commDueTG._mtgId &&
				parseInt((c.id.split(",")[0]).substr(c.id.split(",")[0].length-1)) == 2){
				checkboxList += c.id + " ";
			}
		});
		
		$w(checkboxList).each(function(c){
			$(c).observe("click", function(){
				var index = c.split(",")[1];
				var row = commDueTG.geniisysRows[index];
				var exists = false;
				
				if($(c).checked){
					var printed = true;
					// validation on tagged records
					if (taggedCommDueList.length > 0){
						for (var i=0; i < taggedCommDueList.length; i++){
							if (nvl(taggedCommDueList[i].cvPref, '*') == '*' && nvl(taggedCommDueList[i].cvNo, '*') == '*'){
								printed = false;
							}	
						}	
	
						if ((nvl(row.cvPref, '*') != '*' && nvl(row.cvNo, '*') != '*' && !printed) ||
								(nvl(row.cvPref, '*') == '*' && nvl(row.cvNo, '*') == '*' && printed)){
							commDueTG.geniisysRows[index].generateFlag = "N";	
							$('mtgInput'+commDueTG._mtgId+'_'+commDueTG.getColumnIndex('generateFlag')+','+index).checked = false;
							showMessageBox("Cannot combine unprinted records with printed records.", "I");
							return false;
						}	
					}
					
					$("taggedNetCommDue").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedNetCommDue"))) + parseFloat(nvl(row.netCommDue, 0)));
					commDueTG.geniisysRows[index].generateFlag = "Y";
					
					for (var i=0; i < taggedCommDueList.length; i++){
						if (taggedCommDueList[i].cvPref == commDueTG.geniisysRows[index].cvPref 
								&& taggedCommDueList[i].cvNo == commDueTG.geniisysRows[index].cvNo
								&& taggedCommDueList[i].intmNo == commDueTG.geniisysRows[index].intmNo){
							exists = true;
							break;
						}
					}
					if (!exists){
						taggedCommDueList.push(commDueTG.geniisysRows[index]);
					}
					
					for (var i=0; i < taggedCommDueList.length; i++){
						if (nvl(taggedCommDueList[i].cvPref, '*') == '*' && nvl(taggedCommDueList[i].cvNo, '*') == '*'){
							printed = false;
						}	
					}
					printed ? disableButton("btnGenerate") : enableButton("btnGenerate");
					printed ? enableButton("btnPrint") : disableButton("btnPrint");
				}else{
					$("taggedNetCommDue").value = formatCurrency(parseFloat(unformatCurrencyValue($F("taggedNetCommDue"))) - parseFloat(nvl(row.netCommDue, 0)));
					commDueTG.geniisysRows[index].generateFlag = "N";
					
					for (var i=0; i < taggedCommDueList.length; i++){
						if (taggedCommDueList[i].cvPref == commDueTG.geniisysRows[index].cvPref 
								&& taggedCommDueList[i].cvNo == commDueTG.geniisysRows[index].cvNo
								&& taggedCommDueList[i].intmNo == commDueTG.geniisysRows[index].intmNo){
							taggedCommDueList.splice(i, 1);
							break;
						}
					}
					
					if (taggedCommDueList.length == 0){
						disableButton("btnGenerate");
						disableButton("btnPrint");
					}
				}
				
				commDueTG.updateVisibleRowOnly(commDueTG.geniisysRows[index], index);
				commDueTG.modifiedRows = [];
			});
		});
	}
	
	function recheckRows(){	// shan 09.26.2014
		var g = commDueTG.getColumnIndex("generateFlag");
		var mtgId = commDueTG._mtgId;
		
		if (commDueTG.url.indexOf('&intmList=') != -1){
			for (var a = 0; a < commDueTG.geniisysRows.length; a++){
				for (var b = 0; b < taggedCommDueList.length; b++){
					if (commDueTG.geniisysRows[a].bankFileNo == taggedCommDueList[b].bankFileNo 
							&& commDueTG.geniisysRows[a].intmNo == taggedCommDueList[b].intmNo){
						$('mtgInput'+mtgId+'_'+g+','+a).checked = true;
						commDueTG.geniisysRows[a].cvPref = taggedCommDueList[b].cvPref;
						commDueTG.geniisysRows[a].cvNo = taggedCommDueList[b].cvNo;
						commDueTG.updateVisibleRowOnly(commDueTG.geniisysRows[a], a);
					}
				}
			}
		}else{
			for (var a = 0; a < commDueTG.geniisysRows.length; a++){
				for (var b = 0; b < taggedCommDueList.length; b++){
					if (commDueTG.geniisysRows[a].bankFileNo == taggedCommDueList[b].bankFileNo 
							&& commDueTG.geniisysRows[a].intmNo == taggedCommDueList[b].intmNo){
						$('mtgInput'+mtgId+'_'+g+','+a).checked = true;
						commDueTG.geniisysRows[a].cvPref = taggedCommDueList[b].cvPref;
						commDueTG.geniisysRows[a].cvNo = taggedCommDueList[b].cvNo;
						commDueTG.updateVisibleRowOnly(commDueTG.geniisysRows[a], a);
					}
				}
				
				if (taggedCommDueList.length == 0){
					$('mtgInput'+mtgId+'_'+g+','+a).checked = false;
				}
			}
		}
		commDueTG.modifiedRows = [];
	}
	
	function printCommDueReports(){
		if(!checkAllRequiredFieldsInDiv("printerDiv")){
			return;
		}

		var rows =  taggedCommDueList;
		updateCommDueTags(rows, false);		
	}
	
	function updateCommDueTags(rows, toRevert){		
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action:		"updateCommDueTags",
				fundCd:		$F("fundCd"),
				toRevert:	toRevert ? "Y" : "N",
				parameters: prepareJsonAsParameter(generatedCVNo ? rows : [])
			},
			asynchronous: false,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					//$("cvPref").value = nvl(obj.cvPref, "");
					//$("cvSeqNo").value = nvl(obj.cvSeqNo, 0);
					
					if (toRevert){
						printedCommDue = false;
						getCVSeqNo();
					}else{
						printedCommDue = true;
						if($F("selDestination") == "screen"){
							printBatchToScreen(rows);
						}else if($F("selDestination") == "printer"){
							toggleOnPrint(false);
							printBatchToPrinter(rows, 0);
						}else if($F("selDestination") == "local"){
							toggleOnPrint(false);
							printBatchToLocal(rows);
						}
					}
				}
			}
		});
	}
	
	objGIACS251.updateCommDueTags = updateCommDueTags;
	
	function showCommDueDetailsOverlay(){
		commDueTG.keys.releaseKeys();
		commDueDetailsOverlay = Overlay.show(contextPath+"/GIACCommissionVoucherController", {
			urlParameters: {
				action: "showCommDueDetailsOverlay",
				intmNo: selCommDueRow.intmNo,
				intmName: selCommDueRow.intmName
			},
			urlContent : true,
			draggable: true,
			showNotice: true,
		    title: "Details",
		    height: 455,
		    width: 875
		});
	}
	
	function updateCommDueCVToNull(func){
		new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
			parameters: {
				action:		"updateCommDueCVToNull",
				bankFileNo:	objBankFileNo,
				commDueList: prepareJsonAsParameter(taggedCommDueList)
			},
			asynchronous: false,
			onCreate: showNotice("Updating Commission Due, please wait..."),
			onComplete: function(response){
				hideNotice();
				if (func != null){
					func();
				}
			}
		});
	}
	
	function validatePrinting(rows){
		showConfirmBox("Validate Printing", "Were all the commission voucher successfully printed?", "Yes", "No",
				function(){
					printedCommDue = false;
					getCVSeqNo();					
				}, showLastCVNoOverlay, "1");
	}
	
	function showLastCVNoOverlay(){
		commDueTG.keys.releaseKeys();
		objGIACS251.taggedCommDueList = taggedCommDueList;
		
		lastCVNoOverlay = Overlay.show(contextPath+"/GIACCommissionVoucherController", {
			urlParameters: {
				action: "showLastCVNoOverlay"
			},
			urlContent : true,
			draggable: true,
		    title: "Unsuccessful Printing",
		    height: 125,
		    width: 300
		});
	}
	
	function goBackToPrevModule(){
		if (objACGlobal.previousModule == "GIACS158"){
			$("GIACS251Div").hide();
			$("GIACS251Div").innerHTML = "";
			$("commissionsDueMainDiv").show();
			objACGlobal.previousModule = null;
			commDueTG.keys.releaseKeys();
			setModuleId("GIACS158");
		}
	}
	
	function getNullCommDueCount(){
		try{
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController", {
				method: "POST",
				parameters: {
					action: "getNullCommDueCount",
					bankFileNo:	objBankFileNo,
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						objGIACS251.nullCount = response.responseText;
						
						(parseInt(objGIACS251.nullCount) > 0) ? $("tagAll").enable() : $("tagAll").disable();
						(parseInt(objGIACS251.nullCount) > 0) ? $("untagAll").enable() : $("untagAll").disable();						
					}
				}
			});
		}catch(e){
			showMessageBox(e, imgMessage.ERROR);
		}
	}	// end AFP SR-18481 : shan 05.21.2015
	
	$("fundCd").observe("change", function(){
		if($F("fundCd") != ""){
			showFundLOV();
		}else{
			$("fundDesc").value = "";
			$("fundCd").setAttribute("lastValidValue", "");
			
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
		}
	});
	
	$("tagAll").observe("click", function(){
		tagAll(true);
	});
	
	$("untagAll").observe("click", function(){
		tagAll(false);
	});
	
	$("selDestination").observe("click", function(){
		$("selPrinter").value = "";
		
		if($F("selDestination") == "printer"){
			$("selPrinter").disabled = false;
			$("selPrinter").addClassName("required");
		}else{
			$("selPrinter").disabled = true;
			$("selPrinter").removeClassName("required");
		}
	});
	
	$("btnGenerate").observe("click", function(){
		saveGenerateFlag("Y");
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetForm();
		clearTG();
	});
	
	$("btnToolbarExit").observe("click", function(){
		if (objACGlobal.previousModule == "GIACS158"){	// AFP SR-18481 : shan 05.21.2015
			if (printedCommDue || !generatedCVNo){
				goBackToPrevModule();
			}else{
				updateCommDueCVToNull(goBackToPrevModule());
			}
		}else{
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	$("reloadForm").observe("click", showGIACS251);
	$("searchFundCd").observe("click", showFundLOV);
	$("btnDetails").observe("click", showDetailsOverlay);
	$("btnPrint").observe("click", function(){	// AFP SR-18481 : shan 05.21.2015
		if (objACGlobal.previousModule == "GIACS158"){
			printCommDueReports();
		}else{
			getBatchCVReports();
		}
	});
	$("btnStop").observe("click", stopPrinting);
	$("btnToolbarExecuteQuery").observe("click", getCVSeqNo);
	
	newFormInstance();
</script>