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
	<div id="b490ListingTableGridSectionDiv" style="height: 210px; margin-left: 70px; margin-top: 20px;">
		<div id="b490ListingTableGrid"changeTagAttr="true"></div>
	</div>
	<div  style="margin-top: 15px; margin-bottom: 5px;" align="center" changeTagAttr="true">
		<table>
			<tr>
				<td class="rightAligned" width="100px">Peril Name</td>
				<td class="leftAligned" width="310px">
					<div style="float: left; border: solid 1px gray; width: 306px; height: 20px;" class="withIconDIv required">
						<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 278px; border: none;" name="txtB490DspPerilName" id="txtB490DspPerilName" class="upper required" readonly="readonly" tabindex="1"/>
						<img id="dspPerilNameLOV"  alt="goPolicyNo" style="height: 18px;" class="hover" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" />						
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Peril Rate</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490PremRt" name="txtB490PremRt" style="width: 300px;" class="moneyRate required" tabindex="2"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">TSI Amount</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490TsiAmt" name="txtB490TsiAmt" style="width: 300px;" class="money required" tabindex="3"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Premium Amount</td>
				<td class="leftAligned" width="310px">
					<input type="text" id="txtB490PremAmt" name="txtB490PremAmt" style="width: 300px;" class="money required " tabindex="4"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" width="100px">Remarks</td>
				<td class="leftAligned" width="310px">
					<div style="border: 1px solid gray; height: 20px; width: 306px" changeTagAttr="true">
						<!-- changed limit from 4000 to 35 by robert 09.18.2013 -->
						<textarea onKeyDown="limitText(this,50);" onKeyUp="limitText(this,50);" id="txtB490CompRem" name="txtB490CompRem" style="width: 280px; border: none; height: 13px;" tabindex="5"></textarea>
						<img class="hover" src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks" />
					</div>
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
	
	var nbtPremRt;
	var nbtTsiAmt;
	var nbtPremAmt;
	
	var oldType = null;
	var validateSw = null;
	
	var selectedB490 = null;
	var selectedB490Row = new Object();
	objItmPerl .b490ListTableGrid = JSON.parse('${b490Dtls}'.replace(/\\/g, '\\\\'));
	objItmPerl .b490= objItmPerl .b490ListTableGrid.rows || [];

	try {
		var b490ListingTable = {
			url: contextPath+"/GIEXItmperilController?action=getGIEXS007B490Info&refresh=1&mode=1&policyId="+$F("txtB240PolicyId")+
					"&itemNo="+$F("txtB480ItemNo"),
			id: 2, //Added by Jerome Bautista 10.01.2015 SR 18536
			options: {
				newRowPosition: 'bottom',
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
					setB490Info(null);
					//joanne 02.18.14, initialize elements of objGIEXItmPeril
					var perils 		= b490Grid.geniisysRows; 
					objGIEXItmPeril.splice(0,objGIEXItmPeril.length);
					for (var i=0; i<perils.length; i++) {
						var newPeril	= new Object();
						newPeril.recordStatus 	= 0;
						newPeril.policyId 			= perils[i].policyId;
						newPeril.itemNo 			= perils[i].itemNo;
						newPeril.lineCd 			= perils[i].lineCd;
						newPeril.perilCd 			= perils[i].perilCd;
						newPeril.premRt 			= perils[i].premRt;
						newPeril.premAmt 			= perils[i].premAmt;
						newPeril.tsiAmt 			= perils[i].tsiAmt;
						newPeril.compRem 			= perils[i].compRem;
						newPeril.itemTitle 			= perils[i].itemTitle;
						newPeril.annTsiAmt 			= perils[i].annTsiAmt;
						newPeril.annPremAmt 		= perils[i].annPremAmt;
						newPeril.sublineCd 			= perils[i].sublineCd;
						newPeril.currencyRt 		= perils[i].currencyRt;
						newPeril.dspPerilName 		= perils[i].dspPerilName;
						newPeril.dspPerilType 		= perils[i].dspPerilType;  
						newPeril.dspBascPerlCd 		= perils[i].dspBascPerlCd; 
						newPeril.nbtPremAmt			= perils[i].nbtPremAmt;
						newPeril.nbtTsiAmt			= perils[i].nbtTsiAmt; 
						newPeril.nbtItemTitle		= perils[i].nbtItemTitle; 
						newPeril.initialPerilCd 	= perils[i].initialPerilCd;
						objGIEXItmPeril.push(newPeril);
					}//end joanne
				},
				onCellFocus: function(element, value, x, y, id) {
					mtgId = b490Grid._mtgId;
					if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")) {
						
						selectedB490 = y;
						selectedB490Row = b490Grid.geniisysRows[y];
						objItmPerl.b490Row = selectedB490Row;
						setB490Info(objItmPerl.b490Grid.getRow(y));
						removeItemInfoFocus2();
					}
				},
				onRemoveRowFocus : function(){
					setB490Info(null);
					removeItemInfoFocus2();
					objItmPerl.b490Row = null; //marco - 08.07.2014
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
							    //editor: 'checkbox' //Commented out by Jerome Bautista 10.01.2015 SR 18536	
							},
							{	
								id: 'divCtrId',
								width: '0',
								visible: false
							},
							{
								id: 'dspPerilName',
								title: 'Peril Name',
								width: '250',
								//editable: false, //Commented out by Jerome Bautista 10.01.2015 SR 18536
								filterOption: true
							},
							{
								id: 'premRt',
								title: 'Rate',
								width: '100',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'rate',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
							}, 
							{
								id: 'tsiAmt',
								title: 'TSI Amount',
								width: '160',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
							}, 
							{
								id: 'premAmt',
								title: 'Premium Amount',
								width: '160',
								titleAlign: 'right',
								align: 'right',
								geniisysClass: 'money',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
							},
							{
								id: 'compRem',
								title: 'Remarks',
								width: '200',
								//editable: false //Commented out by Jerome Bautista 10.01.2015 SR 18536
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
								id: 'lineCd',
								width: '0',
								visible: false
							},
							{
								id: 'perilCd',
								width: '0',
								visible: false
							},
							{
								id: 'itemTitle',
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
								id: 'sublineCd',
								width: '0',
								visible: false
							},
							{
								id: 'currencyRt',
								width: '0',
								visible: false
							},
							{
								id: 'dspPerilType',
								width: '0',
								visible: false
							},
							{
								id: 'initialPerilCd',
								width: '0',
								visible: false
							}
						],
			rows: objItmPerl .b490
		};
		b490Grid = new MyTableGrid(b490ListingTable);
		objItmPerl.b490Grid = b490Grid;
		b490Grid.pager = objItmPerl .b490ListTableGrid;
		b490Grid.render('b490ListingTableGrid');
	}catch(e) {
		showErrorMessage("b490Grid", e);
	}
	
	function removeItemInfoFocus2(){
		b490Grid.keys.removeFocus(b490Grid.keys._nCurrentFocus, true);
		b490Grid.keys.releaseKeys();
	}
	
	function setB490Info(obj) {
		try {
			$("txtB490PerilCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("txtB490PremRt").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(formatToNineDecimal(obj.premRt),""))) :null;
			$("txtB490TsiAmt").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(formatCurrency(obj.tsiAmt),""))) :null;
			$("txtB490PremAmt").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(formatCurrency(obj.premAmt),""))) :null;
			$("txtB490PolicyId").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.policyId,""))) :null;
			$("txtB490ItemNo").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemNo,""))) :null;
			$("txtB490CurrencyRt").value				= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.currencyRt,""))) :null;
			$("txtB490ItemTitle").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.itemTitle,""))) :null;
			$("txtB490LineCd").value							= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.lineCd,""))) :null;
			$("txtB490SublineCd").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.sublineCd,""))) :null;
			$("txtB490AnnTsiAmt").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.annTsiAmt,""))) :null;
			$("txtB490AnnPremAmt").value			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.annPremAmt,""))) :null;
			$("txtB490CompRem").value					= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.compRem,""))) :null;
			$("txtB490DspPerilName").value 			= nvl(obj,null) != null ? unescapeHTML2(String(nvl(obj.dspPerilName,""))) :null;
			$("txtB490DspPerilType").value				= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspPerilType,""))) :null;
			$("txtB490DspBascPerlCd").value			= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.dspBascPerlCd,""))) :null;
			$("txtInitialPerilCd").value						= nvl(obj,null) != null ?unescapeHTML2(String(nvl(obj.perilCd,""))) :null;
			$("btnAdd").value 										= obj == null ? "Add" : "Update";
			$("btnAdd").value										!= "Add" ? enableButton("btnDelete") : disableButton("btnDelete");
			nvl(obj,null) == null ? enableSearch("dspPerilNameLOV") : disableSearch("dspPerilNameLOV"); //joanne 01.27.14, disable LOV when item peril is chosen
		} catch(e) {
			showErrorMessage("setB490Info", e);
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
					$("txtB490DspPerilName").value = unescapeHTML2(row.dspPerilName);
					$("txtB490DspPerilType").value = row.dspPerilType;
					$("txtB490DspBascPerlCd").value = row.dspBascPerlCd;
					$("txtB490LineCd").value = row.lineCd;
					$("txtB490PerilCd").value = row.perilCd;
					getDefaultRate();
					changeTag = 1;
				 }
	  		}
		});
	}
	
	function createPerilDtl(obj){
		try {
			var peril 					= (obj == null ? new Object() : obj);			
			peril.recordStatus 	= (obj == null ? 0 : 1);
			peril.policyId 			= escapeHTML2($F("txtB240PolicyId"));
			peril.itemNo 			= escapeHTML2($F("txtB480ItemNo"));
			peril.lineCd 				= escapeHTML2($F("txtB490LineCd"));
			peril.perilCd 				= escapeHTML2($F("txtB490PerilCd"));
			peril.premRt 			= escapeHTML2($F("txtB490PremRt"));
			peril.premAmt 		= unformatCurrencyValue($F("txtB490PremAmt"));
			peril.tsiAmt 				= unformatCurrencyValue($F("txtB490TsiAmt"));
			peril.compRem 		= escapeHTML2($F("txtB490CompRem"));
			peril.itemTitle 			= escapeHTML2($F("txtB480ItemTitle"));
			peril.annTsiAmt 		= unformatCurrencyValue($F("txtB490TsiAmt"));
			peril.annPremAmt 	= unformatCurrencyValue($F("txtB490PremAmt"));
			peril.sublineCd 		= escapeHTML2($F("txtSublineCd"));
			peril.currencyRt 		= escapeHTML2(nvl($F("txtB490CurrencyRt"),$F("txtB480CurrencyRt")));
			peril.dspPerilName = escapeHTML2($F("txtB490DspPerilName"));
			peril.dspPerilType = escapeHTML2($F("txtB490DspPerilType"));  //joanne 02.12.14
			peril.dspBascPerlCd = escapeHTML2($F("txtB490DspBascPerlCd")); //joanne 02.12.14
			peril.nbtPremAmt	= unformatCurrencyValue($F("txtB490PremRt")); //joanne 02.14.14
			peril.nbtTsiAmt	= unformatCurrencyValue($F("txtB490TsiAmt")); //joanne 02.14.14
			peril.nbtItemTitle	= escapeHTML2($F("txtB480ItemTitle")); //joanne 02.14.14
			peril.initialPerilCd 	= escapeHTML2($F("txtInitialPerilCd"));
			return peril;
		} catch (e){
			showErrorMessage("createPerilDtl", e);
		}			
	}
	
	function computeTsiGIEXS007(){
		try{
			new Ajax.Request(contextPath+"/GIEXItmperilController", {
				method: "POST",
				parameters: {action : "computeTsiGIEXS007",
							b490TsiAmt                            	 : unformatCurrencyValue($F("txtB490TsiAmt")),  
							b490PremRt                          	: unformatCurrencyValue($F("txtB490PremRt")),
							b490AnnTsiAmt                     	: unformatCurrencyValue($F("txtB490AnnTsiAmt")), 
							b490AnnPremAmt                 	: unformatCurrencyValue($F("txtB490AnnPremAmt")), 
							b480TsiAmt                             	: unformatCurrencyValue($F("txtB480TsiAmt")),  
							b480PremAmt                     	: unformatCurrencyValue($F("txtB480PremAmt")),    
							b480AnnTsiAmt                     	: unformatCurrencyValue($F("txtB480AnnTsiAmt")),
							b480AnnPremAmt                 	: unformatCurrencyValue($F("txtB480AnnPremAmt")),
							b490NbtTsiAmt                     	: unformatCurrencyValue($F("txtB490NbtTsiAmt")), 
							b490NbtPremRt                     	: unformatCurrencyValue($F("txtB490NbtPremRt")),        
							b490NbtPremAmt                 	: unformatCurrencyValue($F("txtB490NbtPremAmt")), 
							provPremPct                         	: $F("txtProvPremPct"), 
							provPremTag                        	 : $F("txtProvPremTag"),
							isGpa											:$F("txtIsGpa"),
							dspPerilType               			 	: $F("txtB490DspPerilType"),
							b480LineCd                             	: $F("txtB480LineCd"), 
							b480SublineCd                    		 : $F("txtB480SublineCd"),
							b490PerilCd                            	: $F("txtB490PerilCd"),
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
							if($F("txtB490TsiAmt") != ""){
								$("txtB490PremAmt").value = formatCurrency(result.b490PremAmt);
							}
							$("txtB480NbtPremAmt").value = result.b480NbtPremAmt;
							$("txtB480NbtTsiAmt").value = result.b480NbtTsiAmt;
							$("txtB490AnnTsiAmt").value = result.b490AnnTsiAmt;
							$("txtB490AnnPremAmt").value = result.b490AnnPremAmt;		
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
								b490PremAmt 						: unformatCurrencyValue($F("txtB490PremAmt")), 	
								b490TsiAmt								: unformatCurrencyValue($F("txtB490TsiAmt")), 		
								b490AnnPremAmt 					: unformatCurrencyValue($F("txtB490AnnPremAmt")), 						
								b480NbtPremAmt				 	: unformatCurrencyValue($F("txtB480NbtPremAmt")),						
								b480AnnPremAmt 					: unformatCurrencyValue($F("txtB490AnnPremAmt")), 								
								provPremPct 							: $F("txtProvPremPct"),				
								b490NbtTsiAmt 						: unformatCurrencyValue($F("txtB490NbtTsiAmt")), 		
								b490NbtPremAmt 					: unformatCurrencyValue($F("txtB490NbtPremAmt")), 	
								b490NbtPremRt 						: unformatCurrencyValue($F("txtB490NbtPremRt")), 				
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
	
	function getDefaultRate(){
		try{
			new Ajax.Request(contextPath+"/GIISPerilController?action=getDefaultRate", {
				method: "POST",
				parameters: {perilCd: 			$F("txtB490PerilCd"),
										lineCd: 				$F("txtLineCd")
				},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
					     if ($F("txtB490TsiAmt") == '' &&
					    	  $F("txtB490PremAmt") == '' &&
					    	 $F("txtB490PremRt") == ''  &&
					    	 $F("txtIssCd") != $F("txtIssCdRi") &&
					    	 $F("txtB490CompRem") == ''){
					    	 $("txtB490PremRt").value = formatToNineDecimal(response.responseText);	    	 
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
	
	$("dspPerilNameLOV").observe("click", function () {
		var notIn = createCompletedNotInParam(b490Grid, "perilCd");
		showPerilNameLOV($F("txtLineCd"), $F("txtSublineCd"), notIn);
	});
	
	$("editRemarks").observe("click", function () {
		//showEditor("txtB490CompRem", 35); //changed limit from 4000 to 35 by robert 09.18.2013
		showOverlayEditor("txtB490CompRem", 50, $("txtB490CompRem").hasAttribute("readonly"));
	});
	
	$("txtB490DspPerilName").observe("click", function(){
		removeItemInfoFocus2();
	});
	
	$("txtB490PremRt").observe("focus", function(){
		nbtPremRt  		= nvl($F("txtB490PremRt"),0);
		nbtTsiAmt 	 	= nvl($F("txtB490TsiAmt"),0);
		nbtPremAmt 	= nvl($F("txtB490PremAmt"),0);
	});
	
	$("txtB490PremRt").observe("change", function(){ //replaced blur - christian 12.06.2012
		removeItemInfoFocus2();
		var premRt = $F("txtB490PremRt");
		if (premRt == "") {
			$("txtB490PremRt").focus();
			$("txtB490PremRt").value = "";
			showMessageBox("Peril Rate is required.", imgMessage.ERROR);
		} else if(!(isNaN(parseFloat(premRt)))) {
			if ((premRt < 0.00)) {
				clearFocusElementOnError("txtB490PremRt", "Rate must not be less than zero (0%).");
			} else if ((parseFloat(premRt) > 100)) {
				clearFocusElementOnError("txtB490PremRt", "Rate must not be greater than a hundred (100%).");
			} else if(nvl($F("txtB490PremRt"), 0) != nvl(nbtPremRt, 0)){
				computeTsiGIEXS007();
			}
		}
	});
	
	$("txtB490TsiAmt").observe("focus", function(){
		nbtTsiAmt 	 	= nvl($F("txtB490TsiAmt"),0);
	});
	
	$("txtB490TsiAmt").observe("change", function(){  //replaced blur - christian 12.06.2012
		//modify by joanne  12.02.13, add validation for allied perils
		/*try{
			new Ajax.Request(contextPath+"/GIEXItmperilController", {
				method: "POST",
				parameters: {action : "validateItemperil",
							policyId:							$F("txtB240PolicyId"),
							itemNo:								$F("txtB480ItemNo"),
							b480LineCd: 						$F("txtB480LineCd"), 
							b490PerilCd: 						$F("txtB490PerilCd"),
							dspPerilType:						$F("txtB490DspPerilType"),
							basicPerilCd:						$("txtB490DspBascPerlCd"),
							b490TsiAmt:							unformatCurrencyValue($F("txtB490TsiAmt")),  
							b490PremRt:							unformatCurrencyValue($F("txtB490PremRt")),						
								},
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var result = response.responseText.toQueryParams();
						var msg = result.msg;
						if (msg != ""){
							showMessageBox(msg, imgMessage.ERROR);
							$("txtB490TsiAmt").value = "";
							$("txtB490TsiAmt").focus();
						}else{
							removeItemInfoFocus2();
							if ($F("txtB490TsiAmt") != "" && $F("txtB490TsiAmt") < 0.00) {
								showWaitingMessageBox("TSI must not be less than zero.","E", function(){
									$("txtB490TsiAmt").value = formatCurrency(nbtTsiAmt);
								});
							}else if($F("txtB490TsiAmt") != "" && $F("txtB490TsiAmt") == 0){
								showWaitingMessageBox("TSI must not be equal to zero.","E", function(){
									$("txtB490TsiAmt").value = formatCurrency(nbtTsiAmt);
								});
							}else{
								computeTsiGIEXS007();
							}
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		} catch (e){
			showErrorMessage("validateItemperil", e);
		}	*/
		//joanne 01.23.14 remove validation
			removeItemInfoFocus2();
			if ($F("txtB490TsiAmt") != "" && $F("txtB490TsiAmt") < 0.00) {
				showWaitingMessageBox("TSI must not be less than zero.","E", function(){
					$("txtB490TsiAmt").value = formatCurrency(nbtTsiAmt);
				});
	
			}else if($F("txtB490TsiAmt") != "" && $F("txtB490TsiAmt") == 0){
				showWaitingMessageBox("TSI must not be equal to zero.","E", function(){
					$("txtB490TsiAmt").value = formatCurrency(nbtTsiAmt);
				});
			}else{
				computeTsiGIEXS007();
			}
	}); 

	
	$("btnAdd").observe("click", function(){
		if(objItmPerl.b480Row == null){
			showMessageBox("Please select an item record first.", imgMessage.INFO);
		}else if (checkAllRequiredFieldsInDiv("detailsContentsDiv")){	
			//modify by joanne  12.02.13, add validation for allied perils
			/*try{
				new Ajax.Request(contextPath+"/GIEXItmperilController", {
					method: "POST",
					parameters: {action : "validateItemperil",
								policyId:							$F("txtB240PolicyId"),
								itemNo:								$F("txtB480ItemNo"),
								b480LineCd: 						$F("txtB480LineCd"), 
								b490PerilCd: 						$F("txtB490PerilCd"),
								dspPerilType:						$F("txtB490DspPerilType"),
								basicPerilCd:						$("txtB490DspBascPerlCd"),
								b490TsiAmt:							unformatCurrencyValue($F("txtB490TsiAmt")),  
								b490PremRt:							unformatCurrencyValue($F("txtB490PremRt")),						
									},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							if (msg != ""){
								showMessageBox(msg, imgMessage.ERROR);
								$("txtB490TsiAmt").value = "";
								$("txtB490TsiAmt").focus();
							}else{
								var perilDtl = createPerilDtl();
								if($F("btnAdd") == "Add"){	
									b490Grid.createNewRow(perilDtl);
								} else {					
									b490Grid.updateRowAt(perilDtl, selectedB490);
								}
								changeTag = 1;
								setB490Info(null);
							}
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} catch (e){
				showErrorMessage("validateItemperil", e);
			} //end joanne*/
			//joanne 01.22.14 modify validation
			if (validateAddUpdatePeril()){
				var perilDtl = createPerilDtl();
				if($F("btnAdd") == "Add"){	
					perilDtl.recordStatus = 0;
					addNewJSONObject(objGIEXItmPeril, perilDtl);
					b490Grid.createNewRow(perilDtl);
					$("changePerilTag").value = "Y";
				} else {	
					perilDtl.recordStatus = 1;
					updateObjPeril(objGIEXItmPeril, perilDtl);
					b490Grid.updateRowAt(perilDtl, selectedB490);
					$("changePerilTag").value = "Y";
				}
				changeTag = 1;
				setB490Info(null);
			}
		}
	});
	
	$("btnDelete").observe("click", function(){
		if(objItmPerl.b480Row == null){
			showMessageBox("Please select an item record first.", imgMessage.INFO);
		}else if (checkAllRequiredFieldsInDiv("detailsContentsDiv")){	
			//modify by joanne 12-02-13, add validation when deleting basic peril
			/*try{
				new Ajax.Request(contextPath+"/GIEXItmperilController", {
					method: "POST",
					parameters: {action : "deleteItemperil",
								policyId:							$F("txtB240PolicyId"),
								itemNo:								$F("txtB480ItemNo"),
								b480LineCd: 						$F("txtB480LineCd"), 
								b490PerilCd: 						$F("txtB490PerilCd"),
								dspPerilType:						$F("txtB490DspPerilType"),
								basicPerilCd:						$("txtB490DspBascPerlCd"),					
									},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							var result = response.responseText.toQueryParams();
							var msg = result.msg;
							if (msg != ""){
								showMessageBox(msg, imgMessage.ERROR);
							}else{
								if (nvl(b490Grid,null) instanceof MyTableGrid);
								b490Grid.deleteRow(selectedB490);
								setB490Info(null);
							}
						}else{
							showMessageBox(response.responseText, imgMessage.ERROR);
						}
					}
				});
			} catch (e){
				showErrorMessage("deleteItemperil", e);
			} *///end joanne
			//joanne 01.28.14 modify validation
			if (validateDeletePeril(objGIEXItmPeril)){
				var perilDtl = createPerilDtl();
				addDeletedObjPeril(objGIEXItmPeril, perilDtl);
				if (nvl(b490Grid,null) instanceof MyTableGrid);
				b490Grid.deleteRow(selectedB490);
				setB490Info(null);
				$("changePerilTag").value = "Y";
			}
		}
	});
	
	$("txtB490PremAmt").observe("focus", function(){
		nbtPremAmt 	 	= nvl($F("txtB490PremAmt"),0);
	});
	
	$("txtB490PremAmt").observe("change", function(){ //replaced blur - christian 12.06.2012
		removeItemInfoFocus2();
		if (($F("txtB490PremAmt")< 0.00)) {
			showWaitingMessageBox("Premium must not be less than zero.","E", function(){
				$("txtB490PremAmt").value = formatCurrency(nbtPremAmt);
			});
		}else{
			computePremiumGIEXS007();
		}
	});

</script>