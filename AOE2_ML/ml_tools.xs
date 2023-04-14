/* 
        AOE2DE 机器学习库（测试版）
    该机器学习[ML]库包含用于机器学习的一些基本功能和工具函数，主要用于数据模型训练过程中的向量和矩阵处理操作。
    该目录下的各种ML推理算法，用于AOE2DE的实际场景，有待后续完善... 
    
    该ML库中实现的推理算法一览：
        knn : [已实现]
            KNN算法。用于做结果分类的推理算法，与数据本身高度相关。（ETC. 双方军队战斗结果 胜平负 的预测）
        Linear Regression : [实现中...]
            线性回归。预测连续结果值的回归算法。（ETC. AOE2 DE 中的天气系统，与“气温”，“降水”，“季节”相关因子的预测；“阴阳五行装备&技能系统”的属性平衡实践）
        Logistic Regression : [待实现]
            逻辑回归。预测二元分类的推理算法，适合结局固定是2种的情况。（ETC.暂无）
        SoftMax : [待实现]
            逻辑回归（多元逻辑回归）。将预测的连续结果值映射成概率值，并选择概率最高的一种情况进行实践。
            （ETC.当玩家面临基地选择，贸易路线选择时，通过该算法预测，得出一个较为理想的情况反馈给玩家进行决策。）
        Decision Tree : [待实现]
            决策树。用于对多层级关联选择时提供决策的分类算法。（ETC. 关联性卡牌系统，属性受剧情联动影响的RPG类战役中，该算法或许大有可为！）
    
    关于这些推理算法的详细原理，这里不做介绍。如君有兴趣可参考 scikit-learn 的文档：https://scikit-learn.org/stable/
    
    此ML库由 babycat 原创，存在纰漏和不足，欢迎读者指出。您的宝贵意见至关重要！
*/

const float epsilon = 0.000001;
const float PI = 3.1416;
const float E_ = 2.7183;
int Inf = -32768;



/// 数字处理基本函数 ///
mutable 
int randInt(int low=0,int high=0){return(xsGetRandomNumberLH(0,high-low)+low);}
mutable 
float random(){int n1=xsGetRandomNumber(); int I=xsGetRandomNumberLH(0,31); if(I>=30){n1=xsGetRandomNumberLH(0,16990);} float n2=0.000001*(n1+I*32767); return(n2);}
mutable 
int randLarge(int max_=999999999){int I =xsGetRandomNumberLH(0,max_/999999+1); int lar=xsGetRandomNumber(); if(I==1000){lar=xsGetRandomNumberLH(0,1000);} return(I*999999+lar);}
mutable 
float round(float x=0.0,int n=0){float num=0;float x2=x*pow(10,n);int x2_i=x2; if(abs(x2-x2_i)<0.5){num=1.0*x2_i/pow(10,n);} else{num=1.0*(x2_i+1)/pow(10,n);} return(num);}
mutable 
float Max(float x_=0.0, float y_=0.0){if(x_ >= y_){return(x_);} return(y_);}



/// 机器学习相关工具函数 ///
int array_list = 0;    // 数组管理列表

int farr_temp = 0;

mutable 
int xsCreateArray(string dtype="float", string arr_name="", int arr_size=1) 
{// 创建数组，将数组名称加入管理列表
    if(arr_size <= 0) {xsChatData("Array.size must greater than 0."); return (-32768);}
    int arr_id = -1;
         if(dtype == "int") {arr_id = xsArrayCreateInt(arr_size, 0, arr_name);}
    else if(dtype == "float") {arr_id = xsArrayCreateFloat(arr_size, 0.0, arr_name);}
    else if(dtype == "bool") {arr_id = xsArrayCreateBool(arr_size, false, arr_name);}
    else if(dtype == "string") {arr_id = xsArrayCreateString(arr_size, "", arr_name);}
    else if(dtype == "vector") {arr_id = xsArrayCreateVector(arr_size, cOriginVector, arr_name);}
    else {xsChatData("Create array failed, invalid data type."); return (-32768);}
    // 将创建数组的 ID 和名称，添加进数组管理列表 array_list
    int list_size = xsArrayGetSize(array_list);
    // 当array_list的size小于新增数组ID+1时，扩充数组管理列表的长度
    if(list_size < arr_id+1) {xsArrayResizeString(array_list, list_size+1);}
    // 若arr_id 的数组未注册进 array_list，则进行注册操作
    if(xsArrayGetString(array_list, arr_id) == "") 
    {xsArraySetString(array_list, arr_id, arr_name);
    //xsChatData("Register array successed.");
    }
    else {xsChatData("Register array failed, the array already exists."); return (-32768);}
    return (arr_id);
}

int xs_arr01 = -1;  int xs_arr02 = -1;
int xs_arr03 = -1;  int xs_arr04 = -1;
int xs_arr05 = -1;  int xs_arr06 = -1;
int xs_arr07 = -1;  int xs_arr08 = -1;
int xs_arr09 = -1;  int xs_arr10 = -1;
mutable 
void __xsPreDefinedArrays(int init_size=1) 
{
/*
    array_list : 数组管理列表，记录游戏中创建的数组ID及名称
    xs_arr01 ~ xs_arr10 : __xsPreDefinedArrays 函数创建的10个预留数组
    这些ID指向的数组，用于缓存某些操作的中间结果
*/
    array_list = xsArrayCreateString(1, "ArrayNames", "array_list");
    // 用于缓存变量的 值数组 ，索引数组
    // 参数说明：init_size: 预留数组创建时的数组长度，默认为 1
    xs_arr01 =    // arr.id = 1 , 该数组用于暂存bool型数组的元素值
        xsCreateArray("bool", "barr_vals", init_size);
    xs_arr02 =    // arr.id = 2 , 该数组用于暂存 xs_arr01 数组的 argsort
        xsCreateArray("int", "barr_args", init_size);
    xs_arr03 =    // arr.id = 3 , 该数组用于暂存int型数组的元素值
        xsCreateArray("int", "iarr_vals", init_size);
    xs_arr04 =    // arr.id = 4 , 该数组用于暂存 xs_arr03 数组的 argsort
        xsCreateArray("int", "iarr_args", init_size);
    xs_arr05 =    // arr.id = 5 , 该数组用于暂存float型数组的元素值
        xsCreateArray("float", "farr_vals", init_size);
    xs_arr06 =    // arr.id = 6 , 该数组用于暂存 xs_arr05 数组的 argsort
        xsCreateArray("int", "farr_args", init_size);
    xs_arr07 =    // arr.id = 7 , 该数组用于暂存string型数组的元素值
        xsCreateArray("string", "sarr_vals", init_size);
    xs_arr08 =    // arr.id = 8 , 该数组用于暂存 xs_arr07 数组的 argsort
        xsCreateArray("int", "sarr_args", init_size);
    xs_arr09 =    // arr.id = 9 , 该数组用于暂存vector型数组的元素值
        xsCreateArray("vector", "varr_vals", init_size);
    xs_arr10 =    // arr.id = 10, 该数组用于暂存 xs_arr09 数组的 argsort
        xsCreateArray("int", "varr_args", init_size);
}




/// 数组操作相关函数 ///
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
    {xsArraySetFloat(piece, idx, xsArrayGetFloat(arr_id, idx+start_idx));}
    return (piece);
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

int xsArrayPow(int arr_id=-1, float n=1, bool inplace=false) 
{
/* 
    数组元素的幂指数运算：
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
    else if(inplace=true) {res_arr = arr_id;}
    else {xsChatData("The param `inplace` is ileagled."); return (-1);}
    for(idx = 0; < arr_size){xsArraySetFloat(res_arr, idx, pow(xsArrayGetFloat(arr_id, idx), n));}
    return (res_arr);
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



/// 矩阵相关函数 ///
int mat_temp = 0;
int xsCreateMatrix(string mat_name="",  //要创建矩阵的名称
                   int row=0,    //矩阵行数
                   int col=0,    //矩阵列数
                   float def_val=0.0,    //元素默认填充值（default: 0）
                   string rand_func="",    //使用随机函数
                   int fill_arr=-1     //指定一个数组（ID > 0），用数组元素填充矩阵，此参数会覆盖`def_val`参数的默认值
                   )
{// 创建一个指定数据类型和形状的矩阵，并返回其ID
    if((row <= 0) || (col <= 0)) {xsChatData("Invalid `row` or `col` to matrix"); return (Inf);}
    if((row == 1) && (col == 1)) 
    {
        int new_arr = xsArrayCreateFloat(1, def_val, "new_arr"+farr_temp); mat_temp++;
             if(rand_func=="random") {xsArraySetFloat(new_arr, 0, random());}
        else if(rand_func=="randInt") {xsArraySetFloat(new_arr, 0, randInt());}
        else if(rand_func=="randLarge") {xsArraySetFloat(new_arr, 0, randLarge());}
        //else if(rand_func=="?") {xsArraySetFloat(new_arr, 0, ?);}
        else {}
        return (new_arr);
    }
    
    if(mat_name == "") {mat_name = "mat_"+mat_temp;}
    int new_mat = xsArrayCreateInt(col, 0, mat_name); mat_temp++;
    int sub_arr = -1;    // 矩阵的各列向量ID（ArrayID）
    if(fill_arr > 0) {
        // 若指定了用于值填充的数组，用该数组元素填充矩阵。
        // 当Matrix与Array长度不匹配时，未匹配的元素使用默认值
        int arr_size = xsArrayGetSize(fill_arr);
        int mat_size = row * col;
        int e_idx = 0;    // fill_arr中当前填充元素的索引下标
        //new_mat = xsArrayCreateInt(col, -1, mat_name+mat_temp); mat_temp++;
        for(c = 0; < col)
        {
            sub_arr = xsArrayCreateFloat(row, def_val, "mat_sarr"+farr_temp); farr_temp++;
            for(r = 0; < row)
            {
                e_idx = row*c+r; 
                if(e_idx >= arr_size) {continue;}  // skip assignment
                xsArraySetFloat(sub_arr, r, xsArrayGetFloat(fill_arr, e_idx));
            }
            xsArraySetInt(new_mat, c, sub_arr);  // 将列向量ID加进矩阵的列索引
        }
        return (new_mat);
    }
    else 
    {
        for(c = 0; < col) 
        {
            sub_arr = xsArrayCreateFloat(row, def_val, "mat_sarr"+farr_temp); farr_temp++;
            for(r = 0; < row)
            {
                if(rand_func == "random") {xsArraySetFloat(sub_arr, r, random());}
                if(rand_func == "randInt") {xsArraySetFloat(sub_arr, r, randInt());}
                if(rand_func == "randLarge") {xsArraySetFloat(sub_arr, r, randLarge());}
                //if(rand_func=="?") {xsArraySetFloat(sub_arr, r, ?);}
            }
            xsArraySetInt(new_mat, c, sub_arr);  // 子数组ID添加进矩阵列索引
        }
        return (new_mat);
    }
    return (Inf);
}

void iter_matrix(int mat_id=-1, string mat_name="") 
{
/* 遍历矩阵中每个[r, c]元素，并打印输出
    参数说明：
    mat_id: 矩阵ID
    mat_name: 矩阵标识名称
*/
    int rows = xsArrayGetSize(xsArrayGetInt(mat_id, 0));
    int cols = xsArrayGetSize(mat_id);
    if(mat_name == ""){mat_name = ""+mat_id;}
    float temp_e = 0.0;
    for(c = 0; < cols) // 遍历所有列
    {
        for(r = 0; < rows) // 遍历所有行
        {
            temp_e = xsArrayGetFloat(xsArrayGetInt(mat_id, c), r);
            xsChatData("Matrix("+mat_name+")["+r+","+c+"] = " + temp_e);
        }
    }
}

vector xsMatrixShape(int mat_id=-1, string mat_name="") 
{
/* 求矩阵的形状 (M, N)
    参数说明：
        mat_id: 矩阵的ID
        mat_name: 矩阵的标识名称
        return：vector类型；矩阵维度 (行数, 列数)
*/
    // 矩阵第0列的向量（数组）ID编号
    int col0_id = xsArrayGetInt(mat_id, 0);
    if(col0_id > 10)
    {// 判断该列ID是否合法

        int cols = xsArrayGetSize(mat_id);
        int rows = xsArrayGetSize(col0_id);
        if(mat_name == "") {mat_name = ""+mat_id;}
        xsChatData("Matrix("+mat_name+").shape=["+rows+", "+cols+"]");
        return (xsVectorSet(rows, cols, 0));
    }
    else {xsChatData("Matrix("+mat_id+") is not exist.");}
    return (cOriginVector);
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


int sub_mat_i = 0; int sub_arr_i = 0;
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
    if(r_start < 0 || c_start < 0 || r_end > rows || c_end > cols) 
    {xsChatData("The matrix's index `row` or `col` out of range."); return (Inf);}
    else if((r_start > r_end) && (r_end != -1) || (c_start > c_end) && (c_end != -1))
    {xsChatData("The start index is greater than end index."); return (Inf);}
    else {}
    if(c_end == -1) {c_end = cols;}
    if(r_end == -1) {r_end = rows;}
    
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
    //xsChatData("<GREY>SubMatrix.rows: "+ xsArrayGetSize(xsArrayGetInt(sub_mat, 0)));
    //xsChatData("<GREY>SubMatrix.cows: "+ xsArrayGetSize(sub_mat));
    return (sub_mat);
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

/// Map 相关函数 ///
int mkey_i = 0; int mval_i = 0;
mutable 
int xsCreateMap(string dtype="float", string map_name="", int map_size=1) 
{
/*
    创建伪Map，并加入数组管理列表：
    参数说明：
        dtype: Map的数据类型；各类型数组创建时，其默认值对应关系如下：
            {"int": 0, "float": 0.0, "bool": false, "string": "", "vector": cOriginVector}
        map_name: Map名称
        map_size: Map长度
        //array_list: 数组管理列表
        返回值：int类型，返回创建Map的ID
*/
    if(map_size <= 0) {xsChatData("Map.size must greater than 0."); return (Inf);}
    int map_id = xsCreateArray("int", map_name, 2);  // 创建 Map，并将ID注册进 array_list
    int mkey = xsArrayCreateString(map_size, "key", "mkey"+mkey_i); mkey_i++;
    int mval = -1;
         if(dtype == "int") {mval = xsArrayCreateInt(map_size, 0, "mval"+mval_i); mval_i++;}
    else if(dtype == "float") {mval = xsArrayCreateFloat(map_size, 0.0, "mval"+mval_i); mval_i++;}
    else if(dtype == "bool") {mval = xsArrayCreateBool(map_size, false, "mval"+mval_i); mval_i++;}
    else if(dtype == "string") {mval = xsArrayCreateString(map_size, "NULL", "mval"+mval_i); mval_i++;}
    else if(dtype == "vector") {mval = xsArrayCreateVector(map_size, cOriginVector, "mval"+mval_i); mval_i++;}
    else {xsChatData("Create Map failed, invalid data type."); return (Inf);}
    // 将 mkey 和 mval 添加进 map_id
    xsArraySetInt(map_id, 0, mkey);
    xsArraySetInt(map_id, 1, mval);
    
    return (map_id);
}

int xsMapSetFloat_(int map_id=-1, string key_="NULL", float val_=0.0) 
{
/* 
    设置/更新 浮点型Map中的键值对信息：
    参数说明：
      map_id: 
      key_: 要设置的键
      val_: 要设置的值
      return: int类型，设置成功则返回更新元素的索引值up_idx，否则返回0
*/
    if(map_id <= 0) {return(0);}
    int up_idx = 0;
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    int map_size = xsArrayGetSize(mkey);
    // 判断要设置的key是否存在
    bool key_exist = false;
    for(i=1; < map_size) 
    {
        if(xsArrayGetString(mkey, i) == key_) {key_exist = true; up_idx = i; break;}
    }
    if(key_exist) {// 存在则更新该key对应的value
        xsArraySetFloat(mval, up_idx, val_);
    }
    else {// 不存在则新增键值对
        up_idx = map_size;
        xsArrayResizeString(mkey, map_size+1);
        xsArrayResizeFloat(mval, map_size+1);
        xsArraySetString(mkey, up_idx, key_);
        xsArraySetFloat(mval, up_idx, val_);
    }
    return (up_idx);
}