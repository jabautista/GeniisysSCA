<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="printExpRepRenMainDiv" name="processExpPolMainDiv" style="height: 590px;">
	<div id="printExpRepRenMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExitPrintReport">Exit</a></li>
				</ul>
			</div>
	</div>
	<form id="printExpRepRenForm" name="printExpRepRenForm">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Print Expiry Reports/Documents</label>
				<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label> 
			 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
				</span>
			</div>
		</div>
		<div id="groDiv" name="groDiv">
		<input type="hidden">
		<div id="reportTitleDiv" name="reportTitleDiv" class="sectionDiv" style="width: 627px;; height: 200px;">
			<div id="GIEXS006ReportsModel" style="width: 600px;"></div>
		</div>
		<div id="printDialogFormDiv" name="printDialogFormDiv" class="sectionDiv" style="float: left; margin-left: 1px; width: 290px; height: 200px;">
			<table align="center" style="padding-top: 10px;" >
				<tr>
					<td class="rightAligned" width="31%">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 170px;">
							<option value="SCREEN">Screen</option>
							<option value="PRINTER">Printer</option>
							<option value="FILE">File</option>
							<option value="LOCAL">Local Printer</option>
							<option value=""></option>
						</select>
					</td>
				</tr>
				<tr id="fileOption">
				<td class="rightAligned"></td>
				<td class="leftAligned">
					<input type="radio" id="P" name="radioFile"checked disabled>PDF</input>
					<input type="radio" id="C" name="radioFile" disabled>CSV</input>
				</td>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 170px;" class="required">
							<option></option>
							<c:forEach var="p" items="${printers}">
								<option value="${p.name}">${p.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">No. of Copies</td>
					<td class="leftAligned">
						<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 145px;" class="required">
						<div style="float: left; width: 15px;">
							<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
							<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
							<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
							<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
						</div>					
					</td>
				</tr>
				<tr>
					<td height="5"></td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="button" class="button" id="btnPrint" value="Print" style="width: 120px;"/>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<input type="button" class="button" id="btnCancel" value="Cancel" style="text-align: center; width: 120px;"/>
					</td>
				</tr>
			</table>
		</div>
		<div id="expiryDateDiv" name="expiryDateDiv" class="sectionDiv" style="width: 30%; border: 0px">
			<div id="byMonthYearDiv" name="byMonthYearDiv" class="sectionDiv" style="margin-left: 0px; width: 99%;">
				<label style="width: 100px; margin-top: 10px; margin-left: 10px;">Expiry Date</label></td>
				<table style="margin-left: 10px;">
					<tr style="float: left; ">
						<td colspan="4">
					</tr>
					<tr>
						<td style="text-align: right;" colspan="4">
							<input title="By Month/Year" type="radio" id="byMonthYear" name="expiryDate" value="byMonth" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="byMonthYear">By Month/Year</label>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"><td>
						<td style="text-align: right;">From:</td>
						<td>
							<select id="fromMonth" name="fromMonth" style="width: 100px;">
								<option value=""></option>
								<option value="JAN">January</option>
								<option value="FEB">February</option>
								<option value="MAR">March</option>
								<option value="APR">April</option>
								<option value="MAY">May</option>
								<option value="JUN">June</option>
								<option value="JUL">July</option>
								<option value="AUG">August</option>
								<option value="SEP">September</option>
								<option value="OCT">October</option>
								<option value="NOV">November</option>
								<option value="DEC">December</option>
							</select>
						</td>
						<td>
							<input id="fromYear" name="fromYear" type="text" maxlength="4" style="width: 30px; margin-bottom: 4px;">
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"><td>
						<td style="text-align: right;">To:</td>
						<td>
							<select id="toMonth" name="toMonth" style="width: 100px;">
								<option value=""></option>
								<option value="JAN">January</option>
								<option value="FEB">February</option>
								<option value="MAR">March</option>
								<option value="APR">April</option>
								<option value="MAY">May</option>
								<option value="JUN">June</option>
								<option value="JUL">July</option>
								<option value="AUG">August</option>
								<option value="SEP">September</option>
								<option value="OCT">October</option>
								<option value="NOV">November</option>
								<option value="DEC">December</option>
							</select>
						</td>
						<td>
							<input id="toYear" name="toYear" type="text" maxlength="4" style="width: 30px; margin-bottom: 4px;">
						</td>
					</tr>
				</table>
				<table style="margin-left: 10px;">
					<tr>
						<td style="text-align: right;" colspan="3">
							<input title="By Date" type="radio" id="byDate" name="expiryDate" value="byDate" style="margin: 0 5px 0 5px; float: left;"><label for="byDate">By Date</label>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"></td>
						<td style="text-align: right; padding-left: 5px;">From:</td>
						<td>
							<div id="fromDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="fromDate" id="fromDate" readonly="readonly" disabled="disabled" />
								<img id="imgFmDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fromDate'),this, null);"/>						
							</div>
						</td>
					</tr>
					<tr>
						<td style="width: 30px;"></td>
						<td style="text-align: right; padding-left: 5px;">To:</td>
						<td>
							<div id="toDateDiv" style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
								<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 112px; border: none;" name="toDate" id="toDate" readonly="readonly" disabled="disabled" />
								<img id="imgToDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
							</div>
						</td>
					</tr>
					<tr height="20" style="float: left;"></tr>
				</table>
			</div>
			<div id="rangeDiv" name="rangeDiv" class="sectionDiv" style="margin-left: 0px; width: 99%;">
				<div style="float: left; height: 11px; width: 90%"></div>
				<div style="float: left; width: 90%">
					<label style="width: 50%; margin-left: 80px;">
						<input type="radio" id="onOrBefore" name="range" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label>On or Before</label>
					</label>					
				</div>
				<div style="float: left; width: 90%">
					<label style="width: 50%; margin-left: 80px; margin-top: 7px;">
						<input type="radio" id="exactRange" name="range" style="margin: 0 5px 0 5px; float: left;" checked=""><label>Exact Range</label>
					</label>					
				</div>
				<div style="float: left; height: 11px; width: 90%"></div>
			</div>
		</div>
		<div id="inputDiv" name="inputDiv" class="sectionDiv" style="float: left; margin-left: 0px; width: 643px;; height: 264px;">
			<table style="margin-left: 5px;">
				<tr>
					<td width="50"></td>
					<td width="150">
						<label><input type="radio" id="indvlPolNo" name="input" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label>Individual Policy No.</label></label>
					</td>
					<td>
						<span class="indvlPolNoTxt">
							<div id="lineCdDiv" class="sectionDiv" style="float: left; width: 49px; height: 19px; margin-top: 2px; border: 1px solid gray;">
								<input id="lineCd" title="Line Code" type="text" maxlength="2" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCdLOV" name="searchLineCdLOV" alt="Go" style="float: right;"/>
							</div>
							<div id="sublineCdDiv" class="sectionDiv" style="float: left; width: 74px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
								<input id="sublineCd" title="Subline Code" type="text" style="float: left; height: 12px; width: 46px; margin: 0px; border: none;">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCdLOV" name="searchSublineCdLOV" alt="Go" style="float: right;"/>
							</div>
							<div id="issCdDiv" class="sectionDiv" style="float: left; width: 49px; height: 19px; margin-left: 1px; margin-top: 2px; border: 1px solid gray;">
								<input id="issCd" title="Issue Code" maxlength="2" type="text" style="float: left; height: 12px; width: 23px; margin: 0px; border: none;">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCdLOV" name="searchIssCdLOV" alt="Go" style="float: right; "/>
							</div>
							<input id="issueYy" title="Year" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px;">
							<input id="polSeqNo" title="Policy Sequence Number" maxlength="6" type="text" style="float: left; width: 53px; margin-left: 1px;" >
							<input id="renewNo" title="Renew Number" maxlength="2" type="text" style="float: left; width: 33px; margin-left: 1px;">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td>
						<label><input type="radio" id="batch" name="input" style="margin: 0 5px 0 5px; float: left;" checked=""><label>Batch</label></label>
					</td>						
				</tr>
				<tr></tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned" style="cell"><label style="margin-left: 40px;">Line Code</label></td>
					<td>
						<div class="lovSpan" style="width: 114px; margin-top: 2px;">
							<input id="lineLOV" name="lineLOV" type="text" style="border: none; float: left; width: 84px; height: 14px; margin: 0px;" value="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineLOV" name="searchLineLOV" alt="Go" style="float: right;"/>
						</div>
						<span class="lovSpanText">
							<input id="lineName" name="lineName" type="text" style="width: 201px; height: 14px; margin-bottom: 0px; margin-left: 1px;" readonly="readonly" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned"><label style="margin-left: 40px;">Subline Code</label></td>
					<td>
						<div class="lovSpan" style="width: 114px; margin-top: 2px;">
							<input id="sublineLOV" name="sublineLOV" type="text" style="border: none; float: left; width: 84px; height: 14px; margin: 0px;" value="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineLOV" name="searchSublineLOV" alt="Go" style="float: right;"/> 
						</div>
						<span class="lovSpanText">
							<input id="sublineName" name="lovSpanText" type="text" style="width: 201px; height: 14px; margin-bottom: 4px; margin-left: 1px;" readonly="readonly" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned"><label style="margin-left: 40px;">Branch Code</label></td>
					<td>
						<div class="lovSpan" style="width: 114px; margin-top: 2px;">
							<input id="creditingLOV" name="creditingLOV" type="text" style="border: none; float: left; width: 84px; height: 14px; margin: 0px;" value="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCreditingLOV" name="searchCreditingLOV" alt="Go" style="float: right;"/> 
						</div>
						<span class="lovSpanText">
							<input id="creditingName" name="creditingName" type="text" style="width: 201px; height: 14px; margin-bottom: 4px; margin-left: 1px;" readonly="readonly" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned"><label style="margin-left: 40px;">Assured</label></td>
					<td>
						<div class="lovSpan" style="width: 114px; margin-top: 2px;">
							<input id="assuredLOV" name="assuredLOV" type="text" style="border: none; float: left; width: 84px; height: 14px; margin: 0px;" value="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchAssuredLOV" name="searchAssuredLOV" alt="Go" style="float: right;"/> 
						</div>
						<span class="lovSpanText">
							<input id="assuredName" name="assuredName" type="text" style="width: 201px; height: 14px; margin-bottom: 4px; margin-left: 1px;" readonly="readonly" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned"><label style="margin-left: 40px;">Intermediary</label></td>
					<td>
						<div class="lovSpan" style="width: 114px; margin-top: 2px;">
							<input id="intmLOV" name="intmLOV" type="text" style="border: none; float: left; width: 84px; height: 14px; margin: 0px;" value="">
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntmLOV" name="searchIntmLOV" alt="Go" style="float: right;"/> 
						</div>
						<span class="lovSpanText">
							<input id="intmName" name="intmName" type="text" style="width: 201px; height: 14px; margin-bottom: 4px; margin-left: 1px;" readonly="readonly" value="">
						</span>
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td class="leftAligned"><label style="margin-left: 40px;">RN NO.</label></td>
					<td>
						<label style="float: left; margin-top: 6px;">From     :</label>
						<input id="frRnSeqNo" type="text" style="margin-left: 10px; width: 110px; float: left;">
						<label style="float: left; margin-top: 6px; margin-left: 11px;">To     :</label>
						<input id="toRnSeqNo" type="text" style="margin-left: 10px; width: 110px; float: left;">
					</td>
				</tr>
				<tr>
					<td width="50"></td>
					<td>
						<label style="float: left;"><input type="checkbox" id="includePackage" name="includePackage" style="float: left;">Include Package</label>
					</td>
					<td>
						<label style="float: left;"><input type="checkbox" id="claimsOnly" name="claimsOnly" style="float: left; margin-left: 9px;">With Claims Only</label>
						<label style="float: left;"><input type="checkbox" id="premBalanceOnly" name="premBalanceOnly" style="float: left; margin-left: 46px;">With Prem. Balance Only</label>
					</td>
				</tr>
			</table>
		</div>
		</div>
		</div>
		<div id="buttonsDiv">
			<input type="button" class="button" id="btnGenerateRenewalNo" name="generateRenewalNo" value="Generate Renewal No." style="margin-top: 5px;"/>
			<input type="button" class="button" id="btnViewRenewal" name="viewRenewal" value="View Renewal"/>
		</div>
	</form>
</div>
<div id="viewRenewalDiv">
</div>
<script type="text/JavaScript">
try{
	objGiexs006.reqRenewalNo = "N";
	function toggleRequiredFields(dest){
		if(dest == "PRINTER"){		
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("P").disabled = true;
			$("C").disabled = true;
			
		} else {
			if(dest == "FILE"){
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();
			$("P").disabled = false;
			$("C").disabled = false;
			} else {
				$("selPrinter").value = "";
				$("txtNoOfCopies").value = "";
				$("selPrinter").disabled = true;
				$("txtNoOfCopies").disabled = true;
				$("selPrinter").removeClassName("required");
				$("txtNoOfCopies").removeClassName("required");
				$("imgSpinUp").hide();
				$("imgSpinDown").hide();
				$("imgSpinUpDisabled").show();
				$("imgSpinDownDisabled").show();
				$("P").disabled = true;
			$("C").disabled = true;
					
				}
		    }
	}
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
		if($("selDestination").value == "PRINTER"){
			$("selPrinter").selectedIndex = 1;
		}
	});
	
	/* TABLEGRID
	  START */
	initializeAccordion();
	setModuleId("GIEXS006");
	setDocumentTitle("Print Expiry Reports/Documents");
	var selectedIndex = -1;
	
	var objTGGIEXS006Reports = new Object();
	objTGGIEXS006Reports.objTGGIEXS006ReportsListing = JSON.parse('${giexs006ReportsTableGrid}');
	objTGGIEXS006Reports.objTGGIEXS006ReportsList = objTGGIEXS006Reports.objTGGIEXS006ReportsListing.rows || [];
	
	var renew = 0;
	var renewPack = 0;
	
	try{
		var GIEXS006ReportsModel = {
			url: contextPath+"/GIEXExpiryController?action=showPrintExpiryReportRenewalsPage&refresh=1",
			options: {
				height: '178px',
				width: '627px',
				onCellFocus: function(element, value, x, y, id){
	          		var mtgId = giexrs006TableGrid._mtgId;
	            	selectedIndex = -1;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            	}
	            	if(id != "checkReport") {
	            		giexrs006TableGrid.keys.removeFocus(giexrs006TableGrid.keys._nCurrentFocus, true);
						giexrs006TableGrid.keys.releaseKeys();
					}
				},
				onRemoveRowFocus: function(){
	            	selectedIndex = -1;
	            	giexrs006TableGrid.keys.removeFocus(giexrs006TableGrid.keys._nCurrentFocus, true);
	            	giexrs006TableGrid.keys.releaseKeys();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN,MyTableGrid.FILTER_BTN]
	            }	
			},
			columnModel:[
						{   
							id: 'recordStatus',
						    width: '0',
						    visible: false,
						    editor: 'checkbox' 			
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
			            {
			            	id: 'checkReport',
			            	title: '&#160;G',
			            	width: '25px',
			            	align: 'center',
			            	altTitle: 'Generate',
							titleAlign: 'center',
							editable: true,
							sortable: false,
							defaultValue: false,
							otherValue: false,
							hideSelectAllBox: true,
							editor: new MyTableGrid.CellCheckbox({
						        getValueOf: function(value){
						        	if (value){
										return "Y";
					            	}else{
										return "N";	
					            	}
				            	},
				            	onClick: function(value,checked) {
				            		if(giexrs006TableGrid.getRow(selectedIndex).checkReport == "Y"){				            			
			            				if(giexrs006TableGrid.getRow(selectedIndex).reportId == "RENEW"){
			            					renew = 1;
			            				}else if(giexrs006TableGrid.getRow(selectedIndex).reportId == "RENEW_PACK"){
			            					renewPack = 1;
			            				}
				            		}else{
				            			if(giexrs006TableGrid.getRow(selectedIndex).reportId == "RENEW"){
			            					renew = 0;
			            				}else if(giexrs006TableGrid.getRow(selectedIndex).reportId == "RENEW_PACK"){
			            					renewPack = 0;
			            				}
				            		}
				            		if(renew == 0 && renewPack == 0){
				            			disableButton("btnGenerateRenewalNo");
				            		}else if(renew == 1 || renewPack == 1){
				            			enableButton("btnGenerateRenewalNo");
				            		}
				            		getReport(value,checked);			            	
						    	}
				            })
			            },
						{
			            	id: 'reportTitle',
							title: "Report Title",
							width: "570px",
							titleAlign: 'center',
							filterOption: true
							
						},
						{
							id: 'reportId',
							title: "",
							width: "0",
							visible: false
						},
					],
				rows: objTGGIEXS006Reports.objTGGIEXS006ReportsList
		};
		giexrs006TableGrid = new MyTableGrid(GIEXS006ReportsModel);
		giexrs006TableGrid.pager = objTGGIEXS006Reports.objTGGIEXS006ReportsListing;
		giexrs006TableGrid.render('GIEXS006ReportsModel');
	}catch(e){
		showMessageBox("Error in Print Expiry Report/Renewals: " + e, imgMessage.ERROR);
	}
	/* TABLEGRID
	END */
	var reportArr = [];
	var reportArrId = [];
	function getReport(value, checked){
		reportArr = [];
		reportArrId = [];
		if(checked == true){
			for(var i=0; i<giexrs006TableGrid.rows.length; i++){
				if($("mtgInput"+giexrs006TableGrid._mtgId+"_2,"+i).checked == true){
					if(giexrs006TableGrid.getRow(i).reportTitle == "RENEWAL CERTIFICATE" || giexrs006TableGrid.getRow(i).reportTitle == "Expiry List(Report/Assumed)"){
						$("mtgInput"+giexrs006TableGrid._mtgId+"_2,"+i).checked = false;
						showMessageBox("No printing function for " + giexrs006TableGrid.getRow(i).reportTitle + " yet.", "I");
					}else{
						reportArr.push(giexrs006TableGrid.getRow(i).reportTitle);
						reportArrId.push(giexrs006TableGrid.getRow(i).reportId);	
					}
				}
			}
		}else{
			reportArr = [];
			//objGiexs006.giexs006Report = null;
		}
		giexrs006TableGrid.keys.removeFocus(giexrs006TableGrid.keys._nCurrentFocus, true); // andrew - 11.29.2012
    	giexrs006TableGrid.keys.releaseKeys();
	}
	
	$("P").observe("click", function() {
		("C").checked = false;
	});
	
	$("C").observe("click", function() {
		("P").checked = false;
	});
	
	$("searchLineCdLOV").observe("click", function(){
		showPrintExpReportLineLOV();
	});
	
	$("searchSublineCdLOV").observe("click", function(){
		showPrintExpReportSublineLOV();
	});
	
	$("searchIssCdLOV").observe("click", function(){
		showPrintExpReportIssourceLOV();
	});
	
	$("searchLineLOV").observe("click", function(){
		showPrintExpReportLineLOV();
	});
	
	$("searchSublineLOV").observe("click", function(){
		showPrintExpReportSublineLOV();
	});
	
	$("searchCreditingLOV").observe("click", function(){
		showPrintExpReportIssourceLOV();
	});
	
	$("searchAssuredLOV").observe("click", function(){
		showPrintExpReportAssuredLOV();
	});
	
	$("searchIntmLOV").observe("click", function(){
		showPrintExpReportIntmLOV();
	});
	
	$("lineLOV").observe("keyup",function(){
		$("lineLOV").value = $("lineLOV").value.toUpperCase();
	});
	
	$("sublineLOV").observe("keyup",function(){
		$("sublineLOV").value = $("sublineLOV").value.toUpperCase();
	});
	
	$("creditingLOV").observe("keyup",function(){
		$("creditingLOV").value = $("creditingLOV").value.toUpperCase();
	});
	
	$("lineLOV").observe("change", function(){
		var sw = "b";
		if($F("lineLOV") == ""){
			changeIncludePackValue($F("lineLOV"));
			$("lineName").clear();
		}else{
			validateLineCdGiexs006(sw);
		}
	});
	
	$("sublineLOV").observe("change", function(){
		var sw = "b";
		if($F("sublineLOV") == ""){
			$("sublineName").clear();
		}else{
			validateSublineCdGiexs006(sw);
		}
	});
	
	$("creditingLOV").observe("change", function(){
		var sw = "b";
		if($F("creditingLOV") == ""){
			$("creditingName").clear();
		}else{
			validateIssCdGiexs006(sw);
		}
	});
	
	$("assuredLOV").observe("change", function(){
		if($F("assuredLOV") == ""){
			$("assuredName").clear();
		}else{
			if(isNaN($F("assuredLOV"))){
				$("assuredLOV").clear();
				$("assuredName").clear();
				customShowMessageBox("Field must be of form 099999999999.", imgMessage.ERROR, "assuredLOV");
			}else{
				validateAssdNoGiexs006();
			}	
		}
		
	});
	
	$("intmLOV").observe("change", function(){
		if($F("intmLOV") == ""){
			$("intmName").clear();
		}else{
			if(isNaN($F("intmLOV"))){
				$("intmLOV").clear();
				$("intmName").clear();
				customShowMessageBox("Field must be of form 099999999999.", imgMessage.ERROR, "intmLOV");
			}else{
				validateIntmNoGiexs006();
			}	
		}
		
	});
	
	function disableInputDiv(){
		$("includePackage").disable();
		var spanInput = $$('div#inputDiv .lovSpan input');
		for(var i=0;i<spanInput.length;i++){
			spanInput[i].disabled = true;
			spanInput[i].value = "";
		}
		var spanImg = $$('div#inputDiv .lovSpan img');
		for(var i=0;i<spanImg.length;i++){
			disableSearch(spanImg[i]);
		}
		var spanText = $$('div#inputDiv .lovSpanText input');
		for(var i=0;i<spanText.length;i++){
			spanText[i].disabled = true;
			spanText[i].value = "";
		}
		var indvlPolNoTxt = $$('div#inputDiv .indvlPolNoTxt input');
		for(var i=0;i<indvlPolNoTxt.length;i++){
			indvlPolNoTxt[i].disabled = false;
			indvlPolNoTxt[i].addClassName("required");
		}
		$("lineCd").up("div",0).removeClassName("disabledGiexs006");
		$("lineCd").up("div",0).addClassName("required");
		$("sublineCd").up("div",0).removeClassName("disabledGiexs006");
		$("sublineCd").up("div",0).addClassName("required");
		$("issCd").up("div",0).removeClassName("disabledGiexs006");
		$("issCd").up("div",0).addClassName("required");
		enableSearch("searchLineCdLOV");
		enableSearch("searchSublineCdLOV");
		enableSearch("searchIssCdLOV");
		
		$("lineLOV").up("div",0).removeClassName("required");
		$("sublineLOV").up("div",0).removeClassName("required");
		$("creditingLOV").up("div",0).removeClassName("required");
		$("assuredLOV").up("div",0).removeClassName("required");
		$("intmLOV").up("div",0).removeClassName("required");
		$("lineLOV").up("div",0).addClassName("disabledGiexs006");
		$("sublineLOV").up("div",0).addClassName("disabledGiexs006");
		$("creditingLOV").up("div",0).addClassName("disabledGiexs006");
		$("assuredLOV").up("div",0).addClassName("disabledGiexs006");
		$("intmLOV").up("div",0).addClassName("disabledGiexs006");

		$("byMonthYear").removeClassName("required");
		$("fromMonth").removeClassName("required");
		$("fromYear").removeClassName("required");
		$("toMonth").removeClassName("required");
		$("toYear").removeClassName("required");
		$("byMonthYear").disable();
		$("fromMonth").disable();
		$("fromYear").disable();
		$("toMonth").disable();
		$("toYear").disable();
		
		$("byDate").removeClassName("required");
		$("fromDate").removeClassName("required");
		$("fromDate").up("div",0).removeClassName("required");
		$("toDate").removeClassName("required");
		$("toDate").up("div",0).removeClassName("required");
		
		$("byDate").disable();
		$("fromDate").disable();
		$("fromDate").up("div",0).addClassName("disabledGiexs006");
		disableDate("imgFmDate");		
		$("toDate").disable();
		$("toDate").up("div",0).addClassName("disabledGiexs006");
		disableDate("imgToDate");
		
		$("onOrBefore").disable();
		$("exactRange").disable();
		$("fromMonth").clear();
		$("fromYear").clear();
		$("toMonth").clear();
		$("toYear").clear();
		$("fromDate").clear();
		$("toDate").clear();
		$("lineCd").focus();
		objGiexs006.checkPolicyId = "N";
		changeIncludePackValue($F("lineCd"));
	}
	
	function enableInputDiv(){
		$("includePackage").enable();
		var spanInput = $$('div#inputDiv .lovSpan input');
		for(var i=0;i<spanInput.length;i++){
			spanInput[i].disabled = false;
		}
		var spanImg = $$('div#inputDiv .lovSpan img');
		for(var i=0;i<spanImg.length;i++){
			enableSearch(spanImg[i]);
		}
		var spanText = $$('div#inputDiv .lovSpanText input');
		for(var i=0;i<spanText.length;i++){
			spanText[i].disabled = false;
		}
		var indvlPolNoTxt = $$('div#inputDiv .indvlPolNoTxt input');
		for(var i=0;i<indvlPolNoTxt.length;i++){
			indvlPolNoTxt[i].removeClassName("required");
			indvlPolNoTxt[i].disabled = true;
			indvlPolNoTxt[i].value = "";
		}
		$("lineCd").up("div",0).addClassName("disabledGiexs006");
		$("sublineCd").up("div",0).addClassName("disabledGiexs006");
		$("issCd").up("div",0).addClassName("disabledGiexs006");
		$("lineCd").up("div",0).removeClassName("required");
		$("sublineCd").up("div",0).removeClassName("required");
		$("issCd").up("div",0).removeClassName("required");
		disableSearch("searchLineCdLOV");
		disableSearch("searchSublineCdLOV");
		disableSearch("searchIssCdLOV");
		
		$("lineLOV").up("div",0).removeClassName("disabledGiexs006");
		$("sublineLOV").up("div",0).removeClassName("disabledGiexs006");
		$("creditingLOV").up("div",0).removeClassName("disabledGiexs006");
		$("assuredLOV").up("div",0).removeClassName("disabledGiexs006");
		$("intmLOV").up("div",0).removeClassName("disabledGiexs006");
		$("byMonthYear").enable();
		$("byDate").enable();
		$("onOrBefore").enable();
		$("exactRange").enable();
		changeIncludePackValue($F("lineLOV"));
		if($("byMonthYear").checked && $("exactRange").checked){
			$("fromMonth").enable();
			$("fromYear").enable();
			$("toMonth").enable();
			$("toYear").enable();
			$("fromMonth").addClassName("required");
			$("toMonth").addClassName("required");
			$("fromYear").addClassName("required");
			$("toYear").addClassName("required");
		}else if($("byMonthYear").checked && $("onOrBefore").checked){
			$("fromMonth").enable();
			$("fromYear").enable();
			$("fromMonth").addClassName("required");
			$("fromYear").addClassName("required");
		}else if($("byDate").checked && $("exactRange").checked){
			$("fromDate").enable();
			$("fromDate").addClassName("required");
			$("fromDate").up("div",0).removeClassName("disabledGiexs006");
			$("fromDate").up("div",0).addClassName("required");
			enableDate("imgFmDate");
			$("toDate").enable();
			$("toDate").addClassName("required");
			$("toDate").up("div",0).removeClassName("disabledGiexs006");
			$("toDate").up("div",0).addClassName("required");
			enableDate("imgToDate");
		}else if($("byDate").checked && $("onOrBefore").checked){
			$("fromDate").enable();
			$("byDate").addClassName("required");
			$("fromDate").addClassName("required");
			$("fromDate").up("div",0).removeClassName("disabledGiexs006");
			$("fromDate").up("div",0).addClassName("required");
			enableDate("imgFmDate");
		}
	}
	
	function byDate(){
		if($("exactRange").checked == true){
			$("fromMonth").removeClassName("required");
			$("toMonth").removeClassName("required");
			$("fromYear").removeClassName("required");
			$("toYear").removeClassName("required");
			$("fromMonth").disable();
			$("toMonth").disable();
			$("fromYear").disable();
			$("toYear").disable();
			
			$("fromDate").enable();
			$("fromDate").addClassName("required");
			$("fromDate").up("div",0).removeClassName("disabledGiexs006");
			$("fromDate").up("div",0).addClassName("required");
			$("toDate").enable();
			$("toDate").addClassName("required");
			$("toDate").up("div",0).removeClassName("disabledGiexs006");
			$("toDate").up("div",0).addClassName("required");
			enableDate("imgFmDate");
			enableDate("imgToDate");	
			
			$("fromMonth").clear();
			$("toMonth").clear();
			$("fromYear").clear();
			$("toYear").clear();
		}else if($("onOrBefore").checked == true){
			$("fromMonth").removeClassName("required");
			$("toMonth").removeClassName("required");
			$("fromYear").removeClassName("required");
			$("toYear").removeClassName("required");
			$("fromMonth").disable();
			$("toMonth").disable();
			$("fromYear").disable();
			$("toYear").disable();
			
			$("fromDate").enable();
			$("fromDate").addClassName("required");
			$("fromDate").up("div",0).removeClassName("disabledGiexs006");
			$("fromDate").up("div",0).addClassName("required");
			$("toDate").removeClassName("required");
			$("toDate").disable();
			$("toDate").up("div",0).removeClassName("required");
			$("toDate").up("div",0).addClassName("disabledGiexs006");
			enableDate("imgFmDate");
			disableDate("imgToDate");
			
			$("fromMonth").clear();
			$("toMonth").clear();
			$("fromYear").clear();
			$("toYear").clear();
		}
	}
	
	function byMonthYear(){
		if($("exactRange").checked == true){
			$("fromMonth").enable();
			$("toMonth").enable();
			$("fromYear").enable();
			$("toYear").enable();
			$("fromMonth").addClassName("required");
			$("toMonth").addClassName("required");
			$("fromYear").addClassName("required");
			$("toYear").addClassName("required");
			
			$("fromDate").removeClassName("required");
			$("fromDate").up("div",0).removeClassName("required");
			$("toDate").removeClassName("required");
			$("toDate").up("div",0).removeClassName("required");
			
			$("fromDate").disable();
			$("fromDate").up("div",0).addClassName("disabledGiexs006");
			$("toDate").disable();
			$("toDate").up("div",0).addClassName("disabledGiexs006");
			disableDate("imgFmDate");
			disableDate("imgToDate");
			
			$("fromDate").clear();
			$("toDate").clear();
		}else if($("onOrBefore").checked == true){
			$("fromMonth").enable();
			$("fromYear").enable();
			$("fromMonth").addClassName("required");
			$("fromYear").addClassName("required");
			enableDate("imgToDate");
			
			disableDate("imgFmDate");
			disableDate("imgToDate");
			
			$("toYear").removeClassName("required");
			$("toMonth").removeClassName("required");
			$("fromDate").removeClassName("required");
			$("toDate").removeClassName("required");
			$("toYear").disable();
			$("toMonth").disable();
			$("fromDate").disable();
			$("fromDate").up("div",0).removeClassName("required");
			$("fromDate").up("div",0).addClassName("disabledGiexs006");
			$("toDate").disable();
			$("toDate").up("div",0).removeClassName("required");
			$("toDate").up("div",0).addClassName("disabledGiexs006");
			
			$("toYear").clear();
			$("toMonth").clear();
			$("fromDate").clear();
			$("toDate").clear();
		}
	}
	
	$("byDate").observe("click", function(){
		byDate();
	});
	
	$("byMonthYear").observe("click", function(){
		byMonthYear();
	});
	
	$("indvlPolNo").observe("click", function(){
		disableInputDiv();
	});
	
	$("batch").observe("click", function(){
		enableInputDiv();
	});
	
	$("txtNoOfCopies").observe("blur", function() {
		var nCopy = parseInt($F("txtNoOfCopies"));
		if(isNaN(parseInt($F("txtNoOfCopies")))) {
			showMessageBox("Legal characters are 0 - 9 + E.");
			$("txtNoOfCopies").value = "";
			return false;
		} else if(nCopy > 999 || nCopy < 1) {
			showMessageBox("Must be in range 1 to 999.");
			$("txtNoOfCopies").value = "";
			return false;
		}
	});
	
	function validatePrint(){
		var result = true;
		if(($("selPrinter").selectedIndex == 0) && ($("selDestination").value == "PRINTER")){
			result = false;
			$("selPrinter").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}else if(($("txtNoOfCopies").value == "") && ($("selDestination").value == "PRINTER")){
			result = false;
			$("txtNoOfCopies").focus();
			showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
		}
		return result;
	}
	
	
	var btnPrintSw = 'N'; //SR1330 lmlbeltran 06092015
	$("btnPrint").observe("click", function(){
		dspPolicyId = "";
		dspPackPolicyId = "";
		if($("batch").checked){
			if(validateDateRange()){
				objGiexs006.lineCd = $F("lineLOV");
				printReport();	
			}	
		}else{
			btnPrintSw = 'Y'; //SR1330 lmlbeltran 06092015
			validatePolicyNo();
			 /*if(objGiexs006.checkPolicyId == "Y"){	//SR1330 lmlbeltran 06092015
				objGiexs006.lineCd = $F("lineCd");
				printReport();
			} */
		}
	});
	
	function validatePolicyNo(){			
		if($F("lineCd")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "lineCd");
		}else if($F("sublineCd")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "sublineCd");
		}else if($F("issCd")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "issCd");
		}else if($F("issueYy")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "issueYy");
		}else if($F("polSeqNo")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "polSeqNo");
		}else if($F("renewNo")==""){
			customShowMessageBox("Please complete values for individual policy number parameters before printing.", "I", "renewNo");
		}else{
			checkPolicyGiexs006();
		}
	}
	
	var action = "";	
	var controller = "";
	function printReport(){
		if(validatePrint()){
			if(reportArr.length == 0){
				showMessageBox("Unable to print report/document . . . no chosen report/document in the list.  Please check report to print.", imgMessage.ERROR);
			}else{
				getPrintExpiryParams();
			}	
		}
	}
		
	function getPrintExpiryParams(){
		if($("batch").checked){
			objGiexs006.lineCd = $F("lineLOV");
			objGiexs006.issCd  = $F("creditingLOV");
			objGiexs006.sublineCd = $F("sublineLOV");
			if($("byMonthYear").checked){
				if($("exactRange").checked){
					var day = 31;
					var toYear = $F("toYear");
					if($F("toMonth") == "FEB"){
						day = 28;
						if(toYear != ""){
							toYear = parseInt(toYear);	
							if((toYear % 400) == 0 || (((toYear % 4) == 0) && ((toYear % 100) != 0))){
								day = 29;
							}	
						}
					}else if($F("toMonth") == "APR" || $F("toMonth") == "JUN" || $F("toMonth") == "SEP" || $F("toMonth") == "NOV"){
						day = 30;
					}
					objGiexs006.startDate = "01-" + $F("fromMonth") + "-" + $F("fromYear");
					objGiexs006.endDate = day + "-" + $F("toMonth") + "-" + $F("toYear");
				}else if($("onOrBefore").checked){
					var day = 31;
					var fromYear = $F("fromYear");
					if($F("fromMonth") == "FEB"){
						day = 28;
						if(fromYear != ""){
							fromYear = parseInt(fromYear);	
							if((fromYear % 400) == 0 || (((fromYear % 4) == 0) && ((fromYear % 100) != 0))){
								day = 29;
							}	
						}
					}else if($F("fromMonth") == "APR" || $F("fromMonth") == "JUN" || $F("fromMonth") == "SEP" || $F("fromMonth") == "NOV"){
						day = 30;
					}
					objGiexs006.startDate = "";
					objGiexs006.endDate = day + "-" + $F("fromMonth") + "-" + $F("fromYear");
				}
			} else if($("byDate").checked){
				if($("exactRange").checked){
					objGiexs006.startDate = dateFormat($F("fromDate"), "dd-mmm-yyyy");
					objGiexs006.endDate = dateFormat($F("toDate"), "dd-mmm-yyyy");
				}else if($("onOrBefore").checked){
					objGiexs006.startDate = "";
					objGiexs006.endDate = dateFormat($F("fromDate"), "dd-mmm-yyyy");
				}
			}
		}else if($("indvlPolNo").checked){
			objGiexs006.lineCd = $F("lineCd");
			objGiexs006.sublineCd = $F("sublineCd");
			objGiexs006.issCd  = $F("issCd");
			objGiexs006.issueYy = $F("issueYy");
			objGiexs006.polSeqNo = $F("polSeqNo");
			objGiexs006.renewNo = $F("renewNo");
			objGiexs006.startDate = null;
			objGiexs006.endDate = null;
		}
		getSelectedReport();
	}
	
	function getGiispLineCd(param){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			parameters: {
				action : "getGiispLineCdGiexs006",
				param  : param
			},
			evalScripts: true,
			asynchronous: true,
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					
					if(param == "LINE_CODE_MC")
						lineCdMc = response.responseText;
						
					objGiexs006.giispLineCd = response.responseText;
				}
			}
		});
	}
	
	var lineCdMc;
	getGiispLineCd("LINE_CODE_MC");
	
	function getSelectedReport(){
		for(var i = 0; i<reportArr.length; i++){
			if(reportArr[i] == "RENEWAL NOTICE" || reportArr[i] == "PACKAGE RENEWAL NOTICE" || reportArr[i] == "NON-RENEWAL NOTICE" || reportArr[i] == "RENEWAL CERTIFICATE"){
				checkRecordUser(reportArr[i]);	
			}else if(reportArr[i] == "PACKAGE NON-RENEWAL NOTICE"){
				objGiexs006.renewFlag = 1;
				if($("batch").checked){
					checkPolicyIdCount("getRenewalNoticePolicyId", "/GIEXExpiryController", reportArr);	
				}else{
					getDialog(reportArr);
				}
			}else if(reportArr[i].indexOf("Motor Car") > -1){
				//apollo cruz 08.26.2015 SR#20009 populating of line cd for motor car was done upon page load, lineCdMc was used instead of objGiexs006.giispLineCd
				//getGiispLineCd("LINE_CODE_MC");
				if($F("lineLOV") != "" && $F("lineLOV") != lineCdMc /*objGiexs006.giispLineCd*/){
					customShowMessageBox("Invalid line cd.  Report selected is not for "+$F("lineName"), "E", "searchLineLOV");	
				}else{
					printGIEXRReport("",reportArr[i], reportArrId[i]);
				}
			}else{
				printGIEXRReport("",reportArr[i], reportArrId[i]);
			}
			if(i == reportArr.length-1){
				for(var i=0; i<giexrs006TableGrid.rows.length; i++){
					$("mtgInput"+giexrs006TableGrid._mtgId+"_2,"+i).checked = false;
				}
				getReport("", "");
				giexrs006TableGrid.keys.releaseKeys();
			}
		}
		
		if ("SCREEN" == $F("selDestination")) {
			showMultiPdfReport(reports);
			reports = [];
		}
	}
	
	function printGIEXRReport(policyId, reportArr, reportArrId){
		var content;
		var printBy = $("batch").checked;
	    var reportId; //SR-5317

		if($F("selDestination") == "FILE") { //Start: SR-5317
			if(reportArrId == "GIEXR101B" || reportArrId == "GIEXR101A" || reportArrId == "GIEXR102A" || reportArrId == "GIEXR102" ||
				reportArrId == "GIEXR103B" || reportArrId == "GIEXR103A"){
				if ($("P").checked) 
					reportId = reportArrId;
				else {
					reportId = reportArrId+"_CSV";
				}
			}else{
				reportId = reportArrId;
			}
		} else {
			reportId = reportArrId;
		} //End:  SR-5317
		
		if($("indvlPolNo").checked){
			policyId = dspPolicyId;
			printBy = "individual";
		}else{
			printBy = "batch";
		}
		if(reportArr == "RENEWAL NOTICE" || reportArr == "PACKAGE RENEWAL NOTICE"){
			content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+policyId+"&printerName="+$F("selPrinter")+"&reportName="+reportArrId+policyId;
		}else if(reportArr == "Expiry List(Report/Outward)"){
			var expiryMonth;
			var expiryYear;
			if($("byMonthYear").checked){
				if($("onOrBefore").checked){
					expiryMonth = $F("fromMonth");
					expiryYear = $F("fromYear");
				}else{
					expiryMonth = $F("toMonth");
					expiryYear = $F("toYear");
				}
			}else{
				if($("onOrBefore").checked){
					expiryMonth = dateFormat($F("fromDate"),"mmm").toUpperCase();
					//expiryMonth = $F("fromDate").substring(0,2);
					expiryYear = $F("fromDate").substring(6,10);
				}else{
					expiryMonth = dateFormat($F("toDate"),"mmm").toUpperCase();
					//expiryMonth = $F("toDate").substring(0,2);
					expiryYear = $F("toDate").substring(6,10);;
				}
			}
			if($("batch").checked){
				content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+policyId+"&lineName="+$F("lineName")+"&expiryMonth="+expiryMonth+"&expiryYear="+expiryYear+"&reportName="+reportId+"&printerName="+$F("selPrinter")+"&printBy="+printBy;	//reportId* SR-5317
			}else{
				content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+policyId+"&reportName="+reportId+"&printerName="+$F("selPrinter")+"&printBy="+printBy; //reportId* SR-5317
			}
		}else{
			if($("batch").checked){
				content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+policyId
					+"&assdNo="+$F("assuredLOV")+"&intmNo="+$F("intmLOV")+"&issCd="+objGiexs006.issCd
					+"&sublineCd="+objGiexs006.sublineCd+"&lineCd="+objGiexs006.lineCd+"&startDate="+objGiexs006.startDate
					+"&endDate="+objGiexs006.endDate+"&includePackage="+objGiexs006.includePackage+"&claimsOnly="+objGiexs006.claimsOnly	//Gzelle 05202015 SR3698 - changed to global variable
					+"&premBalanceOnly="+objGiexs006.premBalanceOnly+"&printerName="+$F("selPrinter")+"&reportName="+reportId	//Gzelle 05202015 SR3703 - changed to global variable
					+"&printBy="+printBy;	
			}else{
				content = contextPath+"/GIEXExpiryPrintController?action=printGiexs006Report&policyId="+objGiexs006.dspPolicyId+"&printerName="+$F("selPrinter")+"&reportName="+reportId+"&printBy="+printBy;	 //reportId* SR-5317
			}
		}
		if($F("selDestination") == "SCREEN"){
			reports.push({reportUrl : content, reportTitle : reportArr});			
		}else if($F("selDestination") == "PRINTER"){
			new Ajax.Request(content, {
				method: "GET",
				parameters : {noOfCopies : $F("txtNoOfCopies"),
						 	 printerName : $F("selPrinter")
						 	 },
				evalScripts: true,
				asynchronous: true,
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						showMessageBox("Printing complete.",imgMessage.SUCCESS);	//added by Gzelle 05202015 SR3705
					}
				}
			});
		}else if($F("selDestination") == "FILE"){
			 var fileType = "PDF";
		
			if($("P").checked)
				fileType = "PDF";
			else if(reportId == reportArrId+"_CSV" && $("C").checked) // SR-5317
				fileType = "CSV2"; //SR-5317
			else if ($("C").checked)
				fileType = "CSV";
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV" || fileType == "CSV2"){ // CSV2 SR-5317
							copyFileToLocal(response, "csv");
							if(fileType == "CSV"){ //SR-5317
								deleteCSVFileFromServer(response.responseText);
							}
						} else 
							copyFileToLocal(response);
					}
				}
			});
			
			/*new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "FILE"},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						copyFileToLocal(response);
					}
				}
			});*/
		}else if("LOCAL" == $F("selDestination")){
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "LOCAL"},
				evalScripts: true,
				asynchronous: true,
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
	}
	
	$("fromYear").observe("change", function(){
		if($F("fromYear") != ""){
			if($F("fromYear").length != 4 || isNaN($F("fromYear")) || $F("fromYear") <= 0){
				customShowMessageBox("Invalid year.", imgMessage.ERROR, "fromYear");
				$("fromYear").value = "";
			}	
		}
	});
	
	$("toYear").observe("change", function(){
		if($F("toYear") != ""){
			if($F("toYear").length != 4 || isNaN($F("toYear")) || $F("toYear") <= 0){
				customShowMessageBox("Invalid year.", imgMessage.ERROR, "toYear");
				$("toYear").value = "";
			}	
		}
	});

	function validateDate(){
		if(validateRnSeqNo()){
			if($("batch").checked == true){
				if($("exactRange").checked == true){
					if($("byDate").checked == true){
						if($("fromDate").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromDate");
						}else if($("toDate").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "toDate");
						}else{
							return true;
						}
					}else if($("byMonthYear").checked == true){
						if($("fromMonth").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromMonth");
						}else if($F("fromYear") == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromYear");
						}else if($("toMonth").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "toMonth");
						}else if($("toYear").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "toYear");
						}else{
							return true;
						} 
					}
				}else if($("onOrBefore").checked == true){
					if($("byDate").checked == true){
						if($("fromDate").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromDate");
						}else{
							return true;
						}
					}else if($("byMonthYear").checked == true){
						if($("fromMonth").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromMonth");
						}else if($("fromYear").value == ""){
							customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "fromYear");
						}else{
							return true;
						}
					}
				}
			}
		}
	}
	
	function validateRnSeqNo(){
		if($F("frRnSeqNo") == "" && $F("toRnSeqNo") != ""){
			customShowMessageBox("Please enter beginning RN No.", "E", "frRnSeqNo");
		}else if($F("frRnSeqNo") != "" && $F("toRnSeqNo") == ""){
			customShowMessageBox("Please enter ending RN No.", "E", "toRnSeqNo");
		}else{
			return true;
		}
	}

	var fromDate;
	var toDate;
	function validateDateRange(){
		try{
			if(validateDate()){
				var result = false;
				if($("byMonthYear").checked == true){
					fromDate = "01-" + $F("fromMonth") + "-" + $F("fromYear");
					toDate = "01-" + $F("toMonth") + "-" + $F("toYear");
				}else if($("byDate").checked == true){
					fromDate = $("fromDate").value;
					toDate = $("toDate").value;
				}
				if($("exactRange").checked){
					if(Date.parse(toDate) < Date.parse(fromDate)){
						showMessageBox("From Date must not be greater than To Date.", imgMessage.ERROR);
					}else{
						result = true;
					}	
				}else if($("onOrBefore").checked){
					result = true;
				}
				return result;
			}
		}catch(e){
			showMessageError("validateDateRange",e);
		}
	}
	 
	$("frRnSeqNo").observe("change", function(){
		if(isNaN($F("frRnSeqNo"))){
			customShowMessageBox("Field must be of form 0999999.", "E", "frRnSeqNo");
		}else{
			if($F("frRnSeqNo") != ""){
				$("frRnSeqNo").value = formatNumberDigits($F("frRnSeqNo"),7);	
			}
		}
	});
	
	$("toRnSeqNo").observe("change", function(){
		if(isNaN($F("toRnSeqNo"))){
			customShowMessageBox("Field must be of form 0999999.", "E", "toRnSeqNo");
		}else{
			if($F("toRnSeqNo") != ""){
				$("toRnSeqNo").value = formatNumberDigits($F("toRnSeqNo"),7);
			}
		}
	});

	function checkRecordUser(reportArr){
		var action = "";
		var controller = "";
		var polId;
		if(reportArr == "RENEWAL NOTICE" || reportArr == "RENEWAL CERTIFICATE"){
			action = "checkRecordUser";
			controller = "/GIEXExpiryController";
			polId = dspPolicyId;
		}else if(reportArr == "PACKAGE RENEWAL NOTICE"){
			action = "checkPackRecordUser";
			controller = "/GIEXPackExpiryController";
			polId = dspPackPolicyId;
		}else if(reportArr == "NON-RENEWAL NOTICE"){
			action = "checkRecordUserNr";
			controller = "/GIEXExpiryController";
			polId = dspPolicyId;
		}
		new Ajax.Request(contextPath+controller,{
			method: "POST",
			parameters:{
				action     : action,
				policyId   : polId, 
				frRnSeqNo  : $F("frRnSeqNo"),
				toRnSeqNo  : $F("toRnSeqNo"),
				assdNo     : $F("assuredLOV"),
				intmNo     : $F("intmLOV"),
				issCd      : objGiexs006.issCd,
				sublineCd  : objGiexs006.sublineCd,
				lineCd     : objGiexs006.lineCd,
				startDate  : objGiexs006.startDate,
				endDate    : objGiexs006.endDate
			},
			asynchronous: false,
			evalScripts: true,
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'Y'){ // response.responseText == 'Y' dapat ito
						if(reportArr == "RENEWAL NOTICE"){
							objGiexs006.renewFlag = 2;
							if($("batch").checked){
								checkPolicyIdCount("getRenewalNoticePolicyId", "/GIEXExpiryController", reportArr);	
							}else{
								getDialog(reportArr);
							}
						}else if(reportArr == "PACKAGE RENEWAL NOTICE"){
							objGiexs006.renewFlag = 2;
							if($("batch").checked){
								checkPolicyIdCount("getPackPolicyId", "/GIEXPackExpiryController", reportArr);
							}else{
								getDialog(reportArr);
							}
						}else if(reportArr == "NON-RENEWAL NOTICE"){
							objGiexs006.renewFlag = 1;
							if($("batch").checked){
								checkPolicyIdCount("getRenewalNoticePolicyId", "/GIEXExpiryController", reportArr);
							}else{
								getDialog(reportArr);
							}
						}else if(reportArr == "RENEWAL CERTIFICATE"){
							objGiexs006.renewFlag = 2;
							if($("batch").checked){
								checkPolicyIdCount("getPolicyIdGiexs006", "/GIEXExpiriesVController", reportArr);	
							}else{
								getDialog(reportArr);
							}
						}
					}else{
						if(reportArr == "NON-RENEWAL NOTICE"){
							showWaitingMessageBox("Please check if the renewal number is existing and if you are allowed to print it.", imgMessage.ERROR, 
							function(){
								objGiexs006.renewFlag = 1;
								if($("batch").checked){
									checkPolicyIdCount("getRenewalNoticePolicyId", "/GIEXExpiryController", reportArr);
								}else{
									getDialog(reportArr);
								}	
							});
						}else{
							showMessageBox("Please check if the renewal number is existing and if you are allowed to print it.", imgMessage.ERROR);
						}
					}
				}
			}
		});
	}
	
	function checkPolicyIdCount(action, controller, reportArr){
		try{
			new Ajax.Request(contextPath+controller,{
				method: "GET",
				parameters: {
					action	     : action,
					frRnSeqNo    : $F("frRnSeqNo"),
					toRnSeqNo    : $F("toRnSeqNo"),
					assdNo       : $F("assuredLOV"),
					intmNo       : $F("intmLOV"),
					issCd        : objGiexs006.issCd,
					sublineCd    : objGiexs006.sublineCd,
					lineCd       : objGiexs006.lineCd,
					startDate    : objGiexs006.startDate,
					endDate      : objGiexs006.endDate,
					renewFlag    : objGiexs006.renewFlag,
					reqRenewalNo : objGiexs006.reqRenewalNo,
					premBalanceOnly : objGiexs006.premBalanceOnly,	//Gzelle 05202015 SR3703
					claimsOnly : objGiexs006.claimsOnly	//Gzelle 05202015 SR3698
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(response) {
					var res = JSON.parse(response.responseText);
					if(res.length<=5){
						getDialog(reportArr);
					}else{
						showConfirmBox("Confirmation","There are more than 5 records retrived, data will directly be sent to printer. Do you want to continue?"
								,"Ok"
								,"Cancel"
								,function () {
									getDialog(reportArr);
								}
								,"");
					}
				}
			});
		}catch(e){
			showErrorMessage("checkPolicyIdCount", e);
		}
	}
	
	function getDialog(reportArr){
		if(reportArr == "RENEWAL NOTICE" && infoSw == 'Y'){
			showExpiryReportInfoDialog(reportArr);
		}else if(reportArr == "RENEWAL NOTICE" && renewSw == 'Y'){
			showExpiryReportRenewalDialog(reportArr);			
		}else if(reportArr =="PACKAGE RENEWAL NOTICE" && infoSw == 'Y'){
			showExpiryReportInfoDialog(reportArr);
		}else if(reportArr =="PACKAGE RENEWAL NOTICE" && renewSw == 'Y'){
			showExpiryReportRenewalDialog(reportArr);
		}else if(reportArr =="NON-RENEWAL NOTICE" && reasonSw == 'Y'){
			showExpiryReportReasonDialog(reportArr);
		}else if(reportArr =="PACKAGE NON-RENEWAL NOTICE" && reasonSw == 'Y'){
			showExpiryReportReasonDialog(reportArr);
		}else{
			getRenewalNoticePolicyId2();
		}
	}
	
	var lineCd;
	var issCd;
	var sublineCd;
	var issueYy;
	var polSeqNo;
	var renewNo;
	var startDate;
	var endDate;
	var includePackage = "";
	var claimsOnly = "";
	var premBalanceOnly = "";

	$("includePackage").observe("click", function(){
		if($("includePackage").checked){
			includePackage = "Y";
			objGiexs006.includePackage = "Y"; //marco - 04.29.2013
		}else{
			includePackage = "N";
			objGiexs006.includePackage = "N"; //
		}
	});
	
	$("claimsOnly").observe("click", function(){
		if($("claimsOnly").checked){
			claimsOnly = "Y";
			objGiexs006.claimsOnly = "Y";	//Gzelle 05202015 SR3698
		}else{
			claimsOnly = "N";
			objGiexs006.claimsOnly = "";	//Gzelle 05202015 SR3698
		}
	});
	
	$("premBalanceOnly").observe("click", function(){
		if($("premBalanceOnly").checked){
			premBalanceOnly = "Y";
			objGiexs006.premBalanceOnly = "Y";	//Gzelle 05202015 SR3703
		}else{
			premBalanceOnly = "N";
			objGiexs006.premBalanceOnly = "";	//Gzelle 05202015 SR3703
		}
	});

	var reports = [];
	function getRenewalNoticePolicyId2(){
		try{
			new Ajax.Request(contextPath+"/GIEXExpiryController",{
				method: "GET",
				parameters: {
					action	   : "getRenewalNoticePolicyId",
					frRnSeqNo  : $F("frRnSeqNo"),
					toRnSeqNo  : $F("toRnSeqNo"),
					assdNo     : $F("assuredLOV"),
					intmNo     : $F("intmLOV"),
					issCd      : objGiexs006.issCd,
					sublineCd  : objGiexs006.sublineCd,
					lineCd     : objGiexs006.lineCd,
					startDate  : objGiexs006.startDate,
					endDate    : objGiexs006.endDate,
					noOfCopies : $("txtNoOfCopies").value,
					printerName: $("selPrinter").value,
					renewFlag  : objGiexs006.renewFlag,
					premBalanceOnly : objGiexs006.premBalanceOnly,	//Gzelle 05202015 SR3703
					claimsOnly : objGiexs006.claimsOnly	//Gzelle 05202015 SR3698
				},
				evalScripts:	true,
				asynchronous:	true,
				onComplete: function(response) {					
					var res = JSON.parse(response.responseText);
					if(res.length == 0){
						showMessageBox("Policy is not existing.", imgMessage.ERROR);
						objGiexs006.checkPolicyId = "N";
					}else{
						for(var a=0; a<res.length; a++){
							printGIEXRReport(res[a].policyId);
						}
						if ("SCREEN" == $F("selDestination")) {
							showMultiPdfReport(reports);
							reports = [];
						}
					}
					overlayExpiryReportInfoDialog.close();
				}
			});
		}catch(e){
			showErrorMessage("getRenewalNoticePolicyId2", e);
		}
	}

	$("onOrBefore").observe("click", function(){
		$("toMonth").removeClassName("required");
		$("toMonth").disable();
		$("toMonth").clear();
		$("toYear").removeClassName("required");
		$("toYear").disable();
		$("toYear").clear();
		$("toDate").removeClassName("required");
		$("toDate").disable();
		$("toDate").up("div",0).removeClassName("required");
		$("toDate").up("div",0).addClassName("disabledGiexs006");
		$("toDate").clear();
		disableDate("imgToDate");
		if($("byMonthYear").checked == true){
			$("fromMonth").enable();
			$("fromYear").enable();
			$("fromMonth").addClassName("required");
			$("fromYear").addClassName("required");
			$("fromDate").removeClassName("required");
			$("fromDate").disable();
			$("fromDate").up("div",0).addClassName("disabledGiexs006");
			disableDate("imgFmDate");
		}else if($("byDate").checked == true){
			$("fromDate").addClassName("required");
			$("fromDate").enable();
			$("fromDate").up("div",0).removeClassName("disabledGiexs006");
			enableDate("imgFmDate");
			$("fromMonth").removeClassName("required");
			$("fromYear").removeClassName("required");
			$("fromMonth").disable();
			$("fromYear").disable();
		}
	});
	
	$("exactRange").observe("click", function(){
		if($("byMonthYear").checked == true){
			byMonthYear();
		}else if($("byDate").checked == true){
			byDate();
		}
	});
	
	$("btnExitPrintReport").observe("click", function(){
		if(nvl(objUWGlobal.callingForm,"") =='GIEXS004'){
			showProcessExpiringPoliciesPage();
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}
		
	});
	
	$("btnCancel").observe("click", function(){
		//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		if(nvl(objUWGlobal.callingForm,"") =='GIEXS004'){
			showProcessExpiringPoliciesPage();
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);	
		}
	});
	
	$("includePackage").checked = true;
	$("batch").checked = true;
	$("fromDate").disable();
	$("fromDate").up("div",0).addClassName("disabledGiexs006");
	$("toDate").disable();
	$("toDate").up("div",0).addClassName("disabledGiexs006");
	$("fromMonth").focus();
	disableDate("imgFmDate");
	disableDate("imgToDate");
	disableButton("btnGenerateRenewalNo");

	function showExpiryReportInfoDialog(reportArr){
		objGiexs006.giexs006Report = reportArr;
		overlayExpiryReportInfoDialog = Overlay.show(contextPath+"/GIEXExpiryController", {
			urlContent : true,
			urlParameters: {action : "showExpiryReportInfoDialog"},
		    title: "Info",
		    height: 268,
		    width: 350,
		    draggable: true
		});
	}
	
	function showExpiryReportRenewalDialog(reportArr){
		objGiexs006.giexs006Report = reportArr;
		overlayExpiryReportRenewalDialog = Overlay.show(contextPath+"/GIEXExpiryController", {
			urlContent : true,
			urlParameters: {action: "showExpiryReportRenewalDialog"},
			title: "Reason for Renewal",
			height: 240,
			width: 550,
			draggable: true
		});
	}
	
	function showExpiryReportReasonDialog(reportArr){
		objGiexs006.giexs006Report = reportArr;
		overlayExpiryReportReasonDialog = Overlay.show(contextPath+"/GIEXExpiryController", {
			urlContent : true,
			urlParameters: {action: "showExpiryReportReasonDialog"},
			title: "Reason for Non-Renewal",
			height: 240,
			width: 450,
			draggable: true
		});
	}
	
	$("lineCd").observe("keyup",function(){
		$("lineCd").value = $("lineCd").value.toUpperCase();
	});
	
	$("sublineCd").observe("keyup",function(){
		$("sublineCd").value = $("sublineCd").value.toUpperCase();
	});
	
	$("issCd").observe("keyup",function(){
		$("issCd").value = $("issCd").value.toUpperCase();
	});

	$("lineCd").observe("change", function(){
		var sw = "i";
		if($("lineCd").value != ""){
			validateLineCdGiexs006(sw);
		}else{
			changeIncludePackValue($F("lineCd"));
		}
		checkPolicyGiexs006func();
	});
	
	$("sublineCd").observe("change", function(){
		var sw = "i";
		if($("sublineCd").value != ""){
			validateSublineCdGiexs006(sw);
		}
		checkPolicyGiexs006func();
	});
	
	$("issCd").observe("change", function(){
		var sw ="i";
		if($("issCd").value != ""){
			validateIssCdGiexs006(sw);
		}
		checkPolicyGiexs006func();
	});
	
	$("issueYy").observe("change", function(){
		if(isNaN($F("issueYy"))){
			customShowMessageBox("Field must be of form 09.", "E", "issueYy");
			$("issueYy").clear();
		}else{
			$("issueYy").value = formatNumberDigits($F("issueYy"),2);
		}
		checkPolicyGiexs006func();
	});
	
	$("polSeqNo").observe("change", function(){
		if(isNaN($F("polSeqNo"))){
			customShowMessageBox("Field must be of form 0000009.", "E", "polSeqNo");
			$("polSeqNo").clear();
		}else{
			$("polSeqNo").value = formatNumberDigits($F("polSeqNo"),6);
		}
		checkPolicyGiexs006func();
	});
	
	$("renewNo").observe("change", function(){
		if(isNaN($F("renewNo"))){
			customShowMessageBox("Legal characters are 0-9.", "E", "renewNo");
			$("renewNo").clear();
		}
		checkPolicyGiexs006func();
	});
	
	function checkPolicyGiexs006func(){
		if(!($F("lineCd") == "" || $F("sublineCd") == "" || $F("issCd") == "" || $F("issueYy") == "" || $F("polSeqNo") == "" || $F("renewNo") == "")){
			checkPolicyGiexs006();		
		} 
	}
	
	function validateLineCdGiexs006(sw){
		var lineCd;
		var issCd;
		if(sw == "i"){
			lineCd = $F("lineCd");
			issCd = $F("issCd");
		}else{
			lineCd = $F("lineLOV");
			issCd = $F("creditingLOV");
		}
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	   : "validateLineCdGiexs006",
				lineCd 	   : lineCd,
				issCd      : issCd,
				moduleId   : "GIEXS006"
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					if(sw == "i"){
						$("lineCd").value = "";
						showPrintExpReportLineLOV();
					}else{
						$("lineLOV").value ="";
						$("lineName").value ="";
						$("lineLOV").focus();
						customShowMessageBox("Line code does not exist in table giis_line.",imgMessage.ERROR,"lineCd");
					}
				}else{
					if(sw == "b"){
						$("lineName").value = res[0].lineName;
						changeIncludePackValue($F("lineLOV"));
					}else{
						changeIncludePackValue($F("lineCd"));
					}
					
				}	
				
			}
		});
	}
	
	function validateSublineCdGiexs006(sw){
		var lineCd;
		var sublineCd;
		if(sw == "i"){
			lineCd = $F("lineCd");
			sublineCd = $F("sublineCd");
		}else{
			lineCd = $F("lineLOV");
			sublineCd = $F("sublineLOV");
		}
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	   : "validateSublineCdGiexs006",
				lineCd 	   : lineCd,
				sublineCd  : sublineCd
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					if(sw == "i"){
						$("sublineCd").value = "";
						showPrintExpReportSublineLOV();
					}else{
						$("sublineLOV").value = "";
						$("sublineName").value = "";
						$("sublineLOV").focus();
						customShowMessageBox("Subline code does not exist in table giis_subline.",imgMessage.ERROR,"sublineCd");
					}
				}else{
					if(sw == "b"){
						$("sublineName").value = res[0].sublineName;	
					}
				}
			}
		});
	}
	
	function validateIssCdGiexs006(sw){
		var issCd;
		var lineCd;
		if(sw == "i"){
			issCd = $F("issCd");
			lineCd = $F("lineCd");
		}else{
			issCd = $F("creditingLOV");
			lineCd = $F("lineLOV");
		}
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action		: "validateIssCdGiexs006",
				issCd		: issCd,
				lineCd		: lineCd,
				moduleId	: "GIEXS006"
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					if(sw == "i"){
						$("issCd").value = "";
						showPrintExpReportIssourceLOV();
					}else{
						$("creditingLOV").value = "";
						$("creditingName").value = "";
						$("creditingLOV").focus();
						customShowMessageBox("Issuing code does not exist in table giis_issource.",imgMessage.ERROR,"sublineCd");
					}
				}else{
					if(sw == "b"){
						$("creditingName").value = res[0].issName;	
					}
				}
			}
		});
	}
	
	function validateAssdNoGiexs006(){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	: "validateAssdNoGiexs006",
				assdNo	: $F("assuredLOV")
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					$("assuredLOV").clear();
					$("assuredName").clear();
					customShowMessageBox("Assured No. is not existing in the maintenance table.", imgMessage.ERROR, "assuredLOV");
				}else{
					$("assuredName").value = res[0].assdName;
					$("assuredLOV").value = formatNumberDigits($F("assuredLOV"),12);
				}
			}
		});
	}
	
	function validateIntmNoGiexs006(){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	: "validateIntmNoGiexs006",
				intmNo	: $F("intmLOV")
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response){
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					$("intmLOV").clear();
					$("intmName").clear();
					customShowMessageBox("Intermediary No. is not existing in the maintenance table.", imgMessage.ERROR, "intmLOV");
				}else{
					$("intmName").value = res[0].intmName;
					$("intmLOV").value = formatNumberDigits($F("intmLOV"),12);
				}
			}
		});
	}

	function checkPolicyGiexs006(){
		new Ajax.Request(contextPath+"/GIPIPolbasicController",{
			method: "GET",
			parameters: {
				action	   : "checkPolicyGiexs006",
				lineCd 	   : $F("lineCd"),
				sublineCd  : $F("sublineCd"),
				issCd      : $F("issCd"),
				issueYy    : $F("issueYy"),
				polSeqNo   : $F("polSeqNo"),
				renewNo    : $F("renewNo")
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					checkPackPolicyGiexs006($F("lineCd"),$F("sublineCd"),$F("issCd"),$F("issueYy"),$F("polSeqNo"),$F("renewNo"));
				}else{					
					if(res[0].polFlag == 5){
						showMessageBox("This policy is already spoiled, policy that is already spoiled is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}else if(res[0].polFlag == 4){
						showMessageBox("This policy is already cancelled, cancelled policy is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}else if(res[0].polFlag == "X"){
						showMessageBox("This policy is already expired, expired policy is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}
					checkPolicyIdGiexs006(res[0].policyId);
				}
			}
		});
	}
	
	function checkPackPolicyGiexs006(lineCd, sublineCd, issCd, issueYy, polSeqNo, renewNo){
		new Ajax.Request(contextPath+"/GIPIPackPolbasicController",{
			method: "GET",
			parameters: {
				action	   : "checkPackPolicyGiexs006",
				lineCd 	   : lineCd,
				sublineCd  : sublineCd,
				issCd      : issCd,
				issueYy    : issueYy,
				polSeqNo   : polSeqNo,
				renewNo    : renewNo
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				var res = JSON.parse(response.responseText);
				if(res.length == 0){
					showMessageBox("Policy is not existing.", imgMessage.ERROR);
					objGiexs006.checkPolicyId = "N";
				}else{					
					if(res[0].packPolFlag == 5){
						showMessageBox("This policy is already spoiled, policy that is already spoiled is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}else if(res[0].packPolFlag == 4){
						showMessageBox("This policy is already cancelled, cancelled policy is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}else if(res[0].packPolFlag == "X"){
						showMessageBox("This policy is already expired, expired policy is not included in expiry list.", imgMessage.INFO);
						objGiexs006.checkPolicyId = "N";
					}
					checkPackPolicyIdGiexs006(res[0].packPolicyId);
				}
			}
		});
	}
	
	function checkPolicyIdGiexs006(policyId){		
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	   : "checkPolicyIdGiexs006",
				policyId   : policyId
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'N'){
						showMessageBox("Policy is not yet extracted in expiry module.", imgMessage.ERROR);
						objGiexs006.checkPolicyId = "N";
					}else{
						objGiexs006.checkPolicyId = "Y";
						dspPolicyId = policyId;
						objGiexs006.dspPolicyId = policyId; 
					}
					if(objGiexs006.checkPolicyId == "Y" && btnPrintSw == 'Y'){	//SR1330 lmlbeltran 06092015
						objGiexs006.lineCd = $F("lineCd");
						btnPrintSw = 'N';
						printReport();
					}
				}
			}
		});
	}
	
	function checkPackPolicyIdGiexs006(packPolicyId){
		new Ajax.Request(contextPath+"/GIEXPackExpiryController",{
			method: "GET",
			parameters: {
				action	   	   : "checkPackPolicyIdGiexs006",
				packPolicyId   : packPolicyId
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					if(response.responseText == 'N'){
						showMessageBox("Policy is not yet extracted in expiry module.", imgMessage.ERROR);
						objGiexs006.checkPolicyId = "N";
					}else{
						objGiexs006.checkPolicyId = "Y";
						dspPackPolicyId = packPolicyId;
						objGiexs006.dspPolicyId = packPolicyId;
					}
					if(objGiexs006.checkPolicyId == "Y" && btnPrintSw == 'Y'){ // Added by Jerome Bautista SR 19810 07.22.2015
						objGiexs006.lineCd = $F("lineCd");
						btnPrintSw = 'N';
						printReport();
					}
				}
			}
		});
	}
	
	function changeIncludePackValue(lineCd){
		if($("indvlPolNo").checked){
			if($F("lineCd") == ""){
				objGiexs006.includePackage = "N";
				$("indvlPolNo").disable = true;
				$("includePackage").checked = true;
			}else{
				getIncludePackValue(lineCd);
			}
		}else if($("batch").checked){
			if($F("lineLOV") == "" || $F("lineLOV") == null){
				$("indvlPolNo").disable = false;
				$("includePackage").checked = true;
			}else{
				getIncludePackValue(lineCd);
			}
			objGiexs006.includePackage = "Y";
		}
	}
	
	function getIncludePackValue(lineCd){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			parameters: {
				action : "changeIncludePackValue",
				lineCd : lineCd
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				objGiexs006.includePackage = response.responseText;
				if(response.responseText == "Y"){						
					$("includePackage").checked = true;
					$("includePackage").disable();
					objGiexs006.includePackage = "Y";
				}else{
					$("includePackage").checked = false;
					$("includePackage").disable();
					objGiexs006.includePackage = "N";
				}
			}
		});
	}
	
	$("btnGenerateRenewalNo").observe("click", function(){
		generateRenewalNo();
	});
	
	function generateRenewalNo(){
		if($F("lineCd") == "" && $F("lineLOV") == ""){
			if($("indvlPolNo").checked){
				customShowMessageBox("Please enter Policy Number or the Line code of policies you wish to transact.", "E", "lineCd");
			}else{
				customShowMessageBox("Please enter Policy Number or the Line code of policies you wish to transact.", "E", "lineLOV");			
			}
		}else{
			showConfirmBox("Confirmation","Are you sure you want to generate Renewal Notice No.?"
					,"Yes"
					,"No"
					,function (){
						generateRenewalNoParams();
					},
					"");
		}
	}
	
	function generateRenewalNoParams(){
		var frDate;
		var toDate;
		var fDay = 31;
		var tDay = 31;
		var fMonth;
		var tMonth;
		
		if($F("fromMonth") == "FEB"){
			fDay = 29;
		}else if($F("fromMonth") == "APR" || $F("fromMonth") == "JUN" || $F("fromMonth") == "SEP" || $F("fromMonth") == "NOV"){
			fDay = 30;
		}
		
		if($F("toMonth") == "FEB"){
			tDay = 29;
		}else if($F("toMonth") == "APR" || $F("toMonth") == "JUN" || $F("toMonth") == "SEP" || $F("toMonth") == "NOV"){
			tDay = 30;
		}
		
		if($F("fromMonth") == "JAN"){
			fMonth = 01;
		}else if($F("fromMonth") == "FEB"){
			fMonth = 02;
		}else if($F("fromMonth") == "MAR"){
			fMonth = 03;
		}else if($F("fromMonth") == "APR"){
			fMonth = 04;
		}else if($F("fromMonth") == "MAY"){
			fMonth = 05;
		}else if($F("fromMonth") == "JUN"){
			fMonth = 06;
		}else if($F("fromMonth") == "JUL"){
			fMonth = 07;
		}else if($F("fromMonth") == "AUG"){
			fMonth = 08;
		}else if($F("fromMonth") == "SEP"){
			fMonth = 09;
		}else if($F("fromMonth") == "OCT"){
			fMonth = 10;
		}else if($F("fromMonth") == "NOV"){
			fMonth = 11;
		}else if($F("fromMonth") == "DEC"){
			fMonth = 12;
		}
		
		if($F("toMonth") == "JAN"){
			tMonth = 01;
		}else if($F("toMonth") == "FEB"){
			tMonth = 02;
		}else if($F("toMonth") == "MAR"){
			tMonth = 03;
		}else if($F("toMonth") == "APR"){
			tMonth = 04;
		}else if($F("toMonth") == "MAY"){
			tMonth = 05;
		}else if($F("toMonth") == "JUN"){
			tMonth = 06;
		}else if($F("toMonth") == "JUL"){
			tMonth = 07;
		}else if($F("toMonth") == "AUG"){
			tMonth = 08;
		}else if($F("toMonth") == "SEP"){
			tMonth = 09;
		}else if($F("toMonth") == "OCT"){
			tMonth = 10;
		}else if($F("toMonth") == "NOV"){
			tMonth = 11;
		}else if($F("toMonth") == "DEC"){
			tMonth = 12;
		}
		if($("onOrBefore").checked){
			if($("byDate").checked){
				frDate = Date.parse('01-01-1900');
	  	      	toDate = Date.parse($F("fromDate"));
			}else{
				frDate = Date.parse('01-01-1900');
				var tDate = fMonth+"-"+fDay+"-"+$F("fromYear");
	  	      	toDate = Date.parse(tDate);
			}
		}else{
			if($("byDate").checked){
				frDate = Date.parse($F("fromDate"));
	  	      	toDate = Date.parse($F("toDate"));
			}else{
				var fDate = fMonth+"-01-"+$F("fromYear");
				frDate = Date.parse(fDate);
				var tDate = tMonth+"-"+tDay+"-"+$F("toYear");
	  	      	toDate = Date.parse(tDate);
			}
		}
		doGenerateRenewalNo(frDate, toDate);
	}
	
	function checkGenRnNo(frDate, toDate){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			parameters: {
				action	   	: "checkGenRnNo",
				lineLOV 	: $F("lineLOV"),
				sublineLOV 	: $F("sublineLOV"),
				issLOV 		: $F("creditingLOV"),
				intmLOV 	: $F("intmLOV"),
				lineCd 		: $F("lineCd"),
				sublineCd 	: $F("sublineCd"),
				issCd 		: $F("issCd"),
				issueYy		: $F("issueYy"),
				polSeqNo 	: removeLeadingZero($F("polSeqNo")), // ADDED BY IRWIN 7.25.2012
				renewNo 	: $F("renewNo"),
				frDate		: frDate,
				toDate		: toDate
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					if(response.responseText != 0){
						showConfirmBox("Confirmation","Are you sure you want to generate Renewal Notice No.?"
								,"Yes"
								,"No"
								,function (){
									doGenerateRenewalNo(frDate, toDate);
								},
								"");
					}else{
						showMessageBox("There are no record(s) to be processed.", "E");
					}
				}
			}
		});
	}
	
	function doGenerateRenewalNo(frDate, toDate){
		new Ajax.Request(contextPath+"/GIEXExpiryController",{
			method: "GET",
			parameters: {
				action	   	: "generateRenewalNo",
				lineLOV 	: $F("lineLOV"),
				sublineLOV 	: $F("sublineLOV"),
				issLOV 		: $F("creditingLOV"),
				intmLOV 	: $F("intmLOV"),
				lineCd 		: $F("lineCd"),
				sublineCd 	: $F("sublineCd"),
				issCd 		: $F("issCd"),
				issueYy		: $F("issueYy"),
				polSeqNo 	: $F("polSeqNo"),
				renewNo 	: $F("renewNo"),
				frDate		: frDate,
				toDate		: toDate
			},
			evalScripts:	true,
			asynchronous:	true,
			onComplete: function(response) {
				if(checkErrorOnResponse(response)){
					if(response.responseText == "SUCCESS"){
						showMessageBox("Finished generating Renewal Notice no.", imgMessage.SUCCESS);
					}
				}
			}
		});
	}
	
	$("btnViewRenewal").observe("click", function(){
		objUWGlobal.callingForm = "GIEXS006";
		showViewRenewal();
	});
	
	checkDisplayGiexs006("DISPLAY_REASON_FOR_NR");
	checkDisplayGiexs006("DISPLAY_REASON_FOR_RENEWAL");
	checkDisplayGiexs006("DISPLAY_CONTACT_INFO");
	
	enableInputDiv();
	observeReloadForm("reloadForm", showPrintExpiryReportRenewalsPage);
	toggleRequiredFields("SCREEN");
	$("mainContents").style.width = "924px";
	$("outerDiv").style.width = "920px";
	$("mainNav").style.width = "922px";
}catch(e){
	showErrorMessage("GIEXS006 page", e);
}
</script>