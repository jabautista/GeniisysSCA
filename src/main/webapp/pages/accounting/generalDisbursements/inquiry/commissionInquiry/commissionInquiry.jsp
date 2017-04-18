<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="commissionInquiryMainDiv" name="commissionInquiryMainDiv" style="width:100%; float: left; margin-bottom: 50px;">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>View Commission Payments per Bill</label> 
		</div>
	</div>
	<div id="commissionInquiryBodyDiv" class="sectionDiv">
		<div id="commissionInquiryFieldDiv" style="height: 275px; margin:0 0 0 20px;">
				<table cellspacing="0" width="100%" align="center" style="margin: 20px 0 20px 0;">
					<tr>
						<td class="rightAligned">Bill No.</td>
						<td class="leftAligned" width="375px">
<!-- 							<input class="leftAligned required allCaps editable" type="text" id="txtBillIssCd" name="txtBillIssCd" maxlength="2" style="width: 64px;" tabindex="101"/> -->
							<span class="lovSpan required" style="float: left; width: 70px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="leftAligned required allCaps editable" ignoreDelKey="" type="text" id="txtBillIssCd" name="txtBillIssCd" style="width: 45px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="101" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" name="searchIssCd" alt="Go" style="float: right;" />
							</span>
							<span class="lovSpan required" style="float: left; width: 268px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="rightAligned required integerUnformatted" lpad="12" ignoreDelKey="" type="text" id="txtPremSeqNo" name="txtPremSeqNo" style="width: 240px; float: left; border: none; height: 15px; margin: 0;" maxlength="14" tabindex="102" lastValidValue=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBillNo" name="searchBillNo" alt="Go" style="float: right;" tabindex="103"/>
							</span>
<!-- 							<input class="rightAligned required integerUnformatted" lpad="12" type="text" id="txtPremSeqNo" name="txtPremSeqNo" maxlength="14" style= "width: 263px;" tabindex="102"/> -->
<%-- 							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBillNo" name="searchBillNo" style="float: right; padding: 3px; cursor: pointer;" tabindex="103"/> --%>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy No.</td>
						<td class="leftAligned">
							<input class="polNoReq allCaps editable"  type="text" id="txtPolLineCd" name="txtPolLineCd" style="width: 64px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="104"/>
							<input class="polNoReq allCaps editable" type="text" id="txtPolSublineCd" name="txtPolSublineCd" style="width: 70px; float: left; margin: 2px 4px 0 0" maxlength="7" tabindex="105"/>
							<input class="polNoReq allCaps editable" type="text" id="txtPolIssCd" name="txtPolIssCd" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="2" tabindex="106"/>
							<input class="polNoReq integerUnformatted editable" lpad="2" type="text" id="txtPolIssueYr" name="txtPolIssueYr" style="width: 30px; float: left; margin: 2px 4px 0 0" maxlength="4" tabindex="107"/>
							<input class="polNoReq integerUnformatted editable" lpad="7" type="text" id="txtPolSeqNo" name=""txtPolSeqNo"" style="width: 65px; float: left; margin: 2px 4px 0 0" maxlength="30" tabindex="108"/>
							<input class="polNoReq integerUnformatted editable" lpad="2" type="text" id="txtPolRenewNo" name="txtPolRenewNo" style="width: 20px; float: left;" maxlength="4" tabindex="109"/>
						</td>
						<td class="rightAligned" style="width: 100px;">Endorsement No.</td>
						<td class="leftAligned">
							<input class="allCaps editable" type="text" id="txtEndtIssCd" name="txtEndtIssCd" style="width: 64px; float: left; margin: 2px 4px 0 0" maxlength="30" tabindex="110"/>
							<input class="integerUnformatted editable" lpad="2" type="text" id="txtEndtIssueYr" name="txtEndtIssueYr" style="width: 50px; float: left; margin: 2px 4px 0 0" maxlength="4" tabindex="111"/>
							<input class="integerUnformatted editable" lpad="6" type="text" id="txtEndtSeqNo" name="txtEndtSeqNo" style="width: 100px; float: left;" maxlength="8" tabindex="112"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Assured</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 0 0 0; float: left;">
								<input type="text" id="txtAssuredNo" name="txtAssuredNo" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted editable" lpad="6" maxlength="14" tabindex="113" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredNo" name="searchAssuredNo" alt="Go" style="float: right;" tabindex="114"/>
							</span>
							<span class="lovSpan" style="width: 651px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtAssuredName" name="txtAssuredName" style="width: 624px; float: left; border: none; height: 13px;" class="disableDelKey allCaps editable" maxlength="500" tabindex="115" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredName" name="searchAssuredName" alt="Go" style="float: right;" tabindex="116"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Intermediary</td>
						<td colspan="3" class="leftAligned">
							<span class="lovSpan" style="width: 70px; height: 21px; margin: 2px 0 0 0; float: left;">
								<input type="text" id="txtIntmType" name="txtIntmType" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps editable" maxlength="2" tabindex="117" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmType" name="searchIntmType" alt="Go" style="float: right;" tabindex="118"/>
							</span>
							<span class="lovSpan" style="width: 121px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtIntmNo" name="txtIntmNo" style="width: 90px; float: left; border: none; height: 13px;" class="disableDelKey integerUnformatted rightAligned editable" lpad="12" maxlength="14" tabindex="119" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmNo" name="searchIntmNo" alt="Go" style="float: right;" tabindex="120"/>
							</span>
							<span class="lovSpan" style="width: 85px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtRefIntmCd" name="txtRefIntmCd" style="width: 58px; float: left; border: none; height: 13px;" class="disableDelKey rightAligned editable" maxlength="10" tabindex="121" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRefIntmCd" name="searchRefIntmCd" alt="Go" style="float: right;" tabindex="122"/>
							</span>
							<span class="lovSpan" style="width: 433px; height: 21px; margin: 2px 0 0 4px; float: left;">
								<input type="text" id="txtIntmName" name="txtIntmName" style="width: 406px; float: left; border: none; height: 13px;" class="disableDelKey allCaps editable" maxlength="240" tabindex="123" lastValidValue=""/>								
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmName" name="searchIntmName" alt="Go" style="float: right;" tabindex="124"/>
							</span>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Inception Date</td>
						<td class="leftAligned">
							<div style="float: left; width: 123.5px;" class="withIconDiv">
								<input type="text" id="txtInceptionDate" name="txtInceptionDate" class="withIcon" readonly="readonly" style="width: 98px;" tabindex="125"/>
								<img id="hrefInceptionDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Inception Date" onclick="scwShow($('txtInceptionDate'),this, null);" tabindex="126"/>
							</div>
						<label class="rightAligned" style="margin: 5px 5px 0 20px;">Expiry Date</label>
							<div style="float: left; width: 123.5px;" class="withIconDiv">
								<input type="text" id="txtExpiryDate" name="txtExpiryDate" class="withIcon" readonly="readonly" style="width: 98px;" tabindex="127"/>
								<img id="hrefExpiryDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Expiry Date" onclick="scwShow($('txtExpiryDate'),this, null);" tabindex="128"/>
							</div>
						</td>
						<td class="rightAligned">Commission</td>
						<td class="leftAligned">
							<input class="rightAligned local" type="text" id="txtComAmt" name="txtComAmt" style="width: 238px;"  readonly="readonly" tabindex="129"/>
							<input class="rightAligned foren" type="text" id="txtComAmtF" name="txtComAmtF" style="width: 238px;"  readonly="readonly" tabindex="130"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Policy Status</td>
						<td class="leftAligned">
							<input class="allCaps" type="text" id="txtPolFlag" name="txtPolFlag" style="width: 80px;" maxlength="1" tabindex="131" readonly="readonly"/>
							<input type="text" id="txtPolStatus" name="txtPolStatus" style="width: 117px;" readonly="readonly" maxlength="30" tabindex="132" readonly="readonly"/>
							<input type="text" id="txtRegPolSw" name="txtRegPolSw" style="width: 118px;" readonly="readonly" maxlength="30" tabindex="133" readonly="readonly"/>
						</td>
						<td class="rightAligned">Withholding Tax</td>
						<td class="leftAligned"> 
							<input class="rightAligned local" type="text" id="txtWholdingTax" name="txtWholdingTax" style="width: 238px;"  readonly="readonly" tabindex="134"/>
							<input class="rightAligned foren" type="text" id="txtWholdingTaxF" name="txtWholdingTaxF" style="width: 238px;"  readonly="readonly" tabindex="135"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium Amount</td>
						<td class="leftAligned">
							<input class="leftAligned local" type="text" id="txtPremAmtCurr" name="txtPremAmtCurr" style="width: 80px;"  readonly="readonly" tabindex="136"/>
							<input class="rightAligned local" type="text" id="txtPremAmt" name="txtPremAmt" style="width: 247px;"  readonly="readonly" tabindex="137"/>
							<input class="rightAligned foren" type="text" id="txtPremAmtCurrF" name="txtPremAmtCurrF" style="width: 80px;"  readonly="readonly" tabindex="138"/>
							<input class="rightAligned foren" type="text" id="txtPremAmtF" name="txtPremAmtF" style="width: 247px;"  readonly="readonly" tabindex="139"/>
						</td>
						<td class="rightAligned">Input VAT</td>
						<td class="leftAligned">
							<input class="rightAligned local" type="text" id="txtInputVat" name="txtInputVat" style="width: 238px;"  readonly="readonly" tabindex="140"/>
							<input class="rightAligned foren" type="text" id="txtInputVatF" name="txtInputVatF" style="width: 238px;"  readonly="readonly" tabindex="141"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Premium Paid</td>
						<td class="leftAligned">
							<input class="leftAligned local" type="text" id="txtPremPaidCurr" name="txtPremPaidCurr" style="width: 80px;"  readonly="readonly" tabindex="142"/>
							<input class="rightAligned local" type="text" id="txtPremPaid" name="txtPremPaid" style="width: 247px;"  readonly="readonly" tabindex="143"/>
							<input class="rightAligned foren" type="text" id="txtPremPaidCurrF" name="txtPremPaidCurrF" style="width: 80px;"  readonly="readonly" tabindex="144"/>
							<input class="rightAligned foren" type="text" id="txtPremPaidF" name="txtPremPaidF" style="width: 247px;"  readonly="readonly" tabindex="145"/>
						</td>
						<td class="rightAligned">Net Commission </td>
						<td class="leftAligned">
							<input class="rightAligned local" type="text" id="txtNetCom" name="txtNetCom" style="width: 238px;"  readonly="readonly" tabindex="146"/>
							<input class="rightAligned foren" type="text" id="txtNetComF" name="txtNetComF" style="width: 238px;"  readonly="readonly" tabindex="147"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Net Premium</td>
						<td class="leftAligned">
							<input class="rightAligned local" type="text" id="txtNetPrem" name="txtNetPrem" style="width: 339px;" tabindex="148" readonly="readonly"/>
							<input class="rightAligned foren" type="text" id="txtNetPremF" name="txtNetPremF" style="width: 339px;" tabindex="149" readonly="readonly"/>
						</td>
					</tr>
					<tr id="coverRow">
						<td id="currRateLabel" class="rightAligned">Currency Rate</td>
						<td class="leftAligned">
							<input type="text" id="txtCurrRate" name="txtCurrRate" style="width: 339px;" maxlength="30" tabindex="150" readonly="readonly"/>
						</td>
					</tr>
				</table>
			</div>
		<div class="buttonDiv" id="commissionInquiryButtonDiv" align="center" style="margin: 22px;">
			<input type="button" class="button" id="btnHistory" name="btnHistory" value="History" style="width: 130px;" tabindex="151"/>
			<input type="button" class="button" id="btnDetails" name="btnDetails" value="Details" style="width: 130px;" tabindex="152"/>
			<input type="button" class="button" id="btnPremPayment" name="btnPremPayment" value="Premium Payment" style="width: 130px;" tabindex="153"/>
		</div>
	</div>
	<div id="commissionInquiryTableDiv" class="sectionDiv">
		<div id="commissionInquiryTable" style="padding: 10px 10px 5px 10px; height: 250px;">
		</div>
		<div class="buttonDiv" id="commissionInquiryTableButtonDiv" style="float: left; width: 40%; margin: 0 0 10px 10px;">
			<table>
				<tr height="33px">
					<td><input type="button" class="button" id="btnComBreakdown" name="btnComBreakdown" value="Commission Breakdown" style="width: 180px;"  tabindex="154"/></td>
				</tr>
				<tr>
					<td><input type="button" class="button" id="btnParentCom" name="btnParentCom" value="Parent Commission" style="width: 180px;"  tabindex="155"/></td>
					<td><input type="button" class="button" id="btnForenCurr" name="btnForenCurr" value="Foreign Currency Info" style="width: 180px;"  tabindex="156"/></td>
				</tr>
			</table>
		</div>
		<div id="commissionInquiryTableTotalDiv" style="float: right; width: 55%; margin: 0 7px 30px 20px;" >
			<table align = "right">
				<tr>
					<td class="rightAligned">Totals</td>
					<td class="leftAligned"><input class="rightAligned toForen" type="text" id="txtComAmtTotal" name="txtComAmtTotal" style="width: 92px;" readonly="readonly" tabindex="157"/></td>
					<td><input class="rightAligned" type="text" id="txtWholdingTaxTotal" name="txtWholdingTaxTotal" style="width: 92px;" readonly="readonly" tabindex="158"/></td>
					<td><input class="rightAligned" type="text" id="txtInputVatTaxTotal" name="txtInputVatTaxTotal" style="width: 92px;" readonly="readonly" tabindex="159"/></td>
					<td><input class="rightAligned" type="text" id="txtTotal" name="txtTotal" style="width: 92px;" readonly="readonly" tabindex="160"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Balance Due</td>
					<td class="leftAligned"><input class="rightAligned toForen" type="text" id="txtComAmtBalance" name="txtComAmtBalance" style="width: 92px;" readonly="readonly" tabindex="161"/></td>
					<td><input class="rightAligned" type="text" id="txtWholdingTaxBalance" name="txtWholdingTaxBalance" style="width: 92px;" readonly="readonly" tabindex="162"/></td>
					<td><input class="rightAligned" type="text" id="txtInputVatBalance" name="txtInputVatBalance" style="width: 92px;" readonly="readonly" tabindex="163"/></td>
					<td><input class="rightAligned" type="text" id="txtBalance" name="txtBalance" style="width: 92px;" readonly="readonly" tabindex="164"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>

<script>
	initializeAll();
	setModuleId("GIACS221");
	setDocumentTitle("View Commission Payments per Bill");
	var dispOverridingComm = '${dispOverridingComm}';
	var assuredExist = true;
	var intmExist = true;
	var billNoExist = true;

	try {
		var jsonComInquiry = JSON.parse('${jsonComInquiry}');
		commissionInquiryTableModel = {
			url : contextPath+ "/GIACInquiryController?action=showCommissionInquiry",
			options : {
				height : '250px',
				pager : {},
				onCellFocus : function(element, value, x, y, id) {
					tbgComInquiry.keys.releaseKeys();
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					tbgComInquiry.keys.releaseKeys();
				},
				onSort : function(){
					tbgComInquiry.keys.releaseKeys();
				},
				postPager : function() {
					tbgComInquiry.keys.releaseKeys();
				}
			},
			columnModel : [ 
				{
				    id: 'recordStatus',
				    width: '0',
				    visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false 
				},
				{
			    	id:'branchCd tranClass tranClassNo tranYear tranMonth tranSeqNo dspTranDate',
			    	title: 'Transaction',
			    	width: 395,
			    	titleAlign: 'left',
			    	children: [
			    	   	    {	id: 'branchCd',
						    	width: 50,
						    	sortable: false,
						    	title: 'Branch',
						    },
						    {	id: 'tranClass',
						    	width: 50,
						    	sortable: false,
						    	title: 'Class'
						    },
						    {	id: 'tranClassNo',
						    	width: 60,
						    	align: 'right',
						    	title: 'Class No.',
						    	sortable: false,
						    	titleAlign: 'right',
						    	renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),6);
						    	}
						    },
						    {	id: 'tranYear',
						    	width: 50,
						    	align: 'right',
						    	title: 'Year',
						    	sortable: false,
						    	titleAlign: 'right'
						    },
						    {	id: 'tranMonth',
						    	width: 50,
						    	align: 'right',
						    	title: 'Month',
						    	titleAlign: 'right',
						    	sortable: false,
					    		renderer: function(value){
						    		return nvl(value,'') == '' ? '' :formatNumberDigits(nvl(value, 0),2);
						    	}
						    },
						    {	id: 'tranSeqNo',
						    	width: 50,
						    	align: 'right',
						    	title: 'Seq No.',
						    	sortable: false,
						    	titleAlign: 'right'
						    },
						    {	id: 'dspTranDate',
						    	width: 85,
						    	align: 'center',
						    	title: 'Date',
						    	sortable: false,
						    	titleAlign: 'center'
						    }
			    	          ]
			    },
			    {
			    	id:'refNo commAmt wTaxAmt inputVatAmt netComm',
			    	title: '',
			    	width: 475,
			    	titleAlign: 'left',
			    	children: [
						    {	id: 'refNo',
						    	width: 85,
						    	sortable: false,
						    	title: 'Reference No.'
						    },
						    {	id: 'commAmt',
						    	width: 90,
						    	align: 'right',
						    	title: 'Commission',
						    	titleAlign: 'right',
						    	sortable: false,
						    	geniisysClass: "money"
						    },
						    {	id: 'wTaxAmt',
						    	width: 100,
						    	align: 'right',
						    	title: 'Withholding Tax',
						    	titleAlign: 'right',
						    	sortable: false,
						    	geniisysClass: "money"
						    },
						    {	id: 'inputVatAmt',
						    	width: 100,
						    	align: 'right',
						    	title: 'Input VAT',
						    	titleAlign: 'right',
						    	sortable: false,
						    	geniisysClass: "money"
						    },
						    {	id: 'netComm',
						    	width: 100,
						    	align: 'right',
						    	title: 'Net Commission',
						    	titleAlign: 'right',
						    	sortable: false,
						    	geniisysClass: "money"
						    }
			    	          ]
			    },
			],
			rows : jsonComInquiry.rows
		};
		tbgComInquiry = new MyTableGrid(commissionInquiryTableModel);
		tbgComInquiry.pager = jsonComInquiry;
		tbgComInquiry.render('commissionInquiryTable');
		tbgComInquiry.afterRender = function(){
			if ($F("btnForenCurr") == "Foreign Currency Info") {
				hideAndSeekTbg("local");
			} else {
				hideAndSeekTbg("foren");
			}
		};
	} catch (e) {
		showErrorMessage("commissionInquiry.jsp", e);
	}
	
	function setFilter() {
		var obj = new Object();
		obj.assdName = $F("txtAssuredName");
		obj.intmType = $F("txtIntmType");
		obj.refIntmCd = $F("txtRefIntmCd");
		obj.intmName = $F("txtIntmName");
		obj.inceptDate = $F("txtInceptionDate");
		obj.expiryDate = $F("txtExpiryDate");
		return obj;
	}
	
	function showGIACS221IssCdLov(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action : "getGiacs221IssCdLov",
							moduleId : 'GIACS221',
							filterText : ($("txtBillIssCd").readAttribute("lastValidValue").trim() != $F("txtBillIssCd").trim() ? $F("txtBillIssCd").trim() : ""),
							page : 1},
			title: "List of Issue Codes",
			width: 400,
			height: 400,
			columnModel : [ {
								id: "billIssCd",
								title: "Issue Code",
								width : '350px',
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtBillIssCd").readAttribute("lastValidValue").trim() != $F("txtBillIssCd").trim() ? $F("txtBillIssCd").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					$("txtBillIssCd").value = unescapeHTML2(row.billIssCd);
					$("txtBillIssCd").setAttribute("lastValidValue", unescapeHTML2(row.billIssCd));
					
					$("txtPremSeqNo").setAttribute("lastValidValue", "");
					$("txtPremSeqNo").clear();
					$("txtPremSeqNo").focus();
					$("txtPremSeqNo").readOnly = false;
					enableSearch("searchBillNo");
				},
				onCancel: function (){
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBillIssCd").value = $("txtBillIssCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function showBillNoLov() {
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action      : "getGiacs221BillLov",
					moduleId	: "GIACS221",
					issCd		: $F("txtBillIssCd"),
					premSeqNo	: $F("txtPremSeqNo"),
					lineCd      : $F("txtPolLineCd"),
					sublineCd	: $F("txtPolSublineCd"),
					polIssCd	: $F("txtPolIssCd"),
					issueYy		: $F("txtPolIssueYr"),
					polSeqNo	: $F("txtPolSeqNo"),
					renewNo		: $F("txtPolRenewNo"),
					endtIssCd	: $F("txtEndtIssCd"),
					endtYy		: $F("txtEndtIssueYr"),
					endtSeqNo	: $F("txtEndtSeqNo"),
					intmNo		: $F("txtIntmNo"),
					assdNo		: $F("txtAssuredNo"),
					objFilter2   : JSON.stringify(setFilter())
				},
				title : "Bill No. Listing",
				width : 800,
				height : 390,
				filterVersion : "2",
				columnModel : [ {
									id : 'recordStatus',
									title : '',
									width : '0',
									visible : false,
									editor : 'checkbox'
								}, 
								{
									id : 'divCtrId',
									width : '0',
									visible : false
								},
								{
									id : "billNo",
									title : "Bill No.",
									width : '110px',
									filterOption : true
								}, 
								{
									id : "policyNo",
									title : "Policy No.",
									width : '170px',
									filterOption : true
								}, 
								{
									id : "endtNo",
									title : "Endorsement No.",
									width : '110px',
									filterOption : true
								}, 
								{
									id : "assdName",
									title : "Assured Name",
									width : '200px',
									filterOption : true
								},
								{
									id : "intmName",
									title : "Intermediary Name",
									width : '200px',
									filterOption : true
								}
							   ],
				draggable : true,
				autoSelectOneRecord : true,
				onSelect : function(row) {
					if (row != undefined) {
						populateComPayment(row);
						$("txtPremSeqNo").setAttribute("lastValidValue", lpad(nvl(row.premSeqNo,""),12,'0'));
						disableAllFields();
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarPrint"); //vondanix 10.06.2015 SR 5019
						if (objACGlobal.callingForm == "GIACS211"){	// shan 11.17.2014
							fireEvent($("btnToolbarExecuteQuery"), "click");
							disableToolbarButton("btnToolbarEnterQuery");
						}
					}
				},
				onCancel : function(){
					$("txtPremSeqNo").clear();
				},
				onUndefinedRow : function() {
					showMessageBox("No record selected", "I");
					$("txtPremSeqNo").clear();
				}
			});
			
		}catch(e){
			showErrorMessage("showClmListLov", e);
		}
		
	}
	
	function showGiacs221AssuredLov(id){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGIACS221AssuredLOV", //Modified getGiisAssuredLov to getGIACS221AssuredLOV by pjsantos used getGIACS221AssuredLOV instead of getGiisAssuredLov 11/28/2016, to get list of assureds GENQA 5857 
								 filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								 billIssCd : $('txtBillIssCd').value, 
								 page : 1
				},
				title: "List of Assured",
				width: 400,
				height: 400,
				columnModel: [
		 			{
						id : 'assdNo',
						title: 'Assured No.',
						width : '100px',
						align: 'left'
					},
					{
						id : 'assdName',
						title: 'Assured Name',
						width : '280px',
						align: 'left'
					}
				],
				autoSelectOneRecord: true,
				filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
				onSelect: function(row) {
					$("txtAssuredNo").value = lpad(row.assdNo,6,'0');
					$("txtAssuredName").value = unescapeHTML2(row.assdName);
					$("txtAssuredNo").setAttribute("lastValidValue", lpad(row.assdNo,6,'0'));	
					$("txtAssuredName").setAttribute("lastValidValue", unescapeHTML2(row.assdName));	
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel: function (){
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
		}catch(e){
			showErrorMessage("showGiacs221AssuredLov",e);
		}
	}
	
 	function showGiacs221IntermediaryLov(id){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
								 action   : "getGiacs221IntermediaryLov",
								 filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
								 page : 1
				},
				title: "Lists of Intermediaries",
				width: 460,
				height: 400,
				columnModel: [
					{
						id : 'intmType',
						title: 'Intm. Type',
						width : '70px',
						align: 'left'
					},
		 			{
						id : 'intmNo',
						title: 'Intm. No.',
						width : '70px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'refIntmCd',
						title: 'Ref Intm. Cd',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'intmName',
						title: 'Intm. Name',
					    width: '200px',
					    align: 'left'
					}
				],
				autoSelectOneRecord: true,
				filterText : ($(id).readAttribute("lastValidValue").trim() != $F(id).trim() ? $F(id).trim() : "%"),
				onSelect: function(row) {
					if(row != undefined){
						$("txtIntmNo").value = lpad(row.intmNo,12,'0');
						$("txtRefIntmCd").value = unescapeHTML2(row.refIntmCd);
						$("txtIntmName").value = unescapeHTML2(row.intmName);
						$("txtIntmType").value = unescapeHTML2(row.intmType);
						
						$("txtIntmNo").setAttribute("lastValidValue", lpad(row.intmNo,12,'0'));	
						$("txtRefIntmCd").setAttribute("lastValidValue", unescapeHTML2(row.refIntmCd));
						$("txtIntmName").setAttribute("lastValidValue", unescapeHTML2(row.intmName));	
						$("txtIntmType").setAttribute("lastValidValue", unescapeHTML2(row.intmType));
						enableToolbarButton("btnToolbarEnterQuery");
					}
				},
				onCancel: function (){
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$(id).value = $(id).readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
			});
		}catch(e){
			showErrorMessage("showGiacs221IntermediaryLov",e);
		}
	}
	
	function newFormInstance(mode) {
		try{
			resetAllFields();
			$("txtBillIssCd").focus();
			if (dispOverridingComm == "Y") {
				$("btnComBreakdown").show();
			} else {
				$("btnComBreakdown").hide();
			} 
			if (mode == "enterQuery") {
				objACGlobal.hideGIACS221Obj = {};
				objACGlobal.callingForm = null;
				objACGlobal.hideGIACS221Obj.issCd = null;
				objACGlobal.hideGIACS221Obj.premSeqNo = null;
				
				tbgComInquiry.url = contextPath+ "/GIACInquiryController?action=showCommissionInquiry&refresh=1&issCd=&premSeqNo=&intmNo=&commissionAmtL=0";
				tbgComInquiry._refreshList();

			}
			if(objACGlobal.callingForm == "GIACS211"){ //pag tinawag siya ng mga module na yan mag-i-execute query agad.
				//getGiacsCommPaytments("GIACS221", objACGlobal.issCd, objACGlobal.premSeqNo);
				$("txtBillIssCd").value = objACGlobal.issCd;
				$("txtPremSeqNo").value = objACGlobal.premSeqNo;
				showBillNoLov();
			}else if(objACGlobal.callingForm == "GIACS221" && objACGlobal.hideGIACS221Obj.issCd != null && objACGlobal.hideGIACS221Obj.premSeqNo != null){
				enableToolbarButton("btnToolbarEnterQuery");
				getGiacsCommPaytments("GIACS221", objACGlobal.hideGIACS221Obj.issCd, objACGlobal.hideGIACS221Obj.premSeqNo, objACGlobal.hideGIACS221Obj.intmNo);
			}else if(objACGlobal.callingForm == "GIACS288"){ //marco
				enableToolbarButton("btnToolbarEnterQuery");
				getGiacsCommPaytments("GIACS288", objACGlobal.hideGIACS221Obj.issCd, objACGlobal.hideGIACS221Obj.premSeqNo);
			}
			if(objACGlobal.previousModule == "GIACS288"){
				disableToolbarButton("btnToolbarEnterQuery");
			}
		}catch (e) {
			showErrorMessage("newFormInstance",e);
		}
	}
	
	function getGiacsCommPaytments(moduleId,issCd,premSeqNo,intmNo) {
		try {
			new Ajax.Request(contextPath+"/AccountingLOVController",{
				method: "POST",
				parameters : {action : "getGiacs221BillLov",
					          moduleId : moduleId,
					          issCd : issCd,
					          premSeqNo : premSeqNo,
					          intmNo : nvl(intmNo,""),
					          page : 1
				},
				asynchronous: true,
				evalScripts: true,
				onCreate: function (){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						var result = JSON.parse(response.responseText);
						if (result.rows.length > 0) {
							populateComPayment(result.rows[0]);
							executeQuery();
						} else {
							showMessageBox("Query caused no records to be retrieved. Re-enter.","I");
						}
					}
				}
			});
		} catch (e) {
			showErrorMessage("getGiacsCommPaytments",e);
		}
	}
	
	function populateComPayment(obj) {
		try{
			$("txtBillIssCd").value 			= obj			== null ? "" : nvl(obj.billIssCd,"");
			$("txtPremSeqNo").value 			= obj			== null ? "" : lpad(nvl(obj.premSeqNo,""),12,'0');
			$("txtAssuredNo").value 			= obj			== null ? "" : lpad(nvl(obj.assdNo,""),6,'0');
			$("txtAssuredName").value 			= obj			== null ? "" : unescapeHTML2(nvl(obj.assdName,""));
			$("txtPolLineCd").value 			= obj			== null ? "" : nvl(obj.lineCd,"");
			$("txtPolSublineCd").value 			= obj			== null ? "" : nvl(obj.sublineCd,"");
			$("txtPolIssCd").value 				= obj 	 		== null ? "" : nvl(obj.issCd,"");
			$("txtPolIssueYr").value			= obj  			== null ? "" : lpad(nvl(obj.issueYy,""),2,'0');
			$("txtPolSeqNo").value  			= obj  			== null ? "" : lpad(nvl(obj.polSeqNo,""),7,'0');
			$("txtPolRenewNo").value  			= obj  			== null ? "" : lpad(nvl(obj.renewNo,""),2,'0');
			$("txtEndtIssCd").value 			= obj			== null ? "" : nvl(obj.endtIssCd,"");
			$("txtEndtIssueYr").value 			= obj			== null ? "" : obj.endtYy == null ? "" : lpad(obj.endtYy,2,'0');
			$("txtEndtSeqNo").value 			= obj			== null ? "" : obj.endtSeqNo == null? "" : lpad(obj.endtSeqNo,6,'0');
			
			$("txtIntmType").value 				= obj			== null ? "" : nvl(obj.intmType,"");
			$("txtIntmNo").value 				= obj 	 		== null ? "" : lpad(nvl(obj.intmNo,""),12,'0');
			$("txtRefIntmCd").value				= obj  			== null ? "" : nvl(obj.refIntmCd,"");
			$("txtIntmName").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.intmName,"")); 
			$("txtInceptionDate").value  		= obj  			== null ? "" : nvl(obj.inceptDate,"");
			$("txtExpiryDate").value  			= obj  			== null ? "" : nvl(obj.expiryDate,"");
			
			$("txtPolFlag").value  				= obj  			== null ? "" : unescapeHTML2(nvl(obj.polFlag,""));
			$("txtPolStatus").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.polStatus,""));
			$("txtRegPolSw").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.dspRegPolicySw,""));
			
			$("txtComAmt").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.commissionAmtL,""));
			$("txtComAmtF").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.commissionAmtF,""));
			$("txtWholdingTax").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.wholdingTaxL,""));
			$("txtWholdingTaxF").value  		= obj  			== null ? "" : formatCurrency(nvl(obj.wholdingTaxF,""));
			$("txtInputVat").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.inputVatL,""));
			$("txtInputVatF").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.inputVatF,""));
			$("txtNetCom").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.netCommL,""));
			$("txtNetComF").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.netCommF,""));
			$("txtPremAmtCurr").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.shortNameL,""));
			$("txtPremAmtCurrF").value  		= obj  			== null ? "" : unescapeHTML2(nvl(obj.shortNameF,""));
			$("txtPremAmt").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.premiumAmtL,""));
			$("txtPremAmtF").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.premiumAmtF,""));
			$("txtPremPaidCurr").value  		= obj  			== null ? "" : unescapeHTML2(nvl(obj.premPaidSnameL,""));
			$("txtPremPaidCurrF").value  		= obj  			== null ? "" : unescapeHTML2(nvl(obj.premPaidSnameF,""));
			$("txtPremPaid").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.premiumPaidL,""));
			$("txtPremPaidF").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.premiumPaidF,""));
			$("txtNetPrem").value  				= obj  			== null ? "" : formatCurrency(nvl(obj.netPremiumAmtL,""));
			$("txtNetPremF").value  			= obj  			== null ? "" : formatCurrency(nvl(obj.netPremiumAmtF,""));
			$("txtCurrRate").value  			= obj  			== null ? "" : unescapeHTML2(nvl(obj.currencyRtF,""));
		} catch(e){
			showErrorMessage("populateComPayment", e);
		}
	}
	
 	function disableAllFields() {
		try{
			disableToolbarButton("btnToolbarExecuteQuery");
			$$("div#commissionInquiryBodyDiv input[type='text']").each(function (a) {
				$(a).readOnly = true;
			});
			$$("div.withIconDiv").each(function (b) {
				$(b).setStyle({
					  backgroundColor: '#EEEEEE'
					});
			});
			$("txtInceptionDate").disabled = true;
			$("txtExpiryDate").disabled = true;
			$$("div#commissionInquiryBodyDiv img").each(function (img) {
				var src = img.src;
				if(nvl(img, null) != null){
					if(src.include("searchIcon.png")){
						disableSearch(img);
					}else if(src.include("but_calendar.gif")){
						disableDate(img); 
					}
				}
			});
		} catch(e){
			showErrorMessage("disableAllFields", e);
		}
	} 
 	
 	function resetAllFields() {
		try{
			hideAndSeek("foren", "local");
			$("coverRow").hide();
			//disableToolbarButton("btnToolbarPrint"); //vondanix 10.06.2015 SR 5019
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			observeBackSpaceOnDate("txtInceptionDate");
			observeBackSpaceOnDate("txtExpiryDate");
			assuredExist = true;
			intmExist = true;
			billNoExist = true;
			objACGlobal.hideGIACS221Obj.unreleaseComm = {};
			objACGlobal.hideGIACS221Obj.notStandardRt = {};
			
			objACGlobal.hideGIACS221Obj.notStandardRt.fromDate = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.toDate = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.branchCd = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.branchName = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.lineCd = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.lineName ="";
			objACGlobal.hideGIACS221Obj.notStandardRt.intmType = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.intmDesc = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.intmNo = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.intmName = "";
			objACGlobal.hideGIACS221Obj.notStandardRt.dateType = "ISSUE_DATE";
			objACGlobal.hideGIACS221Obj.notStandardRt.branchType = "ISS_CD";
			
			objACGlobal.hideGIACS221Obj.unreleaseComm.branchCd = "";
			objACGlobal.hideGIACS221Obj.unreleaseComm.branchName = "";
			objACGlobal.hideGIACS221Obj.unreleaseComm.branchType = "ISS_CD";
			$$("div#commissionInquiryMainDiv input[type='button']").each(function (a) {
				disableButton(a);
			});
			$$("div#commissionInquiryBodyDiv input[type='text'].editable").each(function (a) {
				$(a).readOnly = false;
				$(a).clear();
			});
			$$("div#commissionInquiryBodyDiv input[type='text']").each(function (a) {
				$(a).clear();
			});
			$$("div.withIconDiv").each(function (b) {
				$(b).setStyle({
					  backgroundColor: '#FFFFFF'
					});
			});
			$("txtInceptionDate").disabled = false;
			$("txtExpiryDate").disabled = false;
			$$("div#commissionInquiryBodyDiv img").each(function (img) {
				var src = img.src;
				if(nvl(img, null) != null){
					if(src.include("searchIcon.png")){
						enableSearch(img);
					}else if(src.include("but_calendar.gif")){
						enableDate(img); 
					}
				}
			});
			$("txtBillIssCd").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").clear();
			$("txtPremSeqNo").readOnly = true;
			disableSearch("searchBillNo");
		} catch(e){
			showErrorMessage("disableAllFields", e);
		}
	} 
	
 	function showParentCommOverlay() {
		try{
			overlayParentCommInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showGiacs221ParentComm&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&intmNo="+$F("txtIntmNo"),
					{urlContent: true,
					 title: "Overriding Commission",
					 height: 350,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showParentCommOverlay",e);
		}
	}
	
	function showCommBreakdownOverlay() {
		try{
			var currencyCond = "F";
			if ($F("btnForenCurr") == "Foreign Currency Info") {
				currencyCond = "L";
			}
			overlayCommBreakdownInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showGiacs221CommBreakdown&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") +"&intmNo="+$F("txtIntmNo") + "&currencyCond=" + currencyCond, 
					{urlContent: true,
					 title: "Commission Breakdown",
					 height: 350,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showCommBreakdownOverlay",e);
		}
	}
	
	function showDetailOverlay() {
		try{
			overlayDetailInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showGiacs221Detail&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") + "&intmNo=" + $F("txtIntmNo"), 
					{urlContent: true,
					 title: "Commission Details",
					 height: 350,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showDetailOverlay",e);
		}
	}
	
	function showHistoryOverlay() {
		try{
			var currencyCond = "F";
			if ($F("btnForenCurr") == "Foreign Currency Info") {
				currencyCond = "L";
			}
			overlayHistoryInfo = Overlay.show(contextPath+"/GIACInquiryController?action=showGiacs221History&issCd=" + $F("txtBillIssCd") + "&premSeqNo=" + $F("txtPremSeqNo") + "&currencyCond=" + currencyCond, 
					{urlContent: true,
					 title: "History",
					 height: 350,
					 width: 880,
					 draggable: false
					});
		}catch (e) {
			showErrorMessage("showHistoryOverlay",e);
		}
	} 
	
	function showGiacs221PrintDialog(title, showFileOption){
		giacs221PrintDialogOverlay = Overlay.show(contextPath+"/GIACInquiryController", {
			urlContent : true,
			urlParameters: {action : "showGiacs221PrintDialog",
							showFileOption : showFileOption},
		    title: title,
		    height: 290,
		    width: 380,
		    draggable: true
		});
	}
	
	function hideAndSeek(toHideClass,toShowClass) {
		$$("div#commissionInquiryMainDiv input[type='text']."+toShowClass).each(function (a) {
			$(a).show();
		});
		$$("div#commissionInquiryMainDiv input[type='text']."+toHideClass).each(function (a) {
			$(a).hide();
		});
	}
	
	function hideAndSeekTbg(toShowCol) {
		if (toShowCol == "foren") {
			for ( var i = 0; i < tbgComInquiry.geniisysRows.length; i++) {
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("commAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].commAmtF,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("wTaxAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].wTaxAmtF,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("inputVatAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].inputVatAmtF,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("netComm") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].netCommF,0));
			}
			for ( var i = 0; i < tbgComInquiry.geniisysRows.length; i++) {
				$("txtComAmtTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totCommAmtF,0));
				$("txtWholdingTaxTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totWTaxAmtF,0));
				$("txtInputVatTaxTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totInputVatF,0));
				$("txtTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totalF,0));
				
				$("txtComAmtBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdCommAmtF,0));
				$("txtWholdingTaxBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdWTaxAmtF,0));
				$("txtInputVatBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdInputVatF,0));
				$("txtBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].balDueF,0));
				break;
			}		
		} else {
			for ( var i = 0; i < tbgComInquiry.geniisysRows.length; i++) {
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("commAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].commAmt,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("wTaxAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].wTaxAmt,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("inputVatAmt") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].inputVatAmt,0));
				$('mtgIC' + tbgComInquiry._mtgId + '_' + tbgComInquiry.getColumnIndex("netComm") + ',' + i).innerHTML = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].netComm,0));
			}
			for ( var i = 0; i < tbgComInquiry.geniisysRows.length; i++) {
				$("txtComAmtTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totCommAmt,0));
				$("txtWholdingTaxTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totWTaxAmt,0));
				$("txtInputVatTaxTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].totInputVat,0));
				$("txtTotal").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].total,0));
				
				$("txtComAmtBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdCommAmt,0));
				$("txtWholdingTaxBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdWTaxAmt,0));
				$("txtInputVatBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].bdInputVat,0));
				$("txtBalance").value = formatCurrency(nvl(tbgComInquiry.geniisysRows[i].balDue,0));
				break;
			}		
		}
	}
	function executeQuery() {
		try {
			disableToolbarButton("btnToolbarExecuteQuery");
			//enableToolbarButton("btnToolbarPrint"); //vondanix 10.07.2015 SR 5019
			disableAllFields();
			$$("div#commissionInquiryMainDiv input[type='button']").each(function (a) {
				enableButton(a);
			});
			tbgComInquiry.url = contextPath+ "/GIACInquiryController?action=showCommissionInquiry&refresh=1&issCd="+$F("txtBillIssCd")
																										 +"&premSeqNo="+$F("txtPremSeqNo")
																										 +"&intmNo="+$F("txtIntmNo")
																										 +"&commissionAmtL="+nvl(unformatCurrency("txtComAmt"),0);
			tbgComInquiry._refreshList();
		} catch (e) {
			showErrorMessage("executeQuery",e);
		}
	}
	
	/* observe */
	$$("div#commissionInquiryBodyDiv input[type='text'].disableDelKey").each(function (a) {
		$(a).observe("keydown",function(e){
			if($(a).readOnly && e.keyCode === 46){
				$(a).blur();
			}
		});
	});
	
	$("searchIssCd").observe("click", showGIACS221IssCdLov);
	$("txtBillIssCd").observe("change", function() {		
		if($F("txtBillIssCd").trim() == "") {
			$("txtBillIssCd").value = "";
			$("txtBillIssCd").setAttribute("lastValidValue", "");
			$("txtPremSeqNo").clear();
			disableSearch("searchBillNo");
		} else {
			if($F("txtBillIssCd").trim() != "" && $F("txtBillIssCd") != $("txtBillIssCd").readAttribute("lastValidValue")) {
				showGIACS221IssCdLov();
			}
		}
	});	
	
	$("searchBillNo").observe("click", showBillNoLov);
	$("txtPremSeqNo").observe("change", function() {		
		if($F("txtPremSeqNo").trim() == "") {
			$("txtPremSeqNo").value = "";
			$("txtPremSeqNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPremSeqNo").trim() != "" && $F("txtPremSeqNo") != $("txtPremSeqNo").readAttribute("lastValidValue")) {
				showBillNoLov();
			}
		}
	});	
	
	$("searchAssuredNo").observe("click", function() {
		showGiacs221AssuredLov("txtAssuredNo");
	});
	$("txtAssuredNo").observe("change", function() {		
		if($F("txtAssuredNo").trim() == "") {
			$("txtAssuredNo").value = "";
			$("txtAssuredNo").setAttribute("lastValidValue", "");
			$("txtAssuredName").value = "";
			$("txtAssuredName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtAssuredNo").trim() != "" && $F("txtAssuredNo") != $("txtAssuredNo").readAttribute("lastValidValue")) {
				showGiacs221AssuredLov("txtAssuredNo");
			}
		}
	});	
	
	$("searchAssuredName").observe("click", function() {
		showGiacs221AssuredLov("txtAssuredName");
	});
	$("txtAssuredName").observe("change", function() {		
		if($F("txtAssuredName").trim() == "") {
			$("txtAssuredName").value = "";
			$("txtAssuredName").setAttribute("lastValidValue", "");
			$("txtAssuredNo").value = "";
			$("txtAssuredNo").setAttribute("lastValidValue", "");
		} else {
			if($F("txtAssuredName").trim() != "" && $F("txtAssuredName") != $("txtAssuredName").readAttribute("lastValidValue")) {
				showGiacs221AssuredLov("txtAssuredName");
			}
		}
	});
	
	function clearIntmValue() {
		$("txtIntmNo").clear();
		$("txtRefIntmCd").clear();
		$("txtIntmName").clear();
		$("txtIntmType").clear();
		$("txtIntmNo").setAttribute("lastValidValue", "");	
		$("txtRefIntmCd").setAttribute("lastValidValue", "");
		$("txtIntmName").setAttribute("lastValidValue", "");	
		$("txtIntmType").setAttribute("lastValidValue", "");
	}
	
	
	$("searchIntmType").observe("click", function() {
		showGiacs221IntermediaryLov("txtIntmType");
	});
	$("txtIntmType").observe("change", function() {		
		if($F("txtIntmType").trim() == "") {
			clearIntmValue();
		} else {
			if($F("txtIntmType").trim() != "" && $F("txtIntmType") != $("txtIntmType").readAttribute("lastValidValue")) {
				showGiacs221IntermediaryLov("txtIntmType");
			}
		}
	});
	
	$("searchIntmNo").observe("click", function() {
		showGiacs221IntermediaryLov("txtIntmNo");
	});
	$("txtIntmNo").observe("change", function() {		
		if($F("txtIntmNo").trim() == "") {
			clearIntmValue();
		} else {
			if($F("txtIntmNo").trim() != "" && $F("txtIntmNo") != $("txtIntmNo").readAttribute("lastValidValue")) {
				showGiacs221IntermediaryLov("txtIntmNo");
			}
		}
	});
	
	$("searchRefIntmCd").observe("click", function() {
		showGiacs221IntermediaryLov("txtIntmNo");
	});
	$("txtRefIntmCd").observe("change", function() {		
		if($F("txtRefIntmCd").trim() == "") {
			clearIntmValue();
		} else {
			if($F("txtRefIntmCd").trim() != "" && $F("txtRefIntmCd") != $("txtRefIntmCd").readAttribute("lastValidValue")) {
				showGiacs221IntermediaryLov("txtRefIntmCd");
			}
		}
	});
	
	$("searchIntmName").observe("click", function() {
		showGiacs221IntermediaryLov("txtIntmName");
	});
	$("txtIntmName").observe("change", function() {		
		if($F("txtIntmName").trim() == "") {
			clearIntmValue();
		} else {
			if($F("txtIntmName").trim() != "" && $F("txtIntmName") != $("txtIntmName").readAttribute("lastValidValue")) {
				showGiacs221IntermediaryLov("txtIntmName");
			}
		}
	});
	
	$("txtInceptionDate").observe("focus", function(){
		if ($("txtExpiryDate").value != "" && this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtInceptionDate")),Date.parse($("txtExpiryDate").value)) == -1) {
				customShowMessageBox("Inception date should not be later than Expiry Date. Please re-enter","E","txtInceptionDate");
				this.clear();
			}
		}
	});
	
	$("txtExpiryDate").observe("focus", function(){
		if ($("txtInceptionDate").value != ""&& this.value != "") {
			if (compareDatesIgnoreTime(Date.parse($F("txtInceptionDate")),Date.parse($("txtExpiryDate").value)) == -1) {
				customShowMessageBox("Inception date should not be later than Expiry Date. Please re-enter","E","txtExpiryDate");
				this.clear();
			}
		}
	});
	
	$("btnHistory").observe("click", function(){
		showHistoryOverlay();
	});
	
	$("btnDetails").observe("click", function(){
		showDetailOverlay();
	});
	
	$("btnComBreakdown").observe("click", function(){
		showCommBreakdownOverlay();
	});
	
	$("btnParentCom").observe("click", function(){
		showParentCommOverlay();
	});
	
	$("btnPremPayment").observe("click", function(){
		//to call the module GIACS211
		if (objACGlobal.callingForm != "GIACS211" || objACGlobal.previousModule == "GIACS288") {
			objACGlobal.callingForm = "GIACS221";
		} 
		objACGlobal.issCd = $F("txtBillIssCd");
		objACGlobal.premSeqNo = $F("txtPremSeqNo");
		objACGlobal.intmNo = $F("txtIntmNo");
		showBillPayment(objACGlobal.callingForm,objACGlobal.issCd,objACGlobal.premSeqNo,objACGlobal.intmNo);
	});
	
	$("btnForenCurr").observe("click", function(){
		if (this.value == "Foreign Currency Info") {
			this.value = "Local Currency Info";
			$("coverRow").show();
			hideAndSeek("local", "foren");
			hideAndSeekTbg("foren");
		} else {
			this.value = "Foreign Currency Info";
			$("coverRow").hide();
			hideAndSeek("foren", "local");
			hideAndSeekTbg("local");
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		if(objACGlobal.callingForm == "GIACS211"){
			//when called by GIACS211
			showBillPayment(objACGlobal.callingForm,objACGlobal.issCd,objACGlobal.premSeqNo);
		}else if (objACGlobal.callingForm == "GIACS288" || objACGlobal.previousModule == "GIACS288") {
			//showBillsByIntermediary("Y"); //marco
			$("otherModuleDiv").hide();	// replacement for code above : shan 11.12.2014
			$("otherModuleDiv").update();
			$("billsByIntmMainDiv").show();
		}else{
			objACGlobal.callingForm = null;
			objACGlobal.issCd = null;
			objACGlobal.premSeqNo = null;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
// 		showCommissionInquiry();
		newFormInstance("enterQuery");
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		executeQuery();
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGiacs221PrintDialog("Print",true);
	});
	
	newFormInstance("onLoad");
</script>