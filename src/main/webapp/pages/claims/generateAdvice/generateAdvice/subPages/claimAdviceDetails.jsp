<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Claim Advice Details</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" id="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv">
	<div id="claimAdviceTableDiv" style="padding: 10px 0 10px 10px;">
		<div id="claimAdviceTable" style="height: 200px"></div>
	</div>
	<div id="hiddenCurrencyFieldsDiv" style="visibility: hidden; display: none;">
		<input type="hidden" id="hidPaidFcurrAmt">
		<input type="hidden" id="hidNetFcurrAmt">
		<input type="hidden" id="hidAdvFcurrAmt">
		<input type="hidden" id="hidOldCurr">
	</div>
	<div align="center" style="margin-bottom: 10px;">
		<table>
			<tr>
				<td class="rightAligned">Advice No</td>
				<td class="leftAligned"><input type="text" id="txtAdviceNo" style="width: 250px;" readonly="readonly" tabindex="200"></td>
				<td class="rightAligned" width="120">Paid Amount</td>
				<td class="leftAligned"><input type="text" id="txtPaidAmount" style="width: 250px;" class="money" readonly="readonly" tabindex="207"></td>
			</tr>
			<tr>
				<td class="rightAligned">Advice Date</td>
				<td class="leftAligned"><input type="text" id="txtAdviceDate" style="width: 250px;" readonly="readonly" tabindex="201"></td>
				<td class="rightAligned">Net Amount</td>
				<td class="leftAligned"><input type="text" id="txtNetAmount" style="width: 250px;" class="money" readonly="readonly" tabindex="208"></td>
			</tr>			
			<tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<select id="selCurrency" name="selCurrency" style="float: left; width: 257px;" class="required" tabindex="202">
						<option id="optCurrency" name="optCurrency"></option>
						<c:forEach var="curr" items="${currency}">
							<option id="optCurrency${curr.code}" name="optCurrency" value="${curr.code}" currencyRt="${curr.valueFloat}">${curr.desc}</option>
						</c:forEach>
					</select>
				</td>
				<td class="rightAligned">Advice Amount</td>
				<td class="leftAligned"><input type="text" id="txtAdviceAmount" style="width: 250px;" class="money" readonly="readonly" tabindex="209"></td>
			</tr>
			<tr>
				<td class="rightAligned">Convert Rate</td>
				<td class="leftAligned"><input type="text" id="txtConvertRate" style="width: 250px;" class="money" readonly="readonly" tabindex="203"></td>
				<td class="rightAligned">Payee Remarks</td>
				<td class="leftAligned">
					<div id="payeeRemarksDiv" name="payeeRemarksDiv" style="float: left; width: 256px; border: 1px solid gray;"/>
						<!-- <input style="float: left; height: 12px; width: 89.5%; margin-top: 0; border: none;" type="text" id="txtPayeeRemarks" name="txtPayeeRemarks" maxlength="500"  onkeyup="limitText(this,500);" tabindex="210"/> --><!--replaced with textarea - christian 04/19/13-->
						<textarea style="float: left; height: 12px; width: 89.5%; margin-top: 0; border: none;" id="txtPayeeRemarks" name="txtPayeeRemarks" maxlength="500"  onkeyup="limitText(this,500);" tabindex="210"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editPayeeRemarks"  tabindex="211"/>
					</div>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 256px; border: 1px solid gray;"/>
						<!-- <input style="float: left; height: 12px; width: 89.5%; margin-top: 0; border: none;" type="text" id="txtRemarks" name="txtRemarks" maxlength="500" onkeyup="limitText(this,500);" tabindex="204"/> --><!--replaced with textarea - christian 04/12/13-->
						<textarea style="float: left; height: 12px; width: 89.5%; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="500" onkeyup="limitText(this,500);" tabindex="204"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="205"/>
					</div>
				</td>
				<td class="rightAligned"></td>
				<td align="center">
					<input type="button" class="button" id="btnLocalCurrency" value="Local Currency" style="width: 150px;" tabindex="212">
				</td>
			</tr>
			<tr>
				<td>
				</td>
				<td colspan="3">
					<label id="lblBatchNo" style="margin-top: 5px; font-weight: bold;">&nbsp;</label>
				</td>				
			</tr>
		</table>
	</div>	
	<div align="center" style="margin: 15px; margin-top: 10px;">
		<input type="button" class="button" id="btnAdviceUpdate" value="Update" tabindex="206">
	</div>
</div>
<script type="text/javascript">	
	function onCurrencyChange(){
		try {
			if($F("selCurrency") == objGICLS032.vars.localCurrency){
				$("txtConvertRate").writeAttribute("readonly");
				$("txtConvertRate").removeClassName("required");
				
				var convertRate = $("selCurrency").options[$("selCurrency").selectedIndex].getAttribute("currencyRt");
				$("txtConvertRate").writeAttribute("oldConvertRate", convertRate);
				$("txtConvertRate").value = formatToNineDecimal(convertRate);
			} else {
				$("txtConvertRate").removeAttribute("readonly");
				$("txtConvertRate").addClassName("required");

				$("txtConvertRate").writeAttribute("oldConvertRate", objGICLS032.vars.adviceRate);
				$("txtConvertRate").value = formatToNineDecimal(objGICLS032.vars.adviceRate);
			}			
			
			if($F("selCurrency") != "" && $F("selCurrency") != $F("hidOldCurr")){
				$("hidOldCurr").value = $F("selCurrency");
				if(parseFloat($F("txtPaidAmount").replace(/,/g, "")) > 0){
					new Ajax.Request(contextPath+"/GICLAdviceController", {
						method: "POST",
						parameters: {action : "gicls032WhenCurrencyChanged",
									 currencyCd : $F("selCurrency"),
									 adviceRate : objGICLS032.vars.adviceRate,							 
									 localCurrency : objGICLS032.vars.localCurrency,
									 paidAmt : $F("txtPaidAmount"),
									 netAmt : $F("txtNetAmount"),
									 adviseAmt : $F("txtAdviceAmount"),
									 paidFcurrAmt : $F("hidPaidFcurrAmt"),
									 netFcurrAmt : $F("hidNetFcurrAmt"),
									 advFcurrAmt : $F("hidAdvFcurrAmt")
									 },
						onComplete : function(response){
							try {
								if(checkErrorOnResponse(response)){
									var result = JSON.parse(response.responseText);
									
									$("txtPaidAmount").value = formatCurrency(parseFloat(result.paidAmt).toFixed(2));
									$("txtNetAmount").value = formatCurrency(parseFloat(result.netAmt).toFixed(2));
									$("txtAdviceAmount").value = formatCurrency(parseFloat(result.adviseAmt).toFixed(2));
									$("hidPaidFcurrAmt").value = result.paidFcurrAmt;
									$("hidNetFcurrAmt").value = result.netFcurrAmt;
									$("hidAdvFcurrAmt").value = result.advFcurrAmt;
								}
							} catch(e){
								showErrorMessage("onCurrencyChange - onComplete", e);
							}
						}
					});
				}
			}
		} catch(e){
			showMessageBox("onCurrencyChange", e);
		}
	}

	function refreshSelected(){
		if(objGICLS032.objCurrGICLAdvice != null){
			objGICLS032.objCurrGICLAdvice = null;					
			objGICLS032.setClaimAdviceForm(null);					
			objGICLS032.disableEnableButtons();
			tbgClaimAdviceHistory.url = contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&lineCd="+objCLMGlobal.lineCd;
			tbgClaimAdviceHistory._refreshList();
		}
		
		if(objGICLS032.objCurrGICLClmLossExp != null){
			objGICLS032.objCurrGICLClmLossExp = null;						
			tbgClaimAdviceHistory.keys.removeFocus(tbgClaimAdviceHistory.keys._nCurrentFocus, true);
			tbgClaimAdviceHistory.keys.releaseKeys();					
		}
	}
	
	var jsonClaimAdvice = JSON.parse('${jsonClaimAdvice}');	
	claimAdviceTableModel = {
			url : contextPath+"/GICLAdviceController?action=showGICLS032ClaimAdvice&claimId="+objCLMGlobal.claimId+"&refresh=1&lineCd="+objCLMGlobal.lineCd,
			options: {
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgClaimAdvice._mtgId;							
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						objGICLS032.objCurrGICLAdvice = tbgClaimAdvice.geniisysRows[y];
						objGICLS032.objCurrGICLAdvice.rowIndex = y;
						tbgClaimAdviceHistory.url = contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&adviceId="+tbgClaimAdvice.geniisysRows[y].adviceId+"&lineCd="+tbgClaimAdvice.geniisysRows[y].lineCd;
						tbgClaimAdviceHistory._refreshList();
						objGICLS032.tempPayeeNameArray.pop(); //Added by Jerome Bautista 08.25.2015 SR 12213 / 4651
					}
					objGICLS032.setClaimAdviceForm(objGICLS032.objCurrGICLAdvice);
					objGICLS032.disableEnableButtons();
					tbgClaimAdvice.keys.removeFocus(tbgClaimAdvice.keys._nCurrentFocus, true);
					tbgClaimAdvice.keys.releaseKeys();
				},
				prePager: function(){
					refreshSelected();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					var mtgId = tbgClaimAdvice._mtgId;							
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						tbgClaimAdviceHistory.url = contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&adviceId=&lineCd="+tbgClaimAdvice.geniisysRows[y].lineCd;
						tbgClaimAdviceHistory._refreshList();
					} 
					tbgClaimAdvice.keys.removeFocus(tbgClaimAdvice.keys._nCurrentFocus, true);
					tbgClaimAdvice.keys.releaseKeys();
					objGICLS032.objCurrGICLAdvice = null;
					objGICLS032.objCurrGICLClmLossExp = null;
					objGICLS032.vars.vSwitch = null;
					objGICLS032.vars.selectedClmLoss = null;
					objGICLS032.selectedRows = [];
					objGICLS032.setClaimAdviceForm(null);
					objGICLS032.disableEnableButtons();
				},
				afterRender : function (){
					
				},
				onSort : function(){
					refreshSelected();				
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
					id : "adviceNo",
					title: "Advice No.",
					width: '130px'
				},
				{
					id : "adviceDate",
					title: "Advice Date",
					width: '100px',
					titleAlign : 'center',
					align : 'center',
					renderer : function(value){
						return dateFormat(value, 'mm-dd-yyyy');
					}
				},
				{
					id : "currencyDesc",
					title: "Currency",
					width: '120px'
				},
				{
					id : "convertRate",
					title: "Convert Rate",
					width: '120px',
					align: 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatToNineDecimal(value);
					}
				},				
				{
					id : "paidAmt",
					title: "Paid Amount",
					width: '130px',
					align: 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "netAmt",
					title: "Net Amount",
					width: '130px',
					align: 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "adviceAmt",
					title: "Advice Amount",
					width: '130px',
					align: 'right',
					titleAlign : 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "claimId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "adviceId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "lineCd",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "advFlaId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "payeeRemarks",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "remarks",
					title: "",
					width: '0',
					visible: false
				},
/* 				{
					id : "csrNo",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "scsrNo",
					title: "",
					width: '0',
					visible: false
				}, */
				{
					id : "batchCsrId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "batchDvId",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "batchNo",
					title: "",
					width: '0',
					visible: false
				}
			],
			rows: jsonClaimAdvice.rows
		};
	
	tbgClaimAdvice = new MyTableGrid(claimAdviceTableModel);
	tbgClaimAdvice.pager = jsonClaimAdvice;
	tbgClaimAdvice.render('claimAdviceTable');	
	
	$("selCurrency").observe("change", onCurrencyChange);
	$("editRemarks").observe("click", function(){
		//showOverlayEditor("txtRemarks", 500, $("txtRemarks").hasAttribute("readonly")); Nica 12.26.2012
		showOverlayEditor("txtRemarks", 500, $("txtRemarks").hasAttribute("readonly"), function(){
			if(objGICLS032.objCurrGICLAdvice != null){
				enableButton("btnAdviceUpdate");
			}
		});
	});
	$("editPayeeRemarks").observe("click", function(){
		showOverlayEditor("txtPayeeRemarks", 500, $("txtPayeeRemarks").hasAttribute("readonly"));
	});
	
	$("txtRemarks").observe("change", function(){
		if(objGICLS032.objCurrGICLAdvice != null){
			enableButton("btnAdviceUpdate");
		}
	});
	
	$("btnAdviceUpdate").observe("click", function(){
		objGICLS032.objCurrGICLAdvice.payeeRemarks = escapeHTML2($F("txtPayeeRemarks"));
		objGICLS032.objCurrGICLAdvice.remarks = escapeHTML2($F("txtRemarks"));
		objGICLS032.setClaimAdviceForm();
		tbgClaimAdvice.updateRowAt(objGICLS032.objCurrGICLAdvice, objGICLS032.objCurrGICLAdvice.rowIndex);
		changeTag = 1;
		enableButton("btnSave");
	});
	
	$("btnLocalCurrency").observe("click", function(){
		overlayForeignCurrency = 
			Overlay.show(contextPath+"/GICLAdviceController", {
				urlContent: true,
				urlParameters: {action : "showAdviceForeignCurrency",																
								ajax : "1"},
			    title: "Foreign Currency",
			    height: 160,
			    width: 350,
			    draggable: true
			});
	});

	$("txtConvertRate").observe("change", function(){
		if(parseFloat($F("txtConvertRate")) > 100 || parseFloat($F("txtConvertRate")) < 0){
			showWaitingMessageBox("Invalid Convert Rate. Valid value should be from 0.000000000 to 100.000000000", imgMessage.ERROR, function(){
				$("txtConvertRate").value = formatToNineDecimal($("txtConvertRate").readAttribute("oldConvertRate"));
				$("txtConvertRate").focus();
			});
		} else if($F("txtConvertRate").trim() == "") {
			$("txtConvertRate").value = formatToNineDecimal($("txtConvertRate").readAttribute("oldConvertRate"));
		} else {
			$("txtConvertRate").writeAttribute("oldConvertRate", $F("txtConvertRate"));
			$("txtConvertRate").value = formatToNineDecimal($F("txtConvertRate"));
			objGICLS032.vars.adviceRate = $F("txtConvertRate").replace(/,/g, "");
		}
	});
	
	if(tbgClaimAdvice.geniisysRows.length > 0){
		enableMenu("clmGenerateFLA");
	} else {
		disableMenu("clmGenerateFLA");
	}
</script>