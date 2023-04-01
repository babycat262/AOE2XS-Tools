
/* 
    【推荐】数组注册管理器：
    数组管理器 array_list，用于管理游戏中脚本创建的数组ID和数组名称，方便后续查看。
    将下列代码放置于你的XS主文件的开头，就能正常使用数组管理功能！
*/

// 数组管理列表 array_list ：ID编号为0的数组。该列表用于管理场景中创建的数组ID和数组名称
int array_list = 0;

int xsCreateArray(string dtype="float", string arr_name="", int arr_size=1) 
{// 创建数组，且将数组名称加入管理列表
    if(arr_size <= 0) {xsChatData("Array.size must greater than 0."); return (-32768);}
    int arr_id = -1;
         if(dtype == "int") {arr_id = xsArrayCreateInt(arr_size, -1, arr_name);}
    else if(dtype == "float") {arr_id = xsArrayCreateFloat(arr_size, 0.0, arr_name);}
    else if(dtype == "bool") {arr_id = xsArrayCreateBool(arr_size, false, arr_name);}
    else if(dtype == "string") {arr_id = xsArrayCreateString(arr_size, "", arr_name);}
    else if(dtype == "vector") {arr_id = xsArrayCreateVector(arr_size, cOriginVector, arr_name);}
    else {xsChatData("Create array failed, invalid data type."); return (-32768);}
    // 将当前数组的ID和名称添加进数组管理列表 array_list
    int list_size = xsArrayGetSize(array_list);
    // 当array_list的size小于新增数组ID+1时，扩充数组管理列表的长度
    if(list_size < arr_id+1) {xsArrayResizeString(array_list, list_size+1);}
    // 若arr_id 的数组未注册进 array_list，则进行注册操作
    if(xsArrayGetString(array_list, arr_id) == "") {
        xsArraySetString(array_list, arr_id, arr_name);
        //xsChatData("Register array successed.");
    }
    else {xsChatData("Register array failed, the array already exists."); return (-32768);}
    return (arr_id);
}
/*
    函数说明：
    1.通过 xsCreateArray() 创建数组之后，可以通过调用 array_tools.xs 模块中的 xsArrayGetName(arr_id) 函数，
      能够通过数组ID得到对应的数组名称；
    2.通过调用数组元素迭代函数 iter_array(array_list, "array_list", "string") ，能够看到当前已注册进管理列表array_list
      的所有数组的ID以及名称，让你能对已创建数组的情况有一目了然的认识。
*/

// xs_arr01 ~ xs_arr10 变量，用于存储 __xsPreDefinedArrays() 函数创建的10个预留数组的ID。这些ID指向的数组，
// 用于暂存某些函数运算中间结果的缓存值，优化数组开销。
int xs_arr01 = -1;  int xs_arr02 = -1;
int xs_arr03 = -1;  int xs_arr04 = -1;
int xs_arr05 = -1;  int xs_arr06 = -1;
int xs_arr07 = -1;  int xs_arr08 = -1;
int xs_arr09 = -1;  int xs_arr10 = -1;
void __xsPreDefinedArrays(int pre_size=1) 
{// 暂存数组 元素值 和 索引 的预留数组
    // 参数说明：pre_size: 预留数组创建时的数组长度，默认为 1
    xs_arr01 =    // arr.id = 1 , 该数组用于暂存bool型数组的元素值
        xsCreateArray("bool", "barr_vals", pre_size);
    xs_arr02 =    // arr.id = 2 , 该数组用于暂存 xs_arr01 数组的 argsort
        xsCreateArray("int", "barr_args", pre_size);
    xs_arr03 =    // arr.id = 3 , 该数组用于暂存int型数组的元素值
        xsCreateArray("int", "iarr_vals", pre_size);
    xs_arr04 =    // arr.id = 4 , 该数组用于暂存 xs_arr03 数组的 argsort
        xsCreateArray("int", "iarr_args", pre_size);
    xs_arr05 =    // arr.id = 5 , 该数组用于暂存float型数组的元素值
        xsCreateArray("float", "farr_vals", pre_size);
    xs_arr06 =    // arr.id = 6 , 该数组用于暂存 xs_arr05 数组的 argsort
        xsCreateArray("int", "farr_args", pre_size);
    xs_arr07 =    // arr.id = 7 , 该数组用于暂存string型数组的元素值
        xsCreateArray("string", "sarr_vals", pre_size);
    xs_arr08 =    // arr.id = 8 , 该数组用于暂存 xs_arr07 数组的 argsort
        xsCreateArray("int", "sarr_args", pre_size);
    xs_arr09 =    // arr.id = 9 , 该数组用于暂存vector型数组的元素值
        xsCreateArray("vector", "varr_vals", pre_size);
    xs_arr10 =    // arr.id = 10, 该数组用于暂存 xs_arr09 数组的 argsort
        xsCreateArray("int", "varr_args", pre_size);
}

// 此Rule初始化 array_list.ID + 10个预留数组的ID
rule array_register
    inactive
    group ArrayRegister
    runImmediately
    priority 100
{
    array_list = xsArrayCreateString(1, "ArrayNames", "array_list");    // 注册 array_list.ID
    __xsPreDefinedArrays();    // 注册预留数组ID
    xsDisableSelf();
}


void main() 
{// 入口函数
    xsEnableRule("array_register");    // 启用array_list规则
}
