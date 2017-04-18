<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="" class="sectionDiv">	
	<table align="center" border="0" width="82%" style="margin-top: 10px; margin-bottom: 10px;">
		<tr>
			<td class="rightAligned" 	width="14%" id="tdTotalItemTsiAmt">Total Item TSI Amt.</td>
			<td class="leftAligned" 	width="16%"><input type="text" class="money1" value="0" maxlength="17" id="txtItemTsiAmt"	name="txtItemTsiAmt" style="width: 96%; text-align: right;" readonly="readonly"/></td>
			<td class="rightAligned" 	width="18%" id="tdTotalItemPremAmt">Total Item Premium Amt.</td>
			<td class="leftAligned" 	width="16%"><input type="text" class="money1" value="0" maxlength="17" id="txtItemPremAmt"	name="txtItemPremAmt" style="width: 96%; text-align: right;" readonly="readonly"/></td>
		</tr>
		<tr>
			<td class="rightAligned" id="tdTotalItemAnnTsiAmt">Total Item Ann. TSI Amt.</td>
			<td class="leftAligned"><input type="text" class="money1" value="0" maxlength="17" id="txtItemAnnTsiAmt" name="txtItemAnnTsiAmt" style="width: 96%; text-align: right;" readonly="readonly"/></td>
			<td class="rightAligned" id="tdTotalItemAnnPremAmt">Total Item Ann. Premium Amt.</td>
			<td class="leftAligned"><input type="text" class="money1" value="0" maxlength="17" id="txtItemAnnPremAmt" name="txtItemAnnPremAmt" style="width: 96%; text-align: right;" readonly="readonly"/></td>
		</tr>
	</table>
</div>
<div id="planDiv" style="" class="sectionDiv">
	<table align="center" border="0" width="82%" style="margin-top: 5px; margin-bottom: 5px;">
		<tr>
			<td class="rightAligned" width="160px">DSP_PLAN</td>
			<td class="leftAligned" width="">
				<input type="text" id="dspPackageCd" name="dspPackageCd" style="width: 175px;"/>
			</td>
		</tr>
	</table>
</div>
<div id="endtPerilInformation" style="" class="sectionDiv">
	<div id="endtPerilTableDiv" style="padding: 10px 0 10px 10px;">
		<div id="endtPerilTable" style="height: 200px"></div>
	</div>
	<div id="itemPerilFormDiv" style="margin-top: 5px; padding-left: 80px; padding-right: 50px;" changeTagAttr="true">
		<table align="center" border="0" width="100%">
			<tr>
				<td class="rightAligned" width="9%">Peril Name</td>
				<td class="leftAligned" width="18%">
					<div style="float: left; border: solid 1px gray; width: 99%; height: 21px;" class="required" >
						<!-- <input type="hidden" id="hidPerilCd" name="hidPerilCd" style="display: none;"/>
						<input type="hidden" id="hidBasicPerilCd" name="hidBasicPerilCd" style="display: none;" /> -->
						<input type="text" style="float: left; margin-top: 0px; width: 86%; border: none;" name="txtPerilName" id="txtPerilName" readonly="readonly" value="" class="required" />
						<img id="searchPeril" alt="Go" style="height: 18px;"  class="" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
				<td class="rightAligned" width="12%">Premium Rate</td>
				<td class="leftAligned" width="18%"><input type="text" class="percentRate required" value="0" maxlength="13" style="width: 96%;" id="txtPremRt" name="txtPremRt" /></td>
				<td rowspan="4" style="width: 14%;" id="sideButtonsTd">
					<table border="0" align="center">
						<tr align="center">
							<td><input id="btnRetrievePerils" class="disabledButton" type="button" style="width: 100%;" value="Retrieve Perils"	name="btnRetrievePerils" /></td>
						</tr>
						<tr align="center">
							<td><input id="btnDeleteDiscounts" class="disabledButton" type="button" style="width: 100%;" value="Delete Discounts" name="btnDeleteDiscounts" /></td>
						</tr>
						<tr align="center">
							<td><input id="btnCopyPeril" class="disabledButton"	type="button" style="width: 100%;" value="Copy Peril" name="btnCopyPeril" /></td>
						</tr>
						<!-- <tr align="center" id="btnCommContainer">
							<td><input id="btnCommission" class="button" type="button" style="width: 100%;" value="Commission" name="btnCommission" /></td>
						</tr> -->
					</table>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="tdTsiAmt">TSI Amt.</td>
				<td class="leftAligned"><input type="text" class="money required" value="0" maxlength="17" id="txtTsiAmt" name="txtTsiAmt" style="width: 96%; text-align: right;" /></td>
				<td class="rightAligned" id="tdPremAmt">Premium Amt.</td>
				<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="txtPremAmt" name="txtPremAmt" style="width: 96%; text-align: right;" /></td>
			</tr>
			<tr>
				<td class="rightAligned" id="tdAnnTsiAmt">Ann. TSI Amt.</td>
				<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="txtAnnTsiAmt"	name="txtAnnTsiAmt" style="width: 96%; text-align: right;" readonly="readonly" /></td>
				<td class="rightAligned" id="tdAnnPremAmt">Ann. Premium Amt.</td>
				<td class="leftAligned"><input type="text" class="money1 required" value="0" maxlength="17" id="txtAnnPremAmt" name="txtAnnPremAmt" style="width: 96%; text-align: right;" readonly="readonly" /></td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblRiAmtTd">Comm. Amount</td>
				<td class="leftAligned"  id="inputRiAmtTd"><input type="text" class="money2" value="0" maxlength="12" id="txtRiCommAmt" name="txtRiCommAmt" style="width: 96%; text-align: right;" /></td>
				<td class="rightAligned" id="lblRiRateTd">RI Rate</td>
				<td class="leftAligned"  id="inputRiRateTd"><input type="text" class="percentRate" value="0" maxlength="12" id="txtRiCommRate" name="txtRiCommRate" style="width: 96%; text-align: right;"/></td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblBaseAmtTd">Base Amount</td>
				<td class="leftAligned"  id="inputBaseAmtTd"><input type="text" class="money2" value="0" maxlength="5" id="txtBaseAmt" name="txtBaseAmt" style="width: 96%;" readonly="readonly" /></td>
				<td class="rightAligned" id="lblDaysNoTd">Number of Days</td>
				<td class="leftAligned"  id="inputDaysNoTd"><input type="text" class="" value="0" maxlength="5" id="txtNoOfDays" name="txtNoOfDays" style="width: 96%; text-align: right; text-align: right;" /></td>
			</tr>	
			<tr>
				<td class="rightAligned" id="lblTariffCdTd">Tariff Code</td>
				<td class="leftAligned"	 id="inputTariffCdTd">
					<div style="float: left; border: solid 1px gray; width: 99%; height: 21px;">
						<input type="hidden" id="hidTarfCd" name="hidTarfCd" style="display: none;"/>
						<input type="text" style="float: left; margin-top: 0px; width: 86%; border: none;" name="txtTarfDesc" id="txtTarfDesc" readonly="readonly" value=""/>
						<img id="searchTarfCd" alt="Go" style="height: 18px;"  class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
					<%-- <select name="inputPerilTariff" id="inputPerilTariff" style="width: 100%;">
						<option value=""></option>
					</select>
					<c:forEach var="peril" items="${perilsList}">					
						<select name="selTarfCd" id="selTarfCd" style="width: 100%;">
							<option value=""></option>
							<c:forEach var="tariff" items="${perilTariffs}">
								<c:if test="${peril.perilCd eq tariff.perilCd}">
									<option tarfRate="${tariff.tarfRate}" value="${tariff.tarfCd}">
										<c:if test="${empty tariff.tarfDesc}">${tariff.tarfCd}</c:if>
										${tariff.tarfDesc}
									</option>
								</c:if>
							</c:forEach>
						</select>
					</c:forEach> --%>							
				</td>	
				<td colspan="3"></td>
			</tr>
			<tr>
				<td class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<%-- <div id="remarksDiv" name="remarksDiv" style="float: left; width: 256px; border: 1px solid gray;"/>
						<input style="float: left; height: 12px; width: 89.5%; margin-top: 0; border: none;" type="text" id="txtCompRem" name="txtCompRem" maxlength="500" onkeyup="limitText(this,500);" tabindex=""/>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex=""/>
					</div> --%>
					<input type="text" id="txtCompRem" name="txtCompRem" maxlength="50" style="width: 98.5%;" />
				</td>
			</tr>
			<tr>
				<td colspan="5" align="center">
					<input id="btnAddPeril" class="button" type="button" value="Add" name="btnAddPeril"	style="width: 60px; margin-top: 5px; margin-bottom: 5px;"/> 
					<input id="btnDeletePeril" class="disabledButton" type="button"	value="Delete" name="btnDeletePeril" style="width: 60px;" /> 
				</td>
			</tr>
		</table>
	</div>
</div>
<div style="display: none;">
	<table align="center" border="0" width="82%">
		<tr>			
			<td class="rightAligned" width="8%">Item No.</td>
			<td><input type="text" class="required" value="1" maxlength="17" id="itemNo" name="itemNo" style="width: 96%;" /></td>
			<td><input type="hidden" class="required" value="1" maxlength="17" id="itemNumbers" name="itemNumbers" style="width: 96%;" /></td>
			<td><input type="hidden" class="required" value="1" maxlength="17" id="tempItemNumbers" name="tempItemNumbers" style="width: 96%;" /></td>
		</tr>
		<tr>		
			<td class="rightAligned" width="8%">Inception Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="inceptDate" name="inceptDate" style="width: 96%;" /></td>
			<td class="rightAligned" width="8%">Expiry Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="expiryDate" name="expiryDate" style="width: 96%;" /></td>
		</tr>
		<tr>
			<td class="rightAligned" width="8%">Effectivity Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="effDate" name="effDate" style="width: 96%;" /></td>
			<td class="rightAligned" width="8%">Endt. Expiry Date</td>
			<td class="leftAligned" width="18%"><input type="text" class="required" value="0" maxlength="17" id="endtExpiryDate" name="endtExpiryDate" style="width: 96%;" /></td>
		</tr>
	</table>
</div>

<script type="text/javascript">	
	var objGIPIS097 = {};	
	
	var jsonEndtPeril = JSON.parse('${jsonEndtPeril}');	
	endtPerilTableModel = {
			url : contextPath+"/GIPIWItemPerilController?action=showEndtPerilInfoTG&globalParId="+$F("globalParId")+"&refresh=1",
			options: {
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					var mtgId = tbgEndtPeril._mtgId;							
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
						objGIPIS097.objCurrEndtPeril = tbgEndtPeril.geniisysRows[y];
						objGIPIS097.objCurrEndtPeril.rowIndex = y;						
					}
					objGIPIS097.setEndtPerilFormTG(objGIPIS097.objCurrEndtPeril);
					tbgEndtPeril.keys.removeFocus(tbgEndtPeril.keys._nCurrentFocus, true);
					tbgEndtPeril.keys.releaseKeys();
				},
				prePager: function(){
					//refreshSelected();
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					/* var mtgId = tbgEndtPeril._mtgId;							
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){						
						tbgEndtPerilHistory.url = contextPath+"/GICLClaimLossExpenseController?action=getGICLClmLossExpList&claimId="+objCLMGlobal.claimId+"&adviceId=&lineCd="+tbgEndtPeril.geniisysRows[y].lineCd;
						tbgEndtPerilHistory._refreshList();
					} 
					
					objGIPIS097.objCurrEndtPeril = null;
					objGIPIS097.objCurrGICLClmLossExp = null;
					objGIPIS097.setClaimAdviceForm(null);
					objGIPIS097.disableEnableButtons(); */
					objGIPIS097.setEndtPerilFormTG();
					tbgEndtPeril.keys.removeFocus(tbgEndtPeril.keys._nCurrentFocus, true);
					tbgEndtPeril.keys.releaseKeys();
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
					id : "aggregateSw",
					title: "A",
					altTitle: "Aggregate",
					width: '23px',
					editor: 'checkbox',
					sortable: false,
					renderer: function(value){
						return (value == "Y" ? true : false);
					}
				},
				{
					id : "surchargeSw",
					title: "S",
					altTitle: "w/ Surcharge",
					width: '23px',
					editor: 'checkbox',
					sortable: false,
					renderer: function(value){
						return (value == "Y" ? true : false);
					}
				},
				{
					id : "discountSw",
					title: "D",
					altTitle: "w/ Discount",
					width: '23px',
					editor: 'checkbox',
					sortable: false,
					renderer: function(value){
						return (value == "Y" ? true : false);
					}
				},
				{
					id : "itemNo",
					title: "Item No.",
					width: '50px',
					sortable: false,
					align: 'right'
				},
				{
					id : "perilCd",
					title: "",
					width: '0',
					visible: false
				},
				{
					id : "perilName",
					title: "Peril Name",
					width: '180px'
				},
				{
					id : "premRt",
					title: "Peril Rate",
					width: '90px',
					align: 'right',
					renderer: function(value){
						return formatToNineDecimal(value);
					}
				},
				{
					id : "tsiAmt",
					title: "TSI Amt",
					width: '110px',
					align: 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "annTsiAmt",
					title: "Ann TSI Amt",
					width: '110px',
					align: 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "premAmt",
					title: "Premium Amt",
					width: '110px',
					align: 'right',
					renderer: function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "annPremAmt",
					title: "Ann Premium Amt",
					width: '110px',
					align: 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				},
				{
					id : "riCommRate",
					title: "RI Rate",
					width: '110px',
					align: 'right',
					renderer : function(value){
						return formatToNineDecimal(value);
					}
				},
				{
					id : "riCommAmt",
					title: "Commission Amt",
					width: '110px',
					align: 'right',
					renderer : function(value){
						return formatCurrency(value);
					}
				}
			],
			rows: jsonEndtPeril.rows
		};
	
	tbgEndtPeril = new MyTableGrid(endtPerilTableModel);
	tbgEndtPeril.pager = jsonEndtPeril;
	tbgEndtPeril.render('endtPerilTable');
	
	function setEndtPerilFormTG(row){
		try {
			$("txtPerilName").value = row == null ? "" : unescapeHTML2(row.perilName);
			$("txtPerilName").writeAttribute("perilCd", row == null ? "" : row.perilCd);
			$("txtPerilName").writeAttribute("basicPerilCd", row == null ? "" : row.basicPerilCd);
			$("txtTsiAmt").value = row == null ? "" : formatCurrency(row.tsiAmt);
			$("txtAnnTsiAmt").value = row == null ? "" : formatCurrency(row.annTsiAmt);
			$("txtPremAmt").value = row == null ? "" : formatCurrency(row.premAmt);
			$("txtAnnPremAmt").value = row == null ? "" : formatCurrency(row.annPremAmt);
			$("txtPremRt").value = row == null ? "" : formatToNineDecimal(row.premRt);
			$("txtRiCommRate").value = row == null ? "" : formatCurrency(row.riCommRate);
			$("txtRiCommAmt").value = row == null ? "" : formatCurrency(row.riCommAmt);
			$("txtBaseAmt").value = row == null ? "" : formatCurrency(row.baseAmt);
			$("txtNoOfDays").value = row == null ? "" : formatCurrency(row.noOfDays);
			$("hidTarfCd").value = row == null ? "" : formatCurrency(row.tarfCd);
			$("txtTarfDesc").value = row == null ? "" : formatCurrency(row.tarfDesc);
			$("txtCompRem").value = row == null ? "" : formatCurrency(row.compRem);
			
			$("btnAddPeril").value = row == null ? "Add" : "Update";
			if(row == null){
				disableButton("btnDeletePeril");
				enableSearch("searchPeril");
			} else {
				enableButton("btnDeletePeril");
				disableSearch("searchPeril");
			}
			
			
		} catch(e){
			showErrorMessage("setEndtPerilFormTG", e);	
		}			
	}
	objGIPIS097.setEndtPerilFormTG = setEndtPerilFormTG;
	objGIPIS097.setEndtPerilFormTG();
	
 	$("searchPeril").observe("click", function(){ 		
		var notIn = "";
		var withPrevious = false;
		var withSelectedRow = false;
/* 		$$("div#perilTableContainerDiv div[name='rowEndtPeril']").each(function(row){		
			if(row.hasClassName("selectedRow")){	
				withSelectedRow = true;
			} 
			if(row.getAttribute("item") == $F("itemNo")){
				if(withPrevious) notIn += ",";
				notIn += row.down("input", 1).value;
				withPrevious = true;
			}			
		});*/
		//if(!withSelectedRow){
			notIn = (notIn != "" ? "("+notIn+")" : "");
			var perilType = null; 
			if(notIn == null || notIn == ""){
				perilType = "B";
			}
			showEndtPerilLOV($F("globalLineCd"), objGIPIWPolbas.sublineCd, perilType, notIn);
		//}
	});
 	
 	$("searchTarfCd").observe("click", function(){ 	
 		showTariffByPeril($F("globalLineCd"), $("txtPerilName").readAttribute("perilCd"));
 	});
 	
 	//initializeAll();
 	initializeAllMoneyFields();
</script>