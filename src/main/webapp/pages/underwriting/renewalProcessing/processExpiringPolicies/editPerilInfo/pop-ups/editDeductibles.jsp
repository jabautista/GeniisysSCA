<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="editTaxChargesMainDiv">
	<div id="editTaxChargesSectionDiv" class="sectionDiv" style="width: 794px; margin-top: 10px;">
		<div style="height: 220px; margin-left: 10px;">
			<div id="deductiblesTableGrid" style="height: 210px; width: 750px;; margin-bottom: 10px; margin-top: 10px;"></div>
		</div>
		<div  id="editDeductiblesContentsDiv" align="center">
			<table>
				<tr>
					<td class="rightAligned" style="width: 80px;">Item</td>
					<td class="leftAligned"  style="width: 300px;" colspan="3">
						<div style="width: 70px;" class="withIconDiv"> <!--class="withIconDiv required"> --><!-- added required by robert 11.12.13 -->
							<input type="text" id="txtDedItemNo" name="txtDedItemNo" value="" style="width: 45px;" class="withIcon" readonly="readonly"> <!-- class="withIcon required" readonly="readonly"> --><!-- added required by robert 11.12.13 -->
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="itemNoLOV" name="itemNoLOV" alt="Go" />
						</div>
						<input type="text" id="txtDedItemTitle" name="txtDedItemTitle" value="" style="width: 400px;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 80px;">Peril</td>
					<td class="leftAligned"  style="width: 300px;" colspan="3">
						<div style="width: 70px;" class="withIconDiv">
							<input type="text" id="txtDedPerilCd" name="txtDedPerilCd" value="" style="width: 45px;" class="withIcon " readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="perilLOV" name="perilLOV" alt="Go" />
						</div>
						<input type="text" id="txtDedPerilName" name="txtDedPerilName" value="" style="width: 400px;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 80px;">Deductible</td>
					<td class="leftAligned"  style="width: 300px;" colspan="3">
						<div style="width: 70px;" class="withIconDiv required">
							<input type="text" id="txtDedDeductibleCd" name="txtDedDeductibleCd" value="" style="width: 45px;" class="withIcon required" readonly="readonly">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="deductiblesLOV" name="deductiblesLOV" alt="Go" />
						</div>
						<!-- joanne 06.06.14, this should be hidden, replace by text field below 
						<input type="text" id="txtDedDedType" name="txtDedDedType" value="" style="width: 400px;" readonly="readonly"> -->
						<input type="text" id="txtDedDedTitle" name="txtDedDedTitle" value="" style="width: 400px;" readonly="readonly">
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="80px">Rate</td>
					<td class="leftAligned" width="201px">
						<input type="text" id="txtDedDeductibleRt" name="txtDedDeductibleRt" style="width: 191px;" class="moneyRate" readonly="readonly"/>
					</td>
					<td class="rightAligned" width="80px">Amount</td>
					<td class="leftAligned" width="200px">
						<input type="text" id="txtDedDeductibleAmt" name="txtDedDeductibleAmt" style="width: 191px;"  class="money" readonly="readonly"/>
					</td>
				</tr>
<!-- 				<tr>
					<td class="rightAligned" width="100px">Amount</td>
					<td class="leftAligned" width="290px">
						<input type="text" id="txtDedDeductibleAmt" name="txtDedDeductibleAmt" style="width: 276px;"  class="money"/>
					</td>
				</tr> -->
				<tr>
					<td class="rightAligned" width="80px">Text</td>
					<td class="leftAligned" width="290px" colspan="3">
						<div style="border: 1px solid gray; height: 20px; width: 482px" changeTagAttr="true">
							<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="txtDedText" name="txtDedText" style="width: 455px; border: none; height: 13px;" readonly="readonly"></textarea>
							<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div id="hidden" style="display: none;">
			<input type="hidden" id="txtDedPolicyId" name="txtDedPolicyId">
			<input type="hidden" id="txtDedLineCd" name="txtDedLineCd">
			<input type="hidden" id="txtDedSublineCd" name="txtDedSublineCd">
			<input type="hidden" id="txtDedIssCd" name="txtDedIssCd">
			<input type="hidden" id="txtDedNbtItemNo" name="txtDedNbtItemNo">
			<input type="hidden" id="txtDedNbtPerilCd" name="txtDedNbtPerilCd">
			<input type="hidden" id="txtDedNbtDeductibleCd" name="txtDedNbtDeductibleCd">
			<input type="hidden" id="txtDedNbtDeductibleRt" name="txtDedNbtDeductibleRt">
			<input type="hidden" id="txtDedNbtDeductibleAmt" name="txtDedNbtDeductibleAmt">
			<input type="hidden" id="txtInitItemNo" name="txtInitItemNo">
			<input type="hidden" id="txtInitPerilCd" name="txtInitPerilCd">
			<input type="hidden" id="txtInitDeductibleCd" name="txtInitDeductibleCd">
			<input type="hidden" id="txtLocalDeductibleAmt" name="txtLocalDeductibleAmt"> <!-- added by joanne 06.05.14 -->
			<input type="hidden" id="txtDedCurrencyRt" name="txtDedCurrencyRt"> <!-- added by joanne 06.06.14 -->
			<input type="hidden" id="txtDedDedType" name="txtDedDedType" > <!-- added by joanne 06.06.14 -->
		</div>
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" class="button" id="btnAddDeductibles" name="btnAddDeductibles" value="Add" style=" width: 80px;"/>
			<input type="button" class="button" id="btnDeleteDeductibles" name="btnDeleteDeductibles" value="Delete" style=" width: 80px;"/>
		</div>
	</div>
	<div id="editTaxChargesButtonsDiv" name="editTaxChargesButtonsDiv" class="buttonsDiv" style="width: 99%; margin-top: 15px; margin-bottom: 0px;">
		<input type="button" class="button" id="btnDedOk" name="btnDedOk" value="Ok">
		<input type="button" class="button" id="btnDedCancel" name="btnDedCancel" value="Cancel">
		<!-- <input type="button" class="button" id="btnDedRecompute" name="btnDedRecompute" value="Recompute Deductibles"> -->
	</div>
</div>

<script type="text/javascript">
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();

	var objGIEXS007  = new Object(); 
	var selectedDeductibles = null;
	var selectedDeductiblesRow = new Object();
	var mtgId = null;
	objGIEXS007.deductiblesListTableGrid = JSON.parse('${deductibles}'.replace(/\\/g, '\\\\'));
	objGIEXS007.deductibles= objGIEXS007.deductiblesListTableGrid.rows || [];
	
	try {
		var deductiblesListingTable = {
			url: contextPath+"/GIEXNewGroupDeductiblesController?action=populateDeductiblesGIEXS007&refresh=1&mode=1&policyId="+$F("txtB240PolicyId"),
			options: {
				width: '775px',
				height: '190px',
				onCellFocus: function(element, value, x, y, id) {
					mtgId = deductiblesGrid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						//console.log(JSON.stringify(deductiblesGrid.geniisysRows[y]));
						selectedDeductibles = y;
						selectedDeductiblesRow = deductiblesGrid.geniisysRows[y];
						setDeductiblesInfo(deductiblesGrid.getRow(y));
						removeDeductibleFocus();
					}
				},
				onRemoveRowFocus : function(){
					setDeductiblesInfo(null);
					removeDeductibleFocus();
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
								id: 'itemNo',
								title: 'Item',
								width: '80',
								titleAlign: 'right',
								align: 'right',
								editable: false,
								sortable: false,
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
								}
							}, 
							{
								id: 'dspPerilName',
								title: 'Peril',
								width: '150',
								sortable: false,
								editable: false
							},
							{
								id: 'dedDeductibleCd',
								title: 'Deductible',
								width: '120',
								sortable: false,
								editable: false
							},
							{
								id: 'deductibleRt',
								title: 'Rate',
								width: '100',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'rate',
								sortable: false,
								editable: false
							}, 
							{
								id: 'deductibleAmt',
								title: 'Amount',
								width: '160',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								sortable: false,
								editable: false
							},
							{ //added by joanne 06.05.14
								id: 'deductibleLocalAmt',
								width: '0',
								visible: false
							},
							{
								id: 'deductibleText',
								title: 'Text',
								width: '200',
								sortable: false,
								editable: false
							},
							{	
								id: 'policyId',
								width: '0',
								visible: false
							},
							{	
								id: 'perilCd',
								width: '0',
								visible: false
							},
							{	
								id: 'lineCd',
								width: '0',
								visible: false
							},
							{	
								id: 'sublineCd',
								width: '0',
								visible: false
							},
							{	
								id: 'dedType',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtItemNo',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtPerilCd',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtDeductibleCd',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtDeductibleRt',
								width: '0',
								visible: false
							},
							{	
								id: 'nbtDeductibleAmt',
								width: '0',
								visible: false
							},
							{	
								id: 'initItemNo',
								width: '0',
								visible: false
							},
							{	
								id: 'initPerilCd',
								width: '0',
								visible: false
							},
							{	
								id: 'initDeductibleCd',
								width: '0',
								visible: false
							},
							{	id : "itemTitle",
								title: "",
								visible: false,
								width: '0'
							},
							{	id : "deductibleTitle",
								title: "",
								visible: false,
								width: '0'
							}
						],
			resetChangeTag: true,
			rows: objGIEXS007.deductibles
		};
		deductiblesGrid = new MyTableGrid(deductiblesListingTable);
		deductiblesGrid.pager = objGIEXS007.deductiblesListTableGrid;
		deductiblesGrid.render('deductiblesTableGrid');
	}catch(e) {
		showErrorMessage("deductiblesGrid", e);
	}

	function getItemNo(policyId){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getItemGIEXS007LOV", 
							policyId : policyId,
							page : 1},
			title: "List of Items",
			width: 450,
			height: 400,
			columnModel : [	
			               	{	id : "itemNo",
								title: "Item No",
								width: '100px',
								titleAlign: 'right',
								align: 'right',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
								}
							} ,
							{	id : "itemTitle",
								title: "Item Title",
								width: '235px'
							} 
						],
			draggable: true,
			onSelect: function(row){
				$("txtDedItemNo").value = unescapeHTML2(row.itemNo);  
				$("txtDedItemTitle").value = unescapeHTML2(row.itemTitle);
			},
	  		onCancel: function(){
				$("txtDedItemNo").focus();
	  		}
		  });
	}
	
	function getItmperilLOV(itemNo, policyId){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getItmperilLOV", 
							itemNo : itemNo,
							policyId : policyId,
							page : 1},
			title: "List of Perils",
			width: 450,
			height: 400,
			columnModel : [	
			               	{	id : "perilCd",
								title: "Peril Code",
								width: '100px',
								titleAlign: 'right',
								align: 'right',
								renderer: function (value){
									return nvl(value,'') == '' ? '' :formatNumberDigits(value,5);
								}
							} ,
							{	id : "perilName",
								title: "Peril Name",
								width: '235px'
							} 
						],
			draggable: true,
			onSelect: function(row){
				$("txtDedPerilCd").value = unescapeHTML2(row.perilCd);
				$("txtDedPerilName").value = unescapeHTML2(row.perilName);
				//enableButton("btnActivate"); // san itong button na to? hehe.. - andrew 12.10.2012
			},
	  		onCancel: function(){
				$("txtDedPerilCd").focus();
	  		}
		  });
	}
	
	function getDeductiblesLOV(lineCd, sublineCd){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDeductiblesLOV", 
							lineCd : lineCd,
							sublineCd: sublineCd,
							page : 1},
			title: "List of Deductibles",
			width: 650,
			height: 400,
			columnModel : [	
							{	id : "deductibleCd",
								title: "Code",
								width: '80px'
							},
							{	id : "deductibleDesc",
								title: "Description",
								width: '140px'
							},
							{	id : "deductibleType",
								title: "Type",
								width: '80px'
							},
							{	id : "deductibleRate",
								align : "right",
								titleAlign : "right",
								title: "Rate",
								width: '100px'
							},
							{	id : "deductibleAmt",
								align : "right",
								titleAlign : "right",
								title: "Amount",
								width: '100px'
							},
							{	id : "deductibleText",
								title: "Text",
								width: '235px'
							}, //joanne 06.06.14
							{	id : "deductibleTitle",
								title: "",
								visible: false,
								width: '0' 
							}
						],
			draggable: true,
			onSelect: function(row){
				$("txtDedDeductibleCd").value = unescapeHTML2(row.deductibleCd);
				$("txtDedDedType").value = unescapeHTML2(row.deductibleType); //unescapeHTML2(row.deductibleTitle); joanne 06.06.14, change into deductibleType
				$("txtDedDedTitle").value = unescapeHTML2(row.deductibleTitle); //joanne 06.06.14
				$("txtDedDeductibleRt").value = formatToNineDecimal(row.deductibleRate);
				$("txtDedCurrencyRt").value = getDeductibleCurrency();
				$("txtDedDeductibleAmt").value = formatCurrency(roundNumber(row.deductibleAmt / $("txtDedCurrencyRt").value, 2)); // formatCurrency(row.deductibleAmt); joanne 06.05.14, display deductible in policy currency
				$("txtLocalDeductibleAmt").value = formatCurrency(row.deductibleAmt); //added by joanne 06.05.14, for deductible local amt
				$("txtDedText").value = unescapeHTML2(row.deductibleText);
			},
	  		onCancel: function(){
				$("txtDedDeductibleCd").focus();
	  		}
		  });
	}
	
	function removeDeductibleFocus(){
		deductiblesGrid.keys.removeFocus(deductiblesGrid.keys._nCurrentFocus, true);
		deductiblesGrid.keys.releaseKeys();
	}
	
	//added by joanne 06.06.14, to get policy currency
	function getDeductibleCurrency(){
		var deductibleCurrencyRt = null;
		new Ajax.Request(contextPath+"/GIEXNewGroupDeductiblesController?action=getDeductibleCurrency", {
			method: "POST",
			parameters: {	policyId					: 	$F("txtB240PolicyId")		
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					deductibleCurrencyRt =  response.responseText;
				}
			}
		});
		return deductibleCurrencyRt;	
	}

	
	function computeDeductibleAmt(itemNo, perilCd, dedRt, dedPolicyId, dedDeductibleCd){
		var deductibleAmt = null;
		new Ajax.Request(contextPath+"/GIEXItmperilController?action=computeDeductibleAmt",{
			method: "POST",
			parameters: {itemNo	: itemNo,
						perilCd	: perilCd,
						dedRt	: dedRt,
						dedPolicyId	: dedPolicyId,
						dedDeductibleCd: dedDeductibleCd
			},
			evalScripts: true,
			asynchronous: false,
			onSuccess: function (response){
				if (checkErrorOnResponse(response)){
					deductibleAmt =  response.responseText;
				}
			}
		});	
		return deductibleAmt;
	}
	
	$("itemNoLOV").observe("click", function(){
		getItemNo($F("txtB240PolicyId"));
	});
	
	$("perilLOV").observe("click", function(){
		getItmperilLOV($F("txtDedItemNo"), $F("txtB240PolicyId"));
	});
	
	$("deductiblesLOV").observe("click", function(){
		//getDeductiblesLOV($F("txtDedLineCd"), $F("txtDedSublineCd"));
		/*if($F("txtDedItemNo").blank()){ //added by robert to prevent saving without item no 11.12.13
			showMessageBox("Item No. is required.");
		}else{*/
			//comment by joanne 06.06.14, item no can be null if deductible is policy level
			getDeductiblesLOV($F("txtLineCd"), $F("txtSublineCd")); // andrew - 12.10.2012
		//}
	});
	
	$("btnDedOk").observe("click", function(){
		fetchNewGroupDed();
		saveGIEXNewGroupDeductibles();
	});
	
	$("btnDedCancel").observe("click", function(){
		deductiblesDetails.close();
	});
	
	function setDeductiblesInfo(obj) {
		try {
			$("txtDedItemNo").value			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemNo,""))) :null;
			$("txtDedItemTitle").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemTitle,""))) :null; // andrew - 12.10.2012
			$("txtDedPerilName").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspPerilName,""))) :null;
			$("txtDedDeductibleCd").value	= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dedDeductibleCd,""))) :null;
			$("txtDedDeductibleRt").value	= nvl(obj,null) != null ?formatToNineDecimal(unescapeHTML2(String(nvl(obj.deductibleRt,"")))) :null;
			$("txtDedDeductibleAmt").value	= nvl(obj,null) != null ?formatCurrency(unescapeHTML2(String(nvl(obj.deductibleAmt,"")))) :null;
			$("txtLocalDeductibleAmt").value= nvl(obj,null) != null ?formatCurrency(unescapeHTML2(String(nvl(obj.deductibleLocalAmt,"")))) :null; //joanne, 06.05.14
			$("txtDedText").value			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.deductibleText,""))) :null;
			$("txtDedPolicyId").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.policyId,""))) :null;
			$("txtDedPerilCd").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("txtDedLineCd").value			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.lineCd,""))) :null;
			$("txtDedSublineCd").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.sublineCd,""))) :null;
			$("txtDedDedType").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dedType/*obj.deductibleTitle replace into dedType*/,""))) :null;
			$("txtDedDedTitle").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.deductibleTitle,""))) :null; //joanne 06.06.14
			$("txtDedNbtItemNo").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemNo,""))) :null;
			$("txtDedNbtPerilCd").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("txtDedNbtDeductibleCd").value = nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dedDeductibleCd,""))) :null;
			$("txtDedNbtDeductibleRt").value = nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.deductibleRt,""))) :null;
			$("txtDedNbtDeductibleAmt").value = nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.deductibleAmt,""))) :null;
			$("txtInitItemNo").value		= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemNo,""))) :null;
			$("txtInitPerilCd").value	 	= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("txtInitDeductibleCd").value	= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dedDeductibleCd,""))) :null;
			//$("btnAddDeductibles").value 	= obj == null ? "Add" : "Update" ;
			obj == null ? enableButton("btnAddDeductibles") : disableButton("btnAddDeductibles");			
			obj != null ? enableButton("btnDeleteDeductibles") : disableButton("btnDeleteDeductibles");
			obj != null ? disableSearch("itemNoLOV") : enableSearch("itemNoLOV");
			obj != null ? disableSearch("perilLOV") : enableSearch("perilLOV");
			obj != null ? disableSearch("deductiblesLOV") : enableSearch("deductiblesLOV");			
		} catch(e) {
			showErrorMessage("setB880Info", e);
		}
	}
	
	function createDeductibles(obj){
		try {		
			var deductibles 			= (obj == null ? new Object() : obj);	
			var currencyRt				= getDeductibleCurrency(); //joanne 06.06.14
			deductibles.recordStatus 	= (obj == null ? 0 : 1);
			deductibles.itemNo 			= nvl($F("txtDedItemNo"), 0);
			deductibles.dspPerilName	= escapeHTML2($F("txtDedPerilName"));
			deductibles.dedDeductibleCd	= escapeHTML2($F("txtDedDeductibleCd"));
			deductibles.deductibleRt 	= escapeHTML2($F("txtDedDeductibleRt"));
			deductibles.deductibleAmt 	= escapeHTML2($F("txtDedDeductibleAmt"));
			deductibles.deductibleLocalAmt 	=  nvl(escapeHTML2($F("txtLocalDeductibleAmt")),roundNumber(escapeHTML2($F("txtDedDeductibleAmt")) * currencyRt, 2)); //added by joanne, 06.05.14
			deductibles.deductibleText 	= escapeHTML2($F("txtDedText"));
			deductibles.policyId 		= escapeHTML2(nvl($F("txtDedPolicyId"), $F("txtB240PolicyId")));
			deductibles.perilCd			= nvl($F("txtDedPerilCd"), 0);
			/* deductibles.lineCd 			= escapeHTML2($F("txtDedLineCd"));
			deductibles.sublineCd 		= escapeHTML2($F("txtDedSublineCd")); */ // replaced by andrew - 1.10.2012
			deductibles.lineCd 			= escapeHTML2($F("txtLineCd"));
			deductibles.sublineCd 		= escapeHTML2($F("txtSublineCd"));
			deductibles.dedType 		= escapeHTML2($F("txtDedDedType"));
			deductibles.nbtItemNo 		= escapeHTML2($F("txtDedNbtItemNo"));
			deductibles.nbtPerilCd 		= escapeHTML2($F("txtDedNbtPerilCd"));
			deductibles.nbtDeductibleCd = escapeHTML2($F("txtDedNbtDeductibleCd"));
			deductibles.nbtDeductibleRt = escapeHTML2($F("txtDedNbtDeductibleRt"));
			deductibles.nbtDeductibleAmt = escapeHTML2($F("txtDedNbtDeductibleAmt"));		
			deductibles.initItemNo 		= escapeHTML2($F("txtInitItemNo"));
			deductibles.initPerilCd 	= escapeHTML2($F("txtInitPerilCd"));
			deductibles.initDeductibleCd = escapeHTML2($F("txtInitDeductibleCd"));	
			return deductibles;
		} catch (e){
			showErrorMessage("createDeductibles", e);
		}			
	}

	function validateDeductible(){
		var addedRows = deductiblesGrid.getNewRowsAdded();
		var deductibles = addedRows.concat(deductiblesGrid.geniisysRows);
		for(var i=0; i<deductibles.length; i++){
			if(deductibles[i].dedDeductibleCd == $F("txtDedDeductibleCd")
					&& deductibles[i].perilCd == nvl($F("txtDedPerilCd"), 0)
					&& deductibles[i].itemNo == nvl($F("txtDedItemNo"), 0)){
				showMessageBox("Deductible record already exists.", "I");
				return false;
			}
		}
		return true;
	}

	function addDeductible(){
		var deductibles = createDeductibles();	
		if($F("btnAddDeductibles") == "Add"){
			if (deductibles.dedType == 'T'){
				var deductibleAmt = computeDeductibleAmt(nvl(deductibles.itemNo,'0'), nvl(deductibles.perilCd,'0'), deductibles.deductibleRt, deductibles.policyId, deductibles.dedDeductibleCd);
				var currencyRt				= getDeductibleCurrency();
				deductibles.deductibleAmt = deductibleAmt;
				deductibles.deductibleLocalAmt = roundNumber(deductibleAmt*currencyRt,2);
			}
			deductiblesGrid.createNewRow(deductibles);
		} else {		
			var itmperilTsiChanged = false;
			var deductibleAmt = computeDeductibleAmt(nvl(deductibles.itemNo,'0'), nvl(deductibles.perilCd,'0'), deductibles.deductibleRt, deductibles.policyId, deductibles.dedDeductibleCd);
			if (unformatCurrencyValue(deductibles.deductibleAmt) != deductibleAmt && deductibles.dedType == 'T'){
				itmperilTsiChanged = true;
			}
			if(itmperilTsiChanged && 
				(deductibles.deductibleAmt == deductibles.nbtDeductibleAmt || deductibles.deductibleAmt == "" && deductibles.nbtDeductibleAmt == null) &&
				(deductibles.deductibeRt == deductibles.nbtDeductibeRt || deductibles.deductibeRt == "" && deductibles.nbtDeductibeRt =="")){
				customShowMessageBox('There are changes in TSI amount. Please recompute deductibles first.', 'E', 'btnDedRecompute');
				return false;
			}else if(nvl(deductibles.deductibleAmt, "" ) != nvl(deductibles.nbtDeductibleAmt, "" ) ||
					nvl(deductibles.deductibleRt, "" ) != nvl(deductibles.nbtDeductibleRt, "" ) ||
					(((deductibles.deductibleAmt == "" && deductibles.nbtDeductibleAmt == "") || 
							(deductibles.deductibeRt == "" && deductibles.nbtDeductibeRt == "")) &&
							deductibles.dedType == 'T')){
				customShowMessageBox('There are unsaved changes in deductibles. Please recompute deductibles first.', 'E', 'btnDedRecompute');
				return false;
			}
			deductiblesGrid.updateRowAt(deductibles, selectedDeductibles);
		}
		changeTag = 1;
		setDeductiblesInfo(null);
	}
	
	$("btnAddDeductibles").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("editDeductiblesContentsDiv")){
			if(validateDeductible()){
				new Ajax.Request(contextPath + "/GIEXNewGroupDeductiblesController", {
					parameters: {action : "validateIfDeductibleExists",
						         policyId : $F("txtB240PolicyId"),
						         itemNo : nvl($F("txtDedItemNo"), 0),
						         perilCd : nvl($F("txtDedPerilCd"), 0),
						         dedDeductibleCd : $F("txtDedDeductibleCd")},
					onComplete: function(response){						
						if(checkErrorOnResponse(response)){
							if(response.responseText == "0"){
								addDeductible();
							} else {
								showMessageBox("Deductible record already exists.", "I");
							}
						}
					}
				});				
			}
		}
	});

	function recomputeDeductibles(){
		try {
			var deductibles = createDeductibles();
			var itmperilTsiChanged = false;
			if (deductibles.deductibleAmt != deductibleAmt && deductibles.dedType == 'T'){
				itmperilTsiChanged = true;
			}
			 if(deductibles.deductibleRt == "" && deductibles.dedType != 'F' ){
				customShowMessageBox('Please enter deductible rate.', 'E', "txtDedDeductibleRt");
				return false;
			}else if(deductibles.deductibleAmt == "" && deductibles.dedType == 'F' ){
				customShowMessageBox('Please enter deductible amount', 'E', "txtDedDeductibleAmt");
				return false;
			}else if(deductibles.deductibleRt != "" && deductibles.dedType == 'T'){
				if(nvl(deductibles.nbtDeductibleRt,parseFloat(deductibles.deductibleRt)+1) != deductibles.deductibleRt || 
						deductibles.deductibleAmt == "" || itmperilTsiChanged) {
					//deductiblesGrid.setValueAt(deductibleAmt, deductiblesGrid.getColumnIndex("deductibleAmt"), selectedDeductibles, true);
					$("txtDedDeductibleAmt").value = formatCurrency(deductibleAmt);
					$("txtDedNbtDeductibleAmt").value = formatCurrency(deductibleAmt);
				}
			}			
		} catch (e){
			showErrorMessage("recomputeDeductibles", e);
		}
	}
	
	/* $("btnDedRecompute").observe("click", recomputeDeductibles); */
	
	$("btnDeleteDeductibles").observe("click", function(){
		if (nvl(deductiblesGrid,null) instanceof MyTableGrid) {
			deductiblesGrid.deleteRow(selectedDeductibles);
			setDeductiblesInfo(null);
		}		
	});
	
	function deleteModNewGroupDeductibles(policyId, itemNo, perilCd, dedDeductibleCd){
		try{
			new Ajax.Request(contextPath+"/GIEXNewGroupDeductiblesController?action=deleteModNewGroupDeductibles", {
				method: "POST",
				parameters: {policyId					: 		policyId,
										itemNo					:		itemNo,
										perilCd					:		perilCd,
										dedDeductibleCd	:		dedDeductibleCd}
			});
		}catch(e) {
			showErrorMessage("deleteModNewGroupDeductibles", e);
		}
	}
	
	function fetchNewGroupDed(){
		try {
			objGIEXS007.modNewGroupDedObj =deductiblesGrid.getModifiedRows();
			var rows = deductiblesGrid.getModifiedRows();
			for(var i=0; i<rows.length;  i++){
				if (rows[i].initItemNo != rows[i].itemNo &&
					 rows[i].initPerilCd != rows[i].perilCd &&
					 rows[i].initDeductibleCd	!= rows[i].dedDeductibleCd){
					deleteModNewGroupDeductibles(rows[i].policyId, rows[i].initItemNo, rows[i].initPerilCd, rows[i].initDeductibleCd);
				}
			}
			objGIEXS007.addNewGroupDedObj = deductiblesGrid.getNewRowsAdded().concat(rows);
			objGIEXS007.delNewGroupDedObj = deductiblesGrid.getDeletedRows();
		} catch (e){
			showErrorMessage("fetchNewGroupDed", e);
		}
	}
	
	function saveGIEXNewGroupDeductibles(){
		new Ajax.Request(contextPath+"/GIEXNewGroupDeductiblesController?action=saveGIEXNewGroupDeductibles",{
			method: "POST",
			parameters: {
				policyId : $F("txtB240PolicyId"),
				parameters: JSON.stringify(objGIEXS007)
			},
			evalScripts: true,
			asynchronous: false,
			onCreate: function (){
				showNotice("Saving Deductibles. Please wait...");
			},
			onSuccess: function (response){
				hideNotice("");
				if (checkErrorOnResponse(response)){
					if (response.responseText == "SUCCESS"){
						deductiblesDetails.close();
					}
				}
			}
		});	
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtDedText", 4000, true);
	});
</script>