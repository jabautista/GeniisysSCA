<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div class="sectionDiv" id="outwardFaculPremPaymtsDivMain">
	<!-- Hidden Fields -->
		<input type="hidden" id="hiddenBinderId" />
		<input type="hidden" id="hiddenAssdNo" />
		<input type="hidden" id="hiddenConvertRate" />
		<input type="hidden" id="hiddenPolicyId" />
		<input type="hidden" id="hiddenIssCd" />
		<input type="hidden" id="hiddenCurrencyCd" />
		<input type="hidden" id="hiddenCurrencyRt" />
		<input type="hidden" id="hiddenCurrencyDesc" />
		<input type="hidden" id="hiddenForeignCurrAmt" />
		<input type="hidden" id="hiddenPremSeqNo" />
		<input type="hidden" id="hiddenPremAmt" />
		<input type="hidden" id="hiddenPremVat" />
		<input type="hidden" id="hiddenCommAmt" />
		<input type="hidden" id="hiddenCommVat" />
		<input type="hidden" id="hiddenwHoldingTax" />
		<input type="hidden" id="hiddenRiCd" />
		<input type="hidden" id="hiddenRecStatus" />
		<input type="hidden" id="hiddenBinderId2" />
		<input type="hidden" id="hiddenPaytGaccTranId" />	<!-- SR-19631 : shan 08.17.2015 -->
		<input type="hidden" id="hiddenRecordNo" />	<!-- SR-19631 : shan 08.17.2015 -->
	<!-- End Hidden Fields -->
	<div id="outwardFaculPremPaytsTableMainDiv" name="outwardFaculPremPaytsTableMainDiv" style="width: 920px; margin: 0 auto;" >
				<div id="outFaculPremPaytsTableGrid"  style="height: 300px; padding: 10px;"></div>
	</div>
	<div style="height:30px; width: 915px;">
		<table  align="right">
			<tr>
				<td class="rightAligned" >Total:</td>
				<td ><input class="rightAligned"  type="text" id="amtTotal" name="amtTotal" readonly="readonly" tabindex=101/></td>
			</tr>
		</table>
	</div>		
	<table width="85%" align="center" cellspacing="1" border="0">
		<tr>
			<td class="rightAligned" style="width: 100px;">Transaction Type</td>
			<td class="leftAligned" style="width: 200px;"> 
				<select id="tranType" style="width: 250px;" class="required" tabindex=102>
					<option></option>
				</select>
			</td>
			<td class="rightAligned" style="width: 100px;">Assured Name</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="assuredName" style="width: 220px;" readOnly="readonly" tabindex=112/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Reinsurer</td>
			<td class="leftAligned" style="width: 200px;"> 
				<div id="reinsurerDiv" style=" border: 1px solid gray; width: 248px; height: 22px; float: left; background-color: cornsilk;"> 
					<input style="width: 220px; border: none; float: left; margin-top: .5px;" id="reinsurer" name="reinsurer" type="text" value="" class="required" readonly="readonly" tabindex=103/> 
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmReinsurer" class="cancelORSearch" name="oscmReinsurer" alt="Go" tabindex=104/>
				</div>
			</td>
			<td class="rightAligned" style="width: 100px;">Policy No.</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="policyNo" style="width: 220px;" readOnly="readonly"  tabindex=113/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Binder No.</td>
			<td class="leftAligned">
				<input type="text" id="faculPremLineCd" style="width: 50px; height: 15px; margin-top: .5px; float: left;" class="required" tabindex=105 maxlength="2"/>
				<input type="text" id="faculPremBinderYY" style="width: 50px; height: 15px; margin-top: .5px; margin-left: 2px; float: left; text-align: right;" class="required" tabindex=106 maxlength="2"/>
				<div id="binderNoDiv" style=" border: 1px solid gray; width: 128px; height: 22px; float: left; background-color: cornsilk; margin-left: 2px;"> 
					<input style="width: 101.5px; border: none; float: left; margin-top: .5px; text-align: right;" id="binderSeqNo" name="binderSeqNo" type="text" value="" class="leftAligned required" tabindex=107 maxlength="5"/> 
					<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="oscmBinderNo" class="cancelORSearch" name="oscmBinderNo" alt="Go" tabindex=108/>
				</div>
			</td>
			<td class="rightAligned" style="width: 100px;">Remarks</td>
			<td class="leftAligned" style="width: 200px;">
				<div  style="float: left; width: 226px; border: 1px solid gray; height: 20px;">
					<textarea style="float: left; height: 14px; width: 196px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex=114></textarea>
					<img id="editRemarks" name="editRemarks" alt="Go" style="float: right;" src="${pageContext.request.contextPath}/images/misc/edit.png"  tabindex=115>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned" style="width: 100px;">Amount</td>
			<td class="leftAligned" style="width: 250px;"> 
				<input type="text" id="amount" style="width: 242px; text-align: right;" class="required" tabindex=109/>
			</td>
			<td  colspan="2"> 
				<input type="button" id="breakdown" style="width: 100px;" value="BreakDown" class="button" tabindex=116/>  <!-- class="disabledButton" -->  
				<input type="button" id="binderBtn" value="Binder" class="button" tabindex=117/> <!-- class="disabledButton" -->  
				<input type="button" id="overrideDefBtn" style="width: 115px;" value="Override Default" class="disabledButton"  tabindex=118/>
		    </td>
		</tr>
		
		<tr>
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="leftAligned" style="width: 250px;"> 
				<input type="checkbox" id="wPremiumTag" style="width: 10px;" disabled />
				w/ Premium Warranty
			</td>
			<td colspan="2"> 
				<input type="button" id="currInformation" value="Currency Information" class="button" tabindex=119/> <!-- class="disabledButton" --> 
				<input type="button" id="revertBtn" value="Revert to Default" class="disabledButton" tabindex=120/>
				<input type="button" id="outfaculList"value="Outfacul List" class="button" tabindex=121/> <!-- class="disabledButton" -->  
		    </td>
		</tr>
		<tr id="rowCMTag">
			<td class="rightAligned" style="width: 100px;"></td>
			<td class="leftAligned" style="width: 250px;"> 
				<input type="checkbox" id="cmTag" style="width: 10px;"/>
				Auto-Generate RCM
			</td>
		</tr>
	</table>
	<div style="margin-top: 10px; height: 30px;">
		<input style="float: left; margin-left: 250px;" type="button" id="btnAdd" name="btnAdd " class="button cancelORBtn"  value="Add" tabindex=110/>
		<input style="float: left; margin-left: 4px;" type="button"  id="btnDelete" name="btnDelete"	class="disabledButton cancelORBtn" value="Delete" tabindex=111/>
	</div>	
</div>
<div id="outwardFaculButtonsDiv" class="buttonsDiv" style="float:left; width: 100%;">			
	<input type="button" style="width: 70px; margin-left: 35px;" id="btnCancel" name="btnCancel"	class="button" value="Cancel" tabindex=122/>
	<input type="button" style="width: 70px;" id="btnSave" name="btnSave" class="button cancelORBtn" value="Save" tabindex=123/>
</div> 

<script>
	try {
		setModuleId("GIACS019");
		setDocumentTitle("Outward Facultative Premium Payments");
		initializeAll();
		objAC.hidObjGIACS019 = {};
		objAC.isValid = false;
		objAC.tempObj = null;
		objAC.tempDisbursementAmt = null;
		objAC.wsDisbursementAmt = null;
		objAC.overideOk = validateUserFunc2("OD", "GIACS019");
		objAC.overrideDef = "N";
		objAC.autoGenerateRCM = '${autoGenerateRCM}';
		var validateAmount=false;
		var recStatus=2;
		var objTranType = JSON.parse('${tranTypeListJSON}'.replace(/\\/g, '\\\\'));
		var amtTotal =0;
		var selectedOrPrintTag = "";
		var selectedIndex = -1;
		$("amtTotal").value = formatCurrency('${totalAmt}').truncate(13, "...");
		var objGIACS019 = {};
		objGIACS019.exitPage = null;
		objGIACS019.logoutPage = null;
		objGIACS019.savePage = null;
		
		populateTranTypeDtls(objTranType, 0);
	}catch (e) {
		showErrorMessage("Intialize",e);
	}
	
	if(objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ"){ //added DISB_REQ by robert SR 5276 01.26.16
		$("rowCMTag").show();
		$("cmTag").checked = (nvl(objAC.autoGenerateRCM, "N") == "Y") ? true : false;
	}else{
		$("rowCMTag").hide();
		$("cmTag").checked = false;
	}
	
	try{
		var outFaculPremPaytsArray =[];
		var objOutFaculPremPayts = new Object();
		objOutFaculPremPayts.objOutFaculPremPaytsTableGrid = JSON.parse('${objOutFaculPremPayts}'.replace(/\\/g, '\\\\'));
		objOutFaculPremPayts.outFaculPremPayts = objOutFaculPremPayts.objOutFaculPremPaytsTableGrid.rows || [];
		var tableModel = {
			url: contextPath+"/GIACOutFaculPremPaytsController?action=showOutFaculPremPaytsTableGrid&gaccTranId="+objACGlobal.gaccTranId,
			options:{
				hideColumnChildTitle: true,
				title: '',
				height: '285px',
				onCellFocus: function(element, value, x, y, id) {
					objAC.tempObj = null;
					objAC.isValid = true;
					selectedIndex = y;
					var obj = outFaculPremPaytsTableGrid.geniisysRows[y];
					recStatus=obj.recordStatus;
					populateOutFaculPremPayts(obj);
					selectedOrPrintTag=obj.orPrintTag;
					formatAppearance("show",obj.recordStatus);
					outFaculPremPaytsTableGrid.keys.releaseKeys();
				},
				onCellBlur: function(element, value, x, y, id) {
					if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){
						observeChangeTagInTableGrid(outFaculPremPaytsTableGrid);
					}
				},
				onRemoveRowFocus: function() {
					selectedOrPrintTag="";
					selectedIndex = -1;
					formatAppearance("hide");
					outFaculPremPaytsTableGrid.keys.releaseKeys();
				},
				onSort: function(){
					selectedOrPrintTag="";
					selectedIndex = -1;
					formatAppearance("hide");
					outFaculPremPaytsTableGrid.keys.releaseKeys();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveOutFaculPremPayts();
								}, function(){
									outFaculPremPaytsTableGrid.refresh();
									changeTag = 0;
								}, "");
						return false;
					}else{
						return true;
					}
				},
				postPager: function () {
					selectedOrPrintTag="";
					selectedIndex = -1;
					formatAppearance("hide");
					outFaculPremPaytsTableGrid.keys.releaseKeys();
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN ],
					onRefresh: function(){
						selectedOrPrintTag="";
						selectedIndex = -1;
						formatAppearance("hide");
						outFaculPremPaytsTableGrid.keys.releaseKeys();
					},
					onFilter: function(){
						selectedOrPrintTag="";
						selectedIndex = -1;
						formatAppearance("hide");
						outFaculPremPaytsTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
			    {	id: 'recordStatus', 	
	 			    title: '',
	 			    width: '0',
	 			   	visible: false,
				    editor: 'checkbox' 					
			    },
			    {	id: 'divCtrId',
					width: '0',
					visible: false
			    },
			    {
					id: 'tranType',
					title: 'Transaction Type',
					width: '150px',
					titleAlign: 'right',
					filterOption: true,	
					align: 'right'
			    },
			    { 	
			    	id: 'riName',
			    	title: 'Reinsurer',
					width: '350px',
					filterOption: true,	
					align: 'left'
			    },
			    
			    {
			    	id:'lineCd binderYY binderSeqNo',
			    	title: 'Binder No.',
			    	width: 180,
			    	children: [
			    	   	    {	id: 'lineCd',
			    	   	    	title: 'Line Code',
						    	width: 50,
						    	filterOption: true,	
						    	align: 'left'
						    },
						    {	id: 'binderYY',
						    	title: 'Binder Year',
						    	width: 50,
						    	align: 'right',
						    	filterOption: true,	
						    	filterOptionType: 'integerNoNegative',
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						    	}
						    },
						    {	id: 'binderSeqNo',
						    	title: 'Binder Seq. No.',
						    	width: 80,
						    	align: 'right',
						    	filterOption: true,	
						    	filterOptionType: 'integerNoNegative',
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),5);
						    	}
						    }
			    	          ]
			    },
			    { 	
			    	id: 'disbursementAmt',
			    	title: 'Amount',
					//width: '160px', replaced by: Nica 06.10.2013
					width: objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ" ? '140px' : '160px', //added DISB_REQ by robert SR 5276 01.26.16
					align: 'right',
					titleAlign: 'right',
					renderer: function(value){
			    		return nvl(value,'') == '' ? '' : formatCurrency(nvl(value, 0));
			    	}
			    },
			    {	id : 'cmTag', // column added by: Nica to display cmTag if objACGlobal.tranSource == "DV"
			    	title: '&#160;',
			    	align: 'center',
			    	altTitle: 'Auto-Generate RCM',
			    	titleAlign: 'center',
			    	width: objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ" ? '20px' : '0px', //added DISB_REQ by robert SR 5276 01.26.16
			    	maxlength: 1, 
			    	sortable: false,
			    	editable: false,
			    	hideSelectAllBox: true,
			    	otherValue: false,
			    	visible: objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ" ? true : false, //added DISB_REQ by robert SR 5276 01.26.16
			    	editor: new MyTableGrid.CellCheckbox({ 
			    		getValueOf: function(value){
			    			if (value){
			    				return "Y";
			    			}else{
			    				return "N";	
			    			}	
			    		}
			    	}),	
			    },
				{
					id : 'policyNo',
					width: '0',
					visible:false
				},
				{
					id: 'assdName',
					width: '0',
					visible: false 
				},
				{
					id: 'remarks',
					width: '0',
					visible: false 
				},
				{
					id: 'message',
					width: '0',
					visible: false 
				},
				{
					id: 'binderId',
					width: '0',
					visible: false 
				},
				{
					id: 'premAmt',
					width: '0',
					visible: false 
				},
				{
					id: 'premVat',
					width: '0',
					visible: false 
				},
				{
					id: 'commAmt',
					width: '0',
					visible: false 
				},
				{
					id: 'commVat',
					width: '0',
					visible: false 
				},
				{
					id: 'wholdingTax',
					width: '0',
					visible: false 
				},
				{
					id: 'currencyCd',
					width: '0',
					visible: false 
				},
				{
					id: 'currencyRt',
					width: '0',
					visible: false 
				},
				{
					id: 'assdNo',
					width: '0',
					visible: false 
				},
				{
					id: 'issCd',
					width: '0',
					visible: false 
				},
				{
					id: 'currencyDesc',
					width: '0',
					visible: false 
				},
				{
					id: 'riCd',
					width: '0',
					visible: false 
				},
				{
					id: 'policyId',
					width: '0',
					visible: false 
				},
				{
					id: 'premVat',
					width: '0',
					visible: false 
				},
				{
					id: 'endtType',
					width: '0',
					visible: false 
				},
				{
					id: 'premSeqNo',
					width: '0',
					visible: false 
				}	,
				{
					id: 'paytGaccTranId',	// SR-19631 : shan 08.17.2015
					width: '0',
					visible: false 
				}	
				
			],
			rows: objOutFaculPremPayts.outFaculPremPayts
		};

		outFaculPremPaytsTableGrid = new MyTableGrid(tableModel);
		outFaculPremPaytsTableGrid.pager = objOutFaculPremPayts.objOutFaculPremPaytsTableGrid;
		outFaculPremPaytsTableGrid.render('outFaculPremPaytsTableGrid');
		outFaculPremPaytsTableGrid.afterRender = function(){
														outFaculPremPaytsArray=outFaculPremPaytsTableGrid.geniisysRows;
														amtTotal = 0;
														if(outFaculPremPaytsArray.length != 0){
															amtTotal=outFaculPremPaytsArray[0].totalAmt;
														}
														$("amtTotal").value = formatCurrency(amtTotal).truncate(13, "...");
							  						};
	}catch (e) {
		showErrorMessage("OutFaculPremPaytsTableGrid",e);
	}	
	
	function formatAppearance(param,obj) {
		try{
			if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objAC.tranFlagState == "D" || objACGlobal.queryOnly == "Y"){ //added by steven 12.10.2013; objAC.tranFlagState == "D"
				disableGIACS019();
				if(param =="show"){
					enableButton("breakdown");
					enableButton("currInformation");
					enableButton("binderBtn");
					//enableButton("outfaculList");
					$("btnAdd").value = "Update";
				}else if(param =="hide"){
					populateOutFaculPremPayts(null);
					disableButton("breakdown");
					disableButton("currInformation");
					disableButton("binderBtn");
					//disableButton("outfaculList");
					$("btnAdd").value="Add";
				}
			} else {
				if(param =="show"){
					enableButton("btnDelete");
// 					enableButton("breakdown");
// 					enableButton("currInformation");
// 					enableButton("binderBtn");
// 					enableButton("outfaculList");
					if (obj===""){
						enableDisableAllFields("disable");
						disableSearch("oscmBinderNo");
						disableSearch("oscmReinsurer");
					}else/*  if (obj === 0 || obj === 1) */{
						enableDisableAllFields("enable");
						enableSearch("oscmBinderNo");
						enableSearch("oscmReinsurer");
						enableButton("revertBtn");
					}
					enableButton("binderBtn");
					//enableButton("outfaculList");
					$("btnAdd").value = "Update";
				}else{
					disableButton("btnDelete");
					disableButton("breakdown");
					disableButton("currInformation");
					//disableButton("outfaculList");
					disableButton("overrideDefBtn");
					disableButton("revertBtn");
					$("btnAdd").value="Add";
					recStatus=2;
					enableSearch("oscmReinsurer");
					enableSearch("oscmBinderNo");
					populateOutFaculPremPayts(null);
					enableDisableAllFields("enable");
				}
			}
		}catch (e) {
			showErrorMessage("formatAppearance",e);
		}
	}
	
	objAC.hidObjGIACS019.formatAppearance = formatAppearance;
	
	function enableDisableAllFields(param){
		if (param == "disable"){
			$("tranType").disabled = true;
			$("reinsurer").disabled = true;
			$("faculPremLineCd").disabled = true;
			$("faculPremBinderYY").disabled = true;
			$("binderSeqNo").disabled = true;
			$("amount").disabled = true;
			$("remarks").readOnly = true;
			$("cmTag").disabled = true;
			disableButton("btnAdd");
			disableButton("binderBtn");
// 			disableButton("overideUserBtn");
			disableButton("revertBtn");
			disableButton("overrideDefBtn");
			
		}else{
			$("tranType").disabled = false;
			$("reinsurer").disabled = false;
			$("faculPremLineCd").disabled = false;
			$("faculPremBinderYY").disabled = false;
			$("binderSeqNo").disabled = false;
			$("amount").disabled = false;
			$("remarks").readOnly = false;
			$("cmTag").disabled = false;
			enableButton("btnAdd");

		}
	}
	
	function populateOutFaculPremPayts(obj) {
		try{
			$("tranType").value  			= (obj) == null ? "" : (nvl(obj.tranType,""));
			$("reinsurer").value  			= (obj) == null ? "" : unescapeHTML2(nvl(obj.riName,""));
			$("assuredName").value  		= (obj) == null ? "" : unescapeHTML2(nvl(obj.assdName,""));
			$("policyNo").value  			= (obj) == null ? "" : (nvl(obj.policyNo,""));
			$("remarks").value  			= (obj) == null ? "" : unescapeHTML2((nvl(obj.remarks,"")));
			$("amount").value 				= (obj) == null ? "" : formatCurrency(nvl(obj.disbursementAmt,0));
			$("faculPremLineCd").value  	= (obj) == null ? "" : (nvl(obj.lineCd,""));
			$("faculPremBinderYY").value  	= (obj) == null ? "" : formatNumberDigits(nvl(obj.binderYY,0),2);
			$("binderSeqNo").value  		= (obj) == null ? "" : formatNumberDigits(nvl(obj.binderSeqNo,0),5);
			$("hiddenBinderId").value  		= (obj) == null ? "" : (nvl(obj.binderId,""));
			$("hiddenAssdNo").value  		= (obj) == null ? "" : (nvl(obj.assdNo,""));
			$("hiddenConvertRate").value  	= (obj) == null ? "" : (nvl(obj.currencyRt,""));
			$("hiddenPolicyId").value  		= (obj) == null ? "" : (nvl(obj.policyId,""));
			$("hiddenRiCd").value			= (obj) == null ? "" : (nvl(obj.riCd,""));
			$("hiddenPremAmt").value		= (obj) == null ? "" : (nvl(obj.premAmt,0));
			$("hiddenPremVat").value		= (obj) == null ? "" : (nvl(obj.premVat,0));
			$("hiddenCommAmt").value		= (obj) == null ? "" : (nvl(obj.commAmt,0));			
			$("hiddenCommVat").value		= (obj) == null ? "" : (nvl(obj.commVat,0));
			$("hiddenwHoldingTax").value	= (obj) == null ? "" : (nvl(obj.wholdingTax,0));	
			$("hiddenCurrencyCd").value		= (obj) == null ? "" : (nvl(obj.currencyCd,0));
			$("hiddenCurrencyRt").value		= (obj) == null ? "" : (nvl(obj.currencyRt,0));
			$("hiddenCurrencyRt").value		= (obj) == null ? "" : (nvl(obj.currencyRt,0));
			$("hiddenCurrencyDesc").value	= (obj) == null ? "" : (nvl(obj.currencyDesc,""));
			$("hiddenForeignCurrAmt").value	= (obj) == null ? "" : (nvl(obj.disbursementAmt,0)) / (nvl(obj.currencyRt,0));
			$("hiddenBinderId2").value		= (obj) == null ? "" : (nvl(obj.binderId,""));
			$("hiddenRecStatus").value		= (obj) == null ? "" : (nvl(obj.recordStatus,""));
			objAC.tempDisbursementAmt		= (obj) == null ? "" : (nvl(obj.disbursementAmt,0));
			$("hiddenPaytGaccTranId").value	= (obj) == null ? "" : (nvl(obj.paytGaccTranId,"")); // SR-9631 : shan 08.17.2015
			$("hiddenRecordNo").value		= (obj) == null ? "" : (nvl(obj.recordNo,"0")); // SR-9631 : shan 08.17.2015
			
			if(obj == null){ // added by: Nica 06.10.2013
				if((nvl(objAC.autoGenerateRCM, "N") == "Y") && (objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ" )){ //added DISB_REQ by robert SR 5276 01.26.16
					$("cmTag").checked = true;
				}else{
					$("cmTag").checked = false;
				}
			}else{
				$("cmTag").checked = nvl(obj.cmTag, "N") == "Y" ? true : false;	
			}
			
			(obj == null) ? disableButton("breakdown") : enableButton("breakdown");	// SR-9631 : shan 08.17.2015
			(obj == null) ? disableButton("currInformation") : enableButton("currInformation");	// SR-9631 : shan 08.17.2015
			
		}catch(e){
			showErrorMessage("populateOutFaculPremPayts",e);
		}	
	}
	
	function populateTranTypeDtls(obj, value){
		try{
			$("tranType").update('<option value="" tranTypeCode="" tranTypeDesc=""></option>');
			var options = "";
			for(var i=0; i<obj.length; i++){						
				options+= '<option value="'+obj[i].rvLowValue+'" tranTypeCode="'+obj[i].rvLowValue+'" tranTypeDesc="'+obj[i].rvMeaning+'">'+obj[i].rvLowValue +' - ' + obj[i].rvMeaning+'</option>';
			}
			$("tranType").insert({bottom: options}); 
			$("tranType").selectedIndex = value;
		}catch (e) {
			showErrorMessage("populateTranTypeDtls",e);
		}
	}
	
	function getBinderDtls(){
		if ($("tranType").selectedIndex > 0) {
			if ($("hiddenRiCd").value > 0){
				if (recStatus !== ""){
					openSearchBinderModal();
				}else{
					showMessageBox("You cannot update this record.", imgMessage.ERROR);
				}
			}else{
				showMessageBox("RI code does not exist.", imgMessage.ERROR);
			}
		}else{
			showMessageBox("Please select transaction type first.", imgMessage.ERROR);
		}
	}
	
	function getNextRecordNo(){ // SR-19631 : shan 08.19.2015
		var recNo = 0;
		if ($F("tranType") == 2 || $F("tranType") == 4){
			var rows = outFaculPremPaytsTableGrid.geniisysRows.filter(function(obj){return ((obj.tranType == 2 || obj.tranType == 4) && obj.recordStatus != -1);});
			recNo = rows.length + 1;
		}
		
		return recNo;
	}
	
	function setOutFaculPremPayts(){
		try{
			var obj = new Object();
			obj.gaccTranId 		= objACGlobal.gaccTranId;
			obj.tranType 		= objAC.hidObjGIACS019.tranType == null ? $F("tranType") : objAC.hidObjGIACS019.tranType;
			obj.riName			= objAC.hidObjGIACS019.riName == null ? $F("reinsurer"):  objAC.hidObjGIACS019.riName;
			obj.riCd			= objAC.hidObjGIACS019.riCd == null ?  $F("hiddenRiCd"):objAC.hidObjGIACS019.riCd;
			obj.binderId 		= $F("hiddenBinderId");
			obj.binderId2 		= $F("hiddenBinderId2");
			obj.lineCd   		= $F("faculPremLineCd");
			obj.binderYY 		= $F("faculPremBinderYY");
			obj.binderSeqNo 	= $F("binderSeqNo");
			obj.assdName		= $F("assuredName");
			obj.assdNo 			= $F("hiddenAssdNo");
			obj.policyNo 		= $F("policyNo");
			obj.remarks  		= $F("remarks");	
			obj.disbursementAmt = unformatCurrency("amount");
			obj.premAmt 		= $F("hiddenPremAmt");
			obj.premVat			= $F("hiddenPremVat");
			obj.commAmt 		= $F("hiddenCommAmt");
			obj.commVat 		= $F("hiddenCommVat");
			obj.wholdingTax  	= $F("hiddenwHoldingTax");	
			obj.currencyCd 		= $("hiddenCurrencyCd").value;
			obj.currencyRt 		= $("hiddenCurrencyRt").value;
			obj.convertRt 		= $("hiddenCurrencyRt").value;
			obj.currencyDesc 	= $("hiddenCurrencyDesc").value;
			obj.foreignCurrAmt 	= $("hiddenForeignCurrAmt").value;
			obj.orPrintTag 		= "N";
			obj.cmTag			= $("cmTag").checked ? "Y" : "N";
			obj.paytGaccTranId 	= $F("hiddenPaytGaccTranId"); // SR-19631 : shan 08.17.2015
			obj.recordNo 		= nvl($F("hiddenRecordNo"), getNextRecordNo()) ; // SR-19631 : shan 08.17.2015
			
			return obj;
		}catch(e){
			showErrorMessage("setOutFaculPremPayts",e);
		}	
	}

	function computeTotalAmountInTable(disbursementAmt) {
		try {
			var total=unformatCurrency("amtTotal");
					total =parseFloat(total) + (parseFloat(disbursementAmt));
			$("amtTotal").value = formatCurrency(total).truncate(13, "...");
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}

	function checkIfBinderExistInList(binderId){
		var exists = false;
		if(binderId != null){
				for(var i=0; i<outFaculPremPaytsArray.length; i++){
					if(($F("tranType") == 1 || $F("tranType") == 3) && // SR-19631 : shan 08.17.2015
							binderId == outFaculPremPaytsArray[i].binderId && outFaculPremPaytsArray[i].recordStatus != -1){
						exists = true;
					}
				}
				if(!exists){
					new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=checkIfBinderExistInList&binderId="+binderId+"&gaccTranId="+objACGlobal.gaccTranId + "&moduleId=GIACS019", { 
						method: "GET",
						evalscripts: true,
						asynchronous: true,
						onComplete: function (response){
							if (response.responseText=='Y') {
								exists = true;
							}
						}
					});
				}
			if (exists){
				showMessageBox("Record already exist with the same Reinsurer and Binder No.", imgMessage.ERROR);
			}
		}else{
			exists = true;
			showMessageBox("Record already exist with the same Reinsurer and Binder No.", imgMessage.ERROR);
		}
		return exists;
	}
	
	objAC.hidObjGIACS019.checkIfBinderExistInList = checkIfBinderExistInList;
	
	//to add records
	function addOutFaculPremPayts(){  
		try{
			if (objACGlobal.orStatus !="CANCELLED"){
				var newObj  = setOutFaculPremPayts();
				if ($F("btnAdd") == "Update"){
					//on UPDATE records
					for(var i = 0; i<outFaculPremPaytsArray.length; i++){
						if ((outFaculPremPaytsArray[i].binderId == newObj.binderId2)&&(outFaculPremPaytsArray[i].recordStatus != -1)
								&&(outFaculPremPaytsArray[i].recordNo == newObj.recordNo)){	// SR-19631 : shan 08.19.2015
							computeTotalAmountInTable(parseFloat(newObj.disbursementAmt)-parseFloat(outFaculPremPaytsArray[i].disbursementAmt));
							newObj.recordStatus = 1;
							outFaculPremPaytsArray.splice(i, 1, newObj);
							outFaculPremPaytsTableGrid.updateVisibleRowOnly(newObj, outFaculPremPaytsTableGrid.getCurrentPosition()[1], false);	// SR-19631 : shan 08.19.2015
						}
					}
				}else{
					//on ADD records
					newObj.recordStatus = 0;
					computeTotalAmountInTable(newObj.disbursementAmt);
					outFaculPremPaytsArray.push(newObj);
					outFaculPremPaytsTableGrid.addBottomRow(newObj);
				}
				enableButton("revertBtn");
				changeTag = 1;
			}else{
				showMessageBox("Form Running in query-only mode. Cannot change database fields.", imgMessage.ERROR);
			}
				formatAppearance("hide");
		}catch(e){
			showErrorMessage("addOutFaculPremPayts", e);
		}
	}
	
	objAC.hidObjGIACS019.addOutFaculPremPayts = addOutFaculPremPayts;
	
// 	function to delete record
	function deleteOutFaculPremPayts(){
		try{
			if (objACGlobal.orStatus !="CANCELLED"){
				if (selectedOrPrintTag==="Y"){
					showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
				}else{
					var delObj  = setOutFaculPremPayts();
					for(var i = 0; i<outFaculPremPaytsArray.length; i++){
						if ((outFaculPremPaytsArray[i].binderId == delObj.binderId2)&&(outFaculPremPaytsArray[i].recordStatus != -1)
								&&(outFaculPremPaytsArray[i].recordNo == delObj.recordNo)){	// SR-19631 : shan 08.19.2015
							delObj.recordStatus = -1;
							computeTotalAmountInTable(-1*parseFloat(delObj.disbursementAmt));
							outFaculPremPaytsArray.splice(i, 1, delObj);
							outFaculPremPaytsTableGrid.deleteRow(outFaculPremPaytsTableGrid.getCurrentPosition()[1]);
							formatAppearance("hide");
							changeTag = 1;
						}
					}
				}
			}else{
				showMessageBox("Form Running in query-only mode. Cannot change database fields.", imgMessage.ERROR);
			}
			formatAppearance("hide");
		} catch(e){
			showErrorMessage("deleteOutFaculPremPayts", e);
		}
	}
	
	//to save the record
	function saveOutFaculPremPayts() {
		try{
			if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS019")){ //marco - SR-5723 - 02.20.2017
				return;
			}
			
			var objParameters = new Object();
			objParameters.setOutFaculPremPayt = getAddedAndModifiedJSONObjects(outFaculPremPaytsArray);
			objParameters.delOutFaculPremPayt  = getDeletedJSONObjects(outFaculPremPaytsArray);
			
			new Ajax.Request(contextPath+"/GIACOutFaculPremPaytsController?action=saveOutFaculPremPayts",{
				method: "POST",
				asynchronous: true,
				parameters:{
					param: JSON.stringify(objParameters),
					gaccTranId: objACGlobal.gaccTranId,
					branchCd: objACGlobal.branchCd,
					fundCd: objACGlobal.fundCd,
					tranSource: objACGlobal.tranSource,
					orFlag: objACGlobal.orFlag
				},
				onCreate: function(){
					showNotice("Saving information, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIACS019.exitPage != null) {
								if(objACGlobal.previousModule ==  'GIACS016'){
									objGIACS019.exitPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
								}else{
									objGIACS019.exitPage();
								}
							} else if(objGIACS019.logoutPage != null){
								outFaculPremPaytsTableGrid.refresh();
							}else if(objGIACS019.savePage != null){
								outFaculPremPaytsTableGrid.refresh();
							}else {
								lastAction();
								lastAction = "";
							}
						});
						changeTag = 0;
					}	
				}
			});
		}catch (e) {
			showErrorMessage("saveOutFaculPremPayts",e);
		}
	} 

	function openSearchBinderModal() {
		try{
			var notIn = "";
			var withPrevious = false;
			for(var i=0; i<outFaculPremPaytsArray.length; i++) {
				if (outFaculPremPaytsArray[i].recordStatus != -1){
					if(withPrevious) notIn += ",";
					if ($F("tranType") == 1 || $F("tranType") == 3){	// SR-19631 : shan 08.24.2015
						notIn += outFaculPremPaytsArray[i].binderId;
					}else{
						notIn += nvl(outFaculPremPaytsArray[i].binderId + outFaculPremPaytsArray[i].paytGaccTranId, ''); //EDITED by MarkS 04/05/2017 SR23893
					}
					//withPrevious = true;
					withPrevious = notIn != '' ? true : false; //added condition by robert SR 5276 01.26.16
				}
			}
			notIn = (notIn != "" ? "("+notIn+")" : "");
			objAC.hidObjGIACS019.notIn=notIn;
			var lineCd = $F("faculPremLineCd");	// added by shan 09.09.2014
			if (objACGlobal.previousModule == 'GIACS016'){
				lineCd = (lineCd.trim() == "" || lineCd == objGIACS002.lineCd ? objGIACS002.lineCd : $F("faculPremLineCd"));
			}
			overlaySearchBinder = Overlay.show(contextPath+"/GIACOutFaculPremPaytsController?action=openSearchBinderModal2&ajaxModal=1&tranType="
														  + $("tranType").options[$("tranType").selectedIndex].value+ "&riCd=" + $F("hiddenRiCd") + "&lineCd="
														  + /*$F("faculPremLineCd")*/ lineCd + "&binderYY=" + $F("faculPremBinderYY") + "&gaccTranId=" + objACGlobal.gaccTranId 
														  + "&moduleId=" + "GIACS019&notIn="+notIn, 
					{urlContent: true,
					 title: "Search Binder No.",
					 height: 420,
					 width: 680,
					 draggable: true,
					 showNotice: true
					});
		}catch (e) {
			showErrorMessage("openSearchBinderModal",e);
		}
	}

	function validateBinderNo(title2,id2,idName2,exception){
		try{
			if($F("hiddenRiCd")!= ""){
				if(validateInput(idName2,exception)){
					if($F("faculPremLineCd") != "" && $F("faculPremBinderYY") == "" && $F("binderSeqNo") == ""){
						validateBinderNo2(title2,id2,idName2,$F("faculPremLineCd"),"","");
					}else if($F("faculPremLineCd") != "" && $F("faculPremBinderYY") != "" && $F("binderSeqNo") == ""){
						validateBinderNo2(title2,id2,idName2,$F("faculPremLineCd"), $F("faculPremBinderYY"),"");
					}else if($F("faculPremLineCd") == "" && $F("faculPremBinderYY") != "" && $F("binderSeqNo") == ""){
						validateBinderNo2(title2,id2,idName2,"",$F("faculPremBinderYY"),"");
					}else if($F("faculPremLineCd") == "" && $F("faculPremBinderYY") != "" && $F("binderSeqNo") != ""){
						validateBinderNo2(title2,id2,idName2,"",$F("faculPremBinderYY"),$F("binderSeqNo"));
					}else if($F("faculPremLineCd") == "" && $F("faculPremBinderYY") == "" && $F("binderSeqNo") != ""){
						validateBinderNo2(title2,id2,idName2,"","",$F("binderSeqNo"));
					}else if($F("faculPremLineCd") != "" && $F("faculPremBinderYY") == "" && $F("binderSeqNo") != ""){
						validateBinderNo2(title2,id2,idName2,$F("faculPremLineCd"),"",$F("binderSeqNo"));
					}else if ($F("faculPremLineCd") != "" && $F("faculPremBinderYY") != "" && $F("binderSeqNo") != ""){
						validateBinderNoAndPopulate(title2,id2,idName2);
					}
				}else{
					$("assuredName").clear();
					$("policyNo").clear();
					$("remarks").clear();
					$("amount").clear();
					if (idName2 == "faculPremBinderYY") {
						$("faculPremBinderYY").clear();
						showMessageBox("Invalid Binder Year. Valid value should be from 00 to 99.", imgMessage.ERROR);
					} else if(idName2 == "binderSeqNo") {
						$("binderSeqNo").clear();
						showMessageBox("Invalid Binder Seq. No. Valid value should be from 1 to 99999.", imgMessage.ERROR);
					}
				}
			}else{
				$("assuredName").clear();
				$("policyNo").clear();
				$("remarks").clear();
				$("amount").clear();
				$("faculPremLineCd").clear();
				$("faculPremBinderYY").clear();
				$("binderSeqNo").clear();
				showMessageBox("RI code does not exist.", imgMessage.ERROR);
			}
		}catch (e) {
			showErrorMessage("validateBinderNo",e);
		}
	}
	
	function populateOutFaculPremPaytsManually() {
		try{
			var lineCd = $F("faculPremLineCd");	// added by shan 09.09.2014
			
			if (objACGlobal.previousModule == 'GIACS016' && lineCd != objGIACS002.lineCd && objAC.tempObj.length > 1){	// added condition : shan 09.09.2014
				openSearchBinderModal();
			}else{				
				if (objAC.tempObj[0].message != null && objAC.tempObj[0].message == "RI premium payment transaction related to this invoice is still open."){ // SR-19631 : shan 08.24.2015
					showWaitingMessageBox(objAC.tempObj[0].message, "I");
				}else if (objAC.tempObj[0].message != null && objAC.tempObj[0].message != "There is still no premium payment for this policy. "){ //added by steven 10.30.2013
					showWaitingMessageBox(objAC.tempObj[0].message+" Will now override default computation.", "I",function(){
						$("hiddenBinderId").value		=	objAC.tempObj[0].binderId;
						$("faculPremLineCd").value		=	objAC.tempObj[0].lineCd;
						$("faculPremBinderYY").value	=	objAC.tempObj[0].binderYY;
						$("binderSeqNo").value			=	objAC.tempObj[0].binderSeqNo;
						$("amount").value				=	formatCurrency((objAC.tempObj[0].currencyRt)*(objAC.tempObj[0].disbursementAmt));
						$("assuredName").value			=	objAC.tempObj[0].assdName;
						$("hiddenAssdNo").value			=	objAC.tempObj[0].assdNo;
						$("policyNo").value				=	objAC.tempObj[0].policyNo;
						$("remarks").value				=	objAC.tempObj[0].remarks;
						$("hiddenCurrencyCd").value		= 	objAC.tempObj[0].currencyCd;
						$("hiddenPremAmt").value		=	objAC.tempObj[0].premAmt;
						$("hiddenPremVat").value		=	objAC.tempObj[0].premVat;
						$("hiddenCommAmt").value		=	objAC.tempObj[0].commAmt;
						$("hiddenCommVat").value		=	objAC.tempObj[0].commVat;	
						$("hiddenwHoldingTax").value	=	objAC.tempObj[0].wholdingVat;
						$("hiddenCurrencyRt").value		= 	objAC.tempObj[0].currencyRt;
						$("hiddenCurrencyDesc").value	= 	objAC.tempObj[0].currencyDesc;
						$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / objAC.tempObj[0].currencyRt;
						objAC.tempDisbursementAmt		=	(objAC.tempObj[0].currencyRt)*(objAC.tempObj[0].disbursementAmt);
					});
				}else{
					$("hiddenBinderId").value		=	objAC.tempObj[0].binderId;
					$("faculPremLineCd").value		=	objAC.tempObj[0].lineCd;
					$("faculPremBinderYY").value	=	objAC.tempObj[0].binderYY;
					$("binderSeqNo").value			=	objAC.tempObj[0].binderSeqNo;
					$("amount").value				=	formatCurrency((objAC.tempObj[0].currencyRt)*(objAC.tempObj[0].disbursementAmt));
					$("assuredName").value			=	objAC.tempObj[0].assdName;
					$("hiddenAssdNo").value			=	objAC.tempObj[0].assdNo;
					$("policyNo").value				=	objAC.tempObj[0].policyNo;
					$("remarks").value				=	objAC.tempObj[0].remarks;
					$("hiddenCurrencyCd").value		= 	objAC.tempObj[0].currencyCd;
					$("hiddenPremAmt").value		=	objAC.tempObj[0].premAmt;
					$("hiddenPremVat").value		=	objAC.tempObj[0].premVat;
					$("hiddenCommAmt").value		=	objAC.tempObj[0].commAmt;
					$("hiddenCommVat").value		=	objAC.tempObj[0].commVat;	
					$("hiddenwHoldingTax").value	=	objAC.tempObj[0].wholdingVat;
					$("hiddenCurrencyRt").value		= 	objAC.tempObj[0].currencyRt;
					$("hiddenCurrencyDesc").value	= 	objAC.tempObj[0].currencyDesc;
					$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / objAC.tempObj[0].currencyRt;
					objAC.tempDisbursementAmt		=	(objAC.tempObj[0].currencyRt)*(objAC.tempObj[0].disbursementAmt);
				}
			}
		}catch(e){
			showErrorMessage("populateOutFaculPremPaytsManually", e);
		}
	}
	
	function populateOverrideManually(obj) {
		try{
			getOverrideDetails($F("tranType"),$F("hiddenRiCd"),objAC.tempObj[0].lineCd,objAC.tempObj[0].binderYY,objAC.tempObj[0].binderSeqNo);
			
/* 			var obj = getOverrideDetails($F("tranType"),$F("hiddenRiCd"),objAC.tempObj[0].lineCd,objAC.tempObj[0].binderYY,objAC.tempObj[0].binderSeqNo);
			$("hiddenBinderId").value		=	obj.binderId;
			$("faculPremLineCd").value		=	obj.lineCd;
			$("faculPremBinderYY").value	=	obj.binderYY;
			$("binderSeqNo").value			=	obj.binderSeqNo;
			$("amount").value				=	formatCurrency((obj.currencyRt)*(obj.disbursementAmt));
			$("assuredName").value			=	obj.assdName;
			$("hiddenAssdNo").value			=	obj.assdNo;
			$("policyNo").value				=	obj.policyNo;
			$("remarks").value				=	obj.remarks;
			$("hiddenCurrencyCd").value		= 	obj.currencyCd;
			$("hiddenPremAmt").value		=	obj.premAmt;
			$("hiddenPremVat").value		=	obj.premVat;
			$("hiddenCommAmt").value		=	obj.commAmt;
			$("hiddenCommVat").value		=	obj.commVat;	
			$("hiddenwHoldingTax").value	=	obj.wholdingVat;
			$("hiddenCurrencyRt").value		= 	obj.currencyRt;
			$("hiddenCurrencyDesc").value	= 	obj.currencyDesc;
			$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / obj.currencyRt;
			objAC.tempDisbursementAmt		=	(obj.currencyRt)*(obj.disbursementAmt); */
		}catch(e){
			showErrorMessage("populateOverrideManually", e);
		}
	}
	
	function validateBinderNoAndPopulate(title,id,idName){
		try{
			new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=validateBinderNo&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $F("hiddenRiCd") + "&lineCd=" + $F("faculPremLineCd") + "&binderYY=" + $F("faculPremBinderYY") + "&gaccTranId=" + objACGlobal.gaccTranId + "&moduleId=" + "GIACS019" + "&binderSeqNo=" + $F("binderSeqNo"), { 
				method: "GET",
				evalscripts: true,
				asynchronous: true,
				onComplete: function (response){
					var result = JSON.parse(response.responseText);
					if (result.length > 0) {
						objAC.tempObj = result;
						
						objAC.overideOk = validateUserFunc2("OD", "GIACS019");	// SR-19773 : shan 07.24.2015
						if (objAC.overideOk) {	// SR-19773 : shan 07.24.2015
							if (objAC.overrideDef == 'Y') {
								disableButton("overrideDefBtn");
								enableButton("revertBtn");
							} else {
								enableButton("overrideDefBtn");
								disableButton("revertBtn");
							}
						}else{
							disableButton("overrideDefBtn");
							disableButton("revertBtn");
						}
						
						if (result[0].disbursementAmt > 0 && ($F("tranType")==1||$F("tranType")==4)&&(result[0].message==="No collection has been made for this binder." || result[0].message===null || result[0].message==="")) {
							populateOutFaculPremPaytsManually();
						}else if(result[0].message === "There is still no premium payment for this policy. " &&  ($F("tranType")==1||$F("tranType")==4)){
							objAC.hidObjGIACS019.cond = 2;
							if (!objAC.overideOk){
								showConfirmBox("CONFIRMATION", "There is still no premium payment for this policy,Do you want to continue facultative premium payment?", "Yes","No", 
										function (){
											showConfirmBox("CONFIRMATION", "You are not allowed to process this transaction. However you can override by pressing OK button.", "OK","Cancel", 
													function (){
														objAC.hidObjGIACS019.override();
													},
													function (){
														formatAppearance("hide");
													});
										},
										function (){
											formatAppearance("hide");
										});
							}else{
								populateOverrideManually();
							}
						}else if((result[0].disbursementAmt <= 0 || result[0].message === "This Binder has been fully paid." || result[0].message === null)  && ($F("tranType")==1||$F("tranType")==4)){
							id.value="";
							$("assuredName").clear();
							$("policyNo").clear();
							$("remarks").clear();
							$("amount").clear();
							customShowMessageBox("This Binder has been fully paid.", imgMessage.INFO,idName);
						}else if(result[0].disbursementAmt < 0 && ($F("tranType")==2||$F("tranType")==3)){
							populateOutFaculPremPaytsManually();
						} else if (result[0].disbursementAmt == 0 && $F("tranType") == 3) { //Deo [01.27.2017]: SR-23187
							id.value="";
							$("assuredName").clear();
							$("policyNo").clear();
							$("remarks").clear();
							$("amount").clear();
							if (result[0].message == "Record already exist with the same Reinsurer and Binder No.") {
								customShowMessageBox(result[0].message, imgMessage.ERROR, idName);
							} else {
								customShowMessageBox("This Binder is already settled.", imgMessage.INFO, idName);
							}
						}else if(result[0].disbursementAmt >= 0 && ($F("tranType")==2||$F("tranType")==3)){
							id.value="";
							$("assuredName").clear();
							$("policyNo").clear();
							$("remarks").clear();
							$("amount").clear();
							customShowMessageBox("Positive amount for entered Binder No.", imgMessage.INFO,idName);
						}else{
							setOverrideButtons();
						}
					}else{
						/*id.value="";	
						$("assuredName").clear();
						$("policyNo").clear();
						$("remarks").clear();
						$("amount").clear();
						customShowMessageBox("This "+ title +" does not exist.", imgMessage.INFO,idName);*/	// moved inside validateManualBinderNo : shan 09.16.2014
						validateManualBinderNo(title,id,idName);
					}
				}
			});
		}catch(e){
			showErrorMessage("validateBinderNoAndPopulate", e);
		}
	}
	
	function validateManualBinderNo(title,id,idName){
		var overrideDef = ($F("btnAdd") == "Add" ? "N" : "Y");
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=validateBinderNo2&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $F("hiddenRiCd") + "&lineCd=" + $F("faculPremLineCd") + "&binderYY=" + $F("faculPremBinderYY") + "&overrideDef=" + overrideDef + "&binderSeqNo=" + $F("binderSeqNo"), { 
			method: "GET",
			evalscripts: true,
			asynchronous: true,
			onComplete: function (response){
				if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					var result = JSON.parse(response.responseText);
					
					if (result.message == "" || result.message == null){
						id.value="";	
						$("assuredName").clear();
						$("policyNo").clear();
						$("remarks").clear();
						$("amount").clear();
						customShowMessageBox("This "+ title +" does not exist.", imgMessage.INFO,idName);
					}else {
						var message = result.message.split("#");
						
						if (message[0] == "Y"){
							
						}else if (message[0] != ""){
							if ($F("tranType") == "1"){
								if (message[0] == "This binder has been fully paid."){
									if ($F("amount") != ""){
										$("amount").clear();
									}
									id.clear();
									customShowMessageBox(message[0], message[1], idName);
								}else if (result.userAccessFlag == "TRUE"){
									enableButton("revertBtn");
									id.clear();
									customShowMessageBox(message[0], message[1], idName);
								}else if (result.userAccessFlag == "FALSE"){
									if (message[0] == "There is still no premium payment for this policy,Do you want to continue facultative premium payment?"){
										objAC.hidObjGIACS019.cond = 2;
										if (!objAC.overideOk){
											showConfirmBox("CONFIRMATION", "There is still no premium payment for this policy,Do you want to continue facultative premium payment?", "Yes","No", 
													function (){
														showConfirmBox("CONFIRMATION", "You are not allowed to process this transaction. However you can override by pressing OK button.", "OK","Cancel", 
																function (){
																	objAC.hidObjGIACS019.override();
																},
																function (){
																	formatAppearance("hide");
																});
													},
													function (){
														formatAppearance("hide");
													});
										}else{
											populateOverrideManually();
										}
									}else{
										id.clear();
										customShowMessageBox(message[0], message[1], idName);
									}
								}
							}else if ($F("tranType") == "2"){
								if (result.userAccessFlag == "TRUE" && result.disbursementAmt < 0){
									enableButton("overrideDefBtn");
								}else{
									id.clear();
									customShowMessageBox(message[0], message[1], idName);
								}
							}else if ($F("tranType") == "3"){
								if (result.userAccessFlag == "TRUE"){
									result.disbursementAmt < 0 ? enableButton("overrideDefBtn") : enableButton("revertBtn");
								}
								id.clear();
								customShowMessageBox(message[0], message[1], idName);
							}else if ($F("tranType") == "4"){
								if (result.disbursementAmt > 0) enableButton("overrideDefBtn");
								id.clear();
								customShowMessageBox(message[0], message[1], idName);
							}
						}
					}	
				}
			}
		});
	}
	
	function validateBinderNo2(title,id,idName,lineCd,binderYY,binderSeqNo) {
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=validateBinderNo&tranType=" + $("tranType").options[$("tranType").selectedIndex].value + "&riCd=" + $F("hiddenRiCd") + "&lineCd=" + lineCd + "&binderYY=" + binderYY + "&gaccTranId=" + objACGlobal.gaccTranId + "&moduleId=" + "GIACS019" + "&binderSeqNo=" + binderSeqNo, { 
			method: "GET",
			evalscripts: true,
			asynchronous: true,
			onComplete: function (response){
				var result = JSON.parse(response.responseText.replace(/\\/g, '\\\\'));
				if (result.length > 0) {
					objAC.tempObj = result;
						setOverrideButtons();
				}else{
					/*id.value="";
					$("assuredName").clear();
					$("policyNo").clear();
					$("remarks").clear();
					$("amount").clear();
					customShowMessageBox("This "+ title +" does not exist.", imgMessage.INFO,idName);*/	// moved inside validateManualBinderNo : shan 09.16.2014
					validateManualBinderNo(title,id,idName);
				}
			}
		});
	}

	function getDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getDisbursementAmt", {
			method: "POST",
			parameters: {
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				riCd: $F("hiddenRiCd"),
				lineCd: $F("faculPremLineCd"),
				binderYY: $F("faculPremBinderYY"),
				binderId: $F("hiddenBinderId"),
				convertRate: $F("hiddenConvertRate"),
				binderSeqNo: $F("binderSeqNo"),
				policyId: $F("hiddenPolicyId"),
				allowDef: true,
				gaccTranId: objACGlobal.gaccTranId	//SR-19631 : shan 08.18.2015
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response){
				var disbursementAmt = response.responseText;
				objAC.wsDisbursementAmt = disbursementAmt;
				validateDisbursement();
			}
		});
	}

	function getOverrideDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getOverrideDisbursementAmt", {
			method: "POST",
			parameters: {
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				lineCd: $F("faculPremLineCd"),
				binderYY: $F("faculPremBinderYY"),
				binderId: $F("hiddenBinderId"),
				binderSeqNo: $F("binderSeqNo")
				},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var disbursement = response.responseText.toQueryParams();
				if (disbursement.message.length == 0){
					objAC.wsDisbursementAmt = disbursement.disbursementAmt;
					validateAmount=true;
				}else{
					showMessageBox(disbursement.message, imgMessage.INFO);
					validateAmount=false;
				}
				validateDisbursement();
			}
		});	
	}

	function getRevertDisbursementAmt(){
		new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getRevertDisbursementAmt", {
			method: "POST",
			parameters: {
				binderId: $F("hiddenBinderId"),
				tranType: $("tranType").options[$("tranType").selectedIndex].value,
				lineCd:  $F("faculPremLineCd"),
				gaccTranId: objACGlobal.gaccTranId,
				riCd: $F("hiddenRiCd")
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function (response) {
				var result = response.responseText;
				var disbursement = response.responseText.toQueryParams();
				if (disbursement.message.length == 0){
					objAC.wsDisbursementAmt = disbursement.disbursementAmt;
					validateAmount=true;
				}else{
					showMessageBox(disbursement.message, imgMessage.INFO);
					validateAmount=false;
				}
				validateDisbursement();
			}
		});
	}

	function validateDisbursement(){
		if (unformatCurrency("amount") == 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("No payment equal to zero(0) is accepted.", imgMessage.ERROR, "amount");
		}else if (($F("tranType") == 1 || $F("tranType") == 4) && unformatCurrency("amount") < 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("Please enter a positive amount for transaction type [1,4].", imgMessage.ERROR, "amount");
		}else if (($F("tranType") == 2 || $F("tranType") == 3) && unformatCurrency("amount") > 0) {
			$("amount").value = objAC.tempDisbursementAmt;
			customShowMessageBox("Please enter a negative amount for transaction type [2,3].", imgMessage.ERROR, "amount");
		}
		if (unformatCurrency("amount") != objAC.tempDisbursementAmt){
			if (Math.abs(unformatCurrency("amount")) > Math.abs(objAC.wsDisbursementAmt)){
				if ($F("tranType") == 1 || $F("tranType") == 4) {
					if (!objAC.overideOk){	// SR-19773 : shan 07.24.2015
						showMessageBox("Policy is partially paid and allowed facul premium payment is " +  formatCurrency(objAC.wsDisbursementAmt) + " only.", imgMessage.INFO);
						$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
	// 					showConfirmBox("CONFIRMATION", "Policy is partially paid and allowed facul premium payment is " +  formatCurrency(objAC.wsDisbursementAmt) + " only. Do you want to pay facul premium more than " + formatCurrency(objAC.wsDisbursementAmt) + "?", "Yes", "No", 
	// 							function (){
	// 								showConfirmBox("CONFIRMATION", "You are not allowed to process this transaction. However you can override by pressing OK button.", "OK","Cancel", 
	// 										function (){
	// 											override();
	// 											$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
	// 										},"");
	// 							},
	// 							function (){
	// 								$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
	// 							});
					}
				}else if ($F("tranType") == 2 || $F("tranType") == 3){
					showMessageBox("Entered amount must be greater than or equal to " + formatCurrency(objAC.wsDisbursementAmt), imgMessage.ERROR);
					$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
					if($F("btnAdd")=="Update"){
						setOverrideButtons();
					}
				}
			}
		}
		
		$("hiddenForeignCurrAmt").value = unformatCurrency("amount") / parseFloat($F("hiddenCurrencyRt"));
	}
	
	function validateInput(id,exception){
		var compVal = 0;
		if(exception){
			if (id == "faculPremBinderYY") {
				compVal = -1;
			} else if(id == "binderSeqNo") {
				compVal = 0;
			}
			if($(id).value <= compVal || isNaN($(id).value) || !checkDecimal($(id).value)){
				return false;
			}
		}
		return true;
	}
	
	function checkDecimal(val){
		for(var i = 0; i < val.length; i++){
			if (val.charAt(i)=='.'){
				  return false;
			}
		}
		return true;
	}
	
	var overrideUser = null;	// SR-19631 : shan 08.13.2015
	function override() {
		try {
			overrideUser = null;	// SR-19631 : shan 08.13.2015
			if (!objAC.overideOk){
				objAC.funcCode = "OD";
				showGenericOverride(
						"GIACS019",
						objAC.funcCode,
						function(ovr, userId, result){
							if(result == "TRUE"){
								overrideUser = userId;	// SR-19631 : shan 08.13.2015
								if(objAC.hidObjGIACS019.cond==1){	
									//objAC.hidObjGIACS019.cond=0;
									objAC.hidObjGIACS019.populateOverride();
								}else if(objAC.hidObjGIACS019.cond==2){
									//objAC.hidObjGIACS019.cond=0;
									populateOverrideManually();
								}

								enableButton("revertBtn");
								disableButton("overrideDefBtn");
								objAC.overideOk=true;
								ovr.close();
								delete ovr;
							}else if(result == "FALSE"){
								showMessageBox(userId + " is not allowed to Override Default.", imgMessage.ERROR);
								$("txtOverrideUserName").clear();
								$("txtOverridePassword").clear();
								return false;
						    }
						},
						function(){
							if(objAC.hidObjGIACS019.cond==1){		
								objAC.hidObjGIACS019.cond=0;
								tbgOutFaculPremPayts.keys.releaseKeys();
								formatAppearance("hide");
								overlaySearchBinder.close();
							}else if(objAC.hidObjGIACS019.cond==2){
								objAC.hidObjGIACS019.cond=0;
								formatAppearance("hide");
							}
						});
			}
		} catch(e){
			showErrorMessage("override", e);
		}
	}
	objAC.hidObjGIACS019.override = override;
	
	function getOverrideDetails(tranType,riCd,lineCd,binderYY,binderSeqNo) {
		try {
			var obj = null;
			new Ajax.Request(contextPath + "/GIACOutFaculPremPaytsController?action=getOverrideDetails", {
				method: "POST",
				parameters: {
					moduleName: "GIACS019",
					moduleId: "GIACS019",
					tranType: tranType,
					gaccTranId: objACGlobal.gaccTranId,
					riCd: riCd,
					lineCd: lineCd,
					binderYY: binderYY,
					binderSeqNo: binderSeqNo,
					overrideUser: overrideUser	// SR-19631 : shan 08.13.2015
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function (response) {
					try {
						obj =JSON.parse(response.responseText);

						$("hiddenBinderId").value		=	obj.binderId;
						$("faculPremLineCd").value		=	obj.lineCd;
						$("faculPremBinderYY").value	=	obj.binderYY;
						$("binderSeqNo").value			=	obj.binderSeqNo;
						$("assuredName").value			=	obj.assdName;
						$("hiddenAssdNo").value			=	obj.assdNo;
						$("policyNo").value				=	obj.policyNo;
						$("remarks").value				=	obj.remarks;	
						$("amount").value				=	obj.disbursementAmt * obj.currencyRt;
						$("hiddenCurrencyCd").value		= 	obj.currencyCd;
						$("hiddenPremAmt").value		=	obj.premAmt;
						$("hiddenPremVat").value		=	obj.premVat;
						$("hiddenCommAmt").value		=	obj.commAmt;
						$("hiddenCommVat").value		=	obj.commVat;	
						$("hiddenwHoldingTax").value	=	obj.wholdingVat;
						$("hiddenCurrencyRt").value		= 	obj.currencyRt;
						$("hiddenCurrencyDesc").value	= 	obj.currencyDesc;
						$("hiddenForeignCurrAmt").value	= 	unformatCurrency("amount") / obj.currencyRt;

						if(objAC.hidObjGIACS019.cond==1){								
							objAC.hidObjGIACS019.addOutFaculPremPayts();
							objAC.hidObjGIACS019.addedLovRecSize = objAC.hidObjGIACS019.addedLovRecSize + 1;
							
							if(objAC.hidObjGIACS019.selectedLovRecSize == objAC.hidObjGIACS019.addedLovRecSize) {
								objAC.hidObjGIACS019.cond=0;
								tbgOutFaculPremPayts.keys.releaseKeys();
								overlaySearchBinder.close();
							}
						}else if(objAC.hidObjGIACS019.cond==2){
							objAC.hidObjGIACS019.cond=0;
							objAC.tempDisbursementAmt		=	(obj.currencyRt)*(obj.disbursementAmt);
						}
					} catch(e){
						showErrorMessage("getOverrideDetails - onComplete", e);
					}
				}
			});		
		} catch(e){
			showErrorMessage("getOverrideDetails", e);
		}
	}
	
	objAC.hidObjGIACS019.getOverrideDetails = getOverrideDetails;
	/* OBSERVE ITEMS */
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						if(objACGlobal.previousModule ==  'GIACS016'){
							objGIACS019.exitPage = showDisbursementMainPage;
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							objGIACS019.exitPage = showGIACS070Page;
							objACGlobal.previousModule = null;
						}else{
							objGIACS019.exitPage = editORInformation;	
						}
						saveOutFaculPremPayts();
					}, function(){
						if(objACGlobal.previousModule ==  'GIACS016'){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.previousModule ==  'GIACS016'){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;
				
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else{
				editORInformation();	
			}
		}
	});
	
	$("btnCancel").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancel").observe("click",function(){
		fireEvent($("acExit"), "click");
	});
	/* $("btnCancel").observe("click", function () {
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveOutFaculPremPayts();
						if(objACGlobal.previousModule ==  'GIACS016'){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.previousModule ==  'GIACS016'){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.previousModule ==  'GIACS016'){
				showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
			}else if(objACGlobal.previousModule == "GIACS002"){
				showDisbursementVoucherPage(objGIACS002.cancelDV, "getDisbVoucherInfo");
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS003"){
				if (objACGlobal.hidObjGIACS003.isCancelJV == 'Y'){
					showJournalListing("showJournalEntries","getCancelJV","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}else{
					showJournalListing("showJournalEntries","getJournalEntries","GIACS003",objACGlobal.fundCd,objACGlobal.branchCd,objACGlobal.gaccTranId,null);
				}
				objACGlobal.previousModule = null;
				
			}else if(objACGlobal.previousModule == "GIACS071"){
				updateMemoInformation(objGIAC071.cancelFlag, objACGlobal.branchCd, objACGlobal.fundCd);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS149"){	//added by shan 08.08.2013
				showGIACS149Page(objGIACS149.intmNo, objGIACS149.gfunFundCd, objGIACS149.gibrBranchCd, objGIACS149.fromDate, objGIACS149.toDate, null);
				objACGlobal.previousModule = null;
			}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
				showGIACS070Page();
				objACGlobal.previousModule = null;
			}else{
				editORInformation();	
			}
		}
	}); */
	
	$("tranType").observe("change", function () {
		$("reinsurer").clear();
		$("hiddenRiCd").clear();
		$("assuredName").clear();
		$("policyNo").clear();
		$("remarks").clear();
		$("amount").clear();
		$("faculPremLineCd").clear();
		$("faculPremBinderYY").clear();
		$("binderSeqNo").clear();
	});
	
	$("reinsurer").observe("change", function () {
	});
	
	$("oscmBinderNo").observe("click", getBinderDtls);
	
	$("oscmReinsurer").observe("click", function () {
		if ($("tranType").selectedIndex > 0) {
			showReinsurerNamesLOV("GIACS019"); 
		}else{
			showMessageBox("Please select transaction type first.", imgMessage.ERROR);
		}
	});

	$("faculPremLineCd").observe("change", function (){
		validateBinderNo("Line Code",$("faculPremLineCd"),"faculPremLineCd",false);
	}); 
	
	$("faculPremLineCd").observe("keyup", function(){
		$("faculPremLineCd").value = $("faculPremLineCd").value.toUpperCase();
	});
	
	$("faculPremBinderYY").observe("change", function (){
			validateBinderNo("Binder Year",$("faculPremBinderYY"),"faculPremBinderYY",true);
	}); 
	
	$("binderSeqNo").observe("change", function (){
			validateBinderNo("Binder Seq. No.",$("binderSeqNo"),"binderSeqNo",true);
	}); 

	$("breakdown").observe("click", function () {
		if (selectedIndex < 0) {
			showMessageBox("Please select a record first.", "I");
		} else {
			showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=showBreakdown&lineCd=" + $F("faculPremLineCd") + "&riCd=" + $F("hiddenRiCd") + "&binderYY=" + $F("faculPremBinderYY") + "&binderSeqNo=" + $F("binderSeqNo") + "&disbursementAmt=" + unformatCurrency("amount") , "Breakdown", 350, "", 100);			
		}
	});

	$("btnAdd").observe("click", function () {
		if(checkAllRequiredFieldsInDiv("outwardFaculPremPaymtsDivMain")) {
			if($("hiddenBinderId").value == $("hiddenBinderId2").value){
				addOutFaculPremPayts();
				populateOutFaculPremPayts(null);
			}else if(!checkIfBinderExistInList($("hiddenBinderId").value)){
// 				if (objAC.tempObj[0].message != null && objAC.tempObj[0].message != "There is still no premium payment for this policy. "){ //move by steven 10.30.2013
// 					showMessageBox(objAC.tempObj[0].message+" Will now override default computation.", imgMessage.INFO);
// 				}
				addOutFaculPremPayts();
				populateOutFaculPremPayts(null);
			}else{
				$("assuredName").clear();
				$("policyNo").clear();
				$("remarks").clear();
				$("amount").clear();
				$("faculPremLineCd").clear();
				$("faculPremBinderYY").clear();
				$("binderSeqNo").clear();
			}
		}	
	});

	$("btnDelete").observe("click", function ()	{
		deleteOutFaculPremPayts();
	});

	$("binderBtn").observe("click", getBinderDtls);

	$("btnSave").observe("click", function () {
		if(changeTag == 0){showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO); return;}
		objGIACS019.savePage = "Y";
		saveOutFaculPremPayts();
		changeTag = 0;
	});

	$("currInformation").observe("click", function (){
		if (selectedIndex < 0) {
			showMessageBox("Please select a record first.", "I");
		} else {
			var currCd;
			var currRt;
			var currAmt;
			var currDesc;
			if (objAC.tempObj == null) {
				for (var i=0; i<outFaculPremPaytsArray.length; i++){
					if (outFaculPremPaytsArray[i].binderId == $F("hiddenBinderId")) {
						currCd = outFaculPremPaytsArray[i].currencyCd;
						currRt = outFaculPremPaytsArray[i].currencyRt;
						currAmt = unformatCurrency("amount") / outFaculPremPaytsArray[i].currencyRt;
						currDesc = outFaculPremPaytsArray[i].currencyDesc;
						break;
					}
				}
			}else {
				currCd = objAC.tempObj[0].currencyCd;
				currRt = objAC.tempObj[0].currencyRt;
				currAmt = unformatCurrency("amount") * objAC.tempObj[0].currencyRt;
				currDesc = objAC.tempObj[0].currencyDesc;
			}
			showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=showCurrencyInfo&currCd=" + currCd + "&currRt=" +  currRt + "&currAmt=" + currAmt + "&currDesc=" + currDesc , "Currency Information", 350, "", 100);		
		}
	});

	function printGIACR019(){
		try {
			var reportTitle = "Outward Facultative Premium Payment";
			var fileType = "";  //koks 14634
			if($("rdoPdf").disabled == false/*  && $("rdoExcel").disabled == false */){
				//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
				fileType = "PDF"; // please revise when csv is available - andrew
			}
			var content = contextPath+"/CashReceiptsReportPrintController?action=printReport"
							+"&tranId="+objACGlobal.gaccTranId
							+"&reportId=GIACR019&reportTitle="+reportTitle
							+"&printerName="+$F("selPrinter")
							+ "&fileType=" + fileType;	//koks
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, reportTitle);
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "FILE"},
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					parameters : {destination : "LOCAL"},
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("printGIACR019", e);
		}
	}
	
	$("outfaculList").observe("click", function () {
		//showOverlayContent2(contextPath+"/GIACOutFaculPremPaytsController?action=printOutFaculPremPayts" , "Outward Facultative Premiums", 350, "", 100);
		showGenericPrintDialog("Outward Facultative Premiums", printGIACR019, "", 'true');
	});


// 	$("overideUserBtn").observe("click", function () {
// 		if (!objAC.overideOk) {
// 			objAC.funcCode = "OD";
// 			commonOverrideOkFunc = function () {
// 								     objAC.overideOk = true;
// 								   };
// 			commonOverrideNotOkFunc	= function () {
// 									    objAC.overideOk = false;
// 									    showMessageBox($F("overideUserName") + "is not allowed to override this transaction.", imgMessage.ERROR);
// 									  };				   
// 			getUserInfo();
// 		}
// 	});

	$("amount").observe("change", function() {
		if (checkRequiredDisabledFields()) {
// 			if (!objAC.overideOk){
				objAC.overideOk = validateUserFunc2("OD", "GIACS019");	// SR-19773 : shan 07.24.2015
				setOverrideButtons();	// SR-19773 : shan 07.24.2015
				getDisbursementAmt();
				this.value=formatCurrency(this.value);
// 			}else{
// 				getOverrideDisbursementAmt();
// 				this.value=formatCurrency(this.value);
// 			}
		}else{
			this.value=formatCurrency(this.value);
		}
	});

	$("revertBtn").observe("click", function() {
		if ($("revertBtn").getAttribute("class") != "disabledButton") {
			objAC.overrideDef = "N";
			getRevertDisbursementAmt();
			setOverrideButtons();
			enableButton("overrideDefBtn");
			if (validateAmount) {
				$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
				objAC.tempDisbursementAmt=objAC.wsDisbursementAmt;
			}
		}
	});

	$("overrideDefBtn").observe("click", function() {
		objAC.overideOk = validateUserFunc2("OD", "GIACS019");	// SR-19773 : shan 07.24.2015
		if (objAC.overideOk){
			if ($("overrideDefBtn").getAttribute("class") != "disabledButton") {
				objAC.overrideDef = "Y";
				getOverrideDisbursementAmt();
				setOverrideButtons();
				enableButton("revertBtn");
				if (validateAmount) {
					$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
					objAC.tempDisbursementAmt=objAC.wsDisbursementAmt;
				}
			}
		}else{
			$("amount").value = formatCurrency(objAC.wsDisbursementAmt);
			showMessageBox("Policy is partially paid and allowed facul premium payment is " +  formatCurrency(objAC.wsDisbursementAmt) + " only.", imgMessage.INFO);
			disableButton("overrideDefBtn");
			disableButton("revertBtn");
		}
	});
	
	$("editRemarks").observe("click", function () {
		if (objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objAC.tranFlagState == "D" || objACGlobal.queryOnly == "Y"){ //added by steven 12.10.2013; objAC.tranFlagState == "D"
			showOverlayEditor("remarks", 4000,'true');
		}else{
			if (recStatus === ""){
				showOverlayEditor("remarks", 4000,'true');
			}else{
				showOverlayEditor("remarks", 4000,'false');
			}
		}
	});
	/* END OBSERVE ITEMS */
	//disable fields if calling form is Cancel OR : 08-16-2012 Christian
	function disableGIACS019(){
		var divArray = ["outwardFaculButtonsDiv", "outwardFaculPremPaymtsDivMain"];
		disableCancelORFields(divArray);
		$("reinsurerDiv").style.backgroundColor = "#EEEEEE"; //"#ECE9D8";
		$("binderNoDiv").style.backgroundColor = "#EEEEEE"; //"#ECE9D8";
		disableButton("outfaculList");
		if(objACGlobal.tranSource == "DV" || objACGlobal.tranSource == "DISB_REQ" ){ //added DISB_REQ by robert SR 5276 01.26.16 //added by Robert SR 5189 12.22.15
			$("cmTag").disabled = true;
		}
	}

	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objAC.tranFlagState == "D" || objACGlobal.queryOnly == "Y"){ //added by steven 12.10.2013; objAC.tranFlagState == "D"
		disableGIACS019();
	} else {
		initializeChangeTagBehavior(saveOutFaculPremPayts);
		initializeChangeAttribute();
	}
	
	//added by steven 10.30.2013
	$("logout").observe("mousedown", function(){
		if(changeTag == 1){
			objGIACS019.logoutPage = "Y";
		}else{
			objGIACS019.logoutPage = null;
		}	
	});
</script>