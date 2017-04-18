<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div class="sectionDiv" style="border-top: none;" id="directTransInputVatDiv" name="directTransInputVatDiv">	
	<div id="lossesRecovTableGridDiv" style= "padding: 10px;">
				<div id="lossesRecovTableGrid" style="height: 300px;"></div>
	</div>
	<div style="height:30px; width: 915px;">
		<table  align="right">
			<tr>
				<td class="rightAligned" >Total Collection:</td>
				<td ><input class="rightAligned"  type="text" id="lossesRecovTotal" name="lossesRecovTotal" readonly="readonly" tabindex=101/></td>
			</tr>
		</table>
	</div>
	<div>
		<table align="center" border="0" style=" margin:40px auto; margin-top:10px; margin-bottom:20px;">
			<tr>
				<td class="rightAligned" >Transaction Type</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyTransactionTypeLossesRecov" name="readOnlyTransactionTypeLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selTransactionTypeLossesRecov" name="selTransactionTypeLossesRecov" style="width:239px;" class="required" tabindex=102>
					<option value=""></option>
						<c:forEach var="transactionType" items="${transactionTypeList }" varStatus="ctr">
							<option value="${transactionType.rvLowValue }" typeDesc="${transactionType.rvMeaning }">${transactionType.rvLowValue } - ${transactionType.rvMeaning }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" style="width:130px">Particulars</td>
				<td class="leftAligned"  >
					<input type="text" id="txtParticularsLossesRecov" class="txtReadOnly" name="txtParticularsLossesRecov" style="width:231px;" value="" readonly="readonly" maxlength="500" tabindex=116/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Share Type</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyShareTypeLossesRecov" name="readOnlyShareTypeLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selShareTypeLossesRecov" name="selShareTypeLossesRecov" style="width:239px;" class="required" tabindex=103>
					<option value=""></option>
						<c:forEach var="shareType" items="${shareTypeList }" varStatus="ctr">
							<option value="${shareType.rvLowValue }">${shareType.rvMeaning }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Policy No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspPolicyLossesRecov" name="txtDspPolicyLossesRecov" style="width:231px;" value="" readonly="readonly" tabindex=117/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Reinsurer</td>
				<td class="leftAligned"  >
					<input type="text" id="readOnlyA180RiCdLossesRecov" name="readOnlyA180RiCdLossesRecov" value="" class="required" style="width:231px; display:none;" readonly="readonly"/>
					<select id="selA180RiCdLossesRecov12" name="selA180RiCdLossesRecov12" style="width:239px;" class="required" tabindex=104>
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer12List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov13" name="selA180RiCdLossesRecov13" style="width:239px;" class="required" tabindex=105>
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer13List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov14" name="selA180RiCdLossesRecov14" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer14List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov22" name="selA180RiCdLossesRecov22" style="width:239px;" class="required" tabindex=106>
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer22List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov23" name="selA180RiCdLossesRecov23" style="width:239px;" class="required" tabindex=107>
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer23List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
					<select id="selA180RiCdLossesRecov24" name="selA180RiCdLossesRecov24" style="width:239px;" class="required">
					<option value=""></option>
						<c:forEach var="riCd" items="${reinsurer24List }" varStatus="ctr">
							<option value="${riCd.riCd }">${riCd.riName }</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned" >Claim No.</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspClaimNoLossesRecov" name="txtDspClaimNoLossesRecov" style="width:231px;" value="" readonly="readonly" tabindex=118/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Final Loss Advice No.</td>
				<td class="leftAligned"  style="background:none;">
					<div style="float: left;">
						<input type="text" style="width:61px;" id="txtE150LineCdLossesRecov"   	name="txtE150LineCdLossesRecov"  	value="" maxlength="2" class="required" tabindex=108/>
						<input type="text" style="width:61px;" id="txtE150LaYyLossesRecov"   	name="txtE150LaYyLossesRecov" 		value="" maxlength="2" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99." tabindex=109/>
						<input type="text" style="width:61px;" id="txtE150FlaSeqNoLossesRecov" 	name="txtE150FlaSeqNoLossesRecov" 	value="" maxlength="5" class="required integerNoNegativeUnformattedNoComma" errorMsg="Entered value is invalid. Valid value is from 0 to 99999." tabindex=110/>
						<input type="hidden" id="txtFLANumber" 		name="txtFLANumber"/>
						<input type="hidden" id="txtORPrintTag" 	name="txtORPrintTag"/>
						<input type="hidden" id="txtCPIRecNo" 		name="txtCPIRecNo"/>
						<input type="hidden" id="txtCPIBranchCd" 	name="txtCPIBranchCd"/>
						<input type="hidden" id="txtClaimIDLossesRecov" 	name="txtClaimIDLossesRecov"/>
						<input type="hidden" id="hidddenA180RiCd" 	name="hidddenA180RiCd"/>
						<input type="hidden" id="tempCollectionAmt" name="tempCollectionAmt"/>
					</div>
					<div style="float:left; margin-left: 4px;"><img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="finalLossAdviceLossesRecDate" name="finalLossAdviceLossesRecDate" alt="Go" /></div>
				</td>
				<td class="rightAligned" >Assured Name</td>
				<td class="leftAligned"  >
					<input type="text" id="txtDspAssuredLossesRecov" name="txtDspAssuredLossesRecov" style="width:231px;" value="" readonly="readonly" tabindex=119/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Payee Type</td>
				<td class="leftAligned"  >
					<input type="text" id="txtPayeeTypeLossesRecov" name="txtPayeeTypeLossesRecov" style="width:231px;" value="" readonly="readonly" class="required" tabindex=111/>
				</td>
				<td>&nbsp;</td>
				<td style="margin:auto;" align="center">
					<input type="button" style="width: 150px;" id="btnCurrencyLossesRecov" class="button" value="Currency Information" tabindex=120/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Collection Amount</td>
				<td class="leftAligned"  >
					<input type="text" id="txtCollectionAmtLossesRecov" name="txtCollectionAmtLossesRecov" value="" class="money  required" maxlength="14" style="width:231px;" readonly="readonly" tabindex=112/>
				</td>
			</tr>
			<tr>
				<td colspan="2" style="margin:auto;" align="center">
					<input type="button" style="width: 80px;" id="btnAddLossesRecov" 	 class="button cancelORBtn" value="Add" tabindex=113/>
					<input type="button" style="width: 80px;" id="btnDeleteLossesRecovLossesRecov"  class="button cancelORBtn" cancelORBtn" value="Delete" tabindex=114/>
					<input type="button" style="width: 80px;" id="btnLossAdvice" 	 class="button cancelORBtn" value="Loss Advice" tabindex=115/>
				</td>
			</tr>	
		</table>
	</div>
	<div id="currencyLossesRecovDiv" style="display: none;">
		<table border="0" align="center" style="margin:10px auto;">
			<tr>
				<td class="rightAligned" style="width: 123px;">Currency Code</td>
				<td class="leftAligned"  ><input type="text" style="width: 50px; text-align: left" id="currencyCdLossesRecov" name="currencyCdLossesRecov" value="" class="required integerNoNegativeUnformattedNoComma deleteInvalidInput" errorMsg="Entered currency code is invalid. Valid value is from 1 to 99." maxlength="2" tabindex=121/></td>
				<td class="rightAligned" style="width: 180px;">Convert Rate</td>
				<td class="leftAligned"  ><input type="text" style="width: 100px; text-align: right" class="moneyRate required" id="convertRateLossesRecov" name="convertRateLossesRecov" value="" maxlength="13" tabindex=123/></td>
			</tr>
			<tr>
				<td class="rightAligned" >Currency Description</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: left" id="currencyDescLossesRecov" name="currencyDescLossesRecov" value="" readonly="readonly" tabindex=122/></td>
				<td class="rightAligned" >Foreign Currency Amount</td>
				<td class="leftAligned"  ><input type="text" style="width: 170px; text-align: right" class="money required" id="foreignCurrAmtLossesRecov" name="foreignCurrAmtLossesRecov" value="" maxlength="18" tabindex=124/></td>
			</tr>
			<tr>
				<td width="100%" style="text-align: center;" colspan="4">
					<input type="button" style="width: 80px;" id="btnHideCurrLossesRecovDiv" class="button" value="Return" tabindex=125/>
				</td>
			</tr>
		</table>
	</div>	
</div>	
<div id="lossRecovButtonsDiv" class="buttonsDiv" style="float:left; width: 100%;">	
	<input type="button" style="width: 80px;" id="btnCancelRiTransLossesRecov"  name="btnCancelRiTransLossesRecov"	class="button" value="Cancel" tabindex=126/>
	<input type="button" style="width: 80px;" id="btnSaveRiTransLossesRecov" 	name="btnSaveRiTransLossesRecov"	class="button cancelORBtn" value="Save" tabindex=127/>
</div> 
<script type="text/javascript">
	objAC.hidObjGIACS009 = {};
	var objSearchLossAdvice = new Object();
	setModuleId("GIACS009");
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeAccordion();
	hideNotice("");
	enableButton("btnAddLossesRecov");
	setDocumentTitle("Collections on Losses Recoverable from RI");
	window.scrollTo(0,0); 	
	var tempCollectionAmt; //robert 03.18.2013 = 0;
	var totalCollectionAmt = 0;
	var selectedOrPrintTag = "";
// 	disableButton("btnSaveRiTransLossesRecov");
	enableButton("btnLossAdvice");
	defaultCollectionAmount = 0; //john 11.18.2014
	try {
		var objLossRecov = new Object();
		objLossRecov.objLossRecovTableGrid = JSON.parse('${objgiacLossRecov}'.replace(/\\/g, '\\\\'));
		objLossRecov.lossRecov = objLossRecov.objLossRecovTableGrid.rows || [];
		
		var tableModel = {
			url: contextPath+"/GIACLossRiCollnsController?action=showRiTransLossesRecovFromRiTableGrid&globalGaccTranId="+objACGlobal.gaccTranId,
			options:{
				hideColumnChildTitle: true,
				title: '',
				height: '285px',
				onCellFocus: function(element, value, x, y, id) {
					var obj = lossesRecovTableGrid.geniisysRows[y];
					toShowAndToHide("readOnlyTransactionTypeLossesRecov", "readOnlyShareTypeLossesRecov", "readOnlyA180RiCdLossesRecov", "selTransactionTypeLossesRecov", "selShareTypeLossesRecov", "selA180RiCdLossesRecov12");
					if (!$F("txtE150FlaSeqNoLossesRecov").blank()){ 
						$("txtE150FlaSeqNoLossesRecov").value = formatNumberDigits($F("txtE150FlaSeqNoLossesRecov"),5);
					}
 					tempCollectionAmt = obj.tempCollectionAmt==null ? obj.collectionAmt : obj.tempCollectionAmt;

					selectedOrPrintTag=obj.orPrintTag;
 					lossesRecovTableGrid.keys.releaseKeys();
					populateLossRecov(obj);
					$("finalLossAdviceLossesRecDate").hide();
 					if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
						disableGIACS009();
					} else {
						$("btnAddLossesRecov").value='Update';
						enableButton("btnDeleteLossesRecovLossesRecov");
						disableButton("btnLossAdvice");
						$("txtParticularsLossesRecov").readOnly= false;
						$("txtCollectionAmtLossesRecov").readOnly= false;
						$("convertRateLossesRecov").readOnly= false;
						$("foreignCurrAmtLossesRecov").readOnly= false;
					}
				},
				onCellBlur: function(element, value, x, y, id) {
					if((objAC.fromMenu != "cancelOR" && objAC.fromMenu != "cancelOtherOR") && objAC.tranFlagState != "C"){
						observeChangeTagInTableGrid(lossesRecovTableGrid);
					}
				},
				onRemoveRowFocus: function() {
					if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
						disableGIACS009();
					} else {
						getAppearance();
					}
					selectedOrPrintTag="";
					lossesRecovTableGrid.keys.releaseKeys();
					populateLossRecov(null);
					clearForm();
				},
				onSort: function(){
					getAppearance();
					selectedOrPrintTag="";
					lossesRecovTableGrid.keys.releaseKeys();
					populateLossRecov(null);
					clearForm();
					if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
						disableGIACS009();
					}
				},
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveLossesRecov();
								}, function(){
									showRiTransLossesRecovFromRi();
									changeTag = 0;
								}, "");
						return false;
					}else{
						if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
							disableGIACS009();
						}
						return true;
					}
				},
				postPager: function () {
					getAppearance();
					selectedOrPrintTag="";
					lossesRecovTableGrid.keys.releaseKeys();
					populateLossRecov(null);
					clearForm();
					if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
						disableGIACS009();
					}
				},
				toolbar : {
					elements : [MyTableGrid.REFRESH_BTN ],
					onRefresh: function(){
						getAppearance();
						selectedOrPrintTag="";
						lossesRecovTableGrid.keys.releaseKeys();
						populateLossRecov(null);
						clearForm();
						if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
							disableGIACS009();
						}
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
			   
			    {	id: 'a180RiCd',
			    	width: '0',
					visible: false
			    },
		
			    {
			    	id:'transactionType transactionTypeDesc',
			    	title: 'Transaction Type',
			    	width: 115,
			    	sortable: true,
			    	children: [
			    	   	    {	id: 'transactionType',
						    	width: 40,
						    	align: 'right',
								title:'Transaction Type No.'
						    },
						    {	id: 'transactionTypeDesc',
						    	width: 80,
						    	title:'Transaction Type Desc',
					    		renderer: function (value){
									return value.toUpperCase();
								}
						    },
			    	          ]
			    },
			    {	id: 'particulars',
					width: '0',
					visible: false
			    },
			    {	id: 'shareType',
					width: '0',
					visible: false
			    },
			    {	id: 'shareTypeDesc',
					title: 'Share Type',
					width: '150px',
					sortable: true,
					align: 'left'
			    },
			    { 	id: 'riName',
			    	title: 'Reinsurer',
					width: '230px',
					sortable: true,
					align: 'left'
			    },
				{
					id: 'e150LineCd e150LaYy e150FlaSeqNo',
					title: 'Final Loss Advice No.',
					width : 120,
					sortable: true,
					children : [
			            {
			                id : 'e150LineCd',
			                title: 'FLA - Line Code',
			                width : 30
			            },
			            {
			                id : 'e150LaYy', 
			                title: 'FLA - Year',
			                width : 30,
			                align: 'right',
							renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
							}
			            },
			            {
			                id : 'e150FlaSeqNo', 
			                title: 'FLA - Sequence Number',
			                width : 60,
			                align: 'right',
							renderer: function (value){
								return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),5);
							}
			            }
					]
				},
			    
			    {	id: 'dspPolicy',
			    	width: '0',
					visible: false
			    },
			    {	id: 'dspClaim',
					width: '0',
					visible: false
			    },
			    {	id: 'claimId',
					width: '0',
					visible: false
			    },
			    {	id: 'dspAssdName',
					title: 'Claim No.',
					width: '0',
					visible: false
			    },
			    {	id: 'payeeType',
				    title: 'Payee Type',
				    sortable: true,
				    width: '80px',
				    align: 'left'
			    },
			    {
					id: 'collectionAmt',
					title: 'Collection Amount',
					width: '150px',
					sortable: true,
					align: 'right',
					renderer: function (value){
						return nvl(value,'') == '' ? '' :formatCurrency(nvl(value,0));
					}
			    },
			    {
					id: 'tempCollectionAmt',
					width: '0',
					sortable: true,
					visible: false
			    },
			    { 	id: 'currencyCd',
					width: '0',
					visible: false
			    },
			    { 	id: 'convertRate',
					width: '0',
					visible: false
			    },
			    { 	id: 'foreignCurrAmt',
					width: '0',
					visible: false
			    },
			    { 	id: 'currencyDesc',
					width: '0',
					visible: false
			    },
			    { 	id: 'orPrintTag',
					width: '0',
					visible: false
			    },
			    { 	id: 'cpiRecNo',
					width: '0',
					visible: false
			    },
			    { 	id: 'cpiBranchCd',
					width: '0',
					visible: false
			    }
			],
			rows: objLossRecov.lossRecov
		};

		lossesRecovTableGrid = new MyTableGrid(tableModel);
		lossesRecovTableGrid.pager = objLossRecov.objLossRecovTableGrid;
		lossesRecovTableGrid.render('lossesRecovTableGrid');
		lossesRecovTableGrid.afterRender = function(){
														objAC.objLossesRecovAC009=lossesRecovTableGrid.geniisysRows;
														totalCollectionAmt = 0;
														if(objAC.objLossesRecovAC009.length != 0){
															totalCollectionAmt=objAC.objLossesRecovAC009[0].totalCollectionAmt;
														}
														$("lossesRecovTotal").value = formatCurrency(totalCollectionAmt).truncate(13, "...");
							  						};
	} catch (e) {
		showErrorMessage("lossesRecovTableGrid.jsp",e);
	}
	
	function computeTotalAmountInTable(amount) {
		try {
			/*var total=unformatCurrency("lossesRecovTotal");
					total =parseFloat(total) + (parseFloat(amount));
			$("lossesRecovTotal").value = formatCurrency(total).truncate(13, "...");*/
			//replaced by john 11.18.2014
			var total2 = 0;
			for ( var i = 0; i < lossesRecovTableGrid.geniisysRows.length; i++) {
				if(lossesRecovTableGrid.geniisysRows[i].recordStatus != -1){
					total2 = parseFloat(total2) + parseFloat(lossesRecovTableGrid.geniisysRows[i].collectionAmt.replace(/,/g, ""));
				}
			}
			$("lossesRecovTotal").value = formatCurrency(total2);
		} catch (e) {
			showErrorMessage("computeTotalAmountInTable", e);
		}
	}
	
	//create new Object to be added on Object Array
	function setLossesRecovObject() {
		try {
			var obj = new Object();
			var tranType = $F("selTransactionTypeLossesRecov");
			var shareType = $F("selShareTypeLossesRecov");
			var transactionTypeDesc = getListAttributeValue("selTransactionTypeLossesRecov","typeDesc");
			
			/*if (tranType==1 && (shareType==2 || shareType==4)){
				obj.a180RiCd = $F("selA180RiCdLossesRecov12");
			}else if (tranType==1 && shareType==3){
				obj.a180RiCd = $F("selA180RiCdLossesRecov13");
			}else if (tranType==2 && (shareType==2 || shareType==4)){
				obj.a180RiCd = $F("selA180RiCdLossesRecov22");
			}else if (tranType==2 && shareType==3){
				obj.a180RiCd = $F("selA180RiCdLossesRecov23");
			} */
			if ($F("btnAddLossesRecov") == "Update") {
				obj.a180RiCd			= $F("hidddenA180RiCd");
				obj.claimId				= $F("txtClaimIDLossesRecov");
				obj.orPrintTag			= $F("txtORPrintTag");
				obj.cpiRecNo			= $F("txtCPIRecNo");
				obj.cpiBranchCd			= $F("txtCPIBranchCd");
				obj.riName				= $F("readOnlyA180RiCdLossesRecov");
			}else{
				obj.a180RiCd			= $F(objAC.hidObjGIACS009.hidCurrReinsurer);
				obj.claimId				= objAC.hidObjGIACS009.hidClaimId;
				obj.orPrintTag			= objAC.hidObjGIACS009.hidOrPrintTag;
				obj.cpiRecNo			= objAC.hidObjGIACS009.hidCpiRecNo;
				obj.cpiBranchCd			= objAC.hidObjGIACS009.hidCpiBranchCd;
				obj.riName				= getListTextValue(objAC.hidObjGIACS009.hidCurrReinsurer);
			}
			obj.tempCollectionAmt	= $F("tempCollectionAmt").replace(/,/g, "");;
			obj.recordStatus		= objAC.hidObjGIACS009.recordStatus;
			obj.gaccTranId			= objACGlobal.gaccTranId;
			obj.transactionType		= $F("selTransactionTypeLossesRecov");
			obj.transactionTypeDesc1= getListTextValue("selTransactionTypeLossesRecov");
			obj.e150LineCd			= $F("txtE150LineCdLossesRecov");
			obj.e150LaYy			= $F("txtE150LaYyLossesRecov");
			obj.e150FlaSeqNo		= $F("txtE150FlaSeqNoLossesRecov");
			obj.finalLossAdviceNo1	= $F("txtE150LineCdLossesRecov")+' - '+$F("txtE150LaYyLossesRecov")+' - '+$F("txtE150FlaSeqNoLossesRecov");
			obj.collectionAmt		= $F("txtCollectionAmtLossesRecov").replace(/,/g, "");
			obj.currencyCd			= $F("currencyCdLossesRecov");
			obj.convertRate			= $F("convertRateLossesRecov").replace(/,/g, "");	
			obj.foreignCurrAmt		= $F("foreignCurrAmtLossesRecov").replace(/,/g, "");
			obj.particulars			= $F("txtParticularsLossesRecov");
			obj.shareType			= $F("selShareTypeLossesRecov");
			obj.payeeType			= $F("txtPayeeTypeLossesRecov");
			obj.currencyDesc		= $F("currencyDescLossesRecov");
			obj.shareTypeDesc		= getListTextValue("selShareTypeLossesRecov");
			obj.transactionTypeDesc = transactionTypeDesc;
			obj.dspPolicy			= $F("txtDspPolicyLossesRecov");
			obj.dspClaim			= $F("txtDspClaimNoLossesRecov");
			obj.dspAssdName			= $F("txtDspAssuredLossesRecov");
			return obj; 
		}catch(e){
			showErrorMessage("setLossesRecovObject", e);
		}
	}		
	
// 	function to add record
	function addLossesRecov(){ //added by steven 3.26.2012
		try{
			
			if (objAC.hidObjGIACS009.hidUpdateable == "N"){ //to have a disable effect on the add/update
				return false;
			}
			//check required fields first
			var exists = false;
			if ($F("selTransactionTypeLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selTransactionTypeLossesRecov");
				exists = true;
			}else if ($F("selShareTypeLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "selShareTypeLossesRecov");
				exists = true;
			}else if ($F("txtE150LineCdLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150LineCdLossesRecov");
				exists = true;
			}else if ($F("txtE150LaYyLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150LaYyLossesRecov");
				exists = true;
			}else if ($F("txtE150FlaSeqNoLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtE150FlaSeqNoLossesRecov");
				exists = true;
			}else if ($F("txtCollectionAmtLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "txtCollectionAmtLossesRecov");
				exists = true;
			}else if ($F("currencyCdLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "currencyCdLossesRecov");
				exists = true;
			}else if ($F("convertRateLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "convertRateLossesRecov");
				exists = true;
			}else if ($F("foreignCurrAmtLossesRecov").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR , "foreignCurrAmtLossesRecov");
				exists = true;
			}else if ($F("selTransactionTypeLossesRecov") != ""){
				if ($F("selTransactionTypeLossesRecov") == "1"){
					if (unformatCurrency("txtCollectionAmtLossesRecov") <= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Collection amount should be greater than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}	
					if (unformatCurrency("txtCollectionAmtLossesRecov") > 9999999999.99 || unformatCurrency("txtCollectionAmtLossesRecov") < 0.01 || isNaN(parseFloat($F("txtCollectionAmtLossesRecov").replace(/,/g, "")))){
						customShowMessageBox("Entered collection amount is invalid. Valid value is from 0.01 to 9,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
						clearForm();
						exists = true;
					}
					if (unformatCurrency("txtCollectionAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Collection amount cannot be more than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}	
					if (unformatCurrency("foreignCurrAmtLossesRecov") <= 0){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Foreign currency amount cannot be less than or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") > 9999999999.99 || unformatCurrency("foreignCurrAmtLossesRecov") < 0.01 || isNaN(parseFloat($F("foreignCurrAmtLossesRecov").replace(/,/g, "")))){
						customShowMessageBox("Entered currency amount is invalid. Valid value is from 0.01 to 9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
						clearForm();
						exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Foreign currency amount cannot be more than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}	
				}else {
					if (unformatCurrency("txtCollectionAmtLossesRecov") >= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Collection amount should be less than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("txtCollectionAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsCollectionAmt.replace(/,/g, ""))){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
			    		customShowMessageBox("Collection amount cannot be less than default value of "+objAC.hidObjGIACS009.hidWsCollectionAmt, imgMessage.ERROR, "txtCollectionAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") >= 0){
						$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Invalid value. Foreign currency amount for this transaction should be less than zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}
					if (unformatCurrency("foreignCurrAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
						$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
			    		customShowMessageBox("Foreign currency amount cannot be less than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			    		exists = true;
					}
				}
			}else if (parseFloat($F("convertRateLossesRecov")) <= 0.000000000 || parseFloat($F("convertRateLossesRecov")) >= 999.999999999 || isNaN(parseFloat($F("convertRateLossesRecov").replace(/,/g, "")))){
				$("convertRateLossesRecov").value = varConvertRateLossesRecov;
				showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
				exists = true;
			}else if (parseInt($F("currencyCdLossesRecov")) < 1 || parseInt($F("currencyCdLossesRecov")) > 99 || isNaN(parseInt($F("currencyCdLossesRecov").replace(/,/g, "")))){
				showMessageBox("Entered currency code is invalid. Valid value is from 1 to 99.", imgMessage.ERROR);
				$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
				exists = true;
			}	
 			//exists = true;
			if (!exists){
				if (objACGlobal.orStatus !="CANCELLED"){
					var newObj  = setLossesRecovObject();
					if ($F("btnAddLossesRecov") == "Update"){
						//on UPDATE records
						if (selectedOrPrintTag==="Y"){
							showMessageBox("Update not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
						}else{
							for(var i = 0; i<objAC.objLossesRecovAC009.length; i++){
								if ((objAC.objLossesRecovAC009[i].a180RiCd == newObj.a180RiCd)&&(objAC.objLossesRecovAC009[i].payeeType == newObj.payeeType)&&(objAC.objLossesRecovAC009[i].e150LineCd == newObj.e150LineCd)&&(objAC.objLossesRecovAC009[i].e150LaYy == newObj.e150LaYy)&&(objAC.objLossesRecovAC009[i].e150FlaSeqNo == newObj.e150FlaSeqNo)&&(objAC.objLossesRecovAC009[i].recordStatus != -1)){
									newObj.recordStatus = 1;
									objAC.objLossesRecovAC009.splice(i, 1, newObj);
									lossesRecovTableGrid.updateVisibleRowOnly(newObj, lossesRecovTableGrid.getCurrentPosition()[1]);
									getAppearance();
									changeTag = 1;
									clearForm();
									computeTotalAmountInTable(parseFloat(newObj.collectionAmt)-parseFloat(objAC.objLossesRecovAC009[i].collectionAmt));
									populateLossRecov(null);
								}
							}
						}
					}else{
						//on ADD records
						newObj.recordStatus = 0;
						objAC.objLossesRecovAC009.push(newObj);
						lossesRecovTableGrid.addBottomRow(newObj);
						changeTag = 1;
						clearForm();
						computeTotalAmountInTable(newObj.collectionAmt);
						populateLossRecov(null);
					}
				}else{
					clearForm();
					populateLossRecov(null);
					showMessageBox("Form Running in query-only mode. Cannot change database fields.", imgMessage.ERROR);
				}
			}	
		}catch(e){
			showErrorMessage("addLossesRecov", e);
		}
	}	
	
 	objAC.hidObjGIACS009.addLossesRecov = addLossesRecov;
	
// 	function to delete record
	function deleteLossesRecov(){
		try{
			if (selectedOrPrintTag==="Y"){
				showMessageBox("Delete not allowed. This record was created before the OR was printed.", imgMessage.ERROR);
			}else{
				var delObj = setLossesRecovObject();
				for(var i = 0; i<objAC.objLossesRecovAC009.length; i++){
					if ((objAC.objLossesRecovAC009[i].a180RiCd == delObj.a180RiCd)&&(objAC.objLossesRecovAC009[i].payeeType == delObj.payeeType)&&(objAC.objLossesRecovAC009[i].e150LineCd == delObj.e150LineCd)&&(objAC.objLossesRecovAC009[i].e150LaYy == delObj.e150LaYy)&&(objAC.objLossesRecovAC009[i].e150FlaSeqNo == delObj.e150FlaSeqNo)&&(objAC.objLossesRecovAC009[i].recordStatus != -1)){
						delObj.recordStatus = -1;
					objAC.objLossesRecovAC009.splice(i, 1, delObj);
					lossesRecovTableGrid.deleteRow(lossesRecovTableGrid.getCurrentPosition()[1]);
					getAppearance();
					changeTag = 1;
					clearForm();
					computeTotalAmountInTable(-1*parseFloat(delObj.collectionAmt));
					populateLossRecov(null);
					}
				}
			}
		} catch(e){
			showErrorMessage("deleteLossesRecov()", e);
		}
	}
	
//	 	function to save record	
		function saveLossesRecov() {
			try{
				if(!checkAcctRecordStatus(objACGlobal.gaccTranId, "GIACS009")){ //marco - SR-5726 - 03.10.2017
					return;
				}
				
				var objParameters = new Object();
				objParameters.setRows = getAddedAndModifiedJSONObjects(objAC.objLossesRecovAC009);
				objParameters.delRows  = getDeletedJSONObjects(objAC.objLossesRecovAC009);
				
				new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=saveLossesRecov",{
					method: "POST",
					asynchronous: true,
					parameters:{
						param: JSON.stringify(objParameters),
						globalGaccTranId: objACGlobal.gaccTranId,
						globalGaccBranchCd: objACGlobal.branchCd,
						globalGaccFundCd: objACGlobal.fundCd,
						globalTranSource: objACGlobal.tranSource,
						globalOrFlag: objACGlobal.orFlag,
					},
					onCreate: function(){
						showNotice("Saving Losses Recov from RI, please wait...");
					},
					onComplete: function(response){
						hideNotice();
						changeTag = 0;
						lossesRecovTableGrid.refresh();
						if(checkErrorOnResponse(response)){
							if(response.responseText != "SUCCESS"){
								showMessageBox(response.responseText, imgMessage.ERROR);
							} else {
								showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
								lastAction();
								lastAction = "";
							}
							
						}	
					}
				});
			} catch(e){
				showErrorMessage("saveRiTransLossesRecov", e);
			}
		}

	//to clear the form inputs
	function clearForm(){
		try{
			$("selTransactionTypeLossesRecov").clear();
			$("selShareTypeLossesRecov").clear();
			$("txtE150LineCdLossesRecov").clear();
			$("txtE150LaYyLossesRecov").clear();
			$("txtE150FlaSeqNoLossesRecov").clear();
			$("txtPayeeTypeLossesRecov").clear();
			$("txtCollectionAmtLossesRecov").clear();
			$("txtParticularsLossesRecov").clear();
			$("txtDspPolicyLossesRecov").clear();
			$("txtDspClaimNoLossesRecov").clear();
			$("txtDspAssuredLossesRecov").clear();
			$("currencyCdLossesRecov").clear();
			$("currencyDescLossesRecov").clear();
			$("convertRateLossesRecov").clear();
			$("foreignCurrAmtLossesRecov").clear();
			
			$("readOnlyTransactionTypeLossesRecov").clear();
			$("readOnlyTransactionTypeLossesRecov").hide();
			$("selTransactionTypeLossesRecov").show();
			//$("selTransactionTypeLossesRecov").enable();
			
			$("readOnlyShareTypeLossesRecov").clear();
			$("readOnlyShareTypeLossesRecov").hide();
			$("selShareTypeLossesRecov").show();
			//$("selShareTypeLossesRecov").enable();
			
			$("readOnlyA180RiCdLossesRecov").clear();
			$("readOnlyA180RiCdLossesRecov").hide();
			updateRiTransLossRecovLOV();
	
			objAC.hidObjGIACS009.hidCurrReinsurer		= "";
			objAC.hidObjGIACS009.hidOrPrintTag			= "N";
			objAC.hidObjGIACS009.hidClaimId			= "";
			objAC.hidObjGIACS009.hidCpiRecNo 			= "";
			objAC.hidObjGIACS009.hidCpiBranchCd 		= "";
			objAC.hidObjGIACS009.hidUpdateable			= "Y";
			objAC.hidObjGIACS009.hidWsCollectionAmt	= "";
			objAC.hidObjGIACS009.hidWsForeignCurrAmt	= "";
			
			tempCollectionAmt = 0;  //added by shan 07.24.2013 SR-13688
			$("tempCollectionAmt").removeAttribute("value");  //added by shan 07.24.2013 SR-13688
			
			$("txtE150LineCdLossesRecov").readOnly 			= true;
			$("txtE150LaYyLossesRecov").readOnly 			= true;
			$("txtE150FlaSeqNoLossesRecov").readOnly 		= true;
			$("txtCollectionAmtLossesRecov").readOnly 		= true;
			$("foreignCurrAmtLossesRecov").readOnly 		= true;
			$("currencyCdLossesRecov").readOnly 			= true;
			$("convertRateLossesRecov").readOnly 			= true;
			$("txtParticularsLossesRecov").readOnly 		= true;
			
			deselectRows("riTransLossesRecovTable","rowRiTransLossesRecov");	
			$("btnAddLossesRecov").value = "Add";
			//enableButton("btnAddLossesRecov");
			//disableButton("btnDeleteLossesRecovLossesRecov");
		}catch (e) {
			showErrorMessage("clearForm", e);
		}
	}	

	//to clear the form inputs for FLA
	function clearFinalLossAdvice(){
		try{
			if ($F("selTransactionTypeLossesRecov") == "" || $F("selShareTypeLossesRecov") == "" || $(objAC.hidObjGIACS009.hidCurrReinsurer).value == ""){
				$("txtE150LineCdLossesRecov").readOnly 			= true;
				$("txtE150LaYyLossesRecov").readOnly 			= true;
				$("txtE150FlaSeqNoLossesRecov").readOnly 		= true;
			}else{
				$("txtE150LineCdLossesRecov").readOnly 			= false;
				$("txtE150LaYyLossesRecov").readOnly 			= false;
				$("txtE150FlaSeqNoLossesRecov").readOnly 		= false;
			}
			$("txtE150LineCdLossesRecov").clear();
			$("txtE150LaYyLossesRecov").clear();
			$("txtE150FlaSeqNoLossesRecov").clear();
			$("txtPayeeTypeLossesRecov").clear();
			$("txtCollectionAmtLossesRecov").clear();
			$("txtParticularsLossesRecov").clear();
			$("txtDspPolicyLossesRecov").clear();
			$("txtDspClaimNoLossesRecov").clear();
			$("txtDspAssuredLossesRecov").clear();
			$("currencyCdLossesRecov").clear();
			$("currencyDescLossesRecov").clear();
			$("convertRateLossesRecov").clear();
			$("foreignCurrAmtLossesRecov").clear();
	
			objAC.hidObjGIACS009.hidClaimId			= "";
			
			$("txtCollectionAmtLossesRecov").readOnly 		= true;
			$("foreignCurrAmtLossesRecov").readOnly 		= true;
			$("currencyCdLossesRecov").readOnly 			= true;
			$("convertRateLossesRecov").readOnly 			= true;
			$("txtParticularsLossesRecov").readOnly 		= true;
		}catch (e) {
			showErrorMessage("clearFinalLossAdvice", e);
		}
	}	

	function observeFLA(){
		try{
			var arr = ["txtE150LineCdLossesRecov", "txtE150LaYyLossesRecov", "txtE150FlaSeqNoLossesRecov"];
			var preValue = "";
			for (var a=0; a<arr.length; a++){
				$(arr[a]).observe("focus", function(rec){
					preValue = this.value;
				});
				$(arr[a]).observe("blur", function(rec){
					if (preValue != this.value){
						validateFLA();
					}
				});
			}
		}catch (e) {
			showErrorMessage("observeFLA", e);
		}
	}	
	

	function validateFLA(){
		try{
			if (!$F("txtE150LineCdLossesRecov").blank() && !$F("txtE150LaYyLossesRecov").blank() 
					&& !$F("txtE150FlaSeqNoLossesRecov").blank()){
				new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=validateFLA",{
					parameters:{	
						transactionType:$F("selTransactionTypeLossesRecov"),
						shareType:  	$F("selShareTypeLossesRecov"),
						a180RiCd:   	$F(objAC.hidObjGIACS009.hidCurrReinsurer),
						e150LineCd: 	$F("txtE150LineCdLossesRecov"),
						e150LaYy: 		$F("txtE150LaYyLossesRecov"),
						e150FlaSeqNo: 	$F("txtE150FlaSeqNoLossesRecov")
					},	
					asynchronous: false,
					evalScripts: true,
					onComplete:function(response){
						if (checkErrorOnResponse(response)){
							var fla = JSON.parse(response.responseText);
							
							//shan 07.24.2013; 
							//SR-13688 made JSONObject to JSONArray to handle too many rows error (FLA with different payee types)
							if (fla.length > 1){ 
								openSearchLossAdvice();
							}else if (fla.length == 1){
								if (changeSingleAndDoubleQuotes(fla[0].dspMsgAlert == null ? "" :nvl(fla[0].dspMsgAlert,"")) != ""){
									showMessageBox(fla[0].dspMsgAlert ,imgMessage.ERROR);
									clearFinalLossAdvice();
								}else{
									for (var b=0; b<objAC.objLossesRecovAC009.length; b++){
										if ($F("txtE150LineCdLossesRecov") == objAC.objLossesRecovAC009[b].e150LineCd
												&& $F("txtE150FlaSeqNoLossesRecov") == formatNumberDigits(objAC.objLossesRecovAC009[b].e150FlaSeqNo,5)
												&& $F("txtE150LaYyLossesRecov") == formatNumberDigits(objAC.objLossesRecovAC009[b].e150LaYy,2)
												&& $F(objAC.hidObjGIACS009.hidCurrReinsurer) == objAC.objLossesRecovAC009[b].a180RiCd
												&& fla[0].dspPayeeType == objAC.objLossesRecovAC009[b].payeeType
												&& getSelectedRowId("rowRiTransLossesRecov") != b
												&& objAC.objLossesRecovAC009[b].recordStatus != -1){
											showMessageBox("Row exists already with same Tran Id, Final Loss Advice No ,RI Code.", imgMessage.ERROR);
											clearFinalLossAdvice();
											return false;
										}	
									}	
									$("txtE150LineCdLossesRecov").value			= changeSingleAndDoubleQuotes(fla[0].dspLineCd == null ? "" :nvl(fla[0].dspLineCd,""));
									$("txtE150LaYyLossesRecov").value 			= (fla[0].dspLaYy == null ? "" :nvl(formatNumberDigits(fla[0].dspLaYy,2),""));
									$("txtE150FlaSeqNoLossesRecov").value 		= (fla[0].dspFlaSeqNo == null ? "" :nvl(formatNumberDigits(fla[0].dspFlaSeqNo,5),""));
									$("txtPayeeTypeLossesRecov").value			= changeSingleAndDoubleQuotes(fla[0].dspPayeeType == null ? "" :nvl(fla[0].dspPayeeType,""));
									$("txtCollectionAmtLossesRecov").value		= (fla[0].dspCollectionAmt == null ? "" :nvl(formatCurrency(fla[0].dspCollectionAmt),""));
									objAC.hidObjGIACS009.hidWsCollectionAmt		= $("txtCollectionAmtLossesRecov").value;
									$("txtDspPolicyLossesRecov").value			= changeSingleAndDoubleQuotes(fla[0].nbtPolicy == null ? "" :nvl(fla[0].nbtPolicy,""));
									$("txtDspClaimNoLossesRecov").value			= changeSingleAndDoubleQuotes(fla[0].nbtClaim == null ? "" :nvl(fla[0].nbtClaim,""));
									$("txtDspAssuredLossesRecov").value			= changeSingleAndDoubleQuotes(fla[0].dspAssdName == null ? "" :nvl(fla[0].dspAssdName,""));
									objAC.hidObjGIACS009.hidClaimId				= (fla[0].nbtClaimId == null ? "" :nvl(fla[0].nbtClaimId,""));
									$("foreignCurrAmtLossesRecov").value 		= (fla[0].dspForeignCurrAmt == null ? "" :nvl(formatCurrency(fla[0].dspForeignCurrAmt),""));;
									objAC.hidObjGIACS009.hidWsForeignCurrAmt		= $("foreignCurrAmtLossesRecov").value;	
									$("currencyCdLossesRecov").value 			= (fla[0].dspCurrencyCd == null ? "" :nvl(fla[0].dspCurrencyCd,""));;
									$("convertRateLossesRecov").value 			= (fla[0].dspConvertRate == null ? "" :nvl(formatToNineDecimal(fla[0].dspConvertRate),""));;
									$("currencyDescLossesRecov").value 			= changeSingleAndDoubleQuotes(fla[0].dspCurrencyDesc == null ? "" :nvl(fla[0].dspCurrencyDesc,""));;
									
									$("txtCollectionAmtLossesRecov").readOnly 		= false;
									$("foreignCurrAmtLossesRecov").readOnly 		= false;
									$("currencyCdLossesRecov").readOnly 			= false;
									$("convertRateLossesRecov").readOnly 			= false;
									$("txtParticularsLossesRecov").readOnly 		= false;
									
									tempCollectionAmt = (fla[0].dspCollectionAmt == null ? "" :nvl(formatCurrency(fla[0].dspCollectionAmt),""));;	//added by shan 07.24.2013 SR-13688
									$("tempCollectionAmt").value = (fla[0].dspCollectionAmt == null ? "" :nvl(formatCurrency(fla[0].dspCollectionAmt),""));;	//added by shan 07.24.2013 SR-13688
								}		
							}
						}
					}	
				});	
			}
		}catch (e) {
			showErrorMessage("validateFLA", e);
		}
	}	
	
	observeFLA();
	clearForm();
	//checkTableItemInfo("riTransLossesRecovTable","riTransLossesRecovListing","rowRiTransLossesRecov");
	//initializeChangeTagBehavior(saveLossesRecov);
	
	
	function populateLossRecov(obj) {
		try{
			$("readOnlyTransactionTypeLossesRecov").value    = (obj) == null ? "" : (nvl(obj.transactionType + ' - ' + obj.transactionTypeDesc.toUpperCase(),""));
	 		$("readOnlyShareTypeLossesRecov").value     = (obj) == null ? "" : (nvl(obj.shareTypeDesc,""));
	 		$("readOnlyA180RiCdLossesRecov").value    	= (obj) == null ? "" : (obj.riName == null ? "" : unescapeHTML2(obj.riName)); // modified by robert 10.09.2013 --changed from (obj) == null ? "" : (nvl(obj.riName,""));
	 		$("txtClaimIDLossesRecov").value 			= (obj) == null ? "" : (nvl(obj.claimId,""));
			$("txtORPrintTag").value					= (obj) == null ? "" : (nvl(obj.orPrintTag,""));
			$("txtCPIRecNo").value						= (obj) == null ? "" : (nvl(obj.cpiRecNo,""));
			$("txtCPIBranchCd").value					= (obj) == null ? "" : (nvl(obj.cpiBranchCd,""));
	 		$("selTransactionTypeLossesRecov").value    = (obj) == null ? "" : (nvl(obj.transactionType,""));
	 		$("selShareTypeLossesRecov").value      	= (obj) == null ? "" : (nvl(obj.shareType,""));
	 		$("hidddenA180RiCd").value    				= (obj) == null ? "" : (nvl(obj.a180RiCd,""));
	 		$("txtE150LineCdLossesRecov").value      	= (obj) == null ? "" : (nvl(obj.e150LineCd,""));
	 		$("txtE150LaYyLossesRecov").value    		= (obj) == null ? "" : (nvl(obj.e150LaYy,""));
	 		$("txtE150FlaSeqNoLossesRecov").value   	= (obj) == null ? "" : (nvl(obj.e150FlaSeqNo,""));
	 		$("txtPayeeTypeLossesRecov").value    		= (obj) == null ? "" : (nvl(obj.payeeType,""));
	 		$("txtCollectionAmtLossesRecov").value   	= (obj) == null ? "" : (nvl(formatCurrency(obj.collectionAmt),0));
	 		$("txtParticularsLossesRecov").value    	= (obj) == null ? "" : (nvl(unescapeHTML2(obj.particulars),"")); //John Dolon; 5.25.2015; SR#2569 - Issues in Losses Recoverable from RI
	 		$("txtDspPolicyLossesRecov").value    		= (obj) == null ? "" : (nvl(unescapeHTML2(obj.dspPolicy),""));
	 		$("txtDspClaimNoLossesRecov").value    		= (obj) == null ? "" : (nvl(unescapeHTML2(obj.dspClaim),""));
	 		$("txtDspAssuredLossesRecov").value    		= (obj) == null ? "" : (nvl(unescapeHTML2(obj.dspAssdName),""));
	 		$("currencyCdLossesRecov").value    		= (obj) == null ? "" : (nvl(obj.currencyCd,""));
	 		$("currencyDescLossesRecov").value    		= (obj) == null ? "" : (nvl(obj.currencyDesc,""));
	 		$("convertRateLossesRecov").value    		= (obj) == null ? "" : (nvl(obj.convertRate,""));
	 		$("foreignCurrAmtLossesRecov").value    	= (obj) == null ? "" : (nvl(formatCurrency(obj.foreignCurrAmt),0));
		}catch (e) {
			showErrorMessage("populateLossRecov", e);
		}
	}
	function toShowAndToHide(show1,show2,show3,hide1,hide2,hide3) {
		try{
			$(show1).show();     	
	 		$(show2).show(); 
	 		$(show3).show(); 
	 		$(hide1).hide();
	 		$(hide2).hide();
	 		$(hide3).hide();
		}catch (e) {
			showErrorMessage("toShowAndToHide", e);
		}
	}
	
	function getAppearance() {
		toShowAndToHide("selTransactionTypeLossesRecov", "selShareTypeLossesRecov", "selA180RiCdLossesRecov12","readOnlyTransactionTypeLossesRecov", "readOnlyShareTypeLossesRecov", "readOnlyA180RiCdLossesRecov");
		$("btnAddLossesRecov").value='Add';
		disableButton("btnDeleteLossesRecovLossesRecov");
		enableButton("btnLossAdvice");
		$("txtParticularsLossesRecov").readOnly= true;
		$("txtCollectionAmtLossesRecov").readOnly= true;
		$("convertRateLossesRecov").readOnly= true;
		$("foreignCurrAmtLossesRecov").readOnly= true;
		$("finalLossAdviceLossesRecDate").show();
		// moved from clearform() - christian
		$("selTransactionTypeLossesRecov").enable();
		$("selShareTypeLossesRecov").enable();
		enableButton("btnAddLossesRecov");
		disableButton("btnDeleteLossesRecovLossesRecov");
	}
	/* observe */
	
	// 	when Add/Update button click
	$("btnAddLossesRecov").observe("click", function(){
		addLossesRecov();
	});

		//when DELETE button click
	$("btnDeleteLossesRecovLossesRecov").observe("click",function(){
		if (objACGlobal.orStatus !="CANCELLED"){
			deleteLossesRecov();
		}else{
			clearForm();
			populateLossRecov(null);
			showMessageBox("Form Running in query-only mode. Cannot change database fields.", imgMessage.ERROR);
		}
	});
	
	//when SAVE button click
	$("btnSaveRiTransLossesRecov").observe("click",function(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}else{
			saveLossesRecov();
		}
	});
		//currency info DIV
	$("btnCurrencyLossesRecov").observe("click",function(){
		if ($("currencyLossesRecovDiv").getStyle("display") == "none"){
			Effect.Appear($("currencyLossesRecovDiv"), {
				duration: .2
			});
		}else{
			Effect.Fade($("currencyLossesRecovDiv"), {
				duration: .2
			});
		}	
	});
	$("btnHideCurrLossesRecovDiv").observe("click",function(){
		Effect.Fade($("currencyLossesRecovDiv"), {
			duration: .2
		});	
	});

	//for transaction type
	$("selTransactionTypeLossesRecov").observe("change", function(){
		updateRiTransLossRecovLOV();
		clearFinalLossAdvice();
	});

	//for share type
	$("selShareTypeLossesRecov").observe("change", function(){
		updateRiTransLossRecovLOV();
		$(objAC.hidObjGIACS009.hidCurrReinsurer).selectedIndex = 0;
		clearFinalLossAdvice();
	});

	//for reinsurer LOV
	$("selA180RiCdLossesRecov12").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov13").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov22").observe("change", function(){
		clearFinalLossAdvice();
	});
	$("selA180RiCdLossesRecov23").observe("change", function(){
		clearFinalLossAdvice();
	});

	//for Loss Advice
	$("txtE150LineCdLossesRecov").observe("keyup",function(){
		$("txtE150LineCdLossesRecov").value = $("txtE150LineCdLossesRecov").value.toUpperCase();
	});
	$("txtE150LaYyLossesRecov").observe("change",function(){
		if (!$F("txtE150LaYyLossesRecov").blank()){
			$("txtE150LaYyLossesRecov").value = formatNumberDigits($F("txtE150LaYyLossesRecov"),2);
		} 
	});

	//for Loss Advice icon
	$("finalLossAdviceLossesRecDate").observe("click", function(){
		if ($F("selTransactionTypeLossesRecov") == ""){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeLossesRecov");
			return false;
		}else if ($F("selShareTypeLossesRecov") == ""){
			customShowMessageBox("Please select a share type first.", imgMessage.ERROR, "selShareTypeLossesRecov");
			return false;
		}else if (($F("selA180RiCdLossesRecov12") == "") && ($F("selA180RiCdLossesRecov13") == "") && ($F("selA180RiCdLossesRecov22") == "") && ($F("selA180RiCdLossesRecov23") == "") && ($F("selA180RiCdLossesRecov14") == "") && ($F("selA180RiCdLossesRecov24") == "")){
			customShowMessageBox("Please select a reinsurer first.", imgMessage.ERROR, objAC.hidObjGIACS009.hidCurrReinsurer);
			return false;
		}else{
			openSearchLossAdvice();
		}
	});
	
	//for Loss Advice button
	$("btnLossAdvice").observe("click", function(){
		if ($F("selTransactionTypeLossesRecov") == ""){
			customShowMessageBox("Please select a transaction type first.", imgMessage.ERROR, "selTransactionTypeLossesRecov");
			return false;
		}else if ($F("selShareTypeLossesRecov") == ""){
			customShowMessageBox("Please select a share type first.", imgMessage.ERROR, "selShareTypeLossesRecov");
			return false;
		}else if (($F("selA180RiCdLossesRecov12") == "") && ($F("selA180RiCdLossesRecov13") == "") && ($F("selA180RiCdLossesRecov22") == "") && ($F("selA180RiCdLossesRecov23") == "") && ($F("selA180RiCdLossesRecov14") == "") && ($F("selA180RiCdLossesRecov24") == "")){
			customShowMessageBox("Please select a reinsurer first.", imgMessage.ERROR, objAC.hidObjGIACS009.hidCurrReinsurer);
			return false;
		}else{
			openSearchLossAdvice();
		}
	});

	//for Collection Amount
	var varTxtCollectionAmtLossesRecov = "";
	$("txtCollectionAmtLossesRecov").observe("focus", function(){
		varTxtCollectionAmtLossesRecov = $F("txtCollectionAmtLossesRecov");
	});	
	//onchange on collection amount
	$("txtCollectionAmtLossesRecov").observe("change", function(){
		tempCollectionAmt = tempCollectionAmt == null ? $("tempCollectionAmt").value : tempCollectionAmt; //robert 03.18.2013
		defaultCollectionAmount = $("txtCollectionAmtLossesRecov").value; //John Dolon; 5.26.2015; SR#4005 - Incorrect Foreign Currency amount in OR Preview is displayed 
		if ($F("txtCollectionAmtLossesRecov").blank()){
			return false;
		}	
		if (unformatCurrency("txtCollectionAmtLossesRecov") > 9999999999.99 || unformatCurrency("txtCollectionAmtLossesRecov") < -9999999999.99){
			customShowMessageBox("Entered collection amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
// 			$("txtCollectionAmtLossesRecov").clear();
			this.value=formatCurrency(tempCollectionAmt);
			return  false;
		}

		if ($F("selTransactionTypeLossesRecov") == "1"){
			if (unformatCurrency("txtCollectionAmtLossesRecov") <= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Collection amount should be greater than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false;
			}	
			if (unformatCurrency("txtCollectionAmtLossesRecov") > parseFloat(defaultCollectionAmount.replace(/,/g, ""))){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Collection amount cannot be more than default value of "+formatCurrency(defaultCollectionAmount), imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false; 
			}	
		}else{
			if (unformatCurrency("txtCollectionAmtLossesRecov") >= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Collection amount should be less than zero(0).", imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false;
			}
			if (unformatCurrency("txtCollectionAmtLossesRecov") < parseFloat(defaultCollectionAmount.replace(/,/g, ""))){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
	    		customShowMessageBox("Collection amount cannot be less than default value of "+formatCurrency(defaultCollectionAmount), imgMessage.ERROR, "txtCollectionAmtLossesRecov");
	    		return false; 
			}
		}	
		if (varTxtCollectionAmtLossesRecov != unformatCurrency("txtCollectionAmtLossesRecov") && $F("txtCollectionAmtLossesRecov").replace(/,/g, "") != ""){	
			$("foreignCurrAmtLossesRecov").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossesRecov"),0) / nvl(unformatCurrency("convertRateLossesRecov"),1));
		}
	});	

	//for Foreign Currency Amount
	var varForeignCurrAmtLossesRecov = "";
	$("foreignCurrAmtLossesRecov").observe("focus", function(){
		varForeignCurrAmtLossesRecov = $F("foreignCurrAmtLossesRecov");
	});	
	//onchange on Foreign Currency Amount
	$("foreignCurrAmtLossesRecov").observe("change", function(){
		if ($F("foreignCurrAmtLossesRecov").blank()){
			return false;
		}	
		if (unformatCurrency("foreignCurrAmtLossesRecov") > 9999999999.99 || unformatCurrency("foreignCurrAmtLossesRecov") < -9999999999.99){
			customShowMessageBox("Entered foreign currency amount is invalid. Valid value is from -9,999,999,999.99 to 9,999,999,999.99.", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
			$("foreignCurrAmtLossesRecov").clear();
			return false;
		}
		if ($F("selTransactionTypeLossesRecov") == "1"){
			if (unformatCurrency("foreignCurrAmtLossesRecov") <= 0){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Foreign currency amount cannot be less than or equal to zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false;
			}	 
			if (unformatCurrency("foreignCurrAmtLossesRecov") > parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Foreign currency amount cannot be more than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false; 
			}	
		}else{
			if (unformatCurrency("foreignCurrAmtLossesRecov") >= 0){
				$("txtCollectionAmtLossesRecov").value = formatCurrency(varTxtCollectionAmtLossesRecov);
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Invalid value. Foreign currency amount for this transaction should be less than zero(0).", imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false;
			}
			if (unformatCurrency("foreignCurrAmtLossesRecov") < parseFloat(objAC.hidObjGIACS009.hidWsForeignCurrAmt.replace(/,/g, ""))){
				$("foreignCurrAmtLossesRecov").value = formatCurrency(varForeignCurrAmtLossesRecov);
	    		customShowMessageBox("Foreign currency amount cannot be less than "+objAC.hidObjGIACS009.hidWsForeignCurrAmt, imgMessage.ERROR, "foreignCurrAmtLossesRecov");
	    		return false; 
			}
		}
		if (varTxtCollectionAmtLossesRecov != $F("foreignCurrAmtLossesRecov")){
			$("txtCollectionAmtLossesRecov").value = formatCurrency(unformatCurrency("foreignCurrAmtLossesRecov") * unformatCurrency("convertRateLossesRecov"));
		}	
	});

	//for Convert rate
	var varConvertRateLossesRecov = "";
	$("convertRateLossesRecov").observe("focus", function(){
		varConvertRateLossesRecov = $F("convertRateLossesRecov");
	});	
	//onchange on Convert rate
	$("convertRateLossesRecov").observe("change", function(){
		if ($F("convertRateLossesRecov").blank()){
			return false;
		}	
		if (isNaN(parseFloat($F("convertRateLossesRecov")))){
			$("convertRateLossesRecov").value = varConvertRateLossesRecov;
			showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
			return false;
		}else if (parseFloat($F("convertRateLossesRecov")) <= 0.000000000 || parseFloat($F("convertRateLossesRecov")) >= 999.999999999){
			$("convertRateLossesRecov").value = varConvertRateLossesRecov;
			showMessageBox("Entered currency rate is invalid. Valid value is from 0.000000001 to 999.999999999.", imgMessage.ERROR);
			return false;
		}
		if (!$F("convertRateLossesRecov").blank()){	
			$("foreignCurrAmtLossesRecov").value = formatCurrency(nvl(unformatCurrency("txtCollectionAmtLossesRecov"),0) / nvl(unformatCurrency("convertRateLossesRecov"),1));
		}
	});	

	//for currency code
	var varCurrencyCdLossesRecov = "";
	$("currencyCdLossesRecov").observe("focus", function(){
		varCurrencyCdLossesRecov = $F("currencyCdLossesRecov");
	});	 
	$("currencyCdLossesRecov").observe("change", function(){
		if ($F("currencyCdLossesRecov").blank()){
			return false;	
		}else{
			if (parseInt($F("currencyCdLossesRecov")) < 1 || parseInt($F("currencyCdLossesRecov")) > 99){
				showMessageBox("Entered currency code is invalid. Valid value is from 1 to 99.", imgMessage.ERROR);
				$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
				return false;
			}	
		}
		if (varCurrencyCdLossesRecov != $F("currencyCdLossesRecov") && !$F("txtCollectionAmtLossesRecov").blank()){
			new Ajax.Request(contextPath+"/GIACLossRiCollnsController?action=validateCurrencyCode",{
				parameters:{
					claimId: objAC.hidObjGIACS009.hidClaimId,
					collectionAmt: unformatCurrency("txtCollectionAmtLossesRecov"),
					currencyCd: $F("currencyCdLossesRecov")
				},
				asynchronous:false,
				evalScripts:true,
				onComplete:function(response){
					var currJSON = response.responseText.evalJSON();
					if (currJSON.vMsgAlert == null || currJSON.vMsgAlert == ""){
						$("currencyDescLossesRecov").value = currJSON.dspCurrencyDesc;
						$("convertRateLossesRecov").value = formatToNineDecimal(currJSON.convertRate);
						$("currencyCdLossesRecov").value = currJSON.currencyCd;
						$("foreignCurrAmtLossesRecov").value = formatCurrency(currJSON.foreignCurrAmt);
					}else{
						showMessageBox(currJSON.vMsgAlert, imgMessage.ERROR);
						$("currencyCdLossesRecov").value = varCurrencyCdLossesRecov;
					}	
				}
			});
		}	
	});	

	$("btnCancelRiTransLossesRecov").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("btnCancelRiTransLossesRecov").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLossesRecov();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
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
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
	
	$("acExit").stopObserving("click"); // copy from quotationCarrierInfo.jsp
	$("acExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveLossesRecov();
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
					}, function(){
						if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
							showDisbursementMainPage(objACGlobal.disbursement, objACGlobal.refId, nvl(objACGlobal.otherBranch,""));
						}else if(objACGlobal.previousModule == "GIACS070"){	//added by shan 08.27.2013
							showGIACS070Page();
							objACGlobal.previousModule = null;
						}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
							$("giacs031MainDiv").hide();
							$("giacs032MainDiv").show();
							$("mainNav").hide();
						}else{
							editORInformation();	
						}
						changeTag = 0;
					}, "");
		}else{
			if(objACGlobal.calledForm == "GIACS016" || objACGlobal.previousModule == "GIACS016"){
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
			}else if(objACGlobal.previousModule == "GIACS032"){ //added john 10.16.2014
				$("giacs031MainDiv").hide();
				$("giacs032MainDiv").show();
				$("mainNav").hide();
			}else{
				editORInformation();	
			}
		}
	});
	//disable fields if calling form is Cancel OR : 08-15-2012 Christian 
	function disableGIACS009(){
		var divArray = ["lossRecovButtonsDiv", "directTransInputVatDiv"];
		disableCancelORFields(divArray);
		$("finalLossAdviceLossesRecDate").hide();
	}
	//added cancelOtherOR by robert 10302013
	if(objAC.fromMenu == "cancelOR" || objAC.fromMenu == "cancelOtherOR" || objAC.tranFlagState == "C" || objACGlobal.queryOnly == "Y"){
		disableGIACS009();
	} else {
		initializeChangeTagBehavior(saveLossesRecov);
		initializeChangeAttribute();
	}
</script>	