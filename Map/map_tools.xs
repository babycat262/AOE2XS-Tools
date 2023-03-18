/// 伪Map相关操作 ///

// 数学常量
const float epsilon = 0.000001;
const int Inf = -32768;
const float PI = 3.1416;
const float e_ = 2.7183;

// 字符串处理函数
string str(float number=0.000001) 
{// 返回字符串形式的number
    if(number == epsilon) {return ("");}
    return (""+number);
}


/*
int mkey_i = 0; int mval_i = 0;
int xsCreateMap(string dtype="float", string map_name="", int map_size=1) 
{
 创建伪Map，并加入数组管理列表：
    参数说明：
        dtype: Map的数据类型；各类型数组创建时，其默认值对应关系如下：
            {"int": 0, "float": 0.0, "bool": false, "string": "", "vector": cOriginVector}
        map_name: Map名称
        map_size: Map长度
        //array_list: 数组管理列表
        返回值：int类型，返回创建Map的ID

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
*/

bool xsKeyExists(int map_id=-1, string key_="") 
{// 判断给定的key是否在Map中
    int key_amt = 0;
    int mkey = xsArrayGetInt(map_id, 0);
    int map_size = xsArrayGetSize(mkey);
    for(i = 0; < map_size) {if(xsArrayGetString(mkey, i) == key_){key_amt++; break;}}
    if(key_amt >= 1) {return (true);}
    return (false);
}

bool iter_map(int map_id=-1, string map_name="", int e_idx=0) 
{
/* 迭代Map中的元素，并以 {key: value} 形式输出
    参数说明：
      map_id: Map的ID编号
      map_name: Map名称
      e_idx: 迭代起始位置的元素索引，默认 0
      return: 若成功迭代完成Map返回true，否则返回false
*/
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    if(xsArrayGetSize(mkey) != xsArrayGetSize(mval)) 
    {xsChatData("The number of keys must equal to vals."); return (false);}
    if(map_name == "") {map_name = ""+map_id;}
    int map_size = xsArrayGetSize(mkey);
    if(e_idx < 0 || e_idx >= map_size) {e_idx = 0;}
    while(e_idx < map_size) 
    {
        xsChatData("Map("+map_name+")["+e_idx+"] = {"+xsArrayGetString(mkey, e_idx)+" : "+xsArrayGetFloat(mval, e_idx)+"}");
        e_idx++;
    }
    return (true);
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


int xsMapAddInt_(int map_id=-1, string key_="", int val_=-32768) 
{
/* 
    在整型Map的末尾添加一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要添加的键
      val_: 要添加的值
      return: int类型值，添加成功返回1，否则返回0
*/
    if(val_ == Inf) {xsChatData("Invalid add operation."); return (0);}
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    int map_size = xsArrayGetSize(mkey);
    
    xsArrayResizeString(mkey, map_size+1);
    xsArraySetString(mkey, map_size, key_);
    xsArrayResizeInt(mval, map_size+1);
    xsArraySetInt(mval, map_size, val_);
    return (1);
}

int xsMapAddFloat_(int map_id=-1, string key_="", float val_=0.000001) 
{
/* 
    在浮点型Map的末尾添加一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要添加的键
      val_: 要添加的值
      return: int类型值，添加成功返回1，否则返回0
*/
    if(val_ == epsilon) {xsChatData("Invalid Add Float operation."); return (0);}
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    int map_size = xsArrayGetSize(mkey);
    
    xsArrayResizeString(mkey, map_size+1);
    xsArraySetString(mkey, map_size, key_);
    xsArrayResizeFloat(mval, map_size+1);
    xsArraySetFloat(mval, map_size, val_);
    return (1);
}

int xsMapAddString_(int map_id=-1, string key_="", string val_="") 
{
/* 
    在字符串型Map的末尾添加一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要添加的键
      val_: 要添加的值
      return: int类型值，添加成功返回1，否则返回0
*/
    if(val_ == str()) {xsChatData("Invalid Add String operation."); return (0);}
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    int map_size = xsArrayGetSize(mkey);
    
    xsArrayResizeString(mkey, map_size+1);
    xsArraySetString(mkey, map_size, key_);
    xsArrayResizeString(mval, map_size+1);
    xsArraySetString(mval, map_size, val_);
    return (1);
}

int xsMapDelInt_(int map_id=-1, int idx=-1) 
{
/* 
    删除整型Map中的一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要删除的键
      val_: 要删除的值
      return: int类型值，成功删除返回1，否则返回0
*/
    int map_size = xsArrayGetSize(xsArrayGetInt(map_id, 0));
    if(idx <= -2 || idx >= map_size) {xsChatData("The index out of range."); return (0);}
    else if(idx == -1) {idx = map_size-1;}
    else {}
    
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    for(i = idx; < map_size) 
    {
        if(i == map_size-1) 
        {xsArrayResizeString(mkey, map_size-1); xsArrayResizeInt(mval, map_size-1);}
        else 
        {xsArraySetString(mkey, i, xsArrayGetString(mkey, i+1));
         xsArraySetInt(mval, i, xsArrayGetInt(mval, i+1));
        }
    }
    return (1);
}

int xsMapDelFloat_(int map_id=-1, int idx=-1) 
{
/* 
    删除浮点型Map中的一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要删除的键
      val_: 要删除的值
      return: int类型值，成功删除返回1，否则返回0
*/
    int map_size = xsArrayGetSize(xsArrayGetInt(map_id, 0));
    if(idx <= -2 || idx >= map_size) {xsChatData("The index out of range."); return (0);}
    else if(idx == -1) {idx = map_size-1;}
    else {}
    
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    for(i = idx; < map_size) 
    {
        if(i == map_size-1) 
        {xsArrayResizeString(mkey, map_size-1); xsArrayResizeFloat(mval, map_size-1);}
        else 
        {xsArraySetString(mkey, i, xsArrayGetString(mkey, i+1));
         xsArraySetFloat(mval, i, xsArrayGetFloat(mval, i+1));
        }
    }
    return (1);
}

int xsMapDelString_(int map_id=-1, int idx=-1) 
{
/* 
    删除字符串型Map中的一个键值对
    参数说明：
      map_id: Map的ID编号
      key_: 要删除的键
      val_: 要删除的值
      return: int类型值，成功删除返回1，否则返回0
*/
    int map_size = xsArrayGetSize(xsArrayGetInt(map_id, 0));
    if(idx <= -2 || idx >= map_size) {xsChatData("The index out of range."); return (0);}
    else if(idx == -1) {idx = map_size-1;}
    else {}
    
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    for(i = idx; < map_size) 
    {
        if(i == map_size-1) // 将Map中的最后一个键值对删除
        {xsArrayResizeString(mkey, map_size-1); xsArrayResizeString(mval, map_size-1);}
        else // 以idx索引为起始位置，将下一个位置的元素值，赋值给该位置元素：Map(i) = Map(i+1)
        {xsArraySetString(mkey, i, xsArrayGetString(mkey, i+1));
         xsArraySetString(mval, i, xsArrayGetString(mval, i+1));
        }
    }
    return (1);
}










