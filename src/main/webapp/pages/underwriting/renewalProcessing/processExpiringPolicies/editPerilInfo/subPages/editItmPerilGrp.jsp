<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma","no-cache");
%>
<div id="detailsContentsDiv" name="detailsContentsDiv" changeTagAttr="true">
	<div id="b490GrpListingTableGridSectionDiv" style="height: 210px; margin-left: 70px; margin-top: 20px;">
		<div id="b490GrpListingTableGrid"changeTagAttr="true"></div>
	</div>
	<div  style="margin-top: 15px; margin-bottom: 5px;" align="center">
		<table>
			<tr>
				<td class="rightAligned" width="100px">Peril Name</td>
				<td class="leftAligned" width="310px">
					<div style="float: left; border: solid 1px gray; width: 306px; height: 20px;" class="withIconDIv required">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 278px; border: none;" name="txtB490GrpDspPerilName" id="txtB490GrpDspPerilName" class="upper required" readonly="readonly"/>
						<img id="dspPerilNameLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Peril Rate</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490GrpPremRt" name="txtB490GrpPremRt" style="width: 300px;" readonly="readonly" class="moneyRate required"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">TSI Amount</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490GrpTsiAmt" name="txtB490GrpTsiAmt" style="width: 300px;" readonly="readonly" class="money required"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Premium Amount</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490GrpPremAmt" name="txtB490GrpPremAmt" style="width: 300px;" readonly="readonly" class="money required"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">No. Of Days</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490GrpNoOfDays" name="txtB490GrpNoOfDays" style="width: 300px;" readonly="readonly" class="integer"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Base Amount</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490GrpBaseAmt" name="txtB490GrpBaseAmt" style="width: 300px;" readonly="readonly" class="money"/> <!-- Modified by Jerome Bautista 12.04.2015 SR 21016-->
				</td>
			</tr>
		</table>
	</div>
</div>
<div class="buttonsDiv" style="margin-bottom: 20px">
	<input type="button" class="button" id="btnAdd" name="btnAdd" value="Add" style=" width: 80px;"/>
	<input type="button" class="button" id="btnDelete" name="btnDelete" value="Delete" style=" width: 80px;"/>
</div>

<script>
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	disableButton("btnDelete");
	 
	var selectedB490Grp = null;
	var selectedB490GrpRow = new Object();
	objItmPerlGrp.b490GrpListTableGrid = JSON.parse('${b490GrpDtls}'.replace(/\\/g, '\\\\'));
	objItmPerlGrp.b490Grp= objItmPerlGrp.b490GrpListTableGrid.rows || [];

	var nbtPremRt;
	var nbtTsiAmt;
	var nbtPremAmt;
	
	var oldType = null;
	var validateSw = null;
	
	try {
		var b490GrpListingTable = {
			url: contextPath+"/GIEXItmperilController?action=getGIEXS007B490GrpInfo&refresh=1&mode=1&policyId="+$F("txtB240PolicyId")+
					"&itemNo="+$F("txtB480GrpItemNo")+"&groupedItemNo="+$F("txtB480GrpGroupedItemNo"),
			options: {
				width: '780px',
				height: '180px',
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", "", "", "");
						return false;
					} else {
						return true;
					}
				},
				prePager: function(){
					if(changeTag == 1){
						showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", "", "", "");
						return false;
					} else {
						return true;
					}
				},	
				onRefresh: function(){
					setB490GrpInfo(null);
				},
				onCellFocus: function(element, value, x, y, id) {
					mtgId = b490GrpGrid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						selectedB490Grp = y;
						selectedB490GrpRow = b490GrpGrid.geniisysRows[y];
						objItmPerl.b490Row = selectedB490GrpRow;
						setB490GrpInfo(objItmPerlGrp.b490GrpGrid.getRow(y));
						removeItemInfoFocus2();
					}
				},
				onRemoveRowFocus : function(){
					setB490GrpInfo(null);
					removeItemInfoFocus2();
			  	},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN]
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
								id: 'dspPerilName',
								title: 'Peril Name',
								width: '300',
								editable: false,
								filterOption: true
							},
							{
								id: 'premRt',
								title: 'Rate',
								width: '117',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'rate',
								editable: false
							}, 
							{
								id: 'tsiAmt',
								title: 'TSI Amount',
								width: '160',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false
							}, 
							{
								id: 'premAmt',
								title: 'Premium Amount',
								width: '160',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								editable: false
							},
							{	id:			'aggregateSw',
								sortable:	false,
								editable: true,
								align:		'center',
								title:		'&#160;&#160;A',
								titleAlign:	'center',
								width:		'27px',
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
								id: 'perilCd',
								width: '0',
								visible: false
							},
							{	
								id: 'policyId',
								width: '0',
								visible: false
							},
							{	
								id: 'itemNo',
								width: '0',
								visible: false
							},
							{	
								id: 'groupedItemNo',
								width: '0',
								visible: false
							},
							{	
								id: 'lineCd',
								width: '0',
								visible: false
							},
							{	
								id: 'annTsiAmt',
								width: '0',
								visible: false
							},
							{	
								id: 'annPremAmt',
								width: '0',
								visible: false
							},
							{	
								id: 'noOfDays',
								width: '0',
								visible: false
							},
							{	
								id: 'baseAmt',
								width: '0',
								visible: false
							},
							{	
								id: 'dspPerilType',
								width: '0',
								visible: false
							},
							{	
								id: 'dspBascPerlCd',
								width: '0',
								visible: false
							},
							{
								id: 'initialPerilCd',
								width: '0',
								visible: false
							}
						],
			resetChangeTag: true,
			rows: objItmPerlGrp .b490Grp
		};
		b490GrpGrid = new MyTableGrid(b490GrpListingTable);
		objItmPerlGrp.b490GrpGrid = b490GrpGrid;
		b490GrpGrid.pager = objItmPerlGrp.b490GrpListTableGrid;
		b490GrpGrid.render('b490GrpListingTableGrid');
	}catch(e) {
		showErrorMessage("b490GrpGrid", e);
	}
	
	function setB490GrpInfo(obj) {
		try {
			//$("txtB490GrpPerilCd").value							= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('perilCd')],""))); //Commented out and replaced by Jerome Bautista 12.04.2015 SR 21016
			$("txtB490GrpPerilCd").value							= obj == null ? null : obj.perilCd;
			//$("txtB490GrpPremRt").value						= obj == null ? null :unescapeHTML2(String(nvl(formatToNineDecimal(obj[b490GrpGrid.getColumnIndex('premRt')]),""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpPremRt").value 					    = obj == null ? null :formatToNineDecimal(obj.premRt);
			//$("txtB490GrpTsiAmt").value							= obj == null ? null :unescapeHTML2(String(nvl(formatCurrency(obj[b490GrpGrid.getColumnIndex('tsiAmt')]),""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpTsiAmt").value 							= obj == null ? null :formatCurrency(obj.tsiAmt);
			//$("txtB490GrpPremAmt").value					= obj == null ? null :unescapeHTML2(String(nvl(formatCurrency(obj[b490GrpGrid.getColumnIndex('premAmt')]),""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpPremAmt").value					= obj == null ? null :formatCurrency(obj.premAmt);
			$("txtB490GrpPolicyId").value						= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('policyId')],"")));
			$("txtB490GrpItemNo").value						= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('itemNo')],"")));
			$("txtB490GrpGroupedItemNo").value		= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('groupedItemNo')],"")));
			$("txtB490GrpLineCd").value							= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('lineCd')],"")));
			$("txtB490GrpAnnTsiAmt").value					= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('annTsiAmt')],"")));
			$("txtB490GrpAnnPremAmt").value				= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('annPremAmt')],"")));
			$("txtB490GrpAggregateSw").value				= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('aggregateSw')],"")));
			//$("txtB490GrpNoOfDays").value					= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('noOfDays')],""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpNoOfDays").value					= obj == null ? null :unescapeHTML2(obj.noOfDays);
			//$("txtB490GrpBaseAmt").value						= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('baseAmt')],""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpBaseAmt").value					= obj == null ? null :unescapeHTML2(obj.baseAmt);
			//$("txtB490GrpDspPerilName").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('dspPerilName')],""))); //Commented out and replaced by Jerome Bautista 11.27.2015 SR 21016
			$("txtB490GrpDspPerilName").value 			= obj == null ? null :unescapeHTML2(obj.dspPerilName);
			$("txtB490GrpDspPerilType").value				= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('dspPerilType')],"")));
			$("txtB490GrpDspBascPerlCd").value			= obj == null ? null :unescapeHTML2(String(nvl(obj[b490GrpGrid.getColumnIndex('dspBascPerlCd')],"")));
			$("txtInitialPerilCd").value								= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("btnAdd").value 												= obj == null ? "Add" : "Update";
			$("btnAdd").value												!= "Add" ? enableButton("btnDelete") : disableButton("btnDelete");
		} catch(e) {
			showErrorMessage("setB490GrpInfo", e);
		}
	}
	
	function createPerilGrpDtl(obj){
		try {
			var perilGrp 								= (obj == null ? new Object() : obj);			
			perilGrp.recordStatus 			= (obj == null ? 0 : 1);
			perilGrp.perilCd 						= escapeHTML2($F("txtB490GrpPerilCd"));
			perilGrp.premRt 						= escapeHTML2($F("txtB490GrpPremRt"));
			perilGrp.tsiAmt 						= escapeHTML2($F("txtB490GrpTsiAmt"));
			perilGrp.premAmt 					= escapeHTML2($F("txtB490GrpPremAmt"));
			perilGrp.policyId 						= escapeHTML2($F("txtB240PolicyId"));
			perilGrp.itemNo 						= escapeHTML2($F("txtB480GrpItemNo"));
			//perilGrp.groupedItemNo		= escapeHTML2($F("txtB490GrpGroupedItemNo")); //Commented out and replaced by code below - Jerome Bautista 12.03.2015 SR 21016
			perilGrp.groupedItemNo		    = objItmPerl.b480Row.groupedItemNo;
			perilGrp.lineCd 						= escapeHTML2($F("txtB490GrpLineCd"));
			perilGrp.annTsiAmt 				= escapeHTML2($F("txtB490GrpTsiAmt"));
			perilGrp.annPremAmt 			= escapeHTML2($F("txtB490GrpPremAmt"));
			perilGrp.aggregateSw 			= escapeHTML2($F("txtB490GrpAggregateSw"));
			perilGrp.noOfDays 					= escapeHTML2($F("txtB490GrpNoOfDays"));
			perilGrp.baseAmt 					= escapeHTML2($F("txtB490GrpBaseAmt"));
			perilGrp.dspPerilName 			= escapeHTML2($F("txtB490GrpDspPerilName"));
			perilGrp.dspPerilType 			= escapeHTML2($F("txtB490GrpDspPerilType"));
			perilGrp.dspBascPerlCd 			= escapeHTML2($F("txtB490GrpDspBascPerlCd"));
			perilGrp.initialPerilCd 			= escapeHTML2($F("txtInitialPerilCd"));
			return perilGrp;
		} catch (e){
			showErrorMessage("createPerilGrpDtl", e);
		}	
	}
	
	function createPerilGrpDtl2(obj){ //Added by Jerome Bautista 12.04.2015 SR 21016
		try {
			var perilGrp 								= (obj == null ? new Object() : obj);			
			perilGrp.recordStatus 			= (obj == null ? 0 : 1);
			perilGrp.perilCd 						= escapeHTML2($F("txtB490GrpPerilCd"));
			perilGrp.premRt 						= escapeHTML2($F("txtB490GrpPremRt"));
			perilGrp.tsiAmt 						= escapeHTML2($F("txtB490GrpTsiAmt"));
			perilGrp.premAmt 					= escapeHTML2($F("txtB490GrpPremAmt"));
			perilGrp.policyId 						= escapeHTML2($F("txtB240PolicyId"));
			perilGrp.itemNo 						= escapeHTML2($F("txtB480GrpItemNo"));
			//perilGrp.groupedItemNo		= escapeHTML2($F("txtB490GrpGroupedItemNo")); //Commented out and replaced by code below - Jerome Bautista 12.03.2015 SR 21016
			perilGrp.groupedItemNo		    = objItmPerl.b480Row.groupedItemNo;
			perilGrp.lineCd 						= escapeHTML2($F("txtB480GrpLineCd"));
			perilGrp.annTsiAmt 				= escapeHTML2($F("txtB490GrpTsiAmt"));
			perilGrp.annPremAmt 			= escapeHTML2($F("txtB490GrpPremAmt"));
			perilGrp.aggregateSw 			= escapeHTML2($F("txtB490GrpAggregateSw"));
			perilGrp.noOfDays 					= escapeHTML2($F("txtB490GrpNoOfDays"));
			perilGrp.baseAmt 					= escapeHTML2($F("txtB490GrpBaseAmt"));
			perilGrp.dspPerilName 			= escapeHTML2($F("txtB490GrpDspPerilName"));
			perilGrp.dspPerilType 			= escapeHTML2($F("txtB490GrpDspPerilType"));
			perilGrp.dspBascPerlCd 			= escapeHTML2($F("txtB490GrpDspBascPerlCd"));
			perilGrp.initialPerilCd 			= escapeHTML2($F("txtInitialPerilCd"));
			return perilGrp;
		} catch (e){
			showErrorMessage("createPerilGrpDtl", e);
		}	
	}
	
	function showPerilNameLOV(lineCd, sublineCd, notIn) {
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getDspPerilNameLOV",
											lineCd: lineCd,
											sublineCd:sublineCd,
											notIn: notIn,
											page : 1},
			title: "List of Perils",
			width: 650,
			height: 404,
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
									id: 'dspPerilName',
									title: 'Peril Name',
									width: '226px'
								},
								{
									id: 'dspPerilSname',
									title: 'Short Name',
									width: '166px'
								},
								{
									id: 'dspPerilType',
									title: 'Type',
									width: '98px'
								},
								{
									id: 'dspPerilSname2',
									title: 'Basic Peril Name',
									width: '180px'
								},
								{
									id: 'dspPrtFlag',
									title: 'Print Rate',
									titleAlign: 'right',
									align: 'right',
									width: '98px'
								},
								{
									id: 'perilCd',
									title: 'Peril Code',
									titleAlign: 'right',
									align: 'right',
									width: '102px'
								}
			              ],
			draggable: true,
	  		onSelect: function(row){
				 if(row != undefined) {
					$("txtB490GrpDspPerilName").value = unescapeHTML2(row.dspPerilName);
					$("txtB490GrpDspPerilType").value = row.dspPerilType;
					$("txtB490GrpDspBascPerlCd").value = row.dspBascPerlCd;
					$("txtB490GrpLineCd").value = row.lineCd;
					$("txtB490GrpPerilCd").value = row.perilCd;
					getDefaultRate();
					changeTag = 1;
				 }
	  		}
		});
	}
	
	function getDefaultRate(){
		try{
			new Ajax.Request(contextPath+"/GIISPerilController?action=getDefaultRate", {
				method: "POST",
				parameters: {perilCd: 			$F("txtB490GrpPerilCd"),
										lineCd: 				$F("txtLineCd")
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
					     if ($F("txtB490GrpTsiAmt") == '' &&
					    	  $F("txtB490GrpPremAmt") == '' &&
					    	 $F("txtB490GrpPremRt") == ''  &&
					    	 $F("txtIssCd") != $F("txtIssCdRi")){
					    	 $("txtB490GrpPremRt").value = formatToNineDecimal(response.responseText);	    	 
					     }
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e) {
			showErrorMessage("getDefaultRate", e);
		}
	}
	
	function computeTsiGIEXS007(){
		try{
			new Ajax.Request(contextPath+"/GIEXItmperilController", {
				method: "POST",
				parameters: {action : "computeTsiGIEXS007",
							b490TsiAmt                            	 : unformatCurrencyValue($F("txtB490GrpTsiAmt")),  
							b490PremRt                          	: unformatCurrencyValue($F("txtB490GrpPremRt")),
							b490AnnTsiAmt                     	: unformatCurrencyValue($F("txtB490GrpAnnTsiAmt")), 
							b490AnnPremAmt                 	: unformatCurrencyValue($F("txtB490GrpAnnPremAmt")), 
							b480TsiAmt                             	: unformatCurrencyValue($F("txtB480GrpTsiAmt")),  
							b480PremAmt                     	: unformatCurrencyValue($F("txtB480GrpPremAmt")),    
							b480AnnTsiAmt                     	: unformatCurrencyValue($F("txtB480GrpAnnTsiAmt")),
							b480AnnPremAmt                 	: unformatCurrencyValue($F("txtB480GrpAnnPremAmt")),
							b490NbtTsiAmt                     	: unformatCurrencyValue(nbtTsiAmt), //Modified by Jerome Bautista 12.03.2015 SR 21016 
							b490NbtPremRt                     	: unformatCurrencyValue(nbtPremRt), //Modified by Jerome Bautista 12.03.2015 SR 21016       
							b490NbtPremAmt                 	: unformatCurrencyValue(nbtPremAmt), //Modified by Jerome Bautista 12.03.2015 SR 21016 
							provPremPct                         	: $F("txtProvPremPct"), 
							provPremTag                        	 : $F("txtProvPremTag"),
							isGpa											:$F("txtIsGpa"),
							dspPerilType               			 	: $F("txtB490GrpDspPerilType"),
							b480LineCd                             	: $F("txtB480GrpLineCd"), 
							b490PerilCd                            	: $F("txtB490GrpPerilCd"),
							validateSw                             	: validateSw,
							oldType                                     : oldType,
							nbtProrateFlag                     	: $F("txtNbtProrateFlag"),   
							endtExpiryDate                    	: $F("txtEndtExpiryDate"),
							effDate                                     	: $F("txtEffDate"), 
							expiryDate                             	: $F("txtExpiryDate"),
							shortRtPercent                     	: $F("txtShortRtPercent"),  
							compSw                                	: $F("txtCompSw")							
								},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if (msg != ""){
							showMessageBox(msg, imgMessage.ERROR);
						}else{
							if($F("txtB490GrpTsiAmt") != ""){
								$("txtB490GrpPremAmt").value = formatCurrency(result.b490PremAmt);
							}
							$("txtB480GrpNbtPremAmt").value = result.b480NbtPremAmt;
							$("txtB480GrpNbtTsiAmt").value = result.b480NbtTsiAmt;
							$("txtB490GrpAnnTsiAmt").value = result.b490AnnTsiAmt;
							$("txtB490GrpAnnPremAmt").value = result.b490AnnPremAmt;					
							changeTag = 1;
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} catch (e){
			showErrorMessage("computeTsiGIEXS007", e);
		}		
	}
	
	function computePremiumGIEXS007(){
		try{
			new Ajax.Request(contextPath+"/GIEXItmperilController", {
				method: "POST",
				parameters: {action : "computePremiumGIEXS007",				
								b490PremAmt 						: unformatCurrencyValue($F("txtB490GrpPremAmt")), 	
								b490TsiAmt								: unformatCurrencyValue($F("txtB490GrpTsiAmt")), 		
								b490AnnPremAmt 					: unformatCurrencyValue($F("txtB490GrpAnnPremAmt")), 						
								b480NbtPremAmt				 	: unformatCurrencyValue($F("txtB480GrpNbtPremAmt")),						
								b480AnnPremAmt 					: unformatCurrencyValue($F("txtB490GrpAnnPremAmt")), 								
								provPremPct 							: $F("txtProvPremPct"),				
								b490NbtTsiAmt 						: unformatCurrencyValue(nbtTsiAmt), //Modified by Jerome Bautista 12.03.2015 SR 21016		
								b490NbtPremAmt 					: unformatCurrencyValue(nbtPremAmt), //Modified by Jerome Bautista 12.03.2015 SR 21016
								b490NbtPremRt 						: unformatCurrencyValue(nbtPremRt), //Modified by Jerome Bautista 12.03.2015 SR 21016
							    effDate										: $F("txtEffDate"), 		
								endtExpiryDate 						: $F("txtEndtExpiryDate"), 					
								expiryDate 								: $F("txtExpiryDate"), 	
								provPremTag							: $F("txtProvPremTag"), 
								nbtProrateFlag 						: $F("txtNbtProrateFlag"), 
								shortRtPercent 						: $F("txtShortRtPercent"), 		
								compSw 									: $F("txtCompSw")},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if (msg != ""){
							showMessageBox(msg, imgMessage.ERROR);
						}else{
							$("txtB490AnnPremAmt").value = result.b490AnnPremAmt;
							$("txtB490NbtPremAmt").value = result.b490NbtPremAmt;
							$("txtB490PremRt").value = formatToNineDecimal(result.b490PremRt);
							changeTag = 1;
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} catch (e){
			showErrorMessage("computePremiumGIEXS007", e);
		}		
	}
	
	function removeItemInfoFocus2(){
		b490GrpGrid.keys.removeFocus(b490GrpGrid.keys._nCurrentFocus, true);
		b490GrpGrid.keys.releaseKeys();
	}
	
	if($("btnAdd").value == "Add"){ //Added by Jerome Bautista 12.02.2015 SR 21016
		$("txtB490GrpPremRt").removeAttribute("readonly");
		$("txtB490GrpTsiAmt").removeAttribute("readonly");
		$("txtB490GrpPremAmt").removeAttribute("readonly");
	}
	
	$("txtB490GrpPremRt").observe("focus", function(){
		nbtPremRt  		= nvl($F("txtB490GrpPremRt"),0);
		nbtTsiAmt 	 	= nvl($F("txtB490GrpTsiAmt"),0);
		nbtPremAmt 	= nvl($F("txtB490GrpPremAmt"),0);
	});
	
	$("txtB490GrpPremRt").observe("change", function(){ //Modified by Jerome Bautista 12.03.2015 SR 21016
		removeItemInfoFocus2();
		var premRt = $F("txtB490GrpPremRt");
		if (premRt == "") {
			$("txtB490GrpPremRt").focus();
			$("txtB490GrpPremRt").value = "";
			showMessageBox("Peril Rate is required.", imgMessage.ERROR);
		} else if(!(isNaN(parseFloat(premRt)))) {
			if ((premRt < 0.00)) {
				clearFocusElementOnError("txtB490GrpPremRt", "Rate must not be less than zero (0%).");
			} else if ((parseFloat(premRt) > 100)) {
				clearFocusElementOnError("txtB490GrpPremRt", "Rate must not be greater than a hundred (100%).");
			} else if(nvl($F("txtB490GrpPremRt"), 0) != nvl(nbtPremRt, 0)){
				computeTsiGIEXS007();
			}
		}
	});
	
	$("dspPerilNameLOV").observe("click", function () {
		var notIn = createCompletedNotInParam(b490GrpGrid, "perilCd");
		showPerilNameLOV($F("txtLineCd"), $F("txtSublineCd"), notIn);
	});
	
	$("btnAdd").observe("click", function(){
		if(objItmPerl.b480Row == null){ //Modified by Jerome Bautista 12.03.2015 SR 21016
			showMessageBox("Please select an item record first.", imgMessage.INFO);
		}else if (checkAllRequiredFieldsInDiv("detailsContentsDiv")){	
			var perilGrpDtl = createPerilGrpDtl();
			var perilGrpDtl2 = createPerilGrpDtl2(); //Added by Jerome Bautista 12.04.2015 SR 21016
			if($F("btnAdd") == "Add"){	
				b490GrpGrid.addRow(perilGrpDtl);
			} else {					
				b490GrpGrid.updateRowAt(perilGrpDtl2, selectedB490Grp); //Modified by Jerome Bautista 12.04.2015 SR 21016
			}
			changeTag = 1;
			setB490GrpInfo(null);
		}
	});
	
	$("btnDelete").observe("click", function(){
		if (nvl(b490GrpGrid,null) instanceof MyTableGrid);
		b490GrpGrid.deleteRow(selectedB490Grp);
		setB490GrpInfo(null);
	});
	
	$("txtB490GrpTsiAmt").observe("focus", function(){
		nbtTsiAmt 	 	= nvl($F("txtB490GrpTsiAmt"),0);
	});
	
	$("txtB490GrpTsiAmt").observe("change", function(){ //Modified by Jerome Bautista 12.03.2015 SR 21016
		removeItemInfoFocus2();
	    var highestTsiAmt = getHighestTsiAmt(); //Added by Jerome Bautista 12.04.2015 SR 21016
		if (($F("txtB490GrpTsiAmt")< 0.00) || ($F("txtB490GrpTsiAmt") > 99999999999999.99)) {
			showWaitingMessageBox("Invalid TSI Amount. Value should be from 0.01 to 99,999,999,999,999.99.","E", function(){ //Modified by Jerome Bautista 12.04.2015 SR 21016
				$("txtB490GrpTsiAmt").value = formatCurrency(nbtTsiAmt);
			});
		}else{
			if($F("txtB490GrpDspBascPerlCd") == ""){ //Added by Jerome Bautista 12.04.2015 SR 21016
				if($F("txtB490GrpDspPerilType") == "A" || selectedB490GrpRow.dspPerilType == "A"){
					if(($F("txtB490GrpTsiAmt") > highestTsiAmt)){
						$("txtB490GrpTsiAmt").value = formatCurrency(nbtTsiAmt);
						showMessageBox("TSI Amount must not be greater than "+formatCurrency(highestTsiAmt)+".", imgMessage.ERROR);
					}
				}
			}
			computeTsiGIEXS007();
		}
	});
	
	function getHighestTsiAmt(){ //Added by Jerome Bautista 12.04.2015 SR 21016
		var tsiArray = [];
		var tsi = 0;
		for(var i = 0;i < b480GrpGrid.rows.length;i++){
			tsiArray.push(parseFloat(b480GrpGrid.rows[i][b480GrpGrid.getColumnIndex("nbtTsiAmt")]));
		}
		tsi = tsiArray.max();
		return tsi;
	}
	
	$("txtB490GrpPremAmt").observe("focus", function(){
		nbtPremAmt 	 	= nvl($F("txtB490GrpPremAmt"),0);
	});
	
	$("txtB490GrpPremAmt").observe("change", function(){ //Modified by Jerome Bautista 12.03.2015 SR 21016
		removeItemInfoFocus2();
		if (($F("txtB490GrpPremAmt")< 0.00)) {
			showWaitingMessageBox("Premium must not be less than zero.","E", function(){
				$("txtB490GrpPremAmt").value = formatCurrency(nbtPremAmt);
			});
		}else{
			computePremiumGIEXS007();
		}
	});
	
	$("txtB490GrpNoOfDays").observe("blur", function(){
		if($F("txtB490GrpNoOfDays") == '0'){
			$("txtB490GrpBaseAmt").value = formatCurrency(0); //Modified by Jerome Bautista 12.04.2015 SR 21016
		}else if($F("txtB490GrpNoOfDays") == ''){
			$("txtB490GrpBaseAmt").value = ""; //Modified by Jerome Bautista 12.04.2015 SR 21016
		}
		if($("txtB490GrpBaseAmt") >= '1.00' && nvl($F("txtB490GrpNoOfDays"),'0') != '0') { //Modified by Jerome Bautista 12.04.2015 SR 21016
			$("txtB490GrpTsiAmt").value = formatCurrency(nvl($F("txtB490GrpBaseAmt"),'0') * nvl($F("txtB490GrpNoOfDays"),'0')); //Modified by Jerome Bautista 12.04.2015 SR 21016
		}
	});
	
	$("txtB490GrpBaseAmt").observe("blur", function(){ //Modified by Jerome Bautista 12.04.2015 SR 21016
		if($F("txtB490GrpNoOfDays") == '0'){
			showWaitingMessageBox("Enter values for field No. Of Days first.", "I", function(){
				$("txtB490GrpBaseAmt").value = formatCurrency(0); //Modified by Jerome Bautista 12.04.2015 SR 21016
				$("txtB490GrpNoOfDays").focus();
			});
		}else if($F("txtB490GrpNoOfDays") == ''){
			showWaitingMessageBox("Enter values for field No. Of Days  first.", "I", function(){
				$("txtB490GrpBaseAmt").value = ''; //Modified by Jerome Bautista 12.04.2015 SR 21016
				$("txtB490GrpNoOfDays").focus();
			});
		}
		if($("txtB490GrpBaseAmt") >= '1.00' && nvl($F("txtB490GrpNoOfDays"),'0') != '0') { //Modified by Jerome Bautista 12.04.2015 SR 21016
			$("txtB490GrpTsiAmt").value = formatCurrency(nvl($F("txtB490GrpBaseAmt"),'0') * nvl($F("txtB490GrpNoOfDays"),'0')); //Modified by Jerome Bautista 12.04.2015 SR 21016
		}
	});

</script>