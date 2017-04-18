<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<!-- hidden divs needed for View Policy information -->
<div id="claimInfoDiv" style="display: none;"></div>
<div id="claimViewPolicyInformationDiv" style="display:none;"> </div>

<div id="printPLAFLAMainDiv" name="printPLAFLAMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
   			<label>Print PLA/FLA</label>
   			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	
	<div id="moduleDiv" name="moduleDiv" class="sectionDiv" style="margin: 0 0 20px 0;">
			<div id="lineCdDiv" name="lineCdDiv" style="height:40px; margin: 20px 0 0 230px;">
				<label id="lblLine" for="txtLineCd" style="margin:4px 4px 2px 2px; ">Line</label>
				<span class="lovSpan" style="width: 76px; margin-right: 2px;">
					<input type="text" id="txtLineCd" name="txtLineCd" lastValidValue="" style="width: 50px; float: left; border: none; height: 14px; margin: 0;" class="upper required" maxlength="2" tabindex="101"/>  
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLineCd" name="osLineCd" alt="Go" style="float: right;" tabindex="102"/>
				</span>
				<input type="text" id="txtLineName" name="txtLineName" style="width: 400px;  margin: 0 0 0 5px; float: left; height: 14px;" readonly="readonly" maxlength="20" tabindex="103" />				
			</div> <!-- end: lineCdDiv -->
		
		
			<div id="mainTabsMenu" name="subMenuDiv" align="center" style="width: 100%; margin-bottom: 0px; float: left;">
				<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
					<ul>
						<li class="tab1 selectedTab1"><a id="tabUnprintedPLA">List of Unprinted PLAs</a></li>
						<li class="tab1"><a id="tabUnprintedFLA">List of Unprinted FLAs</a></li>
					</ul>
				</div>
				<div class="tabBorderBottom1"></div>		
			</div> <!-- end: mainTabsMenu -->
			
			<div id="tgMainDiv" name="tgMainDiv" style="float: left; height: 325px; margin: 20px 20px 0 20px;">
				<div id="printPLATableGrid" name="printPLATableGrid" style="height: 290px; width: 880px;">					
				</div> <!-- end: printPLATableGrid -->
				
				<div id="printFLATableGrid" name="printFLATableGrid" style="height: 290px; width: 880px;">					
				</div> <!-- end: printFLATableGrid -->
			</div> <!-- end: tgMainDiv -->
			
			<div id="claimInfoSubDiv" name="claimInfoSubDiv" class="sectionDiv" style="margin: 0 20px 5px 20px; width: 880px;">
				<table border="0 style="width:860px; margin: 5px 5px 5px 10px;">
					<tr>
						<td class="rightAligned" style="width:120px;">Claim No</td>
						<td style="width:360px;"><input type="text" id="txtClaimNo" name="txtClaimNo" style="margin-left:5px; width:330px;" readonly="readonly" tabindex="201" /></td>
						<td class="rightAligned" style="width:120px;">Processor</td>
						<td style="width:240px;"><input type="text" id="txtInHouAdj" name="txtInHouAdj" style="margin-left:5px; width:220px;" readonly="readonly" tabindex="202" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:120px;">Policy No</td>
						<td style="width:360px;"><input type="text" id="txtPolicyNo" name="txtPolicyNo" style="margin-left:5px; width:330px;" readonly="readonly" tabindex="203" /></td>
						<td class="rightAligned" style="width:120px;">Status</td>
						<td style="width:240px;"><input type="text" id="txtStatus" name="txtStatus" style="margin-left:5px; width:220px;" readonly="readonly" tabindex="204" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:120px;">Assured Name</td>
						<td colspan="3" style="width:740px;"><input type="text" id="txtAssuredName" name="txtAssuredName" style="margin-left:5px; width:717px;" readonly="readonly" tabindex="205" /></td>
					</tr>
				</table>
			</div> <!-- end: claimInfoSubDiv -->
			
			<!-- this div is shown when PLA tab is selected and hidden when FLA tab is selected -->
			<div id="plaItemSubDiv" name="plaItemSubDiv" class="sectionDiv" style="margin: 0 20px 5px 20px; width: 880px;">
				<table border="0" style="width:860px; margin: 5px 5px 5px 10px;">
					<tr>
						<td class="rightAligned" style="width:110px;">Item</td>
						<td>
							<input type="text" id="txtItemNo" name="txtItemNo" style="margin-left:5px; width:70px; text-align: right;" readonly="readonly" tabindex="301" />
							<input type="text" id="txtItemTitle" name="txtItemTitle" style="width:180px;" readonly="readonly" tabindex="302" />
						</td>
						<td class="rightAligned" style="width:150px;">Treaty</td>
						<td style="width:240px;"><input type="text" id="txtTreaty" name="txtTreaty" style="margin-left:5px; width:220px;" readonly="readonly" tabindex="303" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Peril</td>
						<td>
							<input type="text" id="txtPerilCd" name="txtPerilCd" style="margin-left:5px; width:70px; text-align: right;" readonly="readonly" tabindex="304" />
							<input type="text" id="txtPerilName" name="txtPerilName" style="width:180px;" readonly="readonly" tabindex="305" />
						</td>
						<td class="rightAligned" style="width:150px;">Share %</td>
						<td style="width:240px;"><input type="text" id="txtSharePct" name="txtSharePct" style="margin-left:5px; width:220px; text-align: right;" readonly="readonly" tabindex="306" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Loss Reserve</td>
						<td><input type="text" id="txtLossReserve" name="txtLossReserve" style="margin-left:5px; width:262px; text-align: right;" readonly="readonly" tabindex="307" /></td>
						<td class="rightAligned" style="width:150px;">Share Loss Reserve</td>
						<td style="width:240px;"><input type="text" id="txtShareLossReserve" name="txtShareLossReserve" style="margin-left:5px; width:220px; text-align: right;" readonly="readonly" tabindex="308" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Expense Reserve</td>
						<td><input type="text" id="txtExpenseReserve" name="txtExpenseReserve" style="margin-left:5px; width:262px; text-align: right;" readonly="readonly" tabindex="309" /></td>
						<td class="rightAligned" style="width:150px;">Share Expense Reserve</td>
						<td style="width:240px;"><input type="text" id="txtShareExpenseReserve" name="txtShareExpenseReserve" style="margin-left:5px; width:220px; text-align: right;" readonly="readonly" tabindex="310" /></td>
					</tr>
				</table>
			</div> <!-- end: plaItemSubDiv -->
			
			<!-- this div is shown when FLA tab is selected and hidden when PLA tab is selected -->
			<div id="flaItemSubDiv" name="flaItemSubDiv" class="sectionDiv" style="margin: 0 20px 5px 20px; width: 880px;">			
				<table border="0" style="width:860px; margin: 5px 5px 5px 10px;">
					<tr>
						<td class="rightAligned" style="width:110px;">Advice Number</td>
						<td><input type="text" id="txtAdviceNo" name="txtAdviceNo" style="margin-left:5px; width:262px;" readonly="readonly" tabindex="401" /></td>
						<td class="rightAligned" style="width:150px;">Share Name</td>
						<td style="width:240px;"><input type="text" id="txtShareName" name="txtShareName" style="margin-left:5px; width:220px;" readonly="readonly" tabindex="402" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Net Amount</td>
						<td><input type="text" id="txtNetAmount" name="txtNetAmount" style="margin-left:5px; width:262px; text-align: right;" readonly="readonly" tabindex="403" /></td>
						<td class="rightAligned" style="width:150px;">Paid Share Amount</td>
						<td style="width:240px;"><input type="text" id="txtPaidShareAmt" name="txtPaidShareAmt" style="margin-left:5px; text-align: right; width:220px;" readonly="readonly" tabindex="404" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Paid Amount</td>
						<td><input type="text" id="txtPaidAmount" name="txtPaidAmount" style="margin-left:5px; width:262px; text-align: right;" readonly="readonly" tabindex="405" /></td>
						<td class="rightAligned" style="width:150px;">Net Share Amount</td>
						<td style="width:240px;"><input type="text" id="txtNetShareAmt" name="txtNetShareAmt" style="margin-left:5px; width:220px; text-align: right;" readonly="readonly" tabindex="406" /></td>
					</tr>
					<tr>
						<td class="rightAligned" style="width:110px;">Advice Amount</td>
						<td><input type="text" id="txtAdviceAmount" name="txtAdviceAmount" style="margin-left:5px; width:262px; text-align: right;" readonly="readonly" tabindex="407" /></td>
						<td class="rightAligned" style="width:150px;">Advice Share Amount</td>
						<td style="width:240px;"><input type="text" id="txtAdviceShareAmt" name="txtAdviceShareAmt" style="margin-left:5px; width:220px; text-align: right;" readonly="readonly" tabindex="408" /></td>
					</tr>
				</table>
			</div> <!-- end: flaItemSubDiv -->
			
			<!-- lossAdviceInfoDiv --> 
			<div id="plaInfoDiv" name="plaInfoDiv" class="sectionDiv" changeTagAttr="true" style="margin: 0 20px 5px 20px; width: 880px;">
				<table border="0" style="width:860px; margin: 5px 25px 5px 80px;">
					<tr>
						<td id="lblPlaTitle" class="rightAligned">PLA Title</td>
						<td><!-- <input type="text" id="txtLATitle" name="txtLATitle" style="margin-left:5px; width:600px;" tabindex="501" /> -->
							<textarea id="txtPlaTitle" name="txtPlaTitle" maxlength="150" style="height: 15px; resize: none; margin-left:5px; width: 600px;" tabindex="501"  ></textarea>
						</td>
					</tr>
					<tr>
						<td id="lblPlaHeader" class="rightAligned">PLA Header</td>
						<td><!-- <input type="text" id="txtLAHeader" name="txtLAHeader" style="margin-left:5px; width:600px;" tabindex="502" /> -->
							<textarea id="txtPlaHeader" name="txtPlaHeader" maxlength="150" style="height: 15px; margin-left:5px; width:600px; resize: none;" tabindex="502"></textarea>
						</td>
					</tr>
					<tr>
						<td id="lblPlaFooter" class="rightAligned">PLA Footer</td>
						<td><!-- <input type="text" id="txtLAFooter" name="txtLAFooter" style="margin-left:5px; width:600px;" tabindex="503" /> -->
							<textarea id="txtPlaFooter" name="txtPlaFooter" maxlength="2000" style="height: 15px; margin-left:5px; width:600px; resize: none;" tabindex="503"></textarea>
						</td>
					</tr>
				</table>		
			</div> <!-- end: plaInfoDiv -->
			
			<div id="flaInfoDiv" name="flaInfoDiv" class="sectionDiv" changeTagAttr="true" style="margin: 0 20px 5px 20px; width: 880px;">
				<table border="0" style="width:860px; margin: 5px 25px 5px 80px;">
					<tr>
						<td id="lblFlaTitle" class="rightAligned">FLA Title</td>
						<td>
							<textarea id="txtFlaTitle" name="txtFlaTitle" maxlength="500" style="height: 15px; resize: none; margin-left:5px; width: 600px;" tabindex="601"  ></textarea>
						</td>
					</tr>
					<tr>
						<td id="lblFlaHeader" class="rightAligned">FLA Header</td>
						<td><!-- <input type="text" id="txtLAHeader" name="txtLAHeader" style="margin-left:5px; width:600px;" tabindex="502" /> -->
							<textarea id="txtFlaHeader" name="txtFlaHeader" maxlength="500" style="height: 15px; margin-left:5px; width:600px; resize: none;" tabindex="602"></textarea>
						</td>
					</tr>
					<tr>
						<td id="lblFlaFooter" class="rightAligned">FLA Footer</td>
						<td><!-- <input type="text" id="txtLAFooter" name="txtLAFooter" style="margin-left:5px; width:600px;" tabindex="503" /> -->
							<textarea id="txtFlaFooter" name="txtFlaFooter" maxlength="2000" style="height: 15px; margin-left:5px; width:600px; resize: none;" tabindex="603"></textarea>
						</td>
					</tr>
				</table>		
			</div> <!-- end: flaInfoDiv -->
			
			<div id="btnDiv" name="btnDiv" class="buttonsDiv" style="float:left; margin:15px 0 20px 0;">
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width:120px;" tabindex="601"  />
			</div>
		
	</div> <!-- end: moduleDiv -->
	
</div>

<script type="text/javascript">
	
	var userParams = new Object();
	
	var currentView = "P"; 	// variables.curr_view
	var checkBoxCnt = 0;	// variables.chkbx_cnt  - number of checkboxes checked in PLA table
	var checkBoxCnt2 = 0;	// variables.chkbx_cnt2 - number of checkboxes checked in FLA table
	
	var a070 = new Object(); 
	a070.plaCnt	= null;		//a070.pla_cnt
	a070.plaCntAll = null;	//a070.pla_cnt_all
	a070.flaCnt = null;		//a070.fla_cnt
	a070.flaCntAll = null;	//a070.fla_cnt_all
	a070.lineCd = null; 	//a070.line_cd
	a070.lineName = null;
	
	var viewReport = new Object();
	viewReport.genRg = null; //view_report.gen_rg
	viewReport.userId = null; //variables.userId  
	viewReport.printPrsd = "N"; //variables.print_prsd ==> changes to Y when Print button is pressed
	
	var onLOV = false;
	var isQueryExecuted = false; 
	
	var selectedPlaRow = "";
	var selectedFlaRow = "";
	
	var lastSelectedPlaRow = null;
	var lastSelectedFlaRow = null;
	
	var rowsToPrintPla = [];	// for holding records if PLA is selected via checkbox
	var rowsToPrintFla = [];	// for holding records if FLA is selected via checkbox
	
	changeTag = 0;
	
	try {
		userParams = JSON.parse('${userParams}');
		
		var objPLAArray = [];
		var objPLA = new Object();
		objPLA.objPLAListTableGrid = JSON.parse('${plaList}');
		objPLA.objPLAList = objPLA.objPLAListTableGrid.rows || [];
		
		initializePLATG();
		initializeFLATG();
		
		if(currentView == "P"){
			$("printFLATableGrid").hide();
			$("printPLATableGrid").show();
			
		} else if(currentView == "F"){
			$("printPLATableGrid").hide();
			$("printFLATableGrid").show();
		}
		
	} catch(e){
		showErrorMessage("PLA Table Grid", e);
	}
	
	function initializeDefaultValues(){
		/* for printing: if all_user_sw = 'Y' but no records to print,
  		 ** allow access but not printing of PLA/FLA,
  		 ** only list of unprinted PLAs/FLAs may be printed. */
		if(userParams.allUserSw == "Y"){
			//SET_BLOCK_PROPERTY('c016', DEFAULT_WHERE, 'in_hou_adj = in_hou_adj');
		    //SET_BLOCK_PROPERTY('c028', DEFAULT_WHERE, 'in_hou_adj = in_hou_adj');
		} else {
			//SET_BLOCK_PROPERTY('c016', DEFAULT_WHERE, 'in_hou_adj = user');
		    //SET_BLOCK_PROPERTY('c028', DEFAULT_WHERE, 'in_hou_adj = user');
		}
		
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarPrint");
		enableSearch("osLineCd");
		enableInputField("txtLineCd");
		disableButton("btnPrint");
		$("txtLineCd").focus();
		$("flaItemSubDiv").hide();
		$("flaInfoDiv").hide();
		$("plaItemSubDiv").show();
		$("plaInfoDiv").show();		
	}
	
	function initializePLATG(){
		try {
			var objPLATableModel = {
					url : contextPath + "/GICLPrintPLAFLAController?action=showPrintPLAFLAPage&refresh=1"
							+ "&allUserSw=" + encodeURIComponent(userParams.allUserSw)
							+ "&validTag=" + encodeURIComponent(userParams.validTag)
							+ "&lineCd=" + ($F("txtLineCd"))
							+ "&currentView=" + ((currentView == "PP" || currentView == "P") ? "P" : ((currentView == "F" || currentView == "FF") ? "F" : ""))
							+ "&moduleId=GICLS050",
					options : {
						title :'',
						width : '882px',
						hideColumnChildTitle: true,
						validateChangesOnPrePager : false,
						onCellFocus: function(element, value, x, y, id){
							var mtgId = plaListTableGrid._mtgId;
							
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								selectedPlaRow = plaListTableGrid.geniisysRows[y];
								
								// to display the modified Title/Header/Footer if there's any.
								var isExisting = false;
								for (var x=0; x<rowsToPrintPla.length; x++){
									if(rowsToPrintPla[x].plaId == selectedPlaRow.plaId){
										populateInfo(rowsToPrintPla[x]);
										isExisting = true;
										break;
									}
								}
								
								if(!isExisting){
									populateInfo(selectedPlaRow);
								}
								lastSelectedPlaRow = selectedPlaRow;
							}						
						},
						onRemoveRowFocus: function(){
							plaListTableGrid.keys.releaseKeys();
							selectedPlaRow = null;
							populateInfo(null);
			            },
			            beforeSort: function(){
			            	if(changeTag != 0){
			            		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
			            				function(){
			            					prePrint();
			            					return false;
			            				},
			            				function(){
			            					refreshAll();
			            					return true;},
			            				"");
			            	} else {
			            		return true;
			            	}
			            },
			            prePager: function(){
			            	lastSelectedPlaRow = null;
			            	plaListTableGrid.onRemoveRowFocus();
							return true;
			            }
					},
					columnModel : [
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
									    id: 'claimId',
									    width: '0',
										visible: false
									},								
									{
									    id: 'plaId',
									    width: '0',
										visible: false
									},
									{
										id: 'printChkbx',
									    title: '',
										width: '40',
										align: 'center',
										editable: true,
										sortable: false,
									    defaultValue: false,
										otherValue: false,
									    editor: new MyTableGrid.CellCheckbox({
									    	 getValueOf: function(value){
								            		if (value){
														return "Y";
								            		} else {
														return "N";	
								            		}	
								            	},
								            onClick: function(value, checked) {
								            	var newValue = checked;
								            	if(userParams.validTag == "Y"){
								            		if(value == "N"){
								            			checkBoxCnt--;
								            			removeRowToPrint(selectedPlaRow);
								            		} else if(value == "Y"){
								            			checkBoxCnt++;
								            			insertRowToPrint(selectedPlaRow);
								            		}
								            	} else {
								            		if(selectedPlaRow.inHouAdj != userParams.userId){
								            			newValue = false;
								            			showMessageBox("User is not allowed to print this PLA. However, you may print the list of Unprinted PLAs.", "I");
								            		} else {
								            			if(value == "N"){
									            			checkBoxCnt--;
									            			removeRowToPrint(selectedPlaRow);
									            		} else if(value == "Y"){
									            			checkBoxCnt++;
									            			insertRowToPrint(selectedPlaRow);
									            		}
								            		}
								            	}
								            	tagSelectedRow(newValue, plaListTableGrid._mtgId, plaListTableGrid.getColumnIndex("printChkbx"), selectedPlaRow.divCtrId);
								            }
									    })
									},
									{
										id: 'lineCd laYy plaSeqNo',
										title: 'PLA Number',
										//width: '190',
										sortable: true,
										children: [
												{
													id: 'lineCd',
													title: 'Line Cd',
													width: '40'
												},	
												{
													id: 'laYy',
													title: 'La Yy',
													width: '40',
													align: 'right'
												},
												{
													id: 'plaSeqNo',
													title: 'PLA Sequence No',
													width: '100',
													align: 'right',
													renderer: function(value){
														return formatNumberDigits(value, 10);
													}
												}
										]
									},
									{
										id: 'riCd dspRiName',
										title: 'Reinsurer',
										//width: '260'
										sortable: true,
										children: [
											{
												id: 'riCd',
												width: '60',
												align: 'right',
												//sortable: true,
												geniisysClass: 'integerNoNegativeUnformattedNoComma'
											},
											{
												id: 'dspRiName',
												width: '200'/* ,
												sortable: true */
											}
										]
									},
									{
										id: 'lossShrAmt',
										title: 'Loss Share Amount',
										width: '190',
										align: 'right',
										titleAlign: 'right',
										geniisysClass: 'money'
									},
									{
									    id: 'expShrAmt',
									    title: 'Expense Share Amount',
									    width: '190',
										align: 'right',
										titleAlign: 'right',
										geniisysClass: 'money'
									}
						],
					resetChangeTag : true,
					rows : objPLA.objPLAListTableGrid.rows //objPLA.objPLAList
			};
			plaListTableGrid = new MyTableGrid(objPLATableModel);
			plaListTableGrid.pager = objPLA.objPLAList; //objPLA.objPLAListTableGrid;
			plaListTableGrid.render('printPLATableGrid');
			plaListTableGrid.afterRender = function(){
				objPLA.objPLAList = plaListTableGrid.geniisysRows; //objPLA.objPLAListTableGrid.rows;
				var myRows = rowsToPrintPla;
				var isToPrint = false;
				
				for(var i=0; i<myRows.length; i++){
					for(var j=0; j<objPLA.objPLAList.length; j++){
						if(currentView == "P" && myRows[i].plaId == objPLA.objPLAList[j].plaId && myRows[i].grpSeqNo == objPLA.objPLAList[j].grpSeqNo){
							$('mtgInput' + plaListTableGrid._mtgId + '_' + plaListTableGrid.getColumnIndex("printChkbx") + ',' + j).checked = true;
							
							if(lastSelectedPlaRow != null && myRows[i].plaId == lastSelectedPlaRow.plaId){
								isToPrint = true;
								populateInfo(myRows[i]);
								plaListTableGrid.selectRow(lastSelectedPlaRow.divCtrId);
							}
						}
					}
				}
				
				populateInfo(lastSelectedPlaRow);
				if(!isToPrint && lastSelectedPlaRow != null && currentView == "P"){
					plaListTableGrid.selectRow(lastSelectedPlaRow.divCtrId);
				}				
			};
		} catch(e){
			showErrorMessage("initializePLATG: ", e);
		}
	}
	
	function refreshAll(){
		if(currentView == "P"){
			rowsToPrintPla = [];
			selectedPlaRow = null;
			checkBoxCnt = 0;
			plaListTableGrid.refresh();
		}  else if(currentView == "F"){
			rowsToPrintFla = [];
			selectedFlaRow = null;
			checkBoxCnt2 = 0;
			flaListTableGrid.refresh();
		}
		populateInfo(null);
		changeTag = 0;
	}
	
	//checks/unchecks checkbox in the tablegrid
	function tagSelectedRow(isTagged, mtgId, x, y){
		$('mtgInput' + mtgId + '_' + x + ',' + y).checked = isTagged;
		//isTagged ? $('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell') : $('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
		if(isTagged){
			$('mtgIC'+ mtgId + '_' + x + ',' + y).addClassName('modifiedCell');
			//insertRowToPrint(selectedPlaRow);
		} else {
			$('mtgIC'+ mtgId + '_' + x + ',' + y).removeClassName('modifiedCell');
			//removeRowToPrint(selectedPlaRow);
		}
	}
	
	// saves the selected rows for printing PLA/FLA
	function insertRowToPrint(row) {
		var myRows = currentView == "P" ? rowsToPrintPla : (currentView == "F" ? rowsToPrintFla : null);
		var exists = false;
		
		for(var i=0; i<myRows.length; i++) {
			if(currentView == "P" && row.plaId == myRows[i].plaId && row.grpSeqNo == myRows[i].grpSeqNo){
				exists = true;
				break;
			} else if(currentView == "F" && row.flaId == myRows[i].flaId && row.grpSeqNo == myRows[i].grpSeqNo){
				exists = true;
				break;
			}
		}
		
		if(!exists) {
			currentView == "P" ? rowsToPrintPla.push(row) : (currentView == "F" ? rowsToPrintFla.push(row) : null);
		}		
	}
	
	// removes the unselected rows for printing PLA/FLA
	function removeRowToPrint(row) {
		var myRows = currentView == "P" ? rowsToPrintPla : (currentView == "F" ? rowsToPrintFla : null);
		for(var i=0; i<myRows.length; i++) {
			if(currentView == "P" && row.plaId == myRows[i].plaId && row.grpSeqNo == myRows[i].grpSeqNo){
				rowsToPrintPla.splice(i,1);
			} else if(currentView == "F" && row.flaId == myRows[i].flaId && row.grpSeqNo == myRows[i].grpSeqNo){
				rowsToPrintFla.splice(i,1);
			}		
		}
	}
	
	function updatePrevSelectedRow(newRow){
		var myRows = currentView == "P" ? rowsToPrintPla : (currentView == "F" ? rowsToPrintFla : null);
		
		for(var i=0; i<myRows.length; i++){
			if(currentView == "P" && newRow.plaId == myRows[i].plaId && newRow.claimId == myRows[i].claimId 
					&& newRow.grpSeqNo == myRows[i].grpSeqNo && newRow.riCd == myRows[i].riCd && newRow.plaSeqNo == myRows[i].plaSeqNo 
					&& newRow.lineCd == myRows[i].lineCd && newRow.laYy == myRows[i].laYy){
				myRows[i].plaTitle 	= escapeHTML2($F("txtPlaTitle")); //newRow.plaTitle;
				myRows[i].plaHeader = escapeHTML2($F("txtPlaHeader")); //newRow.plaHeader;
				myRows[i].plaFooter = escapeHTML2($F("txtPlaFooter")); //newRow.plaFooter;
				
			} else if(currentView == "F" && newRow.flaId == myRows[i].flaId && newRow.claimId == myRows[i].claimId 
					&& newRow.grpSeqNo == myRows[i].grpSeqNo && newRow.riCd == myRows[i].riCd && newRow.flaSeqNo == myRows[i].flaSeqNo 
					&& newRow.lineCd == myRows[i].lineCd && newRow.laYy == myRows[i].laYy){
				myRows[i].flaTitle 	= escapeHTML2($F("txtFlaTitle")); //newRow.flaTitle;
				myRows[i].flaHeader = escapeHTML2($F("txtFlaHeader")); //newRow.flaHeader;
				myRows[i].flaFooter = escapeHTML2($F("txtFlaFooter")); //newRow.flaFooter;
			}
		}
	}
	
	function initializeFLATG(){
		try {
			var objFLATableModel = {
					url : contextPath + "/GICLPrintPLAFLAController?action=showPrintPLAFLAPage&refresh=1"
							+ "&allUserSw=" + encodeURIComponent(userParams.allUserSw)
							+ "&validTag=" + encodeURIComponent(userParams.validTag)
							+ "&lineCd=" + ($F("txtLineCd"))
							+ "&currentView=" + ((currentView == "PP" || currentView == "P") ? "P" : ((currentView == "F" || currentView == "FF") ? "F" : ""))
							+ "&moduleId=GICLS050",
					options : {
						title :'',
						width : '882px',
						hideColumnChildTitle: true,
						validateChangesOnPrePager: false,
						onCellFocus: function(elemet, value, x, y, id){
							var mtgId = flaListTableGrid._mtgId;
							
							if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
								selectedFlaRow = flaListTableGrid.geniisysRows[y];
								
								// to display the modified Title/Header/Footer if there's any.
								var isExisting = false;
								for (var x=0; x<rowsToPrintFla.length; x++){
									if(rowsToPrintFla[x].flaId == selectedFlaRow.flaId){
										populateInfo(rowsToPrintFla[x]);
										isExisting = true;
										break;
									}
								}
								
								if(!isExisting){
									populateInfo(selectedFlaRow);
								}								
								lastSelectedFlaRow = selectedFlaRow;
							}					
						},
						onRemoveRowFocus: function(){
							flaListTableGrid.keys.releaseKeys();
							selectedFlaRow = null;
							populateInfo(null);
			            },
			            beforeSort: function(){
			            	if(changeTag != 0){
			            		showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
			            				function(){
			            					prePrint();
			            					return false;
			            				},
			            				function(){			            					
			            					refreshAll();
			            					return true;},
			            				"");
			            	} else {
			            		return true;
			            	}
			            },
			            prePager: function(){
			            	lastSelectedFlaRow = null;
			            	flaListTableGrid.onRemoveRowFocus();
							return true;
			            }
					},
					columnModel : [
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
									    id: 'claimId',
									    width: '0',
										visible: false
									},								
									{
									    id: 'plaId',
									    width: '0',
										visible: false
									},
									{
										id: 'printChkbx',
									    title: '',
										width: '40',
										align: 'center',
										sortable: false,
									    editable: true,
										defaultValue: false,
										otherValue: false,
									    editor: new MyTableGrid.CellCheckbox({
									    	 getValueOf: function(value){
								            		if (value){
														return "Y";
								            		} else {
														return "N";	
								            		}	
								            	},
								            	onClick: function(value, checked) {
									            	var newValue = checked;
									            	if(userParams.validTag == "Y"){
									            		if(value == "N"){
									            			checkBoxCnt2--;
									            			removeRowToPrint(selectedFlaRow);
									            		} else if(value == "Y"){
									            			checkBoxCnt2++;
									            			insertRowToPrint(selectedFlaRow);
									            		}
									            	} else {
									            		if(selectedFlaRow.inHouAdj != userParams.userId){
									            			newValue = false;
									            			showMessageBox("User is not allowed to print this FLA. However, you may print the list of Unprinted FLAs.", "I");
									            		} else {
									            			if(value == "N"){
										            			checkBoxCnt2--;
										            			removeRowToPrint(selectedFlaRow);
										            		} else if(value == "Y"){
										            			checkBoxCnt2++;
										            			insertRowToPrint(selectedFlaRow);
										            		}
									            		}
									            	}
									            	tagSelectedRow(newValue, flaListTableGrid._mtgId, flaListTableGrid.getColumnIndex("printChkbx"), selectedFlaRow.divCtrId);
									            }
									    })
									},
									{
										id: 'lineCd laYy flaSeqNo',
										title: 'FLA Number',
										//width: '190',
										sortable: true,
										children: [
												{
													id: 'lineCd',
													title: 'Line Cd',
													width: '40'
												},	
												{
													id: 'laYy',
													title: 'La Yy',
													width: '40',
													align: 'right'
												},
												{
													id: 'flaSeqNo',
													title: 'FLA Sequence No',
													width: '100',
													align: 'right',
													renderer: function(value){
														return formatNumberDigits(value, 10);
													}
												}
										]
									},
									{
										id: 'riCd dspRiName',
										title: 'Reinsurer',
										//width: '260'
										sortable: true,
										children: [
											{
												id: 'riCd',
												width: '40',
												align: 'right'
											},
											{
												id: 'dspRiName',
												width: '165'
											}
										]
									},
									{
										id: 'shrPaidAmt',
										title: 'Paid Share Amount',
										width: '145',
										align: 'right',
										titleAlign: 'right',
										geniisysClass: 'money'/* ,
										renderer: function(value){
											return formatCurrency(value);
										} */
									},
									{
									    id: 'shrNetAmt',
									    title: 'Net Share Amount',
									    width: '145',
										align: 'right',
										titleAlign: 'right',
										geniisysClass: 'money'
									},
									{
									    id: 'shrAdviseAmt',
									    title: 'Advice Share Amount',
									    width: '145',
										align: 'right',
										titleAlign: 'right',
										geniisysClass: 'money'
									}
						],
					resetChangeTag : true,
					rows : objPLA.objPLAListTableGrid.rows //objPLA.objPLAList
			};
			flaListTableGrid = new MyTableGrid(objFLATableModel);
			flaListTableGrid.pager = objPLA.objPLAList; //objPLA.objPLAListTableGrid;
			flaListTableGrid.render('printFLATableGrid');
			flaListTableGrid.afterRender = function(){
				objPLA.objPLAList = flaListTableGrid.geniisysRows; //objPLA.objPLAListTableGrid.rows;
				
				var myRows = rowsToPrintFla;
				var isToPrint = false;
				
				for(var i=0; i<myRows.length; i++){
					for(var j=0; j<objPLA.objPLAList.length; j++){
						if(currentView == "F" && myRows[i].flaId == objPLA.objPLAList[j].flaId && myRows[i].grpSeqNo == objPLA.objPLAList[j].grpSeqNo){
							$('mtgInput' + flaListTableGrid._mtgId + '_' + flaListTableGrid.getColumnIndex("printChkbx") + ',' + j).checked = true;
							
							if(lastSelectedFlaRow != null && myRows[i].flaId == lastSelectedFlaRow.flaId){
								isToPrint = true;
								populateInfo(myRows[i]);
								flaListTableGrid.selectRow(lastSelectedFlaRow.divCtrId);
							}
						}
					}
				}
				populateInfo(lastSelectedFlaRow);
				if(!isToPrint && lastSelectedFlaRow != null && currentView == "F"){
					flaListTableGrid.selectRow(lastSelectedFlaRow.divCtrId);
				}
			};
		} catch(e){
			showErrorMessage("initializeFLATG: ", e);
		}
	}
	
	function getGicls051CdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls051CdLOV",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							moduleId: "GICLS050",
							page : 1},
			title: "Valid Values for Line",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "menuLineCd",
								visble: false,
								width: '0'
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
					$("txtLineCd").value = row.lineCd;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);
					a070.lineCd = row.lineCd;
					a070.lineName = unescapeHTML2(row.lineName);
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	function queryCountLossAdvice(){ // executes query_count_ungen procedure
		try {
			new Ajax.Request(contextPath+"/GICLPrintPLAFLAController",{
				parameters: {
					action		: "queryCountLossAdvice",
					allUserSw	: userParams.allUserSw,
					validTag	: userParams.validTag,
					moduleId	: "GICLS050",
					lineCd		: $F("txtLineCd"),
					currentView	: currentView
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var count = JSON.parse(response.responseText);
						if(currentView == "P" || currentView == "PP"){
							a070.plaCnt = count.laCnt;
							a070.plaCntAll = count.laCntAll;
						} else if(currentView == "F"|| currentView == "FF"){
							a070.flaCnt = count.laCnt;
							a070.flaCntAll = count.laCntAll;
						}
						refreshTG($F("txtLineCd"));
					}
				}
			});
		} catch(e){
			showErrorMessage("queryCountLossAdvice",e);
		}
	}
	
	function executeQuery(){
		if(currentView == "P"){
			if(a070.plaCnt == null){
				queryCountLossAdvice();	
			}
			if(a070.plaCnt == 0 && a070.plaCntAll == 0){
				disableButton("btnPrint");
			} else {
				enableButton("btnPrint");
			}
		} else if(currentView == "F"){
			if(a070.flaCnt == null){
				queryCountLossAdvice();	
			}
			if(a070.flaCnt == 0 && a070.flaCntAll == 0){
				disableButton("btnPrint");
			} else {
				enableButton("btnPrint");
			}
		}
	}
	
	function refreshTG(lineCd){
		var url = contextPath + "/GICLPrintPLAFLAController?action=showPrintPLAFLAPage&refresh=1"
		   + "&allUserSw=" + encodeURIComponent(userParams.allUserSw)
		   + "&validTag=" + encodeURIComponent(userParams.validTag)
		   + "&lineCd=" + lineCd //($F("txtLineCd"))
		   + "&currentView=" + currentView
		   + "&moduleId=GICLS050";
		
		if(currentView == "P"){
			$("printFLATableGrid").hide();
			$("printPLATableGrid").show();
			plaListTableGrid.url = url; 		
			plaListTableGrid._refreshList();
			if(plaListTableGrid.geniisysRows.length == 0 && isQueryExecuted){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}			
		} else if(currentView == "F"){
			$("printPLATableGrid").hide();
			$("printFLATableGrid").show();
			flaListTableGrid.url = url; 		
			flaListTableGrid._refreshList();
			if(flaListTableGrid.geniisysRows.length == 0 && isQueryExecuted){
				showMessageBox("Query caused no records to be retrieved. Re-enter.", "I");
			}
		}
	}
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function populateInfo(row){
		$("txtClaimNo").value 		= row != null ? (nvl(row.lineCd, "") +" - " + nvl(row.sublineCd, "") + " - " + nvl(row.issCd, "") + " - " + nvl(formatNumberDigits(row.clmYy,2), "") + " - " + nvl(formatNumberDigits(row.clmSeqNo,7), "")) : "";
		$("txtPolicyNo").value 		= row != null ? (nvl(row.lineCd, "") +" - " + nvl(row.sublineCd, "") + " - " + nvl(row.polIssCd, "") + " - " + nvl(formatNumberDigits(row.issueYy,2), "") + " - " + nvl(formatNumberDigits(row.polSeqNo,7), "") + " - " + nvl(formatNumberDigits(row.renewNo,2), "")) : "";
		$("txtAssuredName").value 	= row != null ? (nvl(unescapeHTML2(row.assuredName), "")) : "";
		$("txtInHouAdj").value		= row != null ? (nvl(unescapeHTML2(row.inHouAdj), "")) : "";
		$("txtStatus").value		= row != null ? (nvl(unescapeHTML2(row.clmStatDesc), "")) : "";
		
		if(currentView == "P"){
			$("txtItemNo").value 				= row != null ? (nvl(row.itemNo, "")) : ""; 
			$("txtItemTitle").value 			= row != null ? (nvl(unescapeHTML2(row.itemTitle), "")) : "";
			$("txtPerilCd").value				= row != null ? (nvl(row.perilCd, "")) : "";
			$("txtPerilName").value				= row != null ? (nvl(unescapeHTML2(row.perilSname), "")) : "";
			$("txtLossReserve").value			= row != null ? (nvl(formatCurrency(row.lossReserve), "")) : "";
			$("txtExpenseReserve").value		= row != null ? (nvl(formatCurrency(row.expenseReserve), "")) : "";
			$("txtTreaty").value				= row != null ? (nvl(unescapeHTML2(row.trtyName), "")) : "";
			$("txtSharePct").value				= row != null ? (nvl(formatCurrency(row.sharePct), "")) : "";
			$("txtShareLossReserve").value		= row != null ? (nvl(formatCurrency(row.shareLossResAmt), "")) : "";
			$("txtShareExpenseReserve").value	= row != null ? (nvl(formatCurrency(row.shareExpResAmt), "")) : "";
			
			$("txtPlaTitle").value		= row != null ? (nvl(unescapeHTML2(row.plaTitle), "")) : "";
			$("txtPlaHeader").value		= row != null ? (nvl(unescapeHTML2(row.plaHeader), "")) : "";
			$("txtPlaFooter").value		= row != null ? (nvl(unescapeHTML2(row.plaFooter), "")) : "";
		} else if(currentView == "F"){
			$("txtAdviceNo").value		= row != null ? (nvl(row.advLineCd, "") + " - " + nvl(row.advIssCd, "") + " - " + nvl(row.adviceYear, "") + " - " + nvl(formatNumberDigits(row.adviceSeqNo,6), "")) : "";
			$("txtNetAmount").value		= row != null ? (nvl(formatCurrency(row.netAmt), "")) : "";
			$("txtPaidAmount").value	= row != null ? (nvl(formatCurrency(row.paidAmt), "")) : "";
			$("txtAdviceAmount").value	= row != null ? (nvl(formatCurrency(row.adviseAmt), "")) : "";
			$("txtShareName").value 	= row != null ? (nvl(row.trtyName, "")) : "";
			$("txtPaidShareAmt").value 	= row != null ? (nvl(formatCurrency(row.shrPaidAmt), "")) : "";
			$("txtNetShareAmt").value	= row != null ? (nvl(formatCurrency(row.shrNetAmt), "")) : "";
			$("txtAdviceShareAmt").value = row != null ? (nvl(formatCurrency(row.shrAdviseAmt), "")) : "";
			
			$("txtFlaTitle").value		= row != null ? (nvl(unescapeHTML2(row.flaTitle), "")) : "";
			$("txtFlaHeader").value		= row != null ? (nvl(unescapeHTML2(row.flaHeader), "")) : "";
			$("txtFlaFooter").value		= row != null ? (nvl(unescapeHTML2(row.flaFooter), "")) : "";
		}
	}
	
	function addRadioButtons(){
		var htmlCode = "<table border='0' style='margin: 12px 10px 10px 10px;'>"
						+ "<tr><td ><input type='checkbox' id='chkUnprintedPLA' name='chkUnprintedPLA' style='float:left; margin: 4px 2px 2px 0;'/><label for='chkUnprintedPLA' id='lblUnprintedPLA' style='float:left; margin:3px 2px 2px 5px;'>Unprinted PLA(s)</label></td>"
						+ "<td><input type='radio' id='rdoCurrentUser' name='rdoUser' style='margin-left:50px;float:left;'/><label for='rdoCurrentUser' id='lblCurrentUser' style='float:left; margin:3px 2px 2px 5px;'>Current User</label></td></tr>"
						+ "<tr><td><input type='checkbox' id='chkListUnprintedPLA' name='chkListUnprintedPLA' style='float:left; margin: 4px 2px 2px 0;'/><label for='chkListUnprintedPLA' id='lblListUnprintedPLA' style='float:left; margin:3px 2px 2px 5px;'>List of Unprinted PLA(s)</label></td>"
						+ "<td><input type='radio' id='rdoAllUsers' name='rdoUser' style='margin-left:50px; float:left;' /><label for='rdoAllUsers' id='lblAllUsers' style='float:left; margin: 3px 2px 2px 5px;'>All Users</label></td></tr>"
						+ "</table>";
		
		$("printDialogFormDiv2").update(htmlCode); 
		$("printDialogFormDiv2").show();
		$("printDialogMainDiv").up("div",1).style.height = "238px";
		$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "270px";
		
		initializeDefaultValuesForPrint();		
	}
	
	function validateReportId(reportId, reportTitle){
		try {
			new Ajax.Request(contextPath+"/GICLGeneratePLAFLAController",{
				parameters: {
					action:		"validateReportId",
					reportId:	reportId
				},
				ashynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						if (response.responseText == "Y"){
							printReport(reportId, reportTitle);
						}else{
							showMessageBox("No existing records found in GIIS_REPORTS.", "E");
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("validateReportId",e);
		}
	}
	
	function printReport(reportId, reportTitle){
		function displayInfoAfterPrint(){
			showMessageBox("Printing complete.", "S");	
		}
		
		try {
			if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
				var fileType = "";
				if($("rdoPdf").disabled == false/*  && $("rdoExcel").disabled == false */){
					//fileType = $("rdoPdf").checked ? "PDF" : "XLS";
					fileType = "PDF"; //please revise when csv is available -andrew
				} 
				var content = contextPath+"/PrintPLAFLAController?action=printReport"
							+ "&noOfCopies=" + $F("txtNoOfCopies")
							+ "&printerName=" + $F("selPrinter")
							+ "&destination=" + $F("selDestination")
							+ "&reportId=" + reportId
							+ "&reportTitle=" + reportTitle
							+ "&fileType=" + fileType
							+ "&moduleId=" + "GICLS050"
							+ "&lineCd=" + $F("txtLineCd")
							+ "&userId=" + userParams.userId
							+ "&allUsers=" + ($("rdoAllUsers").checked ? "Y" : "N" );
							// + ($("rdoAllUsers").checked ? "" : "&userId=" + userParams.userId);

				var nextFunc = $F("selDestination").toUpperCase() == "PRINTER" ? displayInfoAfterPrint : null;
				printGenericReport(content, reportTitle, nextFunc);
				overlayGenericPrintDialog.close();
				refreshAll();
			}
		} catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function checkReport(){
		if(!$("chkUnprintedPLA").checked && !$("chkListUnprintedPLA").checked){
			showMessageBox("There is no report to print.", "I");
			return false;
		}
		
		if(currentView == "P"){
			if($("chkUnprintedPLA").checked){
				if(checkBoxCnt > 0){
					showConfirmBox("Printing", 
								   "Printing to screen will automatically tag all checked PLA(s) as printed and will not be included in the List of Unprinted PLAs.", 
								   "Ok", "Cancel", 
								   tagAsPrinted, 
								   function(){
										//$("chkUnprintedPLA").checked = false;
									    if($("chkListUnprintedPLA").checked){
											validateReportId("GICLR050A", "List of Unprinted PLAs");
										} else {
											overlayGenericPrintDialog.close();
											refreshAll();
										}
					});
				}
			} else if($("chkListUnprintedPLA").checked){
				validateReportId("GICLR050A", "List of Unprinted PLAs");
			}
		} else if(currentView == "F"){
			if($("chkUnprintedPLA").checked){
				if(checkBoxCnt2 > 0){
					showConfirmBox("Printing", 
								   "Printing to screen will automatically tag all checked FLA(s) as printed and will not be included in the List of Unprinted FLAs.", 
								   "Ok", "Cancel", 
								   tagAsPrinted, 
								   function(){
										if($("chkListUnprintedPLA").checked){
											validateReportId("GICLR051A", "List of Unprinted FLAs");
										} else {
											overlayGenericPrintDialog.close();
											refreshAll();
										}
					});
				}
			} else if($("chkListUnprintedPLA").checked){
				validateReportId("GICLR051A", "List of Unprinted FLAs");
			}
		}
	}
	
	// copied this function from pla.jsp; modified some variables to suit this module
	function populateGiclr028XOL(obj){
		try{
			var reports = [];
			for (var a=1; a<=obj.length; a++){
				var content = contextPath + "/PrintPreliminaryLossAdviceController?action=poopulateGiclr028XOL"
							+ "&noOfCopies=" 	+ $F("txtNoOfCopies") + "&printerName=" + $F("selPrinter") + "&destination=" + $F("selDestination")
							+ "&claimId=" 		+ nvl(obj[a-1].claimId,"") 
							+ "&grpSeqNo=" 		+ nvl(obj[a-1].grpSeqNo,"")
							+ "&itemNo=" 		+ nvl(obj[a-1].itemNo, "")
							+ "&perilCd=" 		+ nvl(obj[a-1].perilCd, "")
							+ "&riCd=" 			+ nvl(obj[a-1].riCd,"")
							+ "&currencyCd=" 	+ nvl(obj[a-1].currencyCd,"")
							+ "&plaId="			+ nvl(obj[a-1].plaId,"")
							+ "&tsiAmt=" 		+ nvl(obj[a-1].tsiAmt,"")
							+ "&lineCd="		+ nvl(obj[a-1].lineCd,"")
							+ "&plaNo="			+ nvl(obj[a-1].lineCd,"") + "-" + formatNumberDigits(nvl(obj[a-1].laYy,""),2) + "-" + formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)
							+ "&plaHeader="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaHeader)),"")
							+ "&plaTitle="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaTitle)),"")
							+ "&plaFooter="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaFooter)),"");
						
				reports.push({reportUrl : content, reportTitle : "PLA_XOL-"+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)});
				
				// removed ajax for updating print_sw...
				
				printGenericReport2(content);
				
				if (a == obj.length){
					if ("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
					if($("chkListUnprintedPLA").checked){
						validateReportId("GICLR050A", "List of Unprinted PLAs");	
					}
				}
			} 
			
		}catch(e){
			showErrorMessage("populateGiclr028XOL", e);	
		}	
	}	
	
	// copied this function from pla.jsp; modified some variables to suit this module
	function checkPlaToPrint(obj){
		try{ 
			var reports = [];
			for (var a=1; a<=obj.length; a++){
				
				var content = contextPath + "/PrintPreliminaryLossAdviceController?action=poopulateGiclr028"
							+ "&noOfCopies=" 	+ $F("txtNoOfCopies") + "&printerName=" + $F("selPrinter") + "&destination="+$F("selDestination")
							+ "&claimId=" 		+ nvl(obj[a-1].claimId,"")
							+ "&riCd="			+ nvl(obj[a-1].riCd,"")
							+ "&currencyCd="	+ nvl(obj[a-1].currencyCd,"")
							+ "&lineCd="		+ nvl(obj[a-1].lineCd,"")
							+ "&sublineCd="		+ nvl(obj[a-1].sublineCd,"")
							+ "&issCd="			+ nvl(obj[a-1].issCd,"")
							+ "&issueYy="		+ nvl(obj[a-1].issueYy,"")
							+ "&polSeqNo="		+ nvl(obj[a-1].polSeqNo,"")
							+ "&renewNo="		+ nvl(obj[a-1].renewNo, "")
							+ "&polEffDate="	+ nvl(obj[a-1].strPolicyEffectivityDate2,"")
							+ "&expiryDate="	+ nvl(obj[a-1].strExpiryDate2,"")
							+ "&lossCatCd="		+ nvl(obj[a-1].lossCatCd,"")
							+ "&shareType="		+ nvl(obj[a-1].shareType,"")
							+ "&laYy="			+ nvl(obj[a-1].laYy,"")
							+ "&plaSeqNo="		+ nvl(obj[a-1].plaSeqNo,"")
							+ "&plaId="			+ nvl(obj[a-1].plaId,"")
							+ "&grpSeqNo="		+ nvl(obj[a-1].grpSeqNo,"")
							+ "&resPlaId="		+ nvl(obj[a-1].resPlaId,"")
							+ "&itemNo="		+ nvl(obj[a-1].itemNo,"")
							+ "&perilCd="		+ nvl(obj[a-1].perilCd,"")
							+ "&clmResHistId="	+ nvl(obj[a-1].clmResHistId,"")
							+ "&groupedItemNo="	+ nvl(obj[a-1].groupedItemNo,"")
							+ "&plaNo="			+ nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)
							//+"&plaHeader="+nvl(obj[a-1].plaHeader,"")+"&plaTitle="+nvl(obj[a-1].plaTitle,"")+"&plaFooter="+nvl(obj[a-1].plaFooter,""); bonok :: 11.21.2012
						 	+ "&plaHeader="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaHeader)),"")
						 	+ "&plaTitle="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaTitle)),"")
						 	 +"&plaFooter="		+ nvl(encodeURIComponent(unescapeHTML2(obj[a-1].plaFooter)),"");
											
				reports.push({reportUrl : content, reportTitle : "PLA-"+nvl(obj[a-1].lineCd,"")+"-"+formatNumberDigits(nvl(obj[a-1].laYy,""),2)+"-"+formatNumberDigits(nvl(obj[a-1].plaSeqNo,""),7)});
				
				// removed ajax for updating print_sw... 
				
				printGenericReport2(content);
				
				if (a == obj.length){
					if ("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}					
					if($("chkListUnprintedPLA").checked){
						validateReportId("GICLR050A", "List of Unprinted PLAs");	
					}
				}
			}
			
		}catch(e){
			showErrorMessage("checkPlaToPrint", e);	
		}
	}	
	
	function tagAsPrinted(){
		try {
			var objParams = new Object();
			//objParams.setRows = currentView == "P" ? getModifiedJSONObjects(rowsToPrintPla) : (currentView == "F" ? getModifiedJSONObjects(rowsToPrintFla) : null);  
			objParams.setRows = currentView == "P" ? rowsToPrintPla : (currentView == "F" ? rowsToPrintFla : null);
			var action = currentView == "P" ? "tagPlaAsPrinted" : "tagFlaAsPrinted";
			
			new Ajax.Request(contextPath+"/GICLPrintPLAFLAController?action="+action, {
				method: "POST",
				parameters: {
					parameters		: JSON.stringify(objParams)
				},
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null)){
						
						if(currentView == "P"){
							// generate GICLR028 or GICLR028_XOL [ copied from pla.jsp ] 
							if($("chkUnprintedPLA").checked){
								var xolRows = [];
								var plaRows = [];
								var allPla = rowsToPrintPla;
								
								for (var a1=1; a1<=allPla.length; a1++){
									if (allPla[a1-1].shareType == "4"){
										xolRows.push(allPla[a1-1]);
									}else{
										plaRows.push(allPla[a1-1]);
									}
									if (a1 == allPla.length){
										if (xolRows.length > 0) populateGiclr028XOL(xolRows);
										if (plaRows.length > 0) checkPlaToPrint(plaRows);
									}	
								}
							} else if($("chkListUnprintedPLA").checked){ // generate GICLR050A
								validateReportId("GICLR050A", "List of Unprinted PLAs");	
							}
							
							refreshAll();
							overlayGenericPrintDialog.close();
						} else if(currentView == "F"){
							// generate GICLR033 or GICLR033_XOL  
							if($("chkUnprintedPLA").checked){
								var xolRows = [];
								var flaRows = [];
								var allFla = rowsToPrintFla;
								
								for (var a1=1; a1<=allFla.length; a1++){
									if (allFla[a1-1].shareType == "4"){
										xolRows.push(allFla[a1-1]);
									}else{
										flaRows.push(allFla[a1-1]);
									}
									if (a1 == allFla.length){
										if (xolRows.length > 0) proceedPrintFla(xolRows);
										if (flaRows.length > 0) printXol(flaRows);
									}	
								}
							} else if($("chkListUnprintedPLA").checked){
								validateReportId("GICLR051A", "List of Unprinted FLAs");
							}
							
							refreshAll();
							overlayGenericPrintDialog.close();
						}
						
						$("chkUnprintedPLA").checked = false;
						$("chkUnprintedPLA").disabled = true;						
					} 
				}
			});	
		} catch(e){
			showErrorMessage("tagAsPrinted: ", e);
		}
	}
	
	// copied from fla.jsp; modified some variables to suit this module
	function proceedPrintFla(obj){
		try{
			var reports = [];
			for(var i = 1; i <= obj.length; i++){
				var content = contextPath + "/PrintFinalLossAdviceController?action=printFla"
							+ "&noOfCopies=" 	+ $F("txtNoOfCopies") + "&printerName="+$F("selPrinter") + "&destination="+$F("selDestination")
							+ "&claimId=" 		+ obj[i-1].claimId
							+ "&riCd="			+ obj[i-1].riCd
							+ "&lineCd="		+ obj[i-1].lineCd
							+ "&laYy="			+ obj[i-1].laYy
							+ "&flaId="			+ obj[i-1].flaId //added by: Nica 04.05.2013
							+ "&flaSeqNo="		+ formatNumberDigits(obj[i-1].flaSeqNo,7)
							+ "&adviceId="		+ obj[i-1].adviceId
							+ "&grpSeqNo="		+ obj[i-1].grpSeqNo
							+ "&shareType="		+ obj[i-1].shareType
							+ "&advFlaId="		+ obj[i-1].advFlaId
							+ "&flaTitle="		+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaTitle)), "")
							+ "&flaHeader="		+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaHeader)), "")
							+ "&flaFooter="		+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaFooter)), "")
							+ "&withRecovery=N";
							// + "&withRecovery="+($("netRecovery").checked == true ? "Y": "N");
				
				reports.push({reportUrl : content, reportTitle : "FLA-"+obj[i-1].lineCd+"-"+obj[i-1].laYy+"-"+formatNumberDigits(obj[i-1].flaSeqNo,7)});
				
				printGenericReport2(content);
				
				if (i == obj.length){
					if("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
					if($("chkListUnprintedPLA").checked){
						validateReportId("GICLR051A", "List of Unprinted FLAs");
					}
				}
			}
		}catch(e){
			showErrorMessage("proceedPrintFla", e);
		}
	}
	
	// copied from fla.jsp; modified some variables to suit this module
	function printXol(obj){
		try{
			var reports = [];
			for(var i = 1; i <= obj.length; i++){
				var content = contextPath 	+ "/PrintFinalLossAdviceController?action=printFlaXol"
							+ "&noOfCopies="+ $F("txtNoOfCopies") + "&printerName=" + $F("selPrinter") + "&destination=" + $F("selDestination")
							+ "&claimId=" 	+ nvl(obj[i-1].claimId, "")
							+ "&grpSeqNo="	+ nvl(obj[i-1].grpSeqNo, "")
							+ "&lineCd="	+ nvl(obj[i-1].lineCd, "")
							+ "&laYy="		+ nvl(obj[i-1].laYy, "")
							+ "&flaSeqNo="	+ formatNumberDigits(obj[i-1].flaSeqNo,7)
							+ "&flaId="		+ nvl(obj[i-1].flaId, "")
							+ "&riCd="		+ nvl(obj[i-1].riCd, "")
							+ "&adviceId="	+ nvl(obj[i-1].adviceId, "")
							+ "&flaTitle="	+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaTitle)), "")
							+ "&flaHeader="	+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaHeader)), "")
							+ "&flaFooter="	+ nvl(encodeURIComponent(unescapeHTML2(obj[i-1].flaFooter)), "");
				
				reports.push({reportUrl : content, reportTitle : "FLA-"+obj[i-1].lineCd+"-"+obj[i-1].laYy+"-"+formatNumberDigits(obj[i-1].flaSeqNo,7)});
				
				printGenericReport2(content);
				
				if (i == obj.length){
					if("screen" == $F("selDestination")){
						showMultiPdfReport(reports); 
					}
					if($("chkListUnprintedPLA").checked){
						validateReportId("GICLR051A", "List of Unprinted FLAs");
					}
				}
			}
		}catch(e){
			showErrorMessage("printXol", e);
		}
	}
	
	function initializeDefaultValuesForPrint(){
		if(currentView == "P"){
			
			if(a070.plaCntAll > 0 || a070.plaCnt > 0){
				$("lblUnprintedPLA").innerHMTL = "Unprinted PLAs";
				$("lblListUnprintedPLA").innerHTML = "List of Unprinted PLA(s)";
				
				if(userParams.allUserSw == "N" || userParams.validTag == "N" || a070.plaCntAll == 0){
					$("rdoAllUsers").disabled = true;
				}
				if(a070.plaCnt == 0){
					$("rdoCurrentUser").disabled = true;
				}
				if(checkBoxCnt > 0){
					$("chkUnprintedPLA").checked = true;
				} else {
					$("chkUnprintedPLA").disabled = true;
					$("chkListUnprintedPLA").checked = true;
					
					if(a070.plaCnt > 0){
						$("rdoCurrentUser").checked = true;	//viewReport.genRg = "C";
					} else if(a070.plaCntAll > 0){
						$("rdoAllUsers").checked = true; //viewReport.genRg = "A";
					}
				}
			}
		} else if(currentView == "F"){
			$("lblUnprintedPLA").innerHTML = "Unprinted FLAs";
			$("lblListUnprintedPLA").innerHTML = "List of Unprinted FLA(s)";
			
			if(a070.flaCntAll > 0 || a070.flaCnt > 0){
				$("lblListUnprintedPLA").value = "List of Unprinted FLAs";
				
				if(userParams.allUserSw == "N" || userParams.validTag == "N" || a070.flaCntAll == 0){
					$("rdoAllUsers").disabled = true;
				}
				if(a070.flaCnt == 0){
					$("rdoCurrentUser").disabled = true;
				}
				if(checkBoxCnt2 > 0){
					$("chkUnprintedPLA").checked = true;
				} else {
					$("chkUnprintedPLA").disabled = true;
					$("chkListUnprintedPLA").checked = true;
					
					if(a070.flaCnt > 0){
						$("rdoCurrentUser").checked = true;
					} else if(a070.flaCntAll > 0){
						$("rdoAllUsers").checked = true;
					}
				}
			}
		}
		
		if($("rdoAllUsers").checked){
			viewReport.userId = null;
		} else if($("rdoCurrentUser").checked){
			viewReport.userId = userParams.userId;
		}
		
		// observe for checkbox and radio buttons
		$("chkListUnprintedPLA").observe("click", function(){
			if($("chkListUnprintedPLA").checked){
				if(!$("rdoAllUsers").disabled && !$("rdoCurrentUser").disabled){
					$("rdoCurrentUser").checked = true;
				} else if(!$("rdoAllUsers").disabled && $("rdoCurrentUser").disabled){
					$("rdoAllUsers").checked = true;	
				} else if($("rdoAllUsers").disabled && !$("rdoCurrentUser").disabled){
					$("rdoCurrentUser").checked = true;
				}
			} else {
				$("rdoCurrentUser").checked = false;
				$("rdoAllUsers").checked = false;
			}
		});
		
		$("rdoCurrentUser").observe("click", function(){observeClickForRdo("rdoCurrentUser");});		
		$("rdoAllUsers").observe("click", function(){observeClickForRdo("rdoAllUsers");});
	}
	
	function observeClickForRdo(rdoId){
		if(!$("chkListUnprintedPLA").checked){
			var label = $("lblListUnprintedPLA").innerHTML;
			$(rdoId).checked = false;
			showMessageBox("Please check the "+label+" checkbox first.", "I");
		}
	}
		
	function prePrint(){ // executes pre_print procedure
		var proceedToViewReport = false;
		
		if(currentView == "P"){
			if(a070.plaCntAll == 0 && a070.plaCnt == 0){
				showMessageBox("There are no records to print for " + $F("txtLineName") +".", "I");
			} else {
				proceedToViewReport = true;
			}
		} else {
			if(a070.flaCntAll == 0 && a070.flaCnt == 0){
				showMessageBox("There are no records to print for " + $F("txtLineName") +".", "I");
			} else {
				proceedToViewReport = true;
			}
		}
		
		if(proceedToViewReport){
			showGenericPrintDialog("Print Unprinted PLA/FLA", checkReport, addRadioButtons, true);
		}
	}
	
	function proceedToNextLine(){
		checkBoxCnt = 0;
		checkBoxCnt2 = 0;
		$("btnToolbarEnterQuery").click();
	}
	
	observeReloadForm("reloadForm", function(){
		objGICLS050 = new Object();
		showPrintPLAFLAPage("P", null);
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		isQueryExecuted = true;
		
		disableSearch("osLineCd");
		$("txtLineCd").disabled = true;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		executeQuery();
		enableToolbarButton("btnToolbarPrint");
		enableButton("btnPrint");
	});
	$("btnToolbarEnterQuery").observe("click", function(){
		if(checkBoxCnt != 0){
			showConfirmBox("Confirmation", "You have checked PLAs for printing. Do you wish to print?", "Yes", "Cancel", prePrint, proceedToNextLine, 2);
		} else {
			isQueryExecuted = false;
			lastSelectedPlaRow = null;
			lastSelectedFlaRow = null;
			enableSearch("osLineCd");
			$("txtLineCd").disabled = false;
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineCd").value = "";
			$("txtLineName").value = "";
			a070.plaCnt = null;
			a070.plaCntAll = null;
			a070.flaCnt = null;
			a070.flaCntAll = null;
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
			disableToolbarButton("btnToolbarEnterQuery");
			disableButton("btnPrint");
			refreshTG($F("txtLineCd"));
			populateInfo(null);
		}
	});
	$("btnToolbarExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");	
	});
	$("btnToolbarPrint").observe("click", prePrint);
	$("btnPrint").observe("click", prePrint);
	
	$("osLineCd").observe("click", getGicls051CdLOV);
	$("txtLineCd").observe("keyup", function() {	
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				getGicls051CdLOV();
			}
		}
	});
	
	$("tabUnprintedPLA").observe("click", function(){
		setCurrentTab("tabUnprintedPLA");
		populateInfo(null);
		currentView = "P";
		$("flaItemSubDiv").hide();
		$("flaInfoDiv").hide();
		
		$("plaItemSubDiv").show();
		$("plaInfoDiv").show();
		
		if(a070.plaCnt == null && isQueryExecuted){
			queryCountLossAdvice();
		} else if(isQueryExecuted){
			refreshTG($F("txtLineCd"));
		} else if(!isQueryExecuted){
			refreshTG("");
		}
	});
	
	$("tabUnprintedFLA").observe("click", function(){
		setCurrentTab("tabUnprintedFLA");
		populateInfo(null);
		currentView = "F";
		$("flaItemSubDiv").show();
		$("flaInfoDiv").show();
		
		$("plaItemSubDiv").hide();
		$("plaInfoDiv").hide();
		
		if(a070.flaCnt == null && isQueryExecuted){
			queryCountLossAdvice();
		} else if(isQueryExecuted){
			refreshTG($F("txtLineCd"));
		} else if(!isQueryExecuted){
			refreshTG("");
		}
		if(a070.genFCnt == 0 && a070.genFCntAll == 0){
			disableToolbarButton("btnToolbarPrint");
			disableButton("btnPrint");
		} else if(a070.genFCnt > 0 || a070.genFCntAll > 0){
			enableToolbarButton("btnToolbarPrint");
			enableButton("btnPrint");
		} else if(isQueryExecuted){
			enableToolbarButton("btnToolbarPrint");
			enableButton("btnPrint");
		} else {
			disableToolbarButton("btnToolbarPrint");
			disableButton("btnPrint");
		}
	});
	
	
	function observeChangeTagAttr(){
		var row = currentView == "P" ? selectedPlaRow : selectedFlaRow;
		var isTagged = currentView == "P" ? ($('mtgInput' + plaListTableGrid._mtgId + '_' + plaListTableGrid.getColumnIndex("printChkbx") + ',' + row.divCtrId).checked)
										  : ($('mtgInput' + flaListTableGrid._mtgId + '_' + flaListTableGrid.getColumnIndex("printChkbx") + ',' + row.divCtrId).checked);
		changeTag = 1;
		
		if(isTagged){
			updatePrevSelectedRow(row);
		}
	}
	
	$("txtPlaTitle").observe("change", observeChangeTagAttr);	
	$("txtPlaHeader").observe("change", observeChangeTagAttr);		
	$("txtPlaFooter").observe("change", observeChangeTagAttr);
	$("txtFlaTitle").observe("change", observeChangeTagAttr);	
	$("txtFlaHeader").observe("change", observeChangeTagAttr);		
	$("txtFlaFooter").observe("change", observeChangeTagAttr);
	
	setModuleId("GICLS050");
	setDocumentTitle("Print PLA/FLA");
	initializeAll();	
	makeInputFieldUpperCase();
	initializeDefaultValues();
	
</script>