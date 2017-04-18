const BLACK_COLOR = "#000000";
const GRAY_COLOR  = "#CCCCCC";
const lineWidth = 3;

var objRoadmapImage = new Object();

objRoadmapImage.CURRENT_LOC_IMG = new Image();
objRoadmapImage.CURRENT_LOC_IMG.src = contextPath + "/css/roadMap/images/curr_loc.icon";

objRoadmapImage.AVAILABLE_LOC_IMG = new Image();
objRoadmapImage.AVAILABLE_LOC_IMG.src = contextPath + "/css/roadMap/images/avail.icon";

objRoadmapImage.UNAVAILABLE_LOC_IMG = new Image();
objRoadmapImage.UNAVAILABLE_LOC_IMG.src = contextPath + "/css/roadMap/images/unavail.icon";

objRoadmapImage.INACCESSIBLE_LOC_IMG = new Image();
objRoadmapImage.INACCESSIBLE_LOC_IMG.src = contextPath + "/css/roadMap/images/no_access.icon";

var objRoadMapAvail = new Object();
var objParamBBI = null;

objRoadMapAvail.parlist = null;
objRoadMapAvail.basicInfo = null;
objRoadMapAvail.packPolItems = null;
objRoadMapAvail.peril = null;
objRoadMapAvail.warrClause = null;
objRoadMapAvail.billInfo = null;
objRoadMapAvail.coInsurance = null;
objRoadMapAvail.prelimDist = null;
objRoadMapAvail.print = null;
objRoadMapAvail.post = null;
objRoadMapAvail.dist = null;
objRoadMapAvail.itemInfo = null;
objRoadMapAvail.itemMC = null;
objRoadMapAvail.itemFI = null;
objRoadMapAvail.itemEN = null;
objRoadMapAvail.itemMN = null;
objRoadMapAvail.itemMH = null;
objRoadMapAvail.itemCA = null;
objRoadMapAvail.itemAV = null;
objRoadMapAvail.itemAC = null;
objRoadMapAvail.itemOthers = null;
objRoadMapAvail.coInsurer = null;
objRoadMapAvail.leadPol = null;
objRoadMapAvail.setupGrp = null;
objRoadMapAvail.perilDist = null;
objRoadMapAvail.oneRiskDist = null;
objRoadMapAvail.bondBasicInfo = null;
objRoadMapAvail.engInfo = null;
objRoadMapAvail.lineSubCov = null;
objRoadMapAvail.carrierInfo = null;
objRoadMapAvail.cargoLiab = null;
objRoadMapAvail.bankColl = null;
objRoadMapAvail.reqDocs = null;
objRoadMapAvail.initAcc = null;
objRoadMapAvail.collTrans = null;
objRoadMapAvail.limLiab = null;
objRoadMapAvail.discSur = null;
objRoadMapAvail.grpItem = null;
objRoadMapAvail.billPrem = null;
objRoadMapAvail.invComm = null;
objRoadMapAvail.distPeril = null;
objRoadMapAvail.distGrp = null;
objRoadMapAvail.allowEntry = null;