// 向量的基本运算
float epsilon = 0.000001;

// [tool]四舍五入函数：对实数 x 按照指定的小数位数 n 进行四舍五入
float round(float x=0.0,int n=0){float num=0;float x2=x*pow(10,n);int x2_i=x2; if(abs(x2-x2_i)<0.5){num=1.0*x2_i/pow(10,n);} else{num=1.0*(x2_i+1)/pow(10,n);} return(num);}


// 向量 (0,0,0), (-1,-1,-1), (1,1,1)
vector zeroVector(){return(vector( 0, 0, 0));}  // cOriginVector
vector nagVector() {return(vector(-1,-1,-1));}  // cInvalidVector
vector onesVector(){return(vector( 1, 1, 1));}

/// 向量基本运算 ///
vector xsVectorAddNumber(vector arg_v=cOriginVector, float num=0.0) 
{// 向量与数字相加（减）
    float X_ = xsVectorGetX(arg_v) + num;
    float Y_ = xsVectorGetY(arg_v) + num;
    float Z_ = xsVectorGetZ(arg_v) + num;
    arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

vector xsVectorMulNumber(vector arg_v=cOriginVector, float num=0.0)
{// 向量与数字相乘
    float X_ = num * xsVectorGetX(arg_v);
    float Y_ = num * xsVectorGetY(arg_v);
    float Z_ = num * xsVectorGetZ(arg_v);
    arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

vector xsVectorDivNumber(vector arg_v=cOriginVector, float num=0.0, int n=4)
{// 向量与数字相除
    if(num == 0) // 当 num=0 时，向量的数量除没有意义
    {
        xsChatData("Invalid operation, cannot divide by 0.");
        return (xsVectorSet(epsilon,epsilon,epsilon));
    }
    float X_ = 1.0/num * xsVectorGetX(arg_v);
    float Y_ = 1.0/num * xsVectorGetY(arg_v);
    float Z_ = 1.0/num * xsVectorGetZ(arg_v);
    X_ = round(X_, n);
    Y_ = round(Y_, n);
    Z_ = round(Z_, n);
    arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

// 向量之间的运算：向量加（减）法，元素乘法，点乘（dot），除法
// 【注意】：这里除了向量点乘，其余均是对2个向量的相应位置元素进行运算
vector xsVectorsAdd(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 两个向量相加
    float X_ = xsVectorGetX(arg_v1) + xsVectorGetX(arg_v2);
    float Y_ = xsVectorGetY(arg_v1) + xsVectorGetY(arg_v2);
    float Z_ = xsVectorGetZ(arg_v1) + xsVectorGetZ(arg_v2);
    vector arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

vector xsVectorsSub(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 两个向量相减： A - B = A + (-1*B)
    float X_ = xsVectorGetX(arg_v1) + (-1*xsVectorGetX(arg_v2));
    float Y_ = xsVectorGetY(arg_v1) + (-1*xsVectorGetY(arg_v2));
    float Z_ = xsVectorGetZ(arg_v1) + (-1*xsVectorGetZ(arg_v2));
    vector arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

vector xsVectorsMul(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 两个向量相乘（对应位置元素相乘）
    float X_ = xsVectorGetX(arg_v1) * xsVectorGetX(arg_v2);
    float Y_ = xsVectorGetY(arg_v1) * xsVectorGetY(arg_v2);
    float Z_ = xsVectorGetZ(arg_v1) * xsVectorGetZ(arg_v2);
    vector arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

float xsVectorsDotProd(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 向量的点乘（内积）： U.dot(V) = U1*V1 + U2*V2 + ... + UnVn
    float X_1 = xsVectorGetX(arg_v1);
    float Y_1 = xsVectorGetY(arg_v1);
    float Z_1 = xsVectorGetZ(arg_v1);
    float X_2 = xsVectorGetX(arg_v2);
    float Y_2 = xsVectorGetY(arg_v2);
    float Z_2 = xsVectorGetZ(arg_v2);
    // U.dot(V) 
    float dot = X_1*X_2 + Y_1*Y_2 + Z_1*Z_2 ;
    return (dot);
}

vector xsVectorsCrossProd(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 向量的叉乘（外积）： UxV = (Y_1*Z_2-Y_2*Z_1, Z_1*X_2-Z_2*X_1, X_1*Y_2-X_2*Y_1)
    float X_1 = xsVectorGetX(arg_v1);
    float Y_1 = xsVectorGetY(arg_v1);
    float Z_1 = xsVectorGetZ(arg_v1);
    float X_2 = xsVectorGetX(arg_v2);
    float Y_2 = xsVectorGetY(arg_v2);
    float Z_2 = xsVectorGetZ(arg_v2);
    // 向量 arg_v1 x arg_v2 的各个分量：
    float X_ = Y_1*Z_2 - Y_2*Z_1 ;
    float Y_ = Z_1*X_2 - Z_2*X_1 ;
    float Z_ = X_1*Y_2 - X_2*Y_1 ;
    vector arg_v = xsVectorSet(X_, Y_, Z_);
    return (arg_v);
}

float xsVectorsDiv(vector arg_v1 = cOriginVector, vector arg_v2 = cOriginVector) 
{// 两个向量相除：若2个向量共线，则有 A = k*B（只有平行/共线向量才有除法），此时A与B相除，就是求k的过程
    // 获取 arg_v1, arg_v2 的各个分量
    float X_1 = xsVectorGetX(arg_v1);
    float Y_1 = xsVectorGetY(arg_v1);
    float Z_1 = xsVectorGetZ(arg_v1);
    float X_2 = xsVectorGetX(arg_v2);
    float Y_2 = xsVectorGetY(arg_v2);
    float Z_2 = xsVectorGetZ(arg_v2);
    float k = 0.0;
    
    if(X_2==0 || Y_2==0 || Z_2 == 0) // 若 arg_v2 中含有0分量
    {xsChatData("Invalid  operation, cannot divide by 0."); return (epsilon);}
    // 若 X_1/X_2 == Y_1/Y_2 == Z_1/Z_2 -> 2个向量共线
    else if((X_1/X_2 == Y_1/Y_2) && (Y_1/Y_2 == Z_1/Z_2)) {k = X_1/X_2; return (k);}
    else {xsChatData("Vectors A and B are not parallel, cannot do A/B operation.");}
    return (epsilon);
    
}

float xsVectorNorm(vector arg_v=cOriginVector) 
{// 求向量的模（长度）：向量的norm为它各个分量的平方和，再开平方根
    float X_ = xsVectorGetX(arg_v);
    float Y_ = xsVectorGetY(arg_v);
    float Z_ = xsVectorGetZ(arg_v);
    float norm = sqrt(pow(X_,2) + pow(Y_,2) + pow(Z_,2));
    return (norm);
}

bool setUnitSize(int p= -1, int unit_id= 119, vector V= vector(-1,-1,-1))
{// 设置玩家单位尺寸XYZ（碰撞体积）
    float sizeX = xsVectorGetX(V);
    float sizeY = xsVectorGetY(V);
    float sizeZ = xsVectorGetZ(V);
    if((sizeX != -1) && (sizeX>=0 && sizeX<=4)){xsEffectAmount(0,unit_id, 3,sizeX,p);} else{return(false);}
    if((sizeY != -1) && (sizeY>=0 && sizeY<=4)){xsEffectAmount(0,unit_id, 4,sizeY,p);} else{return(false);}
    if((sizeZ != -1) && (sizeZ>=0 && sizeZ<=4)){xsEffectAmount(0,unit_id,32,sizeZ,p);} else{return(false);}
    return (true);
}


/// 测试脚本 ///
/*
vector zero_v = cOriginVector;
vector negone_v = cInvalidVector;

vector v1 = vector(1, 3, -5);
vector v2 = vector(6, 4, 2);
vector v3 = vector(3, -1, 5);
vector v4 = vector(-0.5, 8, -3);
vector v5 = vector(0.3333, 0, -2);
vector v6 = vector(6, -4, -2);
vector v7 = vector(-1, -1, -1);

void main() 
{
    //vector vec = xsVectorAddNumber(v1, -2);  // (-1, 1, -7)
    //vector vec = xsVectorMulNumber(v2, 2);  // (12, 8, 4)
    //vector vec = xsVectorDivNumber(v3, 0);  // (0.4286, -0.1429, 0.7143);
    //vector vec = xsVectorsAdd(v1, v3);  // (4, 2, 0)
    //vector vec = xsVectorsMul(negone_v, v4);  // (0.5, -8, 3)
    
    //xsChatData("the Vector's component X = " + xsVectorGetX(vec));
    //xsChatData("the Vector's component Y = " + xsVectorGetY(vec));
    //xsChatData("the Vector's component Z = " + xsVectorGetZ(vec));
    
    float vdiv = xsVectorsDiv(v5, zero_v);  // 0
    //float vdiv = xsVectorsDiv(v3, negone_v);  // (-3, 1, -5)
    xsChatData("the result of vector A/B = " + vdiv);
    
    //float dotv = xsVectorsDotProd(v3, v5);
    //float dotv = xsVectorsDotProd(v6, negone_v);
    //xsChatData("the result of U.dot(V) = " + dotv);
    
    float v7_norm = xsVectorNorm(v7);
    xsChatData("the norm of vector is: " + v7_norm);
}

*/
