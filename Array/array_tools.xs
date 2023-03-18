/*  array_tools.xs
                文档说明 ：
    本文档整理了各类与数组和矩阵操作相关的XS函数封装，供玩家使用。
    以下几种形式的函数，有各自不同的用途（以 "func" 代表函数名称），加以说明：
        
        func  : 常规函数（有部分函数的 inplace 参数，决定是否要改变原对象的值，{true: "是", false: "否"} ）
        func_ : 这些函数是对数组或矩阵的“就地”操作，函数运行之后，原操作对象发生更改！
      __func  : 一些管理数组和矩阵的专有函数，通常情况下不调用它们，除非当你有需要时。
    
    被 mutable 关键字修饰的函数，支持以后对其函数体进行重写。
    
    【警告】：形如 "xxx_i" 的全局变量，用于 动态生成 新创建的 数组或矩阵 的名称，不得随意更改，否则后果自负！！！
*/


/// 数组与二维伪数组（矩阵）的基本操作函数封装 ///
// 数学常量
const float epsilon = 0.000001;    // 误差检验常量（用作某些Float参数默认值）
const int Inf = -32768;    // 错误返回值Int
const float PI = 3.1416;    // 圆周率
const float E_ = 2.7183;    // 自然底数 E

const string NULL = "";    // 空字符串常量



/// 常用Array操作函数 起别名（！试用）  ///
/*
// 数组元素赋值 arr[i] = val;
int boolArrSet(int arr_id=-1, int index=-1, bool value_=false)
{return (xsArraySetBool(arr_id, index, value_));}

int intArrSet(int arr_id=-1, int index=-1, int value_=0)
{return (xsArraySetInt(arr_id, index, value_));}

int floatArrSet(int arr_id=-1, int index=-1, float value_=0.0)
{return (xsArraySetFloat(arr_id, index, value_));}

int stringArrSet(int arr_id=-1, int index=-1, string value_=NULL)
{return (xsArraySetString(arr_id, index, value_));}

int vectorArrSet(int arr_id=-1, int index=-1, vector value_=cOriginVector)
{return (xsArraySetVector(arr_id, index, value_));}

// 访问数组元素 arr[i]
bool boolArrGet(int arr_id=-1, int index=-1)
{return (xsArrayGetBool(arr_id, index));}

int intArrGet(int arr_id=-1,  int index=-1)
{return (xsArrayGetInt(arr_id, index));}

float floatArrGet(int arr_id=-1, int index=-1)
{return (xsArrayGetFloat(arr_id, index));}

string stringArrGet(int arr_id=-1, int index=-1)
{return (xsArrayGetString(arr_id, index));}

vector vectorArrGet(int arr_id=-1, int index=-1)
{return (xsArrayGetVector(arr_id, index));}
*/


string __xsArrayGetName(int arr_id=-1) 
{
    /* 根据已注册进 array_list 的数组ID，获取该数组的名称
        参数说明：
          arr_id: 数组ID
          return：string类型，返回数组名称（默认返回NULL）
    */
    if(arr_id > 0) 
    {
        string arr_name = xsArrayGetString(0, arr_id);  // array_list = 0
        if(arr_name == "") {return (NULL);}
        else {return (arr_name);}
    }
    else {xsChatData("Invalid array ID.");}
    return (NULL);
}



/// 一维数组（向量）的基本运算 ///
int farr_temp = 0;
int xsArrayAddNum(int arr_id=-1, float num=0.0, bool inplace=false) 
{
/* 数组与数字相加：
    参数说明：
        arr_id: 数组ID
        num: 加数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    int res_arr = -1;
    if(inplace == false) 
    {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
    else {res_arr = arr_id;}    // inplace = true
    for(idx = 0; < arr_size) 
    {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr_id, idx)+num);}
    return (res_arr);
}

int xsArraySubNum(int arr_id=-1, float num=0.0, bool inplace=false) 
{
/* 数组与数字相减：
    参数说明：
        arr_id: 数组ID
        num: 减数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    int res_arr = -1;
    if(inplace == false) 
    {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
    else {res_arr = arr_id;}    // inplace = true
    for(idx = 0; < arr_size) 
    {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr_id, idx)-num);}
    return (res_arr);
}

int xsArrayMulNum(int arr_id=-1, float num=0.0, bool inplace=false) 
{
/* 数组与数字相乘：
    参数说明：
        arr_id: 数组ID
        num: 乘数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    int res_arr = -1;
    if(inplace == false) 
    {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
    else {res_arr = arr_id;}    // inplace = true
    for(idx = 0; < arr_size) 
    {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr_id, idx)*num);}
    return (res_arr);
}

int xsArrayDivNum(int arr_id=-1, float num=0.0, bool inplace=false) 
{
/* 数组与数字相除：
    参数说明：
        arr_id: 数组ID
        num: 除数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回数组ID （异常返回值 -32768）
*/
    if(num != 0) // 除数不为0时，数组除法才有意义
    {
        int arr_size = xsArrayGetSize(arr_id);
        int res_arr = -1;
        if(inplace == false) 
        {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
        else {res_arr = arr_id;}  // inplace = true
        for(idx = 0; < arr_size) 
        {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr_id, idx)/num);}
        return (res_arr);
    }
    else {xsChatData("Can't divide by 0.");}
    return (Inf);
}

int xsArrayModNum(int arr_id=-1, float num=0.0, bool inplace=false) 
{
/* 数组元素与数字取余[%]：
    参数说明：
        arr_id: 数组ID
        num: 整除除数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回数组ID （异常返回值 -32768）
*/
    if(num != 0) // 整除除数不为0时，数组元素取余才有意义
    {
        int arr_size = xsArrayGetSize(arr_id);
        int res_arr = -1;
        int mod_num = 0;
        if(inplace == false) 
        {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
        else {res_arr = arr_id;}  // inplace = true
        for(idx = 0; < arr_size) 
        {
            mod_num = xsArrayGetFloat(arr_id, idx) % num;
            xsArraySetFloat(res_arr, idx, mod_num);
        }
        return (res_arr);
    }
    else {xsChatData("Can't int-divide by 0.");}
    return (Inf);
}

int xsArraysAdd(int arr1_id=-1, int arr2_id=-1) 
{
/* 数组加法运算：
    参数说明：
      arr1_id: 数组1的ID
      arr2_id: 数组2的ID
      res_arr: 运算结果的数组ID
      返回值：int类型，返回结果数组ID （默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    int res_arr = -1;
    if(arr1_size == arr2_size) 
    {// 若俩数组的长度相等，进行数组元素相加
        res_arr = xsArrayCreateFloat(arr1_size, 0.0, "arr_add"+farr_temp); farr_temp++;
        for(idx = 0; < arr1_size) 
        {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr1_id, idx) + xsArrayGetFloat(arr2_id, idx));}
        // 返回结果数组的ID
        return (res_arr);
    }
    else {xsChatData("array1.size don't equal to array2.size.");}
    return (Inf);
}

int xsArraysSub(int arr1_id=-1, int arr2_id=-1, int res_arr=-1) 
{
/* 数组减法运算：
    参数说明：
        arr1_id: 数组1的ID
        arr2_id: 数组2的ID
        res_arr: 运算结果的数组ID
        返回值：int类型，返回结果数组ID （默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    
    if(arr1_size == arr2_size) // 若两数组长度相等，进行数组元素相减
    {
        res_arr = xsArrayCreateFloat(arr1_size, 0.0, "arr_sub"+farr_temp); farr_temp++;
        for(idx = 0; < arr1_size) 
        {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr1_id, idx) - xsArrayGetFloat(arr2_id, idx));}
        return (res_arr);
    }
    else {xsChatData("array1.size don't equal to array2.size.");}
    return (Inf);
}

int xsArraysMul(int arr1_id=-1, int arr2_id=-1, int res_arr=-1) 
{
/* 数组逐元素乘法：每个数组中对应位置的元素相乘
    参数说明：
        arr1_id: 数组1的ID
        arr2_id: 数组2的ID
        res_arr: 结果的数组ID
        返回值：int类型，返回结果数组ID （默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    if(arr1_size == arr2_size)    // 若俩数组的长度相等，进行乘法运算
    {
        res_arr = xsArrayCreateFloat(arr1_size, 0.0, "arr_mul"+farr_temp); farr_temp++;
        for(idx = 0; < arr1_size) 
        {xsArraySetFloat(res_arr, idx, xsArrayGetFloat(arr1_id, idx) * xsArrayGetFloat(arr2_id, idx));}
        return (res_arr);
    }
    else {xsChatData("array1.size don't equal to array2.size.");}
    return (Inf);
}

int xsArraysDiv(int arr1_id=-1, int arr2_id=-1, int res_arr=-1) 
{
/* 数组逐元素除法：每个数组中对应位置的元素相除
    参数说明：
        arr1_id: 数组1的ID
        arr2_id: 数组2的ID
        res_arr: 运算结果的数组ID
        返回值：int类型，返回结果数组ID （默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    if(arr1_size == arr2_size)    // 若俩数组的长度相等，进行除法运算
    {
        for(idx = 0; < arr2_size) 
        {
            if(xsArrayGetFloat(arr2_id, idx) == 0) 
            {xsChatData("Can't divide by 0."); return(Inf);}
        }
        
        res_arr = xsArrayCreateFloat(arr1_size, 0.0, "arr_mul"+farr_temp); farr_temp++;
        for(idx2 = 0; < arr1_size) 
        {xsArraySetFloat(res_arr, idx2, xsArrayGetFloat(arr1_id, idx2) * xsArrayGetFloat(arr2_id, idx2));}
        return (res_arr);
    }
    else {xsChatData("array1.size don't equal to array2.size.");}
    return (Inf);
}

int xsArrayPower(int arr_id=-1, int n=1, bool inplace=false) 
{
/* 数组元素的幂指数运算：
    参数说明：
        arr_id: 数组ID
        n: 幂指数
        inplace: 是否对原数组进行更改。{true: "对原数组进行更改", false: "不对原数组进行更改"}
        返回值：int类型，返回结果数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    int res_arr = -1;
    if(inplace == false) 
    {res_arr = xsArrayCreateFloat(arr_size, 0.0, "res_arr"+farr_temp); farr_temp++;}
    else {res_arr = arr_id;}    // inplace = true
    float e = 0.0;
    for(idx = 0; < arr_size) 
    {
        e = xsArrayGetFloat(arr_id, idx);
        xsArraySetFloat(res_arr, idx, pow(e, n));
    }
    return (res_arr);
}

float xsArraysDot(int arr1_id=-1, int arr2_id=-1) 
{
/* 数组的点乘(内积)：arr1.dot(arr2) = arr1[0]*arr2[0] + arr1[1]*arr2[1] + ... + arr1[n]*arr2[n]
    参数说明：
        arr1_id: 数组1的ID
        arr2_id: 数组2的ID
        返回值：float类型，返回计算结果（默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    if(arr1_size == arr2_size) // 若俩数组的长度相等，进行点乘运算
    {
        float dot = 0.0;
        for(idx = 0; < arr1_size) 
        {dot = dot + (xsArrayGetFloat(arr1_id, idx) * xsArrayGetFloat(arr2_id, idx));}
        return (dot);
    }
    else {xsChatData("array1.size don't equal to array2.size.");}
    return (1.0*Inf);
}

int xsArraysProduct(int arr1_id=-1, int arr2_id=-1, int res_arr=-1) // [2,-1,5] x [3,8,0]
{
/* 数组的叉乘(外积)：A1xA2 = (A1[1]*A2[2]-A2[1]*A1[2], A1[2]*A2[0]-A2[2]*A1[0], A1[[0]*A2[1]-A2[0]*A1[1])
    参数说明：
        arr1_id: 数组1的ID
        arr2_id: 数组2的ID
        res_arr: 结果数组的ID
        返回值：float类型，返回计算结果（默认返回 -32768）
*/
    int arr1_size = xsArrayGetSize(arr1_id);
    int arr2_size = xsArrayGetSize(arr2_id);
    if(arr1_size == 3 && arr2_size == 3) 
    {// 若俩数组的长度都等于3，进行叉乘运算
        res_arr = xsArrayCreateFloat(3, 0.0, "arr_prod"+farr_temp); farr_temp++;
        float prod_x = xsArrayGetFloat(arr1_id, 1)*xsArrayGetFloat(arr2_id, 2) - xsArrayGetFloat(arr2_id, 1)*xsArrayGetFloat(arr1_id, 2);
        float prod_y = xsArrayGetFloat(arr1_id, 2)*xsArrayGetFloat(arr2_id, 0) - xsArrayGetFloat(arr2_id, 2)*xsArrayGetFloat(arr1_id, 0);
        float prod_z = xsArrayGetFloat(arr1_id, 0)*xsArrayGetFloat(arr2_id, 1) - xsArrayGetFloat(arr2_id, 0)*xsArrayGetFloat(arr1_id, 1);
        xsArraySetFloat(res_arr, 0, prod_x);
        xsArraySetFloat(res_arr, 1, prod_y);
        xsArraySetFloat(res_arr, 2, prod_z);
        return (res_arr);
    }
    else {xsChatData("The array's dimonsion must equal to 3.");}
    return (Inf);
}

int piece_i = 0;  // 切片序号
int xsArrayPiece(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{
/* 返回指定数组索引在 [start_idx, end_idx) 区间的切片
    参数说明：
        arr_id: 数组ID
        start_idx: 切片起始索引（包含）
        end_idx: 切片结束索引（不包含）
        返回值：int类型，返回切片ID
*/
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = xsArrayGetSize(arr_id)-1;}
    
    int piece_len = end_idx - start_idx;
    int piece = xsArrayCreateFloat(piece_len, 0.0, "piece"+piece_i); piece_i++;
    for(idx = 0; < piece_len) 
    {xsArraySetFloat(piece, idx, xsArrayGetFloat(arr_id, idx + start_idx));}
    return (piece);
}

int xsIntArrayChoice(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{// 随机选择则整型数组在索引区间 [start_idx, end_idx) 中的1个元素
    int arr_size = xsArrayGetSize(arr_id);
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = arr_size - 1;}
    int rand_i = xsGetRandomNumberLH(start_idx, end_idx+1) + start_idx;
    int rand_e = xsArrayGetInt(arr_id, rand_i);
    return (rand_e);
}

float xsFloatArrayChoice(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{// 随机选择则浮点型数组在索引区间 [start_idx, end_idx) 中的1个元素
    int arr_size = xsArrayGetSize(arr_id);
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = arr_size - 1;}
    int rand_i = xsGetRandomNumberLH(start_idx, end_idx+1) + start_idx;
    float rand_e = xsArrayGetFloat(arr_id, rand_i);
    return (rand_e);
}

bool xsBoolArrayChoice(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{// 随机选择则布尔型数组在索引区间 [start_idx, end_idx) 中的1个元素
    int arr_size = xsArrayGetSize(arr_id);
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = arr_size - 1;}
    int rand_i = xsGetRandomNumberLH(start_idx, end_idx+1) + start_idx;
    bool rand_e = xsArrayGetBool(arr_id, rand_i);
    return (rand_e);
}

string xsStringtArrayChoice(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{// 随机选择则字符型数组在索引区间 [start_idx, end_idx) 中的1个元素
    int arr_size = xsArrayGetSize(arr_id);
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = arr_size - 1;}
    int rand_i = xsGetRandomNumberLH(start_idx, end_idx+1) + start_idx;
    string rand_e = xsArrayGetString(arr_id, rand_i);
    return (rand_e);
}

vector xsVectorArrayChoice(int arr_id=-1, int start_idx=-1, int end_idx=-1) 
{// 随机选择则vector型数组在索引区间 [start_idx, end_idx) 中的1个元素
    int arr_size = xsArrayGetSize(arr_id);
    if(start_idx == -1) {start_idx = 0;}
    if(end_idx == -1) {end_idx = arr_size - 1;}
    int rand_i = xsGetRandomNumberLH(start_idx, end_idx+1) + start_idx;
    vector rand_e = xsArrayGetVector(arr_id, rand_i);
    return (rand_e);
}

mutable 
float xsArrayMax(int arr_id=-1) 
{
/* 返回数组中元素的最大值
    参数说明：
        arr_id: 数组ID
        返回值：float类型，最大值的元素
*/
    int arr_size = xsArrayGetSize(arr_id);
    float max_ = xsArrayGetFloat(arr_id, 0);  // 以arr[0]的元素作为起始比较元素
    float x = 0.0;
    for(i = 0; < arr_size) 
    {
        x = xsArrayGetFloat(arr_id, i);
        if(x > max_) {max_ = x ;}
    }
    return (max_);
}

mutable 
float xsArrayMin(int arr_id=-1) 
{
/* 返回数组中元素的最小值
    参数说明：
        arr_id: 数组ID
        返回值：float类型，最小值的元素
*/
    int arr_size = xsArrayGetSize(arr_id);
    float min_ = xsArrayGetFloat(arr_id, 0);  // 以arr[0]的元素作为起始比较元素
    float x = 0.0;
    for(i = 0; < arr_size) 
    {
        x = xsArrayGetFloat(arr_id, i);
        if(x < min_) {min_ = x ;}
    }
    return (min_);
}

mutable 
float xsArraySum(int arr_id=-1) 
{
/* 对数组元素求和：
    参数说明：
        arr_id: 数组ID
        返回值：float类型，数组中各元素之和
*/
    int arr_size = xsArrayGetSize(arr_id);
    float sum_ = 0.0;
    for(i = 0; < arr_size) 
    {sum_ = sum_ + xsArrayGetFloat(arr_id, i);}
    return (sum_);
}

mutable 
float xsArrayMean(int arr_id=-1) 
{
/* 求数组元素的均值：
    参数说明：
        arr_id: 数组ID
        返回值：float类型，数组中各元素的均值
*/
    int arr_size = xsArrayGetSize(arr_id);
    float sum_ = 0.0;
    for(i = 0; < arr_size) 
    {sum_ = sum_ + xsArrayGetFloat(arr_id, i);}
    //float mean_ = sum_/arr_size ;
    return (sum_/arr_size);
}

mutable 
float xsArrayVariance(int arr_id=-1) 
{
/* 求数组元素的方差：S2 = 1/N * [pow(x1 - x_mean, 2) + pow(x2 - x_mean, 2) + ... + pow(xN - x_mean, 2)]
    参数说明：
        arr_id: 数组ID
        返回值：float类型，数组元素的方差
*/
    int arr_size = xsArrayGetSize(arr_id);
    float x_mean = xsArrayMean(arr_id);
    float x_i = 0.0;
    
    float S2 = 0.0;
    for(i = 0; < arr_size) 
    {
        x_i = xsArrayGetFloat(arr_id, i);
        S2 = S2 + pow(x_i-x_mean, 2);
    }
    S2 = S2 / arr_size;
    return (S2);
}

int xsArrayResize_(int arr_id=-1, string dtype="float", int n=0) 
{
/* 数组长度的伸缩变换：arr_size (m -> n)
    参数说明：
        arr_id: 数组ID
        n: 要进行延伸的长度。n>0 代表扩充数组；n<0 代表收缩数组；n=0 则保持长度不变
        返回值：int类型，伸缩变换后的数组ID （异常返回 -32768）
*/
    // 若 n=0，返回原数组ID
    if(n == 0) {return (arr_id);}

    int old_size = xsArrayGetSize(arr_id);
    int new_size = old_size + n;
    if(new_size > 0) 
    {
        if(dtype == "float") {xsArrayResizeFloat(arr_id, new_size);}
        else if(dtype == "int") {xsArrayResizeInt(arr_id, new_size);}
        else if(dtype == "bool") {xsArrayResizeBool(arr_id, new_size);}
        else if(dtype == "string") {xsArrayResizeString(arr_id, new_size);}
        else if(dtype == "vector") {xsArrayResizeVector(arr_id, new_size);}
        else {xsChatData("Invalid dtype of the array."); return(Inf);}
    }
    else //new_size <= 0
    {
        xsChatData("Can't resize to Array("+arr_id+") with size=%d.", new_size);
        return (Inf);
    }
    return (arr_id);
}

void xsIntArrayAppend_(int arr_id=-1, int val_=0) 
{// 数组的append操作：在整型数组末尾新增一个元素
    int arr_size = xsArrayGetSize(arr_id);
    xsArrayResizeInt(arr_id, arr_size+1);
    xsArraySetInt(arr_id, arr_size, val_);
}

void xsFloatArrayAppend_(int arr_id=-1, float val_=0.0) 
{// 数组的append操作：在浮点型数组末尾新增一个元素
    int arr_size = xsArrayGetSize(arr_id);
    xsArrayResizeFloat(arr_id, arr_size+1);
    xsArraySetFloat(arr_id, arr_size, val_);
}

void xsBoolArrayAppend_(int arr_id=-1, bool val_=false) 
{// 数组的append操作：在布尔型数组末尾新增一个元素
    int arr_size = xsArrayGetSize(arr_id);
    xsArrayResizeBool(arr_id, arr_size+1);
    xsArraySetBool(arr_id, arr_size, val_);
}

void xsStringArrayAppend_(int arr_id=-1, string val_="") 
{// 数组的append操作：在字符串型数组末尾新增一个元素
    int arr_size = xsArrayGetSize(arr_id);
    xsArrayResizeString(arr_id, arr_size+1);
    xsArraySetString(arr_id, arr_size, val_);
}

void xsVectorArrayAppend_(int arr_id=-1, vector val_=cOriginVector) 
{// 数组的append操作：在vector型数组末尾新增一个元素
    int arr_size = xsArrayGetSize(arr_id);
    xsArrayResizeVector(arr_id, arr_size+1);
    xsArraySetVector(arr_id, arr_size, val_);
}

void xsIntArrayClear_(int arr_id=-1, int new_size=1) 
{// 清空数组：重置整型数组的元素为默认值0，并将长度设置为 new_size
    int arr_size = xsArrayGetSize(arr_id);
    for(idx = 0; < arr_size) {xsArraySetInt(arr_id, idx, 0);}
    xsArrayResizeInt(arr_id, new_size);
}

void xsFloatArrayClear_(int arr_id=-1, int new_size=1) 
{// 清空数组：重置浮点型数组的元素为默认值0.0，并将长度设置为 new_size
    int arr_size = xsArrayGetSize(arr_id);
    for(idx = 0; < arr_size) {xsArraySetFloat(arr_id, idx, 0.0);}
    xsArrayResizeFloat(arr_id, new_size);
}

void xsBoolArrayClear_(int arr_id=-1, int new_size=1) 
{// 清空数组：重置布尔型数组的元素为默认值false，并将长度设置为 new_size
    int arr_size = xsArrayGetSize(arr_id);
    for(idx = 0; < arr_size) {xsArraySetBool(arr_id, idx, false);}
    xsArrayResizeBool(arr_id, new_size);
}

void xsStringArrayClear_(int arr_id=-1, int new_size=1) 
{// 清空数组：重置字符型数组的元素为默认值""，并将长度设置为 new_size
    int arr_size = xsArrayGetSize(arr_id);
    for(idx = 0; < arr_size) {xsArraySetString(arr_id, idx, "");}
    xsArrayResizeString(arr_id, new_size);
}

void xsVectorArrayClear_(int arr_id=-1, int new_size=1) 
{// 清空数组：重置向量型数组的元素为默认值(0,0,0)，并将长度设置为 new_size
    int arr_size = xsArrayGetSize(arr_id);
    for(idx = 0; < arr_size) {xsArraySetVector(arr_id, idx, cOriginVector);}
    xsArrayResizeVector(arr_id, new_size);
}

int num_arr_i = 0;
int xsGetNumbersE(int number=0) 
{// 取出一个多位数中每一位上的数，存入数组
    int num_arr = xsArrayCreateInt(1, -1, "num_arr"+num_arr_i); num_arr_i++;
    int arr_size = 1;   // 数组初始长度
    int div_num = 1;    // 除数初始值
    int val_ = -1;    // 缓存number在idx处的数值
    while(number >= div_num) {
        val_ = floor(number%(10*div_num)/div_num);
        xsArrayResizeInt(num_arr, arr_size+1); arr_size++;
        xsArraySetInt(num_arr, arr_size-1, val_);
        div_num = 10 * div_num;
    }
    // 反转数组元素
    int idx1 = 0; 
    int idx2 = xsArrayGetSize(num_arr)-1;
    float swap1 = 0.0; float swap2 = 0.0;    // 缓存要交换索引处的元素
    while(idx1 < idx2) {
        swap1 = xsArrayGetInt(num_arr, idx1);
        swap2 = xsArrayGetInt(num_arr, idx2);
        xsArraySetInt(num_arr, idx1, swap2);
        xsArraySetInt(num_arr, idx2, swap1);
        idx1++; idx2--;
    }
    xsArrayResizeInt(num_arr, arr_size-1);  // 去掉末尾的无效元素：-1
    return (num_arr);
}

int rev_arr_i = 0;
int xsReverseIntArray(int arr_id=-1, bool inplace=false) 
{
/* 反转int数组中的元素排列顺序：swap(arr[0],arr[len-1]), swap(arr[1],arr[len-2]) ...
    参数说明：
      arr_id: 数组ID
      dtype : 数组数据类型
      inplace: false
      return: int类型，返回数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    int e1 = 0; int e2 = 0;
    int idx1 = 0; int idx2 = arr1_size-1;
    if(inplace == false) // 新建数组，存储反转后的数组元素
    {
        int rev_arr = xsArrayCreateInt(arr_size, 0, "rev_iarr"+rev_arr_i); rev_arr_i++;
        while(idx1 < idx2) {
            e1 = xsArrayGetInt(arr_id, idx1);
            e2 = xsArrayGetInt(arr_id, idx2);
            xsArraySetInt(rev_arr, idx1, e2);
            xsArraySetInt(rev_arr, idx2, e1);
            idx1++; idx2--; 
        }
        return (rev_arr);
    }
    else if(inplace == true) 
    {// 对原数组反转数组元素，就地更改
        while(idx1 < idx2) {
            e1 = xsArrayGetInt(arr_id, idx1);
            e2 = xsArrayGetInt(arr_id, idx2);
            xsArraySetInt(arr_id, idx1, e2);
            xsArraySetInt(arr_id, idx2, e1);
            idx1++; idx2--; 
        }
    }
    return (arr_id);
}

int xsReverseFloatArray(int arr_id=-1, bool inplace=false) 
{
/* 反转float数组中的元素排列顺序：swap(arr[0],arr[len-1]), swap(arr[1],arr[len-2]) ...
    参数说明：
      arr_id: 数组ID
      dtype : 数组数据类型
      inplace: false
      return: int类型，返回数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    float e1 = 0; float e2 = 0;
    int idx1 = 0; int idx2 = arr1_size-1;
    if(inplace == false) // 新建数组，存储反转后的数组元素
    {
        int rev_arr = xsArrayCreateFloat(arr_size, 0.0, "rev_farr"+rev_arr_i); rev_arr_i++;
        while(idx1 < idx2) {
            e1 = xsArrayGetFloat(arr_id, idx1);
            e2 = xsArrayGetFloat(arr_id, idx2);
            xsArraySetFloat(rev_arr, idx1, e2);
            xsArraySetFloat(rev_arr, idx2, e1);
            idx1++; idx2--; 
        }
        return (rev_arr);
    }
    else if(inplace == true) 
    {// 对原数组反转数组元素，就地更改
        while(idx1 < idx2) {
            e1 = xsArrayGetFloat(arr_id, idx1);
            e2 = xsArrayGetFloat(arr_id, idx2);
            xsArraySetFloat(arr_id, idx1, e2);
            xsArraySetFloat(arr_id, idx2, e1);
            idx1++; idx2--; 
        }
    }
    return (arr_id);
}

mutable 
int xsArrayBubbleSortInt(int arr_id=-1, string sort_way="ASC", bool inplace=false, int temp_arr_id=3) 
{
/* 对整型数组元素进行排序（冒泡排序法）
    参数说明：
        arr_id: 要排序的数组ID
        sort_way: 排序方式。可能的取值情况：{"ASC": 升序排列, "DESC": 降序排列}
        inplace: 是否在原数组上进行操作。false代表创建新数组存储排序后的数据，true表示在原数组上进行排序操作
        temp_arr_id: [Optional]，暂存数组的ID，默认值 3
        return：int类型，返回排序结果的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        int e_swap1 = 0;
        int e_swap2 = 0;
        
        if(inplace == false) 
        {
            xsIntArrayClear_(temp_arr_id, arr_size);
            for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
            {xsArraySetInt(temp_arr_id, idx, xsArrayGetInt(arr_id, idx));}
            for(i = 0; < arr_size-1) // 排序轮数 = 元素个数 - 1
            {
                for(j=0; < arr_size-i-1) 
                {
                    if(
                        (sort_way == "ASC" ) && (xsArrayGetInt(temp_arr_id, j) > xsArrayGetInt(temp_arr_id, j+1)) ||
                        (sort_way == "DESC") && (xsArrayGetInt(temp_arr_id, j) < xsArrayGetInt(temp_arr_id, j+1)) 
                    ) 
                    {// 如果 temp_arr[j] > temp_arr[j+1]，则交换这2个元素的值
                        e_swap1 = xsArrayGetInt(temp_arr_id, j);
                        e_swap2 = xsArrayGetInt(temp_arr_id, j+1);
                        xsArraySetInt(temp_arr_id, j  , e_swap2);
                        xsArraySetInt(temp_arr_id, j+1, e_swap1);
                    }
                }
            }
            return (temp_arr_id);
        }
        else if(inplace == true) 
        {
            for(i = 0; < arr_size-1) // 排序轮数 = 元素个数 - 1
            {
                for(j=0; < arr_size-i-1) 
                {
                    if(
                        (sort_way == "ASC" ) && (xsArrayGetInt(arr_id, j) > xsArrayGetInt(arr_id, j+1)) ||
                        (sort_way == "DESC") && (xsArrayGetInt(arr_id, j) < xsArrayGetInt(arr_id, j+1)) 
                    ) 
                    {// 如果 arr[j] > arr[j+1]，则交换这2个元素的值
                        e_swap1 = xsArrayGetInt(arr_id, j);
                        e_swap2 = xsArrayGetInt(arr_id, j+1);
                        xsArraySetInt(arr_id, j  , e_swap2);
                        xsArraySetInt(arr_id, j+1, e_swap1);
                    }
                }
            }
            return (arr_id);
        }
        else {}
    }
    return (arr_id);
}

mutable 
int xsArrayBubbleSortFloat(int arr_id=-1, string sort_way="ASC", bool inplace=false, int temp_arr_id=5) 
{
/* 对浮点型数组元素进行排序（冒泡排序法）
    参数说明：
        arr_id: 要排序的数组ID
        sort_way: 排序方式。可能的取值情况：{"ASC": 升序排列, "DESC": 降序排列}
        inplace: 是否在原数组上进行操作。false代表创建新数组存储排序后的数据，true表示在原数组上进行排序操作
        temp_arr_id: [Optional]，暂存数组的ID，默认值 5
        return：float类型，返回排序结果的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        float e_swap1 = 0.0;
        float e_swap2 = 0.0;
        
        if(inplace == false) 
        {
            xsFloatArrayClear_(temp_arr_id, arr_size);
            for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
            {xsArraySetFloat(temp_arr_id, idx, xsArrayGetFloat(arr_id, idx));}
            for(i = 0; < arr_size-1) // 排序轮数 = 元素个数 - 1
            {
                for(j=0; < arr_size-i-1) 
                {
                    if(
                        (sort_way == "ASC" ) && (xsArrayGetFloat(temp_arr_id, j) > xsArrayGetFloat(temp_arr_id, j+1)) ||
                        (sort_way == "DESC") && (xsArrayGetFloat(temp_arr_id, j) < xsArrayGetFloat(temp_arr_id, j+1)) 
                    ) 
                    {// 如果 temp_arr[j] > temp_arr[j+1]，则交换这2个元素的值
                        e_swap1 = xsArrayGetFloat(temp_arr_id, j);
                        e_swap2 = xsArrayGetFloat(temp_arr_id, j+1);
                        xsArraySetFloat(temp_arr_id, j  , e_swap2);
                        xsArraySetFloat(temp_arr_id, j+1, e_swap1);
                    }
                }
            }
            return (temp_arr_id);
        }
        else if(inplace == true) 
        {
            for(i = 0; < arr_size-1) // 排序轮数 = 元素个数 - 1
            {
                for(j=0; < arr_size-i-1) 
                {
                    if(
                        (sort_way == "ASC" ) && (xsArrayGetFloat(arr_id, j) > xsArrayGetFloat(arr_id, j+1)) ||
                        (sort_way == "DESC") && (xsArrayGetFloat(arr_id, j) < xsArrayGetFloat(arr_id, j+1)) 
                    ) 
                    {// 如果 arr[j] > arr[j+1]，则交换这2个元素的值
                        e_swap1 = xsArrayGetFloat(arr_id, j);
                        e_swap2 = xsArrayGetFloat(arr_id, j+1);
                        xsArraySetFloat(arr_id, j  , e_swap2);
                        xsArraySetFloat(arr_id, j+1, e_swap1);
                    }
                }
            }
            return (arr_id);
        }
        else {}
    }
    return (arr_id);
}

mutable 
int xsArraySelectSortInt(int arr_id=-1, string sort_way="ASC", bool inplace=false, int temp_arr_id=3) 
{
/* 对整型数组元素进行排序（选择排序法）
    参数说明：
        arr_id: 要排序的数组ID
        sort_way: 排序方式。可能的取值情况：{"ASC": 升序排列, "DESC": 降序排列}
        inplace: 是否在原数组上进行操作。false代表创建新数组存储排序后的数据，true表示在原数组上进行排序操作
        temp_arr_id: [Optional]，暂存数组的ID，默认值 3
        return：int类型，返回排序结果的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        int e_swap1 = 0;
        int e_swap2 = 0;
        int min_idx = 0;
        
        if(inplace == false) 
        {
            xsIntArrayClear_(temp_arr_id, arr_size);
            //xsArrayResizeInt(temp_arr_id, arr_size);
            for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
            {xsArraySetInt(temp_arr_id, idx, xsArrayGetInt(arr_id, idx));}
            for(i = 0; < arr_size) 
            {//寻找 [i, arr_size) 区间里的最小值
                min_idx = i;
                for(j=i+1; < arr_size) 
                {
                    // if (arr[j] < arr[min_idx])
                    if((sort_way == "ASC") && (xsArrayGetInt(temp_arr_id, j) < xsArrayGetInt(temp_arr_id, min_idx))) {min_idx = j;}
                    // if (arr[j] > arr[min_idx])
                    else if((sort_way == "DESC") && (xsArrayGetInt(temp_arr_id, j) > xsArrayGetInt(temp_arr_id, min_idx))) {min_idx = j;}
                }
                // 交换 arr[i] 和 arr[min_idx] 的元素值
                e_swap1 = xsArrayGetInt(temp_arr_id, i);
                e_swap2 = xsArrayGetInt(temp_arr_id, min_idx);
                xsArraySetInt(temp_arr_id, i, e_swap2);
                xsArraySetInt(temp_arr_id, min_idx, e_swap1);
            }
            return (temp_arr_id);
        }
        else if(inplace == true) 
        {
            for(i = 0; < arr_size) 
            {//寻找 [i, arr_size) 区间里的最小值
                min_idx = i;
                for(j=i+1; < arr_size) 
                {
                    // if (arr[j] < arr[min_idx])
                    if((sort_way == "ASC") && (xsArrayGetInt(arr_id, j) < xsArrayGetInt(arr_id, min_idx))) {min_idx = j;}
                    // if (arr[j] > arr[min_idx])
                    else if((sort_way == "DESC") && (xsArrayGetInt(arr_id, j) > xsArrayGetInt(arr_id, min_idx))) {min_idx = j;}
                    else {}
                }
                // 交换 arr[i] 和 arr[min_idx] 的元素值
                e_swap1 = xsArrayGetInt(arr_id, i);
                e_swap2 = xsArrayGetInt(arr_id, min_idx);
                xsArraySetInt(arr_id, i, e_swap2);
                xsArraySetInt(arr_id, min_idx, e_swap1);
            }
            return (arr_id);
        }
        else {}
    }
    return (arr_id);
}

mutable 
int xsArraySelectSortFloat(int arr_id=-1, string sort_way="ASC", bool inplace=false, int temp_arr_id=5) 
{
/* 对浮点型数组元素进行排序（选择排序法）
    参数说明：
        arr_id: 要排序的数组ID
        sort_way: 排序方式。可能的取值情况：{"ASC": 升序排列, "DESC": 降序排列}
        inplace: 是否在原数组上进行操作。false代表创建新数组存储排序后的数据，true表示在原数组上进行排序操作
        temp_arr_id: [Optional]，暂存数组的ID，默认值 5
        return：float类型，返回排序结果的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        float e_swap1 = 0.0;
        float e_swap2 = 0.0;
        int min_idx = 0;
        
        if(inplace == false) 
        {
            xsFloatArrayClear_(temp_arr_id, arr_size);
            //xsArrayResizeFloat(temp_arr_id, arr_size);
            for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
            {xsArraySetFloat(temp_arr_id, idx, xsArrayGetFloat(arr_id, idx));}
            for(i = 0; < arr_size) 
            {//寻找 [i, arr_size) 区间里的最小值
                min_idx = i;
                for(j=i+1; < arr_size) 
                {
                    // if (arr[j] < arr[min_idx])
                    if((sort_way == "ASC") && (xsArrayGetFloat(temp_arr_id, j) < xsArrayGetFloat(temp_arr_id, min_idx))) {min_idx = j;}
                    // if (arr[j] > arr[min_idx])
                    else if((sort_way == "DESC") && (xsArrayGetFloat(temp_arr_id, j) > xsArrayGetFloat(temp_arr_id, min_idx))) {min_idx = j;}
                }
                // 交换 arr[i] 和 arr[min_idx] 的元素值
                e_swap1 = xsArrayGetFloat(temp_arr_id, i);
                e_swap2 = xsArrayGetFloat(temp_arr_id, min_idx);
                xsArraySetFloat(temp_arr_id, i, e_swap2);
                xsArraySetFloat(temp_arr_id, min_idx, e_swap1);
            }
            return (temp_arr_id);
        }
        else if(inplace == true) 
        {
            for(i = 0; < arr_size) 
            {//寻找 [i, arr_size) 区间里的最小值
                min_idx = i;
                for(j=i+1; < arr_size) 
                {
                    // if (arr[j] < arr[min_idx])
                    if((sort_way == "ASC") && (xsArrayGetFloat(arr_id, j) < xsArrayGetFloat(arr_id, min_idx))) {min_idx = j;}
                    // if (arr[j] > arr[min_idx])
                    else if((sort_way == "DESC") && (xsArrayGetFloat(arr_id, j) > xsArrayGetFloat(arr_id, min_idx))) {min_idx = j;}
                    else {}
                }
                // 交换 arr[i] 和 arr[min_idx] 的元素值
                e_swap1 = xsArrayGetFloat(arr_id, i);
                e_swap2 = xsArrayGetFloat(arr_id, min_idx);
                xsArraySetFloat(arr_id, i, e_swap2);
                xsArraySetFloat(arr_id, min_idx, e_swap1);
            }
            return (arr_id);
        }
        else {}
    }
    return (arr_id);
}

mutable 
int xsArgSortInt(int arr_id=-1, string sort_way="ASC", int args_id=4, int temp_arr_id=3) 
{
/*
    对整型数组元素按照指定的方式进行排序，返回排序后元素的 argsort
    参数说明：
      arr_id: 要排序的原数组的ID
      sort_way: 排序方式：{"ASC": 升序排列, "DESC": 降序排列 }
      args_id:  argsort的ID
      temp_arr_id: 暂存排序元素的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        int e_swap1 = 0;
        int e_swap2 = 0;
        int min_idx = 0;
        
        xsIntArrayClear_(temp_arr_id, arr_size);
        for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
        {xsArraySetInt(temp_arr_id, idx, xsArrayGetInt(arr_id, idx));}
        // 元素排序
        for(i = 0; < arr_size) 
        {//寻找 [i, arr_size) 区间里的最小值
            min_idx = i;
            for(j=i+1; < arr_size) 
            {
                // if (arr[j] < arr[min_idx])
                if((sort_way == "ASC") && (xsArrayGetInt(temp_arr_id, j) < xsArrayGetInt(temp_arr_id, min_idx))) {min_idx = j;}
                // if (arr[j] > arr[min_idx])
                else if((sort_way == "DESC") && (xsArrayGetInt(temp_arr_id, j) > xsArrayGetInt(temp_arr_id, min_idx))) {min_idx = j;}
                else {}
            }
            // 交换 arr[i] 和 arr[min_idx] 的元素值
            e_swap1 = xsArrayGetInt(temp_arr_id, i);
            e_swap2 = xsArrayGetInt(temp_arr_id, min_idx);
            xsArraySetInt(temp_arr_id, i, e_swap2);
            xsArraySetInt(temp_arr_id, min_idx, e_swap1);
        }
        // 计算 argsort
        xsIntArrayClear_(args_id, arr_size);
        int arg_e1 = 0; int arg_e2 = 0;
        for(m = 0; < arr_size) 
        {
            arg_e1 = xsArrayGetInt(temp_arr_id, m);
            for(n = 0; < arr_size) 
            {// 若 temp_arr_id[m] = arr_id[n]，则使得 args_id[m] = n
                arg_e2 = xsArrayGetInt(arr_id, n);
                if(arg_e1 == arg_e2) // {xsChatData("sort_arr["+m+"] == arr["+n+"]");}
                {xsArraySetInt(args_id, m, n);}
            }
        }
        return (args_id);
    }
    else if(arr_size == 1) 
    {
        xsIntArrayClear_(args_id);
        return (args_id);
    }
    return (Inf);
}

mutable 
int xsArgSortFloat(int arr_id=-1, string sort_way="ASC", int args_id=6, int temp_arr_id=5) 
{
/*
    对浮点型数组元素按照指定的方式进行排序，返回排序后元素的 argsort
    参数说明：
      arr_id: 要排序的原数组的ID
      sort_way: 排序方式：{"ASC": 升序排列, "DESC": 降序排列 }
      args_id:  argsort的ID
      temp_arr_id: 暂存排序元素的数组ID
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size > 1) 
    {
        float e_swap1 = 0.0;
        float e_swap2 = 0.0;
        int min_idx = 0;
        
        xsFloatArrayClear_(temp_arr_id, arr_size);
        for(idx = 0; < arr_size) // copy(arr_id.data) -> temp_arr_id.data
        {xsArraySetFloat(temp_arr_id, idx, xsArrayGetFloat(arr_id, idx));}
        // 元素排序
        for(i = 0; < arr_size) 
        {//寻找 [i, arr_size) 区间里的最小值
            min_idx = i;
            for(j=i+1; < arr_size) 
            {
                // if (arr[j] < arr[min_idx])
                if((sort_way == "ASC") && (xsArrayGetFloat(temp_arr_id, j) < xsArrayGetFloat(temp_arr_id, min_idx))) {min_idx = j;}
                // if (arr[j] > arr[min_idx])
                else if((sort_way == "DESC") && (xsArrayGetFloat(temp_arr_id, j) > xsArrayGetFloat(temp_arr_id, min_idx))) {min_idx = j;}
                else {}
            }
            // 交换 arr[i] 和 arr[min_idx] 的元素值
            e_swap1 = xsArrayGetFloat(temp_arr_id, i);
            e_swap2 = xsArrayGetFloat(temp_arr_id, min_idx);
            xsArraySetFloat(temp_arr_id, i, e_swap2);
            xsArraySetFloat(temp_arr_id, min_idx, e_swap1);
        }
        // 计算 argsort
        xsIntArrayClear_(args_id, arr_size);
        float arg_e1 = 0.0; float arg_e2 = 0.0;
        for(m = 0; < arr_size) 
        {
            arg_e1 = xsArrayGetFloat(temp_arr_id, m);
            for(n = 0; < arr_size) 
            {// 若 temp_arr_id[m] = arr_id[n]，则使得 args_id[m] = n
                arg_e2 = xsArrayGetFloat(arr_id, n);
                if(arg_e1 == arg_e2) // {xsChatData("sort_arr["+m+"] == arr["+n+"]");}
                {xsArraySetInt(args_id, m, n);}
            }
        }
        return (args_id);
    }
    else if(arr_size == 1) 
    {
        xsIntArrayClear_(args_id);
        return (args_id);
    }
    return (Inf);
}

mutable 
void iter_array(int arr_id=-1, string arr_name="", string arr_dtype="float") 
{// 该函数用于循历数组元素，并打印输出
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_name == "") {arr_name = ""+arr_id;}
    // 这些变量存储array迭代中元素的缓存值
    int    ie = 0;
    float  fe = 0.0;
    bool   be = false;
    string se = "";
    vector ve = cOriginVector; //float ve_x = 0.0; float ve_y = 0.0; float ve_z = 0.0;
    
    if(arr_dtype == "int") // 遍历int型数组
    {for(i = 0; < arr_size) {ie = xsArrayGetInt(arr_id, i); xsChatData("Array("+arr_name+")["+i+"] = " + ie);}}
    else if(arr_dtype == "float") // 遍历float型数组
    {for(i = 0; < arr_size) {fe = xsArrayGetFloat(arr_id, i); xsChatData("Array("+arr_name+")["+i+"] = " + fe);}}
    else if(arr_dtype == "bool") // 遍历bool型数组
    {for(i = 0; < arr_size) {be = xsArrayGetBool(arr_id, i); xsChatData("Array("+arr_name+")["+i+"] = " + be);}}
    else if(arr_dtype == "string") // 遍历string型数组
    {for(i = 0; < arr_size) {se = xsArrayGetString(arr_id, i); xsChatData("Array("+arr_name+")["+i+"] = " + se);}}
    else if(arr_dtype == "vector") // 遍历vector型数组
    {
        for(i = 0; < arr_size) 
        {
            ve = xsArrayGetVector(arr_id, i);
            //ve_x = xsVectorGetX(ve);
            //ve_y = xsVectorGetY(ve);
            //ve_z = xsVectorGetZ(ve);
            xsChatData("Array("+arr_name+").vector["+i+"].X = " + xsVectorGetX(ve));
            xsChatData("Array("+arr_name+").vector["+i+"].Y = " + xsVectorGetY(ve));
            xsChatData("Array("+arr_name+").vector["+i+"].Z = " + xsVectorGetZ(ve));
        }
    }
    else {xsChatData("Datatype is invalid.");}
}

mutable 
void iter_argsort(int args_id=-1, string arr_name="") 
{// 该函数用于循历argsort中的元素，并输出
    int args_len = xsArrayGetSize(args_id);
    if(arr_name == "") {arr_name = ""+args_id;}
    int e = 0.0;
    for(i = 0; < args_len) 
    {
        e = xsArrayGetInt(args_id, i);
        xsChatData("Array("+arr_name+")["+i+"] = " + e);
    }
}



/// 二维数组（矩阵）的基本运算 ///
vector xsMatrixDims(int mat_id=-1, string mat_name="") 
{
/* 求矩阵的维度
    参数说明：
        mat_id: 矩阵的ID
        return：vector类型；返回一个包含矩阵维度的向量
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));

    if(mat_name == "") {mat_name = ""+mat_id;}
    xsChatData("The dimisions of Matrix("+mat_name+"): ("+rows+", "+cols+")");
    
    return (xsVectorSet(rows, cols, 0.0));
}

int xsMatrixToArray(int mat_id=-1) 
{
/* 将矩阵reshape为一维数组
    参数说明：
        mat_id: 矩阵的ID
        return返回值：int类型，返回变形后的数组ID
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    int res_arr = xsArrayCreateFloat(rows*cols, 0.0, "res_arr"+farr_temp); farr_temp++;
    for(c = 0; < cols) {
        for(r = 0; < rows) 
        {xsArraySetFloat(res_arr, rows*c+r, xsArrayGetFloat(xsArrayGetInt(mat_id, c), r));}
    }
    return (res_arr);
}

int mat_temp = 0;
int xsArrayToMatrix(int arr_id=-1, int row=-1, int col=-1) 
{
/* 将一维数组reshape成 (row, col) 的矩阵
    参数说明：
        mat_id: 矩阵的ID
        row: reshape后矩阵的行数
        col: reshape后矩阵的列数
        return返回值：int类型，返回变形后的矩阵ID（列索引）
*/
    int arr_size = xsArrayGetSize(arr_id);
    if(arr_size == (row*col)) 
    {// 若数组能reshape成 row 行 col 列的矩阵
        int res_mat = xsArrayCreateInt(col, 0, "res_mat"+mat_temp); mat_temp++;
        int sub_arr = -1;    // 矩阵的子数组ID（列向量ID）
        
        for(c = 0; < col) 
        {
            sub_arr = xsArrayCreateFloat(row, 0.0, "sub_arr"+farr_temp); farr_temp++;
            for(r = 0; < row) 
            {
                xsArraySetFloat(sub_arr, r, xsArrayGetFloat(arr_id, row*c+r));
            }
            xsArraySetInt(res_mat, c, sub_arr);  // 子数组ID添加进矩阵列索引
        }
        return (res_mat);
    }
    else {xsChatData("The array can't reshape to matrix with row*col.");}
    return (Inf);
}

int xsMatrixReshape(int mat_id=-1, int new_row=-1, int new_col=-1) 
{
/* 将矩阵reshape为 (new_row, new_col) 的新矩阵
    参数说明：
        mat_id : 原矩阵的ID
        new_row: 变形后矩新阵的行数
        new_col: 变形后新矩阵的列数
        return返回值：int类型，返回变形后的矩阵ID（列索引）
*/
    int res_arr = xsMatrixToArray(mat_id);
    int res_mat = xsArrayToMatrix(res_arr, new_row, new_col);
    return (res_mat);
}

float xsMatrixElement(int mat_id=-1, int row=0, int col=0) 
{
/* 获取矩阵元素 matrix[row, col]
    参数说明：
        mat_id: 矩阵的ID
        row: 元素在矩阵中的行索引
        col: 元素在矩阵中的列索引
        return返回值：float类型，返回索引处的元素值
*/
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    int cols = xsArrayGetSize(mat_id);
    if((row >= 0 && row < rows) && (col >= 0 && col < cols)) 
    {// 若同时指定了row 和 col，则返回 matrix[row, col]
        return (xsArrayGetFloat(xsArrayGetInt(mat_id, col), row));
    }
    else {xsChatData("Invalid `row` index or `col` index." );}
    return (1.0*Inf);
}

int xsMatrixAddNum_(int mat_id=-1, float num=0.0) 
{
/* 矩阵与数字相加：
    参数说明：
        mat_id: 矩阵的ID
        num: 加数
        return返回值：int类型，返回相加后的矩阵ID
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    
    float mat_e = 0.0;
    for(c = 0; < cols) 
    {
        for(r = 0; < rows) 
        {// 更新矩阵第r行c列的元素 mat[r,c] -> mat[r,c] + num
            mat_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r) + num ;
                    xsArraySetFloat(xsArrayGetInt(mat_id, c), r, mat_e);
        }
    }
    return (mat_id);
}

int xsMatrixSubNum_(int mat_id=-1, float num=0.0) 
{
/* 矩阵与数字相减：
    参数说明：
        mat_id: 矩阵的ID
        num: 减数
        return返回值：int类型，返回相减后的矩阵ID
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    
    float mat_e = 0.0;
    for(c = 0; < cols) 
    {
        for(r = 0; < rows) 
        {// 更新矩阵第r行c列的元素 mat[r,c] -> mat[r,c] - num
            mat_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r) - num ;
                    xsArraySetFloat(xsArrayGetInt(mat_id, c), r, mat_e);
        }
    }
    return (mat_id);
}

int xsMatrixMulNum_(int mat_id=-1, float num=0.0) 
{
/* 矩阵与数字相乘：
    参数说明：
        mat_id: 矩阵的ID
        num: 乘数
        return返回值：int类型，返回相乘后的矩阵ID
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    
    float mat_e = 0.0;
    for(c = 0; < cols) 
    {
        for(r = 0; < rows) 
        {// 更新矩阵第r行c列的元素 mat[r,c] -> mat[r,c] * num
            mat_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r) * num ;
                    xsArraySetFloat(xsArrayGetInt(mat_id, c), r, mat_e);
        }
    }
    return (mat_id);
}

int xsMatrixDivNum_(int mat_id=-1, float num=0.0) 
{
/* 矩阵与数字相除：
    参数说明：
        mat_id: 矩阵的ID
        num: 除数
        return返回值：int类型，返回相除后的矩阵ID（异常返回 -32768）
*/
    if(num != 0.0) // 只有num不为0时，矩阵数量除才有意义
    {
        int cols = xsArrayGetSize(mat_id);
        int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
        float div_e = 0.0;
        for(c = 0; < cols) 
        {
            for(r = 0; < rows) 
            {// 更新矩阵第r行c列的元素 mat[r,c] -> mat[r,c] / num
                div_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r) / num;
                        xsArraySetFloat(xsArrayGetInt(mat_id, c), r, div_e);
            }
        }
        return (mat_id);
    }
    else {xsChatData("Divide by 0 in matrix div_operate.");}
    return (Inf);
}

int xsMatrixModNum_(int mat_id=-1, float num=0.0) 
{
/* 矩阵与数字取余：
    参数说明：
        mat_id: 矩阵的ID
        num: 除数
        return返回值：int类型，返回相除后的矩阵ID（异常返回 -32768）
*/
    if(num != 0.0) // 只有num不为0时，矩阵取余才有意义
    {
        int cols = xsArrayGetSize(mat_id);
        int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
        int mod_e = 0;
        for(c = 0; < cols) 
        {
            for(r = 0; < rows) 
            {// 更新矩阵第r行c列的元素 mat[r,c] -> mat[r,c] % num
                mod_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r) % num;
                        xsArraySetFloat(xsArrayGetInt(mat_id, c), r, mod_e);
            }
        }
        return (mat_id);
    }
    else {xsChatData("Divide by 0 in matrix mod_operate.");}
    return (Inf);
}

float xsVectorInMatrix(int mat_id=-1, int row=-1, int col=-1) 
{
/* 返回矩阵的 行向量 或 列向量：
    参数说明：
        mat_id: 矩阵的ID
        row: 行索引
        col: 列索引
        return返回值：float类型，返回行向量或列向量ID（异常返回 -32768）
*/
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    int cols = xsArrayGetSize(mat_id);
    // 判断索引是否出界: row = [0, rows)  col = [0, cols)
    if((row < -1) || (row >= rows)) 
    {xsChatData("The `row` index out of range."); return (Inf);}
    if((col < -1) || (col >= cols)) 
    {xsChatData("The `col` index out of range."); return (Inf);}
    
    // row和col均为-1时，返回原矩阵ID
    if((row == -1) && (col == -1)) {return (mat_id);}
    else if((row != -1) && (col != -1)) // row和col都指定时，返回矩阵元素 mat[r, c]
    {return (xsArrayGetFloat(xsArrayGetInt(mat_id, col), row));}
    // 指定col时，获取列向量并返回其 ID
    else if((row == -1) && (col != -1)) 
    {return (xsArrayGetInt(mat_id, col));}
    // 指定row时，获取行向量并返回其 ID
    else if((row != -1) && (col == -1)) 
    {
        int row_vec = xsArrayCreateFloat(cols, 0.0, "row_vec"+farr_temp); farr_temp++;
        for(c = 0; < cols) 
        {xsArraySetFloat(row_vec, c, xsArrayGetFloat(xsArrayGetInt(mat_id, c), row));}
        return (row_vec);
    }
    else{}
    
    return (Inf);
}

int mv_dot_i = 0;
int xsMatrixDotArray(int mat_id=-1, int vec_id=-1) 
{
/* 返回矩阵与向量相乘的结果 M.dot(v)：
    参数说明：
        mat_id: 矩阵的ID
        vec_id: 向量的ID
        return返回值：int类型，返回结果向量的ID（异常返回 -32768）
*/
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    int vec_len = xsArrayGetSize(vec_id);
    
    if(cols == vec_len) // cols 等于 vec_len，才可进行矩阵和向量的乘法运算
    {
        // mv_dot 代表矩阵与向量相乘的结果向量
        int mv_dot = xsArrayCreateFloat(vec_len, 0.0, "mv_dot"+mv_dot_i); mv_dot_i++;
        for(c = 0; < cols) // 矩阵中第c列的向量（列向量），与向量 vec（行向量）进行点乘
        {xsArraySetFloat(mv_dot, c, xsArraysDot(xsArrayGetInt(mat_id, c), vec_id));}
        return (mv_dot);
    }
    return (Inf);
}

int xsMatrixsDot(int mat1_id=-1, int mat2_id=-1) 
{
/* 矩阵与矩阵相乘 M1.dot(M2)：
    参数说明：
        mat1_id: 矩阵1的ID
        mat2_id: 矩阵2的ID
        return返回值：int类型，返回结果矩阵的ID（异常返回 -32768）
*/
    int m1_cols = xsArrayGetSize(mat1_id);
    int m1_rows = xsArrayGetSize(xsArrayGetInt(mat1_id, 0));
    int m2_cols = xsArrayGetSize(mat2_id);
    int m2_rows = xsArrayGetSize(xsArrayGetInt(mat2_id, 0));
    if(m1_cols == m2_rows) 
    {// 若 m1_cols == m2_rows ，进行矩阵乘法
        int mats_dot = xsArrayCreateFloat(m1_rows*m2_cols, 0, "mats_dot"+mat_temp); mat_temp++;
        int idx = 0;
        float marr_dot = -1;
        float temp_e = 0.0;
        
        for(r = 0; < m1_rows) 
        {
            for(c = 0; < m2_cols) 
            {
                marr_dot = xsArraysDot(xsVectorInMatrix(mat1_id, r, -1), xsVectorInMatrix(mat2_id, -1, c));
                xsArraySetFloat(mats_dot, idx, marr_dot);
                idx++;
            }
        }
        mats_dot = xsArrayToMatrix(mats_dot, m1_rows, m2_cols);
        idx = 0;
        return (mats_dot);
    }
    else {xsChatData("The dimision of mat1.cols don't equal to mat2.rows.");}
    return (Inf);
}

int sub_mat_i = 0;
int sub_arr_i = 0;
int xsSubMatrix(int mat_id=-1, int r_start=0, int r_end=-1, int c_start=0, int c_end=-1) 
{
/* 求矩阵的子矩阵，并返回其ID
    参数说明：
        mat_id: 矩阵的ID
        r_start: 行索引起始值
        r_end:  行索引结束值
        c_start: 列索引起始值
        c_end:  列索引结束值
        return返回值：int类型，返回子矩阵的ID（异常返回 -32768）
*/
    // 获取矩阵的 行数 和 列数 
    int cols = xsArrayGetSize(mat_id);
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    // 判断索引范围是否合法
    if(r_start < 0 || c_start < 0 || r_end >= rows || c_end >= cols) 
    {xsChatData("The matrix's index `row` or `col` out of range."); return (Inf);}
    else if((r_start > r_end) && (r_end != -1) || (c_start > c_end) && (c_end != -1))
    {xsChatData("The start index is greater than end index."); return (Inf);}
    else {}
    if(c_end == -1) {c_end = cols-1;}
    if(r_end == -1) {r_end = rows-1;}
    
    // 行索引切片和列索引切片长度
    int r_piece = r_end - r_start;
    int c_piece = c_end - c_start;
    int sub_mat = xsArrayCreateInt(c_piece, 0, "sub_mat"+sub_mat_i); sub_mat_i++;
    int sub_arr = -1;
    for(c = c_start; < c_end) 
    {
        sub_arr = xsArrayCreateFloat(r_piece, 0.0, "sub_arr"+sub_arr_i); sub_arr_i++;
        for(r = r_start; < r_end) 
        {
            xsArraySetFloat(sub_arr, r, xsArrayGetFloat(xsArrayGetInt(mat_id, c), r));
        }
        // 子数组ID加入矩阵的列索引
        xsArraySetInt(sub_mat, c, sub_arr);
    }
    return (sub_mat);
}

int xsConcatMatrix(int mat1_id=-1, int mat2_id=-1, int axis=0) 
{
/* 矩阵的聚合操作：
    参数说明：
        mat1_id: 矩阵1的ID
        mat2_id: 矩阵2的ID
        axis: 聚合操作的方向。axis=0 表示沿 X 轴方向聚合，即合并列；axis=1 表示沿 Y 轴方向，即合并行；
        return返回值：int类型，返回聚合矩阵的ID（异常返回 -32768）
*/
    int m1_cols = xsArrayGetSize(mat1_id);
    int m2_cols = xsArrayGetSize(mat2_id);
    int concat_mat = -1;
    if(axis == 0) 
    {// 横向拼接：all_cols = m1_cols + m2_cols
        int all_cols = m1_cols + m2_cols;
        concat_mat = xsArrayCreateInt(all_cols, -1, "concat_mat");  // 横向拼接的矩阵（列聚合）
        for(i = 0; < m1_cols) {xsArraySetInt(concat_mat, i        , xsArrayGetInt(mat1_id, i));}
        for(j = 0; < m2_cols) {xsArraySetInt(concat_mat, j+m1_cols, xsArrayGetInt(mat2_id, j));}
        return (concat_mat);
    }
    else if(axis == 1)
    {// 纵向拼接：聚合后的矩阵，各列向量的元素个数为，2个矩阵对应列的元素之和
        // ...
        // ...
        return (concat_mat);
    }
    else {xsChatData("Invalid value of `axis`.");}
    return (Inf);
}


