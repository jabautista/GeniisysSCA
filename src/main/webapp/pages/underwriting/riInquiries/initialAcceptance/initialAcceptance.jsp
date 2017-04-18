<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>View Initial Acceptance</label>
		<span class="refreshers" style="margin-top: 0;">
 			<label id="btnReloadForm" name="gro" style="margin-left: 5px;">Reload Form</label>
		</span>
	</div>
</div>
<div class="sectionDiv">
	<table align="center" border="0" style="margin: 15px auto;">
		<tr>
			<td><label style="float: right; margin-right: 5px;">Ceding Company</label></td>
			<td>
				<span class="lovSpan required" style="width: 100px; margin-right: 3px; height: 21px;">
					<input type="text" id="txtRiCd" class="integerNoNegativeUnformattedNoComma required" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0; text-align: right;" maxlength="5" tabindex="100" lastValidValue=""/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgRi" alt="Go" style="float: right;"/>
				</span>
				<input type="text" id="txtRiName" style="width: 300px; margin: 0 3px 0 0;" tabindex="101" readonly="readonly" lastValidValue=""/>			
			</td>
		</tr>
	</table>
</div>
<div class="sectionDiv" style="clear: both; float: none; text-align: center; margin-bottom: 50px;">
	<div style="padding: 10px 0 0 10px;">
		<div id="tableGrid" style="height: 300px; margin-left: auto;"></div>
	</div>
	<table align="center" style="margin: 10px auto;" border="0">
		<tr>
			<td class="rightAligned">
				Ref. Accept No.
			</td>
			<td class="leftAligned" style="width: 200px;">
				<input type="text" id="txtRefAcceptNo" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
			<td class="rightAligned" style="width: 140px;">
				Reassured
			</td>
			<td class="leftAligned">
				<input type="text" id="txtReassured" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td style="align: right;">
				RI Policy No.
			</td>
			<td class="leftAligned">
				<input type="text" id="txtRiPolicyNo" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
			<td class="rightAligned">
				RI Binder No.
			</td>
			<td class="leftAligned">
				<input type="text" id="txtRiBinderNo" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
				RI Endt No.
			</td>
			<td class="leftAligned">
				<input type="text" id="txtRiEndtNo" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
			<td class="rightAligned">
				Date Offered
			</td>
			<td class="leftAligned">
				<input type="text" id="txtOfferDate" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
				Offered By
			</td>
			<td class="leftAligned">
				<input type="text" id="txtOfferedBy" style="width: 200px;" tabindex="" readonly="readonly"/>
			</td>
			<td class="rightAligned">
				Amount Offered
			</td>
			<td class="leftAligned">
				<input type="text" id="txtAmountOffered" style="width: 200px; text-align: right;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
				Orig. TSI Amt
			</td>
			<td class="leftAligned">
				<input type="text" id="txtOrigTsiAmt" style="width: 200px; text-align: right;" tabindex="" readonly="readonly"/>
			</td>
			<td class="rightAligned">
				Orig. Premium
			</td>
			<td class="leftAligned">
				<input type="text" id="txtOrigPremAmt" style="width: 200px; text-align: right;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">
				Policy No.
			</td>
			<td colspan="3" class="leftAligned">
				<input type="text" id="txtPolicyNo" style="width: 560px;" tabindex="" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td class="leftAligned" colspan="3">
				<div id="remarksDiv" name="remarksDiv" style="float: left; width: 566px; border: 1px solid gray; height: 22px; margin-top: 2px;">
					<textarea style="float: left; height: 16px; width: 540px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="" readonly="readonly" ignoreDelKey="true"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
				</div>
			</td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	try {

		objGIRIS027 = new Object();
		
		function initGIRIS027(){
			setModuleId("GIRIS027");
			setDocumentTitle("View Initial Acceptance");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarEnterQuery");
			$("btnToolbarPrint").hide();
			$("txtRiCd").focus();
		}
		
		$("btnReloadForm").observe("click", showGIRIS027);
		$("btnToolbarEnterQuery").observe("click", showGIRIS027);
		var giris027TG = {		
				url : contextPath+"/GIRIInpolbasController?action=populateGiris027",
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: 900,
					height: 265,
					hideColumnChildTitle : true,
					onCellFocus : function(element, value, x, y, id) {
						tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
						tableGrid.keys.releaseKeys();
						populateFields(tableGrid.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
						tableGrid.keys.releaseKeys();
						populateFields(null);
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},
					{
						id: "lineCd issCd parYy parSeqNo quoteSeqNo",
						title: "PAR Number",
						children: [
							{
								id: "lineCd",
								title : "Line Cd",
								width: 40,
								filterOption: true
							},
							{
								id: "issCd",
								title : "Iss Cd",
								width: 40,
								filterOption: true
							},
							{
								id: "parYy",
								title : "Par Yy",
								align: "right",
								width: 40,
								filterOption: true,
								filterOptionType: "integerNoNegative"
							},
							{
								id: "parSeqNo",
								title : "Par Seq No.",
								align: "right",
								width: 60,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								renderer: function(val){
									return formatNumberDigits(val, 6);
								}
							},
							{
								id: "quoteSeqNo",
								title : "Quote Seq No.",
								align: "right",
								width: 40,
								filterOption: true,
								filterOptionType: "integerNoNegative",
								renderer: function(val){
									return formatNumberDigits(val, 2);
								}
							}
						]
					},
					{
						id: "assdName",
						title: "Assured",
						width: 300,
						filterOption: true
					},
					{
						id: "acceptNo",
						title : "Acceptance No.",
						align: "right",
						titleAlign: "right",
						width: 110,
						filterOption: true,
						filterOptionType: "integerNoNegative",
						renderer: function(val){
							return formatNumberDigits(val, 6);
						}
					},
					{
						id: "acceptDate",
						title: "Accept Date",
						align: "center",
						titleAlign : "center",
						width: 110,
						filterOption: true,
						filterOptionType : "formattedDate",
						renderer: function(val){
							return dateFormat(val, "mm-dd-yyyy");
						}
					},
					{
						id: "acceptBy",
						title: "Accepted By",
						width: 120,
						filterOption: true
					}
					
				],
				rows: []
			};
		
		tableGrid = new MyTableGrid(giris027TG);
		tableGrid.pager = [];
		tableGrid.render('tableGrid');
		tableGrid.afterRender = function(){
			tableGrid.keys.removeFocus(tableGrid.keys._nCurrentFocus, true);
			tableGrid.keys.releaseKeys();
			populateFields(null);
		};
		
		function populateFields(obj){
			try {
				if(obj == null) {
					$("txtRefAcceptNo").clear();
					$("txtReassured").clear();
					$("txtRiPolicyNo").clear();
					$("txtRiBinderNo").clear();
					$("txtRiEndtNo").clear();
					$("txtOfferDate").clear();
					$("txtOfferedBy").clear();
					$("txtAmountOffered").clear();
					$("txtOrigTsiAmt").clear();
					$("txtOrigPremAmt").clear();
					$("txtPolicyNo").clear();
					$("txtRemarks").clear();
				} else {
					$("txtRefAcceptNo").value = obj.refAcceptNo;
					$("txtReassured").value = unescapeHTML2(obj.riName);
					$("txtRiPolicyNo").value = unescapeHTML2(obj.riPolicyNo);
					$("txtRiBinderNo").value = unescapeHTML2(obj.riBinderNo);
					$("txtRiEndtNo").value = unescapeHTML2(obj.riEndtNo);
					$("txtOfferDate").value = obj.offerDate == null ? "" : dateFormat(obj.offerDate, "mm-dd-yyyy");
					$("txtOfferedBy").value = unescapeHTML2(obj.offeredBy);
					$("txtAmountOffered").value = formatCurrency(obj.amountOffered);
					$("txtOrigTsiAmt").value = formatCurrency(obj.origTsiAmt);
					$("txtOrigPremAmt").value = formatCurrency(obj.origPremAmt);
					$("txtRemarks").value = unescapeHTML2(obj.remarks);
					
					if(obj.parStatus == 10)
						$("txtPolicyNo").value = unescapeHTML2(obj.policyNo);
					else
						$("txtPolicyNo").clear();
				}
			} catch (e) {
				showErrorMessage("populateFields", e);
			}
		}
		
		function executeQuery(){
			tableGrid.url = contextPath+"/GIRIInpolbasController?action=populateGiris027&riCd=" + removeLeadingZero($F("txtRiCd"));
			tableGrid._refreshList();			
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgRi");
			$("txtRiCd").readOnly = true;
		}
		
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		
		function getRiLov() {
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGiris027RiLov",
					filterText : ($F("txtRiCd") == $("txtRiCd").readAttribute("lastValidValue") ? "" : $F("txtRiCd")),
					page : 1
				},
				title : "List of Cedants",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "riCd",
					title : "Cedant Code",
					width : 100,
					align: "right",
					titleAlign : "right",
					renderer: function(val){return formatNumberDigits(val, 5);}
				}, {
					id : "riName",
					title : "Cedant Name",
					width : 365,
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtRiCd") == $("txtRiCd").readAttribute("lastValidValue") ? "" : $F("txtRiCd")),
				onSelect : function(row) {
					$("txtRiCd").value = formatNumberDigits(row.riCd, 5);
					$("txtRiName").value = unescapeHTML2(row.riName);
					$("txtRiCd").setAttribute("lastValidValue", $("txtRiCd").value);
					$("txtRiName").setAttribute("lastValidValue", $("txtRiName").value);
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function () {
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
					$("txtRiName").value = $("txtRiName").readAttribute("lastValidValue");
					$("txtRiCd").focus();
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtRiCd");
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
					$("txtRiName").value = $("txtRiName").readAttribute("lastValidValue");
					$("txtRiCd").focus();			
				}
			});
		}
		
		$("imgRi").observe("click", function(){
			getRiLov();
		});
		
		$("txtRiCd").observe("change", function(){
			enableToolbarButton("btnToolbarEnterQuery");
			if($F("txtRiCd").trim() == ""){
				$("txtRiCd").clear();
				$("txtRiCd").setAttribute("lastValidValue", "");
				$("txtRiName").clear();
				$("txtRiName").setAttribute("lastValidValue", "");
				disableToolbarButton("btnToolbarExecuteQuery");
				return;
			}
			getRiLov();
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		$("editRemarks").observe("click", function(){
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
		});
		
		initializeAll();
		initGIRIS027();
		
	} catch (e) {
		showErrorMessage("initialAcceptance.jsp" , e);
	}
</script>