/*
            XS常用函数重命名（用于内置XS）
    本文档收录了"AOE2DE UGC" 官网的大部分XS函数，并将其重命名成为简短名称，方便场景内置使用。（关于函数的详细说明，请参考UGC官网）
    https://ugc.aoe2.rocks/general/xs/functions

    使用方法：
    1.在场景中新建一个触发器，状态为“关闭” 
    2.设置若干个 "条件：XS脚本调用"，并且在每个条件的文本输入框中，将下列的这些函数复制进文本框
      【注意】：[1]该触发器必须关闭；[2]每个条件输入框只能写一个函数
    3.将你想用的函数全部输入之后，就可以开始你的作品创作，体验XS函数内置的强大功能了！
    
    
【问题反馈】：
    联系 babycat 
        Q Q ：2855241645
        WX号：babycat262
        
    在下静候君的反馈意见，您的宝贵意见至关重要！
*/



/// Rule 相关函数 ///
// xsDisableRule -> disaR
void disaR(string name=""){xsDisableRule(name);}
// xsDisableRuleGroup -> disaRG
void disaRG(string name=""){xsDisableRuleGroup(name);}
// xsDisableSelf -> disaRS 
void disaRS(){xsDisableSelf();}
// xsEnableRule -> enaR
void enaR(string name=""){xsEnableRule(name);}
// xsEnableRuleGroup -> enaRG 
void enaRG(string name=""){xsEnableRuleGroup(name);}
// xsIsRuleEnabled -> isRena
bool isRena(string name=""){return(xsIsRuleEnabled(name));}
// xsIsRuleGroupEnabled -> isRGena 
//bool isRGena(string name=""){return(xsIsRuleGroupEnabled(name));}
// xsSetRuleMaxInterval -> setRMaxI 
void setRMaxI(string name="", int I=1){xsSetRuleMaxInterval(name,I);}
// xsSetRuleMaxIntervalSelf -> setRMaxIS 
void setRMaxIS(int I=1){xsSetRuleMaxIntervalSelf(I);}
// xsSetRuleMinInterval -> setRMinI 
void setRMinI(string name="", int I=1){xsSetRuleMinInterval(name,I);}
// xsSetRuleMinIntervalSelf -> setRMinIS 
void setRMinIS(int I=1){xsSetRuleMinIntervalSelf(I);}
// xsSetRulePriority -> setRPri 
void setRPri(string name="", int pri=0){xsSetRulePriority(name,pri);}
// xsSetRulePrioritySelf -> setRPriS 
void setRPriS(int pri=0){xsSetRulePrioritySelf(pri);}

/// Vector 相关函数 ///
// xsVectorGetX -> vGetX 
float vGetX(vector v=cOriginVector){return(xsVectorGetX(v));}
// xsVectorGetX -> vGetY 
float vGetY(vector v=cOriginVector){return(xsVectorGetY(v));}
// xsVectorGetX -> vGetZ 
float vGetZ(vector v=cOriginVector){return(xsVectorGetZ(v));}
// xsVectorLength -> vLen 
float vLen(vector v=cOriginVector){return(xsVectorLength(v));}
// xsVectorNormalize -> vNorm 
vector vNorm(vector v=cOriginVector){return(xsVectorNormalize(v));}
// xsVectorSet -> vSet 
vector vSet(float x=0.0,float y=0.0,float z=0.0){return(xsVectorSet(x,y,z));}
// xsVectorSetX -> vSetX 
vector vSetX(vector v=cOriginVector,float x=0.0){return(xsVectorSetX(v,x));}
// xsVectorSetX -> vSetY 
vector vSetY(vector v=cOriginVector,float y=0.0){return(xsVectorSetY(v,y));}
// xsVectorSetX -> vSetZ 
vector vSetZ(vector v=cOriginVector,float z=0.0){return(xsVectorSetZ(v,z));}

/// Array 相关函数 ///
// xsArrayCreateBool -> bArr
int bArr(int size=1,bool val=false,string name=""){return(xsArrayCreateBool(size,val,name));}
// xsArrayCreateInt -> iArr
int iArr(int size=1,int val=-1,string name=""){return(xsArrayCreateInt(size,val,name));}
// xsArrayCreateFloat -> fArr
int fArr(int size=1,float val=0.0, string name=""){return(xsArrayCreateFloat(size,val,name));}
// xsArrayCreateString -> sArr
int sArr(int size=1,string val="",string name=""){return(xsArrayCreateString(size,val,name));}
// xsArrayCreateVector -> vArr
int vArr(int size=1,vector val=cOriginVector,string name=""){return(xsArrayCreateVector(size,val,name));}
// xsArrayGetBool -> bArrGet 
bool bArrGet(int arr=-1,int idx=0){return(xsArrayGetBool(arr,idx));}
// xsArrayGetInt -> iArrGet 
int iArrGet(int arr=-1,int idx=0){return(xsArrayGetInt(arr,idx));}
// xsArrayGetFloat -> fArrGet 
float fArrGet(int arr=-1,int idx=0){return(xsArrayGetFloat(arr,idx));}
// xsArrayGetString -> sArrGet 
string sArrGet(int arr=-1,int idx=0){return(xsArrayGetString(arr,idx));}
// xsArrayGetVector -> vArrGet 
vector vArrGet(int arr=-1,int idx=0){return(xsArrayGetVector(arr,idx));}
// xsArraySetBool -> bArrSet 
int bArrSet(int arr=-1,int idx=0,bool val=false){return(xsArraySetBool(arr,idx,val));}
// xsArraySetInt -> iArrSet 
int iArrSet(int arr=-1,int idx=0,int val=0){return(xsArraySetInt(arr,idx,val));}
// xsArraySetFloat -> fArrSet 
int fArrSet(int arr=-1,int idx=0,float val=0.0){return(xsArraySetFloat(arr,idx,val));}
// xsArraySetString -> sArrSet 
int sArrSet(int arr=-1,int idx=0,string val=""){return(xsArraySetString(arr,idx,val));}
// xsArraySetVector -> vArrSet 
int vArrSet(int arr=-1,int idx=0,vector val=cOriginVector){return(xsArraySetVector(arr,idx,val));}
// xsArrayResizeBool -> bArrResize 
int bArrResize(int arr=-1,int size=1){return(xsArrayResizeBool(arr,size));}
// xsArrayResizeInt -> iArrResize 
int iArrResize(int arr=-1,int size=1){return(xsArrayResizeInt(arr,size));}
// xsArrayResizeFloat -> fArrResize 
int fArrResize(int arr=-1,int size=1){return(xsArrayResizeFloat(arr,size));}
// xsArrayResizeString -> sArrResize 
int sArrResize(int arr=-1,int size=1){return(xsArrayResizeString(arr,size));}
// xsArayResizeVector -> vArrResize 
int vArrResize(int arr=-1,int size=1){return(xsArrayResizeVector(arr,size));}
// xsArrayGetSize -> ArrSize 
int ArrSize(int arr=-1){return(xsArrayGetSize(arr));}

/// 常规函数 ///
// xsChatData -> Chat 
//void Chat(string info="",int val=0){xsChatData(info,val);}
void Chat(string mes="",string c="",int n=-512){if((mes=="")&&(n==-512)){xsChatData(c);} else if((mes=="")&&(n!=-512)){xsChatData(c+n);} else if((mes!="")&&(n==-512)){xsChatData(c+mes);} else if((mes!="")&&(n!=-512)){xsChatData(c+mes+n);}}
// xsEffectAmount -> Effect 
void Effect(int mod=0,int id=0,int attr=0,float val=0.0,int p=-1){xsEffectAmount(mod,id,attr,val,p);}
// xsGetGameTime -> gameTime 
int GameTime(){return(xsGetGameTime());}
// xsGetMapID -> MapID 
int MapID(){return(xsGetMapID());}
// xsGetMapHeight -> MapH 
int MapH(){return(xsGetMapHeight());}
// xsGetMapWidth -> MapW 
int MapW(){return(xsGetMapWidth());}
// xsGetMapName -> MapName 
string MapName(bool ext=true){return(xsGetMapName(ext));}
// xsGetNumPlayers -> getNumP 
int getNumP(){return(xsGetNumPlayers());}
// xsGetObjectCount -> objCount 
int objCount(int p=0,int unit=0){return(xsGetObjectCount(p,unit));}
// xsGetObjectCountTotal -> objCountT 
int objCountT(int p=0,int unit=0){return(xsGetObjectCountTotal(p,unit));}
// xsGetPlayerCivilization(int playerNumber) -> getCiv 
int getCiv(int p=0){return(xsGetPlayerCivilization(p));}
// xsGetPlayerInGame -> isAliveP 
bool isAliveP(int p=0){return(xsGetPlayerInGame(p));}
// xsGetPlayerNumberOfTechs -> getResTechsP 
int getAviTechsP(int p=0){return(xsGetPlayerNumberOfTechs(p));}
// xsGetRandomNumber -> randNum 
int randNum(){return(xsGetRandomNumber());}  // [0, 32767)
// xsGetRandomNumberLH -> randNumLH 
int randNumLH(int low=0,int high=0){return(xsGetRandomNumberLH(low,high));}
// xsGetRandomNumberMax -> randMax 
int randMax(int max=0){return(xsGetRandomNumberMax(max));}
// xsGetVictoryCondition -> vicCond
int vicCond(){return(xsGetVictoryCondition());}
// xsGetVictoryConditionForSecondaryGameMode -> vicSecCond
int vicSecCond(){return(xsGetVictoryConditionForSecondaryGameMode());}
// xsGetVictoryPlayer -> vicP 
int vicP(){return(xsGetVictoryPlayer());}
// xsGetVictoryTime -> vicTime
int vicTime(){return(xsGetVictoryTime());}
// xsGetVictoryTimeForSecondaryGameMode() -> vicSecTime
int vicSecTime(){return(xsGetVictoryTimeForSecondaryGameMode());}
// xsGetVictoryType -> vicType 
int vicType(){return(xsGetVictoryType());}
// xsPlayerAttribute -> getAttr
float getAttr(int p=0,int attr=0){return(xsPlayerAttribute(p,attr));}
// xsSetPlayerAttribute -> setAttr
void setAttr(int p=0,int attr=0,float val=0.0){xsSetPlayerAttribute(p,attr,val);}
// xsResearchTechnology -> resTech 
bool resTech(int tech=0,bool force=true,bool abled=false,int p=0){return(xsResearchTechnology(tech,force,abled,p));}
// xsTriggerVariable -> getVar
int getVar(int var=0){return(xsTriggerVariable(var));}
// xsSetTriggerVariable -> setVar
void setVar(int var=0,int val=0) {xsSetTriggerVariable(var,val);}

/// Read|Write 相关函数 ///
// xsCloseFile -> cloFile
bool cloFile(){return(xsCloseFile());}
// xsCreateFile -> creFile 
bool creFile(bool append=true){return(xsCreateFile(append));}
// xsGetDataTypeSize -> getDTsize 
int getDTsize(int type=-1){return(xsGetDataTypeSize(type));}
// xsGetFilePosition -> gFilePos
int gFilePos(){return(xsGetFilePosition());}
// xsSetFilePosition -> sFilePos
bool sFilePos(int byte=0){return(xsSetFilePosition(byte));}
// xsGetFileSize -> gFileSize
int gFileSize(){return(xsGetFileSize());}
// xsOffsetFilePosition -> osFilePos
bool osFilePos(int dtype=0,bool forw=true){return(xsOffsetFilePosition(dtype, forw));}
// xsOpenFile -> openFile
bool openFile(string fname=""){return(xsOpenFile(fname));}
// xsReadFloat -> readFloat
float readFloat(){return(xsReadFloat());}
// xsReadInt -> readInt
int readInt(){return(xsReadInt());}
// xsReadString -> readStr
string readStr(){return(xsReadString());}
// xsReadVector -> readVec
vector readVec(){return(xsReadVector());}
// xsWriteFloat -> wrFloat
bool wrFloat(float data=0){return(xsWriteFloat(data));}
// xsWriteInt -> wrInt
bool wrInt(int data=0){return(xsWriteInt(data));}
// xsWriteString -> wrStr
bool wrStr(string data=""){return(xsWriteString(data));}
// xsWriteVector -> wrVec
bool wrVec(vector data=cOriginVector){return(xsWriteVector(data));}

/// Other Functions ///
// xsGetFunctionID -> funcID
int funcID(string fname=""){return(xsGetFunctionID(fname));}


/// 自定义函数（更新中...） ///
// round: 对实数 x 按照指定的小数位数 n 进行四舍五入
float round(float x=0.0,int n=0){float num=0;float x2=x*pow(10,n);int x2_i=x2; if(abs(x2-x2_i)<0.5){num=1.0*x2_i/pow(10,n);} else{num=1.0*(x2_i+1)/pow(10,n);} return(num);}
// 对浮点数向下取整(exam: floor(0.67)-> -1)
int floor(float x=0.0){return(1*x);}
// 对浮点数向上取整(exam: ceil(0.67)-> 0.0)
int ceil(float x=0.0){int x2=x; if(abs(x-x2)>0){return(x2+1);} return(x2);}
// randInt: 返回区间[low, high)之间的随机整数（不含high）
int randInt(int low=0,int high=0){return(xsGetRandomNumberLH(0,high-low)+low);}
// 将数值转化为bool
bool num2bool(float x=0.0){if(x==0.0){return(false);} return(true);}
// 将数字转化为string
string num2str(int num=0){return(""+num);}
// 将bool转化为数值
int bool2num(bool b=false) {if(b){return(1);} return(0);}
// 输出字符串形式的bool值 {false:"false", true:"true"}
string bool2str(bool b=false){if(b){return("true");} return("false");}

