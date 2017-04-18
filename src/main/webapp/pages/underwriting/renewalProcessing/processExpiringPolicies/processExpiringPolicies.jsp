<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="processExpPolMainDiv" name="processExpPolMainDiv">
	<div id="processExpPolMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<form id="processExpPolForm" name="processExpPolForm">
		<div id="processExpPolFormDiv">
			<div id="outerDiv" name="outerDiv">
				<div id="innerDiv" name="innerDiv">
					<label>Expiring Policies for Renewal</label>
					<span class="refreshers" style="margin-top: 0;">
						<label name="gro" style="margin-left: 5px;">Hide</label> 
				 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
					</span>
				</div>
			</div>
			<div id="renewExpPolBLock" class="sectionDiv" style=" margin-bottom:30px; ">
				<div id="renewExpPolMainDIv" style="margin: 10px; margin-bottom:20px; display: block; position: relative;"  >
					<div id="renewExpPolTableGridSectionDiv" style="height: 360px; margin-left: 5px;">
						<div id="renewExpPolTableGridDiv">
							<div id="renewExpPolTableGrid"changeTagAttr="true"></div>
						</div>			
					</div>
					<div id="buttonsDiv" style="text-align: center; margin-top:10px; margin-right: 150px; margin-bottom: 10px;">
						<div>
							<input type="button" class="button" id="btnDetails" value="Details" style="width: 120px;"/>
							<input type="button" class="button" id="btnEdit" value="Edit" style="width: 120px;"/>
							<input type="button" class="button" id="btnPurge" value="Purge" style="width: 120px;"/>
							<!-- <input type="button" class="button" id="btnEmail" value="Email Renewal" style="width: 120px;"/> -->
							<input type="button" class="button" id="btnSave" value="Save" style="width: 120px;"/>
						</div>
						<div style="margin-top:5px;">
							<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px;"/>
							<input type="button" class="button" id="btnQuery" value="Query" style="width: 120px;"/>
							<input type="button" class="button" id="btnUpdate" value="Update" style="width: 120px;"/>
							<!-- <input type="button" class="button" id="btnSMS" value="SMS Renewal" style="width: 120px;"/> -->
							<input type="button" class="button" id="btnProcess" value="Process" style="width: 120px;"/>
						</div>
					</div>
					<div id="remarksBlock" name="remarksBlock" style="margin: 10px;  display: block; margin-top: 10px; margin-left: 130px;" changeTagAttr="true">
						<table>
							<!-- <tr>
								<td class="rightAligned" width="140px">SMS Status</td>
								<td class="leftAligned" width="330px">
									<input id="nbtSMSStatus" class="leftAligned" type="text" name="nbtSMSStatus" style="width: 98%;" readonly="readonly" disabled="disabled"/>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" width="140px">Email Status</td>
								<td class="leftAligned" width="330px">
									<input id="nbtEmailStatus" class="leftAligned" type="text" name="nbtEmailStatus" style="width: 98%;" readonly="readonly" disabled="disabled"/>
								</td>
							</tr> -->
							<tr>
								<td class="rightAligned" width="140px">Reason for Non-renewal</td>
								<td class="leftAligned" width="330px">
									<div style="float: left; border: solid 1px gray; width: 26%; height: 20px; margin-right: 4.5px; margin-bottom: 2px;" class="withIconDIv required">
										<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 67%; border: none; height: 14px;" name="nonRenReasonCd" id="nonRenReasonCd" disabled="disabled" class="upper" maxlength="4"/>
										<img id="nonRenReasonCdLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
									</div>
									<div style="float: left; width: 70%;">
										<input id="nonRenReason" class="leftAligned upper" type="text" name="nonRenReason" style="float: left; margin-top: 0px; margin-right: 3px; border: solid 1px gray; height: 14px; width: 100%" value="" maxlength="2000" disabled="disabled" class="upper" />
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned" width="140px">Remarks</td>
								<td class="leftAligned" width="330px">
									<div style="border: 1px solid gray; height: 20px; width: 99.8%" changeTagAttr="true">
										<textarea onKeyDown="limitText(this,4000);" onKeyUp="limitText(this,4000);" id="remarks" name="remarks" style="width: 92%; border: none; height: 13px; resize: none;" disabled="disabled"></textarea>
										<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
									</div>
								</td>
							</tr>
						</table>				
					</div>
					<div id="process" style="padding-top: 10px; padding-left: 40px; float: left; height: 30px; width: 450px; margin-left: 130px; margin-bottom: 20px; margin-top: 10px;" class="sectionDiv" changeTagAttr="true">
						<input type="hidden" id="processTag" name="processTag"value="S">
						<label style="float: left; margin-left: 5px; margin-top: 3px;">Process:</label>
						<input type="radio" value="T" id="tagAll" name="process" tabindex="1" style="float: left; margin-left: 30px;"/> <label for="tagAll" style="float: left; margin-top: 3px; margin-left: 4px;">Tag All</label>
						<input type="radio" value="U" id="untagAll" name="process" tabindex="2" style="float: left; margin-left: 30px;"/> <label for="untagAll" style="float: left; margin-top: 3px; margin-left: 4px;">Untag All</label>
						<input type="radio" value="S" id="selectedPolicies" name="process" tabindex="3"  checked="checked"style="float: left; margin-left: 30px;"/> <label for="selectedPolicies" style="float: left; margin-top: 3px; margin-left: 4px;">Selected Policies</label>
					</div>
					<div style="position: absolute; top:375px; left: 690px; width:170px; height:172px;  display: block; background-color: yellow;" class="sectionDiv">
						<div  id="legend" style="float: none; margin-left: 20px; margin-top: 15px;">
							<label>Legend:</label><br><br>
							<label>P - Process Policy </label><br>
							<label>NR - Non-Renewal</label><br>
							<label>R - Renewal</label><br>
							<label>AR - Auto Renewal</label><br>
							<label>SP - Same Policy</label><br>
							<label>S - Summarized Policy</label><br>
							<label>B - w/ Balance Premium</label><br>
							<label>C - Claim(s)</label><br>
							<label>L - Special Policy</label><br>
						</div>
					</div>
					<div id="hidden" style="display: none;">
						<input type="hidden" id="dspLineCd" name="dspLineCd">
						<input type="hidden" id="dspIssCd" name="dspIssCd">
						<input type="hidden" id="packPolicyId" name="packPolicyId">
						<input type="hidden" id="policyId" name="policyId">
						<input type="hidden" id="isPackage" name="isPackage">	
						<input type="hidden" id="fromPostQuery" name="fromPostQuery">
						<input type="hidden" id="balanceFlag" name="balanceFlag">
						<input type="hidden" id="nbtLineCd" name="nbtLineCd">	
						<input type="hidden" id="nbtSublineCd" name="nbtSublineCd">
						<input type="hidden" id="nbtIssCd" name="nbtIssCd">
						<input type="hidden" id="nbtIssueYy" name="nbtIssueYy">
						<input type="hidden" id="nbtPolSeqNo" name="nbtPolSeqNo">
						<input type="hidden" id="nbtRenewNo" name="nbtRenewNo">	
						<input type="hidden" id="polPrem" name="polPrem">
						<input type="hidden" id="origPolPrem" name="origPolPrem">
						<input type="hidden" id="parId" name="parId">
						<input type="hidden" id="lineCd" name="lineCd">
						<input type="hidden" id="issCd" name="issCd">	
						<input type="hidden" id="parYy" name="parYy">
						<input type="hidden" id="parSeqNo" name="parSeqNo">
						<input type="hidden" id="quoteSeqNo" name="quoteSeqNo">
						<input type="hidden" id="parType" name="parType">
						<input type="hidden" id="assdNo" name="assdNo">	
						<input type="hidden" id="distSw" name="distSw">
						<input type="hidden" id="dspRenewFlag" name="dspRenewFlag">
						<input type="hidden" id="polTsi" name="polTsi">	
						<input type="hidden" id="origPolTsi" name="origPolTsi">
						<input type="hidden" id="userId" name="userId">
						<input type="hidden" id="lastUpdate" name="lastUpdate">
						<input type="hidden" id="dateFormat" name="dateFormat">
						<input type="hidden" id="lcMn" name="lcMn">
						<input type="hidden" id="lcPa" name="lcPa">
						<input type="hidden" id="slcTr" name="slcTr">
						<input type="hidden" id="override" name="override">
						<input type="hidden" id="requireNrReason" name="requireNrReason">
						<input type="hidden" id="lineAc" name="lineAc">
						<input type="hidden" id="lineAv" name="lineAv">
						<input type="hidden" id="lineCa" name="lineCa">
						<input type="hidden" id="lineEn" name="lineEn">
						<input type="hidden" id="lineFi" name="lineFi">
						<input type="hidden" id="lineMc" name="lineMc">
						<input type="hidden" id="lineMh" name="lineMh">
						<input type="hidden" id="lineMn" name="lineMn">
						<input type="hidden" id="lineSu" name="lineSu">
						<input type="hidden" id="issRi" name="issRi">
						<input type="hidden" id="sublineCar" name="sublineCar">
						<input type="hidden" id="sublineEar" name="sublineEar">
						<input type="hidden" id="sublineMbi" name="sublineMbi">
						<input type="hidden" id="sublineMlop" name="sublineMlop">
						<input type="hidden" id="sublineDos" name="sublineDos">
						<input type="hidden" id="sublineBpv" name="sublineBpv">
						<input type="hidden" id="sublineEei" name="sublineEei">
						<input type="hidden" id="sublinePcp" name="sublinePcp">
						<input type="hidden" id="sublineOp" name="sublineOp">
						<input type="hidden" id="sublineBbi" name="sublineBbi">
						<input type="hidden" id="sublineMop" name="sublineMop">
						<input type="hidden" id="sublineMrn" name="sublineMrn">
						<input type="hidden" id="sublineOth" name="sublineOth">
						<input type="hidden" id="sublineOpen" name="sublineOpen">
						<input type="hidden" id="vesselCd" name="vesselCd">
						<input type="hidden" id="claimFlag" name="claimFlag">
						<input type="hidden" id="autoSw" name="autoSw">
						<input type="hidden" id="proceed" name="proceed">
						<input type="hidden" id="required" name="required">
						<input type="hidden" id="itmperilExist" name="itmperilExist">
						<input type="hidden" id="functionCd" name="functionCd"value="RB">
						<input type="hidden" id="menuLineCd" name="menuLineCd">
						<input type="hidden" id="updateFlag" name="updateFlag">
						<input type="hidden" id="samePolnoSw" name="samePolnoSw">
						<input type="hidden" id="summarySw" name="summarySw">
						<input type="hidden" id="checkRenewFlag"  />
						<input type="hidden" id="hidProcessor"  />
					</div>
				</div>
			</div>
		</div>
	</form>
</div>
<div id="claimInfoDiv"></div>
<script>
try{
	initializeAccordion();
	makeInputFieldUpperCase();
	
	var clickable = "N";
	var overrideOk = "N";
	var renewFlag = "";
	var balanceFlag = "";
	var claimFlag = "";
	var updateFlag = "";
	var updateFlagClicked = "N";
	var samePolnoSw = "";
	var summarySw= "";
	var regPolicySw = "";
	var renewFlag = "";
	var isPackage = "";
	var policyId = "";
	var nonRenReasonCd = "";
	var nonRenReason = "";
	var processor = "";
	var lineCd = "";
	var issCd = "";
	var required = "";
	var remarks = "";
	var tagAll="";
	var oldProcess = "";
	var deleteItmperil = "N";
	var delPolId = "";
	var exist = '${exist}';
	var allUser = '${allUser}';
	var allowUndistSw = '${allowUndistSw}';
	var needCommit = "N";
	var alertMsg = "";
	var process = "";
	var modified = "";
	var success ="";
	var policyIds = "";
	var initialVars = '${initialVars}'.toQueryParams();
	
	var objExpPol = new Object(); 
	var selectedExpPol = null;
	var selectedExpPolRow = new Object();
	var mtgId = null;
	objExpPol.renewExpPolTableGrid = JSON.parse('${expPolGrid}'.replace(/\\/g, '\\\\')); // andrew - module will be loaded with no record/s by default, user should use the Query button to show records // Modified by Jerome Bautista 04.22.2016 SR 21993
	objExpPol.expPol= objExpPol.renewExpPolTableGrid.rows || []; // Modified by Jerome Bautista 04.22.2016 SR 21993
	
	try {
		var expPolListingTable = {
			//url: contextPath+"/GIEXExpiriesVController?action=refreshQueriedExpPolListing&intmNo=-1&claimSw=-1&balanceSw=-1&rangeType=-1&range=-1", //Commented out and replaced by code below: Jerome Bautista 04.25.2016 SR 21993
			//modified url by gab 11.11.2016 SR 5805
		    url: contextPath+"/GIEXExpiriesVController?action=refreshQueriedExpPolListing&intmNo="+nvl(objGIEXExpiry.intmNo, '')
					+"&intmName="+objGIEXExpiry.intmName+"&claimSw="+nvl(objGIEXExpiry.claimSw,'')+"&balanceSw="+nvl(objGIEXExpiry.balanceSw,'')+"&rangeType="+nvl(objGIEXExpiry.rangeType,'')
					+"&range="+nvl(objGIEXExpiry.range,'')+"&fmDate="+nvl(objGIEXExpiry.fmDate, '')+"&toDate="+nvl(objGIEXExpiry.toDate, '')+"&fmMon="+nvl(objGIEXExpiry.fmMon, '')+"&fmYear="+nvl(objGIEXExpiry.fmYear,'')
					+"&toMon="+nvl(objGIEXExpiry.toMon, '')+"&toYear="+nvl(objGIEXExpiry.toYear, '')+"&lineCd="+objGIEXExpiry.lineCd+"&sublineCd="+encodeURIComponent(objGIEXExpiry.sublineCd) // objGIEXExpiry.sublineCd  //dren 09.09.2015 SR: 0020086 - Modified to display subline correctly for "H+1/H+2" when doing query
					+"&issCd="+objGIEXExpiry.issCd+"&issueYy="+nvl(objGIEXExpiry.issueYy,'')+"&polSeqNo="+nvl(objGIEXExpiry.polSeqNo, '')+"&renewNo="+nvl(objGIEXExpiry.renewNo, ''),
			options: {
				title: '',
				width: '895px',
				height: '326px',
				postPager: function(){
					whenProcessTypeChanged();
					needCommit = "N";
/* 					if($F("processTag")=="S"){ // comment out by andrew for SR 4942, tagging/untagging is already handled in updateFlag column options
						var rows = expPolGrid.geniisysRows;
						for(var i=0; i<rows.length;  i++){
							if (rows[i].updateFlag == "Y"){
								$("mtgInput1_"+expPolGrid.getColumnIndex("updateFlag")+','+i).checked = true;
							}else{
								$("mtgInput1_"+expPolGrid.getColumnIndex("updateFlag")+','+i).checked = false;
							}
						}
					} */
				},
				onCellFocus: function(element, value, x, y, id) {
					mtgId = expPolGrid._mtgId;
					selectedExpPol = y;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedExpPolRow = expPolGrid.geniisysRows[y];
						$("dspLineCd").value = selectedExpPolRow.lineCd;
						$("dspIssCd").value = selectedExpPolRow.issCd;
						$("packPolicyId").value = selectedExpPolRow.packPolicyId;
						$("policyId").value = selectedExpPolRow.policyId;
						$("isPackage").value = selectedExpPolRow.isPackage;
						$("claimFlag").value = selectedExpPolRow.claimFlag;
						$("autoSw").value = selectedExpPolRow.autoSw;
				
						//$("nbtSMSStatus").enable();
						//$("nbtEmailStatus").enable();
						$("nonRenReasonCd").enable();
						$("nonRenReason").enable();
						$("remarks").enable();
						$("editRemarks").show();
						//$("remarks").up("div",0).removeClassName("disabled");
						$("nonRenReasonCd").setStyle('width : 80px');
						$("remarks").setStyle('width : 303px');
						postQueryGIEXS004();
						clickable = "Y";
						$("remarks").value = expPolGrid.getValueAt(expPolGrid.getColumnIndex("remarks"),selectedExpPol);
						$("nonRenReasonCd").value = expPolGrid.getValueAt(expPolGrid.getColumnIndex("nonRenReasonCd"),selectedExpPol);
						$("nonRenReason").value = expPolGrid.getValueAt(expPolGrid.getColumnIndex("nonRenReason"),selectedExpPol); 
						//var renew = expPolGrid.getValueAt(expPolGrid.getColumnIndex('renewFlag'), selectedExpPol);
						//if(renew != "1" ){
						if(!$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked){
							 $("nonRenReasonCd").disable();
							 $("nonRenReasonCdLOV").hide();
							 $("nonRenReasonCd").setStyle('width : 80px');
							 $("nonRenReason").disable();
							 $("nonRenReasonCd").removeClassName("withIcon upper required");
							 $("nonRenReason").removeClassName("upper required");
							 $("nonRenReasonCd").value = "";
							 $("nonRenReason").value = "";
						}else{
							$("nonRenReasonCd").writeAttribute("class","withIcon upper required");
							$("nonRenReason").writeAttribute("class","upper required");
							$("nonRenReasonCdLOV").show();
							$("nonRenReasonCd").setStyle('width : 57px');
						}
					}
				},
				onRemoveRowFocus : function(){
					//$("nbtSMSStatus").disable();
					//$("nbtEmailStatus").disable();
					$("nonRenReasonCd").disable();
					$("nonRenReasonCdLOV").hide();
					//$("nonRenReasonCd").up("div",0).addClassName("disabled");
					$("nonRenReason").disable();
					$("nonRenReasonCd").writeAttribute("class","upper ");
					$("nonRenReason").writeAttribute("class","upper ");
					$("remarks").disable(); 		
					$("editRemarks").hide();
					//$("remarks").up("div",0).addClassName("disabled");
					$("nonRenReasonCd").setStyle('width : 80px');
					$("remarks").setStyle('width : 322px');
					clearFields();
					clickable = "N";
					selectedExpPol = null;
					expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
					expPolGrid.keys.releaseKeys();
			  	},
			  	onSort: function(){
			  		expPolGrid.onRemoveRowFocus();
			  	},
			  	onRefresh: function(){
			  		expPolGrid.onRemoveRowFocus();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN],
					onSave: function(){
						saveOnChangeTag();
					}
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
					id: 'policyId',
					width: '0',
					visible: false
				},
				{	
					id: 'isPackage',
					width: '0',
					visible: false
				},
				{	
					id: 'nonRenReasonCd',
					width: '0',
					visible: false
				},
				{	
					id: 'nonRenReason',
					width: '0',
					visible: false
				},
				{	
					id: 'remarks',
					width: '0',
					visible: false
				},
				{	
					id: 'delPolId',
					width: '0',
					visible: false
				},
				{	
					id: 'deleteItmPeril',
					width: '0',
					visible: false
				},
				{	
					id: 'required',
					width: '0',
					visible: false
				},
				{	
					id: 'distSw',
					width: '0',
					visible: false
				},
				{	id:'updateFlag',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;P',
					altTitle: 'Process Policy',
					width:		'25px',
					editable:  true,
					hideSelectAllBox: true,
					selectable: false,
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
				{
					id:"renewFlag",
					sortable:false,
					editable:true,
					title: '&#160;NR',
					altTitle: 'Non-Renewal',
					width: '25px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "1";
							}
						},
						onClick: function(value,checked){
							 expPolGrid.setValueAt("1", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);
							$("nonRenReasonCd").enable();
							$("nonRenReason").enable();
							$("nonRenReasonCd").writeAttribute("class","withIcon upper required");
							$("nonRenReason").writeAttribute("class","upper required");
							$("nonRenReasonCd").focus();
							$("nonRenReasonCdLOV").show();
							$("nonRenReasonCd").setStyle('width : 57px');
							expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
							expPolGrid.keys.releaseKeys();
							//checkRenewFlagGIEXS004();
							executeWhenRadionBtnChange(); 
						}
					})
				},
				{
					id:"renewFlag",
					sortable:false,
					editable:true,
					title: '&#160;&#160;R',
					altTitle: 'Renewal',
					width: '25px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "2";
							 }/*  else {
								return "N";
							 } */
						},
						onClick: function(value,checked){
							expPolGrid.setValueAt("2", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);
							expPolGrid.setValueAt("", expPolGrid.getColumnIndex("nonRenReasonCd"), selectedExpPol, true);
							expPolGrid.setValueAt("", expPolGrid.getColumnIndex("nonRenReason"), selectedExpPol, true);
							$("nonRenReasonCd").disable();
							$("nonRenReason").disable();
							$("nonRenReasonCd").writeAttribute("class","upper");
							$("nonRenReason").writeAttribute("class","upper");
							$("nonRenReasonCd").value = "";
							$("nonRenReason").value = "";
							$("nonRenReasonCdLOV").hide();
							$("nonRenReasonCd").setStyle('width : 80px');
							//checkRenewFlagGIEXS004();
							$("nonRenReasonCd").disable();
							$("nonRenReasonCdLOV").hide();
							$("nonRenReason").disable();
							executeWhenRadionBtnChange();
						}
					})
				},
				{
					id:"renewFlag",
					sortable:false,
					editable:true,
					title: '&#160;AR',
					altTitle: 'Auto Renewal',
					width: '25px',
					radioGroup: 'renewFlagGroup',
					editor: new MyTableGrid.CellRadioButton({
						getValueOf: function (value){
							 if (value){
								return "3";
							}
						},
						onClick: function(value,checked){
							expPolGrid.setValueAt("3", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);
							expPolGrid.setValueAt("", expPolGrid.getColumnIndex("nonRenReasonCd"), selectedExpPol, true);
							expPolGrid.setValueAt("", expPolGrid.getColumnIndex("nonRenReason"), selectedExpPol, true);
							$("nonRenReasonCd").disable();
							$("nonRenReason").disable();
							$("nonRenReasonCd").writeAttribute("class","upper");
							$("nonRenReason").writeAttribute("class","upper");
							$("nonRenReasonCd").value = "";
							$("nonRenReason").value = "";
							$("nonRenReasonCdLOV").hide();
							$("nonRenReasonCd").setStyle('width : 80px');
							//checkRenewFlagGIEXS004();	
							executeWhenRadionBtnChange();
						}
					})
				},
				{	id:			'samePolnoSw',
					sortable:	false,
					align:		'center',
					title:		'&#160;SP',
					altTitle: 'Same Policy',
					width:		'25px',
					editable:  true,
					hideSelectAllBox: true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked) {
							needCommit = "Y";
							 if(expPolGrid.getValueAt(expPolGrid.getColumnIndex('renewFlag'), selectedExpPol) == "1" &&
								expPolGrid.getValueAt(expPolGrid.getColumnIndex('samePolnoSw'), selectedExpPol) == "Y"  ){
								 showWaitingMessageBox("Only renewal or auto-renewal policy can be tagged for same policy no.","I", function(){
									 //$("mtgInput"+mtgId+"_15,"+selectedExpPol).checked = false; joanne 02.10.14, replace by code below
	            					 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("samePolnoSw")+','+selectedExpPol).checked = false;
								 });
							 }
	 			    	}
		            })
				},
				{
					id: 'policyNo',
					title: 'Policy Number',
					width: '170',
					titleAlign: 'left',
					align: 'left',
					editable: false
				}, 
				{
					id: 'dspTsi',
					title: 'Ren TSI Amt.',
					width: '80',
					titleAlign: 'center',
					align: 'right',
					geniisysClass: 'money',
					editable: false
				}, 
				{
					id: 'dspPrem',
					title: 'Ren Prem Amt.',
					width: '90',
					titleAlign: 'center',
					align: 'right',
					geniisysClass: 'money',
					editable: false
				},
				{
					id: 'tsiAmt',
					title: 'TSI Amt.',
					width: '80',
					titleAlign: 'center',
					align: 'right',
					geniisysClass: 'money',
					editable: false
					//sortable: false
				},
				{
					id: 'premAmt',
					title: 'Prem Amt.',
					width: '80',
					titleAlign: 'center',
					align: 'right',
					geniisysClass: 'money',
					editable: false
					//sortable: false
				},
				{
					id: 'expiryDate',
					title: 'Expiry Date',
					type: 'date',
					format: $F("dateFormat"),
					width: '75',
					titleAlign: 'center',
					align: 'center',
					editable: false
				},
				{
					id: 'extractUser',
					title: 'Extract User',
					width: '80',
					editable: false
				},
				{
					id: 'processor',
					title: 'Processor',
					width: '85'
				},				
				{
					id: 'credBranch',
					title: 'Cred. Branch',
					width: '80'
				},	
				{	id:			'summarySw',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;S',
					altTitle: 'Summarized Policy',
					titleAlign:	'center',
					width:		'25px',
					editable:  true,
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}	
		            	},
		            	onClick: function(value, checked) {
		            		needCommit = "Y";
		            		 if(expPolGrid.getValueAt(expPolGrid.getColumnIndex('renewFlag'), selectedExpPol) == "3" &&
								expPolGrid.getValueAt(expPolGrid.getColumnIndex('summarySw'), selectedExpPol) == "Y"  ){
								 showWaitingMessageBox("Summarized policy option is not available for policy tagged as auto renewal.","I",function(){
	            					 //$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false; joanne 02.07.14, replace by code below
	            					 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("summarySw")+','+selectedExpPol).checked = false;
								 });
							 }
		            		 if($F("itmperilExist") == "1"){
		            			 showConfirmBox("Confirm","Changing option for summarized policy would cause the deletion of all edited perils of this policy. Do you want to continue?",
				            					 "Yes","No",
				            			function(){
		            				 			expPolGrid.setValueAt($F("policyId"), expPolGrid.getColumnIndex("delPolId"), selectedExpPol, true);		
		            							expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("deleteItmPeril"), selectedExpPol, true);	
		            					 },function(){
		            						 if(expPolGrid.getValueAt(expPolGrid.getColumnIndex('summarySw'), selectedExpPol) == "N"){
		            							 //$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = true; joanne 02.07.14, replace by code below
		            							 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("summarySw")+','+selectedExpPol).checked = true;
				            				 }else{
				            					 //$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false; joanne 02.07.14, replace by code below
				            					 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("summarySw")+','+selectedExpPol).checked = false;
				            				 }
		            					 });	 
		            		 }	 
	 			    	}
		            })
				},
				{	id:			'balanceFlag',
					sortable:	false,
					editable: false,
					align:		'center',
					title:		'&#160;&#160;B',
					altTitle: 'w/  Balance Premium',
					titleAlign:	'center',
					width:		'25px',
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
				{	id:			'claimFlag',
					sortable:	false,
					editable: false,
					align:		'center',
					title:		'&#160;&#160;C',
					altTitle: 'Claim(s)',
					titleAlign:	'center',
					width:		'25px',
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
				{	id:			'regPolicySw',
					sortable:	false,
					editable: false,
					align:		'center',
					title:		'&#160;L',
					altTitle: 'Special Policy',
					titleAlign:	'center',
					width:		'25px',
					editor: new MyTableGrid.CellCheckbox({
			            getValueOf: function(value){
		            		if (value){
								return "N";
		            		}else{
								return "Y";	
		            		}	
		            	}
		            })
				},
				{	
					id: 'lineCd',
					width: '0',
					visible: false
				},
				{	
					id: 'issCd',
					width: '0',
					visible: false
				},
				{	
					id: 'renewFlagGroup',
					width: '0',
					visible: false
				}
			],
			resetChangeTag: true,
			//rows: [] //objExpPol.expPol // Commented out and replaced by Jerome Bautista 04.22.2016 SR 21993
			rows: objExpPol.expPol
		};
		expPolGrid = new MyTableGrid(expPolListingTable);
		//expPolGrid.pager = {};//objExpPol.renewExpPolTableGrid; // Commented out and replaced by Jerome Bautista 04.22.2016 SR 21993
		expPolGrid.pager = objExpPol.renewExpPolTableGrid;
		expPolGrid.render('renewExpPolTableGrid');
		expPolGrid.afterRender = function(){
			try {
				if(expPolGrid.geniisysRows.length == 0){
					if(objGIEXExpiry.querySw == "Y"){
						$("mtgPagerMsg"+expPolGrid._mtgId).innerHTML = "<strong>No records found. Use Query button to view record/s.</strong>";
					} else {
						$("mtgPagerMsg"+expPolGrid._mtgId).innerHTML = "<strong>Use Query button to view record/s.</strong>";
					}
				}
				
				if(expPolGrid.geniisysRows.length > 0) {
					$$("div#renewExpPolTableGrid .mtgInput"+expPolGrid._mtgId+"_"+expPolGrid.getColumnIndex('updateFlag')).each(function(obj){
						obj.observe("click", function(){
							updateFlagClicked = "Y";
						});
					});
				}
			}catch(e){
				showErrorMessage("expPolGrid.afterRender", e);
			}
		}
	}catch(e) {
		showErrorMessage("expPolGrid", e);
	}
	
	function onClickUpdateFlag(){
		try {
			function proceedOnClick(){
				try {
					needCommit = "Y";
					if(expPolGrid.getValueAt(expPolGrid.getColumnIndex('updateFlag'), selectedExpPol) == "Y"  &&
							 $F("distSw")=="N") {
						 if(nvl(allowUndistSw,"N")=="N"){
							 showWaitingMessageBox("Only records with policy and its endorsement that are fully distributed can be processed.","I", function(){
								 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
								 expPolGrid.setValueAt("N", expPolGrid.getColumnIndex("updateFlag"), selectedExpPol, true);	
							 });
						 }
					 }
					 if($F("processTag")=="T" && expPolGrid.getValueAt(expPolGrid.getColumnIndex('updateFlag'), selectedExpPol) == "N"){
						 showWaitingMessageBox("You are not allowed to uncheck procees field of any record because tag all is selected.","I", function(){
							 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = true;
						 });
					 }else if($F("processTag")=="U" && expPolGrid.getValueAt(expPolGrid.getColumnIndex('updateFlag'), selectedExpPol) == "Y"){
						 showWaitingMessageBox("You are not allowed to check procees field of any record because untag all is selected.","I", function(){
							 $("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
						 });
					 }
				} catch(e){
					showErrorMessage("proceedOnClick", e);
				}
			}
		
			if(initialVars.vAllowRenewalOtherUser == "N"){								
				if (userId != expPolGrid.getValueAt(expPolGrid.getColumnIndex('extractUser'), selectedExpPol)){
					if($("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked){
						$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
						expPolGrid.setValueAt("N", expPolGrid.getColumnIndex("updateFlag"), selectedExpPol, true);
					} else {		
						$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = true;
						expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("updateFlag"), selectedExpPol, true);
					}
					
					$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).removeClassName("modifiedCell");
					if(expPolGrid.getModifiedRows().length == 1){
						expPolGrid.modifiedRows = []; // to avoid saving confirmation message on change of page
					}
				} else {
					if($("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked){
						$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = userId;
						expPolGrid.setValueAt(userId, expPolGrid.getColumnIndex("processor"), selectedExpPol, true);
						proceedOnClick();
					} else {
						$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = "";
						expPolGrid.setValueAt("", expPolGrid.getColumnIndex("processor"), selectedExpPol, true);
						proceedOnClick();
					}
				}
			} else if(initialVars.vAllowRenewalOtherUser == "Y"){
				var assignedProcessor = $F("hidProcessor");
				var policyNo = expPolGrid.getValueAt(expPolGrid.getColumnIndex('policyNo'), selectedExpPol);
				if($("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked){
					if(assignedProcessor == "" || assignedProcessor == null) {
						$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = userId;
						expPolGrid.setValueAt(userId, expPolGrid.getColumnIndex("processor"), selectedExpPol, false);
						proceedOnClick(selectedExpPol);
					} else if(assignedProcessor != userId){					
						showConfirmBox2("Confirmation"
										, "Policy "+policyNo+" is being processed by "+assignedProcessor+". Would you like to continue changing the current processor?"
										, "Yes"
										, "No"
										, function(){
											$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = userId;
											expPolGrid.setValueAt(userId, expPolGrid.getColumnIndex("processor"), selectedExpPol, false);
											proceedOnClick();
										}
										, function(){
											$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
											expPolGrid.setValueAt("N", expPolGrid.getColumnIndex("updateFlag"), selectedExpPol, true);
											$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).removeClassName("modifiedCell");
											
											if(expPolGrid.getModifiedRows().length == 1){
												expPolGrid.modifiedRows = []; // to avoid saving confirmation message on change of page
											}
										});
					} else {
						$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = userId;
						expPolGrid.setValueAt(userId, expPolGrid.getColumnIndex("processor"), selectedExpPol, false);
						proceedOnClick();
					}
				} else {
					if(assignedProcessor != "" && assignedProcessor != null && assignedProcessor != "null") {
						showConfirmBox2("Confirmation"
										, "Policy "+policyNo+" is being processed by "+assignedProcessor+". Would you like to continue removing the assigned processor?"
										, "Yes"
										, "No"
										, function(){
											$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = "";
											expPolGrid.setValueAt("", expPolGrid.getColumnIndex("processor"), selectedExpPol, true);
											proceedOnClick();
										}
										, function(){
											$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = true;
											expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("updateFlag"), selectedExpPol, true);
											$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).removeClassName("modifiedCell");
											
											if(expPolGrid.getModifiedRows().length == 1){
												expPolGrid.modifiedRows = []; // to avoid saving confirmation message on change of page
											}															
										});
					} else {
						$("mtgIC"+mtgId+"_"+expPolGrid.getColumnIndex("processor")+','+selectedExpPol).innerHTML = "";
						expPolGrid.setValueAt("", expPolGrid.getColumnIndex("processor"), selectedExpPol, true);
					}					
				}
			}
		} catch(e){
			showErrorMessage("onClickUpdateFlag", e);	
		}			
	}
	
	// checks if there are records in the table giex_expiry
	function checkExpiry(){
		if(exist!=1){
			showWaitingMessageBox("Cannot proceed, no expired policies to process.","E",  
					function () {
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					});
		}
	}
	
	// retrieves details of the selected policy
	function postQueryGIEXS004() {
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=postQueryGIEXS004", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {
						packPolicyId: $F("packPolicyId"),
						policyId:          $F("policyId"),
						isPackage:      $F("isPackage")
					},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = JSON.parse(response.responseText);//.toQueryParams()
							if(result.count>0){
								enableButton("btnPrint");
							}
							$("fromPostQuery").value = result.fromPostQuery;
							$("balanceFlag").value = result.balanceFlag;
							$("nonRenReason").value = unescapeHTML2(result.nonRenReason);
							$("nonRenReasonCd").value = result.nonRenReasonCd;
							$("remarks").value = unescapeHTML2(result.remarks);
							$("nbtLineCd").value = result.nbtLineCd;
							$("nbtSublineCd").value = result.nbtSublineCd;
							$("nbtIssCd").value = result.nbtIssCd;
							$("nbtIssueYy").value = result.nbtIssueYy;
							$("nbtPolSeqNo").value = result.nbtPolSeqNo;
							$("nbtRenewNo").value = result.nbtRenewNo;
							$("polPrem").value = result.polPrem;
							$("origPolPrem").value = result.origPolPrem;
							$("parId").value = result.parId;
							$("lineCd").value = result.lineCd;
							$("issCd").value = result.issCd;
							$("parYy").value = result.parYy;
							$("parSeqNo").value = result.parSeqNo;
							$("quoteSeqNo").value = result.quoteSeqNo;
							$("parType").value = result.parType;
							$("assdNo").value = result.assdNo;
							$("distSw").value = result.distSw;	
							$("dspRenewFlag").value = result.dspRenewFlag;
							$("polTsi").value = result.polTsi;
							$("origPolTsi").value = result.origPolTsi;
							$("userId").value = result.userId;
							$("lastUpdate").value = result.lastUpdate;
							//$("nbtEmailStatus").value = result.nbtEmailStatus;
							//$("nbtSMSStatus").value = result.nbtSmsStatus;
							$("itmperilExist").value = result.itmperilExist;
							$("hidProcessor").value = result.processor;

							if(updateFlagClicked == "Y"){
								updateFlagClicked = "N";
								onClickUpdateFlag();
							}
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("postQueryGIEXS004", e);
		}
	}
	
	//INITIALIZE_DATE_FORMATS program unit
	function initDateFormatGIEXS004() {
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=initDateFormatGIEXS004", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							$("dateFormat").value = ((result.dateFormat).toLowerCase()).replace('rrrr','yyyy');
							$("lcMn").value =result.lcMn;
							$("lcPa").value = result.lcPa;
							$("slcTr").value = result.slcTr;
							//$("override").value = result.override;
							$("requireNrReason").value = result.requireNrReason;
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("initDateFormatGIEXS004", e);
		}
	}
	
	//initialize_line_cd program unit
	function initLineCdGIEXS004(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=initLineCdGIEXS004", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							if(msg!=""){
								showMessageBox(msg,"E");
							}
							$("lineAc").value =result.lineAc;
							$("lineAv").value = result.lineAv;
							$("lineCa").value = result.lineCa;
							$("lineEn").value =result.lineEn;
							$("lineFi").value = result.lineFi;
							$("lineMc").value = result.lineMc;
							$("lineMh").value =result.lineMh;
							$("lineMn").value = result.lineMn;
							$("lineSu").value = result.lineSu;
							$("issRi").value =result.issRi;
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("initLineCdGIEXS004", e);
		}
	}
	
	//initialize_subline_cd program unit -- Initialize the global subline codes
	function initSublineCdGIEXS004(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=initSublineCdGIEXS004", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							if(msg!=""){
								showMessageBox(msg,"E");
							}
							$("sublineCar").value =result.sublineCar;
							$("sublineEar").value = result.sublineEar;
							$("sublineMbi").value = result.sublineMbi;
							$("sublineMlop").value =result.sublineMlop;
							$("sublineDos").value = result.sublineDos;
							$("sublineBpv").value = result.sublineBpv;
							$("sublineEei").value =result.sublineEei;
							$("sublinePcp").value = result.sublinePcp;
							$("sublineOp").value = result.sublineOp;
							$("sublineBbi").value =result.sublineBbi;
							$("sublineMop").value = result.sublineMop;
							$("sublineMrn").value =result.sublineMrn;
							$("sublineOth").value = result.sublineOth;
							$("sublineOpen").value = result.sublineOpen;
							$("vesselCd").value =result.vesselCd;
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
		}catch(e) {
			showErrorMessage("initSublineCdGIEXS004", e);
		}
	}
	
	//delete the record in giex_itmperil
	function deleteItmperilByPolId(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController",{
				method: "POST",
				parameters: {action:"deleteItmperilByPolId",
										policyId: delPolId}
			});
		}catch(e) {
			showErrorMessage("deleteItmperilByPolId", e);
		}
	}
	
	//UPDATE_BALANCE_CLAIM_FLAG program unit
	function updateBalanceClaimFlag(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiryController", {
				method: "POST",
				parameters: {action : "updateBalanceClaimFlag",
										allUser: allUser}, 
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						//showMessageBox("Update successful.", "S");
						//showProcessExpiringPoliciesPage(); // added by irwin . 7/27/2012.
						showWaitingMessageBox("Update successful.", "S", showProcessExpiringPoliciesPage);
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("updateBalanceClaimFlag", e);
		}
	}
	// created by irwin. 8.2012
	function executeWhenRadionBtnChange(){
		try{
			function finalProcess(){
				needCommit = "Y";
				if(renewFlag ==1){
					if($F("requireNrReason")=="Y"){
						$("required").value = "Y";
					}
				} else{
					$("required").value = "N";
				}
				if($F("distSw")=="N"){
					$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
				}else{
					$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = true;
					fireEvent($("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol),"click"); // to properly trigger the change on updateFlag - irwin
				}
				if($F("processTag") == "U"){
					$("processTag").value = "S";
				}
				if(renewFlag == 1){
					$("mtgInput"+mtgId+"_15,"+selectedExpPol).checked = false;
					$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false;
				}else if(renewFlag==3){
					$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false;
				}
			}
			
			function continueProcess(){ // AR process 
				if($F("isPackage") == "Y"){
					new Ajax.Request(contextPath+"/GIEXExpiryController", {
						method: "POST",
						parameters: {action : "arValidationGIEXS004",
												isPackage				: $F("isPackage"),
												fromPostQuery	: $F("fromPostQuery"),			 
												policyId					: $F("policyId"),
												updateFlag			: updateFlag,
												samePolnoSw		: samePolnoSw,
												summarySw			: summarySw,			 
												nonRenReason		: $F("nonRenReason"),
												nonRenReasonCd: $F("nonRenReasonCd")},
						onComplete: function(response){
							if(checkErrorOnResponse(response)){
								var result = response.responseText.toQueryParams();
								var msg = result.msg;
								if(msg==1){
									showConfirmBox("Confirm","Changing option for renew_flag would cause the deletion of all edited perils of this policy. Do you want to continue?", "Yes", "No",
											function(){
												expPolGrid.setValueAt(result.perilPolId, expPolGrid.getColumnIndex("delPolId"), selectedExpPol, true);		
		            							expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("deleteItmPeril"), selectedExpPol, true);
											}, function(){
												$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
												$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
												$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked = false;
												updateRenewFlag();
											});
								}else if(msg==2){
									showConfirmBox("Confirm","Changing option for renew_flag would cause the deletion of all edited perils of this policy. Do you want to continue?", "Yes", "No",
											function(){
												expPolGrid.setValueAt($F("policyId"), expPolGrid.getColumnIndex("delPolId"), selectedExpPol, true);		
		            							expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("deleteItmPeril"), selectedExpPol, true);
											}, function(){
												$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
												$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
												$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked = false;
												updateRenewFlag();
											});
								}else{
									finalProcess();
								}
								
							}else{
								showMessageBox(response.responseText, imgMessage.ERROR);
							}
						}
					});
				}else{
					finalProcess();
				}
			
			
			}
			
			renewFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('renewFlag'), selectedExpPol);
			balanceFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('balanceFlag'), selectedExpPol);
			claimFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('claimFlag'), selectedExpPol);
			updateFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('updateFlag'), selectedExpPol);
			
			if(renewFlag  == "3"){
				if(initialVars.vAllowAR == "N"){
					showWaitingMessageBox("Auto-renewal of policy is not configured. Please check with your administrator.","I",function(){
						 $("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
						 $("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
							updateRenewFlag();
					 });
					return false;
				}else{
					if(nvl(selectedExpPolRow.autoSw,"N") == "N"){
					
						 showWaitingMessageBox("Policy with endorsement(s) cannot be auto-renewed.","I",function(){
							$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
							$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
							updateRenewFlag();
						 });
						return false;	
					}
					
					if(nvl($F("distSw"),"Y") == "N"){
					
						showWaitingMessageBox("Policy cannot be auto-renewed , policy or it's endorsement is not yet distributed.","I", function(){
							$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
							$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
							updateRenewFlag();
							
						});	
						return false;
					}else{
						if(initialVars.vAllowARWDist == "Y"){ // reused from previous functions
							new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
								method: "POST",
								parameters: {action : "checkRenewFlagGIEXS004",
														renewFlag: renewFlag,
														policyId:	 $F("policyId"),
														lineCd:		 $F("nbtLineCd"),
														issCd:			 $F("nbtIssCd")},
								onComplete: function(response){
									if(checkErrorOnResponse(response)){
										var result = response.responseText.toQueryParams();
										var msg = result.msg;
										
										if(msg == 2){
											showWaitingMessageBox("Only policy(s) with 100% net retention distribution is allowed in auto-renew.","I",function(){
												$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
												$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
												updateRenewFlag();
											});
											return false;
										}else{
											continueProcess();
										}
									}
								}
							});							
						}else{
							continueProcess();
						}
					}
				}
			}else{
				continueProcess();
			}
		}catch(e){
			showErrorMessage("executeWhenRadionBtnChange", e);
		}
	}
	
	//when renew flag radio changes
	function checkRenewFlagGIEXS004(){
		renewFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('renewFlag'), selectedExpPol);
		balanceFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('balanceFlag'), selectedExpPol);
		claimFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('claimFlag'), selectedExpPol);
		updateFlag = expPolGrid.getValueAt(expPolGrid.getColumnIndex('updateFlag'), selectedExpPol);
		samePolnoSw = expPolGrid.getValueAt(expPolGrid.getColumnIndex('samePolnoSw'), selectedExpPol);
		summarySw = expPolGrid.getValueAt(expPolGrid.getColumnIndex('summarySw'), selectedExpPol);
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
				method: "POST",
				parameters: {action : "checkRenewFlagGIEXS004",
										renewFlag: renewFlag,
										policyId:	 $F("policyId"),
										lineCd:		 $F("nbtLineCd"),
										issCd:			 $F("nbtIssCd")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if(msg==1){
							 showWaitingMessageBox("Automatic renewal to Policy is temporarily disabled ...","I",function(){
								 $("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
								 $("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
									updateRenewFlag();
							 });
						}else if(msg==2){
							showWaitingMessageBox("Only policy(s) with 100% net retention distribution is allowed in auto-renew.","I",function(){
								$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
								$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
								updateRenewFlag();
							});
						}else if(msg==4 || msg==5){
							showMessageBox("User has no authority to post a policy. Reassign the PAR to another user or set-up the posting limit of user  "+result.userId+".","E");
						}else if(msg==6){
							showWaitingMessageBox("Total TSI amount exceeds the allowable TSI amount of the user  "+result.userId+". Reassign the PAR to another user with higher authority. ","E", function(){
								$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
								$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
								$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked = false;
								updateRenewFlag();
								$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
								});
						}else if(msg==7){
							// override functions are moved to post button
							/*
							showConfirmBox("Confirm","User is not allowed to Auto Renew. Would you like to override?","Yes","No",
									function(){
								 		$("functionCd").value = "AR";
								 		overrideUser();
									},function(){
										 showWaitingMessageBox("User is not allowed to auto renew.","I", function(){
												$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
												$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
												updateRenewFlag();
												$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
												 });
									});
							$("proceed").value = "N";*/
						}else if(msg==8){
							verifyOverrideRbGIEXS004();
						}
						//verifyOverrideRbGIEXS004();
						$("proceed").value = result.proceed;
						needCommit = "Y"; 
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("updateBalanceClaimFlag", e);
		}
	}
	
	function updateRenewFlag(){
		if($("mtgInput"+mtgId+"_12,"+selectedExpPol).checked == true){
			expPolGrid.setValueAt("1", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);
		}else if($("mtgInput"+mtgId+"_13,"+selectedExpPol).checked == true){
			expPolGrid.setValueAt("2", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);	
		}else if($("mtgInput"+mtgId+"_14,"+selectedExpPol).checked == true){
			expPolGrid.setValueAt("3", expPolGrid.getColumnIndex("renewFlagGroup"), selectedExpPol, true);	
		}
	}
	
	//verify_override_rb program unit
	function verifyOverrideRbGIEXS004(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
				method: "POST",
				parameters: {action : "verifyOverrideRbGIEXS004",
										policyId:	 $F("policyId"),
										renewFlag: renewFlag,
										autoSw:		 $F("autoSw"),
										balanceFlag: balanceFlag,			 
										claimFlag:	claimFlag,
										distSw: $F("distSw")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if(msg==1){
							 showWaitingMessageBox("Policy with endorsement(s) cannot be auto-renewed.","I",function(){
									$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
									$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
									updateRenewFlag();
									 });
						}else if(msg==2){
							//override functions and messages are moved to process post button - irwin
							/* showConfirmBox("Confirm","Policy has claim(s). Cannot process policy for renewal. Would you like to override?","Ok","Cancel",
									function(){
										$("functionCd").value = "RB";
										overrideUser();
									},function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										updateRenewFlag();
										$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
									});
							 $("proceed").value = "N"; */
						}else if(msg==3){
							showConfirmBox("Confirm","Policy has claim(s). Would you like to continue?","Ok","Cancel","",
									function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										updateRenewFlag();
										$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
										$("proceed").value = "N";
									});
						}else if(msg==4){
							//override functions and messages are moved to process post button - irwin
							/* showConfirmBox("Confirm","Policy has an outstanding premium balance. Cannot process policy for renewal. Would you like to override?","Ok","Cancel",
									function(){
										$("functionCd").value = "RB";
										overrideUser();
									},function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										updateRenewFlag();
										$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
									});
							 $("proceed").value = "N"; */
						}else if(msg==5){
							//override functions and messages are moved to process post button - irwin
							showConfirmBox("Confirm","Policy has an outstanding premium balance. Would you like to continue?","Ok","Cancel","",
									function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										updateRenewFlag();
										$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
										$("proceed").value = "N";
									});
						}else if(msg==6){
							showWaitingMessageBox("Policy cannot be auto-renewed , policy or it's endorsement is not yet distributed.","I", function(){
								$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
								$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
								updateRenewFlag();
								});
						}else if(msg==7){
							showWaitingMessageBox("Only policy(s) with 100% net retention distribution is allowed in auto-renew.","I", function(){
								$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
								$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
								updateRenewFlag();
							});
						}else if(msg==8){
							arValidation();
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("updateBalanceClaimFlag", e);
		}
	}
	
	//ar_validation program unit
	function arValidation(){
		if(renewFlag ==1){
			if($F("requireNrReason")=="Y"){
				$("required").value = "Y";
			}
		}else{
			$("required").value = "N";
		}
		if($F("distSw")=="N"){
			$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = false;
		}else{
			$("mtgInput"+mtgId+"_"+expPolGrid.getColumnIndex("updateFlag")+','+selectedExpPol).checked = true;
		}
		if($F("processTag") == "U"){
			$("processTag").value = "S";
		}
		if(renewFlag == 1){
			$("mtgInput"+mtgId+"_15,"+selectedExpPol).checked = false;
			$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false;
		}else if(renewFlag==3){
			$("mtgInput"+mtgId+"_20,"+selectedExpPol).checked = false;
		}
		try{
			new Ajax.Request(contextPath+"/GIEXExpiryController", {
				method: "POST",
				parameters: {action : "arValidationGIEXS004",
										isPackage				: $F("isPackage"),
										fromPostQuery	: $F("fromPostQuery"),			 
										policyId					: $F("policyId"),
										updateFlag			: updateFlag,
										samePolnoSw		: samePolnoSw,
										summarySw			: summarySw,			 
										nonRenReason		: $F("nonRenReason"),
										nonRenReasonCd: $F("nonRenReasonCd")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if(msg==1){
							showConfirmBox("Confirm","Changing option for renew_flag would cause the deletion of all edited perils of this policy. Do you want to continue?", "Yes", "No",
									function(){
										expPolGrid.setValueAt(result.perilPolId, expPolGrid.getColumnIndex("delPolId"), selectedExpPol, true);		
            							expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("deleteItmPeril"), selectedExpPol, true);
									}, function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked = false;
										updateRenewFlag();
									});
						}else if(msg==2){
							showConfirmBox("Confirm","Changing option for renew_flag would cause the deletion of all edited perils of this policy. Do you want to continue?", "Yes", "No",
									function(){
										expPolGrid.setValueAt($F("policyId"), expPolGrid.getColumnIndex("delPolId"), selectedExpPol, true);		
            							expPolGrid.setValueAt("Y", expPolGrid.getColumnIndex("deleteItmPeril"), selectedExpPol, true);
									}, function(){
										$("mtgInput"+mtgId+"_14,"+selectedExpPol).checked = false;
										$("mtgInput"+mtgId+"_13,"+selectedExpPol).checked = true;
										$("mtgInput"+mtgId+"_12,"+selectedExpPol).checked = false;
										updateRenewFlag();
									});
						}
						needCommit = result.needCommit; 
						overrideOk = result.overrideOk; 
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("arValidation", e);
		}
	}			
	
	function whenProcessTypeChanged(){
			var rows = expPolGrid.geniisysRows;
			if($F("processTag")=="T"){
				 for(var i=0; i<rows.length;  i++){
						distSw = rows[i].distSw;
						if(distSw == "Y" || (distSw == "N" && allowUndistSw == "Y")){ 
							$("mtgInput1_"+expPolGrid.getColumnIndex("updateFlag")+','+i).checked = true;
							$("mtgIC1_"+expPolGrid.getColumnIndex("processor")+','+i).innerHTML = userId;
							expPolGrid.setValueAt(userId, expPolGrid.getColumnIndex("processor"), i, true);
						}
				}
			}else if($F("processTag")=="U"){
				for(var i=0; i<rows.length;  i++){
					$("mtgInput1_"+expPolGrid.getColumnIndex("updateFlag")+','+i).checked = false;
					$("mtgIC1_"+expPolGrid.getColumnIndex("processor")+','+i).innerHTML = "";
					expPolGrid.setValueAt("", expPolGrid.getColumnIndex("processor"), i, true);
				}
			}
			needCommit = "Y";
	}
	
	function saveProcessTag(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
				method: "POST",
				onCreate: function(){
					showNotice("Saving, please wait...");
				},
				parameters: {action	 		 : "saveProcessTagGIEXS004",
										 allUser   		 : allUser,
										 intmNo	 		 : objGIEXExpiry.intmNo,
									     intmName	 : objGIEXExpiry.intmName,
									     claimSw	 	 : objGIEXExpiry.claimSw,
									     balanceSw	 : objGIEXExpiry.balanceSw,
									     rangeType     : objGIEXExpiry.rangeType,
									     range			     : objGIEXExpiry.range,
									     fmDate			 : objGIEXExpiry.fmDate,
									     toDate			 : objGIEXExpiry.toDate,
									     fmMon			 : objGIEXExpiry.fmMon,
									     fmYear			 : objGIEXExpiry.fmYear,
									     toMon		     : objGIEXExpiry.toMon,
									     toYear			 : objGIEXExpiry.toYear,
									     lineCd		     : objGIEXExpiry.lineCd,
									     sublineCd	     : objGIEXExpiry.sublineCd,
									     issCd				 : objGIEXExpiry.issCd,
									     issueYy           : objGIEXExpiry.issueYy,
									     polSeqNo		 : objGIEXExpiry.polSeqNo,
									     renewNo	     : objGIEXExpiry.renewNo,
										 process   	     : $F("processTag")},
				onComplete: function(response){
					hideNotice("");
					//showMessageBox("Saving successful.", "S");
					//needCommit = "N"; 
					//showProcessExpiringPoliciesPage();
					showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showProcessExpiringPoliciesPage);
				}
			});
		}catch(e) {
			showErrorMessage("saveProcessTag", e);
		}
	}
	
	//save function
	function updateF000Field(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiryController",{
				method: "POST",
				parameters: {action						:"updateF000Field",
										//fromPostQuery			: $F("fromPostQuery"),
										fromPostQuery		: "N",
										isPackage					: isPackage,
										summarySw				: summarySw,
										samePolnoSw			: samePolnoSw,
										updateFlag				: updateFlag,
										balanceFlag				: balanceFlag,
										claimFlag					: claimFlag,
										regPolicySw				: regPolicySw,
										renewFlag					: renewFlag,
										remarks						: remarks,
										nonRenReasonCd	: nonRenReasonCd,
										nonRenReason			: nonRenReason,
										processor	: processor,	// andrew - 09212015 - SR 4942
										policyId						: policyId},
				onComplete: function(){
					/* showMessageBox("Saving successful.", "S");
					showProcessExpiringPoliciesPage(); */
				}
			});
		}catch(e) {
			showErrorMessage("updateF000Field", e);
		}
	}
	
	function clearFields(){
		$("fromPostQuery").value = "";
		$("balanceFlag").value = "";
		$("nonRenReason").value = "";
		$("nonRenReasonCd").value = "";
		$("remarks").value = "";
		$("nbtLineCd").value = "";
		$("nbtSublineCd").value = "";
		$("nbtIssCd").value = "";
		$("nbtIssueYy").value = "";
		$("nbtPolSeqNo").value = "";
		$("nbtRenewNo").value = "";
		$("polPrem").value = "";
		$("origPolPrem").value = "";
		$("parId").value = "";
		$("lineCd").value = "";
		$("issCd").value = "";
		$("parYy").value = "";
		$("parSeqNo").value = "";
		$("quoteSeqNo").value = "";
		$("parType").value = "";
		$("assdNo").value = "";
		$("distSw").value = "";
		$("dspRenewFlag").value = "";
		$("polTsi").value = "";
		$("origPolTsi").value = "";
		$("userId").value = "";
		$("lastUpdate").value = "";
		//$("nbtEmailStatus").value = "";
		//$("nbtSMSStatus").value = "";
	}
	
	function showNonRenReasonCdLOV() {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getNonRenewalCdLOV",
											lineCd: $F("dspLineCd"),
											notIn: "",
											page : 1},
			title: "List of Non-Renewal Codes and Descriptions",
			width: 350,
			height: 386,
			columnModel: [ {   id: 'recordStatus',
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
									id: 'nonRenReasonCd',
									title: 'Code',
									titleAlign: 'center',
									width: '100px'
								},
								{
									id: 'nonRenReasonDesc',
									title: 'Description',
									titleAlign: 'center',
									width: '231px'
								}
			              ],
			draggable: true,
	  		onSelect: function(row){
				 if(row != undefined) {
					needCommit = "Y";
					$("nonRenReasonCd").value = unescapeHTML2(row.nonRenReasonCd);
					$("nonRenReason").value = unescapeHTML2(row.nonRenReasonDesc);
					expPolGrid.setValueAt($F("nonRenReasonCd"), expPolGrid.getColumnIndex("nonRenReasonCd"), selectedExpPol, true);		
					expPolGrid.setValueAt($F("nonRenReason"), expPolGrid.getColumnIndex("nonRenReason"), selectedExpPol, true);		
				 }
	  		}
		});
	}
	
	//checks if the non-renewal reason code exists in maintenance table
	function validateReasonCd() {
		try{
			if ($F("nonRenReasonCd") != "" && $F("requireNrReason") == "Y"){ 
				new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=validateReasonCd", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {nonRenReasonCd: $F("nonRenReasonCd")},
					onComplete: function(response) {
						if (checkErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							if (result.msg != ""){
								showWaitingMessageBox(result.msg, "E", function(){
									$("nonRenReasonCd").focus();
									$("nonRenReasonCd").value = "";
								});
							}
							$("nonRenReason").value = result.nonRenReason;
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} else{
				showMessageBox("Please enter non-renewal reason.", "I");	
			}
		}catch(e) {
			showErrorMessage("validateReasonCd", e);
		}
	}
	
	//when btn_process pressed
	function processPost(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=processPostButtonGIEXS004", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {overrideOk   		 	 : overrideOk,
										 override         			 : $F("override"),
										 allUser						 : allUser,
										 lineAc						 : $F("lineAc"),
										 menuLineCd			 : $F("menuLineCd"),
										 lineCa						 : $F("lineCa"),
										 lineAv						 : $F("lineAv"),
										 lineFi							 : $F("lineFi"),
										 lineMc						 : $F("lineMc"),
										 lineMn						 : $F("lineMn"),
										 lineMh						 : $F("lineMh"),
										 lineEn						 : $F("lineEn"),
										 vesselCd					 : $F("vesselCd"),
										 sublineBpv				 : $F("sublineBpv"),
										 sublineMop				 : $F("sublineMop"),
										 sublineMrn				 : $F("sublineMrn"),
										 lineSu						 : $F("lineSu"),
										 sublineBbi				 : $F("sublineBbi"),
										 issRi							 : $F("issRi")},
				onCreate: function(){
					showNotice("Processing policies, please wait...");
				},
				onComplete: function(response) {
					hideNotice("");
					if (checkErrorOnResponse(response)) {
						try{
							if(response.responseText.include("ERROR")){
								var cause = response.responseText;
								var errorMsg = cause.substring(cause.indexOf(" "), cause.length);
								showMessageBox(errorMsg, imgMessage.ERROR);
							}else{
								var result = response.responseText.toQueryParams();
								policyIds = result.policyIds;
								if(result.messageBox != ""){
									replaceContentOfDiv(result.messageBox);
								}
								if (result.msgAlert != ""){
									if(result.msgAlert==6){
										showMessageBox(result.msg,"W");
									}else if(result.msgAlert==9){
										showMessageBox(result.msg,"I");
									}else if(result.msgAlert==1 || result.msgAlert==2 || result.msgAlert==3){
										if(result.msgAlert==1){
											alertMsg = "Policy has an outstanding premium balance and claim. Cannot process policy for renewal. Would you like to override?";
										}else if (result.msgAlert == 2){
											alertMsg = "Policy has an outstanding premium balance. Cannot process policy for renewal. Would you like to override?";
										}else if(result.msgAlert==3){
											alertMsg = "Policy has claim. Cannot process policy for renewal. Would you like to override?";
										}
										showConfirmBox("Confirm",alertMsg,"Ok","Cancel",
												function(){
													process = "TRUE";
													overrideUser();},""); 
									}else if(result.msgAlert==5){
										showConfirmBox("Confirm","Policy(s) that will be renewed to PAR are not yet fully paid. Do you want to continue?","Ok","Cancel","",""); 
									}else if(result.msgAlert==4){
										showWaitingMessageBox(result.msg,"E",  function () {
											goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);});
									}else if(result.msgAlert==7){
										    showWaitingMessageBox("Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.","I",function(){
									    		getRenewedPoliciesSummary();
										    });
									}else if(result.msgAlert==8) {
											getRenewedPoliciesSummary();
									}
								}
							}
						}catch(e){
							showErrorMessage("processPostMessage", e);
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("processPost", e);
		}
	}
	
	function giexs004ProcessPolicies(){
		try{
			function process(){
				new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=giexs004ProcessPolicies", {
					evalScripts: true,
					asynchronous: false,
					method: "GET",
					parameters: {overrideOk   		 	 : overrideOk,
											 override         			 : $F("override"),
											 allUser						 : allUser,
											 lineAc						 : $F("lineAc"),
											 menuLineCd			 : $F("menuLineCd"),
											 lineCa						 : $F("lineCa"),
											 lineAv						 : $F("lineAv"),
											 lineFi							 : $F("lineFi"),
											 lineMc						 : $F("lineMc"),
											 lineMn						 : $F("lineMn"),
											 lineMh						 : $F("lineMh"),
											 lineEn						 : $F("lineEn"),
											 vesselCd					 : $F("vesselCd"),
											 sublineBpv				 : $F("sublineBpv"),
											 sublineMop				 : $F("sublineMop"),
											 sublineMrn				 : $F("sublineMrn"),
											 lineSu						 : $F("lineSu"),
											 sublineBbi				 : $F("sublineBbi"),
											 issRi							 : $F("issRi"),
												vAllowARWDist: initialVars.vAllowARWDist,
												lineCd: 		objGIEXExpiry.lineCd, //joanne
												sublineCd: 		objGIEXExpiry.sublineCd,
												issCd: 			objGIEXExpiry.issCd,
												issueYy: 		objGIEXExpiry.issueYy,
												polSeqNo: 		objGIEXExpiry.polSeqNo,
												renewNo: 		objGIEXExpiry.renewNo,
												claimSw: 		objGIEXExpiry.claimSw,
												balanceSw: 		objGIEXExpiry.balanceSw,
												intmNo: 		objGIEXExpiry.intmNo, //change intmName to intmNo koks 8/14/2015 
												intmName: 		objGIEXExpiry.intmName, //change claimSw to intmName 
												rangeType: 		objGIEXExpiry.rangeType,
												range: 			objGIEXExpiry.range,
												fmDate: 		objGIEXExpiry.fmDate,
												toDate: 		objGIEXExpiry.toDate,
												fmMon: 			objGIEXExpiry.fmMon,
												toMon:			objGIEXExpiry.toMon,
												fmYear: 		objGIEXExpiry.fmYear,
												toYear: 		objGIEXExpiry.toYear
												
					},
					onCreate: function(){
						showNotice("Processing policies, please wait...");
					},
					onComplete: function(response) {
						hideNotice("");
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
							var result = response.responseText.toQueryParams();
							policyIds = result.policyIds;
							getRenewedPoliciesSummary();
						} else {
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			}
			if(nvl($F("checkRenewFlag") ,"N") == "Y"){
				showWaitingMessageBox("Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.","I",process);
			}else{
				process();
			}
			
		}catch(e) {
			showErrorMessage("giexs004ProcessPolicies", e);
		}
	}
	/**
		Created By: Irwin C. Tabisora
		Date: 8.6.2012
	**/
	function giexs004ProcessPostButton(confirmBranchSw, confirmFmvSw){ //benjo 09.22.2016 SR-5621
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=giexs004ProcessPostButton", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					allUser: allUser,
					moduleId: 'GIEXS004',
					lineCd: 			objGIEXExpiry.lineCd, //joanne
					sublineCd: 			objGIEXExpiry.sublineCd,
					issCd: 				objGIEXExpiry.issCd,
					issueYy: 			objGIEXExpiry.issueYy,
					polSeqNo: 			objGIEXExpiry.polSeqNo,
					renewNo: 			objGIEXExpiry.renewNo,
					claimSw: 			objGIEXExpiry.claimSw,
					balanceSw: 			objGIEXExpiry.balanceSw,
					intmNo: 			objGIEXExpiry.intmNo, //change intmName to intmNo koks 8/14/2015 
					intmName: 			objGIEXExpiry.intmName, //change claimSw to intmName 
					rangeType: 			objGIEXExpiry.rangeType,
					range: 				objGIEXExpiry.range,
					fmDate: 			objGIEXExpiry.fmDate,
					toDate: 			objGIEXExpiry.toDate,
					fmMon: 				objGIEXExpiry.fmMon,
					toMon:				objGIEXExpiry.toMon,
					fmYear: 			objGIEXExpiry.fmYear,
					toYear: 			objGIEXExpiry.toYear, //joanne
					vOverrideRenewal:   initialVars.vOverrideRenewal,
					confirmBranchSw:    confirmBranchSw,
					confirmFmvSw:       confirmFmvSw, //benjo 09.22.2016 SR-5621
					vValidateMcFmv:     initialVars.vValidateMcFmv //benjo 09.22.2016 SR-5621
				},onCreate: function(){
					showNotice("Processing policies, please wait...");
				},onComplete: function(response){
					hideNotice("");
					if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						var result = response.responseText.toQueryParams();
						var message = "";
						
						$("checkRenewFlag").value = result.renewFlag; // will be checked later in the process
						if(result.message == "0"){
							showConfirmBox("Confirmation", "There is maintained Issue place/s that does not exist in renewal par's new issue code. This will recompute the LGT of new par. Do you want to continue?"
											,"Yes"
											,"No"
											,function(){
												giexs004ProcessPostButton("Y", confirmFmvSw); //benjo 09.22.2016 SR-5621
											},
											"");
						} else if(result.message == "1"){
							showConfirmBox("Process Expiring Policies","Policy has an outstanding premium balance and claim; override may be required.","Proceed","Cancel",function(){
								if (nvl(result.tempRBOverride,"N") =="Y"){
									$("functionCd").value = "RB";
									overrideUserParam($F("functionCd"));
								}else{
									giexs004ProcessRenewal();
								}
							});
						}else if(result.message =="2"){
							showConfirmBox("Process Expiring Policies","Policy has an outstanding premium balance; override may be required.","Proceed","Cancel",function(){
								if (nvl(result.tempRBOverride,"N") =="Y"){
									$("functionCd").value = "RB";
									overrideUserParam($F("functionCd"));
								}else{
									giexs004ProcessRenewal();
								}
							});
						}else if(result.message == "3"){
							showConfirmBox("Policy has Claim","Policy has claim; override may be required.","Proceed","Cancel",function(){
								if (nvl(result.tempRBOverride,"N") =="Y"){
									$("functionCd").value = "RB";
									overrideUserParam($F("functionCd"));
								}else{
									giexs004ProcessRenewal();
								}
							});
						}else if(result.message == "4"){ //benjo 09.22.2016 SR-5621
							if (nvl(result.polCount, 1) == 1){
								message = "TSI amount is not within the Fair Market Value. Would you like to continue?";
							}else{
								message = "TSI amount of policies to be renewed is not within the Fair Market Value. Would you like to continue?";
							}
							showConfirmBox("Confirmation",message,"Yes","No",
									function(){
										giexs004ProcessPostButton(confirmBranchSw, "Y");
									},
									"");
						}else if(result.message == "5"){ //benjo 09.22.2016 SR-5621
							if (nvl(result.polCount, 1) == 1){
								message = "TSI amount is not within the Fair Market Value. Would you like to override?";
							}else{
								message = "TSI amount of policies to be renewed is not within the Fair Market Value. Would you like to override?";
							}
							showConfirmBox("Confirmation",message,"Yes","No",
									function(){
										expPolGrid.keys.releaseKeys();
										showGenericOverride("GIEXS004","OF",
												function(ovr, userId, result) {
													if (result == "FALSE") {
														showMessageBox("User "+userId+" does not have access in function OF. Please contact MIS.","I");
													} else {
														giexs004ProcessPostButton(confirmBranchSw, "Y");
														ovr.close();
														delete ovr;
													}
												}, function() {
													this.close();
												});
									},
									"");
						}else if(result.message == "6"){ //benjo 09.22.2016 SR-5621
							if (nvl(result.polCount, 1) == 1){
								message = "TSI amount should be within the Fair Market Value. Please contact MIS.";
							}else{
								message = "TSI amount of policies to be renewed is not within the Fair Market Value. Please contact MIS.";
							}
							showMessageBox(message,"I");
						}else{
							/*if(nvl(result.tempABOverride,"N") =="Y"){
								$("functionCd").value = "AB";
								overrideUserParam("AB");
							}else if (nvl(result.tempACOverride,"N") =="Y"){
								$("functionCd").value = "AC";
								overrideUserParam("AC");
							}
							else if (nvl(result.tempAROverride,"N") =="Y"){
								showConfirmBox("Process Auto Renewal","User is not allowed to process auto renewal. Override is required.","Proceed","Cancel",function(){
									overrideUserParam("AR");
								});
							}else{
								giexs004ProcessRenewal();
							}*/
							// JOANNE
							if (nvl(result.tempAROverride,"N") =="Y"){
								showConfirmBox("Process Auto Renewal","User is not allowed to process auto renewal. Override is required.","Proceed?","Cancel",function(){
									overrideUserParam("AR");
								});
							}else if(nvl(result.tempABOverride,"N") =="Y"){
								$("functionCd").value = "AB";
								showConfirmBox("With Balance","Policy/ies for Auto-renewal has/have an outstanding premium balance. Override is required.","Proceed?","Cancel",function(){
									overrideUserParam($("functionCd"));//JOANNE
								});
							}else if (nvl(result.tempACOverride,"N") =="Y"){
								$("functionCd").value = "AC";
								showConfirmBox("Policy has Claim","Policy/ies for Auto-renewal has/have claim/s. Override is required.","Proceed?","Cancel",function(){
									overrideUserParam($("functionCd")); //JOANNE
								});	
							}else{
								giexs004ProcessRenewal();
							}
						}
					}else{
						showMessageBox(response.responseText,e );
					}
				}
			});
			
		}catch(e){
			showErrorMessage("giexs004ProcessPostButton",e);
		}
	}
	
	function giexs004ProcessRenewal(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=giexs004ProcessRenewal", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {
					allUser: allUser,
					moduleId: 'GIEXS004',
					vOverrideRenewal: initialVars.vOverrideRenewal
				},onCreate: function(){
					showNotice("Processing policies, please wait...");
				},onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
						 var result = response.responseText.toQueryParams();
						 if(result.message == "1"){
							 showConfirmBox("With Balance","Policy(s) that will be renewed to PAR are not yet fully paid. Do you want to continue?","Ok","Cancel",function(){
								 giexs004ProcessPolicies();
							});
						 }else{
								giexs004ProcessPolicies();
							}
					}else{
						showMessageBox(response.responseText,"E");
					}
				}
			});	 
		}catch(e){
			showErrorMessage("processRenewal",e);
		}
	}
	
	
	function overrideUserParam(functionCd) {
		expPolGrid.keys.releaseKeys();
		showGenericOverride("GIEXS004",functionCd,
				function(ovr, userId, result) {
					if (result == "FALSE") {
						var message ="";
						if(functionCd == "AR"){
							message = "User "+userId+" does not have access in function AR.  Please contact your administrator.";	
						}else if(functionCd =="AB"){
							message = "User "+userId+" does not have access in function AB.  Please contact your administrator.";	
						}else if(functionCd == "AC"){
							message = "User "+userId+" does not have access in function AC.  Please contact your administrator.";	
						}else if(functionCd == "RB"){
							message = "User "+userId+" does not have access in function RB.  Please contact your administrator.";	
						}
						
						showMessageBox(message,"I");
					} else {
						//processPostOnOverride();
						giexs004ProcessRenewal();
						ovr.close();
						delete ovr;
					}
				}, function() {
					this.close();
				});
	}
	//on override
/* 	function overrideUser(){
		try{
			objAC.funcCode = $F("functionCd");
			objACGlobal.calledForm = "GIEXS004";
			setCommonOverrideUserFunc(processPostOnOverride);
			getUserInfo();
			var title = "Override User";
			$("overlayTitle").innerHTML = title;
		}catch (e) {
			showErrorMessage("overrideUser", e);
		}
	}	 */
	
	function overrideUser() {
		showGenericOverride("GIEXS004",$F("functionCd"),
				function(ovr, userId, result) {
					if (result == "FALSE") {
						showMessageBox(userId+ " is not allowed to override.",imgMessage.ERROR);
					} else {
						processPostOnOverride();
						ovr.close();
						delete ovr;
					}
				}, function() {
					this.close();
				});
	}
	
	//when ok button pressed on override
	function processPostOnOverride(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiriesVController?action=processPostOnOverrideGIEXS004", {
				evalScripts: true,
				asynchronous: false,
				method: "GET",
				parameters: {functionCd				 : $F("functionCd"),
										 user						     : $F("overideUserName"), 
										 process						 : process,
										 allUser						 : allUser,
										 lineAc						 : $F("lineAc"),
										 menuLineCd			 : $F("menuLineCd"),
										 lineCa						 : $F("lineCa"),
										 lineAv						 : $F("lineAv"),
										 lineFi							 : $F("lineFi"),
										 lineMc						 : $F("lineMc"),
										 lineMn						 : $F("lineMn"),
										 lineMh						 : $F("lineMh"),
										 lineEn						 : $F("lineEn"),
										 vesselCd					 : $F("vesselCd"),
										 sublineBpv				 : $F("sublineBpv"),
										 sublineMop				 : $F("sublineMop"),
										 sublineMrn				 : $F("sublineMrn"),
										 lineSu						 : $F("lineSu"),
										 sublineBbi				 : $F("sublineBbi"),
										 issRi							 : $F("issRi"),
										 fromPostQuery		 : "N"},
				onComplete: function(response) {
					if (checkErrorOnResponse(response)) {
						if(response.responseText.include("ERROR")){
							var cause = response.responseText;
							var errorMsg = cause.substring(cause.indexOf(" "), cause.length);
							showMessageBox(errorMsg, imgMessage.ERROR);
						} else {
							var result = response.responseText.toQueryParams();
							if(result.messageBox != ""){
								replaceContentOfDiv(result.messageBox);
							}
							if (result.msgAlert != ""){
								if(result.msgAlert == 1){
									showMessageBox(result.msg,"E");
									return false;
								}else if(result.msgAlert == 2){
									
								}else if(result.msgAlert == 3){
									showWaitingMessageBox("Policy(s) that will be renewed to PAR will not copy discount records and co-insurance information.","I",function(){
										getRenewedPoliciesSummary();
								    });
								}else{
									getRenewedPoliciesSummary();
								}
							}
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("processPostOnOverride", e);
		}
	}
	
	function replaceContentOfDiv(content) {
		var div = document.getElementById("legend");
		div.innerHTML = '<b>'+content+'</b>';
	}

	function saveOnChangeTag(){
		onExit = "Y";		
		var rows =   expPolGrid.getModifiedRows();
		for(var i=0; i<rows.length;  i++){
			summarySw = rows[i].summarySw;
			samePolnoSw = rows[i].samePolnoSw;
			updateFlag = rows[i].updateFlag;
			balanceFlag = rows[i].balanceFlag;
			claimFlag = rows[i].claimFlag;
			regPolicySw = rows[i].regPolicySw;
			renewFlag = rows[i].renewFlagGroup;
			isPackage = rows[i].isPackage;
			policyId = rows[i].policyId;
			nonRenReasonCd = rows[i].nonRenReasonCd;
			nonRenReason = rows[i].nonRenReason;
			remarks = rows[i].remarks;
			processor = rows[i].processor;
			deleteItmPeril = rows[i].deleteItmPeril;
			delPolId = rows[i].delPolId;
			required = rows[i].required;
			if(renewFlag == "1"  && $F("nonRenReasonCd") == ""){
				if($F("requireNrReason") == "Y"){
					showMessageBox("Please enter non-renewal reason.", "I");	
					onExit = "N";
					return;
				}else{
					 if(deleteItmPeril =="Y"){
							deleteItmperilByPolId();
					 }
					 updateF000Field();
				}
			}else{
				 if(deleteItmPeril =="Y"){
					deleteItmperilByPolId();
				}
				updateF000Field();
			} 
			/* if(required == "Y"  && nonRenReasonCd == null){ Kenneth L.10.23.2013
				showMessageBox("Please enter non-renewal reason.", "I");	
				return false;
			}else{
				 if(deleteItmPeril =="Y"){
					deleteItmperilByPolId();
				}
				updateF000Field();
			} */
		    modified = "Y";
		}
		 if ($F("processTag") == "T" || $F("processTag") == "U"){
			 saveProcessTag();
		 }else{
			// showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showProcessExpiringPoliciesPage); Kenneth L.10.23.2013
			 showMessageBox("Saving successful.", "S");
		 }
		 //showMessageBox("Saving successful.", "S");
			//needCommit = "N"; 
			//showProcessExpiringPoliciesPage();
		 
	}
	
	function saveExpPolGrid(){
		var id = expPolGrid._mtgId;
		fireEvent($('mtgSaveBtn'+id), 'click');
	}
	
	function getRenewedPoliciesSummary(){
		    var contentDiv = new Element("div", {id : "modal_content_renewedPoliciesSummary"});
		    var contentHTML = '<div id="modal_content_renewedPoliciesSummary"></div>';
		    
		    winWorkflow = Overlay.show(contentHTML, {
								id: 'modal_dialog_renewedPoliciesSummary',
								title: "Policy Renewed to (Policy/PAR) Number",
								width: 550,
								height: 410,
								draggable: true
								//closable: true
							});
		    
		    new Ajax.Updater("modal_content_renewedPoliciesSummary", contextPath+"/GIEXExpiriesVController?action=getRenewedPoliciesSummary&policyIds="+policyIds, {
		    	evalScripts: true,
				asynchronous: false,
				onComplete: function (response) {			
					hideNotice("");
					if (!checkErrorOnResponse(response)) {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
	}
	
	//marco - 08.12.2013
	function showSMSRenewal(){
		try{
			new Ajax.Updater("mainContents", contextPath+"/GIEXExpiryController",{
				method: "GET",
				parameters: {
					action: "showSMSRenewal",
					moduleId: "GIEXS004"
				},
				evalScripts: true,
				asynchronous: false,
				onCreate: showNotice("Loading SMS Renewal, please wait..."),
				onComplete: function(){
					hideNotice("");
					Effect.Appear($("mainContents").down("div", 0), {duration: .001});
				}
			});
		}catch(e){
			showErrorMessage("showSMSRenewal",e);
		}
	}
	
	$("remarks").observe("blur", function(){
		expPolGrid.setValueAt($F("remarks"), expPolGrid.getColumnIndex("remarks"), selectedExpPol, true);		
		needCommit = "Y";
	});
	
	$("editRemarks").observe("click", function () {
		if ($("remarks").getAttribute("disabled") == "disabled" || 
				$("remarks").getAttribute("disabled") == ""){
			
		}else{
			showEditor("remarks", 4000);
		}
	});
	
	$("tagAll").observe("click",function(){
		$("processTag").value = "T";
		whenProcessTypeChanged();
	});
	
	$("untagAll").observe("click",function(){
		$("processTag").value = "U";
		whenProcessTypeChanged();
	});
	
	$("selectedPolicies").observe("click",function(){
		$("processTag").value = "S";
		whenProcessTypeChanged();
	});
	
	$("nonRenReasonCdLOV").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if ($("nonRenReasonCd").getAttribute("disabled") == "disabled" || 
				$("nonRenReasonCd").getAttribute("disabled") == ""){
			
		}else{
			showNonRenReasonCdLOV();
		}
	});
	
	$("nonRenReasonCd").observe("change", function() {
			expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
			expPolGrid.keys.releaseKeys();
			validateReasonCd();
			expPolGrid.setValueAt($F("nonRenReasonCd"), expPolGrid.getColumnIndex("nonRenReasonCd"), selectedExpPol, true);		
		    needCommit = "Y";
	});
	
	$("nonRenReason").observe("blur", function() {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if($F("nonRenReason") == "" && $F("requireNrReason") == "Y"){
			showMessageBox("Non-renewal reason is required.", "I");
		}
		expPolGrid.setValueAt($F("nonRenReason"), expPolGrid.getColumnIndex("nonRenReason"), selectedExpPol, true);		
	});
	
	$("btnDetails").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the DETAIL button.","I");
		}else {
			if(clickable=="Y"){
				Modalbox.show(contextPath+'/GIEXExpiriesVController?action=showPolicyDetailsPage&packPolicyId='+$F("packPolicyId")+'&policyId='+$F("policyId"), {
					title: 'Policy Details',
					width: 600
				});
				Modalbox.resizeToContent();
			}else{
				showMessageBox("No record selected.","I");
			}
		}
	});
	
	$("btnPrint").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the PRINT button.","I");
		}else{
			//call module GIEXS006
			showPrintExpiryReportRenewalsPage('GIEXS004');
		}
	});
	
	$("btnEdit").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the EDIT button.","I");
		}else{
			if(clickable=="Y"){
				if($F("dspRenewFlag")!=2){
					showMessageBox("Only policy with renewal options can have it's peril(s) edited.","I");
					return false;
				}else{
					if ($F("isPackage") == 'Y'){
						objGIEXExpiry.packPolicyId = $F("policyId");
					}else{
						objGIEXExpiry.policyId =  $F("policyId");
					}
					showEditPerilInformationPage(objGIEXExpiry.packPolicyId, objGIEXExpiry.policyId);
				}
			}else{
				showMessageBox("No record selected.","I");
			}
		}
	});
	
	function showQueryOverlay(){
		try{
			overlayQuery = Overlay.show(contextPath+"/GIEXExpiriesVController",{
				urlContent: true,
				urlParameters: {action : "showQueryPoliciesPage", allUser : allUser},
			    title: "Query Policies",
			    height: 330,
			    width: 730,
			    draggable: true
			});
		}catch(e){
			showErrorMessage(error, e);
		}		
	}
	
	$("btnQuery").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the QUERY button.","I");
		}else{
			/* Modalbox.show(contextPath+'/GIEXExpiriesVController?action=showQueryPoliciesPage&allUser='+allUser, {
				title: 'Query Policies',
				width: 700
			});
			Modalbox.resizeToContent(); */
			showQueryOverlay();
		}
	});
	
	if(checkUserModule("GIEXS003")){
		enableButton("btnPurge");
	} else {
		disableButton("btnPurge");	
	}
	
	$("btnPurge").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		objUWGlobal.module = "GIEXS004";
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the PURGE button.","I");
		}else{
			showPurgeExtractTablePage();
		}
	});
	
	$("btnUpdate").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){ //marco - 04.20.2013 - added condition
			showMessageBox("Please save changes first before pressing the UPDATE button.","I");
		}else{
			showConfirmBox("Confirm","Are you sure you want to update w/ claim and w/ balance flag?","Yes","No",
				function(){
					updateBalanceClaimFlag();
				},"");
		}
	});
	
/* 	$("btnEmail").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(changeTag == 1 || needCommit == "Y"){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO); //Kenneth L. 10.21.2013 //call module GIEXS010
		}
	}); */
	
/* 	$("btnSMS").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		//marco - 08.12.2013
		if(changeTag == 1 || needCommit == "Y"){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
		}else{
			showSMSRenewal();
		}
	});
 */	
	$("btnSave").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			var rows =   expPolGrid.getModifiedRows();
			for(var i=0; i<rows.length;  i++){
				summarySw = rows[i].summarySw;
				samePolnoSw = rows[i].samePolnoSw;
				updateFlag = rows[i].updateFlag;
				balanceFlag = rows[i].balanceFlag;
				claimFlag = rows[i].claimFlag;
				regPolicySw = rows[i].regPolicySw;
				renewFlag = rows[i].renewFlagGroup;
				isPackage = rows[i].isPackage;
				policyId = rows[i].policyId;
				nonRenReasonCd = rows[i].nonRenReasonCd;
				nonRenReason = rows[i].nonRenReason;
				remarks = rows[i].remarks;
				deleteItmPeril = rows[i].deleteItmPeril;
				delPolId = rows[i].delPolId;
				required = rows[i].required;
				processor = rows[i].processor;
				if(renewFlag == "1"  && $F("nonRenReasonCd") == ""){
					if($F("requireNrReason") == "Y"){
						showMessageBox("Please enter non-renewal reason.", "I");	
						return false;
					}else{
						 if(deleteItmPeril =="Y"){
								deleteItmperilByPolId();
						 }
						 updateF000Field();
					}
				}else{
					 if(deleteItmPeril =="Y"){
						deleteItmperilByPolId();
					}
					updateF000Field();
				} 
			    modified = "Y";
			}
			
			 if ($F("processTag") == "T" || $F("processTag") == "U"){
				 saveProcessTag();
			 }else{
				 showWaitingMessageBox(objCommonMessage.SUCCESS, "S", function(){
					 needCommit = "N";
					 expPolGrid._refreshList();
				 });				 
			 }
			 
			 changeTag = 0;
			 //showMessageBox("Saving successful.", "S");
				//needCommit = "N"; 
			//	showProcessExpiringPoliciesPage();
		}else{
			showMessageBox("No changes to save.","I");
		}
	});
	
	$("btnProcess").observe("click", function () {
		expPolGrid.keys.removeFocus(expPolGrid.keys._nCurrentFocus, true);
		expPolGrid.keys.releaseKeys();
		if(needCommit=="Y"){
			showMessageBox("Please save changes first before pressing the PROCESS button.","I");
		}else{
			policyIds = "";
			//processPost();
			giexs004ProcessPostButton("N", "N"); //benjo 09.22.2016 SR-5621
		}
		changeTag = 0;
	});
	
	$("btnExit").observe("click", function(){
		if(changeTag == 1 || needCommit == "Y") {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", function(){
				saveOnChangeTag();
				if(onExit == "Y"){
					goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					changeTag = 0;
					clearObjectValues(objGIEXExpiry); //Added by Jerome Bautista 04.22.2016 SR 21993
				}
			}, function(){
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
				changeTag = 0;
				clearObjectValues(objGIEXExpiry); //Added by Jerome Bautista 04.22.2016 SR 21993
			}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
			changeTag = 0;
			clearObjectValues(objGIEXExpiry); //Added by Jerome Bautista 04.22.2016 SR 21993
		}
		
	});

	$("nonRenReasonCdLOV").hide();
	//$("nonRenReasonCd").up("div",0).addClassName("disabled");
	$("nonRenReasonCd").setStyle('width : 80px');
	$("editRemarks").hide();
	//$("remarks").up("div",0).addClassName("disabled");
	$("remarks").setStyle('width : 322px');
	//clearObjectValues(objGIEXExpiry); //Commented out by Jerome Bautista 04.22.2016 SR 21993
	checkExpiry();
	initDateFormatGIEXS004();
	initLineCdGIEXS004();
	initSublineCdGIEXS004();
	changeTag = 0;
	initializeChangeTagBehavior(saveExpPolGrid);
	initializeChangeAttribute();
	observeReloadForm("reloadForm", showProcessExpiringPoliciesPage);
	setModuleId("GIEXS004");
		
}catch(e){
	showErrorMessage("GIEXS004 page", e);
}
</script>
