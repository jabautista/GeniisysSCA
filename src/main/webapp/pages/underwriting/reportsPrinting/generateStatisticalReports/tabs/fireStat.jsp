<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="fireStatMainDiv">
	<div class="" style="float: left; width: 920px; height: 500px;" align="center"> 
		<div id="fieldsDiv1" class="sectionDiv" style="width: 510px; height: 230px; margin: 25px 0 1px 25px;"><!-- changed height to 230px : edgar 03/20/2015 -->
			<table style="margin-top: 30px;"><!-- changed margin to 30px from 20px : edgar 03/20/2015 -->
				<tr>
					<td class="rightAligned" style="padding-right: 7px;">Zone Description</td>
					<td>
						<input id="hidZoneType" type="hidden"/>
						<div id="zoneDiv" class="required" style="border: 1px solid gray; width: 300px; height: 20px; float: left; margin-right: 7px;">
							<input id="txtZone" name="txtZone" class="leftAligned upper required" type="text" maxlength="40" style="border: none; float: left; width: 270px; height: 13px; margin: 0px;" value="" tabindex="101"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchZone" name="searchZone" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
				<tr>
					<td style="padding-right: 7px;">
						<input value="1" title="By Date" type="radio" id="byDateRB" name="dateParamRG" style="margin: 2px 5px 4px 15px; float: left;" checked="checked"><label for="byDateRB" style="margin: 2px 0 4px 0" tabindex="102">By Date</label>
						<label style="margin: 2px 0 4px 25px;">From</label>
					</td>
					<td>
						<div id="fromDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 135px; height: 20px;">
							<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 110px; height: 13px; margin: 0px;" value="" tabindex="103"/>
							<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtFromDate').focus(); scwShow($('txtFromDate'),this, null);" />
						</div>
						<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 8px;">To</label>
						<div id="toDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 135px; height: 20px;">
							<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="withIcon required disableDelKey" maxlength="10" style="border: none; float: left; width: 110px; height: 13px; margin: 0px;" value="" tabindex="104"/>
							<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtToDate').focus(); scwShow($('txtToDate'),this, null);" />
						</div>
					</td>
				</tr>
				<tr>
					<td></td>
					<td style="padding-top: 5px;">
						<input value="AD" title="Acctg Entry Date" type="radio" id="acctEntDateRB" name="paramDateRG" style="margin: 4px 5px 4px 5px; float: left;" ><label for="acctEntDateRB" style="margin: 4px 0 4px 0" tabindex="105">Accounting Entry Date</label>									
						<input value="ED" title="Effectivity Date" type="radio" id="effDateRB" name="paramDateRG" style="margin: 4px 5px 4px 25px; float: left;" checked="checked" ><label for="effDateRB" style="margin: 4px 0 4px 0" tabindex="106">Effectivity Date</label>									
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input value="ID" title="Issue Date" type="radio" id="issueDateRB" name="paramDateRG" style="margin: 5px 5px 4px 5px; float: left;" ><label for="issueDateRB" style="margin: 5px 0 4px 0" tabindex="107">Issue Date</label>									
						<input value="BD" title="Booking Date" type="radio" id="bookingDateRB" name="paramDateRG" style="margin: 5px 5px 4px 90px; float: left;"><label for="bookingDateRB" style="margin: 5px 0 4px 0" tabindex="108">Booking Date</label>									
					</td>
				</tr>
				
				<tr>
					<td style="padding-top: 15px;">
						<input value="2" title="As Of" type="radio" id="asOfRB" name="dateParamRG" style="margin: 2px 5px 4px 15px; float: left;"><label for="asOfRB" style="margin: 2px 0 4px 0" tabindex="109">As Of</label>
					</td>
					<td style="padding-top: 15px;">
						<div id="asOfDateDiv" class="required" style="float: left; border: 1px solid gray; width: 135px; height: 20px;">
							<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="required" maxlength="10" style="border: none; float: left; width: 110px; height: 13px; margin: 0px;" value="" tabindex="110"/>
							<img id="imgAsOfDate" alt="imgAsOfDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtAsOfDate').focus; scwShow($('txtAsOfDate'),this, null);" />
						</div>
					</td>
				</tr>
			</table>
		</div>
					
		
		<!-- <div id="fieldsDiv2" class="sectionDiv" style="width: 360px; height: 145px; margin: 25px 0 1px 1px;">
			<table style="margin: 5px 0 0 15px; float: left;">
				<tr>
					<td>
						<input type="checkbox" id="chkInclNull" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkInclNull" style="margin: 2px 0 4px 3px" tabindex="111">Include Null Zone</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="chkInclEndt" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkInclEndt" style="margin: 2px 0 4px 3px" tabindex="112">Include Endorsement/s beyond the given period</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="chkInclExpired" style="margin: 2px 5px 4px 2px; float: left;" checked="checked"><label for="chkInclExpired" style="margin: 2px 0 4px 3px" tabindex="113">Include Expired Policies</label>
					</td>
				</tr>
				<tr>
					<td style="margin-top: 8px;"><label>Risk Count:</label> </td>
				</tr>
				<tr>
					<td>
						<input value="R" title="Per Risk" type="radio" id="perRiskRB" name="riskRG" style="margin: 2px 5px 4px 50px; float: left;" checked="checked"><label for="perRiskRB" style="margin: 2px 0 4px 0" tabindex="114">Per Risk</label>
					</td>
				</tr>
				<tr>
					<td>
						<input value="P" title="Per Policy" type="radio" id="perPolicyRB" name="riskRG" style="margin: 2px 5px 4px 50px; float: left;"><label for="perPolicyRB" style="margin: 2px 0 4px 0" tabindex="115">Per Policy</label>
					</td>
				</tr>
			</table>
		</div>--> <!-- moved div to the last part : edgar 02/24/2015 -->
		
		<div style="float:right; width: 360px; margin: 0px 21px 0px 0px;">
			<div id="fieldsDiv3" class="sectionDiv" style="width: 360px; height: 80px; margin: 25px 0px 1px 0px;"> <!-- modified margin : edgar 02/24/2015 -->
				<table style="margin: 5px 0 0 15px; float: left;">
					<tr>
						<td>
							<input value="1" title="Fire Statistics" type="radio" id="fireStatRB" name="repTypeRG" style="margin: 2px 5px 4px 0px; float: left;" checked="checked"><label for="fireStatRB" style="margin: 2px 0 4px 3px" tabindex="116">Fire Statistics</label>
						</td>
					</tr>
					<tr>
						<td>
							<input value="2" title="Per Policy" type="radio" id="commitAccumRB" name="repTypeRG" style="margin: 2px 5px 4px 0px; float: left;"><label for="commitAccumRB" style="margin: 2px 0 4px 3px" tabindex="117">Commitment and Accumulation Summary</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkPolicyCnt" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkPolicyCnt" style="margin: 2px 0 4px 3px" tabindex="118">Policy Count</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="fieldsDiv4" class="sectionDiv" style="width: 360px; height: 60px; margin: 1px 0px 0px 0px;">
				<table style="margin: 5px 0 0 15px; float: left;">
					<tr>
						<td>
							<input type="checkbox" id="chkByZone" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkByZone" style="margin: 2px 0 4px 3px" tabindex="119">by ZONE</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkByTariff" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkByTariff" style="margin: 2px 0 4px 3px" tabindex="120">by TARIFF (PIRA/IC)</label>
						</td>
					</tr>
				</table>
			</div>
			
			<div id="fieldsDiv6" class="sectionDiv" style="width: 360px; height: 80px; margin: 1px 0px 0px 0px;">
				<table style="margin: 5px 0 0 15px; float: left;">
					<tr>
						<td>
							<input type="checkbox" id="chkBasic" name="chkRG" value="B" style="margin: 2px 5px 4px 2px; float: left;" ><label for="chkBasic" style="margin: 2px 0 4px 3px" tabindex="101">Basic Peril/s Only</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkAllied" name="chkRG" value="A" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkAllied" style="margin: 2px 0 4px 3px" tabindex="102">Allied Peril/s Only</label>
						</td>
					</tr>
					<tr>
						<td>
							<input type="checkbox" id="chkBoth" name="chkRG" value="AB" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkBoth" style="margin: 2px 0 4px 3px" tabindex="103">Both peril types (Basic + Allied Perils)</label>
						</td>
					</tr>
				</table>
			</div>	<!-- added edgar 03/20/2015 -->	
			
			<div id="fieldsDiv5" class="sectionDiv" style="width: 360px; height: 75px; margin: 1px 0px 0px 0px;">
				<table style="margin: 5px 0 0 15px; float: left;">
					<tr>
						<td>
							<input value="1" title="Direct Business Only" type="radio" id="directRB" name="businessRG" style="margin: 2px 5px 2px 0px; float: left;" checked="checked"><label for="directRB" style="margin: 2px 0 2px 3px" tabindex="121">Direct Business Only</label>
						</td>
					</tr>
					<tr>
						<td>
							<input value="2" title="Assumed Business Only" type="radio" id="riRB" name="businessRG" style="margin: 2px 5px 2px 0px; float: left;"><label for="riRB" style="margin: 2px 0 2px 3px" tabindex="122">Assumed Business Only</label>
						</td>
					</tr>
					<tr>
						<td>
							<input value="3" title="Direct and Assumed Business" type="radio" id="directRiRB" name="businessRG" style="margin: 2px 5px 2px 0px; float: left;"><label for="directRiRB" style="margin: 2px 0 2px 3px" tabindex="123">Direct and Assumed Business</label><!-- changed value to 3 : edgar 03/30/2015 -->
						</td>
					</tr>
				</table>
			</div>
		
		</div>
		
		<div class="sectionDiv" id="printDialogFormDiv" style="margin: 1px 0 0 25px; width: 510px; height: 214px; float: left;" align="center"><!-- changed height to 214px from 175px :edgar 03/20/2015 -->
			<table style="float: left; padding: 22px 0 0 95px;"><!-- changed padding to 22px from 12px :edgar 03/20/2015 -->
				<tr>
					<td class="rightAligned">Destination</td>
					<td class="leftAligned">
						<select id="selDestination" style="width: 200px;" tabindex="124">
							<option value="screen">Screen</option>
							<option value="printer">Printer</option>
							<option value="file">File</option>
							<option value="local">Local Printer</option>
						</select>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="125">PDF</label>
						<!-- <input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0" tabindex="126">Excel</label> -->
						<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0" tabindex="126">CSV</label>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Printer</td>
					<td class="leftAligned">
						<select id="selPrinter" style="width: 200px;" class="required" tabindex="127">
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
						<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="128">
						<div style="float: left; width: 15px;">
							<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
							<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
							<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
							<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
						</div>					
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Paper Size</td>
					<td class="leftAligned">
						<select id="selPaperSize" style="width: 200px;" tabindex="129">
							<option value="bond">Letter 8 1/2 x 11</option>
							<option value="a3">A3 11 x 14 7/8</option>
							<option value="void"></option> <!-- added edgar 04/08/2015  -->
						</select>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<input type="checkbox" id="chkSummarized" checked="checked" style="margin: 5px 5px 14px 5px; float: left;"><label for="chkSummarized" style="margin: 5px 0 14px 3px" tabindex="130">Summarized</label>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- moved div here : edgar 02/24/2015 -->
		<div id="fieldsDiv2" class="sectionDiv" style="width: 360px; height: 140px; margin: 1px 0px 0px 2px;">
			<table style="margin: 5px 0 0 15px; float: left;">
				<tr>
					<td>
						<input type="checkbox" id="chkInclNull" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkInclNull" style="margin: 2px 0 4px 3px" tabindex="111">Include Null Zone</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="chkInclEndt" style="margin: 2px 5px 4px 2px; float: left;"><label for="chkInclEndt" style="margin: 2px 0 4px 3px" tabindex="112">Include Endorsement/s beyond the given period</label>
					</td>
				</tr>
				<tr>
					<td>
						<input type="checkbox" id="chkInclExpired" style="margin: 2px 5px 4px 2px; float: left;" checked="checked"><label for="chkInclExpired" style="margin: 2px 0 4px 3px" tabindex="113">Include Expired Policies</label>
					</td>
				</tr>
				<tr>
					<td style="margin-top: 8px;"><label>Risk Count:</label> </td>
				</tr>
				<tr>
					<td>
						<p style="float:left; width: 100%;padding: 0;margin: 0 0 2px 0;"><input value="R" title="Per Risk" type="radio" id="perRiskRB" name="riskRG" style="margin: 2px 5px 4px 50px; float: left;" checked="checked"><label for="perRiskRB" style="margin: 2px 0 4px 0" tabindex="114">Per Risk</label></p>
						<p style="float:left; width: 100%;padding: 0;margin: 0;"><input value="P" title="Per Policy" type="radio" id="perPolicyRB" name="riskRG" style="margin: 2px 5px 4px 50px; float: left;"><label for="perPolicyRB" style="margin: 2px 0 4px 0" tabindex="115">Per Policy/Item</label></p><!-- edgar 04/27/2015 FULL WEB SR 4322 -->
					</td>
				</tr>
				<!-- <tr>
					<td>
						<input value="P" title="Per Policy" type="radio" id="perPolicyRB" name="riskRG" style="margin: 2px 5px 4px 50px; float: left;"><label for="perPolicyRB" style="margin: 2px 0 4px 0" tabindex="115">Per Policy</label>
					</td>
				</tr>-->
			</table>
		</div>
		
		<div class="buttonsDiv">			
			<input id="btnExtract" type="button" class="button" value="Extract Statistical Data" style="width: 150px;" tabindex="129">
			<input id="btnViewDetails" type="button" class="button" value="View Details" style="width: 120px;" tabindex="130">
			<input id="btnPrint" type="button" class="button" value="Print" style="width: 120px;" tabindex="131">
		</div>
	</div>
</div>

<script type="text/javascript">
try{
	initializeAll();
	makeInputFieldUpperCase();
	$("asOfDateDiv").removeClassName("required");
	$("txtAsOfDate").removeClassName("required");
	$("txtAsOfDate").readOnly = true;
	disableDate("imgAsOfDate"); //edgar 03/31/2015
	$("txtZone").focus(); 
	
	var dateParam = "1";
	var repType = "1";
	var fireStat = "";
	var businessRB = "1";
	var riskCnt = "R";
	var inclEndt = "N";
	var inclExp = "Y";
	var inclNull = "N";
	var dspZone = "";
	var pZone = "---";
	//var inclNull = "FALSE"; //commented out edgar 03/12/2015 : variable already existing and has the same purpose
	var pDate = "ED";
	var zoneTariff = "";
	var perilExt = "";
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("pdfRB").disabled = true;
			//$("excelRB").disabled = true; //edgar 03/20/2015
			$("csvRB").disabled = true;
			$("selPaperSize").disabled = false;
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
			$("selPaperSize").disabled = false; //edgar 03/30/2015
			if(dest == "file"){
				$("pdfRB").disabled = false;
				//$("excelRB").disabled = false;//edgar 03/20/2015
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				//$("excelRB").disabled = true;//edgar 03/20/2015
				$("csvRB").disabled = true;
			}		
		}
	}
	
	function showZoneTypeLOV(){
		var searchString = $F("txtZone") == "" ? '%' : escapeHTML2($F("txtZone").trim());
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGIPIS901ZoneTypeLOV2",
				page : 1
			},
			title : "Zone Types",
			width : 480,
			height : 386,
			columnModel : [ 
			 {
				id : "rvMeaning",
				title : "Zone Description",  // jhing 03.21.2015 changed from "Rv Meaning" to "Zone Description" 
				width : '345px'
			},{
				id : "rvLowValue",
				title : "Zone Level",                  // jhing 03.21.2015 changed from "" to "Zone Level" 
				width : '120px',
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			findText: searchString,
			onSelect : function(row) {
				if(row != null || row != undefined){
					$("hidZoneType").value = unescapeHTML2(row.rvLowValue);
					$("txtZone").value = unescapeHTML2(row.rvMeaning);
					//added edgar 03/23/2015
					if ($("hidZoneType").value == 4){
						$("chkByTariff").checked = true;
						$("selPaperSize").value = "void"; //edgar 04/08/2015
						$("selPaperSize").disabled = true; //edgar 04/08/2015
						$("chkByZone").checked = false;
						$("chkByZone").disabled = true;
						fireStat = "by_tariff";
					}else{
						$("chkByZone").disabled = false;
					}
					//ended edgar 03/23/2015
				}
			},
			onCancel: function(){
				$("txtZone").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtZone");
			} 
		});
	}
	
	function showPerilFireDialog(){
		objGIPIS901.chkboxStat = [];
		$$("input[type='checkbox']").each(function(cb){
			var id = cb.id;
			var stat = cb.checked;
			objGIPIS901.chkboxStat.push({chkboxId: id,
										 stat:	   stat});
		});	
		
		overlayPerilFireDialog = Overlay.show(contextPath+"/GIPIGenerateStatisticalReportsController", {
			urlContent : true,
			urlParameters: {action : "showFirePerilDialog"},
		    title: "Peril",
		    height: 200,
		    width: 340,
		    draggable: true
		});
	}
	
	function extractRecords(){
		new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
			parameters: {
				action:			"extractFireStat",
				fireStat:		fireStat,
				dateRb:			dateParam,
				pDate:			pDate,
				dateFrom:		$F("txtFromDate"),
				dateTo:			$F("txtToDate"),
				asOfDate:		$F("txtAsOfDate"),
				busCd:			businessRB,
				zone:			pZone,
				zoneType:		$F("hidZoneType"),
				riskCnt:		riskCnt,
				inclEndt:		inclEndt,
				inclExp:		inclExp,
				perilType:		objGIPIS901.firePerilType
			},
			onCreate: showNotice("Extracting records, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					zoneTariff = fireStat;
					perilExt = objGIPIS901.firePerilType;
					
					if (response.responseText > 0){
						showMessageBox("Extraction successfully completed. " + response.responseText + " records processed.", "I");
					}else{
						showMessageBox("Extraction successfully completed. No data found.", "I");
					}
				}
			}
		});
	}
	
	function checkPrevFieldsValues(){
		var noneChanged = true;
		
		if($("chkInclNull").checked){
			pZone = "ALL";
			inclNull = "Y";
		}else{
			pZone = "---";
			inclNull = "N";
		}  
		new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
			parameters: {
				action:			"checkFireStat",
				fireStat:		fireStat,
				dateRb:			dateParam,
				pDate:			pDate,
				dateFrom:		$F("txtFromDate"),
				dateTo:			$F("txtToDate"),
				asOfDate:		$F("txtAsOfDate"),
				busCd:			businessRB,
				zone:			pZone,
				zoneType:		$F("hidZoneType"),
				riskCnt:		riskCnt,
				inclEndt:		inclEndt,
				inclExp:		inclExp,
				perilType:		objGIPIS901.firePerilType
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: showNotice("Checking records, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					if (response.responseText > 0){
						noneChanged = true;
					}else{
						noneChanged = false;
						showMessageBox("No Data Found. Please extract data first.", "I");
					}
				}
			}
		});
		/*if (zoneTariff != fireStat){
			showMessageBox("Please extract data first.", "I");
			noneChanged = false;
		}		
		
		if(objGIPIS901.extractPrevParam[0] == undefined){
			showMessageBox("Please extract data first.", "I");
			noneChanged = false;
		}else{
			if (objGIPIS901.extractPrevParam[0].riskCnt != riskCnt){
				showMessageBox("Type of risk count has been changed.  Please extract data first.", "I");
				noneChanged = false;
			}		
			if (perilExt != objGIPIS901.firePerilType){
				showMessageBox("Peril type has been changed.  Please extract data first.", "I");
				noneChanged = false;
			}
			if (objGIPIS901.extractPrevParam[0].inclEndt != inclEndt){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			if (objGIPIS901.extractPrevParam[0].inclExp != inclExp){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			if (objGIPIS901.extractPrevParam[0].zoneType != $F("hidZoneType")){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			if (objGIPIS901.extractPrevParam[0].dateParam != dateParam){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			if (objGIPIS901.extractPrevParam[0].busCd != businessRB){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			if (dateParam == 1){
				if (objGIPIS901.extractPrevParam[0].pDate != pDate){
					showMessageBox("Please extract data first.", "I");
					noneChanged = false;
				}
				if (objGIPIS901.extractPrevParam[0].dateFrom != $F("txtFromDate")){
					showMessageBox("Please extract data first.", "I");
					noneChanged = false;
				}
				if (objGIPIS901.extractPrevParam[0].dateTo != $F("txtToDate")){
					showMessageBox("Please extract data first.", "I");
					noneChanged = false;
				}
			}else{
				if (objGIPIS901.extractPrevParam[0].asOfDate != $F("txtAsOfDate") || $F("txtAsOfDate") == "" ){
					showMessageBox("Please extract data first.", "I");
					noneChanged = false;
				}
			}		
			if (objGIPIS901.extractPrevParam[0].inclNull != inclNull){
				showMessageBox("Please extract data first.", "I");
				noneChanged = false;
			}
			
		}*///commented out edgar : 03/20/2015 replaced with checking codes below
		
		return noneChanged;
	}
	
	function showDetailsDialog(action, title){
		overlayDetailsDialog = Overlay.show(contextPath+"/GIPIGenerateStatisticalReportsController", {
			urlContent : true,
			urlParameters: {
				action : 	action,
				asOfSw:		objGIPIS901.asOfSw,
				lineCdFi:	objGIPIS901.lineCdFi,
				zoneType :  $F("hidZoneType") // jhing 03.19.2015
			},
		    title: title,
		    height: action == "getFireCommAccumMaster" ? 535 : 510, //modified edgar 04/15/2015
		    width: action == "getFireCommAccumMaster" ? 1100 : 870,
		    draggable: true
		});
	}
	
	function prepareReportParams(progUnit){
		try{
			if (dateParam == "2"){
				objGIPIS901.asOfSw = "Y";
			}else{
				objGIPIS901.asOfSw = "N";
			}
			
			var reportId = "";
			var reportTitle = "";
			var content = contextPath+"/UWPrintStatisticalReportsController?action=printReportsFireStatTab"+"&noOfCopies="
			  			  +$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination");
			
			if (progUnit == "printZone" || progUnit == "printZoneEd"){
				if (repType == 1){
					if ($F("selPaperSize") == "bond"){
						reportId = "GIPIR037";
						reportTitle = "FIRE STATISTICAL REPORT";
					}else if ($F("selPaperSize") == "a3"){
						reportId = "GIPIR037A";
						reportTitle = "FIRE STATISTICAL REPORT";
					}
				}else if(repType == 2){
					if ($("chkPolicyCnt").checked){
						reportId = "GIPIR039B";
						reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY (POLICY COUNT)";
					}else{
						reportId = "GIPIR039A";
						reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY-TOTAL AS A WHOLE";
					}
				}
				var table = null;
				var column = null;
				if ($F("txtZone") == 'EARTHQUAKE') { //added by steven 06.19.2014
					table = 'giis_eqzone';
					column = 'eq_zone';
				} else if($F("txtZone") == 'TYPHOON') {
					table = 'giis_typhoon_zone';
					column = 'typhoon_zone';
				}else{
					table = 'giis_flood_zone';
					column = 'flood_zone';
				}
				
				content = content+"&reportId="+reportId+"&inclExp="+inclExp+"&pDate="+pDate+"&zoneType="+$F("hidZoneType")+"&trtyTypeCd="+
						  "&dateParam="+dateParam+ "&tableName="+table+"&columnName="+column+"&asOfDate="+$F("txtAsOfDate")+"&dateFrom="+$F("txtFromDate")+
						  "&dateTo="+$F("txtToDate")+"&zone="+$F("txtZone")+"&busCd="+businessRB+"&asOfSw="+objGIPIS901.asOfSw+"&expiredAsOf="+
						  $F("txtAsOfDate")+"&periodStart="+$F("txtFromDate")+"&periodEnd="+$F("txtToDate")+"&inclEndt="+inclEndt+"&riskCnt="+riskCnt; //added riskCnt : edgar 03/13/2015
				
			}else if (progUnit == "printTariff" || progUnit == "printTariffEd"){
				reportId = "GIPIR038C";
				if ($F("txtZone").match(/FLOOD/g) || $F("txtZone").match(/TYPHOON/g)){
					//reportId = "GIPIR038A"; //edgar 04/10/2015
					reportTitle = "FLOOD/TYPHOON STATISTICAL REPORT";
				}else if ($F("txtZone").match(/FIRE/g)){
					//reportId = "GIPIR038B";//edgar 04/10/2015
					reportTitle = "FIRE STATISTICAL REPORT";
				}else if ($F("txtZone").match(/EARTHQUAKE/g)){
					//reportId = "GIPIR038C";//edgar 04/10/2015
					reportTitle = "EARTHQUAKE STATISTICAL REPORT";
				}
				
				content = content+"&reportId="+reportId+"&asOfSw="+objGIPIS901.asOfSw+"&asOfDate="+$F("txtAsOfDate")+"&dateFrom="+
						  $F("txtFromDate")+"&dateTo="+$F("txtToDate")+"&zoneType="+$F("hidZoneType")+"&riskCnt="+riskCnt; //added riskCnt : edgar 03/13/2015
				
				if (fireStat = "by_tariff"){
					content = content + "&dir="+"DIRECT";
				}
				if (reportId == "GIPIR038C"){
					content = content + "&zoneTypeA=5&zoneTypeB=6&zoneTypeC=7&zoneTypeD=8";
				}
				
				/* printZone
				select count(*) from gixx_firestat_summary
			  	WHERE AS_OF_SW = 'N' AND DATE_FROM = :fire_stat.p_starting_date AND DATE_TO = :fire_stat.p_ending_date; 
				
				printZoneEd
				select count(*) from gixx_firestat_summary
			  	WHERE AS_OF_SW = 'Y' AND AS_OF_DATE = :fire_stat.p_as_of_date;
				*/
				
			}else if(progUnit == "printSummary"){
				reportId = "GIPIR039D";
				reportTitle = "COMMITMENT AND ACCUMULATION SUMMARY-summarized";
				var table = null;
				var column = null;
				if ($F("txtZone") == 'EARTHQUAKE') { //added by steven 06.19.2014
					table = 'giis_eqzone';
					column = 'eq_zone';
				} else if($F("txtZone") == 'TYPHOON') {
					table = 'giis_typhoon_zone';
					column = 'typhoon_zone';
				}else{
					table = 'giis_flood_zone';
					column = 'flood_zone';
				}
				
				content = content+"&reportId="+reportId+"&inclExp="+inclExp+"&zoneType="+$F("hidZoneType")+"&dateParam="+dateParam+"&tableName="+table
						 +"&columnName="+column+"&asOfDate="+$F("txtAsOfDate")+"&dateFrom="+$F("txtFromDate")+"&dateTo="+$F("txtToDate")+"&asOfSw="+
						 objGIPIS901.asOfSw+"&byCount="+riskCnt+"&inclEndt="+inclEndt+"&dateType="+pDate;
			}
			
			
			printReport(content, reportTitle);
			
		}catch(e){
			showErrorMessage("prepareReportParams", e);
		}
	}
	
	
	function printReport(content, reportTitle){
		try{
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				//added by clperello | 06.10.2014
				 var fileType = "PDF";
			
				/*if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV"; *///commented out repllaced with codes below : edgar 03/20/2015
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("csvRB").checked)
					fileType = "CSV";
				//end here clperello | 06.10.2014
				
					new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType}, //$("pdfRB").checked ? "PDF" : "XLS"}, commented out by clperello
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								if (checkErrorOnResponse(response)){
									if (fileType == "CSV"){ //added by clperello | 06.10.2014
										copyFileToLocalFireStat(response, "csv"); //edgar 04/10/2015
										deleteCSVFileFromServer(response.responseText);
									} else 
										copyFileToLocalFireStat(response); //edgar 04/10/2015
								}
							}
						}
					});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}	
		}catch(e){
			showErrorMessage("printReport", e);
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
		togglePaperSize(); //edgar 04/13/2015
	});	
	
	
	$$("input[name='dateParamRG']").each(function(rb){
		rb.observe("click", function(){
			dateParam = rb.value;
			
			if (rb.value == 1){	//by date
				$("fromDateDiv").addClassName("required");
				$("toDateDiv").addClassName("required");
				$("txtFromDate").addClassName("required");
				$("txtToDate").addClassName("required");
				$("txtFromDate").readOnly = false;
				$("txtToDate").readOnly = false;
				enableDate("imgFromDate");
				enableDate("imgToDate");
				$("acctEntDateRB").disabled = false;
				$("effDateRB").disabled = false;
				$("issueDateRB").disabled = false;
				$("bookingDateRB").disabled = false;
				$("asOfDateDiv").removeClassName("required");
				$("txtAsOfDate").removeClassName("required");
				$("txtAsOfDate").readOnly = true;
				$("txtAsOfDate").value = null;//edgar 03/26/2015
				disableDate("imgAsOfDate");
				$("txtFromDate").focus();
			}else if(rb.value == 2){	// as of
				$("fromDateDiv").removeClassName("required");
				$("toDateDiv").removeClassName("required");
				$("txtFromDate").removeClassName("required");
				$("txtToDate").removeClassName("required");
				$("txtFromDate").readOnly = true;
				$("txtToDate").readOnly = true;
				$("txtFromDate").value = null;//edgar 03/26/2015
				$("txtToDate").value = null;//edgar 03/26/2015
				disableDate("imgFromDate");
				disableDate("imgToDate");
				$("acctEntDateRB").disabled = true;
				$("effDateRB").disabled = true;
				$("issueDateRB").disabled = true;
				$("bookingDateRB").disabled = true;
				$("asOfDateDiv").addClassName("required");
				$("txtAsOfDate").addClassName("required");
				$("txtAsOfDate").readOnly = true;
				enableDate("imgAsOfDate");
				$("txtAsOfDate").focus();				
			}
		});
	});
	
	$$("input[name='paramDateRG']").each(function(rb){
		rb.observe("click", function(){
			pDate = rb.value;
		});
	});
	
	$$("input[name='repTypeRG']").each(function(rb){
		rb.observe("click", function(){
			repType = rb.value;
			
			if (rb.value == 1){	 //fire statistics
				$("chkByTariff").disabled = false;
				$("selPaperSize").disabled = false;
				$("chkSummarized").checked = false;
				$("chkSummarized").disabled = true;
				$("chkPolicyCnt").checked = false;
				$("chkPolicyCnt").disabled = true;
				// added edgar 04/08/2015
				$("selPaperSize").value = "bond"; 
				if ($("hidZoneType").value == 4){
					$("chkByTariff").checked = true;
					$("selPaperSize").value = "void";
					$("selPaperSize").disabled = true;
					$("chkByZone").checked = false;
					$("chkByZone").disabled = true;
				}
				// ended edgar 04/08/2015
			}else if (rb.value == 2){	 //commitment and accumulation summary
				$("chkByTariff").disabled = true;
				$("chkByTariff").checked = false;
				$("chkByZone").checked = true;
				fireStat = "by_zone";
				$("selPaperSize").disabled = true;
				$("selPaperSize").value = "void"; //edgar 04/08/2015
				$("chkSummarized").checked = true;
				$("chkSummarized").disabled = false;
				$("chkPolicyCnt").checked = false;
				$("chkPolicyCnt").disabled = false;
			}
		});
	});
	
	$("chkInclEndt").observe("click", function(){
		if (this.checked){
			inclEndt = "Y";
		}else{
			inclEndt = "N";
		}
	});
	
	$("chkInclExpired").observe("click", function(){
		if (this.checked){
			inclExp = "Y";
		}else{
			inclExp = "N";
		}
	});
	
	$("chkInclNull").observe("click", function(){
		if (this.checked){
			inclNull = "Y";
		}else{
			inclNull = "N";
		}
	});
	
	$("chkByZone").observe("click", function(){
		if ($F("hidZoneType") == "4"){
			if ($("chkByZone").checked){
				$("chkByZone").checked = false;
				$("chkByTariff").checked = true;
				fireStat = "by_tariff";
				
				return false;
			}
		}
		
		if ($("chkByZone").checked){
			$("chkByTariff").checked = false;
			fireStat = "by_zone";
			$("selPaperSize").disabled = false;
		}else if ($("chkByZone").checked == false){
			$("chkByTariff").checked = false;
			fireStat = "by_tariff";
			$("chkByZone").checked = true;
			$("selPaperSize").disabled = true;
		}
		
		if($("chkByZone").checked){
			fireStat = "by_zone";
			//showPerilFireDialog(); //commented out edgar 03/20/2015
			$("selPaperSize").value = "bond"; //edgar 04/08/2015
			$("selPaperSize").disabled = false; //edgar 04/08/2015
		}
	});
	
	$("chkByTariff").observe("click", function(){
		if ($("chkByTariff").checked){
			$("chkByZone").checked = false;
			fireStat = "by_tariff";
			$("fireStatRB").checked = true;
			repType = "1";
		}else if ($("chkByTariff").checked == false){
			$("chkByZone").checked = false;
			fireStat = "by_zone";
			$("chkByTariff").checked = true;
		}
		
		if($("chkByTariff").checked){
			fireStat = "by_tariff";
			//showPerilFireDialog(); //commented out by edgar 03/20/2015
			$("selPaperSize").value = "void"; //edgar 04/08/2015
			$("selPaperSize").disabled = true; //edgar 04/08/2015
		}
	});
	
	$$("input[name='businessRG']").each(function(rb){
		rb.observe("click", function(){
			businessRG = rb.value;
			businessRB = rb.value;//edgar 03/30/2015
		});
	});
	
	$$("input[name='riskRG']").each(function(rb){
		rb.observe("click", function(){
			riskCnt = rb.value;
		});
	});
	
	$("searchZone").observe("click", showZoneTypeLOV);

	$("txtZone").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGIPIS901ZoneTypeLOV2",findText,"Searching Zone Type, please wait...");
			
			if(cond == 0){
				$("hidZoneType").clear();
				this.clear();
				//showMessageBox("Invalid value for Zone", imgMessage.INFO);
				showZoneTypeLOV();
			}else if(cond == 2){
				showCoverageLOV();
			}else{
				$("hidZoneType").value = unescapeHTML2(cond.rows[0].rvLowValue);
				this.value = unescapeHTML2(cond.rows[0].rvMeaning);
				if ($F("hidZoneType") == 4){
					$("chkByTariff").checked = true;
					$("selPaperSize").value = "void"; //edgar 04/08/2015
					$("selPaperSize").disabled = true; //edgar 04/08/2015
					$("chkByZone").checked = false;
					fireStat = "by_tariff";
				}else{
					fireStat = "by_zone";
				}
			}
		}else{
			$("hidZoneType").clear();
		}
	});
	
	$("txtFromDate").observe("blur", function(){
		checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
	});
	
	$("txtToDate").observe("blur", function(){
		checkInputDates("txtToDate", "txtFromDate", "txtToDate");
	});
	
	$("btnExtract").observe("click", function(){
		if ($("chkByZone").checked == false && $("chkByTariff").checked == false){
			showMessageBox("Please select type of statistical report (by ZONE or by TARIFF)", "I");
			return false;
		}else if($("chkBasic").checked == false && $("chkAllied").checked == false && $("chkBoth").checked == false){
			showMessageBox("Please select the type of peril.", "I");
			return false;
		}

		objGIPIS901.extractPrevParam = [];
		objGIPIS901.extractPrevParam.push({fireStat: 	fireStat,
										   busCd:	 	businessRB,
										   zoneType:	$F("hidZoneType"),
										   zone:		$F("txtZone"),
										   dateParam:	dateParam,
										   pDate:		pDate,
										   asOfDate:	$F("txtAsOfDate"),
										   dateFrom:	$F("txtFromDate"),
										   dateTo:		$F("txtToDate"),
										   inclEndt:	inclEndt,
										   inclExp:		inclExp,
										   inclNull:	inclNull,
										   riskCnt:		riskCnt,
										   perilType:	objGIPIS901.firePerilType});
		
		if($("chkInclNull").checked){
			pZone = "ALL";
			inclNull = /*"TRUE"*/"Y"; //edgar 03/12/2015
		}else{
			pZone = "---";
			inclNull = /*"FALSE"*/"N"; //edgar 03/12/2015
		}
		
		//if ($F("hidZoneType") == "4" && repType == "2"){
		//	showMessageBox("Extraction for this report is not allowed in FIRE peril.", "I");
		//	return false;
		//} //commented out edgar 04/08/2015 transferred below
		
		if (checkAllRequiredFieldsInDiv("fieldsDiv1")){//modified edgar 04/08/2015
			if ($F("hidZoneType") == "4" && repType == "2"){
				showMessageBox("Extraction for this report is not allowed in FIRE peril.", "I");
				return false;
			}else{
				if( !validateBeforeExtract("E") ){ //added validation : //edgar 04/27/2015 FULL WEB SR 4322
					return false;
				}else{
					extractRecords();
				}
			}
		}		
	});
	
	$("btnViewDetails").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("fieldsDiv1") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){//edgar 04/08/2015	
			if ($F("hidZoneType") == "4" && repType == "2"){
				showMessageBox("Viewing the details of this type of report is not allowed for FIRE Peril.", "I");
				return false;
			}else{
				if (checkPrevFieldsValues()){
					//modified and added if for validation : edgar 04/27/2015 FULL WEB SR 4322
						if (!validateBeforeExtract("V")){
							return false;
						}else{
							if (dateParam == "2"){
								objGIPIS901.asOfSw = "Y";
							}else{
								objGIPIS901.asOfSw = "N";
							}
				
							objGIPIS901.zone = $F("txtZone");
							//added edgar 03/20/2015
							objGIPIS901.extractPrevParam = [];
							objGIPIS901.extractPrevParam.push({fireStat: 	fireStat,
															   busCd:	 	businessRB,
															   zoneType:	$F("hidZoneType"),
															   zone:		$F("txtZone"),
															   dateParam:	dateParam,
															   pDate:		pDate,
															   asOfDate:	$F("txtAsOfDate"),
															   dateFrom:	$F("txtFromDate"),
															   dateTo:		$F("txtToDate"),
															   inclEndt:	inclEndt,
															   inclExp:		inclExp,
															   inclNull:	inclNull,
															   riskCnt:		riskCnt,
															   perilType:	objGIPIS901.firePerilType});
							//ended edgar 03/20/2015
							if (repType == 1){
								if (fireStat == "by_zone"){
									showDetailsDialog("getFireZoneMaster", "Firestat Zone");
								}else{
									showDetailsDialog("getFireTariffMaster", "Firestat Tariff Detail");
								}
							}else if(repType == 2){
								showDetailsDialog("getFireCommAccumMaster", "Commitment and Accumulation Summary");
							}
						}
					//end of modification for validation : edgar 04/27/2015 FULL WEB SR 4322
				}
			}
		}
	});
	
	$("btnPrint").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("fieldsDiv1") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){//edgar 04/08/2015
			if ($F("hidZoneType") == "4" && repType == "2"){
				showMessageBox("Printing for this report is not allowed for FIRE Peril.", "I");
				return false;
			}else{
				if (checkPrevFieldsValues()){
					//modified and added if for validation : edgar 04/27/2015 FULL WEB SR 4322
						if (!validateBeforeExtract("P")){
							return false;
						}else{
							if (checkAllRequiredFieldsInDiv("fieldsDiv1") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){
								if (dateParam == 1){	//from to
									new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
										parameters:{
											action:		"countFireStatExt",
											fireStat:	fireStat
										},
										asynchronous: false,
										evalScripts: true,
										onComplete: function(response){
											if (checkErrorOnResponse(response)){
												if ((fireStat == "by_zone" || repType == '2') && $("chkSummarized").checked == false){
													prepareReportParams("printZone");
												}else if(fireStat == "by_tariff"){
													prepareReportParams("printTariff");
												}else if ((fireStat == "by_zone" || repType == '2') && $("chkSummarized").checked){
													prepareReportParams("printSummary");
												}
											}
										}
									});
								}else if(dateParam == 2){	//as of
									if ((fireStat == "by_zone" || repType == '2') && $("chkSummarized").checked == false){
										prepareReportParams("printZoneEd");
									}else if(fireStat == "by_tariff"){
										prepareReportParams("printTariffEd");
									}else if ((fireStat == "by_zone" || repType == '2') && $("chkSummarized").checked){
										prepareReportParams("printSummary");
									}
								}
							}	
						}
					//end of modification for validation : edgar 04/27/2015 FULL WEB SR 4322
				}
			}
		}
	});
	//added edgar 02/24/2015
	if ($("fireStatRB").checked == true){
		$("chkSummarized").checked = false;
		$("chkSummarized").disabled = true;
		$("chkPolicyCnt").checked = false;
		$("chkPolicyCnt").disabled = true;
	}
	
	$("chkBasic").observe("click", function(){
		if($("chkBasic").checked){
			objGIPIS901.firePerilType = "B";
			$("chkAllied").checked = false;
			$("chkBoth").checked = false;
		}else if($("chkBasic").checked == false){
			$("chkBasic").checked = true;
		}
	});
	
	$("chkAllied").observe("click", function(){
		if($("chkAllied").checked){
			objGIPIS901.firePerilType = "A";
			$("chkBasic").checked = false;
			$("chkBoth").checked = false;
		}else if($("chkAllied").checked == false){
			$("chkAllied").checked = true;
		}
	});
	
	$("chkBoth").observe("click", function(){
		if($("chkBoth").checked){
			objGIPIS901.firePerilType = "AB";
			$("chkBasic").checked = false;
			$("chkAllied").checked = false;
		}else if($("chkBoth").checked == false){
			$("chkBoth").checked = true;
		}
	});
	
	function setDefaultValues(){
		$("chkBoth").click();
		$("chkByZone").click();
	}
	
	setDefaultValues();
	
	function copyFileToLocalFireStat(response, subFolder, onOkFunc){ 
		try {
			subFolder = (subFolder == null || subFolder == "" ? "reports" : subFolder);
			if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
				showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
			} else {
				var message = $("geniisysAppletUtil").copyFileToLocal(response.responseText, subFolder);
				if(message.include("SUCCESS")){
					showWaitingMessageBox("Report file generated to " + message.substring(9), "I", function(){
						if(onOkFunc != null)
							onOkFunc();
					});
				} else {
					showMessageBox(message, "E");
				}			
			}
			new Ajax.Request(contextPath + "/GIISController", {
				parameters : {
					action : "deletePrintedReport",
					url : response.responseText
				}
			});
		} catch(e){
			showErrorMessage("copyFileToLocalFireStat", e);
		}
	}
	
	function togglePaperSize(){
		if ($("fireStatRB").checked && $("chkByZone").checked){
			$("selPaperSize").value = "bond";
			$("selPaperSize").disabled = false;
		}else{
			$("selPaperSize").value = "void";
			$("selPaperSize").disabled = true;
		}
	}
	
	function validateBeforeExtract(param){ //edgar 04/27/2015 FULL WEB SR 4322
		var noneChanged = true;
		try {
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:			"validateBeforeExtract",
					fireStat:		param,
					dateRb:			dateParam,
					pDate:			pDate,
					dateFrom:		$F("txtFromDate"),
					dateTo:			$F("txtToDate"),
					asOfDate:		$F("txtAsOfDate"),
					busCd:			businessRB,
					zone:			pZone,
					zoneType:		$F("hidZoneType"),
					riskCnt:		riskCnt,
					inclEndt:		inclEndt,
					inclExp:		inclExp,
					perilType:		objGIPIS901.firePerilType
				},
				asynchronous: false,
				evalScripts: true,
				onCreate: showNotice("Checking records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var res = JSON.parse(response.responseText);
						if (res.msgAlert != "SUCCESS"){
							noneChanged = false;
							//customShowMessageBox(res.message, imgMessage.INFO, "btnExtract");
						}else{
							noneChanged = true;
							//showMessageBox("No Data Found. Please extract data first.", "I");
						}
					}else{
						noneChanged = false;
					}
				}
			});	
			
			return noneChanged;
		}catch (e) {
			showErrorMessage("validateBeforeExtract", e);
		}	
	}
	//ended edgar 02/24/2015
	
	toggleRequiredFields("screen");
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>

