include "ml_tools.xs";

// KNN 分类算法
const int Inf = -32768;
const float epsilon = 0.000001;
const float PI = 3.1416;
const float e_ = 2.7183;



int map_i = 1;
int xsCounter(int arr_id=-1, string sort_way="ASC") 
{
    int sort_arr = xsArrayBubbleSortFloat(arr_id, sort_way, true);
    int arr_size = xsArrayGetSize(sort_arr);
    // 创建存储统计信息的Map
    int map_info = xsCreateMap("float", "map_info"+map_i, 1); map_i++;
    float  cur_val = 0.0;
    string cur_key = "";
    int ele_amt = 0;
    float pre_val = 0.0;
    
    for(idx = 0; < arr_size)
    {
        cur_val = xsArrayGetFloat(sort_arr, idx);
        if(idx == 0) {
            cur_key = ""+cur_val;
            ele_amt = 1;
            xsMapSetFloat_(map_info, cur_key, ele_amt);
        }
        else if((idx > 0)&&(idx < arr_size)) {
            pre_val = xsArrayGetFloat(sort_arr, idx-1);
            if(cur_val == pre_val) {ele_amt++; xsMapSetFloat_(map_info, cur_key, ele_amt);}
            else {cur_key = ""+cur_val; ele_amt = 1; xsMapSetFloat_(map_info, cur_key, ele_amt);}
        }
        else {}
    }
    //iter_map(map_info, "e_maps", 1);
    return (map_info);
}

vector map_most_common(int map_id=-1, int most_n=1)
{
    int mkey = xsArrayGetInt(map_id, 0);
    int mval = xsArrayGetInt(map_id, 1);
    int map_size = xsArrayGetSize(mkey);
    float max_e = -32768.0;
    int e_idx = 0;  // 当前element对应的索引
    float e_temp = 0.0;
    for(idx = 1; < map_size) {
        // 遍历数组，更新最大元素的值和索引
        e_temp = xsArrayGetFloat(mval, idx);
        if(max_e < e_temp) {max_e = e_temp; e_idx = idx;}
    }
    vector most_item = xsVectorSet(e_idx, max_e, 0.0);
    
    return (most_item);
}


//数据集属性：训练集/测试集
int X_data = -1;
int y_lab =  -1;
int X_train = -1; int X_test = -1;
int y_train = -1; int y_test = -1;

bool train_test_split(int X_=-1, int lab_=-1, float test_ratio=0.3) 
{// 训练集和测试集分离
    int x_size = xsArrayGetSize(xsArrayGetInt(X_, 0));
    int lab_size = xsArrayGetSize(lab_);
    if(x_size != lab_size) {xsChatData("The size of X and Lab must equal."); return (false);}
    
    int test_size = round(test_ratio*lab_size,0);
    int train_size = x_size - test_size;
    X_train = xsSubMatrix(X_, 0, train_size, 0, -1);
    X_test = xsSubMatrix(X_, train_size, -1, 0, -1);
    y_train = xsArrayPiece(lab_, 0, train_size);
    y_test = xsArrayPiece(lab_, train_size, -1);
    return (true);
}

vector KneighborsClassifier(int k=3, vector KNN_OBJ=cInvalidVector) 
{//初始化KNN分类器
    //if((k < 1) || (k > xsArrayGetSize(xsArrayGetInt(X_data, 0))))
    //{xsChatData("k must be greater or equal 1."); return (cInvalidVector);}
    KNN_OBJ = xsVectorSet(X_train, y_train, k);
    return (KNN_OBJ);
}

vector KNN_fit(vector KNN_OBJ=cInvalidVector, int X_=-1, int lab_=-1) 
{//根据训练数据集 X_train 和 y_train 训练KNN分类器
    int k = xsVectorGetZ(KNN_OBJ);
    int x_size = xsArrayGetSize(xsArrayGetInt(X_, 0));    // 训练集的样本数
    int lab_size = xsArrayGetSize(lab_);    // 训练集标签数
xsChatData("<RED>x_size: "+ x_size); xsChatData("<RED>lab_size: "+ lab_size);
    if((k <= 1)||(k > x_size)) {xsChatData("Param `k` is invalid."); return(cInvalidVector);}
    if(x_size != lab_size) {xsChatData("The size of X_ must be equal to the size of lab_"); return(cInvalidVector);}
    
    X_train = X_ ;
    y_train = lab_ ;
    KNN_OBJ = xsVectorSet(X_, lab_, k);
    return (KNN_OBJ);
}

int dist_i = 0;
int near_i = 0;
int _KNN_predict(vector KNN_OBJ=cInvalidVector, int x_pred=-1) 
{//给定单个待测数据x， 返回x的预测结果值
    int X_train_rows = xsVectorGetX(xsMatrixShape(X_train));
    int X_train_cols = xsVectorGetY(xsMatrixShape(X_train));
    if(xsArrayGetSize(x_pred) != X_train_cols)    //x_pred.shape[0] != X_train.shape[1]
    {xsChatData("The feature number of x_pred must be equal to X_train."); return(-32768);}
    
    float dist_x = 0.0;
    int x_ = -1;
    int distances = xsArrayCreateFloat(X_train_rows, 0.0, "distances"+dist_i); dist_i++;
    for(r = 0; < X_train_rows) 
    {
        x_ = xsVectorInMatrix(X_train, r, -1);
        // sqrt(np.sum((x_ - x) ** 2))
        dist_x = sqrt(xsArraySum(xsArrayPow(xsArraysSub(x_, x_pred), 2)));
        xsArraySetFloat(distances, r, dist_x);
    }

    int k = xsVectorGetZ(KNN_OBJ);
    int near_idx = xsArgSortFloat(distances, "ASC");
    //xsArrayResizeInt(near_idx, k);
    //int near_idx_piece = xsArrayPiece(near_idx, 0, k);
    //int k_piece_size = xsArrayGetSize(near_idx_piece);
    int nearest_Y = xsArrayCreateFloat(k, 0.0, "nearest_Y"+near_i); near_i++;
    int y_i = 0;
    float y_train_i = 0.0;
    for(i = 0; < k) 
    {
        y_i = xsArrayGetInt(near_idx, i);
        y_train_i = xsArrayGetFloat(y_train, y_i);
        xsArraySetFloat(nearest_Y, i, y_train_i);
    }
    // Counter 计数器对序列中元素和该元素出现的次数进行统计
    int votes = xsCounter(nearest_Y);  // votes是数组统计结果的键值对 Mapping 
    vector most_n_item = map_most_common(votes, 1);
    int lab_ = xsVectorGetY(most_n_item);
    return (lab_);
}

int KNN_predict(vector KNN_OBJ=cInvalidVector, int X_=-1) 
{// 根据接收到的矩阵X_ , 预测结果标签向量
    vector X_train_shape = xsMatrixShape(X_train);
    vector X_shape = xsMatrixShape(X_);
    if(xsVectorGetY(X_train_shape) != xsVectorGetY(X_shape)) 
    {xsChatData("The features count of X_ must be equal to X_train."); return(-32768);}
    
    int x_test_size = xsVectorGetX(X_shape);
    int y_pred = xsArrayCreateFloat(x_test_size, 0.0, "y_pred");
    for(r = 0; < x_test_size) {// 矩阵 X_test 中第r个样本的数据
        xsArraySetFloat(y_pred, r, _KNN_predict(KNN_OBJ, xsVectorInMatrix(X_, r)));
    }
    return (y_pred);
}




/* KNN 算法测试 */

// 单位相关属性构成的矩阵 
int units_mat = -1;
int hps = -1;
int speeds = -1;
int attacks = -1;
int defend1 = -1;
int defend2 = -1;
int types = -1;    // labels


void units_initial()
{
    units_mat = xsCreateArray("int", "units", 5);
    hps        = xsCreateArray("float", "hps", 20);
    speeds     = xsCreateArray("float", "speeds", 20);
    attacks    = xsCreateArray("float", "attacks", 20);
    defend1    = xsCreateArray("float", "defend1", 20);
    defend2    = xsCreateArray("float", "defend2", 20);
    types = xsCreateArray("float", "types", 20);

// 0036：手推炮 | 0041：近卫军 | 0283：重装骑士 | 0359：长戟兵 | 0492：劲弩手 | 0548：重型冲车 | 0558：精锐战象 | 0567：冠军剑士 | 
// 0588：重型投石车 | 0752：精锐鹰勇士 | 0757：精锐答刺罕骑兵 | 0868：精锐热那亚弩手 | 0871：精锐马扎尔骠骑 | 0878：精锐贵族铁骑 | 
// 1003：精锐风琴炮 | 1227：精锐龙骑兵 | 1131：精锐藤甲弓兵 | 1134：精锐象兵 | 1661：精锐萨金特卫兵 | 1707：波兰翼骑兵 |     
    // Add attrs into array.
    xsArraySetFloat( hps, 00, 080);    xsArraySetFloat( speeds, 00, 0.70);    xsArraySetFloat( attacks, 00, 40);    xsArraySetFloat( defend1, 00, 2);    xsArraySetFloat( defend2, 00, 5);    xsArraySetFloat( types, 00, 13);  // 攻城武器
    xsArraySetFloat( hps, 01, 060);    xsArraySetFloat( speeds, 01, 1.05);    xsArraySetFloat( attacks, 01, 10);    xsArraySetFloat( defend1, 01, 0);    xsArraySetFloat( defend2, 01, 8);    xsArraySetFloat( types, 01, 06);  // 步兵
    xsArraySetFloat( hps, 02, 120);    xsArraySetFloat( speeds, 02, 1.35);    xsArraySetFloat( attacks, 02, 12);    xsArraySetFloat( defend1, 02, 2);    xsArraySetFloat( defend2, 02, 2);    xsArraySetFloat( types, 02, 12);  // 骑兵
    xsArraySetFloat( hps, 03, 060);    xsArraySetFloat( speeds, 03, 1.00);    xsArraySetFloat( attacks, 03, 06);    xsArraySetFloat( defend1, 03, 0);    xsArraySetFloat( defend2, 03, 0);    xsArraySetFloat( types, 03, 06);
    xsArraySetFloat( hps, 04, 040);    xsArraySetFloat( speeds, 04, 0.96);    xsArraySetFloat( attacks, 04, 06);    xsArraySetFloat( defend1, 04, 0);    xsArraySetFloat( defend2, 04, 0);    xsArraySetFloat( types, 04, 00);  // 弓箭手
    xsArraySetFloat( hps, 05, 270);    xsArraySetFloat( speeds, 05, 0.60);    xsArraySetFloat( attacks, 05,204);    xsArraySetFloat( defend1, 05,-3);    xsArraySetFloat( defend2, 05,195);   xsArraySetFloat( types, 05, 13);  // 攻城武器
    xsArraySetFloat( hps, 06, 600);    xsArraySetFloat( speeds, 06, 0.70);    xsArraySetFloat( attacks, 06, 20);    xsArraySetFloat( defend1, 06, 1);    xsArraySetFloat( defend2, 06, 3);    xsArraySetFloat( types, 06, 12);  // 骑兵
    xsArraySetFloat( hps, 07, 070);    xsArraySetFloat( speeds, 07, 0.90);    xsArraySetFloat( attacks, 07, 13);    xsArraySetFloat( defend1, 07, 1);    xsArraySetFloat( defend2, 07, 1);    xsArraySetFloat( types, 07, 06);
    xsArraySetFloat( hps, 08, 120);    xsArraySetFloat( speeds, 08, 1.35);    xsArraySetFloat( attacks, 08, 14);    xsArraySetFloat( defend1, 08, 2);    xsArraySetFloat( defend2, 08, 2);    xsArraySetFloat( types, 08, 12);
    xsArraySetFloat( hps, 09, 070);    xsArraySetFloat( speeds, 09, 0.85);    xsArraySetFloat( attacks, 09, 20);    xsArraySetFloat( defend1, 09, 2);    xsArraySetFloat( defend2, 09, 6);    xsArraySetFloat( types, 09, 13);
    xsArraySetFloat( hps, 10, 150);    xsArraySetFloat( speeds, 10, 1.35);    xsArraySetFloat( attacks, 10, 11);    xsArraySetFloat( defend1, 10, 1);    xsArraySetFloat( defend2, 10, 4);    xsArraySetFloat( types, 10, 12);
    xsArraySetFloat( hps, 11, 050);    xsArraySetFloat( speeds, 11, 0.96);    xsArraySetFloat( attacks, 11, 06);    xsArraySetFloat( defend1, 11, 1);    xsArraySetFloat( defend2, 11, 0);    xsArraySetFloat( types, 11, 00);  // 弓箭手
    xsArraySetFloat( hps, 12, 085);    xsArraySetFloat( speeds, 12, 1.50);    xsArraySetFloat( attacks, 12, 10);    xsArraySetFloat( defend1, 12, 0);    xsArraySetFloat( defend2, 12, 2);    xsArraySetFloat( types, 12, 12);
    xsArraySetFloat( hps, 13, 130);    xsArraySetFloat( speeds, 13, 1.30);    xsArraySetFloat( attacks, 13, 14);    xsArraySetFloat( defend1, 13, 8);    xsArraySetFloat( defend2, 13, 3);    xsArraySetFloat( types, 13, 12);
    xsArraySetFloat( hps, 14, 060);    xsArraySetFloat( speeds, 14, 1.30);    xsArraySetFloat( attacks, 14, 09);    xsArraySetFloat( defend1, 14, 0);    xsArraySetFloat( defend2, 14, 4);    xsArraySetFloat( types, 14, 06);  // pred_lab[0]
    xsArraySetFloat( hps, 15, 070);    xsArraySetFloat( speeds, 15, 0.60);    xsArraySetFloat( attacks, 15, 75);    xsArraySetFloat( defend1, 15, 0);    xsArraySetFloat( defend2, 15, 8);    xsArraySetFloat( types, 15, 13);  // pred_lab[1]
    xsArraySetFloat( hps, 16, 045);    xsArraySetFloat( speeds, 16, 1.10);    xsArraySetFloat( attacks, 16, 07);    xsArraySetFloat( defend1, 16, 0);    xsArraySetFloat( defend2, 16, 6);    xsArraySetFloat( types, 16, 00);  // pred_lab[2]
    xsArraySetFloat( hps, 17, 300);    xsArraySetFloat( speeds, 17, 0.85);    xsArraySetFloat( attacks, 17, 14);    xsArraySetFloat( defend1, 17, 1);    xsArraySetFloat( defend2, 17, 3);    xsArraySetFloat( types, 17, 12);  // pred_lab[3]
    xsArraySetFloat( hps, 18, 085);    xsArraySetFloat( speeds, 18, 0.90);    xsArraySetFloat( attacks, 18, 11);    xsArraySetFloat( defend1, 18, 4);    xsArraySetFloat( defend2, 18, 4);    xsArraySetFloat( types, 18, 06);  // pred_lab[4]
    xsArraySetFloat( hps, 19, 080);    xsArraySetFloat( speeds, 19, 1.50);    xsArraySetFloat( attacks, 19, 09);    xsArraySetFloat( defend1, 19, 1);    xsArraySetFloat( defend2, 19, 2);    xsArraySetFloat( types, 19, 12);  // pred_lab[5]
    // Add array features into matrix.
    xsArraySetInt(units_mat, 0, hps);    xsArraySetInt(units_mat, 1, speeds);    xsArraySetInt(units_mat, 2, attacks);    xsArraySetInt(units_mat, 3, defend1);    xsArraySetInt(units_mat, 4, defend2);    //xsArraySetInt(units_mat, 5, types);
    
    //return (units_mat);
}

rule KnnAlgh
    inactive
    group MachineLearning
    minInterval 3
    maxInterval 3
    priority 100
{
    // Step1: 分割数据集（train_test_split ），测试集比例为 30%
    train_test_split(units_mat, types, 0.3);
    // 创建KNN分类器对象
    vector knn_clf = KneighborsClassifier(3);  // k = 3
    xsChatData("<RED>KNN Object: "+ knn_clf);
    // 拟合训练数据
    KNN_fit(knn_clf, X_train, y_train);
    // 对测试数据的标签（单位种类）进行预测
    y_lab = KNN_predict(knn_clf, X_test);
    // 迭代预测结果数组的元素
    iter_array(y_lab, "predict_", "float");
    
    xsDisableSelf();
}

void main() 
{
    __xsPreDefinedArrays();
    units_initial();    // Step0: 初始化单位数据
    xsEnableRule("KnnAlgh");
}

