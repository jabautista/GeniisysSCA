<jsp:useBean id="today" class="java.util.Date" />
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<script language="Javascript">
	var contextPath = "${pageContext.request.contextPath}";
	var calendarImg = contextPath+"/images/misc/but_calendar.gif";
	var userId = "${PARAMETERS['USER'].userId}"; // andrew - 09.30.2011
	var imgMessage = new Object();
	imgMessage.ERROR = "error";
	imgMessage.WARNING = "warning";
	imgMessage.INFO = "info";
	imgMessage.SUCCESS = "success";
	var changeTag = 0;
	var changeTagFunc = "";
	var mainContainerWidth = 921;
	var oldFormContent = "";
	var newFormContent = "";
	var passwordExpiry = "";
	//var userId = "";
	var newUserTag = 0;
	var daysBeforePasswordExpires = 0;
	var resultMessageDelimiter = "-*|@geniisys@|*-";
	var modules = null;
	var textEditorFont = "${textEditorFont}";
</script>

<link rel="shortcut icon" href="${pageContext.request.contextPath}/images/misc/geniisys.ico" />

<!-- JS Files -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/prototype.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/scriptaculous.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/builder.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/controls.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/dragdrop.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/effects.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/slider.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/sound.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/unittest.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/modalbox.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/deployJava.js"></script>

<%-- <!-- tooltip -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/wz_tooltip.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/tip_centerwindow.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/tip_balloon.js"></script> --%>

<!-- LIGHTBOX by whofeih -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/lightwindow.js"></script>
<!-- PWC by Whofeih -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/window.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/window_effects.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/windowCalls.js"></script>
<!-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/pwc-os.js"></script> -->
<!-- Kinetic 2D -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/kinetic2d.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/roadMapCanvas.js"></script>
<!--CALENDAR-->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/calendar.js"></script>
<!-- dropdowncontent -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/dropdowncontent.js"></script>
<!--GLOBAL ACTIVITY INDICATOR-->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showAbout.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/showLogin.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/isMS.js"></script>
<script type="text/javascript" id="loadFunctionsHere"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/loadFunctions.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/common.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/commonActions.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/objCommon.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/regularExpression.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quotation.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quotationInformation.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quoteDeductibles.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/invoice.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quotation-lov.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quotation-pack.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quotation/quotationInformation-pack.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/dateFormat.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/fieldValidator.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/jquery.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/ddsmoothmenu.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quote/quote.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/marketing/quote/quote-lov.js"></script>
<script type="text/javascript">
	jQuery.noConflict();
</script>

<!-- security js sources -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/security/user.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/security/security.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/security/userGroup.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/security/modules.js"></script>
<!-- date js sources -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/date.js"></script>
<!-- json js sources -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/passwordMeter.js"></script>
<!-- passwordMeter js sources -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/json.js"></script>
<!-- endt item js sources  -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/endt/item.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/endt/peril.js"></script>
<!-- WYSIWYG js sources -->
<!-- <script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/wysiwyg/scripts/wysiwyg.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/wysiwyg/scripts/wysiwyg-settings.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/nicEdit/nicEdit.js"></script> -->
<!-- TAB PANEL TONIO Sept. 7, 2010 -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/ajaxtags.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/mytablegrid.js"></script> 
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/tablegrid.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/calendar.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/controls.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/format.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/keytable.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/mtg/textfield.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/third_party/overlay.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/workflow/workflow.js"></script>
<!-- underwriting js sources - 3.15.2011 - andrew -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting-pack.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting-item-save-functions.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting-policy-inquiries.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting-lov.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/underwriting-util.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/reInsurance.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/distribution.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/underwriting/roadMap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/accounting/accounting.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/accounting/accounting-creceipts-utilities.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/accounting/accounting-lov.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/accounting/accounting-dcp.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/accounting/acctg-directprem.js"></script>

<!-- Claims -->
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims-item.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims-lov.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims-lossExpenseHist.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/Claims-McEvaluationReport.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims-reserve.js"></script>

<!-- CSS Files -->
<link href="${pageContext.request.contextPath}/css/lightwindow.css" rel="stylesheet" type="text/css" media="screen" />
<link href="${pageContext.request.contextPath}/css/themes/default.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/themes/darkX.css" rel="stylesheet" type="text/css" />	
<link href="${pageContext.request.contextPath}/css/themes/lighting.css" rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/themes/mac_os_x.css" rel="stylesheet" type="text/css" />
<link id="alphacube" name="alphacube" href="${pageContext.request.contextPath}/css/themes/alphacube-${defaultColor}.css" rel="stylesheet" type="text/css" />
<!-- end of PWC by Whofeih -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/modalbox.css" type="text/css" media="screen" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/roadMap/roadMap.css" type="text/css"/>
<link id="commonCss" name="commonCss" href="${pageContext.request.contextPath}/css/color_theme/common-${defaultColor}.css"	rel="stylesheet" type="text/css" />
<link href="${pageContext.request.contextPath}/css/modalbox.css"rel="stylesheet" type="text/css" />
<link id="menuCss" name="menuCss" rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/color_theme/ddsmoothmenu-${defaultColor}.css" />
<!-- Common Css -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css" type="text/css" media="screen" />
<!--<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/tabPanel.css"></link>-->
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/ajaxTags.css"></link>
<!-- MyTableGrid files - 11.19.2010 - andrew -->
<link type="text/css" href="${pageContext.request.contextPath}/css/mtg/mytablegrid.css" rel="stylesheet">
<link type="text/css" href="${pageContext.request.contextPath}/css/mtg/calendar.css" rel="stylesheet">