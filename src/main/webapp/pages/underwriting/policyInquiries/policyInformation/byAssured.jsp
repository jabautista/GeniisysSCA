<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="viewByAssuredMainDiv" name="viewByAssuredMainDiv" style="">

	<div id="regeneratePolicyDocumentsMenu">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
<!-- 		<div id="mainNav" name="mainNav">  	commented out by Gzelle 07292014 replaced with toolbar-->	
<!-- 			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu"> -->
<!-- 				<ul> -->
<!-- 					<li><a id="parExit">Exit</a></li> -->
<!-- 				</ul> -->
<!-- 			</div> -->
<!-- 		</div> -->
	</div>
	
	<div class="sectionDiv" id="assuredDiv">
		<div style="margin:10px 5px 5px auto;">
			<div style="width:98%;margin-left:2%;">
			<table>	<!--modified by Gzelle 07292014  -->
				<td class="rightAligned" style="padding-left: 20px;">Assured Name</td>
				<td class="leftAligned" colspan="">
					<span class="lovSpan required"  style="float: left; width: 110px; margin-right: 3px; margin-top: 2px; height: 21px;">
						<input type="text" id="txtAssdNo" name="txtAssdNo" style="width: 85px; float: left; border: none; height: 15px; margin: 0;" class="integerNoNegativeUnformattedNoComma required rightAligned" maxlength="12" ignoreDelKey="1" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForAssuredNo" name="searchForAssuredNo" alt="Go" style="margin-top: 2px;" title="Search Assured"/>
					</span>
					</td>
			    <td class="rightAligned" colspan="">
				<span class="lovSpan required"  style="float: right; width: 635px; margin-right: 3px; margin-top: 2px; height: 21px;">
				<input type="text" id="txtAssdName" name="txtAssdName" style="width:605px; float: left; border: none; height: 15px; margin: 0px;" class="required" lastValidValue=""/>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchForAssuredName" name="searchForAssuredName" alt="Go" style="margin-top: 2px;" title="Search Assured"/> <!-- Edited by Gab 07.23.2015 -->
					</span>
					</td>
			</table>
			</div>
		</div>
		
		<div id="policyByAssuredDiv"  style="height:304px;width:856px;margin:10px auto 10px auto;"></div>
		
		<div style="text-align:center;margin:10px auto 20px auto">
			<input type="button" class="button" id="btnSummarizedInfo" name="btnSummarizedInfo" value="Summarized Information"/>
			<input type="button" class="button" id="btnPolEndtDetails" name="btnPolEndtDetails" value="Policy/Endorsement Details"/>
		</div>
	</div>
	
</div>

<script>
	//added by Gab 08.04.2015
	if(typeof objGIPIS100 != "undefined"){
		if(nvl(objGIPIS100.query, "N") == "Y"){
			objGIPIS100.query = "N";
			queryOnLoad();
		} else {
			getPolicyByAssuredTable();
		}
	}
	//$("parExit").observe("click",showViewPolicyInformationPage);		commented out by Gzelle 07292014
	
	/* commented out by shan 03.25.2014
	$("searchForAssuredNo").observe("click", function(){
		overlayAssuredList = Overlay.show(contextPath+"/GIPIPolbasicController", {
			urlContent: true,
			urlParameters: {action : "showPolicyAssuredOverLay"},
			title: "Assured",
			width: 416,
			height: 400,
			draggable: false
		});
	});*/
	
	$("searchForAssuredNo").observe("click", function() {
		if($F('txtAssdNo') != $('txtAssdNo').getAttribute('lastValidValue')){
			showGIISAssuredLOVGIPIS100($F('txtAssdNo'));
		}else
			showGIISAssuredLOVGIPIS100('%'); 
	}
	); //edited by Gab 07.23.2015
	
	$("searchForAssuredName").observe("click", function() {
		if($F('txtAssdName') != $('txtAssdName').getAttribute('lastValidValue')){
			showGIISAssuredLOVGIPIS100($F('txtAssdName'));
		}else
			showGIISAssuredLOVGIPIS100('%');
	} // edited by Gab 07.23.2015
	
			/*function(){showGIISAssuredLOV("getGIISAssuredLOV", 
					function(row){
						$("txtAssdNo").value = row.assdNo;
						$("txtAssdName").value = unescapeHTML2(row.assdName);
						getPolicyByAssuredTable(row.assdNo);}
					);}	commented out by Gzelle 07292014 */
	);
	
	//added by Gzelle 07292014 // edited by Gab 07.23.2015
	function showGIISAssuredLOVGIPIS100(search) {
		try {
			LOV.show({
				controller : "UWPolicyInquiryLOVController",
				urlParameters : {
					action : "getGIISAssuredLOVTG",
					filterText : escapeHTML2(search),
					page : 1
				},
				title : "List of Assureds",
				width : 500,
				height : 370,
				autoSelectOneRecord : true,
				filterText : search,
				columnModel : [ {
					id : "assdNo",
					title : "Assured No",
					width : '80px'
				}, {
					id : "assdName",
					title : "Assured Name",
					width : '415px'
				} ],
				draggable : true,
				onSelect : function(row) {
					$("txtAssdNo").value = row.assdNo;
					$("txtAssdName").value = unescapeHTML2(row.assdName);
					$("txtAssdNo").setAttribute("lastValidValue", row.assdNo);
					$("txtAssdName").setAttribute("lastValidValue", unescapeHTML2(row.assdName));
					enableToolbarButton("btnToolbarExecuteQuery");
					enableToolbarButton("btnToolbarEnterQuery");
					disableSearch("searchForAssuredNo");
					disableSearch("searchForAssuredName");
					disableInputField("txtAssdNo");
					disableInputField("txtAssdName");
				},
				onCancel: function(){
					$("txtAssdNo").value = $("txtAssdNo").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtAssdNo").value = $("txtAssdNo").getAttribute("lastValidValue");
				},
				onCancel: function(){
					$("txtAssdName").value = $("txtAssdName").getAttribute("lastValidValue");
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("txtAssdName").value = $("txtAssdName").getAttribute("lastValidValue");
				},
			});
		} catch (e) {
			showErrorMessage("showGIISAssuredLOVGIPIS100", e);
		}
	}
	
	function queryOnLoad(){
		$("txtAssdNo").value = objGIPIS100.assdNo;
		$("txtAssdName").value = objGIPIS100.assdName;
		disableToolbarButton("btnToolbarExecuteQuery");
		enableToolbarButton("btnToolbarEnterQuery");
		getPolicyByAssuredTable($F("txtAssdNo"));
	}
	
	//edited by gab 07.23.2015
	$("txtAssdNo").observe("change", function() {
		/* if (this.value != "") {
			showGIISAssuredLOVGIPIS100($("txtAssdNo").value);
		} else {
			$("txtAssdNo").clear();
			$("txtAssdNo").setAttribute("lastValidValue", "");
			$("txtAssdName").setAttribute("lastValidValue", "");
		} */
		
		if($F('txtAssdNo') != $('txtAssdNo').getAttribute('lastValidValue')){
			showGIISAssuredLOVGIPIS100($F('txtAssdNo'));
		}else
			showGIISAssuredLOVGIPIS100('%');
	});
	
	//added by gab 07.23.2015
	$("txtAssdName").observe("change", function() {
		if($F('txtAssdName') != $('txtAssdName').getAttribute('lastValidValue')){
			showGIISAssuredLOVGIPIS100($F('txtAssdName'));
		}else
			showGIISAssuredLOVGIPIS100('%');
	});
	
	$("btnToolbarExecuteQuery").observe("click",function(){
		if(checkAllRequiredFieldsInDiv("assuredDiv")){
			getPolicyByAssuredTable($F("txtAssdNo"));
			disableInputField("txtAssdNo");
			disableInputField("txtAssdName");
			disableSearch("searchForAssuredNo");
			disableSearch("searchForAssuredName");
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		}
	});
	
	$("btnToolbarEnterQuery").observe("click",function(){
		getPolicyByAssuredTable();
		enableInputField("txtAssdNo");
		enableInputField("txtAssdName");
		enableSearch("searchForAssuredNo");
		enableSearch("searchForAssuredName");
		$("txtAssdNo").clear();
		$("txtAssdName").clear();
		$("txtAssdNo").setAttribute("lastValidValue", "");
		$("txtAssdName").setAttribute("lastValidValue", "");
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		
	});
	
	$("btnToolbarExit").observe("click", function(){
		showViewPolicyInformationPage();
	});
	
	//added by gab.08.04.2015
	if($F("txtAssdNo") != "" || $F("txtAssdName") != "" ){
		enableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableInputField("txtAssdNo");
		disableInputField("txtAssdName");
		disableSearch("searchForAssuredNo");
		disableSearch("searchForAssuredName");
	} else {
		disableToolbarButton("btnToolbarEnterQuery");
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	// objGIPIS100.callingForm = "GIPIS130"; commented out by gab 08.17.2015 
	hideToolbarButton("btnToolbarPrint");
	initializeAll();
</script>