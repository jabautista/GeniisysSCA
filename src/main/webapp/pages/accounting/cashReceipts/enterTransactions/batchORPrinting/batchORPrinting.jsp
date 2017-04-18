<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="batchORMainDiv" name="batchORMainDiv">
	<div id="batchORPrintingToolBarDiv">  <!-- nieko Accounting Uploading -->
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Official Receipt Batch Printing</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>

	<div class="sectionDiv">
		<div id="batchORHeaderDiv" align="center">
			<table cellspacing="2" border="0" style="margin: 10px auto;">	 			
				<tr>
					<td class="rightAligned" style="" id="">Company</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="fundCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="3" tabindex="101" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFundCd" name="searchFundCd" alt="Go" style="float: right;"/>
						</span>
						<input id="fundDesc" name="headerField" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="102"/>
					</td>
					<td class="rightAligned" style="width: 65px;" id="">Branch</td>
					<td class="leftAligned" colspan="3">
						<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px;">
							<input class="required upper" type="text" id="branchCd" name="headerField" style="width: 40px; float: left; border: none; height: 13px; margin: 0;" maxlength="2" tabindex="103" lastValidValue=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchCd" name="searchBranchCd" alt="Go" style="float: right;"/>
						</span>
						<input id="branchName" name="headerField" type="text" style="width: 280px;" value="" readonly="readonly" tabindex="104"/>
					</td>
				</tr>
			</table>			
		</div>
	</div>
	
	<div id="batchORDetailsDiv" class="sectionDiv" style="height: 385px;">
		<div id="batchORTGDiv" style="padding: 5px 0 0 5px; height: 340px;"></div>
		
		<div style="float: left;">
			<label style="margin: 3px 3px 0 15px;">Particulars</label>
			<div id="particularsDiv" style="border: 1px solid gray; height: 20px; width: 690px; float: left;">
				<textarea id="particulars" name="particulars" style="width: 660px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="500" readonly="readonly" tabindex="105"/></textarea>
				<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
			</div>
			<input id="btnPrintCommSlip" name="controlButton" type="button" class="button" value="Print Comm Slip" style="width: 125px; margin-left: 10px;
			<c:if test="${'Y' ne ora2010Sw}">
				display: none;
			</c:if>" tabindex="106">
		</div>
	</div>
	
	<div id="batchORControlDiv" class="sectionDiv" style="padding: 7px 0 12px 0; margin-bottom: 30px;">
		<div id="printerDiv">
			<table style="margin: 24px 30px 0 20px; float: left;">
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 215px;" tabindex="107">
							<option value="printer">Printer</option>
							<option value="local">Local Printer</option>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer Name</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 215px;" class="required" tabindex="108">
							<option></option>
							<c:forEach var="p" items="${printers}">
								<option value="${p.name}">${p.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="orSeqNoDiv" align="right" style="width: 60%; float: left;">
			<table>
				<tr>
					<td class="rightAligned" style="padding-bottom: 2px;">Start With:</td>
					<td id="vatORButton">
						<input title="VAT OR" type="radio" id="vatOr" name="orType" value="V" style="margin: 9px 5px 10px 5px; float: left;" tabindex="109">
						<label for="vatOr" style="margin-top: 9px;">VAT OR</label>
					</td>
					<td id="vatORField">
						<input id="vatOrPref" name="vatOrPref" type="hidden">
						<input id="vatSeq" name="vatSeq" type="text" class="required integerNoNegativeUnformatted" style="width: 60px; text-align: right;" maxlength="10" tabindex="110">
					</td>
					<td id="nonVatORButton">
						<input title="Non VAT OR" type="radio" id="nonVatOr" name="orType" value="N" style="margin: 9px 5px 10px 5px; float: left;" tabindex="111">
						<label for="nonVatOr" style="margin-top: 9px;">Non VAT OR</label>
					</td>
					<td id="nonVatORField">
						<input id="nonVatOrPref" name="vatOrPref" type="hidden">
						<input id="nonVatSeq" name="nonVatSeq" type="text" class="required integerNoNegativeUnformatted" style="width: 60px; text-align: right;" maxlength="10" tabindex="112">
					</td>
					<td id="otherORButton" style="display: none;">
						<input title="Other" type="radio" id="otherOr" name="orType" value="M" style="margin: 9px 5px 10px 5px; float: left;" tabindex="113">
						<label for="otherOr" style="margin-top: 9px;">Other</label>
					</td>
					<td id="otherORField" style="display: none;">
						<input id="otherOrPref" name="vatOrPref" type="hidden">
						<input id="otherSeq" name="otherSeq" type="text" class="required integerNoNegativeUnformatted" style="width: 60px; text-align: right;" maxlength="10" tabindex="114">
					</td>
				</tr>
			</table>
		</div>
		
		<table style="float: left;">
			<tr>
				<td style="padding: 1px;">
					<input title="Untag All" type="radio" id="untagAll" name="tagUntagRG" style="margin: 7px 5px 10px 15px; float: left;" checked="checked" tabindex="115">
					<label for="untagAll" style="margin-top: 7px;">Untag All</label>
					<input title="Tag All" type="radio" id="tagAll" name="tagUntagRG" style="margin: 7px 5px 10px 20px; float: left;" tabindex="116">
					<label for="tagAll" style="margin-top: 7px;">Tag All</label>
				</td>
				<td>
					<input id="btnView" name="controlButton" type="button" class="button" value="View OR Details" style="width: 180px;" tabindex="117">
				</td>
				<td>
					<input id="btnPrint" name="controlButton" type="button" class="button" value="Print OR" style="width: 180px;" tabindex="118">
				</td>
			</tr>
			<tr>
				<td>
					<input id="btnStop" name="controlButton" type="button" class="button" value="STOP PRINTING" style="width: 180px;" tabindex="119">
				</td>
				<td>
					<input id="btnGenerate" name="controlButton" type="button" class="button" value="Generate OR Number" style="width: 180px;" tabindex="120">
				</td>
				<td>
					<input id="btnSpoil" name="controlButton" type="button" class="button" value="Spoil OR" style="width: 180px;" tabindex="121">
				</td>
			</tr>
		</table>
	</div>
	
	<div style="display: none;">
		<input id="lastPrintedOR" name="lastPrintedOR" type="hidden" value="">
	</div>
</div>

<script type="text/javascript">
	objBatchOR = new Object();
	var selectedRow = null;
	var selectedIndex = -1;
	var ora2010Sw = nvl('${ora2010Sw}', "N");
	var editORNo = nvl('${editORNo}', "N");
	var oneORSequence = nvl('${oneORSequence}', "N");
	var vatNonVatSeries = nvl('${vatNonVatSeries}', "V");
	var onLoadSw = true;
	var executeInitModule = false;
	
	try{
		batchORTGModel = {
			url: contextPath+"/GIACOrderOfPaymentController?action=getBatchORList&refresh=1",
			options: {
	          	height: '306px',
	          	width: '900px',
	          	hideColumnChildTitle: true,
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedIndex = y;
	          		selectedRow = batchORTG.geniisysRows[selectedIndex];
	          		$("particulars").value = unescapeHTML2(selectedRow.particulars);
	          		batchORTG.keys.removeFocus(batchORTG.keys._nCurrentFocus, true);
	          		batchORTG.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	selectedRow = null;
	            	$("particulars").value = "";
	          		batchORTG.keys.removeFocus(batchORTG.keys._nCurrentFocus, true);
	            	batchORTG.keys.releaseKeys();
	            },
	            onSort: function(){
	            	batchORTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		batchORTG.onRemoveRowFocus();
	            		uncheckAllORs();
	            	},
	            	onFilter: function(){
	            		batchORTG.onRemoveRowFocus();
	            	},
	            	onSave: function(){
	            		saveGenerateTag(null);
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
							id: 'printedFlag',
							title: '&#160;P',
			            	width: '23px',
			            	altTitle: 'Printed',
			            	titleAlign: 'center',
			            	sortable: false,
			            	editable: false,
			            	hideSelectAllBox: true,
			            	editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
					            	return value ? "Y" : "N";
				            	}
			            	})
						},
						{	id: 'dspOrDate',
							title: 'OR Date',
							width: '100px',
							align: 'center',
							filterOption: true,
							filterOptionType: 'formattedDate'
						},
						{	id: 'dspOrPref dspOrNo',
							title: 'OR Number',
							width: '135px',
							sortable: false,					
							children: [
								{	id: 'dspOrPref',							
									width: 60,							
									sortable: false
								},
								{	id: 'dspOrNo',							
									width: 75,
									sortable: false,
									editable: false
								}
							]
						},
						{	id: 'payor',
							title: 'Payor',
							width: '600px',
							filterOption: true
						}
						],
			rows: []
		};
		batchORTG = new MyTableGrid(batchORTGModel);
		batchORTG.pager = {};
		batchORTG.render('batchORTGDiv');
		
		batchORTG.afterRender = function(){
			batchORTG.onRemoveRowFocus();
			observeGenerateCheckbox();
			toggleGenerate();
			if(onLoadSw){
				onLoadSw = false;
				clearTG();
			}
			if (executeInitModule){
				executeInitModule = false;
				initModule();
			}
		};
	}catch(e){
		showMessageBox("Error in Batch OR Printing TableGrid: " + e, imgMessage.ERROR);
	}
	
	function showFundLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getCompany2LOV",
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
						$("fundCd").value = row.fundCd;
						$("fundDesc").value = unescapeHTML2(row.fundDesc);
						$("fundCd").setAttribute("lastValidValue", row.fundCd);
						$("branchCd").focus();
						enableInputField("branchCd");
						enableSearch("searchBranchCd");
						toggleToolbars();
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
	
	function showBranchLOV(){
		try{
			LOV.show({
				controller: "AccountingLOVController",
				urlParameters: {
					action: "getGIACS053BranchLOV",
					fundCd: $F("fundCd"),
					moduleId: "GIACS053",
					filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%"
				},
				title: "Valid values for branch",
				width: 382,
				height: 386,
				columnModel:[
								{	id: "branchCd",
									title: "Branch",
									width: "100px"
								},
								{	id: "branchName",
									title: "Branch Name",
									width: "250px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("branchCd") != $("branchCd").getAttribute("lastValidValue") ? nvl($F("branchCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						$("branchCd").value = row.branchCd;
						$("branchName").value = unescapeHTML2(row.branchName);
						$("branchCd").setAttribute("lastValidValue", row.branchCd);
						toggleToolbars();
					}
				},
				onCancel: function(){
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("branchCd").value = $("branchCd").getAttribute("lastValidValue");
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showBranchLOV", e);
		}
	}
	
	function newFormInstance(){
		objBatchOR.calledByUpload = "N";
		objBatchOR.uploadQuery = "";
		objBatchOR.tranIdGroup = "";

		resetForm();
		toggleFields();
		initializeAll();
		initializeParameters();
		makeInputFieldUpperCase();
		setModuleId("GIACS053");
		setDocumentTitle("Official Receipt Batch Printing");
		hideToolbarButton("btnToolbarPrint");
		
		if(objACGlobal.callingForm2 == "GIACS607" || objACGlobal.callingForm2 == "GIACS603" || objACGlobal.callingForm2 == "GIACS604"  
			|| objACGlobal.callingForm2 == "GIACS608" || objACGlobal.callingForm2 == "GIACS610" || objACGlobal.callingForm2 == "GIACS609"){
			executeInitModule = true;
		}
	}
	
	function initModule(){	//used when module is called by another module	
		if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
			$("mainNav").hide();
		
			$("fundCd").value = unescapeHTML2(objGIACS607.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS607.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS607.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS607.branchName);			

			//nieko Accounting Uploading GIACS608
			objBatchOR.uploadQuery = unescapeHTML2(objGIACS607.uploadQuery);
			//objBatchOR.uploadQuery = objGIACS607.gaccTranId;
			
			objBatchOR.calledByUpload = "Y";
			
			executeQuery();
		} else if(objACGlobal.callingForm2 == "GIACS603"){ //john; 8.5.2015; conversion of GIACS603
			$("mainNav").hide();
			
			$("fundCd").value = unescapeHTML2(objGIACS603.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS603.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS603.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS603.branchName);
			
			//nieko Accounting Uploading GIACS603
			objBatchOR.uploadQuery = unescapeHTML2(objGIACS603.uploadQuery);
			//objBatchOR.uploadQuery = objGIACS603.gaccTranId; //nieko
			
			objBatchOR.calledByUpload = "Y";
			
			executeQuery();
		} else if(objACGlobal.callingForm2 == "GIACS604"){ //john; conversion of GIACS604
			$("mainNav").hide();
			
			$("fundCd").value = unescapeHTML2(objGIACS604.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS604.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS604.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS604.branchName);			
			
			//nieko Accounting Uploading GIACS604
			objBatchOR.uploadQuery = unescapeHTML2(objGIACS604.uploadQuery);
			//objBatchOR.uploadQuery = objGIACS604.gaccTranId;
			
			objBatchOR.calledByUpload = "Y";
			
			executeQuery();
		} else if(objACGlobal.callingForm2 == "GIACS608"){
			$("mainNav").hide();
			
			$("fundCd").value = unescapeHTML2(objGIACS608.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS608.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS608.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS608.branchName);			
			
			//nieko Accounting Uploading GIACS608
			objBatchOR.uploadQuery = unescapeHTML2(objGIACS608.uploadQuery);
			//objBatchOR.uploadQuery = objGIACS608.gaccTranId;
			
			objBatchOR.calledByUpload = "Y";
			
			executeQuery();
		} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
			$("mainNav").hide();
			$("fundCd").value = unescapeHTML2(objGIACS609.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS609.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS609.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS609.branchName);			
			objBatchOR.uploadQuery = objGIACS609.tranId;
			objBatchOR.calledByUpload = "Y";
			executeQuery();
		} else if(objACGlobal.callingForm2 == "GIACS610"){
			$("mainNav").hide();
			
			$("fundCd").value = unescapeHTML2(objGIACS610.fundCd);
			$("fundDesc").value = unescapeHTML2(objGIACS610.fundDesc);
			$("branchCd").value = unescapeHTML2(objGIACS610.branchCd);
			$("branchName").value = unescapeHTML2(objGIACS610.branchName);			
			objBatchOR.uploadQuery = objGIACS610.gaccTranId;
			objBatchOR.calledByUpload = "Y";
			
			executeQuery();
		}
	}
	
	function resetForm(){
		$("fundCd").focus();
		$$("input[name='headerField']").each(function(i){
			i.value = "";
			i.setAttribute("lastValidValue", "");
		});
		
		$$("input[name='orType']").each(function(i){
			i.checked = false;
			i.disable();
		});
		
		$("vatSeq").value = "";
		$("nonVatSeq").value = "";
		$("otherSeq").value = "";
		
		$("fundCd").readOnly = false;
		$("branchCd").readOnly = true;
		enableSearch("searchFundCd");
		disableSearch("searchBranchCd");
		
		toggleToolbars();
		toggleControls(false);
	}
	
	function toggleFields(){
		if(ora2010Sw == "N"){
			$("particularsDiv").setStyle("width: 825px;");
			$("particulars").setStyle("width: 795px;");
		}
		
		if(oneORSequence == "Y"){
			if(editORNo == "Y"){
				if(vatNonVatSeries == "V"){
					enableInputField("vatSeq");
				}else if(vatNonVatSeries == "N"){
					enableInputField("nonVatSeq");
				}else if(vatNonVatSeries == "M"){
					enableInputField("otherSeq");
				}
			}else{
				if(vatNonVatSeries == "V"){
					disableInputField("vatSeq");
				}else if(vatNonVatSeries == "N"){
					disableInputField("nonVatSeq");
				}else if(vatNonVatSeries == "M"){
					disableInputField("otherSeq");
				}
			}
			
			if(vatNonVatSeries == "V"){
				$("nonVatORButton").hide();
				$("nonVatORField").hide();
				$("vatOr").checked = true;
			}else if(vatNonVatSeries == "N"){
				$("vatORButton").hide();
				$("vatORField").hide();
				$("nonVatOr").checked = true;
			}else if(vatNonVatSeries == "M"){
				$("vatORButton").hide();
				$("vatORField").hide();
				$("nonVatORButton").hide();
				$("nonVatORField").hide();
				$("otherORButton").show();
				$("otherORField").show();
				$("otherOr").checked = true;
			}
		}else{
			if(editORNo == "Y"){
				enableInputField("vatSeq");
				enableInputField("nonVatSeq");
			}else{
				disableInputField("vatSeq");
				disableInputField("nonVatSeq");
			}
		}
	}
	
	function toggleControls(toggle){
		toggle ? $("selDestination").enable() : $("selDestination").disable();
		toggle ? $("selPrinter").enable() : $("selPrinter").disable();
		toggle ? $("untagAll").enable() : $("untagAll").disable();
		toggle ? $("tagAll").enable() : $("tagAll").disable();
		
		$("selDestination").value = "printer";
		$("selPrinter").value = "";
		$("selPrinter").addClassName("required");
		
		$$("input[name='controlButton']").each(function(b){
			toggle ? enableButton(b.id) : disableButton(b.id);
		});
		
		toggleFields();
		disableButton("btnStop");
		disableButton("btnGenerate");
	}
	
	function toggleToolbars(){
		if($F("fundCd") == "" && $F("branchCd") == ""){
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("fundCd") == "" || $F("branchCd") == ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("fundCd") != "" && $F("branchCd") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function toggleGenerate(){
		for(var i = 0; i < batchORTG.geniisysRows.length; i++){
			if($("mtgInput"+batchORTG._mtgId+"_2," + i).checked && nvl(batchORTG.geniisysRows[i].dspOrNo, "") == ""){
				enableButton("btnGenerate");
				return;
			}
		}
		disableButton("btnGenerate");
	}
	
	function toggleOnPrint(toggle){
		$w("btnView btnPrint btnSpoil btnPrintCommSlip").each(function(i){
			toggle ? enableButton(i) : disableButton(i);
		});
		
		$w("vatOr nonVatOr otherOr untagAll tagAll selDestination selPrinter").each(function(i){
			toggle ? $(i).enable() : $(i).disable();
		});
		
		if(toggle && $F("selDestination") == "local"){
			$("selPrinter").disable();
		}
		
		toggleFields();
		toggle ? disableButton("btnStop") : enableButton("btnStop");
	}
	
	function initializeParameters(){
		$w("GIACS603 GIACS604 GIACS607 GIACS608 GIACS609 GIACS610 GIACS611").each(function(module){
			if(objACGlobal.callingForm == module || objACGlobal.callingForm2 == module){
				objBatchOR.calledByUpload = "Y";
			}
		});
	}
	
	function clearTG(){
		objBatchOR.generatedOR = false;
		batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList";
		batchORTG._refreshList();
	}
	
	function executeQuery(){
		batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList"+
									"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd")+
									"&calledByUpload="+objBatchOR.calledByUpload+"&uploadQuery="+objBatchOR.uploadQuery;
		batchORTG.refresh();
		batchORTG.url = batchORTG.url + "&refresh=1";
		getDefaultOrValues();
		
		enableButton("btnPrintCommSlip");
		enableButton("btnView");
		enableButton("btnPrint");
		enableButton("btnSpoil");
		
		$("fundCd").readOnly = true;
		$("branchCd").readOnly = true;
		disableSearch("searchFundCd");
		disableSearch("searchBranchCd");
		$("fundCd").focus();
		
		$("tagAll").enable();
		$("untagAll").enable();
		
		toggleControls(true);
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function getDefaultOrValues(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "getDefaultOrValues",
				oneORSequence: objBatchOR.oneORSequence,
				vatNonVatSeries: objBatchOR.vatNonVatSeries,
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Loading, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					$("vatOrPref").value = nvl(obj.vatOrPref, "");
					$("vatSeq").value = nvl(obj.vatSeq, 0);
					$("nonVatOrPref").value = nvl(obj.nonVatOrPref, "");
					$("nonVatSeq").value = nvl(obj.nonVatSeq, 0);
					$("otherOrPref").value = nvl(obj.otherOrPref, "");
					$("otherSeq").value = nvl(obj.otherSeq, 0);
				}
			}
		});
	}
	objBatchOR.oneORSequence = oneORSequence;
	objBatchOR.vatNonVatSeries = vatNonVatSeries;
	objBatchOR.getDefaultOrValues = getDefaultOrValues;
	
	function checkOR(gaccTranId, index){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "checkOR",
				gaccTranId: gaccTranId
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Validating, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText != "Y"){
						showWaitingMessageBox(response.responseText, "E", function(){
							$("mtgInput"+batchORTG._mtgId+"_2," + index).checked = false;
							toggleGenerate();
							batchORTG.geniisysRows[index].generateFlag = $("mtgInput"+batchORTG._mtgId+"_2," + index).checked ? "Y" : "N";
							batchORTG.updateVisibleRowOnly(batchORTG.geniisysRows[index], index);
						});
					}else{
						toggleGenerate();
						batchORTG.geniisysRows[index].generateFlag = $("mtgInput"+batchORTG._mtgId+"_2," + index).checked ? "Y" : "N";
						batchORTG.updateVisibleRowOnly(batchORTG.geniisysRows[index], index);
					}
				}else{
					$("mtgInput"+batchORTG._mtgId+"_2," + index).checked = false;
					toggleGenerate();
					batchORTG.geniisysRows[index].generateFlag = $("mtgInput"+batchORTG._mtgId+"_2," + index).checked ? "Y" : "N";
					batchORTG.updateVisibleRowOnly(batchORTG.geniisysRows[index], index);
				}
			}
		});
	}
	
	function checkAllORs(){
		var dspOrDate = nvl(batchORTG.objFilter.dspOrDate, "");
		var payor = nvl(batchORTG.objFilter.payor, "");
		
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "checkAllORs",
				dspOrDate: dspOrDate,
				payor: payor
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList&refresh=1"+
												"&dspOrDate="+dspOrDate+"&payor="+encodeURIComponent(payor);
					batchORTG._refreshList();
					var obj = JSON.parse(response.responseText);
					var messageList = [];
					if(nvl(obj.message1, "") != ""){
						messageList.push(obj.message1);
					}
					if(nvl(obj.message2, "") != ""){
						messageList.push(obj.message2);
					}
					if(nvl(obj.message3, "") != ""){
						messageList.push(obj.message3);
					}
					showORMessage(messageList, 0);
				}
			}
		});
	}
	
	function uncheckAllORs(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "uncheckAllORs"
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					objBatchOR.generatedOR = false;
					batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList"+
										"&fundCd="+$F("fundCd")+"&branchCd="+$F("branchCd")+
										"&calledByUpload="+objBatchOR.calledByUpload+"&uploadQuery="+objBatchOR.uploadQuery;
					batchORTG._refreshList();
					$$("input[name='orType']").each(function(i){
						i.checked = false;
						i.disable();
					});
				}
			}
		});
	}
	
	function showORMessage(messageList, index){
		if(index < messageList.length){
			showWaitingMessageBox(messageList[index], "I", function(){
				showORMessage(messageList, index+1);
			});
		}
	}
	
	function observeGenerateCheckbox(){
		var checkboxList = "";
		
		$$("input[type='checkbox']").each(function(c){
			if(!c.disabled && c.id != "mtgSelectAll"+batchORTG._mtgId &&
				parseInt((c.id.split(",")[0]).substr(c.id.split(",")[0].length-1)) == 2){
				checkboxList += c.id + " ";
			}
		});
		
		$w(checkboxList).each(function(c){
			$(c).observe("click", function(){
				var index = c.split(",")[1];
				if(!nvl(objBatchOR.generatedOR, false)){
					if($(c).checked){
						checkOR(batchORTG.geniisysRows[index].gaccTranId, index);
					}else{
						toggleGenerate();
						batchORTG.geniisysRows[index].generateFlag = $("mtgInput"+batchORTG._mtgId+"_2," + index).checked ? "Y" : "N";
						batchORTG.updateVisibleRowOnly(batchORTG.geniisysRows[index], index);
					}
				}else{
					showWaitingMessageBox("OR numbers were already generated. Update not allowed.", "E", function(){
						$(c).checked = !$(c).checked;
						batchORTG.geniisysRows[index].generateFlag = $("mtgInput"+batchORTG._mtgId+"_2," + index).checked ? "Y" : "N";
						batchORTG.updateVisibleRowOnly(batchORTG.geniisysRows[index], index);
					});
				}
			});
		});
	}
	
	function setORParamsGIACS053(gaccTranId) {
		try {
			new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
				method: "GET",
				parameters: {
					action: "retrieveORParams",
					gaccTranId: gaccTranId
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response) {
					if(checkErrorOnResponse(response)) {
						var res = JSON.parse(response.responseText);
						objACGlobal.orFlag = res.orFlag;
						objACGlobal.opTag = res.opTag;
						objACGlobal.tranFlagState = res.tranFlag;					
						objACGlobal.orTag = res.orTag;
						objAC.tranFlagState = res.tranFlag;
						viewORDetails();
					}
				}
			});
		} catch(e) {
			showErrorMessage("setORParamsGIACS053", e);
		}
	}
	
	function viewORDetails(){
		objACGlobal.gaccTranId = selectedRow.gaccTranId;
		objACGlobal.fundCd = $F("fundCd");
		objACGlobal.branchCd = $F("branchCd");
		objACGlobal.queryOnly = "Y";
		objACGlobal.previousModule = "GIACS053";
		objAC.butLabel = "Spoil OR";
		$("acExit").show();
		$("mainNav").show();
		editORInformation();
	}
	
	function tagGenerate(tag){
		$$("input[type='checkbox']").each(function(c){
			if(!(nvl(objBatchOR.generatedOR, false))){
				if(tag){
					checkAllORs();
					throw $break;
				}else{
					uncheckAllORs();
					throw $break;
				}
			}else{
				showWaitingMessageBox("OR numbers were already generated. Update not allowed.", "E", function(){
					$(c).checked = !$(c).checked;
				});
			}
		});
	}
	
	function saveGenerateTag(postFunction){
		var objParams = new Object();
		objParams.setRows = getAddedAndModifiedJSONObjects(batchORTG.geniisysRows);
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			method: "POST",
			parameters: {
				action : "saveGenerateTag",
				parameters : JSON.stringify(objParams)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					if(postFunction == "generate"){
						generateOrNumbers();
					}else if(postFunction == "batchCommSlip"){
						getBatchCommSlipParams();
					}
				}
			}
		});
	}
	
	function generateOrNumbers(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "generateOrNumbers",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				oneORSequence: oneORSequence,
				vatNonVatSeries: vatNonVatSeries,
				vatPref: $F("vatOrPref"),
				vatSeq: $F("vatSeq"),
				nonVatPref: $F("nonVatOrPref"),
				nonVatSeq: $F("nonVatSeq"),
				otherPref: $F("otherOrPref"),
				otherSeq: $F("otherSeq")
			},
			asynchronous : false,
			evalScripts : true,
			onCreate: showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var dspOrDate = nvl(batchORTG.objFilter.dspOrDate, "");
					var payor = nvl(batchORTG.objFilter.payor, "");
					objBatchOR.generatedOR = true;
					
					batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList&refresh=1"+
												"&dspOrDate="+dspOrDate+"&payor="+encodeURIComponent(payor);
					batchORTG._refreshList();
					
					$("vatOr").enable();
					$("nonVatOr").enable();
					$("otherOr").enable();
					disableButton("btnGenerate");
				}
			}
		});
	}
	
	function printGeneratedOrs(){
		if(!(nvl(objBatchOR.generatedOR, false))){
			showMessageBox("Please generate O.R. numbers first.", "I");
		}else{
			if(oneORSequence == "N" && (!$("vatOr").checked && !$("nonVatOr").checked)){
				showMessageBox("Please select O.R. type to be printed (VAT or Non VAT).", "I");
			}else{
				if(checkAllRequiredFieldsInDiv("printerDiv")){
					showWaitingMessageBox("Accounting entries of successfully printed ORs will be automatically closed.", "I", function(){
						hideNotice();
						toggleOnPrint(false);
						getBatchORReportParams();
					});
				}
			}
		}
	}
	
	function getBatchORReportParams(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "getBatchORReportParams",
				orType: $("vatOr").checked ? "V" : $("nonVatOr").checked ? "N" : "M"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var rows = JSON.parse(response.responseText);
					if(rows.length == 0){
						validatePrinting();
					}else{
						if($F("selDestination") == "printer"){
							printBatchOR(rows, 0);
						}else if($F("selDestination") == "local"){
							//printBatchORToLocalOld(rows); //display printer applet for every report to be printed
							printBatchORToLocal2(rows);
						}
					}
				}
			}
		});
	}
	
	function printBatchORToLocal2(rows){
		var printerName = null;
		
		if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").selectPrinter, null) == null ||
			nvl($("geniisysAppletUtil").printBatchJRPrintFileToPrinter, null) == null){
			showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
				toggleOnPrint(true);
				objBatchOR.stopPrinting = false;
			});
			return;
		}else{
			printerName = $("geniisysAppletUtil").selectPrinter();
		}
		
		if(printerName == "" || printerName == null){
			showWaitingMessageBox("No printer selected.", "I", function(){
				toggleOnPrint(true);
				objBatchOR.stopPrinting = false;
			});
			return;
		}
		
		for(var i = 0; i < rows.length; i++){
			var content = contextPath+"/BatchORPrintController?action=printReport&reportId=GIACR050"+
				"&gaccTranId="+rows[i].gaccTranId+"&orPref="+rows[i].orPref+"&orNo="+rows[i].orNo+
				"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if(!nvl(objBatchOR.stopPrinting, false)){
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
			}else{
				$("lastPrintedOR").value = rows[index].orNo;
				showWaitingMessageBox("Printing was stopped by user.", "I", showLastORNoOverlay);
			}
		}
		validatePrinting();
	}
	
	function printBatchORToLocalOld(rows){
		if(nvl($("geniisysAppletUtil"), null) == null || nvl($("geniisysAppletUtil").printJRPrintFileToPrinter, null) == null){
			showWaitingMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", "E", function(){
				toggleOnPrint(true);
				objBatchOR.stopPrinting = false;
				return
			});
		}
		
		for(var index = 0; index < rows.length; index++){
			var content = contextPath+"/BatchORPrintController?action=printReport&reportId=GIACR050"+
				"&gaccTranId="+rows[index].gaccTranId+"&orPref="+rows[index].orPref+"&orNo="+rows[index].orNo+
				"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if(!nvl(objBatchOR.stopPrinting, false)){
				new Ajax.Request(content, {
					evalScripts: true,
					asynchronous: false,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
								return false;
							}
						}
					}
				});
			}else{
				$("lastPrintedOR").value = rows[index].orNo;
				showWaitingMessageBox("Printing was stopped by user.", "I", showLastORNoOverlay);
			}
		}
		validatePrinting();
	}
	
	function printBatchOR(rows, index){
		hideNotice();
		var content = contextPath+"/BatchORPrintController?action=printReport&reportId=GIACR050"+
						"&gaccTranId="+rows[index].gaccTranId+"&orPref="+rows[index].orPref+"&orNo="+rows[index].orNo+
						"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
		
		new Ajax.Request(content, {
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if(!nvl(objBatchOR.stopPrinting, false)){
						if((index + 1) == rows.length){
							validatePrinting();
						}else{
							printBatchOR(rows, ++index);
						}
					}else{
						$("lastPrintedOR").value = rows[index].orNo;
						showWaitingMessageBox("Printing was stopped by user.", "I", showLastORNoOverlay);
					}
				}
			}
		});
	}
	
	function validatePrinting(){
		showConfirmBox("Validate Printing", "Were all the O.R.s successfully printed?", "Yes", "No",
			processPrintedOR, showLastORNoOverlay, "1");
	}
	
	function processPrintedOR(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			method: "POST",
			parameters: {
				action: "processPrintedBatchOR",
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd"),
				orType: $("vatOr").checked ? "V" : $("nonVatOr").checked ? "N" : "M"
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				toggleOnPrint(true);
				objBatchOR.stopPrinting = false;
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					batchORTG._refreshList();
					getDefaultOrValues();
				}
			}
		});
	}
	objBatchOR.processPrintedOR = processPrintedOR;
	
	function showLastORNoOverlay(){
		toggleOnPrint(true);
		objBatchOR.stopPrinting = false;
		
		lastORNoOverlay = Overlay.show(contextPath+"/GIACOrderOfPaymentController", {
			urlParameters: {
				action: "showLastORNoOverlay"
			},
			urlContent : true,
			draggable: true,
		    title: "Unsuccessful Printing",
		    height: 125,
		    width: 300
		});
	}
	objBatchOR.showLastORNoOverlay = showLastORNoOverlay;
	
	function stopPrinting(){
		objBatchOR.stopPrinting = true;
	}
	
	function confirmSpoilOR(){
		if(selectedIndex == -1){
			showMessageBox("Please select a record first.", "I");
		}else{
			if(nvl(batchORTG.geniisysRows[selectedIndex].orFlag, "N") == "N" || nvl(batchORTG.geniisysRows[selectedIndex].printedFlag, "") != "Y"){
				showMessageBox("This O.R. has not yet been printed.", "I");
			}else{
				showConfirmBox("Confirmation", "Are you sure you want to spoil O.R. No. " + batchORTG.geniisysRows[selectedIndex].dspOrPref + "-" +
						batchORTG.geniisysRows[selectedIndex].dspOrNo + "?", "Yes", "No", spoilSelectedOR, null, "1");
			}
		}
	}
	
	function spoilSelectedOR(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			method: "POST",
			parameters: {
				action: "spoilSelectedOR",
				gaccTranId: batchORTG.geniisysRows[selectedIndex].gaccTranId,
				orPref: batchORTG.geniisysRows[selectedIndex].dspOrPref,
				orNo: batchORTG.geniisysRows[selectedIndex].dspOrNo,
				fundCd: $F("fundCd"),
				branchCd: $F("branchCd")
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					showWaitingMessageBox("O.R. was successfully spoiled.", "S", function(){
						batchORTG._refreshList();
						getDefaultOrValues();
					});
				}
			}
		});
	}
	
	function getBatchCommSlipParams(){
		new Ajax.Request(contextPath+"/GIACOrderOfPaymentController", {
			parameters: {
				action: "getBatchCommSlipParams"
			},
			asynchronous : false,
			evalScripts : true,
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					showConfirmBox("Confirmation", "Only printed OR's will be shown in the Commission Slip Batch Printing screen. Do you want to continue?",
						"Yes", "No", function(){callGIACS250(obj);}, null, "1");
				}
			}
		});
	}
	
	function validateBeforePrint(){
		for(var i = 0; i < batchORTG.geniisysRows.length; i++){
			if(batchORTG.geniisysRows[i].generateFlag == "Y" && (nvl(batchORTG.geniisysRows[i].dspOrNo, "") == "" || nvl(batchORTG.geniisysRows[i].dspOrPref, "") == "")){
				return false;
			}
		}
		return true;
	}
	
	function callGIACS250(obj){
		if(obj.gaccTranIdList != "()"){
			showGIACS250();
		}else{
			if(parseInt(nvl(obj.orCount, 0)) == 0){
				showMessageBox("No OR is selected. Kindly select OR by checking the Generate field of the OR and then try again.", "I");
			}else{
				showMessageBox("All selected ORs are not yet printed. The system cannot continue printing the commission slip.", "I");
			}
		}
	}
	
	$("fundCd").observe("change", function(){
		if($F("fundCd") == ""){
			$("fundCd").setAttribute("lastValidValue", "");
			$("branchCd").setAttribute("lastValidValue", "");
			$("fundDesc").value = "";
			$("branchCd").value = "";
			$("branchName").value = "";
			disableInputField("branchCd");
			disableSearch("searchBranchCd");
		}else{
			showFundLOV();
		}
		toggleToolbars();
	});
	
	$("searchFundCd").observe("click", function(){
		showFundLOV();
	});
	
	$("branchCd").observe("change", function(){
		if($F("branchCd") == ""){
			$("branchCd").setAttribute("lastValidValue", "");
			$("branchName").value = "";
		}else{
			showBranchLOV();
		}
		toggleToolbars();
	});
	
	$("searchBranchCd").observe("click", function(){
		showBranchLOV();
	});

	$("editParticulars").observe("click", function(){
		showOverlayEditor("particulars", 4000, true);
	});
	
	$("tagAll").observe("click", function(){
		tagGenerate(true);
	});
	
	$("untagAll").observe("click", function(){
		tagGenerate(false);
		toggleGenerate();
	});
	
	$("selDestination").observe("change", function(){
		$("selPrinter").value = "";
		
		if($F("selDestination") == "printer"){
			$("selPrinter").disabled = false;
			$("selPrinter").addClassName("required");
		}else{
			$("selPrinter").disabled = true;
			$("selPrinter").removeClassName("required");
		}
	});
	
	$$("input[name='orType']").each(function(c){
		c.observe("click", function(){
			var dspOrDate = nvl(batchORTG.objFilter.dspOrDate, "");
			var payor = nvl(batchORTG.objFilter.payor, "");
			batchORTG.url = contextPath +"/GIACOrderOfPaymentController?action=getBatchORList&refresh=1"+
										"&dspOrDate="+dspOrDate+"&payor="+encodeURIComponent(payor)+
										"&orType="+c.value;
			batchORTG._refreshList();
		});
	});
	
	$("btnView").observe("click", function(){
		if(selectedIndex == -1){
			showMessageBox("Please select a record first.", "I");
		}else{
			setORParamsGIACS053(selectedRow.gaccTranId);
		}
	});
	
	$("btnGenerate").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("orSeqNoDiv")){
			$$("input[name='orType']").each(function(e){
				e.checked = false;
			});
			saveGenerateTag("generate");
		}
	});
	
	$("btnPrintCommSlip").observe("click", function(){
		objACGlobal.previousModule = "GIACS053";
		saveGenerateTag("batchCommSlip");
	});
	
	$("btnPrint").observe("click", function(){
		if(batchORTG.geniisysRows.length == 0){
			showMessageBox("No records to print.", "I");
		}else if(!validateBeforePrint()){
			showMessageBox("Please generate O.R. numbers first.", "I");
		}else{
			printGeneratedOrs();
		}
	});
	
	$("btnStop").observe("click", function(){
		stopPrinting();
	});
	
	$("btnSpoil").observe("click", function(){
		confirmSpoilOR();
	});
	
	$("reloadForm").observe("click", function(){
		showBatchORPrinting();
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetForm();
		clearTG();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(objACGlobal.callingForm2 == "GIACS607"){ //shan 06.09.2015 : conversion of GIACS607
			/*$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			
			$("processPremAndCommDiv").show();
			$("mainNav").show();
			
			objBatchOR.uploadQuery = null;

			setModuleId("GIACS607");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS607");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			
			//nieko Accounting Uploading GIACS607
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGIACS607",
					sourceCd: objGIACS607.sourceCd,
					fileNo: objGIACS607.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if(objACGlobal.callingForm2 == "GIACS603"){ //john dolon; 7.6.2015; conversion of GIACS603
			/*$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			
			$("processDataPerPolicy").show();
			$("mainNav").show();
			
			objBatchOR.uploadQuery = null;

			setModuleId("GIACS603");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs603",
					sourceCd: objGIACS603.sourceCd,
					fileNo:   objGIACS603.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if(objACGlobal.callingForm2 == "GIACS604"){ //john dolon; conversion of GIACS604
			/*$("otherModuleDiv").innerHTML = "";
			$("otherModuleDiv").hide();
			
			$("processDataPerBill").show();
			$("mainNav").show();
			objBatchOR.uploadQuery = null;

			setModuleId("GIACS604");
			
			$("acExit").stopObserving();
			$("acExit").observe("click", function() {
				objACGlobal.callingForm = "";
				$("process").innerHTML = "";
				$("process").hide();
				
				setModuleId("GIACS601");
				$("convertFileMainDiv").show();
				$("acExit").show();
				$("acExit").stopObserving();
				$("acExit").observe("click", function() {
					goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
				});
			});*/
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs604",
					sourceCd: objGIACS604.sourceCd,
					fileNo:   objGIACS604.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else if (objACGlobal.callingForm2 == "GIACS610") { //Deo [10.06.2016]: add start
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs610",
					sourceCd: objGIACS610.sourceCd,
					fileNo: objGIACS610.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			}); //Deo [10.06.2016]: add ends
		} else if (objACGlobal.callingForm2 == "GIACS608") {
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGIACS608",
					sourceCd: objGIACS608.sourceCd,
					fileNo: objGIACS608.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			}); 		
		} else if (objACGlobal.callingForm2 == "GIACS609") { //Deo: GIACS609 conversion
			new Ajax.Request(contextPath+"/GIACUploadingController",{
				parameters: {
					action : "showGiacs609",
					sourceCd: objGIACS609.sourceCd,
					fileNo: objGIACS609.fileNo
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						objACGlobal.callingForm2 = "";
						$("mainNav").hide();
						$("mainContents").update(response.responseText);
					}
				}
			});
		} else{
			delete objBatchOR;
			objACGlobal.gaccTranId = "";
			objACGlobal.branchCd = "";
			objACGlobal.queryOnly = "";
			objACGlobal.previousModule = "";
			objACGlobal.callingForm = "";
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	newFormInstance();
</script>
