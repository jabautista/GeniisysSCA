<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
    
<div id="outerDiv" name="outerDiv" style="float:left">
	<div id="innerDiv" name="innerDiv">
   		<label>Other Details</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div class="sectionDiv" id="otherDetailsDiv" style="float:left; width: 100%;" changeTagAttr="true">
	<div id="otherDetails" style="margin:10px auto;">
	<table width="100%" border="0">
		<c:choose>
			<c:when test="${parType eq 'P'}">
				<tr>
					<td class="rightAligned" width="30%">Initial Information </td>
					<td class="leftAligned"  width="70%">
						<div style="float:left; border: 1px solid gray; height: 20px; width: 71%;">
							<textarea onKeyDown="limitText(this,32767);" onKeyUp="limitText(this,32767);" id="initialInformation" name="initialInformation" style="width: 93%; border: none; height: 13px;"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editInitInfoText" />
						</div>
						<img style="float:left; margin-left:3px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="initInfoDate" name="initInfoDate" alt="Go" />
					</td>
				</tr>
			</c:when>
			<c:when test="${parType eq 'E'}">
				<tr id="endorsementInformation">
					<td class="rightAligned" width="30%">Endorsement Information </td>
					<td class="leftAligned"  width="70%">
						<div style="float:left; border: 1px solid gray; height: 20px; width: 71%;">
							<%-- <textarea onKeyDown="limitText(this,32767);" onKeyUp="limitText(this,32767);" id="endtInformation" name="endtInformation" style="width: 93%; border: none; height: 13px;" >${gipiWEndtText.endtText01 }${gipiWEndtText.endtText02 }${gipiWEndtText.endtText03 }${gipiWEndtText.endtText04 }${gipiWEndtText.endtText05 }${gipiWEndtText.endtText06 }${gipiWEndtText.endtText07 }${gipiWEndtText.endtText08 }${gipiWEndtText.endtText09 }${gipiWEndtText.endtText10 }${gipiWEndtText.endtText11 }${gipiWEndtText.endtText12 }${gipiWEndtText.endtText13 }${gipiWEndtText.endtText14 }${gipiWEndtText.endtText15 }${gipiWEndtText.endtText16 }${gipiWEndtText.endtText17}</textarea> --%>
							<!--shan 07.05.2013, SR-13508: change limit from 32767 to 32760 to prevent truncated bind ORA error -->
							<textarea onKeyDown="limitText(this,32760);" onKeyUp="limitText(this,32760);" id="endtInformation" name="endtInformation" style="width: 93%; border: none; height: 13px;" class="required"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editEndtInfoText" />
						</div>
					    <img style="float:left; margin-left:3px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="endtTextDate" name="endtTextDate" alt="Go" />
					</td>
				</tr>
			</c:when>
		</c:choose>			
		<tr>
			<td class="rightAligned">General Information </td>
			<td class="leftAligned">				
				<div style="float:left; border: 1px solid gray; height: 20px; width: 71%;">
					<%-- <textarea onKeyDown="limitText(this,32767);" onKeyUp="limitText(this,32767);" id="generalInformation" name="generalInformation" style="width: 93%; border: none; height: 13px;">${gipiWPolGenin.genInfo01 }${gipiWPolGenin.genInfo02 }${gipiWPolGenin.genInfo03 }${gipiWPolGenin.genInfo04 }${gipiWPolGenin.genInfo05 }${gipiWPolGenin.genInfo06 }${gipiWPolGenin.genInfo07 }${gipiWPolGenin.genInfo08 }${gipiWPolGenin.genInfo09 }${gipiWPolGenin.genInfo10 }${gipiWPolGenin.genInfo11 }${gipiWPolGenin.genInfo12 }${gipiWPolGenin.genInfo13 }${gipiWPolGenin.genInfo14 }${gipiWPolGenin.genInfo15 }${gipiWPolGenin.genInfo16 }${gipiWPolGenin.genInfo17 }</textarea> --%>
					<!--shan 07.05.2013, SR-13508: change limit from 32767 to 32760 to prevent truncated bind ORA error -->
					<textarea onKeyDown="limitText(this,32760);" onKeyUp="limitText(this,32760);" id="generalInformation" name="generalInformation" style="width: 93%; border: none; height: 13px;"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editGenInfoText" />
				</div>
				<img style="float:left; margin-left:3px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="genInfoDate" name="genInfoDate" alt="Go" />	
				<!--  <c:choose>
					<c:when test="${parType eq 'P'}">
						<img style="float:left; margin-left:3px;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="genInfoDate" name="genInfoDate" alt="Go" />
					</c:when>
				</c:choose>	  replaced by: Nica 11.18.2011 to show search icon even for endt-->					
			</td>		
		</tr>
	</table>
	</div>		
</div>

<script type="text/javascript">
	//if(nvl(objUWParList.parType, null) == null) objUWParList.parType = objUWGlobal.parType;
	function showInitialInfoLOV(){ // added by andrew 11.08.2012
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISGenInitialInfoLOV",
							page : 1},
			title: "General Information",
			width: 900,
			height: 410,
			columnModel : [	{	id : "geninInfoCd",
								title: "Code",
								width: '80px'
							},
							{	id : "geninInfoTitle",
								title: "Title",
								width: '320px'
							},
							{	id : "initialInfoText",
								title: "Text",
								width: '550px',
								sortable: false
							}
						],
			draggable: true,
			onSelect: function(row){
				$("initialInformation").value = unescapeHTML2(row.initialInfoText);
				objUW.hidObjGIPIS002.geninInfoCd = row.geninInfoCd;
				$("initialInformation").focus();
			}
		  });
	}
	
	if (objUWParList.parType == "P"){
		$("initialInformation").value = unescapeHTML2('${gipiWPolGenin.initialInfo01}${gipiWPolGenin.initialInfo02 }${gipiWPolGenin.initialInfo03 }${gipiWPolGenin.initialInfo04 }${gipiWPolGenin.initialInfo05 }${gipiWPolGenin.initialInfo06 }${gipiWPolGenin.initialInfo07 }${gipiWPolGenin.initialInfo08 }${gipiWPolGenin.initialInfo09 }${gipiWPolGenin.initialInfo10 }${gipiWPolGenin.initialInfo11 }${gipiWPolGenin.initialInfo12 }${gipiWPolGenin.initialInfo13 }${gipiWPolGenin.initialInfo14 }${gipiWPolGenin.initialInfo15 }${gipiWPolGenin.initialInfo16 }${gipiWPolGenin.initialInfo17 }');
		$("generalInformation").value = unescapeHTML2('${gipiWPolGenin.genInfo01}${gipiWPolGenin.genInfo02 }${gipiWPolGenin.genInfo03 }${gipiWPolGenin.genInfo04 }${gipiWPolGenin.genInfo05 }${gipiWPolGenin.genInfo06 }${gipiWPolGenin.genInfo07 }${gipiWPolGenin.genInfo08 }${gipiWPolGenin.genInfo09 }${gipiWPolGenin.genInfo10 }${gipiWPolGenin.genInfo11 }${gipiWPolGenin.genInfo12 }${gipiWPolGenin.genInfo13 }${gipiWPolGenin.genInfo14 }${gipiWPolGenin.genInfo15 }${gipiWPolGenin.genInfo16 }${gipiWPolGenin.genInfo17 }');
		
		//var polGeninObj = JSON.parse('${gipiWPolGeninObj}');
		observeChangeTagOnDate("editInitInfoText", "initialInformation");
		observeChangeTagOnDate("editGenInfoText", "generalInformation");
		$("editInitInfoText").observe("click", function () {
			showEditor("initialInformation", 32767);	
		});
		//when init info LOV icon click
		observeChangeTagOnDate("initInfoDate", "initialInformation");
		$("initInfoDate").observe("click",function(){
			//openSearchInitInfo();
			showInitialInfoLOV(); // andrew 11.08.2012
		});
	}else{	
		$("endtInformation").value = unescapeHTML2('${gipiWEndtText.endtText01 }${gipiWEndtText.endtText02 }${gipiWEndtText.endtText03 }${gipiWEndtText.endtText04 }${gipiWEndtText.endtText05 }${gipiWEndtText.endtText06 }${gipiWEndtText.endtText07 }${gipiWEndtText.endtText08 }${gipiWEndtText.endtText09 }${gipiWEndtText.endtText10 }${gipiWEndtText.endtText11 }${gipiWEndtText.endtText12 }${gipiWEndtText.endtText13 }${gipiWEndtText.endtText14 }${gipiWEndtText.endtText15 }${gipiWEndtText.endtText16 }${gipiWEndtText.endtText17}');
		$("generalInformation").value = unescapeHTML2('${gipiWPolGenin.genInfo01}${gipiWPolGenin.genInfo02 }${gipiWPolGenin.genInfo03 }${gipiWPolGenin.genInfo04 }${gipiWPolGenin.genInfo05 }${gipiWPolGenin.genInfo06 }${gipiWPolGenin.genInfo07 }${gipiWPolGenin.genInfo08 }${gipiWPolGenin.genInfo09 }${gipiWPolGenin.genInfo10 }${gipiWPolGenin.genInfo11 }${gipiWPolGenin.genInfo12 }${gipiWPolGenin.genInfo13 }${gipiWPolGenin.genInfo14 }${gipiWPolGenin.genInfo15 }${gipiWPolGenin.genInfo16 }${gipiWPolGenin.genInfo17 }');
		
		observeChangeTagOnDate("editEndtInfoText", "endtInformation");
		$("editEndtInfoText").observe("click", function () {
			showEditor("endtInformation", 32760); 	//shan 07.05.2013, SR-13508: change limit from 32767 to 32760 to prevent truncated bind ORA error
		});
		
		observeChangeTagOnDate("endtTextDate", "endtInformation");
		$("endtTextDate").observe("click",function(){
			openSearchEndtText();
		});
		if(nvl(objUW.GIPIS031, null) != null ) {
			$("generalInformation").value = unescapeHTML2(nvl(objUW.GIPIS031.gipiWPolGenin.genInfo, ""));
			$("endtInformation").value = unescapeHTML2(nvl(objUW.GIPIS031.gipiWEndtText.endtText, ""));
		}
	}
	
	function showGeninInfoLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {action : "getGIISGeninInfoLOV",
							page : 1},
			title: "General Information",
			width: 900,
			height: 410,
			columnModel : [	{	id : "geninInfoCd",
								title: "Code",
								width: '80px'
							},
							{	id : "geninInfoTitle",
								title: "Title",
								width: '320px'
							},
							{	id : "genInfoText",
								title: "Text",
								width: '550px',
								sortable: false
							}
						],
			draggable: true,
			onSelect: function(row){
				$("generalInformation").value = unescapeHTML2(row.genInfoText);
				objUW.hidObjGIPIS002.geninInfoCd = row.geninInfoCd;
				$("generalInformation").focus();
			}
		  });
	}
	
	$("editGenInfoText").observe("click", function () {
		showEditor("generalInformation", 32760);  //shan 07.05.2013, SR-13508: change limit from 32767 to 32760 to prevent truncated bind ORA error
	});
	//if ($F("parType") == "P"){
		//when init info LOV icon click
		//observeChangeTagOnDate("genInfoDate", "generalInformation");
		$("genInfoDate").observe("click",function(){
			//openSearchGenInfo();
			showGeninInfoLOV(); // andrew 11.08.2012
		});
	//} modified by: Nica 11.18.2011 -- remove condition  	
</script>